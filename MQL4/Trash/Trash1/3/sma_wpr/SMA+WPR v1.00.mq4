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
extern string              menucomment01        = "========= Параметры индикатора =========";
extern ENUM_TIMEFRAMES     time_frame           = PERIOD_CURRENT;
extern int                 ma_period            = 105;
extern ENUM_MA_METHOD      ma_method            = MODE_SMA;
extern ENUM_APPLIED_PRICE  ma_price             = PRICE_CLOSE;
extern int                 wpr_period           = 21;
extern double              wpr_sell_level       = -5;
extern double              wpr_buy_level        = -95;
extern int                 open_bar             = 0;
extern string              menucomment02        = "========= Прочие параметры =========";
extern int                 magic                = 9238;
       int                 slippage_open        = 3;
       int                 slippage_close       = 15;
       int                 TryToTrade           = 20;
       int                 WaitTime             = 1500;
extern int                 CommentSize          = 7;


int      i, r, z,                               // переменные для пересчетов for
         dg, dig,                               // округление лотов и цены
         last_ticket;                           // последние тикет для пересчета ордеров for
bool     Work=true, Test=false,                 // флаг разрашения работы и фраг работы в тестере
         long_allowed=true, short_allowed=true; // разрешение покупать и продавать
double   Pp, Mnoj,                              // Point округленный до 2/4 знака и обратный множитель
         Pp2, Mnoj2,                            // стандартный Point и обратный множитель
         min_lot, max_lot;                      // минимальный и максимальный лот
string   Symb,                                  // валюта инструмента
         CommentBox[],cm2;                      // комментарий на графике

