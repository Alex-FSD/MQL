#property copyright "Copyright © 2008, AutoTrader fx-auto-trader@mail.ru"
#property link      "fx-auto-trader@mail.ru"

#include <stdlib.mqh>

extern double lots = 0.1;
extern int Slippage = 2;
extern int Warp = 67;
extern double Deviation = 1.85;
extern int Amplitude = 155;
extern double Distortion = 0.79;
extern bool SL_long_EQUAL_SL_short = FALSE;
extern double SL_long = 80.0;
extern double SL_short = 65.0;
extern bool UseSound = TRUE;
extern int MagicNumber = 55555;
string gs_140 = "PNN Shell © 2008, FX-Systems Co Ltd";
int gi_148 = 0;
int gi_152 = 6;
double gd_156 = 5.0;
double gd_164 = 25.0;

void init() {
   if (SL_long_EQUAL_SL_short == TRUE) SL_short = SL_long;
}

void deinit() {
}

void start() {
   int li_0;
   int li_4;
   int l_ord_total_8;
   int l_ticket_16;
   ExternalParametersCheck();
   CheckConditions();
   if (Time[0] != gi_148) {
      gi_148 = Time[0];
      li_0 = 3;
      if (IsTradeAllowed()) {
         RefreshRates();
         li_0 = MarketInfo(Symbol(), MODE_SPREAD);
      } else {
         gi_148 = Time[1];
         return;
      }
      li_4 = -1;
      l_ord_total_8 = OrdersTotal();
      for (int l_pos_12 = l_ord_total_8 - 1; l_pos_12 >= 0; l_pos_12--) {
         OrderSelect(l_pos_12, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            l_ticket_16 = OrderTicket();
            if (OrderType() == OP_BUY) {
               if (Bid <= OrderStopLoss() + (2.0 * SL_long + li_0) * Point) return;
               if (Direction(Warp, Deviation, Amplitude, Distortion) < 0.0) {
                  li_4 = OrderSendReliable(Symbol(), OP_SELL, lots, Bid, Slippage, Ask + SL_short * Point, 0, gs_140, MagicNumber, 0, Red);
                  Sleep(30000);
                  if (li_4 < 0) {
                     gi_148 = Time[1];
                     return;
                  }
                  OrderSelect(l_ticket_16, SELECT_BY_TICKET);
                  OrderClose(l_ticket_16, OrderLots(), Bid, 3, Blue);
                  return;
               }
               if (!(!OrderModifyReliable(OrderTicket(), OrderOpenPrice(), Bid - SL_long * Point, 0, 0, Blue))) return;
               Sleep(30000);
               gi_148 = Time[1];
               return;
            }
            if (Ask >= OrderStopLoss() - (2.0 * SL_short + li_0) * Point) return;
            if (Direction(Warp, Deviation, Amplitude, Distortion) > 0.0) {
               li_4 = OrderSendReliable(Symbol(), OP_BUY, lots, Ask, Slippage, Bid - SL_long * Point, 0, gs_140, MagicNumber, 0, Blue);
               Sleep(30000);
               if (li_4 < 0) {
                  gi_148 = Time[1];
                  return;
               }
               OrderSelect(l_ticket_16, SELECT_BY_TICKET);
               OrderClose(l_ticket_16, OrderLots(), Ask, 3, Blue);
               return;
            }
            if (!(!OrderModifyReliable(OrderTicket(), OrderOpenPrice(), Ask + SL_short * Point, 0, 0, Blue))) return;
            Sleep(30000);
            gi_148 = Time[1];
            return;
         }
      }
      if (Direction(Warp, Deviation, Amplitude, Distortion) > 0.0) {
         li_4 = OrderSendReliable(Symbol(), OP_BUY, lots, Ask, Slippage, Bid - SL_long * Point, 0, gs_140, MagicNumber, 0, Blue);
         if (li_4 < 0) {
            Sleep(30000);
            gi_148 = Time[1];
         }
      } else {
         li_4 = OrderSendReliable(Symbol(), OP_SELL, lots, Bid, Slippage, Ask + SL_short * Point, 0, gs_140, MagicNumber, 0, Red);
         if (li_4 < 0) {
            Sleep(30000);
            gi_148 = Time[1];
         }
      }
   }
}

