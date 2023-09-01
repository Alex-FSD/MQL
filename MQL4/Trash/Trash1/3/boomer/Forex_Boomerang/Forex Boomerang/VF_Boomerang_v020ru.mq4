#property copyright "*"
#property link      "*"

extern bool CanOpenNew = TRUE;
extern int TimeFrame = 60;
extern bool Send_Email = FALSE;
extern bool Show_Alerts = TRUE;
extern int Magic_N = 888;
extern int OrdersCount = 10;
extern int Level = 50;
extern double Ord_1_Lots = 0.1;
extern double Ord_2_Lots = 0.2;
extern double Ord_3_Lots = 0.4;
extern double Ord_4_Lots = 0.8;
extern double Ord_5_Lots = 1.6;
extern double Ord_6_Lots = 3.2;
extern double Ord_7_Lots = 6.4;
extern double Ord_8_Lots = 12.8;
extern double Ord_9_Lots = 25.0;
extern double Ord_10_Lots = 25.0;
extern bool InfoOn = TRUE;
extern color InfoColor = Yellow;
int gia_192[] = {1111111, 1111111, 1111111, 1111111};
string gs_196 = "2008.11.21";
int gi_204 = 16748574;
string gs_208 = "VF_Boomerang";
string gs_224 = "AccInfSymbInf_Lbl_";
int g_datetime_232 = 0;
int g_datetime_236 = 0;
int g_datetime_240 = 0;
int g_datetime_244 = 0;
int g_datetime_248 = 0;
int g_datetime_252 = 0;
int g_datetime_256 = 0;
int g_datetime_260 = 0;
int g_datetime_264 = 0;
bool gi_268;
int gia_272[];
string gsa_276[];
int gia_280[];
double gda_284[];
double gda_288[];
double gda_292[];
double gda_296[];
int gia_300[];
int gia_304[];

int init() {
   bool li_0;
   /*if (!IsTesting() && !IsDemo()) {
      li_0 = FALSE;
      for (int l_index_4 = 0; l_index_4 < ArraySize(gia_192); l_index_4++) {
         if (gia_192[l_index_4] == AccountNumber()) {
            li_0 = TRUE;
            break;
         }
      }
      if (!li_0) Alert("Эксперт VF_Boomerang - неверный номер счета!");
   }
   if (TimeCurrent() > StrToTime(gs_196)) Alert("Эксперт VF_Boomerang - закончилось время работы!");*/
   return (0);
}

int deinit() {
   fObjDeleteByPrefix(gs_224);
   return (0);
}

