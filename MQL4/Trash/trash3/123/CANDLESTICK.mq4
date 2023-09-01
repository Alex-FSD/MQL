//+------------------------------------------------------------------+
//|                                            Bheurekso_pattern.mq4 |
//|                                                   Nikelodeon     |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Nikelodeon"
#property link      ""

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Lime
#property indicator_color2 Red
//---- input parameters
extern bool       lines=true;
extern int       step=500;
extern bool       Dell=true;

//----buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,108);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexEmptyValue(0,0.0);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,108);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexEmptyValue(1,0.0);
//----
	ObjectsDeleteAll(0,OBJ_TEXT);
	ObjectsDeleteAll(0,OBJ_ARROW);
	ObjectsDeleteAll(0,OBJ_TREND);
	//DelArrow(0,0); 
   return(0);

  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- 
 ObjectsDeleteAll(0,OBJ_TEXT);
ObjectsDeleteAll(0,OBJ_ARROW);  
ObjectsDeleteAll(0,OBJ_TREND);  
//----
   return(0);
  }

//+------------------------------------------------------------------+
//SetArrow(t[shift1],l[shift1]-15*Point,241,LIME);
void SetArrow(int sh, datetime tm, double pr, int cod,color clr)
{
	ObjectCreate("Arrow-"+sh,OBJ_ARROW,0,tm,pr);
	ObjectSet("Arrow-"+sh,OBJPROP_ARROWCODE,cod);
	ObjectSet("Arrow-"+sh,OBJPROP_COLOR,clr);
}
void SetArrow1(int sh, datetime tm, double pr, int cod,color clr)
{
	ObjectCreate("Arrow+"+sh,OBJ_ARROW,0,tm,pr);
	ObjectSet("Arrow+"+sh,OBJPROP_ARROWCODE,cod);
	ObjectSet("Arrow+"+sh,OBJPROP_COLOR,clr);
}

//SetText(t[shift1],l[shift1]-28*Point,"Engulfing",LIME);
void SetText(int sh,datetime tm,double pr,string text,color clr)
{
	ObjectCreate("x"+sh,OBJ_TEXT,0,tm,pr);
	ObjectSetText("x"+sh,text);
	ObjectSet("x"+sh,OBJPROP_COLOR,clr);
}
void SetText1(int sh,datetime tm,double pr,string text,color clr)
{
	ObjectCreate("y"+sh,OBJ_TEXT,0,tm,pr);
	ObjectSetText("y"+sh,text);
	ObjectSet("y"+sh,OBJPROP_COLOR,clr);
}

