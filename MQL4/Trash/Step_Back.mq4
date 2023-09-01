//+------------------------------------------------------------------+
//|                                                    Step Back.mq4 |
//|                              Copyright 2016, Vladimir Gribachev. |
//|                                         http://moneystrategy.ru/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, Vladimir Gribachev."
#property link      "http://moneystrategy.ru/"
#property version   "1.00"
#property strict
#property strict

extern int    PriceMove      = 10;
extern int    TakeProfit     = 50;
extern int    StopLoss       = 15;
extern double AutoLot        = 1.00;
extern double Lot            = 0.01;
extern int    Magic          = 12345;
extern string Com            = "Step Back";
extern int    BreakevenStop  = 5;
extern int    BreakevenStep  = 1;
extern int    TrailingStop   = 15;
extern int    TrailingStep   = 3;
extern bool   DrawInfo       = true;

string Font="Tahoma",Comm,sBut[4];
datetime StartHistory=D'2000.01.01';
int Attempts=10,Pause=30,FontSize=9,LowBar,HighBar,Up,Dn;
double SL,TP,OOP;
bool Signal[2];
color Header=clrOrange,Body=clrGray,TextColor=clrWhite;
int up_moving,dn_moving;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class AccountHistory
  {
private:
   int               c_Magic; // Магик
   datetime          c_HistoryBegin; // Начало истории
   double            c_ProfitByMagic; // Общий профит по магику
   double            c_TotalProfit; // Общий профит по счету
   double            c_LossByMagic; // Общий убыток по магику
   double            c_TotalLoss; // Общий убыток по счету
   double            c_Deposit; // Пополнение счета
   double            c_Withdraw; // Снятие со счета
   double            c_InitialDeposit; // Начальный депозит
   datetime          c_HistoryLastCalc; // Последний пересчет
   int               c_TradesByMagicWithProfit; // Количество прибыльных сделок
   int               c_TradesByMagicWithLoss; // Количесвто убыточных сделок
   void              ReCalulation(datetime HistoryBegin,int Magic);

public:
   void              Init(datetime HistoryBegin=0,int l_Magic=-1); // Инициализация переменных
   void     SetHistoryBegin(datetime HistoryBegin) {ReCalulation(HistoryBegin,c_Magic); return;} // Установка начала истории
   void     Setl_Magic(int l_Magic) {ReCalulation(c_HistoryBegin,l_Magic); return;} // Установка Магика
   int      TotalTrades() {ReCalulation(c_HistoryBegin,c_Magic); return(c_TradesByMagicWithProfit+c_TradesByMagicWithLoss);} //Общее количество сделок по магику
   int      TotalTrades(int l_Magic) {ReCalulation(c_HistoryBegin,l_Magic); return(c_TradesByMagicWithProfit+c_TradesByMagicWithLoss);} //Общее количество сделок по магику
   int      TotalTrades(datetime HistoryBegin,int l_Magic) {ReCalulation(HistoryBegin,l_Magic); return(c_TradesByMagicWithProfit+c_TradesByMagicWithLoss);}  //Общее количество сделок по магику
   int      ProfitTrades() {ReCalulation(c_HistoryBegin,c_Magic); return c_TradesByMagicWithProfit;} // Количество прибыльных сделок по магику
   int      ProfitTrades(int l_Magic) {ReCalulation(c_HistoryBegin,l_Magic); return c_TradesByMagicWithProfit;} // Количество прибыльных сделок по магику
   int      ProfitTrades(datetime HistoryBegin,int l_Magic) {ReCalulation(HistoryBegin,l_Magic); return c_TradesByMagicWithProfit;} // Количество прибыльных сделок по магику
   int      LossTrades() {ReCalulation(c_HistoryBegin,c_Magic); return c_TradesByMagicWithLoss;} // Количество убыточных сделок по магику
   int      LossTrades(int l_Magic) {ReCalulation(c_HistoryBegin,l_Magic); return c_TradesByMagicWithLoss;} // Количество убыточных сделок по магику
   int      LossTrades(datetime HistoryBegin,int l_Magic) {ReCalulation(HistoryBegin,l_Magic); return c_TradesByMagicWithLoss;} // Количество убыточных сделок по магику
   double   Profitfactor() {ReCalulation(c_HistoryBegin,c_Magic); if(c_LossByMagic!=0) return(c_ProfitByMagic/c_LossByMagic); else return 0;} // Профитфактор по магику
   double   Profitfactor(int l_Magic) {ReCalulation(c_HistoryBegin,l_Magic); if(c_LossByMagic!=0) return(c_ProfitByMagic/c_LossByMagic); else return 0;} // Профитфактор по магику
   double   Profitfactor(datetime HistoryBegin,int l_Magic) {ReCalulation(HistoryBegin,l_Magic); if(c_LossByMagic!=0) return(c_ProfitByMagic/c_LossByMagic); else return 0;} // Профитфактор по магику
   double   TotalProfit() {ReCalulation(c_HistoryBegin,c_Magic); return(c_ProfitByMagic-c_LossByMagic);} // Общая прибыль по магику
   double   TotalProfit(int l_Magic) {ReCalulation(c_HistoryBegin,l_Magic); return(c_ProfitByMagic-c_LossByMagic);} // Общая прибыль по магику
   double   TotalProfit(datetime HistoryBegin,int l_Magic) {ReCalulation(HistoryBegin,l_Magic); return(c_ProfitByMagic-c_LossByMagic);} // Общая прибыль по магику
   double   Payoff() {ReCalulation(c_HistoryBegin,c_Magic); if((c_TradesByMagicWithProfit+c_TradesByMagicWithLoss)!=0) return((c_ProfitByMagic-c_LossByMagic)/(c_TradesByMagicWithProfit+c_TradesByMagicWithLoss)); else return 0;} // Математическое ожидание по магику
   double   Payoff(int l_Magic) {ReCalulation(c_HistoryBegin,l_Magic); if((c_TradesByMagicWithProfit+c_TradesByMagicWithLoss)!=0) return((c_ProfitByMagic-c_LossByMagic)/(c_TradesByMagicWithProfit+c_TradesByMagicWithLoss)); else return 0;} // Математическое ожидание по магику
   double   Payoff(datetime HistoryBegin,int l_Magic) {ReCalulation(HistoryBegin,l_Magic); if((c_TradesByMagicWithProfit+c_TradesByMagicWithLoss)!=0) return((c_ProfitByMagic-c_LossByMagic)/(c_TradesByMagicWithProfit+c_TradesByMagicWithLoss)); else return 0;} // Математическое ожидание по магику
   double   AverageProfit() {ReCalulation(c_HistoryBegin,c_Magic); if(c_TradesByMagicWithProfit!=0) return(c_ProfitByMagic/c_TradesByMagicWithProfit); else return 0;} // Средняя прибыль по магику
   double   AverageProfit(int l_Magic) {ReCalulation(c_HistoryBegin,l_Magic); if(c_TradesByMagicWithProfit!=0) return(c_ProfitByMagic/c_TradesByMagicWithProfit); else return 0;} // Средняя прибыль по магику
   double   AverageProfit(datetime HistoryBegin,int l_Magic) {ReCalulation(HistoryBegin,l_Magic);if(c_TradesByMagicWithProfit!=0) return(c_ProfitByMagic/c_TradesByMagicWithProfit); else return 0;} // Средняя прибыль по магику
   double   AverageLoss() {ReCalulation(c_HistoryBegin,c_Magic); if(c_TradesByMagicWithLoss!=0) return(c_LossByMagic/c_TradesByMagicWithLoss); else return 0;} // Средний убыток по магику
   double   AverageLoss(int l_Magic) {ReCalulation(c_HistoryBegin,l_Magic); if(c_TradesByMagicWithLoss!=0) return(c_LossByMagic/c_TradesByMagicWithLoss); else return 0;} // Средний убыток по магику
   double   AverageLoss(datetime HistoryBegin,int l_Magic) {ReCalulation(HistoryBegin,l_Magic); if(c_TradesByMagicWithLoss!=0) return(c_LossByMagic/c_TradesByMagicWithLoss); else return 0;} // Средний убыток по магику
   double   InitialDeposit() {if(c_HistoryBegin==c_HistoryLastCalc) ReCalulation(c_HistoryBegin,c_Magic); return(c_InitialDeposit);} // Начальный депозит
   double   InitialDeposit(datetime HistoryBegin) {if(c_HistoryBegin==c_HistoryLastCalc || c_HistoryBegin!=HistoryBegin) ReCalulation(HistoryBegin,c_Magic); return(c_InitialDeposit);} // Начальный депозит
   double   Deposit() {ReCalulation(c_HistoryBegin,c_Magic); return(c_Deposit);} // Пополнение
   double   Deposit(datetime HistoryBegin) {ReCalulation(HistoryBegin,c_Magic); return(c_Deposit);}  // Пополнение
   double   Withdraw() {ReCalulation(c_HistoryBegin,c_Magic); return(c_Withdraw);} // Снятие
   double   Withdraw(datetime HistoryBegin) {ReCalulation(HistoryBegin,c_Magic); return(c_Withdraw);} // Снятие
  };
