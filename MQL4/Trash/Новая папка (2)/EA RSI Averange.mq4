//+------------------------------------------------------------------+
//|                               Copyright © 2018, Vladimir Hlystov |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2018, http://cmillion.ru"
#property link      "cmillion@narod.ru"
#property version   "1.00"
#property strict
//-------------------------------------------------------------------
extern ENUM_TIMEFRAMES timeframe_RSI = 60;
extern int    period_RSI      = 14;
extern int    level_buy       = 30;
extern int    level_sell      = 70;
extern int    MinStep         = 20;
extern double Lot             = 0.1;
extern double K_Lot           = 1.5;
extern int    Takeprofit      = 50;
extern int    Magic           = 0;
extern int    DigitsLot       = 2;
extern int    slippage        = 3;
//-------------------------------------------------------------------
string AC;
double MINLOT,MAXLOT;
datetime TimeBar=0;
//-------------------------------------------------------------------
void OnTick()
{
   if (!IsTradeAllowed()) 
   {
      DrawLABEL("cm Торговля",1,5,20,Red,"Торговля запрещена");
      return;
   } 
   else DrawLABEL("cm Торговля",1,5,20,clrGreen,"Торговля разрешена");

   //---

   double STOPLEVEL=MarketInfo(Symbol(),MODE_STOPLEVEL);
   //---
   double MaxOrderBuy=0,MinOrderSell=0,MinOrderBuy=0,MaxOrderSell=0,OL=0,LB=0,LS=0,PB=0,PS=0;
   double OSL,OTP,OOP,SL,Profit=0,ProfitB=0,ProfitS=0;
   int i,b=0,s=0,tip;
   for (i=0; i<OrdersTotal(); i++)
   {    
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      { 
         if (OrderSymbol()==Symbol() && Magic==OrderMagicNumber())
         { 
            tip = OrderType(); 
            OOP = NormalizeDouble(OrderOpenPrice(),Digits);
            OL = OrderLots();
            if (tip==OP_BUY)             
            {  
               PB += OOP*OL; LB+=OL;
               ProfitB+=OrderProfit()+OrderCommission()+OrderSwap();
               b++; 
               if (MaxOrderBuy < OOP || MaxOrderBuy==0) MaxOrderBuy = OOP;
               if (MinOrderBuy > OOP || MinOrderBuy==0) MinOrderBuy = OOP;
            }                                         
            if (tip==OP_SELL)        
            {
               PS += OOP*OL; LS+=OL;
               ProfitS+=OrderProfit()+OrderCommission()+OrderSwap();
               s++;
               if (MinOrderSell > OOP || MinOrderSell==0) MinOrderSell = OOP;
               if (MaxOrderSell < OOP || MaxOrderSell==0) MaxOrderSell = OOP;
            } 
         }
      }
   }
   //---
   Profit=ProfitB+ProfitS;
   double NLb=0,NLs=0;
   if (b>0) NLb = NormalizeDouble(PB/LB,Digits);
   if (s>0) NLs = NormalizeDouble(PS/LS,Digits);
   double TPB=0,TPS=0;
   if (b>0) TPB = NormalizeDouble(NLb+Takeprofit*Point,Digits);
   if (s>0) TPS = NormalizeDouble(NLs-Takeprofit*Point,Digits);
   //---
   
   if (b+s > 0) 
   {
      for (i=0; i<OrdersTotal(); i++)
      {    
         if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         { 
            if (OrderSymbol()==Symbol() && Magic==OrderMagicNumber())
            { 
               tip = OrderType(); 
               OSL = NormalizeDouble(OrderStopLoss(),Digits);
               OTP = NormalizeDouble(OrderTakeProfit(),Digits);
               OOP = NormalizeDouble(OrderOpenPrice(),Digits);
               SL = OSL;
               if (tip==OP_BUY)             
               {  
                  if (TPB != OTP)
                  {  
                     if (!OrderModify(OrderTicket(),OOP,OSL,TPB,0,White)) Print("Error OrderModify TP Martin ",GetLastError());
                  }
               }                                         
               if (tip==OP_SELL)        
               {
                  if (TPS != OTP)
                  {  
                     if (!OrderModify(OrderTicket(),OOP,OSL,TPS,0,White)) Print("Error OrderModify TP Martin ",GetLastError());
                  }
               } 
            }
         }
      }
   }   
   
   double AB = AccountBalance();
   
   DrawLABEL("cm Balance"        ,1,5,35,clrGreen,DoubleToStr(AB,2));
   DrawLABEL("cm Equity"         ,1,5,50,clrGreen,DoubleToStr(AccountEquity(),2));
   DrawLABEL("cm FreeMargin"     ,1,5,65,clrGreen,DoubleToStr(AccountFreeMargin(),2));
   DrawLABEL("cm Take"           ,1,5,80,Color(Profit>0,clrGreen,clrRed),DoubleToStr(Profit,2));
   
   //---
   if (TimeBar==iTime(NULL,timeframe_RSI,0)) return;
   double Lots=0,RSI1=0,RSI0=0;

   //---
   if (b==0 || s==0)
   {
      RSI0= iRSI (NULL,timeframe_RSI,period_RSI,PRICE_CLOSE,0);
      RSI1= iRSI (NULL,timeframe_RSI,period_RSI,PRICE_CLOSE,1);
   }

   if (RSI0>=level_buy && RSI1<=level_buy)
   {
      if ((MinOrderBuy-MinStep*Point>Ask || MinOrderBuy==0))
      {
         Lots=NormalizeDouble(Lot*MathPow(K_Lot,b),DigitsLot);

         if (Lots>MAXLOT) Lots = MAXLOT;
         if (Lots<MINLOT) Lots = MINLOT;
      
         if (OrderSend(Symbol(),OP_BUY, Lots,NormalizeDouble(Ask,Digits),slippage,0,0,NULL,Magic,0,CLR_NONE)==-1) 
            Print("Ошибка ",GetLastError()," открытия ордера ");
         else TimeBar=iTime(NULL,timeframe_RSI,0);
      }
   }

   //---
   Lots=0;
   if (RSI0<=level_sell && RSI1>=level_sell)
   {

      if (MaxOrderSell+MinStep*Point<Bid)
      {
         Lots=NormalizeDouble(Lot*MathPow(K_Lot,s),DigitsLot);
   
         if (Lots>MAXLOT) Lots = MAXLOT;
         if (Lots<MINLOT) Lots = MINLOT;

         if (OrderSend(Symbol(),OP_SELL,Lots,NormalizeDouble(Bid,Digits),slippage,0,0,NULL,Magic,0,CLR_NONE)==-1) 
            Print("Ошибка ",GetLastError()," открытия ордера ");
         else TimeBar=iTime(NULL,timeframe_RSI,0);
      }
   }

return;
}
//------------------------------------------------------------------
void OnDeinit(const int reason)
{
   if (!IsTesting()) 
   {
      ObjectsDeleteAll(0,"cm");
   }
}
//-------------------------------------------------------------------
void DrawLABEL(string name, int CORNER, int X, int Y, color clr, string Name,ENUM_ANCHOR_POINT ANCHOR=ANCHOR_RIGHT_UPPER)
{
   if (ObjectFind(name)!=-1) ObjectDelete(name);
   ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
   ObjectSet(name, OBJPROP_CORNER, CORNER);
   ObjectSet(name, OBJPROP_ANCHOR, ANCHOR);
   ObjectSet(name, OBJPROP_XDISTANCE, X);
   ObjectSet(name, OBJPROP_YDISTANCE, Y);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,name,OBJPROP_SELECTED,false);
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
   ObjectSetText(name,Name,10,"Arial",clr);
}
//+------------------------------------------------------------------+
int OnInit()
{
   RectLabelCreate(0,"cm fon",0,195,15,195,85);
   DrawLABEL("cm Balance AC"        ,1,190,35,clrGreen,"Balance ",ANCHOR_LEFT_UPPER);
   DrawLABEL("cm Equity AC"         ,1,190,50,clrGreen,"Equity ",ANCHOR_LEFT_UPPER);
   DrawLABEL("cm FreeMargin AC"     ,1,190,65,clrGreen,"FMargin ",ANCHOR_LEFT_UPPER);
   DrawLABEL("cm Profit AC"         ,1,190,80,clrGreen,"Profit ",ANCHOR_LEFT_UPPER);
   MINLOT = MarketInfo(Symbol(),MODE_MINLOT);
   MAXLOT = MarketInfo(Symbol(),MODE_MAXLOT);
   Comment("Start ",TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS));
   AC = StringConcatenate(" ", AccountCurrency());
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
color Color(bool P,color a,color b)
{
   if (P) return(a);
   else return(b);
}
//------------------------------------------------------------------
bool RectLabelCreate(const long             chart_ID=0,               // ID графика
                     const string           name="RectLabel",         // имя метки
                     const int              sub_window=0,             // номер подокна
                     const long              x=0,                     // координата по оси X
                     const long              y=0,                     // координата по оси y
                     const int              width=50,                 // ширина
                     const int              height=18,                // высота
                     const color            back_clr=clrWhite,        // цвет фона
                     const color            clr=clrBlack,             // цвет плоской границы (Flat)
                     const ENUM_LINE_STYLE  style=STYLE_SOLID,        // стиль плоской границы
                     const int              line_width=1,             // толщина плоской границы
                     const bool             back=false,               // на заднем плане
                     const bool             selection=false,          // выделить для перемещений
                     const bool             hidden=true,              // скрыт в списке объектов
                     const long             z_order=0)                // приоритет на нажатие мышью
  {
   ResetLastError();
   if (ObjectFind(chart_ID,name)==-1)
   {
      ObjectCreate(chart_ID,name,OBJ_RECTANGLE_LABEL,sub_window,0,0);
      ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_TYPE,BORDER_FLAT);
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
      ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
      ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,line_width);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
   }
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
   return(true);
}
//--------------------------------------------------------------------
