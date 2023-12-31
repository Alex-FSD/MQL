//+------------------------------------------------------------------+
#property copyright "Copyright © 2020, Vladimir Khlystov"
#property link      "cmillion@narod.ru"
#property strict
#property description "Советник открывает позиции по индикатору RSI после SL увеличивает лот"
#property description "Следующая сделка не открывается, пока не закрыта предыдущая"
//-------------------------------------------------------------------
extern ENUM_TIMEFRAMES timeframe_RSI = 15;
extern int    period_RSI   = 14;
extern int    level_buy    = 30;
extern int    level_sell   = 70;

extern double LotPercent   = 0.1;
extern double K_Martin     = 2.0;

extern int    Stoploss     = 270,
              Takeprofit   = 330;

extern int    Magic        = 0;
extern int    DigitsLot    = 2;
extern int    slippage     = 3;
//-------------------------------------------------------------------
string AC;
datetime OpenTime;
double MINLOT,MAXLOT;
//-------------------------------------------------------------------
void OnTick()
{
   if (!IsTradeAllowed()) 
   {
      DrawLABEL("Торговля",0,0,0,Red,"Торговля запрещена");
      return;
   } 
   else DrawLABEL("Торговля",0,0,0,Lime,"Торговля разрешена");

   //---

   double STOPLEVEL=MarketInfo(Symbol(),MODE_STOPLEVEL);
   //---
   double OSL,OTP,OOP,SL,TP,Profit=0;
   int b=0,s=0,tip;
   for (int i=0; i<OrdersTotal(); i++)
   {    
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      { 
         if (OrderSymbol()==Symbol() && Magic==OrderMagicNumber())
         { 
            tip = OrderType(); 
            OSL = NormalizeDouble(OrderStopLoss(),Digits);
            OTP = NormalizeDouble(OrderTakeProfit(),Digits);
            OOP = NormalizeDouble(OrderOpenPrice(),Digits);
            SL=OSL;TP=OTP;
            Profit+=OrderProfit()+OrderCommission()+OrderSwap();
            if (tip==OP_BUY)             
            {  
               b++; 
               if (OSL==0 && Stoploss!=0)
               {
                  if ((Bid-NormalizeDouble(OOP - Stoploss * Point,Digits)) / Point>=STOPLEVEL) SL = NormalizeDouble(OOP - Stoploss * Point,Digits);
               } 
               if (OTP==0 && Takeprofit!=0)
               {
                  if ((NormalizeDouble(OOP + Takeprofit * Point,Digits)-Ask) / Point>=STOPLEVEL) TP = NormalizeDouble(OOP + Takeprofit * Point,Digits);
               } 
               if (SL != OSL || TP != OTP)
               {  
                  if (!OrderModify(OrderTicket(),OOP,SL,TP,0,White)) Print("Error OrderModify ",GetLastError());
               }
            }                                         
            if (tip==OP_SELL)        
            {
               s++;
               if (OSL==0 && Stoploss!=0)
               {
                  if ((NormalizeDouble(OOP + Stoploss * Point,Digits)-Ask) / Point>=STOPLEVEL) SL = NormalizeDouble(OOP + Stoploss   * Point,Digits);
               }
               if (OTP==0 && Takeprofit!=0)
               {
                  if ((Bid-NormalizeDouble(OOP - Takeprofit * Point,Digits)) / Point>=STOPLEVEL) TP = NormalizeDouble(OOP - Takeprofit * Point,Digits);
               }
               if (SL != OSL || TP != OTP)
               {  
                  if (!OrderModify(OrderTicket(),OOP,SL,TP,0,White)) Print("Error OrderModify ",GetLastError());
               }
            } 
         }
      }
   }
   
   
   //---
   
   double AB = AccountBalance();
   
   //---
   
   DrawLABEL("Balance"        ,1,5,0,clrGreen,StringConcatenate("Balance ",DoubleToStr(AB,2),AC));
   DrawLABEL("Equity"         ,1,5,0,clrGreen,StringConcatenate("Equity ",DoubleToStr(AccountEquity(),2),AC));
   DrawLABEL("FreeMargin"     ,1,5,0,clrGreen,StringConcatenate("FreeMargin ",DoubleToStr(AccountFreeMargin(),2),AC));
   DrawLABEL("Take"           ,1,5,0,Color(Profit>0,Lime,Red),StringConcatenate("Profit ",DoubleToStr(Profit,2),AC));
   
   double Lots=0,RSI1=0,RSI0=0;
   if (b+s==0)
   {
      RSI0= iRSI (NULL,timeframe_RSI,period_RSI,PRICE_CLOSE,0);
      RSI1= iRSI (NULL,timeframe_RSI,period_RSI,PRICE_CLOSE,1);
   }
   else return;

   //---
   if (RSI0>=level_buy && RSI1<=level_buy)
   {
      Lots=LOT();

      if (Lots>MAXLOT) Lots = MAXLOT;
      if (Lots<MINLOT) Lots = MINLOT;
      
      if(SendOrder(OP_BUY, Lots, NormalizeDouble(Ask,Digits)))OpenTime=iTime(NULL,timeframe_RSI,1); 
   }

   //---
   
   if (RSI0<=level_sell && RSI1>=level_sell)
   {
      Lots=LOT();

      if (Lots>MAXLOT) Lots = MAXLOT;
      if (Lots<MINLOT) Lots = MINLOT;

      if(SendOrder(OP_SELL, Lots, NormalizeDouble(Bid,Digits))) OpenTime=iTime(NULL,timeframe_RSI,1); 
   }
}
//------------------------------------------------------------------
bool SendOrder(int tip, double lots, double price, double sl=0, double tp=0)
{
   if (tip<2)
   {
      if (AccountFreeMarginCheck(Symbol(),tip,lots)<0)
      {
         Alert("Недостаточно средств");
         return(false);
      }
   }
   for (int i=0; i<10; i++)
   {    
      if (OrderSend(Symbol(),tip, lots,price,slippage,sl,tp,NULL,Magic,0,clrNONE)!=-1) return(true);
         Alert(" попытка ",i," Ошибка открытия ордера ",Strtip(tip)," <<",(GetLastError()),">>  lot=",lots,"  pr=",price," sl=",sl," tp=",tp);
      Sleep(500);
      RefreshRates();
      if (IsStopped()) return(false);
   }
   return(false);
}
//------------------------------------------------------------------
string Strtip(int tip)
{
   switch(tip) 
   { 
   case OP_BUY:
      return("BUY"); 
   case OP_SELL:
      return("SELL"); 
   case OP_BUYSTOP:
      return("BUYSTOP"); 
   case OP_SELLSTOP:
      return("SELLSTOP"); 
   case OP_BUYLIMIT:
      return("BUYLIMIT"); 
   case OP_SELLLIMIT:
      return("SELLLIMIT"); 
   }
   return("error"); 
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
   if (ObjectFind(name)==-1)
   {
      ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
      ObjectSet(name, OBJPROP_CORNER, CORNER);
      ObjectSet(name, OBJPROP_XDISTANCE, X);
      ObjectSet(name, OBJPROP_YDISTANCE, Y);
   }
   ObjectSetText(name,Name,10,"Arial",clr);
}
//+------------------------------------------------------------------+
int OnInit()
{
   MINLOT = MarketInfo(Symbol(),MODE_MINLOT);
   MAXLOT = MarketInfo(Symbol(),MODE_MAXLOT);
   Comment("Start ",TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS));
   
   AC = StringConcatenate(" ", AccountCurrency());
   
   int Y=15;
   DrawLABEL("Торговля"  ,1,5,Y,Red,"Торговля ");Y += 20;
   DrawLABEL("Balance"   ,1,5,Y,clrGreen,StringConcatenate("Balance ",DoubleToStr(AccountBalance(),2),AC));Y += 15;
   DrawLABEL("Equity"    ,1,5,Y,clrGreen,StringConcatenate("Equity ",DoubleToStr(AccountEquity(),2),AC));Y += 15;
   DrawLABEL("FreeMargin",1,5,Y,clrGreen,StringConcatenate("FreeMargin ",DoubleToStr(AccountFreeMargin(),2),AC));Y += 30;

   DrawLABEL("Take"           ,1,5,Y,Lime,"Profit ");Y += 20;
   
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
color Color(bool P,color a,color b)
{
   if (P) return(a);
   else return(b);
}
//------------------------------------------------------------------
double LOT()
{
   int n=0;
   double OL = NormalizeDouble(AccountBalance()*LotPercent/100/MarketInfo(Symbol(),MODE_MARGINREQUIRED),DigitsLot);
   if (OL>MAXLOT) OL = MAXLOT;
   if (OL<MINLOT) OL = MINLOT;
   for (int j = OrdersHistoryTotal()-1; j >= 0; j--)
   {
      if (OrderSelect(j, SELECT_BY_POS,MODE_HISTORY))
      {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic)
         {
            if (OrderProfit()<0) 
            {
               OL=NormalizeDouble(OrderLots()*K_Martin,DigitsLot);
            }
            break;
         }
      }
   }
   return(OL);
}
//------------------------------------------------------------------


