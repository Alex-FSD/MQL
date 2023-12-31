//+------------------------------------------------------------------+
//|                                             LastKissBuyRight.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

int res;
double Lots = 1;
double Low0 = 0.00;
double High100 = 0.00;

void CalculateLots()
  {
      Lots = AccountBalance()/100*0.01;
  }

void RiskManagment()
  {
     for(int i=0; i<OrdersTotal(); i++)
     {
         if (OrderSelect(i, SELECT_BY_POS,MODE_TRADES) == true)
            if ((OrderProfit() < 0) && ((OrderProfit() * (-1))) > (AccountBalance()*0.1))
            {
               res = OrderClose(OrderTicket(),OrderLots(),Bid,3,clrRed);      
            }
     }
  }

void OnBuyOrder()
  {
      if (Low0 == 0)
         {  
            if (Close[1]>Close[2] && Close[1]>Open[1] && Close[2]<Open[2])
               {
                  Low0 = Low[1]; 
               }
         }
      else    
      if (Close[1]>Low0)
         {      
            if ((Close[1]<Open[1]) && (High100 == 0)) 
               {
                  High100 = High[1];   
               }
               else
               if ((High100 != 0) && (Close[1]>High100) && (Close[1]>Open[1]))
                  {
                     res = OrderSend(Symbol(),OP_BUY,Lots,Ask,3,Low0,High100+(High100-Low0)*1.5,"",123123,0,clrGreen);  
                     Low0 = 0;
                     High100 = 0;
                  }

         }
         else
            {
               Low0 = 0;
               High100 = 0;
            }
  }
  
void OnSellOrder()
  {
  }

void OnTick()
  {    
      //CalculateLots();  
      //RiskManagment();
      OnBuyOrder();     
  }