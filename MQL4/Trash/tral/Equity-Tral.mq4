//+------------------------------------------------------------------+
//|                               Copyright © 2015, Vladimir Hlystov |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2019, http://cmillion.ru"
#property link      "cmillion@narod.ru"
#property version   "1.00"
#property strict

extern double  Total_Profit_Start   = 5000;  //Сумма в USD от которой стартовать трал по Профиту
extern double  Profit_Percent       = 1;     //% Процент профита для старта трала
extern double  Profit_Rollback      = 0.5;   //% Процент отката для закрытия всех ордеров

double EquityStart=0;
bool Trall=false;
int slippage=1000;
//-------------------------------------------------------------------- 
int OnInit()
{ 
   double AE = AccountEquity();
   EquityStart=AE+AE/100*Profit_Percent;
   return(0);
   return(INIT_SUCCEEDED);
}
//-------------------------------------------------------------------
void OnTick()
{
   if (!IsTradeAllowed()) return;

   double AB = AccountBalance();
   double AE = AccountEquity();

   DrawLABEL("Balance",1,5,20,Lime,StringConcatenate("Balance ",DoubleToStr(AB,2)));
   DrawLABEL("Equity" ,1,5,40,Lime,StringConcatenate("Equity ",DoubleToStr(AE,2)));

   if (OrdersTotal()==0) {Trall=false;EquityStart=AE+AE/100*Profit_Percent;}
   if (!Trall)
   {  
      DrawLABEL("Equity Start",1,5,60,Lime,StringConcatenate("Equity Start Trall ",DoubleToStr(MathMax(EquityStart,Total_Profit_Start),2)));
      if (AE>=EquityStart && AE>=Total_Profit_Start) //запуск тралла по эквити
      {  
         EquityStart=AE+AE/100*Profit_Percent;
         Alert("Запуск трейлинга Equity, Equity = "+DoubleToStr(AE,2));
         Trall=true;
      }
   }
   if (Trall)
   {  
      if (EquityStart<AE+AE/100*Profit_Percent) EquityStart=AE+AE/100*Profit_Percent;
      DrawLABEL("Equity Start",1,5,0,Red,StringConcatenate("Трал Equity закрытие при ",DoubleToStr(EquityStart-EquityStart/100*Profit_Rollback,2)));
      if (AE<=EquityStart-EquityStart/100*Profit_Rollback)
      {  
         CloseAll();
         Trall=false;
         AE=AccountEquity();
         EquityStart=AE+AE/100*Profit_Percent;
      }
   }
}
//------------------------------------------------------------------
void OnDeinit(const int reason)
{
   if (!IsTesting()) 
   {
      ObjectsDeleteAll(0);
   }
}
//-------------------------------------------------------------------
void DrawLABEL(string name, int CORNER, int X, int Y, color clr, string Name)
{
   if (ObjectFind(name)!=-1) ObjectDelete(name);
   ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
   ObjectSet(name, OBJPROP_CORNER, CORNER);
   ObjectSet(name, OBJPROP_XDISTANCE, X);
   ObjectSet(name, OBJPROP_YDISTANCE, Y);
   ObjectSetText(name,Name,10,"Arial",clr);
}
//+------------------------------------------------------------------+
color Color(bool P,color a,color b)
{
   if (P) return(a);
   else return(b);
}
//------------------------------------------------------------------
double CloseAll()
{
   bool error=true;
   int OMN,nn=0,OT,Ticket,j;
   double loss=0;
   while(true)
   {
      for (j = OrdersTotal()-1; j >= 0; j--)
      {
         if (OrderSelect(j, SELECT_BY_POS))
         {
            OT = OrderType();
            OMN=OrderMagicNumber();
            Ticket = OrderTicket();
            if (OT>1) error=OrderDelete(Ticket);
            if (OT==OP_BUY) 
            {
               error=OrderClose(Ticket,OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_BID),(int)MarketInfo(OrderSymbol(),MODE_DIGITS)),slippage,Blue);
               if (error) loss+=OrderProfit();
            }
            if (OT==OP_SELL) 
            {
               error=OrderClose(Ticket,OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_ASK),(int)MarketInfo(OrderSymbol(),MODE_DIGITS)),slippage,Red);
               if (error) loss+=OrderProfit();
            }
         }
      }
      int n=0;
      for (j = 0; j < OrdersTotal(); j++)
      {
         if (OrderSelect(j, SELECT_BY_POS))
         {
            OT = OrderType();
            n++;
         }
      }
      if (n==0) break;
      nn++;
      if (nn>10) 
      {
         Alert(Symbol()," Не удалось закрыть все сделки, осталось еще ",n);
         return(loss);
      }
      Sleep(1000);
      RefreshRates();
   }
   return(loss);
}
//--------------------------------------------------------------------
