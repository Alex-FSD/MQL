//+-----------------------------------------------------------------------------------------------+
//|                                                                     Simple Moving Average.mq4 |
//|                                                                 Copyright 2016, Andrey Minaev |
//|                                                     https://www.mql5.com/ru/users/id.scorpion |
//+-----------------------------------------------------------------------------------------------+
#property copyright "Copyright 2016, Andrey Minaev"
#property link      "https://www.mql5.com/ru/users/id.scorpion"
#property version   "1.00"
#property strict

// ��������� ���������
extern string sParametersEA = "";     // ��������� ���������
extern double dLots         = 0.01;   // ���������� �����
extern int    iStopLoss     = 30;     // ������� ������ (� �������)
extern int    iTakeProfit   = 30;     // ������� ������� (� �������)
extern int    iSlippage     = 3;      // ��������������� (� �������)
extern int    iMagic        = 1;      // �������������� ���������
// ��������� ����������
extern string sParametersMA = "";     // ��������� ���������� 
extern int    iPeriodMA     = 14;     // ������ ����������
// ���������� ����������
double dMA;
//+-----------------------------------------------------------------------------------------------+
int OnInit()
{
   // ���� ������ ���������� 3 ��� 5 ������ ����� �������, �� �������� �� 10 
   if(Digits == 3 || Digits == 5)
   {
      iStopLoss   *= 10;
      iTakeProfit *= 10;
      iSlippage   *= 10;
   }
   
   return(INIT_SUCCEEDED);
}
//+-----------------------------------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   
}
//+-----------------------------------------------------------------------------------------------+
void OnTick()
{
   // ������� �������� ����������
   dMA = iMA(Symbol(), 0, iPeriodMA, 0, MODE_SMA, PRICE_CLOSE, 0);
   
   // ���� ��� �������� �������, �� ������ � �������
   if(bCheckOrders() == true)
   {
      // ���� �������� ������ �� �������, �� ������� ����� �� �������
      if(bSignalBuy() == true)
         vOrderOpenBuy();
      
      // ���� �������� ������ �� �������, �� ������� ����� �� �������
      if(bSignalSell() == true)
         vOrderOpenSell();      
   }
}
//+-----------------------------------------------------------------------------------------------+
//|                                                             ������� �������� �������� ������� |
//+-----------------------------------------------------------------------------------------------+
bool bCheckOrders()
{
   // ��������� � ����� ������, ��� �������� �������� ������� ������ ����������
   for(int i = 0; i <= OrdersTotal(); i++)
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == iMagic)
            return(false);
            
   return(true);
}
//+-----------------------------------------------------------------------------------------------+
//|                                                             ������� ������ ������� �� ������� |
//+-----------------------------------------------------------------------------------------------+
bool bSignalBuy()
{
   if(dMA > Open[1] && dMA < Close[1])
      return(true);
      
   return(false);
}
//+-----------------------------------------------------------------------------------------------+
//|                                                             ������� ������ ������� �� ������� |
//+-----------------------------------------------------------------------------------------------+
bool bSignalSell()
{
   if(dMA < Open[1] && dMA > Close[1])
      return(true);
      
   return(false);
}
//+-----------------------------------------------------------------------------------------------+
//|                                                            ������� �������� ������ �� ������� |
//+-----------------------------------------------------------------------------------------------+
void vOrderOpenBuy()
{
   int iOTi = 0;   // ����� ������ 
   
   iOTi = OrderSend(Symbol(), OP_BUY, dLots, Ask, iSlippage, 0, 0, "", iMagic, 0, clrNONE);
   
   // �������� �������� �� �����
   if(iOTi > 0)
      // ���� ��, �� �������� ������ ������ � �������
      vOrderModify(iOTi);
   else
      // ���� ���, �� ������� ������
      vError(GetLastError());
}
//+-----------------------------------------------------------------------------------------------+
//|                                                            ������� �������� ������ �� ������� |
//+-----------------------------------------------------------------------------------------------+
void vOrderOpenSell()
{
   int iOTi = 0;   // ����� ������ 
   
   iOTi = OrderSend(Symbol(), OP_SELL, dLots, Bid, iSlippage, 0, 0, "", iMagic, 0, clrNONE);
   
   // �������� �������� �� �����
   if(iOTi > 0)
      // ���� ��, �� �������� ������ ������ � �������
      vOrderModify(iOTi);
   else
      // ���� ���, �� ������� ������
      vError(GetLastError());
}
//+-----------------------------------------------------------------------------------------------+
//|                                                                    ������� ����������� ������ |
//+-----------------------------------------------------------------------------------------------+
void vOrderModify(int iOTi)
{  
   int    iOTy = -1;   // ��� ������
   double dOOP = 0;    // ���� �������� ������
   double dOSL = 0;    // ���� ����
   int    iMag = 0;    // ������������� ���������
   
   double dSL = 0;     // ������� ������
   double dTP = 0;     // ������� �������
   
   // ������� �� ������ �������� �����, ������� ��������� ��������
   if(OrderSelect(iOTi, SELECT_BY_TICKET, MODE_TRADES))
   {
      iOTy = OrderType();
      dOOP = OrderOpenPrice();
      dOSL = OrderStopLoss();
      iMag = OrderMagicNumber();
   }
   
   // ���� ����� ������ ������ ��������, �� ������ � �������
   if(OrderSymbol() == Symbol() && OrderMagicNumber() == iMag)
   {
      // ���� ���� ���� �������� ������ ����� ����, �� ������������ �����
      if(dOSL == 0)
      {
         if(iOTy == OP_BUY)
         {
            dSL = NormalizeDouble(dOOP - iStopLoss * Point, Digits);
            dTP = NormalizeDouble(dOOP + iTakeProfit * Point, Digits);
            
            bool bOM = OrderModify(iOTi, dOOP, dSL, dTP, 0, clrNONE);       
         }
         
         if(iOTy == OP_SELL)
         {
            dSL = NormalizeDouble(dOOP + iStopLoss * Point, Digits);
            dTP = NormalizeDouble(dOOP - iTakeProfit * Point, Digits);
            
            bool bOM = OrderModify(iOTi, dOOP, dSL, dTP, 0, clrNONE);       
         }         
      }  
   } 
}
//+-----------------------------------------------------------------------------------------------+
//|                                                                      ������� ��������� ������ |
//+-----------------------------------------------------------------------------------------------+
void vError(int iErr)
{
   switch(iErr)
   {
      case 129:   // ������������ ����
      case 135:   // ���� ����������
      case 136:   // ��� ���
      case 138:   // ����� ����
         Sleep(1000);
         RefreshRates();
         break;
      
      case 137:   // ������ �����
      case 146:   // ���������� �������� ������        
         Sleep(3000);
         RefreshRates();
         break;
   }
}
//+-----------------------------------------------------------------------------------------------+