//+------------------------------------------------------------------+
//|                                           !UsrednenieDynamic.mq4 |
//|                                                  Melnicuc Alexei |
//|                                           miller.bird0@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Melnicuc Alexei"
#property link      "miller.bird0@gmail.com"

//--- input parameters
extern double Lot=0.1;
extern int MinGrid=130;
extern int StochPeriod=50;
extern int StochPeriodSlow=50;
extern int StdDevPeriodEntry=40;
extern int StdDevPeriodGrid=1200;
extern double DifPrice=0.0945;

//--- vars
double grid;
int UsrednenieMN;
string Prefix;
double mingrid;
int Lock=0;
double Level0, Level1, Level2;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   Prefix=Symbol()+"!UsrednenieDynamic.";
   
   UsrednenieMN=0; for(int i=0; i<StringLen(Prefix); i++)UsrednenieMN+=StringGetChar(Prefix,i);

   mingrid=MinGrid*Point;
   
   Level0=StdDevLevel(0);
   Level1=StdDevLevel(1);
   Level2=StdDevLevel(2);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   //return(0);
   
   int position=PositionExist();
   int condition=Condition();
   
   if(position==OP_BUY && condition==OP_BUY){SetOrder(OP_BUY); return(0);}
   if(position==OP_SELL && condition==OP_SELL){SetOrder(OP_SELL); return(0);}
   if(position==-1 && condition==OP_BUY)SetOrder(OP_BUY);
   else if(position==-1 && condition==OP_SELL)SetOrder(OP_SELL);
//----
   return(0);
  }
//+------------------------------------------------------------------+
int Condition(){
bool u=false, d=false;

  double difprice=100;
  if(OrderSelect(OrdersTotal()-1,SELECT_BY_POS,MODE_TRADES)){
     if(OrderMagicNumber()==UsrednenieMN){
        difprice=100*MathAbs(OrderOpenPrice()-Close[0])/(OrderOpenPrice()/2+Close[0]/2);
     }
  }
  if(difprice<DifPrice)return(-1);
  
  double StdDev=iStdDev(NULL,0,StdDevPeriodEntry,0,MODE_EMA,PRICE_CLOSE,0);
  if(StdDev>Level0)return(-1);
   
  double Stohastic=iStochastic(NULL,0,StochPeriod,3,StochPeriodSlow,MODE_SMA,0,MODE_SIGNAL,0);
  double dif=iStochastic(NULL,0,StochPeriod,3,StochPeriodSlow,MODE_SMA,0,MODE_SIGNAL,1)-iStochastic(NULL,0,StochPeriod,3,StochPeriodSlow,MODE_SMA,0,MODE_SIGNAL,2);
  if(Stohastic>80 && dif<0)d=true;
  if(Stohastic<20 && dif>0)u=true;

if(u)return(OP_BUY);
if(d)return(OP_SELL);
return(-1);
}
//+------------------------------------------------------------------+
void SetOrder(int u){
int k=-1;
int op;
double tp, sl, entry;

//grid=iStdDev(NULL,0,StdDevPeriodGrid,0,MODE_EMA,PRICE_CLOSE,0);

grid=HL(MathMod(TimeHour(TimeCurrent())+1,24),PERIOD_H1);
//grid=HL(MathMod(TimeHour(TimeCurrent())+1,24),PERIOD_H4);
//grid=HL(MathMod(TimeDay(TimeCurrent())+1,31),PERIOD_D1);

if(grid<mingrid)return(0);

      entry=Bid; tp=entry-grid; sl=0; op=OP_SELL;
      if(u==OP_BUY){entry=Ask; tp=entry+grid; sl=0; op=OP_BUY;}
      k=OrderSend(Symbol(),op,UsrednenieLot(),NormalizeDouble(entry,Digits),1,NormalizeDouble(sl,Digits),NormalizeDouble(tp,Digits),"Usrednenie",UsrednenieMN,0,Blue);
      if(k!=-1)ModifyAllTP(tp);
      
return(0);
}
//+------------------------------------------------------------------+
double UsrednenieLot(){
double Profit=0;
  for(int i=OrdersTotal()-1; i>=0; i--){
   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
      if(OrderMagicNumber()==UsrednenieMN){
         Profit+=-OrderProfit()-grid/Point*OrderLots();
      }
   }
  }
double L=Profit/grid*Point+Lot;
if(L<Lot)L=Lot;
NormalizeDouble(L,2);
return(L);
}
//+------------------------------------------------------------------+
int PositionExist(){
  for(int i=OrdersTotal()-1; i>=0; i--){
   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
      if(OrderMagicNumber()==UsrednenieMN){
         return(OrderType());
      }
   }
  }
