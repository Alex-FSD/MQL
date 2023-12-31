#property copyright "Reutskiy Dmitriy"
#property link      "https://www.mql5.com/ru/users/dmrdimtriy"
#property version   "1.11"
#property strict

extern double dblLots       = 0.02;
extern bool   blStepFibo    = false;
extern bool   blRisk        = true;
extern double dblMultiplier = 1;
extern int    intMagic      = 999; 
extern int    intSplit      = 3;
extern int    intTakeProfit = 200;
//extern int    intStopLoss   = 300
//-------------------------------
extern string strSTH_         = "Параметры STH";
extern bool   blSTH           = true;
extern int    int_STH_MaxRisk = 30;
extern int    int_STH_Step    = 125;
extern int    int_StochK      = 5; 
extern int    int_StochD      = 3;
extern int    int_StochL      = 3;
extern string strTR_          = "Параметры Тренда";
extern int    int_MA_Period   = 30;
extern int    int_Wait        = 5;
//--------------------------------
extern string strMA_buy          = "Параметры MA_buy";
extern bool   blMA_buy           = false;
extern int    int_MA_buy_MaxRisk = 25;
extern int    int_MA_buy_Step    = 525;
extern int    int_MA_buy_Period  = 196;
//--------------------------------
extern string strMA_sell          = "Параметры MA_sell";
extern bool   blMA_sell           = false;
extern int    int_MA_sell_MaxRisk = 25;
extern int    int_MA_sell_Step    = 340;
extern int    int_MA_sell_Period  = 92;
//---------------------------------



bool 
 blCrossUp   = false,
 blCrossDown = false;

int intTicket , intBar, intStepOrd,
intStep, intMaxRisk, intTakeMod= 10;

double dblTP,dblSL, dblPrice, dblLastLot, dblPercentRisk,
dblPrevious,dblCurrent;
datetime dtTime;



//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
 if (Digits == 3)
 {
  intTakeProfit *= 10;
  intStep       *= 10;
 }
 return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
