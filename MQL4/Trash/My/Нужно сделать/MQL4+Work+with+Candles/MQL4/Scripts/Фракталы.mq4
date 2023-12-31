//+------------------------------------------------------------------+
//|                                                     Фракталы.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   DeleteObjects("FRCTL");
   ShowFractals();
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ShowFractals()
  {
   for(int i=Bars-2; i>1; i--)
     {
      string Name;// имя объекта
      bool IsUp, IsDown;

      // получаем тип фрактала, если он сформирован на данном баре
      GetFractalType(i,IsUp,IsDown);

      // сформирован фрактал вверх
      if(IsUp)
        {
         Name="FRCTL_UP_"+_Symbol+"_"+IntegerToString(iTime(_Symbol,_Period,i));
         // рисуем над High свечи синюю точку
         ArrowCreate(0,Name,0,iTime(_Symbol,_Period,i),iHigh(_Symbol,_Period,i),159,ANCHOR_BOTTOM,clrBlue,STYLE_SOLID,2,true,false);
        }
      // сформирован фрактал вниз
      if(IsDown)
        {
         Name="FRCTL_DOWN_"+_Symbol+"_"+IntegerToString(iTime(_Symbol,_Period,i));
         // рисуем под Low свечи красную точку
         ArrowCreate(0,Name,0,iTime(_Symbol,_Period,i),iLow(_Symbol,_Period,i),159,ANCHOR_TOP,clrRed,STYLE_SOLID,2,true,false);
        }

     }
  }
//+------------------------------------------------------------------+
//| Удаляет графические объекты с префиксом prfx                     |
//+------------------------------------------------------------------+
void DeleteObjects(string prfx)
  {
   for(int i=ObjectsTotal()-1; i>=0; i--)
     {
      string nm=ObjectName(0,i);
      if(StringSubstr(nm,0,StringLen(prfx))==prfx)
         ObjectDelete(0,nm);
     }
  }
//+------------------------------------------------------------------+
//| Проверяет, сформирован ли на баре с индексом index               |
//| фрактал                                                          |
//|                                                                  |
//| is_up - эта переменная принимает значение true, если сфорирован  |
//| фрактактал вверх                                                 |
//| is_down - эта переменная принимает значение true, если сфорирован|
//| фрактактал вниз                                                  |
//| Если фрактал не сформирован, то обеим переменным                 |
//| присваивается значение false                                     |
//+------------------------------------------------------------------+
void GetFractalType(int index, bool &is_up, bool &is_down)
  {
// сбрасывам значения переменных
   is_up=is_down=false;

// проверяем, выше ли High (максимум) центральной свечи двух предыдущих и двух последующих
   is_up=(iHigh(_Symbol,_Period,index+1)<iHigh(_Symbol,_Period,index) &&
          iHigh(_Symbol,_Period,index+2)<iHigh(_Symbol,_Period,index) &&
          iHigh(_Symbol,_Period,index-1)<iHigh(_Symbol,_Period,index) &&
          iHigh(_Symbol,_Period,index-2)<iHigh(_Symbol,_Period,index));

// проверяем, ниже ли Low (минимум) центральной свечи двух предыдущих и двух последующих
   is_down=(iLow(_Symbol,_Period,index+1)>iLow(_Symbol,_Period,index) &&
            iLow(_Symbol,_Period,index+2)>iLow(_Symbol,_Period,index) &&
            iLow(_Symbol,_Period,index-1)>iLow(_Symbol,_Period,index) &&
            iLow(_Symbol,_Period,index-2)>iLow(_Symbol,_Period,index));
  }

//+------------------------------------------------------------------+
//| Создает стрелку                                                  |
//+------------------------------------------------------------------+
bool ArrowCreate(const long              chart_ID=0,           // ID графика
                 const string            name="Arrow",         // имя стрелки
                 const int               sub_window=0,         // номер подокна
                 datetime                time=0,               // время точки привязки
                 double                  price=0,              // цена точки привязки
                 const uchar             arrow_code=252,       // код стрелки
                 const ENUM_ARROW_ANCHOR anchor=ANCHOR_BOTTOM, // положение точки привязки
                 const color             clr=clrRed,           // цвет стрелки
                 const ENUM_LINE_STYLE   style=STYLE_SOLID,    // стиль окаймляющей линии
                 const int               width=3,              // размер стрелки
                 const bool              back=false,           // на заднем плане
                 const bool              selection=true,       // выделить для перемещений
                 const bool              hidden=true,          // скрыт в списке объектов
                 const long              z_order=0)            // приоритет на нажатие мышью
  {
//--- сбросим значение ошибки
   ResetLastError();
//--- создадим стрелку
   if(!ObjectCreate(chart_ID,name,OBJ_ARROW,sub_window,time,price))
     {
      Print(__FUNCTION__,
            ": не удалось создать стрелку! Код ошибки = ",GetLastError());
      return(false);
     }
//--- установим код стрелки
   ObjectSetInteger(chart_ID,name,OBJPROP_ARROWCODE,arrow_code);
//--- установим способ привязки
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
//--- установим цвет стрелки
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- установим стиль окаймляющей линии
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- установим размер стрелки
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- отобразим на переднем (false) или заднем (true) плане
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- включим (true) или отключим (false) режим перемещения стрелки мышью
//--- при создании графического объекта функцией ObjectCreate, по умолчанию объект
//--- нельзя выделить и перемещать. Внутри же этого метода параметр selection
//--- по умолчанию равен true, что позволяет выделять и перемещать этот объект
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- скроем (true) или отобразим (false) имя графического объекта в списке объектов
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- установим приоритет на получение события нажатия мыши на графике
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- успешное выполнение
   return(true);
  }
//+------------------------------------------------------------------+