int start() {
   bool li_0;
   double l_ord_open_price_60;
   double l_ord_open_price_68;
   double l_ord_stoploss_76;
   double l_ord_stoploss_84;
   double l_ord_open_price_92;
   double l_ord_open_price_100;
   double ld_108;
   double ld_116;
   int li_128;
   int l_str2int_132;
   int li_136;
   double ld_140;
   string ls_148;
   double ld_160;
   double ld_168;
   double ld_176;
   int l_pos_4 = 0;
   /*if (!IsTesting() && !IsDemo()) {
      li_0 = FALSE;
      for (int l_pos_4 = 0; l_pos_4 < ArraySize(gia_192); l_pos_4++) {
         if (gia_192[l_pos_4] == AccountNumber()) {
            li_0 = TRUE;
            break;
         }
      }
      if (!li_0) {
         Alert("ксперт VF_Boomerang - неверный номер счета!");
         return (0);
      }
   }
   if (TimeCurrent() > StrToTime(gs_196)) {
      Alert("ксперт VF_Boomerang - закончилось время работы!");
      return (0);
   }*/
   if (InfoOn) AccountAndSymbolLbls();
   fObjLabel("VF_Boomerang_Obj_Lbl", 4, 1, "“Victorious Forex” Trading Technologies", 2, gi_204, 8, 0, "Arial", FALSE);
   double l_irsi_8 = iRSI(NULL, TimeFrame, 12, PRICE_CLOSE, 1);
   double l_irsi_16 = iRSI(NULL, TimeFrame, 12, PRICE_CLOSE, 2);
   bool li_24 = FALSE;
   if ((l_irsi_8 > 50.0 && l_irsi_16 <= 50.0) || (l_irsi_8 < 50.0 && l_irsi_16 >= 50.0)) li_24 = TRUE;
   bool li_28 = FALSE;
   bool li_32 = FALSE;
   bool li_36 = FALSE;
   bool li_40 = FALSE;
   int li_unused_44 = 0;
   bool li_48 = FALSE;
   int li_unused_52 = 0;
   bool li_56 = FALSE;
   int l_count_124 = 0;
   for (l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
      if (OrderSelect(l_pos_4, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic_N) {
            l_count_124++;
            if (StringFind(OrderComment(), "=1=", 0) == 0) {
               if (OrderType() == OP_BUY) li_28 = TRUE;
               if (OrderType() == OP_BUYLIMIT) {
                  li_32 = TRUE;
                  l_ord_open_price_60 = OrderOpenPrice();
                  l_ord_stoploss_76 = OrderStopLoss();
               }
               if (OrderType() == OP_SELL) li_36 = TRUE;
               if (OrderType() == OP_SELLLIMIT) {
                  li_40 = TRUE;
                  l_ord_open_price_68 = OrderOpenPrice();
                  l_ord_stoploss_84 = OrderStopLoss();
               }
            }
            if (StringFind(OrderComment(), "=2=", 0) == 0) {
               if (OrderType() == OP_BUY) li_unused_44 = 1;
               if (OrderType() == OP_BUYSTOP) {
                  li_48 = TRUE;
                  l_ord_open_price_100 = OrderOpenPrice();
               }
               if (OrderType() == OP_SELL) li_unused_52 = 1;
               if (OrderType() == OP_SELLSTOP) {
                  li_56 = TRUE;
                  l_ord_open_price_92 = OrderOpenPrice();
               }
            }
         }
      } else return (0);
   }
   if (l_count_124 == 0 && CanOpenNew) {
      if (li_24) {
         l_ord_open_price_60 = ND(Ask - Point * Level);
         l_ord_stoploss_76 = ND(Bid - 2.0 * Point * Level);
         if (fOrderSetBuyLimit(Ord_1_Lots, l_ord_open_price_60, l_ord_stoploss_76, ND(Bid), "=1=") > 0) {
            l_count_124++;
            li_32 = TRUE;
         } else return (0);
      }
   }
   if (l_count_124 == 1) {
      if (li_32) {
         l_ord_open_price_68 = ND(l_ord_open_price_60 - (Ask - Bid) + 2.0 * Point * Level);
         l_ord_stoploss_84 = ND(l_ord_open_price_68 + Point * Level + (Ask - Bid));
         if (fOrderSetSellLimit(Ord_1_Lots, l_ord_open_price_68, l_ord_stoploss_84, ND(l_ord_open_price_68 - Point * Level + (Ask - Bid)), "=1=") > 0) {
            l_count_124++;
            li_40 = TRUE;
         } else return (0);
      }
   }
   if (l_count_124 == 2) {
      if (li_32 && li_40) {
         l_ord_open_price_92 = ND(l_ord_stoploss_76);
         ld_108 = ND(l_ord_open_price_60);
         if (fOrderSetSellStop(Ord_2_Lots, l_ord_open_price_92, ld_108, ND(l_ord_open_price_92 - Point * Level + (Ask - Bid)), "=2=") > 0) {
            l_count_124++;
            li_56 = TRUE;
         } else return (0);
      }
   }
   if (l_count_124 == 3) {
      if (li_32 && li_40 && li_56) {
         l_ord_open_price_100 = ND(l_ord_stoploss_84);
         ld_116 = ND(l_ord_open_price_68);
         if (fOrderSetBuyStop(Ord_2_Lots, l_ord_open_price_100, ld_116, ND(l_ord_open_price_100 + Point * Level - (Ask - Bid)), "=2=") > 0) {
            l_count_124++;
            li_48 = TRUE;
         } else return (0);
      }
   }
   if (li_36) {
      if (li_32 || li_56) {
         for (l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
            if (OrderSelect(l_pos_4, SELECT_BY_POS, MODE_TRADES)) {
               if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic_N) {
                  if (StringFind(OrderComment(), "=1=", 0) == 0) {
                     if (OrderType() == OP_BUYLIMIT) {
                        if (fDeletePendig(OrderTicket()) == 0) {
                           li_32 = FALSE;
                           l_count_124--;
                        }
                     }
                  }
                  if (StringFind(OrderComment(), "=2=", 0) == 0) {
                     if (OrderType() == OP_SELLSTOP) {
                        if (fDeletePendig(OrderTicket()) == 0) {
                           li_56 = FALSE;
                           l_count_124--;
                        }
                     }
                  }
               }
            } else return (0);
         }
      }
   }
   if (li_28) {
      if (li_40 || li_48) {
         for (l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
            if (OrderSelect(l_pos_4, SELECT_BY_POS, MODE_TRADES)) {
               if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic_N) {
                  if (StringFind(OrderComment(), "=1=", 0) == 0) {
                     if (OrderType() == OP_SELLLIMIT) {
                        if (fDeletePendig(OrderTicket()) == 0) {
                           li_40 = FALSE;
                           l_count_124--;
                        }
                     }
                  }
                  if (StringFind(OrderComment(), "=2=", 0) == 0) {
                     if (OrderType() == OP_BUYSTOP) {
                        if (fDeletePendig(OrderTicket()) == 0) {
                           li_48 = FALSE;
                           l_count_124--;
                        }
                     }
                  }
               }
            } else return (0);
         }
      }
   }
   if (l_count_124 == 1) {
      for (l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
         if (OrderSelect(l_pos_4, SELECT_BY_POS, MODE_TRADES)) {
            if (!(OrderSymbol() == Symbol() && OrderMagicNumber() == Magic_N)) continue;
            if (OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP || OrderType() == OP_BUYLIMIT || OrderType() == OP_SELLLIMIT) fDeletePendig(OrderTicket());
            if (!(OrderType() == OP_BUY || OrderType() == OP_SELL)) continue;
            if (StringFind(OrderComment(), "=", 0) != 0) continue;
            li_128 = StringFind(OrderComment(), "=", 1);
            l_str2int_132 = StrToInteger(StringSubstr(OrderComment(), 1, li_128 - 1));
            if (l_str2int_132 >= OrdersCount || l_str2int_132 >= 10) break;
            li_136 = l_str2int_132 + 1;
            ld_140 = 0;
            switch (li_136) {
            case 3:
               ld_140 = Ord_3_Lots;
               ls_148 = "=3=";
               break;
            case 4:
               ld_140 = Ord_4_Lots;
               ls_148 = "=4=";
               break;
            case 5:
               ld_140 = Ord_5_Lots;
               ls_148 = "=5=";
               break;
            case 6:
               ld_140 = Ord_6_Lots;
               ls_148 = "=6=";
               break;
            case 7:
               ld_140 = Ord_7_Lots;
               ls_148 = "=7=";
               break;
            case 8:
               ld_140 = Ord_8_Lots;
               ls_148 = "=8=";
               break;
            case 9:
               ld_140 = Ord_9_Lots;
               ls_148 = "=9=";
               break;
            case 10:
               ld_140 = Ord_10_Lots;
               ls_148 = "=10=";
            }
            if (OrderType() == OP_BUY) {
               ld_160 = ND(OrderStopLoss() + (Ask - Bid));
               ld_168 = ND(OrderStopLoss() - Point * Level);
               ld_176 = ND(OrderStopLoss() + Point * Level);
               fOrderSetBuyLimit(ld_140, ld_160, ld_168, ld_176, ls_148);
               break;
            }
            if (OrderType() != OP_SELL) continue;
            ld_160 = ND(OrderStopLoss() - (Ask - Bid));
            ld_168 = ND(OrderStopLoss() + Point * Level);
            ld_176 = ND(OrderStopLoss() - Point * Level);
            fOrderSetSellLimit(ld_140, ld_160, ld_168, ld_176, ls_148);
            break;
         }
         return (0);
      }
   }
   if (Send_Email || Show_Alerts) OrderEvents();
   return (0);
}

int fDeletePendig(int a_ticket_0) {
   if (!IsTradeContextBusy()) {
      if (!OrderDelete(a_ticket_0)) {
         Print("Error del pending " + a_ticket_0 + ". " + fMyErDesc(GetLastError()));
         return (-1);
      }
   } else {
      if (TimeCurrent() > g_datetime_232 + 20) {
         g_datetime_232 = TimeCurrent();
         Print("Need del pending " + a_ticket_0 + ". Trade Context Busy");
      }
      return (-2);
   }
   return (0);
}

double ND(double ad_0) {
   return (NormalizeDouble(ad_0, Digits));
}

double fGetLotsSimple(int a_cmd_0, double ad_4) {
   if (AccountFreeMarginCheck(Symbol(), a_cmd_0, ad_4) <= 0.0) return (-1);
   if (GetLastError() == 134/* NOT_ENOUGH_MONEY */) return (-2);
   return (ad_4);
}

