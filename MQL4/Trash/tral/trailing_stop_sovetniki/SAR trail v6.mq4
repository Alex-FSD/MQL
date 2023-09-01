//+------------------------------------------------------------------+
//|                                                 SAR trail v4.mq4 |
//|                                   Copyright © 2009, Maxim Markov |
//|                                                   marmax@mail.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, Maxim Markov"
#property link      "marmax@mail.ru"

extern int DistancePoints     =1; 
extern bool AllowLoss         =true;

int AccuracyPoints            =1;
double SARstep                =0.02;
double SARmaximum             =0.2;

int init()
   {
    Print("SAR Trail v.4 Copyright © 2009, Maxim Markov  marmax@mail.ru");
    return(0);
   }

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
   double Distance            =DistancePoints*Point;
   double Accuracy            =AccuracyPoints*Point;
   double StopCurrent         =0;
   double StopRequired        =0;
   double StopAllowed         =0;
   double StopSet             =0;
   double Spread              =MarketInfo(Symbol(), MODE_SPREAD)*Point;
   double Minimum_Distance    =MarketInfo(Symbol(), MODE_STOPLEVEL)*Point;
   
   for(int i=0;i<OrdersTotal();i++)
      {
       if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==FALSE) break;
       if (OrderSymbol()==Symbol())
         {
          StopCurrent=OrderStopLoss();
          if ((OrderType()==OP_BUY) && (Close[0]>iSAR(NULL,0,SARstep,SARmaximum,0)))
            {
             StopRequired=iSAR(NULL,0,SARstep,SARmaximum,0)-Distance;
             StopAllowed=Close[0]-Minimum_Distance;
             StopSet=MathMin(StopAllowed, StopRequired);
             if ((StopSet > StopCurrent+Accuracy) && (StopRequired >= OrderOpenPrice()||AllowLoss))
               OrderModify(OrderTicket(),OrderOpenPrice(),StopSet,OrderTakeProfit(),0);            
            }
          if ((OrderType()==OP_SELL) && (Close[0]<iSAR(NULL,0,SARstep,SARmaximum,0)))
            {
             StopRequired=iSAR(NULL,0,SARstep,SARmaximum,0)+Spread+Distance;
             StopAllowed=Close[0]+Spread+Minimum_Distance;
             StopSet=MathMax(StopAllowed, StopRequired);
             if (((StopSet < StopCurrent-Accuracy) || (StopCurrent == 0)) && (StopRequired <= OrderOpenPrice() || AllowLoss))
               OrderModify(OrderTicket(),OrderOpenPrice(),StopSet,OrderTakeProfit(),0);
            }
         }
      }
    return(0);
  }
//+------------------------------------------------------------------+