AccountHistory AccountInformation;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   AccountInformation.Init(StartHistory,-1);
   if(_Digits==3 || _Digits==5)
     {
      TakeProfit*=10;
      StopLoss*=10;
      TrailingStop*=10;
      TrailingStep*=10;
      BreakevenStop*=10;
      BreakevenStep*=10;
     }
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   for(int i=0; i<ObjectsTotal(0,-1,-1);i++)
     {
      if(StringFind(ObjectName(0,i),"Label")>=0)
         if(ObjectDelete(0,ObjectName(0,i)))
            i--;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   int Tick,LastTick;
   double open,high,low,close;
   NoBack(up_moving,dn_moving,open,high,low,close,Tick,LastTick);

   if(DrawInfo)Info();

   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol()==Symbol() && (OrderMagicNumber()==Magic || Magic==0))
           {
            if(OrderType()==OP_BUY)
              {
               AverageBreakeven(OP_BUY);
               if(OrderStopLoss()==0 || OrderTakeProfit()==0)AverageTPSL(OP_BUY);
              }
            if(OrderType()==OP_SELL)
              {
               AverageBreakeven(OP_SELL);
               if(OrderStopLoss()==0 || OrderTakeProfit()==0)AverageTPSL(OP_SELL);
              }
           }
     }

   double order_lots=0,LB=0,LS=0,price_b=0,price_s=0;
   double osl,otp,oop,sl,prof=0,prof_buy=0,prof_sell=0,maxlot_buy=0,maxlot_sell=0;
   int i,buy=0,sell=0,tip;
   for(i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && (OrderMagicNumber()==Magic || Magic==0))
           {
            tip = OrderType();
            oop = NormalizeDouble(OrderOpenPrice(),Digits);
            order_lots=OrderLots();
            if(tip==OP_BUY)
              {
               price_b+=oop*order_lots;
               prof_buy+=OrderProfit()+OrderCommission()+OrderSwap();
               buy++;
               LB+=order_lots;
               if(maxlot_buy<order_lots || maxlot_buy==0) maxlot_buy=order_lots;
              }
            if(tip==OP_SELL)
              {
               price_s+=oop*order_lots;
               prof_sell+=OrderProfit()+OrderCommission()+OrderSwap();
               sell++;
               LS+=order_lots;
               if(maxlot_sell<order_lots || maxlot_sell==0) maxlot_sell=order_lots;
              }
           }
        }
     }
   prof=prof_buy+prof_sell;
