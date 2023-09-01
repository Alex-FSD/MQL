//+------------------------------------------------------------------+
//|                                            LastKissSellRight.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

int res;
double Lots = 1;
double High0 = 0.00;
double Low100 = 0.00;

void OnSellOrder()
  {
      if (High0 == 0)
         {  
            if (Close[1]<Close[2] && Close[1]<Open[1] && Close[2]>Open[2])
               {
                  High0 = High[1];   
               }
         }
      else    
      if (Close[1]<High0)
         {      
            if ((Close[1]>Open[1]) && (Low100 == 0)) 
               {
                  Low100 = Low[1];   
               }
               else
               if ((Low100 != 0) && (Close[1]<Low100) && (Close[1]<Open[1]))
                  {
                     res = OrderSend(Symbol(),OP_SELL,Lots,Bid,3,High0,Low100-(High0-Low100)*1.5,"",123123,0,clrRed);  
                     High0 = 0;
                     Low100 = 0;
                  }

         }
         else
            {
               High0 = 0;
               Low100 = 0;
            }
  }

void OnTick()
  {    
      OnSellOrder();     
  }