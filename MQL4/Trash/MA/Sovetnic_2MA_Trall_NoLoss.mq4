//+------------------------------------------------------------------+
//|                                             простой советник.mq4 |
//|                               Copyright © 2011, Хлыстов Владимир |
//|                                                cmillion@narod.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, http://cmillion.narod.ru"
#property link      "cmillion@narod.ru"
//--------------------------------------------------------------------
extern string  MA1="";     
extern int     period_1             = 5,           //Период усреднения для вычисления первой MA.
               ma_shift_1           = 0,           //Сдвиг индикатора относительно ценового графика.
               ma_method_1          = MODE_EMA,    //Метод усреднения. Может быть любым из значений методов скользящего среднего (Moving Average).
                                                   //MODE_SMA 0 Простое скользящее среднее 
                                                   //MODE_EMA 1 Экспоненциальное скользящее среднее 
                                                   //MODE_SMMA 2 Сглаженное скользящее среднее 
                                                   //MODE_LWMA 3 Линейно-взвешенное скользящее среднее 

               applied_price_1      = PRICE_OPEN,  //Используемая цена. Может быть любой из ценовых констант.
                                                   //PRICE_CLOSE 0 Цена закрытия 
                                                   //PRICE_OPEN 1 Цена открытия 
                                                   //PRICE_HIGH 2 Максимальная цена 
                                                   //PRICE_LOW 3 Минимальная цена 
                                                   //PRICE_MEDIAN 4 Средняя цена, (high+low)/2 
                                                   //PRICE_TYPICAL 5 Типичная цена, (high+low+close)/3 
                                                   //PRICE_WEIGHTED 6 Взвешенная цена закрытия, (high+low+close+close)/4 

               timeframe_1          = 0;           //Период. Может быть одним из периодов графика. 0 означает период текущего графика.
extern string  MA2="";     
extern int     period_2             = 30,          //Период усреднения для вычисления второй MA.
               ma_shift_2           = 0,           //Сдвиг индикатора относительно ценового графика.
               ma_method_2          = MODE_LWMA,   //Метод усреднения. Может быть любым из значений методов скользящего среднего (Moving Average).
               applied_price_2      = PRICE_OPEN,  //Используемая цена. Может быть любой из ценовых констант.
               timeframe_2          = 0;           //Период. Может быть одним из периодов графика. 0 означает период текущего графика.   
extern int     stoploss             = 0,           //стоплосс
               takeprofit           = 0,           //тейкпрофит
               TrailingStop         = 0,           //трейлингстоп, если 0, то нет трейлинга
               NoLoss               = 0,           //перевод в безубыток, если 0, то нет перевода в безубыток
               MaxOrders            = 1;           //максимальное кол-во ордеров одновременно на счете
