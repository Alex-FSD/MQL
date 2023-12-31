//+------------------------------------------------------------------+
//|                                                   Four Weeks.mq4 |
//|                                               Yuriy Tokman (YTG) |
//|                       https://www.mql5.com/ru/users/satop/seller |
//+------------------------------------------------------------------+
#property copyright "Yuriy Tokman (YTG)"
#property link      "https://www.mql5.com/ru/users/satop/seller"
#property version   "1.00"
#property strict
#property indicator_chart_window

//---
input bool L1                = true;
input int bar1               = 1;
input ENUM_TIMEFRAMES TF1    = PERIOD_W1;
input color color1           = clrBlue;
input ENUM_LINE_STYLE style1 = STYLE_SOLID;
//---
input bool L2                = true;
input int bar2               = 2;
input ENUM_TIMEFRAMES TF2    = PERIOD_W1;
input color color2           = clrRed;
input ENUM_LINE_STYLE style2 = STYLE_SOLID;
//---
input bool L3                = true;
input int bar3               = 3;
input ENUM_TIMEFRAMES TF3    = PERIOD_W1;
input color color3           = clrGreen;
input ENUM_LINE_STYLE style3 = STYLE_SOLID;
//---
input bool L4                = true;
input int bar4               = 4;
input ENUM_TIMEFRAMES TF4    = PERIOD_W1;
input color color4           = clrDarkGray;
input ENUM_LINE_STYLE style4 = STYLE_SOLID;
//----
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping

//---
   return(INIT_SUCCEEDED);
  }
void OnDeinit(const int reason) {GetDellName();}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   double cW1 = iClose(Symbol(),TF1,bar1);
   double cW2 = iClose(Symbol(),TF2,bar2);
   double cW3 = iClose(Symbol(),TF3,bar3);
   double cW4 = iClose(Symbol(),TF4,bar4);

   if(NewBar1() && L1)
     {
      TrendCreate(0,"ytg_c1",0,iTime(Symbol(),TF1,bar1-1),cW1,TimeCurrent(),cW1,color1,style1);
      TextCreate(0,"ytg_c1_txt",0,Time[0]+20*Period()*60,cW1,"L1 ["+DoubleToString(cW1,Digits)+"]","Arial",8,color1);
     }
//---
   if(NewBar2() && L2)
     {
      TrendCreate(0,"ytg_c2",0,iTime(Symbol(),TF2,bar2-1),cW2,TimeCurrent(),cW2,color2,style2);
      TextCreate(0,"ytg_c2_txt",0,Time[0]+20*Period()*60,cW2,"L2 ["+DoubleToString(cW2,Digits)+"]","Arial",8,color2);
     }
//---
   if(NewBar3() && L3)
     {
      TrendCreate(0,"ytg_c3",0,iTime(Symbol(),TF3,bar3-1),cW3,TimeCurrent(),cW3,color3,style3);
      TextCreate(0,"ytg_c3_txt",0,Time[0]+20*Period()*60,cW3,"L3 ["+DoubleToString(cW3,Digits)+"]","Arial",8,color3);
     }
