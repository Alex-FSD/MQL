//+------------------------------------------------------------------+
//|                                                FiboWave v2.2.mq4 |
//|                                      Copyright © 2010, wellforex |
//|                                              forex-way@yandex.ru |
//|                                              http://wellforex.ru |
//-------------------------------------------------------------------+
#property copyright "Copyright 2010, forex-way@yandex.ru"
#property link      "http://wellforex.ru"
#property version   "2.20"
#property description "Trading on Fibonacci levels"

input int    Magic=10001;                  //магик для торговли на разных парах 
input double Lots = 0.1;                   //Фиксированный лот
input bool   MM=false;                     //Включение ММ 
input double MMRisk=0.03;                  //Риск-фактор, процент депозита при расчёте лота
input int    LotDigits=2;                  //количество разрядов в значении лота
input string WaveSet= "--- Waves length and Fibo levels ---";
input int    WaveMin=300;                   //Минимальная длина учитываемой волны
input int    WaveMax=1000;                  //Максималдьная длина учитываемой волны
input double FiboOpen=28;                  //фибо-уровень установки лимит ордера - открытие (откат %)
input double FiboStop=50;                  //фибо-уровень установки стоплосса (откат %)
input double FiboTake=143;                 //фибо-уровень установки тейкпрофита (расширение %)                      
input string TralSet="--- Trailing stop ---";
input bool   Tral=false;                   //Трейлинг-стоп вкл/выкл
input int    TralStartLevel=10;            //Профит включения трейлинг-стопа 
input int    TralStop=20;                  //Уровень трейлинг-стопа 
input string DisplaySet=" --- Display ---";
input bool   Info=true;                    //Отображение информации-комментариев вкл/выкл
input bool   Levels=true;                  //Отображение уровней вкл/выкл
input string ZigZagSet=" --- ZigZag ---";
input int    ExtDepth=16;
input int    ExtDeviation=5;
input int    ExtBackstep=3;

int MaxTries=5;
int TS,Dec,digit=0;
int i,cnt=0,ticket,mode=0,OrderCod=0,LowBar,HiBar,Up,Dn;
double BuyProfit=0,SellProfit=0;
double   Lotsi=0;
double BuyPrice,SellPrice,Stop_Loss,Take_Profit,LastWaveM;
double  BuyStop=0,SellStop=0,MemWave;
string name="FiboWave",TralOn="Off";

