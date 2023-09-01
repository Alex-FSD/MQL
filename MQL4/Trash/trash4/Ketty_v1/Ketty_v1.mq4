//+------------------------------------------------------------------+
//|                                                        Ketty.mq4 |
//|                                     Copyright © 2010, NutCracher |
//|                                              forex-way@yandex.ru |
//|                                              http://wellforex.ru |
//-------------------------------------------------------------------+

#property copyright "Copyright © 2010, http://wellforex.ru"
#property link      "forex-way@yandex.ru"
extern string   ParamertSet = "Параметры эксперта";
extern string   CheckTimeStart  = "07:00";
extern string   CheckTimeEnd    = "08:00";
extern int      OpenTime=8;
extern int      CloseTime=18;
extern int      Delta=30;
extern int      OrderPriceShift=10;
extern int      StopLoss=25;
extern int      TakeProfit=75;
extern string   BrokerSet = "Установки ДЦ";  
extern int      NumberOfDigit=5;                //Количество знаков в котировках торгового сервера: 4 или 5
extern string   MMSet = "Управление капиталом";
extern bool     MM=false;                       // ММ Switch
extern double   MMRisk=0.1;                     // Risk Factor
extern double   Lots = 0.1;
extern string   VisualSet = "Отображение";
extern bool Visual=true;
extern color ColorToShow = CornflowerBlue;

int        Magic=10001;


int  MaxTries=5, Dec, b1, b2;
int   i, cnt=0, ticket, mode=0, digit=0;
double  BuyProfit=0, SellProfit=0, BuyPrice, SellPrice, p1,p2,max=0,min=0, Lotsi=0;
bool  OrderToday=false;
double  BuyStop=0, SellStop=0;
string name;
datetime t1, t2;

int init()
  {
   return(0);
  }
//Money Management

double MoneyManagement ( bool flag, double risk)
{
   double Lotsi=Lots;
	    
   if ( flag ) Lotsi=NormalizeDouble(AccountFreeMargin()*risk/1000,2);   
   if (Lotsi<0.1) Lotsi=0.1;  
   return(Lotsi);
}   

//Closing of Pending Orders      
void PendOrdDel(int Magic)
{
    int total=OrdersTotal();
    for (int cnt=total-1;cnt>=0;cnt--)
    { 
      OrderSelect(cnt, SELECT_BY_POS,MODE_TRADES);   
      
        if ((OrderMagicNumber()==Magic)  )     
        {
        bool result = false;
 
 for (int try=1;try<=MaxTries;try++)
       {
		 
          result = OrderDelete(OrderTicket()); 
          if(result)
            {
            Print("PendOrdDel Ok"); break;
            }  
          if(!result)
            {
            Print("OrderSend failed with error #",GetLastError());                           
            }
        }
       }
      } 
     
  return;
  }  


//Sell open
void SellStopOrdOpen(int ColorOfSell,int Magic)
{		      

 for (int try=1;try<=MaxTries;try++)
       {
       while (!IsTradeAllowed()) Sleep(500);
       RefreshRates();		  
		  
          ticket = OrderSend(Symbol(),OP_SELLSTOP,Lotsi,
		                     NormalizeDouble(SellPrice,digit),
		                     2*Dec,
		                     NormalizeDouble(SellStop,digit),
		                     NormalizeDouble(SellProfit,digit),name,Magic,0,ColorOfSell);
       
           Sleep(200);
            if (ticket>0) {OrderToday=true;   break;}            
            
            if(ticket<0)
            {
             if (try==MaxTries) {Print("Warning!!!Last try failed!");}
            Print("OrderSend failed with error #",GetLastError());
            return(0);
            }
}
}
//Buy open
void BuyStopOrdOpen(int ColorOfBuy,int Magic)
{		     
 
for (int try=1;try<=MaxTries;try++)
       {
       while (!IsTradeAllowed()) Sleep(500);
       RefreshRates();	

		   ticket = OrderSend(Symbol(),OP_BUYSTOP ,Lotsi,
		                     NormalizeDouble(BuyPrice ,digit),
		                     2*Dec,
		                     NormalizeDouble(BuyStop ,digit),
		                     NormalizeDouble(BuyProfit,digit),name,Magic,0,ColorOfBuy);              
                   Sleep(200);    
               if (ticket>0) {OrderToday=true;   break;}          
            if(ticket<0)
            {
            if (try==MaxTries) {Print("Warning!!!Last try failed!");}
            Print("OrderSend failed with error #",GetLastError());
            return(0);
            }
            }
}      


