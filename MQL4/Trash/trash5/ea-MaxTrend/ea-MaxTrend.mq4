//+------------------------------------------------------------------+
//|                                                     MaxTrend.mq4 |
//|                               Copyright � 2014, Vladimir Hlystov |
//|                                                cmillion@narod.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright � 2014, Vladimir Hlystov"
#property link      "http://cmillion.ru"
//+------------------------------------------------------------------+
//����������� ������������ ����� ��� ������
extern int ����� = 100;     //����� ����� ����
extern datetime TimeFindStart = D'2013.01.01 00:00'; //����� � �������� ����
extern datetime TimeFindEnd = D'2011.12.31 00:00'; //����� �� ������� ����
datetime TimeOld,TimeOld�o���2;
string txt;
int BarStart;
//+------------------------------------------------------------------+
int init()
{
   if (TimeFindEnd>TimeCurrent()) TimeFindEnd=TimeCurrent();
   txt=StringConcatenate("MaxTrend","\n","Copyright � 2014, Vladimir Hlystov","\n","http://cmillion.ru",
           "\n","� ",TimeToStr(TimeFindStart,TIME_DATE|TIME_MINUTES),
           "\n","�� ",TimeToStr(TimeFindEnd,TIME_DATE|TIME_MINUTES));
   BarStart = iBarShift(NULL,0,TimeFindStart);
   if (BarStart==-1) txt="��� ��������� �� ";
   RectLabelCreate(0,"fon",     0,255,15,250,170,clrLightGray,clrLightGray,STYLE_SOLID,3,false,false,true,0);
   LabelCreate(0,"�����" ,0 ,150,38,CORNER_RIGHT_UPPER,StringConcatenate("����� ",�����),"Arial",10,clrBlue,0,ANCHOR_CENTER,false,false,true,0);
   ButtonCreate(0,"kn ����� up",0,10,20,18,18,CharToStr(217),"Wingdings",8,clrBlue,clrGray,clrLightGray,clrNONE,false);
   ButtonCreate(0,"kn ����� dn",0,10,40,18,18,CharToStr(218),"Wingdings",8,clrBlue,clrGray,clrLightGray,clrNONE,false);
   return(0);
}
//+------------------------------------------------------------------+
int deinit()
{
   ObjectsDeleteAll(0);
   return(0);
}
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{

   if(id==CHARTEVENT_OBJECT_CLICK)
   {
      string clickedChartObject=sparam;
      if (clickedChartObject=="kn ����� up")
      {
         �����+=10;
         Sleep(100);
         if (ObjectGetInteger(0,"kn ����� up",OBJPROP_STATE)) ObjectSetInteger(0,"kn ����� up",OBJPROP_STATE,false);
      }
      if (clickedChartObject=="kn ����� dn")
      {
         �����-=10;
         Sleep(100);
         if (ObjectGetInteger(0,"kn ����� dn",OBJPROP_STATE)) ObjectSetInteger(0,"kn ����� dn",OBJPROP_STATE,false);
      }
   LabelCreate(0,"�����" ,0 ,150,38,CORNER_RIGHT_UPPER,StringConcatenate("����� ",�����),"Arial",10,clrBlue,0,ANCHOR_CENTER,false,false,true,0);
   chek();
   }
}
//--------------------------------------------------------------------
int start()
{
   chek();
   return(0);
}
//+------------------------------------------------------------------+
int chek()
{
   ObjectsDeleteAll(0,OBJ_TREND);
   int b=0,s=0;
   datetime TimeMin,TimeMax;
   double minPrice = Low[BarStart]; TimeMin = Time[BarStart];
   double maxPrice = High[BarStart];TimeMax = Time[BarStart];
   int MaxTrednB=0,MaxTrendS=0;
   string Name;
   for (int i=BarStart; i>=0; i--)
   {
      if (Time[i]>TimeFindEnd) break;
      if (minPrice > Low[i])  {minPrice = Low[i]; TimeMin = Time[i];}
      if (maxPrice < High[i]) {maxPrice = High[i];TimeMax = Time[i];}
      int ���_����� = (maxPrice-minPrice)/Point;
      
      if ((maxPrice-Low[i])/Point >= ����� && ���_�����>����� && TimeMin<TimeMax) //��������� �����
      {
         if (MaxTrednB < ���_�����) 
         {
            MaxTrednB = ���_�����; 
            Name = "��� "+TimeToStr(Time[i],TIME_DATE|TIME_MINUTES)+"  ������ "+���_�����;
            ObjectDelete(Name);
            ObjectCreate(Name, OBJ_TREND, 0,TimeMin,minPrice,TimeMax,maxPrice);
            ObjectSet   (Name, OBJPROP_COLOR, Blue);
            ObjectSet   (Name, OBJPROP_STYLE, 0);
            ObjectSet   (Name, OBJPROP_WIDTH, 2);
            ObjectSet   (Name, OBJPROP_BACK,  true);
            ObjectSet   (Name, OBJPROP_RAY,   false);

            Name = Name + "�����";
            ObjectDelete(Name);
            ObjectCreate(Name, OBJ_TREND, 0,TimeMax,maxPrice,Time[i],Low[i]);
            ObjectSet   (Name, OBJPROP_COLOR, Yellow);
            ObjectSet   (Name, OBJPROP_STYLE, 0);
            ObjectSet   (Name, OBJPROP_WIDTH, 2);
            ObjectSet   (Name, OBJPROP_BACK,  true);
            ObjectSet   (Name, OBJPROP_RAY,   false);
         }
         
         minPrice = Low[i];
         TimeMin = Time[i];
         b++;
         continue;
      }
    
      if ((High[i]-minPrice)/Point >= ����� && ���_�����>����� && TimeMin>TimeMax) 
      {
         if (MaxTrendS < ���_�����) 
         {
            MaxTrendS = ���_�����; 
            Name = "������� "+TimeToStr(Time[i],TIME_DATE|TIME_MINUTES)+"  ������ "+���_�����;
            ObjectDelete(Name);
            ObjectCreate(Name, OBJ_TREND, 0,TimeMax,maxPrice,TimeMin,minPrice);
            ObjectSet   (Name, OBJPROP_COLOR, Red);
            ObjectSet   (Name, OBJPROP_STYLE, 0);
            ObjectSet   (Name, OBJPROP_WIDTH, 2);
            ObjectSet   (Name, OBJPROP_BACK,  true);
            ObjectSet   (Name, OBJPROP_RAY,   false);
            Name = Name + "�����";
            ObjectDelete(Name);
            ObjectCreate(Name, OBJ_TREND, 0,TimeMin,minPrice,Time[i],Low[i]);
            ObjectSet   (Name, OBJPROP_COLOR, Gold);
            ObjectSet   (Name, OBJPROP_STYLE, 0);
            ObjectSet   (Name, OBJPROP_WIDTH, 2);
            ObjectSet   (Name, OBJPROP_BACK,  true);
            ObjectSet   (Name, OBJPROP_RAY,   false);
         }
         {maxPrice = High[i];TimeMax = Time[i];}
         s++;
      }
   }
   LabelCreate(0,"������������ �������� �����" ,0 ,130,70,CORNER_RIGHT_UPPER,StringConcatenate("������������ �������� ����� ",MaxTrendS),"Arial",8,clrBlue,0,ANCHOR_CENTER,false,false,true,0);
   LabelCreate(0,"������������ ����� �����"    ,0 ,130,90,CORNER_RIGHT_UPPER,StringConcatenate("������������ ����� ����� ",MaxTrednB),"Arial",8,clrBlue,0,ANCHOR_CENTER,false,false,true,0);
   LabelCreate(0,"������������� �������"       ,0 ,130,120,CORNER_RIGHT_UPPER,"������������� ������� ","Arial",8,clrBlue,0,ANCHOR_CENTER,false,false,true,0);
   LabelCreate(0,"�������� �����"              ,0 ,130,140,CORNER_RIGHT_UPPER,StringConcatenate("�������� ����� ",s),"Arial",8,clrBlue,0,ANCHOR_CENTER,false,false,true,0);
   LabelCreate(0,"����� �����"                 ,0 ,130,160,CORNER_RIGHT_UPPER,StringConcatenate("����� ����� ",b),"Arial",8,clrBlue,0,ANCHOR_CENTER,false,false,true,0);
   Comment(txt,
           "\n","�����",�����,"������������ �������� ����� ",MaxTrendS,
               "\n������������ ����� ����� ",MaxTrednB,
               "\n\n������������� ������� ",
               "\n�������� ����� ",s,
               "\n����� ����� ",b);
   return(0);
}
//+------------------------------------------------------------------+
bool ButtonCreate(const long              chart_ID=0,               // ID �������
                  const string            name="Button",            // ��� ������
                  const int               sub_window=0,             // ����� �������
                  const long               x=0,                      // ���������� �� ��� X
                  const long               y=0,                      // ���������� �� ��� Y
                  const int               width=50,                 // ������ ������
                  const int               height=18,                // ������ ������
                  const string            text="Button",            // �����
                  const string            font="Arial",             // �����
                  const int               font_size=10,             // ������ ������
                  const color             clr=clrLime,              // ���� ������
                  const color             clrON=clrLime,            // ���� ����
                  const color             clrOFF=clrBlack,          // ���� ����
                  const color             border_clr=clrNONE,       // ���� �������
                  const bool              state=false)              // ������/������
  {
   if (ObjectFind(chart_ID,name)==-1)
   {
      ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0);
      ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
      ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
      ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
      ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,0);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,0);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,0);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,1);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,0);
      ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state);
   }
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
   color back_clr;
   if (ObjectGetInteger(chart_ID,name,OBJPROP_STATE)) back_clr=clrON; else back_clr=clrOFF;
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
   return(true);
}
//--------------------------------------------------------------------
bool RectLabelCreate(const long             chart_ID=0,               // ID �������
                     const string           name="RectLabel",         // ��� �����
                     const int              sub_window=0,             // ����� �������
                     const long              x=0,                     // ���������� �� ��� X
                     const long              y=0,                     // ���������� �� ��� y
                     const int              width=50,                 // ������
                     const int              height=18,                // ������
                     const color            back_clr=clrNONE,         // ���� ����
                     const color            clr=clrNONE,              // ���� ������� ������� (Flat)
                     const ENUM_LINE_STYLE  style=STYLE_SOLID,        // ����� ������� �������
                     const int              line_width=1,             // ������� ������� �������
                     const bool             back=false,               // �� ������ �����
                     const bool             selection=false,          // �������� ��� �����������
                     const bool             hidden=true,              // ����� � ������ ��������
                     const long             z_order=0)                // ��������� �� ������� �����
  {
   ResetLastError();
   if (ObjectFind(chart_ID,name)==-1)
   {
      ObjectCreate(chart_ID,name,OBJ_RECTANGLE_LABEL,sub_window,0,0);
      ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_TYPE,BORDER_FLAT);
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
      ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,ANCHOR_RIGHT_UPPER);
      ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
      ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,line_width);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
   }
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
   return(true);
}
//--------------------------------------------------------------------
bool LabelCreate(const long              chart_ID=0,               // ID �������
                 const string            name="Label",             // ��� �����
                 const int               sub_window=0,             // ����� �������
                 const long              x=0,                      // ���������� �� ��� X
                 const long              y=0,                      // ���������� �� ��� y
                 const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // ���� ������� ��� ��������
                 const string            text="Label",             // �����
                 const string            font="Arial",             // �����
                 const int               font_size=10,             // ������ ������
                 const color             clr=clrNONE,      
                 const double            angle=0.0,                // ������ ������
                 const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // ������ ��������
                 const bool              back=false,               // �� ������ �����
                 const bool              selection=false,          // �������� ��� �����������
                 const bool              hidden=true,              // ����� � ������ ��������
                 const long              z_order=0)                // ��������� �� ������� �����
{
   ResetLastError();
   if (ObjectFind(chart_ID,name)==-1)
   {
      if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0))
      {
         Print(__FUNCTION__,": �� ������� ������� ��������� �����! ��� ������ = ",GetLastError());
         return(false);
      }
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
      ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
      ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
      ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
      ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
   }
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
   return(true);
  }
//--------------------------------------------------------------------
