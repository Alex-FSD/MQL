//+---------------------------------------------------------------------------+
//|�������� ���� �� ��                                                TrallMA |
//|                                      Copyright � 2011, http://cmillion.ru |
//|---------------------------------------------------------------------------+
#property copyright "Copyright � 2014, http://cmillion.ru"
#property link      "cmillion@narod.ru"
//+------------------------------------------------------------------ 
extern int    ������_��                 = 14;
extern bool   �������_������_���������� = true;
extern int    ���������                 = 15;
extern int    ������                    = 5;
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
   double OSL,OOP,StL=iMA(NULL,���������,������_��,0,MODE_SMA,PRICE_CLOSE,0),
   StLoB=NormalizeDouble(StL-������*Point,Digits),
   StLoS=NormalizeDouble(StL+������*Point,Digits);
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
               if (StLoB < OOP && �������_������_����������) continue;
               if (StLoB > NormalizeDouble(Bid-STOPLEVEL*Point,Digits)) continue;
               if (StLoB > OSL)
               {  
                  if (!OrderModify(Ticket,OOP,NormalizeDouble(StLoB,Digits),OrderTakeProfit(),0,White)) Print("Error order ",Ticket);
               }
            }                                         
            if (tip==OP_SELL)        
            {
               if (StLoS > OOP && �������_������_����������) continue;
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