return(-1);
}
//+------------------------------------------------------------------+
void SetLock(bool flag){
double L=0;
  for(int i=OrdersTotal()-1; i>=0; i--){
   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
      if(OrderMagicNumber()==UsrednenieMN){
         L+=OrderLots();
      }
   }
  }
  int k=-1;
   
  double entry=Bid; double tp=0; double sl=0; int op=OP_SELL;
  if(flag){entry=Ask; tp=0; sl=0; op=OP_BUY;}
  k=OrderSend(Symbol(),op,NormalizeDouble(L,2),NormalizeDouble(entry,Digits),1,NormalizeDouble(sl,Digits),NormalizeDouble(tp,Digits),"Lock",UsrednenieMN,0,Blue);
  if(k!=-1 && flag)Lock=1;
  if(k!=-1 && !flag)Lock=-1;
  
return(0);
}
//+------------------------------------------------------------------+
void DeleteLock(){
 for(int i=OrdersTotal()-1; i>=0; i--){
    if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)){
      if(OrderMagicNumber()==UsrednenieMN && OrderComment()=="Lock"){
         if(OrderType()==OP_BUY){ 
            OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_BID),MarketInfo(OrderSymbol(),MODE_DIGITS)),1,White);
         }
         if(OrderType()==OP_SELL){ 
            OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_ASK),MarketInfo(OrderSymbol(),MODE_DIGITS)),1,White);
         }
      }
    }
 }
 Lock=0;
return(0);
}
//+------------------------------------------------------------------+
double HL(int h, int period){
if(period==PERIOD_H1)int k=0;
if(period==PERIOD_H4)k=1;
if(period==PERIOD_D1)k=2;
static double HL[32,3];
if(HL[h,k]!=0)return(HL[h,k]);

double Mean=0;
int n=0;
   for(int i=1; i<iBars(Symbol(),period); i++){
      if(period==PERIOD_H1)if(TimeHour(iTime(Symbol(),period,i))!=h)continue;
      if(period==PERIOD_H4)if(TimeHour(iTime(Symbol(),period,i))!=h)continue;
      if(period==PERIOD_D1)if(TimeDay(iTime(Symbol(),period,i))!=h)continue;
      Mean+=iHigh(Symbol(),period,i)-iLow(Symbol(),period,i);
      n++;
   }
   if(n==0){Print("n Mean==0"); return(-1);}
   Mean=Mean/n;
double Dispersia=0;
n=0;
   for(i=1; i<iBars(Symbol(),period); i++){
      if(period==PERIOD_H1)if(TimeHour(iTime(Symbol(),period,i))!=h)continue;
      if(period==PERIOD_H4)if(TimeHour(iTime(Symbol(),period,i))!=h)continue;
      if(period==PERIOD_D1)if(TimeDay(iTime(Symbol(),period,i))!=h)continue;
      Dispersia+=MathAbs(iHigh(Symbol(),period,i)-iLow(Symbol(),period,i)-Mean);
      n++;
   }
   Dispersia=Dispersia/n;
   if(n==0){Print("n Dispersia==0"); return(-1);}
   Mean=Mean-Dispersia;
   HL[h,k]=Mean;
return(Mean);
}
//+------------------------------------------------------------------+
double StdDevLevel(int Level){
static double Mean=0;
if(Mean==0){
   int n=0;
      for(int i=1; i<Bars; i++){
         double StdDev=iStdDev(NULL,0,StdDevPeriodEntry,0,MODE_EMA,PRICE_CLOSE,i);
         Mean+=StdDev;
         n++;
      }
      Mean=Mean/n;
}
   for(int j=0; j<Level; j++){
      double MeanLevel=0;
      n=0;
      for(i=1; i<Bars; i++){
         StdDev=iStdDev(NULL,0,StdDevPeriodEntry,0,MODE_EMA,PRICE_CLOSE,i);
         if(StdDev<Mean)
         MeanLevel+=StdDev;
         n++;
      }
      MeanLevel=MeanLevel/n;
      Mean=MeanLevel;
   }
 
return(Mean);
}
//+------------------------------------------------------------------+
void ModifyAllTP(double tp){
  for(int i=OrdersTotal()-2; i>=0; i--){
   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
      if(OrderMagicNumber()==UsrednenieMN){
         OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),NormalizeDouble(tp,Digits),0,Blue);
      }
   }
  }
return(0);
}
//+------------------------------------------------------------------+