string fMyErDesc(int ai_0) {
   string ls_4 = "Err Num: " + ai_0 + " - ";
   switch (ai_0) {
   case 0:
      return (ls_4 + "NO ERROR");
   case 1:
      return (ls_4 + "NO RESULT");
   case 2:
      return (ls_4 + "COMMON ERROR");
   case 3:
      return (ls_4 + "INVALID TRADE PARAMETERS");
   case 4:
      return (ls_4 + "SERVER BUSY");
   case 5:
      return (ls_4 + "OLD VERSION");
   case 6:
      return (ls_4 + "NO CONNECTION");
   case 7:
      return (ls_4 + "NOT ENOUGH RIGHTS");
   case 8:
      return (ls_4 + "TOO FREQUENT REQUESTS");
   case 9:
      return (ls_4 + "MALFUNCTIONAL TRADE");
   case 64:
      return (ls_4 + "ACCOUNT DISABLED");
   case 65:
      return (ls_4 + "INVALID ACCOUNT");
   case 128:
      return (ls_4 + "TRADE TIMEOUT");
   case 129:
      return (ls_4 + "INVALID PRICE");
   case 130:
      return (ls_4 + "INVALID STOPS");
   case 131:
      return (ls_4 + "INVALID TRADE VOLUME");
   case 132:
      return (ls_4 + "MARKET CLOSED");
   case 133:
      return (ls_4 + "TRADE DISABLED");
   case 134:
      return (ls_4 + "NOT ENOUGH MONEY");
   case 135:
      return (ls_4 + "PRICE CHANGED");
   case 136:
      return (ls_4 + "OFF QUOTES");
   case 137:
      return (ls_4 + "BROKER BUSY");
   case 138:
      return (ls_4 + "REQUOTE");
   case 139:
      return (ls_4 + "ORDER LOCKED");
   case 140:
      return (ls_4 + "LONG POSITIONS ONLY ALLOWED");
   case 141:
      return (ls_4 + "TOO MANY REQUESTS");
   case 145:
      return (ls_4 + "TRADE MODIFY DENIED");
   case 146:
      return (ls_4 + "TRADE CONTEXT BUSY");
   case 147:
      return (ls_4 + "TRADE EXPIRATION DENIED");
   case 148:
      return (ls_4 + "TRADE TOO MANY ORDERS");
   case 4000:
      return (ls_4 + "NO MQLERROR");
   case 4001:
      return (ls_4 + "WRONG FUNCTION POINTER");
   case 4002:
      return (ls_4 + "ARRAY INDEX OUT OF RANGE");
   case 4003:
      return (ls_4 + "NO MEMORY FOR FUNCTION CALL STACK");
   case 4004:
      return (ls_4 + "RECURSIVE STACK OVERFLOW");
   case 4005:
      return (ls_4 + "NOT ENOUGH STACK FOR PARAMETER");
   case 4006:
      return (ls_4 + "NO MEMORY FOR PARAMETER STRING");
   case 4007:
      return (ls_4 + "NO MEMORY FOR TEMP STRING");
   case 4008:
      return (ls_4 + "NOT INITIALIZED STRING");
   case 4009:
      return (ls_4 + "NOT INITIALIZED ARRAYSTRING");
   case 4010:
      return (ls_4 + "NO MEMORY FOR ARRAYSTRING");
   case 4011:
      return (ls_4 + "TOO LONG STRING");
   case 4012:
      return (ls_4 + "REMAINDER FROM ZERO DIVIDE");
   case 4013:
      return (ls_4 + "ZERO DIVIDE");
   case 4014:
      return (ls_4 + "UNKNOWN COMMAND");
   case 4015:
      return (ls_4 + "WRONG JUMP");
   case 4016:
      return (ls_4 + "NOT INITIALIZED ARRAY");
   case 4017:
      return (ls_4 + "DLL CALLS NOT ALLOWED");
   case 4018:
      return (ls_4 + "CANNOT LOAD LIBRARY");
   case 4019:
      return (ls_4 + "CANNOT CALL FUNCTION");
   case 4020:
      return (ls_4 + "EXTERNAL EXPERT CALLS NOT ALLOWED");
   case 4021:
      return (ls_4 + "NOT ENOUGH MEMORY FOR RETURNED STRING");
   case 4022:
      return (ls_4 + "SYSTEM BUSY");
   case 4050:
      return (ls_4 + "INVALID FUNCTION PARAMETERS COUNT");
   case 4051:
      return (ls_4 + "INVALID FUNCTION PARAMETER VALUE");
   case 4052:
      return (ls_4 + "STRING FUNCTION INTERNAL ERROR");
   case 4053:
      return (ls_4 + "SOME ARRAY ERROR");
   case 4054:
      return (ls_4 + "INCORRECT SERIES ARRAY USING");
   case 4055:
      return (ls_4 + "CUSTOM INDICATOR ERROR");
   case 4056:
      return (ls_4 + "INCOMPATIBLE ARRAYS");
   case 4057:
      return (ls_4 + "GLOBAL VARIABLES PROCESSING ERROR");
   case 4058:
      return (ls_4 + "GLOBAL VARIABLE NOT FOUND");
   case 4059:
      return (ls_4 + "FUNCTION NOT ALLOWED IN TESTING MODE");
   case 4060:
      return (ls_4 + "FUNCTION NOT CONFIRMED");
   case 4061:
      return (ls_4 + "SEND MAIL ERROR");
   case 4062:
      return (ls_4 + "STRING PARAMETER EXPECTED");
   case 4063:
      return (ls_4 + "INTEGER PARAMETER EXPECTED");
   case 4064:
      return (ls_4 + "DOUBLE PARAMETER EXPECTED");
   case 4065:
      return (ls_4 + "ARRAY AS PARAMETER EXPECTED");
   case 4066:
      return (ls_4 + "HISTORY WILL UPDATED");
   case 4067:
      return (ls_4 + "TRADE ERROR");
   case 4099:
      return (ls_4 + "END OF FILE");
   case 4100:
      return (ls_4 + "SOME FILE ERROR");
   case 4101:
      return (ls_4 + "WRONG FILE NAME");
   case 4102:
      return (ls_4 + "TOO MANY OPENED FILES");
   case 4103:
      return (ls_4 + "CANNOT OPEN FILE");
   case 4104:
      return (ls_4 + "INCOMPATIBLE ACCESS TO FILE");
   case 4105:
      return (ls_4 + "NO ORDER SELECTED");
   case 4106:
      return (ls_4 + "UNKNOWN SYMBOL");
   case 4107:
      return (ls_4 + "INVALID PRICE PARAM");
   case 4108:
      return (ls_4 + "INVALID TICKET");
   case 4109:
      return (ls_4 + "TRADE NOT ALLOWED");
   case 4110:
      return (ls_4 + "LONGS  NOT ALLOWED");
   case 4111:
      return (ls_4 + "SHORTS NOT ALLOWED");
   case 4200:
      return (ls_4 + "OBJECT ALREADY EXISTS");
   case 4201:
      return (ls_4 + "UNKNOWN OBJECT PROPERTY");
   case 4202:
      return (ls_4 + "OBJECT DOES NOT EXIST");
   case 4203:
      return (ls_4 + "UNKNOWN OBJECT TYPE");
   case 4204:
      return (ls_4 + "NO OBJECT NAME");
   case 4205:
      return (ls_4 + "OBJECT COORDINATES ERROR");
   case 4206:
      return (ls_4 + "NO SPECIFIED SUBWINDOW");
   case 4207:
      return (ls_4 + "SOME OBJECT ERROR");
   }
   return (ls_4 + "WRONG ERR NUM");
}

