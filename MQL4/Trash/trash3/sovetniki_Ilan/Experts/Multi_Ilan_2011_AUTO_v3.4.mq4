/*
   Generated by EX4-TO-MQ4 decompiler V4.0.224.1 []
   Website: http://purebeam.biz
   E-mail : purebeam@gmail.com
*/
#property copyright "Copyright � 2011, Mazur Gennady"
#property link      "mailto: gennady@mazuru.com"

extern bool ModeIndividual = FALSE;
extern double Lot = 0.01;
extern double KoefLots = 1.66;
extern double RiskProc = 0.3;
extern double TakeProfit0 = 60.0;
extern double TakeProfitN = 7.0;
extern double Shag = 25.0;
extern double Shag5 = 100.0;
extern double Shag6 = 120.0;
extern double Shag7 = 140.0;
extern double Shag8 = 150.0;
extern double Shag9 = 170.0;
extern double Shag10 = 200.0;
extern int MaxPozition = 8;
extern double UrovenR = 55.0;
extern double ProfTralProc = 70.0;
extern bool RejimTral = TRUE;
extern double ProfBUProc = 50.0;
extern bool RejimBU = TRUE;
extern bool RejimTrend = TRUE;
extern bool ProverHedg = TRUE;
extern bool Comments = TRUE;
extern int SdvigInfo = 0;
extern bool Alerts = FALSE;
extern int HourOp1Day = 2;
extern int HourCl5Day = 22;
extern int MaxNHedj = 5;
extern bool RejimDopProfit = FALSE;
extern double DopTral = 10.0;
extern int FrameInduk = 5;
extern string T1 = "--�������� ������ $ --";
extern string Para11 = "EURUSD";
extern string Para12 = "GBPUSD";
extern string Para13 = "AUDUSD";
extern string Para14 = "NZDUSD";
extern string Para15 = "EURGBP";
extern string Para16 = "EURCHF";
extern string T2 = "--�������� �� $ --";
extern string Para21 = "USDCAD";
extern string Para22 = "USDJPY";
extern string Para23 = "USDCHF";
int g_digits_348;
int gi_352;
double gd_356;
double gd_364;
double g_minlot_372;
int g_slippage_380;
int g_minute_384;
int g_hour_388;
int gi_392;
bool gi_396;
int g_index_400;
int g_index_404;
double gd_408;
double gd_416;
double g_ord_lots_424;
double g_ord_open_price_432;
double gd_440;
double gd_448;
string gs_460 = "";
double gd_468 = 0.0;
double gd_476 = 0.0;
double gd_484 = 0.0;
double gda_492[14];
double gda_496[14];
double gda_500[14];
double gda_504[14];
string g_var_name_508;
string gsa_516[9];
string g_var_name_520;
string gsa_528[9];
int gi_532;
double gd_536;