//---
   double trailsell=0,trailbuy=0,trailstopsell=0,trailstopbuy=0;
//---   
   if(buy>0)
     {
      trailbuy=NormalizeDouble(price_b/LB+(TrailingStop+TrailingStep)*Point/buy,Digits);
      trailstopbuy=NormalizeDouble(price_b/LB+TrailingStep*Point/buy,Digits);
      if(DrawInfo)Text("text_b",(StringConcatenate("———[ ",buy," | ",DoubleToStr(LB,2)," | ",DoubleToStr(prof_buy,2)," ]")),Time[1],trailbuy,style(prof_buy>0,clrLawnGreen,clrOrange),true);
     }
   if(buy==0)ObjectDelete(0,"text_b");

   if(sell>0)
     {
      trailsell=NormalizeDouble(price_s/LS-(TrailingStop+TrailingStep)*Point/sell,Digits);
      trailstopsell=NormalizeDouble(price_s/LS-TrailingStep*Point/sell,Digits);
      if(DrawInfo)Text("text_s",(StringConcatenate("———[ ",sell," | ",DoubleToStr(LS,2)," | ",DoubleToStr(prof_sell,2)," ]")),Time[1],trailsell,style(prof_sell>0,clrLawnGreen,clrOrange),true);
     }
   if(sell==0)ObjectDelete(0,"text_s");
//---
   if(buy+sell>0)
     {
      for(i=0; i<OrdersTotal(); i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
           {
            if(OrderSymbol()==Symbol() && (OrderMagicNumber()==Magic || Magic==0))
              {
               tip = OrderType();
               osl = NormalizeDouble(OrderStopLoss(),Digits);
               otp = NormalizeDouble(OrderTakeProfit(),Digits);
               oop = NormalizeDouble(OrderOpenPrice(),Digits);
               sl=osl;
               if(tip==OP_BUY)
                 {
                  if(otp==0)AverageTPSL(OP_BUY);
                  sl=NormalizeDouble(Bid-TrailingStop*Point,_Digits);
                  if((sl>osl || osl==0) && sl>=trailstopbuy && sl!=osl)
                    {
                     //Print("trailing buy error: ",Error(GetLastError()));
                     if(!OrderModify(OrderTicket(),oop,sl,otp,0,clrLawnGreen))
                        Print("trailing buy error: ",Error(GetLastError()));
                    }
                  Sleep(1000);
                  RefreshRates();
                 }
               if(tip==OP_SELL)
                 {
                  if(otp==0)AverageTPSL(OP_SELL);
                  sl=NormalizeDouble(Ask+TrailingStop*Point,_Digits);
                  if((sl<osl || osl==0) && sl<=trailstopsell && sl!=osl)
                    {
                     //Print("trailing sell error: ",Error(GetLastError()));
                     if(!OrderModify(OrderTicket(),oop,sl,otp,0,clrOrange))
                        Print("trailing sell error: ",Error(GetLastError()));
                    }
                  Sleep(1000);
                  RefreshRates();
                 }
              }
           }
        }
     }

//---   
   double lot=0;

   if(AutoLot>0)lot=MoneyManagement();
   if(AutoLot<=0)lot=Lot;
   lot=NormalizeLots(lot,_Symbol);
//---
   if(up_moving>=PriceMove && (CountBuy()+CountSell()==0 || Ask>=FindLastPrice(OP_BUY)))
     {
      if(AccountFreeMarginCheck(Symbol(),OP_BUY,lot)<=0){Print("order send error: ",Error(GetLastError()));return;}
      if(AntiRequoteOrderSend(Symbol(),OP_BUY,lot,NormalizeDouble(Ask,Digits),0,0,0,Com,Magic,0,clrNONE)==-1)
         Print("order send error: ",Error(GetLastError()));
     }
//---
   if(dn_moving>=PriceMove && (CountBuy()+CountSell()==0 || Bid<=FindLastPrice(OP_SELL)))
     {
      if(AccountFreeMarginCheck(Symbol(),OP_SELL,lot)<=0){Print("order send error: ",Error(GetLastError()));return;}
      if(AntiRequoteOrderSend(Symbol(),OP_SELL,lot,NormalizeDouble(Bid,Digits),0,0,0,Com,Magic,0,clrNONE)==-1)
         Print("order send error: ",Error(GetLastError()));
     }
//---        
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double MoneyManagement()
  {
   double DynamicLot=0;
   double Free_Equity=AccountEquity();
   if(Free_Equity<=0)return(0);
   double TickValue=MarketInfo(Symbol(),MODE_TICKVALUE);
   double LotStep=MarketInfo(Symbol(),MODE_LOTSTEP);
   DynamicLot=MathFloor((Free_Equity*MathMin(AutoLot,100)/100)/(StopLoss*TickValue)/LotStep)*LotStep;
   double MinLot=MarketInfo(Symbol(),MODE_MINLOT);
   double MaxLot=MarketInfo(Symbol(),MODE_MAXLOT);
   if(DynamicLot<MinLot)DynamicLot=MinLot;
   if(DynamicLot>MaxLot)DynamicLot=MaxLot;
   return(DynamicLot);
  }