int fOrderSetBuyLimit(double a_lots_0, double a_price_8, double a_price_16, double a_price_24, string a_comment_32) {
   int l_ticket_40;
   RefreshRates();
   a_lots_0 = fGetLotsSimple(OP_BUY, a_lots_0);
   if (a_lots_0 > 0.0) {
      if (!IsTradeContextBusy()) {
         l_ticket_40 = OrderSend(Symbol(), OP_BUYLIMIT, a_lots_0, a_price_8, 0, a_price_16, a_price_24, a_comment_32, Magic_N, 0, CLR_NONE);
         if (l_ticket_40 > 0) return (l_ticket_40);
         Print("Error set BUYLIMIT. " + fMyErDesc(GetLastError()));
         return (-1);
      }
      if (g_datetime_236 != iTime(NULL, 0, 0)) {
         g_datetime_236 = iTime(NULL, 0, 0);
         Print("Need set buylimit. Trade Context Busy");
      }
      return (-2);
   }
   if (g_datetime_240 != iTime(NULL, 0, 0)) {
      g_datetime_240 = iTime(NULL, 0, 0);
      if (a_lots_0 == -1.0) Print("Need set buylimit. No money");
      if (a_lots_0 == -2.0) Print("Need set buylimit. Wrong lots size");
   }
   return (-3);
}

int fOrderSetBuyStop(double a_lots_0, double a_price_8, double a_price_16, double a_price_24, string a_comment_32) {
   int l_ticket_40;
   RefreshRates();
   a_lots_0 = fGetLotsSimple(OP_BUY, a_lots_0);
   if (a_lots_0 > 0.0) {
      if (!IsTradeContextBusy()) {
         l_ticket_40 = OrderSend(Symbol(), OP_BUYSTOP, a_lots_0, a_price_8, 0, a_price_16, a_price_24, a_comment_32, Magic_N, 0, CLR_NONE);
         if (l_ticket_40 > 0) return (l_ticket_40);
         Print("Error set BUYSTOP. " + fMyErDesc(GetLastError()));
         return (-1);
      }
      if (g_datetime_244 != iTime(NULL, 0, 0)) {
         g_datetime_244 = iTime(NULL, 0, 0);
         Print("Need set buystop. Trade Context Busy");
      }
      return (-2);
   }
   if (g_datetime_248 != iTime(NULL, 0, 0)) {
      g_datetime_248 = iTime(NULL, 0, 0);
      if (a_lots_0 == -1.0) Print("Need set buystop. No money");
      if (a_lots_0 == -2.0) Print("Need set buystop. Wrong lots size");
   }
   return (-3);
}

int fOrderSetSellLimit(double a_lots_0, double a_price_8, double a_price_16, double a_price_24, string a_comment_32) {
   int l_ticket_40;
   RefreshRates();
   a_lots_0 = fGetLotsSimple(OP_SELL, a_lots_0);
   if (a_lots_0 > 0.0) {
      if (!IsTradeContextBusy()) {
         l_ticket_40 = OrderSend(Symbol(), OP_SELLLIMIT, a_lots_0, a_price_8, 0, a_price_16, a_price_24, a_comment_32, Magic_N, 0, CLR_NONE);
         if (l_ticket_40 > 0) return (l_ticket_40);
         Print("Error set SELLLIMIT. " + fMyErDesc(GetLastError()));
         return (-1);
      }
      if (g_datetime_252 != iTime(NULL, 0, 0)) {
         g_datetime_252 = iTime(NULL, 0, 0);
         Print("Need set selllimit. Trade Context Busy");
      }
      return (-2);
   }
   if (g_datetime_256 != iTime(NULL, 0, 0)) {
      g_datetime_256 = iTime(NULL, 0, 0);
      if (a_lots_0 == -1.0) Print("Need set selllimit. No money");
      if (a_lots_0 == -2.0) Print("Need set selllimit. Wrong lots size");
   }
   return (-3);
}

int fOrderSetSellStop(double a_lots_0, double a_price_8, double a_price_16, double a_price_24, string a_comment_32) {
   int l_ticket_40;
   RefreshRates();
   a_lots_0 = fGetLotsSimple(OP_SELL, a_lots_0);
   if (a_lots_0 > 0.0) {
      if (!IsTradeContextBusy()) {
         l_ticket_40 = OrderSend(Symbol(), OP_SELLSTOP, a_lots_0, a_price_8, 0, a_price_16, a_price_24, a_comment_32, Magic_N, 0, CLR_NONE);
         if (l_ticket_40 > 0) return (l_ticket_40);
         Print("Error set SELLSTOP. " + fMyErDesc(GetLastError()));
         return (-1);
      }
      if (g_datetime_260 != iTime(NULL, 0, 0)) {
         g_datetime_260 = iTime(NULL, 0, 0);
         Print("Need set sellstop. Trade Context Busy");
      }
      return (-2);
   }
   if (g_datetime_264 != iTime(NULL, 0, 0)) {
      g_datetime_264 = iTime(NULL, 0, 0);
      if (a_lots_0 == -1.0) Print("Need set sellstop. No money");
      if (a_lots_0 == -2.0) Print("Need set sellstop. Wrong lots size");
   }
   return (-3);
}

string DS2(double ad_0) {
   return (DoubleToStr(ad_0, 2));
}

string DS(double ad_0) {
   return (DoubleToStr(ad_0, Digits));
}

