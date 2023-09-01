//+------------------------------------------------------------------+
//|                                     Copyright © 2010, NutCracker |
//|                                              forex-way@yandex.ru |
//|                                              http://wellforex.ru |
//-------------------------------------------------------------------+

#property copyright "Copyright © 2010, http://wellforex.ru"
#property link      "forex-way@yandex.ru"
extern string   ParamertSet1 = "Параметры эксперта";
extern  int     Magic=10002;
extern  int     MA_Period=32;
extern  int     Shift=9;
extern int      Take=50;                        
extern int      Stop=110;                       
extern bool     Tral=false;                     
extern int      TS=40;                           
extern int      TralStep=10;                    
extern bool     CloseByMA=true;                      
extern int      MinBar=25;                   
extern int      MaxBar=90; 
extern bool     ExitByBar=false;                
extern int      ExitBar=3;                                    
extern string   ParamertSet2 = "Trading Days";
extern bool     Monday=true;     
extern bool     Tuesday=true; 
extern bool     Wednesday=true; 
extern bool     Thursday=true; 
extern bool     Friday=true; 
extern string   ParamertSet3 = "Trading Time";
extern int      CheckTimeStart  = 0;
extern int      CheckTimeEnd    = 25;
extern string   MMSet = "Управление капиталом";
extern bool     MM=false;                       
extern double   MMRisk=0.1;                    
extern double   Lots = 0.1;                   


int  MaxTries=10, Dec, b1, b2;
int   i, cnt=0, ticket, mode=0, digit=0, total, LastVol=5;
double  StopLoss, TakeProfit, TakeProfitSell, max=0,min=0, Lotsi=0, MA, ZeroBuy, ZeroSell, LastZeroBuy,LastZeroSell;
bool  OrderToday=false;
double  BuyStop=0, SellStop=0,  LastSellStop, LastBuyStop, LastSellTake, LastBuyTake, Price;
datetime t1, t2, t3,t4;
int up,dn,BuySig, SellSig, OrderSig, BuySigPer, SellSigPer;
string name="DoubleZT";
color ColorOfSig;
      
int init()
  {

   return(0);
  }
  
int start()
{
   digit  = MarketInfo(Symbol(),MODE_DIGITS); 
   if (digit==5 || digit==3) Dec=10;
   if (digit==4 || digit==2) Dec=1; 
   Lotsi = MoneyManagement (MM,MMRisk);
if (!IsOptimization() && !IsTesting() && !IsVisualMode()) {Comment("Следующий лот = ", Lotsi,
        "   \nОткрытых позиций = ", ScanTradesOpen(Magic), 
        "   \nMagic = ", Magic,
        "   \nМинимальный лот = ", MarketInfo(Symbol(), MODE_MINLOT)); DrawLogo();}

if(Volume[0]==1 || Volume[0]<LastVol)
{  

if (ScanTradesOpen(Magic)>0 && ExitByBar) CloseByBar(Magic); 
MA=iMA(Symbol(),0,MA_Period,0,MODE_SMMA,PRICE_MEDIAN,1);

   OrderSig=Rules();
  if (OrderSig==1 && ScanTradesOpen(Magic)==0 ) 
  {
  BuyMarketOrdOpen(Blue,Magic); 
  }
  
  if (OrderSig==2 && ScanTradesOpen(Magic)==0 ) 
  {
   SellMarketOrdOpen(Red,Magic); 
  }
          
if (ScanTradesOpen(Magic)>0 && Tral) TrailStops(Magic); 

if (ScanTradesBuyOpen(Magic)>0 && iClose(Symbol(),0,1)<MA && CloseByMA) AllBuyOrdDel(Magic); 
if (ScanTradesSellOpen(Magic)>0 && iClose(Symbol(),0,1)>MA && CloseByMA) AllSellOrdDel(Magic); 
}
LastVol=Volume[0];  

return(0);
} 

