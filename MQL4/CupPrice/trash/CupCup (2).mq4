//+------------------------------------------------------------------+
//|                                                       CupCup.mq4 |
//|                                          Copyright 2021, Aleksei |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "CupCup"
#property link        "https://www.mql5.com"
#property version     "1.02" // Текущая версия эксперта  
#property description "CupCup"
#property description "Деньги Кап Кап"
#property description "Деньги Кап Кап"
#property description "Деньги Кап Кап"

#property strict

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
extern string delimiter0                  = "Настройки условия точки входа, открытия сделки";//_______________________________________________________________
extern int directionImpulse               = 1;    //Направление сделок (1-По импульсу, 2-Против импульса)
extern int minCandleSize                  = 200;  //Минимальный размер свечи (Включительно)
extern int maxCandleSize                  = 500;  //Максимальный размер свечи (Включительно)
extern string delimiter1                  = "Настройки усредняющей сетки";//_______________________________________________________________
extern int gridStep                       = 300;  //Шаг сетки
extern int gridStepInc                    = 0;    //Последующие увеличение сетки (в пипсах)
extern int gridCheckBigCandle             = 0;    //Не усреднять на одной свече, смещает усреднение (сетку)
extern int gridCheckContr                 = 0;    //Проверять наличие противоположного сигнала, смещает усреднение
extern int gridCheckContr2                = 0;    //Вычитать разницу смещения от тейка? (При фиксации прибыли 2)
extern string delimiter2                  = "Настройки объёмов сделки. Первой, либо фиксированной";//_______________________________________________________________
extern int DynamicLots                    = 1;    //Использовать динамичный лот (объем) (1 = Вкл, 0 = Выкл)
extern double fixVolume                   = 0.01; //Если (выкл), какой лот (объем) использовать?
extern double EarlyLots                   = 0.01; //Если (вкл), Начальный лот, далее увеличивается каждый "Шаг"
extern double IncLots                     = 0.01; //Если (вкл), На сколько увеличивать лот от свободной маржи
extern int DepoForInc                     = 1500; //Если (вкл), Шаг маржи при котором будет увеличиваться лот
extern string delimiter3                  = "Настройки работы с объемом сделок";//_______________________________________________________________
extern int volumeMethod                   = 2;    //Лотность (1-Фикс, 2-Мартин, 3-Щадящий Мартин, 4-Фибоначчи)
extern double martinVolume                = 1.6;  //Коэфицент умножения/прибавления по Мартину (при Лотности 2 и 3)
extern int stepVolume                     = 1;    //После какого шага увеличивать объём? (0 = Выкл)
extern string delimiter4                  = "Настройки фиксации прибыли, закрытия сделки";//_______________________________________________________________
extern int takeProfitMethod               = 2;    //Фикс(1-В валюте,2-Тейк,3-В общ прибыли,4-В пункт,5-В пункт общ)
extern int profitInCurr                   = 200;  //Прибыль (Тейкпрофит, Пункты, Пипсы, Сумма, Валюта, Прибыль)
extern int profitStep                     = 100;  //(При фиксации прибыли 2) Увеличение тейка с каждым шагом
extern int profitStepDecr1                = 5;    //(При фиксации прибыли 2) Шаг, на котором увеличение уменьшается
extern int profitStepDecr2                = 50;   //(При фикс прибыли 2) На сколько уменьшить прибавку тейка
extern int profitStepDecr3                = 8;    //(При фикс прибыли 2) Шаг, на котором увеличение ещё уменьшается
extern int profitStepDecr4                = 100;  //(При фикс прибыли 2) На сколько ещё уменьшить прибавку тейка
extern int profitStepStop                 = 10;   //(При фикс прибыли 2) Шаг, на котором закрывать безубыток
extern string delimiter5                  = "Настройки сопровождения сделок";//_______________________________________________________________
extern int partClose                      = 1;    //Частичное закрытие сетки (Перекрывает прибылью убытки)
extern int partCloseStep                  = 7;    //Шаг, с которого начнётся частичное закрытие
extern int partCloseStepStop              = 3;    //Шаг, до которого работает частичное закрытие
extern int partCloseMethod                = 1;    //Фиксация прибыли (1-В валюте, 2-В пунктах крайнего ордера)
extern int partCloseProfit                = 0;    //C какой прибылью закрывать сделки? (Валюта, Пункты, Пипсы)
extern int partCloseTake                  = 0;    //(При фикс прибыли 2) Оставлять тейк = 0, Пересчитывать = 1
extern string delimiter6                  = "Настройки дополнительных функций. Настройки интерфейса";//_______________________________________________________________
extern int showTake                       = 0;    //Отображать на графике тейкпрофит? (0-Выкл,1-Вкл)
extern ENUM_LINE_STYLE showTakeStyle      = 3;    //Стиль отображения тейкпрофита?
extern int chartColorsInput               = 0;    //Изменить цветовую схему графика? (0-Выкл,1-Светлая,2-Тёмная)
extern int infoAcc                        = 0;    //Показывать информацию об акаунте? (1-Вкл, 0-Выкл)
extern int infoAccExtra                   = 0;    //Показывать дополнительную информацию об акаунте? (1-Вкл, 0-Выкл)
extern int PushMessage                    = 0;    //Отправлять push-уведомления? (0-Выкл, 1-Вкл, 2-Только важные!)
extern string delimiter7                  = "Настройки магического числа. Отличительное число сделок советника";//_______________________________________________________________
extern int magic                          = 31052021; // Магическое число
extern int slippage                       = 50;       // Проскальзывание

