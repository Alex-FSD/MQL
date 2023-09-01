//+------------------------------------------------------------------+
//|                                                         Ten.mq4  |
//|                                                   Vradii Sergei  |
//|                                                                  |
//+------------------------------------------------------------------+

#property copyright "Vradii Sergei"
#include <stdlib.mqh>
#include <WinUser32.mqh>

// exported variables
extern int Stoploss = 20;              //----- Stop loss
extern int Takeprofit = 30;            //----- Take profit
extern int TrailingStop = 15;          //----- Trailing stop
extern int TrailingGap = 10;           //----- Step of trailing stop
extern int PriceOffset = 20;           //----- Offset from the current price to the nearest limit order
extern int Interval = 50;              //----- Interval between neighbouring orders
extern int OrdersLimit = 5;            //----- The maximal amount of orders of each type
extern double BalanceRiskPercent = 1;  //----- Risk (% of balance) for one order

                                       // local variables
double PipValue=1;    // this variable is here to support 5-digit brokers
bool Terminated= false;
string LF = "\n";  // use this in custom or utility blocks where you need line feeds
int NDigits = 4;   // used mostly for NormalizeDouble in Flex type blocks
int ObjCount = 0;  // count of all objects created on the chart, allows creation of objects with unique names
int current=0;

int Today=-1;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   NDigits=Digits;

   if(false) ObjectsDeleteAll();      // clear the chart

   Comment("");    // clear the chart
   return (0);
  }
//+------------------------------------------------------------------+
//| Expert start                                                     |
//+------------------------------------------------------------------+
int start()
  {
   if(Bars<10)
     {
      Comment("Not enough bars");
      return (0);
     }
   if(Terminated==true)
     {
      Comment("EA Terminated.");
      return (0);
     }

   OnEveryTick();
   return (0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnEveryTick()
  {
   PipValue=1;
   if(NDigits==3 || NDigits==5) PipValue=10;

   TrailingStop1();
   TrailingStop2();
   AtCertainTime();
   IfNoOrderExist();

  }
//+------------------------------------------------------------------+
//| Trailing stop for buys                                           |
//+------------------------------------------------------------------+
void TrailingStop1()
  {
   for(int i=OrdersTotal()-1; i>=0; i--)
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==1)
           {
            double takeprofit=OrderTakeProfit();

            if(OrderType()==OP_BUY && Ask-OrderOpenPrice()>TrailingStop*PipValue*Point)
              {
               if(OrderStopLoss()<Ask-(TrailingStop+TrailingGap)*PipValue*Point)
                 {
                  if(0!=0) takeprofit=Ask+(0+TrailingStop)*PipValue*Point;
                  bool ret1=OrderModify(OrderTicket(),OrderOpenPrice(),Ask-TrailingStop*PipValue*Point,takeprofit,OrderExpiration(),Blue);
                  if(ret1==false)
                     Print("OrderModify() error - ",ErrorDescription(GetLastError()));
                 }
              }
            if(OrderType()==OP_SELL && OrderOpenPrice()-Bid>TrailingStop*PipValue*Point)
              {
               if(OrderStopLoss()>Bid+(TrailingStop+TrailingGap)*PipValue*Point)
                 {
                  if(0!=0) takeprofit=Bid-(0+TrailingStop)*PipValue*Point;
                  bool ret2=OrderModify(OrderTicket(),OrderOpenPrice(),Bid+TrailingStop*PipValue*Point,takeprofit,OrderExpiration(),Blue);
                  if(ret2==false)
                     Print("OrderModify() error - ",ErrorDescription(GetLastError()));
                 }
              }
           }
        }
   else
      Print("OrderSelect() error - ",ErrorDescription(GetLastError()));

  }
