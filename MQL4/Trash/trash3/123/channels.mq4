//+------------------------------------------------------------------+
//|                                                     channels.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Николай Семко SemkoNV@bk.ru"
#property link      "http://www.7ko.org"

// хвалить и ругать по адресу SemkoNV@bk.ru

#property  indicator_chart_window
#property  indicator_buffers 1


#property  indicator_width1  1
#property  indicator_minimum 0
//---- indicator parameters

extern int Start =0;           //от какого момента начинается анализ данных, 0 - от текущего.
extern int BarAnaliz=400;      //кол-во баров для анализа в каждом периоде до дневки включительно. Не более 2000!
extern double k_shirina=4;     //коэф. ширины канала
extern int tochnost =50;       //точность моделирования 1-никакой точности, если BarAnaliz -макс. точность. Чем выше точность -тем медлее работает индикатор
extern double filtr = 0.55;    //фильтр глубины формирования нового канала, целесообразно использовать диапазон 0.382-0,618
extern double MinShirina = 0;  // минимальная средневзешенная ширина канала в пунктах, (с меньшей шириной каналы не формируются)
extern double MaxShirina=10000;  // максимальная средневзешенная ширина канала в пунктах, (с большей шириной каналы не формируются)
extern bool luch =  true;      // признак продолжения канала; true - луч, false - отрезок
extern bool maxmin =  true;    // признак - строить канал принимая во внимание крайние экстремумамы 
                               // -true - Да. Чтобы построение проходило через крайние экстремумы коэф. ширины k_shirina должен быть большим, например 100
// -false - Нет. В данном случает верхняя и нижняя граница канала равноудалена от центральной оси канала(центра "массы")
extern bool color_fill=true;// признак заливки каналов

//---- indicator buffers

double     Canals[];
double     Shir[];
double     Vertikal[];

double     Shirina[];
double     ShirinaU[];
double     ShirinaD[];
double     CanalR[];
double     CanalL[];
double     Kanals[20][9];

int preBars=0;
int p[9]={43200,10080,1440,240,60,30,15,5,1};
int FinishL;
int tick=0;
int bar=0;
int b=0;
//datetime x1,x2;
double sumPlus=0;
double sumMinus=0;
double yOptR,yOptL;
int prexL=0;
int prexR=0;
double ma=0;
int  prevxR=-5;
int  prevp=0;
int prevper=-5;
double sum1=0;
double sum2=0;
double curdeltaMax=-10000;
double curdeltaMin=10000;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void deinit()
  {
   Comment("");
   for(int i=0;i<20;i++)
     {
      ObjectDelete("LineCanal9_"+DoubleToStr(i,0));
      ObjectDelete("LineCanal9_"+DoubleToStr(i,0)+" UP");
      ObjectDelete("LineCanal9_"+DoubleToStr(i,0)+" DOWN");
      ObjectDelete("LineCanal9_"+DoubleToStr(i,0)+" TRIUP");
      ObjectDelete("LineCanal9_"+DoubleToStr(i,0)+" TRIDown");
      ObjectDelete("Vertical_9_"+DoubleToStr(i,0));
     }
  }
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- drawing settings
   IndicatorDigits(Digits+1);
//---- indicator buffers mapping

   LoadHist();
//---- indicator buffers mapping

   SetIndexBuffer(0,Canals);
//   IndicatorDigits(20);

//---- initialization done
   return(0);
  }
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

int start()
  {
//LoadHist();
   RefreshRates();
//return(0);
   if(preBars == Bars) return(0);
   preBars=Bars;

   int size=Bars;
   ArrayResize(Shirina,size);
   ArrayResize(ShirinaU,size);
   ArrayResize(ShirinaD,size);
   ArrayResize(CanalR,size);
   ArrayResize(CanalL,size);

   ArrayResize(Canals,size);
   ArrayResize(Shir,size);
   ArrayResize(Vertikal,size);

   int j=AllCanals();
   Canals[0]=j;                                     //Число сформированных каналов

   if(j>0)
     {
      for(int i=0; i<j; i++)
        {
         Canals[7*i+1] = Kanals[i][0];                //Ширина
         Canals[7*i+2] = Kanals[i][1];                //Текущий i - левая граница канала
         Canals[7*i+3] = Kanals[i][2];                //Период формирования канала
         Canals[7*i+4] = Kanals[i][3];                //yOptR
         Canals[7*i+5] = Kanals[i][4];                //yOptL
         Canals[7*i+6] = Kanals[i][5]/Point;          //приращение в пунктах на бар поминутно или угол наклона канала, положит.- вверх, отр. - вниз
         Canals[7*i+7] = Kanals[i][6];                //длина в барах текущего периода
         Canals[7*i+8] = Kanals[i][7];                //Ширина Up
         Canals[7*i+9] = Kanals[i][8];                //Ширина Doun
        }
      BildCanals(j);
     }
   return(0);
  }