bool   allowOpenBuy,
       allowOpenSell;

int BuyMaxTic = 0, BuyMinTic = 0, SellMaxTic = 0, SellMinTic = 0;
double BuyMaxLot = 0, BuyMinLot = 0, SellMaxLot = 0, SellMinLot = 0;
double BuyMaxProfit = 0, BuyMinProfit = 0, SellMaxProfit = 0, SellMinProfit = 0;

datetime LastBuyAvgTime, LastSellAvgTime;

double Lots = 0.01;

int countLvlBuy = 0;
int countLvlSell = 0;
int countClosedLvlBuy = 0;
int countClosedLvlSell = 0;

double summLotsSell, summLotsBuy = 0.0;

double tkProfitSell, tkProfitBuy = 0.0;
double tkProfitSellInfo, tkProfitBuyInfo = 0.0;

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
   if(AccountNumber() != 5886465)
      if(AccountNumber() != 5885448)
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
void CheckSignalExist(void)
  {
   if(CountPositionsNumber(OP_BUY) == 0)
     {
      double open = iOpen(_Symbol, PERIOD_CURRENT, 1),
             close = iClose(_Symbol, PERIOD_CURRENT, 1),
             candleSize = 0;
      candleSize = MathAbs(open - close) / _Point;
      if(minCandleSize <= candleSize && candleSize <= maxCandleSize)
        {
         if(open > close)
           {
            if(directionImpulse == 2)
              {
               allowOpenBuy = true;
              }
           }
         if(open < close)
           {
            if(directionImpulse == 1)
              {
               allowOpenBuy = true;
              }
           }
        }
     }
   if(CountPositionsNumber(OP_SELL) == 0)
     {
      double open = iOpen(_Symbol, PERIOD_CURRENT, 1),
             close = iClose(_Symbol, PERIOD_CURRENT, 1),
             candleSize = 0;
      candleSize = MathAbs(open - close) / _Point;
      if(minCandleSize <= candleSize && candleSize <= maxCandleSize)
        {
         if(open > close)
           {
            if(directionImpulse == 1)
              {
               allowOpenSell = true;
              }
           }
         if(open < close)
           {
            if(directionImpulse == 2)
              {
               allowOpenSell = true;
              }
           }
        }
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
         ObjectSet("take_buy", OBJPROP_COLOR, clrRed);
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
            ObjectSet("take_sell", OBJPROP_COLOR, clrRed);
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
void CalculateTake(int type)
  {
   if(type == OP_BUY)
     {
      if(countLvlBuy > 0)
        {
         int profitStepDecrBuy = 0;
         int profitStepDecrBuy2 = 0;
         double profitGridDecrBuy = 0;
         if(countLvlBuy >= profitStepDecr1)
           {
            profitStepDecrBuy = profitStepDecr2 * (countLvlBuy - profitStepDecr1 + 1);
           }
         if(countLvlBuy >= profitStepDecr3)
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
            int profitStepDecrSell = 0;
            int profitStepDecrSell2 = 0;
            double profitGridDecrSell = 0;
            if(countLvlSell >= profitStepDecr1)
              {
               profitStepDecrSell = profitStepDecr2 * (countLvlSell - profitStepDecr1 + 1);
              }
            if(countLvlSell >= profitStepDecr3)
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
      if(countLvlBuy < profitStepStop)
        {
         if(Bid >= tkProfitBuy)
           {
            ClosePosition(OP_BUY);
           }
        }
      else
        {
         double buyProfit = 0;
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
         if(buyProfit >= 0)
           {
            ClosePosition(OP_BUY);
           }
        }
      if(countLvlSell < profitStepStop)
        {
         if(Ask <= tkProfitSell)
           {
            ClosePosition(OP_SELL);
           }
        }
      else
        {
         double sellProfit = 0;
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
         if(sellProfit >= 0)
           {
            ClosePosition(OP_SELL);
           }
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
      price = Ask;
      openVolume = CalculateLots(type);
     }
   if(type == OP_SELL)
     {
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
         if(takeProfitMethod == 2)
           {
            CalculateTake(OP_SELL);
           }
         if(infoAccExtra == 1)
           {
            summLotsSell =  SummLots(OP_SELL);
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
                     countLvlBuy = 0;
                     tkProfitBuy = 0;
                     tkProfitBuyInfo = 0;
                     countClosedLvlBuy = 0;
                     summLotsBuy = 0;
                     if(infoAcc == 1)
                       {
                        CheckAccountInfo();
                       }
                     if(ObjectFind(ChartID(), "take_buy") != -1)
                        if(!ObjectDelete(ChartID(), "take_buy"))
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
                     countLvlSell = 0;
                     tkProfitSell = 0;
                     tkProfitSellInfo = 0;
                     countClosedLvlSell = 0;
                     summLotsSell = 0;
                     if(infoAcc == 1)
                       {
                        CheckAccountInfo();
                       }
                     if(ObjectFind(ChartID(), "take_sell") != -1)
                        if(!ObjectDelete(ChartID(), "take_sell"))
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
      if(PushMessage == 1)
        {
         if(AccountInfoDouble(ACCOUNT_MARGIN_LEVEL) < 2000)
           {
            SendNotification("Уровень маржи = " + DoubleToString(AccountInfoDouble(ACCOUNT_MARGIN_LEVEL), 2) + "%");
            lastPushMessageHour = Hour();
           }
        }
      if(PushMessage == 2)
        {
         if(AccountInfoDouble(ACCOUNT_MARGIN_LEVEL) < 2000)
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
void OpenPositionAVG()
  {
   if(CountPositionsNumber(OP_BUY) > 0)
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
   if(CountPositionsNumber(OP_SELL) > 0)
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
         if((countLvlBuy >= partCloseStep) && (countClosedLvlBuy <= partCloseStepStop))
           {
            GetFisrtLastTicket();
            if(BuyMinProfit + BuyMaxProfit >= partCloseProfit)
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
         if((countLvlSell >= partCloseStep) && (countClosedLvlSell <= partCloseStepStop))
           {
            GetFisrtLastTicket();
            if(SellMaxProfit + SellMinProfit >= partCloseProfit)
              {
               if(OrderClose(SellMaxTic, SellMaxLot, Bid, slippage, clrRed))
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
               if(OrderClose(SellMinTic, SellMinLot, Bid, slippage, clrRed))
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
            if((countLvlBuy >= partCloseStep) && (countClosedLvlBuy <= partCloseStepStop))
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
            if((countLvlSell >= partCloseStep) && (countClosedLvlSell <= partCloseStepStop))
              {
               GetFisrtLastTicket();
               if(((GetLastOpenPrice(OP_SELL) - Ask) / Point) >= partCloseProfit)
                 {
                  if(OrderClose(SellMaxTic, SellMaxLot, Bid, slippage, clrRed))
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
                  if(OrderClose(SellMinTic, SellMinLot, Bid, slippage, clrRed))
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
void OnTick(void)
  {
//
   if((CountPositionsNumber(OP_BUY) > 0) || (CountPositionsNumber(OP_SELL) > 0))
     {
      CheckPositionsProfit();
      PartClosePosition();
     }
//
   CheckSignalExist();
   if(allowOpenBuy)
      OpenPosition(OP_BUY);
   if(allowOpenSell)
      OpenPosition(OP_SELL);
//
   OpenPositionAVG();
//
   if(PushMessage != 0)
     {
      SendPushMessage();
     }
//
   if((infoAcc == 1) && ((CountPositionsNumber(OP_BUY) > 0) || (CountPositionsNumber(OP_SELL) > 0)))
     {
      CheckAccountInfo();
     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
