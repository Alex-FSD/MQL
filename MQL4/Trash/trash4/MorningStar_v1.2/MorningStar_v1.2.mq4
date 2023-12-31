//+------------------------------------------------------------------+
//|                                                  MorningStar.mq4 |
//|                                     Copyright � 2010, NutCracker |
//|                                              forex-way@yandex.ru |
//|                                              http://wellforex.ru |
//-------------------------------------------------------------------+

#property copyright "Copyright � 2010, http://wellforex.ru"
#property link      "forex-way@yandex.ru"


int        Magic=10004;
double     Lots = 0.1;
extern bool       MM=false;                    // �� Switch
extern double     MMRisk=0.1;                 // Risk Factor
extern   int DayForCheck=4; 
extern   int PercentOfRange=60;
extern   int PercentOfOrder=35;
extern   int Stop=38;
extern   int Take=180;
extern   int CheckTime=8;
extern   int CloseTime=15;


int MaxTries=5;
int  TS;
int      i,cnt=0, ticket, mode=0, digit=0, TS_Spider;
double   range=0, spread=0, BuyProfit=0, SellProfit=0;
double   Lotsi=0;
double BuyPrice, SellPrice, Stop_Loss, Take_Profit;
double  BuyStop=0, SellStop=0;
string name;
double  LastUpFractal, LastDownFractal;
int Dec;

int init()
  {
   return(0);
  }
// ---- Money Management
double MoneyManagement ( bool flag, double risk)
{
   double Lotsi=Lots;    
   if ( flag ) Lotsi=NormalizeDouble(AccountFreeMargin()*risk/1000,2);   
   if (Lotsi<0.1) Lotsi=0.1;  
   return(Lotsi);
}     

// Closing of Pending Orders      
void PendOrdDel(int Magic)
{
    int total=OrdersTotal();
    for (int cnt=total-1;cnt>=0;cnt--)
    { 
      OrderSelect(cnt, SELECT_BY_POS,MODE_TRADES);        
      if (OrderMagicNumber()==Magic && (OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP) )     
      {
      bool result = false;
 for (int try=1;try<=MaxTries;try++)
       {		 
          result = OrderDelete(OrderTicket()); 
          if(result) {Print("PendOrdDel Ok"); break;}  
          if(!result) {Print("OrderSend failed with error #",GetLastError());}
        }
       }
      }    
  return;
  }    

void CloseOrdbyTime(int Magic)
{
     bool result;
     int total=OrdersTotal();    
     for (cnt=0;cnt<total;cnt++)
     { 
      OrderSelect(cnt, SELECT_BY_POS);   
      if(OrderMagicNumber()!=Magic) break;
      mode=OrderType();
  if (OrderProfit()>0) {
  if (mode==OP_BUY ) 
  {
  for (int try=1;try<=MaxTries;try++)
       {
       while (!IsTradeAllowed()) Sleep(5000);
       RefreshRates();	
			     result=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Bid,digit),20,Yellow);
			     Sleep(5000);
			     if (result) break;
		  }
   }
  if (mode==OP_SELL)
  {
  for (int tryy=1;tryy<=MaxTries;tryy++)
       {
       while (!IsTradeAllowed()) Sleep(5000);
       RefreshRates();	
			     result=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Ask,digit),20,White);
			     Sleep(5000);
			     if (result) break;
		  }
   }
}       
}
}


void SellStopOrdOpen(int ColorOfSell,int Magic)
{		     

  
 for (int try=1;try<=MaxTries;try++)
       {
       while (!IsTradeAllowed()) Sleep(5000);
       RefreshRates();		  
		  
          ticket = OrderSend(Symbol(),OP_SELLSTOP,Lotsi,
		                     NormalizeDouble(SellPrice,digit),
		                     20,
		                     NormalizeDouble(SellStop,digit),
		                     NormalizeDouble(SellProfit,digit),name,Magic,0,ColorOfSell);
       
           Sleep(2000);
            if (ticket>0)  break;           
            
            if(ticket<0)
            {
             if (try==MaxTries) {Print("Warning!!!Last try failed!");}
            Print("OrderSend failed with error #",GetLastError());
            return(0);
            }
}
}