void Setline(int sh,datetime tm,double pr,datetime tm1,double pr1, color clr)
{
	ObjectCreate("-"+sh,OBJ_TREND,0,tm,pr,tm1,pr1,clr);
	ObjectSet("-"+sh,7,STYLE_SOLID);
	ObjectSet("-"+sh,10,false);
	ObjectSet("-"+sh,6,Yellow);
}
void Setline1(int sh,datetime tm,double pr,datetime tm1,double pr1, color clr)
{
	ObjectCreate("+"+sh,OBJ_TREND,0,tm,pr,tm1,pr1,clr);
	ObjectSet("+"+sh,7,STYLE_SOLID);
	ObjectSet("+"+sh,10,false);
	ObjectSet("+"+sh,6,LightBlue);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
	int    counted_bars=IndicatorCounted();
//---- 
	int myBars=0, StartBar=0;//, Kedip(false);
	int shift=0, shift1=0, shift2=0, shift3=0;
	bool BullEngulf=False, MorningStar=False, BullPierce=False, Hammer=False,Name=false,Arrow=false;
	bool BearEngulf=False, EveningStar=False, DarkCloud=False, Shooter=False,Name1=false,Arrow1=false;
	bool BullHarami=False, BearHarami=false, BullCross=false, BearCross=false,up=false,down=false; 
	int limit,n,a,b,x,k, doji=false; 
  	double  l[1000] ,h[1000];

	int p3[100],x1[100];
p3[1]=0;	
	if(myBars!=Bars) 
	{ 
		myBars=Bars; 
	}
   limit=step;//Bars-counted_bars;
	for(shift=limit;shift>=0;shift--) 
	{
		// Manjakan MT
		shift1=shift+1;
		shift2=shift+2;
		shift3=shift+3;

		//*** periksa pola bullish***
		//***************************
		//Определение рыночной тенденции
		//В НШ можно отфильтровать для прогноза будущеё на время
		if ((iMA(NULL,0,5,0,MODE_EMA,PRICE_CLOSE,shift)>iMA(NULL,0,5,0,MODE_EMA,PRICE_CLOSE,shift1)) &&
		(iMA(NULL,0,5,0,MODE_EMA,PRICE_CLOSE,shift1)>iMA(NULL,0,5,0,MODE_EMA,PRICE_CLOSE,shift2)) &&
		(iMA(NULL,0,5,0,MODE_EMA,PRICE_CLOSE,shift2)>iMA(NULL,0,5,0,MODE_EMA,PRICE_CLOSE,shift3))) up=true;
		else up=false;
		if ((iMA(NULL,0,5,0,MODE_EMA,PRICE_CLOSE,shift)<iMA(NULL,0,5,0,MODE_EMA,PRICE_CLOSE,shift1)) &&
		(iMA(NULL,0,5,0,MODE_EMA,PRICE_CLOSE,shift1)<iMA(NULL,0,5,0,MODE_EMA,PRICE_CLOSE,shift2)) &&
		(iMA(NULL,0,5,0,MODE_EMA,PRICE_CLOSE,shift2)<iMA(NULL,0,5,0,MODE_EMA,PRICE_CLOSE,shift3))) down=true;
		else down=false;

      //Определение периода
      if (5==Period()){a=15; b=5;}
      if (15==Period()){a=7; b=3;}
      if (60==Period()){a=25; b=15;}
      if (240==Period()){a=30; b=20;}
      if (1440==Period()){a=35; b=25;}
      
		//Выявления всех моделей
		//Харами Вверх		
		if ((down)&&(Open[shift2]>Close[shift2]) && (Open[shift1]>Close[shift2]) && (Close[shift1]<Open[shift2]) &&
		      (Close[shift1]>Open[shift1]))
		      BullHarami=true;
		  else BullHarami=false;
		
		//Проникающие линии бычков
		   
		if ((Open[shift2]>Close[shift2]) && (Open[shift1]>Close[shift2])&& (Open[shift1]<Open[shift2])&& (Close[shift1]>Open[shift2]))
		   BullCross=true;
		   else BullCross=false;
		   
		//--- Bullish Engulfing (2 bars)
		if((Close[shift2]<Open[shift2]) && (Open[shift1]<Close[shift2]) && //| l[shift1] < l[shift2]) & 
				(Close[shift1]>Open[shift2])) 
			BullEngulf=True;
		else 
			BullEngulf=False;
		
		//--- Bullish Piercing (2 bars) cuma cari kalo ga ada BullEngulf
		if(!BullEngulf)
		{
			if((Close[shift2]<Open[shift2]) && (Close[shift1]>Open[shift1]) && 
					((Open[shift1]<Close[shift2]) /*|| (Low[shift1]<Low[shift2])*/) && 
					(Close[shift1]>Close[shift2]+((Open[shift2]-Close[shift2])/2))) 
				BullPierce=True;
			else 
				BullPierce=False;
		}
		else 
		{
			BullPierce=False;
		}
		
		// Morning Star (3 bars)
		if((Close[shift3]<Open[shift3]) && (Open[shift2]<Close[shift3]) && (Close[shift2]<Close[shift3]) &&
				((Open[shift1]>Close[shift2]) && (Open[shift1]>Open[shift2])) && (Close[shift1]>=Close[shift3]))
			MorningStar=True;
		else
			MorningStar=False;
		
		// Hammer
		if((Open[shift1]-Low[shift1]>MathMax(High[shift1]-Close[shift1],Close[shift1]-Open[shift1])*3) &&
		   (Close[shift1]-Low[shift1]>MathMax(High[shift1]-Close[shift1],Close[shift1]-Open[shift1])*3))
			Hammer=True;
		else 
		 	Hammer=False;
		
		//*** periksa pola bearish***
		//***************************
		//Харами Вниз		
		if ((up)&&(Open[shift2]<Close[shift2]) && (Open[shift1]<Close[shift2]) && (Close[shift1]>Open[shift2]) &&
		      (Close[shift1]<Open[shift1]))
		      BearHarami=true;
		  else BearHarami=false;
		
		//Проникающие линии медвежат
		   
		if ((Open[shift2]<Close[shift2]) && (Open[shift1]<Close[shift2])&&(Open[shift1]>Open[shift2])&& (Close[shift1]<Open[shift2]))
		   BearCross=true;
		   else BearCross=false;


		//--- Bearish Engulfing (2 bars)
		if((Close[shift2]>Open[shift2]) && (Close[shift1]<Open[shift1]) && (Open[shift1]>Close[shift2]) &&
				((Close[shift1]<Open[shift2]) ))
			BearEngulf=True;
		else
			BearEngulf=False;
		
		//--- Bearish Dark Cloud (2 bars) cuma cari kalo ga ada BearEngulf
		if(!BearEngulf)
		{
			if((Close[shift2]>Open[shift2]) && ((Open[shift1]>Close[shift2]) /*|| (High[shift1]>High[shift2]*/) &&
					(Close[shift1]<Close[shift2]-((Close[shift2]-Open[shift2])/2)))
				DarkCloud=True;
			else 
				DarkCloud=False;
		}
		else 
		{
			DarkCloud=False;
		}
		
		// Evening Star (3 bars)
		if((Close[shift3]>Open[shift3]) && (Open[shift2]>Close[shift3]) && (Close[shift2]>Close[shift3]) && 
				((Open[shift1]<Close[shift2]) && (Open[shift1]<Open[shift2])) && (Close[shift1]<Close[shift3]))
			EveningStar=True;
		else 
			EveningStar=False;
		
		// Shooting Star 
		if((up)&&(High[shift1]-Open[shift1]>MathMax(Close[shift1]-Low[shift1],Open[shift1]-Close[shift1])*3)&&
		   (High[shift1]-Close[shift1]>MathMax(Close[shift1]-Low[shift1],Open[shift1]-Close[shift1])*3)) 
			Shooter=True;
		else
			Shooter=False;
			
	//подтверждение		
			if( (BullEngulf || BullPierce || MorningStar || BullHarami || BullCross ) && 
				(Close[shift]>Close[shift1])&& Close[shift]>Open[shift1]){
//			ExtMapBuffer1[shift] = Low[shift]-7*Point;
			Name=true;
			Arrow=true;
			}
		else 
			{ExtMapBuffer1[shift] = 0.0; Name=false; Arrow=false; }

		if( (BearEngulf || DarkCloud || EveningStar || Shooter || BearHarami || BearCross) && 
				(Close[shift]<Close[shift1])&& Close[shift]<Open[shift1]){
//			ExtMapBuffer2[shift] = High[shift]+7*Point;
			Name1=true;
			Arrow1=true;
			}
		else 
			{ExtMapBuffer2[shift] = 0.0; Name1=false; Arrow1=false;}
			
      //Подтверждение молота отдельно
      
         if (Hammer){ 
            if ((down))  {Name=true;
                          Arrow=true;}
  //                        ExtMapBuffer1[shift] = Low[shift]-7*Point;}
            else {Name=false; Arrow=false;}
            if ((up)) {Name1=true;
                       Arrow1=true;}
                       
     //		           ExtMapBuffer2[shift] = High[shift]+7*Point;}
            else {Name1=false; Arrow1=false;}
         }
         
         
         		
		// Вывод свечных моделей на экран
		// Модели быков
		if(BullHarami)
		{
			if(Name)	{n++; l[n]=Low[shift1];
            Setline(n,Time[shift1],l[n],Time[shift],l[n],Blue);
				SetText(n,Time[shift1],Low[shift1]-a*Point,"Харами",Lime);}
				if(Arrow)
				SetArrow(n,Time[shift1],Low[shift1]-b*Point,241,Lime);
		}

		if(BullCross)
		{
			if(Name){n++;
				SetText(n,Time[shift1],Low[shift1]-a*Point,"Проникающие линии",Aqua);
	
   			l[n]=Low[shift1];
            Setline(n,Time[shift1],l[n],Time[shift],l[n],Blue);}

			if(Arrow)
				SetArrow(n,Time[shift1],Low[shift1]-b*Point,241,Aqua);
		}


		if(BullEngulf)
		{
			if(Name){
				n++;
			   l[n]=Low[shift1];
            Setline(n,Time[shift1],l[n],Time[shift],l[n],Blue);
				SetText(n,Time[shift1],Low[shift1]-a*Point,"Поглощение",Yellow);}
			if(Arrow)
				SetArrow(n,Time[shift1],Low[shift1]-b*Point,241,Yellow);
		}
		if(BullPierce)
			{
				if(Name){
				n++;
			   l[n]=Low[shift1];
            Setline(n,Time[shift1],l[n],Time[shift],l[n],Blue);
				SetText(n,Time[shift1],Low[shift1]-a*Point,"Просвет облаков",White);}
				if(Arrow)
					SetArrow(n,Time[shift1],Low[shift1]-b*Point,241,White);
			}
		
		
		if(MorningStar)
		{
			if(Name){
			n++;
			SetText(n,Time[shift2],Low[shift2]-a*Point,"Утреняя Звезда",Magenta);
				l[n]=Low[shift2];
            Setline(n,Time[shift2],l[n],Time[shift],l[n],Blue);}

			if(Arrow)
				SetArrow(n,Time[shift2],Low[shift2]-b*Point,241,Magenta);
		}
		

		if(Hammer)
		{
			if(Name){
			n++;
				SetText(n,Time[shift1],Low[shift1]-a*Point,"Молот",Yellow);
   			l[n]=Low[shift1];
            Setline(n,Time[shift1],l[n],Time[shift],l[n],Blue);}

			if(Arrow)
				SetArrow(n,Time[shift1],Low[shift1]-b*Point,241,Yellow);
		}
///
////////////////////////////////////////////////////////////////////////////////////
//

		//модели медведей
		if(BearHarami)
		{
			if(Name1){
				x++;	
   			h[x]=High[shift1];
   			   			Setline1(x,Time[shift1],h[x],Time[shift],h[x],Blue);

				SetText1(x,Time[shift1],High[shift1]+(15+a)*Point,"Харами",Lime);}
			if(Arrow1)
				SetArrow1(x,Time[shift1],High[shift1]+(10+b)*Point,242,Lime);
		}
		
		if(BearCross)
		{
			if(Name1){		x++;
				SetText1(x,Time[shift1],High[shift1]+(15+a)*Point,"Проникающие линии",Aqua);
				h[x]=High[shift1];
            Setline1(x,Time[shift1],h[x],Time[shift],h[x],Blue);}

			if(Arrow1)
				SetArrow1(x,Time[shift1],High[shift1]+(10+b)*Point,242,Aqua);
		}
		
		
		if(Hammer)
		{
			if(Name1){	x++;
				SetText1(x,Time[shift1],High[shift1]+(15+a)*Point,"Повешаный",Yellow);
   		
   			h[x]=High[shift1];
   			Setline1(x,Time[shift1],h[x],Time[shift],h[x],Blue);}
			if(Arrow1)
				SetArrow1(x,Time[shift1],High[shift1]+(10+b)*Point,242,Yellow);
		}
		
	
		if(BearEngulf)
		{
			if(Name1){
				x++;	
   			h[x]=High[shift1];
   			Setline1(x,Time[shift1],h[x],Time[shift],h[x],Blue);

				SetText1(x,Time[shift1],High[shift1]+(15+a)*Point,"Поглощение",RoyalBlue);}
			if(Arrow1)
				SetArrow1(x,Time[shift1],High[shift1]+(10+b)*Point,242,RoyalBlue);
		}
		
		if(DarkCloud)
			{
				if(Name1){x++;	
   			h[x]=High[shift1];
   			   			Setline1(x,Time[shift1],h[x],Time[shift],h[x],Blue);

				SetText1(x,Time[shift1],High[shift1]+(15+a)*Point,"Темные облака",White);}
				if(Arrow1)
					SetArrow1(x,Time[shift1],High[shift1]+(10+b)*Point,242,White);
			}

		
		if(EveningStar)
		{
			if(Name1){
			x++;	
   			h[x]=High[shift2];
   			   			Setline1(x,Time[shift2],h[x],Time[shift],h[x],Blue);

				SetText1(x,Time[shift2],High[shift2]+(15+a)*Point,"Вечерняя звезда",Magenta);}
			if(Arrow1)
				SetArrow1(x,Time[shift2],High[shift2]+(10+b)*Point,242,Magenta);
		}
		
		if((Shooter))
		{
			if(Name1){	x++;
				SetText1(x,Time[shift1],High[shift1]+(15+a)*Point,"Падающая звезда",OrangeRed);
			
   			h[x]=High[shift1];
   			Setline1(x,Time[shift1],h[x],Time[shift],h[x],Blue);}

			if(Arrow1)
				SetArrow1(x,Time[shift1],High[shift1]+(10+b)*Point,242,OrangeRed);
		}
		
//Рисование линий поддержки и сопротивления
if (lines){
ObjectMove("-"+n, 1,Time[1],l[n]);
ObjectMove("+"+x, 1,Time[1],h[x]);
for (int i=1; i<50;i++) {
    if (Close[shift]<l[i]){ObjectSet("-"+i,6,DarkBlue); ObjectSet("-"+i,7,STYLE_DASHDOT);
              ObjectSet("x"+i,OBJPROP_COLOR,DarkBlue);ObjectSet("Arrow-"+i,OBJPROP_COLOR,DarkBlue);
              if (Dell) {ObjectDelete("-"+i);ObjectDelete("x"+i);ObjectDelete("Arrow-"+i);}
             }
 
}
for (int q=1; q<50;q++) {
 
    if (Close[shift]>h[q]){ObjectSet("+"+q,6,Black); ObjectSet("+"+q,7,STYLE_DASHDOT);
                ObjectSet("y"+q,OBJPROP_COLOR,Black);ObjectSet("Arrow+"+q,OBJPROP_COLOR,Black);
              if (Dell) {ObjectDelete("+"+q);ObjectDelete("y"+q);ObjectDelete("Arrow+"+q);}
               }
             

}

	}	// Tampilkan disaat ada konfirmasi.
		
		StartBar-=1;
	}
	
//Comment(p3[1],p3[2],p3[3],p3[4],p3[5],p3[6],p3[7],)	;
//Comment(x1[1],x1[2],x1[3],x1[4],x1[5],x1[6],x1[7],)	;
	
//----
   return(0);
}
//+------------------------------------------------------------------+