//+------------------------------------------------------------------+
///////////////////////////// Функции ////////////////////////////////
//+------------------------------------------------------------------+

int BildCanals(int j)//Данные о каналах находятся в массиве Kanals[20][7]
  {
   string name;
   datetime x1,x2;
   double y1,y2;
//int  color_i[]={Red,Tomato,Yellow,LawnGreen,Green,Aqua,MediumBlue,BlueViolet,FireBrick,BurlyWood,DeepPink,SeaGreen};
   int  color_i[]={C'200,0,0',C'200,100,0',C'160,160,0',C'100,200,0',C'0,200,0',C'0,200,100',C'0,180,180',C'0,60,120',C'0,0,200',C'100,0,200',C'160,0,160',C'160,80,120'};
   int color_i2[]={C'80,0,0', C'80,40,0',  C'60,60,0',  C'40,80,0',  C'0,60,0', C'0,70,50',  C'0,50,50',  C'0,20,40', C'0,0,80', C'40,0,80',  C'50,0,60',  C'60,20,50'};
   for(int i=j;i<20;i++)
     {
      ObjectDelete("LineCanal9_"+DoubleToStr(i,0));
      ObjectDelete("LineCanal9_"+DoubleToStr(i,0)+" UP");
      ObjectDelete("LineCanal9_"+DoubleToStr(i,0)+" DOWN");
      ObjectDelete("Vertical_9_"+DoubleToStr(i,0));
      ObjectDelete("LineCanal9_"+DoubleToStr(i,0)+" TRIUP");
      ObjectDelete("LineCanal9_"+DoubleToStr(i,0)+" TRIDown");
      Kanals[i][2]=0;
      Kanals[i][1]=0;
      Kanals[i][0]=0;
     }
//Comment("Колличество каналов = ",j);
   string comm="Колличество каналов = ";
   comm=comm+j;
   for(i=0; i<j; i++)
     { comm=comm+"\n"+"Канал № "+DoubleToStr((i+1),0)+" : Ширина - "+DoubleToStr(Kanals[i][0],0)+", длина канала -  "+DoubleToStr(Kanals[i][6],0)+" баров на периоде "+DoubleToStr(Kanals[i][2],0);}
   Comment(comm);

   for(i=0; i<j; i++)
     {
      x1 = iTime(NULL,0,Start);
      y1 = Kanals[i][3];
      if(iTime(NULL,0,(Bars-1))<=iTime(NULL,Kanals[i][2],Kanals[i][1]))
        {
         x2 = iTime(NULL,Kanals[i][2],Kanals[i][1]);
         y2 = Kanals[i][4];
        }
      else
        {
         x2=iTime(NULL,0,(Bars-1));
         if(Kanals[i][6]!=0) y2=y1-((iBarShift(NULL,Kanals[i][2],x2,FALSE)-iBarShift(NULL,Kanals[i][2],x1,FALSE))/Kanals[i][6])*(y1-Kanals[i][4]);
        }

      name="LineCanal9_"+DoubleToStr(i,0);
      if(ObjectFind(name)==-1)
        {
         if(!ObjectCreate(name,OBJ_TREND,0,x2,y2,x1,y1)) Comment("Ошибка 0 = ",GetLastError());
         ObjectSet(name,OBJPROP_RAY,FALSE);
         ObjectSet(name,OBJPROP_COLOR,color_i[i]);
         ObjectSet(name,OBJPROP_STYLE,STYLE_DOT);
         ObjectSet(name,OBJPROP_RAY,luch);

         if(maxmin==true)
            ObjectCreate(name+" UP",OBJ_TREND,0,x2,(y2+Point*Kanals[i][7]),x1,(y1+Point*Kanals[i][7]));
         else
            ObjectCreate(name+" UP",OBJ_TREND,0,x2,(y2+k_shirina*Point*Kanals[i][0]),x1,(y1+k_shirina*Point*Kanals[i][0]));
         ObjectSet(name+" UP",OBJPROP_RAY,FALSE);
         ObjectSet(name+" UP",OBJPROP_COLOR,color_i[i]);
         ObjectSet(name+" UP",OBJPROP_STYLE,STYLE_DASH);
         ObjectSet(name+" UP",OBJPROP_RAY,luch);

         if(maxmin==true)
            ObjectCreate(name+" DOWN",OBJ_TREND,0,x2,(y2+Point*Kanals[i][8]),x1,(y1+Point*Kanals[i][8]));
         else
            ObjectCreate(name+" DOWN",OBJ_TREND,0,x2,(y2-k_shirina*Point*Kanals[i][0]),x1,(y1-k_shirina*Point*Kanals[i][0]));
         ObjectSet(name+" DOWN",OBJPROP_RAY,FALSE);
         ObjectSet(name+" DOWN",OBJPROP_COLOR,color_i[i]);
         ObjectSet(name+" DOWN",OBJPROP_STYLE,STYLE_DASH);
         ObjectSet(name+" DOWN",OBJPROP_RAY,luch);

         if(color_fill==true)
           {
            ObjectCreate(name+" TRIUP",OBJ_TRIANGLE,0,x2,(y2+Point*Kanals[i][7]),x1,(y1+Point*Kanals[i][7]),x2,(y2+Point*Kanals[i][8]));
            ObjectSet(name+" TRIUP",OBJPROP_COLOR,color_i2[i]);
            ObjectCreate(name+" TRIDown",OBJ_TRIANGLE,0,x1,(y1+Point*Kanals[i][7]),x1,(y1+Point*Kanals[i][8]),x2,(y2+Point*Kanals[i][8]));
            ObjectSet(name+" TRIDown",OBJPROP_COLOR,color_i2[i]);
           }

         if(!ObjectCreate("Vertical_9_"+DoubleToStr(i,0),OBJ_VLINE,0,x2,8)) Comment("Ошибка 0 = ",GetLastError());
         ObjectSet("Vertical_9_"+DoubleToStr(i,0),OBJPROP_COLOR,color_i[i]);
         ObjectSet("Vertical_9_"+DoubleToStr(i,0),OBJPROP_STYLE,STYLE_DOT);
        }
      else
        {
         if(!ObjectMove(name,0,x2,y2)) Comment("Ошибка 1 = ",GetLastError());
         if(!ObjectMove(name,1,x1,y1)) Comment("Ошибка 2 = ",GetLastError());

         if(maxmin==true)
           {
            ObjectMove(name+" UP",0,x2,y2+Point*Kanals[i][7]);
            ObjectMove(name+" UP",1,x1,y1+Point*Kanals[i][7]);

            ObjectMove(name+" DOWN",0,x2,y2+Point*Kanals[i][8]);
            ObjectMove(name+" DOWN",1,x1,y1+Point*Kanals[i][8]);

            if(color_fill==true)
              {
               ObjectMove(name+" TRIUP",0,x2,(y2+Point*Kanals[i][7]));
               ObjectMove(name+" TRIUP",1,x1,(y1+Point*Kanals[i][7]));
               ObjectMove(name+" TRIUP",2,x2,(y2+Point*Kanals[i][8]));

               ObjectMove(name+" TRIDown",0,x1,(y1+Point*Kanals[i][7]));
               ObjectMove(name+" TRIDown",1,x1,(y1+Point*Kanals[i][8]));
               ObjectMove(name+" TRIDown",2,x2,(y2+Point*Kanals[i][8]));
              }
           }
         else
           {
            ObjectMove(name+" UP",0,x2,y2+k_shirina*Point*Kanals[i][0]);
            ObjectMove(name+" UP",1,x1,y1+k_shirina*Point*Kanals[i][0]);

            ObjectMove(name+" DOWN",0,x2,y2-k_shirina*Point*Kanals[i][0]);
            ObjectMove(name+" DOWN",1,x1,y1-k_shirina*Point*Kanals[i][0]);
           }
        }

     }
   return(0);
  }
