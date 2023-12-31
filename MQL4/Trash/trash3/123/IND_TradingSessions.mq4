//+-----------------------------------------------------------------------------------------------+
//| Developer:   Andrey Minaev                                                                    |
//| Indicator:   IND_TradingSessions.mq4                                                          |
//| MQL5:        mql5.com/ru/users/id.scorpion                                                    |
//| Mail:        id.scorpion@mail.ru                                                              |
//| Skype:       id.scorpion                                                                      |
//+-----------------------------------------------------------------------------------------------+
#property copyright "Developer: Andrey Minaev"
#property link      "http://www.mql5.com/ru/users/id.scorpion"
#property version   "1.00"
#property strict
#property indicator_chart_window

enum YESNO
{
   YES,   // Да
   NO,    // Нет
};

input int   diffInHours          = -2;             // Разница во времени GMT и серверного времени брокера (часы)
input YESNO showAsianSession     = YES;            // Показывать азиаткую сессию
input color colorAsianSession    = clrKhaki;       // Цвет азиатской сессии
input YESNO showEuropeanSession  = YES;            // Показывать европейскую сессию
input color colorEuropeanSession = clrLightBlue;   // Цвет европейской сессии
input YESNO showAmericanSession  = YES;            // Показывать американскую сессию
input color colorAmericanSession = clrPink;        // Цвет американской сессии
input YESNO showPacificSession   = YES;            // Показывать тихоокеанскую сессию
input color colorPacificSession  = clrLightGray;   // Цвет тихоокеанской сессии

datetime newCandle;   // новая свеча
long chartID;         // идентификатор графика
int  dayOfWeek;       // день недели

//--- азиатская сессия
bool     remTimeAsS;    // true - разрешено запомнить новые даты сессии
datetime begTimeAsS;    // время начала сессии
datetime endTimeAsS;    // время конца сессии
int      begHourAsS;    // час начала сессии
int      endHourAsS;    // час конца сессии
double   maxPriceAsS;   // максимальная цена за сессию
double   minPriceAsS;   // минимальная цена за сессию
bool     oneDayAsS;     // true -  сессия находится в пределах одного дня

//--- европейская сессия
bool     remTimeEuS;    // true - разрешено запомнить новые даты сессии
datetime begTimeEuS;    // время начала сессии
datetime endTimeEuS;    // время конца сессии
int      begHourEuS;    // час начала сессии
int      endHourEuS;    // час конца сессии
double   maxPriceEuS;   // максимальная цена за сессию
double   minPriceEuS;   // минимальная цена за сессию
bool     oneDayEuS;     // true -  сессия находится в пределах одного дня

//--- американская сессия
bool     remTimeAmS;    // true - разрешено запомнить новые даты сессии
datetime begTimeAmS;    // время начала сессии
datetime endTimeAmS;    // время конца сессии
int      begHourAmS;    // час начала сессии
int      endHourAmS;    // час конца сессии
double   maxPriceAmS;   // максимальная цена за сессию
double   minPriceAmS;   // минимальная цена за сессию
bool     oneDayAmS;     // true -  сессия находится в пределах одного дня

//--- тихоокеанская сессия
bool     remTimePaS;    // true - разрешено запомнить новые даты сессии
datetime begTimePaS;    // время начала сессии
datetime endTimePaS;    // время конца сессии
int      begHourPaS;    // час начала сессии
int      endHourPaS;    // час конца сессии
double   maxPricePaS;   // максимальная цена за сессию
double   minPricePaS;   // минимальная цена за сессию
bool     oneDayPaS;     // true -  сессия находится в пределах одного дня

