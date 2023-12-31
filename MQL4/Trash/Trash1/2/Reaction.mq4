//+------------------------------------------------------------------+
//|                                                     Reaction.mq4 |
//|                                               Yuriy Tokman (YTG) |
//|                       https://www.mql5.com/ru/users/satop/seller |
//+------------------------------------------------------------------+
#property copyright "Yuriy Tokman (YTG)"
#property link      "https://www.mql5.com/ru/users/satop/seller"
#property version   "1.00"
#property strict

extern int    TakeProfit = 2;
extern int Lock_Level = 45;
extern double koef_l = 2.0;
extern double TakeProfit_Av = 40;
extern int AV_Level = 5;
extern int OR_Level = 40;
extern double koef_av = 2.0;
//-------+
extern int lot_digits = 1;
extern double Lotos      = 0.1;
extern int    NumberOfTry   = 5;
extern int    Slippage      = 3;
extern int MagicNumber   = 1975;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
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
   int STOPLEVEL = (int)MarketInfo(Symbol(),MODE_STOPLEVEL);
   if(TakeProfit<STOPLEVEL)TakeProfit=STOPLEVEL;
   if(OR_Level<STOPLEVEL)OR_Level=STOPLEVEL;
   double stoplevel = STOPLEVEL*Point;
   int MN_1 = MagicNumber+1;
   int MN_2 = MagicNumber+2;
   double tp = 0;   
//----
   //----+
 double Price_b=-1,Lot_b=-1,Price_s=-1,Lot_s=-1,profit_b = 0,profit_s = 0;
 int Ticket_b = -1, Ticket_s = -1;
 double Price_1=-1,  Lot_1 = -1; int Ticket_1 = -1;double profit_1 = 0;
 double Price_2=-1,  Lot_2 = -1; int Ticket_2 = -1;double profit_2 = 0; 
 for(int cnt=0;cnt<=OrdersTotal()-1;cnt++) {
  if (OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)) {
	if (OrderSymbol()==Symbol()){
	  //----+
	  if(OrderMagicNumber() == MagicNumber) {	   				
	    if ( OrderType()==OP_BUY) {	  	    
	  	      Price_b = OrderOpenPrice();
	  	      Lot_b = OrderLots();
	  	      Ticket_b = OrderTicket();
	  	      profit_b += OrderProfit();  	     	  	     
	  	    }
	    if ( OrderType()==OP_SELL) {	  	    
	  	      Price_s = OrderOpenPrice();
	  	      Lot_s = OrderLots();
	  	      Ticket_s = OrderTicket();
	  	      profit_s += OrderProfit();	  	        	     	  	     
	  	    }
	  	 }
	  //----+
	  if(OrderMagicNumber() == MN_1) 
	   {	   					  	    
	  	 Price_1 = OrderOpenPrice();
	  	 Lot_1 = OrderLots();
	  	 Ticket_1 = OrderTicket();
	  	 profit_1 +=OrderProfit();  	     	  	     
	  	}	  
	  //----+
	  if(OrderMagicNumber() == MN_2) 
	   {	   					  	    
	  	 Price_2 = OrderOpenPrice();
	  	 Lot_2 = OrderLots();
	  	 Ticket_2 = OrderTicket();
	  	 profit_2 +=OrderProfit();  	     	  	     
	  	}	  
	  //----+	  	    	  
	  }
   }
 }
//----+1
  if(profit_b+profit_1 > GetProfitAV(Lotos))
   {
    if(Ticket_b>0 && Ticket_1>0)ClosePosBySelect(Ticket_b);
    ClosePositions(Symbol(), -1, MagicNumber+1);
    DeleteOrders(Symbol(), -1, MagicNumber+1);
   }
  //----+
 if(Ticket_1>0 && Bid-Price_1>AV_Level*Point && CheckVolumeValue(NormalizeDouble(Lot_1*koef_av,lot_digits)))
   SetOrder(Symbol(), OP_SELLSTOP, NormalizeDouble(Lot_1*koef_av,lot_digits), 
            NormalizeDouble(Bid-OR_Level*Point,Digits),0, 0, MagicNumber+1);
  //----+
 if(Ticket_1<0 && Ticket_b>0 && Price_b-Ask>Lock_Level*Point && CheckVolumeValue(NormalizeDouble(Lot_b*koef_l,lot_digits)))
   OpenPosition(NULL, OP_SELL, NormalizeDouble(Lot_b*koef_l,lot_digits), 0, 0, MagicNumber+1);   
  //----+
 if(Ticket_b<0 && CheckVolumeValue(Lotos))
  {
   if (TakeProfit>0) tp=Ask+TakeProfit*Point; else tp=0;
   OpenPosition(NULL, OP_BUY, Lotos, 0, tp, MagicNumber);
  }
