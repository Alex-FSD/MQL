//+------------------------------------------------------------------+
//|                                                  Quantum 103.mq4 |
//|                                               Yuriy Tokman (YTG) |
//|                                               http://ytg.com.ua/ |
//+------------------------------------------------------------------+
#property copyright "Yuriy Tokman (YTG)"
#property link      "http://ytg.com.ua/"
#property version   "1.00"
#property strict

input bool TimeCLOSE = false;
input int TIME_HOUR_STOP = 23;
input int TIME_MINUTE_STOP = 59;
input int TIME_HOUR_START = 00;
input int TIME_MINUTE_START = 01;
input int BuyStop_count = 5;
input int BuyLimit_count = 5;
input int SellStop_count = 5;
input int SellLimit_count = 5;
input int Step = 10;
input bool StopLoss_overall = false;
input double Buy_StopLoss = 1.12;
input double Sell_StopLoss = 1.19;
input int StopLoss = 250;

input int TakeProfit = 10;
input double LOT = 0.1;
input int    Slippage      = 30;

input bool Tralling = false;
bool TSProfitOnly = true;
input int TralingStart = 10;
input int TrailingStep = 1;

input double Profit_currency = 0.1;
input int MagicNumber = 350;

bool  gbDisabled = False;
color clOpenBuy  = LightBlue;
color clOpenSell = LightCoral;
datetime TimeStart =0;
bool staste = false;
bool STOPE = false;
string sname = "";
bool close=false;
double BufA[];
double BufB[];
double BufC[];
double BufD[];

double BufUP[];
double BufDN[];
int leveUP,leveDN;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   leveUP = BuyStop_count + SellLimit_count;
   leveDN = BuyLimit_count + SellStop_count;
   ArrayResize(BufUP,leveUP);
   ArrayResize(BufDN,leveDN);

   ArrayResize(BufA,BuyStop_count);
   ArrayResize(BufB,BuyLimit_count);
   ArrayResize(BufC,SellStop_count);
   ArrayResize(BufD,SellLimit_count);   
   
  double lv=0;

  while(lv<Bid)
   {
    lv+=Step*GetPoint();
   }
  
  for(int i=0; i<BuyStop_count;i++)BufA[i]=lv+i*Step*GetPoint();
  for(int i=0; i<SellLimit_count;i++)BufD[i]=lv+i*Step*GetPoint(); 
  for(int i=0; i<BuyLimit_count;i++)BufB[i]=lv-(i+1)*Step*GetPoint();  
  for(int i=0; i<SellStop_count;i++)BufC[i]=lv-(i+1)*Step*GetPoint();      
//---
   staste = true;
   STOPE = false;
   TimeStart = TimeCurrent();
   sname = "q4_"+Symbol();   
   Button(sname+"_CLOSE",clrDimGray,"CLOSE",524,3);    
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   GetDell(sname);
   Comment(""); 
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {

  datetime db, de;
  db=StrToTime(TimeToStr(TimeCurrent(), TIME_DATE)+" "+(string)TIME_HOUR_START+":"+(string)TIME_MINUTE_START);
  de=StrToTime(TimeToStr(TimeCurrent(), TIME_DATE)+" "+(string)TIME_HOUR_STOP+":"+(string)TIME_MINUTE_STOP);

  Comment(TimeToStr(TimeCurrent(), TIME_DATE)+" "+(string)TIME_HOUR_START+":"+(string)TIME_MINUTE_START);

  if(TimeCurrent()>=de && TimeCLOSE)
  {STOPE = true;close=false;Button(sname+"_CLOSE",clrLime,"START",524,3);}
  if(close && !STOPE){STOPE = true;close=false;Button(sname+"_CLOSE",clrLime,"START",524,3);}
  if(close && STOPE && !staste){STOPE = false;close=false;Button(sname+"_CLOSE",clrCoral,"CLOSE",524,3);staste = true;}  
//----
 double pf=0;
   for(int cnt=0;cnt<=OrdersTotal()-1;cnt++){
    if (OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)){
     if (OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber){
     if (OrderType()==OP_BUY || OrderType()==OP_SELL) 
       pf += OrderProfit()+OrderCommission()+OrderSwap();      
 }}}
 
 if(Profit_currency>0 && pf>=Profit_currency){
  Print(" Closed on profit in currency  pf= "+(string)pf);     
  ClosePositions(Symbol(),-1,MagicNumber);}
  