void OrderEvents() {
   int lia_40[];
   string lsa_44[];
   int lia_48[];
   double lda_52[];
   double lda_56[];
   double lda_60[];
   double lda_64[];
   int lia_68[];
   int lia_72[];
   bool li_80;
   bool li_84;
   bool li_92;
   bool li_0 = FALSE;
   bool li_4 = FALSE;
   bool li_8 = TRUE;
   bool li_12 = TRUE;
   bool li_16 = TRUE;
   bool li_20 = TRUE;
   bool li_24 = TRUE;
   bool li_28 = FALSE;
   bool li_32 = FALSE;
   bool li_36 = FALSE;
   ArrayResize(lia_40, 0);
   ArrayResize(lsa_44, 0);
   ArrayResize(lia_48, 0);
   ArrayResize(lda_52, 0);
   ArrayResize(lda_56, 0);
   ArrayResize(lda_60, 0);
   ArrayResize(lda_64, 0);
   ArrayResize(lia_68, 0);
   ArrayResize(lia_72, 0);
   for (int l_pos_76 = 0; l_pos_76 < OrdersTotal(); l_pos_76++) {
      if (!(OrderSelect(l_pos_76, SELECT_BY_POS, MODE_TRADES))) return;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic_N) {
         ArrayResize(lia_40, ArraySize(lia_40) + 1);
         ArrayResize(lsa_44, ArraySize(lsa_44) + 1);
         ArrayResize(lia_48, ArraySize(lia_48) + 1);
         ArrayResize(lda_52, ArraySize(lda_52) + 1);
         ArrayResize(lda_56, ArraySize(lda_56) + 1);
         ArrayResize(lda_60, ArraySize(lda_60) + 1);
         ArrayResize(lda_64, ArraySize(lda_64) + 1);
         ArrayResize(lia_68, ArraySize(lia_68) + 1);
         ArrayResize(lia_72, ArraySize(lia_72) + 1);
         lia_40[ArraySize(lia_40) - 1] = OrderTicket();
         lsa_44[ArraySize(lsa_44) - 1] = OrderSymbol();
         lia_48[ArraySize(lia_48) - 1] = OrderType();
         lda_52[ArraySize(lda_52) - 1] = ND(OrderOpenPrice());
         lda_56[ArraySize(lda_56) - 1] = ND(OrderStopLoss());
         lda_60[ArraySize(lda_60) - 1] = ND(OrderTakeProfit());
         lda_64[ArraySize(lda_64) - 1] = OrderLots();
         lia_68[ArraySize(lia_68) - 1] = ND(OrderOpenTime());
         lia_72[ArraySize(lia_72) - 1] = ND(OrderCloseTime());
      }
   }
   if (gi_268) {
      for (l_pos_76 = 0; l_pos_76 < ArraySize(lia_40); l_pos_76++) {
         li_84 = TRUE;
         for (int l_index_88 = 0; l_index_88 < ArraySize(gia_272); l_index_88++) {
            if (lia_40[l_pos_76] == gia_272[l_index_88]) {
               li_84 = FALSE;
               if (lia_48[l_pos_76] != gia_280[l_index_88]) {
                  if (lia_48[l_pos_76] == 0) {
                     if (gia_280[l_index_88] == 2) {
                        if (li_24) {
                           if (Show_Alerts) {
                              Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "BUYLIMIT " + gia_272[l_index_88] + " -> BUY (L:: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) +
                                 ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                           }
                           if (Send_Email) {
                              SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "BUYLIMIT " + gia_272[l_index_88] + " -> BUY (L:: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) +
                                 ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                           }
                        }
                     }
                     if (gia_280[l_index_88] == 4) {
                        if (li_24) {
                           if (Show_Alerts) {
                              Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "BUYSTOP " + gia_272[l_index_88] + " -> BUY (L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) +
                                 ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                           }
                           if (Send_Email) {
                              SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "BUYSTOP " + gia_272[l_index_88] + " -> BUY (L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) +
                                 ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                           }
                        }
                     }
                  }
                  if (lia_48[l_pos_76] == 1) {
                     if (gia_280[l_index_88] == 3) {
                        if (li_24) {
                           if (Show_Alerts) {
                              Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "SELLLIMIT " + gia_272[l_index_88] + " -> SELL (L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) +
                                 ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                           }
                           if (Send_Email) {
                              SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "SELLLIMIT " + gia_272[l_index_88] + " -> SELL (L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) +
                                 ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                           }
                        }
                     }
                     if (gia_280[l_index_88] == 5) {
                        if (li_24) {
                           if (Show_Alerts) {
                              Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "SELLSTOP " + gia_272[l_index_88] + " -> SELL (L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) +
                                 ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                           }
                           if (Send_Email) {
                              SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "SELLSTOP " + gia_272[l_index_88] + " -> SELL (L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) +
                                 ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                           }
                        }
                     }
                  }
               }
               if (lda_52[l_pos_76] != gda_284[l_index_88] || lda_56[l_pos_76] != gda_288[l_index_88] || lda_60[l_pos_76] != gda_292[l_index_88]) {
                  if (lia_48[l_pos_76] == 0) {
                     li_80 = FALSE;
                     if (lda_56[l_pos_76] >= lda_52[l_pos_76] && !(gda_288[l_index_88] >= gda_284[l_index_88]) || gda_288[l_index_88] == 0.0) {
                        if (li_32) {
                           if (Show_Alerts) {
                              Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "BUY " + gia_272[l_index_88] + " modified to BreakEven (L: " + DS2(gda_296[l_index_88]) + ", P: " + DS(gda_284[l_index_88]) +
                                 ", SL: " + DS(gda_288[l_index_88]) + ", TP: " + DS(gda_292[l_index_88]) + " -> L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) + ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                           }
                           if (Send_Email) {
                              SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "BUY " + gia_272[l_index_88] + " modified to BreakEven (L: " + DS2(gda_296[l_index_88]) + ", P: " + DS(gda_284[l_index_88]) +
                                 ", SL: " + DS(gda_288[l_index_88]) + ", TP: " + DS(gda_292[l_index_88]) + " -> L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) + ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                           }
                           li_80 = TRUE;
                        }
                     }
                     if (li_28 && !li_80) {
                        if (Show_Alerts) {
                           Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "BUY " + gia_272[l_index_88] + " modified (L: " + DS2(gda_296[l_index_88]) + ", P: " + DS(gda_284[l_index_88]) +
                              ", SL: " + DS(gda_288[l_index_88]) + ", TP: " + DS(gda_292[l_index_88]) + " -> L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) + ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                        }
                        if (Send_Email) {
                           SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "BUY " + gia_272[l_index_88] + " modified (L: " + DS2(gda_296[l_index_88]) + ", P: " + DS(gda_284[l_index_88]) +
                              ", SL: " + DS(gda_288[l_index_88]) + ", TP: " + DS(gda_292[l_index_88]) + " -> L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) + ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                        }
                     }
                  }
                  if (lia_48[l_pos_76] == 1) {
                     li_80 = FALSE;
                     if (lda_56[l_pos_76] <= lda_52[l_pos_76] && lda_56[l_pos_76] != 0.0 && !(gda_288[l_index_88] <= gda_284[l_index_88]) || gda_288[l_index_88] == 0.0) {
                        if (li_32) {
                           if (Show_Alerts) {
                              Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "SELL " + gia_272[l_index_88] + " modified to BreakEven (L: " + DS2(gda_296[l_index_88]) + ", P: " +
                                 DS(gda_284[l_index_88]) + ", SL: " + DS(gda_288[l_index_88]) + ", TP: " + DS(gda_292[l_index_88]) + " -> L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) + ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                           }
                           if (Send_Email) {
                              SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "SELL " + gia_272[l_index_88] + " modified to BreakEven (L: " + DS2(gda_296[l_index_88]) + ", P: " +
                                 DS(gda_284[l_index_88]) + ", SL: " + DS(gda_288[l_index_88]) + ", TP: " + DS(gda_292[l_index_88]) + " -> L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) + ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                           }
                           li_80 = TRUE;
                        }
                     }
                     if (li_28 && !li_80) {
                        if (Show_Alerts) {
                           Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "SELL " + gia_272[l_index_88] + " modified (L: " + DS2(gda_296[l_index_88]) + ", P: " + DS(gda_284[l_index_88]) +
                              ", SL: " + DS(gda_288[l_index_88]) + ", TP: " + DS(gda_292[l_index_88]) + " -> L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) + ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                        }
                        if (Send_Email) {
                           SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "SELL " + gia_272[l_index_88] + " modified (L: " + DS2(gda_296[l_index_88]) + ", P: " + DS(gda_284[l_index_88]) +
                              ", SL: " + DS(gda_288[l_index_88]) + ", TP: " + DS(gda_292[l_index_88]) + " -> L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) + ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                        }
                     }
                  }
                  if (lia_48[l_pos_76] == 4) {
                     if (li_36) {
                        if (Show_Alerts) {
                           Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "BUYSTOP " + gia_272[l_index_88] + " modified (L: " + DS2(gda_296[l_index_88]) + ", P: " + DS(gda_284[l_index_88]) +
                              ", SL: " + DS(gda_288[l_index_88]) + ", TP: " + DS(gda_292[l_index_88]) + " -> L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) + ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                        }
                        if (Send_Email) {
                           SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "BUYSTOP " + gia_272[l_index_88] + " modified (L: " + DS2(gda_296[l_index_88]) + ", P: " + DS(gda_284[l_index_88]) +
                              ", SL: " + DS(gda_288[l_index_88]) + ", TP: " + DS(gda_292[l_index_88]) + " -> L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) + ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                        }
                     }
                  }
                  if (lia_48[l_pos_76] == 5) {
                     if (li_36) {
                        if (Show_Alerts) {
                           Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "SELLSTOP " + gia_272[l_index_88] + " modified (L: " + DS2(gda_296[l_index_88]) + ", P: " + DS(gda_284[l_index_88]) +
                              ", SL: " + DS(gda_288[l_index_88]) + ", TP: " + DS(gda_292[l_index_88]) + " -> L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) + ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                        }
                        if (Send_Email) {
                           SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "SELLSTOP " + gia_272[l_index_88] + " modified (L: " + DS2(gda_296[l_index_88]) + ", P: " + DS(gda_284[l_index_88]) +
                              ", SL: " + DS(gda_288[l_index_88]) + ", TP: " + DS(gda_292[l_index_88]) + " -> L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) + ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                        }
                     }
                  }
                  if (lia_48[l_pos_76] == 2) {
                     if (li_36) {
                        if (Show_Alerts) {
                           Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "BUYLIMIT " + gia_272[l_index_88] + " modified (L: " + DS2(gda_296[l_index_88]) + ", P: " + DS(gda_284[l_index_88]) +
                              ", SL: " + DS(gda_288[l_index_88]) + ", TP: " + DS(gda_292[l_index_88]) + " -> L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) + ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                        }
                        if (Send_Email) {
                           SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "BUYLIMIT " + gia_272[l_index_88] + " modified (L: " + DS2(gda_296[l_index_88]) + ", P: " + DS(gda_284[l_index_88]) +
                              ", SL: " + DS(gda_288[l_index_88]) + ", TP: " + DS(gda_292[l_index_88]) + " -> L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) + ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                        }
                     }
                  }
                  if (lia_48[l_pos_76] == 3) {
                     if (li_36) {
                        if (Show_Alerts) {
                           Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "SELLLIMIT " + gia_272[l_index_88] + " modified (L: " + DS2(gda_296[l_index_88]) + ", P: " + DS(gda_284[l_index_88]) +
                              ", SL: " + DS(gda_288[l_index_88]) + ", TP: " + DS(gda_292[l_index_88]) + " -> L: " + DS(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) + ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                        }
                        if (Send_Email) {
                           SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "SELLLIMIT " + gia_272[l_index_88] + " modified (L: " + DS2(gda_296[l_index_88]) + ", P: " + DS(gda_284[l_index_88]) +
                              ", SL: " + DS(gda_288[l_index_88]) + ", TP: " + DS(gda_292[l_index_88]) + " -> L: " + DS(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) + ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                        }
                     }
                  }
               }
            }
         }
         if (li_84) {
            if (lia_48[l_pos_76] == 0) {
               if (li_0) {
                  if (Show_Alerts) {
                     Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "BUY " + lia_40[l_pos_76] + " opened (L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) +
                        ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                  }
                  if (Send_Email) {
                     SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "BUY " + lia_40[l_pos_76] + " opened (L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) +
                        ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                  }
               }
            }
            if (lia_48[l_pos_76] == 1) {
               if (li_0) {
                  if (Show_Alerts) {
                     Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "SELL " + lia_40[l_pos_76] + " opened (L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) +
                        ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                  }
                  if (Send_Email) {
                     SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "SELL " + lia_40[l_pos_76] + " opened (L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) +
                        ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                  }
               }
            }
            if (lia_48[l_pos_76] == 4) {
               if (li_16) {
                  if (Show_Alerts) {
                     Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "BUYSTOP " + lia_40[l_pos_76] + " placed (L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) +
                        ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                  }
                  if (Send_Email) {
                     SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "BUYSTOP " + lia_40[l_pos_76] + " placed (L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) +
                        ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                  }
               }
            }
            if (lia_48[l_pos_76] == 5) {
               if (li_16) {
                  if (Show_Alerts) {
                     Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "SELLSTOP " + lia_40[l_pos_76] + " placed (L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) +
                        ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                  }
                  if (Send_Email) {
                     SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "SELLSTOP " + lia_40[l_pos_76] + " placed (L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) +
                        ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                  }
               }
            }
            if (lia_48[l_pos_76] == 2) {
               if (li_16) {
                  if (Show_Alerts) {
                     Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "BUYLIMIT " + lia_40[l_pos_76] + " placed (L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) +
                        ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                  }
                  if (Send_Email) {
                     SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "BUYLIMIT " + lia_40[l_pos_76] + " placed (L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) +
                        ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                  }
               }
            }
            if (lia_48[l_pos_76] == 3) {
               if (li_16) {
                  if (Show_Alerts) {
                     Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "SELLLIMIT " + lia_40[l_pos_76] + " placed (L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) +
                        ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                  }
                  if (Send_Email) {
                     SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "SELLLIMIT " + lia_40[l_pos_76] + " placed (L: " + DS2(lda_64[l_pos_76]) + ", P: " + DS(lda_52[l_pos_76]) +
                        ", SL: " + DS(lda_56[l_pos_76]) + ", TP: " + DS(lda_60[l_pos_76]) + ")");
                  }
               }
            }
         }
      }
      for (l_pos_76 = 0; l_pos_76 < ArraySize(gia_272); l_pos_76++) {
         li_92 = FALSE;
         for (l_index_88 = 0; l_index_88 < ArraySize(lia_40); l_index_88++)
            if (gia_272[l_pos_76] == lia_40[l_index_88]) li_92 = TRUE;
         if (!li_92) {
            if (gia_280[l_pos_76] == 0) {
               if (OrderSelect(gia_272[l_pos_76], SELECT_BY_TICKET)) {
                  if (ND(OrderClosePrice()) >= ND(OrderTakeProfit()) && ND(OrderTakeProfit()) != 0.0) {
                     if (li_12) {
                        if (Show_Alerts) Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "BUY " + gia_272[l_pos_76] + " closed by TakeProfit ($" + DS2(OrderProfit()) + ")");
                        if (Send_Email) SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "BUY " + gia_272[l_pos_76] + " closed by TakeProfit ($" + DS2(OrderProfit()) + ")");
                     }
                  } else {
                     if (ND(OrderClosePrice()) <= ND(OrderStopLoss()) && ND(OrderStopLoss()) != 0.0) {
                        if (li_8) {
                           if (Show_Alerts) Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "BUY " + gia_272[l_pos_76] + " closed by StopLoss ($" + DS2(OrderProfit()) + ")");
                           if (Send_Email) SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "BUY " + gia_272[l_pos_76] + " closed by StopLoss ($" + DS2(OrderProfit()) + ")");
                        }
                     } else {
                        if (li_4) {
                           if (Show_Alerts) Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "BUY " + gia_272[l_pos_76] + " closed at " + DS(OrderClosePrice()) + " ($" + DS2(OrderProfit()) + ")");
                           if (Send_Email) SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "BUY " + gia_272[l_pos_76] + " closed at " + DS(OrderClosePrice()) + " ($" + DS2(OrderProfit()) + ")");
                        }
                     }
                  }
               } else {
                  if (li_12 || li_8 || li_4) {
                     if (Show_Alerts) Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "BUY " + gia_272[l_pos_76] + " closed (undefined method)");
                     if (Send_Email) SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "BUY " + gia_272[l_pos_76] + " closed (undefined method)");
                  }
               }
            }
            if (gia_280[l_pos_76] == 1) {
               if (OrderSelect(gia_272[l_pos_76], SELECT_BY_TICKET)) {
                  if (ND(OrderClosePrice()) <= ND(OrderTakeProfit()) && ND(OrderTakeProfit()) != 0.0) {
                     if (li_12) {
                        if (Show_Alerts) Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "SELL " + gia_272[l_pos_76] + " closed by TakeProfit ($" + DS2(OrderProfit()) + ")");
                        if (Send_Email) SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "SELL " + gia_272[l_pos_76] + " closed by TakeProfit ($" + DS2(OrderProfit()) + ")");
                     }
                  } else {
                     if (ND(OrderClosePrice()) >= ND(OrderStopLoss()) && ND(OrderStopLoss()) != 0.0) {
                        if (li_8) {
                           if (Show_Alerts) Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "SELL " + gia_272[l_pos_76] + " closed by StopLoss ($" + DS2(OrderProfit()) + ")");
                           if (Send_Email) SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "SELL " + gia_272[l_pos_76] + " closed by StopLoss ($" + DS2(OrderProfit()) + ")");
                        }
                     } else {
                        if (li_4) {
                           if (Show_Alerts) Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "BUY " + gia_272[l_pos_76] + " closed at " + DS(OrderClosePrice()) + " ($" + DS2(OrderProfit()) + ")");
                           if (Send_Email) SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "BUY " + gia_272[l_pos_76] + " closed at " + DS(OrderClosePrice()) + " ($" + DS2(OrderProfit()) + ")");
                        }
                     }
                  }
               } else {
                  if (li_12 || li_8 || li_4) {
                     if (Show_Alerts) Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "SELL " + gia_272[l_pos_76] + " closed (undefined method)");
                     if (Send_Email) SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "SELL " + gia_272[l_pos_76] + " closed (undefined method)");
                  }
               }
            }
            if (gia_280[l_pos_76] == 4) {
               if (li_20) {
                  if (Show_Alerts) Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "BUYSTOP " + gia_272[l_pos_76] + " deleted");
                  if (Send_Email) SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "BUYSTOP " + gia_272[l_pos_76] + " deleted");
               }
            }
            if (gia_280[l_pos_76] == 5) {
               if (li_20) {
                  if (Show_Alerts) Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "SELLSTOP " + gia_272[l_pos_76] + " deleted");
                  if (Send_Email) SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "SELLSTOP " + gia_272[l_pos_76] + " deleted");
               }
            }
            if (gia_280[l_pos_76] == 2) {
               if (li_20) {
                  if (Show_Alerts) Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "BUYLIMIT " + gia_272[l_pos_76] + " deleted");
                  if (Send_Email) SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "BUYLIMIT " + gia_272[l_pos_76] + " deleted");
               }
            }
            if (gia_280[l_pos_76] == 3) {
               if (li_20) {
                  if (Show_Alerts) Alert(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + "): " + "SELLLIMIT " + gia_272[l_pos_76] + " deleted");
                  if (Send_Email) SendMail(gs_208 + "(" + Symbol() + ",Magic=" + Magic_N + ")", "SELLLIMIT " + gia_272[l_pos_76] + " deleted");
               }
            }
         }
      }
   }
   ArrayResize(gia_272, ArraySize(lia_40));
   ArrayResize(gsa_276, ArraySize(lsa_44));
   ArrayResize(gia_280, ArraySize(lia_48));
   ArrayResize(gda_284, ArraySize(lda_52));
   ArrayResize(gda_288, ArraySize(lda_56));
   ArrayResize(gda_292, ArraySize(lda_60));
   ArrayResize(gda_296, ArraySize(lda_64));
   ArrayResize(gia_300, ArraySize(lia_68));
   ArrayResize(gia_304, ArraySize(lia_72));
   if (ArraySize(lia_40) > 0) {
      ArrayCopy(gia_272, lia_40, 0, 0, ArraySize(lia_40));
      ArrayCopy(gsa_276, lsa_44, 0, 0, ArraySize(lsa_44));
      ArrayCopy(gia_280, lia_48, 0, 0, ArraySize(lia_48));
      ArrayCopy(gda_284, lda_52, 0, 0, ArraySize(lda_52));
      ArrayCopy(gda_288, lda_56, 0, 0, ArraySize(lda_56));
      ArrayCopy(gda_292, lda_60, 0, 0, ArraySize(lda_60));
      ArrayCopy(gda_296, lda_64, 0, 0, ArraySize(lda_64));
      ArrayCopy(gia_300, lia_68, 0, 0, ArraySize(lia_68));
      ArrayCopy(gia_304, lia_72, 0, 0, ArraySize(lia_72));
   }
   gi_268 = TRUE;
}