//+------------------------------------------------------------------+
//|  Функция нормализации объема сделки                              |
//+------------------------------------------------------------------+
double NormalizeLots(double lots,string l_Symbol)
  {
   double result=0;
   double minLot=SymbolInfoDouble(l_Symbol,SYMBOL_VOLUME_MIN);
   double maxLot=SymbolInfoDouble(l_Symbol,SYMBOL_VOLUME_MAX);
   double stepLot=SymbolInfoDouble(l_Symbol,SYMBOL_VOLUME_STEP);
   if(lots>0)
     {
      lots=MathMax(minLot,lots);
      lots=minLot+NormalizeDouble((lots-minLot)/stepLot,0)*stepLot;
      result=MathMin(maxLot,lots);
     }
   else
      result=minLot;
   return (NormalizeDouble(result,2));
  }
//+------------------------------------------------------------------+
//| Функция отправки приказов без реквотов                           |
//+------------------------------------------------------------------+
int AntiRequoteOrderSend(string symbol,int cmd,double volume,double pric,int slippage,double stoploss,double takeprofit,string comment="",int magic=0,datetime expiration=0,color arrow_color=CLR_NONE)
  {
   int ticket=0;
   int cnt=0;
   while(true)
     {
      if(cnt>=10) {Print("order not opened after ",10," attempts"); break;}
      cnt++;
      ticket=OrderSend(symbol,cmd,volume,pric,slippage,stoploss,takeprofit,comment,magic,expiration,arrow_color);
      if(ticket>0) break;
      Sleep(30000);
     }
   return(ticket);
  }
