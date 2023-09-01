//+------------------------------------------------------------------+
//|                                              MACD-Stochastic.mq4 |
//|                                              forex-way@yandex.ru |
//|                                              http://wellforex.ru |
//-------------------------------------------------------------------+
#property copyright "Copyright © 2010, http://wellforex.ru"
#property link      "forex-way@yandex.ru"
extern  int     Magic=10010;
extern string   MACDSet = "Параметры MACD";
extern int      Fast_ema_period=12;
extern int      Slow_ema_period=26; 
extern int      Signal_period=1;
extern int      applied_price=0;              // PRICE_CLOSE 0 Close price. 
                                              //PRICE_OPEN 1 Open price. 
                                              //PRICE_HIGH 2 High price. 
                                              //PRICE_LOW 3 Low price. 
                                              //PRICE_MEDIAN 4 Median price, (high+low)/2. 
                                              //PRICE_TYPICAL 5 Typical price, (high+low+close)/3. 
                                              //PRICE_WEIGHTED 6 Weighted close price, (high+low+close+close)/4. 
extern string   StochasticSet = "Параметры Stochastic";
extern int St_HI=80;                          //Уровень перекупленности
extern int St_LO=20;                          //Уровень перепроданности 
extern int Kperiod=20;                        //%K line period
extern int Dperiod=3;                         //%D line period 
extern int slowing=3;                         //Slowing value
extern int method=2;                          //MODE_SMA 0 Simple moving average
                                              //MODE_EMA 1 Exponential moving average
                                              //MODE_SMMA 2 Smoothed moving average
                                              //MODE_LWMA 3 Linear weighted moving average
extern int price_field=1;                     //0 - Low/High or 1 - Close/Close.                                             
extern string   MAEet = "Параметры EМА"; 
extern int      EMA_Period=50;                 //Период MA
extern int      Stop=21;                      //StopLoss
extern int      Take=210;                     //TakeProfit
extern bool     UseSound       = True;        // Использовать звуковой сигнал да/нет
extern double   Lots = 0.1;                   // Лот
extern bool   MM=false;                       // ММ Switch
extern double MMRisk=3;                       // Risk Factor

int  MaxTries=5, Dec,LastOrderType=0;
int   i, cnt=0, ticket, mode=0, digit=0, total, OrderToday=0;
double  SumProfit, StopLoss, TakeProfit, Lotsi=0, spread, min, max;
double MA_OPEN1, MA_OPEN2, MA_CLOSE1, MA_CLOSE2, SM1, SM2, MACD_M1, MACD_M2;
int LastVol, SigZZ, SigVM, SigST;
string  name="MACD-ST";
string SoundSuccess   = "alert.wav";      // Звук успеха
string SoundError     = "timeout.wav";    // Звук ошибки
double BuyProfit=0, SellProfit=0, BuyPrice, SellPrice, BuyStop, SellStop, LastOrderLot, LastOrderBuyPrice, LastOrderSellPrice;
datetime t1, t2, t3;
      
int init()
  {
   return(0);
  }


