//+------------------------------------------------------------------+
//|                                                     CupPrice.mq4 |
//|                                          Copyright 2021, Aleksei |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "CupPrice"
#property link        "https://www.mql5.com"
#property version     "2.12"
#property description "CupPrice"

#property strict

enum EN_Signal
  {
   enSignal                 = 1, //По сигналу
   enAgainstSignal          = 2  //Против сигнала
  };

enum EN_AreaAppSignal
  {
   enFirst                  = 1, //К первой сделки
   enAllGrid                = 2  //Ко всей сетке
  };

enum EN_OnOff
  {
   enOn                     = 1, //Включить
   enOff                    = 0  //Выключить
  };

enum EN_MaMethod
  {
   enMaFilter               = 0, //Выше/Ниже МА
   enMastrategy             = 1  //Пробитие свечей МА
  };

enum EN_RsiMethod
  {
   enRsiFilter              = 0, //Выше/Ниже уровней
   enRsiStrategy            = 1  //Выход из заданных уровней
  };

enum EN_StochMethod
  {
   enStochFilter            = 0, //Выше/Ниже уровней
   enStochStrategy          = 1  //Пересечение главной линии сигнальной
  };

enum EN_IncLotsMethod
  {
   enFixLots                = 1, //Фиксированный лот (1, 1, 1, 1, 1 ...)
   enMartinLots             = 2, //Мартингейл (Умножение) (1, 2, 4, 8, 16 ...)
   enMartinLotsLite         = 3, //Мартингейл (Сложение) (1, 2, 3, 4, 5 ...)
   enFiboLots               = 4  //Фибоначчи (1, 1, 2, 3, 5 ...)
  };

enum EN_ProfitMethod
  {
   enTakeProfit             = 2, //По тейку (Тейк профит)
   enCurrency               = 1, //В валюте (При достижении заданной прибыли)
   enAllProfit              = 3, //В валюте общ (... ВСЕХ ордеров и buy и sell)
   enInPips                 = 4, //В пунктах (При достижении заданного расстояния в Pips)
   enInAllPips              = 5  //В пунктах общ (... ВСЕХ ордеров и buy и sell)
  };

enum EN_ProfitMethod2
  {
   enCurrency2               = 1, //В валюте (При достижении заданной прибыли)
   enInPips2                 = 2, //В пунктах крайнего ордера (При достижении заданного расстояния в Pips)
  };

enum EN_LossesMethod
  {
   enStopLoss               = 0, //СтопЛосс
   enAverage                = 1  //Усреднение
  };

enum EN_PartCloseTakeMethod
  {
   enStayTake               = 0, //Оставлять тейкпрофит на том же месте
   enRecalculateTake        = 1  //Пересчитывать тейкпрофит после уменьшения сетки
  };

enum EN_ChartTheme
  {
   enOffTheme               = 0, //Выключено (Не использовать тему)
   enLightTheme             = 1, //Светлая тема
   enDarkTheme              = 2  //Тёмная тема
  };