double Direction(int ai_0, double ad_4, int ai_12, double ad_16) {
   double ld_ret_24 = 0;
   double l_iac_32 = iAC(Symbol(), 0, 0);
   double l_iac_40 = iAC(Symbol(), 0, 7);
   double l_iac_48 = iAC(Symbol(), 0, 14);
   double l_iac_56 = iAC(Symbol(), 0, 21);
   ld_ret_24 = ai_0 * l_iac_32 + 100.0 * (ad_4 - 1.0) * l_iac_40 + (ai_12 - 100) * l_iac_48 + 100.0 * ad_16 * l_iac_56;
   return (ld_ret_24);
}

void ExternalParametersCheck() {
   if (Slippage > 10) {
      Comment("... Задано слишком высокое значение проскальзывания Slippage,", 
      "\n", "... Скорректируйте чтобы было не более 10п и перезапустите эксперт.");
      return;
   }
   if (Warp > 100 || Warp < -100) {
      Comment("... Неправильно задан параметр искажения Warp,", 
         "\n", "... Диапазон допустимых значений от -100 до +100 с шагом 1,", 
      "\n", "... Скорректируйте и перезапустите эксперт.");
      return;
   }
   if (Deviation > 2.0 || Warp < 0) {
      Comment("... Неправильно задан параметр девиации Deviation,", 
         "\n", "... Диапазон допустимых значений от 0 до +2 с шагом 0.01,", 
      "\n", "... Скорректируйте и перезапустите эксперт.");
      return;
   }
   if (Amplitude > 200 || Amplitude < 0) {
      Comment("... Неправильно задан параметр девиации Amplitude,", 
         "\n", "... Диапазон допустимых значений от 0 до +200 с шагом 1,", 
      "\n", "... Скорректируйте и перезапустите эксперт.");
      return;
   }
   if (Distortion > 1.0 || Distortion < -1.0) {
      Comment("... Неправильно задан параметр девиации Distortion,", 
         "\n", "... Диапазон допустимых значений от -1 до +1 с шагом 0.01,", 
      "\n", "... Скорректируйте и перезапустите эксперт.");
      return;
   }
}

void CheckConditions() {
   if (IsConnected() == FALSE) {
      Comment(" ... ОТСУТСТВУЕТ связь с торговым сервером\n" + " ... Приём торговых команд ОСТАНОВЛЕН");
      return;
   }
   if (IsTradeContextBusy() == TRUE) Comment(" ... Торговый поток ЗАНЯТ\n" + " ... Торговая команда на сервер не отослана");
}

