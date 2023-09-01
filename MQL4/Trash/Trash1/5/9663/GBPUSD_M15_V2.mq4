//---- ������� ���������---------------
extern string Long="��������� ������� �������";
extern int    PeriodMA1=20;
extern int    ���_��������1 = 16;
extern int    ���_��������1 = 8;
extern string Short="��������� �������� �������";
extern int    PeriodMA2=20;
extern int    ���_��������2 = 6;
extern int    ���_��������2 = 13;
extern string ��="���������� �� � ��������� �� ����";
extern double �������_TP=0.6; 
extern string ������="��������� ������� ����������� �� ����/���� �������� �� ... �������";
extern int    ProfitPips=35;
extern string �����="��������� ������";
extern int    Period_MA=200;
extern int    n_MA=2;
extern string lot="��������� �������� ����";
extern double Lots=0.01;
extern string ��="��������� ���������� ����������";
extern double Loss = 0.02;    // �������� ������ � ��������� �� ���� ������
extern int    �������=0; //����� ������ 0-��� �� 1-������ % �� ��������� 2- �������� ������� % �� �������
extern string x1="��� ���������� ������� � 5 ������� x �������� �� 10";
extern int    x=10;
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
static datetime    dt;
static bool   permission_long = true, permission_short = true; // ���������� ������� � �������� �������
int start()
  {
  double a;// ���������� �-������ � ������
  int n=1; // ������ �������� � ����� �� ��������
  int total,cnt;
  int TP=0;
  int magik_Buy=13;
  int magik_Sell=14;
  int ���_��=0, ���_���=0;
  double MA11=iMA(NULL,0,PeriodMA1,0,MODE_SMA,PRICE_MEDIAN,1);
  double MA12=iMA(NULL,0,PeriodMA1,0,MODE_SMA,PRICE_MEDIAN,2);
  double MA21=iMA(NULL,0,PeriodMA2,0,MODE_SMA,PRICE_MEDIAN,1);
  double MA22=iMA(NULL,0,PeriodMA2,0,MODE_SMA,PRICE_MEDIAN,2);
  double Medium1=iMA(NULL,0,1,0,MODE_SMA,PRICE_MEDIAN,1);
  double Medium2=iMA(NULL,0,1,0,MODE_SMA,PRICE_MEDIAN,2);
  double MA_Long1=iMA(NULL,0,Period_MA,0,MODE_EMA,PRICE_MEDIAN,1);
  double MA_Long_n=iMA(NULL,0,Period_MA,0,MODE_EMA,PRICE_MEDIAN,n_MA);
  
  if(dt!=iTime(NULL,PERIOD_D1,0)) // ���������� �������� ������ ��� 
  {
  permission_long = true;         // ��������� �������� ������� ������� �� ���� ����
  permission_short = true;        // ��������� �������� �������� ������� �� ���� ����
  dt=iTime(NULL,PERIOD_D1,0);     // ���������� ����� �������� ������� �����
  }
  total=OrdersTotal();
  for(cnt=0;cnt<total;cnt++)
      {
         OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         if(OrderType()<=OP_SELL &&   // check for opened position 
         OrderSymbol()==Symbol())  // check for symbol
         {
         if(OrderMagicNumber()==magik_Buy) ���_��=���_��+1;
         if(OrderMagicNumber()==magik_Sell) ���_���=���_���+1;
         }
      }
        
     for(cnt=0;cnt<total;cnt++)
      {
         OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         if(OrderType()<=OP_SELL &&   // check for opened position 
         OrderSymbol()==Symbol())  // check for symbol
         {
         // ---------------------��������-------------------------------------------------
         if(OrderType()==OP_BUY && OrderMagicNumber()==magik_Buy)
         {
            if(Hour()==���_��������1)
            {
               OrderClose(OrderTicket(),OrderLots(),Bid,3*x,Red);
               Sleep(60000); // �������� � 60 ������
               return(0);
            }
            if(Medium1>MA11 && Medium2<=MA12 && Bid-OrderOpenPrice()>ProfitPips*x*Point)
            {
               OrderClose(OrderTicket(),OrderLots(),Bid,3*x,Red);
               Sleep(60000); // �������� � 60 ������
               return(0);
            }
            
         }
         //-------------------��������----------------------------------------------------  
         if(OrderType()==OP_SELL && OrderMagicNumber()==magik_Sell)
         {
            if(Hour()==���_��������2)
            {
               OrderClose(OrderTicket(),OrderLots(),Ask,3*x,Red);
               Sleep(60000); // �������� � 60 ������
               return(0);
            }
            if(Medium1<MA21 && Medium2>=MA22 && OrderOpenPrice()-Ask>ProfitPips*x*Point)
            {
               OrderClose(OrderTicket(),OrderLots(),Ask,3*x,Red);
               Sleep(60000); // �������� � 60 ������
               return(0);
            }
         }               
  
         }
      }
   if((Hour()==���_��������1 || Hour()==���_��������1+n) && permission_long==true && ���_��<1) // ���� ��� �������
     {
      // �������� ������� �������
      if(Medium1>MA11 && MA11>MA12 && MA_Long1>MA_Long_n)
        {
        a=MathAbs(Ask*0.01);
        Lots=ValueLot(a);
        TP=������_TP(Ask,�������_TP);
        if(buy(TP,magik_Buy,Lots)!=-1) permission_long = false;
        Sleep(60000); // �������� � 60 ������
        return(0);
        }
      }
   if((Hour()==���_��������2 || Hour()==���_��������2+n) && permission_short == true && ���_���<1) // ���� ��� �������
     {   
      // �������� �������� �������
      if(Medium1<MA21 && MA21<MA22 && MA_Long1<MA_Long_n)
        {
         a=MathAbs(Bid*0.01);
         Lots=ValueLot(a);
         TP=������_TP(Bid,�������_TP);
         if(sell(TP,magik_Sell,Lots)!=-1) permission_short = false;
         Sleep(60000); // �������� � 60 ������
         return(0);
        }
     }
//---------------------------------------------------------------------------------------   
return(0);
}
double ������_TP(double A,double B)
   {
   int x=0;
   double y=A*B/100;
   x=MathRound(y/Point);
   if (x<30*x) x=30*x;
   return(x); 
   }