void AccountAndSymbolLbls() {
   string lsa_192[13];
   string ls_0 = Symbol();
   string ls_8 = MarketType(ls_0);
   string ls_16 = AccountCurrency();
   string ls_24 = ls_0;
   if (ls_8 == "Forex") ls_24 = StringSubstr(ls_0, 0, 3);
   double l_free_magrin_32 = AccountFreeMargin();
   double l_lotsize_40 = MarketInfo(ls_0, MODE_LOTSIZE);
   double ld_48 = 0;
   double ld_56 = 0;
   double ld_64 = 0;
   double l_ask_72 = MarketInfo(ls_0, MODE_ASK);
   double l_bid_80 = MarketInfo(ls_0, MODE_BID);
   if (ls_8 == "Forex") {
      if (ls_24 == ls_16) {
         l_ask_72 = 1;
         l_bid_80 = 1;
      } else {
         l_ask_72 = MarketInfo(ls_24 + ls_16, MODE_ASK);
         l_bid_80 = MarketInfo(ls_24 + ls_16, MODE_BID);
      }
   }
   double l_leverage_88 = 0;
   if (ls_8 == "Forex") l_leverage_88 = AccountLeverage();
   if (ls_8 == "Metalls") l_leverage_88 = 10;
   if (ls_8 == "CFD") l_leverage_88 = 10;
   if (l_leverage_88 > 0.0) ld_48 = l_lotsize_40 / l_leverage_88;
   ld_56 = ld_48 * l_ask_72;
   ld_64 = ld_48 * l_bid_80;
   if (ls_8 == "Futures") {
      ld_48 = FuturesLotMargin(ls_0);
      ld_56 = ld_48;
      ld_64 = ld_48;
   }
   string ls_96 = DoubleToStr(ld_56, 2) + " " + ls_16;
   string ls_104 = DoubleToStr(ld_64, 2) + " " + ls_16;
   if (ls_8 == "Forex" && ls_24 != ls_16) {
      ls_96 = ls_96 + " (" + DoubleToStr(ld_48, 2) + " " + ls_24 + ")";
      ls_104 = ls_104 + " (" + DoubleToStr(ld_48, 2) + " " + ls_24 + ")";
   }
   double ld_112 = 0;
   double ld_120 = 0;
   if (ld_56 > 0.0 && l_free_magrin_32 > 0.0) ld_112 = l_free_magrin_32 / ld_56;
   if (ld_64 > 0.0 && l_free_magrin_32 > 0.0) ld_120 = l_free_magrin_32 / ld_64;
   double l_minlot_128 = MarketInfo(ls_0, MODE_MINLOT);
   bool li_136 = FALSE;
   if (l_minlot_128 > 0.0) li_136 = ld_112 / l_minlot_128;
   bool li_140 = FALSE;
   if (l_minlot_128 > 0.0) li_140 = ld_120 / l_minlot_128;
   ld_112 = l_minlot_128 * li_136;
   ld_120 = l_minlot_128 * li_140;
   double l_tickvalue_144 = MarketInfo(ls_0, MODE_TICKVALUE);
   double ld_152 = 0;
   if (l_minlot_128 > 0.0) ld_152 = MarketInfo(ls_0, MODE_SWAPLONG) / l_minlot_128;
   double ld_160 = 0;
   if (l_minlot_128 > 0.0) ld_160 = MarketInfo(ls_0, MODE_SWAPSHORT) / l_minlot_128;
   double ld_168 = 0;
   if (l_tickvalue_144 > 0.0) ld_168 = ld_152 / l_tickvalue_144;
   double ld_176 = 0;
   if (l_tickvalue_144 > 0.0) ld_176 = ld_160 / l_tickvalue_144;
   string ls_184 = "Реал";
   if (IsDemo()) ls_184 = "Демо";
   lsa_192[0] = "Тип счета: " + ls_184;
   lsa_192[1] = "Номер счета: " + AccountNumber();
   lsa_192[2] = "Плечо: " + AccountLeverage();
   lsa_192[3] = "Баланс: " + DoubleToStr(AccountBalance(), 2) + " " + ls_16;
   lsa_192[4] = "Средства: " + DoubleToStr(AccountEquity(), 2) + " " + ls_16;
   lsa_192[5] = "Залог: " + DoubleToStr(AccountMargin(), 2) + " " + ls_16;
   lsa_192[6] = "Символ: " + ls_0;
   lsa_192[7] = "Свободно лотов для BUY : " + DoubleToStr(ld_112, 1);
   lsa_192[8] = "Свободно лотов для SELL: " + DoubleToStr(ld_120, 1);
   lsa_192[9] = "Залог за лот для BUY : " + ls_96;
   lsa_192[10] = "Залог за лот для SELL: " + ls_104;
   lsa_192[11] = "Спред: " + DoubleToStr(MarketInfo(ls_0, MODE_SPREAD), 0);
   lsa_192[12] = "Точность: " + DoubleToStr(MarketInfo(ls_0, MODE_DIGITS), 0);
   int li_196 = 4;
   int li_200 = 22;
   for (int l_index_204 = 0; l_index_204 < 13; l_index_204++) fObjLabel(gs_224 + l_index_204, li_196, li_200 + 10 * l_index_204, lsa_192[l_index_204], 0, InfoColor, 8, 0, "Arial", FALSE);
   ObjectsRedraw();
}