int init() {
   g_digits_348 = MarketInfo(Symbol(), MODE_DIGITS);
   if (g_digits_348 == 2 || g_digits_348 == 4) {
      gd_356 = 1.0 * Point;
      g_slippage_380 = 5;
      gd_364 = MarketInfo(Symbol(), MODE_STOPLEVEL);
      gd_416 = MarketInfo(Symbol(), MODE_TICKVALUE);
   } else {
      gd_356 = 10.0 * Point;
      g_slippage_380 = 50;
      gd_364 = MarketInfo(Symbol(), MODE_STOPLEVEL) / 10.0;
      gd_416 = 10.0 * MarketInfo(Symbol(), MODE_TICKVALUE);
   }
   g_minlot_372 = MarketInfo(Symbol(), MODE_MINLOT);
   switch (g_minlot_372) {
   case 0.01:
      g_digits_348 = 2;
      break;
   case 0.1:
      g_digits_348 = 1;
      break;
   case 1.0:
      g_digits_348 = 0;
      break;
   default:
      g_digits_348 = 1;
   }
   if (Lot < g_minlot_372 && Lot != 0.0) Lot = g_minlot_372;
   g_var_name_508 = "GP_" + Symbol();
   if (GlobalVariableCheck(g_var_name_508) == FALSE) GlobalVariableSet(g_var_name_508, 100);
   else GlobalVariableSet(g_var_name_508, 100);
   gsa_516[0] = "GP_" + Para11;
   gsa_516[1] = "GP_" + Para12;
   gsa_516[2] = "GP_" + Para13;
   gsa_516[3] = "GP_" + Para14;
   gsa_516[4] = "GP_" + Para15;
   gsa_516[5] = "GP_" + Para16;
   gsa_516[6] = "GP_" + Para21;
   gsa_516[7] = "GP_" + Para22;
   gsa_516[8] = "GP_" + Para23;
   if (Para11 == Symbol() || Para12 == Symbol() || Para13 == Symbol() || Para14 == Symbol() || Para15 == Symbol() || Para16 == Symbol()) gi_532 = 1;
   if (Para21 == Symbol() || Para22 == Symbol() || Para23 == Symbol()) gi_532 = -1;
   g_var_name_520 = "No_" + Symbol();
   if (GlobalVariableCheck(g_var_name_520) == FALSE) GlobalVariableSet(g_var_name_520, 0);
   else GlobalVariableSet(g_var_name_520, 0);
   gsa_528[0] = "No_" + Para11;
   gsa_528[1] = "No_" + Para12;
   gsa_528[2] = "No_" + Para13;
   gsa_528[3] = "No_" + Para14;
   gsa_528[4] = "No_" + Para15;
   gsa_528[5] = "No_" + Para16;
   gsa_528[6] = "No_" + Para21;
   gsa_528[7] = "No_" + Para22;
   gsa_528[8] = "No_" + Para23;
   if (RiskProc > 0.5) RiskProc = 0.5;
   gd_536 = NormalizeDouble(MarketInfo(Symbol(), MODE_MARGINREQUIRED) * g_minlot_372 * AccountLeverage() / RiskProc, 2);
   double ld_8 = gd_536 - 0.05 * gd_536;
   string ls_16 = "------------����� � ��������!-----------";
   if (gd_536 > AccountBalance() + 0.05 * AccountBalance()) ls_16 = "��������� ������� �� ����������� �����!";
   Alert("------------- � � � � � � � � ! -------------", 
      "\n", " ������������ ������� ����������� ", 
      "\n", " �������������� ����� ������ � ������ ", 
      "\n", " ������� �������� � ������ ����� 1:", DoubleToStr(AccountLeverage(), 0), 
      "\n", " ������ ������ �����  ", DoubleToStr(AccountBalance(), 2), " ������", 
      "\n", " ����������� ����������� ������ ", 
      "\n", " ��� ��������  ", Symbol(), " ", ld_8, " ������", 
      "\n", 
   "\n", ls_16);
   return (0);
}

int deinit() {
   GlobalVariablesDeleteAll(g_var_name_508);
   return (0);
}