datetime time_bar;                              // время открытие нулевой свечи
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
void start() {
   if (!Work) return;
   if(!IsTradeAllowed()) return;
   // получение сигнала _________________________________________________________________________________________________________
   int signal=-1;
   if (time_bar!=iTime(Symb,time_frame,0)) {
      double ma      = iMA(Symb,time_frame,ma_period,0,ma_method,ma_price,open_bar);
      double wpr_last= iWPR(Symb,time_frame,wpr_period,open_bar+1);
      double wpr_now = iWPR(Symb,time_frame,wpr_period,open_bar);
      if(Bid>ma && wpr_last>wpr_buy_level && wpr_now<=wpr_buy_level) signal=0;
      if(Bid<ma && wpr_last<wpr_sell_level && wpr_now>=wpr_sell_level) signal=1;
      if(signal!=-1 || open_bar>0) time_bar=iTime(Symb,time_frame,0);
      }
   // учет ордеров ______________________________________________________________________________________________________________
   int open_orders   = 0;
   last_ticket=-1;
   for(i=OrdersTotal()-1;i>=0;i--) if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==Symb && OrderMagicNumber()==magic) {
      if(last_ticket==OrderTicket()) continue;
      last_ticket=OrderTicket();
      if(signal!=OrderType() && signal!=-1) { CloseOrder(OrderTicket()); continue; }
      open_orders++;
      }
   // торговое решение __________________________________________________________________________________________________________
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
   if (!IsTesting() && !TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) PnC("Проверьте в настройках терминала разрешение на автоматическую торговлю!",1);
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
   if (Start_Hour>End_Hour) { // час открытия больше часа закрытия
      if (HOUR<Start_Hour && HOUR>End_Hour) TradeAllow=false;
      }else{ // час октрытия меньше часа закрытия
      if (HOUR<Start_Hour || HOUR>End_Hour) TradeAllow=false;
      }
   if (HOUR==Start_Hour && MIN<Start_Min) TradeAllow=false;
   if (HOUR==End_Hour && MIN>=End_Min)  TradeAllow=false;
   if (TradeAllow) return(true); else return(false);
   }
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
>>>         Функция открытия ордера
>>> Параметры:
>>>   int      Ticket   - тикет открываемого ордера      
>>>   int      Type     - тип открываемого ордера (0-BUY, 1-SELL, 2-BUYLIMIT, 3-SELLLIMIT, 4-BUYSTOP, 5-SELLSTOP)
>>>   double   LT       - объем открываемого ордера
>>>   
>>>   double   OP       - цены по которой открываем ордер (если Type равен 0 или 1, задавать не имеет смысла)
>>>   int      ModeSL   - метод задаваемого стоп лоса (0-конкретная цена инструмента, 1-пункты)
>>>   double   SL       - стоп лосс
>>>   int      ModeTP   - метод задаваемого тейк профита (0-конкретная цена инструмента, 1-пункты)
>>>   double   TP       - тейк профит
>>>   string   CM       - комментарий ордера
>>>   int      MG       - меджик ордера
>>>   
>>> Возвращаемые значения:
>>>   Возвращает TRUE при успешном завершении функции. Возвращает FALSE при неудачном завершении функции.
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
bool SendOrder(int &Ticket, int Type ,double LT ,double OP=-1 ,int ModeSL=0 ,double SL=0 ,int ModeTP=0 ,double TP=0, string CM="", int MG=-1) {
   if(MG==-1) MG=magic;
   color CL;
   int k,LastError;
   bool TickeT;
   if (Type==0) CL=Blue; else  if (Type==1) CL=Red; else  if (Type==2 || Type==4) CL=DarkTurquoise; else if (Type==3 || Type==5) CL=Orange;
   // проверка направления
   if(Type==0 || Type==2 || Type==4) {
      if(!long_allowed) return(false);
      }else{
      if(!short_allowed) return(false);
      }
   // проверка объема
   if (LT*MarketInfo(Symbol(),MODE_MARGINREQUIRED)>AccountFreeMargin()) {
      PnC(StringConcatenate("[S] Не хватает средств для открытия сделки ",TypeToStr(Type)," объемом: ",DoubleToStr(LT,dg)),1);
      PnC("[S] Советник прекратил работу",1);
      Work=false;
      return(false);
      }
   if(LT<min_lot) {
      PnC(StringConcatenate("[S] Объем сделки меньше минимального ",DoubleToStr(min_lot,dg),". Будет открыт минимальный объем"),1);
      LT=min_lot;
      }
   if(LT>max_lot) {
      PnC(StringConcatenate("[S] Объем сделки больше максимального ",DoubleToStr(min_lot,dg),". Будет открыт максимальный объем"),1);
      LT=max_lot;
      }
   // проверка отложенных ордеров
   double Slv=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point;
   switch(Type) {
      case 2: if(Ask-OP<Slv) OP=Ask-Slv; break;
      case 3: if(OP-Bid<Slv) OP=Bid+Slv; break;
      case 4: if(OP-Ask<Slv) OP=Ask+Slv; break;
      case 5: if(Bid-OP<Slv) OP=Bid-Slv; break;
      }
   // открытие
   for(k=0;k<TryToTrade;k++) {
      RefreshRates(); 
      if (Type==0) OP=Ask; 
      if (Type==1) OP=Bid;  
      PnC(StringConcatenate("[S] Открытие ордера ",TypeToStr(Type)," объемом: ",DoubleToStr(LT,dg)," по цене: ",DoubleToStr(OP,dig)," меджик: ",MG," комментарий: ",CM),0); 
      if (IsTradeAllowed()) {
         Ticket=OrderSend(Symbol(),Type,LT,NormalizeDouble(OP,dig),slippage_open,0,0,CM,MG,0,CL);
         }else{ 
         PnC(StringConcatenate("[S] Торговый поток занят, ждем ",k),0); 
         Sleep(WaitTime); 
         continue; 
         }
      if (Ticket > 0) { 
         PnC(StringConcatenate("[S] Успешно открыт ордер ",Ticket),0); 
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
      PnC(StringConcatenate("[S] Не удалось открыть ордер"),1); 
      return(false);
      }
   if(!OrderSelect(Ticket,SELECT_BY_TICKET)) {
      PnC(StringConcatenate("[S] Ошибка выбора открытого ордера ",Ticket," для выставления стопов"),1); 
      return(false);
      }
   // проверка и расчет стопов
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
   // выставляем стопы
   for(k=0;k<TryToTrade;k++) {
      PnC(StringConcatenate("[S] Установка стопов на ордер: ",Ticket," с/л: ",DoubleToStr(SL,dig)," т/п: ",DoubleToStr(TP,dig)),0);
      if (IsTradeAllowed()) {
         TickeT=OrderModify(Ticket,OrderOpenPrice(),NormalizeDouble(SL,dig),NormalizeDouble(TP,dig),0,CLR_NONE);
         }else{ 
         PnC(StringConcatenate("[S] Торговый поток занят, ждем ",k),0); 
         Sleep(WaitTime); 
         continue; 
         }
      if (TickeT) { 
         PnC(StringConcatenate("[S] Успешно модифицирован ордер ",Ticket),0); 
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
>>>         Функция модификации ордера
>>> Параметры:
>>>   int      Ticket   - номер ордера
>>>   
>>>   double   OP       - новая цена открытия ордера. Если -1 - останется без изменений
>>>   int      ModeSL   - метод задаваемого стоп лоса (0-конкретная цена инструмента, 1-пункты)
>>>   double   SL       - новый стоп лосс ордера. Если -1 - останется без изменений
>>>   int      ModeTP   - метод задаваемого тейк профита (0-конкретная цена инструмента, 1-пункты)
>>>   double   TP       - новый тейк профит ордера. Если -1 - останется без изменений
>>>   
>>> Возвращаемые значения:
>>>   Возвращает TRUE при успешном завершении функции. Возвращает FALSE при неудачном завершении функции.
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
bool ModifyOrder (int Ticket,double OP=-1,int ModeSL=0 ,double SL=0 ,int ModeTP=0 ,double TP=0) {
   bool TickeT;
   int k,LastError;
   TickeT=OrderSelect(Ticket,SELECT_BY_TICKET);
   if (!TickeT) {
      PnC("[M] Ошибка выбора ордера для модификации ",0);
      return(false);
      }
   if (OrderCloseTime()>0) {
      PnC("[M] Ордер был закрыт или удален",0);
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
   if(OP<0) OP=OrderOpenPrice(); else cm="цена " + DoubleToStr(OrderOpenPrice(),dig) + " => " + DoubleToStr(OP,dig) + "; ";
   if(SL<0) SL=OrderStopLoss(); else cm=cm+"с/л " + DoubleToStr(OrderStopLoss(),dig) + " => " + DoubleToStr(SL,dig) + "; ";
   if(TP<0) TP=OrderTakeProfit(); else cm=cm+"т/п " + DoubleToStr(OrderTakeProfit(),dig) + " => " + DoubleToStr(TP,dig) + "; ";
   if(Type==0 || Type==3 || Type==5) cm=cm+"текущая цена Bid: "+DoubleToStr(Bid,dig);
   if(Type==1 || Type==2 || Type==4) cm=cm+"текущая цена Ask: "+DoubleToStr(Ask,dig);
   color modify_color;
   if(MathMod(OrderType(),2.0)==0) modify_color=Aqua; else modify_color=Orange;
   for(k=0;k<TryToTrade;k++) {
      PnC(StringConcatenate("[M] Модификация ордера: ",Ticket," ",cm),0);
      if (IsTradeAllowed()) {
         TickeT=OrderModify(Ticket,NormalizeDouble(OP,dig),NormalizeDouble(SL,dig),NormalizeDouble(TP,dig),0,modify_color);
         }else{ 
         PnC(StringConcatenate("[M] Торговый поток занят, ждем ",k),0); 
         Sleep(WaitTime); 
         continue; 
         }
      if (TickeT ==true) { 
         PnC(StringConcatenate("[M] Успешно модифицирован ордер ",Ticket),0); 
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
>>>         Функция закрытия ордера
>>> Параметры:
>>>   int      Ticket   - номер ордера
>>>   
>>>   double   LT       - объем который необходимо закрыть. Если -1 - ордер будет закрыт полностью
>>>   
>>> Возвращаемые значения:
>>>   Возвращает TRUE при успешном завершении функции. Возвращает FALSE при неудачном завершении функции.
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
bool CloseOrder(int Ticket,double LT=-1) {
   bool TickeT;
   double OCP;
   int k,LastError;
   TickeT=OrderSelect(Ticket,SELECT_BY_TICKET);
   if (!TickeT) {
      PnC("[C] Ошибка выбора ордера для закрытия ",0);
      return(false);
      }
   if (OrderCloseTime()>0) {
      PnC("[C] Ордер был закрыт или удален",0);
      return(false);
      }
   int Type=OrderType();
   if (Type>1) {
      PnC("[C] Ордер закрыть нельзя, он отложенный ",0);
      return(false);
      }
   if(LT==-1) LT=NormalizeDouble(OrderLots(),dg); else LT=NormalizeDouble(LT,dg);
   for(k=0;k<=TryToTrade;k++) {
      RefreshRates(); 
      if (Type==0) OCP=Bid; else OCP=Ask;
      PnC(StringConcatenate("[C] Закрытие ордера ",TypeToStr(Type)," номер: ",Ticket," объемом: ",DoubleToStr(LT,dg)," по цене: ",DoubleToStr(OCP,dig)),0);
      if (IsTradeAllowed()) {
         TickeT=OrderClose(Ticket,LT,NormalizeDouble(OCP,dig),slippage_close,White);
         }else{ 
         PnC(StringConcatenate("[C] Торговый поток занят, ждем ",k),0); 
         Sleep(WaitTime); 
         continue; 
         }
      if (TickeT) { 
         PnC(StringConcatenate("[C] Успешно закрыт ордер ",Ticket),0); 
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
>>>         Функция удаления ордера
>>> Параметры:
>>>   int      Ticket   - номер ордера
>>>   
>>> Возвращаемые значения:
>>>   Возвращает TRUE при успешном завершении функции. Возвращает FALSE при неудачном завершении функции.
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
bool DeleteOrder(int Ticket) {
   bool TickeT;
   int k,LastError;
   TickeT=OrderSelect(Ticket,SELECT_BY_TICKET);
   if (!TickeT) {
      PnC(StringConcatenate("[D] Ошибка выбора ордера для закрытия ",Ticket),0);
      return(false);
      }
   if (OrderCloseTime()>0) {
      PnC(StringConcatenate("[D] Ордер был закрыт или удален ",Ticket),0);
      return(false);
      }
   int Type=OrderType();
   if (Type<2) {
      PnC(StringConcatenate("[D] Ордер удалить нельзя, он уже исполнен ",Ticket),0);
      return(false);
      }
   for(k=0;k<=TryToTrade;k++) {
      PnC(StringConcatenate("[D] Удаление ордера: ",Ticket," тип: ",TypeToStr(Type)),0);
      if (IsTradeAllowed()) {
         TickeT=OrderDelete(Ticket);
         }else{ 
         PnC(StringConcatenate("[D] Торговый поток занят, ждем ",k),0); 
         Sleep(WaitTime); 
         continue; 
         }
      if (TickeT) { 
         PnC(StringConcatenate("[D] Успешно удален ордер ",Ticket),0); 
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
>>>         Функция удаления и закрытия всех ордеров
>>> Возвращаемые значения:
>>>   Возвращает TRUE при успешном завершении функции. Возвращает FALSE при неудачном завершении функции.
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
>>>         Функция удаления всех ордеров
>>> Возвращаемые значения:
>>>   Возвращает TRUE при успешном завершении функции. Возвращает FALSE при неудачном завершении функции.
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
>>>         Функция текстовых сообщений
>>> Описание:
>>>   Функция позволяет отображать системные сообщения на экране в виде ленты в левом верхнем углу экрана, 
>>>   заносить их в журнал а также при необходимости отображать уведомление (Alert).
>>>
>>> Параметры:
>>>   string   txt      - текст сообщения
>>>   int      Mode     - тип сообщения (0-только Print, 1-Print и Alert, 2-ничего)
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
>>>         Функция преобразования типа ордера
>>> Описание:
>>>   Преобразование числа, содержащего числовое представление типа ордера в строку
>>>
>>> Параметры:
>>>   int      Type     -  тип ордера (0-BUY, 1-SELL, 2-BUYLIMIT, 3-SELLLIMIT, 4-BUYSTOP, 5-SELLSTOP)
>>>   
>>> Возвращаемые значения:
>>>   В случае успешного исполнения функции возвращает строку с типом переменной. В обратном случае возвращает "NONE".
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
>>>         Функция преобразования тайм фрейма
>>> Описание:
>>>   Преобразование тайм фрейма, содержащего числовое представление времени в строку
>>>
>>> Параметры:
>>>   int      pts_period   -  тайм фрейм (0,1,5,15,30,60,240,1440,10080,43200)
>>>   
>>> Возвращаемые значения:
>>>   В случае успешного исполнения функции возвращает строку с тайм фреймом. В обратном случае возвращает "NONE".
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
>>>         Функция обработки ошибок
>>> Описание:
>>>   Функция выводит сообщение об ошибке с текстовым описанием, а также возвращает ответ в зависимости от того к какой из трех групп принадлежит ошибка.
>>>   Также в случае ошибок 4110 и 4111 (запрет на торговлю в определенном направлении в общих настройках эксперта) меняет переменные long.allowed и 
>>>   short.allowed на false с тем чтобы в следующий раз функция SendOrder не исполнялась в этом же направлении
>>>
>>> Параметры:
>>>   int      er       - номер ошибки
>>>   
>>> Возвращаемые значения:
>>>   В случае успешного исполнения функции возвращает одиз из трех ответов:
>>>   0 - следует повторить выполнение торговой функции
>>>   1 - следует прекратить выполнение торговой функции
>>>   2 - следует завершить работу советника
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
int Fun_Error(int er) {
   switch(er) {
      // группа 1: не прекращать попытки
      case 2: PnC("Общая ошибка",0); return(0);
      case 4: PnC("Торговый сервер занят",0); return(0);
      case 8: PnC("Слишком частые запросы",0); return(0);
      case 129: PnC("Неправильная цена",0); return(0);
      case 135: PnC("Цена изменилась",0); return(0);
      case 136: PnC("Нет цен",0); return(0);
      case 137: PnC("Брокер занят",0); return(0);
      case 138: PnC("Новые цены",0); return(0);
      case 141: PnC("Слишком много запросов",0); return(0);
      case 146: PnC("Подсистема торговли занята",0); return(0);
      // группа 2: прекращаем попытки
      case 0: PnC("Ошибка отсутствует",0); return(1);
      case 1: PnC("Нет ошибки, но результат не известен",0); return(1);
      case 3: PnC("Неправильные параметры",0); return(1);
      case 6: PnC("Нет связи с торговым сервером",0); return(1);
      case 128: PnC("Истек срок ожидания совершения сделки",0); return(1);
      case 130: PnC("Неправильные стопы",0); return(1);
      case 131: PnC("Неправильный объем",0); return(1);
      case 132: PnC("Рынок закрыт",0); return(1);
      case 133: PnC("Торговля запрещена",0); return(1);
      case 134: PnC("Недостаточно денег для совершения операции",0); return(1);
      case 139: PnC("Ордер заблокирован и уже обрабатывается",0); return(1);
      case 145: PnC("Модификация запрещена, так как ордер слишком близок к рынку",0); return(1);
      case 148: PnC("Количество открытых и отложенных ордеров достигло предела, установленного брокером",0); return(1);
      case 4000: PnC("Нет ошибки",0); return(1);
      case 4107: PnC("Неправильный параметр цены для торговой функции",0); return(1);
      case 4108: PnC("Ордер не найден",0); return(1);
      case 4110: PnC("BUY позиции не разрешены",0); long_allowed=false; return(1);
      case 4111: PnC("SELL позиции не разрешены",0); short_allowed=false; return(1);
      // группа 3: завершаем работу
      case 5: PnC("Старая версия клиентского терминала",1); return(2);
      case 7: PnC("Недостаточно прав",1); return(2);
      case 9: PnC("Недопустимая операция нарушающая функционирование сервера",1); return(2);
      case 64: PnC("Счет заблокирован",1); return(2);
      case 65: PnC("Неправильный номер счета",1); return(2);
      case 140: PnC("Разрешена только покупка",1); return(2);
      case 147: PnC("Использование даты истечения ордера запрещено брокером",1); return(2);
      case 149: PnC("Попытка открыть противоположную позицию к уже существующей в случае, если хеджирование запрещено",1); return(2);
      case 150: PnC("Попытка закрыть позицию по инструменту в противоречии с правилом FIFO",1); return(2);
      case 4109: PnC("Торговля не разрешена, разрешите торговлю советнику и перезапустите его",1); return(2);
      }
   return(0);
   }                     
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