//+-----------------------------------------------------------------------------------------------+
int OnInit(void)
{
   //--- проверим разницу во времени
   bool within = false;
   for(int i = -12; i <= 12; i++) if(i == diffInHours) within = true;
   if(!within)
   {
      Alert("Разница во времени GMT и серверного времени брокера не должна быть за пределами -12 ... 12");
      return INIT_FAILED;
   }
   if(Period() > PERIOD_H1)
   {
      Alert("Для визуального отображения торговых сессий, таймфрем должен быть не больше 1 часа");
      return INIT_FAILED;
   }       
   chartID = ChartID();
   
   remTimeAsS = remTimeEuS = remTimeAmS = remTimePaS = true;
   minPriceAsS = minPriceEuS = minPriceAmS = minPricePaS = 999999999;
   
   begHourAsS  = 23+diffInHours;
   endHourAsS  = 09+diffInHours;
   
   if(begHourAsS > 23) begHourAsS = begHourAsS-24;
   if(endHourAsS < 0)  endHourAsS = 24+endHourAsS;
   
   if(begHourAsS < endHourAsS) oneDayAsS = true;
   
   begHourEuS  = 06+diffInHours;
   endHourEuS  = 16+diffInHours;
   
   if(begHourEuS < 0)  begHourEuS = 24+begHourEuS;
   if(endHourEuS > 23) endHourEuS = endHourEuS-24;
   
   if(begHourEuS < endHourEuS) oneDayEuS = true;
   
   begHourAmS  = 13+diffInHours;
   endHourAmS  = 23+diffInHours;
   
   if(begHourAmS > 23) begHourAmS = begHourAmS-24;
   if(endHourAmS > 23) endHourAmS = endHourAmS-24;
   
   if(begHourAmS < endHourAmS) oneDayAmS = true;
   
   begHourPaS  = 20+diffInHours;
   endHourPaS  = 07+diffInHours;
   
   if(begHourPaS > 23) begHourPaS = begHourPaS-24;
   if(endHourPaS < 0)  endHourPaS = 24+endHourPaS;
   
   if(endHourPaS < endHourPaS) endHourPaS = true;
   
   return INIT_SUCCEEDED;
}
//+-----------------------------------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   ObjectsDeleteAll(chartID);
}
//+-----------------------------------------------------------------------------------------------+
int OnCalculate(const int      rates_total,
                const int      prev_calculated,
                const datetime &time[],
                const double   &open[],
                const double   &high[],
                const double   &low[],
                const double   &close[],
                const long     &tick_volume[],
                const long     &volume[],
                const int      &spread[])
{
   if(prev_calculated == 0)
      for(int i = Bars-1; i > 0; i--)
      {
         string begDay = TimeToString(time[i], TIME_DATE);
         dayOfWeek = TimeDayOfWeek(StrToTime(begDay));
         
         if(showAsianSession    == YES) TradingSession("AsianSession ",    time[i], begDay, remTimeAsS, begTimeAsS, endTimeAsS, begHourAsS, endHourAsS, high[i], low[i], maxPriceAsS, minPriceAsS, oneDayAsS, colorAsianSession);
         if(showEuropeanSession == YES) TradingSession("EuropeanSession ", time[i], begDay, remTimeEuS, begTimeEuS, endTimeEuS, begHourEuS, endHourEuS, high[i], low[i], maxPriceEuS, minPriceEuS, oneDayEuS, colorEuropeanSession);
         if(showAmericanSession == YES) TradingSession("AmericanSession ", time[i], begDay, remTimeAmS, begTimeAmS, endTimeAmS, begHourAmS, endHourAmS, high[i], low[i], maxPriceAmS, minPriceAmS, oneDayAmS, colorAmericanSession);
         if(showPacificSession  == YES) TradingSession("PacificSession ",  time[i], begDay, remTimePaS, begTimePaS, endTimePaS, begHourPaS, endHourPaS, high[i], low[i], maxPricePaS, minPricePaS, oneDayPaS, colorPacificSession);
      }
   if(prev_calculated > 0)
   {
      //--- работаем на новой свече
      if(newCandle == time[0]) return 0;
      newCandle = time[0];
      
      string begDay = TimeToString(TimeCurrent(), TIME_DATE);
      
         if(showAsianSession    == YES) TradingSession("AsianSession ",    TimeCurrent(), begDay, remTimeAsS, begTimeAsS, endTimeAsS, begHourAsS, endHourAsS, high[1], low[1], maxPriceAsS, minPriceAsS, oneDayAsS, colorAsianSession);
         if(showEuropeanSession == YES) TradingSession("EuropeanSession ", TimeCurrent(), begDay, remTimeEuS, begTimeEuS, endTimeEuS, begHourEuS, endHourEuS, high[1], low[1], maxPriceEuS, minPriceEuS, oneDayEuS, colorEuropeanSession);
         if(showAmericanSession == YES) TradingSession("AmericanSession ", TimeCurrent(), begDay, remTimeAmS, begTimeAmS, endTimeAmS, begHourAmS, endHourAmS, high[1], low[1], maxPriceAmS, minPriceAmS, oneDayAmS, colorAmericanSession);
         if(showPacificSession  == YES) TradingSession("PacificSession ",  TimeCurrent(), begDay, remTimePaS, begTimePaS, endTimePaS, begHourPaS, endHourPaS, high[1], low[1], maxPricePaS, minPricePaS, oneDayPaS, colorPacificSession);
   }
   return rates_total;
}
//+-----------------------------------------------------------------------------------------------+
//| Функция расчета торговой сессии                                                               |
//+-----------------------------------------------------------------------------------------------+
void TradingSession(string name, datetime time, string begDay, bool &remTime, datetime &begTime, datetime &endTime, 
                     int begHour, int endHour, double high, double low, double &maxPrice, double &minPrice, bool oneDay, color clr)
{
   //--- торговая сессия находится в пределах одного дня
   if(oneDay && remTime)
   {
      begTime = StringToTime(begDay+" "+(string)begHour+":00");
      endTime = StringToTime(begDay+" "+(string)endHour+":00");
      remTime = false;
   }
   //--- торговая сессия находится за пределами одного дня
   if(!oneDay)
   {
      if(remTime && dayOfWeek != 5)
      {
         begTime = StringToTime(begDay+" "+(string)begHour+":00");
         endTime = StringToTime(begDay+" "+(string)endHour+":00")+86400;
         remTime = false;
      }
      if(remTime && dayOfWeek == 5)
      {
         begTime = StringToTime(begDay+" "+(string)begHour+":00");
         endTime = StringToTime(begDay+" "+(string)endHour+":00")+86400*3;
         remTime = false;
      }
   }
   //--- создадим фон торговой сессии
   if(begTime <= time && endTime >= time)
   {
      if(maxPrice < high) maxPrice = high;
      if(minPrice > low)  minPrice = low;
      CreateBGSession(name+TimeToString(begTime), begTime, maxPrice, endTime, minPrice, clr);
   }
   //--- обнулим значения по окончанию торговой сессии
   if(endTime < time)
   {
      remTime  = true;
      maxPrice = 0;
      minPrice = 999999999;
   }
}
//+-----------------------------------------------------------------------------------------------+
//| Функция создает фон для торговой cессии                                                       |
//+-----------------------------------------------------------------------------------------------+
void CreateBGSession(string name, datetime time1, double price1, datetime time2, double price2, color clr)
{
   ObjectDelete(chartID, name);
   
   ObjectCreate    (chartID, name, OBJ_RECTANGLE, 0, time1, price1, time2, price2);
   ObjectSetInteger(chartID, name, OBJPROP_COLOR, clr);
   ObjectSetInteger(chartID, name, OBJPROP_BACK, true);
   ObjectSetInteger(chartID, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(chartID, name, OBJPROP_SELECTED, false);
   ObjectSetInteger(chartID, name, OBJPROP_HIDDEN, true);
}
//+-----------------------------------------------------------------------------------------------+