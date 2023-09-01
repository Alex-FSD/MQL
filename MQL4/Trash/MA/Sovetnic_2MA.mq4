//+------------------------------------------------------------------+
//|                                             простой советник.mq4 |
//|                               Copyright © 2011, Хлыстов Владимир |
//|                                                cmillion@narod.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, http://cmillion.narod.ru"
#property link      "cmillion@narod.ru"
//--------------------------------------------------------------------
extern int     period_EMA           = 28,
               period_WMA           = 8 ,
               stoploss             = 0,
               takeprofit           = 0;
extern double  LOT                  = 0.1;
extern bool    CloseRevers          = true;
//--------------------------------------------------------------------
int TimeBar;
//--------------------------------------------------------------------
int start()
{
   if (TimeBar==Time[0]) return(0);

   double EMA0 = iMA(NULL,0,period_EMA,0,MODE_EMA, PRICE_OPEN,0);
   double WMA0 = iMA(NULL,0,period_WMA,0,MODE_LWMA,PRICE_OPEN,0);
   double EMA1 = iMA(NULL,0,period_EMA,0,MODE_EMA, PRICE_OPEN,1);
   double WMA1 = iMA(NULL,0,period_WMA,0,MODE_LWMA,PRICE_OPEN,1);
   
   double SL,TP;
   if (EMA0<WMA0&&EMA1>WMA1)
   {
      TimeBar=Time[0];                            
      if (takeprofit!=0) TP  = NormalizeDouble(Ask + takeprofit*Point,Digits); else TP = 0;
      if (stoploss!=0)   SL  = NormalizeDouble(Bid - stoploss*Point,Digits); else SL = 0;
      if (CloseRevers) CLOSEORDER(OP_SELL);
      OrderSend(Symbol(),OP_BUY, LOT,NormalizeDouble(Ask,Digits),2,SL,TP,"простой советник",123,3);
   }
   if (EMA0>WMA0&&EMA1<WMA1)
   {
      TimeBar=Time[0];                            
      if (takeprofit!=0) TP = NormalizeDouble(Bid - takeprofit*Point,Digits); else TP = 0;
      if (stoploss!=0)   SL = NormalizeDouble(Ask + stoploss*Point,Digits); else SL = 0;
      if (CloseRevers) CLOSEORDER(OP_BUY);
      OrderSend(Symbol(),OP_SELL,LOT,NormalizeDouble(Bid,Digits),2,SL,TP,"простой советник",123,3);
   }
return(0);
}
//--------------------------------------------------------------------
void CLOSEORDER(int ord)
{
   for (int i=0; i<OrdersTotal(); i++)
   {                                               
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         if (OrderSymbol()==Symbol() && OrderMagicNumber()==123)
         {
            if (OrderType()==OP_BUY && ord==OP_BUY)
               OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Bid,Digits),3,CLR_NONE);
            if (OrderType()==OP_SELL && ord==OP_SELL)
               OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Ask,Digits),3,CLR_NONE);
         }
      }   
   }
}
//--------------------------------------------------------------------