//+------------------------------------------------------------------+
//| Trailing stop for sells                                          |
//+------------------------------------------------------------------+
void TrailingStop2()
  {
   for(int i=OrdersTotal()-1; i>=0; i--)
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==2)
           {
            double takeprofit=OrderTakeProfit();

            if(OrderType()==OP_BUY && Ask-OrderOpenPrice()>TrailingStop*PipValue*Point)
              {
               if(OrderStopLoss()<Ask-(TrailingStop+TrailingGap)*PipValue*Point)
                 {
                  if(0!=0) takeprofit=Ask+(0+TrailingStop)*PipValue*Point;
                  bool ret1=OrderModify(OrderTicket(),OrderOpenPrice(),Ask-TrailingStop*PipValue*Point,takeprofit,OrderExpiration(),Red);
                  if(ret1==false)
                     Print("OrderModify() error - ",ErrorDescription(GetLastError()));
                 }
              }
            if(OrderType()==OP_SELL && OrderOpenPrice()-Bid>TrailingStop*PipValue*Point)
              {
               if(OrderStopLoss()>Bid+(TrailingStop+TrailingGap)*PipValue*Point)
                 {
                  if(0!=0) takeprofit=Bid-(0+TrailingStop)*PipValue*Point;
                  bool ret2=OrderModify(OrderTicket(),OrderOpenPrice(),Bid+TrailingStop*PipValue*Point,takeprofit,OrderExpiration(),Red);
                  if(ret2==false)
                     Print("OrderModify() error - ",ErrorDescription(GetLastError()));
                 }
              }
           }
        }
   else
      Print("OrderSelect() error - ",ErrorDescription(GetLastError()));

  }
//+------------------------------------------------------------------+
//| Deleting pending orders in the end of the day                    |
//+------------------------------------------------------------------+
void AtCertainTime()
  {
   int datetime1=TimeLocal();
   int hour0=TimeHour(datetime1);
   int minute0=TimeMinute(datetime1);
   if(DayOfWeek()!=Today && hour0==23 && minute0==59)
     {
      Today=DayOfWeek();
      DeletePendingOrder1();
      DeletePendingOrder2();

     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeletePendingOrder1()
  {

   for(int i=OrdersTotal()-1; i>=0; i--)
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderType()==OP_BUYSTOP && OrderSymbol()==Symbol() && OrderMagicNumber()==1)
           {
            bool ret=OrderDelete(OrderTicket(),Blue);

            if(ret==false)
              {
               Print("OrderDelete() error - ",ErrorDescription(GetLastError()));
              }
           }
        }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeletePendingOrder2()
  {

   for(int i=OrdersTotal()-1; i>=0; i--)
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderType()==OP_BUYSTOP && OrderSymbol()==Symbol() && OrderMagicNumber()==2)
           {
            bool ret=OrderDelete(OrderTicket(),Red);

            if(ret==false)
              {
               Print("OrderDelete() error - ",ErrorDescription(GetLastError()));
              }
           }
        }

  }
//+------------------------------------------------------------------+
//| Filter "there is no any order"                                   |
//+------------------------------------------------------------------+
void IfNoOrderExist()
  {
   bool exists=false;
   for(int i=OrdersTotal()-1; i>=0; i--)
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol())
           {
            exists=true;
           }
        }
   else
     {
      Print("OrderSelect() error - ",ErrorDescription(GetLastError()));
     }

   if(exists==false)
     {
      BuyPendingRiskFixed();
      SellPendingRiskFixed();

     }
  }