double Zig,Zag,LastLow,LastHi,LastWave,LastVol,WaveZig,WaveZag,MemZig,MemZag,StopLoss;
bool NewWave;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {

//Last Low
   for(i=0; i<1000; i++)
     {
      Zig=iCustom(NULL,0,"ZigZag",ExtDepth,ExtDeviation,ExtBackstep,2,i);
      if(Zig!=0) {LastLow=Zig; LowBar=i; break;}
     }
//Last Hi
   for(i=0; i<1000; i++)
     {
      Zag=iCustom(NULL,0,"ZigZag",ExtDepth,ExtDeviation,ExtBackstep,1,i);
      if(Zag!=0) {LastHi=Zag; HiBar=i; break;}
     }
   Up=0; Dn=0;
   if(LowBar>HiBar) Up=1;
   if(LowBar<HiBar) Dn=1;
   if(Up==1 && Levels)
     {
      ObjectDelete("Fibo");
      ObjectCreate("Fibo",OBJ_FIBO,0,iTime(Symbol(),0,LowBar),LastLow,iTime(Symbol(),0,HiBar),LastHi);
      ObjectSet("Fibo",OBJPROP_COLOR,Blue);
      ObjectSet("Fibo",OBJPROP_WIDTH,2);
     }

   if(Dn==1 && Levels)
     {
      ObjectDelete("Fibo");
      ObjectCreate("Fibo",OBJ_FIBO,0,iTime(Symbol(),0,HiBar),LastHi,iTime(Symbol(),0,LowBar),LastLow);
      ObjectSet("Fibo",OBJPROP_COLOR,Red);
      ObjectSet("Fibo",OBJPROP_WIDTH,2);
     }

   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void deinit()
  {
   ObjectDelete("Fibo");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   digit=MarketInfo(Symbol(),MODE_DIGITS);
   if(digit==5 || digit==3) Dec=10;
   if(digit==4 || digit==2) Dec=1;

   if(!MM) Lotsi=Lots;

   if(Tral) {TralOn="On"; TrailStops(Magic);}

   if(Info)
     {
      Comment(" ",
              "   \n------------------------------------------------------------------",
              "   \nAccountNumber : ",DoubleToStr(AccountNumber(),0),
              "   \n",TerminalCompany(),
              "   \nCurrent Server Time : "+TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS),
              "   \n------------------------------------------------------------------",
              "   \nFiboOpen % = ",DoubleToStr(FiboOpen,1),
              "   \nFiboTake % = ",DoubleToStr(FiboTake,1)," / FiboStop % = ",DoubleToStr(FiboStop,1),
              "   \nWaveMin = ",DoubleToStr(WaveMin,1),
              "   \nWaweMax = ",DoubleToStr(WaveMax,1),
              "   \nCurrentWave = ",DoubleToStr(LastWave/Dec,1),
              "   \n------------------------------------------------------------------",
              "   \nLot = ",DoubleToStr(Lotsi,LotDigits),
              "   \nMinLot on symbol = ",DoubleToStr(MarketInfo(Symbol(),MODE_MINLOT),2)," / Tral - ",TralOn,
              "   \n------------------------------------------------------------------");
     }

   if(Volume[0]<=10 && (Volume[0]<LastVol || Volume[0]==1))
     {

      //Last Low
      for(i=0; i<1000; i++)
        {
         Zig=iCustom(NULL,0,"ZigZag",ExtDepth,ExtDeviation,ExtBackstep,2,i);
         if(Zig!=0) {LastLow=Zig; LowBar=i; break;}
        }
      //Last Hi
      for(i=0; i<1000; i++)
        {
         Zag=iCustom(NULL,0,"ZigZag",ExtDepth,ExtDeviation,ExtBackstep,1,i);
         if(Zag!=0) {LastHi=Zag; HiBar=i; break;}
        }
      Up=0; Dn=0;
      if(LowBar>HiBar) Up=1;
      if(LowBar<HiBar) Dn=1;

      if(Up==1 && Levels)
        {
         ObjectDelete("Fibo");
         ObjectCreate("Fibo",OBJ_FIBO,0,iTime(Symbol(),0,LowBar),LastLow,iTime(Symbol(),0,HiBar),LastHi);
         ObjectSet("Fibo",OBJPROP_COLOR,Blue);
         ObjectSet("Fibo",OBJPROP_WIDTH,2);
        }

      if(Dn==1 && Levels)
        {
         ObjectDelete("Fibo");
         ObjectCreate("Fibo",OBJ_FIBO,0,iTime(Symbol(),0,HiBar),LastHi,iTime(Symbol(),0,LowBar),LastLow);
         ObjectSet("Fibo",OBJPROP_COLOR,Red);
         ObjectSet("Fibo",OBJPROP_WIDTH,2);
        }

      LastWave=NormalizeDouble((LastHi-LastLow)/Point,Digits);

      if(ScanTradesPend(Magic)>0 && LastWave!=MemWave && LastWave>WaveMin*Dec && LastWave<WaveMax*Dec) PendOrdDel(Magic);

      if(Up==1 && ScanTradesOpen(Magic)==0 && ScanTradesPend(Magic)==0 && LastWave>WaveMin*Dec && LastWave<WaveMax*Dec)
        {
         BuyPrice=0;
         BuyPrice=LastHi-FiboOpen*LastWave*Point/100;
         BuyStop=LastHi-FiboStop*LastWave*Point/100;
         BuyProfit=LastHi+(FiboTake-100)*LastWave*Point/100;
         StopLoss=BuyPrice-BuyStop;
         if(MM)
           {
            Lotsi=NormalizeDouble(AccountBalance()*MMRisk/10/StopLoss*Dec*Point,LotDigits);
            if(Lotsi<MarketInfo(Symbol(),MODE_MINLOT)) Lotsi=MarketInfo(Symbol(),MODE_MINLOT);
           }
         if(Ask>BuyPrice+3*Dec*Point) BuyLimitOrdOpen(Blue,Magic);
         Sleep(5000);
         if(ScanTradesPend(Magic)>0) MemWave=LastWave;
        }

      if(Dn==1 && ScanTradesOpen(Magic)==0 && ScanTradesPend(Magic)==0 && LastWave>WaveMin*Dec && LastWave<WaveMax*Dec)
        {
         SellPrice=0;
         if(ScanTradesPend(Magic)>0) PendOrdDel(Magic);
         SellPrice=LastLow+FiboOpen*LastWave*Point/100;
         SellStop=LastLow+FiboStop*LastWave*Point/100;
         SellProfit=LastLow-(FiboTake-100)*LastWave*Point/100;
         StopLoss=SellStop-SellPrice;
         if(MM)
           {
            Lotsi=NormalizeDouble(AccountBalance()*MMRisk/10/StopLoss*Dec*Point,LotDigits);
            if(Lotsi<MarketInfo(Symbol(),MODE_MINLOT)) Lotsi=MarketInfo(Symbol(),MODE_MINLOT);
           }
         if(Bid<SellPrice-3*Dec*Point) SellLimitOrdOpen(Red,Magic);
         Sleep(5000);
         if(ScanTradesPend(Magic)>0) MemWave=LastWave;
        }

     }
   LastVol=Volume[0];
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SellLimitOrdOpen(int ColorOfSell,int nMagic)
  {

   for(int try=1;try<=MaxTries;try++)
     {
      while(!IsTradeAllowed()) Sleep(500);
      RefreshRates();

      ticket=OrderSend(Symbol(),OP_SELLLIMIT,Lotsi,
                       NormalizeDouble(SellPrice,digit),
                       6,
                       NormalizeDouble(SellStop,digit),
                       NormalizeDouble(SellProfit,digit),name,nMagic,0,ColorOfSell);

      Sleep(200);
      if(ticket>0) break;

      if(ticket<0)
        {
         if(try==MaxTries) {Print("Warning!!!Last try failed!");}
         Print("OrderSend failed with error #",GetLastError());
         return;
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BuyLimitOrdOpen(int ColorOfBuy,int nMagic)
  {

   for(int try=1;try<=MaxTries;try++)
     {
      while(!IsTradeAllowed()) Sleep(500);
      RefreshRates();

      ticket=OrderSend(Symbol(),OP_BUYLIMIT,Lotsi,
                       NormalizeDouble(BuyPrice,digit),
                       6,
                       NormalizeDouble(BuyStop,digit),
                       NormalizeDouble(BuyProfit,digit),name,nMagic,0,ColorOfBuy);
      Sleep(200);
      if(ticket>0) break;
      if(ticket<0)
        {
         if(try==MaxTries) {Print("Warning!!!Last try failed!");}
         Print("OrderSend failed with error #",GetLastError());
         return;
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TrailStops(int nMagic)
  {
   int total=OrdersTotal();
   for(cnt=0;cnt<total;cnt++)
     {

      if(OrderSelect(cnt,SELECT_BY_POS) && OrderSymbol()==Symbol() && OrderMagicNumber()==nMagic)
        {
         mode=OrderType();
         if(mode==OP_BUY)
           {
            if(NormalizeDouble(Ask-OrderOpenPrice(),Digits)>Point*TralStartLevel*Dec && NormalizeDouble(Ask-OrderStopLoss(),Digits)>Point*TralStop*Dec)
              {
               if(OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Ask-TralStop*Dec*Point,Digits),OrderTakeProfit(),0,Green)) return;

              }
           }

         if(mode==OP_SELL)
           {
            if(NormalizeDouble(OrderOpenPrice()-Bid,Digits)>Point*TralStartLevel*Dec && (NormalizeDouble(OrderStopLoss()-Bid,Digits)>Point*TralStop*Dec || OrderStopLoss()==0))
              {
               if(OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Bid+TralStop*Dec*Point,Digits),OrderTakeProfit(),0,Green))return;

              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ScanTradesPend(int nMagic)
  {
   int total=OrdersTotal();
   int numords=0;

   for(cnt=0; cnt<total; cnt++)
     {

      if(OrderSelect(cnt,SELECT_BY_POS) && (OrderType()==OP_BUYLIMIT || OrderType()==OP_SELLLIMIT) && OrderMagicNumber()==nMagic)
         numords++;
     }
   return(numords);
  }
     
void PendOrdDel(int nMagic)
  {
   int total=OrdersTotal();
   for(cnt=total;cnt>=0;cnt--)
     {

      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES) && OrderMagicNumber()==nMagic && (OrderType()==OP_SELLLIMIT || OrderType()==OP_BUYLIMIT))
        {
         bool result=false;

         for(int try=1;try<=MaxTries;try++)
           {

            result=OrderDelete(OrderTicket());
            if(result) break;

            if(!result)
              {
               Print("OrderSend failed with error #",GetLastError()); Sleep(5000);
              }
           }
        }
     }

   return;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ScanTradesOpen(int nMagic)
  {
   int total=OrdersTotal();
   int numords=0;

   for(cnt=0; cnt<total; cnt++)
     {

      if(OrderSelect(cnt,SELECT_BY_POS) && OrderSymbol()==Symbol() && (OrderType()==OP_BUY || OrderType()==OP_SELL) && OrderMagicNumber()==nMagic)
         numords++;
     }
   return(numords);
  }
//+------------------------------------------------------------------+