//-----+2
  if(profit_s+profit_2 > GetProfitAV(Lotos))
   {
    if(Ticket_s>0 && Ticket_2>0)ClosePosBySelect(Ticket_s);
    ClosePositions(Symbol(), -1, MagicNumber+2);
    DeleteOrders(Symbol(), -1, MagicNumber+2);
   }
  //----+
 if(Ticket_2>0 && Price_2-Ask>AV_Level*Point && CheckVolumeValue(NormalizeDouble(Lot_2*koef_av,lot_digits)))
   SetOrder(Symbol(), OP_BUYSTOP, NormalizeDouble(Lot_2*koef_av,lot_digits), 
            NormalizeDouble(Ask+OR_Level*Point,Digits),0, 0, MagicNumber+2);
  //----+
 if(Ticket_2<0 && Ticket_s>0 && Bid-Price_s>Lock_Level*Point && CheckVolumeValue(NormalizeDouble(Lot_s*koef_l,lot_digits)))
   OpenPosition(NULL, OP_BUY, NormalizeDouble(Lot_s*koef_l,lot_digits), 0, 0, MagicNumber+2);   
  //----+
 if(Ticket_s<0)
  {
   if (TakeProfit>0) tp=Bid-TakeProfit*Point; else tp=0;
   if(CheckVolumeValue(Lotos))OpenPosition(NULL, OP_SELL, Lotos, 0, tp, MagicNumber);
  }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|  Проверяет объем ордера на корректность                          |
//+------------------------------------------------------------------+
bool CheckVolumeValue(double volume)
  {
//--- минимально допустимый объем для торговых операций
   double min_volume=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN);
   if(volume<min_volume)
     {
      //description=StringFormat("Объем меньше минимально допустимого SYMBOL_VOLUME_MIN=%.2f",min_volume);
      return(false);
     }

//--- максимально допустимый объем для торговых операций
   double max_volume=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MAX);
   if(volume>max_volume)
     {
      //description=StringFormat("Объем больше максимально допустимого SYMBOL_VOLUME_MAX=%.2f",max_volume);
      return(false);
     }

//--- получим минимальную градацию объема
   double volume_step=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_STEP);

   int ratio=(int)MathRound(volume/volume_step);
   if(MathAbs(ratio*volume_step-volume)>0.0000001)
     {
      //description=StringFormat("Объем не является кратным минимальной градации SYMBOL_VOLUME_STEP=%.2f, ближайший корректный объем %.2f",
                               //volume_step,ratio*volume_step);
      return(false);
     }
   //description="Корректное значение объема";
   return(true);
  }
