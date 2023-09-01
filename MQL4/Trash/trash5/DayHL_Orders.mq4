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
      //��������� �������
      if(TYPE<=0)
      {
         // ����� ��������� STOP-������
         if(iHigh(Symbol(),PERIOD_D1,1)+SPREAD - STOPLEVEL > Ask)
            OrderSend(Symbol(),OP_BUYSTOP,lot,iHigh(Symbol(),PERIOD_D1,1)+SPREAD,3,iHigh(Symbol(),PERIOD_D1,1) - SL*Point,iHigh(Symbol(),PERIOD_D1,1) + TP*Point,NULL,Magic_Number,iTime(Symbol(),PERIOD_D1,0)+PERIOD_D1*60,Aqua);
         else Alert("���������� ���������� OP_BUYSTOP, ���� ������� ������ ��� ���� High");
         if(iLow(Symbol(),PERIOD_D1,1) + STOPLEVEL < Bid)
            OrderSend(Symbol(),OP_SELLSTOP,lot,iLow(Symbol(),PERIOD_D1,1),3,iLow(Symbol(),PERIOD_D1,1) + SPREAD + SL*Point,iLow(Symbol(),PERIOD_D1,1) + SPREAD - TP*Point,NULL,Magic_Number,iTime(Symbol(),PERIOD_D1,0)+PERIOD_D1*60,Magenta);
         else Alert("���������� ���������� OP_SELLSTOP, ���� ������� ������ ��� ���� Low");
      }
      if(TYPE>=1)
      {
         // ����� ��������� LIMIT-������
         if(iHigh(Symbol(),PERIOD_D1,1) - STOPLEVEL > Bid)
            OrderSend(Symbol(),OP_SELLLIMIT,lot,iHigh(Symbol(),PERIOD_D1,1),3,iHigh(Symbol(),PERIOD_D1,1) + SPREAD + SL*Point,iHigh(Symbol(),PERIOD_D1,1) + SPREAD - TP*Point,NULL,Magic_Number,iTime(Symbol(),PERIOD_D1,0)+PERIOD_D1*60,Magenta);
         else Alert("���������� ���������� OP_SELLLIMIT, ���� ������� ������ ��� ���� High");
         if(iLow(Symbol(),PERIOD_D1,1) + STOPLEVEL < Ask)
            OrderSend(Symbol(),OP_BUYLIMIT,lot,iLow(Symbol(),PERIOD_D1,1)+SPREAD,3,iLow(Symbol(),PERIOD_D1,1) - SL*Point,iLow(Symbol(),PERIOD_D1,1) + TP*Point,NULL,Magic_Number,iTime(Symbol(),PERIOD_D1,0)+PERIOD_D1*60,Aqua);
         else Alert("���������� ���������� OP_BUYLIMIT, ���� ������� ������ ��� ���� Low");
      }
   }
   return(0);
}

//---- ���������� ���������� ������� ���������� ��������(������,������) ----//
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