enum EN_PushMessage
  {
   EN_OffPushMessage        = 0, //Выключено (Не отправлять)
   EN_OnPushMessage         = 1, //Включено (Отправлять push-уведомления)
   EN_PushMessage           = 2  //Только важные (Отправлять только важные push-уведомления)
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
sinput string dlm_0                               = "==================== Настройки условия точки входа, открытия сделки ====================";//==================== #1 ====================
extern EN_Signal directionSignal                    = 1;              //Направление сделок
extern EN_AreaAppSignal areaAppSignal               = 1;              //Условия входа применяются...
sinput string dlm_01                              = "==================== Настройки точки входа по импульсной свече ====================";//==================== #1.1 ====================
extern EN_OnOff checkInImpulse                      = 1;              //Использовать для входа импульсную свечу
extern int minCandleSize                            = 200;            //Минимальный размер свечи (Включительно)
extern int maxCandleSize                            = 500;            //Максимальный размер свечи (Включительно)
sinput string dlm_02                              = "==================== Настройки точки входа по скользящей средней ====================";//==================== #1.2 ====================
extern EN_OnOff checkInMA                           = 0;              //Использовать для входа скользящую среднюю
extern EN_MaMethod checkInMAMethod                  = 0;              //Фильтр/Стратегия
extern int MovingPeriod                             = 200;            //Период скользящей средней
extern int MovingShift                              = 0;              //Сдвиг скользящей средней
extern ENUM_MA_METHOD MovingMethod                  = MODE_EMA;       //Метод скользящей средней
extern ENUM_APPLIED_PRICE MovingAppliedPrice        = PRICE_CLOSE;    //Построение скользящей средней по ценам...
sinput string dlm_03                              = "==================== Настройки точки входа по RSI ====================";//==================== #1.3 ====================
extern EN_OnOff checkInRSI                          = 0;              //Использовать для входа RSI
extern EN_RsiMethod checkInRSIMethod                = 0;              //Фильтр/Стратегия
extern int RSIPeriod                                = 14;             //Период RSI
extern int RSIHighLevel                             = 70;             //Верхний уровень RSI
extern int RSILowLevel                              = 30;             //Нижний уровень RSI
extern ENUM_APPLIED_PRICE RSIAppliedPrice           = PRICE_CLOSE;    //Построение RSI по ценам...
sinput string dlm_04                              = "==================== Настройки точки входа по Stochastic ====================";//==================== #1.4 ====================
extern EN_OnOff checkInStoch                        = 0;              //Использовать для входа Stochastic
extern EN_StochMethod checkInStochMethod            = 0;              //Фильтр/Стратегия
extern int stochPeriodK                             = 5;              //Период K Stochastic
extern int stochPeriodD                             = 3;              //Период D Stochastic
extern int stochSlowing                             = 3;              //Замедление Stochastic
extern ENUM_MA_METHOD stochMethod                   = MODE_SMA;       //Метод Stochastic
extern int stochAppliedPrice                        = 0;              //Построение Stochastic по ценам... (0 - Low/High 1 - Close)
extern int stochHighLevel                           = 80;             //Верхний уровень Stochastic
extern int stochLowLevel                            = 20;             //Нижний уровень Stochastic
sinput string dlm_1                               = "==================== Настройки объёмов сделки. Первой, либо фиксированной ====================";//==================== #2 ====================
extern EN_OnOff DynamicLots                         = 1;              //Использовать динамичный лот (объем)
extern double fixVolume                             = 0.01;           //Если (выкл), какой фиксированный лот (объем) использовать?
extern double EarlyLots                             = 0.01;           //Если (вкл), Начальный лот, далее увеличивается каждый "Шаг"
extern double IncLots                               = 0.01;           //Если (вкл), На сколько увеличивать лот от свободной маржи
extern int DepoForInc                               = 1300;           //Если (вкл), Шаг маржи при котором будет увеличиваться лот
extern double maxFirstLots                          = 0.55;           //Если (вкл), Максимальный объём первого ордера
sinput string dlm_2                               = "==================== Настройки работы с объемом сделок ====================";//#3
extern EN_IncLotsMethod volumeMethod                = 2;              //Метод работы с объёмом (лотность)
extern double martinVolume                          = 1.6;            //Коэфицент умножения/сложения при использовании Мартингейла
extern int stepVolume                               = 1;              //После какого шага увеличивать объём? (0 = Выкл)
sinput string dlm_3                               = "==================== Настройки фиксации прибыли, закрытия сделки ====================";//==================== #4 ====================
extern EN_ProfitMethod takeProfitMethod             = 2;              //Метод Фиксирования прибыли
extern int profitInCurr                             = 200;            //Прибыль (Тейкпрофит, Пункты, Пипсы, Сумма, Валюта, Прибыль)
extern int profitStep                               = 100;            //(Для тейка) Увеличение тейка с каждым шагом
extern int profitStepDecr1                          = 5;              //(Для тейка) Шаг, на котором увеличение уменьшается (0 выкл)
extern int profitStepDecr2                          = 50;             //(Для тейка) На сколько уменьшить прибавку тейка
extern int profitStepDecr3                          = 8;              //(Для тейка) Шаг, на котором увеличение ещё уменьшается (0 выкл)
extern int profitStepDecr4                          = 100;            //(Для тейка) На сколько ещё уменьшить прибавку тейка
extern int profitStepStop                           = 10;             //(Для тейка) Шаг, на котором закрывать безубыток
sinput string dlm_4                               = "==================== Настройки усредняющей сетки/стоплосса ====================";//==================== #5 ====================
extern EN_LossesMethod stopLossMethod               = 1;              //Метод работы с убытками
extern int stopLoss                                 = 200;            //Значение СтопЛосса (при использование стопов)
extern int gridStep                                 = 300;            //Шаг сетки (при использование усреднения)
extern int gridStepInc                              = 0;              //Последующие увеличение сетки (в пипсах)
extern EN_OnOff gridCheckBigCandle                  = 0;              //Не усреднять на одной свече, смещает усреднение (сетку)
extern EN_OnOff gridCheckContr                      = 0;              //Проверять наличие противоположного сигнала, смещает усреднение
extern EN_OnOff gridCheckContr2                     = 0;              //Вычитать разницу смещения от тейка? (При фиксации тейкпрофита)
sinput string dlm_5                               = "==================== Настройки трейлинг стопа ====================";//==================== #6 ====================
extern EN_OnOff tralActive                          = 1;              //Использовать трейлинг
extern EN_OnOff tralWithTake                        = 1;              //Двигать Тейк вместе с траллом
extern EN_OnOff tralNL                              = 0;              //При откате цены от трейллинга закрывать сетку?
extern int tralNLCurrent                            = 0;              //При откате цены с какой прибылью закрыть сетку? (0 - БУ)
extern int tralBeginStep                            = 5;              //На каком шаге включить трейлинг
extern int tralDisc                                 = 500;            //Растояние для трейлинг стопа
sinput string dlm_6                               = "==================== Настройки ограничений ====================";//==================== #7 ====================
extern EN_OnOff doubleOpenCandle                    = 0;              //Повторное открытие ордера на одной свече ("дубль")
extern int maxOpenBuy                               = 12;             //Максимальное количестов ордеров на покупку (для сетки)
extern int maxOpenSell                              = 12;             //Максимальное количестов ордеров на продажу (для сетки)
sinput string dlm_7                               = "==================== Настройки сопровождения сделок ====================";//==================== #8 ====================
extern EN_OnOff partClose                           = 1;              //Частичное закрытие сетки (Перекрывает прибылью убытки)
extern int partCloseStep                            = 8;              //Шаг, с которого начнётся частичное закрытие
extern int partCloseStepStop                        = 2;              //Шаг, до которого работает частичное закрытие
extern EN_ProfitMethod2 partCloseMethod             = 1;              //Фиксация прибыли частичного закрытия
extern int partCloseProfit                          = 0;              //При каком значении закрывать сделки? (Валюта, Пункты, Пипсы)
extern EN_PartCloseTakeMethod partCloseTake         = 0;              //(При фикс прибыли по тейку) При частичном закрытии сетки...
sinput string dlm_8                               = "==================== Настройки дополнительных функций. Настройки интерфейса ====================";//==================== #9 ====================
sinput EN_OnOff showTake                            = 0;              //Отображать на графике тейкпрофит?
sinput ENUM_LINE_STYLE showTakeStyle                = 3;              //Стиль отображения тейкпрофита?
sinput color showTakeColor                          = clrRed;         //Цвет отображения тейкпрофита?
sinput EN_OnOff showTral                            = 0;              //Отображать на графике трейлинг?
sinput ENUM_LINE_STYLE showTralStyle                = 3;              //Стиль отображения трейлинга?
sinput color showTralColor                          = clrDodgerBlue;  //Цвет отображения трейлинга?
sinput EN_OnOff showStop                            = 0;              //Отображать на графике стоплосс?
sinput ENUM_LINE_STYLE showStopStyle                = 3;              //Стиль отображения стоплосса?
sinput color showStopColor                          = clrRed;         //Цвет отображения стоплосса?
sinput EN_ChartTheme chartColorsInput               = 0;              //Изменение цветовой темы графика
sinput EN_OnOff infoAcc                             = 0;              //Показывать информацию об акаунте?
sinput EN_OnOff infoAccExtra                        = 0;              //Показывать дополнительную информацию об акаунте?
sinput EN_PushMessage PushMessage                   = 0;              //Отправлять push-уведомления?
sinput string dlm_9                               = "==================== Прочие настройки советника ====================";//==================== #10 ====================
sinput int magic                                    = 290896;         // Магическое число. Отличительное число сделок для советников
sinput int slippage                                 = 50;             // Проскальзывание

bool   allowOpenBuy = false,
       allowOpenSell = false;;

bool   tralCheckBuy = false,
       tralCheckSell = false;

int BuyMaxTic = 0,
    BuyMinTic = 0,
    SellMaxTic = 0,
    SellMinTic = 0;

double BuyMaxLot = 0.0,
       BuyMinLot = 0.0,
       SellMaxLot = 0.0,
       SellMinLot = 0.0;

double BuyMaxProfit = 0.0,
       BuyMinProfit = 0.0,
       SellMaxProfit = 0.0,
       SellMinProfit = 0.0;

datetime LastBuyOpenTime = 0,
         LastSellOpenTime = 0;

datetime LastBuyAvgTime = 0,
         LastSellAvgTime = 0;

double Lots = 0;

int countLvlBuy = 0,
    countLvlSell = 0;

int countClosedLvlBuy = 0,
    countClosedLvlSell = 0;

double summLotsSell = 0,
       summLotsBuy = 0;

double tralPriceSell = 0.0,
       tralPriceBuy = 0.0;

double tkProfitSell = 0.0,
       tkProfitBuy = 0.0;

double tkProfitSellInfo = 0.0,
       tkProfitBuyInfo = 0.0;

bool partCloseBuyCheck = false;
bool partCloseSellCheck = false;
bool infoCheck = false;

double MinMarginLevel = 0.0;

int lastPushMessageHour = 0;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit(void)
  {
   if(AccountNumber() != 60990103)
     {
      ExpertRemove();
     }
   if(chartColorsInput == 1)
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
      ChartSetInteger(0, CHART_COLOR_ASK, clrOrangeRed);
      ChartSetInteger(0, CHART_COLOR_STOP_LEVEL, clrOrangeRed);
     }
   if(chartColorsInput == 2)
     {
      ChartSetInteger(0, CHART_SHIFT, true);
      ChartSetInteger(0, CHART_AUTOSCROLL, true);
      ChartSetInteger(0, CHART_SHOW_GRID, false);
      ChartSetInteger(0, CHART_SHOW_ASK_LINE, true);
      ChartSetInteger(0, CHART_MODE, CHART_CANDLES);
      ChartSetInteger(0, CHART_SHOW_PERIOD_SEP, false);
      ChartSetInteger(0, CHART_COLOR_BACKGROUND, C'19,23,34');
      ChartSetInteger(0, CHART_COLOR_FOREGROUND, clrWhiteSmoke);
      ChartSetInteger(0, CHART_COLOR_GRID, C'64,64,80');
      ChartSetInteger(0, CHART_COLOR_CHART_UP, C'70,255,70');
      ChartSetInteger(0, CHART_COLOR_CHART_DOWN, C'255,69,70');
      ChartSetInteger(0, CHART_COLOR_CANDLE_BULL, clrDarkGreen);
      ChartSetInteger(0, CHART_COLOR_CANDLE_BEAR, C'89,37,41');
      ChartSetInteger(0, CHART_COLOR_CHART_LINE, clrYellow);
      ChartSetInteger(0, CHART_COLOR_VOLUME, clrGreen);
      ChartSetInteger(0, CHART_COLOR_ASK, clrOrangeRed);
      ChartSetInteger(0, CHART_COLOR_STOP_LEVEL, clrOrangeRed);
     }
   return INIT_SUCCEEDED;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  }