//----
void OpenPosition(string sy, int op, double ll, double sl=0, double tp=0, int mn=0) {
  color    clOpen;
  double   pp, pa, pb;
  int      dg, ticket=0;
  string   lsComm="YTG";

  if (sy=="" || sy=="0") sy=Symbol();
  if (op==OP_BUY) clOpen=Lime; else clOpen=Red;
    dg=(int)MarketInfo(sy, MODE_DIGITS);
    pa=MarketInfo(sy, MODE_ASK);
    pb=MarketInfo(sy, MODE_BID);
    if (op==OP_BUY) pp=pa; else pp=pb;
    pp=NormalizeDouble(pp, dg);
      ticket=OrderSend(sy, op, ll, pp, Slippage, sl, tp, lsComm, mn, 0, clOpen);
    if (ticket<0)
     {
      Print("Ask=",pa," Bid=",pb," sy=",sy," ll=",ll," op=",op,
            " pp=",pp," sl=",sl," tp=",tp," mn=",mn);
      Sleep(1000*5);
    }
}
void ClosePosBySelect( int t) {
  bool   fc;
  color  clClose;
  double ll, pa, pb, pp;
  int    err, it;

  if (OrderSelect(t, SELECT_BY_TICKET, MODE_TRADES)) {
    for (it=1; it<=5; it++) {
      if (!IsTesting() && (!IsExpertEnabled() || IsStopped())) break;
      while (!IsTradeAllowed()) Sleep(5000);
      RefreshRates();
      pa=NormalizeDouble(MarketInfo(OrderSymbol(), MODE_ASK),Digits);
      pb=NormalizeDouble(MarketInfo(OrderSymbol(), MODE_BID),Digits);
      if (OrderType()==OP_BUY) {
        pp=pb; clClose=Aqua;
      } else {
        pp=pa; clClose=Gold;
      }
      ll=OrderLots();
      fc=OrderClose(OrderTicket(), ll, pp, Slippage, clClose);
      if (fc) {
        PlaySound("tick"); break;
      } else {
        err=GetLastError();
        if (err==146) while (IsTradeContextBusy()) Sleep(1000*11);
        Print("Error(",err,") Close ",OrderType()," ",", try ",it);
        Print(OrderTicket(),"  Ask=",pa,"  Bid=",pb,"  pp=",pp);
        Print("sy=",OrderSymbol(),"  ll=",ll,"  sl=",OrderStopLoss(),
              "  tp=",OrderTakeProfit(),"  mn=",OrderMagicNumber());
        Sleep(1000*5);
      }
    }
  } else Print("Incorrect trade operation. Close ",OrderType());
}
 double GetProfitAV(double l)
  {
   int vDigits =Digits;double vMn = 100;
   if (vDigits==3 || vDigits >= 5) vMn = 1000;
   double p = l*1000*TakeProfit_Av/vMn;
   return(p);  
  }