int start() {
   double l_irsi_0;
   double l_irsi_8;
   if (Bars < 100) {
      Print("���������� ����� ����� 100");
      return (0);
   }
   gi_352 = OrdersTotal();
   gi_392 = totalSymbol(gi_352);
   if (gi_392 == 0) {
      gd_468 = 0;
      gd_476 = 0;
      gd_484 = 0;
   }
   if (!ModeIndividual)
      if (CheckGlobal() != 1) return (0);
   if (Otkluchka()) return (0);
   if (Minute() != g_minute_384) {
      if (gi_392 > 0 && DayOfWeek() == 5) {
         if ((Hour() == HourCl5Day && Minute() > 50) || Hour() > HourCl5Day)
            if (gd_408 > 0.0) CloseSymbol(gi_352);
      }
      if (gi_392 == 0) {
         l_irsi_0 = iRSI(NULL, FrameInduk, 14, PRICE_CLOSE, 1);
         l_irsi_8 = iRSI(NULL, FrameInduk, 14, PRICE_CLOSE, 2);
         if (Lot == 0.0) gd_448 = RaschLot(RiskProc);
         else gd_448 = Lot;
         if (gi_392 == 0 && gi_396 != FALSE && Alerts == TRUE) Alert(Symbol(), " ��� ������� �������");
         gi_396 = FALSE;
         if (GlobalVariableGet(g_var_name_508) == 1.0) gs_460 = "BUY";
         if (GlobalVariableGet(g_var_name_508) == -1.0) gs_460 = "SELL";
         if ((DayOfWeek() == 1 && Hour() > HourOp1Day) || DayOfWeek() > 1) {
            if ((DayOfWeek() == 5 && Hour() < HourCl5Day) || DayOfWeek() < 5) {
               if (GlobalVariableGet(g_var_name_508) == 0.0) {
                  if (l_irsi_0 > l_irsi_8 && l_irsi_0 < 100.0 - UrovenR && iClose(NULL, PERIOD_M5, 1) > iOpen(NULL, PERIOD_M5, 1)) gs_460 = "BUY";
                  if (l_irsi_0 < l_irsi_8 && l_irsi_0 > UrovenR && iClose(NULL, PERIOD_M5, 1) < iOpen(NULL, PERIOD_M5, 1)) gs_460 = "SELL";
               }
            }
         }
      } else {
         if (gi_392 < 3) {
            if (MathMod(Minute(), 5) == 0.0) {
               if (g_index_400 > 0) UsloviaOpen("BUY");
               if (g_index_404 > 0) UsloviaOpen("SELL");
            }
         } else {
            if (gi_392 < 5) {
               if (MathMod(Minute(), 15) == 0.0) {
                  if (g_index_400 > 0) UsloviaOpen("BUY");
                  if (g_index_404 > 0) UsloviaOpen("SELL");
               }
            } else {
               if (gi_392 < 8 && gi_392 < MaxPozition) {
                  if (g_index_400 > 1) GlobalVariableSet(g_var_name_520, 1);
                  if (g_index_404 > 1) GlobalVariableSet(g_var_name_520, -1);
                  if (g_hour_388 != Hour()) {
                     if (ProverHedg && gi_392 == 5) {
                        Alert(Symbol(), 
                           "\n", "������� ������� ", gi_392, 
                           "\n", "��������� ��������� ���� �� ������� ������������ ������ ����!", 
                        "\n", "��������� �� ���� , ��� �� �������� ������ ������ ����!");
                     }
                     if (Alerts) {
                        Alert(Symbol(), 
                           "\n", "������� ������� ", gi_392, 
                        "\n", "������ �� ���� ", NormalizeDouble(gd_408, 2));
                     }
                     if (g_index_400 > 1) UsloviaOpen("BUY");
                     if (g_index_404 > 1) UsloviaOpen("SELL");
                  }
               } else {
                  if (MathMod(Hour(), 4) == 0.0 && gi_392 < MaxPozition) {
                     if (Alerts) {
                        Alert(Symbol(), 
                           "\n", "������� ������� ", gi_392, 
                        "\n", "������ �� ���� ", NormalizeDouble(gd_408, 2));
                     }
                     if (g_index_400 > 1) UsloviaOpen("BUY");
                     if (g_index_404 > 1) UsloviaOpen("SELL");
                  }
               }
            }
         }
      }
      if (gs_460 != "") OpenOrder(gs_460, gd_448);
      if (gi_392 > 1 && gi_392 != gi_396) {
         if (g_index_400 > 1) {
            RaschetProfit("BUY");
            gd_484 = gd_468 - TakeProfitN * gd_356;
            if (RejimDopProfit) gd_484 = gd_468 - 2.0 * TakeProfitN * gd_356;
            if (g_index_400 >= 8) gd_484 = gd_468 - 3.0 * gd_356;
         }
         if (g_index_404 > 1) {
            RaschetProfit("SELL");
            gd_484 = gd_476 + TakeProfitN * gd_356;
            if (RejimDopProfit) gd_484 = gd_476 + 2.0 * TakeProfitN * gd_356;
            if (g_index_404 >= 8) gd_484 = gd_476 + 3.0 * gd_356;
         }
      }
      gi_396 = gi_392;
      g_minute_384 = Minute();
      g_hour_388 = Hour();
   }
   if (gi_392 == 1) Modiftral(gi_352);
   if (gi_392 > 1) Modifikator(gi_352);
   if (Comments == TRUE) Commentary();
   return (0);
}

void Commentary() {
   double ld_0;
   ObjectCreate("Broker", OBJ_LABEL, 0, 0, 0);
   ObjectSet("Broker", OBJPROP_XDISTANCE, SdvigInfo + 200);
   ObjectSetText("Broker", "������: " + AccountCompany() + ". �����: 1:" + DoubleToStr(AccountLeverage(), 0), 12, "Arial Bold", White);
   ObjectCreate("KolOrder", OBJ_LABEL, 0, 0, 0);
   ObjectSet("KolOrder", OBJPROP_XDISTANCE, SdvigInfo + 200);
   ObjectSet("KolOrder", OBJPROP_YDISTANCE, 80);
   if (g_index_400 > g_index_404) ObjectSetText("KolOrder", "���������� �������� BUY ������� " + gi_392, 12, "Arial Bold", Blue);
   if (g_index_400 < g_index_404) ObjectSetText("KolOrder", "���������� �������� SELL ������� " + gi_392, 12, "Arial Bold", Red);
   if (g_index_400 == 0 && g_index_404 == 0) ObjectSetText("KolOrder", "�������� ������� ���", 12, "Arial Bold", White);
   if (g_index_400 > 0 || g_index_404 > 0) {
      ObjectCreate("NLOTS", OBJ_LABEL, 0, 0, 0);
      ObjectSet("NLOTS", OBJPROP_XDISTANCE, SdvigInfo + 200);
      ObjectSet("NLOTS", OBJPROP_YDISTANCE, 105);
      ObjectSetText("NLOTS", "��������� ����� ���� �� ���� " + gd_440, 12, "Arial Bold", White);
      if (g_index_400 > 1 || g_index_404 > 1) {
         ObjectCreate("NPrice", OBJ_HLINE, 0, 0, 0);
         ObjectSet("NPrice", OBJPROP_PRICE1, gd_484);
         ObjectSet("NPrice", OBJPROP_COLOR, White);
         ObjectSet("NPrice", OBJPROP_STYLE, STYLE_DASH);
         if (g_index_400 > g_index_404) ld_0 = gd_484 - (AccountBalance() - 0.2 * AccountBalance()) * gd_356 / (gd_416 * gd_440);
         if (g_index_400 < g_index_404) ld_0 = gd_484 + (AccountBalance() - 0.2 * AccountBalance()) * gd_356 / (gd_416 * gd_440);
         ObjectCreate("Sliv", OBJ_HLINE, 0, 0, 0);
         ObjectSet("Sliv", OBJPROP_PRICE1, ld_0);
         ObjectSet("Sliv", OBJPROP_COLOR, Red);
         ObjectSet("Sliv", OBJPROP_STYLE, STYLE_DASH);
      }
      ObjectCreate("SumBalans", OBJ_LABEL, 0, 0, 0);
      ObjectSet("SumBalans", OBJPROP_XDISTANCE, SdvigInfo + 200);
      ObjectSet("SumBalans", OBJPROP_YDISTANCE, 130);
      if (gd_408 >= 0.0) ObjectSetText("SumBalans", "������ �� ���� " + NormalizeDouble(gd_408, 2), 12, "Arial Bold", Blue);
      if (gd_408 < 0.0) ObjectSetText("SumBalans", "������ �� ���� --" + NormalizeDouble(gd_408, 2), 12, "Arial Bold", Red);
   }
   ObjectCreate("Schet", OBJ_LABEL, 0, 0, 0);
   ObjectSet("Schet", OBJPROP_XDISTANCE, SdvigInfo + 200);
   ObjectSet("Schet", OBJPROP_YDISTANCE, 155);
   ObjectSetText("Schet", "�������/������ �� ����� " + ((AccountEquity() - AccountBalance())), 12, "Arial Bold", White);
}

