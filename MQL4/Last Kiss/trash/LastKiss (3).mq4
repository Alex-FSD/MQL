//+------------------------------------------------------------------+
//|                                                     LastKiss.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property description "Last Kiss"
#property description ""
#property description "Советник работающий по торговой стратегии 'Last Kiss', уровням Фибоначчи."
#property description "Все настройки советника находятся на вкладке 'Входные параметры'"

#property strict

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input int MethodFibo_input = 1; //Метод построения Фибоначчи (1 = High/Low, 2 = Close)
input string DelimiterLine0 = "======================================================================================================================================================";//==================================================

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input int BuyRight_input = 1; //Вкл/Выкл робота правый ЛК на покупку (1 = Вкл, 0 = Выкл)
input int BuyLeft_input = 1; //Вкл/Выкл робота левый ЛК на покупку (1 = Вкл, 0 = Выкл)
input int SellRight_input = 1; //Вкл/Выкл робота правый ЛК на продажу (1 = Вкл, 0 = Выкл)
input int SellLeft_input = 1; //Вкл/Выкл робота левый ЛК на продажу (1 = Вкл, 0 = Выкл)
input int BuyCic_input = 1; //Вкл/Выкл робота Свеча в свече на покупку (1 = Вкл, 0 = Выкл)
input int SellCic_input = 1; //Вкл/Выкл робота Свеча в свече на продажу (1 = Вкл, 0 = Выкл)
input string DelimiterLine1 = "======================================================================================================================================================";//==================================================

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input double BR_TP1_input = 2.61; //Тейкпрофит для правого ЛК в покупку(2.00 2.61 4.23)
input double BR_TP2_input = 4.23; //Тейк, при пробитии 161 уровня (4.23 6.85 11.09)
input double BR_TP3_input = 6.85; //Тейк, при пробитии 261 уровня (6.85 11.09)
input double BR_TP4_input = 11.09; //Тейк, при пробитии 423 уровня (11.09)
input double BR_SL_input = 0.61; //Стоп лосс для правого ЛК в покупку  (0.00 0.14 0.5 0.61)
input string DelimiterLine2 = "======================================================================================================================================================";//==================================================

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input double BL_TP1_input = 2.61; //Тейкпрофит для левого ЛК в покупку (2.00 2.61 4.23)
input double BL_TP2_input = 4.23; //Тейк, при пробитии 161 уровня (4.23 6.85 11.09)
input double BL_TP3_input = 6.85; //Тейк, при пробитии 261 уровня (6.85 11.09)
input double BL_TP4_input = 11.09; //Тейк, при пробитии 423 уровня (11.09)
input double BL_SL_input = 0.61; //Стоп лосс для левого ЛК в покупку (0.00 0.14 0.5 0.61)
input string DelimiterLine3 = "======================================================================================================================================================";//==================================================

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input double SR_TP1_input = 2.61; //Тейкпрофит для правого ЛК в продажу (2.00 2.61 4.23)
input double SR_TP2_input = 4.23; //Тейк, при пробитии 161 уровня (4.23 6.85 11.09)
input double SR_TP3_input = 6.85; //Тейк, при пробитии 261 уровня (6.85 11.09)
input double SR_TP4_input = 11.09; //Тейк, при пробитии 423 уровня (11.09)
input double SR_SL_input = 0.61; //Стоп лосс для правого ЛК в продажу (0.00 0.14 0.5 0.61)
input string DelimiterLine4 = "======================================================================================================================================================";//==================================================

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input double SL_TP1_input = 2.61; //Тейкпрофит для левого ЛК в продажу (2.00 2.61 4.23)
input double SL_TP2_input = 4.23; //Тейк, при пробитии 161 уровня (4.23 6.85 11.09)
input double SL_TP3_input = 6.85; //Тейк, при пробитии 261 уровня (6.85 11.09)
input double SL_TP4_input = 11.09; //Тейк, при пробитии 423 уровня (11.09)
input double SL_SL_input = 0.61; //Стоп лосс для левого ЛК в продажу (0.00 0.14 0.5 0.61)
input string DelimiterLine5 = "======================================================================================================================================================";//==================================================

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input double BCic_TP1_input = 2.61; //Тейкпрофит для Свеча в свече в покупку (2.00 2.61 4.23)
input double BCic_TP2_input = 4.23; //Тейк, при пробитии 161 уровня (4.23 6.85 11.09)
input double BCic_TP3_input = 6.85; //Тейк, при пробитии 261 уровня (6.85 11.09)
input double BCic_TP4_input = 11.09; //Тейк, при пробитии 423 уровня (11.09)
input double BCic_SL_input = 0.61; //Стоп лосс для Свеча в свече в покупку (0.00 0.14 0.5 0.61)
input string DelimiterLine6 = "======================================================================================================================================================";//==================================================

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input double SCic_TP1_input = 2.61; //Тейкпрофит для Свеча в свече в продажу (2.00 2.61 4.23)
input double SCic_TP2_input = 4.23; //Тейк, при пробитии 161 уровня (4.23 6.85 11.09)
input double SCic_TP3_input = 6.85; //Тейк, при пробитии 261 уровня (6.85 11.09)
input double SCic_TP4_input = 11.09; //Тейк, при пробитии 423 уровня (11.09)
input double SCic_SL_input = 0.61; //Стоп лосс для Свеча в свече в продажу (0.00 0.14 0.5 0.61)
input string DelimiterLine7 = "======================================================================================================================================================";//==================================================

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input int ChangeStopLoss = 1; //Изменять стоплосс при достижении уровня (1 = Вкл, 0 = Выкл)
input double ChangeStopLoss_Level = 2.50; //Уровень для переноса стоп-лосса
input double ChangeStopLoss_Level2 = 1.10; //На какой уровень переносить Стоп
input string DelimiterLine8 = "======================================================================================================================================================";//==================================================

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input int DynamicLots_input = 1; //Использовать динамичный лот (1 = Вкл, 0 = Выкл)
input double EarlyLots_input = 0.01; //Начальный лот. Далее лот увеличивается каждый "Шаг"
input double IncLots_input = 0.01; //На сколько увеличивать лот, при увеличение депозита
input int DepoForInc_input = 750; //Шаг депозита при котором будет увеличиваться лот
input double FixLots_input = 0.01; //Если динамичный лот выкл, какой лот использовать
input string DelimiterLine9 = "======================================================================================================================================================";//==================================================

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input int BR_Safe_input = 0; //Метод сейфа для 1 Робота (0 = Нет, 1 = Да, 2 = Да х2 Лотом)
input int BL_Safe_input = 0; //Метод сейфа для 2 Робота (0 = Нет, 1 = Да, 2 = Да х2 Лотом)
input int SR_Safe_input = 0; //Метод сейфа для 3 Робота (0 = Нет, 1 = Да, 2 = Да х2 Лотом)
input int SL_Safe_input = 0; //Метод сейфа для 4 Робота (0 = Нет, 1 = Да, 2 = Да х2 Лотом)
input int BCic_Safe_input = 0; //Метод сейфа для 5 Робота (0 = Нет, 1 = Да, 2 = Да х2 Лотом)
input int SCic_Safe_input = 0; //Метод сейфа для 6 Робота (0 = Нет, 1 = Да, 2 = Да х2 Лотом)
input double BR_SafeTP_input = 2.00; //Тейкпрофит для сейфа 1 (1.61 2.00 2.61)
input double BL_SafeTP_input = 2.00; //Тейкпрофит для сейфа 2 (1.61 2.00 2.61)
input double SR_SafeTP_input = 2.00; //Тейкпрофит для сейфа 3 (1.61 2.00 2.61)
input double SL_SafeTP_input = 2.00; //Тейкпрофит для сейфа 4 (1.61 2.00 2.61)
input double BCic_SafeTP_input = 2.00; //Тейкпрофит для сейфа 5 (1.61 2.00 2.61)
input double SCic_SafeTP_input = 2.00; //Тейкпрофит для сейфа 6 (1.61 2.00 2.61)
input double BR_SafeSL_input = 0.618; //Стоп лосс для сейфа 1 (0.00 0.14 0.5 0.618)
input double BL_SafeSL_input = 0.618; //Стоп лосс для сейфа 2 (0.00 0.14 0.5 0.618)
input double SR_SafeSL_input = 0.618; //Стоп лосс для сейфа 3 (0.00 0.14 0.5 0.618)
input double SL_SafeSL_input = 0.618; //Стоп лосс для сейфа 4 (0.00 0.14 0.5 0.618)
input double BCic_SafeSL_input = 0.618; //Стоп лосс для сейфа 5 (0.00 0.14 0.5 0.618)
input double SCic_SafeSL_input = 0.618; //Стоп лосс для сейфа 6 (0.00 0.14 0.5 0.618)
input string DelimiterLine10 = "======================================================================================================================================================";//==================================================

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input int MovingBuy_input = 0; //Использовать мувинг на покупку (0 = Нет, 1 = Да)
input int MovingSell_input = 0; //Использовать мувинг на продажу (0 = Нет, 1 = Да)
input int MovingPeriod_input = 0; //Период мувинга
input int MovingShift_input = 0; //Сдвиг мувинга
input ENUM_MA_METHOD MovingMethod_input = MODE_SMMA; //Метод мувинга
input ENUM_APPLIED_PRICE MovingAppPrice_input = PRICE_CLOSE; //Применять мувинг к ...
input string DelimiterLine11 = "======================================================================================================================================================";//==================================================

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input int RiskManagment_input = 0; //Закрытие убыточных сделок (1 = Вкл, 0 = Выкл)
input double RiskManagmentPercent_input = 0.2; //Допустимый убыток сделки, % от депозита (0.2 = 20%)
input string DelimiterLine12 = "======================================================================================================================================================";//==================================================

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input int ChartColors_input = 1; //Изменить цветовую схему графика? (1 = Вкл, 0 = Выкл)
input string DelimiterLine13 = "======================================================================================================================================================";//==================================================