int start()
{

 // Работаем раз в свечу
 if(dtTime == iTime(NULL,0,0)) return(0);
  dtTime = iTime(NULL,0,0); 
 
 if(blRisk && F_int_CountTrades()>0 && F_dbl_OrdersProfit()<0) // Pf
 {
  dblPercentRisk = MathAbs(F_dbl_OrdersProfit())*100/AccountBalance();
  dblPercentRisk = NormalizeDouble(dblPercentRisk,0);
  if(dblPercentRisk > intMaxRisk) // Риск превышает допустимый
  {
   F_vd_CloseAll();
  }
 }
 
 // если нет ордеров Добавить проверку по таймфрейму
 if(F_int_CountTrades() == 0)
 {
  // Проверяем пересечение со среденией
   SignMA(); 
  //-----------------------------------
   if( ((blSTH && strSTH() == "buy" && blCrossUp )||(blMA_buy && strMA() == "buy" ))  && F_int_CountTrades() == 0)  //
   { //&& blCrossDown
    dblTP = NormalizeDouble(Ask + intTakeProfit*Point,Digits);
   // dblSL = NormalizeDouble(Bid - intStopLoss*Point,Digits);
    intTicket = 0;
    intTicket = OrderSend(Symbol(),OP_BUY,dblLots,Ask,5,0,dblTP, "1-й ордер", intMagic,0,clrBlue);
    if(intTicket < 0) 
    {
     Print("Ошибка выставления ордера");
    }
    else
    {
     blCrossUp = false;
    }
   }    
  
   if( ((blSTH && strSTH() == "sell" && blCrossDown)||(blMA_sell && strMA() == "sell" )) && F_int_CountTrades() == 0) //
   {  // && blCrossUp
    dblTP = NormalizeDouble(Bid - intTakeProfit*Point,Digits);
   // dblSL = NormalizeDouble(Ask + intStopLoss*Point,Digits);
    intTicket = 0;
    intTicket = OrderSend(Symbol(),OP_SELL,dblLots,Bid,5,0,dblTP, "1-й ордер", intMagic,0,clrRed);
    if(intTicket < 0) 
    {
     Print("Ошибка выставления ордера");
    }
    else
    {
     blCrossDown = false;
    }
  }
 
 }
 else // если есть ордера
 {
  // новый шаг ордеров
  if(blStepFibo) 
   {
    if(F_int_CountTrades() == 1) 
      intStepOrd = intStep;
     else 
      intStepOrd = F_int_CountTrades()*intStep*2;
   }
    else intStepOrd = intStep;
   
  int intOrder_type = F_int_LastOrderType();
 //--------------------------------
  if(intOrder_type == OP_BUY)
  {
   dblPrice = F_dbl_FindLastOrderprice(OP_BUY);
   
   if(iLow(NULL,0,0) <= dblPrice - intStepOrd*Point ) // iClose(NULL,0,0)
   // если превышено допустимое отклонение intStepOrd && еслить сигнал 
   // добавляем ордер на покупку
   {
    dblLastLot = F_dbl_FindLastLot(OP_BUY);
    Comment ("Последний лот" + DoubleToStr(dblLastLot,3));
    dblLastLot = NormalizeDouble(dblLastLot*dblMultiplier,2);
    intTicket = OrderSend(Symbol(),OP_BUY,dblLastLot,Ask,5,0,0,"",intMagic,0,clrBlue);
     if( intTicket < 1)Print("Order opened sucsess");
    F_vd_ModifyOrders(OP_BUY);
   }
  
  }
  //--------------------------------
  if(intOrder_type == OP_SELL)
  {
   dblPrice = F_dbl_FindLastOrderprice(OP_SELL);
   if(iHigh(NULL,0,0) >= dblPrice + intStepOrd*Point ) //&& strRSI("insert") == "sell"
   // если превышено допустимое отклонение intStepOrd && еслить сигнал
   // добавляем ордер на продажу
   {
    dblLastLot = F_dbl_FindLastLot(OP_SELL);
    dblLastLot = NormalizeDouble(dblLastLot*dblMultiplier,2);
    intTicket = OrderSend(Symbol(),OP_SELL,dblLastLot,Bid,5,0,0,"",intMagic,0,clrRed);
     if( intTicket < 1)Print("Order opened sucsess");
    F_vd_ModifyOrders(OP_SELL);
   }
  }
 }  

 return(0);
}
//+------------------------------------------------------------------+
int F_int_CountTrades()
{
 int intCount =0;
 for (int i = OrdersTotal()-1; i>=0; i--)
 {
  if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
  {
   if(OrderSymbol() == Symbol() && OrderMagicNumber()==intMagic)
    if(OrderType()==OP_BUY || OrderType()==OP_SELL)
     intCount++;
  }
 }
 return(intCount);
}

int F_int_LastOrderType()
{
 for(int i=OrdersTotal()-1;1>=0;i--)
 {
  if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
  {
   if(OrderSymbol() == Symbol() && OrderMagicNumber() == intMagic)
    return(OrderType());
  }
 }
}
//----------------------------------------------------------------------------------------

double F_dbl_FindLastOrderprice(int intOType)
{
 int  intOldTicket;
 double dblOldOpenPrice=0;
 intTicket =0;
 
 for(int cnt=OrdersTotal()-1; cnt>=0; cnt--)
 {
  if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES))
  {
   if(OrderSymbol() == Symbol() && OrderMagicNumber() == intMagic && OrderType() == intOType)
   {
    intOldTicket = OrderTicket();
    if(intOldTicket > intTicket)
    {
     intTicket = intOldTicket;
     dblOldOpenPrice = OrderOpenPrice();
    }
   }
  }
 }
 return (dblOldOpenPrice);
}

//-------------------------------------
double F_dbl_FindLastLot(int intOType)
{
 int  intOldTicket;
 double dblOldLot=0;
 intTicket = 0;
 for(int cnt=OrdersTotal()-1; cnt>=0; cnt--)
 {
  if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES))
  {
   if(OrderSymbol() == Symbol() && OrderMagicNumber() == intMagic && OrderType() == intOType)
   {
    intOldTicket = OrderTicket();
    if(intOldTicket > intTicket)
    {
     intTicket = intOldTicket;
     dblOldLot = OrderLots();
    }
   }
  }
 }
 return (dblOldLot);
}

