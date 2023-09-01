//+------------------------------------------------------------------+
//|                                                           MA.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#define MAGICMA  12102021

input double                     Lots                       = 0.1;

input int                        MovingPeriod               = 12;
input int                        MovingShift                = 6;
input ENUM_MA_METHOD             MovingMethod               = MODE_SMA;
input ENUM_APPLIED_PRICE         MovingAppliedPrice         = PRICE_CLOSE;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CountPositionsNumber(int type)
  {
   int number = 0;
   for(int i = 0; i < OrdersTotal(); i++)
      if(OrderSelect(i, SELECT_BY_POS))
         if(OrderSymbol() == _Symbol && OrderMagicNumber() == MAGICMA && OrderType() == type)
            number++;
   return number;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpen()
  {
   double ma;
   int    res;
   ma = iMA(NULL, 0, MovingPeriod, MovingShift, MovingMethod, MovingAppliedPrice, 0);
   if(CountPositionsNumber(OP_SELL) < 1)
     {
      if(Open[1] > ma && Close[1] < ma)
        {
         res = OrderSend(Symbol(), OP_SELL, Lots, Bid, 3, 0, 0, "", MAGICMA, 0, Red);
        }
     }
   if(CountPositionsNumber(OP_BUY) < 1)
     {
      if(Open[1] < ma && Close[1] > ma)
        {
         res = OrderSend(Symbol(), OP_BUY, Lots, Ask, 3, 0, 0, "", MAGICMA, 0, Blue);
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForClose()
  {
   double ma;
   ma = iMA(NULL, 0, MovingPeriod, MovingShift, MovingMethod, MovingAppliedPrice, 0);
   if(Open[1] > ma && Close[1] < ma)
     {
      for(int i = 0; i < OrdersTotal(); i++)
         if(OrderSelect(i, SELECT_BY_POS))
            if(OrderSymbol() == _Symbol && OrderMagicNumber() == MAGICMA && OrderType() == OP_BUY)
               if(!OrderClose(OrderTicket(), OrderLots(), Bid, 3, White))
                  Print("OrderClose error ", GetLastError());
     }
   if(Open[1] < ma && Close[1] > ma)
     {
      for(int i = 0; i < OrdersTotal(); i++)
         if(OrderSelect(i, SELECT_BY_POS))
            if(OrderSymbol() == _Symbol && OrderMagicNumber() == MAGICMA && OrderType() == OP_SELL)
               if(!OrderClose(OrderTicket(), OrderLots(), Ask, 3, White))
                  Print("OrderClose error ", GetLastError());
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   CheckForOpen();
   CheckForClose();
  }
//+------------------------------------------------------------------+