////////////////////////////////////////////////////////
int AllCanals()
  {
   int i1=0,i2,i3;
   int k=0;
   int i=0;
   int lastper;
   int St,Fin;
   datetime S,F,prevS,CurStart;
   int lastmin;
   double lmin;
   double premin;
//ArrayInitialize(Kanals,0);
   lastper=9;

   CurStart=iTime(NULL,Period(),Start);
   if(Start==0) CurStart=iTime(NULL,1,0);
   prevS=iTime(NULL,p[0],(iBarShift(NULL,p[0],CurStart,FALSE)+BarAnaliz));
//ArrayInitialize(Vertikal,0);
//ArrayInitialize(Shir,0);

   for(int jj=0;jj<lastper;jj++)
     {
      //ArrayInitialize(Shirina,0);
      if(jj==8)
         S = CurStart;
      else S=iTime(NULL,p[jj+1],(iBarShift(NULL,p[jj+1],CurStart,FALSE)+BarAnaliz));
      F=prevS;
      prevS=S;
      St=iBarShift(NULL,p[jj],CurStart,FALSE);
      Fin=iBarShift(NULL,p[jj],F,FALSE);

      if(St==0 && Fin==0)  return(0);
      if(jj!=8) {ArrShirina(St,Fin,(iBarShift(NULL,p[jj],S,FALSE))-St-7,p[jj]); }//Print("1111111111  ",p[jj],"   ", St,"   ", Fin,"   ",(iBarShift(NULL,p[jj],S,FALSE))-St-7);}
      else  {ArrShirina(St,Fin,0,p[jj]);}// Print("888888888  ",p[jj],"   ", St,"   ", Fin);}
      lastmin=Fin+1;
      if(jj==0) lmin=10000000;
      if(jj==0) premin=Shirina[Fin-St-1];
      // Print(Start,"  ",p[jj],"  Старт - ",(iBarShift(NULL,p[jj],S,FALSE)),"  Финиш - ",Fin);
      if(Fin>iBarShift(NULL,p[jj],S,FALSE))
         for(i=Fin-1; i>(iBarShift(NULL,p[jj],S,FALSE))-1; i--)
           {
            if(iTime(NULL,0,Bars-1)<=iTime(NULL,p[jj],i))
              {
               i3=iBarShift(NULL,0,iTime(NULL,p[jj],i),FALSE);
               for(i2=0;i2<=p[jj]/Period();i2++)
                 {
                  if(((i3-i2)>=0) && ((i3-i2)<ArraySize(Shir)))
                     if(((i-St)>=0) && ((i-St)<ArraySize(Shirina)))
                       {
                        Shir[i3-i2]=Shirina[i-St];
                       }
                 }
              }
            if(Shirina[i-St]<lmin) {lmin=Shirina[i-St];lastmin=i;}

            if(((i-St)>=0) && ((i-St)<ArraySize(Shirina)))
               if((((i-St-1)>=0) && ((i-St-1)<ArraySize(Shirina))) && (((i-St+1)>=0) && ((i-St+1)<ArraySize(Shirina))))
                  if(Shirina[i-St]<=Shirina[i-St-1] && Shirina[i-St]<=Shirina[i-St+1])
                     if(lastmin==i)
                       {
                        if(Shirina[i-St]<premin*filtr && Shirina[i-St]>MinShirina && Shirina[i-St]<MaxShirina)
                          {
                           if(i1>0) for(k=0; k<i1; k++)
                             {
                              if(Shirina[i-St]!=0) if((Kanals[k][0]/Shirina[i-St])<1.2 && (Kanals[k][0]/Shirina[i-St])>0.8) i1=k;
                             }
                           if(iTime(NULL,0,Bars-1)<=iTime(NULL,p[jj],i)) Vertikal[i1]=i3;
                           Kanals[i1][0]= Shirina[i-St];                            //Ширина Up
                           Kanals[i1][1]= i;                                        //Текущий i - левая граница канала
                           Kanals[i1][2]= p[jj];                                    //Период
                           Kanals[i1][3]= CanalR[i-St];                             //yOptR
                           Kanals[i1][4]= CanalL[i-St];                             //yOptL
                           if((i-St)*p[jj]!=0) Kanals[i1][5]=(CanalR[i-St]-CanalL[i-St])/((i-St)*p[jj]);  //приращение на бар
                           Kanals[i1][6]= (i-St);                                   //длина в барах
                           Kanals[i1][7]= ShirinaU[i-St];                           //Ширина Up
                           Kanals[i1][8]= ShirinaD[i-St];                           //Ширина Down
                           premin=Shirina[i-St];
                           i1++;
                          }
                       }
           }

     }
   return(i1);
  }