//---
   if(NewBar4() && L4)
     {
      TrendCreate(0,"ytg_c4",0,iTime(Symbol(),TF4,bar4-1),cW4,TimeCurrent(),cW4,color4,style4);
      TextCreate(0,"ytg_c4_txt",0,Time[0]+20*Period()*60,cW4,"L4 ["+DoubleToString(cW4,Digits)+"]","Arial",8,color4);
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//----+
void GetDellName(string name_n = "ytg")
  {
   string vName;
   for(int i=ObjectsTotal()-1; i>=0; i--)
     {
      vName = ObjectName(i);
      if(StringFind(vName,name_n) !=-1)
         ObjectDelete(vName);
     }
  }
//----+
bool NewBar1(ENUM_TIMEFRAMES _TF = PERIOD_CURRENT)
  {
   static datetime NewTime=0;
   if(NewTime!=iTime(Symbol(),_TF,0))
     {
      NewTime=iTime(Symbol(),_TF,0);
      return(true);
     }
   return(false);
  }
//----+
//----+
bool NewBar2(ENUM_TIMEFRAMES _TF = PERIOD_CURRENT)
  {
   static datetime NewTime=0;
   if(NewTime!=iTime(Symbol(),_TF,0))
     {
      NewTime=iTime(Symbol(),_TF,0);
      return(true);
     }
   return(false);
  }
//----+
//----+
bool NewBar3(ENUM_TIMEFRAMES _TF = PERIOD_CURRENT)
  {
   static datetime NewTime=0;
   if(NewTime!=iTime(Symbol(),_TF,0))
     {
      NewTime=iTime(Symbol(),_TF,0);
      return(true);
     }
   return(false);
  }
//----+
//----+
bool NewBar4(ENUM_TIMEFRAMES _TF = PERIOD_CURRENT)
  {
   static datetime NewTime=0;
   if(NewTime!=iTime(Symbol(),_TF,0))
     {
      NewTime=iTime(Symbol(),_TF,0);
      return(true);
     }
   return(false);
  }
//----+
//+------------------------------------------------------------------+
//| Создает линию тренда по заданным координатам                     |
//+------------------------------------------------------------------+
bool TrendCreate(const long            chart_ID=0,        // ID графика
                 const string          name="TrendLine",  // имя линии
                 const int             sub_window=0,      // номер подокна
                 datetime              time1=0,           // время первой точки
                 double                price1=0,          // цена первой точки
                 datetime              time2=0,           // время второй точки
                 double                price2=0,          // цена второй точки
                 const color           clr=clrRed,        // цвет линии
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // стиль линии
                 const int             width=1,           // толщина линии
                 const bool            back=true,        // на заднем плане
                 const bool            selection=false,    // выделить для перемещений
                 const bool            ray_right=true,   // продолжение линии вправо
                 const bool            hidden=true,       // скрыт в списке объектов
                 const long            z_order=0)         // приоритет на нажатие мышью
  {
//--- установим координаты точек привязки, если они не заданы
   if(ObjectFind(chart_ID,name)!=-1)
      ObjectDelete(chart_ID,name);
//--- сбросим значение ошибки
   ResetLastError();
//--- создадим трендовую линию по заданным координатам
   if(!ObjectCreate(chart_ID,name,OBJ_TREND,sub_window,time1,price1,time2,price2))
     {
      Print(__FUNCTION__,
            ": не удалось создать линию тренда! Код ошибки = ",GetLastError());
      return(false);
     }
//--- установим цвет линии
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- установим стиль отображения линии
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- установим толщину линии
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- отобразим на переднем (false) или заднем (true) плане
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- включим (true) или отключим (false) режим перемещения линии мышью
//--- при создании графического объекта функцией ObjectCreate, по умолчанию объект
//--- нельзя выделить и перемещать. Внутри же этого метода параметр selection
//--- по умолчанию равен true, что позволяет выделять и перемещать этот объект
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- включим (true) или отключим (false) режим продолжения отображения линии вправо
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_RIGHT,ray_right);
//--- скроем (true) или отобразим (false) имя графического объекта в списке объектов
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- установим приоритет на получение события нажатия мыши на графике
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- успешное выполнение
   return(true);
  }
//----
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Создает объект "Текст"                                           |
//+------------------------------------------------------------------+
bool TextCreate(const long              chart_ID=0,               // ID графика
                const string            name="Text",              // имя объекта
                const int               sub_window=0,             // номер подокна
                datetime                time=0,                   // время точки привязки
                double                  price=0,                  // цена точки привязки
                const string            text="Text",              // сам текст
                const string            font="Arial",             // шрифт
                const int               font_size=10,             // размер шрифта
                const color             clr=clrRed,               // цвет
                const double            angle=0.0,                // наклон текста
                const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // способ привязки
                const bool              back=false,               // на заднем плане
                const bool              selection=false,          // выделить для перемещений
                const bool              hidden=true,              // скрыт в списке объектов
                const long              z_order=0)                // приоритет на нажатие мышью
  {
//--- установим координаты точки привязки, если они не заданы
   if(ObjectFind(chart_ID,name)!=-1)
      ObjectDelete(chart_ID,name);
//--- сбросим значение ошибки
   ResetLastError();
//--- создадим объект "Текст"
   if(!ObjectCreate(chart_ID,name,OBJ_TEXT,sub_window,time,price))
     {
      Print(__FUNCTION__,
            ": не удалось создать объект \"Текст\"! Код ошибки = ",GetLastError());
      return(false);
     }
//--- установим текст
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- установим шрифт текста
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- установим размер шрифта
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- установим угол наклона текста
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
//--- установим способ привязки
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
//--- установим цвет
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- отобразим на переднем (false) или заднем (true) плане
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- включим (true) или отключим (false) режим перемещения объекта мышью
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- скроем (true) или отобразим (false) имя графического объекта в списке объектов
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- установим приоритет на получение события нажатия мыши на графике
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- успешное выполнение
   return(true);
  }
//---
//+------------------------------------------------------------------+
