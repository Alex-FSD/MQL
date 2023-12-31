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
double TP = 0.00;
double SL = 0.00;
double Level14 = 0.00;
double Level161 = 0.00;
double Level261 = 0.00;
double Level423 = 0.00;
double CountPips = 0.00;

void CalculateLots()
  {
      Lots = AccountBalance()/1000*0.01;
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
               if ((High100 != 0) && (Close[1]>High100))
                  {
                     if ((High100 != 0) && (Low0 != 0)) 
                        {
                           CountPips = (High100 - Low0)/Point;
                           Level161 = Low0 + CountPips * 1.61 * Point;
                           Level261 = Low0 + CountPips * 2.61 * Point;
                           Level423 = Low0 + CountPips * 4.23 * Point;
                           Level14 = Low0 + CountPips * 0.14 * Point;
                           
                           SL = Level14;    
                           
                           if (High[1] > Level161)
                              {
                                 TP = Level423;
                              }
                              else
                                 {
                                    TP = Level261;
                                 }
                                                      
                        }
                     res = OrderSend(Symbol(),OP_BUY,Lots,Ask,3,SL,TP,"",123123,0,clrGreen);  
                     Low0 = 0;
                     High100 = 0;
                     TP = 0;
                     SL = 0; 
                  }

         }
         else
            {
               Low0 = 0;
               High100 = 0;
               TP = 0;
               SL = 0; 
            }
  }
  
void OnSellOrder()
  {
  }

void OnTick()
  {    
      CalculateLots();  
      //RiskManagment();
      OnBuyOrder();     
  }