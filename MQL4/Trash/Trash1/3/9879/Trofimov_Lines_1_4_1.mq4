//+---------------------------------------------------------------------+
//|                                                Trofimov_Lines.mq4   |
//|                                         Copyright � Trofimov 2010   |
//+---------------------------------------------------------------------+
#property copyright "Copyright � Trofimov Evgeniy, 2010"
#property link      "http://www.mql4.com/ru/users/EvgeTrofi"
//---- �������� ����������
#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 Blue
#property indicator_width1 1
#property indicator_color2 Red
#property indicator_width2 1

//---- �������� ���������
extern int MaxiCanal=5000; //������������ ������ ������
extern int MinLengh=0;    //����������� ����� ������
double Buff_line1[];
double Buff_line2[];
double Buff_line3[]; //-�����
double Buff_line4[]; //-������
double Buff_line5[]; //-����
double Buff_line6[]; //-������� �����
double Buff_line7[]; //-������� �������
double Buff_line8[]; //-����������� ������
double Golden = 0.381966;
//+------------------------------------------------------------------+
//|                ������� ������������� ����������                  |
//+------------------------------------------------------------------+
int init() {
//---- x �������������� ������, ������������ ��� �������
   IndicatorBuffers(8);
   IndicatorDigits(Digits); 
//---- ��������� ��������� (��������� ���������� ����)
   //SetIndexDrawBegin(0,1);
   //SetIndexDrawBegin(1,1);
//---- x �������������� ������ ����������
   SetIndexBuffer(0,Buff_line1);
   SetIndexBuffer(1,Buff_line2);
   SetIndexBuffer(2,Buff_line3);
   SetIndexBuffer(3,Buff_line4);
   SetIndexBuffer(4,Buff_line5);
   SetIndexBuffer(5,Buff_line6);
   SetIndexBuffer(6,Buff_line7);
   SetIndexBuffer(7,Buff_line8);
//---- ��� ���������� � ��������� ��� �����
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
//|                ������� ����������                                |
//+------------------------------------------------------------------+
int start() {
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   int limit=Bars-counted_bars;
   int j, x;
   double y, y1;
   //������� ��������� ��������:
   double width; //-������ ������
   double WDown, WUp; //���������� �� ����������� ����� ��������� �� ������ � ������� �������
   int begin; //-����� ��������� ����� ��� ����������� ��������
   static datetime beginTime;
   double angle; //-���� ������� �������� � ���������
   static bool first=true;
   if(first) {
      beginTime=Time[limit-1];
      first=false;
   }
   for(int t=limit-1; t>-1; t--){//����� t - ��� ������� �����, ��� ������� ������ ������
      begin=Candle(beginTime, t);
      x=begin-t;
      if(x==0) continue;
      angle=((High[t]+Low[t])/2-(High[begin]+Low[begin])/2)/x;//����������
      y1=(High[begin]+Low[begin])/2;
      WDown=0; WUp=0;
      for(j=begin-1; j>=t; j--){//����� ������� � ������ �������
         x=begin-j;//- ���������� �� ��������� ��������� �� ������������� ����� � ������
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

