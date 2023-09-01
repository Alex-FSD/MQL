//+------------------------------------------------------------------+
//|                                                   FlatStream.mq4 |
//|                                     Copyright © 2010, NutCracker |
//|                                              forex-way@yandex.ru |
//|                                              http://wellforex.ru |
//-------------------------------------------------------------------+

#property copyright "Copyright © 2010, http://wellforex.ru"
#property link      "forex-way@yandex.ru"
extern int    Magic=10003;   
extern bool   MM=false;                       
extern double MMRisk=3;                 
extern double StartLots = 0.1;  
extern int    TimeStart=20;  
extern int    TimeEnd=23;  
extern int    TimeClose=4;  
extern int    Stop=60;
extern int    Take=20;
extern int    Step=10;
extern int    OrderMax=2;  

int MaxTries=5;
int i,cnt=0, ticket, mode=0, digit=5, OrderCod=0;
double Lotsi=0;
double BuyPrice, SellPrice,SShort;
double  StopLoss, TakeProfit, NewTake, open,StartPriceAsk,StartPriceBid;
string name="FlatStream", Market="n/a";
int ADX=6;
int ADX_L=50;
int ATR=2;
extern int D_ATR=26;
int MaxDayRange=210;
int OrderPriceShift    = 21; 
int Dec=10, LastVol=5, Num=1,OrderMax1;
double SLong, min, max, p1, p2, ADX_M, ADX_MINUS, ADX_PLUS;
double  LastUpFractal, LastDownFractal, SAR1, SAR2, SAR3, Shift;
int NumberUp, NumberDown, TS_Spider, TS;
double PriceMove, SentPrice, OrderPrice, spread, Orderspread, Maxspread, MedSpread, SumSpread=0;
bool OrderToday=false;

int init()
  {
   HideTestIndicators(true);
   return(0);
  }

int start()

{

  if (Month()==12 && Day()>=18) return(0); 
  if (Month()==1 && Day()<=4) return(0);   
   digit  = MarketInfo(Symbol(),MODE_DIGITS); 
   if (digit==5 || digit==3) Dec=10;
   if (digit==4 || digit==2) Dec=1;   
Lotsi = F_832 (MM,MMRisk);

if (!IsOptimization() && !IsTesting() && !IsVisualMode()) {Comment("Magic = ", Magic,"\nNext Lot = ", Lotsi,
        "   \nMin Lot = ", MarketInfo(Symbol(), MODE_MINLOT),"\nToday Market - "+Market);}
 
if(Volume[0]<=LastVol) 
{
if (Hour()==0) OrderToday=false;

if(O_521(Magic)==0)
 {
   OrderMax1=0;
   if(D_410()==1) Z_451(Blue,Magic);
   if(D_410()==2) T_112(Red,Magic);
 }
if(O_521(Magic)>0) 
 {
U_653(Magic);
if (Hour()==TimeClose) {OrderMax1=0; P_910(Magic);}
 }
}
LastVol=Volume[0];

}

int D_410()
{
bool ADX_B, ADX_S;
ADX_M=iADX(NULL,60,ADX,PRICE_CLOSE,MODE_MAIN,1);
ADX_PLUS=iADX(NULL,60,ADX,PRICE_CLOSE,MODE_PLUSDI,1);
ADX_MINUS=iADX(NULL,60,ADX,PRICE_CLOSE,MODE_MINUSDI,1);
ADX_B=true; ADX_S=true;
//if (ADX_M>ADX_L && ADX_PLUS>ADX_MINUS) ADX_S=false;
//if (ADX_M>ADX_L && ADX_PLUS<ADX_MINUS) ADX_B=false;

if (Hour()<TimeStart) {OrderToday=false; StartPriceAsk=0; StartPriceBid=0;}
if (Hour()<TimeStart || Hour()>TimeEnd) return (0);     
if (Hour()==TimeStart && StartPriceAsk==0) {StartPriceAsk=Ask; StartPriceBid=Bid;}
if (Hour()>=TimeStart && OrderToday==true) return (0);          
max=0;
for(int kkk=1;kkk<=Hour();kkk++){if (iHigh(NULL,PERIOD_H1,kkk)>max) max=iHigh(NULL,PERIOD_H1,kkk);}p1=max;min=100000; 
for(int lll=1;lll<=Hour();lll++){if (iLow(NULL,PERIOD_H1,lll)<min) min=iLow(NULL,PERIOD_H1,lll);}p2=min;
if (((p1-p2)+iATR(NULL,PERIOD_D1,2,1))/2>MaxDayRange*Point*Dec)  {Market="Bad, no trading today";return;}
Market="Ok";
StopLoss=Stop*Dec*Point;
TakeProfit=Take*Dec*Point;
if (MathAbs(iClose(NULL,PERIOD_H1,1)-iOpen(NULL,PERIOD_H1,1))>30*Dec*Point) return;
if (iATR(NULL,PERIOD_H1,ATR,1)>D_ATR*Point*Dec)  return;  
if (iClose(NULL,PERIOD_M15,1)<iOpen(NULL,PERIOD_M15,1) && Ask<StartPriceAsk-OrderPriceShift*Dec*Point && ADX_B) return(1); // 1- Buy
if (iClose(NULL,PERIOD_M15,1)>iOpen(NULL,PERIOD_M15,1) && Bid>StartPriceBid+OrderPriceShift*Dec*Point && ADX_S) return(2); // 2- Sell  

} 

double F_832( bool flag, double risk)
{
   double Lotsi=StartLots;
	    
   if ( flag ) Lotsi=NormalizeDouble(AccountBalance()*risk/10000,2);   
   if (Lotsi<MarketInfo(Symbol(), MODE_MINLOT)) Lotsi=MarketInfo(Symbol(), MODE_MINLOT);  
   return(Lotsi);
}   