//----  
  if(STOPE)
   {
    ClosePositions(Symbol(),-1,MagicNumber);
    DeleteOrders(Symbol(),-1,MagicNumber);
    Print("or the time is out or the button is pressed");
    Comment(" The trade is over! You need to restart the Expert Advisor! ");
    return;
   }  
  
  if(TimeCurrent()>=db){Comment("Go!");}
  else
   {
    Comment("STILL NOT TIME! WAITING FOR WAITING ... ");
    return;
   }  
//---
 if(Tralling)SimpleTrailing(Symbol(),-1,MagicNumber);
//---
  double level = Bid;     
  int stop_level = (int)MarketInfo(Symbol(),MODE_STOPLEVEL);
  int spread = (int)MarketInfo(Symbol(),MODE_SPREAD);
  Comment(
     "Stop Level ="+DoubleToStr(stop_level,0)+
     "\nSpread ="+DoubleToStr(spread,0)     
  );


if(staste)
 {
  STart();
  
  staste = false;
  return;
 }
//---
  Vost();
  }
//+------------------------------------------------------------------+
  //+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
 {
  bool selected;
  if(id==CHARTEVENT_OBJECT_CLICK)
   {
    string clickedChartObject=sparam;
    if(clickedChartObject==sname+"_CLOSE")
     {
      selected=ObjectGetInteger(0,sname+"_CLOSE",OBJPROP_STATE);
      if(selected)
       {
        close = true;
        ObjectSetInteger(0,sname+"_CLOSE",OBJPROP_COLOR,clrYellow);
        ObjectSetInteger(0,sname+"_CLOSE",OBJPROP_BGCOLOR,clrSlateGray);
        ObjectSetInteger(0,sname+"_CLOSE",OBJPROP_BORDER_COLOR,clrYellow);        
       }
      else 
       {
        close = false;
        ObjectSetInteger(0,sname+"_CLOSE",OBJPROP_COLOR,clrDimGray);
        ObjectSetInteger(0,sname+"_CLOSE",OBJPROP_BGCOLOR,clrGray);
        ObjectSetInteger(0,sname+"_CLOSE",OBJPROP_BORDER_COLOR,clrDimGray);        
       }}      
      //----
      ChartRedraw();
    }}