int sell(int TP, int magik_Sell, double Lot)         //������� ����� � �������� �������
   {
   int t=-1;
   t=OrderSend(Symbol(),OP_SELL,Lot,Bid,3*x,0,Bid-TP*Point,"order_sell",magik_Sell,0,Red);
   return(t);
   }

int buy(int TP, int magik_Buy, double Lot)           //������� ����� � ������� �������
   {
   int t=-1;
   t=OrderSend(Symbol(),OP_BUY,Lot,Ask,3*x,0,Ask+TP*Point,"order_buy",magik_Buy,0,Green);
   return(t);
   }
double ValueLot (double A)
   {
   RefreshRates();
   double ticvalue=MarketInfo(Symbol(),MODE_TICKVALUE);
   double minlot=MarketInfo(Symbol(),MODE_MINLOT);   
   double maxlot=MarketInfo(Symbol(),MODE_MAXLOT);
   double standartlot=MarketInfo(Symbol(),MODE_LOTSIZE);
   double x=0;
   if (�������==0) x=Lots;
   if(�������==1) x=NormalizeDouble(MathFloor((AccountFreeMargin()*Loss*Point)/(ticvalue*A*minlot))*minlot,2);
   if(�������==2) x=NormalizeDouble(minlot*((AccountFreeMargin()*Loss)/(1000*minlot)),2);
   if(�������==3)
   {
   double bb=MathSqrt(AccountFreeMargin()/1000);
   x=NormalizeDouble(bb*Loss,2);
   }
   if(x>=maxlot) x=maxlot;
   if(x<=minlot) x=minlot;   
   return(x);
   }
  