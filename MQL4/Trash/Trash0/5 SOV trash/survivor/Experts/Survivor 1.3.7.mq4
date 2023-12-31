
#property copyright "Survivor"
#property link      "tradelikeapro.ru"
//#property version   "14.00" 
#property strict


extern string     t="----------- ТАЙМЕР -----------";
extern int        Start_Monday_Minuts = 5;// пауза в торговле на открытии понедельника. 0-выкл
extern string     Stop_Time_Friday    ="20:00"; // время остановки торговли в пятницу (hh:mm) ""-выкл
extern string     Close_Time_Friday   ="22:30"; // время закрытия ордеров в пятницу (hh:mm) ""-выкл

input string      _inp1_ = "Для первого входа параметры";
input string      _BB1_ = "Bollinger Bands";
input int         periodBB1 = 10;
input int         deviationBB1 = 2;
input int         bands_shiftBB1 = 0;
extern int        priceBBUP1  = PRICE_CLOSE;
extern int        priceBBDN1  = PRICE_CLOSE;
input int         CheckBarsBB1 = 10;

input string      _RSI1_ = "RSI";
input int         periodRSI1 = 5;
extern int        priceRSI1  = PRICE_CLOSE;
input int         levelRSIsell1 = 70;
input int         levelRSIbuy1 = 30;

input string      _ADX1_ = "ADX";
input int         periodADX1 = 7;
extern int        priceADX1  = PRICE_CLOSE;
input int         levelADX1 = 20;

input string      _DM1_ = "DeMarker";
input int         periodDM1 = 5;
input double      levelDMsell1 = 0.7;
input double      levelDMbuy1 = 0.3;

input string      _MA1_ = "MA";
input bool        UseMA1 = true;
input int         MA_Period1 = 105;
extern int        Ma_shift1  =  0; // сдвиг ма
extern int        Ma_type1  =  0; // тип ма
extern int        Ma_price1 =  PRICE_CLOSE; // вид цены ма (7 видов)
extern int        Slippage_MA1 = 25;

input string      _inp2_ = "Для последующих входов параметры";
input string      _BB2_ = "Bollinger Bands";
input int         periodBB2 = 10;
input int         deviationBB2 = 2;
input int         bands_shiftBB2 = 0;
extern int        priceBBUP2  = PRICE_CLOSE;
extern int        priceBBDN2  = PRICE_CLOSE;
input int         CheckBarsBB2 = 10;

input string      _RSI2_ = "RSI";
input int         periodRSI2 = 5;
extern int        priceRSI2  = PRICE_CLOSE;
input int         levelRSIsell2 = 70;
input int         levelRSIbuy2 = 30;

input string      _ADX2_ = "ADX";
input int         periodADX2 = 7;
extern int        priceADX2  = PRICE_CLOSE;
input int         levelADX2 = 20;

input string      _DM2_ = "DeMarker";
input int         periodDM2 = 5;
input double      levelDMsell2 = 0.7;
input double      levelDMbuy2 = 0.3;

input string      _MA2_ = "MA";
input bool        UseMA2 = true;
input int         MA_Period2 = 105;
extern int        Ma_shift2         =  0; // сдвиг ма
extern int        Ma_type2          =  0; // тип ма
extern int        Ma_price2         =  PRICE_CLOSE; // вид цены ма (7 видов)
extern int        Slippage_MA2 = 25;

input string      _inp3_ = "Для реверса параметры";
input string      _BB3_ = "Bollinger Bands";
input int         periodBB3 = 10;
input int         deviationBB3 = 2;
input int         bands_shiftBB3 = 0;
extern int        priceBBUP3  = PRICE_CLOSE;
extern int        priceBBDN3  = PRICE_CLOSE;
input int         CheckBarsBB3 = 10;

input string      _RSI3_ = "RSI";
input int         periodRSI3 = 5;
extern int        priceRSI3  = PRICE_CLOSE;
input int         levelRSIsell3 = 70;
input int         levelRSIbuy3 = 30;