//////////////////////////////////////////////////////////////////////
double ArrShirina(int Start1,int Finish,int Sdvig,int per)
  {
   Shirina[0]=0;
   if(Sdvig<0) Sdvig=0;
   yOptR=iOpen(NULL,per,Start1);

   int d,i1;
   double dC,dR,dL;
   int p=0;
   int lnz=Sdvig;
//Print("Start  ",Start1,"Finish   ",Finish);
   for(int i=(1+Sdvig); i<(Finish-Start1); i++)
     {
      //x2 = iTime(NULL,per,i);
      if(tochnost!=0) p=MathFloor((i-1)/tochnost);
      i=i+p;
      Shirina[i]=MinCanal2(Start1,i+Start1,per);

      if(maxmin==true)
        {
         if( k_shirina*Shirina[i]<curdeltaMax/Point) ShirinaU[i]=(curdeltaMax/Point+k_shirina*Shirina[i])/2; else ShirinaU[i]=curdeltaMax/Point;
         if(-k_shirina*Shirina[i]>curdeltaMin/Point) ShirinaD[i]=(curdeltaMin/Point-k_shirina*Shirina[i])/2; else ShirinaD[i]=curdeltaMin/Point;
        }
      CanalL[i]  = yOptL;
      CanalR[i]  = yOptR;
      d=i-lnz;
      if(d!=0)
        {
         dC=(Shirina[i]-Shirina[lnz])/d;
         dR=(CanalR[i]-CanalR[lnz])/d;
         dL=(CanalL[i]-CanalL[lnz])/d;
        }
      if(d>1)
         for(i1=1;i1<d;i1++)
           {
            Shirina[lnz+i1] = Shirina[lnz+i1-1]+dC;
            CanalL[lnz+i1]  = CanalL[lnz+i1-1]+dL;
            CanalR[lnz+i1]  = CanalR[lnz+i1-1]+dR;
           }
      lnz=i;
     }
   return(0);
  }