int OrderSendReliable(string a_symbol_0, int a_cmd_8, double a_lots_12, double a_price_20, int a_slippage_28, double a_price_32, double a_price_40, string a_comment_48, int a_magic_56, int a_datetime_60 = 0, color a_color_64 = -1) {
   double ld_96;
   if (!IsConnected()) {
      Print("OrderSendReliable:  error: IsConnected() == false");
      return (-1);
   }
   if (IsStopped()) {
      Print("OrderSendReliable:  error: IsStopped() == true");
      return (-1);
   }
   for (int l_count_68 = 0; !IsTradeAllowed() && l_count_68 < gi_152; l_count_68++) OrderReliable_SleepRandomTime(gd_156, gd_164);
   if (!IsTradeAllowed()) {
      Print("OrderSendReliable: error: no operation possible because IsTradeAllowed()==false, even after retries.");
      return (-1);
   }
   int li_72 = MarketInfo(a_symbol_0, MODE_DIGITS);
   if (li_72 > 0) {
      a_price_20 = NormalizeDouble(a_price_20, li_72);
      a_price_32 = NormalizeDouble(a_price_32, li_72);
      a_price_40 = NormalizeDouble(a_price_40, li_72);
   }
   if (a_price_32 != 0.0) OrderReliable_EnsureValidStop(a_symbol_0, a_price_20, a_price_32);
   int l_error_76 = GetLastError();
   l_error_76 = 0;
   bool li_80 = FALSE;
   bool li_84 = FALSE;
   int l_ticket_88 = -1;
   if (a_cmd_8 == OP_BUYSTOP || a_cmd_8 == OP_SELLSTOP) {
      l_count_68 = 0;
      while (!li_80) {
         if (IsTradeAllowed()) {
            l_ticket_88 = OrderSend(a_symbol_0, a_cmd_8, a_lots_12, a_price_20, a_slippage_28, a_price_32, a_price_40, a_comment_48, a_magic_56, a_datetime_60, a_color_64);
            l_error_76 = GetLastError();
         } else l_count_68++;
         switch (l_error_76) {
         case 0/* NO_ERROR */:
            li_80 = TRUE;
            break;
         case 4/* SERVER_BUSY */:
         case 6/* NO_CONNECTION */:
         case 129/* INVALID_PRICE */:
         case 136/* OFF_QUOTES */:
         case 137/* BROKER_BUSY */:
         case 146/* TRADE_CONTEXT_BUSY */:
            l_count_68++;
            break;
         case 135/* PRICE_CHANGED */:
         case 138/* REQUOTE */:
            RefreshRates();
            continue;
            break;
         case 130/* INVALID_STOPS */:
            ld_96 = MarketInfo(a_symbol_0, MODE_STOPLEVEL) * MarketInfo(a_symbol_0, MODE_POINT);
            if (a_cmd_8 == OP_BUYSTOP) {
               if (MathAbs(Ask - a_price_20) <= ld_96) li_84 = TRUE;
            } else {
               if (a_cmd_8 == OP_SELLSTOP)
                  if (MathAbs(Bid - a_price_20) <= ld_96) li_84 = TRUE;
            }
            li_80 = TRUE;
            break;
         default:
            li_80 = TRUE;
         }
         if (l_count_68 > gi_152) li_80 = TRUE;
         if (li_80) {
            if (l_error_76 != 0/* NO_ERROR */) Print("OrderSendReliable: non-retryable error: " + ErrorDescription(l_error_76));
            if (l_count_68 > gi_152) Print("OrderSendReliable: retry attempts maxed at " + gi_152);
         }
         if (!li_80) {
            Print("OrderSendReliable: retryable error (" + l_count_68 + "/" + gi_152 + "): " + ErrorDescription(l_error_76));
            OrderReliable_SleepRandomTime(gd_156, gd_164);
            RefreshRates();
         }
      }
      if (l_error_76 == 0/* NO_ERROR */) {
         Print("OrderSendReliable: apparently successful OP_BUYSTOP or OP_SELLSTOP order placed, details follow.");
         OrderSelect(l_ticket_88, SELECT_BY_TICKET, MODE_TRADES);
         OrderPrint();
         return (l_ticket_88);
      }
      if (!li_84) {
         Print("OrderSendReliable: failed to execute OP_BUYSTOP/OP_SELLSTOP, after " + l_count_68 + " retries");
         Print("OrderSendReliable: failed trade: " + OrderReliable_CommandString(a_cmd_8) + " " + a_symbol_0 + "@" + a_price_20 + " tp@" + a_price_40 + " sl@" + a_price_32);
         Print("OrderSendReliable: last error: " + ErrorDescription(l_error_76));
         return (-1);
      }
   }
   if (li_84) {
      Print("OrderSendReliable: going from limit order to market order because market is too close.");
      if (a_cmd_8 == OP_BUYSTOP) {
         a_cmd_8 = 0;
         a_price_20 = Ask;
      } else {
         if (a_cmd_8 == OP_SELLSTOP) {
            a_cmd_8 = 1;
            a_price_20 = Bid;
         }
      }
   }
   l_error_76 = GetLastError();
   l_error_76 = 0;
   l_ticket_88 = -1;
   if (a_cmd_8 == OP_BUY || a_cmd_8 == OP_SELL) {
      l_count_68 = 0;
      while (!li_80) {
         if (IsTradeAllowed()) {
            l_ticket_88 = OrderSend(a_symbol_0, a_cmd_8, a_lots_12, a_price_20, a_slippage_28, a_price_32, a_price_40, a_comment_48, a_magic_56, a_datetime_60, a_color_64);
            l_error_76 = GetLastError();
         } else l_count_68++;
         switch (l_error_76) {
         case 0/* NO_ERROR */:
            li_80 = TRUE;
            break;
         case 4/* SERVER_BUSY */:
         case 6/* NO_CONNECTION */:
         case 129/* INVALID_PRICE */:
         case 136/* OFF_QUOTES */:
         case 137/* BROKER_BUSY */:
         case 146/* TRADE_CONTEXT_BUSY */:
            l_count_68++;
            break;
         case 135/* PRICE_CHANGED */:
         case 138/* REQUOTE */:
            RefreshRates();
            continue;
         default:
            li_80 = TRUE;
         }
         if (l_count_68 > gi_152) li_80 = TRUE;
         if (!li_80) {
            Print("OrderSendReliable: retryable error (" + l_count_68 + "/" + gi_152 + "): " + ErrorDescription(l_error_76));
            OrderReliable_SleepRandomTime(gd_156, gd_164);
            RefreshRates();
         }
         if (li_80) {
            if (l_error_76 != 0/* NO_ERROR */) Print("OrderSendReliable: non-retryable error: " + ErrorDescription(l_error_76));
            if (l_count_68 > gi_152) Print("OrderSendReliable: retry attempts maxed at " + gi_152);
         }
      }
      if (l_error_76 == 0/* NO_ERROR */) {
         Print("OrderSendReliable: apparently successful OP_BUY or OP_SELL order placed, details follow.");
         OrderSelect(l_ticket_88, SELECT_BY_TICKET, MODE_TRADES);
         OrderPrint();
         return (l_ticket_88);
      }
      Print("OrderSendReliable: failed to execute OP_BUY/OP_SELL, after " + l_count_68 + " retries");
      Print("OrderSendReliable: failed trade: " + OrderReliable_CommandString(a_cmd_8) + " " + a_symbol_0 + "@" + a_price_20 + " tp@" + a_price_40 + " sl@" + a_price_32);
      Print("OrderSendReliable: last error: " + ErrorDescription(l_error_76));
      return (-1);
   }
   return (0);
}

