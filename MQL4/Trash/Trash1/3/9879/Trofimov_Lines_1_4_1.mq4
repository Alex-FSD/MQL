//+---------------------------------------------------------------------+
//|                                                Trofimov_Lines.mq4   |
//|                                         Copyright © Trofimov 2010   |
//+---------------------------------------------------------------------+
#property copyright "Copyright © Trofimov Evgeniy, 2010"
#property link      "http://www.mql4.com/ru/users/EvgeTrofi"
//---- Свойства индикатора
#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 Blue
#property indicator_width1 1
#property indicator_color2 Red
#property indicator_width2 1

//---- Входящие параметры
extern int MaxiCanal=5000; //Максимальная ширина канала
extern int MinLengh=0;    //Минимальная длина канала
double Buff_line1[];
double Buff_line2[];
double Buff_line3[]; //-Длина
double Buff_line4[]; //-Ширина
double Buff_line5[]; //-Угол
double Buff_line6[]; //-Средняя линия
double Buff_line7[]; //-Золотое сечение
double Buff_line8[]; //-вероятность тренда
double Golden = 0.381966;
//+------------------------------------------------------------------+
//|                Функция инициализации индикатора                  |
//+------------------------------------------------------------------+
int init() {
//---- x дополнительных буфера, используемых для расчета
   IndicatorBuffers(8);
   IndicatorDigits(Digits); 
//---- параметры рисования (установка начального бара)
   //SetIndexDrawBegin(0,1);
   //SetIndexDrawBegin(1,1);
//---- x распределенных буфера индикатора
   SetIndexBuffer(0,Buff_line1);
   SetIndexBuffer(1,Buff_line2);
   SetIndexBuffer(2,Buff_line3);
   SetIndexBuffer(3,Buff_line4);
   SetIndexBuffer(4,Buff_line5);
   SetIndexBuffer(5,Buff_line6);
   SetIndexBuffer(6,Buff_line7);
   SetIndexBuffer(7,Buff_line8);
//---- имя индикатора и подсказки для линий
   IndicatorShortName("TrofiLines");
   SetIndexLabel(0,"Up");
   SetIndexLabel(1,"Dn");
   SetIndexLabel(2,"Lengh");
   SetIndexLabel(3,"Width");
   SetIndexLabel(4,"Angle");
   SetIndexLabel(5,"Midle");
   SetIndexLabel(6,"Gold");
   SetIndexLabel(7,"Trend");
   SetIndexStyle(2,DRAW_NONE);
   SetIndexStyle(3,DRAW_NONE);
   SetIndexStyle(4,DRAW_NONE);
   SetIndexStyle(5,DRAW_NONE);
   SetIndexStyle(7,DRAW_NONE);
   return(0);
}//init()
//+------------------------------------------------------------------+
//|                Функция индикатора                                |
//+------------------------------------------------------------------+
int start() {
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   int limit=Bars-counted_bars;
   int j, x;
   double y, y1;
   //Текущие расчётные значения:
   double width; //-ширина канала
   double WDown, WUp; //Расстояние от центральной линии регрессии до нижней и верхней границы
   int begin; //-номер начальной свечи для образования коридора
   static datetime beginTime;
   double angle; //-угол наклона коридора к горизонту
   static bool first=true;
   if(first) {
      beginTime=Time[limit-1];
      first=false;
   }
   for(int t=limit-1; t>-1; t--){//Здесь t - это текущая свеча, для которой строим график
      begin=Candle(beginTime, t);
      x=begin-t;
      if(x==0) continue;
      angle=((High[t]+Low[t])/2-(High[begin]+Low[begin])/2)/x;//Приращение
      y1=(High[begin]+Low[begin])/2;
      WDown=0; WUp=0;
      for(j=begin-1; j>=t; j--){//Поиск перхней и нижней границы
         x=begin-j;//- расстояние от исходного положения до анализируемой свечи в свечах
         y=angle*x+y1;
         if(Low[j]<y-WDown) WDown=y-Low[j];
         if(High[j]>y+WUp) WUp=High[j]-y;
      }//Next j
      width=(WDown+WUp)/Point;
      if(x>MinLengh){
         Buff_line1[t]=y+WUp;
         Buff_line2[t]=y-WDown;
         Buff_line6[t]=y;
         if(angle>0) {
            Buff_line7[t]=Buff_line2[t]+(WUp+WDown)*Golden;
            Buff_line8[t]=(Close[t]-Buff_line7[t])*100/(Buff_line1[t]-Buff_line7[t]);
         }else{
            Buff_line7[t]=Buff_line1[t]-(WUp+WDown)*Golden;
            Buff_line8[t]=-(Buff_line7[t]-Close[t])*100/(Buff_line7[t]-Buff_line2[t]);
         }   
      }
      Buff_line3[t]=x;
      Buff_line4[t]=width;
      Buff_line5[t]=angle/Point;
      if(width>MaxiCanal) {
         beginTime=Time[t];
         width=0;
         Buff_line1[t]=EMPTY_VALUE;
         Buff_line2[t]=EMPTY_VALUE;
      }
   }//Next t   
}//start()
//+------------------------------------------------------------------+
int Candle(datetime MyTime, int start=0){
   for(int i=start; i<Bars; i++){
      if(MyTime>=Time[i]) return(i);
   }
   return(-1);
}//Candle()
//+------------------------------------------------------------------+