///////////////////////////////////////////////////////
double MinCanal2(int xR,int xL,int per)
  {
   double p=xL-xR;
   double j1,j2,j3,h1,h2,d;

   j1 = p + 1;
   j2 = p*(p+1)/2;
   j3 = p*(p+1)*(2*p+1)/6;


   if(prevxR!=xR || prevper!=per)
     {
      prevp=0;
      sum1=0;
      sum2=0;
     }

   for(int n=prevp; n<=p; n++)
     {
      sum2+=iOpen(NULL,per,n+xR);
     }

   for(n=prevp; n<=p; n++)
     {
      sum1+=iOpen(NULL,per,n+xR)*n;
     }

   h2 = sum2;
   h1 = sum1;
   prevxR=xR;
   prevp=p+1;
   prevper=per;
   d=(j2*h2-j1*h1)/(j2*j2-j1*j3);
   yOptR = (h1-j3*d)/j2;
   yOptL = d*p+yOptR;

   return(SumPlus2(xL,xR,yOptR,yOptL,per)/j1);
  }
///////////////////////////////////////////////////////

double SumPlus2(int xL1,int xR1,double yR1,double yL1,int per)
  {
   double curLinePrice,curdelta,curdeltaH,curdeltaL,delta;
   curdeltaMax=-100000;
   curdeltaMin=100000;
   int i = xR1;
   if(xL1==xR1)return(0);
   if((xL1-xR1)!=0) delta = (yL1-yR1)/(xL1-xR1);
   curLinePrice = yR1;
   sumPlus=0;
   while(i<=xL1)
     {
      curdelta=iOpen(NULL,per,i)-curLinePrice;
      curdeltaH = iHigh(NULL,per,i) - curLinePrice;
      curdeltaL = iLow(NULL,per,i) - curLinePrice;
      if(curdeltaMax<curdeltaH) curdeltaMax=curdeltaH;
      if(curdeltaMin>curdeltaL) curdeltaMin=curdeltaL;
      if(curdelta>0) sumPlus=sumPlus+curdelta;
      curLinePrice=curLinePrice+delta;
      i++;
     }
   return(sumPlus/Point);
  }
////////////////////////////////////////////////////////////////////////////////////
void LoadHist()
  {
   int iPeriod[9];
   iPeriod[0]=1;
   iPeriod[1]=5;
   iPeriod[2]=15;
   iPeriod[3]=30;
   iPeriod[4]=60;
   iPeriod[5]=240;
   iPeriod[6]=1440;
   iPeriod[7]=10080;
   iPeriod[8]=43200;
   for(int iii=0;iii<9;iii++)
     {
      datetime open=iTime(Symbol(),iPeriod[iii],0);
      //datetime open = MarketInfo(Symbol(),MODE_TIME);
      int error=GetLastError();
      //Comment("");
      while(error==4066)
        {
         //MessageBox("Не были загружены исторические данные для всех таймфреймов, требуется перезагрузка индикатора или перейдите на другой таймфрейм","ВНИМАНИЕ!!!",1);
         Comment("Не были загружены исторические данные для ",iPeriod[iii]," периода, требуется перезагрузка индикатора или перейти на другой таймфрейм");
         Sleep(10000);
         open = iTime(Symbol(), iPeriod[iii], 0);
         error=GetLastError();
        }
     }
  }
//+------------------------------------------------------------------+