string MarketType(string as_0) {
   string ls_12;
   int l_str_len_8 = StringLen(as_0);
   if (StringSubstr(as_0, 0, 1) == "_") return ("Indexes");
   if (StringSubstr(as_0, 0, 1) == "#") {
      ls_12 = StringSubstr(as_0, l_str_len_8 - 1, 1);
      if (ls_12 == "0") return ("Futures");
      if (ls_12 == "1") return ("Futures");
      if (ls_12 == "2") return ("Futures");
      if (ls_12 == "3") return ("Futures");
      if (ls_12 == "4") return ("Futures");
      if (ls_12 == "5") return ("Futures");
      if (ls_12 == "6") return ("Futures");
      if (ls_12 == "7") return ("Futures");
      if (ls_12 == "8") return ("Futures");
      if (ls_12 == "9") return ("Futures");
      return ("CFD");
   }
   if (as_0 == "GOLD") return ("Metalls");
   if (as_0 == "SILVER") return ("Metalls");
   if (l_str_len_8 == 6) {
      ls_12 = StringSubstr(as_0, 0, 3);
      if (ls_12 == "AUD") return ("Forex");
      if (ls_12 == "CAD") return ("Forex");
      if (ls_12 == "CHF") return ("Forex");
      if (ls_12 == "EUR") return ("Forex");
      if (ls_12 == "GBP") return ("Forex");
      if (ls_12 == "LFX") return ("Forex");
      if (ls_12 == "NZD") return ("Forex");
      if (ls_12 == "SGD") return ("Forex");
      if (ls_12 == "USD") return ("Forex");
   }
   return ("");
}