input int BR_MagicNumber = 28012021; //Отличительное число 1 робота
input int BRS_MagicNumber = 04022021; //Отличительное число 1 робота с "сейфом"
input int BL_MagicNumber = 29012021; //Отличительное число 2 робота
input int BLS_MagicNumber = 05022021; //Отличительное число 2 робота с "сейфом"
input int SR_MagicNumber = 30012021; //Отличительное число 3 робота
input int SRS_MagicNumber = 06022021; //Отличительное число 3 робота с "сейфом"
input int SL_MagicNumber = 31012021; //Отличительное число 4 робота
input int SLS_MagicNumber = 07022021; //Отличительное число 4 робота с "сейфом"
input int BCic_MagicNumber = 01022021; //Отличительное число 5 робота
input int BCicS_MagicNumber = 08022021; //Отличительное число 5 робота с "сейфом"
input int SCic_MagicNumber = 02022021; //Отличительное число 6 робота
input int SCicS_MagicNumber = 09022021; //Отличительное число 6 робота с "сейфом"

bool res;

int CountTrades = 0;

double Lots = 0.01;

datetime BR_Time1 = 0;
datetime BR_Time2 = 0;
double BR_Low0 = 0.00;
double BR_High100 = 0.00;
double BR_TP = 0.00;
double BR_SL = 0.00;
double BR_CountPips = 0.00;
double BR_Level161 = 0.00;
double BR_Level261 = 0.00;
double BR_Level423 = 0.00;

datetime BCic_Time1 = 0;
datetime BCic_Time2 = 0;
double BCic_Low0 = 0.00;
double BCic_High100 = 0.00;
double BCic_TP = 0.00;
double BCic_SL = 0.00;
double BCic_CountPips = 0.00;
double BCic_Level161 = 0.00;
double BCic_Level261 = 0.00;
double BCic_Level423 = 0.00;

datetime SCic_Time1 = 0;
datetime SCic_Time2 = 0;
double SCic_Low100 = 0.00;
double SCic_High0 = 0.00;
double SCic_TP = 0.00;
double SCic_SL = 0.00;
double SCic_CountPips = 0.00;
double SCic_Level161 = 0.00;
double SCic_Level261 = 0.00;
double SCic_Level423 = 0.00;

datetime BL_Time1 = 0;
datetime BL_Time2 = 0;
double BL_Low0 = 0;
double BL_High100 = 0;
double BL_TP = 0;
double BL_SL = 0;
double BL_CountPips = 0.00;
double BL_Level161 = 0.00;
double BL_Level261 = 0.00;
double BL_Level423 = 0.00;

datetime SL_Time1 = 0;
datetime SL_Time2 = 0;
double SL_Low100 = 0;
double SL_High0 = 0;
double SL_TP = 0;
double SL_SL = 0;
double SL_CountPips = 0.00;
double SL_Level161 = 0.00;
double SL_Level261 = 0.00;
double SL_Level423 = 0.00;