void F_vd_ModifyOrders(int intOType)
{
 double dblAVG_price, dblOrder_lots=0, dblCRPrice = 0;
 for(int i=OrdersTotal()-1;i>=0;i--)
 {
  if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
  {
   if(OrderSymbol()==Symbol() && OrderMagicNumber()==intMagic && OrderType() == intOType)
   {
    dblCRPrice += OrderOpenPrice() * OrderLots();
    dblOrder_lots += OrderLots();
   }
  }
 }
 dblAVG_price = NormalizeDouble(dblCRPrice/dblOrder_lots,Digits);
 
 if(intOType == OP_BUY)  dblTP = NormalizeDouble(dblAVG_price + intTakeMod*Point,Digits);
 if(intOType == OP_SELL) dblTP = NormalizeDouble(dblAVG_price - intTakeMod*Point,Digits);
 // модифицируем ордера
 for(int i = OrdersTotal() -1; i>=0;i--)
 {
  if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
  {
   if(OrderSymbol()==Symbol() && OrderMagicNumber()==intMagic && OrderType() == intOType)
   {
    if(OrderModify(OrderTicket(),OrderOpenPrice(),0,dblTP,0))
     Print("Ордера успешно модифицированы!");
    else
     Print("Ошибка модификации ордеров");
    
   }
  }
 }
 
}


double F_dbl_OrdersProfit()
{
 double dblProfit=0;
 for(int i=OrdersTotal()-1; i>=0; i--)
 {
  if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
  {
   if(OrderSymbol()==Symbol()&& OrderMagicNumber()==intMagic)
   {
    dblProfit += OrderProfit();
   }
  }
 }
 return (dblProfit);
}


void F_vd_CloseAll() 
{
 for (int trade = OrdersTotal() - 1; trade >= 0; trade--) 
 {
  if(OrderSelect(trade, SELECT_BY_POS, MODE_TRADES))
  {
   if(OrderSymbol() == Symbol() && OrderMagicNumber() == intMagic) 
   {
    if (OrderType() == OP_BUY)
    { 
     if(!OrderClose(OrderTicket(), OrderLots(), Bid, intSplit, clrBlue))
      Print("Error of closing orders");
     else Print("Closed");
    }  
    if (OrderType() == OP_SELL) 
    {
     if(!OrderClose(OrderTicket(), OrderLots(), Ask, intSplit, clrRed))
      Print("Error of closing orders");
      else Print("Closed");
    }
   }
  Sleep(1000);
  }
 }
}
//-----------------------------Sign------------------------

// Добавить отслеживание Разрешения на покупку и продажу 


//количество свечей над Ma
// сигнал на добавление strSign = "insert"
string strSTH()
{

int    
 i = 0, grow=0, intV=0, intRoad=0;
bool   
 blBuy=false, 
 blSell=false;

double
 
M_1 = iStochastic(NULL,0,int_StochK,int_StochD,int_StochL,MODE_SMA,0,MODE_MAIN,  1),
M_2 = iStochastic(NULL,0,int_StochK,int_StochD,int_StochL,MODE_SMA,0,MODE_MAIN,  2),
S_1 = iStochastic(NULL,0,int_StochK,int_StochD,int_StochL,MODE_SMA,0,MODE_SIGNAL,1),
S_2 = iStochastic(NULL,0,int_StochK,int_StochD,int_StochL,MODE_SMA,0,MODE_SIGNAL,2),
dblIMAi = iMA(NULL,0,int_MA_Period,0,MODE_SMA,PRICE_CLOSE,1);
 // Переключать глобальную переменную в момент пересечения
 // cредней   
 if( M_2 > S_2 && M_1 <= S_1 && M_1 < 20   )   blBuy = true; //&& iClose(NULL,0,1) > dblIMA_M2
 if( M_2 < S_2 && M_1 >= S_1 && M_1 > 80  )   blSell = true; //&& iClose(NULL,0,1) < dblIMA_M2 
 
for(i=1;i<=int_Wait;i++)
{
 dblIMAi = iMA(NULL,0,int_MA_Period,0,MODE_SMA,PRICE_CLOSE,i);
 if(iClose(NULL,0,i) < dblIMAi) blBuy = false;
} 

for(i=1;i<=int_Wait;i++)
{
 dblIMAi = iMA(NULL,0,int_MA_Period,0,MODE_SMA,PRICE_CLOSE,i);
 if(iClose(NULL,0,i) > dblIMAi) blSell = false;
}
 
//{ 
// if( M_2 < S_2 && M_1 >= S_1 && M_1 < 30)   return "buy"; 
//}   
  
 
 

if(blBuy || blSell)
{
 intMaxRisk    = int_STH_MaxRisk;
 intStep       = int_STH_Step;
}
  
if(blBuy) return "buy";
 else
  if(blSell) return "sell";
   else return "none";
   
 return "none";
}