void Z_451(int ColorOfBuy,int Magic)
  {
  int try, res;       
  for (try=1;try<=MaxTries;try++)
       {
       while (!IsTradeAllowed()) Sleep(5000);
       RefreshRates();		  
      SentPrice=Ask; Orderspread=MarketInfo(Symbol(),MODE_SPREAD);
      res=OrderSend(Symbol(),OP_BUY,Lotsi,NormalizeDouble(Ask ,digit),2*Dec,NormalizeDouble(Bid ,digit)-StopLoss,NormalizeDouble(Ask ,digit)+TakeProfit,name,Magic,0,ColorOfBuy);
      Sleep(2000);
      if(res>0)
           {
            if(OrderSelect(res,SELECT_BY_TICKET,MODE_TRADES)) {OrderPrice=OrderOpenPrice(); OrderToday=true; break;}
            }
         else 
         {
         Print("Error opening BUY order : ",GetLastError()); 
         }     
       }
      return;
      }

void T_112(int ColorOfSell,int Magic)      
      { 
        int try, res;  
 for (try=1;try<=MaxTries;try++)
       {
       while (!IsTradeAllowed()) Sleep(5000);
       RefreshRates();	
      SentPrice=Bid; Orderspread=MarketInfo(Symbol(),MODE_SPREAD);        
      res=OrderSend(Symbol(),OP_SELL,Lotsi,NormalizeDouble(Bid ,digit),2*Dec,NormalizeDouble(Ask ,digit)+StopLoss,NormalizeDouble(Bid ,digit)-TakeProfit,name,Magic,0,ColorOfSell);
      Sleep(2000);
      if(res>0)
           {
            if(OrderSelect(res,SELECT_BY_TICKET,MODE_TRADES)) {OrderPrice=OrderOpenPrice(); OrderToday=true; break;}
            }
         else 
         {
         Print("Error opening BUY order : ",GetLastError()); 
        }
      }
      return;
      }
      
void P_910(int Magic)
{
    int total=OrdersTotal();
    bool result = false;
    for (int cnt=total-1;cnt>=0;cnt--)
    { 
      OrderSelect(cnt, SELECT_BY_POS,MODE_TRADES);   
      
        if (OrderMagicNumber()==Magic && OrderType()==OP_BUY)     
        {
        result = false;
 
 for (int try=1;try<=MaxTries;try++)
       {		 
          result = OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Bid ,digit),2*Dec,Yellow);
          if(result) break;            
          if(!result) Print("OrderSend failed with error #",GetLastError());                                      
        }
       }
        if (OrderMagicNumber()==Magic && OrderType()==OP_SELL)     
        {
        result = false;
 
 for (try=1;try<=MaxTries;try++)
       {		 
          result = OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Ask ,digit),2*Dec,Yellow);
          if(result) break;            
          if(!result) Print("OrderSend failed with error #",GetLastError());                                      
        }
       }
      } 
     
  return;
  }

int O_521(int Magic)
{   
   int total = OrdersTotal();
   int numords = 0;
      
   for(cnt=0; cnt<total; cnt++) 
   {        
   OrderSelect(cnt, SELECT_BY_POS);            
   if(OrderSymbol() == Symbol() && (OrderType()==OP_BUY || OrderType()==OP_SELL)  && OrderMagicNumber() == Magic) 
   numords++;
   }
if (OrderMax1<numords) OrderMax1=numords;
   return(numords);
}

void U_653(int Magic)
{        
    int total=OrdersTotal(), try;
    double LastOpen;
    bool result=false;

    if (OrderMax1>=OrderMax) return (0); 

     for (cnt=0;cnt<=total;cnt++)      
       {
      OrderSelect(cnt, SELECT_BY_POS);
      if (OrderMagicNumber() == Magic && OrderSymbol()==Symbol() && (OrderType()==OP_BUY || OrderType()==OP_SELL)) 
      {LastOpen=OrderOpenPrice(); mode=OrderType();

       }              
       } 

      StopLoss=Stop*Dec*Point;
      TakeProfit=Take*Dec*Point;
    if (NormalizeDouble(Ask ,digit)-LastOpen<-(Step*Dec*Point) && mode==OP_BUY)
    {
     Z_451(Blue,Magic);

     total=OrdersTotal();

     NewTake=NormalizeDouble(Ask ,digit)+TakeProfit;
     for (cnt=0;cnt<total-1;cnt++)      
       {
      OrderSelect(cnt, SELECT_BY_POS);           
      if (OrderMagicNumber() == Magic) 
      {
 for (try=1;try<=MaxTries;try++)
       {		 
          result = OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),NewTake,0,Green);
          if(result) break;
          if(!result) Print("OrderModify failed with error #",GetLastError());                           

        }
      }
       }
    }
    if (LastOpen-NormalizeDouble(Bid ,digit)<-(Step*Dec*Point) && mode==OP_SELL)
    {
     T_112(Red,Magic);

     total=OrdersTotal();
     //OrderSelect(total-1, SELECT_BY_POS); 
     NewTake=NormalizeDouble(Bid ,digit)-TakeProfit;
     for (cnt=0;cnt<total-1;cnt++)      
       {
       OrderSelect(cnt, SELECT_BY_POS);           
       if (OrderMagicNumber() == Magic) 
       {
        for (try=1;try<=MaxTries;try++)
       {		 
          result = OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),NewTake,0,Green);
          if(result) break;
          if(!result) Print("OrderModify failed with error #",GetLastError());                           

        }
       
       }
       }
    }
    return(0);
} 

 
 