bool OrderModifyReliable(int a_ticket_0, double a_price_4, double a_price_12, double a_price_20, int a_datetime_28, color a_color_32 = -1) {
   string ls_40;
   if (!IsConnected()) {
      Print("OrderModifyReliable:  error: IsConnected() == false");
      return (-1);
   }
   if (IsStopped()) {
      Print("OrderModifyReliable:  error: IsStopped() == true");
      return (-1);
   }
   for (int l_count_36 = 0; !IsTradeAllowed() && l_count_36 < gi_152; l_count_36++) OrderReliable_SleepRandomTime(gd_156, gd_164);
   if (!IsTradeAllowed()) {
      Print("OrderModifyReliable: error: no operation possible because IsTradeAllowed()==false, even after retries.");
      return (-1);
   }
   int l_error_52 = GetLastError();
   l_error_52 = 0;
   bool li_56 = FALSE;
   l_count_36 = 0;
   bool l_bool_60 = FALSE;
   while (!li_56) {
      if (IsTradeAllowed()) {
         l_bool_60 = OrderModify(a_ticket_0, a_price_4, a_price_12, a_price_20, a_datetime_28, a_color_32);
         l_error_52 = GetLastError();
      } else l_count_36++;
      if (l_bool_60 == TRUE) li_56 = TRUE;
      switch (l_error_52) {
      case 0/* NO_ERROR */:
         li_56 = TRUE;
         break;
      case 1/* NO_RESULT */:
         li_56 = TRUE;
         break;
      case 4/* SERVER_BUSY */:
      case 6/* NO_CONNECTION */:
      case 129/* INVALID_PRICE */:
      case 136/* OFF_QUOTES */:
      case 137/* BROKER_BUSY */:
      case 146/* TRADE_CONTEXT_BUSY */:
         l_count_36++;
         break;
      case 135/* PRICE_CHANGED */:
      case 138/* REQUOTE */:
         RefreshRates();
         continue;
      default:
         li_56 = TRUE;
      }
      if (l_count_36 > gi_152) li_56 = TRUE;
      if (!li_56) {
         Print("OrderModifyReliable: retryable error (" + l_count_36 + "/" + gi_152 + "): " + ErrorDescription(l_error_52));
         OrderReliable_SleepRandomTime(gd_156, gd_164);
         RefreshRates();
      }
      if (li_56) {
         if (l_error_52 != 0/* NO_ERROR */ && l_error_52 != 1/* NO_RESULT */) Print("OrderModifyReliable: non-retryable error: " + ErrorDescription(l_error_52));
         if (l_count_36 > gi_152) Print("OrderModifyReliable: retry attempts maxed at " + gi_152);
      }
   }
   if (l_error_52 == 0/* NO_ERROR */) {
      Print("OrderModifyReliable: apparently successful modification order, updated trade details follow.");
      OrderSelect(a_ticket_0, SELECT_BY_TICKET, MODE_TRADES);
      OrderPrint();
      return (TRUE);
   }
   if (l_error_52 == 1/* NO_RESULT */) {
      Print("OrderModifyReliable:  Server reported modify order did not actually change parameters.");
      Print("OrderModifyReliable:  redundant modification: " + a_ticket_0 + " " + ls_40 + "@" + a_price_4 + " tp@" + a_price_20 + " sl@" + a_price_12);
      Print("OrderModifyReliable:  Suggest modifying code logic");
   }
   Print("OrderModifyReliable: failed to execute modify after " + l_count_36 + " retries");
   Print("OrderModifyReliable: failed modification: " + a_ticket_0 + " " + ls_40 + "@" + a_price_4 + " tp@" + a_price_20 + " sl@" + a_price_12);
   Print("OrderModifyReliable: last error: " + ErrorDescription(l_error_52));
   return (FALSE);
}

