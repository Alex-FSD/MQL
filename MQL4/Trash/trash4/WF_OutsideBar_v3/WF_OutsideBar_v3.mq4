//+------------------------------------------------------------------+
//|                                                   OutSideBar.mq4 |
//|                                     Copyright © 2010, NutCracker |
//|                                              forex-way@yandex.ru |
//|                                              http://wellforex.ru |
//-------------------------------------------------------------------+

#property copyright "Copyright © 2010, http://wellforex.ru"
#property link      "forex-way@yandex.ru"
extern string   ParamertSet = "Параметры эксперта";
extern  int     Magic=10002;
extern int      CheckTimeStart  = 10;
extern int      CheckTimeEnd    = 23;
extern  int     MA_Period=31;
extern int      Take=150;                        //Тейкпрофит
extern bool     Tral=false;                      // Включение Trailing Stop да/нет
extern int      TS=40;                            //Trailing Stop
extern int      TralStep=2;                      //Trailing Step
extern bool     CloseByMA=true;                      // Включение Trailing Stop да/нет
extern int      MinBar=10;                       //Допустимая длина бара
extern int      MaxBar=95;                       //Допустимая длина бара
extern bool     ExitByBar=false;                 //Выход по бару де/нет
extern int      ExitBar=3;                      //Бар выхода
extern string   ParamertSet3 = "Trading Days";
extern bool     Monday=true;     
extern bool     Tuesday=true; 
extern bool     Wednesday=true; 
extern bool     Thursday=true; 
extern bool     Friday=true; 
extern string   MMSet = "Управление капиталом";
extern bool     MM=false;                       // Включение ММ да/нет
extern double   MMRisk=0.1;                     // Risk Factor
extern double   Lots = 0.1;                     // Лот


int  MaxTries=10, Dec, b1, b2;
int   i, cnt=0, ticket, mode=0, digit=0, total, LastVol=5;
double  StopLoss, TakeProfit, TakeProfitSell, max=0,min=0, Lotsi=0, MA;
bool  OrderToday=false;
double  BuyStop=0, SellStop=0,  LastSellStop, LastBuyStop, LastSellTake, LastBuyTake, Price;
datetime t1, t2, t3,t4;
int up,dn,BuySig, SellSig, OrderSig, BuySigPer, SellSigPer;
string LastSig=" Не определено", name="OutSideBar";
color ColorOfSig;


int start()
{

   digit  = MarketInfo(Symbol(),MODE_DIGITS); 
   if (digit==5 || digit==3) Dec=10;
   if (digit==4 || digit==2) Dec=1; 
   Lotsi = MoneyManagement (MM,MMRisk);
if (!IsOptimization() && !IsTesting() && !IsVisualMode()) {Comment("Magic = ", Magic,"\nСледующий лот = ", Lotsi,
        "   \nМинимальный лот = ", MarketInfo(Symbol(), MODE_MINLOT)); DrawLogo();}
if (ScanTradesOpen(Magic)>0 && Tral) TrailStops(Magic);  
if (DayOfWeek()==1 && !Monday) return(0);
if (DayOfWeek()==2 && !Tuesday) return(0);
if (DayOfWeek()==3 && !Wednesday) return(0);
if (DayOfWeek()==4 && !Thursday) return(0);
if (DayOfWeek()==5 && !Friday) return(0);

if (Volume[0]<=10 && (Volume[0]<LastVol || Volume[0]==1))
{

MA=iMA(Symbol(),0,MA_Period,0,MODE_SMMA,PRICE_MEDIAN,1);



   OrderSig=Rules();
  if (OrderSig==1 && ScanTradesOpen(Magic)==0 && Hour()>=CheckTimeStart && Hour()<CheckTimeEnd) 
  {
  BuyMarketOrdOpen(Blue,Magic); 
  }
  
  if (OrderSig==2 && ScanTradesOpen(Magic)==0 && Hour()>=CheckTimeStart && Hour()<CheckTimeEnd) 
  {
   SellMarketOrdOpen(Red,Magic); 
  }
          


if (ScanTradesBuyOpen(Magic)>0 && iClose(Symbol(),0,1)<MA && CloseByMA) AllBuyOrdDel(Magic); 
if (ScanTradesSellOpen(Magic)>0 && iClose(Symbol(),0,1)>MA && CloseByMA) AllSellOrdDel(Magic); 

if (ScanTradesOpen(Magic)>0 && ExitByBar) CloseByBar(Magic); 
}
LastVol=Volume[0];  
}
      
