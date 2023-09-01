//+------------------------------------------------------------------+
//|                                                                  |
//|       Советник на поиск патернов                                 |
//|       перед трендом                                              | 
//|                             http://www.mql4.com/ru/users/ikatsko |
//+------------------------------------------------------------------+
#property copyright "Ivan Katsko"
#property link      "ICQ:372739628"
#include <stdlib.mqh>
//----
extern int TrendBars            = 7;    // Баров в тренде 
extern int TrendLevel           = 7;    // Величина тренда к среднему размеру свечи
extern int Discret              = 8;    // Дискретность кода баров: 1 - 64 уровня, 32 - 2 уровня 
extern int    Variant           = 1;    // 0 - открываем все, что есть, 1 - Работает только в одном направлении, 2 - в двух направлениях (BUY/SELL)
 int    Accuracy          = 0;    // Точность лота, знаков после запятой. "0" - минимальный шаг
//+---------------------------------------------------+
//|Money Management                                   |
//+---------------------------------------------------+
extern string MM                = "MoneyManagement";
extern double Lots              = 0;    // 0 - включает MoneyManagement 
extern double ProfitPercent     = 1;    // В любом случае взять Profit в %% к свободным средствам
extern double LossPercent       = 30;   // Loss в %%  к свободным средствам с учетом StopLoss
//extern double SL_mode           = 190;  // > 10 - = StopLoss, иначе - коэф к TakeProfit
extern int    ConsiderHistoryProfits = 1; //1/0 - учитывать/не учитывать историю выигрышей
extern int    TimeControl       = 0;    // 0 - нет контроля времени открытых позиций, 1 - закрыть позиции через TrendBars баров, 2 - обязательно закрыть позиции через TrendBars баров
extern int    DayControl        = 0;    // 0 - нет контроля закрытия позиций в конце дня, 1 - закрыть позиции в конце дня
extern string UTS               = "UseTrailingStop";
extern int    UseTrailingStop   = 0;    // 0 - Stop по комб.свечей, 1 - Stop по комб.свечей + трал SL, 2 - только трал SL
extern int    SpeedTrailing     = 5;    // 
extern int    EquityCtrl        = 0;    // 
extern double NotUsedPart       = 0;  // Не используемая часть баланса
extern double MaxUsedPart       = 100000;  // Максимальная используемая часть баланса
//---
double TopShade[100];
double BotShade[100];
double Body[100];
int    Pattern[1000] [4];
int    pattern[4];
double MaxTopShade, MaxBotShade, MaxBody,
       MinTopShade, MinBotShade, MinBody,
       tempMaxTopShade, tempMaxBotShade, tempMaxBody,
       tempMinTopShade, tempMinBotShade, tempMinBody;
double countTSup, countTSdn, countTSmd,
       countBSup, countBSdn, countBSmd,
       countBoup, countBodn, countBomd;
double body = 0, not_used_part;
int    LastPattern, old_last_pattern;
int    bars_count=0, size,
       pool, poos, pattern_count,
       OpPzBUY, OpPzSELL;
//----------------------------------------------------------------
int    Slippage          = 4;           // Possible fix for not getting closed Could be higher with some brokers    
double StopLoss          = 190;         // Maximum pips willing to lose per position.
int    TakeProfit        = 100;         // Maximum profit level achieved.
int    MagicNumber;                     // Magic EA identifier. Allows for several co-existing EA with different input values
int    attempt                  = 5;    //Попыток на открытие/закрытие ордеров
int    color_close_buy          = MediumBlue;
int    color_close_sell         = DarkViolet;
string ExpertName;                      // To "easy read" which EA place an specific order and remember me forever :)
string news_wav                 = "news.wav";
double lotMM, price_buy, price_sell, hg, lw, profit_percent;
double stimul, equity = 0, day_equity = 0, new_equity;
double spread                   = 3.0;
bool   TrailingReadyBuy, TrailingReadySell;
bool   MoneyManagement;                 // Change to false to shutdown money management controls.
bool   sound_yes                = TRUE; //Разрешить звуки
bool   is_loss                  = false;
double sl_up, sl_dn, Pnt, Cor;
static int prevtime             = 0;
bool New_Bar=false;                     // Флаг нового бара 
static datetime New_Time;
int j=0;
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start() {

   Fun_New_Bar();
   Print_Comment();

   if (New_Bar) {
      OpPzBUY = openPositionsBUY(false);
      OpPzSELL = openPositionsSELL(false);

      HandleOpenPositions();

      bars_count++;
      if (bars_count > 100) {
         bars_count = 0;
         Calculation_of_deviations(100);
      }

      old_last_pattern = LastPattern;     
      LastPattern = Pattern_Find(old_last_pattern); 
      if (LastPattern == 0) LastPattern = old_last_pattern+1;

      if (Is_Pattern()) {
         if (pattern[0] > MathAbs(64/Discret)) {
            if (CheckEntryOpenSELL()) {
               if (OpenSell() == 1) {
                  TrailingReadyBuy = false;
                  profit_percent = ProfitPercent;
                  return(0);
               }
            }
         } else {
            if (CheckEntryOpenBUY()) {
               if (OpenBuy() == 1) {
                  TrailingReadySell = false;
                  profit_percent = ProfitPercent;
                  return(0);
               }
            }   
         }
      }
   }
   Trailing();
// }
   return(0);
}

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init() {
   not_used_part = AccountBalance() - NotUsedPart - MaxUsedPart;
   equity = AccountBalance() - not_used_part;
   day_equity = equity;
   pool = ProfitableOrdersOfLongs();
   poos = ProfitableOrdersOfShorts();
   size = -250*Discret +9000;
   ArrayResize(Pattern,size);
   if (Digits == 2) {
      Pnt = 0.01;
      Cor = 1;
   } else {
      Pnt = Point*MathPow(10,Digits-4);
      Cor = MathPow(10,Digits-4);
   }
   int array_size = 100;
   ArrayResize(TopShade,array_size+1);
   ArrayResize(BotShade,array_size+1);
   ArrayResize(Body,array_size+1);
   Calculation_of_deviations(array_size);
   int hh=FileOpen("f_name1.bin",FILE_BIN|FILE_READ);
   int s=FileReadInteger(hh,LONG_VALUE);
   FileReadArray(hh,Pattern,0,s);
   FileClose(hh);
   if (hh == -1) {
      LastPattern = Pattern_Find(Bars, false)-1;
      for (int i = 0; i <= size; i++) {
         if (Pattern[i][0] == 0 && Pattern[i][1] == 0 && Pattern[i][2] == 0 && Pattern[i][3] == 0) break;
      }
      Print("На ",Bars," барах найдено ",i-1," паттернов ");
      if (i > 0.1*Bars) {
         for (int l = MathRound(0.1*Bars); l <= size; l++) {
            for (int k = 0; k < 4; k++) {
               Pattern[l][k] = 0;
            }
         }
         for (i = 0; i <= size; i++) {
            if (Pattern[i][0] == 0 && Pattern[i][1] == 0 && Pattern[i][2] == 0 && Pattern[i][3] == 0) break;
         }
         Print("и ограничено до ",MathRound(i)," паттернов ");
      }
   } else {    
      for (i = 0; i <= size; i++) {
         if (Pattern[i][0] == 0 && Pattern[i][1] == 0 && Pattern[i][2] == 0 && Pattern[i][3] == 0) break;
      }
      if (i>j) {Print("Загружено ",i," паттернов "); j=i;}
      if (i > 0.1*Bars) {
         for (l = MathRound(0.1*Bars); l <= size; l++) {
            for (k = 0; k < 4; k++) {
               Pattern[l][k] = 0;
            }
         }
         Print("и ограничено до ",MathRound(0.1*Bars)," паттернов ");
      }
   }
//----------------------------------------------------------------------------------
   profit_percent = ProfitPercent;   
   prevtime = Time[0];
   stimul = LossPercent*0.01;
   if (Lots == 0)       MoneyManagement=true;   else MoneyManagement=false;
   MagicNumber=2000 + func_Symbol2Val(Symbol())*100/* + func_TimeFrame_Const2Val(Period())*/;
   ExpertName="iK_TF: " + MagicNumber + " : " + Symbol() + "_" + func_TimeFrame_Val2String(func_TimeFrame_Const2Val(Period()));
   return(0);
}