input string      _ADX3_ = "ADX";
input int         periodADX3 = 7;
extern int        priceADX3  = PRICE_CLOSE;
input int         levelADX3 = 20;

input string      _DM3_ = "DeMarker";
input int         periodDM3 = 5;
input double      levelDMsell3 = 0.7;
input double      levelDMbuy3 = 0.3;

input string      par="----- ПАРАМЕТРЫ СОВЕТНИКА -------";
input double      Lots             =    0.01; 
input double      Risk             =       0; 
input int         MaxSpread        =       0;
input bool        Close_Revers     =    true; 
// закрывать все по обратному сигналу
extern int        Step_Input       =      10; 
// отступать на лучшую цену при повторном входе 0-выкл.  

extern string     S_11         = "<== TP/SL Settings ==>";             // >     >     >
extern double     Sl               =      50; 
extern double     Tp               =      50; 
extern int        TP_SL_ATR_Period     = 300;         //TP/SL ATR Period
extern double     TP_ATR_Multiplier      = 0;         //Dynamic TP: ATR Multiplier
extern double     SL_ATR_Multiplier      = 0;         //Dynamic SL: ATR Multiplier

input string      MM_type ="---- ВЫБОР СПОСОБА ММ 0-выкл, 1 - по сделке, 2 - по серии -------";
input int         Martin_Type      =       0; 
//0- выкл. 1- наращивать лот по убытку в сделке, 2 - по убытку в серии
input double       Lots_exp        =       2; 
// множитель ордеров серии
input int         MaxOrders        =       5; 
// максимальное число открытых ордеров
input int         MAGIC            =     101;
input string      OrdersComment    =     "Survivor 1.3.7";

//--------------------------------------------------------------------
datetime prevtime, open_timeseria;
int ticket;
double lots,profit,MinPriceBuy,MaxPriceSell, minstop;
int mp = 1,orders_buy,orders_sell,pending;string prevbuy,prevsell;
double HistProfitSeria,LastCloseLots,LastCloseProfit; bool trade;
double TakeProfit;
double StopLoss;
double ATR;
//--------------------------------------------------------------------

//+----------------------------------------------------------------------------+
//|  expert initialization function                                            |
//+----------------------------------------------------------------------------+
int OnInit() {
   TakeProfit = Tp; StopLoss = Sl;
   
   if(Digits==3 || Digits==5) mp=10;
   StopLoss*=mp; TakeProfit*=mp;Step_Input*=mp;
   Slippage_MA1*=mp;
   Slippage_MA2*=mp;
   prevtime=Time[0];
   
   //Print(TakeProfit + "/"+ StopLoss);
   return(INIT_SUCCEEDED);
}
//------------
void OnDeinit(const int reason) {
   Comment(""); 
}
//------------------------------------------------------------------------------