int start()
{
   digit  = MarketInfo(Symbol(),MODE_DIGITS); 
   spread  = MarketInfo(Symbol(),MODE_SPREAD); 
   if (digit==5 || digit==3) Dec=10;
   if (digit==4 || digit==2) Dec=1; 
   Lotsi = MoneyManagement (MM,MMRisk);
        
if (Volume[0]==1 || Volume[0]<LastVol)
{ 

MA_OPEN1=iMA(Symbol(),0,EMA_Period,0,1,PRICE_OPEN,1); 
MA_CLOSE1=iMA(Symbol(),0,EMA_Period,0,1,PRICE_CLOSE,1); 
MA_OPEN2=iMA(Symbol(),0,EMA_Period,0,1,PRICE_OPEN,2); 
MA_CLOSE2=iMA(Symbol(),0,EMA_Period,0,1,PRICE_CLOSE,2); 
SM1=iStochastic(Symbol(),0,Kperiod,Dperiod,slowing,method,price_field,MODE_MAIN,1);
SM2=iStochastic(Symbol(),0,Kperiod,Dperiod,slowing,method,price_field,MODE_MAIN,2);
MACD_M1=iMACD(Symbol(),0,Fast_ema_period, Slow_ema_period, Signal_period, applied_price,MODE_MAIN,1);
MACD_M2=iMACD(Symbol(),0,Fast_ema_period, Slow_ema_period, Signal_period, applied_price,MODE_MAIN,2);


if(ScanTradesOpenBuy(Magic)>0 && MA_CLOSE1<MA_OPEN1) AllBuyOrdDel(Magic); 
if(ScanTradesOpenSell(Magic)>0 && MA_CLOSE1>MA_OPEN1) AllSellOrdDel(Magic);

if(ScanTradesOpen(Magic)==0 && MACD_M1>MACD_M2 && SM1>SM2 && SM1>St_LO && SM1<St_HI && iClose(Symbol(),0,2)<iClose(Symbol(),0,1) && MA_CLOSE1>=MA_OPEN1 && MA_CLOSE2<=MA_OPEN2) 
{
StopLoss=NormalizeDouble(Bid ,digit)-Stop*Dec*Point;
TakeProfit=Take*Dec*Point;
BuyMarketOrdOpen(Blue,Magic);
}

if(ScanTradesOpen(Magic)==0 && MACD_M1<MACD_M2 && SM1<SM2 && SM1>St_LO && SM1<St_HI && iClose(Symbol(),0,2)>iClose(Symbol(),0,1) && MA_CLOSE1<=MA_OPEN1 && MA_CLOSE2>=MA_OPEN2)
{

StopLoss=NormalizeDouble(Ask ,digit)+Stop*Dec*Point;
TakeProfit=Take*Dec*Point;
SellMarketOrdOpen(Red,Magic);
}

}
LastVol=Volume[0];  

}

double MoneyManagement ( bool flag, double risk)
{
   double Lotsi=Lots;
	    
   if ( flag ) Lotsi=NormalizeDouble(AccountBalance()*risk/10000,2);   
   if (Lotsi<MarketInfo(Symbol(), MODE_MINLOT)) Lotsi=MarketInfo(Symbol(), MODE_MINLOT);  
   return(Lotsi);
}   


void BuyMarketOrdOpen(int ColorOfBuy,int Magic)
  {
  int try, res;
      
  for (try=1;try<=MaxTries;try++)
       {
       while (!IsTradeAllowed()) Sleep(5000);
       RefreshRates();		  

         res=OrderSend(Symbol(),OP_BUY,Lotsi,NormalizeDouble(Ask ,digit),2*Dec,StopLoss,NormalizeDouble(Ask ,digit)+TakeProfit,name,Magic,0,ColorOfBuy);
      Sleep(2000);
      if(res>0)
           {
            if (UseSound) PlaySound(SoundSuccess);
            OrderToday=OrderToday+1;
            GlobalVariableSet("OrdersCalc", OrderToday);
            if(OrderSelect(res,SELECT_BY_TICKET,MODE_TRADES)) break;
            }
         else 
         {
          if (UseSound) PlaySound(SoundError);
         Print("Error opening BUY order : ",GetLastError(), " Try ", try); 
          if (try==MaxTries) {Print("Warning!!!Last try failed!");}
         Sleep(5000);
         }     
       }
      return;
      }

