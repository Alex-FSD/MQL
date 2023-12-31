//+------------------------------------------------------------------+
//|                                             LastKissBuyRight.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

input double TP1_input = 0.00;
input double TP2_input = 0.00;
input double SL_input = 0.00;

input int    MovingPeriod  = 0;
input int    MovingShift   = 0;

int res;
double Lots = 0.01;
double Low0 = 0.00;
double High100 = 0.00;
double TP = 0.00;
double SL = 0.00;

double CountPips = 0.00;
double Level0 = 0.00;
double Level14 = 0.00;
double Level23 = 0.00;
double Level50 = 0.00;
double Level61 = 0.00;
double Level76 = 0.00;
double Level161 = 0.00;
double Level200 = 0.00;
double Level261 = 0.00;
double Level314 = 0.00;
double Level423 = 0.00;
double Level685 = 0.00;

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
                           Level0 = Low0 + CountPips * 0 * Point;
                           Level14 = Low0 + CountPips * 0.14 * Point;
                           Level23 = Low0 + CountPips * 0.23 * Point;
                           Level50 = Low0 + CountPips * 0.5 * Point;
                           Level61 = Low0 + CountPips * 0.6 * Point;
                           Level76 = Low0 + CountPips * 0.76 * Point;
                           Level161 = Low0 + CountPips * 1.61 * Point;
                           Level200 = Low0 + CountPips * 2 * Point;
                           Level261 = Low0 + CountPips * 2.61 * Point;
                           Level314 = Low0 + CountPips * 3.14 * Point;
                           Level423 = Low0 + CountPips * 4.23 * Point; 
                           Level685 = Low0 + CountPips * 6.85 * Point;
                           
                           //SL = Level61;    
                           SL = Low0 + CountPips * SL_input * Point;
                           
                           if (High[1] > Level161)
                              {
                                    //TP = Level261;
                                    TP = Low0 + CountPips * TP1_input * Point;
                              }
                              else
                                 {
                                    //TP = Level423;
                                    TP = Low0 + CountPips * TP2_input * Point;
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
      if (Close[1] > iMA(NULL,0,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,0)) 
         {
            OnBuyOrder();     
         }
         else
            {
               for(int i=OrdersTotal()-1;i>=0;i--)
                  {
                     res = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
                     if (OrderType() == OP_BUY) res = OrderClose(OrderTicket(),OrderLots(),Bid,1000,0);
                     if (OrderType() == OP_SELL) res = OrderClose(OrderTicket(),OrderLots(),Ask,1000,0);
                  } 
            
               Low0 = 0;
               High100 = 0;
               TP = 0;
               SL = 0; 
            }
  }