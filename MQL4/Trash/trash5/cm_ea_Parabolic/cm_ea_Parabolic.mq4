//+------------------------------------------------------------------+
//|                               Copyright © 2014, ’лыстов ¬ладимир |
//|                                                cmillion@narod.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2014, cmillion@narod.ru"
#property link      "cmillion@narod.ru"
//--------------------------------------------------------------------
extern int     Stoploss    = 50,
               Takeprofit  = 10;     
extern double  Lot         = 0.1;

extern double  Step        = 0.02;  //параметр Parabolic Step
extern double  Maximum     = 0.2;   //параметр Parabolic Maximum

extern int     Magic       = 123,   //уникальный номер ордеров этого советника, если 0 то ведет все ордера, в том числе выставленные вручную
               slippage    = 3;     //ћаксимально допустимое отклонение цены дл€ рыночных ордеров
//--------------------------------------------------------------------
int start()
{
   double Parab0 = iSAR(NULL,0,Step,Maximum,1);
   double Parab1 = iSAR(NULL,0,Step,Maximum,2);

   double STOPLEVEL=MarketInfo(Symbol(),MODE_STOPLEVEL);
   double OSL,OTP,OOP,SL,TP;
   int bTicket=0,sTicket=0,Type;
   for (int i=0; i<OrdersTotal(); i++)
   {    
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      { 
         if (OrderSymbol()==Symbol() && Magic==OrderMagicNumber())
         { 
            Type = OrderType(); 
            OSL = NormalizeDouble(OrderStopLoss(),Digits);
            OTP = NormalizeDouble(OrderTakeProfit(),Digits);
            OOP = NormalizeDouble(OrderOpenPrice(),Digits);
            SL=OSL;TP=OTP;
            if (Type==OP_BUY)             
            {  
               bTicket=OrderTicket();
               if (OSL==0 && Stoploss>=STOPLEVEL && Stoploss!=0)
               {
                  SL = NormalizeDouble(OOP - Stoploss   * Point,Digits);
               } 
               if (OTP==0 && Takeprofit>=STOPLEVEL && Takeprofit!=0)
               {
                  TP = NormalizeDouble(OOP + Takeprofit * Point,Digits);
               } 
               if (SL != OSL || TP != OTP)
               {  
                  if (!OrderModify(bTicket,OOP,SL,TP,0,CLR_NONE)) Print("Error OrderModify ",GetLastError());
               }
            }                                         
            if (Type==OP_SELL)        
            {
               sTicket=OrderTicket();
               if (OSL==0 && Stoploss>=STOPLEVEL && Stoploss!=0)
               {
                  SL = NormalizeDouble(OOP + Stoploss   * Point,Digits);
               }
               if (OTP==0 && Takeprofit>=STOPLEVEL && Takeprofit!=0)
               {
                  TP = NormalizeDouble(OOP - Takeprofit * Point,Digits);
               }
               if (SL != OSL || TP != OTP)
               {  
                  if (!OrderModify(sTicket,OOP,SL,TP,0,CLR_NONE)) Print("Error OrderModify ",GetLastError());
               }
            } 
         }
      }
   } 
   if (Parab1 < Bid && Parab0 > Bid)
   {
      if (bTicket>0) 
         if (OrderClose(bTicket,Lot,NormalizeDouble(Bid,Digits),slippage,CLR_NONE)) Comment("Close ",bTicket);
      if (sTicket==0) 
         if (OrderSend(Symbol(),OP_SELL, Lot,NormalizeDouble(Bid,Digits),slippage,0,0,NULL,Magic,0,CLR_NONE)==-1) Comment("Open SELL");
   }
   if (Parab1 > Bid && Parab0 < Bid)
   {
      if (sTicket>0) 
         if (OrderClose(sTicket,Lot,NormalizeDouble(Ask,Digits),slippage,CLR_NONE)) Comment("Close ",sTicket);
      if (bTicket==0) 
         if (OrderSend(Symbol(),OP_BUY, Lot,NormalizeDouble(Ask,Digits),slippage,0,0,NULL,Magic,0,CLR_NONE)==-1) Comment("Open BUY");
   }
   return(0);
}
//--------------------------------------------------------------------