//+----------------------------------------------------------------------------+
//|  expert start function                                                     |
//+----------------------------------------------------------------------------+
void OnTick() {
   int Status, signal, signalrevers, ma, spr,stoptrade=0;
   spr = 1;

   //--- close bar
//   if(Close_Bars_Exit)OrdersCloseTime();
   
   RefreshRates();Comment("");
   if(Start_Monday_Minuts>0)
   if(DayOfWeek()==1 && TimeCurrent()-iTime(NULL,1440,0)<Start_Monday_Minuts*60)
     {Comment("\n ПАУЗА В ТОРГОВЛЕ ",Start_Monday_Minuts,"  минут ");return;}
   
   if(DayOfWeek()==5)
     {
      Status=OrdersScaner(); 
      if(Stop_Time_Friday!="")if(TimeCurrent()>=StrToTime(Stop_Time_Friday))
        {stoptrade=1; if(Status==0){Comment("\n ТОРГОВЛЯ ЗАВЕРШЕНА "); Sleep(3000);return;}}
      if(Close_Time_Friday!="" && Status>0 && TimeCurrent()>=StrToTime(Close_Time_Friday)){CloseAll();return;}
      }
   
   if(OrdersTotal() > 0) OrdersScaner();
   //------- new-bar
   if(prevtime==Time[0])return; prevtime=Time[0];
   
   if(MaxSpread > 0) {
      if(!CheckMaxSpread()) {spr = 0;Print("Спред превышен. Ждем его нормализации");if(IsTesting())return;}
      while(!CheckMaxSpread()) {Sleep(500);}
      if(spr == 0) {Print("Спред нормализовался. Работаем.");spr = 1;}
   }
   
   Status=OrdersScaner();
   signal=0;
    //--- close signal
   if(Close_Revers && Status>0)
    {
     signalrevers=Signal(1, periodBB3, deviationBB3, bands_shiftBB3,priceBBUP3,priceBBDN3, CheckBarsBB3, 
              periodRSI3, priceRSI3, levelRSIsell3, levelRSIbuy3, periodADX3,priceADX3,levelADX3, periodDM3, 
              levelDMsell3, levelDMbuy3);
      if(orders_buy >0 && signalrevers==-1){if(CloseAll()==1)Status=OrdersScaner();}//signal=signalrevers;
      if(orders_sell>0 && signalrevers== 1){if(CloseAll()==1)Status=OrdersScaner();}//signal=signalrevers;
    }
   
   if(stoptrade==1)return;
   
   if(Status==0)
   {// == 0
   signal=Signal(1, periodBB1, deviationBB1, bands_shiftBB1,priceBBUP1,priceBBDN1, CheckBarsBB1, 
              periodRSI1,priceRSI1,levelRSIsell1, levelRSIbuy1, periodADX1,priceADX1,levelADX1, periodDM1, 
              levelDMsell1, levelDMbuy1);
   if(UseMA1)
    {
     ma = FilterMA(MA_Period1,Ma_shift1,Ma_type1,Ma_price1,Slippage_MA1);
     if(signal>0 && ma<1 ) signal = 0;
     if(signal<0 && ma>-1) signal = 0;
    }
   }// == 0
   if(Status>0)
   {// > 0
   signal=Signal(1, periodBB2, deviationBB2, bands_shiftBB2,priceBBUP2,priceBBDN2, CheckBarsBB2, 
              periodRSI2,priceRSI2,levelRSIsell2, levelRSIbuy2, periodADX2,priceADX2,levelADX2, periodDM2, 
              levelDMsell2, levelDMbuy2);
   if(UseMA2)
    {
     ma = FilterMA(MA_Period2,Ma_shift2,Ma_type2,Ma_price2,Slippage_MA2);
     if(signal>0 && ma<1 ) signal = 0;
     if(signal<0 && ma>-1) signal = 0;
    }
   }// > 0
  
   if(TP_ATR_Multiplier > 0 || SL_ATR_Multiplier > 0) {
      ATR = NormalizeDouble(iATR(NULL,PERIOD_CURRENT,TP_SL_ATR_Period,1),Digits);
      if(TP_ATR_Multiplier > 0) TakeProfit =  MathMax(ATR*TP_ATR_Multiplier/Point,MarketInfo(Symbol(), MODE_STOPLEVEL));
      if(SL_ATR_Multiplier > 0) StopLoss = MathMax(ATR*SL_ATR_Multiplier/Point,MarketInfo(Symbol(), MODE_STOPLEVEL));
   }
   
   //--- input
   if(signal== 1 && Status<MaxOrders){
       //-----------------------------------------------------------------
       if(Martin_Type==0) lots=AutoMM_Count();   
         else
         {
         SeriaHistory(open_timeseria);
         if(Martin_Type==2){
           if( HistProfitSeria<0){
            if(LastCloseProfit<0)lots=LastCloseLots*Lots_exp;
             else lots=LastCloseLots;
            }
            else {lots=AutoMM_Count(); open_timeseria=TimeCurrent();}
           }
         if(Martin_Type==1){
           if(LastCloseProfit<0)lots=LastCloseLots*Lots_exp;
             else {lots=AutoMM_Count(); open_timeseria=TimeCurrent();}
           }
         }
     trade=1;
     if(orders_buy > 0 && Step_Input > 0) if(Close[1]> MinPriceBuy-Step_Input*Point)trade=0; //if(MinPriceBuy-Step_Input*Point < Ask) trade=0;
     if(orders_sell > 0) trade = 0;
     if(trade)
      if(OpenBuyMarket(MAGIC,lots,OrdersComment+"|BUY_"+IntegerToString(orders_buy+1),Blue)>0) return;
      else {prevtime=Time[1];Print("Error BUY = ",GetLastError());return;} 
     } 
   if(signal==-1 && Status<MaxOrders ){   
      if(Martin_Type==0)lots=AutoMM_Count();   
         else
         {
         SeriaHistory(open_timeseria);
         if(Martin_Type==2){
           if( HistProfitSeria<0){
            if(LastCloseProfit<0)lots=LastCloseLots*Lots_exp;
             else lots=LastCloseLots;
            }
            else {lots=AutoMM_Count(); open_timeseria=TimeCurrent();}
           }
         if(Martin_Type==1){
           if(LastCloseProfit<0)lots=LastCloseLots*Lots_exp;
             else {lots=AutoMM_Count(); open_timeseria=TimeCurrent();}
           }
         }
     trade=1;
     if(orders_sell>0 && Step_Input > 0) if(Close[1]< MaxPriceSell+Step_Input*Point)trade=0; //if(MaxPriceSell+Step_Input*Point > Bid)trade=0;
     if(orders_buy>0)trade=0;
     if(trade)
      if(OpenSellMarket(MAGIC,lots,OrdersComment+"SELL_"+IntegerToString(orders_sell+1),Red)>0) return;
      else {prevtime=Time[1];Print("Error SELL = ",GetLastError());return;}    
    }
//---   
  return;
}

