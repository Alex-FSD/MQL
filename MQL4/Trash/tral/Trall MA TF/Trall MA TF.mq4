//+---------------------------------------------------------------------------+
//|Трейлинг стоп по МА                                                TrallMA |
//|                                      Copyright © 2011, http://cmillion.ru |
//|---------------------------------------------------------------------------+
#property copyright "Copyright © 2014, http://cmillion.ru"
#property link      "cmillion@narod.ru"
//+------------------------------------------------------------------ 
extern int    Период_МА                 = 14;
extern bool   Тралить_только_прибыльные = true;
extern int    таймфрейм                 = 15;
extern int    отступ                    = 5;
//-------------------------------------------------------------------
int init()
{
   int err;
   if (IsTesting())
   {
      err=OrderSend(Symbol(),OP_BUY, 0.1,Ask,3,0,0,"TrallMA",0,0,Blue);
      err=OrderSend(Symbol(),OP_SELL,0.1,Bid,3,0,0,"TrallMA",0,0,Red);
   }
   return(0);
}
//-------------------------------------------------------------------
int deinit()
{
   return(0);
}
//-------------------------------------------------------------------
int start()
{
   int tip,Ticket,STOPLEVEL=MarketInfo(Symbol(),MODE_STOPLEVEL);
   double OSL,OOP,StL=iMA(NULL,таймфрейм,Период_МА,0,MODE_SMA,PRICE_CLOSE,0),
   StLoB=NormalizeDouble(StL-отступ*Point,Digits),
   StLoS=NormalizeDouble(StL+отступ*Point,Digits);
   for (int i=0; i<OrdersTotal(); i++) 
   {  
      if (OrderSelect(i, SELECT_BY_POS))
      {  
         tip = OrderType();
         if (tip<2 && OrderSymbol()==Symbol())
         {
            OSL   = OrderStopLoss();
            OOP   = OrderOpenPrice();
            Ticket = OrderTicket();
            if (tip==OP_BUY)             
            {
               if (StLoB < OOP && Тралить_только_прибыльные) continue;
               if (StLoB > NormalizeDouble(Bid-STOPLEVEL*Point,Digits)) continue;
               if (StLoB > OSL)
               {  
                  if (!OrderModify(Ticket,OOP,NormalizeDouble(StLoB,Digits),OrderTakeProfit(),0,White)) Print("Error order ",Ticket);
               }
            }                                         
            if (tip==OP_SELL)        
            {
               if (StLoS > OOP && Тралить_только_прибыльные) continue;
               if (StLoS < NormalizeDouble(Ask+STOPLEVEL*Point,Digits)) continue;
               if (StLoS < OSL || OSL==0)
               {  
                  if (!OrderModify(Ticket,OOP,NormalizeDouble(StLoS,Digits),OrderTakeProfit(),0,White)) Print("Error order ",Ticket);
               }
            } 
         }
      }
   }
   return(0);
}
//--------------------------------------------------------------------