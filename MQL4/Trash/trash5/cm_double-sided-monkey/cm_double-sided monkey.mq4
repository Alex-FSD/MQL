//+------------------------------------------------------------------+
#property copyright "Copyright © 2017, Vladimir Hlystov"
#property link      "cmillion@narod.ru"
#property strict
//-------------------------------------------------------------------
/*чистый мартингейл
Открыли buy - после закрытия по профиту открываем buy с начальным лотом, при закрытии по SL лот увеличиваем
Так же параллельно торгуем и на продажи*/
//-------------------------------------------------------------------
extern double Lot          = 0.1;   //начальный лот
extern double K_Martin     = 2.0;   //коэффициент умножения последующих лотов
extern int    Stoploss     = 50,    //стоплосс
              Takeprofit   = 50;    //тейкпрофит
extern int    Magic        = 0;
int DigitsLot=2;
int slippage =30;
//-------------------------------------------------------------------
double MINLOT,MAXLOT;
//-------------------------------------------------------------------
void OnTick()
{
   if (!IsTradeAllowed()) return;
   double Lots,OSL=0,OTP=0,OOP=0,SL=0,TP=0,STOPLEVEL=(int)MarketInfo(Symbol(),MODE_STOPLEVEL);
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
            if (tip==OP_BUY)             
            {  
               b++; 
               if (OSL==0)
               {
                  if ((Bid-NormalizeDouble(OOP - Stoploss * Point,Digits)) / Point>=STOPLEVEL) 
                     SL = NormalizeDouble(OOP - Stoploss * Point,Digits);
                  else SL = NormalizeDouble(Bid - STOPLEVEL * Point,Digits);
               } 
               if (OTP==0)
               {
                  if ((NormalizeDouble(OOP + Takeprofit * Point,Digits)-Ask) / Point>=STOPLEVEL) 
                     TP = NormalizeDouble(OOP + Takeprofit * Point,Digits);
                  else TP = NormalizeDouble(Ask + STOPLEVEL * Point,Digits);
               } 
               if (SL != OSL || TP != OTP)
               {  
                  if (!OrderModify(OrderTicket(),OOP,SL,TP,0,CLR_NONE)) Print("Error OrderModify ",GetLastError());
               }
            }                                         
            if (tip==OP_SELL)        
            {
               s++;
               if (OSL==0)
               {
                  if ((NormalizeDouble(OOP + Stoploss * Point,Digits)-Ask) / Point>=STOPLEVEL) 
                     SL = NormalizeDouble(OOP + Stoploss   * Point,Digits);
                  else SL = NormalizeDouble(Ask + STOPLEVEL   * Point,Digits);
               }
               if (OTP==0)
               {
                  if ((Bid-NormalizeDouble(OOP - Takeprofit * Point,Digits)) / Point>=STOPLEVEL) 
                     TP = NormalizeDouble(OOP - Takeprofit * Point,Digits);
                  else TP = NormalizeDouble(Bid - STOPLEVEL * Point,Digits);
               }
               if (SL != OSL || TP != OTP)
               {  
                  if (!OrderModify(OrderTicket(),OOP,SL,TP,0,CLR_NONE)) Print("Error OrderModify ",GetLastError());
               }
            } 
         }
      }
   }
   //---
   if (b==0)
   {
      Lots=LOT(OP_BUY);
      if (Lots>MAXLOT) Lots = MAXLOT;
      if (Lots<MINLOT) Lots = MINLOT;
      if (AccountFreeMarginCheck(Symbol(),OP_BUY,Lots)>0)
      {
         if (OrderSend(Symbol(),OP_BUY, Lots,NormalizeDouble(Ask,Digits),slippage,0,0,NULL,Magic,0,CLR_NONE)==-1) 
            Print("Ошибка ",GetLastError()," открытия ордера ");
      }
      else
      {
         Print("Недостаточно средств для открытия ",DoubleToStr(Lots,DigitsLot)," лота BUY ");
         Comment("Недостаточно средств для открытия ",DoubleToStr(Lots,DigitsLot)," лота BUY ");
      }
   }
   //---
   if (s==0)
   {
      Lots=LOT(OP_SELL);
      if (Lots>MAXLOT) Lots = MAXLOT;
      if (Lots<MINLOT) Lots = MINLOT;
      if (AccountFreeMarginCheck(Symbol(),OP_SELL,Lots)>0)
      {
         if (OrderSend(Symbol(),OP_SELL,Lots,NormalizeDouble(Bid,Digits),slippage,0,0,NULL,Magic,0,CLR_NONE)==-1) 
            Print("Ошибка ",GetLastError()," открытия ордера ");
      }
      else
      {
         Print("Недостаточно средств для открытия ",DoubleToStr(Lots,DigitsLot)," лота SELL ");
         Comment("Недостаточно средств для открытия ",DoubleToStr(Lots,DigitsLot)," лота SELL ");
      }
   }
}
//------------------------------------------------------------------
void OnDeinit(const int reason)
{
}
//-------------------------------------------------------------------
int OnInit()
{
   MINLOT = MarketInfo(Symbol(),MODE_MINLOT);
   MAXLOT = MarketInfo(Symbol(),MODE_MAXLOT);
   return(INIT_SUCCEEDED);
}
//--------------------------------------------------------------------
double LOT(int OT)
{
   for (int j = OrdersHistoryTotal()-1; j >= 0; j--)
   {
      if (OrderSelect(j, SELECT_BY_POS,MODE_HISTORY))
      {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic && OT==OrderType())
         {
            if (OrderProfit()<0) return(NormalizeDouble(OrderLots()*K_Martin,DigitsLot));
            else return(Lot);
         }
      }
   }
   return(Lot);
}
//------------------------------------------------------------------


