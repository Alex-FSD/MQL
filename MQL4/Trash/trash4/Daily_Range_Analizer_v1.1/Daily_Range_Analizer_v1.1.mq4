//+------------------------------------------------------------------+
//|                                             Daily Range Analizer |
//|                                              forex-way@yandex.ru |
//|                                              http://wellforex.ru |
//-------------------------------------------------------------------+

extern  int     Magic=10013;                  //Magic number
extern double   Lots = 0.1;                   //Fixed lot
extern string   MM_ind = "ММ % 1 = (0.1) per $1000, 0 - Off";
extern double   MM=0; 
extern string   Sets = "Main sets";
extern bool     OnePos=false;                 //Only one open pos 
extern double   MinBodyPercent=25;            //Min Body % of candle size (High-Low), 0-off     
extern int      MaxBodySize=40;               //Max candle body size 
extern int      MaxCandleSize=120;            //Max candle size   
extern int      StopShift=30;                 //Stop loss shift  
extern int      TP_CandlePercent=80;          //TP % of candle (high/low) use in case TP_Mode=2
extern string   TralSet = "Trailing stop";
extern bool     TrailingStopUSE=false;
extern int      TralStop=60;                  //Trailing stop 
extern int      TralStep=30;                  //Trailing step  

extern string   WLuseSet = "MovingInWLUSE";
extern bool     WLuseOn     = true;           //WLuse Switch
extern int      LevelWLoss=-15;               //WLUSE level (can be or 0 or + or -) (mode 3) 
extern int      LevelProfit =16;              //WLUSE start level (mode 3)  

extern bool     PartCloseCandle     = true;    //Part Close by Candle Switch  
extern int      PartCandle1=0;
extern int      PartCandle2=100;
extern int      PartCandle3=100;
extern int      Pips1=0;                 //Pips Open-Close Candle1
extern int      Pips2=0;                 //Pips Close1-Close2
extern int      Pips3=0;                 //Pips Close2-Close3
    
extern bool     DrawInfo=false;                

int  TralStartLevel=0, StepB, StepS, MemBars;                
bool  UseSound       = True;        // Использовать звуковой сигнал да/нет              
int  MaxTries=3, Dec, LastOrderType=0;
int   i, ticket, mode=0, digit=0, OrderToday=0;
double  SumProfit, Lotsi=0,spread,LC,DayRange, TakeProfit;
int LastVol;
string  name="DRA";
string SoundSuccess   = "news.wav";      // Звук успеха
string SoundError     = "timeout.wav";    // Звук ошибки

   
int init()
{
return(0);
}

void deinit() 
{

}

