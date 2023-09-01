//+------------------------------------------------------------------+
//|                                                 TrailingStop.mq4 |
//|                              Copyright © 2014, Khlystov Vladimir |
//|                                         http://cmillion.narod.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2014, cmillion@narod.ru"
#property link      "http://cmillion.narod.ru"
//--------------------------------------------------------------------
input int     StopLoss     = 50;     //стоплосс
input int     TakeProflt   = 100;     //желаемая прибыль).
input int     TrailingStop = 10;     //как прибыль ордера достигает этого значения в пунктах, Stop Loss переносится на на цену открытия ордера и далее тралится по профиту. 
input int     StepTrall    = 10;     //Шаг Трала.
//--------------------------------------------------------------------
int start()                                  
{      
   double OSL,OTP,OOP,StLo,SL,TP;
   int tip;
   for (int i=0; i<OrdersTotal(); i++)
   {    
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      { 
         if (OrderSymbol()==Symbol())
         { 
            tip = OrderType(); 
            OSL = NormalizeDouble(OrderStopLoss(),Digits);
            OTP = NormalizeDouble(OrderTakeProfit(),Digits);
            OOP = NormalizeDouble(OrderOpenPrice(),Digits);
            SL=OSL;TP=OTP;
            if (tip==OP_BUY)             
            {  
               if (OSL==0 &&StopLoss!=0)
               {
                  SL = NormalizeDouble(OOP - StopLoss   * Point,Digits);
               } 
               if (OTP==0 && TakeProflt!=0)
               {
                  TP = NormalizeDouble(OOP + TakeProflt * Point,Digits);
               } 
               if (TrailingStop!=0)
               {
                  StLo = NormalizeDouble(Bid - TrailingStop*Point,Digits); 
                  if (StLo >= OOP && StLo >= OSL+StepTrall*Point) SL = StLo;
               }
               if (SL != OSL || TP != OTP)
               {  
                  if (!OrderModify(OrderTicket(),OOP,SL,TP,0,White)) Print("Error OrderModify ",GetLastError());
               }
            }                                         
            if (tip==OP_SELL)        
            {
               if (OSL==0 && StopLoss!=0)
               {
                  SL = NormalizeDouble(OOP + StopLoss   * Point,Digits);
               }
               if (OTP==0 && TakeProflt!=0)
               {
                  TP = NormalizeDouble(OOP - TakeProflt * Point,Digits);
               }
               if (TrailingStop!=0)
               {
                  StLo = NormalizeDouble(Ask + TrailingStop*Point,Digits); 
                  if (StLo <= OOP && (StLo <= OSL-StepTrall*Point || OSL==0)) SL = StLo;
               }
               if (SL != OSL || TP != OTP)
               {  
                  if (!OrderModify(OrderTicket(),OOP,SL,TP,0,White)) Print("Error OrderModify ",GetLastError());
               }
            } 
         }
      }
   } 
   int err;
   if (IsTesting() && OrdersTotal()==0)
   {
      double Lot=0.1;
      err=OrderSend(Symbol(),OP_BUY,Lot,NormalizeDouble(Ask,Digits),30,0,0,"тест",0);
      err=OrderSend(Symbol(),OP_SELL,Lot,NormalizeDouble(Bid,Digits),30,0,0,"тест",0);
      return(0);
   }
   return(0);
}
//+------------------------------------------------------------------+