int totalSymbol(int ai_0) {
   int li_ret_8;
   g_index_400 = 0;
   g_index_404 = 0;
   gd_440 = 0;
   g_ord_lots_424 = 0;
   g_ord_open_price_432 = 0;
   gd_408 = 0;
   ArrayInitialize(gda_492, 0);
   ArrayInitialize(gda_500, 0);
   ArrayInitialize(gda_496, 0);
   ArrayInitialize(gda_504, 0);
   for (int l_pos_4 = 0; l_pos_4 < ai_0; l_pos_4++) {
      OrderSelect(l_pos_4, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol()) {
         li_ret_8++;
         if (OrderType() == OP_BUY) {
            gda_492[g_index_400] = OrderOpenPrice();
            gda_500[g_index_400] = OrderLots();
            g_ord_lots_424 = OrderLots();
            g_ord_open_price_432 = OrderOpenPrice();
            gd_440 += g_ord_lots_424;
            gd_408 = gd_408 + OrderSwap() + (Bid - OrderOpenPrice()) / gd_356 * OrderLots() * gd_416;
            g_index_400++;
         }
         if (OrderType() == OP_SELL) {
            gda_496[g_index_404] = OrderOpenPrice();
            gda_504[g_index_404] = OrderLots();
            g_ord_lots_424 = OrderLots();
            g_ord_open_price_432 = OrderOpenPrice();
            gd_440 += g_ord_lots_424;
            gd_408 = gd_408 + OrderSwap() + (OrderOpenPrice() - Ask) / gd_356 * OrderLots() * gd_416;
            g_index_404++;
         }
      }
   }
   if (li_ret_8 == 0 && GlobalVariableGet(g_var_name_508) == 100.0) {
      GlobalVariableSet(g_var_name_508, 0);
      Sleep(3000);
   }
   if (li_ret_8 > 0 && GlobalVariableGet(g_var_name_508) != 100.0) GlobalVariableSet(g_var_name_508, 100);
   return (li_ret_8);
}

