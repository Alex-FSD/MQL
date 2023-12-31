//+------------------------------------------------------------------+
//|                                                         Corr.mq4 |
//|                                Copyright 2020, Medvedev Vitaliy. |
//|                         https://www.mql5.com/ru/users/raduga5409 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Medvedev Vitaliy."
#property link      "https://www.mql5.com/ru/users/raduga5409"
#property version   "1.0"
#property strict

input string sn =" >>>>>>>>>>> НАСТРОЙКИ СИГНАЛОВ <<<<<<<<<<<< ";

extern int DeltaBuy      = 2650;
extern int MA_PeriodB    = 80;
extern int MA_MetodB      = 0;

extern int DeltaSell     = 1650;
extern int MA_PeriodS    = 25;
extern int MA_MetodS      = 1;

input string mm =" >>>>>>>>>>> УПРАВЛЕНИЕ РИСКОМ <<<<<<<<<<<< ";

extern int StopLoss    = 130;
extern int TakeProfit_S  = 18900;

//extern int StopLoss    = 130;
extern int TakeProfit_B  = 18100;

extern double Lots       = 0.01;
extern double Risk          = 1;
extern int Slippadge     = 30;

input string mg = "      >>>>>>>>>>>   Magic  <<<<<<<<<<<< ";

extern int Magic         = 1234;

double tp,sl;
//+------------------------------------------------------------------+
int SignalBuy()
{
      double Db = 0;
      double prise = Low[1];
      double ma2   = iMA(Symbol(), 0, MA_PeriodB,0, MA_MetodB, PRICE_CLOSE, 1);
      if(prise < ma2)
      {
        Db = ma2-prise;
        if(Db < DeltaBuy)return(1);
      }
      return(0);
}
//+------------------------------------------------------------------+
int SignalSell()
{
      double Ds = 0;
      double prise = High[1];
      double ma1   = iMA(Symbol(), 0, MA_PeriodS,0, MA_MetodS, PRICE_CLOSE, 1);
      if(prise > ma1)
      {
        Ds = prise - ma1;
        if(Ds < DeltaSell)return(-1);
      }
      return(0);
}
//+------------------------------------------------------------------+
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
            OrderType() == OP_SELL)
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
            (OrderType() == OP_BUY ))
            count++;
        }
     }
   return(count);
  }

//+------------------------------------------------------------------+
void Open_Sell()
  {

   if(CountSell() + CountBuy() == 0 && SignalSell() == -1)
     {
      int ticket = OrderSend(Symbol(), OP_SELL, LotsByRisk(OP_SELL, Risk), Bid, Slippadge,0,0, "Corr_test", Magic, 0, Red);

      if(ticket > 0)
        {
         tp = NormalizeDouble(Bid - TakeProfit_S*Point, Digits);
         sl = NormalizeDouble(Bid + StopLoss*Point, Digits);
         if(OrderSelect(ticket, SELECT_BY_TICKET))
            if(!OrderModify(ticket, OrderOpenPrice(), sl, tp,0))
               Print("Order Sell Not Modify");
        }
     }
  }
//+------------------------------------------------------------------+
void Open_Buy()
  {

   if(CountSell() + CountBuy() == 0 && SignalBuy() == 1)
     {
      int ticket = OrderSend(Symbol(), OP_BUY, LotsByRisk( OP_BUY, Risk), Ask, Slippadge,0,0, "Corr_test", Magic, 0, Green);

      if(ticket > 0)
        {
         tp = NormalizeDouble(Ask + TakeProfit_B*Point, Digits);
         sl = NormalizeDouble(Ask - StopLoss*Point, Digits);
         if(OrderSelect(ticket, SELECT_BY_TICKET))
            if(!OrderModify(ticket, OrderOpenPrice(), sl, tp,0))
               Print("Order Sell Not Modify");
        }
     }
  }
bool NewBar = false;
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
//+------------------------------------------------------------------+
void OnTick()
  {
     FunNew_Bar();
     if(NewBar == false)
     return;
       
     Open_Sell();
     Open_Buy();
  }
//+------------------------------------------------------------------+