//+------------------------------------------------------------------+
bool Commi(int tic =0) {

  int      i, k=OrdersHistoryTotal();

  for (i=0; i<k; i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) {
      if (OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber) {
        if (OrderType()>-1 && OrderType()<6) {
          if (TimeStart<OrderCloseTime())
          {
           if(StrToInteger(OrderComment())==tic)return(false);
          }
        }
      }
    }
  }
  return(true);
}
//----
bool ExistOrd(int tic =0) {
  int i, k=OrdersTotal(), ty;
  for (i=0; i<k; i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      ty=OrderType();
      if (ty>-1 && ty<6 && OrderMagicNumber()==MagicNumber) {
            if(StrToInteger(OrderComment())==tic)return(true);
      }
    }
  }
  return(False);
}
//----
double GetPoint(string sy="")
{ 
 string _SY = sy;
 if(sy=="")_SY=Symbol();
 int vres = StringFind(_SY,"JPY");
 if (vres == -1) return(0.0001);
 return(0.01);
}
//-----
//----
void SetOrder(string sy, int op, double ll, double pp,
              double sl=0, double tp=0, int mn=0,string com="", datetime ex=0) {
  color    clOpen;
  datetime ot;
  double   pa, pb, mp;
  int      err, it, ticket, msl;
  string   lsComm=com;

  if (sy=="" || sy=="0") sy=Symbol();
  msl=(int)MarketInfo(sy, MODE_STOPLEVEL);
  if (op==OP_BUYLIMIT || op==OP_BUYSTOP) clOpen=Lime; else clOpen=Red;
  if (ex>0 && ex<TimeCurrent()) ex=0;
  for (it=1; it<=5; it++) {
    if (!IsTesting() && (!IsExpertEnabled() || IsStopped())) {
      Print("SetOrder(): Stop the function");
      break;
    }
    while (!IsTradeAllowed()) Sleep(5000);
    RefreshRates();
    ot=TimeCurrent();
//----+
    if(AccountFreeMarginCheck(Symbol(),OP_BUY, ll)<=0 || AccountFreeMarginCheck(Symbol(),OP_SELL, ll)<=0 || GetLastError()==134) 
    {
    return;}    
//----+
    ticket=OrderSend(sy, op, ll, pp, Slippage, sl, tp, lsComm, mn, ex, clOpen);
    if (ticket>0) {
      PlaySound("ok"); break;
    } else {
      err=GetLastError();
      if (err==128 || err==142 || err==143) {
        Sleep(1000*66);
        if (ExistOrders(sy, op, mn, ot)) {
          PlaySound("ok"); break;
        }
        Print("Error(",err,") set order: ",err,", try ",it);
        continue;
      }
      mp=MarketInfo(sy, MODE_POINT);
      pa=MarketInfo(sy, MODE_ASK);
      pb=MarketInfo(sy, MODE_BID);
      if (err==130) return;
      Print("Error(",err,") set order: ",err,", try ",it);
      Print("Ask=",pa,"  Bid=",pb,"  sy=",sy,"  ll=",ll,"  op=",GetNameOP(op),
            "  pp=",pp,"  sl=",sl,"  tp=",tp,"  mn=",mn);
      if (pa==0 && pb==0) Message("SetOrder(): Check the availability of the symbol in the market overview "+sy);
      if (err==2 || err==64 || err==65 || err==133) {
        gbDisabled=True; break;
      }
      if (err==4 || err==131 || err==132) {
        Sleep(1000*300); break;
      }
      if (err==8 || err==141) Sleep(1000*100);
      if (err==139 || err==140 || err==148) break;
      if (err==146) while (IsTradeContextBusy()) Sleep(1000*11);
      if (err==147) {
        ex=0; continue;
      }
      if (err!=135 && err!=138) Sleep(1000*7.7);
    }
  }
}
//----
//+----------------------------------------------------------------------------+
bool ExistOrders(string sy="", int op=-1, int mn=-1, datetime ot=0) {
  int i, k=OrdersTotal(), ty;
 
  if (sy=="0") sy=Symbol();
  for (i=0; i<k; i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      ty=OrderType();
      if (ty>1 && ty<6) {
        if ((OrderSymbol()==sy || sy=="") && (op<0 || ty==op)) {
          if (mn<0 || OrderMagicNumber()==mn) {
            if (ot<=OrderOpenTime()) return(True);
          }
        }
      }
    }
  }
  return(False);
}
//----
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
              fd=OrderDelete(OrderTicket(), Lime);
              if (fd) {
                 PlaySound("ok"); break;
              } else {
                err=GetLastError();
                Print("Error(",err,") delete order ",GetNameOP(ot),
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
//----
//+----------------------------------------------------------------------------+
string GetNameOP(int op) {
  switch (op) {
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
string GetNameTF(int TimeFrame=0) {
  if (TimeFrame==0) TimeFrame=Period();
  switch (TimeFrame) {
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
void Message(string m) {
  Comment(m);
  if (StringLen(m)>0) Print(m);
}
//----
//----
void ClosePosBySelect() {
  bool   fc;
  color  clClose;
  double ll, pa, pb, pp;
  int    err, it;

  if (OrderType()==OP_BUY || OrderType()==OP_SELL) {
    for (it=1; it<=5; it++) {
      if (!IsTesting() && (!IsExpertEnabled() || IsStopped())) break;
      while (!IsTradeAllowed()) Sleep(5000);
      RefreshRates();
      pa=MarketInfo(OrderSymbol(), MODE_ASK);
      pb=MarketInfo(OrderSymbol(), MODE_BID);
      if (OrderType()==OP_BUY) {
        pp=pb; clClose=Lime;
      } else {
        pp=pa; clClose=Red;
      }
      ll=OrderLots();
      fc=OrderClose(OrderTicket(), ll, pp, Slippage, clClose);
      if (fc) {
        PlaySound(""); break;
      } else {
        err=GetLastError();
        if (err==146) while (IsTradeContextBusy()) Sleep(1000*11);
        Print("Error(",err,") Close ",GetNameOP(OrderType())," ",
              err,", try ",it);
        Print(OrderTicket(),"  Ask=",pa,"  Bid=",pb,"  pp=",pp);
        Print("sy=",OrderSymbol(),"  ll=",ll,"  sl=",OrderStopLoss(),
              "  tp=",OrderTakeProfit(),"  mn=",OrderMagicNumber());
        Sleep(1000*5);
      }
    }
  } else Print("ERROR. Close ",GetNameOP(OrderType()));
}
//----
void ClosePositions(string sy="", int op=-1, int mn=-1) {
  int i, k=OrdersTotal();

  if (sy=="0") sy=Symbol();
  for (i=k-1; i>=0; i--) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      if ((OrderSymbol()==sy || sy=="") && (op<0 || OrderType()==op)) {
        if (OrderType()==OP_BUY || OrderType()==OP_SELL) {
          if (mn<0 || OrderMagicNumber()==mn) ClosePosBySelect();
        }
      }
    }
  }
}
//----
bool Button(string name="",color clr=clrWhite,string txt = "", int x=0, int y=0, int xs=80,int ys=20, int sz = 12){

 if(ObjectFind(name)>=0)ObjectDelete(name);
   ResetLastError(); 
   if(!ObjectCreate(0,name,OBJ_BUTTON,0,0,0)) 
     { 
      Print(name,__FUNCTION__, ": could not create a button! Error code= ",GetLastError()); 
      return(false); 
     }  
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,xs);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,ys);
   ObjectSetString(0,name,OBJPROP_FONT,"Arial Black");
   ObjectSetString(0,name,OBJPROP_TEXT,txt);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,sz);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,0);
   
   return(true);
}
//----
void GetDell (string name_n = "ytg_L")
  {
   string vName;
   for(int i=ObjectsTotal()-1; i>=0;i--)
    {
     vName = ObjectName(i);
     if (StringFind(vName,name_n) !=-1) ObjectDelete(vName);
    }  
  }
