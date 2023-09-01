//+------------------------------------------------------------------+
//|                                                 DayHL_Orders.mq4 |
//|                                                               TO |
//|                             http://forex-tradexperts-to.narod.ru |
//+------------------------------------------------------------------+
#property copyright "TO"
#property link      "http://forex-tradexperts-to.narod.ru"

extern int TYPE = 0;
extern int TP = 20;
extern int SL = 50;
extern double lot = 0.1;
extern int Magic_Number = 639713;

int init(){   return(0);}
int deinit(){   return(0);}
int start()
{
   double SPREAD = MarketInfo(Symbol(),MODE_SPREAD)*Point;
   double STOPLEVEL = MarketInfo(Symbol(),MODE_STOPLEVEL)*Point;
   if(Orders_Total( Magic_Number, Symbol()) == 0 )
   {
      //Установка ордеров
      if(TYPE<=0)
      {
         // Здесь установим STOP-ордера
         if(iHigh(Symbol(),PERIOD_D1,1)+SPREAD - STOPLEVEL > Ask)
            OrderSend(Symbol(),OP_BUYSTOP,lot,iHigh(Symbol(),PERIOD_D1,1)+SPREAD,3,iHigh(Symbol(),PERIOD_D1,1) - SL*Point,iHigh(Symbol(),PERIOD_D1,1) + TP*Point,NULL,Magic_Number,iTime(Symbol(),PERIOD_D1,0)+PERIOD_D1*60,Aqua);
         else Alert("Невозможно установить OP_BUYSTOP, цена слишком близка или выше High");
         if(iLow(Symbol(),PERIOD_D1,1) + STOPLEVEL < Bid)
            OrderSend(Symbol(),OP_SELLSTOP,lot,iLow(Symbol(),PERIOD_D1,1),3,iLow(Symbol(),PERIOD_D1,1) + SPREAD + SL*Point,iLow(Symbol(),PERIOD_D1,1) + SPREAD - TP*Point,NULL,Magic_Number,iTime(Symbol(),PERIOD_D1,0)+PERIOD_D1*60,Magenta);
         else Alert("Невозможно установить OP_SELLSTOP, цена слишком близка или ниже Low");
      }
      if(TYPE>=1)
      {
         // Здесь установим LIMIT-ордера
         if(iHigh(Symbol(),PERIOD_D1,1) - STOPLEVEL > Bid)
            OrderSend(Symbol(),OP_SELLLIMIT,lot,iHigh(Symbol(),PERIOD_D1,1),3,iHigh(Symbol(),PERIOD_D1,1) + SPREAD + SL*Point,iHigh(Symbol(),PERIOD_D1,1) + SPREAD - TP*Point,NULL,Magic_Number,iTime(Symbol(),PERIOD_D1,0)+PERIOD_D1*60,Magenta);
         else Alert("Невозможно установить OP_SELLLIMIT, цена слишком близка или выше High");
         if(iLow(Symbol(),PERIOD_D1,1) + STOPLEVEL < Ask)
            OrderSend(Symbol(),OP_BUYLIMIT,lot,iLow(Symbol(),PERIOD_D1,1)+SPREAD,3,iLow(Symbol(),PERIOD_D1,1) - SL*Point,iLow(Symbol(),PERIOD_D1,1) + TP*Point,NULL,Magic_Number,iTime(Symbol(),PERIOD_D1,0)+PERIOD_D1*60,Aqua);
         else Alert("Невозможно установить OP_BUYLIMIT, цена слишком близка или ниже Low");
      }
   }
   return(0);
}

//---- Возвращает количество ордеров указанного эксперта(Маджик,Символ) ----//
int Orders_Total( int mn, string sym)
{
   int num_orders=0;
   for(int i= OrdersTotal()-1;i>=0;i--)
   {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderMagicNumber() == mn && sym==OrderSymbol())
         num_orders++;
   }
   return(num_orders);
}