int start()
{
   digit  = MarketInfo(Symbol(),MODE_DIGITS); 

   if (digit==5 || digit==3) Dec=10;
   if (digit==4 || digit==2) Dec=1; 
   Lotsi=Lots;
   if (MM>0) 
   {
   Lotsi=NormalizeDouble(AccountBalance()*MM/10000,2);  
   if (Lotsi<MarketInfo(Symbol(), MODE_MINLOT)) Lotsi=MarketInfo(Symbol(), MODE_MINLOT);
   }
   spread= MarketInfo(Symbol(),MODE_SPREAD);

TakeProfit=NormalizeDouble((iHigh(Symbol(),PERIOD_D1,1)-iLow(Symbol(),PERIOD_D1,1))/Point/Dec*TP_CandlePercent/100,0);


if (DrawInfo) 
{
Comment(" ",   
        "   \n------------------------------------------------------------------",
        "   \nAccountNumber : ",DoubleToStr(AccountNumber(),0), 
        "   \n",TerminalCompany(), 
        "   \nCurrent Server Time : " + TimeToStr(TimeCurrent(), TIME_DATE|TIME_SECONDS),
        "   \n------------------------------------------------------------------",               
        "   \nLot = ", DoubleToStr(Lotsi,2),       
        "   \nLastDayBobySize = ",(iClose(Symbol(),PERIOD_D1,1)-iOpen(Symbol(),PERIOD_D1,1))/Point/Dec,
        "   \nMaxBodySize = ",MaxBodySize,
        "   \nLastDayCandleSize = ",(iHigh(Symbol(),PERIOD_D1,1)-iLow(Symbol(),PERIOD_D1,1))/Point/Dec,
        "   \nMaxCandleSize = ",MaxCandleSize,  
        "   \nLastDayBodyPercent = ",NormalizeDouble(MathAbs(iClose(Symbol(),PERIOD_D1,1)-iOpen(Symbol(),PERIOD_D1,1))/(iHigh(Symbol(),PERIOD_D1,1)-iLow(Symbol(),PERIOD_D1,1))*100,2),
        "   \nMinBodyPercent = ",MinBodyPercent, 
        "   \nCurrent spread = ",spread,
        "   \nAccount Min Lot = ",DoubleToStr(MarketInfo(Symbol(),MODE_MINLOT), 2),
        "   \n------------------------------------------------------------------"); 
}

if ((ScanTradesOpenBuy(Magic)>0 || ScanTradesOpenSell(Magic)>0) && TrailingStopUSE) TrailStops1(Magic);        

// BU
if ((ScanTradesOpenBuy(Magic)>0 || ScanTradesOpenSell(Magic)>0) && WLuseOn) BU(Magic); 

if (ScanTradesOpen(Magic)>0 && PartCloseCandle) PartCloseCandle(Magic);

DayRange=NormalizeDouble(iClose(Symbol(),PERIOD_D1,1)-iOpen(Symbol(),PERIOD_D1,1),Digits);

if (DayRange!=GlobalVariableGet("DR") && Hour()==0)
{
Sleep(5000);
RefreshRates();
GlobalVariableSet("DR",DayRange);

if (Month()==12 && Day()>=24) return(0);
if (Month()==1 && Day()<=3) return(0);

if (MinBodyPercent>0 && MathAbs(iClose(Symbol(),PERIOD_D1,1)-iOpen(Symbol(),PERIOD_D1,1))/(iHigh(Symbol(),PERIOD_D1,1)-iLow(Symbol(),PERIOD_D1,1))*100<MinBodyPercent) return(0);
if (MathAbs(iClose(Symbol(),PERIOD_D1,1)-iOpen(Symbol(),PERIOD_D1,1))/Point/Dec>MaxBodySize) return(0);
if ((iHigh(Symbol(),PERIOD_D1,1)-iLow(Symbol(),PERIOD_D1,1))/Point/Dec>MaxCandleSize) return(0);

if((ScanTradesOpen(Magic)==0 || !OnePos) && (iClose(Symbol(),PERIOD_D1,1)-iOpen(Symbol(),PERIOD_D1,1))/Point/Dec>0) SellOpen(Red,Magic);
if((ScanTradesOpen(Magic)==0 || !OnePos) && (iClose(Symbol(),PERIOD_D1,1)-iOpen(Symbol(),PERIOD_D1,1))/Point/Dec<0) BuyOpen(Blue,Magic);


}

return(0);
}

void BuyOpen(int ColorOfBuy,int nMagic)
  {
  int try, res;
  int try2, iii=1;
  bool result=false;
  double SSL=0, TTP=0;

  StepB=0;
  SSL=NormalizeDouble(iLow(Symbol(),PERIOD_D1,1),digit)-StopShift*Dec*Point;

  if (SSL>=Bid-5*Dec*Point) SSL=NormalizeDouble(Bid,digit)-(StopShift+5)*Dec*Point;  
  if (TakeProfit>0) TTP=NormalizeDouble(Ask ,digit)+TakeProfit*Dec*Point;  
          
  for (try=1;try<=MaxTries;try++)
       {
       while (!IsTradeAllowed()) Sleep(5000);
       RefreshRates();		  
      res=OrderSend(Symbol(),OP_BUY,Lotsi,NormalizeDouble(Ask ,digit),2*Dec,0,0,name,nMagic,0,ColorOfBuy);
      Sleep(2000);
      if(res>0)
           {
            if(OrderSelect(res,SELECT_BY_TICKET,MODE_TRADES)) 
            {
       for (try2=1;try2<=MaxTries;try2++)
       {		 
          while (!IsTradeAllowed()) Sleep(2000);
          RefreshRates();
          //if (TakeProfit==0) break;
          result = OrderModify(OrderTicket(),OrderOpenPrice(),SSL,TTP,0,Yellow);
          if(result) break;
          if(!result) Print("OrderModify Buy failed with error #",GetLastError());                           
          Sleep(5000);
        }
         PlaySound("news.wav");            
         break;   
            }
            }
         else 
         {
         Print("Error opening BUY order : ",GetLastError()); PlaySound("timeout.wav"); Sleep(5000);
         }     
       }
      return;
      }

