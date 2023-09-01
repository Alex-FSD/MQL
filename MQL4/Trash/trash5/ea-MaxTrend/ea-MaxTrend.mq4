//+------------------------------------------------------------------+
//|                                                     MaxTrend.mq4 |
//|                               Copyright © 2014, Vladimir Hlystov |
//|                                                cmillion@narod.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2014, Vladimir Hlystov"
#property link      "http://cmillion.ru"
//+------------------------------------------------------------------+
//определение максимальной волны без отката
extern int откат = 100;     //какой откат ждем
extern datetime TimeFindStart = D'2013.01.01 00:00'; //Время с которого ищем
extern datetime TimeFindEnd = D'2011.12.31 00:00'; //Время по которое ищем
datetime TimeOld,TimeOldВoлна2;
string txt;
int BarStart;
//+------------------------------------------------------------------+
int init()
{
   if (TimeFindEnd>TimeCurrent()) TimeFindEnd=TimeCurrent();
   txt=StringConcatenate("MaxTrend","\n","Copyright © 2014, Vladimir Hlystov","\n","http://cmillion.ru",
           "\n","с ",TimeToStr(TimeFindStart,TIME_DATE|TIME_MINUTES),
           "\n","по ",TimeToStr(TimeFindEnd,TIME_DATE|TIME_MINUTES));
   BarStart = iBarShift(NULL,0,TimeFindStart);
   if (BarStart==-1) txt="Нет котировок за ";
   RectLabelCreate(0,"fon",     0,255,15,250,170,clrLightGray,clrLightGray,STYLE_SOLID,3,false,false,true,0);
   LabelCreate(0,"откат" ,0 ,150,38,CORNER_RIGHT_UPPER,StringConcatenate("откат ",откат),"Arial",10,clrBlue,0,ANCHOR_CENTER,false,false,true,0);
   ButtonCreate(0,"kn откат up",0,10,20,18,18,CharToStr(217),"Wingdings",8,clrBlue,clrGray,clrLightGray,clrNONE,false);
   ButtonCreate(0,"kn откат dn",0,10,40,18,18,CharToStr(218),"Wingdings",8,clrBlue,clrGray,clrLightGray,clrNONE,false);
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
      if (clickedChartObject=="kn откат up")
      {
         откат+=10;
         Sleep(100);
         if (ObjectGetInteger(0,"kn откат up",OBJPROP_STATE)) ObjectSetInteger(0,"kn откат up",OBJPROP_STATE,false);
      }
      if (clickedChartObject=="kn откат dn")
      {
         откат-=10;
         Sleep(100);
         if (ObjectGetInteger(0,"kn откат dn",OBJPROP_STATE)) ObjectSetInteger(0,"kn откат dn",OBJPROP_STATE,false);
      }
   LabelCreate(0,"откат" ,0 ,150,38,CORNER_RIGHT_UPPER,StringConcatenate("откат ",откат),"Arial",10,clrBlue,0,ANCHOR_CENTER,false,false,true,0);
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
      int тек_тренд = (maxPrice-minPrice)/Point;
      
      if ((maxPrice-Low[i])/Point >= откат && тек_тренд>откат && TimeMin<TimeMax) //прерываем тренд
      {
         if (MaxTrednB < тек_тренд) 
         {
            MaxTrednB = тек_тренд; 
            Name = "бык "+TimeToStr(Time[i],TIME_DATE|TIME_MINUTES)+"  размер "+тек_тренд;
            ObjectDelete(Name);
            ObjectCreate(Name, OBJ_TREND, 0,TimeMin,minPrice,TimeMax,maxPrice);
            ObjectSet   (Name, OBJPROP_COLOR, Blue);
            ObjectSet   (Name, OBJPROP_STYLE, 0);
            ObjectSet   (Name, OBJPROP_WIDTH, 2);
            ObjectSet   (Name, OBJPROP_BACK,  true);
            ObjectSet   (Name, OBJPROP_RAY,   false);

            Name = Name + "откат";
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
    
      if ((High[i]-minPrice)/Point >= откат && тек_тренд>откат && TimeMin>TimeMax) 
      {
         if (MaxTrendS < тек_тренд) 
         {
            MaxTrendS = тек_тренд; 
            Name = "медведь "+TimeToStr(Time[i],TIME_DATE|TIME_MINUTES)+"  размер "+тек_тренд;
            ObjectDelete(Name);
            ObjectCreate(Name, OBJ_TREND, 0,TimeMax,maxPrice,TimeMin,minPrice);
            ObjectSet   (Name, OBJPROP_COLOR, Red);
            ObjectSet   (Name, OBJPROP_STYLE, 0);
            ObjectSet   (Name, OBJPROP_WIDTH, 2);
            ObjectSet   (Name, OBJPROP_BACK,  true);
            ObjectSet   (Name, OBJPROP_RAY,   false);
            Name = Name + "откат";
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
   LabelCreate(0,"максимальный медвежий тренд" ,0 ,130,70,CORNER_RIGHT_UPPER,StringConcatenate("максимальный медвежий тренд ",MaxTrendS),"Arial",8,clrBlue,0,ANCHOR_CENTER,false,false,true,0);
   LabelCreate(0,"максимальный бычий тренд"    ,0 ,130,90,CORNER_RIGHT_UPPER,StringConcatenate("максимальный бычий тренд ",MaxTrednB),"Arial",8,clrBlue,0,ANCHOR_CENTER,false,false,true,0);
   LabelCreate(0,"зафиксировано откатов"       ,0 ,130,120,CORNER_RIGHT_UPPER,"зафиксировано откатов ","Arial",8,clrBlue,0,ANCHOR_CENTER,false,false,true,0);
   LabelCreate(0,"медвежий тренд"              ,0 ,130,140,CORNER_RIGHT_UPPER,StringConcatenate("медвежий тренд ",s),"Arial",8,clrBlue,0,ANCHOR_CENTER,false,false,true,0);
   LabelCreate(0,"бычий тренд"                 ,0 ,130,160,CORNER_RIGHT_UPPER,StringConcatenate("бычий тренд ",b),"Arial",8,clrBlue,0,ANCHOR_CENTER,false,false,true,0);
   Comment(txt,
           "\n","откат",откат,"максимальный медвежий тренд ",MaxTrendS,
               "\nмаксимальный бычий тренд ",MaxTrednB,
               "\n\nзафиксировано откатов ",
               "\nмедвежий тренд ",s,
               "\nбычий тренд ",b);
   return(0);
}
//+------------------------------------------------------------------+
bool ButtonCreate(const long              chart_ID=0,               // ID графика
                  const string            name="Button",            // имя кнопки
                  const int               sub_window=0,             // номер подокна
                  const long               x=0,                      // координата по оси X
                  const long               y=0,                      // координата по оси Y
                  const int               width=50,                 // ширина кнопки
                  const int               height=18,                // высота кнопки
                  const string            text="Button",            // текст
                  const string            font="Arial",             // шрифт
                  const int               font_size=10,             // размер шрифта
                  const color             clr=clrLime,              // цвет текста
                  const color             clrON=clrLime,            // цвет фона
                  const color             clrOFF=clrBlack,          // цвет фона
                  const color             border_clr=clrNONE,       // цвет границы
                  const bool              state=false)              // нажата/отжата
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
bool RectLabelCreate(const long             chart_ID=0,               // ID графика
                     const string           name="RectLabel",         // имя метки
                     const int              sub_window=0,             // номер подокна
                     const long              x=0,                     // координата по оси X
                     const long              y=0,                     // координата по оси y
                     const int              width=50,                 // ширина
                     const int              height=18,                // высота
                     const color            back_clr=clrNONE,         // цвет фона
                     const color            clr=clrNONE,              // цвет плоской границы (Flat)
                     const ENUM_LINE_STYLE  style=STYLE_SOLID,        // стиль плоской границы
                     const int              line_width=1,             // толщина плоской границы
                     const bool             back=false,               // на заднем плане
                     const bool             selection=false,          // выделить для перемещений
                     const bool             hidden=true,              // скрыт в списке объектов
                     const long             z_order=0)                // приоритет на нажатие мышью
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
bool LabelCreate(const long              chart_ID=0,               // ID графика
                 const string            name="Label",             // имя метки
                 const int               sub_window=0,             // номер подокна
                 const long              x=0,                      // координата по оси X
                 const long              y=0,                      // координата по оси y
                 const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // угол графика для привязки
                 const string            text="Label",             // текст
                 const string            font="Arial",             // шрифт
                 const int               font_size=10,             // размер шрифта
                 const color             clr=clrNONE,      
                 const double            angle=0.0,                // наклон текста
                 const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // способ привязки
                 const bool              back=false,               // на заднем плане
                 const bool              selection=false,          // выделить для перемещений
                 const bool              hidden=true,              // скрыт в списке объектов
                 const long              z_order=0)                // приоритет на нажатие мышью
{
   ResetLastError();
   if (ObjectFind(chart_ID,name)==-1)
   {
      if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0))
      {
         Print(__FUNCTION__,": не удалось создать текстовую метку! Код ошибки = ",GetLastError());
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