void BuyStopOrdOpen(int ColorOfBuy,int Magic)
{		     

for (int try=1;try<=MaxTries;try++)
       {
       while (!IsTradeAllowed()) Sleep(5000);
       RefreshRates();	

		   ticket = OrderSend(Symbol(),OP_BUYSTOP ,Lotsi,
		                     NormalizeDouble(BuyPrice ,digit),
		                     20,
		                     NormalizeDouble(BuyStop ,digit),
		                     NormalizeDouble(BuyProfit,digit),name,Magic,0,ColorOfBuy);                 
                   Sleep(2000);
    
               if (ticket>0) break;        
            if(ticket<0)
            {
            if (try==MaxTries) {Print("Warning!!!Last try failed!");}
            Print("OrderSend failed with error #",GetLastError());
            return(0);
            }
            }
}      

// ---- Scan Trades
int ScanTradesPend(int Magic)
{   
   int total = OrdersTotal();
   int numords = 0;     
   for(cnt=0; cnt<total; cnt++) 
   {        
   OrderSelect(cnt, SELECT_BY_POS);            
   if(OrderSymbol()==Symbol() && (OrderType()==OP_BUYSTOP  || OrderType()==OP_SELLSTOP) && OrderMagicNumber() == Magic) 
   numords++;
   }
   return(numords);
}

int ScanTradesOpen(int Magic)
{   
   int total = OrdersTotal();
   int numords = 0;
      
   for(cnt=0; cnt<total; cnt++) 
   {        
   OrderSelect(cnt, SELECT_BY_POS);            
   if(OrderSymbol() == Symbol() && (OrderType()==OP_BUY || OrderType()==OP_SELL)  && OrderMagicNumber() == Magic) 
   numords++;
   }
   return(numords);
}
   
int RulesOfTrade() //��������� � ������� ��������
      {
 double t1,t2,p1,p2,TakeProfit, min, max,Bar;
 int b1,b2;
    if (Hour()==CheckTime) 
    {  
         max=0;
         Bar=Hour();   
   for(int kkk=1;kkk<=Bar;kkk++){
         if (iHigh(Symbol(),PERIOD_H1,kkk)>max) max=iHigh(Symbol(),PERIOD_H1,kkk);
      }
      p1=max;
     min=5000;   
   for(int lll=1;lll<=Bar;lll++){
         if (iLow(Symbol(),PERIOD_H1,lll)<min) min=iLow(Symbol(),PERIOD_H1,lll);
      }
      p2=min;
      range =iATR(Symbol(),PERIOD_D1,DayForCheck,1); 

      SellPrice=p2-range*PercentOfOrder/100;
      BuyPrice =p1+range*PercentOfOrder/100;    

      Stop_Loss=Stop*Point*Dec;
      Take_Profit=Take*Point*Dec;
      SellStop=SellPrice + Stop_Loss;
      BuyStop=BuyPrice - Stop_Loss;
      BuyProfit=BuyPrice+Take_Profit;
      SellProfit=SellPrice-Take_Profit;

if (p1-p2<range*PercentOfRange/100) 
{ name="MorningStar";  return(1);} 

     } 
   }
            
int start()
{  
   digit  = MarketInfo(Symbol(),MODE_DIGITS); 
   if (digit==5 || digit==3) Dec=10;
   if (digit==4 || digit==2) Dec=1;   
   Lotsi = MoneyManagement (MM,MMRisk);

   if ((Hour()==CloseTime) && ScanTradesPend(Magic)>0) {PendOrdDel(Magic);}
   if ( Hour()==0 && ScanTradesOpen(Magic)>0) {CloseOrdbyTime(Magic);} 
   if (ScanTradesPend(Magic)==1) {PendOrdDel(Magic);}     
   if (ScanTradesOpen(Magic)==0  && ScanTradesPend(Magic)==0)
      {
      if (RulesOfTrade()==1) {BuyStopOrdOpen(Blue,Magic);SellStopOrdOpen(Red,Magic);}            
      }
}