//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit() {
      for (int i = 0; i <= size; i++) {
         if (Pattern[i][0] == 0 && Pattern[i][1] == 0 && Pattern[i][2] == 0 && Pattern[i][3] == 0) break;
      }
      if (i>j) {Print("Выгружено ",i-1," паттернов "); j=i;}
      int h=FileOpen("f_name.bin",FILE_BIN|FILE_WRITE);
      FileWriteInteger(h,ArraySize(Pattern),LONG_VALUE);
      FileWriteArray(h,Pattern,0,ArraySize(Pattern));
      FileClose(h);
   return(0);
}
//+------------------------------------------------------------------+
//| CheckEntryOpen                                                   |
//| Check if rules are met for Buy trade                             |
//+------------------------------------------------------------------+
bool CheckEntryOpenBUY() {
   pool = ProfitableOrdersOfLongs();
   poos = ProfitableOrdersOfShorts();
   if (((Variant > 3*pool || pool >= poos) && ConsiderHistoryProfits) || !ConsiderHistoryProfits) {
      if ((OpPzBUY  < 1 && OpPzSELL < 1)    ||
          (OpPzBUY  > 0 && Ask < price_buy) ||
          (OpPzSELL > 0 && OpPzBUY  < 1 && Ask < price_sell)) {
         if ( Variant == 0 ||
             (Variant == 1 && OpPzBUY < 1 && OpPzSELL < 1) ||
             (Variant == 2 && OpPzBUY < 1 && OpPzSELL < 2) ||
             (Variant  > 2 && Variant > 2*OpPzBUY)) {
            return(true);
         }
      }
   }          
   return(false);
}

//+------------------------------------------------------------------+
//| CheckEntryOpen                                                   |
//| Check if rules are met for open of trade                         |
//+------------------------------------------------------------------+
bool CheckEntryOpenSELL() {
   pool = ProfitableOrdersOfLongs();
   poos = ProfitableOrdersOfShorts();
   if (((Variant > 3*poos || poos >= pool) && ConsiderHistoryProfits) || !ConsiderHistoryProfits) {
      if ((OpPzBUY  < 1 && OpPzSELL < 1)     ||
          (OpPzSELL > 0 && Bid > price_sell) ||
          (OpPzBUY  > 0 && OpPzSELL < 1 && Bid > price_buy)) {
         if ( Variant == 0 ||
             (Variant == 1 && OpPzBUY < 1 && OpPzSELL < 1) ||
             (Variant == 2 && OpPzBUY < 2 && OpPzSELL < 1) ||
             (Variant  > 2 && Variant > 2*OpPzSELL)) {
            return(true);
         }
      }
   }
   return(false);          
}
//+------------------------------------------------------------------+
//| OpenBuy                                                          |
//+------------------------------------------------------------------+
int OpenBuy() {
   lotMM=GetLots();
   if (lotMM > 0) {
      int err, ticket;
      color myColor = Green;
   
      if (MarketInfo(Symbol(), MODE_STOPLEVEL) > 2*spread) double shift = MarketInfo(Symbol(), MODE_STOPLEVEL);
      else shift = 2*spread;

      double myPrice      = NormalizeDouble(Ask/* - shift*Point*/,Digits);
      double myTakeProfit = NormalizeDouble(myPrice + TakeProfit*Pnt,Digits);                                                     //
      double myStopLoss   = NormalizeDouble(myPrice - StopLoss*Pnt,Digits);
      sl_up = StopLoss*Cor;
      int h = 1;
      int slp = Slippage;
      while (h < 5) {
         ticket=OrderSend(Symbol(),OP_BUY,lotMM,myPrice,slp,0,0,ExpertName, MagicNumber,0,myColor);
         if(ticket<=0) {
            h++;
            slp = slp*2;
         }  else {
            OrderSelect(ticket, SELECT_BY_TICKET);
            while(!OrderModify(ticket, OrderOpenPrice(), myStopLoss, myTakeProfit,0,myColor)) continue;
            break;  
         }
      }
      string MyTxt;
      MyTxt = " for " + DoubleToStr(myPrice,4); 
         
      if(ticket<=0) {
         err=GetLastError();
         Print("iK_TF: Error opening Open Buy order [" + ExpertName + "]: (" + err + ") " + ErrorDescription(err) + " /// " + MyTxt);
         return(0);
      } else {
         OrderSelect(0, SELECT_BY_POS, MODE_TRADES);
         price_buy = OrderOpenPrice();
      }
      return(1);
   }   
}