void SellMarketOrdOpen(int ColorOfSell,int Magic)      
      { 
        int try, res;  

 for (try=1;try<=MaxTries;try++)
       {
       while (!IsTradeAllowed()) Sleep(5000);
       RefreshRates();	
       
      res=OrderSend(Symbol(),OP_SELL,Lotsi,NormalizeDouble(Bid ,digit),2*Dec,StopLoss,NormalizeDouble(Bid ,digit)-TakeProfit,name,Magic,0,ColorOfSell);
      Sleep(2000);
      if(res>0)
           {
            if (UseSound) PlaySound(SoundSuccess);
            OrderToday=OrderToday+1;
            GlobalVariableSet("OrdersCalc", OrderToday); 
            if(OrderSelect(res,SELECT_BY_TICKET,MODE_TRADES)) break;
            }
         else 
         {
          if (UseSound) PlaySound(SoundError);
         Print("Error opening SELL order : ",GetLastError(), " Try ", try); 
         if (try==MaxTries) {Print("Warning!!!Last try failed!");} 
         Sleep(5000);
        }
      }
      return;
      }
        

// ---- Scan Trades opened
int ScanTradesOpen(int Magic)
{   
   total = OrdersTotal();
   int numords = 0;
      
   for(cnt=0; cnt<total; cnt++) 
   {        
   OrderSelect(cnt, SELECT_BY_POS);            
   if(OrderSymbol() == Symbol() && (OrderType()==OP_BUY || OrderType()==OP_SELL)  && OrderMagicNumber() == Magic) 
   {
   LastOrderLot=OrderLots();
   if (OrderType()==OP_BUY) LastOrderType=1;
   if (OrderType()==OP_SELL) LastOrderType=2;
   numords++;
   }
   }
   return(numords);
}
 
int ScanTradesOpenBuy(int Magic)
{   
   total = OrdersTotal();
   int numords = 0;
      
   for(cnt=0; cnt<total; cnt++) 
   {        
   OrderSelect(cnt, SELECT_BY_POS);            
   if(OrderSymbol() == Symbol() && OrderType()==OP_BUY && OrderMagicNumber() == Magic) 
   {
   numords++;
   }
   }
   return(numords);
}

int ScanTradesOpenSell(int Magic)
{   
   total = OrdersTotal();
   int numords = 0;
      
   for(cnt=0; cnt<total; cnt++) 
   {        
   OrderSelect(cnt, SELECT_BY_POS);            
   if(OrderSymbol() == Symbol() && OrderType()==OP_SELL && OrderMagicNumber() == Magic) 
   {
   numords++;
   }
   }
   return(numords);
}
 

void AllBuyOrdDel(int Magic)
{
    int total=OrdersTotal();
    for (int cnt=total-1;cnt>=0;cnt--)
    { 
      OrderSelect(cnt, SELECT_BY_POS,MODE_TRADES);   
      
        if (OrderMagicNumber()==Magic && OrderType()==OP_BUY)     
        {
        bool result = false;
 
 for (int try=1;try<=MaxTries;try++)
       {		 
          RefreshRates();
          result = OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Bid ,digit),5*Dec,Yellow);
          if(result) break;            
          if(!result) Print("OrderSend CloseBuy failed with error #",GetLastError(), " Try ", try);                                      
          if (try==MaxTries) {Print("Warning!!!Last try failed!");}
          Sleep(5000);
        }
       }
      } 
     
  return;
  }  

void AllSellOrdDel(int Magic)
{
    int total=OrdersTotal();
    for (int cnt=total-1;cnt>=0;cnt--)
    { 
      OrderSelect(cnt, SELECT_BY_POS,MODE_TRADES);   
      
        if (OrderMagicNumber()==Magic && OrderType()==OP_SELL)     
        {
        bool result = false;
 
 for (int try=1;try<=MaxTries;try++)
       {		 
          RefreshRates();
          result = OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Ask ,digit),5*Dec,Yellow);
          if(result) break;            
          if(!result) Print("OrderSend CloseSell failed with error #",GetLastError(), " Try ", try);                                      
          if (try==MaxTries) {Print("Warning!!!Last try failed!");}
          Sleep(5000);
        }
       }
      } 
     
  return;
  }

     



