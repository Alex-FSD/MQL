//+------------------------------------------------------------------+
//|                                                   TrofiLines.mq4 |
//|                               Copyright © 2010, Evgeniy Trofimov |
//|                           http://www.mql4.com/ru/users/EvgeTrofi |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, Evgeniy Trofimov"
#property link      "http://www.mql4.com/ru/users/EvgeTrofi"
extern bool FixLot=false;     //H1
extern double RiskLot =0.1;
/*
extern int MaxiCanal=700; //600 - 2500
extern int MinLengh=18;    //12  - 30
extern int MinAngle=32;    //20  - 80
*/
                        //M15
extern int MaxiCanal=1300; //600 - 2500
extern int MinLengh=18;    //12  - 30
extern int MinAngle=28;    //20  - 80

extern int MagicNumber=46578;
int Slippage=10;
//+------------------------------------------------------------------+
int start() {
   UpdateValue();
   if(SygnalClose()){
      CloseAllPozitions();
   }
   if(OrdersTotal()>0) return(0);
   int S=SygnalOpen();
   if(S==OP_BUY){
      BUY_pips(ModifyLot(), 0, 0, MagicNumber);
   }else if(S==OP_SELL){
      SELL_pips(ModifyLot(), 0, 0, MagicNumber);
   }
   return(0);
}//start()
//+------------------------------------------------------------------+
double CurrentAngle, CurrentUp;
int CurrentLengh;
void UpdateValue(){
   CurrentAngle=iCustom(Symbol(),0, "Trofimov_Lines 1.4.1",MaxiCanal,MinLengh,4,1);
   CurrentLengh=iCustom(Symbol(),0, "Trofimov_Lines 1.4.1",MaxiCanal,MinLengh,2,1);
   //CurrentUp=iCustom(Symbol(),0, "Trofimov_Lines 1.4.1",MaxiCanal,MinLengh,0,1);
}//UpdateValue()
//+------------------------------------------------------------------+
int SygnalOpen(){
   //Функция возвращает сигнал на открытие позиции:
   //-1 - не открывать позицию
   // 0 - покупать
   // 1 - продавать
   
   if(CurrentAngle>MinAngle && CurrentLengh>MinLengh){
      return(OP_BUY);
   }else if(CurrentAngle<-MinAngle && CurrentLengh>MinLengh){
      return(OP_SELL);
   }
   return(-1);   
}//SygnalOpen()
//+------------------------------------------------------------------+
bool SygnalClose(){
   static datetime LastTime;
   if(LastTime!=Time[0]){
   double LastAngle = iCustom(Symbol(),0, "Trofimov_Lines 1.4.1",MaxiCanal,MinLengh,4,2);
      LastTime=Time[0];
      if(Positive(LastAngle)!=Positive(CurrentAngle)){
         return(true);
      }
   }
   return(false);
}//SygnalClose()
//+------------------------------------------------------------------+
bool Positive(double Value){
   //Возвращает true, если значение положительно.
   if(MathAbs(Value)-Value==0.0){
      return(true);
   }
   return(false);
}//Positive()
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
int SELL_pips(double lt, int sl_pips, int tp_pips, int magic=0) {
   double sl, tp;
   int ticket = -1; //продаём по цене Bid
   int LE=135;
   if(lt<MarketInfo(Symbol(), MODE_MINLOT)) return(0);
   if(lt>MarketInfo(Symbol(), MODE_MAXLOT)) lt=MarketInfo(Symbol(), MODE_MAXLOT);
   if(lt>AccountFreeMargin()*0.90/MarketInfo(Symbol(),MODE_MARGINREQUIRED)) lt=AccountFreeMargin()*0.90/MarketInfo(Symbol(),MODE_MARGINREQUIRED);
   lt = NormalizeDouble(lt, MathAbs(MathLog(MarketInfo(Symbol(), MODE_LOTSTEP))/MathLog(10.0))+0.5);
   while(LE>134 && LE<139) {
      if(sl_pips>0) {
         if(sl_pips<MarketInfo(Symbol(), MODE_STOPLEVEL)) sl_pips=MarketInfo(Symbol(), MODE_STOPLEVEL);
         sl=NormalizeDouble(Bid+sl_pips*Point,Digits);
      }
      if(tp_pips>0) {
         if(tp_pips<MarketInfo(Symbol(), MODE_STOPLEVEL)) tp_pips=MarketInfo(Symbol(), MODE_STOPLEVEL);
         tp=NormalizeDouble(Bid-tp_pips*Point,Digits);
      }
      ticket = OrderSend(Symbol(), OP_SELL, lt, Bid, Slippage, sl, tp, WindowExpertName(), magic, 0, Red); 
      LE = GetLastError();
      Sleep(5000);
      RefreshRates();
   }
   if (ticket > 0) Sleep(10000);
   return(ticket);
}//SELL_pips()
//+------------------------------------------------------------------+
int BUY_pips(double lt, int sl_pips, int tp_pips, int magic=0) {
   double sl, tp;
   int ticket = -1; //покупаем по цене Ask
   int LE=135;
   if(lt<MarketInfo(Symbol(), MODE_MINLOT)) return(0);
   if(lt>MarketInfo(Symbol(), MODE_MAXLOT)) lt=MarketInfo(Symbol(), MODE_MAXLOT);
   if(lt>AccountFreeMargin()*0.90/MarketInfo(Symbol(),MODE_MARGINREQUIRED)) lt=AccountFreeMargin()*0.90/MarketInfo(Symbol(),MODE_MARGINREQUIRED);
   lt = NormalizeDouble(lt, MathAbs(MathLog(MarketInfo(Symbol(), MODE_LOTSTEP))/MathLog(10.0))+0.5);
   while(LE>134 && LE<139) {
      if(sl_pips>0) {
         if(sl_pips<MarketInfo(Symbol(), MODE_STOPLEVEL)) sl_pips=MarketInfo(Symbol(), MODE_STOPLEVEL);
         sl=NormalizeDouble(Ask-sl_pips*Point,Digits);
      }
      if(tp_pips>0) {
         if(tp_pips<MarketInfo(Symbol(), MODE_STOPLEVEL)) tp_pips=MarketInfo(Symbol(), MODE_STOPLEVEL);
         tp=NormalizeDouble(Ask+tp_pips*Point,Digits);
      }
      ticket = OrderSend(Symbol(), OP_BUY, lt, Ask, Slippage, sl, tp, WindowExpertName(), magic, 0, Blue); 
      LE = GetLastError();
      Sleep(5000);
      RefreshRates();
   }
   if (ticket > 0) Sleep(10000);
   return(ticket);
}//BUY_pips()
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
int CloseAllPozitions() {
   int n;
   double PriceClose;
   if(IsTradeAllowed()) {
      int  total = OrdersTotal();
      for (int i = total-1; i >= 0; i--) {
         OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
         if(OrderMagicNumber()==MagicNumber && OrderSymbol()==Symbol()) {
            if(OrderType()==OP_BUY) {
               PriceClose=MarketInfo(OrderSymbol(),MODE_BID);
            } else if(OrderType()==OP_SELL) {
               PriceClose=MarketInfo(OrderSymbol(),MODE_ASK);
            }
            n=0;
            while(IsTradeContextBusy() || !IsConnected()) {
               Sleep(2000);
               n++;
               if(n>9) break;
            }
            if(!OrderClose(OrderTicket(),OrderLots(),PriceClose,Slippage))
               Print("Ставка не закрывается по причине ошибки № ",GetLastError());
         } // Если свой
      } // Next i
   } // Советнику можно торговать
   return(0);
}//CloseAllPozitions()
//+------------------------------------------------------------------+
double ModifyLot(){
   double L;
   if(FixLot){
      return(RiskLot);
   }else{
      L=AccountBalance()/(10000*MarketInfo(Symbol(),MODE_TICKVALUE));
      L=RiskLot*L/100;
      if(L<MarketInfo(Symbol(), MODE_MINLOT)) L=MarketInfo(Symbol(), MODE_MINLOT);
      return(L);
   }
}//ModifyLot
//+------------------------------------------------------------------+