//----Rules of trading   
int Rules() 
{
if (DayOfWeek()==1 && !Monday) return(0);
if (DayOfWeek()==2 && !Tuesday) return(0);
if (DayOfWeek()==3 && !Wednesday) return(0);
if (DayOfWeek()==4 && !Thursday) return(0);
if (DayOfWeek()==5 && !Friday) return(0);
if (Hour()<CheckTimeStart || Hour()>=CheckTimeEnd) return(0);
ZeroBuy = StrToDouble(DoubleToStr(NormalizeDouble(iClose(Symbol(),0,1) ,digit),2));
ZeroSell = StrToDouble(DoubleToStr(NormalizeDouble(iClose(Symbol(),0,1)+10*Dec*Point ,digit),2));
 if (!IsOptimization())
 {
         ObjectCreate("Z0"+TimeCurrent(), OBJ_ARROW,0,0,0,0,0);
         ObjectSet   ("Z0"+TimeCurrent(), OBJPROP_COLOR, Yellow);
         ObjectSet   ("Z0"+TimeCurrent(), OBJPROP_ARROWCODE, 4);
         ObjectSet   ("Z0"+TimeCurrent(), OBJPROP_TIME1,TimeCurrent()-Period());
         ObjectSet   ("Z0"+TimeCurrent(), OBJPROP_PRICE1,ZeroBuy);  

         ObjectCreate("Z1"+TimeCurrent(), OBJ_ARROW,0,0,0,0,0);
         ObjectSet   ("Z1"+TimeCurrent(), OBJPROP_COLOR, Yellow);
         ObjectSet   ("Z1"+TimeCurrent(), OBJPROP_ARROWCODE, 4);
         ObjectSet   ("Z1"+TimeCurrent(), OBJPROP_TIME1,TimeCurrent()-Period());
         ObjectSet   ("Z1"+TimeCurrent(), OBJPROP_PRICE1,ZeroBuy+100*Dec*Point);  
         
         ObjectCreate("Z2"+TimeCurrent(), OBJ_ARROW,0,0,0,0,0);
         ObjectSet   ("Z2"+TimeCurrent(), OBJPROP_COLOR, Yellow);
         ObjectSet   ("Z2"+TimeCurrent(), OBJPROP_ARROWCODE, 4);
         ObjectSet   ("Z2"+TimeCurrent(), OBJPROP_TIME1,TimeCurrent()-Period());
         ObjectSet   ("Z2"+TimeCurrent(), OBJPROP_PRICE1,ZeroBuy-100*Dec*Point);   
 }

TakeProfit=Take*Dec*Point;
StopLoss=Stop*Dec*Point;
if (ZeroBuy!=LastZero(Magic) && iOpen(Symbol(),0,1)<ZeroBuy-Shift*Dec*Point && iClose(Symbol(),0,1)>ZeroBuy-Shift*Dec*Point && iClose(Symbol(),0,1)>MA && iClose(Symbol(),0,2)-iOpen(Symbol(),0,2)>MinBar*Dec*Point && iClose(Symbol(),0,2)-iOpen(Symbol(),0,2)<MaxBar*Dec*Point) 
{

 if (!IsOptimization())
 {
         ObjectCreate("DZ"+TimeCurrent(), OBJ_ARROW,0,0,0,0,0);
         ObjectSet   ("DZ"+TimeCurrent(), OBJPROP_COLOR, Blue);
         ObjectSet   ("DZ"+TimeCurrent(), OBJPROP_ARROWCODE, 233);
         ObjectSet   ("DZ"+TimeCurrent(), OBJPROP_TIME1,TimeCurrent()-Period());
         ObjectSet   ("DZ"+TimeCurrent(), OBJPROP_PRICE1,iLow(Symbol(),0,1));   
 }
  LastZeroBuy=ZeroBuy;
return(1);
}
if (ZeroSell!=LastZero(Magic) && iOpen(Symbol(),0,1)>ZeroSell+Shift*Dec*Point && iClose(Symbol(),0,1)<ZeroSell+Shift*Dec*Point && iClose(Symbol(),0,1)<MA && iOpen(Symbol(),0,2)-iClose(Symbol(),0,2)>MinBar*Dec*Point && iOpen(Symbol(),0,2)-iClose(Symbol(),0,2)<MaxBar*Dec*Point) 
{
 if (!IsOptimization())
 {
         ObjectCreate("DZ"+TimeCurrent(), OBJ_ARROW,0,0,0,0,0);
         ObjectSet   ("DZ"+TimeCurrent(), OBJPROP_COLOR, Red);
         ObjectSet   ("DZ"+TimeCurrent(), OBJPROP_ARROWCODE, 234);
         ObjectSet   ("DZ"+TimeCurrent(), OBJPROP_TIME1,TimeCurrent()-Period());
         ObjectSet   ("DZ"+TimeCurrent(), OBJPROP_PRICE1,iHigh(Symbol(),0,1)+Period()*Dec*Point/3);   
 }
 LastZeroSell=ZeroSell;
return(2);
}

return(0);

   }
   