//+------------------------------------------------------------------+
//| OpenSell                                                         |
//+------------------------------------------------------------------+
int OpenSell() {
   lotMM=GetLots();
   if (lotMM > 0) {
      int err, ticket;
      color myColor = Red;
   
      if (MarketInfo(Symbol(), MODE_STOPLEVEL) > 2*spread) double shift = MarketInfo(Symbol(), MODE_STOPLEVEL);
      else shift = 2*spread;
      double myPrice      = NormalizeDouble(Bid/* + shift*Point*/,Digits);         
      double myTakeProfit = NormalizeDouble(myPrice - TakeProfit*Pnt,Digits);
      double myStopLoss   = NormalizeDouble(myPrice + StopLoss*Pnt,Digits);
      sl_dn = StopLoss*Cor; 
      int h = 1;
      int slp = Slippage;
      while (h < 5) {
         ticket=OrderSend(Symbol(),OP_SELL,lotMM,myPrice,slp,0,0,ExpertName, MagicNumber,0,myColor);
         if(ticket<=0) {
            h++;
            slp = slp*2;
         }  else {
            OrderSelect(ticket, SELECT_BY_TICKET);
            while(!OrderModify(ticket, OrderOpenPrice(), myStopLoss, myTakeProfit,0,myColor)) continue;
            break;  
         }  
      }
   
      string MyTxt;
      MyTxt = " for " + DoubleToStr(myPrice,4); 
         
      if(ticket<=0) {
         err=GetLastError();
         Print("iK_TF: Error opening Open Sell order [" + ExpertName + "]: (" + err + ") " + ErrorDescription(err) + " /// " + MyTxt);
         return(0);
      } else {
         OrderSelect(0, SELECT_BY_POS, MODE_TRADES);
         price_sell = OrderOpenPrice();
      }
      return(1);
   }   
}

//+------------------------------------------------------------------------+
//| counts the number of open positions BUY                                    |
//+------------------------------------------------------------------------+
int openPositionsBUY(bool limit = true) {  
   int op =0;
   for(int i=0;i<=OrdersTotal()-1;i++) {
      OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if(OrderSymbol()==Symbol()) {
         if (100*MathFloor(OrderMagicNumber()/100) == MagicNumber)
            if(OrderType()==OP_BUY) {
               op++;
               price_buy = OrderOpenPrice();
            }
         if(limit && OrderType()==OP_BUYLIMIT)op++;
      }
   }
   return(op);
}

//+------------------------------------------------------------------------+
//| counts the number of open positions SELL                                   |
//+------------------------------------------------------------------------+
int openPositionsSELL(bool limit = true) {  
   int op =0;
   for(int i=0;i<=OrdersTotal()-1;i++) {
      OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if(OrderSymbol()==Symbol())  {
         if (100*MathFloor(OrderMagicNumber()/100) == MagicNumber)
            if(OrderType()==OP_SELL) {
               op++;
               price_sell = OrderOpenPrice();
            }
         if(limit && OrderType()==OP_SELLLIMIT)op++;
      }
   }
   return(op);
}

//+------------------------------------------------------------------+
//| Get number of lots for this trade                                |
//+------------------------------------------------------------------+
double GetLots() {
   double lot;
   double Step   =MarketInfo(Symbol(),MODE_LOTSTEP);
   if(MoneyManagement) {
      RefreshRates();                              // Обновление данных
      double
         TickValue = MarketInfo(Symbol(),MODE_TICKVALUE),
         Min_Lot=MarketInfo(Symbol(),MODE_MINLOT),           // Миним. колич. лотов 
         Max_Lot=MathFloor(MarketInfo(Symbol(),MODE_MAXLOT)),// Макс. колич. лотов 
         Free   =GetFreeMargin()-NotUsedPart,                // Свободн средства
         One_Lot=MarketInfo(Symbol(),MODE_MARGINREQUIRED);   // Стоимость 1 лота
      //Print("Step=",Step);
      //GetFreeMargin();
      stimul = LossPercent*0.01;
      if (Free > MaxUsedPart) Free = MaxUsedPart;
      double free = AccountBalance() - AccountMargin();
      Print("free = ",free);
      if (Free > free) Free = free;
      lot = stimul*Free/(StopLoss*Cor*TickValue);
      if (MathFloor(lot/Step)*Step >= 0) {
         if (stimul == 3*LossPercent*0.01) {
            Print("После убытка ЛОТ в пределах % утроенного риска от SL и равен ",lot," или ",100*stimul,"% баланса");
         } else {
            if (stimul != LossPercent*0.01) {
               Print("После убытка ЛОТ в пределах % максимального риска от SL и равен ",lot," или ",100*stimul,"% баланса");
             } else {
               Print("ЛОТ в пределах заданного % риска от SL и равен ",lot," или ",100*stimul,"% баланса");
             }
         }

      }
      if (lot > Max_Lot && lot >= 0) {
         lot = Max_Lot;
         Print("ЛОТ ограничен максимумом и равен ",MathFloor(lot/Step)*Step);
      }
      if (lot*One_Lot > stimul*Free && lot >= 0) {
         lot =stimul*Free/One_Lot;
         Print("ЛОТ ограничен свободными средствами и равен ",MathFloor(lot/Step)*Step);
      }
      int level=AccountStopoutLevel(); ///// ТОЛЬКО ЕСЛИ ВЫРАЖЕН В ПРОЦЕНТАХ!!!
      if (AccountStopoutMode() == 0 && lot >= 0) {
         if (lot > Free/(level*One_Lot/100.0 + StopLoss*Cor*TickValue)) {
            lot = Free/(level*One_Lot/100.0 + StopLoss*Cor*TickValue);
            Print("ЛОТ ограничен уровнем StopOut и равен ",MathFloor(lot/Step)*Step," или ",MathRound(100*lot*StopLoss*Cor*TickValue/Free),"% баланса");
         }
      }   
      if (lot < Min_Lot && lot >= 0) {
         if (2*lot > Min_Lot) {
            lot=Min_Lot;               // Не меньше минимальн
            Print("ЛОТ ограничен минимумом и равен ",MathFloor(lot/Step)*Step);
         } else lot=0;
      }
   } else lot=Lots;

   if (Accuracy == 0) 
      lot = MathFloor(lot/Step)*Step;
   else lot = NormalizeDouble(lot,Accuracy); 
   //Alert("lot=",lot);
   if (lot < 0) lot = 0;
   return(lot);
}

//+------------------------------------------------------------------+
int GetProfitLastClosePos(string sy="", int mn=-1) {
  datetime t;
  int      i, k=OrdersHistoryTotal(), r=0;
  
  if (sy=="0") sy=Symbol();
  for (i=k-1; i>=0; i--) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) {
      if ((OrderSymbol()==sy || sy=="") && (mn<0 || 100*MathFloor(OrderMagicNumber()/100)==mn)) {
        if (OrderType()==OP_BUY || OrderType()==OP_SELL) {
           t=OrderCloseTime();
           r=OrderProfit();
           break;
        }
      }
    }
  }
  return(r);
}

//+------------------------------------------------------------------+
//| Time frame interval appropriation  function                      |
//+------------------------------------------------------------------+
int func_TimeFrame_Const2Val(int Constant) {
     switch(Constant) {
         case     1: return(1);
         case     5: return(2);
         case    15: return(3);
         case    30: return(4);
         case    60: return(5);
         case   240: return(6);
         case  1440: return(7);
         case 10080: return(8);
         case 43200: return(9);
     }
}

