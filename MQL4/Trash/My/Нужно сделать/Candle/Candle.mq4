//+------------------------------------------------------------------+
//|                                                       Candle.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Candle"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern int     Magic = 10012;                 //Магический номер для одновременной торговли на разных парах
extern double   Lots = 0.1;                   //Фиксированный лот
extern bool     MM = false;                   //Включение ММ
extern double   MMRisk = 0.03;                //Риск-фактор, процент депозита при расчёте лота
extern bool     UseTime       = false;        //Использовать время да/нет
extern string   TimeStart  = "08:00";         //Время начала торговли
extern string   TimeEnd    = "15:00";         //Время окончания торговли
extern int      StopLoss = 40;                //Стоплосс, 0-без стоплосса
extern int      TakeProfit = 70;              //Тейкпрофит,0-без тейкпрофита
extern bool     Tral = false;                    //Трейлинг-стоп вкл/выкл
extern int      TralStartLevel = 30;           //Профит включения трейлинг-стопа
extern int      TralStop = 40;                  //Уровень трейлинг-стопа
extern bool     DrawInfo = false;                //Вывод информации-комментариев на график вкл/выкл

extern string C12 = "----------  Candles -------------";
extern bool Hammer = true; //Молот
extern bool HangingMan = true; //Повешенный
extern bool Engulfing = true; //Модель Поглощения
extern bool MorningStar = true; //Утренняя звезда
extern bool EveningStar = true; //Вечерняя звезда
extern bool DarkCloudCover = true; //Завеса из темных облаков
extern bool Piercing = true; //Просвет в облаках
extern bool ShootingStar = true; //Падающая Звезда
extern bool InvertedHammer = true; //Перевернутый Молот
extern bool Harami = true; //Харами
extern bool Tweezer = true; //Вершины и Основания "Пинцет"
extern bool BeltHoldLine = true; //Захват за пояс
extern bool UpsideGapTwoCrows = true; //Две взлетевшие вороны
extern bool ThreeCrows = true; //Три вороны
extern bool MatHoldPattern = true; //Удержание на татами
extern bool CounterattackLines = true; //Контратака
extern bool SeparatingLines = true; //Разделение
extern bool GravestoneDoji = true; //Доджи-надгробие
extern bool LongLeggedDoji = true; //Длинноногий доджи
extern bool Doji = true; //Доджи (Харами крест)
extern bool TasukiGap = true; //Разрыв тасуки
extern bool SideBySideWhite = true; //Смежные белые свечи
extern bool ThreeMethods = true; //Три метода
extern bool Gap = true; //Окно
extern bool ThreeWhiteSoldiers = true; //Три белых солдата
extern bool AdvanceBlock = true; //Отбитое наступление
extern bool StalledPattern = true; //Торможение
extern bool ThreeLineStrike = true; //Тройной удар
extern bool OnNeckLine = true; //У линии шеи