void SellOpen(int ColorOfSell,int nMagic)      
      { 
  int try, res, iii=1;
  int try2;
  bool result=false;  
  double SSL=0, TTP=0; 
    
  StepS=0;  
  SSL=NormalizeDouble(iHigh(Symbol(),PERIOD_D1,1),digit)+StopShift*Dec*Point; 
  if (SSL<=Ask+5*Dec*Point) SSL=NormalizeDouble(Ask,digit)+(StopShift+5)*Dec*Point;   
  if (TakeProfit>0) TTP=NormalizeDouble(Bid ,digit)-TakeProfit*Dec*Point;   
  
  for (try=1;try<=MaxTries;try++)
       {
       while (!IsTradeAllowed()) Sleep(5000);
       RefreshRates();		  
      res=OrderSend(Symbol(),OP_SELL,Lotsi,NormalizeDouble(Bid ,digit),2*Dec,0,0,name,nMagic,0,ColorOfSell);
      Sleep(2000);
      if(res>0)
           {
            if(OrderSelect(res,SELECT_BY_TICKET,MODE_TRADES)) 
            {
       for (try2=1;try2<=MaxTries;try2++)
       {		 
          while (!IsTradeAllowed()) Sleep(2000);
          RefreshRates();
          //if (TakeProfit==0) break;
          result = OrderModify(OrderTicket(),OrderOpenPrice(),SSL,TTP,0,Yellow);
          if(result) break;
          if(!result) Print("OrderModify Sell failed with error #",GetLastError());                           
          Sleep(5000);
        } 
         PlaySound("news.wav");          
         break;   
            }
            }
         else 
         {
         Print("Error opening SELL order : ",GetLastError()); PlaySound("timeout.wav"); Sleep(5000);
         }     
       }
      return;
      }
  

// ---- Scan Trades opened
int ScanTradesOpen(int nMagic)

    
{   
   int total=OrdersTotal();
   int numords = 0;
      
   for(int cnt=0; cnt<total; cnt++) 
   {        
   OrderSelect(cnt, SELECT_BY_POS);            
   if(OrderSymbol() == Symbol() && (OrderType()==OP_BUY || OrderType()==OP_SELL)  && OrderMagicNumber() == nMagic) 
   {

   if (OrderType()==OP_BUY) LastOrderType=1;
   if (OrderType()==OP_SELL) LastOrderType=2;
   numords++;
   }
   }
   return(numords);
}
 
int ScanTradesOpenBuy(int nMagic)
{   
   int total=OrdersTotal();
   int numords = 0;
      
   for(int cnt=0; cnt<total; cnt++) 
   {        
   OrderSelect(cnt, SELECT_BY_POS);            
   if(OrderSymbol() == Symbol() && OrderType()==OP_BUY && OrderMagicNumber() == nMagic) 
   {
   numords++;
   }
   }
   return(numords);
}

int ScanTradesOpenSell(int nMagic)
{   
   int total=OrdersTotal();
   int numords = 0;
      
   for(int cnt=0; cnt<total; cnt++) 
   {        
   OrderSelect(cnt, SELECT_BY_POS);            
   if(OrderSymbol() == Symbol() && OrderType()==OP_SELL && OrderMagicNumber() == nMagic) 
   {
   numords++;
   }
   }
   return(numords);
}
 

