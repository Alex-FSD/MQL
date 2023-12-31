//+------------------------------------------------------------------+
//|                                                        Masha.mq4 |
//|                                               Yuriy Tokman (YTG) |
//|                                               https://ytg.com.ua |
//+------------------------------------------------------------------+
#property copyright "Yuriy Tokman (YTG)"
#property link      "https://ytg.com.ua"
#property version   "1.00"
#property strict

input int    StopLoss        = 100;
input int    TakeProfit      = 150;
input double Lot             = 0.1;
input double factor          = 1.0;
input int    additional      = 5;
input int    distance        = 22;
input double profit_currency = 1;
input int    period_MA1      = 5;
input int    period_MA2      = 12;
input int    shift           = 1;
input int    magic_number    = 2808;
input int    TStop           = 40;
input int    TrailingStep    = 5;

bool   TSProfitOnly  = true;
string txt           = "ytg.com.ua";
bool   UseSound      = True;
string NameFileSound = "expert.wav";
bool   MarketWatch   = True;
int    Slippage      = 30;
int    NumberOfTry   = 5;
bool   gbDisabled    = False;
color  clOpenBuy     = LightBlue;
color  clOpenSell    = LightCoral;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   double sl,tp,ll=Lot;
//---
   double tp_buy=0,tp_sell=0;
   double l_buy=0,l_sell=0;
   int op_buy=0,op_sell=0;
   double sl_buy=0,sl_sell=0,p_sell=0,p_buy=0,pf_buy=0,pf_sell=0;

   for(int cnt=0;cnt<=OrdersTotal()-1;cnt++)
     {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol())
           {
            if(OrderMagicNumber()==magic_number)
              {
               if(OrderType()==OP_BUY)
                 {
                  op_buy++;
                  sl_buy = OrderStopLoss();
                  tp_buy = OrderTakeProfit();
                  l_buy=OrderLots();
                  p_buy=OrderOpenPrice();
                  pf_buy+=OrderProfit()+OrderSwap()+OrderCommission();
                 }
               //-----	  
               if(OrderType()==OP_SELL)
                 {
                  op_sell++;
                  sl_sell = OrderStopLoss();
                  tp_sell = OrderTakeProfit();
                  l_sell=OrderLots();
                  p_sell=OrderOpenPrice();
                  pf_sell+=OrderProfit()+OrderSwap()+OrderCommission();
                 }
               //----
               //----
              }
           }
        }
     }
//+------------------------------------------------------------------+
  SimpleTrailing(Symbol(),-1,magic_number);