datetime SR_Time1 = 0;
datetime SR_Time2 = 0;
double SR_Low100 = 0;
double SR_High0 = 0;
double SR_TP = 0;
double SR_SL = 0;
double SR_CountPips = 0.00;
double SR_Level161 = 0.00;
double SR_Level261 = 0.00;
double SR_Level423 = 0.00;

double AC_Buy_CountPips = 0.00;
double AC_Buy_Level = 0.00;
double AC_Buy_Level2 = 0.00;

int AC_BR_IndexOpenBars = 0;
double AC_BR_TP = 0.00;
double AC_BR_Level = 0.00;
double AC_BR_Level1 = 0.00;
double AC_BR_Level2 = 0.00;
double AC_BR_Level3 = 0.00;
double AC_BR_Level4 = 0.00;
double AC_BR_Level5 = 0.00;

int AC_BL_IndexOpenBars = 0;
double AC_BL_TP = 0.00;
double AC_BL_Level = 0.00;
double AC_BL_Level1 = 0.00;
double AC_BL_Level2 = 0.00;
double AC_BL_Level3 = 0.00;
double AC_BL_Level4 = 0.00;
double AC_BL_Level5 = 0.00;

int AC_BCic_IndexOpenBars = 0;
double AC_BCic_TP = 0.00;
double AC_BCic_Level = 0.00;
double AC_BCic_Level1 = 0.00;
double AC_BCic_Level2 = 0.00;
double AC_BCic_Level3 = 0.00;
double AC_BCic_Level4 = 0.00;
double AC_BCic_Level5 = 0.00;

