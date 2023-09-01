//+------------------------------------------------------------------+
//|                                                  EMA WMA RSI.mq4 |
//|                               Copyright © 2014, Хлыстов Владимир |
//|                                                cmillion@narod.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2014, Хлыстов Владимир"
#property link      "cmillion@narod.ru"
//--------------------------------------------------------------------
extern int     period_EMA           = 28,
               period_WMA           = 8 ,
               period_RSI           = 14,
               stoploss             = 0,
               takeprofit           = 500,
               risk                 = 10,
               Magic                = 777;
extern bool    CloseCounter         = false;
extern double  Lot                  = 0.1;
extern int     TrailingStop         = 70;    //если= 0, то трейлинг по фракталам или свечам
extern int     Tip_Fr_or_Candl      = 1;     //если= 0, то трейлинг по фракталам 
                                             //если= 1, то трейлинг по свечам
//--------------------------------------------------------------------
double SL,TP;
int TimeBar;
//--------------------------------------------------------------------
int start()
{
   if (TimeBar==Time[0]) return(0);
   double EMA0 = iMA(NULL,0,period_EMA,0,MODE_EMA, PRICE_OPEN,0);
   double WMA0 = iMA(NULL,0,period_WMA,0,MODE_LWMA,PRICE_OPEN,0);
   double EMA1 = iMA(NULL,0,period_EMA,0,MODE_EMA, PRICE_OPEN,1);
   double WMA1 = iMA(NULL,0,period_WMA,0,MODE_LWMA,PRICE_OPEN,1);
   double RSI  = iRSI(NULL,0,period_RSI,PRICE_OPEN,0);
   if (EMA0 < WMA0 && EMA1 > WMA1 && RSI > 50)
   {
      if (takeprofit!=0) TP  = NormalizeDouble(Ask + takeprofit*Point,Digits);
      if (stoploss!=0)   SL  = NormalizeDouble(Ask - stoploss*  Point,Digits);     
      if (CloseCounter) CLOSEORDER(OP_SELL);
      OPENORDER (OP_BUY);
   }
   if (EMA0 > WMA0 && EMA1 < WMA1 && RSI < 50)
   {
      if (takeprofit!=0) TP = NormalizeDouble(Bid - takeprofit*Point,Digits);
      if (stoploss!=0)   SL = NormalizeDouble(Bid + stoploss*  Point,Digits);            
      if (CloseCounter) CLOSEORDER(OP_BUY);
      OPENORDER (OP_SELL);
   }
   TrailingStop();
return(0);
}
//--------------------------------------------------------------------
void CLOSEORDER(int ord)
{
   for (int i=0; i<OrdersTotal(); i++)
   {                                               
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if (OrderSymbol()!=Symbol()||Magic!=OrderMagicNumber()) continue;
         if (OrderType()==OP_BUY && ord==OP_BUY)
            if (!OrderClose(OrderTicket(),OrderLots(),Bid,3,CLR_NONE)) Print("Error OrderClose ",GetLastError());
         if (OrderType()==OP_SELL && ord==OP_SELL)
            if (!OrderClose(OrderTicket(),OrderLots(),Ask,3,CLR_NONE)) Print("Error OrderClose ",GetLastError());
      }   
   }
}
//--------------------------------------------------------------------
void OPENORDER(int ord)
{
   int error;
   if (ord==OP_BUY) error=OrderSend(Symbol(),OP_BUY, LOT(),Ask,2,SL,TP,"EMA WMA RSI",Magic,3);
   if (ord==OP_SELL) error=OrderSend(Symbol(),OP_SELL,LOT(),Bid,2,SL,TP,"EMA WMA RSI",Magic,3);
   if (error==-1)   ShowERROR(error);
   else TimeBar=Time[0];                            
return;
}                  
//--------------------------------------------------------------------
void ShowERROR(int Ticket)
{
   int err=GetLastError();
   switch ( err )
   {                  
      case 1:                                                                               return;
      case 2:   Alert("Нет связи с торговым сервером   "              ,Ticket," ",Symbol());return;
      case 130: Alert("Error близкие стопы   Ticket ",                 Ticket," ",Symbol());return;
      case 134: Alert("Недостаточно денег   ",                         Ticket," ",Symbol());return;
      case 146: Alert("Error Подсистема торговли занята ",             Ticket," ",Symbol());return;
      case 129: Alert("Error Неправильная цена ",                      Ticket," ",Symbol());return;
      case 131: Alert("Error Неправильный объем ",                     Ticket," ",Symbol());return;
      default:  Alert("Error  " ,err,"   Ticket ",                     Ticket," ",Symbol());return;
   }
}
//--------------------------------------------------------------------
double LOT()
{
   if (Lot!=0) return(Lot);
   double MINLOT = MarketInfo(Symbol(),MODE_MINLOT);
   double LOT = AccountFreeMargin()*risk/100/MarketInfo(Symbol(),MODE_MARGINREQUIRED);
   if (LOT>MarketInfo(Symbol(),MODE_MAXLOT)) LOT = MarketInfo(Symbol(),MODE_MAXLOT);
   if (LOT<MINLOT) LOT = MINLOT;
   if (MINLOT<0.1) LOT = NormalizeDouble(LOT,2); else LOT = NormalizeDouble(LOT,1);
   return(LOT);
}
//--------------------------------------------------------------------
void TrailingStop()
{
   int tip,Ticket;
   bool error;
   double StLo,OSL,OOP;
   for (int i=0; i<OrdersTotal(); i++) 
   {  if (OrderSelect(i, SELECT_BY_POS)==true)
      {  tip = OrderType();
         if (tip<2 && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
         {
            OSL   = OrderStopLoss();
            OOP   = OrderOpenPrice();
            Ticket = OrderTicket();
            if (tip==OP_BUY)             
            {
               StLo = SlLastBar(1,Bid,Tip_Fr_or_Candl,TrailingStop);        
               if (StLo <= OOP) continue;
               if (StLo > OSL)
               {  error=OrderModify(Ticket,OOP,NormalizeDouble(StLo,Digits),
                  OrderTakeProfit(),0,White);
                  Comment("TrailingStop ",Ticket," ",TimeToStr(TimeCurrent(),TIME_MINUTES));
                  Sleep(500);
                  if (!error) Comment("Error order ",Ticket," TrailingStop ",
                              GetLastError(),"   ",Symbol(),"   SL ",StLo);
               }
            }                                         
            if (tip==OP_SELL)        
            {
               StLo = SlLastBar(-1,Ask,Tip_Fr_or_Candl,TrailingStop);  
               if (StLo==0) continue;        
               if (StLo >= OOP) continue;
               if (StLo < OSL || OSL==0 )
               {  error=OrderModify(Ticket,OOP,NormalizeDouble(StLo,Digits),
                  OrderTakeProfit(),0,White);
                  Comment("TrailingStop "+Ticket," ",TimeToStr(TimeCurrent(),TIME_MINUTES));
                  Sleep(500);
                  if (!error) Comment("Error order ",Ticket," TrailingStop ",
                              GetLastError(),"   ",Symbol(),"   SL ",StLo);
               }
            } 
         }
      }
   }
}
//--------------------------------------------------------------------
double SlLastBar(int tip,double price, int tipFr, int tral)
{
   double fr;
   int jj,ii,delta=5;
   if (tral!=0)
   {
      if (tip==1) fr = Bid - tral*Point;  
      else fr = Ask + tral*Point;  
   }
   else
   {
      if (tipFr==0)
      {
         if (tip== 1)
         for (ii=1; ii<100; ii++) 
         {
            fr = iFractals(NULL,0,MODE_LOWER,ii);
            if (fr!=0) if (price-delta*Point > fr) break;
            else fr=0;
         }
         if (tip==-1)
         for (jj=1; jj<100; jj++) 
         {
            fr = iFractals(NULL,0,MODE_UPPER,jj);
            if (fr!=0) if (price+delta*Point < fr) break;
            else fr=0;
         }
      }
      else
      {
         if (tip== 1)
         for (ii=1; ii<100; ii++) 
         {
            fr = iLow(NULL,0,ii);
            if (fr!=0) if (price-delta*Point > fr) break;
            else fr=0;
         }
         if (tip==-1)
         for (jj=1; jj<100; jj++) 
         {
            fr = iHigh(NULL,0,jj);
            if (price+delta*Point < fr) break;
            else fr=0;
         }
      }
   }
   return(fr);
}
//--------------------------------------------------------------------