void OpenOrder(string as_0, double a_lots_8) {
   int l_ticket_16 = 0;
   int l_index_20 = 0;
   double ld_24 = 0;
   double ld_32 = 0;
   double l_price_40 = 0;
   double ld_48 = TakeProfitN;
   if (RejimDopProfit) ld_48 = 2.0 * TakeProfitN;
   if (gi_392 > 7) ld_48 = 3;
   if (as_0 == "BUY") {
      if (g_index_400 == 0) l_price_40 = Ask + TakeProfit0 * gd_356;
      l_ticket_16 = OrderSend(Symbol(), OP_BUY, a_lots_8, Ask, g_slippage_380, 0, l_price_40, "Ilan BUY " + a_lots_8, 123456789, 0, Blue);
      if (l_ticket_16 > 0 && OrderSelect(l_ticket_16, SELECT_BY_TICKET, MODE_TRADES)) {
         if (Alerts) {
            Alert(Symbol(), 
            "\n", "������ ����� ����� ������� ", a_lots_8);
         }
         if (GlobalVariableGet(g_var_name_508) != 100.0) GlobalVariableSet(g_var_name_508, 100);
         gi_352++;
         gs_460 = "";
         if (g_index_400 > 0) {
            ld_32 = a_lots_8;
            for (l_index_20 = 0; l_index_20 < g_index_400; l_index_20++) {
               ld_24 += (gda_492[l_index_20] - OrderOpenPrice()) * gda_500[l_index_20];
               ld_32 += gda_500[l_index_20];
            }
            gd_468 = OrderOpenPrice() + ld_48 * gd_356 + ld_24 / ld_32;
         }
      }
   }
   if (as_0 == "SELL") {
      if (g_index_404 == 0) l_price_40 = Bid - TakeProfit0 * gd_356;
      l_ticket_16 = OrderSend(Symbol(), OP_SELL, a_lots_8, Bid, g_slippage_380, 0, l_price_40, "Ilan SELL " + a_lots_8, 123456789, 0, Red);
      if (l_ticket_16 > 0 && OrderSelect(l_ticket_16, SELECT_BY_TICKET, MODE_TRADES)) {
         if (Alerts) {
            Alert(Symbol(), 
            "\n", "������ ����� ����� ������� ", a_lots_8);
         }
         if (GlobalVariableGet(g_var_name_508) != 100.0) GlobalVariableSet(g_var_name_508, 100);
         gi_352++;
         gs_460 = "";
         if (g_index_404 > 0) {
            ld_32 = a_lots_8;
            for (l_index_20 = 0; l_index_20 < g_index_404; l_index_20++) {
               ld_24 += (OrderOpenPrice() - gda_496[l_index_20]) * gda_504[l_index_20];
               ld_32 += gda_504[l_index_20];
            }
            gd_476 = OrderOpenPrice() - ld_48 * gd_356 - ld_24 / ld_32;
         }
      }
   }
   if (gi_392 >= 1) {
      if (GlobalVariableGet(g_var_name_508) != 100.0) GlobalVariableSet(g_var_name_508, 100);
      Modifikator(gi_352);
   }
}

void UsloviaOpen(string as_0) {
   gs_460 = "";
   int l_timeframe_8 = 5;
   double ld_12 = Shag;
   if (gi_392 == 4) ld_12 = Shag5;
   if (gi_392 == 5) ld_12 = Shag6;
   if (gi_392 == 6) ld_12 = Shag7;
   if (gi_392 == 7) ld_12 = Shag8;
   if (gi_392 == 8) ld_12 = Shag9;
   if (gi_392 >= 9) ld_12 = Shag10;
   if (gi_392 > 2) l_timeframe_8 = 15;
   if (gi_392 > 4) l_timeframe_8 = 60;
   if (gi_392 > 7) l_timeframe_8 = 240;
   if (g_ord_lots_424 != 0.0) {
      gd_448 = NormalizeDouble(g_ord_lots_424 * KoefLots, g_digits_348);
      if (as_0 == "BUY" && Ask < g_ord_open_price_432 - ld_12 * gd_356 && g_ord_open_price_432 != 0.0) {
         if (RejimTrend) {
            if (iClose(NULL, l_timeframe_8, 1) >= iOpen(NULL, l_timeframe_8, 1)) gs_460 = "BUY";
         } else gs_460 = "BUY";
      }
      if (as_0 == "SELL" && Bid > g_ord_open_price_432 + ld_12 * gd_356 && g_ord_open_price_432 != 0.0) {
         if (RejimTrend) {
            if (iClose(NULL, l_timeframe_8, 1) <= iOpen(NULL, l_timeframe_8, 1)) gs_460 = "SELL";
         } else gs_460 = "SELL";
      }
   }
}

void RaschetProfit(string as_0) {
   double ld_8 = TakeProfitN;
   if (RejimDopProfit) ld_8 = 2.0 * TakeProfitN;
   if (gi_392 > 7) ld_8 = 3;
   int l_index_16 = 0;
   double ld_20 = 0;
   double ld_28 = 0;
   if (as_0 == "BUY") {
      for (l_index_16 = 0; l_index_16 < g_index_400; l_index_16++) {
         ld_20 += (gda_492[l_index_16] - g_ord_open_price_432) * gda_500[l_index_16];
         ld_28 += gda_500[l_index_16];
      }
      gd_468 = g_ord_open_price_432 + ld_8 * gd_356 + ld_20 / ld_28;
   }
   if (as_0 == "SELL") {
      for (l_index_16 = 0; l_index_16 < g_index_404; l_index_16++) {
         ld_20 += (g_ord_open_price_432 - gda_496[l_index_16]) * gda_504[l_index_16];
         ld_28 += gda_504[l_index_16];
      }
      gd_476 = g_ord_open_price_432 - ld_8 * gd_356 - ld_20 / ld_28;
   }
}