//----Rules of trading   
int Rules() 
{


TakeProfit=Take*Dec*Point;

if (iLow(Symbol(),0,1)>MA && iClose(Symbol(),0,1)>iHigh(Symbol(),0,2) && iClose(Symbol(),0,2)>MA && iOpen(Symbol(),0,2)<MA && iClose(Symbol(),0,1)-iOpen(Symbol(),0,1)>MinBar*Dec*Point && iClose(Symbol(),0,1)-iOpen(Symbol(),0,1)<MaxBar*Dec*Point) 
{
StopLoss=iClose(Symbol(),0,1)-iLow(Symbol(),0,2);
 if (!IsOptimization())
 {
         ObjectCreate("BB"+TimeCurrent(), OBJ_ARROW,0,0,0,0,0);
         ObjectSet   ("BB"+TimeCurrent(), OBJPROP_COLOR, Blue);
         ObjectSet   ("BB"+TimeCurrent(), OBJPROP_ARROWCODE, 233);
         ObjectSet   ("BB"+TimeCurrent(), OBJPROP_TIME1,TimeCurrent()-Period());
         ObjectSet   ("BB"+TimeCurrent(), OBJPROP_PRICE1,iLow(Symbol(),0,1));   
 }
return(1);
}
if (iHigh(Symbol(),0,1)<MA && iClose(Symbol(),0,1)<iLow(Symbol(),0,2) && iClose(Symbol(),0,2)<MA && iOpen(Symbol(),0,2)>MA && iOpen(Symbol(),0,1)-iClose(Symbol(),0,1)>MinBar*Dec*Point && iOpen(Symbol(),0,1)-iClose(Symbol(),0,1)<MaxBar*Dec*Point) 
{
StopLoss=iHigh(Symbol(),0,2)-iClose(Symbol(),0,1);
 if (!IsOptimization())
 {
         ObjectCreate("BB"+TimeCurrent(), OBJ_ARROW,0,0,0,0,0);
         ObjectSet   ("BB"+TimeCurrent(), OBJPROP_COLOR, Red);
         ObjectSet   ("BB"+TimeCurrent(), OBJPROP_ARROWCODE, 234);
         ObjectSet   ("BB"+TimeCurrent(), OBJPROP_TIME1,TimeCurrent()-Period());
         ObjectSet   ("BB"+TimeCurrent(), OBJPROP_PRICE1,iHigh(Symbol(),0,1)+Period()*Dec*Point/3);   
 }
return(2);
}

return(0);

   }


int init()
  {

   return(0);
  }
//Money Management

double MoneyManagement ( bool flag, double risk)
{
   double Lotsi=Lots;
	    
   if ( flag ) Lotsi=NormalizeDouble(AccountFreeMargin()*risk/1000,2);   
   if (Lotsi<MarketInfo(Symbol(), MODE_MINLOT)) Lotsi=MarketInfo(Symbol(), MODE_MINLOT);  
   return(Lotsi);
}   