//+------------------------------------------------------------------+
//|  Профит                                                          |
//+------------------------------------------------------------------+
double valueprofit()
  {
   double ID=0;
   int OT=OrdersTotal();
   if(OT>0)
     {
      for(int i=OT-1; i>=0; i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
           {
            if((OrderMagicNumber()==Magic || Magic==0) && OrderSymbol()==_Symbol)
               ID+=OrderProfit()+OrderSwap()+OrderCommission();
           }
        }
     }
   return(ID);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double value_profit()
  {
   double ID=0;
   int OT=OrdersTotal();
   if(OT>0)
     {
      for(int i=OT-1; i>=0; i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
           {
            ID+=OrderProfit()+OrderSwap()+OrderCommission();
           }
        }
     }
   return(ID);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetLabel(string nm,string tx,color cl,int xd,int yd,int cr=0,int fs=9,string font="Tahoma")
  {
   if(ObjectFind(nm)<0) ObjectCreate(nm,OBJ_LABEL,0,0,0);
   ObjectSetText(nm,tx,fs,font,cl);
   ObjectSet(nm,OBJPROP_COLOR,cl);
   ObjectSet(nm,OBJPROP_XDISTANCE,xd);
   ObjectSet(nm,OBJPROP_YDISTANCE,yd);
   ObjectSet(nm,OBJPROP_CORNER,cr);
   ObjectSet(nm,OBJPROP_FONTSIZE,fs);
   ObjectSet(nm,OBJPROP_BACK,false);
   ObjectSet(nm,OBJPROP_SELECTABLE,false);
   ObjectSet(nm,OBJPROP_READONLY,false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AccountHistory::Init(datetime HistoryBegin=0,int l_Magic=-1)
  {
   c_Magic=l_Magic;
   c_HistoryBegin=HistoryBegin;
   c_ProfitByMagic=0;
   c_TotalProfit=0;
   c_LossByMagic=0;
   c_TotalLoss=0;
   c_Deposit=0;
   c_Withdraw=0;
   c_InitialDeposit=0;
   c_TradesByMagicWithProfit=0;
   c_TradesByMagicWithLoss=0;
   c_HistoryLastCalc=(datetime)MathMax(HistoryBegin-1,0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AccountHistory::ReCalulation(datetime l_HistoryBegin,int l_Magic)
  {
   if(c_HistoryBegin!=l_HistoryBegin || c_Magic!=l_Magic)
      Init(l_HistoryBegin,l_Magic);
   double BalanceCurrent=AccountBalance();
   datetime l_last_order=c_HistoryLastCalc;
   for(int i=OrdersHistoryTotal()-1; i>=0; i--)
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
        {
         if(OrderOpenTime()<=c_HistoryLastCalc)
            break;
         if(OrderCloseTime()<=c_HistoryLastCalc)
            continue;
         l_last_order=(datetime)MathMax(l_last_order,OrderCloseTime());
         double profit=OrderProfit()+OrderCommission()+OrderSwap();
         int magic=OrderMagicNumber();
         if(profit>=0)
           {
            switch(OrderType())
              {
               case 0:
               case 1:
                  c_TotalProfit+=profit;
                  if(c_Magic<0 || c_Magic==OrderMagicNumber())
                    {
                     c_TradesByMagicWithProfit++;
                     c_ProfitByMagic+=profit;
                    }
                  break;
               case 6:
                 {
                  if(i==0)
                     c_InitialDeposit=profit;
                  else
                     c_Deposit+=profit;
                 }
               break;
              }
           }
         if(profit<0)
           {
            switch(OrderType())
              {
               case 0:
               case 1:
                  c_TotalLoss-=profit;
                  if(c_Magic<0 || c_Magic==OrderMagicNumber())
                    {
                     c_TradesByMagicWithLoss++;
                     c_LossByMagic-=profit;
                    }
                  break;
               case 6:
                  c_Withdraw-=profit;
                  break;
              }
           }
        }
   c_HistoryLastCalc=l_last_order;
   if(c_InitialDeposit==0)
      c_InitialDeposit=BalanceCurrent-c_TotalProfit+c_TotalLoss-c_Deposit+c_Withdraw;
  }
//+------------------------------------------------------------------+
//|  Функция ошибок                                                  |
//+------------------------------------------------------------------+
string Error(int error_code)
  {
   string error_string;
   switch(error_code)
     {
      case 0:
         error_string="no error returned.";                                                                  break;
      case 1:
         error_string="no error returned, but the result is unknown.";                                       break;
      case 2:
         error_string="common error.";                                                                       break;
      case 3:
         error_string="invalid trade parameters.";                                                           break;
      case 4:
         error_string="trade server is busy.";                                                               break;
      case 5:
         error_string="old version of the client terminal.";                                                 break;
      case 6:
         error_string="no connection with trade server.";                                                    break;
      case 7:
         error_string="not enough rights.";                                                                  break;
      case 8:
         error_string="too frequent requests.";                                                              break;
      case 9:
         error_string="malfunctional trade operation.";                                                      break;
      case 64:
         error_string="account disabled.";                                                                   break;
      case 65:
         error_string="invalid account.";                                                                    break;
      case 128:
         error_string="trade timeout.";                                                                      break;
      case 129:
         error_string="invalid price.";                                                                      break;
      case 130:
         error_string="invalid stops.";                                                                      break;
      case 131:
         error_string="invalid trade volume.";                                                               break;
      case 132:
         error_string="market is closed.";                                                                   break;
      case 133:
         error_string="trade is disabled.";                                                                  break;
      case 134:
         error_string="not enough money.";                                                                   break;
      case 135:
         error_string="price changed.";                                                                      break;
      case 136:
         error_string="off quotes.";                                                                         break;
      case 137:
         error_string="broker is busy.";                                                                     break;
      case 138:
         error_string="requote.";                                                                            break;
      case 139:
         error_string="order is locked.";                                                                    break;
      case 140:
         error_string="long positions only allowed.";                                                        break;
      case 141:
         error_string="too many requests.";                                                                  break;
      case 145:
         error_string="modification denied because an order is too close to market.";                        break;
      case 146:
         error_string="trade context is busy.";                                                              break;
      case 147:
         error_string="expirations are denied by broker.";                                                   break;
      case 148:
         error_string="the amount of opened and pending orders has reached the limit set by a broker.";      break;
      case 4000:
         error_string="no error.";                                                                           break;
      case 4001:
         error_string="wrong function pointer.";                                                             break;
      case 4002:
         error_string="array index is out of range.";                                                        break;
      case 4003:
         error_string="no memory for function call stack.";                                                  break;
      case 4004:
         error_string="recursive stack overflow.";                                                           break;
      case 4005:
         error_string="not enough stack for parameter.";                                                     break;
      case 4006:
         error_string="no memory for parameter string.";                                                     break;
      case 4007:
         error_string="no memory for temp string.";                                                          break;
      case 4008:
         error_string="not initialized string.";                                                             break;
      case 4009:
         error_string="not initialized string in an array.";                                                 break;
      case 4010:
         error_string="no memory for an array string.";                                                      break;
      case 4011:
         error_string="too long string.";                                                                    break;
      case 4012:
         error_string="remainder from zero divide.";                                                         break;
      case 4013:
         error_string="zero divide.";                                                                        break;
      case 4014:
         error_string="unknown command.";                                                                    break;
      case 4015:
         error_string="wrong jump.";                                                                         break;
      case 4016:
         error_string="not initialized array.";                                                              break;
      case 4017:
         error_string="DLL calls are not allowed.";                                                          break;
      case 4018:
         error_string="cannot load library.";                                                                break;
      case 4019:
         error_string="cannot call function.";                                                               break;
      case 4020:
         error_string="EA function calls are not allowed.";                                                  break;
      case 4021:
         error_string="not enough memory for a string returned from a function.";                            break;
      case 4022:
         error_string="system is busy.";                                                                     break;
      case 4050:
         error_string="invalid function parameters count.";                                                  break;
      case 4051:
         error_string="invalid function parameter value.";                                                   break;
      case 4052:
         error_string="string function internal error.";                                                     break;
      case 4053:
         error_string="some array error.";                                                                   break;
      case 4054:
         error_string="incorrect series array using.";                                                       break;
      case 4055:
         error_string="custom indicator error.";                                                             break;
      case 4056:
         error_string="arrays are incompatible.";                                                            break;
      case 4057:
         error_string="global variables processing error.";                                                  break;
      case 4058:
         error_string="global variable not found.";                                                          break;
      case 4059:
         error_string="function is not allowed in testing mode.";                                            break;
      case 4060:
         error_string="function is not confirmed.";                                                          break;
      case 4061:
         error_string="mail sending error.";                                                                 break;
      case 4062:
         error_string="string parameter expected.";                                                          break;
      case 4063:
         error_string="integer parameter expected.";                                                         break;
      case 4064:
         error_string="double parameter expected.";                                                          break;
      case 4065:
         error_string="array as parameter expected.";                                                        break;
      case 4066:
         error_string="requested history data in updating state.";                                           break;
      case 4067:
         error_string="some error in trade operation execution.";                                            break;
      case 4099:
         error_string="end of a file.";                                                                      break;
      case 4100:
         error_string="some file error.";                                                                    break;
      case 4101:
         error_string="wrong file name.";                                                                    break;
      case 4102:
         error_string="too many opened files.";                                                              break;
      case 4103:
         error_string="cannot open file.";                                                                   break;
      case 4104:
         error_string="incompatible access to a file.";                                                      break;
      case 4105:
         error_string="no order selected.";                                                                  break;
      case 4106:
         error_string="unknown symbol.";                                                                     break;
      case 4107:
         error_string="invalid price param.";                                                                break;
      case 4108:
         error_string="invalid ticket.";                                                                     break;
      case 4109:
         error_string="trade is not allowed.";                                                               break;
      case 4110:
         error_string="longs are not allowed.";                                                              break;
      case 4111:
         error_string="shorts are not allowed.";                                                             break;
      case 4200:
         error_string="object already exists.";                                                              break;
      case 4201:
         error_string="unknown object property.";                                                            break;
      case 4202:
         error_string="object does not exist.";                                                              break;
      case 4203:
         error_string="unknown object type.";                                                                break;
      case 4204:
         error_string="no object name.";                                                                     break;
      case 4205:
         error_string="object coordinates error.";                                                           break;
      case 4206:
         error_string="no specified subwindow.";                                                             break;
      case 4207:
         error_string="ERR_SOME_OBJECT_ERROR.";                                                              break;
      default:
         error_string="error is not known.";
     }
   return(error_string);
  }
//+------------------------------------------------------------------+
double Profit(int Bar)
  {
   double OProfit=0;
   for(int i=0; i<OrdersHistoryTotal(); i++)
     {
      if(!(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))) break;
      if(OrderMagicNumber()==Magic || Magic==0)
        {
         if(OrderCloseTime()>=iTime(Symbol(),PERIOD_D1,Bar) && OrderCloseTime()<iTime(Symbol(),PERIOD_D1,Bar)+86400) OProfit+=OrderProfit();
        }
     }
   return (OProfit);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CountBuy()
  {
   int count = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i --)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && (OrderMagicNumber()==Magic || Magic==0))
            count++;
        }
     }
   return (count);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CountSell()
  {
   int count = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i --)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && (OrderMagicNumber()==Magic || Magic==0))
            count++;
        }
     }
   return (count);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void NoBack(int &iUP,int &iDN,double &open,double &HIGH,double &LOW,double &close,int &tick,int &lasttick)
  {
   static int LastTick=0;
   static int low=0,high=0;
   iUP=0;
   iDN=0;
   open=Open[0];
   HIGH=High[0];
   LOW=Low[0];
   close=Close[0];
   int Tick=(int)(close*MathPow(10,(_Digits>=4 ? 4 : 2)));
   if((Tick/MathPow(10,(_Digits>=4 ? 4 : 2)))<close && Tick<LastTick)
      Tick+=1;
   if((Tick/MathPow(10,(_Digits>=4 ? 4 : 2)))>close && Tick>LastTick)
      Tick-=1;
   tick=Tick;
   lasttick=LastTick;
   if(LastTick>0)
     {
      if(LastTick>Tick)
        {
         iDN=high-Tick;
         low=Tick;
         LastTick=Tick;
        }
      if(LastTick<Tick)
        {
         high=Tick;
         iUP=Tick-low;
         LastTick=Tick;
        }
     }
   else
     {
      low=high=Tick;
      LastTick=Tick;
     }
   return;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AverageTPSL(int op_type)
  {
   double avgprice=0,orderlots=0;
   double pricetp=0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && (OrderMagicNumber()==Magic || Magic==0) && OrderType()==op_type)
           {
            pricetp+=OrderOpenPrice()*OrderLots();
            orderlots+=OrderLots();
           }
        }
     }
   double stops=SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   avgprice=NormalizeDouble(pricetp/orderlots,Digits);
   if(op_type==OP_BUY)
     {
      TP=NormalizeDouble(avgprice+TakeProfit*Point,Digits);
      SL=NormalizeDouble(avgprice-StopLoss*Point,Digits);
     }
   if(op_type==OP_SELL)
     {
      TP=NormalizeDouble(avgprice-TakeProfit*Point,Digits);
      SL=NormalizeDouble(avgprice+StopLoss*Point,Digits);
     }
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && (OrderMagicNumber()==Magic || Magic==0) && OrderType()==op_type)
           {
            if(OrderStopLoss()!=SL || OrderTakeProfit()!=TP)
              {
               if((OrderType()==OP_BUY && (OrderClosePrice()<=SL || OrderClosePrice()>=TP)) ||
                  (OrderType()==OP_SELL && (OrderClosePrice()>=SL || OrderClosePrice()<=TP)))
                 {
                  bool res=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),15,clrNONE);
                  continue;
                 }
               if(MathAbs(OrderClosePrice()-SL)<stops || MathAbs(TP-OrderClosePrice())<stops)
                 {
                  continue;
                 }
               if(!OrderModify(OrderTicket(),OrderOpenPrice(),SL,TP,OrderExpiration(),clrNONE))
                 {
                  Print(__FUNCTION__+" error: ",Error(GetLastError()));
                  Print((op_type==OP_BUY ? Bid : Ask)," ",DoubleToString(SL,Digits)," ",DoubleToString(TP,Digits)," ",DoubleToString(avgprice,Digits)," - ",DoubleToString(stops,Digits));
                 }
               else
                  Sleep(1000);
               RefreshRates();
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AverageBreakeven(int op_type)
  {
   double avgprice=0,orderlots=0;
   double pricetp=0,BR=0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && (OrderMagicNumber()==Magic || Magic==0) && OrderType()==op_type)
           {
            pricetp+=OrderOpenPrice()*OrderLots();
            orderlots+=OrderLots();
           }
        }
     }
   avgprice=NormalizeDouble(pricetp/orderlots,Digits);
   if(op_type==OP_BUY)
     {
      NormalizeDouble(BR=avgprice+BreakevenStep*Point,Digits);
     }
   if(op_type==OP_SELL)
     {
      NormalizeDouble(BR=avgprice-BreakevenStep*Point,Digits);
     }
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && (OrderMagicNumber()==Magic || Magic==0) && OrderType()==op_type)
           {
            if(op_type==OP_BUY)
              {
               SL=OrderStopLoss();
               TP=OrderTakeProfit();
               OOP=OrderOpenPrice();
               if(SL<BR || SL==0)
                 {
                  if(Bid>NormalizeDouble(BR+BreakevenStop*Point,Digits))
                    {
                     if(!OrderModify(OrderTicket(),OOP,BR,TP,0,clrNONE))
                        Print(__FUNCTION__+" error: ",Error(GetLastError()));
                     else
                        Sleep(1000);
                     RefreshRates();
                    }
                 }
              }
            if(op_type==OP_SELL)
              {
               SL=OrderStopLoss();
               TP=OrderTakeProfit();
               OOP=OrderOpenPrice();
               if(SL>BR || SL==0)
                 {
                  if(Ask<NormalizeDouble(BR-BreakevenStop*Point,Digits))
                    {
                     if(!OrderModify(OrderTicket(),OOP,BR,TP,0,clrNONE))
                        Print(__FUNCTION__+" error: ",Error(GetLastError()));
                     else
                        Sleep(1000);
                     RefreshRates();
                    }
                 }
              }

           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
color style(bool P,color a,color buy)
  {
   if(P) return(a);
   else return(buy);
  }
//+------------------------------------------------------------------+
//|  Функция вывода текстовой информации                             |
//+------------------------------------------------------------------+  
void Text(string name,string text,datetime tim,double pr,color col,bool fl=false,int fs=9,string font="Tahoma")
  {
   if(ObjectFind(name)<0){if(!ObjectCreate(name,OBJ_TEXT,0,tim,pr))return;}
   ObjectSetText(name,text,fs,font,col);
   ObjectSetInteger(0,name,OBJPROP_COLOR,col);
   ObjectSetInteger(0,name,OBJPROP_TIME,tim);
   ObjectSetDouble(0,name,OBJPROP_PRICE,pr);
   ObjectSet(name,OBJPROP_FONTSIZE,fs);
   ObjectSet(name,OBJPROP_BACK,false);
   ObjectSet(name,OBJPROP_SELECTABLE,false);
   ObjectSet(name,OBJPROP_READONLY,false);
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_LEFT);
   if(fl)ChartRedraw();
  }