void Modifikator(int ai_0) {
   double l_price_8;
   double l_price_16;
   for (int l_pos_4 = 0; l_pos_4 < ai_0; l_pos_4++) {
      OrderSelect(l_pos_4, SELECT_BY_POS, MODE_TRADES);
      if (OrderType() <= OP_SELL && OrderSymbol() == Symbol()) {
         if (OrderType() == OP_BUY) {
            if (g_index_404 == 11 && g_index_400 == 1) {
               l_price_8 = 0;
               if (OrderStopLoss() == 0.0) {
                  l_price_16 = gd_476;
                  OrderModify(OrderTicket(), OrderOpenPrice(), l_price_16, l_price_8, 0, Lime);
               }
            }
            if (gd_468 != 0.0 && OrderTakeProfit() != gd_468 && OrderStopLoss() == 0.0) {
               l_price_8 = gd_468;
               OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), l_price_8, 0, Lime);
            }
            if (RejimDopProfit) {
               if (OrderStopLoss() == 0.0 && Bid - TakeProfitN * gd_356 > gd_484) {
                  l_price_8 = gd_484 + TakeProfit0 * gd_356 / 2.0;
                  l_price_16 = gd_484 + 1.0 * gd_356;
                  OrderModify(OrderTicket(), OrderOpenPrice(), l_price_16, l_price_8, 0, Lime);
               }
               if (OrderStopLoss() != 0.0 && Bid - DopTral * gd_356 > gd_484) {
                  if (OrderStopLoss() + 1.0 * gd_356 < Bid - DopTral * gd_356) {
                     l_price_16 = Bid - DopTral * gd_356;
                     OrderModify(OrderTicket(), OrderOpenPrice(), l_price_16, OrderTakeProfit(), 0, Lime);
                  }
               }
            }
         } else {
            if (g_index_400 == 11 && g_index_404 == 1) {
               l_price_8 = 0;
               if (OrderStopLoss() == 0.0) {
                  l_price_16 = gd_468;
                  OrderModify(OrderTicket(), OrderOpenPrice(), l_price_16, l_price_8, 0, Lime);
               }
            }
            if (gd_476 != 0.0 && OrderTakeProfit() != gd_476 && OrderStopLoss() == 0.0) {
               l_price_8 = gd_476;
               OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), l_price_8, 0, Lime);
            }
            if (RejimDopProfit) {
               if (OrderStopLoss() == 0.0 && Ask + TakeProfitN * gd_356 < gd_484) {
                  l_price_8 = gd_484 - TakeProfit0 * gd_356 / 2.0;
                  l_price_16 = gd_484 - 1.0 * gd_356;
                  OrderModify(OrderTicket(), OrderOpenPrice(), l_price_16, l_price_8, 0, Lime);
               }
               if (OrderStopLoss() != 0.0 && Ask + DopTral * gd_356 < gd_484) {
                  if (OrderStopLoss() - 1.0 * gd_356 > Ask + DopTral * gd_356) {
                     l_price_16 = Ask + DopTral * gd_356;
                     OrderModify(OrderTicket(), OrderOpenPrice(), l_price_16, OrderTakeProfit(), 0, Lime);
                  }
               }
            }
         }
      }
   }
}