//-------------------------------------------------------------------
void Set_gld(string name,double x)
  {
   if(!GlobalVariableCheck(name))GlobalVariableSet(name,x);
   if((GlobalVariableGet(name)-x)!=0)GlobalVariableSet(name,x);
  }
//-------------------------------------------------------------------
double Gld(string name){return(GlobalVariableGet(name));}
//--------------------------------------------------------------------
//+------------------------------------------------------------------+
double AutoMM_Count() { //Расчет лота при указании процента риска в настройках.
   
   if(Risk == 0) return(Lots);
   
   double lot = Lots;
   double TickValue = 0;
   int a = 0;
   do {
      TickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
      a++;
      if (TickValue == 0) Sleep(500);
      } while (TickValue == 0 && a < 10);
   if (TickValue == 0) { Print("TickValue Error"); lot = MarketInfo(Symbol(), MODE_MINLOT); return(lot); }  
   
   lot = ((AccountBalance() - AccountCredit()) * (Risk / 100)) / StopLoss / TickValue;
   lot = MathFloor(lot/MarketInfo(Symbol(), MODE_LOTSTEP))* MarketInfo(Symbol(), MODE_LOTSTEP); //округление полученного лота вниз
   lot = MathMin(MathMax(lot, MarketInfo(Symbol(), MODE_MINLOT)), MarketInfo(Symbol(), MODE_MAXLOT)); //сравнение полученнго лота с минимальным/максимальным.
   
   return (lot);
}