//+------------------------------------------------------------------+
//| Time frame string appropriation  function                        |
//+------------------------------------------------------------------+
string func_TimeFrame_Val2String(int Value) {
    switch(Value) {
        case 1: return("PERIOD_M1");
        case 2: return("PERIOD_M5");
        case 3: return("PERIOD_M15");
        case 4: return("PERIOD_M30");
        case 5: return("PERIOD_H1");
        case 6: return("PERIOD_H4");
        case 7: return("PERIOD_D1");
        case 8: return("PERIOD_W1");
        case 9: return("PERIOD_MN1");
        default: return("undefined " + Value);
    }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int func_Symbol2Val(string symbol)  {
     if(symbol=="AUDCAD")  {
        return(1);
     } else if(symbol=="AUDJPY") {
        return(2);
     } else if(symbol=="AUDNZD") {
        return(3);
     } else if(symbol=="AUDUSD") {
        return(4);
     } else if(symbol=="CHFJPY") {
        return(5);
     } else if(symbol=="EURAUD") {
        return(6);
     } else if(symbol=="EURCAD") {
        return(7);
     } else if(symbol=="EURCHF") {
        return(8);
     } else if(symbol=="EURGBP") {
        return(9);
     } else if(symbol=="EURJPY") {
        return(10);
     } else if(symbol=="EURUSD") {
        return(11);
     } else if(symbol=="GBPCHF") {
        return(12);
     } else if(symbol=="GBPJPY") {
        return(13);
     } else if(symbol=="GBPUSD") {
        return(14);
     } else if(symbol=="NZDUSD") {
        return(15);
     } else if(symbol=="USDCAD") {
        return(16);
     } else if(symbol=="USDCHF") {
        return(17);
     } else if(symbol=="USDJPY") {
        return(18);
     } else {
        Comment("unexpected Symbol");
        return(0);
     }
}

void CloseAllPos(int typ=2) {
   //Print("Начали CloseAllPos(",typ,")");
   int l_ord_total_22 = OrdersTotal();
   int l_ord_total_24 = l_ord_total_22;
   for (int l_pos_18 = l_ord_total_22 - 1; l_pos_18 >= 0; l_pos_18--) {
      if (OrderSelect(l_pos_18, SELECT_BY_POS, MODE_TRADES)) {
         if (typ == 2) {
            if (100*MathFloor(OrderMagicNumber()/100) == MagicNumber) {
               ClosePosBySelect(typ);
               l_ord_total_24--;
            }
         } else {
            if (OrderType() == typ)
               if (100*MathFloor(OrderMagicNumber()/100) == MagicNumber) {
                  ClosePosBySelect(typ);
                  l_ord_total_24--;
               }
         }      
      }         
   }
   if (l_ord_total_24 == 0) return;
} 

void CloseSelectTicket(int ticket) {
   bool l_ord_close_0;
   color l_color_4;
   double l_ord_lots_8;
   double ld_16;
   double ld_24;
   double l_price_32;
   int l_error_40;
   for (int li_44 = 1; li_44 <= attempt; li_44++) {
      if (!IsTesting() && !IsExpertEnabled() || IsStopped()) break;
      while (!IsTradeAllowed()) Sleep(5000);
      RefreshRates();
      ld_16 = NormalizeDouble(Ask, Digits);
      ld_24 = NormalizeDouble(Bid, Digits);
      if (OrderType() == OP_BUY) {
         l_price_32 = ld_24;
         l_color_4 = color_close_buy;
      } else {
         l_price_32 = ld_16;
         l_color_4 = color_close_sell;
      }
      l_ord_lots_8 = OrderLots();
   
      if (ticket != 0)
         l_ord_close_0 = OrderClose(ticket, l_ord_lots_8, l_price_32, Slippage, l_color_4);
      else
         break;
      
      if (l_ord_close_0) {
         if (!(sound_yes)) break;
         PlaySound(news_wav);
         return;
      }
      l_error_40 = GetLastError();
      if (l_error_40 == 146/* TRADE_CONTEXT_BUSY */) while (IsTradeContextBusy()) Sleep(11000);
      Print("Error(", l_error_40, ") Close ", ticket, " ", ErrorDescription(l_error_40), ", try ", li_44);
      Sleep(5000);
   }
}

void ClosePosBySelect(int typ) {
   bool l_ord_close_0;
   color l_color_4;
   double l_ord_lots_8;
   double ld_16;
   double ld_24;
   double l_price_32;
   int l_error_40;
   if (OrderType() == OP_BUY || OrderType() == OP_SELL) {
      for (int li_44 = 1; li_44 <= attempt; li_44++) {
         if (!IsTesting() && !IsExpertEnabled() || IsStopped()) break;
         while (!IsTradeAllowed()) Sleep(5000);
         RefreshRates();
         ld_16 = NormalizeDouble(MarketInfo(OrderSymbol(), MODE_ASK), Digits);
         ld_24 = NormalizeDouble(MarketInfo(OrderSymbol(), MODE_BID), Digits);
         if (OrderType() == OP_BUY) {
            l_price_32 = ld_24;
            l_color_4 = color_close_buy;
         } else {
            l_price_32 = ld_16;
            l_color_4 = color_close_sell;
         }
         l_ord_lots_8 = OrderLots();
         
         if (typ == 2) l_ord_close_0 = OrderClose(OrderTicket(), l_ord_lots_8, l_price_32, Slippage, l_color_4);
         else if (typ == OrderType()) l_ord_close_0 = OrderClose(OrderTicket(), l_ord_lots_8, l_price_32, Slippage, l_color_4);
         
         if (l_ord_close_0) {
            if (!(sound_yes)) break;
            PlaySound(news_wav);
            return;
         }
         l_error_40 = GetLastError();
         if (l_error_40 == 146/* TRADE_CONTEXT_BUSY */) while (IsTradeContextBusy()) Sleep(11000);
         Print("Error(", l_error_40, ") Close ", OrderType(), " ", ErrorDescription(l_error_40), ", try ", li_44);
         Sleep(5000);
      }
   } else Print("Некорректная торговая операция. Close ", OrderType());
}
//+------------------------------------------------------------------+
void again() {
   prevtime = Time[1];
   Sleep(30000);
}
//+------------------------------------------------------------------+
void Fun_New_Bar()                              // Ф-ия обнаружения нового бара
  {                                             
   New_Bar=false;                               // Нового бара нет
   if(New_Time!=Time[0]) {                      // Сравниваем время
      New_Time=Time[0];                         // Теперь время такое
      New_Bar=true;                             // Поймался новый бар  
   }
  }
//+------------------------------------------------------------------+
void Trailing()
   {
      if (UseTrailingStop >= 1) {
         int total = OrdersTotal();   
         for(int i = total - 1; i >= 0; i--) {
            OrderSelect(i, SELECT_BY_POS, MODE_TRADES); 
            if ((OrderSymbol() == Symbol()) && (100*MathFloor(OrderMagicNumber()/100) == MagicNumber)) {
               double modeSl = MarketInfo(Symbol(), MODE_STOPLEVEL);
               if (modeSl > sl_up) sl_up = modeSl+1;
               if (modeSl > sl_dn) sl_dn = modeSl+1;
               if (OrderType() == OP_BUY) {
                  double p_b = OrderOpenPrice();
                  if (TrailingReadyBuy) {
                     if ((Bid > (OrderStopLoss() + (sl_up/(0.01*(100-SpeedTrailing)) + 3*spread) * Point)) &&
                         (Bid > p_b)) {
                        if (Bid > p_b + 0.75*TakeProfit*Cor*Point) {
                           if (!OrderModify(OrderTicket(), p_b, NormalizeDouble(Bid - sl_up * Point,Digits), 0, 0, Blue)) {
                              again();
                           } else {profit_percent = 500;}
                        } else {
                           if (!OrderModify(OrderTicket(), p_b, NormalizeDouble(Bid - sl_up * Point,Digits), OrderTakeProfit(), 0, Blue)) 
                              {again();}
                        }
                        sl_up = NormalizeDouble(sl_up*0.01*(100-SpeedTrailing),0);/*}*/
                     }
                  } else {
                     if (Bid > p_b + 0.75*TakeProfit*Cor*Point) {
                        if (modeSl < NormalizeDouble((Bid - (p_b + 3*spread * Point))/Point,0)) {
                           if (!OrderModify(OrderTicket(), p_b, NormalizeDouble(p_b + spread * Point,Digits), 0, 0, Blue)) 
                              {again();}
                           sl_up = NormalizeDouble(0.75*TakeProfit*Cor,0);
                           profit_percent = 500;
                           TrailingReadyBuy = true;
                        } else {Print("Traling won`t be...");}
                     }   
                  }
               } else { 
                  double p_s = OrderOpenPrice();
                  if (TrailingReadySell) {
                     if ((Ask < (OrderStopLoss() - (sl_dn/(0.01*(100-SpeedTrailing)) + spread) * Point)) &&
                         (Ask < p_s)) {
                        if (Ask < p_s - 0.75*TakeProfit*Cor*Point) {
                           if (!OrderModify(OrderTicket(), p_s, NormalizeDouble(Ask + sl_dn * Point,Digits), 0, 0, Blue)) {
                              again();
                           } else {profit_percent = 500;}
                        } else {
                           if (!OrderModify(OrderTicket(), p_s, NormalizeDouble(Ask + sl_dn * Point,Digits), OrderTakeProfit(), 0, Blue)) 
                              {again();}
                        }
                        sl_dn = NormalizeDouble(sl_dn*0.01*(100-SpeedTrailing),0);/*}*/
                     }
                  } else {
                     if (Ask < p_s - 0.75*TakeProfit*Cor*Point) {
                        if (modeSl < NormalizeDouble((p_s - spread * Point - Ask)/Point,0)) {
                           if (!OrderModify(OrderTicket(), p_s, NormalizeDouble(p_s - spread * Point,Digits), 0, 0, Blue)) 
                              {again();}
                           sl_dn = NormalizeDouble(0.75*TakeProfit*Cor,0);
                           profit_percent = 500;
                           TrailingReadySell = true;
                        } else {Print("Traling won`t be...");}
                     }   
                  }
               }
               return(0);
            }
         }
      }
   }
//------------------------------------------------------------
//
//------------------------------------------------------------
void Calculation_of_deviations(int history=5, int shift=0) {
   if (history > Bars) history = Bars;
   double k_dev = 0.1, coeff = 0.9;
   MaxTopShade = 0; MaxBotShade = 0; MaxBody = 0;
   MinTopShade = 0; MinBotShade = 0; MinBody = 0;
   double MAXcountTSup=0.33, MINcountTSup=0.33,
          MAXcountTSdn=0.33, MINcountTSdn=0.33,
          MAXcountBSup=0.33, MINcountBSup=0.33,
          MAXcountBSdn=0.33, MINcountBSdn=0.33,
          MAXcountBoup=0.33, MINcountBoup=0.33,
          MAXcountBodn=0.33, MINcountBodn=0.33;
   while (true) {
      double sumTS = 0, sumBS = 0, sumBo = 0;
      double devTS = 0, devBS = 0, devBo = 0;
      int beg = 1 + shift;
      int end = history + shift;
      for (int j = beg; j <= end; j++) {
         if (Open[j] > Close[j]) {
            TopShade[j] = High[j] - Open[j];
            BotShade[j] = Close[j] - Low[j];
            Body[j] = Open[j] - Close[j];
         } else {
            TopShade[j] = High[j] - Close[j];
            BotShade[j] = Open[j] - Low[j];
            Body[j] = 0;
            if (Open[j] < Close[j]) {
               Body[j] = Close[j] - Open[j];
            } 
         }
      }
      // Средний размер теней и тела свечей 
      for (int i = beg; i <= end; i++) {
         sumTS += TopShade[i];
         sumBS += BotShade[i];
         sumBo += Body[i];
      }
      sumTS /= history;
      sumBS /= history;
      sumBo /= history;
      for (i = beg; i <= end; i++) {
         devTS += MathAbs(sumTS - TopShade[i]);
         devBS += MathAbs(sumBS - BotShade[i]);
         devBo += MathAbs(sumBo - Body[i]);
      }
      devTS /= history;
      devBS /= history;
      devBo /= history;
   
      // Средний размер отклонений теней и тела свечей с учетом коэф. девиации
      devTS *= k_dev;
      devBS *= k_dev;
      devBo *= k_dev;

      // Средний размер отклонений д.б. меньше размера теней/тела свечи
      if (devTS > sumTS) devTS = sumTS;
      if (devBS > sumBS) devBS = sumBS;
      if (devBo > sumBo) devBo = sumBo;
      // Максимальное/минимальное значение размера теней и тела свечей
      tempMaxTopShade = sumTS + devTS;
      tempMaxBotShade = sumBS + devBS;
      tempMaxBody     = sumBo + devBo;
      tempMinTopShade = sumTS - devTS;
      tempMinBotShade = sumBS - devBS;
      tempMinBody     = sumBo - devBo;

      // Количество больших/малых/средних теней/тел свечей
      countTSup = 0; countTSdn = 0; countTSmd = 0;
      countBSup = 0; countBSdn = 0; countBSmd = 0;
      countBoup = 0; countBodn = 0; countBomd = 0;
      for (i = 1; i <= history; i++) {
         if (TopShade[i] > tempMaxTopShade) {
            countTSup++;
         } else {
            if (TopShade[i] < tempMinTopShade) {
               countTSdn++;
            }
         }
         if (BotShade[i] > tempMaxBotShade) {
            countBSup++;
         } else {
            if (BotShade[i] < tempMinBotShade) {
               countBSdn++;
            }
         }
         if (Body[i] > tempMaxBody) {
            countBoup++;
         } else {
            if (Body[i] < tempMinBody) {
               countBodn++;
            }
         }
         countTSmd = history - countTSup - countTSdn;
         countBSmd = history - countBSup - countBSdn;
         countBomd = history - countBoup - countBodn;
      }
      if (MaxTopShade == 0 || MinTopShade == 0)
         if ((countTSup/history > MINcountTSup) && 
             (countTSup/history < MAXcountTSup) &&
             (countTSdn/history > MINcountTSdn) && 
             (countTSdn/history < MAXcountTSdn)) {
            MaxTopShade = tempMaxTopShade;
            MinTopShade = tempMinTopShade;   
         } 
      if (MaxBotShade == 0 || MinBotShade == 0)
         if ((countBSup/history > MINcountBSup) && 
             (countBSup/history < MAXcountBSup) &&
             (countBSdn/history > MINcountBSdn) && 
             (countBSdn/history < MAXcountBSdn)) {
            MaxBotShade = tempMaxBotShade;
            MinBotShade = tempMinBotShade;   
         } 
      if (MaxBody == 0 || MinBody == 0)
         if ((countBoup/history > MINcountBoup) && 
             (countBoup/history < MAXcountBoup) &&
             (countBodn/history > MINcountBodn) && 
             (countBodn/history < MAXcountBodn)) {
            MaxBody = tempMaxBody;
            MinBody = tempMinBody;   
         } 
      if (MaxTopShade == 0 || MaxBotShade == 0 || MaxBody == 0 ||
          MinTopShade == 0 || MinBotShade == 0 || MinBody == 0) {
         k_dev += 0.1;
         if (1.1 - k_dev < 0.1) {
            if (MaxTopShade == 0 || MinTopShade == 0) {
               MINcountTSup*=coeff;
               MINcountTSdn*=coeff;
               if (MAXcountTSup < 1) MAXcountTSup /=coeff;
               if (MAXcountTSdn < 1) MAXcountTSdn /=coeff;
               k_dev = 0.1;
               continue;
            }   
            if (MaxBotShade == 0 || MinBotShade == 0) {
               MINcountBSup*=coeff;
               MINcountBSdn*=coeff;
               if (MAXcountBSup < 1) MAXcountBSup /=coeff;
               if (MAXcountBSdn < 1) MAXcountBSdn /=coeff;
               k_dev = 0.1;
               continue;
            }   
            if (MaxBody == 0 || MinBody == 0) {
               MINcountBoup*=coeff;
               MINcountBodn*=coeff;
               if (MAXcountBoup < 1) MAXcountBoup /=coeff;
               if (MAXcountBodn < 1) MAXcountBodn /=coeff;
               k_dev = 0.1;
               continue;
            }   
         }
      } else break;  
   }
}
//------------------------------------------------------------
//
//------------------------------------------------------------
int Candle_Code(int sh=1) {                                                    // Смещение исследуемой свечи
   if (Open[sh] > Close[sh]) {
      double body = Open[sh] - Close[sh];                              // Тело  свечи
      int CandleCode = 0;                        // Свеча черная
   } else {
      body = Close[sh] - Open[sh];                              // Тело  свечи
      CandleCode = 64;                                            // Свеча белая или дож
   }
   if (CandleCode == 64) {
      double top_shade = High[sh] - Close[sh];
      double bot_shade = Open[sh] - Low[sh];
      if (body <= MinBody) {
         CandleCode += 16;
      }
      if (body >= MaxBody) {
         CandleCode += 3*16;
      }
      if ((body > MinBody) && (body < MaxBody)) {
         CandleCode += 2*16;
      }
   } else {
      top_shade = High[sh] - Open[sh];
      bot_shade = Close[sh] - Low[sh];
      if (body <= MinBody) {
         CandleCode += 2*16;
      }
      if (body == 0.0) {
         //Print("Тело дож +3*16");
         CandleCode += 3*16;
      }
      if ((body > MinBody) && (body < MaxBody)) {
         CandleCode += 16;
      }
   }
   if (top_shade <= MinTopShade) {
      CandleCode += 4; 
   }
   if (top_shade >= MaxTopShade) {
      CandleCode += 3*4; 
   }
   if ((top_shade > MinTopShade) && (top_shade < MaxTopShade)) {
      CandleCode += 2*4;
   }
   if (bot_shade == 0.0) {
      CandleCode += 3; 
   } else {
      if (bot_shade <= MinBotShade) {
         CandleCode += 2; 
      }
   }
   if ((bot_shade > MinBotShade) && (bot_shade < MaxBotShade)) {
      CandleCode += 1;
   }
   CandleCode = (CandleCode - MathMod(CandleCode,Discret))/Discret;
   return(CandleCode);
}
//------------------------------------------------------------
//
//------------------------------------------------------------
int Pattern_Find(int history=100, bool prn = true, int pattern_bars=4) {
   int trend_bars=TrendBars;
   int ternd_level=TrendLevel;
   int lst_patt = 0;
   if (body == 0 || bars_count == 0) {
      body = 0;
      double RateInfo[100][6];
      ArrayResize(RateInfo, Bars);
      int bars = ArrayCopyRates(RateInfo);
      if (bars > 1000) bars = 1000;
      for (int i = 1; i < bars; i++) {
         body += MathAbs(RateInfo[i][1] - RateInfo[i][4]);
      }
      body /= bars;
   }
   TakeProfit = NormalizeDouble(ternd_level*body/Point/Cor,0);
   StopLoss = NormalizeDouble(10*TakeProfit,0);
   if (StopLoss > 210) StopLoss = 210;
   ArrayResize(pattern,pattern_bars);
   for (i = history; i > trend_bars; i--) {
      if (Close[i] > Open[i])
         for (int j = i-1; j >= i-trend_bars; j--)
            if (Close[j] - Open[i] > ternd_level*body) {
               ObjectDelete("TrendUp");
               ObjectCreate("TrendUp",OBJ_ARROW,0,Time[i],Low[i]-50*Point);
               ObjectSet("TrendUp",OBJPROP_ARROWCODE,SYMBOL_ARROWUP);
               ObjectSet("TrendUp",OBJPROP_COLOR,Red);
               if (!Is_Pattern(i)) {
                  ObjectSet("TrendUp",OBJPROP_COLOR,Green);
                  //========процедура сдвига всего 2-x мерного массива buf на 1 индекс========
                  ArraySetAsSeries(Pattern,true); //"переворачиваем" массив
                  ArrayCopy(Pattern, Pattern, ArrayRange(Pattern,1), 0);
                  ArraySetAsSeries(Pattern,false);//возвращаем в исходное значение
                  for (int k = 0; k < pattern_bars; k++) {
                     Pattern[0][k] = pattern[k];
                  }
                  for (int m = 0; m <= size; m++) {
                     if (Pattern[m][0] == 0 && Pattern[m][1] == 0 && Pattern[m][2] == 0 && Pattern[m][3] == 0) {
                        break;
                     }   
                  }
                  pattern_count = m;
                  if (prn) 
                     if (MathMod(m, 100) == 0) Print("В работе ",m," паттернов на ",Bars," барах");
                  if (m > 0.1*Bars) {
                     for (int l = MathRound(0.1*Bars); l <= size; l++) {
                        for (int n = 0; n < 4; n++) {
                           Pattern[l][n] = 0;
                        }
                     }
                  }
               }
               lst_patt = i;
               break;
            }
      if (Open[i] > Close[i]/* && Close[i+1] >= Open[i+1]*/)
         for (j = i-1; j >= i-trend_bars; j--)
            if (Open[i] - Close[j] > ternd_level*body) {
               ObjectDelete("TrendDn");
               ObjectCreate("TrendDn",OBJ_ARROW,0,Time[i],High[i]+150*Point);
               ObjectSet("TrendDn",OBJPROP_ARROWCODE,SYMBOL_ARROWDOWN);
               ObjectSet("TrendDn",OBJPROP_COLOR,Red);
               if (!Is_Pattern(i)) {
                  ObjectSet("TrendDn",OBJPROP_COLOR,Green);
                  //========процедура сдвига всего 2-x мерного массива buf на 1 индекс========
                  ArraySetAsSeries(Pattern,true); //"переворачиваем" массив
                  ArrayCopy(Pattern, Pattern, ArrayRange(Pattern,1), 0);
                  ArraySetAsSeries(Pattern,false);//возвращаем в исходное значение
                  for (k = 0; k < pattern_bars; k++) {
                     Pattern[0][k] = pattern[k];
                  }
                  for (m = 0; m <= size; m++) {
                     if (Pattern[m][0] == 0 && Pattern[m][1] == 0 && Pattern[m][2] == 0 && Pattern[m][3] == 0) {
                        break;
                     }
                  }
                  if (prn) 
                     if (MathMod(m, 100) == 0) Print("В работе ",m," паттернов на ",Bars," барах");
                  if (m > 0.1*Bars) {
                     for (l = MathRound(0.1*Bars); l <= size; l++) {
                        for (n = 0; n < 4; n++) {
                           Pattern[l][n] = 0;
                        }
                     }
                  }
               }
               lst_patt = i;
               break;
            }
   }
   return(lst_patt);
}
//------------------------------------------------------------
//
//------------------------------------------------------------
bool Is_Pattern(int sh=0) {
   for (int k = 0; k < 4; k++) {
      pattern[k] = Candle_Code(sh+1+k);
   }
   for (int m = 0; m < size; m++) {
      if (Pattern[m][0] == pattern[0] && Pattern[m][1] == pattern[1] && Pattern[m][2] == pattern[2] && Pattern[m][3] == pattern[3]) {
         return(true);
      }
      if (Pattern[m][0] == 0 && Pattern[m][1] == 0 && Pattern[m][2] == 0 && Pattern[m][3] == 0) {
         return(false);
      }
   }
   return(false);
}
//+------------------------------------------------------------------+
//| Handle Open Positions                                            |
//| Check if any open positions need to be closed or modified        |
//+------------------------------------------------------------------+
int HandleOpenPositions()
  {
   DelOrdersComlement();
   int cnt;
   int tot = 0, 
       to = OrdersTotal();
   double pt = 0;
   for(cnt=to-1;cnt>=0;cnt--) {
      OrderSelect (cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderSymbol()!=Symbol()) continue;
      if(OrderMagicNumber()!=MagicNumber)  continue;
      if(OrderProfit() > 0)
         pt = pt + OrderProfit();
   }
   if (TimeToStr(Time[0],TIME_MINUTES) == "00:00") day_equity = AccountBalance() - not_used_part;
   new_equity = AccountEquity() - not_used_part;
   for(cnt=to-1;cnt>=0;cnt--) {
      OrderSelect (cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderSymbol()!=Symbol()) continue;
      if(OrderMagicNumber()!=MagicNumber)  continue;
      if(OrderProfit() > 0 && pt > 0.01*profit_percent*MaxUsedPart) {
         Alert(Symbol()," Закрыли: суммарный профит = ",pt,">",0.01*profit_percent*MaxUsedPart,", ордеров: ",OrdersTotal());
         ClosePosBySelect(OrderType());
      }
      if (TimeControl >= 1)
         if (OrderTakeProfit() > 0) {
            int bars_control = MathRound((Time[0] - OrderOpenTime())/60/Period());
            if (bars_control  >= TrendBars)
               if ((TimeControl == 1 && OrderProfit() >= -0.0001*bars_control*profit_percent*MaxUsedPart) || TimeControl == 2) {
                  Alert(Symbol()," Закрыли: по времени");
                  CloseSelectTicket(OrderTicket());
               }   
         } 
   }
   to = OrdersTotal();
   for(cnt=to-1;cnt>=0;cnt--) {
      OrderSelect (cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderSymbol()!=Symbol()) continue;
      if(OrderMagicNumber()!=MagicNumber)  continue;
      if(OrderProfit() > 0 && pt > 0.01*profit_percent*MaxUsedPart) {
         Alert(Symbol()," Закрыли: суммарный профит = ",pt,">",0.01*profit_percent*MaxUsedPart,", ордеров: ",OrdersTotal());
         ClosePosBySelect(OrderType());
      }
      if (DayControl == 1) {
         int last_bar_of_day = 86400 - MathFloor((Time[0] - MathFloor(Time[0]/60/60/24)*60*60*24)/60/Period())*60*Period();
         if (last_bar_of_day <= Period()*60) {  // В начале последнего бара
            if (new_equity > day_equity*(1 + 0.01*profit_percent)) {
               Alert(Symbol()," Закрыли: в конце дня");
               CloseSelectTicket(OrderTicket());
            }
         }
      }   
   }
   to = OrdersTotal();
   for(cnt=to-1;cnt>=0;cnt--) {
      OrderSelect (cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderSymbol()!=Symbol()) continue;
      if(OrderMagicNumber()!=MagicNumber)  continue;
      tot++;
   }
   if (tot == 0) equity = AccountBalance() - not_used_part;
   if (tot > 1) {
      if (EquityCtrl == 1) {
         if (new_equity > equity*(1 + 0.01*profit_percent)) {
            Alert(Symbol()," Закрыли: по Equity",", ордеров: ",tot);
            CloseAllPos();
         }
      }
   }
  }
//------------------------------------------------------------
//
//------------------------------------------------------------
double GetFreeMargin() {
   double free = equity;
   int total = OrdersTotal();   
   for(int i = total - 1; i >= 0; i--) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == false) continue;
      double 
         op  = OrderOpenPrice(),
         sl  = OrderStopLoss(), 
         lot = OrderLots(), 
         tv  = MarketInfo(Symbol(),MODE_TICKVALUE);
      if (sl == 0) free *= 0.7;
      else {
         free -= (MathAbs(op - sl)/Point) * lot * tv;
      }   
   }
   return(free);   
}
//------------------------------------------------------------
//
//------------------------------------------------------------
void Print_Comment() {
   int total = OrdersTotal();
   int count_op_buy = 0;   
   int count_op_sell = 0; 
   double op_buy_profit = 0;  
   double op_sell_profit = 0;  
   double op_buy_profit_future = 0;  
   double op_sell_profit_future = 0;  
   double op_buy_loss_future = 0;  
   double op_sell_loss_future = 0;  
   for(int i = total - 1; i >= 0; i--) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == false) continue;
      if (OrderSymbol()!=Symbol()) continue;
      if (100*MathFloor(OrderMagicNumber()/100)!=MagicNumber)  continue;
      double 
         op  = OrderOpenPrice(),
         sl  = OrderStopLoss(), 
         tp  = OrderTakeProfit(), 
         lot = OrderLots(), 
         tv  = MarketInfo(Symbol(),MODE_TICKVALUE);
      if (OrderType() == OP_BUY) {
         count_op_buy++;
         op_buy_profit += OrderProfit();
         op_buy_profit_future += (MathAbs(op - tp)/Point) * lot * tv;
         op_buy_loss_future += -(MathAbs(op - sl)/Point) * lot * tv;
      }
      if (OrderType() == OP_SELL) {
         count_op_sell++;
         op_sell_profit += OrderProfit();
         op_sell_profit_future += (MathAbs(op - tp)/Point) * lot * tv;
         op_sell_loss_future += -(MathAbs(op - sl)/Point) * lot * tv;
      }
   }
   string info = StringConcatenate(
      "Ордера | К-во | Баланс | Profit | Loss \n",
      "Всего       ",count_op_buy + count_op_sell,"     ",MathRound(op_buy_profit + op_sell_profit),"     ",MathRound(op_buy_profit_future + op_sell_profit_future),"     ",MathRound(op_buy_loss_future + op_sell_loss_future),"\n",
      "BUY         ",count_op_buy,"     ",MathRound(op_buy_profit),"     ",MathRound(op_buy_profit_future),"     ",MathRound(op_buy_loss_future),"\n",
      "SELL         ",count_op_sell,"     ",MathRound(op_sell_profit),"     ",MathRound(op_sell_profit_future),"     ",MathRound(op_sell_loss_future),"\n",
      "Паттернов в работе         ",pattern_count);
   if (ConsiderHistoryProfits == 1) info = StringConcatenate(info,"\n",   
      "ProfitableOrdersOfLongs      ",pool,"\n",
      "ProfitableOrdersOfShorts     ",poos);
   if (EquityCtrl == 1) info = StringConcatenate(info,"\n",   
      "Текущий эквити                ",DoubleToStr(new_equity, 0),"$","\n",
      "Фиксированный эквити      ",DoubleToStr(equity, 0),"$");
   if (DayControl == 1) info = StringConcatenate(info,"\n",   
      "Эквити на начало дня      ",DoubleToStr(day_equity, 0),"$");
   Comment(info);
}
int ProfitableOrdersOfLongs() {
   int i,Orders=0,all_orders=0,k; 
   k = OrdersHistoryTotal();
   for(i=k-1;i>=0;i--) {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))continue;
      if(OrderSymbol()!=Symbol())continue;
      if(OrderMagicNumber()!=MagicNumber)continue;
      all_orders++;
      if (Variant > 0)
         if (all_orders > Variant+1) break;
      if(OrderType()==0)if(OrderProfit()>0) Orders++;              
   }  
   return(Orders);
} 
//====================================================================================================== 
int ProfitableOrdersOfShorts() {
   int i,Orders=0,all_orders=0,k;
   k = OrdersHistoryTotal();
   for(i=k-1;i>=0;i--) {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))continue;
      if(OrderSymbol()!=Symbol())continue;
      if(OrderMagicNumber()!=MagicNumber)continue;
      all_orders++;
      if (Variant > 0)
         if (all_orders > Variant+1) break;
      if(OrderType()==1)if(OrderProfit()>0) Orders++;              
   }  
   return(Orders);
} 
//====================================================================================================== 
void DelOrdersComlement() {
   int to = OrdersTotal();
   for(int cnt=to-1;cnt>=0;cnt--) {
      OrderSelect (cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol()!=Symbol()) continue;
      if (OrderMagicNumber()!=MagicNumber)  continue;
      if (OrderType() == OP_BUY) {
         int or_ti1 = OrderTicket();
         double or_lo1 = OrderLots();
         double or_pr1 = OrderProfit();
         for(int ct=to-1;ct>=0;ct--) {
            OrderSelect (ct, SELECT_BY_POS, MODE_TRADES);
            if (OrderSymbol()!=Symbol()) continue;
            if (OrderMagicNumber()!=MagicNumber)  continue;
            if (OrderType() == OP_BUY)  continue;
            int or_ti2 = OrderTicket();
            double or_lo2 = OrderLots();
            double or_pr2 = OrderProfit();
            if (or_lo1 == or_lo2) 
               if (or_pr1 == -or_pr2) {
                  Print("OrderClose(",or_ti2,",",or_lo2,",",NormalizeDouble(Ask,Digits),",",Slippage,")");
                  if (OrderClose(or_ti2,or_lo2,NormalizeDouble(Ask,Digits),Slippage))
                     Print("Закрыли один из двух комплементарных ордера");
                  Print("OrderClose(",or_ti1,",",or_lo1,",",NormalizeDouble(Bid,Digits),",",Slippage,")");
                  if (OrderClose(or_ti1,or_lo1,NormalizeDouble(Bid,Digits),Slippage))
                     Print("Закрыли второй из двух комплементарных ордера");
               }
         }
      }
   }
}   

