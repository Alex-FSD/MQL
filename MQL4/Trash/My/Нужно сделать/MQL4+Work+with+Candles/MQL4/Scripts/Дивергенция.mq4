//+------------------------------------------------------------------+
//|                                                  Дивергенция.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#property script_show_inputs

input int  RSIPeriod             = 9;     // Период RSI
input bool ShowFracrals          = false; // Показывать фракталы
input bool ShowHiddenDivergence  = false; // Показывать "скрытую" дивергенцию


#define PREFIX  "OBJ_DIV_"

struct fractal
  {
   datetime          time;      // время открытия бара, на котором был сформирован фрактал
   double            peak;      // максимум или минимум бара в зависимости от типа фрактала
   double            indicator; // значение индикатора RSI на баре
  } FractalsUp[], FractalsDown[];

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   DeleteObjects(PREFIX);
// установим нулевой размер у массивов фракталов
   ArrayResize(FractalsUp,0);
   ArrayResize(FractalsDown,0);
// определим направление индексации в массивах фракталов как в таймсериях(справо налево)
   ArraySetAsSeries(FractalsUp,true);
   ArraySetAsSeries(FractalsDown,true);

   ShowFractalsAndFillArrays();
   ShowDivergence();
  }
//+------------------------------------------------------------------+
//| Находит на истории все фракталы и заполняет соответствующие      |
//| массивы фракталов.                                               |
//| В зависимости от параметра ShowFracrals отображает найденные     |
//| фракталы на графике                                              |
//+------------------------------------------------------------------+
void ShowFractalsAndFillArrays()
  {
// пропускаем по два бара в конце и в начале таймсерии
   int to=Bars-2;
   for(int i=2; i<to; i++)
     {
      string Name;// имя объекта
      bool IsUp, IsDown;
      double rsi;

      // получаем тип фрактала, если он сформирован на данном баре
      GetFractalType(i,IsUp,IsDown);

      // сформирован фрактал вверх
      if(IsUp)
        {
         rsi=iRSI(_Symbol,_Period,RSIPeriod,PRICE_CLOSE,i);
         // также есть максимум на RSI
         if(iRSI(_Symbol,_Period,RSIPeriod,PRICE_CLOSE,i+1)<rsi && iRSI(_Symbol,_Period,RSIPeriod,PRICE_CLOSE,i-1)<rsi)
           {
            // добавляем данные о фрактале в массив
            int ind=AddFractalToArray(FractalsUp,iTime(_Symbol,_Period,i),iHigh(_Symbol,_Period,i),rsi);

            // рисуем над High свечи синюю точку
            if(ShowFracrals)
              {
               Name=PREFIX+_Symbol+"_FRCTL_UP_"+IntegerToString(FractalsUp[ind].time);
               ArrowCreate(0,Name,0,FractalsUp[ind].time,FractalsUp[ind].peak,159,ANCHOR_BOTTOM,clrBlue,STYLE_SOLID,2,true,false);
              }
           }
        }
      // сформирован фрактал вниз
      if(IsDown)
        {
         rsi=iRSI(_Symbol,_Period,RSIPeriod,PRICE_CLOSE,i);
         // также есть минимум на RSI
         if(iRSI(_Symbol,_Period,RSIPeriod,PRICE_CLOSE,i+1)>rsi && iRSI(_Symbol,_Period,RSIPeriod,PRICE_CLOSE,i-1)>rsi)
           {
            // добавляем данные о фрактале в массив
            int ind=AddFractalToArray(FractalsDown,iTime(_Symbol,_Period,i),iLow(_Symbol,_Period,i),rsi);

            // рисуем под Low свечи красную точку
            if(ShowFracrals)
              {
               Name=PREFIX+_Symbol+"_FRCTL_DOWN_"+IntegerToString(FractalsDown[ind].time);
               ArrowCreate(0,Name,0,FractalsDown[ind].time,FractalsDown[ind].peak,159,ANCHOR_TOP,clrRed,STYLE_SOLID,2,true,false);
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Ищет и размечает трендовыми линиями дивергенции на               |
//| графике цены и осцилляторе RSI                                   |
//+------------------------------------------------------------------+
void ShowDivergence()
  {
   int size;
   string Name=PREFIX+_Symbol+"TLINE_";

// ----------- рисуем линии медвежьей дивергенции по локальным максимумам
   size=ArraySize(FractalsUp);
   for(int i=0; i<size-1; i++)
     {
      int Style=EMPTY;

      // медвежья дивергенция – цена вверх, RSI вниз
      if(FractalsUp[i].peak>FractalsUp[i+1].peak && FractalsUp[i].indicator<FractalsUp[i+1].indicator)
         Style=STYLE_SOLID;
      else
         // скрытая медвежья дивергенция (конвергенция) – цена вниз, RSI вверх
         if(ShowHiddenDivergence && FractalsUp[i].peak<FractalsUp[i+1].peak && FractalsUp[i].indicator>FractalsUp[i+1].indicator)
            Style=STYLE_DOT;

      if(Style>EMPTY)
        {
         TrendCreate(0,Name+"BEAR_BAR_"+IntegerToString(FractalsUp[i].time),0,FractalsUp[i+1].time,
                     FractalsUp[i+1].peak,FractalsUp[i].time,FractalsUp[i].peak,clrMaroon,ENUM_LINE_STYLE(Style));

         TrendCreate(0,Name+"BEAR_RSI_"+IntegerToString(FractalsUp[i].time),1,FractalsUp[i+1].time,
                     FractalsUp[i+1].indicator,FractalsUp[i].time,FractalsUp[i].indicator,clrMaroon,ENUM_LINE_STYLE(Style));
        }

     }

// ----------- рисуем линии бычьей дивергенции по локальным минимумам
   size=ArraySize(FractalsDown);
   for(int i=0; i<size-1; i++)
     {
      int Style=EMPTY;

      // бычья дивергенция – цена вниз, RSI вверх
      if(FractalsDown[i].peak<FractalsDown[i+1].peak && FractalsDown[i].indicator>FractalsDown[i+1].indicator)
         Style=STYLE_SOLID;
      else
         // скрытая бычья дивергенция (конвергенция) – цена вверх, RSI вниз
         if(ShowHiddenDivergence && FractalsDown[i].peak>FractalsDown[i+1].peak && FractalsDown[i].indicator<FractalsDown[i+1].indicator)
            Style=STYLE_DOT;


      if(Style>EMPTY)
        {
         TrendCreate(0,Name+"BULL_BAR_"+IntegerToString(FractalsDown[i].time),0,FractalsDown[i+1].time,
                     FractalsDown[i+1].peak,FractalsDown[i].time,FractalsDown[i].peak,clrGreen,ENUM_LINE_STYLE(Style));

         TrendCreate(0,Name+"BULL_RSI_"+IntegerToString(FractalsDown[i].time),1,FractalsDown[i+1].time,
                     FractalsDown[i+1].indicator,FractalsDown[i].time,FractalsDown[i].indicator,clrGreen,ENUM_LINE_STYLE(Style));
        }
     }

  }
//+------------------------------------------------------------------+
//| Добавляет в массив фракталов arr[] новый элемент и заполняет     |
//| структуру переданными значениями                                 |
//| Возвращает индекс последнего добавленного элемента или -1(EMPTY),|
//| если произошла ошибк и не удалось увеличить размер массива       |
//+------------------------------------------------------------------+
int AddFractalToArray(fractal &arr[], datetime time, double peak, double indicator)
  {
   int size=ArraySize(arr);
   if(ArrayResize(arr,size+1,1000)>0)
     {
      arr[size].time=time;
      arr[size].peak=peak;
      arr[size].indicator=indicator;
      return(size);
     }
   return(EMPTY);
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
                 const bool              selection=false,      // выделить для перемещений
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
                 const bool            back=false,        // на заднем плане
                 const bool            selection=false,   // выделить для перемещений
                 const bool            ray_right=false,   // продолжение линии вправо
                 const bool            hidden=true,       // скрыт в списке объектов
                 const long            z_order=0)         // приоритет на нажатие мышью
  {
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
//+------------------------------------------------------------------+