//----------------------------------------------------------------------------------
double SeriaHistory(datetime OpenTimeSeria){
 datetime time=0;  int orders_seria=0;  HistProfitSeria=0; 
 LastCloseLots=0; LastCloseProfit=0;
 if(OpenTimeSeria==0)return(0);// no seria
   else{
    for ( int i=OrdersHistoryTotal();i>=1;i--){
         if(OrderSelect(i-1, SELECT_BY_POS, MODE_HISTORY))
         if(OrderSymbol ()!= Symbol())continue;
         if(OrderMagicNumber()!= MAGIC )continue;
         if(OrderCloseTime()<=OpenTimeSeria)continue;
         if(OrderType() <=1){
          orders_seria++;
          HistProfitSeria+=OrderProfit()+OrderSwap();
          if(OrderCloseTime()>time)
            {
             time = OrderCloseTime();
             LastCloseLots= OrderLots(); 
             LastCloseProfit=OrderProfit()-OrderSwap();
            }
          }
       }
     }
  //Print(" Последний профит ",LastCloseProfit); 
  return(HistProfitSeria);
}
//-----------------------------------------------------------------------

   
//------------------------------------------------------------------------------
int Signal(int i, int periodBB, int deviationBB, int bands_shiftBB,int UPBBprice,int DNBBprice, int CheckBarsBB, 
           int periodRSI, int priceRSI,int levelRSIsell, int levelRSIbuy, int periodADX, int priceADX,int levelADX, int periodDM, 
           double levelDMsell, double levelDMbuy){
 double adxsell,adxbuy,dm,rsi;
 int BB = GetBB(i, periodBB, deviationBB, bands_shiftBB, UPBBprice,DNBBprice,CheckBarsBB);
 
     HideTestIndicators(0);
     if(BB == 0) return(0);
     if(BB == -1)
      {
       rsi = iRSI(NULL,0,periodRSI,priceRSI,i);
       if(rsi>=levelRSIsell){
        dm = iDeMarker(NULL,0,periodDM,i);
        if(dm>=levelDMsell){
         adxsell = iADX(NULL,0,periodADX,priceADX,MODE_PLUSDI,i);
          //HideTestIndicators(0);
         if(adxsell>=levelADX)return(-1);
      
      }}}
     HideTestIndicators(0);
     if(BB ==  1)
      {
       rsi = iRSI(NULL,0,periodRSI,priceRSI,i);
       if(rsi<=levelRSIbuy){
        dm = iDeMarker(NULL,0,periodDM,i);
        if(dm<=levelDMbuy){
         adxbuy = iADX(NULL,0,periodADX,priceADX,MODE_MINUSDI,i);
         HideTestIndicators(0);
         if(adxbuy>=levelADX)return(1);
        
      }}}
return(0);
}