double LastZero(int nMagic)
{
      int Last_Order_Number=HistoryTotal();
      double LastZero;
      if (OrderSelect(Last_Order_Number, SELECT_BY_TICKET, MODE_HISTORY) && OrderMagicNumber() == nMagic) 
      {
       if (OrderType()==OP_BUY) LastZero=StrToDouble(DoubleToStr(NormalizeDouble(OrderOpenPrice() ,digit),2));
       if (OrderType()==OP_SELL) LastZero=StrToDouble(DoubleToStr(NormalizeDouble(OrderOpenPrice()+10*Dec*Point ,2),digit-3));
      }
      return(LastZero);
}


//Money Management

double MoneyManagement ( bool flag, double risk)
{
   Lotsi=Lots;
	    
   if ( flag ) Lotsi=NormalizeDouble(AccountFreeMargin()*risk/1000,2);   
   if (Lotsi<MarketInfo(Symbol(), MODE_MINLOT)) Lotsi=MarketInfo(Symbol(), MODE_MINLOT);  
   return(Lotsi);
}   


void CloseByBar(int nMagic)
{
    total=OrdersTotal();
    int CloseBar;
    for (cnt=total-1;cnt>=0;cnt--)
    { 
       
    CloseBar=ExitBar;   
    
        if (OrderSelect(cnt, SELECT_BY_POS,MODE_TRADES) &&  OrderMagicNumber()==nMagic && (OrderType()==OP_BUY || OrderType()==OP_SELL) && (TimeCurrent()-OrderOpenTime())/Period()/60>=CloseBar)     
        {
        bool result = false;
 
 for (int try=1;try<=MaxTries;try++)
       {		 
          RefreshRates();
          if (OrderType()==OP_BUY) result = OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Bid ,digit),5*Dec,Yellow);
          if (OrderType()==OP_SELL) result = OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Ask ,digit),5*Dec,Yellow);
          if(result) break;            
          if(!result) Print("OrderSend failed with error #",GetLastError(), " Try ", try);                                      
          if (try==MaxTries) {Print("Warning!!!Last try failed!");}
          Sleep(5000);
        }
       }
      } 
     
  return;
  } 