extern double  LOT                  = 0.1;         //объем ордера
extern bool    CloseRevers          = true;        //закрывать ордера при встречном сигнале
//--------------------------------------------------------------------
int TimeBar,STOPLEVEL,Magic=1234567890;
//--------------------------------------------------------------------
int start()
{
   STOPLEVEL=MarketInfo(Symbol(),MODE_STOPLEVEL);
   if (TrailingStop>=STOPLEVEL) TrailingStop(TrailingStop); else if (TrailingStop>0) TrailingStop(STOPLEVEL+1);
   if (NoLoss>=STOPLEVEL) NoLoss(NoLoss); else if (NoLoss>0) NoLoss(STOPLEVEL+1);
   if (TimeBar==Time[0]) return(0);

   double MA10 = NormalizeDouble(iMA(NULL,timeframe_1,period_1,ma_shift_1,ma_method_1,applied_price_1,0),Digits);
   double MA11 = NormalizeDouble(iMA(NULL,timeframe_1,period_1,ma_shift_1,ma_method_1,applied_price_1,1),Digits);
   double MA20 = NormalizeDouble(iMA(NULL,timeframe_2,period_2,ma_shift_2,ma_method_2,applied_price_2,0),Digits);
   double MA21 = NormalizeDouble(iMA(NULL,timeframe_2,period_2,ma_shift_2,ma_method_2,applied_price_2,1),Digits);

   double SL,TP;
   if (MA10>=MA20&&MA11<MA21)
   {
      if (CloseRevers) CLOSEORDER(OP_SELL);
      if (MaxOrders>OrdersTotal())       
      {
         if (takeprofit!=0) TP  = NormalizeDouble(Ask + takeprofit*Point,Digits); else TP = 0;
         if (stoploss!=0)   SL  = NormalizeDouble(Bid - stoploss*Point,Digits); else SL = 0;
         if (OrderSend(Symbol(),OP_BUY, LOT,NormalizeDouble(Ask,Digits),2,SL,TP,"простой советник",Magic,3)!=-1) TimeBar=Time[0]; 
         else Print("OrderSend BUY Error ",GetLastError(),"  SL ",SL,"  TP ",TP);
      }
   }
   if (MA10<=MA20&&MA11>MA21)
   {
      if (CloseRevers) CLOSEORDER(OP_BUY);
      if (MaxOrders>OrdersTotal()) 
      {
         if (takeprofit!=0) TP = NormalizeDouble(Bid - takeprofit*Point,Digits); else TP = 0;
         if (stoploss!=0)   SL = NormalizeDouble(Ask + stoploss*Point,Digits); else SL = 0;
         if (OrderSend(Symbol(),OP_SELL,LOT,NormalizeDouble(Bid,Digits),2,SL,TP,"простой советник",Magic,3)!=-1) TimeBar=Time[0]; 
         else Print("OrderSend SELL Error ",GetLastError(),"  SL ",SL,"  TP ",TP);
      }
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
         if (OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
         {
            if (OrderType()==OP_BUY && ord==OP_BUY)
               bool res = OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Bid,Digits),3,CLR_NONE);
            if (OrderType()==OP_SELL && ord==OP_SELL)
               res = OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Ask,Digits),3,CLR_NONE);
         }
      }   
   }
}
//--------------------------------------------------------------------
void TrailingStop(int TS)
{
   int tip,Ticket;
   double StLo,OSL,OOP;
   for (int i=0; i<OrdersTotal(); i++) 
   {  if (OrderSelect(i, SELECT_BY_POS))
      {  tip = OrderType();
         if (tip<2 && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
         {
            OSL   = NormalizeDouble(OrderStopLoss(),Digits);
            OOP   = NormalizeDouble(OrderOpenPrice(),Digits);
            Ticket = OrderTicket();
            if (tip==OP_BUY)             
            {
               StLo = NormalizeDouble(Bid-TS*Point,Digits);
               if (StLo > OSL && StLo > OOP)
               {  if (!OrderModify(Ticket,OOP,StLo,OrderTakeProfit(),0,White))
                     Print("TrailingStop Error ",GetLastError()," buy SL ",OSL,"->",StLo);
               }
            }                                         
            if (tip==OP_SELL)        
            {
               StLo = NormalizeDouble(Ask+TS*Point,Digits);
               if (StLo > OOP || StLo==0) continue;
               if (StLo < OSL || OSL==0 )
               {  if (!OrderModify(Ticket,OOP,StLo,OrderTakeProfit(),0,White))
                     Print("TrailingStop Error ",GetLastError()," sell SL ",OSL,"->",StLo);
               }
            } 
         }
      }
   }
}
//--------------------------------------------------------------------
void NoLoss(int NoLo)
{
   int tip,Ticket;
   double StLo,OSL,OOP;
   for (int i=0; i<OrdersTotal(); i++) 
   {  if (OrderSelect(i, SELECT_BY_POS))
      {  tip = OrderType();
         if (tip<2 && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
         {
            OSL   = NormalizeDouble(OrderStopLoss(),Digits);
            OOP   = NormalizeDouble(OrderOpenPrice(),Digits);
            Ticket = OrderTicket();
            if (tip==OP_BUY)             
            {
               if (OSL>OOP) continue;
               StLo = NormalizeDouble(OOP+Point,Digits);
               if (NormalizeDouble((Bid-OOP)/Point,0)>=NoLo)
               {  if (!OrderModify(Ticket,OOP,StLo,OrderTakeProfit(),0,White))
                     Print("NoLoss Error ",GetLastError()," buy SL ",OSL,"->",StLo);
               }
            }                                         
            if (tip==OP_SELL)        
            {
               if (OSL<OOP) continue;
               StLo = NormalizeDouble(OOP-Point,Digits);
               if (NormalizeDouble((OOP-Ask)/Point,0)>=NoLo)
               {  if (!OrderModify(Ticket,OOP,StLo,OrderTakeProfit(),0,White))
                     Print("NoLoss Error ",GetLastError()," sell SL ",OSL,"->",StLo);
               }
            } 
         }
      }
   }
}
//--------------------------------------------------------------------