//------------------------------------------------------------------------------
int GetBB(int ii, int periodBB, int deviationBB, int bands_shiftBB, int uppr, int dnpr, int CheckBarsBB)
{
 double  bh, bl; int dn=0,up=0;
 int j;
 for(j = ii; j<=ii+CheckBarsBB; j++)
 {
   bh = iBands(NULL,0,periodBB,deviationBB,bands_shiftBB,uppr,MODE_UPPER,j);
   bl = iBands(NULL,0,periodBB,deviationBB,bands_shiftBB,dnpr,MODE_LOWER,j);
   if(Close[j]>=bh) {dn++;break;} 
   if(Close[j]<=bl) {up++;break;} 
  }
 if(dn>0)return(-1);
 if(up>0)return( 1);
 return(0);
}
//+----------------------------------------------------------------------------+
int FilterMA(int Ma_Period,int Ma_shift, int Ma_type, int Ma_price,int Slippage_MA) 
{   
   double g_iclose_376 = iClose(NULL, 0, 1);
   double g_ima_408 = iMA(NULL, 0,Ma_Period,Ma_shift,Ma_type,Ma_price, 1);
   
   if( g_iclose_376 > g_ima_408 + Slippage_MA * Point ) return(1);
   if( g_iclose_376 < g_ima_408 - Slippage_MA * Point ) return(-1);
 
 return(0);
}
//+----------------------------------------------------------------------------+
bool CheckMaxSpread()
{
   RefreshRates();
   if (NormalizeDouble(Ask - Bid, Digits)/Point <= MaxSpread*mp) return (TRUE);
   //---
   else return (FALSE);
}
//+------------------------------------------------------------------+ 
int OrdersScaner() { //------------------сканер ордеров ---------   
      
   orders_buy=0;orders_sell=0;//profit=0;
   MinPriceBuy=0;MaxPriceSell=0;pending=0;
   for (int i=OrdersTotal();i>=1;i--) {
      if(OrderSelect(i-1, SELECT_BY_POS, MODE_TRADES)==FALSE) break;
      if(OrderSymbol() != Symbol()) continue;
      if(OrderMagicNumber() != MAGIC) continue;
      
      if(OrderType() > 1) pending++;
      else if(OrderType() == OP_BUY ) {
         orders_buy++;
         if(orders_buy == 1) MinPriceBuy = OrderOpenPrice();
         if(orders_buy > 1 && OrderOpenPrice() < MinPriceBuy) MinPriceBuy = OrderOpenPrice();
         
         if((OrderStopLoss() == 0 && StopLoss > 0) || (OrderTakeProfit() == 0 && TakeProfit > 0)) { //выставление СЛ/ТП
            while(IsTradeContextBusy()) Sleep(1000); RefreshRates();
            double op = OrderOpenPrice(), tp = 0 , sl = 0;
            minstop = MarketInfo(Symbol(),MODE_STOPLEVEL);
            if(StopLoss!=0) sl = NormalizeDouble(op-StopLoss*Point, Digits); //else sl = 0;
            if(TakeProfit!=0) tp = NormalizeDouble(op+TakeProfit*Point, Digits); //else tp = 0;
            if(tp!=0) if(tp-Ask<minstop*Point)tp=Ask+minstop*Point;
            if(sl!=0) if(Bid-sl<minstop*Point)sl=Bid-minstop*Point;
            if(!OrderModify(OrderTicket(),op,sl,tp,0,Blue)) Print("Не получилось модифицировать ордер на BUY ",GetLastError());
         }
         
         //profit += OrderProfit()+OrderSwap();
      }
      else if(OrderType() == OP_SELL) {
         orders_sell++;
         if(orders_sell == 1) MaxPriceSell = OrderOpenPrice();
         if(orders_sell > 1 && OrderOpenPrice() > MaxPriceSell) MaxPriceSell = OrderOpenPrice();
         
         if((OrderStopLoss() == 0 && StopLoss > 0) || (OrderTakeProfit() == 0 && TakeProfit > 0)) { //выставление СЛ/ТП
            while(IsTradeContextBusy()) Sleep(1000); RefreshRates();
            double op = OrderOpenPrice(), tp = 0 , sl = 0;
            minstop = MarketInfo(Symbol(),MODE_STOPLEVEL);
            if(StopLoss!=0) sl = NormalizeDouble(op+StopLoss*Point, Digits); //else sl = 0;
            if(TakeProfit!=0) tp = NormalizeDouble(op-TakeProfit*Point, Digits); //else tp = 0;
            if(tp!=0)if(Bid-tp<minstop*Point)tp=Bid-minstop*Point;
            if(sl!=0)if(sl-Ask<minstop*Point)sl=Ask+minstop*Point;
            if(!OrderModify(OrderTicket(),op,sl,tp,0,Red)) Print("Не получилось модифицировать ордер на SELL ",GetLastError());
            else Print("Ордер был модифицирован. ТП: " + DoubleToStr(TakeProfit/mp,1) + ", СЛ: " + DoubleToStr(StopLoss/mp,1));
         }
         
         //profit += OrderProfit()+OrderSwap();
      }
   }
   int status = orders_buy+orders_sell;
   return(status);
}

//--------------------------------------------------------------------------------------
int OpenBuyMarket(int Magic,double lot,string _comm,color clr) {

   if(AccountFreeMarginCheck(Symbol(),OP_BUY,lot)<=0 || GetLastError()==134) { /* NOT_ENOUGH_MONEY */
      Print("Нет или не хватает для открытия  свободных средств");
      Comment("Нет или не хватает для открытия  свободных средств"); Sleep(5000);return(0);
   }
   
   while(IsTradeContextBusy()) Sleep(1000); RefreshRates();
   double ask = NormalizeDouble(Ask,Digits);
   
   ticket = 0;
   for(int i = 0; i<=5; i++) {
      ticket = OrderSend(Symbol(),OP_BUY,lot,ask,50,0,0,_comm,Magic,0,clr);
      if(ticket < 0) {
         Print(__FUNCTION__ + ": Не удалось открыть ордер. ");
         Sleep(10000);
      }
      else {
      	string q = __FUNCTION__ + ": ордер был открыт по цене: " + DoubleToStr(ask,Digits) + ". Спред: " + DoubleToStr(MarketInfo(Symbol(), MODE_SPREAD)/mp,1);
			Print(q);
         Sleep(1000);
         break; //завершение цикла открытия ордеров
      }   
   } 
   
   OrdersScaner();
   return(ticket);
  }