void BuyMarketOrdOpen(int ColorOfBuy,int nMagic)
  {
  int try, res;

 //  if(Volume[0]>1) return;

          
  for (try=1;try<=MaxTries;try++)
       {
       while (!IsTradeAllowed()) Sleep(5000);
       RefreshRates();		  

      res=OrderSend(Symbol(),OP_BUY,Lotsi,NormalizeDouble(Ask ,digit),2*Dec,NormalizeDouble(Bid ,digit)-StopLoss,NormalizeDouble(Ask ,digit)+TakeProfit,name,nMagic,0,ColorOfBuy);
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

void SellMarketOrdOpen(int ColorOfSell,int nMagic)      
      { 
        int try, res;  

 //       if(Volume[0]>1) return;

  
 for (try=1;try<=MaxTries;try++)
       {
       while (!IsTradeAllowed()) Sleep(5000);
       RefreshRates();	
       
      res=OrderSend(Symbol(),OP_SELL,Lotsi,NormalizeDouble(Bid ,digit),2*Dec,NormalizeDouble(Ask ,digit)+StopLoss,NormalizeDouble(Bid ,digit)-TakeProfit,name,nMagic,0,ColorOfSell);
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
int ScanTradesOpen(int nMagic)
{   
   total = OrdersTotal();
   int numords = 0;
      
   for(cnt=0; cnt<total; cnt++) 
   {        
              
   if(OrderSelect(cnt, SELECT_BY_POS) && OrderSymbol() == Symbol() && (OrderType()==OP_BUY || OrderType()==OP_SELL)  && OrderMagicNumber() == nMagic) 
   numords++;
   }
   return(numords);
}

int ScanTradesBuyOpen(int nMagic)
{   
   total = OrdersTotal();
   int numords = 0;
      
   for(cnt=0; cnt<total; cnt++) 
   {        
             
   if(OrderSelect(cnt, SELECT_BY_POS) &&  OrderSymbol() == Symbol() && (OrderType()==OP_BUY)  && OrderMagicNumber() == nMagic) 
   numords++;
   }
   return(numords);
}

int ScanTradesSellOpen(int nMagic)
{   
   total = OrdersTotal();
   int numords = 0;
      
   for(cnt=0; cnt<total; cnt++) 
   {        
            
   if(OrderSelect(cnt, SELECT_BY_POS) && OrderSymbol() == Symbol() && (OrderType()==OP_SELL)  && OrderMagicNumber() == nMagic) 
   numords++;
   }
   return(numords);
}

void TrailStops(int nMagic)
{        
    total=OrdersTotal();
    int rs;
    for (cnt=0;cnt<total;cnt++)
    { 
       
         
        if (OrderSelect(cnt, SELECT_BY_POS) && OrderSymbol()==Symbol() && OrderMagicNumber()==nMagic ) 
        {
          mode=OrderType();
            if ( mode==OP_BUY )
            {
           if(OrderStopLoss()<OrderOpenPrice() && NormalizeDouble(Ask,digit)-OrderOpenPrice()>Point*TS*Dec)
               {
         if (OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Ask,digit)-TralStep*Dec*Point,OrderTakeProfit(),0,Green)) rs=1;
         return;
        } 
           if(OrderStopLoss()>OrderOpenPrice() && NormalizeDouble(Ask,digit)-OrderStopLoss()>Point*2*TralStep*Dec)
               {
         if (OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Ask,digit)-TralStep*Dec*Point,OrderTakeProfit(),0,Green)) rs=1;
         return;
        }        
            }
             
           if ( mode==OP_SELL)
            {
            if(OrderStopLoss()>OrderOpenPrice() && OrderOpenPrice()-NormalizeDouble(Bid,digit)>Point*TS*Dec)
            {
           if (OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Bid,digit)+TralStep*Dec*Point,OrderTakeProfit(),0,Green)) rs=1;
           return;
            }
            if(OrderStopLoss()<OrderOpenPrice() && OrderStopLoss()-NormalizeDouble(Bid,digit)>Point*2*TralStep*Dec)
            {
           if (OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Bid,digit)+TralStep*Dec*Point,OrderTakeProfit(),0,Green)) rs=1;
           return;
            }
        }    
        }
    }   
}


void AllBuyOrdDel(int nMagic)
{
    total=OrdersTotal();
    for (cnt=total-1;cnt>=0;cnt--)
    { 
       
      
        if ( OrderSelect(cnt, SELECT_BY_POS,MODE_TRADES) && OrderMagicNumber()==nMagic && OrderType()==OP_BUY)     
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

void AllSellOrdDel(int nMagic)
{
    total=OrdersTotal();
    for (cnt=total-1;cnt>=0;cnt--)
    { 
      
      
        if (OrderSelect(cnt, SELECT_BY_POS,MODE_TRADES) && OrderMagicNumber()==nMagic && OrderType()==OP_SELL)     
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



