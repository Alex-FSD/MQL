//+------------------------------------------------------------------+
//|                                                    Wednesday.mq4 |
//|                                     Copyright © 2010, NutCracher |
//|                                              forex-way@yandex.ru |
//|                                              http://wellforex.ru |
//-------------------------------------------------------------------+

#property copyright "Copyright © 2010, http://wellforex.ru"
#property link      "forex-way@yandex.ru"

extern int      Magic    = 777;                          
extern string   s1 = "--- MM ---";
extern bool     MM       = false;                   // Включение ММ
extern double   MMRisk   = 0.1;                     // Риск-фактор
extern double   Lots     = 0.1;                     // Фиксированный лот
extern string   s2 = "--- Stochastic ---";
extern int      K        = 20;                      //K - параметр стохастика
extern int      S        = 33;                      //S - параметр стохастика
extern double   L_open    = 21;                     //Уровень перекупленности/перепроданности (L_open / 100-L_open)
extern string   s3 = "--- DayWeek ---";
extern bool     Monday    = true;     
extern bool     Tuesday   = false; 
extern bool     Wednesday = true; 
extern bool     Thursday  = false; 
extern bool     Friday    = false; 
extern string   s4 = "---------";
extern double   Stop_Loss = 40;                    //Стоплосс
extern double   Take_Profit=100;                   //Тейкпрофит
extern double   EndTime   = 23;                    //Время закрытия ордеров


double SMain_current_M15; double SMain_past_M15;
double SS_current_M15, SS_past_M15, Axel;
double Trend_M15;
double TrailingStop; 
int MODE_AV, D=1;
int res, cnt; int Slippage=3; int MaxTries=5, mode=0, Dec, LotsDecimal, digit, MemBars;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   LotsDecimal=MathLog(1/MarketInfo(Symbol(),MODE_LOTSTEP))/MathLog(10);
   digit=MarketInfo(Symbol(),MODE_DIGITS);
   if(digit==5 || digit==3) Dec=10;
   if(digit==4 || digit==2) Dec=1;
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+  
int start()
  {

   if(Bars>MemBars) 
     {
      MemBars=Bars;
      if (MM) Lots = MoneyManagement (MM,MMRisk);
      
      // Check Trading Days
      
     if (DayOfWeek()==1 && !Monday) return(0);
     if (DayOfWeek()==2 && !Tuesday) return(0);
     if (DayOfWeek()==3 && !Wednesday) return(0);
     if (DayOfWeek()==4 && !Thursday) return(0);
     if (DayOfWeek()==5 && !Friday) return(0);
      
      if(CalculateCurrentOrders(Symbol())==0)
        {
         if (Hour()<EndTime) CheckForOpen();
        }
      else                                    
        if (Hour()>=EndTime) CloseOrds(); 

      }
      return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+  
double MoneyManagement ( bool flag, double risk)
{
   double Lotsi=Lots;
	    
   if ( flag ) Lotsi=NormalizeDouble(AccountFreeMargin()*risk/1000,LotsDecimal);   
   if (Lotsi<MarketInfo(Symbol(), MODE_MINLOT)) Lotsi=MarketInfo(Symbol(), MODE_MINLOT); 
   return(Lotsi);
}   

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CalculateCurrentOrders(string symbol)
  {
   int buys=0,sells=0;
//----
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
        {
         if(OrderType()==OP_BUY)  buys++;
         if(OrderType()==OP_SELL) sells++;
        }
     }
   if(buys>0) return(buys);
   else       return(-sells);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseOrds()
{
     bool result;
     int total=OrdersTotal();
     
     for (cnt=0;cnt<total;cnt++)
     { 
        if(OrderSelect(cnt, SELECT_BY_POS)) mode=OrderType();

    if (mode==OP_BUY ) 
     {
     for (int try=1;try<=MaxTries;try++)
       {
       while (!IsTradeAllowed()) Sleep(5000);
       RefreshRates();	
			     result=OrderClose(OrderTicket(),OrderLots(),Bid,Slippage*Dec,Yellow);
			     Sleep(2000);
			     if (result) break;
		  }
    }
   if (mode==OP_SELL)
     {
     for (int tryy=1;tryy<=MaxTries;tryy++)
       {
       while (!IsTradeAllowed()) Sleep(5000);
       RefreshRates();	
			     result=OrderClose(OrderTicket(),OrderLots(),Ask,Slippage*Dec,White);
			     Sleep(2000);
			     if (result) break;
		  }
      }
     }       
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckForOpen()
  {

      SMain_current_M15=iStochastic(Symbol(),PERIOD_M15,K,D,S,MODE_EMA,1,MODE_MAIN,1);
      SS_current_M15=iStochastic(Symbol(),PERIOD_M15,K,D,S,MODE_EMA,1,MODE_SIGNAL,1);      
      SMain_past_M15=iStochastic(Symbol(),PERIOD_M15,K,D,S,MODE_EMA,1,MODE_MAIN,2);  
               
      if (SMain_current_M15>L_open && SMain_past_M15<L_open)    
      {
     for (int try=1;try<=MaxTries;try++)
       {
       while (!IsTradeAllowed()) Sleep(500);
       RefreshRates();	
      res=OrderSend(Symbol(),OP_BUY,Lots,Ask,3*Dec,Bid-Stop_Loss*Dec*Point,Ask+Take_Profit*Dec*Point,"",Magic,0,Blue);
      Sleep(200);
      if(res>0)
           {
            if(OrderSelect(res,SELECT_BY_TICKET,MODE_TRADES)) Print("BUY по цене : ",OrderOpenPrice());
            break;
            }
         else 
         {
         Print("Error opening BUY order : ",GetLastError()); 
         }
      }
      }
       
      if (SMain_current_M15<100-L_open && SMain_past_M15>100-L_open)   
      {
    for (int tryy=1;tryy<=MaxTries;tryy++)
       {
       while (!IsTradeAllowed()) Sleep(500);
       RefreshRates();	      
      res=OrderSend(Symbol(),OP_SELL,Lots,Bid,3*Dec,Ask+Stop_Loss*Dec*Point,Bid-Take_Profit*Dec*Point,"",Magic,0,Red);
        Sleep(200);    
      if(res>0)
           {
            if(OrderSelect(res,SELECT_BY_TICKET,MODE_TRADES)) Print("SELL по цене : ",OrderOpenPrice());
             break;
            }
         else 
         {
         Print("Error opening BUY order : ",GetLastError()); 
        }
        }
       }
      return;
      }

//+------------------------------------------------------------------+