#property copyright "FORTRADER.RU, Юрий, ftyuriy@gmail.com, modified by Evgeniy Trofimov"
#property link      "http://FORTRADER.RU, Price"
//+------------------------------------------------------------------+
extern int pips=250;
extern int profitpips=250;
extern double Lots=0.01;
extern double LimitLot=20.00;
extern int time=0; //1 - включено, 0 - выключено.
extern int starttime = 7; 
extern int stoptime = 17; 
//+------------------------------------------------------------------+
static datetime LastTime;
static int Slippage=30;
//+------------------------------------------------------------------+
int timecontrol() {
   if ( ( (Hour()>=0 && Hour()<=stoptime-1) ||  (Hour()>=starttime && Hour()<=23)) && starttime>stoptime) {
      return(1);
   }  
   if ( (Hour()>=starttime && Hour()<=stoptime-1) && starttime<stoptime) {
      return(1);
   }  
   if(time==0){ return(1);}
   return(0);
}//timecontrol()
//+------------------------------------------------------------------+
int SL=0;
int TP=0;
int err;
int start() {
   if(LastTime==Time[0]) return(0);
   LastTime=Time[0];   
   if(timecontrol()==1) {
      if(!OrdersExist()) {
         err=OpenNewOrders();
      }else{
         TrailStopOrders();
      }
      if(CountPos(0)==0 && CountPos(1)==0 && ChStopPosLimitSumm()<2){
         _DeleteOrder();
      }
      if(ChStopPosLimitSumm()<1){
         if(GetMaxLot()*2>LimitLot){
            _DeleteOrder();
            CloseAllPozitions();
         } else {
            DopOrder(GetMaxLot()*2);
         }
      }
      err=CloseManager();
   }
   return(0);
}//start()
//+------------------------------------------------------------------+
double op,sl,tp;
int OpenNewOrders(){
   int err;
   op=Ask-pips*Point;if(SL>0){sl=Ask;}else{sl=0;}if(TP>0){tp=op-TP*Point;}else{tp=0;}
   err=OrderSend(Symbol(),OP_SELLSTOP,Lots,NormalizeDouble(op,Digits),3,NormalizeDouble(sl,Digits),NormalizeDouble(tp,Digits),"",0,0,Red);
   if(err<0){
      Print("OrderSend()-  Ошибка OP_SELLSTOP.  op "+op+" sl "+sl+" tp "+tp+" "+GetLastError());return(-1);
      LastTime=Time[1];
   }
   op=Bid+pips*Point;if(SL>0){sl=Bid;}else{sl=0;}if(TP>0){tp=op+TP*Point;}else{tp=0;}
   err=OrderSend(Symbol(),OP_BUYSTOP,Lots,NormalizeDouble(op,Digits),3,NormalizeDouble(sl,Digits),NormalizeDouble(tp,Digits),"",0,0,Red);
   if(err<0){
      Print("OrderSend()-  Ошибка OP_BUYSTOP.  op "+op+" sl "+sl+" tp "+tp+" "+GetLastError());return(-1);
      LastTime=Time[1];
   }
   return(err);
}//OpenNewOrders()
//+------------------------------------------------------------------+
int TrailStopOrders() {
   int i;bool err;
   for(i=1; i<=OrdersTotal(); i++) {
      if(OrderSelect(i-1,SELECT_BY_POS)==true) {  
         if( OrderType()==OP_BUYSTOP && OrderSymbol()==Symbol() && (OrderOpenPrice()-Bid)>pips*Point) {
            err=OrderModify(OrderTicket(),Bid+pips*Point,OrderStopLoss(),OrderTakeProfit(),0,Green);
            if(err==false){
               LastTime=Time[1];
               return(-1);
            }
         }//if(OrderType()==OP_BUYSTOP
      }//if(OrderSelect(i-1,SEL
      if(OrderSelect(i-1,SELECT_BY_POS)==true) {
         if(OrderType()==OP_SELLSTOP && OrderSymbol()==Symbol() && (Ask-OrderOpenPrice())>pips*Point) {
            err=OrderModify(OrderTicket(),Ask-pips*Point,OrderStopLoss(),OrderTakeProfit(),0,Green);
            if(err==false){
               LastTime=Time[1];
               return(-1);
            }
         }//if(OrderType()==OP_SELLSTOP 
      }//if(OrderSelect(i-1,
   }// for( i=1; i<=O
   return(0);
}//TrailStopOrders()
//+------------------------------------------------------------------+
int CountPos(int type) {
   int i,b,s;
   for( i=1; i<=OrdersTotal(); i++) {
      if(OrderSelect(i-1,SELECT_BY_POS)==true) {                                   
         if(OrderType()==OP_BUY && OrderSymbol()==Symbol()){b=b+1;}
         if(OrderType()==OP_SELL && OrderSymbol()==Symbol()){s=s+1;}
      }
   }   
   if(type==0){return(s);}
   if(type==1){return(b);}
}//CountPos()
//+------------------------------------------------------------------+
int ChStopPosLimitSumm() {
   int i,z;
   for( i=1; i<=OrdersTotal(); i++) {
      if(OrderSelect(i-1,SELECT_BY_POS)==true) {                                   
         if(OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP ){z=z+1;}
      }
   }   
   return(z);
}//ChStopPosLimitSumm()
//+------------------------------------------------------------------+
int _DeleteOrder() {
   //Удаление всех отложенных ордеров
   for(int i=1; i<=OrdersTotal(); i++) {
      if(OrderSelect(i-1,SELECT_BY_POS)==true) {
         if(OrderType()>3 && OrderSymbol()==Symbol()) {
            OrderDelete(OrderTicket()); 
         }//if
      }//if
   }//Next i
   return(0);
}//_DeleteOrder()
//+------------------------------------------------------------------+
int CloseManager() {
   //Закрытие всех позиций и отложенных ордеров,
   //если в сделке с максимальным лотом величина
   //профитных пунктов достигла указанной границы
   int err;
   double maxlot=GetMaxLot();
   for(int i=1; i<=OrdersTotal(); i++) {
      if(OrderSelect(i-1,SELECT_BY_POS)) {
         if(OrderSymbol()==Symbol()) {
            if(OrderLots()==maxlot) {
               if(OrderType()==OP_SELL && ((OrderOpenPrice()-Ask)>profitpips*Point)) {
                  _DeleteOrder();
                  CloseAllPozitions();
               }//if
               if(OrderType()==OP_BUY && ((Bid-OrderOpenPrice())>profitpips*Point)) {
                  _DeleteOrder();
                  CloseAllPozitions();
               }//if
            }//if(OrderLots()==maxlot)
         }//if(OrderSymbol()==Symbol())
      }//if
   }//Next i
   return(err);
}//CloseManager()
//+------------------------------------------------------------------+
double GetMaxLot() {
   //Функция возвращает размер максимального лота,
   //найденного среди открытых позиций
   int i; double maxlot;
   for(i=1; i<=OrdersTotal(); i++) {
      if(OrderSelect(i-1,SELECT_BY_POS)) {                                   
         if(OrderType()<2 && OrderSymbol()==Symbol()) {
            if(maxlot<OrderLots()) {
               maxlot=OrderLots();
            }
         }
      }
   }   
   return(maxlot);
}//GetMaxLot()
//+------------------------------------------------------------------+
int GetLastTypePos() {
//Функция возвращает тип последней открытой позиции
   int i; datetime dt; int type;
   for( i=1; i<=OrdersTotal(); i++) {
      if(OrderSelect(i-1,SELECT_BY_POS)==true) {                                   
         if(OrderType()<2 && OrderSymbol()==Symbol()) {
            if(dt<OrderOpenTime()){
               dt=OrderOpenTime();
               type=OrderType();
            }
         }
      }//
   }//Next i
   return(type);
}//GetLastTypePos()
//+------------------------------------------------------------------+
int DopOrder(double Lots) {
   //Функция выставляет отложенный ордер, на продажу, 
   //если последняя открытая сделка - покупает
   //и наоборот
   int type=GetLastTypePos();
   if(type==OP_SELL){
      op=Bid+pips*Point;
      if(SL>0){sl=Bid;}         else {sl=0;}
      if(TP>0){tp=op+TP*Point;} else {tp=0;}
      err=OrderSend(Symbol(),OP_BUYSTOP,Lots,NormalizeDouble(op,Digits),3,NormalizeDouble(sl,Digits),NormalizeDouble(tp,Digits),"FORTRADER.RU",0,0,Red);
      if(err<0){
         LastTime=Time[1];
         Print("OrderSend()-  Ошибка OP_BUYSTOP.  op "+op+" sl "+sl+" tp "+tp+" "+GetLastError());
         return(-1);
      }
   } else if(type==OP_BUY) {
      op=Ask-pips*Point;
      if(SL>0){sl=Ask;}         else {sl=0;}
      if(TP>0){tp=op-TP*Point;} else {tp=0;}
      err=OrderSend(Symbol(),OP_SELLSTOP,Lots,NormalizeDouble(op,Digits),3,NormalizeDouble(sl,Digits),NormalizeDouble(tp,Digits),"FORTRADER.RU",0,0,Red);
      if(err<0){
         LastTime=Time[1];
         Print("OrderSend()-  Ошибка OP_SELLSTOP.  op "+op+" sl "+sl+" tp "+tp+" "+GetLastError());
         return(-1);
      }
   }
   return(0);
}//DopOrder()
//+------------------------------------------------------------------+
int CloseAllPozitions() {
   double PriceClose;
   int  total = OrdersTotal();
   for (int i = total-1; i >= 0; i--) {
      OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if(OrderSymbol()==Symbol()) {
         if(OrderType()==OP_BUY) {
            PriceClose=Bid;
         } else if(OrderType()==OP_SELL) {
            PriceClose=Ask;
         }
         if(!OrderClose(OrderTicket(),OrderLots(),PriceClose,Slippage)) {
            Print("Ставка ",OrderTicket()," не закрывается по причине ошибки № ",GetLastError());
            LastTime=Time[1];
         }
      } // Если свой
   } // Next i
   return(0);
}//CloseAllPozitions()
//+------------------------------------------------------------------+
bool OrdersExist() {
   //Функция возвращает true, если количество ордеров на текущем инструменте > 0
   int total = OrdersTotal();
   for (int i = 0; i < total; i++) {
      OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol()) {
         return(true);
      }
   }
   return(false);
}//OpenLots()
//+------------------------------------------------------------------+