//+------------------------------------------------------------------+
//| Buystop with fixed risk                                          |
//+------------------------------------------------------------------+
void BuyPendingRiskFixed()
  {
   double lotsize = MarketInfo(Symbol(),MODE_LOTSIZE) / AccountLeverage();
   double pipsize = 1 * 10;
   double maxlots = AccountFreeMargin() / 100 * BalanceRiskPercent / lotsize * pipsize;
   if(Stoploss == 0) Print("OrderSend() error - stoploss can not be zero");
   double lots = maxlots / Stoploss * 10;

// calculate lot size based on current risk
   double lotvalue= 0.001;
   double minilot = MarketInfo(Symbol(),MODE_MINLOT);
   int powerscount= 0;
   while(minilot<1)
     {
      minilot=minilot*MathPow(10,powerscount);
      powerscount++;
     }
   lotvalue=NormalizeDouble(lots,powerscount-1);

   if(lotvalue<MarketInfo(Symbol(),MODE_MINLOT)) // make sure lot is not smaller than allowed value
     {
      lotvalue=MarketInfo(Symbol(),MODE_MINLOT);
     }
   if(lotvalue>MarketInfo(Symbol(),MODE_MAXLOT)) // make sure lot is not greater than allowed value
     {
      lotvalue=MarketInfo(Symbol(),MODE_MAXLOT);
     }

   int expire=TimeCurrent()+60*1440;
   int PriceOffset1;
   int i=1;
   PriceOffset1=PriceOffset;
   while(i<=OrdersLimit)
     {
      double price=NormalizeDouble(Ask,NDigits)+PriceOffset1*PipValue*Point;
      double SL=price-Stoploss*PipValue*Point;
      if(Stoploss==0) SL=0;
      double TP=price+Takeprofit*PipValue*Point;
      if(Takeprofit==0) TP=0;
      if(1440==0) expire=0;
      int ticket= OrderSend(Symbol(),OP_BUYSTOP,lotvalue,price,0,SL,TP,"My Expert",1,expire,Blue);
      if(ticket == -1)
        {
         Print("OrderSend() error - ",ErrorDescription(GetLastError()));
        }
      PriceOffset1=PriceOffset1+Interval;
      i++;
     }
  }
//+------------------------------------------------------------------+
//| Sellstop with fixed risk                                         |
//+------------------------------------------------------------------+
void SellPendingRiskFixed()
  {
   double lotsize = MarketInfo(Symbol(),MODE_LOTSIZE) / AccountLeverage();
   double pipsize = 1 * 10;
   double maxlots = AccountFreeMargin() / 100 * BalanceRiskPercent / lotsize * pipsize;
   if(Stoploss == 0) Print("OrderSend() error - stoploss can not be zero");
   double lots = maxlots / Stoploss * 10;

// calculate lot size based on current risk
   double lotvalue= 0.001;
   double minilot = MarketInfo(Symbol(),MODE_MINLOT);
   int powerscount= 0;
   while(minilot<1)
     {
      minilot=minilot*MathPow(10,powerscount);
      powerscount++;
     }
   lotvalue=NormalizeDouble(lots,powerscount-1);

   if(lotvalue<MarketInfo(Symbol(),MODE_MINLOT)) // make sure lot is not smaller than allowed value
     {
      lotvalue=MarketInfo(Symbol(),MODE_MINLOT);
     }
   if(lotvalue>MarketInfo(Symbol(),MODE_MAXLOT)) // make sure lot is not greater than allowed value
     {
      lotvalue=MarketInfo(Symbol(),MODE_MAXLOT);
     }

   int expire=TimeCurrent()+60*1440;
   int PriceOffset1;
   int i=1;
   PriceOffset1=PriceOffset;
   while(i<=OrdersLimit)
     {
      double price=NormalizeDouble(Bid,NDigits)-PriceOffset1*PipValue*Point;
      double SL=price+Stoploss*PipValue*Point;
      if(Stoploss==0) SL=0;
      double TP=price-Takeprofit*PipValue*Point;
      if(Takeprofit==0) TP=0;
      if(1440==0) expire=0;
      int ticket= OrderSend(Symbol(),OP_SELLSTOP,lotvalue,price,0,SL,TP,"My Expert",2,expire,Red);
      if(ticket == -1)
        {
         Print("OrderSend() error - ",ErrorDescription(GetLastError()));
        }
      PriceOffset1=PriceOffset1+Interval;
      i++;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   if(false) ObjectsDeleteAll();

   return (0);
  }
//+------------------------------------------------------------------+
