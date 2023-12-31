//+------------------------------------------------------------------+
//|                                            Elder's three screens |
//|                             Copyright 2020, Zakhvatkin Aleksandr |
//|                                                zahvatkin@mail.ru |
//+------------------------------------------------------------------+
#property copyright   "Copyright 2020, Zakhvatkin Aleksandr."
#property link        "https://www.mql5.com/ru/users/z.a.m"
#property description "Elder's three screens"
#property strict

//--- input parameters
extern double lot    = 0.1;   // lot size
extern int    indent = 10;    // indent from candlestick extremes in points
extern int    scr1   = 240;   // first screen in minutes
extern int    scr2   = 60;    // second screen in minutes
extern int    scr3   = 15;    // third screen in minutes

//--- Global variables ----------------------------------------------+
bool set;

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
void start()
{

// -- checking trading conditions
if (!SetBy()&&!SetSel()) {Comment("No trade"); return;}
if (SetBy()) Comment("We buy"); if (SetSel()) Comment("We sell");
if (SetBy() && SigBy()) Comment("Buy signal"); if (SetSel() && SigSel()) Comment("Sell signal");

// -- placing orders
if (SetBy() && SigBy() && OrdersTotal()==0)
 {
  set = OrderSend (Symbol(),OP_BUYSTOP,lot,iHigh(NULL,scr3,1)+(MarketInfo(Symbol(),MODE_SPREAD)+indent)*Point,5,iLow(NULL,scr3,1)-indent*Point,
  iHigh(NULL,scr3,1)+(MarketInfo(Symbol(),MODE_SPREAD)+indent)*Point+tp()*Point,NULL,0,TimeCurrent()+scr3*60,CLR_NONE);
  if (set) {Print("Successfully placed order Buy Stop"); return;} else {Print("OrderSend failed #",GetLastError()); return;}
 }

if (SetSel() && SigSel() && OrdersTotal()==0)
 {
  set = OrderSend (Symbol(),OP_SELLSTOP,lot,iLow(NULL,scr3,1)-indent*Point,5,iHigh(NULL,scr3,1)+(MarketInfo(Symbol(),MODE_SPREAD)+indent)*Point,
  iLow(NULL,scr3,1)-indent*Point-tp()*Point,NULL,0,TimeCurrent()+scr3*60,CLR_NONE);
  if (set) {Print("Successfully placed order Sell Stop"); return;} else {Print("OrderSend failed #",GetLastError()); return;}
 }

// -- exit from start
return;
}

//+------------------------------------------------------------------+
//| We buy                                                           |
//+------------------------------------------------------------------+
bool SetBy()
{
 if(iMACD(NULL,scr1,12,26,1,PRICE_CLOSE,MODE_MAIN,1)>iMACD(NULL,scr1,12,26,1,PRICE_CLOSE,MODE_MAIN,2) && 
 iMACD(NULL,scr1,12,26,1,PRICE_CLOSE,MODE_MAIN,1)>0 && iClose(NULL,scr1,1)>iMA(NULL,scr1,13,0,MODE_EMA,PRICE_CLOSE,1))
 return(true); else return(false);
}
//+------------------------------------------------------------------+
//| We sell                                                          |
//+------------------------------------------------------------------+
bool SetSel()
{
 if (iMACD(NULL,scr1,12,26,1,PRICE_CLOSE,MODE_MAIN,1)<iMACD(NULL,scr1,12,26,1,PRICE_CLOSE,MODE_MAIN,2) &&
 iMACD(NULL,scr1,12,26,1,PRICE_CLOSE,MODE_MAIN,1)<0 && iClose(NULL,scr1,1)<iMA(NULL,scr1,13,0,MODE_EMA,PRICE_CLOSE,1))
 return(true); else return(false); 
}
//+------------------------------------------------------------------+
//| Buy signal                                                       |
//+------------------------------------------------------------------+
bool SigBy()
{
 if(iStochastic(NULL,scr2,5,3,3,MODE_SMA,0,MODE_MAIN,2)<=20 && iStochastic(NULL,scr2,5,3,3,MODE_SMA,0,MODE_MAIN,1)>20)
 return(true); else return(false);
}
//+------------------------------------------------------------------+
//| Sell signal                                                      |
//+------------------------------------------------------------------+
bool SigSel()
{
 if(iStochastic(NULL,scr2,5,3,3,MODE_SMA,0,MODE_MAIN,2)>=80 && iStochastic(NULL,scr2,5,3,3,MODE_SMA,0,MODE_MAIN,1)<80)
 return(true); else return(false);
}
//+------------------------------------------------------------------+
//| Take profit                                                      |
//+------------------------------------------------------------------+
double tp()
{
double p = (iHigh(NULL,scr3,1) - iLow(NULL,scr3,1))/Point+3*indent;
return(3*p);
}