void BuyMarketOrdOpen(int ColorOfBuy,int Magic)
  {
  int try, res;

 //  if(Volume[0]>1) return;

          
  for (try=1;try<=MaxTries;try++)
       {
       while (!IsTradeAllowed()) Sleep(5000);
       RefreshRates();		  

      res=OrderSend(Symbol(),OP_BUY,Lotsi,NormalizeDouble(Ask ,digit),2*Dec,NormalizeDouble(Bid ,digit)-StopLoss,NormalizeDouble(Ask ,digit)+TakeProfit,name,Magic,0,ColorOfBuy);
      Sleep(2000);
      if(res>0)
           {
            if(OrderSelect(res,SELECT_BY_TICKET,MODE_TRADES)) break;
            }
         else 
         {
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

 //       if(Volume[0]>1) return;

  
 for (try=1;try<=MaxTries;try++)
       {
       while (!IsTradeAllowed()) Sleep(5000);
       RefreshRates();	
       
      res=OrderSend(Symbol(),OP_SELL,Lotsi,NormalizeDouble(Bid ,digit),2*Dec,NormalizeDouble(Ask ,digit)+StopLoss,NormalizeDouble(Bid ,digit)-TakeProfit,name,Magic,0,ColorOfSell);
      Sleep(2000);
      if(res>0)
           {
            if(OrderSelect(res,SELECT_BY_TICKET,MODE_TRADES)) break;
            }
         else 
         {
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
   numords++;
   }
   return(numords);
}

int ScanTradesBuyOpen(int Magic)
{   
   int total = OrdersTotal();
   int numords = 0;
      
   for(cnt=0; cnt<total; cnt++) 
   {        
   OrderSelect(cnt, SELECT_BY_POS);            
   if(OrderSymbol() == Symbol() && (OrderType()==OP_BUY)  && OrderMagicNumber() == Magic) 
   numords++;
   }
   return(numords);
}

int ScanTradesSellOpen(int Magic)
{   
   int total = OrdersTotal();
   int numords = 0;
      
   for(cnt=0; cnt<total; cnt++) 
   {        
   OrderSelect(cnt, SELECT_BY_POS);            
   if(OrderSymbol() == Symbol() && (OrderType()==OP_SELL)  && OrderMagicNumber() == Magic) 
   numords++;
   }
   return(numords);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TrailStops(int nMagic)
  {
   total=OrdersTotal();
   for(cnt=0;cnt<total;cnt++)
     {
      OrderSelect(cnt,SELECT_BY_POS);
      mode=OrderType();
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==nMagic)
        {

         if(mode==OP_BUY)
           {
            if(NormalizeDouble(Ask-OrderOpenPrice(),Digits)>0 && NormalizeDouble(Ask-OrderStopLoss(),Digits)>Point*(TS+TralStep)*Dec)
              {
               OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Ask-TS*Dec*Point,Digits),OrderTakeProfit(),0,Green);
              }
           }

         if(mode==OP_SELL)
           {
            if(NormalizeDouble(OrderOpenPrice()-Bid,Digits)>0 && (NormalizeDouble(OrderStopLoss()-Bid,Digits)>Point*(TS+TralStep)*Dec || OrderStopLoss()==0))
              {
               OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Bid+TS*Dec*Point,Digits),OrderTakeProfit(),0,Green);
              }
           }
        }
     }
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

void DrawLogo() {

   string l_name_8 = "Logo" + "1";
   if (ObjectFind(l_name_8) == -1) {
      ObjectCreate(l_name_8, OBJ_LABEL, 0, 0, 0);
      ObjectSet(l_name_8, OBJPROP_CORNER, 1);
      ObjectSet(l_name_8, OBJPROP_XDISTANCE, 10);
      ObjectSet(l_name_8, OBJPROP_YDISTANCE, 15);
   }
   ObjectSetText(l_name_8, "WELLFOREX  ", 16, "Arial", Red);

   l_name_8 = "Logo" + "2";
   if (ObjectFind(l_name_8) == -1) {
      ObjectCreate(l_name_8, OBJ_LABEL, 0, 0, 0);
      ObjectSet(l_name_8, OBJPROP_CORNER, 1);
      ObjectSet(l_name_8, OBJPROP_XDISTANCE, 10);
      ObjectSet(l_name_8, OBJPROP_YDISTANCE, 35);
   }
   ObjectSetText(l_name_8, "TRADING SYSTEMS        ", 8, "Arial", Yellow);

   l_name_8 = "Logo" + "3";
   if (ObjectFind(l_name_8) == -1) {
      ObjectCreate(l_name_8, OBJ_LABEL, 0, 0, 0);
      ObjectSet(l_name_8, OBJPROP_CORNER, 1);
      ObjectSet(l_name_8, OBJPROP_XDISTANCE, 10);
      ObjectSet(l_name_8, OBJPROP_YDISTANCE, 47);
   }
   ObjectSetText(l_name_8, "http://wellforex.ru   ", 8, "Courier New", White);
}


void CloseByBar(int Magic)
{
    int total=OrdersTotal();
    int CloseBar;
    for (int cnt=total-1;cnt>=0;cnt--)
    { 
      OrderSelect(cnt, SELECT_BY_POS,MODE_TRADES);   

      CloseBar=ExitBar;   
     
        if (OrderMagicNumber()==Magic && (OrderType()==OP_BUY || OrderType()==OP_SELL) && (TimeCurrent()-OrderOpenTime())/Period()/60>=CloseBar)     
        {
        bool result = false;
 
 for (int try=1;try<=MaxTries;try++)
       {		 
          RefreshRates();
          result = OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Bid ,digit),5*Dec,Yellow);
          if(result) break;            
          if(!result) Print("OrderSend failed with error #",GetLastError(), " Try ", try);                                      
          if (try==MaxTries) {Print("Warning!!!Last try failed!");}
          Sleep(5000);
        }
       }
      } 
     
  return;
  }            