void OrderReliable_EnsureValidStop(string a_symbol_0, double ad_8, double &ad_16) {
   double ld_24;
   if (ad_16 != 0.0) {
      ld_24 = MarketInfo(a_symbol_0, MODE_STOPLEVEL) * MarketInfo(a_symbol_0, MODE_POINT);
      if (MathAbs(ad_8 - ad_16) <= ld_24) {
         if (ad_8 > ad_16) ad_16 = ad_8 - ld_24;
         else {
            if (ad_8 < ad_16) ad_16 = ad_8 + ld_24;
            else Print("OrderReliable_EnsureValidStop: error, passed in price == sl, cannot adjust");
         }
         ad_16 = NormalizeDouble(ad_16, MarketInfo(a_symbol_0, MODE_DIGITS));
      }
   }
}

string OrderReliable_CommandString(int ai_0) {
   if (ai_0 == 0) return ("OP_BUY");
   if (ai_0 == 1) return ("OP_SELL");
   if (ai_0 == 4) return ("OP_BUYSTOP");
   if (ai_0 == 5) return ("OP_SELLSTOP");
   return ("(CMD==" + ai_0 + ")");
}

void OrderReliable_SleepRandomTime(double ad_0, double ad_8) {
   double ld_16;
   int li_24;
   double ld_28;
   if (IsTesting() == 0) {
      ld_16 = MathCeil(ad_0 / 0.1);
      if (ld_16 > 0.0) {
         li_24 = MathRound(ad_8 / 0.1);
         ld_28 = 1.0 - 1.0 / ld_16;
         Sleep(1000);
         for (int l_count_36 = 0; l_count_36 < li_24; l_count_36++) {
            if (MathRand() > 32768.0 * ld_28) break;
            Sleep(1000);
         }
      }
   }
}