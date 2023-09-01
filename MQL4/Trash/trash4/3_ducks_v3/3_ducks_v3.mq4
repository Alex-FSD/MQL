//+------------------------------------------------------------------+
//|                                                      3 ducks.mq4 |
//|                                     Copyright � 2010, NutCracker |
//|                                              forex-way@yandex.ru |
//|                                              http://wellforex.ru |
//-------------------------------------------------------------------+


#property copyright "Copyright � 2010, http://wellforex.ru"
#property link      "forex-way@yandex.ru"
extern  int     Magic=10001;
extern int EMA1=60;                           //EMA1  period
extern int EMA2=60;                           //EMA2  period
extern int EMA3=60;                           //EMA3  period
extern bool     CloseByMA=true;                      // ��������� Trailing Stop ��/���
extern int      Take=50;                        //TakeProfit
extern int      Stop=100;                       //StopLoss
extern bool     Tral=false;                    //���� ������� ��/���                  
extern int      TS=30;                         //������� �����                          
extern int      TralStep=15;                   //��� ����� 
extern bool     UseSound       = True;          // ������������ �������� ������ ��/���
extern bool     MM=false;                       // ��������� �� ��/���
extern double   MMRisk=1;                      // Risk Factor
extern double   Lots = 0.1;                     // ���


int  MaxTries=5,Dec;
int  i, cnt=0, ticket, mode=0, digit=0, total, OrderToday=0;
double  StopLoss, TakeProfit, Lotsi=0, spread,LastOrderProfit=0,MinStop,LastLossLav;
int MagicBB1,LastVol,LossOrders=0, NX=0;
string  name="BarBreak";
string SoundSuccess   = "alert.wav";      // ���� ������
string SoundError     = "timeout.wav"; // ���� ������
double MA1, MA2, MA3, MA32;
datetime t1, t2, t3;
      
int init()
  {
Lotsi = Lots;

return(0);
  }


int start()
{
   MinStop=MarketInfo(Symbol(), MODE_STOPLEVEL);
   digit  = MarketInfo(Symbol(),MODE_DIGITS); 
   spread  = MarketInfo(Symbol(),MODE_SPREAD); 
   if (digit==5 || digit==3) Dec=10;
   if (digit==4 || digit==2) Dec=1; 
 //  Lotsi = Lots;
    

if(Volume[0]==1 || Volume[0]<LastVol)
{ 
//if (Hour()==0 && ScanTradesOpen(Magic)==0) {SumProfit=0; OrderToday=0;}
MA1=iMA(Symbol(),240,EMA1,0,MODE_EMA,PRICE_MEDIAN,1);
MA2=iMA(Symbol(),60,EMA2,0,MODE_EMA,PRICE_MEDIAN,1);
MA3=iMA(Symbol(),5,EMA3,0,MODE_EMA,PRICE_MEDIAN,1);
MA32=iMA(Symbol(),5,EMA3,0,MODE_EMA,PRICE_MEDIAN,2);

if (ScanTradesOpen(Magic)>0 && Tral) TrailStops(Magic); 
if (ScanTradesBuyOpen(Magic)>0 && iClose(Symbol(),60,1)<MA2 && CloseByMA) AllBuyOrdDel(Magic); 
if (ScanTradesSellOpen(Magic)>0 && iClose(Symbol(),60,1)>MA2 && CloseByMA) AllSellOrdDel(Magic); 

if (ScanTradesOpen(Magic)==0 && iClose(Symbol(),240,1)>MA1 && iClose(Symbol(),60,1)>MA2 && iClose(Symbol(),5,1)>MA3 && iOpen(Symbol(),5,1)<MA32)
{
TakeProfit=Take*Dec*Point;
StopLoss=Stop*Dec*Point;
if (MM) Lotsi = MoneyManagement (MM,MMRisk);
BuyMarketOrdOpen(Blue,Magic);
}

if (ScanTradesOpen(Magic)==0 && iClose(Symbol(),240,1)<MA1 && iClose(Symbol(),60,1)<MA2 && iClose(Symbol(),5,1)<MA3 && iOpen(Symbol(),5,1)>MA32)
{
TakeProfit=Take*Dec*Point;
StopLoss=Stop*Dec*Point;
if (MM) Lotsi = MoneyManagement (MM,MMRisk);
SellMarketOrdOpen(Red,Magic);
}

}


LastVol=Volume[0];  
}


//Money Management
double MoneyManagement ( bool flag, double risk)
{
   double Lotsi=Lots;
        
   if ( flag ) Lotsi=NormalizeDouble(AccountFreeMargin()*risk/10000,2);   
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
       
      res=OrderSend(Symbol(),OP_BUY,Lotsi,NormalizeDouble(Ask ,digit),2*Dec,NormalizeDouble(Bid ,digit)-StopLoss,NormalizeDouble(Ask ,digit)+TakeProfit,name,Magic,0,ColorOfBuy);
      Sleep(2000);
      if(res>0)
           {
            if (UseSound) PlaySound(SoundSuccess);
            OrderToday=OrderToday+1;
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
       
      res=OrderSend(Symbol(),OP_SELL,Lotsi,NormalizeDouble(Bid ,digit),2*Dec,NormalizeDouble(Ask ,digit)+StopLoss,NormalizeDouble(Bid ,digit)-TakeProfit,name,Magic,0,ColorOfSell);
      Sleep(2000);
      if(res>0)
           {
            if (UseSound) PlaySound(SoundSuccess);
            OrderToday=OrderToday+1;
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
   numords++;
   }
   }
   return(numords);
}
 



void TrailStops(int Magic)
{        
    int total=OrdersTotal();
    for (cnt=0;cnt<total;cnt++)
    { 
     OrderSelect(cnt, SELECT_BY_POS);   
     mode=OrderType();    
        if ( OrderSymbol()==Symbol() && OrderMagicNumber()==Magic ) 
        {
          
            if ( mode==OP_BUY )
            {
           if(OrderStopLoss()<OrderOpenPrice() && NormalizeDouble(Ask,digit)-OrderOpenPrice()>Point*TS*Dec)
               {
         OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Ask,digit)-TralStep*Dec*Point,OrderTakeProfit(),0,Green);
         return(0);
        } 
           if(OrderStopLoss()>OrderOpenPrice() && NormalizeDouble(Ask,digit)-OrderStopLoss()>Point*TralStep*Dec)
               {
         OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Ask,digit)-TralStep*Dec*Point,OrderTakeProfit(),0,Green);
         return(0);
        }        
            }
             
           if ( mode==OP_SELL)
            {
            if((OrderStopLoss()>OrderOpenPrice() || OrderStopLoss()==0) && OrderOpenPrice()-NormalizeDouble(Bid,digit)>Point*TS*Dec)
            {
           OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Bid,digit)+TralStep*Dec*Point,OrderTakeProfit(),0,Green);
           return(0);
            }
            if(OrderStopLoss()<OrderOpenPrice()  && OrderStopLoss()-NormalizeDouble(Bid,digit)>Point*TralStep*Dec)
            {
           OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Bid,digit)+TralStep*Dec*Point,OrderTakeProfit(),0,Green);
           return(0);
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
}