//----
//----
void SimpleTrailing(string sy="", int op=-1, int mn=-1) {
  double po, pp;
  int    i, k=OrdersTotal();

  if (sy=="0") sy=Symbol();
  for (i=0; i<k; i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      if ((OrderSymbol()==sy || sy=="") && (op<0 || OrderType()==op)) {
        po=GetPoint(sy);//MarketInfo(OrderSymbol(), MODE_POINT);
        if (mn<0 || OrderMagicNumber()==mn) {
          if (OrderType()==OP_BUY) {
            pp=MarketInfo(OrderSymbol(), MODE_BID);
            if (pp-OrderOpenPrice()>(TralingStart+TrailingStep)*po) {
              if (OrderStopLoss()<pp-(TralingStart+TrailingStep)*po) {
                ModifyOrder(-1, pp-TralingStart*po, -1);
              }
            }
          }
          if (OrderType()==OP_SELL) {
            pp=MarketInfo(OrderSymbol(), MODE_ASK);
            if (OrderOpenPrice()-pp>(TralingStart+TrailingStep)*po) {
              if (OrderStopLoss()>pp+(TralingStart+TrailingStep)*po || OrderStopLoss()==0) {
                Print("   gfgf ",pp+TralingStart*po,"  ",pp,"   ",TralingStart*po);
                ModifyOrder(-1, pp+TralingStart*po, -1);
              }
            }
          }
        }
      }
    }
  }
}
//---
//---
void ModifyOrder(double pp=-1, double sl=0, double tp=0, color cl=CLR_NONE) {
  bool   fm;
  double op, pa, pb, os, ot;
  int    dg=(int)MarketInfo(OrderSymbol(), MODE_DIGITS), er, it;
 
  if (pp<=0) pp=OrderOpenPrice();
  if (sl<0 ) sl=OrderStopLoss();
  if (tp<0 ) tp=OrderTakeProfit();
  
  pp=NormalizeDouble(pp, dg);
  sl=NormalizeDouble(sl, dg);
  tp=NormalizeDouble(tp, dg);
  op=NormalizeDouble(OrderOpenPrice() , dg);
  os=NormalizeDouble(OrderStopLoss()  , dg);
  ot=NormalizeDouble(OrderTakeProfit(), dg);
 
  if (pp!=op || sl!=os || tp!=ot) {
    for (it=1; it<=5; it++) {
      if (!IsTesting() && (!IsExpertEnabled() || IsStopped())) break;
      while (!IsTradeAllowed()) Sleep(5000);
      RefreshRates();
      fm=OrderModify(OrderTicket(), pp, sl, tp, 0, cl);
      if (fm) {
        PlaySound("expert.wav"); break;
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
//---
 void STart()
  {
  double pp=0,sl=0,tp=0,ll=LOT;   
  
if(BuyStop_count>0)
 {  
  for(int i=0; i<BuyStop_count; i++)
   {
    pp = NormalizeDouble(BufA[i],Digits);
    sl = NormalizeDouble(Buy_StopLoss,Digits);
    if(!StopLoss_overall)sl = NormalizeDouble(pp-StopLoss*GetPoint(),Digits);
    tp = NormalizeDouble(pp+TakeProfit*GetPoint(),Digits);
    SetOrder(Symbol(),OP_BUYSTOP,ll,pp,sl,tp,MagicNumber,"start A");    
   }
 }

if(BuyLimit_count>0)
 {  
  for(int i=0; i<BuyLimit_count; i++)
   {
    pp = NormalizeDouble(BufB[i],Digits);
    sl = NormalizeDouble(Buy_StopLoss,Digits);
    if(!StopLoss_overall)sl = NormalizeDouble(pp-StopLoss*GetPoint(),Digits);    
    tp = NormalizeDouble(pp+TakeProfit*GetPoint(),Digits);
    SetOrder(Symbol(),OP_BUYLIMIT,ll,pp,sl,tp,MagicNumber,"start D");    
   }
 }

if(SellStop_count>0)
 {  
  for(int i=0; i<SellStop_count; i++)
   {
    pp = NormalizeDouble(BufC[i],Digits);    
    sl = NormalizeDouble(Sell_StopLoss,Digits);
    if(!StopLoss_overall)sl = NormalizeDouble(pp+StopLoss*GetPoint(),Digits);
    tp = NormalizeDouble(pp-TakeProfit*GetPoint(),Digits);
    SetOrder(Symbol(),OP_SELLSTOP,ll,pp,sl,tp,MagicNumber,"start C");    
   }
 } 

if(SellLimit_count>0)
 {  
  for(int i=0; i<SellLimit_count; i++)
   {
    pp = NormalizeDouble(BufD[i],Digits);    
    sl = NormalizeDouble(Sell_StopLoss,Digits);
    if(!StopLoss_overall)sl = NormalizeDouble(pp+StopLoss*GetPoint(),Digits);    
    tp = NormalizeDouble(pp-TakeProfit*GetPoint(),Digits);
    SetOrder(Symbol(),OP_SELLLIMIT,ll,pp,sl,tp,MagicNumber,"start D");    
   }
 } 
  
}
//----
void Vost()
 {
  string txt = "";
  double pp=0,sl=0,tp=0,ll=LOT;
  double stoplevel = MarketInfo(Symbol(),MODE_STOPLEVEL)*Point;

 if(SellStop_count>0){  
   for(int i=0; i<SellStop_count; i++){
     if(LVR(Symbol(),MagicNumber,OP_SELLSTOP,BufC[i]) && LVR(Symbol(),MagicNumber,OP_SELL,BufC[i])){
       pp = NormalizeDouble(BufC[i],Digits);
       sl = NormalizeDouble(Sell_StopLoss,Digits);
       if(!StopLoss_overall)sl = NormalizeDouble(pp+StopLoss*GetPoint(),Digits);
       tp = NormalizeDouble(pp-TakeProfit*GetPoint(),Digits);
       if(Bid-pp>=stoplevel)SetOrder(Symbol(),OP_SELLSTOP,ll,pp,sl,tp,MagicNumber,txt+"|");
 }}}          

 if(SellLimit_count>0){  
   for(int i=0; i<SellLimit_count; i++){
     if(LVR(Symbol(),MagicNumber,OP_SELLLIMIT,BufD[i]) && LVR(Symbol(),MagicNumber,OP_SELL,BufD[i])){          
      pp = NormalizeDouble(BufD[i],Digits);
      sl = NormalizeDouble(Sell_StopLoss,Digits);
      if(!StopLoss_overall)sl = NormalizeDouble(pp+StopLoss*GetPoint(),Digits);
      tp = NormalizeDouble(pp-TakeProfit*GetPoint(),Digits);
      if(pp-Ask>=stoplevel)SetOrder(Symbol(),OP_SELLLIMIT,ll,pp,sl,tp,MagicNumber,txt+"|");
  }}}

 if(BuyStop_count>0){  
  for(int i=0; i<BuyStop_count; i++){
     if(LVR(Symbol(),MagicNumber,OP_BUYSTOP,BufA[i]) && LVR(Symbol(),MagicNumber,OP_BUY,BufA[i])){   
       pp = NormalizeDouble(BufA[i],Digits);
       sl = NormalizeDouble(Buy_StopLoss,Digits);
       if(!StopLoss_overall)sl = NormalizeDouble(pp-StopLoss*GetPoint(),Digits);
       tp = NormalizeDouble(pp+TakeProfit*GetPoint(),Digits);
       if(pp-Ask>=stoplevel)SetOrder(Symbol(),OP_BUYSTOP,ll,pp,sl,tp,MagicNumber,txt+"|");
  }}}

 if(BuyLimit_count>0){  
  for(int i=0; i<BuyLimit_count; i++){
     if(LVR(Symbol(),MagicNumber,OP_BUYLIMIT,BufB[i]) && LVR(Symbol(),MagicNumber,OP_BUY,BufB[i])){             
            pp = NormalizeDouble(BufB[i],Digits);
            sl = NormalizeDouble(Buy_StopLoss,Digits);
            if(!StopLoss_overall)sl = NormalizeDouble(pp-StopLoss*GetPoint(),Digits);
            tp = NormalizeDouble(pp+TakeProfit*GetPoint(),Digits);
            if(Bid-pp>=stoplevel)SetOrder(Symbol(),OP_BUYLIMIT,ll,pp,sl,tp,MagicNumber,txt+"|");
  }}}
//---- 
 }
//---- ++++ 
 bool EOP(string sy="", int mn=-1,string ttxt ="") {
 
  bool metka = true;
  int i, k=OrdersTotal(), ty;
  
  if (sy=="0") sy=Symbol();
  for (i=0; i<k; i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      ty=OrderType();
      if (ty>-1 && ty<6) {
        if (OrderSymbol()==sy || sy=="") {
          if (mn<0 || OrderMagicNumber()==mn) {
            if (OComm(OrderComment())==ttxt){        
            metka=false;break;}
          }
        }
      }
    }
  }
  return(metka);
}
//---
bool EOH(string sy="",int mn=-1,string ttxt ="") {
  
  bool mmetka = true;
  int      i, k=OrdersHistoryTotal();

  for (i=0; i<k; i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) {
      if (OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber) {
        if (OrderType()==OP_SELL || OrderType()==OP_BUY) {
          if(OComm(OrderComment())==ttxt){
          mmetka=false;break;}
        }
      }
    }
  }
  return(mmetka);
}
//----
string OComm(string txt = "")
 {
  int count = StringLen(txt), i=0; 
  for(i=0; i<count; i++)
   {
    if(StringSubstr(txt,i,1)=="|")
     {
      break;
     }
   }  
  return(StringSubstr(txt,0,i));
 }
 //----
 bool LVR(string sy="", int mn=-1,int opt=0,double pric=0) {
 
  int i, k=OrdersTotal(), ty;
  
  if (sy=="0") sy=Symbol();
  for (i=0; i<k; i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      ty=OrderType();
      if (ty==opt) {
        if (OrderSymbol()==sy || sy=="") {
          if (mn<0 || OrderMagicNumber()==mn) {
            if (NormalizeDouble(MathAbs(OrderOpenPrice()-pric),Digits)<Point)return(false);
          }
        }
      }
    }
  }
  return(true);
}