//+------------------------------------------------------------------+
//|   Функция возвращает цену последнего ордера по типу              |
//+------------------------------------------------------------------+
double FindLastPrice(int op_type)
  {
   double oldopenprice=0;
   int oldticket;
   int ticket=0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && (OrderMagicNumber()==Magic || Magic==0) && OrderType()==op_type)
           {
            oldticket=OrderTicket();
            if(oldticket>ticket)
              {
               oldopenprice=OrderOpenPrice();
               ticket=oldticket;
              }
           }
        }
     }
   return(NormalizeDouble(oldopenprice,Digits));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Info()
  {
   string txt1="---",txt2="---",txt3="---",txt5="---",txt6="---",txt7="---",txt8="---";
   double losspersent=0,winpersent=0;
   if(Profit(0)<0)losspersent=(-1*Profit(0)*100)/AccountBalance();
   losspersent=NormalizeDouble(losspersent,2);
   if(Profit(0)>0)winpersent=(Profit(0)*100)/AccountBalance();
   winpersent=NormalizeDouble(winpersent,2);
//---   
   double losstoday=0,wintoday=0;
   if(Profit(0)<0)losstoday=(-1*Profit(0));
   losstoday=NormalizeDouble(losstoday,2);
   if(Profit(0)>0)wintoday=Profit(0);
   wintoday=NormalizeDouble(wintoday,2);
//---
   double drawdownpersent=0,profitpersent=0;
   if(valueprofit()<0)drawdownpersent=(-1*valueprofit()*100)/AccountBalance();
   drawdownpersent=NormalizeDouble(drawdownpersent,2);
   if(valueprofit()>0)profitpersent=(valueprofit()*100)/AccountBalance();
   profitpersent=NormalizeDouble(profitpersent,2);
//---   
   double drawdownmoney=0,profitmoney=0;
   if(valueprofit()<0)drawdownmoney=(-1*valueprofit());
   drawdownmoney=NormalizeDouble(drawdownmoney,2);
   if(valueprofit()>0)profitmoney=valueprofit();
   profitmoney=NormalizeDouble(profitmoney,2);

   if(value_profit()>0)txt5="Profit";
   if(value_profit()<0)txt5="Drawdown";
   if(value_profit()==0 && CountBuy()+CountSell()>0)txt5="Breakeven";
   if(value_profit()==0 && CountBuy()+CountSell()==0)txt5="Waiting deals";
   if(Profit(0)>0)txt1="Win today";
   if(Profit(0)<0)txt1="Loss today";
   if(Profit(0)==0)txt1="Waiting result";

   txt8=AccountCurrency();
   if(Profit(0)>0)txt7=DoubleToStr(wintoday,2);
   if(Profit(0)<0)txt7=DoubleToStr(losstoday,2);
   if(Profit(0)==0)txt7="---";
   if(value_profit()>0)txt6=DoubleToStr(profitmoney,2);
   if(value_profit()<0)txt6=DoubleToStr(drawdownmoney,2);
   if(value_profit()==0)txt6="---";

   if(ObjectFind("Label")<0)
     {
      ObjectCreate("Label",OBJ_LABEL,0,0,0);
      ObjectSetText("Label","g",190,"Webdings",Header);
      ObjectSet("Label",OBJPROP_BACK,FALSE);
      ObjectSet("Label",OBJPROP_XDISTANCE,5);
      ObjectSet("Label",OBJPROP_YDISTANCE,15);
      ObjectSet("Label",OBJPROP_SELECTABLE,false);
      ObjectSet("Label",OBJPROP_SELECTED,false);
      ObjectSet("Label",OBJPROP_HIDDEN,true);
      ObjectSet("Label",OBJPROP_ZORDER,10);
      ChartSetInteger(0,CHART_FOREGROUND,false);
     }
   if(ObjectFind("Label1")<0)
     {
      ObjectCreate("Label1",OBJ_LABEL,0,0,0);
      ObjectSetText("Label1","g",190,"Webdings",Body);
      ObjectSet("Label1",OBJPROP_BACK,FALSE);
      ObjectSet("Label1",OBJPROP_XDISTANCE,5);
      ObjectSet("Label1",OBJPROP_YDISTANCE,43);
      ObjectSet("Label1",OBJPROP_SELECTABLE,false);
      ObjectSet("Label1",OBJPROP_SELECTED,false);
      ObjectSet("Label1",OBJPROP_HIDDEN,true);
      ObjectSet("Label1",OBJPROP_ZORDER,10);
     }
   SetLabel("Label2","   Step Back",TextColor,2,21,0,11);
   SetLabel("Label3","   Trades",TextColor,2,50);
   SetLabel("Label4","   Profit Trades",TextColor,2,65);
   SetLabel("Label5","   Loss Trades",TextColor,2,80);
   SetLabel("Label6","   Profit Factor",TextColor,2,95);
   SetLabel("Label7","   Expected Payoff",TextColor,2,110);
   SetLabel("Label8","   Average Profit",TextColor,2,125);
   SetLabel("Label9","   Average Loss",TextColor,2,140);
   SetLabel("Label10","   Growth",TextColor,2,155);
   SetLabel("Label11","   Initial Deposit",TextColor,2,170);
   SetLabel("Label12","   Deposits",TextColor,2,185);
   SetLabel("Label13","   Withdrawals",TextColor,2,200);
   SetLabel("Label14","   Balance",TextColor,2,215);
   SetLabel("Label15","   Equity",TextColor,2,230);
   SetLabel("Label16","   "+txt5,TextColor,2,260);
   SetLabel("Label17","   "+txt1,TextColor,2,275);
   SetLabel("Label18","   –––––––––––––––––––––––––––––––––",TextColor,2,245);

   SetLabel("Label19","| "+IntegerToString(AccountInformation.TotalTrades()),TextColor,120,50);
   SetLabel("Label20","| "+IntegerToString(AccountInformation.ProfitTrades()),TextColor,120,65);
   SetLabel("Label21","| "+IntegerToString(AccountInformation.LossTrades()),TextColor,120,80);
   SetLabel("Label22","| "+DoubleToString(AccountInformation.Profitfactor(),2),TextColor,120,95);
   SetLabel("Label23","| "+DoubleToString(AccountInformation.Payoff(),2),TextColor,120,110);
   SetLabel("Label24","| "+DoubleToString(AccountInformation.AverageProfit(),2),TextColor,120,125);
   SetLabel("Label25","| "+DoubleToString(AccountInformation.AverageLoss(),2),TextColor,120,140);
   SetLabel("Label26","| "+DoubleToString(AccountInformation.TotalProfit(),2),TextColor,120,155);
   SetLabel("Label27","| "+DoubleToString(AccountInformation.InitialDeposit(),2),TextColor,120,170);
   SetLabel("Label28","| "+DoubleToString(AccountInformation.Deposit(),2),TextColor,120,185);
   SetLabel("Label29","| "+DoubleToString(AccountInformation.Withdraw(),2),TextColor,120,200);
   SetLabel("Label30","| "+DoubleToStr(AccountInfoDouble(ACCOUNT_BALANCE),2),TextColor,120,215);
   SetLabel("Label31","| "+DoubleToStr(AccountInfoDouble(ACCOUNT_FREEMARGIN),2),TextColor,120,230);
   SetLabel("Label32","| "+txt6,TextColor,120,260);
   SetLabel("Label33","| "+txt7,TextColor,120,275);

   SetLabel("Label35","",TextColor,225,50);
   SetLabel("Label36","",TextColor,225,65);
   SetLabel("Label37","",TextColor,225,80);
   SetLabel("Label38","",TextColor,225,95);
   SetLabel("Label39",AccountCurrency(),TextColor,225,110);
   SetLabel("Label40",AccountCurrency(),TextColor,225,125);
   SetLabel("Label41",AccountCurrency(),TextColor,225,140);
   SetLabel("Label42",AccountCurrency(),TextColor,225,155);
   SetLabel("Label43",AccountCurrency(),TextColor,225,170);
   SetLabel("Label44",AccountCurrency(),TextColor,225,185);
   SetLabel("Label45",AccountCurrency(),TextColor,225,200);
   SetLabel("Label46",AccountCurrency(),TextColor,225,215);
   SetLabel("Label47",AccountCurrency(),TextColor,225,230);
   SetLabel("Label48",txt8,TextColor,225,260);
   SetLabel("Label49",txt8,TextColor,225,275);
  }
//+------------------------------------------------------------------+
