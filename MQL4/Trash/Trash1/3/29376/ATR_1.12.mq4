//+------------------------------------------------------------------+
//|                                                     ATR_1.11.mq4 |
//|                        Copyright 2020, Medvedev Vitaliy.         |
//|                         https://www.mql5.com/ru/users/raduga5409 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Medvedev Vitaliy."
#property link      "https://www.mql5.com/ru/users/raduga5409"
#property version   "1.11"
#property strict

sinput string           on          = ">>>>>>>>> Основные насторойки <<<<<<<<<<<  ";
extern int ma_period    = 100;
extern double k         = 2;

sinput string           mm          = ">>>>>>>>> Управление риском <<<<<<<<<<<  ";
extern int StopLoss     = 100;
extern int TakeProfit   = 300;
extern double Risk      = 4;
extern double Lots      = 0.01;

sinput string           tr          =       ">>>>>>>>> Трал <<<<<<<<<<<  ";
extern bool vkl/*вкл/выкл */        = false;
extern int TrailingStop = 30;
extern int TrailingStep = 10;

sinput string           ms         = ">>>>>>>>> Мэджик/Проскальзывание <<<<<<<<<<<  ";
extern int Magic        = 111;
extern int Slippadge    = 30;

double sl,tp, d, SL;
int ticket;
bool NewBar = false;

//+------------------------------------------------------------------+

void OnTick()
{ 
   
   FunNew_Bar();
   if(NewBar == false)
      return;

//+------------------------------------------------------------------+
double ma0 = iMA(Symbol(),0, ma_period, 0, 0, PRICE_CLOSE, 0);


double a0,a1,a2,a3,a4,a5;

      a0 = iHigh(Symbol() ,0,1)-iLow(Symbol() ,0,1);
      a1 = iHigh(Symbol() ,0,2)-iLow(Symbol() ,0,2);
      a2 = iHigh(Symbol() ,0,3)-iLow(Symbol() ,0,3);
      a3 = iHigh(Symbol() ,0,4)-iLow(Symbol() ,0,4);
      a4 = iHigh(Symbol() ,0,5)-iLow(Symbol() ,0,5);
      a5 = iHigh(Symbol() ,0,6)-iLow(Symbol() ,0,6);

double atr = (a1+a2+a3+a4+a5)/5;

   if (CountSell()+ CountBuy() == 0 && a0 > atr*k && Open[1]>Close[1] && !(High[1]>ma0 && Low[1]<ma0))
   {
  
      ticket = OrderSend(Symbol(), OP_BUY,LotsByRisk(OP_BUY, Risk),Ask,Slippadge,0,0,"",Magic,0,Green);
      if (ticket > 0)
      {
         tp = NormalizeDouble(Ask + TakeProfit*Point, Digits);
         sl = NormalizeDouble(Ask - StopLoss*Point, Digits);
         if (OrderSelect(ticket, SELECT_BY_TICKET))
         if(!OrderModify(ticket, OrderOpenPrice(), sl, tp,0))
            Print("Order Buy Not Modify");
      }
   }  
      
   if (CountSell()+ CountBuy() == 0 && a0 > atr*k && Open[1]<Close[1] && !(High[1]>ma0 && Low[1]<ma0))
   {
      ticket = OrderSend(Symbol(), OP_SELL,LotsByRisk(OP_SELL, Risk),Bid,Slippadge,0,0,"",Magic,0,Red);
      if (ticket > 0)
      {
         tp = NormalizeDouble(Bid - TakeProfit*Point, Digits);
         sl = NormalizeDouble(Bid + StopLoss*Point, Digits);
         if (OrderSelect(ticket, SELECT_BY_TICKET))
         if(!OrderModify(ticket, OrderOpenPrice(), sl, tp,0))
            Print("Order Sell Not Modify");
         
      }
      
   }
     if(vkl && !Trailing()) return;

 }       
//+------------------------------------------------------------------+

int CountSell()
  {
   int count = 0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if(OrderSymbol() == Symbol()&&
            OrderMagicNumber() == Magic &&
            (OrderType() == OP_SELL || OP_SELLSTOP))
            count++;
        }
     }
   return(count);
  }
//+------------------------------------------------------------------+

int CountBuy()
  {
   int count = 0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if(OrderSymbol() == Symbol()&&
            OrderMagicNumber() == Magic &&
            (OrderType() == OP_SELL || OP_SELLSTOP))
            count++;
        }
     }
   return(count);
  }
//---  
 void FunNew_Bar()
  {
   static datetime NewTime = 0;
   NewBar = false;
   if(NewTime!=Time[0])
     {
      NewTime = Time[0];
      NewBar = true;
     }
  }
//---  
bool Trailing()
{
   for (int i = 0; i<OrdersTotal(); i++)
   {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol()==Symbol() && OrderMagicNumber() == Magic)
         {
            if(OrderType() == OP_BUY)
            {
               if(Bid - OrderOpenPrice() > TrailingStop*Point)
               {
                  if(OrderStopLoss()<Bid - (TrailingStop + TrailingStep)*Point)
                  {
                     SL = NormalizeDouble(Bid - TrailingStop*Point, Digits);
                     if(OrderStopLoss()!= SL)
                     if (!OrderModify(OrderTicket(), OrderOpenPrice(), SL, 0, 0))
                     Print("Error mod tral buy");
                  }
               }
            }
            if(OrderType()== OP_SELL)
            {
               if(OrderOpenPrice()-Ask > TrailingStop*Point)
               {
                  if(OrderStopLoss()>Ask + (TrailingStop + TrailingStep)*Point)
                  {
                     SL = NormalizeDouble(Ask + TrailingStop*Point, Digits);
                     if(OrderStopLoss()!= SL)
                     if (!OrderModify(OrderTicket(), OrderOpenPrice(), SL, 0, 0))
                     Print("Error mod tral sell");
                  }
               }
            }
         }
      }
   }
   return(false);
}
//---
double LotsByRisk(int op_type, double risk)
{
   double lot_min  = MarketInfo(Symbol(), MODE_MINLOT);
   double lot_max  = MarketInfo(Symbol(), MODE_MAXLOT);
   double lot_step = MarketInfo(Symbol(), MODE_LOTSTEP);
   double lotcost  = MarketInfo(Symbol(), MODE_TICKVALUE);
   
   double lot       = 0;
   double UsdPerPip = 0;
   
   lot = AccountBalance()*risk/100;
   UsdPerPip = lot/StopLoss;
   
   lot = NormalizeDouble(UsdPerPip/lotcost, 2);
   lot = NormalizeDouble(lot/lot_step, 0)* lot_step;
   
   if (lot < lot_min) lot = lot_min;
   if (lot > lot_max) lot = lot_max;
   
   if (AccountFreeMarginCheck(Symbol(), op_type, lot) < 10 || GetLastError()==ERR_NOT_ENOUGH_MONEY)return(-1);
   return(lot);   
}
//---