// ---- Scan Trades pend
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
// ---- Scan Trades opened
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

// ---- Show chanal
int ShowVisual()
{
      if (TimeCurrent()>t2 && ObjectFind("Chanal"+t2)==-1)
      {
         ObjectCreate("Chanal"+t2, OBJ_RECTANGLE,0,0,0,0,0);
         ObjectSet   ("Chanal"+t2, OBJPROP_STYLE, STYLE_SOLID);
         ObjectSet   ("Chanal"+t2, OBJPROP_COLOR, ColorToShow);
         ObjectSet   ("Chanal"+t2, OBJPROP_BACK, true);
         ObjectSet   ("Chanal"+t2, OBJPROP_TIME1,t1);
         ObjectSet   ("Chanal"+t2, OBJPROP_PRICE1,p1);
         ObjectSet   ("Chanal"+t2, OBJPROP_TIME2,t2);
         ObjectSet   ("Chanal"+t2, OBJPROP_PRICE2,p2);
      }
}
//----Rules of trading   
int RulesOfKetty() 
{


    if (Hour()>=OpenTime && Hour()<=CloseTime) 
    {  
  t1        = StrToTime(StringConcatenate(Day(),".",Month(),".",Year()," ",CheckTimeStart,       ":00"));
  t2        = StrToTime(StringConcatenate(Day(),".",Month(),".",Year()," ",CheckTimeEnd,       ":00"));
  t1=StrToTime(TimeToStr(CurTime(), TIME_DATE)+" "+CheckTimeStart);
  t2=StrToTime(TimeToStr(CurTime(), TIME_DATE)+" "+CheckTimeEnd);

  b1=iBarShift(NULL, PERIOD_M15, t1);
  b2=iBarShift(NULL, PERIOD_M15, t2);
   max=0;min=0;
   for(int kkk=b2;kkk<=b1;kkk++){
         if (iHigh(NULL,PERIOD_M15,kkk)>max) max=iHigh(NULL,PERIOD_M15,kkk);
      }
      p1=max;
     min=5;   
   for(int lll=b2;lll<=b1;lll++){
         if (iLow(NULL,PERIOD_M15,lll)<min) min=iLow(NULL,PERIOD_M15,lll);
      }
      p2=min;
           
      SellPrice=p2-OrderPriceShift*Dec*Point;
      BuyPrice =p1+OrderPriceShift*Dec*Point;    
      SellStop=SellPrice + StopLoss*Dec*Point;
      BuyStop=BuyPrice - StopLoss*Dec*Point;
      BuyProfit=BuyPrice+TakeProfit*Dec*Point;
      SellProfit=SellPrice-TakeProfit*Dec*Point;

if (Visual) ShowVisual();
if (iLow(NULL,PERIOD_M15,1)<p2-Delta*Dec*Point) 
{ name="Ketty";  return(1);} // 1- Buy
if (iHigh(NULL,PERIOD_M15,1)>p1+Delta*Dec*Point) 
{ name="Ketty";  return(2);} // 2- Sell
     } 
   }
            

int start()
{  
   if (NumberOfDigit==4) Dec=1;
   if (NumberOfDigit==5) Dec=10;   
   digit  = MarketInfo(Symbol(),MODE_DIGITS); 
   Lotsi = MoneyManagement (MM,MMRisk);

   if ((Hour()==CloseTime+1) && ScanTradesPend(Magic)>0) {PendOrdDel(Magic);}
   if ( Hour()==0) {OrderToday=false;}      
   if (ScanTradesOpen(Magic)==0 && ScanTradesPend(Magic)==0 && OrderToday==false)
      {
      if (RulesOfKetty()==1) {BuyStopOrdOpen(Blue,Magic);}
      if (RulesOfKetty()==2) {SellStopOrdOpen(Red,Magic);}              
      }
}