//----------------------------------------------------------------------------------------
int OpenSellMarket(int Magic,double lot,string _comm,color clr) {
  
   if(AccountFreeMarginCheck(Symbol(),OP_SELL,lot)<=0 || GetLastError()==134) { /* NOT_ENOUGH_MONEY */
      Print("Нет или не хватает для открытия  свободных средств");
      Comment("Нет или не хватает для открытия  свободных средств"); Sleep(5000);return(0);
   }
   
   while(IsTradeContextBusy()) Sleep(1000); RefreshRates();
   double bid = NormalizeDouble(Bid,Digits);
   
   ticket = 0;
   for(int i = 0; i<=5; i++) {
      ticket = OrderSend(Symbol(),OP_SELL,lot,bid,50,0,0,_comm,Magic,0,clr);
      if(ticket < 0) {
         Print(__FUNCTION__ + ": Не удалось открыть ордер. ");
         Sleep(10000);
      }
      else {
      	string q = __FUNCTION__ + ": ордер был открыт по цене: " + DoubleToStr(bid,Digits) + ". Спред: " + DoubleToStr(MarketInfo(Symbol(), MODE_SPREAD)/mp,1);
			Print(q);
         Sleep(1000);
         break; //завершение цикла открытия ордеров
      }   
   } 
   
   OrdersScaner();
   return(ticket);
}
//--------------------------------------------------------------------
//--------------------------------------------------------------------
int CloseAll()
  {// функция КИМА ему респект
//Print("ЗАКРЫВАЕМ ВСЕ ПОЗЫ"); 
   bool   UseSound=0;
   int    Slippage=5*mp;               // Проскальзывание цены
   int    NumberOfTry=6;               // Количество попыток
   int    PauseAfterError=5;              // Пауза после ошибки в секундах
   color clCloseBuy  = Blue;         // Цвет значка закрытия покупки
   color clCloseSell = Red;          // Цвет значка закрытия продажи
   string NameFileSound="";

   bool   fc;
   double pp;
   int    err,i,it,cnt=0,magic;

   for(i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))// {
         if(OrderSymbol()==Symbol())
           {
            magic=OrderMagicNumber();
            if(magic==MAGIC)
              {
               fc=False;
               for(it=1; it<=NumberOfTry; it++)
                 {
                  while(!IsTradeAllowed()) Sleep(500);
                  RefreshRates();
                  if(OrderType()==OP_BUY)
                    {
                     pp=MarketInfo(OrderSymbol(), MODE_BID);
                     fc=OrderClose(OrderTicket(), OrderLots(), pp, Slippage, clCloseBuy);
                     if(fc) {if(UseSound) PlaySound(NameFileSound); break;}
                     else { err=GetLastError(); Print("Error",err);Sleep(1000*PauseAfterError);}
                    }
                  if(OrderType()==OP_SELL)
                    {
                     pp=MarketInfo(OrderSymbol(), MODE_ASK);
                     fc=OrderClose(OrderTicket(), OrderLots(), pp, Slippage, clCloseSell);
                     if(fc) {if(UseSound) PlaySound(NameFileSound); break;}
                     else {err=GetLastError(); Print("Error",err); Sleep(1000*PauseAfterError);}
                    }
                 }
              }
           }
     }//}
//--------- проверка выполнения закрытия ---------------
   for(i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol()!=Symbol()) continue;
      magic=OrderMagicNumber();
      if(magic!=MAGIC) continue;
      if(OrderType()==OP_BUY || OrderType()==OP_SELL)cnt++;
     }
   if(cnt==0)return(1);
   else return (0);
  }
//--------------------------------------------------------------------------------------