void TrailStops1(int nMagic)
{        
int total=OrdersTotal();
    for (int cnt=0;cnt<total;cnt++)
    { 
     OrderSelect(cnt, SELECT_BY_POS);   
     mode=OrderType();    
        if ( OrderSymbol()==Symbol() && OrderMagicNumber()==nMagic ) 
        {
          
         if ( mode==OP_BUY )
         {
         if(NormalizeDouble(Ask-OrderOpenPrice(),Digits)>Point*TralStartLevel*Dec && NormalizeDouble(Ask-OrderStopLoss(),Digits)>Point*(TralStop+TralStep)*Dec)
         {
         OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Ask-TralStop*Dec*Point,Digits),OrderTakeProfit(),0,Green);        
         }        
         }
             
         if ( mode==OP_SELL)
         {
         if(NormalizeDouble(OrderOpenPrice()-Bid,Digits)>Point*TralStartLevel*Dec && (NormalizeDouble(OrderStopLoss()-Bid,Digits)>Point*(TralStop+TralStep)*Dec || OrderStopLoss()==0))
         {
         OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Bid+TralStop*Dec*Point,Digits),OrderTakeProfit(),0,Green);           
         }
        }    
        }
    }   
}





void BU(int nMagic)
{        
    int total=OrdersTotal();
    for (int cnt=0;cnt<total;cnt++)
    { 
     OrderSelect(cnt, SELECT_BY_POS);   
     mode=OrderType();    
        if ( OrderSymbol()==Symbol() && OrderMagicNumber()==nMagic ) 
        {
          
            if ( mode==OP_BUY )
            {
            if(NormalizeDouble(Ask-OrderOpenPrice(),Digits)>Point*LevelProfit*Dec && NormalizeDouble(OrderStopLoss(),Digits)<NormalizeDouble(OrderOpenPrice()+LevelWLoss*Dec*Point,Digits))
               {
         OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()+LevelWLoss*Dec*Point,Digits),OrderTakeProfit(),0,Green);
         
        }        
            }
             
           if ( mode==OP_SELL)
            {
            if(NormalizeDouble(OrderOpenPrice()-Bid,Digits)>Point*LevelProfit*Dec && NormalizeDouble(OrderStopLoss(),Digits)>NormalizeDouble(OrderOpenPrice()-LevelWLoss*Dec*Point,Digits))
            {
           OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()-LevelWLoss*Dec*Point,Digits),OrderTakeProfit(),0,Green);
           
            }
        }    
        }
    }   
}


  
void PartCloseCandle(int nMagic)
{
    int total=OrdersTotal();
    int try;
    double CloseLot, PercentForClose,OrdPrice,OrdLot;
    string OrdComm;
    datetime OrdTime;
    bool result = false;

    for (int cnt=total-1;cnt>=0;cnt--)
    { 
      OrderSelect(cnt, SELECT_BY_POS,MODE_TRADES);     
      OrdPrice=OrderOpenPrice();
      OrdLot=OrderLots();
      OrdComm=OrderComment();
      OrdTime=OrderOpenTime();
      if (OrderMagicNumber()==nMagic && OrderType()==OP_BUY)   
      {
  
 PercentForClose=0;
 //Print("HC= ",iClose(Symbol(),PERIOD_D1,iLowest(Symbol(),PERIOD_D1,MODE_CLOSE,iBarShift(Symbol(),PERIOD_D1,OrdTime),2)));
 if (iClose(Symbol(),PERIOD_D1,1)>OrdPrice+Pips1*Dec*Point && iBarShift(Symbol(),PERIOD_D1,OrdTime)==1)  PercentForClose=PartCandle1;
 if (iClose(Symbol(),PERIOD_D1,1)>OrdPrice && iClose(Symbol(),PERIOD_D1,1)>iClose(Symbol(),PERIOD_D1,2)+Pips2*Dec*Point && iBarShift(Symbol(),PERIOD_D1,OrdTime)==2)  PercentForClose=PartCandle2;
 if (iClose(Symbol(),PERIOD_D1,1)>OrdPrice && iClose(Symbol(),PERIOD_D1,1)>iClose(Symbol(),PERIOD_D1,iHighest(Symbol(),PERIOD_D1,MODE_CLOSE,iBarShift(Symbol(),PERIOD_D1,OrdTime),2))+Pips3*Dec*Point && iBarShift(Symbol(),PERIOD_D1,OrdTime)>2)  PercentForClose=PartCandle3;

 if (PercentForClose>0)
 {
 for (try=1;try<=MaxTries;try++)
       {		 
       while (!IsTradeAllowed()) Sleep(5000);
          RefreshRates();
          CloseLot=NormalizeDouble(OrderLots()*PercentForClose/100 ,2);
          if (CloseLot<MarketInfo(Symbol(), MODE_MINLOT)) CloseLot=OrderLots();
          result = OrderClose(OrderTicket(),CloseLot,NormalizeDouble(Bid ,digit),5*Dec,Yellow);
          if(result) break;            
          if(!result) Print("OrderClose failed with error #",GetLastError(), " Try ", try);                                      
          if (try==MaxTries) {Print("Warning!!!Last try failed!");}
          Sleep(5000);
        }
       }
       }
        if (OrderMagicNumber()==Magic && OrderType()==OP_SELL)     
        {

 PercentForClose=0;
 //Print("LC= ",iClose(Symbol(),PERIOD_D1,iLowest(Symbol(),PERIOD_D1,MODE_CLOSE,iBarShift(Symbol(),PERIOD_D1,OrdTime),2)));
 if (iClose(Symbol(),PERIOD_D1,1)<OrdPrice-Pips1*Dec*Point && iBarShift(Symbol(),PERIOD_D1,OrdTime)==1)  PercentForClose=PartCandle1;
 if (iClose(Symbol(),PERIOD_D1,1)<OrdPrice && iClose(Symbol(),PERIOD_D1,1)<iClose(Symbol(),PERIOD_D1,2)-Pips2*Dec*Point && iBarShift(Symbol(),PERIOD_D1,OrdTime)==2)  PercentForClose=PartCandle2;
 if (iClose(Symbol(),PERIOD_D1,1)<OrdPrice && iClose(Symbol(),PERIOD_D1,1)<iClose(Symbol(),PERIOD_D1,iLowest(Symbol(),PERIOD_D1,MODE_CLOSE,iBarShift(Symbol(),PERIOD_D1,OrdTime),2))-Pips3*Dec*Point && iBarShift(Symbol(),PERIOD_D1,OrdTime)>2)  PercentForClose=PartCandle3;


 if (PercentForClose>0)
 { 
 for (try=1;try<=MaxTries;try++)
       {		 
          RefreshRates();
          while (!IsTradeAllowed()) Sleep(5000); 
          CloseLot=NormalizeDouble(OrderLots()*PercentForClose/100 ,2);
          if (CloseLot<MarketInfo(Symbol(), MODE_MINLOT)) CloseLot=OrderLots();
          result = OrderClose(OrderTicket(),CloseLot,NormalizeDouble(Ask ,digit),5*Dec,Yellow);
          if(result) break;            
          if(!result) Print("OrderClose failed with error #",GetLastError(), " Try ", try);                                      
          if (try==MaxTries) {Print("Warning!!!Last try failed!");}
          Sleep(5000);
        }
       }
       }
      } 
     
  return;
  }
 
//Информация о последнем закрытом ордере
double LastClose(int nMagic, double Pr, int Tp)
{
      int cnt=OrdersHistoryTotal(); 
      double LastClose=0;

      while(cnt>0)
      {
      if (OrderSelect(cnt-1, SELECT_BY_POS, MODE_HISTORY && OrderMagicNumber() == nMagic) && OrderSymbol()==Symbol() && (OrderType()==OP_BUY || OrderType()==OP_SELL)) 
      { 
      if (NormalizeDouble(Pr,Digits)==NormalizeDouble(OrderOpenPrice(),Digits) && Tp==OrderType()) {LastClose=NormalizeDouble(OrderClosePrice(),Digits); return(LastClose);}
      }
      cnt=cnt-1; 
      }  
      return(LastClose);
} 

void Item(string nname, string txt)
{

   ObjectCreate(nname, OBJ_LABEL, 0, TimeCurrent(), Ask-20*Dec*Point);
   ObjectSetText(nname, txt, 10, "Verdana", DodgerBlue);


}