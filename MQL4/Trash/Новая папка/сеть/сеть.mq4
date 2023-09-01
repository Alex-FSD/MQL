//+------------------------------------------------------------------+
//|                               Copyright © 2015, Хлыстов Владимир |
//|                                                cmillion@narod.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2015, http://cmillion.ru"
#property link      "cmillion@narod.ru"
//--------------------------------------------------------------------*/
extern int     Takeprofit           = 20;          //тейкпрофит
extern double  LotBuy               = 0.10;        //
extern double  LotSell              = 0.10;        //
extern int     MaxOrders            = 100;         //максимальное кол-во доливочных ордеров
extern string  Comment_order        = "";
extern int     Magic                = 777888;
extern bool    DrawInfo             = true;        //вывод информации на экран
extern int     slippage             = 3;           //Максимально допустимое отклонение цены для рыночных ордеров (ордеров на покупку или продажу).
//--------------------------------------------------------------------
string val;
int N;
//-------------------------------------------------------------------- 
int init() 
{ 
   val = " "+AccountCurrency();
   return(0);
}
//-------------------------------------------------------------------
int deinit()
{
   if (!IsTesting()) ObjectsDeleteAll(0);
   return(0);
}
//--------------------------------------------------------------------
int start()
{
   if (!IsTradeAllowed()) 
   {
      DrawLABEL("IsTradeAllowed","Торговля запрещена",5,15,Red);
      return(0);
   }
   else DrawLABEL("IsTradeAllowed","Торговля разрешена",5,15,Lime);

   //---

   double OSL,OTP,OOP,TP,Profit,ProfitB,ProfitS;
   int n=0,tip;
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
            TP=OTP;
            if (tip==OP_BUY)             
            {  
               ProfitB+=OrderProfit()+OrderSwap()+OrderCommission();
               n++; 
               if (OTP==0 && Takeprofit!=0)
               {
                  TP = NormalizeDouble(OOP + Takeprofit * Point,Digits);
               } 
               if (TP != OTP) if (!OrderModify(OrderTicket(),OOP,OSL,TP,0,White)) Print("Error OrderModify ",GetLastError());
            }                                         
            if (tip==OP_SELL)        
            {
               ProfitS+=OrderProfit()+OrderSwap()+OrderCommission();
               n++;
               if (OTP==0 && Takeprofit!=0)
               {
                  TP = NormalizeDouble(OOP - Takeprofit * Point,Digits);
               }
               if (TP != OTP) if (!OrderModify(OrderTicket(),OOP,OSL,TP,0,White)) Print("Error OrderModify ",GetLastError());
            } 
         }
      }
   } 
   Profit = ProfitB + ProfitS;
   double FM=AccountFreeMargin();
   DrawLABEL("Balance",StringConcatenate("Balance ",DoubleToStr(AccountBalance(),2),val),5,35,Lime);
   DrawLABEL("Equity",StringConcatenate("Equity ",DoubleToStr(AccountEquity(),2),val),5,55,Lime);
   DrawLABEL("FreeMargin",StringConcatenate("FreeMargin ",DoubleToStr(FM,2),val),5,75,Color(FM<0,Red,Lime));
   DrawLABEL("Profit",StringConcatenate("Profit ",DoubleToStr(Profit,2),val),5,95,Color(Profit<0,Red,Lime));
   DrawLABEL("Orders",StringConcatenate("Orders ",n),5,115,Color(Profit<0,Red,Lime));
   //----------------------------------------------------------------

   if (n>=N && n!=0) return(0);
   
   if (n<MaxOrders)
   {
      if (OrderSend(Symbol(),OP_BUY, LotBuy,NormalizeDouble(Ask,Digits),slippage,0,0,Comment_order,Magic,0,CLR_NONE)==-1
      ||  OrderSend(Symbol(),OP_SELL,LotSell,NormalizeDouble(Bid,Digits),slippage,0,0,Comment_order,Magic,0,CLR_NONE)==-1)
       Print("Ошибка ",GetLastError()," открытия ордера ");
   }
   N=0;
   for (i=0; i<OrdersTotal(); i++)
   {    
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      { 
         if (OrderSymbol()==Symbol() && Magic==OrderMagicNumber())
         { 
            N++; 
         }
      }
   } 

return(0);
}
//------------------------------------------------------------------
color Color(bool P,color a,color b)
{
   if (P) return(a);
   else return(b);
}
//------------------------------------------------------------------
void DrawLABEL(string name, string Name, int X, int Y, color clr)
{
   if (ObjectFind(name)==-1)
   {
      ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
      ObjectSet(name, OBJPROP_CORNER, 1);
      ObjectSet(name, OBJPROP_XDISTANCE, X);
      ObjectSet(name, OBJPROP_YDISTANCE, Y);
   }
   ObjectSetText(name,Name,12,"Arial",clr);
}
//--------------------------------------------------------------------