bool  UseSound  = true;  // Использовать звуковой сигнал да/нет
int  MaxTries = 5, Dec, LastOrderType = 0;
int   i, cnt = 0, ticket, mode = 0, total, digit = 0, OrderToday = 0;
double  Lotsi = 0.0, spread;
long LastVol;
string  name = "CandleBot";
string SoundSuccess   = "alert.wav";      // Звук успеха
string SoundError     = "timeout.wav";    // Звук ошибки
double BuyProfit = 0, SellProfit = 0, BuyPrice, SellPrice, BuyStop, SellStop, LastOrderLot, LastOrderBuyPrice, LastOrderSellPrice;
datetime t1, t2, t3;
bool CloseStop = false;
string TralOn = "Off";
string Text;
int CandleBuy = 0, CBuy = 0;
int CandleSell = 0, CSell = 0;
bool CheakResult = false;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   return INIT_SUCCEEDED;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   t1 = StrToTime(TimeToStr(TimeCurrent(), TIME_DATE) + " " + TimeStart);
   t2 = StrToTime(TimeToStr(TimeCurrent(), TIME_DATE) + " " + TimeEnd);
   digit = Digits;
   if(digit == 5 || digit == 3)
      Dec = 10;
   if(digit == 4 || digit == 2)
      Dec = 1;
   Lotsi = Lots;
   if(MM)
      Lotsi = NormalizeDouble(AccountBalance() * MMRisk / 100, 2);
   if(Lotsi < MarketInfo(Symbol(), MODE_MINLOT))
      Lotsi = MarketInfo(Symbol(), MODE_MINLOT);
   spread = MarketInfo(Symbol(), MODE_SPREAD);
   if(DrawInfo)
     {
      Comment(" ",
              "   \n------------------------------------------------------------------",
              "   \nAccountNumber : ", DoubleToStr(AccountNumber(), 0),
              "   \n", TerminalCompany(),
              "   \nCurrent Server Time : " + TimeToStr(TimeCurrent(), TIME_DATE | TIME_SECONDS),
              "   \n------------------------------------------------------------------",
              "   \nLot = ", DoubleToStr(Lotsi, 2), " / Take = ", DoubleToStr(TakeProfit, 0),
              "   \nWorkTime = ", TimeStart, " - ", TimeEnd, " / Stop = ", DoubleToStr(StopLoss, 0),
              "   \nCurrent spread = ", spread,
              "   \nMinLot on symbol = ", DoubleToStr(MarketInfo(Symbol(), MODE_MINLOT), 2), " / Tral - ", TralOn,
              "   \n------------------------------------------------------------------");
     }
   if(Tral)
     {
      TralOn = "On";
      TrailStops();
     }
   if(Volume[0] <= 10 && (Volume[0] < LastVol || Volume[0] == 1))
     {
      Text = " ";
      CandleBuy = -1;
      CBuy = -1;
      CandleSell = -1;
      CSell = -1;
      Condition(0);
      if(HangingMan && Text == "Повешенный")
        {
         CSell = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(Hammer && Text == "Молот")
        {
         CBuy = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(MorningStar && Text == "Утренняя звезда")
        {
         CBuy = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(EveningStar && Text == "Вечерняя звезда")
        {
         CSell = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(Engulfing && Text == "Поглощение" && CandleBuy > 0)
        {
         CBuy = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(Engulfing && Text == "Поглощение" && CandleSell > 0)
        {
         CSell = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(DarkCloudCover && Text == "Завеса из облаков")
        {
         CSell = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(Piercing && Text == "Просвет в облаках")
        {
         CBuy = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(ShootingStar && Text == "Падающая Звезда")
        {
         CSell = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(InvertedHammer && Text == "Перевёрнутый Молот")
        {
         CBuy = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(Harami && Text == "Харами" && CandleBuy > 0)
        {
         CBuy = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(Harami && Text == "Харами" && CandleSell > 0)
        {
         CSell = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(Tweezer && Text == "Вершина Пинцет")
        {
         CSell = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(Tweezer && Text == "Основание Пинцет")
        {
         CBuy = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(BeltHoldLine && Text == "Захват за пояс"  && CandleSell > 0)
        {
         CSell = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(BeltHoldLine && Text == "Захват за пояс"  && CandleBuy > 0)
        {
         CBuy = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(UpsideGapTwoCrows && Text == "Две взлетевшие вороны")
        {
         CSell = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(ThreeCrows && Text == "Три вороны")
        {
         CSell = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(MatHoldPattern && Text == "Удержание на татами")
        {
         CBuy = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(CounterattackLines && Text == "Контратака"  && CandleSell > 0)
        {
         CSell = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(CounterattackLines && Text == "Контратака" && CandleBuy > 0)
        {
         CBuy = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(SeparatingLines && Text == "Разделение"  && CandleSell > 0)
        {
         CSell = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(SeparatingLines && Text == "Разделение"  && CandleBuy > 0)
        {
         CBuy = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(GravestoneDoji && Text == "Доджи-надгробие")
        {
         CSell = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(LongLeggedDoji && Text == "Длинноногий доджи"  && CandleSell > 0)
        {
         CSell = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(LongLeggedDoji && Text == "Длинноногий доджи"  && CandleBuy > 0)
        {
         CBuy = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(Doji && Text == "Доджи поглощения"  && CandleSell > 0)
        {
         CSell = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(Doji && Text == "Доджи поглощения"  && CandleBuy > 0)
        {
         CBuy = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(TasukiGap && Text == "Разрыв Тасуки"  && CandleSell > 0)
        {
         CSell = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(TasukiGap && Text == "Разрыв Тасуки"  && CandleBuy > 0)
        {
         CBuy = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(SideBySideWhite && Text == "Смежные белые свечи"  && CandleSell > 0)
        {
         CSell = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(SideBySideWhite && Text == "Смежные белые свечи"  && CandleBuy > 0)
        {
         CBuy = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(ThreeMethods && Text == "Три метода"  && CandleSell > 0)
        {
         CSell = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(ThreeMethods && Text == "Три метода"  &&  CandleBuy > 0)
        {
         CBuy = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(Gap && Text == "Окно" &&  CandleBuy > 0)
        {
         CBuy = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(Gap && Text == "Окно" && CandleSell > 0)
        {
         CSell = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(ThreeWhiteSoldiers && Text == "Три белых солдата")
        {
         CBuy = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(AdvanceBlock && Text == "Отбитое наступление")
        {
         CSell = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(StalledPattern && Text == "Торможение")
        {
         CSell = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(ThreeLineStrike && Text == "Тройной удар"  && CandleSell > 0)
        {
         CSell = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(ThreeLineStrike && Text == "Тройной удар" &&  CandleBuy > 0)
        {
         CBuy = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(OnNeckLine && Text == "У линии шеи"  && CandleSell > 0)
        {
         CSell = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(OnNeckLine && Text == "У линии шеи" &&  CandleBuy > 0)
        {
         CBuy = 1;
         CreateTextObject(Time[1], 0, Yellow, Text);
        }
      if(UseTime && (TimeCurrent() < t1 || TimeCurrent() >= t2))
         return;
      if(ScanTradesOpen() == 0 && CBuy > 0)
        {
         PlaySound("news.wav");
         BuyOpen(Blue);
        }
      if(ScanTradesOpen() == 0 && CSell > 0)
        {
         PlaySound("news.wav");
         SellOpen(Red);
        }
     }
   LastVol = Volume[0];
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BuyOpen(int ColorOfBuy)
  {
   int try, res;
   int try2;
   bool result = false;
   double SSL = 0, TTP = 0;
   if(StopLoss > 0)
      SSL = NormalizeDouble(Bid, digit) - StopLoss * Dec * Point;
   if(TakeProfit > 0)
      TTP = NormalizeDouble(Ask, digit) + TakeProfit * Dec * Point;
   for(try
          = 1; try
             <= MaxTries; try
                ++)
              {
               while(!IsTradeAllowed())
                  Sleep(5000);
               RefreshRates();
               res = OrderSend(Symbol(), OP_BUY, Lotsi, NormalizeDouble(Ask, digit), 2 * Dec, 0, 0, name + " (" + Symbol() + ")", Magic, 0, ColorOfBuy);
               Sleep(2000);
               if(res > 0)
                 {
                  if(OrderSelect(res, SELECT_BY_TICKET, MODE_TRADES))
                    {
                     for(try2 = 1; try2 <= MaxTries; try2++)
                       {
                        while(!IsTradeAllowed())
                           Sleep(2000);
                        RefreshRates();
                        if(TakeProfit == 0)
                           break;
                        result = OrderModify(OrderTicket(), OrderOpenPrice(), SSL, TTP, 0, Green);
                        if(result)
                           break;
                        if(!result)
                           Print("OrderModify Buy failed with error #", GetLastError());
                        Sleep(5000);
                       }
                     PlaySound("news.wav");
                     break;
                    }
                 }
               else
                 {
                  Print("Error opening BUY order : ", GetLastError());
                  PlaySound("timeout.wav");
                  Sleep(5000);
                 }
              }
   return;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SellOpen(int ColorOfSell)
  {
   int try, res;
   int try2;
   bool result = false;
   double SSL = 0, TTP = 0;
   if(StopLoss > 0)
      SSL = NormalizeDouble(Ask, digit) + StopLoss * Dec * Point;
   if(TakeProfit > 0)
      TTP = NormalizeDouble(Bid, digit) - TakeProfit * Dec * Point;
   for(try
          = 1; try
             <= MaxTries; try
                ++)
              {
               while(!IsTradeAllowed())
                  Sleep(5000);
               RefreshRates();
               res = OrderSend(Symbol(), OP_SELL, Lotsi, NormalizeDouble(Bid, digit), 2 * Dec, 0, 0, name + " (" + Symbol() + ")", Magic, 0, ColorOfSell);
               Sleep(2000);
               if(res > 0)
                 {
                  if(OrderSelect(res, SELECT_BY_TICKET, MODE_TRADES))
                    {
                     for(try2 = 1; try2 <= MaxTries; try2++)
                       {
                        while(!IsTradeAllowed())
                           Sleep(2000);
                        RefreshRates();
                        if(TakeProfit == 0)
                           break;
                        result = OrderModify(OrderTicket(), OrderOpenPrice(), SSL, TTP, 0, Green);
                        if(result)
                           break;
                        if(!result)
                           Print("OrderModify Sell failed with error #", GetLastError());
                        Sleep(5000);
                       }
                     PlaySound("news.wav");
                     break;
                    }
                 }
               else
                 {
                  Print("Error opening SELL order : ", GetLastError());
                  PlaySound("timeout.wav");
                  Sleep(5000);
                 }
              }
   return;
  }


// ---- Scan Trades opened
int ScanTradesOpen()
  {
   int total0 = OrdersTotal();
   int numords = 0;
   for(cnt = 0; cnt < total0; cnt++)
     {
      CheakResult = OrderSelect(cnt, SELECT_BY_POS);
      if(OrderSymbol() == Symbol() && (OrderType() == OP_BUY || OrderType() == OP_SELL)  && OrderMagicNumber() == Magic)
        {
         LastOrderLot = OrderLots();
         if(OrderType() == OP_BUY)
            LastOrderType = 1;
         if(OrderType() == OP_SELL)
            LastOrderType = 2;
         numords++;
        }
     }
   return(numords);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TrailStops()
  {
   int total0 = OrdersTotal();
   for(cnt = 0; cnt < total0; cnt++)
     {
      CheakResult = OrderSelect(cnt, SELECT_BY_POS);
      mode = OrderType();
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == Magic)
        {
         if(mode == OP_BUY)
           {
            if(NormalizeDouble(Ask - OrderOpenPrice(), Digits) > Point * TralStartLevel * Dec && NormalizeDouble(Ask - OrderStopLoss(), Digits) > Point * TralStop * Dec)
              {
               CheakResult = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(Ask - TralStop * Dec * Point, Digits), OrderTakeProfit(), 0, Green);
               return;
              }
           }
         if(mode == OP_SELL)
           {
            if(NormalizeDouble(OrderOpenPrice() - Bid, Digits) > Point * TralStartLevel * Dec && (NormalizeDouble(OrderStopLoss() - Bid, Digits) > Point * TralStop * Dec || OrderStopLoss() == 0))
              {
               CheakResult = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(Bid + TralStop * Dec * Point, Digits), OrderTakeProfit(), 0, Green);
               return;
              }
           }
        }
     }
  }

//******************************************************************************

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetUpperShadowHeight(int shift)
  {
   return (MathAbs(High[shift] - MathMax(Close[shift], Open[shift])));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetLowerShadowHeight(int shift)
  {
   return (MathAbs(MathMin(Close[shift], Open[shift]) - Low[shift]));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetBodyHeight(int shift)
  {
   return (MathAbs(Close[shift] - Open[shift]));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetAllHeight(int shift)
  {
   return (MathAbs(High[shift] - Low[shift]));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsHigher(int shift)
  {
   if(High[shift] >= High[shift + 1] + 2.0 * Point && High[shift] >= High[shift + 2] + 2.0 * Point && High[shift] >= High[shift + 3] + 2.0 * Point)
      return (true);
   return (false);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsLower(int shift)
  {
   if(Low[shift] + 2.0 * Point * Dec < Low[shift + 1] && Low[shift] + 2.0 * Point * Dec < Low[shift + 2] && Low[shift] + 2.0 * Point * Dec < Low[shift + 3])
      return (true);
   return (false);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int IsYing(int shift)
  {
   if(Close[shift] < Open[shift])
      return (1);
   return (0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int IsYang(int shift)
  {
   if(Close[shift] > Open[shift])
      return (1);
   return (0);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetLowCloseOpen(int shift)
  {
   return (MathMin(Close[shift], Open[shift]));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetHighCloseOpen(int shift)
  {
   return (MathMax(Close[shift], Open[shift]));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int AlmostSameBodyHeight(int shift, int ai_4)
  {
   if(MathAbs(GetBodyHeight(shift) - GetBodyHeight(ai_4)) < 5.0 * Point * Dec)
      return (1);
   return (0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreateTextObject(datetime a_datetime_0, double a_price_4, color a_color_12, string a_text_16)
  {
   string l_name_24;
   l_name_24 = TimeToStr(TimeCurrent());
   if(CandleSell > 0)
     {
      ObjectCreate(l_name_24, OBJ_ARROW, 0, 0, 0, 0, 0);
      ObjectSet(l_name_24, OBJPROP_COLOR, Pink);
      ObjectSet(l_name_24, OBJPROP_ARROWCODE, 234);
      ObjectSet(l_name_24, OBJPROP_TIME1, Time[1]);
      ObjectSet(l_name_24, OBJPROP_PRICE1, High[1] + Period()*Dec * Point / 2);
      ObjectCreate(l_name_24 + "T", OBJ_TEXT, 0, a_datetime_0, High[1] + Period()*Dec * Point);
      ObjectSetText(l_name_24 + "T", a_text_16, 7);
      ObjectSet(l_name_24 + "T", OBJPROP_COLOR, Yellow);
     }
   if(CandleBuy > 0)
     {
      ObjectCreate(l_name_24, OBJ_ARROW, 0, 0, 0, 0, 0);
      ObjectSet(l_name_24, OBJPROP_COLOR, DeepSkyBlue);
      ObjectSet(l_name_24, OBJPROP_ARROWCODE, 233);
      ObjectSet(l_name_24, OBJPROP_TIME1, Time[1]);
      ObjectSet(l_name_24, OBJPROP_PRICE1, Low[1] - Period()*Dec * Point / 2);
      ObjectCreate(l_name_24 + "T", OBJ_TEXT, 0, a_datetime_0, Low[1] - Period()*Dec * Point);
      ObjectSetText(l_name_24 + "T", a_text_16, 7);
      ObjectSet(l_name_24 + "T", OBJPROP_COLOR, Yellow);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsHammer(int shift)
  {
   if(GetAllHeight(shift) >= 10.0 * Point * Dec && GetUpperShadowHeight(shift) < GetAllHeight(shift) / 5.0 && GetLowerShadowHeight(shift) > 2.0 * GetBodyHeight(shift) && GetUpperShadowHeight(shift) > 0.0 * Point * Dec)
      if(IsLower(shift))
         return (true);
   return (false);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsHangMan(int shift)
  {
   if(GetAllHeight(shift) >= 10.0 * Point * Dec && GetUpperShadowHeight(shift) < GetAllHeight(shift) / 5.0 && GetLowerShadowHeight(shift) > 1.0 * GetBodyHeight(shift))
      if(IsHigher(shift))
         return (true);
   return (false);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsDoji(int shift)
  {
   if(MathAbs(Open[shift] - Close[shift]) < 3.0 * Point)
      return (true);
   return (false);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsInvertHammer(int shift)
  {
   if(GetLowerShadowHeight(shift) < GetAllHeight(shift) / 5.0)
     {
      if(GetUpperShadowHeight(shift) > 2.0 * GetBodyHeight(shift))
         if(IsLower(shift))
            return (true);
     }
   return (false);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsInvertHammerCFM(int ai_unused_0)
  {
   return (false);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsThree_Crows(int shift)
  {
   if(High[shift + 1] > High[shift + 2] && IsYing(shift + 2) && IsYing(shift + 1) && IsYing(shift) && Open[shift + 1] < Open[shift + 2] && Close[shift +
         1] < Close[shift + 2] && Open[shift] < Open[shift + 1] && Close[shift] < Close[shift + 1])
      return (true);
   return (false);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsThree_White_Soldiers(int shift)
  {
   if(IsYang(shift + 3) && IsYang(shift + 2) && IsYang(shift + 1) && Open[shift + 2] > Open[shift + 3] + GetBodyHeight(shift + 3) / 2.0 && Open[shift + 1] > Open[shift + 2] +
      GetBodyHeight(shift + 2) / 2.0 && Close[shift + 2] > Close[shift + 3] && Close[shift + 1] > Close[shift + 2] && High[shift + 2] > High[shift + 3] && High[shift + 1] > High[shift + 2] && GetUpperShadowHeight(shift + 1) < 10.0 * Dec * Point && GetUpperShadowHeight(shift + 2) < 10.0 * Dec * Point && GetUpperShadowHeight(shift + 3) < 10.0 * Dec * Point && AlmostSameBodyHeight(shift + 3, shift + 2) && AlmostSameBodyHeight(shift + 2, shift + 1))
      return (true);
   return (false);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Condition(int shift)
  {
   if(!IsDoji(shift + 2))
     {
      if(IsYang(shift + 2) != IsYang(shift + 1))
        {
         if(MathMax(Close[shift + 1], Open[shift + 1]) > MathMax(Close[shift + 2], Open[shift + 2]) && MathMin(Close[shift + 1], Open[shift + 1]) < MathMin(Close[shift + 2], Open[shift + 2]))
           {
            if(IsLower(shift + 2) || (IsLower(shift + 1) && IsYang(shift + 1)))
              {
               Text = "Поглощение";
               CandleBuy = 1;
               return(0);
              }
            if(IsHigher(shift + 2) || (IsHigher(shift + 1) && IsYing(shift + 1)))
              {
               Text = "Поглощение";
               CandleSell = 1;
               return(0);
              }
            if(GetBodyHeight(shift + 2) >= 15.0 * Point * Dec || (IsLower(shift + 1) && IsYang(shift + 1)))
              {
               Text = "Поглощение";
               CandleBuy = 1;
               return(0);
              }
            if(GetBodyHeight(shift + 2) >= 15.0 * Point * Dec || (IsHigher(shift + 1) && IsYing(shift + 1)))
              {
               Text = "Поглощение";
               CandleSell = 1;
               return(0);
              }
           }
        }
     }
   if(IsDoji(shift + 2))
     {
      if(MathMax(Close[shift + 1], Open[shift + 1]) > MathMax(Close[shift + 2], Open[shift + 2]) && MathMin(Close[shift + 1], Open[shift + 1]) < MathMin(Close[shift + 2], Open[shift + 2]))
        {
         if(IsLower(shift + 2) || (IsLower(shift + 1) && IsYang(shift + 1)))
            Text = "Доджи поглощение бай";
         if(IsHigher(shift + 2) || (IsHigher(shift + 1) && IsYing(shift + 1)))
            Text = "Доджи поглощение селл";
        }
     }
   if(IsYang(shift + 2) && IsYing(shift + 1) && IsHigher(shift + 2) && GetBodyHeight(shift + 2) >= 10.0 * Point * Dec && Open[shift + 1] > High[shift + 2] && Close[shift + 1] < Open[shift +
         2] + (Close[shift + 2] - (Open[shift + 2])) / 2.0 && GetLowCloseOpen(shift + 1) > GetLowCloseOpen(shift + 2))
     {
      Text = "Завеса из облаков";
      CandleSell = 1;
      return(0);
     }
   if(MathAbs(Close[shift + 2] - (Open[shift + 2])) > 15.0 * Point * Dec)
     {
      if(MathMax(Close[shift + 1], Open[shift + 1]) < MathMax(Close[shift + 2], Open[shift + 2]) && MathMin(Close[shift + 1], Open[shift + 1]) > MathMin(Close[shift + 2], Open[shift +
            2]))
        {
         if((IsYang(shift + 2) && IsHigher(shift + 2)) || (IsYang(shift + 2)))
           {
            Text = "Харами";
            CandleSell = 1;
            return(0);
           }
         if((IsYing(shift + 2) && IsLower(shift + 2)) || (IsYing(shift + 2)))
           {
            Text = "Харами";
            CandleBuy = 1;
            return(0);
           }
        }
     }
   if(IsHammer(shift + 1))
     {
      Text = "Молот";
      CandleBuy = 1;
      return(0);
     }
   if(IsHangMan(shift + 1))
     {
      Text = "Повешенный";
      CandleSell = 1;
      return(0);
     }
   if(IsInvertHammer(shift + 1))
     {
      Text = "Перевёрнутый Молот";
      CandleBuy = 1;
      return(0);
     }
   if(IsInvertHammerCFM(shift + 1))
     {
      Text = "Перевёрнутый Молот";
      CandleBuy = 1;
      return(0);
     }
   if(IsYang(shift + 1) && IsYing(shift + 2) && GetBodyHeight(shift + 2) >= 10.0 * Point * Dec && Open[shift + 1] < Low[shift + 2] && Close[shift + 1] > Close[shift + 2] + (Open[shift +
         2] - (Close[shift + 2])) / 2.0 && GetHighCloseOpen(shift + 1) < GetHighCloseOpen(shift + 2))
     {
      Text = "Просвет в облаках";
      CandleBuy = 1;
      return(0);
     }
   if(IsYing(shift + 3) && IsYang(shift + 1) && IsLower(shift + 3))
     {
      if(GetLowCloseOpen(shift + 3) > GetHighCloseOpen(shift + 2) || (GetLowCloseOpen(shift + 1) > GetHighCloseOpen(shift + 2) && GetHighCloseOpen(shift + 1) > GetLowCloseOpen(shift +
            3) && GetBodyHeight(shift + 2) <= 10.0 * Point * Dec && GetBodyHeight(shift + 3) >= 8.0 * Point * Dec && GetBodyHeight(shift + 1) >= 8.0 * Point * Dec))
        {
         Text = "Утренняя звезда";
         CandleBuy = 1;
         return(0);
        }
     }
   if(IsYang(shift + 3) && IsYing(shift + 1) && IsHigher(shift + 3))
     {
      if(GetHighCloseOpen(shift + 3) < GetLowCloseOpen(shift + 2) || (GetHighCloseOpen(shift + 1) < GetLowCloseOpen(shift + 2) && GetLowCloseOpen(shift + 1) < GetHighCloseOpen(shift +
            3) && GetBodyHeight(shift + 2) <= 10.0 * Point * Dec && GetBodyHeight(shift + 3) > 8.0 * Point * Dec && GetBodyHeight(shift + 1) > 8.0 * Point * Dec))
        {
         Text = "Вечерняя звезда";
         CandleSell = 1;
         return(0);
        }
     }
   if(GetLowerShadowHeight(shift + 1) < GetAllHeight(shift + 1) / 5.0)
     {
      if(GetUpperShadowHeight(shift + 1) > 2.0 * GetBodyHeight(shift + 1))
         if(IsHigher(shift + 1))
           {
            Text = "Падающая Звезда";
            CandleSell = 1;
            return(0);
           }
     }
   if((IsHigher(shift + 2) && High[shift + 2] == High[shift + 1]) || High[shift + 3] == High[shift + 1] || High[shift +
         4] == High[shift + 1])
     {
      Text = "Вершина Пинцет";
      CandleSell = 1;
      return(0);
     }
   if((IsLower(shift + 2) && Low[shift + 2] == Low[shift + 1]) || Low[shift + 3] == Low[shift + 1] || Low[shift +
         4] == Low[shift + 1])
     {
      Text = "Основание Пинцет";
      CandleBuy = 1;
      return(0);
     }
   if(GetBodyHeight(shift + 1) >= 10.0 * Point * Dec && IsYang(shift + 1) && GetLowerShadowHeight(shift + 1) == 0.0 && GetBodyHeight(shift + 1) > GetAllHeight(shift +
         1) / 2.0)
     {
      Text = "Захват за пояс";
      CandleBuy = 1;
      return(0);
     }
   if(GetBodyHeight(shift + 1) >= 10.0 * Point * Dec && IsYing(shift + 1) && GetUpperShadowHeight(shift + 1) == 0.0 && GetBodyHeight(shift + 1) > GetAllHeight(shift +
         1) / 2.0)
     {
      Text = "Захват за пояс";
      CandleSell = 1;
      return(0);
     }
   if(IsHigher(shift + 3) && IsYang(shift + 3) && IsYing(shift + 2) && IsYing(shift + 1) && Open[shift + 2] > Open[shift + 3] && Open[shift + 1] > Open[shift + 2] && Close[shift +
         1] < Close[shift + 2] && GetLowCloseOpen(shift + 1) > GetHighCloseOpen(shift + 3) && GetLowCloseOpen(shift + 2) > GetHighCloseOpen(shift + 3))
     {
      Text = "Две взлетевшие вороны";
      CandleSell = 1;
      return(0);
     }
   if(IsYang(shift + 5) && IsYing(shift + 4) && IsYing(shift + 3) && IsYing(shift + 2) && IsYang(shift + 1) && Open[shift + 4] < Close[shift + 1] &&
      GetBodyHeight(shift + 5) >= 5.0 * Point * Dec && GetBodyHeight(shift + 1) >= 5.0 * Point * Dec)
     {
      Text = "Удержание на татами";
      CandleBuy = 1;
      return(0);
     }
   if(IsThree_Crows(shift + 1))
     {
      Text = "Три вороны";
      CandleSell = 1;
      return(0);
     }
   if(GetBodyHeight(shift + 1) > 5.0 * Point && GetBodyHeight(shift + 2) > 5.0 * Point)
     {
      if(IsHigher(shift + 1) && IsYang(shift + 2) && IsYing(shift + 1) && GetHighCloseOpen(shift + 1) - GetHighCloseOpen(shift + 2) >= 2.0 * Point * Dec && Close[shift + 2] > Close[shift + 1] && GetBodyHeight(shift + 2) >= 10.0 * Point * Dec)
        {
         Text = "Контратака";
         CandleSell = 1;
         return(0);
        }
      if(IsLower(shift + 1) && IsYing(shift + 2) && IsYang(shift + 1) && GetLowCloseOpen(shift + 2) - GetLowCloseOpen(shift + 1) >= 2.0 * Point * Dec && Close[shift + 2] < Close[shift + 1] && GetBodyHeight(shift + 2) >= 10.0 * Point * Dec)
        {
         Text = "Контратака";
         CandleBuy = 1;
         return(0);
        }
     }
   if(GetBodyHeight(shift + 1) > 5.0 * Point && GetBodyHeight(shift + 2) > 5.0 * Point)
     {
      if(IsYang(shift + 2) && IsYing(shift + 1) && Open[shift + 2] - (Open[shift + 1]) >= -2.0 * Point * Dec && GetBodyHeight(shift + 2) >= 2.0 * Point * Dec)
        {
         Text = "Разделение";
         CandleSell = 1;
         return(0);
        }
      if(IsYing(shift + 2) && IsYang(shift + 1) && Open[shift + 1] - (Open[shift + 2]) >= -2.0 * Point * Dec && GetBodyHeight(shift + 2) >= 2.0 * Point * Dec)
        {
         Text = "Разделение";
         CandleBuy = 1;
         return(0);
        }
     }
   if(Close[shift + 1] == Open[shift + 1] && GetLowerShadowHeight(shift + 1) == 0.0)
     {
      Text = "Доджи-надгробие";
      CandleSell = 1;
      return(0);
     }
   if(IsHigher(shift + 1) && MathAbs(Close[shift + 1] - (Open[shift + 1])) < 2.0 * Point * Dec && GetAllHeight(shift + 1) > 10.0 * Point * Dec && High[shift + 1] > High[shift + 2])
     {
      Text = "Длинноногий доджи";
      CandleSell = 1;
      return(0);
     }
   if(IsLower(shift + 1) && MathAbs(Close[shift + 1] - (Open[shift + 1])) < 2.0 * Point * Dec && GetAllHeight(shift + 1) > 10.0 * Point * Dec && Low[shift + 1] < Low[shift + 2])
     {
      Text = "Длинноногий доджи";
      CandleBuy = 1;
      return(0);
     }
   if((GetBodyHeight(shift + 2) > 10.0 * Point * Dec && IsHigher(shift + 2)) || (IsHigher(shift + 1) && IsYang(shift + 2) && MathAbs(Close[shift + 1] - (Open[shift + 1])) < 1.0 * Point * Dec))
     {
      Text = "Доджи поглощения";
      CandleSell = 1;
      return(0);
     }
   if((GetBodyHeight(shift + 2) > 10.0 * Point * Dec && IsLower(shift + 2)) || (IsLower(shift + 1) && IsYing(shift + 2) && MathAbs(Close[shift + 1] - (Open[shift + 1])) < 1.0 * Point * Dec))
     {
      Text = "Доджи поглощения";
      CandleBuy = 1;
      return(0);
     }
   if(IsHigher(shift + 3) || (IsHigher(shift + 2) && (IsYang(shift + 3) && IsYang(shift + 2) && IsYing(shift + 1))  && Low[shift +
                              1] - (Low[shift + 3]) >= 2.0 * Point && Open[shift + 2] - (Close[shift + 3]) > 0.1 * Point * Dec && Close[shift + 1] < Open[shift + 2] && MathAbs(GetBodyHeight(shift +
                                    1) - GetBodyHeight(shift + 2)) < 5.0 * Point * Dec))
     {
      Text = "Разрыв Тасуки";
      CandleBuy = 1;
      return(0);
     }
   if(IsLower(shift + 3) || (IsLower(shift + 2) && (IsYing(shift + 3) && IsYing(shift + 2) && IsYang(shift + 1))  && High[shift +
                             3] - (High[shift + 1]) >= 2.0 * Point && Close[shift + 3] - (Open[shift + 2]) > 0.1 * Point * Dec && Close[shift + 1] > Open[shift + 2] && MathAbs(GetBodyHeight(shift +
                                   1) - GetBodyHeight(shift + 2)) < 5.0 * Point * Dec))
     {
      Text = "Разрыв Тасуки";
      CandleSell = 1;
      return(0);
     }
   if(IsHigher(shift + 3) && (IsYang(shift + 3) && IsYang(shift + 2) && IsYang(shift + 1))  && MathAbs(Open[shift + 1] - Open[shift +
         2]) < 3.0 * Point * Dec && MathAbs(GetBodyHeight(shift + 1) - GetBodyHeight(shift + 2)) < 10.0 * Point * Dec)
     {
      Text = "Смежные белые свечи";
      CandleBuy = 1;
      return(0);
     }
   if(IsLower(shift + 3) && (IsYing(shift + 3) && IsYang(shift + 2) && IsYang(shift + 1))  && MathAbs(Open[shift + 1] - Open[shift +
         2]) < 3.0 * Point * Dec && MathAbs(GetBodyHeight(shift + 1) - GetBodyHeight(shift + 2)) < 10.0 * Point * Dec)
     {
      Text = "Смежные белые свечи";
      CandleSell = 1;
      return(0);
     }
   if(IsHigher(shift + 5) && IsYang(shift + 5) && IsYang(shift + 1) && IsYing(shift + 2) && IsYing(shift + 3) && IsYing(shift + 4) && GetBodyHeight(shift + 5) > 5.0 * Point &&
      GetBodyHeight(shift + 1) > 5.0 * Point * Dec && Open[shift + 5] < Close[shift + 1])
     {
      Text = "Три метода";
      CandleBuy = 1;
      return(0);
     }
   if(IsLower(shift + 5) && IsYing(shift + 5) && IsYing(shift + 1) && IsYang(shift + 2) && IsYang(shift + 3) && IsYang(shift + 4) && GetBodyHeight(shift + 5) > 5.0 * Point &&
      GetBodyHeight(shift + 1) > 5.0 * Point * Dec && Open[shift + 5] > Close[shift + 1])
     {
      Text = "Три метода";
      CandleSell = 1;
      return(0);
     }
   if(IsHigher(shift + 1) && IsYang(shift + 1) && IsYang(shift + 2) && Open[shift + 1] - (Close[shift + 2]) >= 1 * Point * Dec)
     {
      Text = "Окно";
      CandleBuy = 1;
      return(0);
     }
   if(IsLower(shift + 1) && IsYing(shift + 1) && IsYing(shift + 2) && Close[shift + 2] - (Open[shift + 1]) >= 1 * Point * Dec)
     {
      Text = "Окно";
      CandleSell = 1;
      return(0);
     }
   if(IsThree_White_Soldiers(shift))
     {
      Text = "Три белых солдата";
      CandleBuy = 1;
      return(0);
     }
   if(IsYang(shift + 3) && IsYang(shift + 2) && IsYang(shift + 1) && Open[shift + 2] > Open[shift + 3] + GetBodyHeight(shift + 3) / 2.0 && Open[shift + 1] > Open[shift + 2] +
      GetBodyHeight(shift + 2) / 2.0 && Close[shift + 2] > Close[shift + 3] && Close[shift + 1] > Close[shift + 2] && High[shift + 2] > High[shift + 3] && High[shift + 1] > High[shift + 2]  && GetBodyHeight(shift + 3) > GetBodyHeight(shift + 2) && GetBodyHeight(shift + 2) > GetBodyHeight(shift + 1))
     {
      Text = "Отбитое наступление";
      CandleSell = 1;
      return(0);
     }
   if(IsYang(shift + 3) && IsYang(shift + 2) && IsYang(shift + 1) && Open[shift + 2] > Open[shift + 3] + GetBodyHeight(shift + 3) / 2.0 && Open[shift + 1] > Open[shift + 2] +
      GetBodyHeight(shift + 2) / 2.0 && Close[shift + 2] > Close[shift + 3] && Close[shift + 1] > Close[shift + 2] && High[shift + 2] > High[shift + 3] && High[shift + 1] > High[shift + 2] && GetBodyHeight(shift + 3) < GetBodyHeight(shift + 2) / 2 && GetBodyHeight(shift + 1) < GetBodyHeight(shift + 2) / 2)
     {
      Text = "Торможение";
      CandleSell = 1;
      return(0);
     }
   if(IsYang(shift + 1) && IsThree_Crows(shift + 2) && Close[shift + 1] > Open[shift + 2])
     {
      Text = "Тройной удар";
      CandleSell = 1;
      return(0);
     }
   if(IsYing(shift + 1) && IsThree_White_Soldiers(shift + 1) && Close[shift + 1] < Open[shift + 2])
     {
      Text = "Тройной удар";
      CandleBuy = 1;
      return(0);
     }
   if(IsYing(shift + 2) && IsYang(shift + 1)  && Close[shift + 1] < Open[shift + 2] - (Open[shift + 2] - (Close[shift +
         2])) / 2.0 && Open[shift + 1] < GetLowCloseOpen(shift + 2))
     {
      Text = "У линии шеи";
      CandleSell = 1;
      return(0);
     }
   if(IsYang(shift + 2) && IsYing(shift + 1)  && Close[shift + 1] > Open[shift + 2] + (Close[shift + 2] - (Open[shift +
         2])) / 2.0 && Open[shift + 1] > GetHighCloseOpen(shift + 2))
     {
      Text = "У линии шеи";
      CandleBuy = 1;
      return(0);
     }
   return (0);
  }
//+------------------------------------------------------------------+