double FuturesLotMargin(string as_0) {
   double ld_ret_8 = 0;
   string ls_16 = AccountCurrency();
   double l_bid_24 = 1;
   if (ls_16 != "USD") l_bid_24 = MarketInfo(ls_16 + "USD", MODE_BID);
   int l_str_len_32 = StringLen(as_0);
   string ls_36 = StringSubstr(as_0, 0, l_str_len_32 - 2);
   if (ls_36 == "#ENQ") ld_ret_8 = 3750.0 * l_bid_24;
   if (ls_36 == "#EP") ld_ret_8 = 3938.0 * l_bid_24;
   if (ls_36 == "#SLV") ld_ret_8 = 5063.0 * l_bid_24;
   if (ls_36 == "#GOLD") ld_ret_8 = 2363.0 * l_bid_24;
   if (ls_36 == "#CL") ld_ret_8 = 4725.0 * l_bid_24;
   if (ls_36 == "#NG") ld_ret_8 = 8100.0 * l_bid_24;
   if (ls_36 == "#W") ld_ret_8 = 608.0 * l_bid_24;
   if (ls_36 == "#S") ld_ret_8 = 1148.0 * l_bid_24;
   if (ls_36 == "#C") ld_ret_8 = 473.0 * l_bid_24;
   return (ld_ret_8);
}

void fObjDeleteByPrefix(string as_0) {
   for (int li_8 = ObjectsTotal() - 1; li_8 >= 0; li_8--)
      if (StringFind(ObjectName(li_8), as_0, 0) == 0) ObjectDelete(ObjectName(li_8));
}

void fObjLabel(string a_name_0, int a_x_8, int a_y_12, string a_text_16, int a_corner_24 = 0, color a_color_28 = 255, int a_fontsize_32 = 9, int a_window_36 = 0, string a_fontname_40 = "Arial", bool a_bool_48 = FALSE) {
   if (ObjectFind(a_name_0) != a_window_36) ObjectCreate(a_name_0, OBJ_LABEL, a_window_36, 0, 0);
   ObjectSet(a_name_0, OBJPROP_XDISTANCE, a_x_8);
   ObjectSet(a_name_0, OBJPROP_YDISTANCE, a_y_12);
   ObjectSetText(a_name_0, a_text_16, a_fontsize_32, a_fontname_40, a_color_28);
   ObjectSet(a_name_0, OBJPROP_BACK, a_bool_48);
   ObjectSet(a_name_0, OBJPROP_CORNER, a_corner_24);
}