//+-------------------------------------------------------------------------------------------------------------------------------------------------+
//| Функция проверяет наличие сигнала                                                                                                               |
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
void CheckSignalExist(int type)
  {
//var
   bool   boolImpBuy = false,
          boolImpSell = false,
          boolMABuy = false,
          boolMASell = false,
          boolRSIBuy = false,
          boolRSISell = false,
          boolStochBuy = false,
          boolStochSell = false;
//---BUY---
   if(type == OP_BUY)
     {
      //Impulse signal
      if(checkInImpulse == 1)
        {
         double open = iOpen(_Symbol, PERIOD_CURRENT, 1),
                close = iClose(_Symbol, PERIOD_CURRENT, 1),
                candleSize = 0;
         candleSize = MathAbs(open - close) / _Point;
         if(minCandleSize <= candleSize && candleSize <= maxCandleSize)
           {
            if(directionSignal == 1)
              {
               if(open < close)
                 {
                  boolImpBuy = true;
                 }
              }
            else
               if(directionSignal == 2)
                 {
                  if(open > close)
                    {
                     boolImpBuy = true;
                    }
                 }
           }
        }
      else
         if(checkInImpulse == 0)
           {
            boolImpBuy = true;
           }
      //MA signal
      if(checkInMA == 1)
        {
         double ma = 0;
         ma = iMA(NULL, 0, MovingPeriod, MovingShift, MovingMethod, MovingAppliedPrice, 0);
         if(directionSignal == 1)
           {
            if(checkInMAMethod == 0)
              {
               if(Ask > ma)
                 {
                  boolMABuy = true;
                 }
              }
            else
               if(checkInMAMethod == 1)
                 {
                  if(Open[1] < ma && Close[1] > ma)
                    {
                     boolMABuy = true;
                    }
                 }
           }
         else
            if(directionSignal == 2)
              {
               if(checkInMAMethod == 0)
                 {
                  if(Ask < ma)
                    {
                     boolMABuy = true;
                    }
                 }
               else
                  if(checkInMAMethod == 1)
                    {
                     if(Open[1] > ma && Close[1] < ma)
                       {
                        boolMABuy = true;
                       }
                    }
              }
        }
      else
         if(checkInMA == 0)
           {
            boolMABuy = true;
           }
      //RSI signal
      if(checkInRSI == 1)
        {
         double rsi, rsi1 = 0;
         rsi = iRSI(NULL, 0, RSIPeriod, RSIAppliedPrice, 0);
         rsi1 = iRSI(NULL, 0, RSIPeriod, RSIAppliedPrice, 1);
         if(directionSignal == 1)
           {
            if(checkInRSIMethod == 0)
              {
               if(rsi < RSILowLevel)
                 {
                  boolRSIBuy = true;
                 }
              }
            else
               if(checkInRSIMethod == 1)
                 {
                  if((rsi >= RSILowLevel) && (rsi1 < RSILowLevel))
                    {
                     boolRSIBuy = true;
                    }
                 }
           }
         else
            if(directionSignal == 2)
              {
               if(checkInRSIMethod == 0)
                 {
                  if(rsi > RSIHighLevel)
                    {
                     boolRSIBuy = true;
                    }
                 }
               else
                  if(checkInRSIMethod == 1)
                    {
                     if((rsi <= RSIHighLevel) && (rsi1 > RSIHighLevel))
                       {
                        boolRSIBuy = true;
                       }
                    }
              }
        }
      else
         if(checkInRSI == 0)
           {
            boolRSIBuy = true;
           }
      //Stochastic signal
      if(checkInStoch == 1)
        {
         double mainLine1, mainLine2,
                signLine1, signLine2;
         mainLine1 = iStochastic(NULL, 0, stochPeriodK, stochPeriodD, stochSlowing, stochMethod, stochAppliedPrice, MODE_MAIN, 0);
         mainLine2 = iStochastic(NULL, 0, stochPeriodK, stochPeriodD, stochSlowing, stochMethod, stochAppliedPrice, MODE_MAIN, 1);
         signLine1 = iStochastic(NULL, 0, stochPeriodK, stochPeriodD, stochSlowing, stochMethod, stochAppliedPrice, MODE_SIGNAL, 0);
         signLine2 = iStochastic(NULL, 0, stochPeriodK, stochPeriodD, stochSlowing, stochMethod, stochAppliedPrice, MODE_SIGNAL, 1);
         if(directionSignal == 1)
           {
            if(checkInStoch == 0)
              {
               if(mainLine1 < stochLowLevel && signLine1 < stochLowLevel)
                 {
                  boolStochBuy = true;
                 }
              }
            else
               if(checkInStoch == 1)
                 {
                  if(mainLine1 > signLine1 && mainLine2 < signLine2 && mainLine1 < stochLowLevel && mainLine2 < stochLowLevel && signLine1 < stochLowLevel && signLine2 < stochLowLevel)
                    {
                     boolStochBuy = true;
                    }
                 }
           }
         else
            if(directionSignal == 2)
              {
               if(checkInStoch == 0)
                 {
                  if(mainLine1 > stochHighLevel && signLine1 > stochHighLevel)
                    {
                     boolStochBuy = true;
                    }
                 }
               else
                  if(checkInStoch == 1)
                    {
                     if(mainLine1 < signLine1 && mainLine2 > signLine2 && mainLine1 > stochHighLevel && mainLine2 > stochHighLevel && signLine1 > stochHighLevel && signLine2 > stochHighLevel)
                       {
                        boolStochBuy = true;
                       }
                    }
              }
        }
      else
         if(checkInStoch == 0)
           {
            boolStochBuy = true;
           }
      //result
      allowOpenBuy = boolImpBuy && boolMABuy && boolRSIBuy && boolStochBuy;
     }
//---SELL---
   if(type == OP_SELL)
     {
      //Impulse signal
      if(checkInImpulse == 1)
        {
         double open = iOpen(_Symbol, PERIOD_CURRENT, 1),
                close = iClose(_Symbol, PERIOD_CURRENT, 1),
                candleSize = 0;
         candleSize = MathAbs(open - close) / _Point;
         if(minCandleSize <= candleSize && candleSize <= maxCandleSize)
           {
            if(directionSignal == 1)
              {
               if(open > close)
                 {
                  boolImpSell = true;
                 }
              }
            else
               if(directionSignal == 2)
                 {
                  if(open < close)
                    {
                     boolImpSell = true;
                    }
                 }
           }
        }
      else
         if(checkInImpulse == 0)
           {
            boolImpSell = true;
           }
      //MA signal
      if(checkInMA == 1)
        {
         double ma = 0;
         ma = iMA(NULL, 0, MovingPeriod, MovingShift, MovingMethod, MovingAppliedPrice, 0);
         if(directionSignal == 1)
           {
            if(checkInMAMethod == 0)
              {
               if(Bid < ma)
                 {
                  boolMASell = true;
                 }
              }
            else
               if(checkInMAMethod == 1)
                 {
                  if(Open[1] > ma && Close[1] < ma)
                    {
                     boolMASell = true;
                    }
                 }
           }
         else
            if(directionSignal == 2)
              {
               if(checkInMAMethod == 0)
                 {
                  if(Bid > ma)
                    {
                     boolMASell = true;
                    }
                 }
               else
                  if(checkInMAMethod == 1)
                    {
                     if(Open[1] < ma && Close[1] > ma)
                       {
                        boolMASell = true;
                       }
                    }
              }
        }
      else
         if(checkInMA == 0)
           {
            boolMASell = true;
           }
      //RSI signal
      if(checkInRSI == 1)
        {
         double rsi, rsi1 = 0;
         rsi = iRSI(NULL, 0, RSIPeriod, RSIAppliedPrice, 0);
         rsi1 = iRSI(NULL, 0, RSIPeriod, RSIAppliedPrice, 1);
         if(directionSignal == 1)
           {
            if(checkInRSIMethod == 0)
              {
               if(rsi > RSIHighLevel)
                 {
                  boolRSISell = true;
                 }
              }
            else
               if(checkInRSIMethod == 1)
                 {
                  if((rsi <= RSIHighLevel) && (rsi1 > RSIHighLevel))
                    {
                     boolRSISell = true;
                    }
                 }
           }
         else
            if(directionSignal == 2)
              {
               if(checkInRSIMethod == 0)
                 {
                  if(rsi < RSILowLevel)
                    {
                     boolRSISell = true;
                    }
                 }
               else
                  if(checkInRSIMethod == 1)
                    {
                     if((rsi >= RSILowLevel) && (rsi1 < RSILowLevel))
                       {
                        boolRSISell = true;
                       }
                    }
              }
        }
      else
         if(checkInRSI == 0)
           {
            boolRSISell = true;
           }
      //Stochastic signal
      if(checkInStoch == 1)
        {
         double mainLine1, mainLine2,
                signLine1, signLine2;
         mainLine1 = iStochastic(NULL, 0, stochPeriodK, stochPeriodD, stochSlowing, stochMethod, stochAppliedPrice, MODE_MAIN, 0);
         mainLine2 = iStochastic(NULL, 0, stochPeriodK, stochPeriodD, stochSlowing, stochMethod, stochAppliedPrice, MODE_MAIN, 1);
         signLine1 = iStochastic(NULL, 0, stochPeriodK, stochPeriodD, stochSlowing, stochMethod, stochAppliedPrice, MODE_SIGNAL, 0);
         signLine2 = iStochastic(NULL, 0, stochPeriodK, stochPeriodD, stochSlowing, stochMethod, stochAppliedPrice, MODE_SIGNAL, 1);
         if(directionSignal == 1)
           {
            if(checkInStoch == 0)
              {
               if(mainLine1 > stochHighLevel && signLine1 > stochHighLevel)
                 {
                  boolStochSell = true;
                 }
              }
            else
               if(checkInStoch == 1)
                 {
                  if(mainLine1 < signLine1 && mainLine2 > signLine2 && mainLine1 > stochHighLevel && mainLine2 > stochHighLevel && signLine1 > stochHighLevel && signLine2 > stochHighLevel)
                    {
                     boolStochSell = true;
                    }
                 }
           }
         else
            if(directionSignal == 2)
              {
               if(checkInStoch == 0)
                 {
                  if(mainLine1 < stochLowLevel && signLine1 < stochLowLevel)
                    {
                     boolStochSell = true;
                    }
                 }
               else
                  if(checkInStoch == 1)
                    {
                     if(mainLine1 > signLine1 && mainLine2 < signLine2 && mainLine1 < stochLowLevel && mainLine2 < stochLowLevel && signLine1 < stochLowLevel && signLine2 < stochLowLevel)
                       {
                        boolStochSell = true;
                       }
                    }
              }
        }
      else
         if(checkInStoch == 0)
           {
            boolStochSell = true;
           }
      //result
      allowOpenSell = boolImpSell && boolMASell && boolRSISell && boolStochSell;
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void showTakeFunc(int type)
  {
   if(type == OP_BUY)
     {
      if(ObjectCreate(ChartID(), "take_buy", OBJ_HLINE, 0, 0, tkProfitBuy))
        {
         ObjectSet("take_buy", OBJPROP_COLOR, showTakeColor);
         ObjectSet("take_buy", OBJPROP_WIDTH, 1);
         ObjectSet("take_buy", OBJPROP_STYLE, showTakeStyle);
        }
      else
        {
         ObjectMove(ChartID(), "take_buy", 0, 0, tkProfitBuy);
        }
     }
   else
      if(type == OP_SELL)
        {
         if(ObjectCreate(ChartID(), "take_sell", OBJ_HLINE, 0, 0, tkProfitSell))
           {
            ObjectSet("take_sell", OBJPROP_COLOR, showTakeColor);
            ObjectSet("take_sell", OBJPROP_WIDTH, 1);
            ObjectSet("take_sell", OBJPROP_STYLE, showTakeStyle);
           }
         else
           {
            ObjectMove(ChartID(), "take_sell", 0, 0, tkProfitSell);
           }
        }
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetZeroLevel(int type)
  {
   int count = 0;
   double lots = 0;
   double sum = 0;
   double sum1 = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
         if((OrderSymbol() == _Symbol) && (OrderMagicNumber() == magic) && (OrderType() == type))
           {
            lots = lots + OrderLots();
            sum = sum + OrderLots() * OrderOpenPrice();
            sum1 = sum1 + OrderProfit() + OrderSwap() + OrderCommission();
            count++;
           }
     }
   double zeroprice = 0;
   if(lots != 0)
      zeroprice = sum / lots;
   zeroprice = (MathRound(zeroprice * MathPow(10, Digits))) / MathPow(10, Digits);
   return(zeroprice);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CalculateTake(int type)
  {
   if(type == OP_BUY)
     {
      if(countLvlBuy > 0)
        {
         if(countLvlBuy < profitStepStop)
           {
            int profitStepDecrBuy = 0;
            int profitStepDecrBuy2 = 0;
            double profitGridDecrBuy = 0;
            if((countLvlBuy >= profitStepDecr1) && profitStepDecr1 > 0)
              {
               profitStepDecrBuy = profitStepDecr2 * (countLvlBuy - profitStepDecr1 + 1);
              }
            if((countLvlBuy >= profitStepDecr3) && profitStepDecr3 > 0)
              {
               profitStepDecrBuy2 = (profitStepDecr4 * (countLvlBuy - profitStepDecr3 + 1)) + (profitStepDecr2 * (countLvlBuy - profitStepDecr3 + 1));
              }
            if((gridCheckContr2 == 1) && ((countLvlBuy > 1)))
              {
               profitGridDecrBuy = (MathCeil(MathAbs((GetFirstOpenPrice(OP_BUY) - GetLastOpenPrice(OP_BUY))  / Point)) - (gridStep * (countLvlBuy - 1)));
              }
            tkProfitBuyInfo = profitInCurr + (profitStep * (countLvlBuy - 1)) - profitStepDecrBuy - profitStepDecrBuy2 - profitGridDecrBuy;
            tkProfitBuy = GetLastOpenPrice(OP_BUY) + (tkProfitBuyInfo * _Point);
           }
         else
           {
            tkProfitBuy = GetZeroLevel(OP_BUY);
            tkProfitBuyInfo = (tkProfitBuy - GetLastOpenPrice(OP_BUY)) / _Point;
           }
        }
      if(showTake == 1)
        {
         showTakeFunc(OP_BUY);
        }
     }
   else
      if(type == OP_SELL)
        {
         if(countLvlSell > 0)
           {
            if(countLvlSell < profitStepStop)
              {
               int profitStepDecrSell = 0;
               int profitStepDecrSell2 = 0;
               double profitGridDecrSell = 0;
               if((countLvlSell >= profitStepDecr1) && profitStepDecr1 > 0)
                 {
                  profitStepDecrSell = profitStepDecr2 * (countLvlSell - profitStepDecr1 + 1);
                 }
               if((countLvlSell >= profitStepDecr3) && profitStepDecr3 > 0)
                 {
                  profitStepDecrSell2 = (profitStepDecr4 * (countLvlSell - profitStepDecr3 + 1)) + (profitStepDecr2 * (countLvlSell - profitStepDecr3 + 1));
                 }
               if((gridCheckContr2 == 1) && ((countLvlSell > 1)))
                 {
                  profitGridDecrSell = (MathCeil(MathAbs((GetFirstOpenPrice(OP_SELL) - GetLastOpenPrice(OP_SELL) / Point))) - (gridStep * (countLvlSell - 1)));
                 }
               tkProfitSellInfo = profitInCurr + (profitStep * (countLvlSell - 1)) - profitStepDecrSell - profitStepDecrSell2 - profitGridDecrSell;
               tkProfitSell = GetLastOpenPrice(OP_SELL) - (tkProfitSellInfo * _Point);
              }
            else
              {
               tkProfitSell = GetZeroLevel(OP_SELL);
               tkProfitSellInfo = (tkProfitSell - GetLastOpenPrice(OP_SELL)) / _Point;
              }
           }
         if(showTake == 1)
           {
            showTakeFunc(OP_SELL);
           }
        }
  }
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
//| Функция проверяет профит открытых позиций                                                                                                       |
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
void CheckPositionsProfit()
  {
   if(takeProfitMethod == 1)
     {
      double buyProfit = 0;
      double sellProfit = 0;
      for(int i = OrdersTotal() - 1; i >= 0; i--)
        {
         if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
           {
            if(OrderSymbol() == _Symbol)
              {
               if(OrderMagicNumber() == magic)
                 {
                  if(OrderType() == OP_BUY)
                     buyProfit = buyProfit + OrderProfit() + OrderSwap() + OrderCommission();
                 }
              }
           }
        }
      if(buyProfit >= profitInCurr)
        {
         ClosePosition(OP_BUY);
        }
      for(int i = OrdersTotal() - 1; i >= 0; i--)
        {
         if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
           {
            if(OrderSymbol() == _Symbol)
              {
               if(OrderMagicNumber() == magic)
                 {
                  if(OrderType() == OP_SELL)
                     sellProfit = sellProfit + OrderProfit() + OrderSwap() + OrderCommission();
                 }
              }
           }
        }
      if(sellProfit >= profitInCurr)
        {
         ClosePosition(OP_SELL);
        }
     }
//
   if(takeProfitMethod == 2)
     {
      if(Bid >= tkProfitBuy)
        {
         ClosePosition(OP_BUY);
        }
      if(Ask <= tkProfitSell)
        {
         ClosePosition(OP_SELL);
        }
     }
//
   if(takeProfitMethod == 3)
     {
      if(AccountBalance() + profitInCurr <= AccountEquity())
        {
         ClosePosition(OP_BUY);
         ClosePosition(OP_SELL);
        }
     }
//
   if(takeProfitMethod == 4)
     {
      if(((Bid -  GetLastOpenPrice(OP_BUY)) / Point) >= profitInCurr)
        {
         ClosePosition(OP_BUY);
        }
      if(((GetLastOpenPrice(OP_SELL) - Ask) / Point) >= profitInCurr)
        {
         ClosePosition(OP_SELL);
        }
     }
//
   if(takeProfitMethod == 5)
     {
      double buyProfit = 0;
      double sellProfit = 0;
      for(int i = OrdersTotal() - 1; i >= 0; i--)
        {
         if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
           {
            if(OrderSymbol() == _Symbol)
              {
               if(OrderMagicNumber() == magic)
                 {
                  if(OrderType() == OP_BUY)
                     buyProfit = buyProfit + ((Bid - OrderOpenPrice()) / Point);
                 }
              }
           }
        }
      if(buyProfit >= profitInCurr)
        {
         ClosePosition(OP_BUY);
        }
      for(int i = OrdersTotal() - 1; i >= 0; i--)
        {
         if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
           {
            if(OrderSymbol() == _Symbol)
              {
               if(OrderMagicNumber() == magic)
                 {
                  if(OrderType() == OP_SELL)
                     sellProfit = sellProfit + ((OrderOpenPrice() - Ask) / Point);
                 }
              }
           }
        }
      if(sellProfit >= profitInCurr)
        {
         ClosePosition(OP_SELL);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetLastVolume(int type)
  {
   double VolumeValue = 0;
   for(int i = 0; i < OrdersTotal(); i++)
      if(OrderSelect(i, SELECT_BY_POS))
         if(OrderSymbol() == _Symbol && OrderMagicNumber() == magic && OrderType() == type)
            VolumeValue = OrderLots();
   return VolumeValue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetLastVolume2(int type)
  {
   double VolumeValue = 0;
   for(int i = 0; i < OrdersTotal() - 1; i++)
      if(OrderSelect(i, SELECT_BY_POS))
         if(OrderSymbol() == _Symbol && OrderMagicNumber() == magic && OrderType() == type)
            VolumeValue = OrderLots();
   return VolumeValue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CheckVolumeValue(double newVolumeValue)
  {
//--- минимально допустимый объем для торговых операций
   double min_volume = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN);
   if(newVolumeValue < min_volume)
      return(min_volume);
//--- максимально допустимый объем для торговых операций
   double max_volume = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MAX);
   if(newVolumeValue > max_volume)
      return(max_volume);
   return(newVolumeValue);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CalculateLots(int type)
  {
   double NewLots = 0.0;
   if(DynamicLots == 1)
     {
      if(AccountFreeMargin() <= DepoForInc)
        {
         Lots = EarlyLots;
        }
      else
        {
         Lots = AccountFreeMargin() / DepoForInc * IncLots;
        }
     }
   else
     {
      Lots = fixVolume;
     }
//---
   NewLots = Lots;
//---
   if(CountPositionsNumber(type) >= 1)
     {
      if(volumeMethod == 1)
        {
         NewLots = Lots;
        }
      if(volumeMethod == 2)
        {
         NewLots = NormalizeDouble(GetLastVolume(type) * martinVolume, 2);
        }
      if(volumeMethod == 3)
        {
         NewLots = NormalizeDouble(GetLastVolume(type) + martinVolume, 2);
        }
      if(volumeMethod == 4)
        {
         NewLots = NormalizeDouble(GetLastVolume(type) + GetLastVolume2(type), 2);
        }
      if(CountPositionsNumber(type) < stepVolume)
        {
         NewLots = Lots;
        }
     }
   else
     {
      if(NewLots > maxFirstLots)
        {
         NewLots = maxFirstLots;
        }
     }
   NewLots = CheckVolumeValue(NewLots);
   return(NewLots);
  }

//+-------------------------------------------------------------------------------------------------------------------------------------------------+
//| Функция открывает позицию по текущей цене                                                                                                       |
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
void OpenPosition(int type)
  {
   double price = 0.0;
   double openVolume = 0;
   int ticket = 0;
   if(type == OP_BUY)
     {
      if((doubleOpenCandle == 0) && (LastBuyOpenTime == iTime("", 0, 0)))
        {
         return;
        }
      price = Ask;
      openVolume = CalculateLots(type);
     }
   if(type == OP_SELL)
     {
      if((doubleOpenCandle == 0) && (LastSellOpenTime == iTime("", 0, 0)))
        {
         return;
        }
      price = Bid;
      openVolume = CalculateLots(type);
     }
   ticket = OrderSend(_Symbol, type, openVolume, price, 0, 0, 0, "", magic, 0);
   if(ticket > 0)
     {
      if(type == OP_BUY)
        {
         allowOpenBuy = false;
         countLvlBuy++;
         LastBuyOpenTime = iTime("", 0, 0);
         if(takeProfitMethod == 2)
           {
            CalculateTake(OP_BUY);
           }
         if(infoAccExtra == 1)
           {
            summLotsBuy = SummLots(OP_BUY);
           }
        }
      if(type == OP_SELL)
        {
         allowOpenSell = false;
         countLvlSell++;
         LastSellOpenTime = iTime("", 0, 0);
         if(takeProfitMethod == 2)
           {
            CalculateTake(OP_SELL);
           }
         if(infoAccExtra == 1)
           {
            summLotsSell = SummLots(OP_SELL);
           }
        }
     }
   if(ticket < 0)
     {
      if(type == OP_BUY)
         Print("Позиция Buy не открылась, ошибка: ", GetLastError());
      if(type == OP_SELL)
         Print("Позиция Sell не открылась, ошибка: ", GetLastError());
     }
  }

//+-------------------------------------------------------------------------------------------------------------------------------------------------+
//| Функция закрывает позицию по текущей цене                                                                                                       |
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
void ClosePosition(int type)
  {
   if(type == OP_BUY)
     {
      for(int i = OrdersTotal() - 1; i >= 0; i--)
         if(OrderSelect(i, SELECT_BY_POS))
            if(OrderSymbol() == _Symbol && OrderMagicNumber() == magic)
               if(OrderType() == OP_BUY)
                  if(OrderClose(OrderTicket(), OrderLots(), Bid, 0))
                    {
                     partCloseBuyCheck = false;
                     tralCheckBuy = false;
                     countLvlBuy = 0;
                     tkProfitBuy = 0;
                     tkProfitBuyInfo = 0;
                     countClosedLvlBuy = 0;
                     summLotsBuy = 0;
                     tralPriceBuy = 0;
                     if(infoAcc == 1)
                       {
                        CheckAccountInfo();
                       }
                     if(ObjectFind(ChartID(), "take_buy") != -1)
                        if(!ObjectDelete(ChartID(), "take_buy"))
                          {
                           Print(__FUNCTION__, ": не удалось удалить горизонтальную линию! Код ошибки = ", GetLastError());
                          }
                     if(ObjectFind(ChartID(), "tral_buy") != -1)
                        if(!ObjectDelete(ChartID(), "tral_buy"))
                          {
                           Print(__FUNCTION__, ": не удалось удалить горизонтальную линию! Код ошибки = ", GetLastError());
                          }
                     if(ObjectFind(ChartID(), "stop_buy") != -1)
                        if(!ObjectDelete(ChartID(), "stop_buy"))
                          {
                           Print(__FUNCTION__, ": не удалось удалить горизонтальную линию! Код ошибки = ", GetLastError());
                          }
                    }
                  else
                    {
                     Print("Позиция Buy не закрылась, тикет: ", OrderTicket(), ", ошибка: ", GetLastError());
                    }
     }
   if(type == OP_SELL)
     {
      for(int i = OrdersTotal() - 1; i >= 0; i--)
         if(OrderSelect(i, SELECT_BY_POS))
            if(OrderSymbol() == _Symbol && OrderMagicNumber() == magic)
               if(OrderType() == OP_SELL)
                  if(OrderClose(OrderTicket(), OrderLots(), Ask, 0))
                    {
                     partCloseSellCheck = false;
                     tralCheckSell = false;
                     countLvlSell = 0;
                     tkProfitSell = 0;
                     tkProfitSellInfo = 0;
                     countClosedLvlSell = 0;
                     summLotsSell = 0;
                     tralPriceSell = 0;
                     if(infoAcc == 1)
                       {
                        CheckAccountInfo();
                       }
                     if(ObjectFind(ChartID(), "take_sell") != -1)
                        if(!ObjectDelete(ChartID(), "take_sell"))
                          {
                           Print(__FUNCTION__, ": не удалось удалить горизонтальную линию! Код ошибки = ", GetLastError());
                          }
                     if(ObjectFind(ChartID(), "tral_sell") != -1)
                        if(!ObjectDelete(ChartID(), "tral_sell"))
                          {
                           Print(__FUNCTION__, ": не удалось удалить горизонтальную линию! Код ошибки = ", GetLastError());
                          }
                     if(ObjectFind(ChartID(), "stop_sell") != -1)
                        if(!ObjectDelete(ChartID(), "stop_sell"))
                          {
                           Print(__FUNCTION__, ": не удалось удалить горизонтальную линию! Код ошибки = ", GetLastError());
                          }
                    }
                  else
                    {
                     Print("Позиция Sell не закрылась, тикет: ", OrderTicket(), ", ошибка: ", GetLastError());
                    }
     }
  }
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
//| Функция возвращает цену открытия последней позиции                                                                                              |
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
double GetLastOpenPrice(int type)
  {
   double price = 0;
   for(int i = 0; i < OrdersTotal(); i++)
      if(OrderSelect(i, SELECT_BY_POS))
         if(OrderSymbol() == _Symbol && OrderMagicNumber() == magic && OrderType() == type)
            price = OrderOpenPrice();
   return price;
  }
//+------------------------------------------------------------------+
//| Функция возвращает цену открытия последней позиции               |
//+------------------------------------------------------------------+
double GetFirstOpenPrice(int type)
  {
   double price = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
      if(OrderSelect(i, SELECT_BY_POS))
         if(OrderSymbol() == _Symbol && OrderMagicNumber() == magic && OrderType() == type)
            price = OrderOpenPrice();
   return price;
  }
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
//| Функция подсчитывает количество открытых позиций                                                                                                |
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
int CountPositionsNumber(int type)
  {
   int number = 0;
   for(int i = 0; i < OrdersTotal(); i++)
      if(OrderSelect(i, SELECT_BY_POS))
         if(OrderSymbol() == _Symbol && OrderMagicNumber() == magic && OrderType() == type)
            number++;
   return number;
  }
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
//|                                                                                                                                                 |
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
double SummLots(int type)
  {
   double summvar = 0.0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if((OrderSymbol() == _Symbol) && (OrderMagicNumber() == magic))
           {
            if(OrderType() == type)
               summvar = summvar + OrderLots();
           }
        }
     }
   return(summvar);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckAccountInfo()
  {
   string lvlStop = "";
   string lvlMarginCall = "";
   string extraInfo = "";
   if(AccountStopoutMode() == 0)
     {
      lvlMarginCall = ("Уровень маржин колл : " + DoubleToString(AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL), 0) + "%");
      lvlStop = ("Уровень стоп аута : " + IntegerToString(AccountStopoutLevel()) + "%");
     }
   else
     {
      lvlMarginCall = ("Уровень маржин колл : " + DoubleToString(AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL), 0) + " " + AccountCurrency());
      lvlStop = ("Уровень стоп аута : " + IntegerToString(AccountStopoutLevel()) + " " + AccountCurrency());
     }
   if((NormalizeDouble(AccountInfoDouble(ACCOUNT_MARGIN_LEVEL), 2) < MinMarginLevel) && (NormalizeDouble(AccountInfoDouble(ACCOUNT_MARGIN_LEVEL), 2) != 0))
     {
      MinMarginLevel = NormalizeDouble(AccountInfoDouble(ACCOUNT_MARGIN_LEVEL), 2);
     }
   else
      if(MinMarginLevel == 0)
        {
         MinMarginLevel = NormalizeDouble(AccountInfoDouble(ACCOUNT_MARGIN_LEVEL), 2);
        }
   if(infoAccExtra == 1)
     {
      extraInfo = "   \n ------------------------------------------------------------------" +
                  "   \n  Покупки:" +
                  "   \n     Шаг : " + DoubleToStr(countLvlBuy, 0) +
                  "   \n     Тейк : " + DoubleToStr(tkProfitBuyInfo, 0) +
                  "   \n     Общий объём : " + DoubleToStr(summLotsBuy, 2) +
                  "   \n  Продажи:" +
                  "   \n     Шаг : " + DoubleToStr(countLvlSell, 0) +
                  "   \n     Тейк : " + DoubleToStr(tkProfitSellInfo, 0) +
                  "   \n     Общий объём : " + DoubleToStr(summLotsSell, 2);
     }
   else
     {
      extraInfo = "";
     }
   Comment("   \n ------------------------------------------------------------------",
           "   \n                             CupCup                                ",
           "   \n ------------------------------------------------------------------",
           "   \n  Серверное время: ", TimeToStr(TimeCurrent(), TIME_DATE | TIME_SECONDS),
           "   \n ------------------------------------------------------------------",
           "   \n  Компания: ", TerminalCompany(),
           "   \n  Номер счёта: ", DoubleToStr(AccountNumber(), 0),
           "   \n ------------------------------------------------------------------",
           "   \n  Кредитное плечо : 1 к ", DoubleToStr(AccountLeverage(), 0),
           "   \n  Задействованная маржа : ", DoubleToStr(AccountMargin(), 2), " ", AccountCurrency(),
           "   \n  Свободная маржа : ", DoubleToStr(AccountFreeMargin(), 2), " ", AccountCurrency(),
           "   \n  Уровень маржи = ", DoubleToString(AccountInfoDouble(ACCOUNT_MARGIN_LEVEL), 2), "%",
           "   \n  Минимальный уровень маржи = ", DoubleToString(MinMarginLevel, 2), "%",
           "   \n  ", lvlMarginCall,
           "   \n  ", lvlStop,
           extraInfo,
           "   \n ------------------------------------------------------------------",
           "   \n  Баланс : ", DoubleToStr(AccountBalance(), 2), " ", AccountCurrency(),
           "   \n  Средства : ", DoubleToStr(AccountEquity(), 2), " ", AccountCurrency(),
           "   \n  Прибыль : ", DoubleToStr(AccountProfit(), 2), " ", AccountCurrency());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SendPushMessage()
  {
   if((Hour() != lastPushMessageHour) && (DayOfWeek() != 0 || DayOfWeek() != 6))
     {
      if(PushMessage == 1) //common
        {
         if(AccountInfoDouble(ACCOUNT_MARGIN_LEVEL) < 2000)
           {
            SendNotification("Уровень маржи = " + DoubleToString(AccountInfoDouble(ACCOUNT_MARGIN_LEVEL), 2) + "%");
            lastPushMessageHour = Hour();
           }
        }
      if(PushMessage == 2) //important
        {
         if(AccountInfoDouble(ACCOUNT_MARGIN_LEVEL) < 1000)
           {
            SendNotification("Уровень маржи = " + DoubleToString(AccountInfoDouble(ACCOUNT_MARGIN_LEVEL), 2) + "%");
            lastPushMessageHour = Hour();
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckStopLoss(int type)
  {
   if(type == OP_BUY)
     {
      double dist = (GetLastOpenPrice(OP_BUY) - Bid) / _Point;
      showStopFunc(OP_BUY);
      if(stopLoss <= dist)
        {
         ClosePosition(OP_BUY);
        }
     }
   if(type == OP_SELL)
     {
      double dist = (Ask - GetLastOpenPrice(OP_SELL)) / _Point;
      showStopFunc(OP_SELL);
      if(stopLoss <= dist)
        {
         ClosePosition(OP_SELL);
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OpenPositionAVG(int type)
  {
   if((type == OP_BUY) && (countLvlBuy < maxOpenBuy))
     {
      if(areaAppSignal == 1)
        {
         double dist = (GetLastOpenPrice(OP_BUY) - Ask) / _Point;
         if((gridStep + (gridStepInc * (CountPositionsNumber(OP_BUY) - 1))) <= dist)
           {
            if(((gridCheckContr == 1) && (CountPositionsNumber(OP_SELL) == 1)) || ((gridCheckBigCandle == 1) && LastBuyAvgTime == iTime("", 0, 0)))
              {
               allowOpenBuy = false;
              }
            else
              {
               allowOpenBuy = true;
               LastBuyAvgTime = iTime("", 0, 0);
              }
           }
        }
      else
         if(areaAppSignal == 2)
           {
            double dist = (GetLastOpenPrice(OP_BUY) - Ask) / _Point;
            if((gridStep + (gridStepInc * (CountPositionsNumber(OP_BUY) - 1))) <= dist)
              {
               if(((gridCheckContr == 1) && (CountPositionsNumber(OP_SELL) == 1)) || ((gridCheckBigCandle == 1) && LastBuyAvgTime == iTime("", 0, 0)))
                 {
                  allowOpenBuy = false;
                 }
               else
                 {
                  CheckSignalExist(OP_BUY);
                  LastBuyAvgTime = iTime("", 0, 0);
                 }
              }
           }
     }
   if((type == OP_SELL) && (countLvlSell < maxOpenSell))
     {
      if(areaAppSignal == 1)
        {
         double dist = (Bid - GetLastOpenPrice(OP_SELL)) / _Point;
         if((gridStep + (gridStepInc * (CountPositionsNumber(OP_SELL) - 1))) <= dist)
           {
            if(((gridCheckContr == 1) && (CountPositionsNumber(OP_BUY) == 1)) || ((gridCheckBigCandle == 1) && LastSellAvgTime == iTime("", 0, 0)))
              {
               allowOpenSell = false;
              }
            else
              {
               allowOpenSell = true;
               LastSellAvgTime = iTime("", 0, 0);
              }
           }
        }
      else
         if(areaAppSignal == 2)
           {
            double dist = (Bid - GetLastOpenPrice(OP_SELL)) / _Point;
            if((gridStep + (gridStepInc * (CountPositionsNumber(OP_SELL) - 1))) <= dist)
              {
               if(((gridCheckContr == 1) && (CountPositionsNumber(OP_BUY) == 1)) || ((gridCheckBigCandle == 1) && LastSellAvgTime == iTime("", 0, 0)))
                 {
                  allowOpenSell = false;
                 }
               else
                 {
                  CheckSignalExist(OP_SELL);
                  LastSellAvgTime = iTime("", 0, 0);
                 }
              }
           }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GetFisrtLastTicket()
  {
   double lastPrise = 0;
   double BuyPriceMax = 0, BuyPriceMin = 0, SellPriceMin = 0, SellPriceMax = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
         if(OrderMagicNumber() == magic)
            if(OrderSymbol() == Symbol())
              {
               lastPrise = NormalizeDouble(OrderOpenPrice(), Digits());
               if(OrderType() == OP_BUY)
                 {
                  if(lastPrise > BuyPriceMax || BuyPriceMax == 0)
                    {
                     BuyPriceMax = lastPrise;
                     BuyMaxLot = NormalizeDouble(OrderLots(), 2);
                     BuyMaxProfit = OrderProfit();
                     BuyMaxTic = OrderTicket();
                    }
                  if(lastPrise < BuyPriceMin || BuyPriceMin == 0)
                    {
                     BuyPriceMin = lastPrise;
                     BuyMinLot = NormalizeDouble(OrderLots(), 2);
                     BuyMinProfit = OrderProfit();
                     BuyMinTic = OrderTicket();
                    }
                 }
               if(OrderType() == OP_SELL)
                 {
                  if(lastPrise > SellPriceMax || SellPriceMax == 0)
                    {
                     SellPriceMax = lastPrise;
                     SellMaxLot = NormalizeDouble(OrderLots(), 2);
                     SellMaxProfit = OrderProfit();
                     SellMaxTic = OrderTicket();
                    }
                  if(lastPrise < SellPriceMin || SellPriceMin == 0)
                    {
                     SellPriceMin = lastPrise;
                     SellMinLot = NormalizeDouble(OrderLots(), 2);
                     SellMinProfit = OrderProfit();
                     SellMinTic = OrderTicket();
                    }
                 }
              }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PartClosePosition()
  {
   if(partClose == 1)
     {
      if(partCloseMethod == 1)
        {
         if((countLvlBuy >= partCloseStep) && (countClosedLvlBuy < partCloseStepStop))
           {
            GetFisrtLastTicket();
            if((BuyMinProfit + BuyMaxProfit >= partCloseProfit) && (!tralCheckBuy))
              {
               if(OrderClose(BuyMaxTic, BuyMaxLot, Bid, slippage, clrRed))
                 {
                  BuyMaxTic = 0;
                  BuyMaxLot = 0;
                  BuyMaxProfit = 0;
                  countLvlBuy--;
                  partCloseBuyCheck = true;
                 }
               else
                 {
                  Print("Позиция Buy не закрылась, тикет: ", OrderTicket(), ", ошибка: ", GetLastError());
                 }
               if(OrderClose(BuyMinTic, BuyMinLot, Bid, slippage, clrRed))
                 {
                  BuyMinTic = 0;
                  BuyMinLot = 0;
                  BuyMinProfit = 0;
                  partCloseBuyCheck = true;
                  countClosedLvlBuy++;
                 }
               else
                 {
                  Print("Позиция Buy не закрылась, тикет: ", OrderTicket(), ", ошибка: ", GetLastError());
                 }
               if((takeProfitMethod == 2) && (partCloseTake == 1))
                 {
                  CalculateTake(OP_BUY);
                 }
              }
           }
         if((countLvlSell >= partCloseStep) && (countClosedLvlSell < partCloseStepStop))
           {
            GetFisrtLastTicket();
            if((SellMaxProfit + SellMinProfit >= partCloseProfit) && (!tralCheckSell))
              {
               if(OrderClose(SellMaxTic, SellMaxLot, Ask, slippage, clrRed))
                 {
                  SellMaxTic = 0;
                  SellMaxLot = 0;
                  SellMaxProfit = 0;
                  countLvlSell--;
                  partCloseSellCheck = true;
                 }
               else
                 {
                  Print("Позиция Sell не закрылась, тикет: ", OrderTicket(), ", ошибка: ", GetLastError());
                 }
               if(OrderClose(SellMinTic, SellMinLot, Ask, slippage, clrRed))
                 {
                  SellMinTic = 0;
                  SellMinLot = 0;
                  SellMinProfit = 0;
                  partCloseSellCheck = true;
                  countClosedLvlSell++;
                 }
               else
                 {
                  Print("Позиция Sell не закрылась, тикет: ", OrderTicket(), ", ошибка: ", GetLastError());
                 }
               if((takeProfitMethod == 2) && (partCloseTake == 1))
                 {
                  CalculateTake(OP_SELL);
                 }
              }
           }
        }
      else
         if(partCloseMethod == 2)
           {
            if((countLvlBuy >= partCloseStep) && (countClosedLvlBuy < partCloseStepStop))
              {
               GetFisrtLastTicket();
               if(((Bid -  GetLastOpenPrice(OP_BUY)) / Point) >= partCloseProfit)
                 {
                  if(OrderClose(BuyMaxTic, BuyMaxLot, Bid, slippage, clrRed))
                    {
                     BuyMaxTic = 0;
                     BuyMaxLot = 0;
                     BuyMaxProfit = 0;
                     countLvlBuy--;
                     partCloseBuyCheck = true;
                    }
                  else
                    {
                     Print("Позиция Buy не закрылась, тикет: ", OrderTicket(), ", ошибка: ", GetLastError());
                    }
                  if(OrderClose(BuyMinTic, BuyMinLot, Bid, slippage, clrRed))
                    {
                     BuyMinTic = 0;
                     BuyMinLot = 0;
                     BuyMinProfit = 0;
                     partCloseBuyCheck = true;
                     countClosedLvlBuy++;
                    }
                  else
                    {
                     Print("Позиция Buy не закрылась, тикет: ", OrderTicket(), ", ошибка: ", GetLastError());
                    }
                  if((takeProfitMethod == 2) && (partCloseTake == 1))
                    {
                     CalculateTake(OP_BUY);
                    }
                 }
              }
            if((countLvlSell >= partCloseStep) && (countClosedLvlSell < partCloseStepStop))
              {
               GetFisrtLastTicket();
               if(((GetLastOpenPrice(OP_SELL) - Ask) / Point) >= partCloseProfit)
                 {
                  if(OrderClose(SellMaxTic, SellMaxLot, Ask, slippage, clrRed))
                    {
                     SellMaxTic = 0;
                     SellMaxLot = 0;
                     SellMaxProfit = 0;
                     countLvlSell--;
                     partCloseSellCheck = true;
                    }
                  else
                    {
                     Print("Позиция Sell не закрылась, тикет: ", OrderTicket(), ", ошибка: ", GetLastError());
                    }
                  if(OrderClose(SellMinTic, SellMinLot, Ask, slippage, clrRed))
                    {
                     SellMinTic = 0;
                     SellMinLot = 0;
                     SellMinProfit = 0;
                     partCloseSellCheck = true;
                     countClosedLvlSell++;
                    }
                  else
                    {
                     Print("Позиция Sell не закрылась, тикет: ", OrderTicket(), ", ошибка: ", GetLastError());
                    }
                  if((takeProfitMethod == 2) && (partCloseTake == 1))
                    {
                     CalculateTake(OP_SELL);
                    }
                 }
              }
           }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void showTralFunc(int type)
  {
   if(type == OP_BUY)
     {
      if(ObjectCreate(ChartID(), "tral_buy", OBJ_HLINE, 0, 0, tralPriceBuy))
        {
         ObjectSet("tral_buy", OBJPROP_COLOR, showTralColor);
         ObjectSet("tral_buy", OBJPROP_WIDTH, 1);
         ObjectSet("tral_buy", OBJPROP_STYLE, showTralStyle);
        }
      else
        {
         ObjectMove(ChartID(), "tral_buy", 0, 0, tralPriceBuy);
        }
     }
   else
      if(type == OP_SELL)
        {
         if(ObjectCreate(ChartID(), "tral_sell", OBJ_HLINE, 0, 0, tralPriceSell))
           {
            ObjectSet("tral_sell", OBJPROP_COLOR, showTralColor);
            ObjectSet("tral_sell", OBJPROP_WIDTH, 1);
            ObjectSet("tral_sell", OBJPROP_STYLE, showTralStyle);
           }
         else
           {
            ObjectMove(ChartID(), "tral_sell", 0, 0, tralPriceSell);
           }
        }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void showStopFunc(int type)
  {
   if(type == OP_BUY)
     {
      if(ObjectCreate(ChartID(), "stop_buy", OBJ_HLINE, 0, 0, GetLastOpenPrice(OP_BUY) - stopLoss * _Point))
        {
         ObjectSet("stop_buy", OBJPROP_COLOR, showStopColor);
         ObjectSet("stop_buy", OBJPROP_WIDTH, 1);
         ObjectSet("stop_buy", OBJPROP_STYLE, showStopStyle);
        }
      else
        {
         ObjectMove(ChartID(), "stop_buy", 0, 0, GetLastOpenPrice(OP_BUY) - stopLoss * _Point);
        }
     }
   else
      if(type == OP_SELL)
        {
         if(ObjectCreate(ChartID(), "stop_sell", OBJ_HLINE, 0, 0, GetLastOpenPrice(OP_SELL) + stopLoss * _Point))
           {
            ObjectSet("stop_sell", OBJPROP_COLOR, showStopColor);
            ObjectSet("stop_sell", OBJPROP_WIDTH, 1);
            ObjectSet("stop_sell", OBJPROP_STYLE, showStopStyle);
           }
         else
           {
            ObjectMove(ChartID(), "stop_sell", 0, 0, GetLastOpenPrice(OP_SELL) + stopLoss * _Point);
           }
        }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckTral(int type)
  {
   if((CountPositionsNumber(OP_BUY) > 0) && (type == OP_BUY))
     {
      if(countLvlBuy >= tralBeginStep)
        {
         double dist = (Ask - GetLastOpenPrice(OP_BUY)) / _Point;
         if(tralDisc > dist)
           {
            tralCheckBuy = false;
           }
         else
           {
            tralCheckBuy = true;
           }
        }
     }
   if((CountPositionsNumber(OP_SELL) > 0) && (type == OP_SELL))
     {
      if(countLvlSell >= tralBeginStep)
        {
         double dist = (GetLastOpenPrice(OP_SELL) - Bid) / _Point;
         if(tralDisc > dist)
           {
            tralCheckSell = false;
           }
         else
           {
            tralCheckSell = true;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TrallingGo(int type)
  {
   if(type == OP_BUY)
     {
      double dist = (Bid - tralPriceBuy) / _Point;
      if((dist >= tralDisc) || (tralPriceBuy == 0))
        {
         tralPriceBuy = Bid - (tralDisc * _Point);
         if(tralWithTake == 1)
           {
            tkProfitBuy = tralPriceBuy + (tkProfitBuyInfo * _Point);
            if(showTake == 1)
               showTakeFunc(OP_BUY);
           }
        }
      if(showTral == 1)
        {
         showTralFunc(OP_BUY);
        }
     }
   if(type == OP_SELL)
     {
      double dist = (tralPriceSell - Ask) / _Point;
      if((dist >= tralDisc) || (tralPriceSell == 0))
        {
         tralPriceSell = Ask + (tralDisc * _Point);
         if(tralWithTake == 1)
           {
            tkProfitSell = tralPriceSell - (tkProfitSellInfo * _Point);
            if(showTake == 1)
               showTakeFunc(OP_SELL);
           }
        }
      if(showTral == 1)
        {
         showTralFunc(OP_SELL);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckTralProfit(int type)
  {
   double buyProfit = 0;
   double sellProfit = 0;
   if(type == OP_BUY)
     {
      if(Bid <= tralPriceBuy)
        {
         ClosePosition(OP_BUY);
        }
      if(tralNL == 1)
        {
         for(int i = OrdersTotal() - 1; i >= 0; i--)
           {
            if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
              {
               if(OrderSymbol() == _Symbol)
                 {
                  if(OrderMagicNumber() == magic)
                    {
                     if(OrderType() == OP_BUY)
                        buyProfit = buyProfit + OrderProfit() + OrderSwap() + OrderCommission();
                    }
                 }
              }
           }
         if(buyProfit <= tralNLCurrent)
           {
            ClosePosition(OP_BUY);
           }
        }
     }
   if(type == OP_SELL)
     {
      if(Ask >= tralPriceSell)
        {
         ClosePosition(OP_SELL);
        }
      if(tralNL == 1)
        {
         for(int i = OrdersTotal() - 1; i >= 0; i--)
           {
            if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
              {
               if(OrderSymbol() == _Symbol)
                 {
                  if(OrderMagicNumber() == magic)
                    {
                     if(OrderType() == OP_SELL)
                        sellProfit = sellProfit + OrderProfit() + OrderSwap() + OrderCommission();
                    }
                 }
              }
           }
         if(sellProfit <= tralNLCurrent)
           {
            ClosePosition(OP_SELL);
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick(void)
  {
//Check_input
   if((checkInImpulse == 0) && (checkInMA == 0) && (checkInRSI == 0) && (checkInStoch == 0))
     {
      return;
     }
//Check close position or tral
   if((CountPositionsNumber(OP_BUY) > 0) || (CountPositionsNumber(OP_SELL) > 0))
     {
      CheckPositionsProfit();
      PartClosePosition();
      //
      if(tralActive == 1)
        {
         if(tralCheckBuy)
           {
            TrallingGo(OP_BUY);
            CheckTralProfit(OP_BUY);
           }
         else
            CheckTral(OP_BUY);
         if(tralCheckSell)
           {
            TrallingGo(OP_SELL);
            CheckTralProfit(OP_SELL);
           }
         else
            CheckTral(OP_SELL);
        }
     }
//Check signal exist
   if(CountPositionsNumber(OP_BUY) == 0)
     {
      CheckSignalExist(OP_BUY);
     }
   if(CountPositionsNumber(OP_SELL) == 0)
     {
      CheckSignalExist(OP_SELL);
     }
//Check Avg or StopLoss
   if(CountPositionsNumber(OP_BUY) > 0)
     {
      if(stopLossMethod == 1)
        {
         OpenPositionAVG(OP_BUY);
        }
      else
         if(stopLossMethod == 0)
           {
            CheckStopLoss(OP_BUY);
           }
     }
   if(CountPositionsNumber(OP_SELL) > 0)
     {
      if(stopLossMethod == 1)
        {
         OpenPositionAVG(OP_SELL);
        }
      else
         if(stopLossMethod == 0)
           {
            CheckStopLoss(OP_SELL);
           }
     }
//Open position first or avg
   if(allowOpenBuy)
      OpenPosition(OP_BUY);
   if(allowOpenSell)
      OpenPosition(OP_SELL);
//Push
   if(PushMessage != 0)
     {
      //SendPushMessage();
     }
//Info
   if((infoAcc == 1) && ((CountPositionsNumber(OP_BUY) > 0) || (CountPositionsNumber(OP_SELL) > 0)))
     {
      CheckAccountInfo();
     }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