void ClosePositions(string sy="", int op=-1, int mn=-1) {
  int i, k=OrdersTotal();

  if (sy=="0") sy=Symbol();
  for (i=k-1; i>=0; i--) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      if ((OrderSymbol()==sy || sy=="") && (op<0 || OrderType()==op)) {
        if (OrderType()==OP_BUY || OrderType()==OP_SELL) {
          if (mn<0 || OrderMagicNumber()==mn) ClosePosBySelect(OrderTicket());
        }
      }
    }
  }
}
void SetOrder(string sy, int op, double ll, double pp,
              double sl=0, double tp=0, int mn=0, datetime ex=0) {
  color    clOpen;
  datetime ot;
  double   pa, pb, mp;
  int      err, it, ticket, msl, opp;
  string   lsComm="YTG";
  if (sy=="" || sy=="0") sy=Symbol();
  msl=(int)MarketInfo(sy, MODE_STOPLEVEL);
    if (op==OP_BUYLIMIT || op==OP_BUYSTOP) {clOpen=Lime; opp=OP_BUY;}
  else {clOpen=Red; opp=OP_SELL;} 
  if (ex>0 && ex<TimeCurrent()) ex=0;
  for (it=1; it<=5; it++) {
    if (!IsTesting() && (!IsExpertEnabled() || IsStopped())) {
      Print("SetOrder(): Stop");
      break;
    }
    while (!IsTradeAllowed()) Sleep(5000);
    RefreshRates();
    ot=TimeCurrent();
//----+
    if(AccountFreeMarginCheck(Symbol(),opp, ll)<=0 || GetLastError()==134) 
    {Alert(WindowExpertName()+" "+Symbol()," "," ","For opening a position ",op,", Lots=",ll,
    ", The free means do not suffice.");return;}    
//----+
    ticket=OrderSend(sy, op, ll, pp, Slippage, sl, tp, lsComm, mn, ex, clOpen);
    if (ticket>0){PlaySound("ok"); break;}
    else {
      err=GetLastError();
      if (err==128 || err==142 || err==143) {
        Sleep(1000*66);
        if (ExistOrders(sy, op, mn, ot)){PlaySound("alert2"); break;}
        Print("Error(",err,") set order: ",err,", try ",it);
        continue;
      }
      mp=MarketInfo(sy, MODE_POINT);
      pa=MarketInfo(sy, MODE_ASK);
      pb=MarketInfo(sy, MODE_BID);
      //
      if (err==130) {
        switch (op) {
          case OP_BUYLIMIT:
            if (pp>pa-msl*mp) pp=pa-msl*mp;
            if (sl>pp-(msl+1)*mp) sl=pp-(msl+1)*mp;
            if (tp>0 && tp<pp+(msl+1)*mp) tp=pp+(msl+1)*mp;
            break;
          case OP_BUYSTOP:
            if (pp<pa+(msl+1)*mp) pp=pa+(msl+1)*mp;
            if (sl>pp-(msl+1)*mp) sl=pp-(msl+1)*mp;
            if (tp>0 && tp<pp+(msl+1)*mp) tp=pp+(msl+1)*mp;
            break;
          case OP_SELLLIMIT:
            if (pp<pb+msl*mp) pp=pb+msl*mp;
            if (sl>0 && sl<pp+(msl+1)*mp) sl=pp+(msl+1)*mp;
            if (tp>pp-(msl+1)*mp) tp=pp-(msl+1)*mp;
            break;
          case OP_SELLSTOP:
            if (pp>pb-msl*mp) pp=pb-msl*mp;
            if (sl>0 && sl<pp+(msl+1)*mp) sl=pp+(msl+1)*mp;
            if (tp>pp-(msl+1)*mp) tp=pp-(msl+1)*mp;
            break;
        }
        Print("SetOrder(): The price levels are corrected");
      }
      Print("Error(",err,") set order: ",err,", try ",it);
      Print("Ask=",pa,"  Bid=",pb,"  sy=",sy,"  ll=",ll,"  op=",op,
            "  pp=",pp,"  sl=",sl,"  tp=",tp,"  mn=",mn);
      if (pa==0 && pb==0) Print("SetOrder(): Check up in the review of the market presence of a symbol "+sy);
      // 
      if (err==4 || err==131 || err==132) {
        Sleep(1000*300); break;
      }
      // 
      if (err==8 || err==141) Sleep(1000*100);
      if (err==139 || err==140 || err==148) break;
      // 
      if (err==146) while (IsTradeContextBusy()) Sleep(1000*11);
      // 
      if (err==147) {
        ex=0; continue;
      }
      if (err!=135 && err!=138) Sleep(1000*7.7);
    }
  }
}
bool ExistOrders(string sy="", int op=-1, int mn=-1, datetime ot=0) {
  int i, k=OrdersTotal(), ty;
 
  if (sy=="0") sy=Symbol();
  for (i=0; i<k; i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      ty=OrderType();
      if (ty>1 && ty<6) {
        if ((OrderSymbol()==sy || sy=="") && (op<0 || ty==op)) {
          if (mn<0 || OrderMagicNumber()==mn) {
            if (ot<=OrderOpenTime()) return(true);
          }
        }
      }
    }
  }
  return(false);
}
void DeleteOrders(string sy="", int op=-1, int mn=-1) {
  bool fd;
  int err, i, it, k=OrdersTotal(), ot;
  
  if (sy=="0") sy=Symbol();
  for (i=k-1; i>=0; i--) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      ot=OrderType();
      if (ot>1 && ot<6) {
        if ((OrderSymbol()==sy || sy=="") && (op<0 || ot==op)) {
          if (mn<0 || OrderMagicNumber()==mn) {
            for (it=1; it<=5; it++) {
              if (!IsTesting() && (!IsExpertEnabled() || IsStopped())) break;
              while (!IsTradeAllowed()) Sleep(5000);
              fd=OrderDelete(OrderTicket(), White);
              if (fd) {
                PlaySound("timeout"); break;
              } else {
                err=GetLastError();
                Print("Error(",err,") delete order ",ot,
                      ": ",err,", try ",it);
                Sleep(1000*5);
              }
            }
          }
        }
      }
    }
  }
}