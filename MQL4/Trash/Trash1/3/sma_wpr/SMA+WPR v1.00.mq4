/*
                             SMA+WPR 
                     Coder: Nikolay Khrushchev 
                            MqlLab.ru
*/
#property copyright "MqlLab.ru"
#property link      "http://www.mqllab.com"

extern double              lot                  = 0.1;
extern double              risk                 = 0;
extern double              stop_loss            = 20;
extern double              take_profit          = 10;
extern int                 max_orders           = 1;
extern int                 Start_Hour           = 0;
extern int                 Start_Min            = 0;
extern int                 End_Hour             = 24;
extern int                 End_Min              = 0;
extern string              menucomment01        = "========= ��������� ���������� =========";
extern ENUM_TIMEFRAMES     time_frame           = PERIOD_CURRENT;
extern int                 ma_period            = 105;
extern ENUM_MA_METHOD      ma_method            = MODE_SMA;
extern ENUM_APPLIED_PRICE  ma_price             = PRICE_CLOSE;
extern int                 wpr_period           = 21;
extern double              wpr_sell_level       = -5;
extern double              wpr_buy_level        = -95;
extern int                 open_bar             = 0;
extern string              menucomment02        = "========= ������ ��������� =========";
extern int                 magic                = 9238;
       int                 slippage_open        = 3;
       int                 slippage_close       = 15;
       int                 TryToTrade           = 20;
       int                 WaitTime             = 1500;
extern int                 CommentSize          = 7;


int      i, r, z,                               // ���������� ��� ���������� for
         dg, dig,                               // ���������� ����� � ����
         last_ticket;                           // ��������� ����� ��� ��������� ������� for
bool     Work=true, Test=false,                 // ���� ���������� ������ � ���� ������ � �������
         long_allowed=true, short_allowed=true; // ���������� �������� � ���������
double   Pp, Mnoj,                              // Point ����������� �� 2/4 ����� � �������� ���������
         Pp2, Mnoj2,                            // ����������� Point � �������� ���������
         min_lot, max_lot;                      // ����������� � ������������ ���
string   Symb,                                  // ������ �����������
         CommentBox[],cm2;                      // ����������� �� �������

datetime time_bar;                              // ����� �������� ������� �����
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
void start() {
   if (!Work) return;
   if(!IsTradeAllowed()) return;
   // ��������� ������� _________________________________________________________________________________________________________
   int signal=-1;
   if (time_bar!=iTime(Symb,time_frame,0)) {
      double ma      = iMA(Symb,time_frame,ma_period,0,ma_method,ma_price,open_bar);
      double wpr_last= iWPR(Symb,time_frame,wpr_period,open_bar+1);
      double wpr_now = iWPR(Symb,time_frame,wpr_period,open_bar);
      if(Bid>ma && wpr_last>wpr_buy_level && wpr_now<=wpr_buy_level) signal=0;
      if(Bid<ma && wpr_last<wpr_sell_level && wpr_now>=wpr_sell_level) signal=1;
      if(signal!=-1 || open_bar>0) time_bar=iTime(Symb,time_frame,0);
      }
   // ���� ������� ______________________________________________________________________________________________________________
   int open_orders   = 0;
   last_ticket=-1;
   for(i=OrdersTotal()-1;i>=0;i--) if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==Symb && OrderMagicNumber()==magic) {
      if(last_ticket==OrderTicket()) continue;
      last_ticket=OrderTicket();
      if(signal!=OrderType() && signal!=-1) { CloseOrder(OrderTicket()); continue; }
      open_orders++;
      }
   // �������� ������� __________________________________________________________________________________________________________
   if(signal==-1) return;
   if(!TimeAllowed()) return;
   if(open_orders>=max_orders && max_orders>0) return;
   if(risk>0) lot=NormalizeDouble((AccountBalance()*(risk/100))/(MarketInfo(Symb,MODE_TICKVALUE)*(stop_loss)*(Pp/Point)),dg);
   SendOrder(last_ticket,signal,lot,-1,1,stop_loss,1,take_profit);
   // end start      
   }
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
void init() {
   dig=Digits;
   Pp=Point();
   Pp2=Pp;
   Mnoj2=1/Pp;
   if (NormalizeDouble(Pp,dig)==NormalizeDouble(0.00001,dig) || NormalizeDouble(Pp,dig)==NormalizeDouble(0.001,dig)) Pp*=10; 
   Mnoj=1/Pp;
   Symb=Symbol();
   if (MarketInfo(Symb,MODE_LOTSTEP)==0.01) dg=2;
   if (MarketInfo(Symb,MODE_LOTSTEP)==0.1)  dg=1;
   min_lot=NormalizeDouble( MarketInfo(Symb,MODE_MINLOT) ,dg);
   max_lot=NormalizeDouble( MarketInfo(Symb,MODE_MAXLOT) ,dg);
   if(IsTesting() && !IsVisualMode()) Test=true;
   int k;
   if(!Test) {
      if(CommentSize>0) ArrayResize(CommentBox,CommentSize);
      for(k=0;k<CommentSize;k++) CommentBox[k]="";
      }
   if (!IsTesting() && !TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) PnC("��������� � ���������� ��������� ���������� �� �������������� ��������!",1);
   return;
   }
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
void deinit() {
   Comment("");
   return;
   }
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
bool TimeAllowed(int time=-1) {
   int HOUR,MIN;
   if(time==-1) {
      HOUR=Hour();
      MIN=Minute();
      }else{
      HOUR=TimeHour(time);
      MIN=TimeMinute(time);
      }
   bool TradeAllow=true;
   if (Start_Hour>End_Hour) { // ��� �������� ������ ���� ��������
      if (HOUR<Start_Hour && HOUR>End_Hour) TradeAllow=false;
      }else{ // ��� �������� ������ ���� ��������
      if (HOUR<Start_Hour || HOUR>End_Hour) TradeAllow=false;
      }
   if (HOUR==Start_Hour && MIN<Start_Min) TradeAllow=false;
   if (HOUR==End_Hour && MIN>=End_Min)  TradeAllow=false;
   if (TradeAllow) return(true); else return(false);
   }
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
>>>         ������� �������� ������
>>> ���������:
>>>   int      Ticket   - ����� ������������ ������      
>>>   int      Type     - ��� ������������ ������ (0-BUY, 1-SELL, 2-BUYLIMIT, 3-SELLLIMIT, 4-BUYSTOP, 5-SELLSTOP)
>>>   double   LT       - ����� ������������ ������
>>>   
>>>   double   OP       - ���� �� ������� ��������� ����� (���� Type ����� 0 ��� 1, �������� �� ����� ������)
>>>   int      ModeSL   - ����� ����������� ���� ���� (0-���������� ���� �����������, 1-������)
>>>   double   SL       - ���� ����
>>>   int      ModeTP   - ����� ����������� ���� ������� (0-���������� ���� �����������, 1-������)
>>>   double   TP       - ���� ������
>>>   string   CM       - ����������� ������
>>>   int      MG       - ������ ������
>>>   
>>> ������������ ��������:
>>>   ���������� TRUE ��� �������� ���������� �������. ���������� FALSE ��� ��������� ���������� �������.
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
bool SendOrder(int &Ticket, int Type ,double LT ,double OP=-1 ,int ModeSL=0 ,double SL=0 ,int ModeTP=0 ,double TP=0, string CM="", int MG=-1) {
   if(MG==-1) MG=magic;
   color CL;
   int k,LastError;
   bool TickeT;
   if (Type==0) CL=Blue; else  if (Type==1) CL=Red; else  if (Type==2 || Type==4) CL=DarkTurquoise; else if (Type==3 || Type==5) CL=Orange;
   // �������� �����������
   if(Type==0 || Type==2 || Type==4) {
      if(!long_allowed) return(false);
      }else{
      if(!short_allowed) return(false);
      }
   // �������� ������
   if (LT*MarketInfo(Symbol(),MODE_MARGINREQUIRED)>AccountFreeMargin()) {
      PnC(StringConcatenate("[S] �� ������� ������� ��� �������� ������ ",TypeToStr(Type)," �������: ",DoubleToStr(LT,dg)),1);
      PnC("[S] �������� ��������� ������",1);
      Work=false;
      return(false);
      }
   if(LT<min_lot) {
      PnC(StringConcatenate("[S] ����� ������ ������ ������������ ",DoubleToStr(min_lot,dg),". ����� ������ ����������� �����"),1);
      LT=min_lot;
      }
   if(LT>max_lot) {
      PnC(StringConcatenate("[S] ����� ������ ������ ������������� ",DoubleToStr(min_lot,dg),". ����� ������ ������������ �����"),1);
      LT=max_lot;
      }
   // �������� ���������� �������
   double Slv=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point;
   switch(Type) {
      case 2: if(Ask-OP<Slv) OP=Ask-Slv; break;
      case 3: if(OP-Bid<Slv) OP=Bid+Slv; break;
      case 4: if(OP-Ask<Slv) OP=Ask+Slv; break;
      case 5: if(Bid-OP<Slv) OP=Bid-Slv; break;
      }
   // ��������
   for(k=0;k<TryToTrade;k++) {
      RefreshRates(); 
      if (Type==0) OP=Ask; 
      if (Type==1) OP=Bid;  
      PnC(StringConcatenate("[S] �������� ������ ",TypeToStr(Type)," �������: ",DoubleToStr(LT,dg)," �� ����: ",DoubleToStr(OP,dig)," ������: ",MG," �����������: ",CM),0); 
      if (IsTradeAllowed()) {
         Ticket=OrderSend(Symbol(),Type,LT,NormalizeDouble(OP,dig),slippage_open,0,0,CM,MG,0,CL);
         }else{ 
         PnC(StringConcatenate("[S] �������� ����� �����, ���� ",k),0); 
         Sleep(WaitTime); 
         continue; 
         }
      if (Ticket > 0) { 
         PnC(StringConcatenate("[S] ������� ������ ����� ",Ticket),0); 
         break; 
         }
      LastError=Fun_Error(GetLastError());
      switch(LastError) {
         case 0: 
            if (k==TryToTrade) return(false);
            Sleep(WaitTime); 
            break;
         case 1:
            return(false);
         case 2:
            Work=false; 
            return(false); 
         }
      }
   if (SL==0 && TP==0) return(true);
   if(Ticket==-1) {
      PnC(StringConcatenate("[S] �� ������� ������� �����"),1); 
      return(false);
      }
   if(!OrderSelect(Ticket,SELECT_BY_TICKET)) {
      PnC(StringConcatenate("[S] ������ ������ ��������� ������ ",Ticket," ��� ����������� ������"),1); 
      return(false);
      }
   // �������� � ������ ������
   if(SL!=0) {
      if (ModeSL==1) {
         if (Type==0 || Type==2 || Type==4) SL=OrderOpenPrice()-SL*Pp; else SL=OrderOpenPrice()+SL*Pp;
         }
      if(Type==0 && Bid-SL<Slv && SL!=0) SL=Bid-Slv;
      if(Type==1 && SL-Ask<Slv && SL!=0) SL=Ask+Slv;
      }
   if(TP!=0) {
      if (ModeTP==1) {
         if (Type==0 || Type==2 || Type==4) TP=OrderOpenPrice()+TP*Pp; else TP=OrderOpenPrice()-TP*Pp;
         }    
      if(Type==0 && TP-Bid<Slv && TP!=0) TP=Bid+Slv;
      if(Type==1 && Ask-TP<Slv && TP!=0) TP=Ask-Slv;
      }
   // ���������� �����
   for(k=0;k<TryToTrade;k++) {
      PnC(StringConcatenate("[S] ��������� ������ �� �����: ",Ticket," �/�: ",DoubleToStr(SL,dig)," �/�: ",DoubleToStr(TP,dig)),0);
      if (IsTradeAllowed()) {
         TickeT=OrderModify(Ticket,OrderOpenPrice(),NormalizeDouble(SL,dig),NormalizeDouble(TP,dig),0,CLR_NONE);
         }else{ 
         PnC(StringConcatenate("[S] �������� ����� �����, ���� ",k),0); 
         Sleep(WaitTime); 
         continue; 
         }
      if (TickeT) { 
         PnC(StringConcatenate("[S] ������� ������������� ����� ",Ticket),0); 
         break; 
         }
      LastError=Fun_Error(GetLastError());
      switch(LastError) {
         case 0: 
            if (k==TryToTrade) return(false);
            Sleep(WaitTime); 
            break;
         case 1:
            return(false);
         case 2:
            Work=false; 
            return(false); 
         }
      }
   return(true);
   }
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
>>>         ������� ����������� ������
>>> ���������:
>>>   int      Ticket   - ����� ������
>>>   
>>>   double   OP       - ����� ���� �������� ������. ���� -1 - ��������� ��� ���������
>>>   int      ModeSL   - ����� ����������� ���� ���� (0-���������� ���� �����������, 1-������)
>>>   double   SL       - ����� ���� ���� ������. ���� -1 - ��������� ��� ���������
>>>   int      ModeTP   - ����� ����������� ���� ������� (0-���������� ���� �����������, 1-������)
>>>   double   TP       - ����� ���� ������ ������. ���� -1 - ��������� ��� ���������
>>>   
>>> ������������ ��������:
>>>   ���������� TRUE ��� �������� ���������� �������. ���������� FALSE ��� ��������� ���������� �������.
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
bool ModifyOrder (int Ticket,double OP=-1,int ModeSL=0 ,double SL=0 ,int ModeTP=0 ,double TP=0) {
   bool TickeT;
   int k,LastError;
   TickeT=OrderSelect(Ticket,SELECT_BY_TICKET);
   if (!TickeT) {
      PnC("[M] ������ ������ ������ ��� ����������� ",0);
      return(false);
      }
   if (OrderCloseTime()>0) {
      PnC("[M] ����� ��� ������ ��� ������",0);
      return(false);
      }
   int Type=OrderType();
   double mo_calcl_price=OrderOpenPrice();
   if(OP>0) mo_calcl_price=OP;
   if (ModeSL==1 && SL!=-1) {
      if (Type==0 || Type==2 || Type==4) SL=mo_calcl_price-SL*Pp; else SL=mo_calcl_price+SL*Pp;
      }
   if (ModeTP==1 && TP!=-1) {
      if (Type==0 || Type==2 || Type==4) TP=mo_calcl_price+TP*Pp; else TP=mo_calcl_price-TP*Pp;
      } 
   string cm;
   if(OP<0) OP=OrderOpenPrice(); else cm="���� " + DoubleToStr(OrderOpenPrice(),dig) + " => " + DoubleToStr(OP,dig) + "; ";
   if(SL<0) SL=OrderStopLoss(); else cm=cm+"�/� " + DoubleToStr(OrderStopLoss(),dig) + " => " + DoubleToStr(SL,dig) + "; ";
   if(TP<0) TP=OrderTakeProfit(); else cm=cm+"�/� " + DoubleToStr(OrderTakeProfit(),dig) + " => " + DoubleToStr(TP,dig) + "; ";
   if(Type==0 || Type==3 || Type==5) cm=cm+"������� ���� Bid: "+DoubleToStr(Bid,dig);
   if(Type==1 || Type==2 || Type==4) cm=cm+"������� ���� Ask: "+DoubleToStr(Ask,dig);
   color modify_color;
   if(MathMod(OrderType(),2.0)==0) modify_color=Aqua; else modify_color=Orange;
   for(k=0;k<TryToTrade;k++) {
      PnC(StringConcatenate("[M] ����������� ������: ",Ticket," ",cm),0);
      if (IsTradeAllowed()) {
         TickeT=OrderModify(Ticket,NormalizeDouble(OP,dig),NormalizeDouble(SL,dig),NormalizeDouble(TP,dig),0,modify_color);
         }else{ 
         PnC(StringConcatenate("[M] �������� ����� �����, ���� ",k),0); 
         Sleep(WaitTime); 
         continue; 
         }
      if (TickeT ==true) { 
         PnC(StringConcatenate("[M] ������� ������������� ����� ",Ticket),0); 
         return(true); 
         }
      LastError=Fun_Error(GetLastError());
      switch(LastError) {
         case 0: 
            if (k==TryToTrade) return(false);
            Sleep(WaitTime); 
            break;
         case 1:
            return(false);
         case 2:
            Work=false; 
            return(false); 
         }
      }
   return(true);
   }
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
>>>         ������� �������� ������
>>> ���������:
>>>   int      Ticket   - ����� ������
>>>   
>>>   double   LT       - ����� ������� ���������� �������. ���� -1 - ����� ����� ������ ���������
>>>   
>>> ������������ ��������:
>>>   ���������� TRUE ��� �������� ���������� �������. ���������� FALSE ��� ��������� ���������� �������.
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
bool CloseOrder(int Ticket,double LT=-1) {
   bool TickeT;
   double OCP;
   int k,LastError;
   TickeT=OrderSelect(Ticket,SELECT_BY_TICKET);
   if (!TickeT) {
      PnC("[C] ������ ������ ������ ��� �������� ",0);
      return(false);
      }
   if (OrderCloseTime()>0) {
      PnC("[C] ����� ��� ������ ��� ������",0);
      return(false);
      }
   int Type=OrderType();
   if (Type>1) {
      PnC("[C] ����� ������� ������, �� ���������� ",0);
      return(false);
      }
   if(LT==-1) LT=NormalizeDouble(OrderLots(),dg); else LT=NormalizeDouble(LT,dg);
   for(k=0;k<=TryToTrade;k++) {
      RefreshRates(); 
      if (Type==0) OCP=Bid; else OCP=Ask;
      PnC(StringConcatenate("[C] �������� ������ ",TypeToStr(Type)," �����: ",Ticket," �������: ",DoubleToStr(LT,dg)," �� ����: ",DoubleToStr(OCP,dig)),0);
      if (IsTradeAllowed()) {
         TickeT=OrderClose(Ticket,LT,NormalizeDouble(OCP,dig),slippage_close,White);
         }else{ 
         PnC(StringConcatenate("[C] �������� ����� �����, ���� ",k),0); 
         Sleep(WaitTime); 
         continue; 
         }
      if (TickeT) { 
         PnC(StringConcatenate("[C] ������� ������ ����� ",Ticket),0); 
         return(true); 
         }
      LastError=Fun_Error(GetLastError());
      switch(LastError) {
         case 0: 
            if (k==TryToTrade) return(false);
            Sleep(WaitTime); 
            break;
         case 1:
            return(false);
         case 2:
            Work=false; 
            return(false); 
         }
      }
   return(true);
   }
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
>>>         ������� �������� ������
>>> ���������:
>>>   int      Ticket   - ����� ������
>>>   
>>> ������������ ��������:
>>>   ���������� TRUE ��� �������� ���������� �������. ���������� FALSE ��� ��������� ���������� �������.
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
bool DeleteOrder(int Ticket) {
   bool TickeT;
   int k,LastError;
   TickeT=OrderSelect(Ticket,SELECT_BY_TICKET);
   if (!TickeT) {
      PnC(StringConcatenate("[D] ������ ������ ������ ��� �������� ",Ticket),0);
      return(false);
      }
   if (OrderCloseTime()>0) {
      PnC(StringConcatenate("[D] ����� ��� ������ ��� ������ ",Ticket),0);
      return(false);
      }
   int Type=OrderType();
   if (Type<2) {
      PnC(StringConcatenate("[D] ����� ������� ������, �� ��� �������� ",Ticket),0);
      return(false);
      }
   for(k=0;k<=TryToTrade;k++) {
      PnC(StringConcatenate("[D] �������� ������: ",Ticket," ���: ",TypeToStr(Type)),0);
      if (IsTradeAllowed()) {
         TickeT=OrderDelete(Ticket);
         }else{ 
         PnC(StringConcatenate("[D] �������� ����� �����, ���� ",k),0); 
         Sleep(WaitTime); 
         continue; 
         }
      if (TickeT) { 
         PnC(StringConcatenate("[D] ������� ������ ����� ",Ticket),0); 
         return(true); 
         }
      LastError=Fun_Error(GetLastError());
      switch(LastError) {
         case 0: 
            if (k==TryToTrade) return(false);
            Sleep(WaitTime); 
            break;
         case 1:
            return(false);
         case 2:
            Work=false; 
            return(false); 
         }
      }
   return(true);
   }
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
>>>         ������� �������� � �������� ���� �������
>>> ������������ ��������:
>>>   ���������� TRUE ��� �������� ���������� �������. ���������� FALSE ��� ��������� ���������� �������.
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
bool CloseAll() {
   for(i=OrdersTotal()-1;i>=0;i--) if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==Symb && OrderMagicNumber()==magic) {
      if (OrderType()<2) {
         if(!CloseOrder(OrderTicket())) return(false); 
         }else{
         if(!DeleteOrder(OrderTicket())) return(false); 
         }
      }
   return(true);
   } 
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
>>>         ������� �������� ���� �������
>>> ������������ ��������:
>>>   ���������� TRUE ��� �������� ���������� �������. ���������� FALSE ��� ��������� ���������� �������.
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
bool DeleteAll() {
   for(i=OrdersTotal()-1;i>=0;i--) if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==Symb && OrderMagicNumber()==magic) {
      if (OrderType()>1) {
         if(!DeleteOrder(OrderTicket())) return(false); 
         }
      }
   return(true);
   } 
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
>>>         ������� ��������� ���������
>>> ��������:
>>>   ������� ��������� ���������� ��������� ��������� �� ������ � ���� ����� � ����� ������� ���� ������, 
>>>   �������� �� � ������ � ����� ��� ������������� ���������� ����������� (Alert).
>>>
>>> ���������:
>>>   string   txt      - ����� ���������
>>>   int      Mode     - ��� ��������� (0-������ Print, 1-Print � Alert, 2-������)
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
void PnC(string txt,int Mode) {
   int j;
   string cm;
   if(Mode!=2) {
      string HR=DoubleToStr(Hour(),0);    if (StringLen(HR)<2) HR="0"+HR;
      string MN=DoubleToStr(Minute(),0);  if (StringLen(MN)<2) MN="0"+MN;
      string SC=DoubleToStr(Seconds(),0); if (StringLen(SC)<2) SC="0"+SC;
      txt=StringConcatenate(HR,":",MN,":",SC," ",Symb," ",txt);
      Print(txt);
      if(Test) return;
      if (Mode>0) Alert(txt);
      for(j=CommentSize-1;j>=1;j--) CommentBox[j]=CommentBox[j-1];
      CommentBox[0]=txt;
      }
   if(CommentSize>0) { 
      for(j=CommentSize-1;j>=0;j--) if(CommentBox[j]!="") cm=StringConcatenate(cm,CommentBox[j],"\n");
      }
   if(CommentSize>0) 
      cm=StringConcatenate(cm,"\n",cm2);
      else
      cm=StringConcatenate(cm2);
   Comment(cm); 
   }
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
>>>         ������� �������������� ���� ������
>>> ��������:
>>>   �������������� �����, ����������� �������� ������������� ���� ������ � ������
>>>
>>> ���������:
>>>   int      Type     -  ��� ������ (0-BUY, 1-SELL, 2-BUYLIMIT, 3-SELLLIMIT, 4-BUYSTOP, 5-SELLSTOP)
>>>   
>>> ������������ ��������:
>>>   � ������ ��������� ���������� ������� ���������� ������ � ����� ����������. � �������� ������ ���������� "NONE".
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
string TypeToStr(int Type) {
   switch(Type) {
      case 0: return("BUY");
      case 1: return("SELL");
      case 2: return("BUYLIMIT");
      case 3: return("SELLLIMIT");
      case 4: return("BUYSTOP");
      case 5: return("SELLSTOP");
      }
   return("NONE");
   }
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
>>>         ������� �������������� ���� ������
>>> ��������:
>>>   �������������� ���� ������, ����������� �������� ������������� ������� � ������
>>>
>>> ���������:
>>>   int      pts_period   -  ���� ����� (0,1,5,15,30,60,240,1440,10080,43200)
>>>   
>>> ������������ ��������:
>>>   � ������ ��������� ���������� ������� ���������� ������ � ���� �������. � �������� ������ ���������� "NONE".
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
string PeriodToStr(int pts_period=0) {
   if(pts_period==0) pts_period=Period();
   switch(pts_period) {
      case 1:     return("M1");
      case 5:     return("M5");
      case 15:    return("M15");
      case 30:    return("M30");
      case 60:    return("H1");
      case 240:   return("H4");
      case 1440:  return("D1");
      case 10080: return("W1");
      case 43200: return("MN1");
      }
   return("NONE");
   }
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
>>>         ������� ��������� ������
>>> ��������:
>>>   ������� ������� ��������� �� ������ � ��������� ���������, � ����� ���������� ����� � ����������� �� ���� � ����� �� ���� ����� ����������� ������.
>>>   ����� � ������ ������ 4110 � 4111 (������ �� �������� � ������������ ����������� � ����� ���������� ��������) ������ ���������� long.allowed � 
>>>   short.allowed �� false � ��� ����� � ��������� ��� ������� SendOrder �� ����������� � ���� �� �����������
>>>
>>> ���������:
>>>   int      er       - ����� ������
>>>   
>>> ������������ ��������:
>>>   � ������ ��������� ���������� ������� ���������� ���� �� ���� �������:
>>>   0 - ������� ��������� ���������� �������� �������
>>>   1 - ������� ���������� ���������� �������� �������
>>>   2 - ������� ��������� ������ ���������
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
int Fun_Error(int er) {
   switch(er) {
      // ������ 1: �� ���������� �������
      case 2: PnC("����� ������",0); return(0);
      case 4: PnC("�������� ������ �����",0); return(0);
      case 8: PnC("������� ������ �������",0); return(0);
      case 129: PnC("������������ ����",0); return(0);
      case 135: PnC("���� ����������",0); return(0);
      case 136: PnC("��� ���",0); return(0);
      case 137: PnC("������ �����",0); return(0);
      case 138: PnC("����� ����",0); return(0);
      case 141: PnC("������� ����� ��������",0); return(0);
      case 146: PnC("���������� �������� ������",0); return(0);
      // ������ 2: ���������� �������
      case 0: PnC("������ �����������",0); return(1);
      case 1: PnC("��� ������, �� ��������� �� ��������",0); return(1);
      case 3: PnC("������������ ���������",0); return(1);
      case 6: PnC("��� ����� � �������� ��������",0); return(1);
      case 128: PnC("����� ���� �������� ���������� ������",0); return(1);
      case 130: PnC("������������ �����",0); return(1);
      case 131: PnC("������������ �����",0); return(1);
      case 132: PnC("����� ������",0); return(1);
      case 133: PnC("�������� ���������",0); return(1);
      case 134: PnC("������������ ����� ��� ���������� ��������",0); return(1);
      case 139: PnC("����� ������������ � ��� ��������������",0); return(1);
      case 145: PnC("����������� ���������, ��� ��� ����� ������� ������ � �����",0); return(1);
      case 148: PnC("���������� �������� � ���������� ������� �������� �������, �������������� ��������",0); return(1);
      case 4000: PnC("��� ������",0); return(1);
      case 4107: PnC("������������ �������� ���� ��� �������� �������",0); return(1);
      case 4108: PnC("����� �� ������",0); return(1);
      case 4110: PnC("BUY ������� �� ���������",0); long_allowed=false; return(1);
      case 4111: PnC("SELL ������� �� ���������",0); short_allowed=false; return(1);
      // ������ 3: ��������� ������
      case 5: PnC("������ ������ ����������� ���������",1); return(2);
      case 7: PnC("������������ ����",1); return(2);
      case 9: PnC("������������ �������� ���������� ���������������� �������",1); return(2);
      case 64: PnC("���� ������������",1); return(2);
      case 65: PnC("������������ ����� �����",1); return(2);
      case 140: PnC("��������� ������ �������",1); return(2);
      case 147: PnC("������������� ���� ��������� ������ ��������� ��������",1); return(2);
      case 149: PnC("������� ������� ��������������� ������� � ��� ������������ � ������, ���� ������������ ���������",1); return(2);
      case 150: PnC("������� ������� ������� �� ����������� � ������������ � �������� FIFO",1); return(2);
      case 4109: PnC("�������� �� ���������, ��������� �������� ��������� � ������������� ���",1); return(2);
      }
   return(0);
   }                     
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