int CheckGlobal() {
   bool li_ret_0 = TRUE;
   for (int l_index_4 = 0; l_index_4 < 9; l_index_4++) {
      if (GlobalVariableCheck(gsa_516[l_index_4]) == FALSE) {
         Print("-- ���� ", gsa_516[l_index_4], " �� ����������� --");
         Alert("-- �������� ��������� ��������� �� ���� ", gsa_516[l_index_4]);
         li_ret_0 = FALSE;
         break;
      }
   }
   if (GlobalVariableGet(g_var_name_508) == 100.0 && gi_392 >= MaxNHedj) {
      if (gi_532 == 1) {
         if (g_index_400 > 0) {
            if (GlobalVariableGet(gsa_516[0]) != 100.0) GlobalVariableSet(gsa_516[0], -1);
            if (GlobalVariableGet(gsa_516[1]) != 100.0) GlobalVariableSet(gsa_516[1], -1);
            if (GlobalVariableGet(gsa_516[2]) != 100.0) GlobalVariableSet(gsa_516[2], -1);
            if (GlobalVariableGet(gsa_516[3]) != 100.0) GlobalVariableSet(gsa_516[3], -1);
            if (GlobalVariableGet(gsa_516[4]) != 100.0) GlobalVariableSet(gsa_516[4], -1);
            if (GlobalVariableGet(gsa_516[5]) != 100.0) GlobalVariableSet(gsa_516[5], -1);
            if (GlobalVariableGet(gsa_516[6]) != 100.0) GlobalVariableSet(gsa_516[6], 1);
            if (GlobalVariableGet(gsa_516[7]) != 100.0) GlobalVariableSet(gsa_516[7], 1);
            if (GlobalVariableGet(gsa_516[8]) != 100.0) GlobalVariableSet(gsa_516[8], 1);
         }
         if (g_index_404 > 0) {
            if (GlobalVariableGet(gsa_516[0]) != 100.0) GlobalVariableSet(gsa_516[0], 1);
            if (GlobalVariableGet(gsa_516[1]) != 100.0) GlobalVariableSet(gsa_516[1], 1);
            if (GlobalVariableGet(gsa_516[2]) != 100.0) GlobalVariableSet(gsa_516[2], 1);
            if (GlobalVariableGet(gsa_516[3]) != 100.0) GlobalVariableSet(gsa_516[3], 1);
            if (GlobalVariableGet(gsa_516[4]) != 100.0) GlobalVariableSet(gsa_516[4], 1);
            if (GlobalVariableGet(gsa_516[5]) != 100.0) GlobalVariableSet(gsa_516[5], 1);
            if (GlobalVariableGet(gsa_516[6]) != 100.0) GlobalVariableSet(gsa_516[6], -1);
            if (GlobalVariableGet(gsa_516[7]) != 100.0) GlobalVariableSet(gsa_516[7], -1);
            if (GlobalVariableGet(gsa_516[8]) != 100.0) GlobalVariableSet(gsa_516[8], -1);
         }
      }
      if (gi_532 == -1) {
         if (g_index_400 > 0) {
            if (GlobalVariableGet(gsa_516[0]) != 100.0) GlobalVariableSet(gsa_516[0], 1);
            if (GlobalVariableGet(gsa_516[1]) != 100.0) GlobalVariableSet(gsa_516[1], 1);
            if (GlobalVariableGet(gsa_516[2]) != 100.0) GlobalVariableSet(gsa_516[2], 1);
            if (GlobalVariableGet(gsa_516[3]) != 100.0) GlobalVariableSet(gsa_516[3], 1);
            if (GlobalVariableGet(gsa_516[4]) != 100.0) GlobalVariableSet(gsa_516[4], 1);
            if (GlobalVariableGet(gsa_516[5]) != 100.0) GlobalVariableSet(gsa_516[5], 1);
            if (GlobalVariableGet(gsa_516[6]) != 100.0) GlobalVariableSet(gsa_516[6], -1);
            if (GlobalVariableGet(gsa_516[7]) != 100.0) GlobalVariableSet(gsa_516[7], -1);
            if (GlobalVariableGet(gsa_516[8]) != 100.0) GlobalVariableSet(gsa_516[8], -1);
         }
         if (g_index_404 > 0) {
            if (GlobalVariableGet(gsa_516[0]) != 100.0) GlobalVariableSet(gsa_516[0], -1);
            if (GlobalVariableGet(gsa_516[1]) != 100.0) GlobalVariableSet(gsa_516[1], -1);
            if (GlobalVariableGet(gsa_516[2]) != 100.0) GlobalVariableSet(gsa_516[2], -1);
            if (GlobalVariableGet(gsa_516[3]) != 100.0) GlobalVariableSet(gsa_516[3], -1);
            if (GlobalVariableGet(gsa_516[4]) != 100.0) GlobalVariableSet(gsa_516[4], -1);
            if (GlobalVariableGet(gsa_516[5]) != 100.0) GlobalVariableSet(gsa_516[5], -1);
            if (GlobalVariableGet(gsa_516[6]) != 100.0) GlobalVariableSet(gsa_516[6], 1);
            if (GlobalVariableGet(gsa_516[7]) != 100.0) GlobalVariableSet(gsa_516[7], 1);
            if (GlobalVariableGet(gsa_516[8]) != 100.0) GlobalVariableSet(gsa_516[8], 1);
         }
      }
   }
   return (li_ret_0);
}