double AC_Sell_CountPips = 0.00;
double AC_Sell_Level = 0.00;
double AC_Sell_Level2 = 0.00;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CalculateLots()
  {
   if(DynamicLots_input == 1)
     {
      if(AccountBalance() <= DepoForInc_input)
        {
         Lots = EarlyLots_input;
        }
      else
        {
         Lots = AccountBalance() / DepoForInc_input * IncLots_input;
        }
     }
   else
     {
      Lots = FixLots_input;
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RiskManagment()
  {
   for(int i = 0; i < OrdersTotal(); i++)
     {
      if((OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true) && ((OrderMagicNumber() == BR_MagicNumber) || (OrderMagicNumber() == BL_MagicNumber)))
         if((OrderProfit() < 0) && ((OrderProfit() * (-1))) > (AccountBalance()*RiskManagmentPercent_input))
           {
            res = OrderClose(OrderTicket(), OrderLots(), Bid, 1000, 0);
           }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CleanFibo()
  {
   if(OrderSelect(OrdersHistoryTotal() - 1, SELECT_BY_POS, MODE_HISTORY))
     {
      for(int i = OrdersHistoryTotal() - 1; i >= 0; i--)
        {
         res = OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);
         ObjectDelete(0, IntegerToString(OrderTicket()));
        }
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreateFibo(datetime time1, double point1, datetime time2, double point2)
  {
   ObjectCreate(0, IntegerToString(OrderTicket()), OBJ_FIBO, 0, time1, point1, time2, point2);
   ObjectSetInteger(0, IntegerToString(OrderTicket()), OBJPROP_LEVELCOLOR, 0, clrBlue);
   ObjectSetInteger(0, IntegerToString(OrderTicket()), OBJPROP_COLOR, clrBlue);
   ObjectSetInteger(0, IntegerToString(OrderTicket()), OBJPROP_STYLE, STYLE_SOLID);
   ObjectSetInteger(0, IntegerToString(OrderTicket()), OBJPROP_WIDTH, 1);
   ObjectSetInteger(0, IntegerToString(OrderTicket()), OBJPROP_BACK, false);
   ObjectSetInteger(0, IntegerToString(OrderTicket()), OBJPROP_SELECTABLE, true);
   ObjectSetInteger(0, IntegerToString(OrderTicket()), OBJPROP_SELECTED, true);
   ObjectSetInteger(0, IntegerToString(OrderTicket()), OBJPROP_RAY_RIGHT, true);
   ObjectSetInteger(0, IntegerToString(OrderTicket()), OBJPROP_LEVELS, 10);
   ObjectSetDouble(0, IntegerToString(OrderTicket()), OBJPROP_LEVELVALUE, 0, 0.00);
   ObjectSetString(0, IntegerToString(OrderTicket()), OBJPROP_LEVELTEXT, 0, "0.0 = %$");
   ObjectSetDouble(0, IntegerToString(OrderTicket()), OBJPROP_LEVELVALUE, 1, 0.50);
   ObjectSetString(0, IntegerToString(OrderTicket()), OBJPROP_LEVELTEXT, 1, "50.0 = %$");
   ObjectSetDouble(0, IntegerToString(OrderTicket()), OBJPROP_LEVELVALUE, 2, 0.618);
   ObjectSetString(0, IntegerToString(OrderTicket()), OBJPROP_LEVELTEXT, 2, "61.8 = %$");
   ObjectSetDouble(0, IntegerToString(OrderTicket()), OBJPROP_LEVELVALUE, 3, 1.00);
   ObjectSetString(0, IntegerToString(OrderTicket()), OBJPROP_LEVELTEXT, 3, "100.0 = %$");
   ObjectSetDouble(0, IntegerToString(OrderTicket()), OBJPROP_LEVELVALUE, 4, 1.618);
   ObjectSetString(0, IntegerToString(OrderTicket()), OBJPROP_LEVELTEXT, 4, "161.8 = %$");
   ObjectSetDouble(0, IntegerToString(OrderTicket()), OBJPROP_LEVELVALUE, 5, 2.00);
   ObjectSetString(0, IntegerToString(OrderTicket()), OBJPROP_LEVELTEXT, 5, "200.0 = %$");
   ObjectSetDouble(0, IntegerToString(OrderTicket()), OBJPROP_LEVELVALUE, 6, 2.618);
   ObjectSetString(0, IntegerToString(OrderTicket()), OBJPROP_LEVELTEXT, 6, "261.8 = %$");
   ObjectSetDouble(0, IntegerToString(OrderTicket()), OBJPROP_LEVELVALUE, 7, 4.236);
   ObjectSetString(0, IntegerToString(OrderTicket()), OBJPROP_LEVELTEXT, 7, "423.6 = %$");
   ObjectSetDouble(0, IntegerToString(OrderTicket()), OBJPROP_LEVELVALUE, 8, 6.854);
   ObjectSetString(0, IntegerToString(OrderTicket()), OBJPROP_LEVELTEXT, 8, "685.4 = %$");
   ObjectSetDouble(0, IntegerToString(OrderTicket()), OBJPROP_LEVELVALUE, 9, 11.09);
   ObjectSetString(0, IntegerToString(OrderTicket()), OBJPROP_LEVELTEXT, 9, "1109 = %$");
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BuyCicOrder()
  {
   if((Close[2] < Open[2] && Close[1] > Open[1] && Close[1] > Close[2] && Low[1] > Low[2] && Close[1] > High[2]) && (BCic_High100 == 0) && (iTime(NULL, 0, 1) != BCic_Time1))
     {
      if(MethodFibo_input == 1)
        {
         BCic_High100 = High[1];
         BCic_Time1 = iTime(NULL, 0, 1);
         BCic_Low0 = Low[2];
         BCic_Time2 = iTime(NULL, 0, 2);
        }
      else
        {
         if(MethodFibo_input == 2)
           {
            BCic_High100 = Close[1];
            BCic_Time1 = iTime(NULL, 0, 1);
            BCic_Low0 = Close[2];
            BCic_Time2 = iTime(NULL, 0, 2);
           }
        }
     }
   else
      if((BCic_Low0 != 0) && (Close[1] > BCic_Low0))
        {
         BCic_CountPips = (BCic_High100 - BCic_Low0) / Point;
         BCic_SL = BCic_Low0 + BCic_CountPips * BCic_SL_input * Point;
         BCic_TP = BCic_Low0 + BCic_CountPips * BCic_TP1_input * Point;
         res = OrderSend(Symbol(), OP_BUY, Lots, Ask, 3, BCic_SL, BCic_TP, IntegerToString(CountTrades), BCic_MagicNumber, 0, clrGreen);
         if(res)
            CountTrades++;
         if(OrderSelect(OrdersTotal() - 1, SELECT_BY_POS) == true)
           {
            CreateFibo(BCic_Time1, BCic_High100, BCic_Time2, BCic_Low0);
           }
         if(BCic_Safe_input == 1)
           {
            BCic_TP = BCic_Low0 + BCic_CountPips * BCic_SafeTP_input * Point;
            BCic_SL = BCic_Low0 + BCic_CountPips * BCic_SafeSL_input * Point;
            res = OrderSend(Symbol(), OP_BUY, Lots, Ask, 3, BCic_SL, BCic_TP, IntegerToString(CountTrades), BCicS_MagicNumber, 0, clrGreen);
            if(res)
               CountTrades++;
           }
         else
            if(BCic_Safe_input == 2)
              {
               BCic_TP = BCic_Low0 + BCic_CountPips * BCic_SafeTP_input * Point;
               BCic_SL = BCic_Low0 + BCic_CountPips * BCic_SafeSL_input * Point;
               res = OrderSend(Symbol(), OP_BUY, Lots * 2, Ask, 3, BCic_SL, BCic_TP, IntegerToString(CountTrades), BCicS_MagicNumber, 0, clrGreen);
               if(res)
                  CountTrades++;
              }
         BCic_Low0 = 0;
         BCic_High100 = 0;
         BCic_TP = 0;
         BCic_SL = 0;
        }
      else
        {
         BCic_Low0 = 0;
         BCic_High100 = 0;
         BCic_TP = 0;
         BCic_SL = 0;
        }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SellCicOrder()
  {
   if((Close[2] > Open[2] && Close[1] < Open[1] && Close[1] < Close[2] && High[1] < High[2] && Close[1] < Low[2]) && (SCic_High0 == 0) && (iTime(NULL, 0, 2) != SCic_Time1))
     {
      if(MethodFibo_input == 1)
        {
         SCic_High0 = High[2];
         SCic_Time1 = iTime(NULL, 0, 2);
         SCic_Low100 = Low[1];
         SCic_Time2 = iTime(NULL, 0, 1);
        }
      else
        {
         if(MethodFibo_input == 2)
           {
            SCic_High0 = Close[2];
            SCic_Time1 = iTime(NULL, 0, 2);
            SCic_Low100 = Close[1];
            SCic_Time2 = iTime(NULL, 0, 1);
           }
        }
     }
   else
      if((SCic_Low100 != 0) && (Close[1] < SCic_High0))
        {
         SCic_CountPips = (SCic_High0 - SCic_Low100) / Point;
         SCic_SL = SCic_High0 - SCic_CountPips * SCic_SL_input * Point;
         SCic_TP = SCic_High0 - SCic_CountPips * SCic_TP1_input * Point;
         res = OrderSend(Symbol(), OP_SELL, Lots, Bid, 3, SCic_SL, SCic_TP, IntegerToString(CountTrades), SCic_MagicNumber, 0, clrRed);
         if(res)
            CountTrades++;
         if(OrderSelect(OrdersTotal() - 1, SELECT_BY_POS) == true)
           {
            CreateFibo(SCic_Time2, SCic_Low100, SCic_Time1, SCic_High0);
           }
         if(SCic_Safe_input == 1)
           {
            SCic_TP = SCic_High0 - SCic_CountPips * SCic_SafeTP_input * Point;
            SCic_SL = SCic_High0 - SCic_CountPips * SCic_SafeSL_input * Point;
            res = OrderSend(Symbol(), OP_SELL, Lots, Bid, 3, SCic_SL, SCic_TP, IntegerToString(CountTrades), SCic_MagicNumber, 0, clrRed);
            if(res)
               CountTrades++;
           }
         else
            if(SCic_Safe_input == 2)
              {
               SCic_TP = SCic_High0 - SCic_CountPips * SCic_SafeTP_input * Point;
               SCic_SL = SCic_High0 - SCic_CountPips * SCic_SafeSL_input * Point;
               res = OrderSend(Symbol(), OP_SELL, Lots * 2, Bid, 3, SCic_SL, SCic_TP, IntegerToString(CountTrades), SCic_MagicNumber, 0, clrRed);
               if(res)
                  CountTrades++;
              }
         SCic_Low100 = 0;
         SCic_High0 = 0;
         SCic_TP = 0;
         SCic_SL = 0;
        }
      else
        {
         SCic_Low100 = 0;
         SCic_High0 = 0;
         SCic_TP = 0;
         SCic_SL = 0;
        }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BuyRightOrder()
  {
   if(BR_Low0 == 0)
     {
      if(Close[1] > Close[2] && Close[1] > Open[1] && Close[2] < Open[2])
        {
         if(MethodFibo_input == 1)
           {
            BR_Low0 = Low[1];
            BR_Time2 = iTime(NULL, 0, 1);
           }
         else
           {
            if(MethodFibo_input == 2)
              {
               BR_Low0 = Open[1];
               BR_Time2 = iTime(NULL, 0, 1);
              }
           }
        }
     }
   else
      if(Close[1] > BR_Low0)
        {
         if((Close[1] < Open[1] && Close[1] < Close[2]) && (BR_High100 == 0))
           {
            if(MethodFibo_input == 1)
              {
               BR_High100 = High[1];
               BR_Time1 = iTime(NULL, 0, 1);
              }
            else
              {
               if(MethodFibo_input == 2)
                 {
                  BR_High100 = Open[1];
                  BR_Time1 = iTime(NULL, 0, 1);
                 }
              }
           }
         else
            if((BR_High100 != 0) && (Close[1] > BR_High100))
              {
               if((BR_High100 != 0) && (BR_Low0 != 0))
                 {
                  BR_CountPips = (BR_High100 - BR_Low0) / Point;
                  BR_Level161 = BR_Low0 + BR_CountPips * 1.618 * Point;
                  BR_Level261 = BR_Low0 + BR_CountPips * 2.618 * Point;
                  BR_Level423 = BR_Low0 + BR_CountPips * 4.236 * Point;
                  BR_SL = BR_Low0 + BR_CountPips * BR_SL_input * Point;
                  BR_TP = BR_Low0 + BR_CountPips * BR_TP1_input * Point;
                  if(High[1] > BR_Level161)
                     BR_TP = BR_Low0 + BR_CountPips * BR_TP2_input * Point;
                  if(High[1] > BR_Level261)
                     BR_TP = BR_Low0 + BR_CountPips * BR_TP3_input * Point;
                  if(High[1] > BR_Level423)
                     BR_TP = BR_Low0 + BR_CountPips * BR_TP4_input * Point;
                 }
               res = OrderSend(Symbol(), OP_BUY, Lots, Ask, 3, BR_SL, BR_TP, IntegerToString(CountTrades), BR_MagicNumber, 0, clrGreen);
               if(res)
                  CountTrades++;
               if(OrderSelect(OrdersTotal() - 1, SELECT_BY_POS) == true)
                 {
                  CreateFibo(BR_Time1, BR_High100, BR_Time2, BR_Low0);
                 }
               if(BR_Safe_input == 1)
                 {
                  BR_TP = BR_Low0 + BR_CountPips * BR_SafeTP_input * Point;
                  BR_SL = BR_Low0 + BR_CountPips * BR_SafeSL_input * Point;
                  res = OrderSend(Symbol(), OP_BUY, Lots, Ask, 3, BR_SL, BR_TP, IntegerToString(CountTrades), BRS_MagicNumber, 0, clrGreen);
                  if(res)
                     CountTrades++;
                 }
               else
                  if(BR_Safe_input == 2)
                    {
                     BR_TP = BR_Low0 + BR_CountPips * BR_SafeTP_input * Point;
                     BR_SL = BR_Low0 + BR_CountPips * BR_SafeSL_input * Point;
                     res = OrderSend(Symbol(), OP_BUY, Lots * 2, Ask, 3, BR_SL, BR_TP, IntegerToString(CountTrades), BRS_MagicNumber, 0, clrGreen);
                     if(res)
                        CountTrades++;
                    }
               BR_Low0 = 0;
               BR_High100 = 0;
               BR_TP = 0;
               BR_SL = 0;
              }
        }
      else
        {
         BR_Low0 = 0;
         BR_High100 = 0;
         BR_TP = 0;
         BR_SL = 0;
        }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BuyLeftOrder()
  {
   if(BL_High100 == 0)
     {
      if(Close[1] < Close[2] && Close[1] < Open[1] && Close[2] > Open[2])
        {
         if(MethodFibo_input == 1)
           {
            BL_High100 = High[1];
            BL_Time1 = iTime(NULL, 0, 1);
           }
         else
           {
            if(MethodFibo_input == 2)
              {
               BL_High100 = Open[1];
               BL_Time1 = iTime(NULL, 0, 1);
              }
           }
        }
     }
   else
      if((Close[1] > Open[1]) && (Close[1] > Close[2]) && (BL_Low0 == 0))
        {
         if(MethodFibo_input == 1)
           {
            BL_Low0 = Low[1];
            BL_Time2 = iTime(NULL, 0, 1);
           }
         else
           {
            if(MethodFibo_input == 2)
              {
               BL_Low0 = Open[1];
               BL_Time2 = iTime(NULL, 0, 1);
              }
           }
        }
      else
         if(Close[1] > BL_Low0)
           {
            if((BL_Low0 != 0) && (Close[1] > BL_High100))
              {
               if((BL_High100 != 0) && (BL_Low0 != 0))
                 {
                  BL_CountPips = (BL_High100 - BL_Low0) / Point;
                  BL_Level161 = BL_Low0 + BL_CountPips * 1.618 * Point;
                  BL_Level261 = BL_Low0 + BL_CountPips * 2.618 * Point;
                  BL_Level423 = BL_Low0 + BL_CountPips * 4.236 * Point;
                  BL_SL = BL_Low0 + BL_CountPips * BL_SL_input * Point;
                  BL_TP = BL_Low0 + BL_CountPips * BL_TP1_input * Point;
                  if(High[1] > BL_Level161)
                     BL_TP = BL_Low0 + BL_CountPips * BL_TP2_input * Point;
                  if(High[1] > BL_Level261)
                     BL_TP = BL_Low0 + BL_CountPips * BL_TP3_input * Point;
                  if(High[1] > BL_Level423)
                     BL_TP = BL_Low0 + BL_CountPips * BL_TP4_input * Point;
                 }
               res = OrderSend(Symbol(), OP_BUY, Lots, Ask, 3, BL_SL, BL_TP, IntegerToString(CountTrades), BL_MagicNumber, 0, clrGreen);
               if(res)
                  CountTrades++;
               if(OrderSelect(OrdersTotal() - 1, SELECT_BY_POS) == true)
                 {
                  CreateFibo(BL_Time1, BL_High100, BL_Time2, BL_Low0);
                 }
               if(BL_Safe_input == 1)
                 {
                  BL_TP = BL_Low0 + BL_CountPips * BL_SafeTP_input * Point;
                  BL_SL = BL_Low0 + BL_CountPips * BL_SafeSL_input * Point;
                  res = OrderSend(Symbol(), OP_BUY, Lots, Ask, 3, BL_SL, BL_TP, IntegerToString(CountTrades), BLS_MagicNumber, 0, clrGreen);
                  if(res)
                     CountTrades++;
                 }
               else
                  if(BL_Safe_input == 2)
                    {
                     BL_TP = BL_Low0 + BL_CountPips * BL_SafeTP_input * Point;
                     BL_SL = BL_Low0 + BL_CountPips * BL_SafeSL_input * Point;
                     res = OrderSend(Symbol(), OP_BUY, Lots * 2, Ask, 3, BL_SL, BL_TP, IntegerToString(CountTrades), BLS_MagicNumber, 0, clrGreen);
                     if(res)
                        CountTrades++;
                    }
               BL_Low0 = 0;
               BL_High100 = 0;
               BL_TP = 0;
               BL_SL = 0;
              }
           }
         else
           {
            BL_Low0 = 0;
            BL_High100 = 0;
            BL_TP = 0;
            BL_SL = 0;
           }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SellRightOrder()
  {
   if(SR_High0 == 0)
     {
      if(Close[1] < Open[1] && Close[2] > Open[2] && Close[1] < Close[2])
        {
         if(MethodFibo_input == 1)
           {
            SR_High0 = High[1];
            SR_Time2 = iTime(NULL, 0, 1);
           }
         else
           {
            if(MethodFibo_input == 2)
              {
               SR_High0 = Open[1];
               SR_Time2 = iTime(NULL, 0, 1);
              }
           }
        }
     }
   else
      if(Close[1] < SR_High0)
        {
         if((Close[1] > Open[1] && Close[1] > Close[2]) && (SR_Low100 == 0))
           {
            if(MethodFibo_input == 1)
              {
               SR_Low100 = Low[1];
               SR_Time1 = iTime(NULL, 0, 1);
              }
            else
              {
               if(MethodFibo_input == 2)
                 {
                  SR_Low100 = Open[1];
                  SR_Time1 = iTime(NULL, 0, 1);
                 }
              }
           }
         else
            if((SR_Low100 != 0) && (Close[1] < SR_Low100))
              {
               if((SR_High0 != 0) && (SR_Low100 != 0))
                 {
                  SR_CountPips = (SR_High0 - SR_Low100) / Point;
                  SR_Level161 = SR_High0 - SR_CountPips * 1.618 * Point;
                  SR_Level261 = SR_High0 - SR_CountPips * 2.618 * Point;
                  SR_Level423 = SR_High0 - SR_CountPips * 4.236 * Point;
                  SR_TP = SR_High0 - SR_CountPips * SR_TP1_input * Point;
                  if(Low[1] < SR_Level161)
                     SR_TP = SR_High0 - SR_CountPips * SR_TP2_input * Point;
                  if(Low[1] < SR_Level261)
                     SR_TP = SR_High0 - SR_CountPips * SR_TP3_input * Point;
                  if(Low[1] < SR_Level423)
                     SR_TP = SR_High0 - SR_CountPips * SR_TP4_input * Point;
                  SR_SL = SR_High0 - SR_CountPips * SR_SL_input * Point;
                 }
               res = OrderSend(Symbol(), OP_SELL, Lots, Bid, 3, SR_SL, SR_TP, IntegerToString(CountTrades), SR_MagicNumber, 0, clrRed);
               if(res)
                  CountTrades++;
               if(OrderSelect(OrdersTotal() - 1, SELECT_BY_POS) == true)
                 {
                  CreateFibo(SR_Time1, SR_Low100, SR_Time2, SR_High0);
                 }
               if(SR_Safe_input == 1)
                 {
                  SR_TP = SR_High0 - SR_CountPips * SR_SafeTP_input * Point;
                  SR_SL = SR_High0 - SR_CountPips * SR_SafeSL_input * Point;
                  res = OrderSend(Symbol(), OP_SELL, Lots, Bid, 3, SR_SL, SR_TP, IntegerToString(CountTrades), SRS_MagicNumber, 0, clrRed);
                  if(res)
                     CountTrades++;
                 }
               else
                  if(SR_Safe_input == 2)
                    {
                     SR_TP = SR_High0 - SR_CountPips * SR_SafeTP_input * Point;
                     SR_SL = SR_High0 - SR_CountPips * SR_SafeSL_input * Point;
                     res = OrderSend(Symbol(), OP_SELL, Lots * 2, Bid, 3, SR_SL, SR_TP, IntegerToString(CountTrades), SRS_MagicNumber, 0, clrRed);
                     if(res)
                        CountTrades++;
                    }
               SR_High0 = 0;
               SR_Low100 = 0;
               SR_TP = 0;
               SR_SL = 0;
              }
        }
      else
        {
         SR_High0 = 0;
         SR_Low100 = 0;
         SR_TP = 0;
         SR_SL = 0;
        }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SellLeftOrder()
  {
   if(SL_Low100 == 0)
     {
      if(Close[2] < Open[2] && Close[1] > Open[1] && Close[1] > Close[2])
        {
         if(MethodFibo_input == 1)
           {
            SL_Low100 = Low[1];
            SL_Time1 = iTime(NULL, 0, 1);
           }
         else
           {
            if(MethodFibo_input == 2)
              {
               SL_Low100 = Open[1];
               SL_Time1 = iTime(NULL, 0, 1);
              }
           }
        }
     }
   else
      if(((Close[1] < Open[1]) && (Close[1] < Close[2])) && (SL_High0 == 0))
        {
         if(MethodFibo_input == 1)
           {
            SL_High0 = High[1];
            SL_Time2 = iTime(NULL, 0, 1);
           }
         else
           {
            if(MethodFibo_input == 2)
              {
               SL_High0 = Open[1];
               SL_Time2 = iTime(NULL, 0, 1);
              }
           }
        }
      else
        {
         if(SL_High0 != 0)
            if(Close[1] < SL_High0)
              {
               if((SL_Low100 != 0) && (Close[1] < SL_Low100))
                 {
                  if((SL_High0 != 0) && (SL_Low100 != 0))
                    {
                     SL_CountPips = (SL_High0 - SL_Low100) / Point;
                     SL_Level161 = SL_High0 - SL_CountPips * 1.618 * Point;
                     SL_Level261 = SL_High0 - SL_CountPips * 2.618 * Point;
                     SL_Level423 = SL_High0 - SL_CountPips * 4.236 * Point;
                     SL_TP = SL_High0 - SL_CountPips * SL_TP1_input * Point;
                     if(Low[1] < SL_Level161)
                        SL_TP = SL_High0 - SL_CountPips * SL_TP2_input * Point;;
                     if(Low[1] < SL_Level261)
                        SL_TP = SL_High0 - SL_CountPips * SL_TP3_input * Point;
                     if(Low[1] < SL_Level423)
                        SL_TP = SL_High0 - SL_CountPips * SL_TP4_input * Point;
                     SL_SL = SL_High0 - SL_CountPips * SL_SL_input * Point;
                    }
                  res = OrderSend(Symbol(), OP_SELL, Lots, Bid, 3, SL_SL, SL_TP, IntegerToString(CountTrades), SL_MagicNumber, 0, clrRed);
                  if(res)
                     CountTrades++;
                  if(OrderSelect(OrdersTotal() - 1, SELECT_BY_POS) == true)
                    {
                     CreateFibo(SL_Time1, SL_Low100, SL_Time2, SL_High0);
                    }
                  if(SL_Safe_input == 1)
                    {
                     SL_TP = SL_High0 - SL_CountPips * SL_SafeTP_input * Point;
                     SL_SL = SL_High0 - SL_CountPips * SL_SafeSL_input * Point;
                     res = OrderSend(Symbol(), OP_SELL, Lots, Bid, 3, SL_SL, SL_TP, IntegerToString(CountTrades), SLS_MagicNumber, 0, clrRed);
                     if(res)
                        CountTrades++;
                    }
                  else
                     if(SL_Safe_input == 2)
                       {
                        SL_TP = SL_High0 - SL_CountPips * SL_SafeTP_input * Point;
                        SL_SL = SL_High0 - SL_CountPips * SL_SafeSL_input * Point;
                        res = OrderSend(Symbol(), OP_SELL, Lots * 2, Bid, 3, SL_SL, SL_TP, IntegerToString(CountTrades), SLS_MagicNumber, 0, clrRed);
                        if(res)
                           CountTrades++;
                       }
                  SL_High0 = 0;
                  SL_Low100 = 0;
                  SL_TP = 0;
                  SL_SL = 0;
                 }
              }
            else
              {
               SL_High0 = 0;
               SL_Low100 = 0;
               SL_TP = 0;
               SL_SL = 0;
              }
        }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Accompaniment()
  {
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)
        {
         if(OrderType() == OP_BUY)
           {
            if(OrderMagicNumber() == BR_MagicNumber)
              {
               AC_Buy_CountPips = (ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE1) - ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2)) / Point;
               AC_Buy_Level = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * ChangeStopLoss_Level * Point;
               AC_Buy_Level2 = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * ChangeStopLoss_Level2 * Point;
               if((ChangeStopLoss == 1) && (High[1] > AC_Buy_Level) && (OrderStopLoss() <= ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE1)))
                 {
                  res = OrderModify(OrderTicket(), OrderOpenPrice(), AC_Buy_Level2, OrderTakeProfit(), 0, clrGreen);
                 }
               AC_BR_Level = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * 1.000 * Point;
               AC_BR_Level1 = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * 1.618 * Point;
               AC_BR_Level2 = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * 2.618 * Point;
               AC_BR_Level3 = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * 4.236 * Point;
               AC_BR_Level4 = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * 6.854 * Point;
               AC_BR_Level5 = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * 11.090 * Point;
               AC_BR_IndexOpenBars = iBarShift(NULL, 0, OrderOpenTime(), false) + 1;
               if((OrderTakeProfit() < BR_TP2_input) && (Close[1] > Open[1]) && (High[1] > AC_BR_Level1) && (High[1] < AC_BR_Level2))
                 {
                  AC_BR_TP = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * BR_TP2_input * Point;
                  for(int j = 0; j <= AC_BR_IndexOpenBars; j++)
                    {
                     if(Close[j] < Open[j])
                       {
                        AC_BR_TP = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * BR_TP1_input * Point;
                        break;
                       }
                     if(Low[j] < AC_BR_Level)
                        break;
                    }
                  res = OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), AC_BR_TP, 0, clrGreen);
                 }
              }
            else
              {
               if(OrderMagicNumber() == BL_MagicNumber)
                 {
                  AC_Buy_CountPips = (ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE1) - ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2)) / Point;
                  AC_Buy_Level = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * ChangeStopLoss_Level * Point;
                  AC_Buy_Level2 = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * ChangeStopLoss_Level2 * Point;
                  if((ChangeStopLoss == 1) && (High[1] > AC_Buy_Level) && (OrderStopLoss() <= ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE1)))
                    {
                     res = OrderModify(OrderTicket(), OrderOpenPrice(), AC_Buy_Level2, OrderTakeProfit(), 0, clrGreen);
                    }
                  AC_BL_Level = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * 1.000 * Point;
                  AC_BL_Level1 = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * 1.618 * Point;
                  AC_BL_Level2 = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * 2.618 * Point;
                  AC_BL_Level3 = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * 4.236 * Point;
                  AC_BL_Level4 = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * 6.854 * Point;
                  AC_BL_Level5 = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * 11.090 * Point;
                  AC_BL_IndexOpenBars = iBarShift(NULL, 0, OrderOpenTime(), false) + 1;
                  if((OrderTakeProfit() < BL_TP2_input) && (Close[1] > Open[1]) && (High[1] > AC_BL_Level1) && (High[1] < AC_BL_Level2))
                    {
                     AC_BL_TP = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * BL_TP2_input * Point;
                     for(int j = 1; j <= AC_BL_IndexOpenBars; j++)
                       {
                        if(Close[j] < Open[j])
                          {
                           AC_BL_TP = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * BL_TP1_input * Point;
                           break;
                          }
                        if(Low[j] < AC_BL_Level)
                           break;
                       }
                     res = OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), AC_BL_TP, 0, clrGreen);
                    }
                 }
               else
                 {
                  if(OrderMagicNumber() == BCic_MagicNumber)
                    {
                     AC_Buy_CountPips = (ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE1) - ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2)) / Point;
                     AC_Buy_Level = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * ChangeStopLoss_Level * Point;
                     AC_Buy_Level2 = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * ChangeStopLoss_Level2 * Point;
                     if((ChangeStopLoss == 1) && (High[1] > AC_Buy_Level) && (OrderStopLoss() <= ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE1)))
                       {
                        res = OrderModify(OrderTicket(), OrderOpenPrice(), AC_Buy_Level2, OrderTakeProfit(), 0, clrGreen);
                       }
                     AC_BCic_Level = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * 1.000 * Point;
                     AC_BCic_Level1 = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * 1.618 * Point;
                     AC_BCic_Level2 = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * 2.618 * Point;
                     AC_BCic_Level3 = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * 4.236 * Point;
                     AC_BCic_Level4 = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * 6.854 * Point;
                     AC_BCic_Level5 = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * 11.090 * Point;
                     AC_BCic_IndexOpenBars = iBarShift(NULL, 0, OrderOpenTime(), false) + 1;
                     if((OrderTakeProfit() < BCic_TP2_input) && (Close[1] > Open[1]) && (High[1] > AC_BCic_Level1) && (High[1] < AC_BCic_Level2))
                       {
                        AC_BCic_TP = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * BCic_TP2_input * Point;
                        for(int j = 0; j <= AC_BCic_IndexOpenBars; j++)
                          {
                           if(Close[j] < Open[j])
                             {
                              AC_BCic_TP = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) + AC_Buy_CountPips * BCic_TP1_input * Point;
                              break;
                             }
                           if(Low[j] < AC_BCic_Level)
                              break;
                          }
                        res = OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), AC_BCic_TP, 0, clrGreen);
                       }
                    }
                 }
              }
           }
         else
           {
            if((OrderType() == OP_SELL) && ((OrderMagicNumber() == SR_MagicNumber) || (OrderMagicNumber() == SL_MagicNumber)))
              {
               AC_Sell_CountPips = (ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) - ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE1)) / Point;
               AC_Sell_Level = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) - AC_Sell_CountPips * ChangeStopLoss_Level * Point;
               AC_Sell_Level2 = ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE2) - AC_Sell_CountPips * ChangeStopLoss_Level2 * Point;
               if((ChangeStopLoss == 1) && (Low[1] < AC_Sell_Level) && (OrderStopLoss() >= ObjectGetDouble(0, IntegerToString(OrderTicket()), OBJPROP_PRICE1)))
                 {
                  res = OrderModify(OrderTicket(), OrderOpenPrice(), AC_Sell_Level2, OrderTakeProfit(), 0, clrRed);
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnInit()
  {
   if(ChartColors_input == 1)
     {
      ChartSetInteger(0, CHART_SHIFT, true);
      ChartSetInteger(0, CHART_AUTOSCROLL, true);
      ChartSetInteger(0, CHART_SHOW_GRID, false);
      ChartSetInteger(0, CHART_SHOW_ASK_LINE, true);
      ChartSetInteger(0, CHART_MODE, CHART_CANDLES);
      ChartSetInteger(0, CHART_SHOW_PERIOD_SEP, false);
      ChartSetInteger(0, CHART_COLOR_BACKGROUND, clrWhiteSmoke);
      ChartSetInteger(0, CHART_COLOR_FOREGROUND, clrBlack);
      ChartSetInteger(0, CHART_COLOR_GRID, clrSilver);
      ChartSetInteger(0, CHART_COLOR_CHART_UP, clrDarkGreen);
      ChartSetInteger(0, CHART_COLOR_CHART_DOWN, clrBrown);
      ChartSetInteger(0, CHART_COLOR_CANDLE_BULL, clrLimeGreen);
      ChartSetInteger(0, CHART_COLOR_CANDLE_BEAR, clrTomato);
      ChartSetInteger(0, CHART_COLOR_CHART_LINE, clrBlack);
      ChartSetInteger(0, CHART_COLOR_VOLUME, clrGreen);
      ChartSetInteger(0, CHART_COLOR_ASK, clrRed);
      ChartSetInteger(0, CHART_COLOR_STOP_LEVEL, clrRed);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   CalculateLots();
//---
   if(MovingBuy_input == 1)
     {
      if(Close[1] >= iMA(NULL, 0, MovingPeriod_input, MovingShift_input, MovingMethod_input, MovingAppPrice_input, 0))
        {
         if(BuyRight_input == 1)
           {
            BuyRightOrder();
           }
         if(BuyLeft_input == 1)
           {
            BuyLeftOrder();
           }
         if(BuyCic_input == 1)
           {
            BuyCicOrder();
           }
         for(int i = OrdersTotal() - 1; i >= 0; i--)
           {
            res = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
            if((OrderType() == OP_SELL) && ((OrderMagicNumber() == SCic_MagicNumber) || (OrderMagicNumber() == SCicS_MagicNumber) || (OrderMagicNumber() == SR_MagicNumber) || (OrderMagicNumber() == SRS_MagicNumber) || (OrderMagicNumber() == SL_MagicNumber) || (OrderMagicNumber() == SLS_MagicNumber)))
               res = OrderClose(OrderTicket(), OrderLots(), Ask, 1000, 0);
           }
         SR_High0 = 0;
         SR_Low100 = 0;
         SR_TP = 0;
         SR_SL = 0;
         SL_High0 = 0;
         SL_Low100 = 0;
         SL_TP = 0;
         SL_SL = 0;
        }
     }
   else
      if(MovingSell_input == 1)
        {
         if(Close[1] < iMA(NULL, 0, MovingPeriod_input, MovingShift_input, MovingMethod_input, MovingAppPrice_input, 0))
           {
            if(SellRight_input == 1)
              {
               SellRightOrder();
              }
            if(SellLeft_input == 1)
              {
               SellLeftOrder();
              }
            if(SellCic_input == 1)
              {
               SellCicOrder();
              }
            for(int i = OrdersTotal() - 1; i >= 0; i--)
              {
               res = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
               if((OrderType() == OP_BUY) && ((OrderMagicNumber() == BCic_MagicNumber) || (OrderMagicNumber() == BCicS_MagicNumber) || (OrderMagicNumber() == BR_MagicNumber) || (OrderMagicNumber() == BRS_MagicNumber) || (OrderMagicNumber() == BL_MagicNumber) || (OrderMagicNumber() == BLS_MagicNumber)))
                  res = OrderClose(OrderTicket(), OrderLots(), Bid, 1000, 0);
              }
            BR_Low0 = 0;
            BR_High100 = 0;
            BR_TP = 0;
            BR_SL = 0;
            BL_Low0 = 0;
            BL_High100 = 0;
            BL_TP = 0;
            BL_SL = 0;
           }
        }
      else
        {
         if(BuyRight_input == 1)
           {
            BuyRightOrder();
           }
         if(BuyLeft_input == 1)
           {
            BuyLeftOrder();
           }
         if(SellRight_input == 1)
           {
            SellRightOrder();
           }
         if(SellLeft_input == 1)
           {
            SellLeftOrder();
           }
         if(BuyCic_input == 1)
           {
            BuyCicOrder();
           }
         if(SellCic_input == 1)
           {
            SellCicOrder();
           }
        }
//---
   Accompaniment();
//---
   if(RiskManagment_input == 1)
     {
      RiskManagment();
     }
   if(CountTrades == 0)
      CountTrades = OrdersTotal();
   if(OrdersTotal() > CountTrades)
      CountTrades = OrdersTotal();
   if(OrdersTotal() < CountTrades)
     {
      CountTrades = OrdersTotal();
      CleanFibo();
     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