// Определяет торгуем мы или нет
void SignMA()
{

double 
 dblIMA1 = iMA(NULL,0,int_MA_Period,0,MODE_SMA,PRICE_CLOSE,1),
 dblIMA2 = iMA(NULL,0,int_MA_Period,0,MODE_SMA,PRICE_CLOSE,2);
 
if(iOpen(NULL,0,2) <  dblIMA1 && iClose(NULL,0,1) > dblIMA1)
{
 blCrossDown = false;
 blCrossUp = true;
}

if(iOpen(NULL,0,2) >  dblIMA1 && iClose(NULL,0,1) < dblIMA1)
{
 blCrossDown = true;
 blCrossUp = false;
}  

if(blCrossDown) Comment("Ждем открыния вниз");
if(blCrossUp) Comment("Ждем открыния вверх");
if(!blCrossDown && !blCrossUp) Comment("Нет сигнала");

}


string strMA()
{

int  i=0;
bool blSell = false,
     blBuy  = false;

double 
     dblOSMA1  = iOsMA(NULL,0,12,26,9,PRICE_OPEN,1),
     dblOSMA2  = iOsMA(NULL,0,12,26,9,PRICE_OPEN,2),
     dblOSMA3  = iOsMA(NULL,0,12,26,9,PRICE_OPEN,3),
     dblOSMA4  = iOsMA(NULL,0,12,26,9,PRICE_OPEN,4),
     dblOSMA5  = iOsMA(NULL,0,12,26,9,PRICE_OPEN,5),
     dblRSIi  = 0,
     dblIMAi  = 0;

if(blMA_buy) 
{
 double dblIMA_buy  = iMA(NULL,0,int_MA_buy_Period,0,MODE_SMA,PRICE_CLOSE,1);
 if(dblOSMA4>0 && dblOSMA3<0 && dblOSMA2>0  && dblOSMA1<0 && iClose(NULL,0,1) < dblIMA_buy) //(dblIMA1 -iClose(NULL,0,1))/Point > int_RSI_distance
 { //&& dblOSMA5<0 &&  
  blBuy = true;
 }

if(blBuy)
{
 intMaxRisk    = int_MA_buy_MaxRisk;
 intStep       = int_MA_buy_Step;
}


}

if(blMA_sell) 
{
 double dblIMA_sell = iMA(NULL,0,int_MA_sell_Period,0,MODE_SMA,PRICE_CLOSE,1);
 if(dblOSMA4>0 && dblOSMA3<0 && dblOSMA2>0  && dblOSMA1<0 && iClose(NULL,0,1) > dblIMA_sell) //(dblIMA1 -iClose(NULL,0,1))/Point > int_RSI_distance
 { //dblOSMA5<0 &&  
   blSell = true;
 }

if(blSell)
{
 intMaxRisk    = int_MA_sell_MaxRisk;
 intStep       = int_MA_sell_Step;
}

}

if(blBuy) return "buy";
 else
  if(blSell) return "sell";
   else return "none";
   
 return "none";

}