void Modiftral(int ai_0) {
   double l_price_8;
   for (int l_pos_4 = 0; l_pos_4 < ai_0; l_pos_4++) {
      OrderSelect(l_pos_4, SELECT_BY_POS, MODE_TRADES);
      if (OrderType() <= OP_SELL && OrderSymbol() == Symbol()) {
         if (OrderType() == OP_BUY) {
            if (RejimBU == TRUE && g_index_400 > 0 && OrderStopLoss() == 0.0) {
               if (Bid - OrderOpenPrice() > (OrderTakeProfit() - OrderOpenPrice()) * ProfBUProc / 100.0) {
                  l_price_8 = OrderOpenPrice() + (Ask - Bid);
                  OrderModify(OrderTicket(), OrderOpenPrice(), l_price_8, OrderTakeProfit(), 0, Lime);
               }
            }
            if (RejimTral == TRUE && g_index_400 > 0 && Bid - OrderOpenPrice() > (OrderTakeProfit() - OrderOpenPrice()) * ProfTralProc / 100.0) {
               l_price_8 = Bid - (OrderTakeProfit() - Bid);
               if (Bid - l_price_8 < gd_364 * gd_356) l_price_8 = Bid - (gd_364 + 1.0) * gd_356;
               if (l_price_8 > OrderStopLoss()) OrderModify(OrderTicket(), OrderOpenPrice(), l_price_8, OrderTakeProfit(), 0, Lime);
            }
         } else {
            if (RejimBU == TRUE && g_index_404 > 0 && OrderStopLoss() == 0.0) {
               if (OrderOpenPrice() - Ask > (OrderOpenPrice() - OrderTakeProfit()) * ProfBUProc / 100.0) {
                  l_price_8 = OrderOpenPrice() - (Ask - Bid);
                  OrderModify(OrderTicket(), OrderOpenPrice(), l_price_8, OrderTakeProfit(), 0, Lime);
               }
            }
            if (RejimTral == TRUE && g_index_404 > 0 && OrderOpenPrice() - Ask > (OrderOpenPrice() - OrderTakeProfit()) * ProfTralProc / 100.0) {
               l_price_8 = Ask + (Ask - OrderTakeProfit());
               if (l_price_8 - Ask < gd_364 * gd_356) l_price_8 = Ask + (gd_364 + 1.0) * gd_356;
               if (l_price_8 < OrderStopLoss()) OrderModify(OrderTicket(), OrderOpenPrice(), l_price_8, OrderTakeProfit(), 0, Lime);
            }
         }
      }
   }
}

double RaschLot(double ad_0) {
   double l_minlot_8 = 0;
   double ld_16 = AccountBalance() - AccountBalance() / 10.0;
   gd_536 = NormalizeDouble(MarketInfo(Symbol(), MODE_MARGINREQUIRED) * g_minlot_372 * AccountLeverage() / ad_0, 2);
   l_minlot_8 = NormalizeDouble(g_minlot_372 * ld_16 / gd_536, g_digits_348);
   if (l_minlot_8 < g_minlot_372) l_minlot_8 = g_minlot_372;
   return (l_minlot_8);
}

void CloseSymbol(int ai_0) {
   int l_ord_close_4;
   double l_price_8;
   int l_cmd_20;
   for (int l_pos_16 = 0; l_pos_16 < ai_0; l_pos_16++) {
      if (OrderSelect(l_pos_16, SELECT_BY_POS, MODE_TRADES)) {
         l_cmd_20 = OrderType();
         if (OrderSymbol() == Symbol()) {
            if (l_cmd_20 == OP_BUY) l_price_8 = Bid;
            else l_price_8 = Ask;
            l_ord_close_4 = OrderClose(OrderTicket(), OrderLots(), l_price_8, g_slippage_380, CLR_NONE);
            if (l_ord_close_4 == 1) {
               if (l_cmd_20 == OP_BUY) g_index_400--;
               if (l_cmd_20 == OP_SELL) g_index_404--;
            }
         }
      }
   }
   Alert(Symbol(), " �������� �������");
}

bool Otkluchka() {
   int li_4;
   int l_global_var_8;
   int li_0 = -1;
   for (int l_index_12 = 0; l_index_12 < 9; l_index_12++) {
      if (GlobalVariableGet(gsa_528[l_index_12]) != 0.0) {
         l_global_var_8 = GlobalVariableGet(gsa_528[l_index_12]);
         li_0 = l_index_12;
         break;
      }
   }
   if (li_0 == -1) return (FALSE);
   for (l_index_12 = 0; l_index_12 < 9; l_index_12++) {
      if (gsa_528[l_index_12] == g_var_name_520) {
         li_4 = l_index_12;
         break;
      }
   }
   if (li_4 == li_0) return (FALSE);
   if (li_0 < 6) {
      if (li_4 < 6) {
         if (l_global_var_8 == 1 && g_index_400 > 0) return (TRUE);
         if (!(l_global_var_8 == -1 && g_index_404 > 0)) return (FALSE);
         return (TRUE);
      }
      if (l_global_var_8 == -1 && g_index_400 > 0) return (TRUE);
      if (l_global_var_8 == 1 && g_index_404 > 0) return (TRUE);
   } else {
      if (li_4 < 6) {
         if (l_global_var_8 == -1 && g_index_400 > 0) return (TRUE);
         if (!(l_global_var_8 == 1 && g_index_404 > 0)) return (FALSE);
         return (TRUE);
      }
      if (l_global_var_8 == 1 && g_index_400 > 0) return (TRUE);
      if (l_global_var_8 == -1 && g_index_404 > 0) return (TRUE);
   }
   return (FALSE);
}