//+------------------------------------------------------------------+

   if(profit_currency>0 && pf_buy>=profit_currency && op_buy>1)
     {
      ClosePositions(Symbol(),OP_BUY,magic_number);
      return;
     }

   if(profit_currency>0 && pf_sell>=profit_currency && op_sell>1)
     {
      ClosePositions(Symbol(),OP_SELL,magic_number);
      return;
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(GetSignal()>0)//buy
     {
      if(op_buy<1)
        {
         if(NewBarB())
           {
            if(StopLoss>0)  sl = NormalizeDouble(Bid - StopLoss  *Point,Digits); else sl=0;
            if(TakeProfit>0)tp = NormalizeDouble(Ask + TakeProfit*Point,Digits); else tp=0;
            OpenPosition(Symbol(),OP_BUY,ll,sl,tp,magic_number,txt);
            return;
           }
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(GetSignal()<0)
     {
      if(op_sell<1)
        {
         if(NewBarS())
           {
            if(StopLoss>0)  sl = NormalizeDouble(Ask + StopLoss  *Point,Digits); else sl=0;
            if(TakeProfit>0)tp = NormalizeDouble(Bid - TakeProfit*Point,Digits); else tp=0;
            OpenPosition(Symbol(),OP_SELL,ll,sl,tp,magic_number,txt);
            return;
           }
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(op_buy>0 && op_buy<additional && MathAbs(p_buy-Ask)>=distance*Point && GetSignal()>0)
     {
      if(NewBarB())
        {
         if(StopLoss>0)  sl = NormalizeDouble(Bid - StopLoss  *Point,Digits); else sl=0;
         if(TakeProfit>0)tp = NormalizeDouble(Ask + TakeProfit*Point,Digits); else tp=0;
         OpenPosition(Symbol(),OP_BUY,NormalizeDouble(l_buy*factor,LotPoint()),sl,tp,magic_number);
         return;
        }
     }

   if(op_sell>0 && op_sell<additional && MathAbs(Bid-p_sell)>=distance*Point && GetSignal()<0)
     {
      if(NewBarS())
        {
         if(StopLoss>0)  sl = NormalizeDouble(Ask + StopLoss  *Point,Digits); else sl=0;
         if(TakeProfit>0)tp = NormalizeDouble(Bid - TakeProfit*Point,Digits); else tp=0;
         OpenPosition(Symbol(),OP_SELL,NormalizeDouble(l_sell*factor,LotPoint()),sl,tp,magic_number);
         return;
        }
     }
//---  
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
 int GetSignal()
  {
   
//---      
   double ma_fast0= iMA(Symbol(),0,period_MA1,0,MODE_EMA,PRICE_CLOSE,shift);
   double ma_fast1= iMA(Symbol(),0,period_MA1,0,MODE_EMA,PRICE_CLOSE,shift+1);
   double ma_slow0= iMA(Symbol(),0,period_MA2,0,MODE_EMA,PRICE_CLOSE,shift);
   double ma_slow1= iMA(Symbol(),0,period_MA2,0,MODE_EMA,PRICE_CLOSE,shift+1);
   
   if(ma_fast1<ma_slow1 && ma_fast0>ma_slow1)return(1);
   if(ma_fast1>ma_slow1 && ma_fast0<ma_slow1)return(-1);   
//---
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

bool ClosePosBySelect(int _ti=0) 
  {
   bool   fc;
   color  clClose;
   double ll,pa,pb,pp;
   int    err,it;

   if(OrderSelect(_ti,SELECT_BY_TICKET))
     {
      if(OrderType()==OP_BUY || OrderType()==OP_SELL) 
        {
         for(it=1; it<=NumberOfTry; it++) 
           {
            if(!IsTesting() && (!IsExpertEnabled() || IsStopped())) break;
            while(!IsTradeAllowed()) Sleep(5000);
            RefreshRates();
            pa=MarketInfo(OrderSymbol(), MODE_ASK);
            pb=MarketInfo(OrderSymbol(), MODE_BID);
            if(OrderType()==OP_BUY) 
              {
               pp=pb; clClose=Lime;
                 } else {
               pp=pa; clClose=Red;
              }
            ll=OrderLots();
            fc=OrderClose(OrderTicket(), ll, pp, Slippage, clClose);
            if(fc) 
              {
               if(UseSound) PlaySound(NameFileSound); return(true);
                 } else {
               err=GetLastError();
               if(err==146) while(IsTradeContextBusy()) Sleep(1000*11);
               Print("Error(",err,") Close ",GetNameOP(OrderType())," ",
                     err,", try ",it);
               Print(OrderTicket(),"  Ask=",pa,"  Bid=",pb,"  pp=",pp);
               Print("sy=",OrderSymbol(),"  ll=",ll,"  sl=",OrderStopLoss(),
                     "  tp=",OrderTakeProfit(),"  mn=",OrderMagicNumber());
               Sleep(1000*5);
              }
           }
        }
      else Print("Некорректная торговая операция. Close ",GetNameOP(OrderType()));
     }
   return(false);
  }
//----
void ClosePositions(string sy="",int op=-1,int mn=-1) 
  {
   int i,k=OrdersTotal();

   if(sy=="0") sy=Symbol();
   for(i=k-1; i>=0; i--) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) 
        {
         if((OrderSymbol()==sy || sy=="") && (op<0 || OrderType()==op)) 
           {
            if(OrderType()==OP_BUY || OrderType()==OP_SELL) 
              {
               if(mn<0 || OrderMagicNumber()==mn) ClosePosBySelect(OrderTicket());
              }
           }
        }
     }
  }
//---- 
//---- 
bool ExistPositions(string sy="",int op=-1,int mn=-1,datetime ot=0) 
  {
   int i,k=OrdersTotal();

   if(sy=="0") sy=Symbol();
   for(i=0; i<k; i++) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) 
        {
         if(OrderSymbol()==sy || sy=="") 
           {
            if(OrderType()==OP_BUY || OrderType()==OP_SELL) 
              {
               if(op<0 || OrderType()==op) 
                 {
                  if(mn<0 || OrderMagicNumber()==mn) 
                    {
                     if(ot<=OrderOpenTime()) return(True);
                    }
                 }
              }
           }
        }
     }
   return(False);
  }
//----
//+----------------------------------------------------------------------------+
string GetNameOP(int op) 
  {
   switch(op) 
     {
      case OP_BUY      : return("Buy");
      case OP_SELL     : return("Sell");
      case OP_BUYLIMIT : return("Buy Limit");
      case OP_SELLLIMIT: return("Sell Limit");
      case OP_BUYSTOP  : return("Buy Stop");
      case OP_SELLSTOP : return("Sell Stop");
      default          : return("Unknown Operation");
     }
  }
//+----------------------------------------------------------------------------+
string GetNameTF(int TimeFrame=0) 
  {
   if(TimeFrame==0) TimeFrame=Period();
   switch(TimeFrame) 
     {
      case PERIOD_M1:  return("M1");
      case PERIOD_M5:  return("M5");
      case PERIOD_M15: return("M15");
      case PERIOD_M30: return("M30");
      case PERIOD_H1:  return("H1");
      case PERIOD_H4:  return("H4");
      case PERIOD_D1:  return("Daily");
      case PERIOD_W1:  return("Weekly");
      case PERIOD_MN1: return("Monthly");
      default:         return("UnknownPeriod");
     }
  }
//+----------------------------------------------------------------------------+
void Message(string m) 
  {
   Comment(m);
   if(StringLen(m)>0) Print(m);
  }
//+----------------------------------------------------------------------------+
void ModifyOrder(double pp=-1,double sl=0,double tp=0,datetime ex=0) 
  {
   bool   fm;
   double op,pa,pb,os,ot;
   int    dg=(int)MarketInfo(OrderSymbol(),MODE_DIGITS);
   int er,it;

   if(pp<=0) pp=OrderOpenPrice();
   if(sl<0 ) sl=OrderStopLoss();
   if(tp<0 ) tp=OrderTakeProfit();

   pp=NormalizeDouble(pp, dg);
   sl=NormalizeDouble(sl, dg);
   tp=NormalizeDouble(tp, dg);
   op=NormalizeDouble(OrderOpenPrice() , dg);
   os=NormalizeDouble(OrderStopLoss()  , dg);
   ot=NormalizeDouble(OrderTakeProfit(), dg);

   if(pp!=op || sl!=os || tp!=ot) 
     {
      for(it=1; it<=NumberOfTry; it++) 
        {
         if(!IsTesting() && (!IsExpertEnabled() || IsStopped())) break;
         while(!IsTradeAllowed()) Sleep(5000);
         RefreshRates();
         fm=OrderModify(OrderTicket(),pp,sl,tp,ex);
         if(fm) 
           {
            if(UseSound) PlaySound(NameFileSound); break;
              } else {
            er=GetLastError();
            pa=MarketInfo(OrderSymbol(), MODE_ASK);
            pb=MarketInfo(OrderSymbol(), MODE_BID);
            Print("Error(",er,") modifying order: ",er,", try ",it);
            Print("Ask=",pa,"  Bid=",pb,"  sy=",OrderSymbol(),
                  "  op="+GetNameOP(OrderType()),"  pp=",pp,"  sl=",sl,"  tp=",tp);
            Sleep(1000*10);
           }
        }
     }
  }
//+----------------------------------------------------------------------------+
void OpenPosition(string sy,int op,double ll,double sl=0,double tp=0,int mn=0,string comment="") 
  {
   color    clOpen;
   datetime ot;
   double   pp,pa,pb;
   int      dg,err,it,ticket=0;
   string   lsComm=comment;//WindowExpertName()+" "+GetNameTF(Period());

   if(sy=="" || sy=="0") sy=Symbol();
   if(op==OP_BUY) clOpen=clOpenBuy; else clOpen=clOpenSell;
   for(it=1; it<=NumberOfTry; it++) 
     {
      if(!IsTesting() && (!IsExpertEnabled() || IsStopped())) 
        {
         Print("OpenPosition(): Остановка работы функции");
         break;
        }
      while(!IsTradeAllowed()) Sleep(5000);
      RefreshRates();
      dg=(int)MarketInfo(sy, MODE_DIGITS);
      pa=MarketInfo(sy, MODE_ASK);
      pb=MarketInfo(sy, MODE_BID);
      if(op==OP_BUY) pp=pa; else pp=pb;
      pp=NormalizeDouble(pp, dg);
      ot=TimeCurrent();
      //----+
      if(AccountFreeMarginCheck(Symbol(),op,ll)<=0 || GetLastError()==134)
        {
         return;
        }   
      //----+ 
      if(MarketWatch)
         ticket=OrderSend(sy,op,ll,pp,Slippage,0,0,lsComm,mn,0,clOpen);
      else
         ticket=OrderSend(sy,op,ll,pp,Slippage,sl,tp,lsComm,mn,0,clOpen);
      if(ticket>0) 
        {
         if(UseSound) PlaySound(NameFileSound); break;
           } else {
         err=GetLastError();
         if(pa==0 && pb==0) Message("Проверьте в Обзоре рынка наличие символа "+sy);
         // Вывод сообщения об ошибке
         Print("Error(",err,") opening position: ",err,", try ",it);
         Print("Ask=",pa," Bid=",pb," sy=",sy," ll=",ll," op=",GetNameOP(op),
               " pp=",pp," sl=",sl," tp=",tp," mn=",mn," com=",lsComm);
         // Блокировка работы советника
         if(err==2 || err==64 || err==65 || err==133) 
           {
            gbDisabled=True; break;
           }
         // Длительная пауза
         if(err==4 || err==131 || err==132) 
           {
            Sleep(1000*300); break;
           }
         if(err==128 || err==142 || err==143) 
           {
            Sleep(1000*66.666);
            if(ExistPositions(sy,op,mn,ot)) 
              {
               if(UseSound) PlaySound(NameFileSound); break;
              }
           }
         if(err==140 || err==148 || err==4110 || err==4111) break;
         if(err==141) Sleep(1000*100);
         if(err==145) Sleep(1000*17);
         if(err==146) while(IsTradeContextBusy()) Sleep(1000*11);
         if(err!=135) Sleep(1000*7.7);
        }
     }
   if(MarketWatch && ticket>0 && (sl>0 || tp>0)) 
     {
      if(OrderSelect(ticket,SELECT_BY_TICKET)) ModifyOrder(-1,sl,tp);
     }
  }
//---
bool NewBarB(int TF=0)
  {
   static datetime NewTime=0;
   if(NewTime!=iTime(Symbol(),TF,0))
     {
      NewTime=iTime(Symbol(),TF,0);
      return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool NewBarS(int TF=0)
  {
   static datetime NewTime=0;
   if(NewTime!=iTime(Symbol(),TF,0))
     {
      NewTime=iTime(Symbol(),TF,0);
      return(true);
     }
   return(false);
  }
//----
void SimpleTrailing(string sy="", int op=-1, int mn=-1) {
  double po, pp;
  int    i, k=OrdersTotal();

  if (sy=="0") sy=Symbol();
  for (i=0; i<k; i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      if ((OrderSymbol()==sy || sy=="") && (op<0 || OrderType()==op)) {
        po=MarketInfo(OrderSymbol(), MODE_POINT);
        if (mn<0 || OrderMagicNumber()==mn) {
          if (OrderType()==OP_BUY) {
            pp=MarketInfo(OrderSymbol(), MODE_BID);
            if (!TSProfitOnly || pp-OrderOpenPrice()>TStop*po) {
              if (OrderStopLoss()<pp-(TStop+TrailingStep-1)*po) {
                ModifyOrder(-1, pp-TStop*po, -1);
              }
            }
          }
          if (OrderType()==OP_SELL) {
            pp=MarketInfo(OrderSymbol(), MODE_ASK);
            if (!TSProfitOnly || OrderOpenPrice()-pp>TStop*po) {
              if (OrderStopLoss()>pp+(TStop+TrailingStep-1)*po || OrderStopLoss()==0) {
                ModifyOrder(-1, pp+TStop*po, -1);
              }
            }
          }
        }
      }
    }
  }
}
//-----
int LotPoint()
{
 double steplot = MarketInfo(Symbol(),MODE_LOTSTEP);
 int LotsDigits = (int)MathCeil(MathAbs(MathLog(steplot)/MathLog(10)));
 return(LotsDigits);
}
//----
