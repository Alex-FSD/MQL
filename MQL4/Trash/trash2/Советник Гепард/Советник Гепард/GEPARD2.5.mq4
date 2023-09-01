
#property copyright "Copyright © 2008, Forex Team"
#property link      ""

extern string sSymbols1 = "AUDCAD: 1; AUDCHF: 1; AUDJPY: 1; AUDNZD: 1; AUDUSD: 1; CADCHF: 1; CADJPY: 1; CHFJPY: 1; EURAUD: 1; EURCAD: 1; EURCHF: 1; EURGBP: 1; EURJPY: 1; EURNZD: 1; EURUSD: 1;";
extern string sSymbols2 = "GBPAUD: 1; GBPCAD: 1; GBPCHF: 1; GBPJPY: 1; GBPNZD: 1; GBPUSD: 1; NZDCAD: 1; NZDCHF: 1; NZDGBP: 1; NZDJPY: 1; NZDUSD: 1; USDCAD: 1; USDCHF: 1; USDJPY: 1";
int gi_92 = 0;
string gs_96 = "";
string gs_104 = "";
string gs_112 = "";
string gs_120 = "";
string gs_128 = "";
string gs_136 = "";
string gs_144 = "";
extern double dRisk = 0.005;
extern string sRisk = "";
int gi_168 = 0;
extern int dMaxSymbolOrdersCount = 5;
extern string sMaxSymbolOrdersCount = "";
extern double MaxOpenValPosition = 7.0;
int gi_192 = 18;
string gs_196 = "EURGBP: 14; AUDUSD: 14; EURJPY: 20; GBPCHF: 25; GBPJPY: 25; GBPUSD: 25";
int gi_204 = 18;
string gs_208 = "EURGBP: 14; AUDUSD: 14; EURJPY: 20; GBPCHF: 25; GBPJPY: 25; GBPUSD: 25";
extern int dStopLoss = 0;
extern string sStopLoss = "";
int gi_228 = 0;
string gs_232 = "";
int gi_240 = 0;
string gs_244 = "";
int gi_252 = 0;
string gs_256 = "";
int gi_264 = 0;
string gs_268 = "";
int gi_276 = 0;
string gs_280 = "";
int gi_288 = 0;
string gs_292 = "";
int gi_300 = 5;
string gs_304 = "";
int gi_312 = 1;
string gs_316 = "";
int gi_324 = 1;
string gs_328 = "";
extern double dMinDistanceRealOrdersB_PR = 5.0;
extern string sMinDistanceRealOrdersB_PR = "";
extern double dMinDistanceRealOrdersS_PR = 5.0;
extern string sMinDistanceRealOrdersS_PR = "";
int gi_368 = 0;
string gs_372 = "";
int gi_380 = 0;
string gs_384 = "";
int gi_392 = 0;
string gs_396 = "";
int gi_404 = 17;
string gs_408 = "";
int gi_416 = 17;
string gs_420 = "";
int gi_428 = 83;
string gs_432 = "";
int gi_440 = 83;
string gs_444 = "";
extern int CR_UseCorrection = 1;
extern double CR_WaitCorrectionAfterMove_PR = 1.2;
extern double CR_WaitCorrectionAfterFlat_PR = 0.2;
extern double CR_MaxDistanceFromBottom_PR = 0.1;
extern double CR_SizeCorrection_PR = 0.3;
extern double CR_StopLoss_PR = 0.0;
extern int CR_AnalizMove_Period = 5;
extern int CR_AnalizMove_CountBars = 6;
extern int CR_AnalizFlat_Period = 2;
extern int CR_AnalizFlat_CountBars = 2;
int gi_512 = 0;
string gs_516 = "";
int gi_524 = 3;
string gs_528 = "";
int gi_536 = 3;
string gs_540 = "";
int gi_548 = 0;
string gs_552 = "";
int gi_560 = 1;
string gs_564 = "";
int gi_572 = 2;
string gs_576 = "";
int gi_584 = 2;
string gs_588 = "";
int gi_596 = 1;
string gs_600 = "";
int gi_608 = 0;
string gs_612 = "";
double gd_620 = 0.0005;
string gs_628 = "";
int gi_636 = 1;
string gs_640 = "";
int gi_648 = 35;
string gs_652 = "";
extern int dCountHighLowLimits = 2;
extern string sCountHighLowLimits = "";
extern double diHL_LimitDistance1_PR = 1.0;
extern string siHL_LimitDistance1_PR = "";
extern int diHL_Period1 = 5;
extern string siHL_Period1 = "";
extern int diHL_CountBars1 = 6;
extern string siHL_CountBars1 = "";
extern double diHL_LimitDistance2_PR = 5.0;
extern string siHL_LimitDistance2_PR = "";
extern int diHL_Period2 = 7;
extern string siHL_Period2 = "";
extern int diHL_CountBars2 = 2;
extern string siHL_CountBars2 = "";
extern int dUseFlatIndicator = 1;
extern string sUseFlatIndicator = "";
int gi_764 = 10;
string gs_768 = "";
int gi_776 = 50;
string gs_780 = "";
extern int diFL_MinExtremumsCount = 1;
extern string siFL_MinExtremumsCount = "";
extern int diFL_Period = 1;
extern string siFL_Period = "";
extern int diFL_CountBars = 12;
extern string siFL_CountBars = "";
extern int diFL_StopLoss = 0;
extern string siFL_StopLoss = "";
double gd_836 = 1.0;
string gs_844 = "";
extern double dMinLotSize = 0.01;
extern string sMinLotSize = "";
extern double dMaxLotSize = 0.0;
extern string sMaxLotSize = "";
extern double dStepLotSize = 0.01;
extern string sStepLotSize = "";
int gi_900 = 1;
string gs_904 = "";
int gi_912 = 0;
int gi_916 = 10;
string gs_920 = "";
int gi_928 = 50;
string gs_932 = "";
int gi_940 = 10;
extern int MaxSpreadForTradeSymbol = 12;
string gs_gepard__948 = "gepard ";
bool gi_unused_956 = FALSE;
int gi_unused_960 = 0;
int gi_964;
string gsa_968[];
double gda_972[];
double gda_976[];
double gda_980[];
double gda_984[];
int gia_988[];
int gia_992[];
int gia_996[];
double gda_1000[];
double gda_1004[];
double gda_1008[];
int gia_1012[];
int gia_1016[];
int gia_1020[];
int gia_1024[];
int gia_1028[];
int gia_1032[];
int gia_1036[];
int gia_1040[];
int gia_1044[];
int gia_1048[];
int gia_1052[];
int gia_1056[];
int gia_1060[];
int gia_1064[];
int gia_1068[];
int gia_1072[];
double gda_1076[];
double gda_1080[];
int gia_1084[];
int gia_1088[];
int gia_1092[];
int gia_1096[];
int gia_1100[];
int gia_1104[];
int gia_1108[];
int gia_1112[];
int gia_1116[];
int gia_1120[];
int gia_1124[];
double gda_1128[];
double gda_1132[];
double gda_1136[];
int gia_1140[];
double gda_1144[];
int gia_1148[];
int gia_1152[];
double gda_1156[];
int gia_1160[];
int gia_1164[];
int gia_1168[];
int gia_1172[];
int gia_1176[];
int gia_1180[];
int gia_1184[];
int gia_1188[];
int gia_1192[];
double gda_1196[];
double gda_1200[];
double gda_1204[];
double gda_1208[];
int gia_1212[];
int gia_1216[];
int gia_1220[];
int gia_1224[];
string g_symbol_1228;
double gd_1236;
double gd_1244;
double g_bid_1252;
double g_ask_1260;
int gi_1268;
int gi_1272;
int gi_1276;
int gi_1280;
int gi_1284;
int gi_1288;
int gi_1292;
int gi_1296;
int gi_1300;
int gi_1304;
int gi_1308;
int gi_1312;
int gi_1316;
int gi_1320;
int gi_1324;
int gi_1328;
int gi_1332;
double gd_1336;
double gd_1344;
int gi_1352;
int gi_1356;
int gi_1360;
int gi_1364;
int gi_1368;
int gi_1372;
int gi_1376;
int gi_1380;
int gi_1384;
int gi_1388;
int gi_1392;
double gd_1396;
int gi_1404;
int gi_1408;
int gi_1412;
double gd_1416;
int gi_1424;
int gi_1428;
double gd_1432;
int gi_1440;
int gi_1444;
int gi_1448;
int gi_1452;
int gi_1456;
int gi_1460;
int gi_1464;
int gi_1468;
int gi_1472;
double gd_1476;
int gi_1484;
double gd_1488;
double gd_1496;
int gi_1504;
int gi_1508;
int gi_1512;
bool gi_1516 = FALSE;
int g_day_1520 = 0;
int gi_1524;
int gi_1528;
double gd_1536;
double gd_1544;
double gd_1552;
double gd_1568;
double gd_1576;
double g_price_1584;
double gd_1592;
double gd_1600;
double gd_1608;
double gd_1616;
int g_ticket_1624;
int gi_1628;
int gi_1632;
bool gi_1636;
bool gi_1640;
string gs_1644;
int gi_1652;
string gsa_1656[];
double gda_1660[];
double gda_1664[];
int gia_1668[6];
double gda_1672[6];
double gda_1676[6];
double gda_1680[6];
bool gi_1684;
double gd_1688;
double gd_1696;
double gda_1704[2];
double gda_1708[2];
double gd_1712;
bool gi_1720;
double g_ilow_1724;
double g_ihigh_1732;
double gd_1740;
int gi_1748 = 0;
int gi_1752 = 1;
int gi_1756 = 2;
int gi_1760 = 3;
int gi_1764 = 4;
int gi_1768 = 5;
int gia_1772[10] = {1, 5, 15, 30, 60, 240, 1440, 10080, 43200, 0};

int init() {
   int li_12;
   int li_16;
   bool li_20;
   string ls_24;
   string ls_32;
   string lsa_40[];
   if (gi_228 == 0) gi_228 = dStopLoss;
   if (gi_240 == 0) gi_240 = dStopLoss;
   if (gs_232 == "") gs_232 = sStopLoss;
   if (gs_244 == "") gs_244 = sStopLoss;
   gi_964 = 0;
   for (int l_index_8 = 1; l_index_8 <= 2; l_index_8++) {
      switch (l_index_8) {
      case 1:
         ls_24 = sSymbols1;
         break;
      case 2:
         ls_24 = sSymbols2;
      }
      li_16 = glSeparateStringInArray(ls_24, lsa_40, ";");
      for (int l_index_0 = 0; l_index_0 < li_16; l_index_0++) {
         li_12 = StringFind(lsa_40[l_index_0], ":");
         if (li_12 != -1) {
            if (glStringTrimAll(StringSubstr(lsa_40[l_index_0], li_12 + 1)) == "1") {
               ls_32 = glStringTrimAll(StringSubstr(lsa_40[l_index_0], 0, li_12));
               gi_964++;
               ArrayResize(gsa_968, gi_964);
               gsa_968[gi_964 - 1] = ls_32;
            }
         }
      }
   }
   ArrayResize(gda_972, gi_964);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) gda_972[l_index_0] = MarketInfo(gsa_968[l_index_0], MODE_POINT);
   ArrayResize(gda_976, gi_964);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) gda_976[l_index_0] = MarketInfo(gsa_968[l_index_0], MODE_DIGITS);
   ArrayResize(gda_980, gi_964);
   ArrayResize(gda_984, gi_964);
   gi_1652 = 0;
   ArrayResize(gsa_1656, gi_1652);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (StringLen(gsa_968[l_index_0]) == 6) {
         for (int l_count_4 = 0; l_count_4 < 2; l_count_4++) {
            ls_32 = StringSubstr(gsa_968[l_index_0], 3 * l_count_4 + 0, 3);
            li_20 = FALSE;
            for (l_index_8 = 0; l_index_8 < gi_1652; l_index_8++) {
               if (gsa_1656[l_index_8] == ls_32) {
                  li_20 = TRUE;
                  break;
               }
            }
            if (!li_20) {
               gi_1652++;
               ArrayResize(gsa_1656, gi_1652);
               gsa_1656[gi_1652 - 1] = ls_32;
            }
         }
      }
   }
   ArrayResize(gda_1660, gi_1652);
   ArrayResize(gda_1664, gi_1652);
   GetSymbolsSettingsFromStrings();
   myGetSymbolSettingsDay();
   return (0);
}

int myGetSymbolParameters(int ai_0) {
   gi_1268 = gia_992[ai_0];
   gi_1272 = gia_996[ai_0];
   if (gi_1268 == 0 && gi_1272 == 0) return (0);
   gd_1236 = gda_972[ai_0];
   gd_1244 = gda_976[ai_0];
   if (gd_1236 == 0.0) return (0);
   g_bid_1252 = MarketInfo(g_symbol_1228, MODE_BID);
   g_ask_1260 = MarketInfo(g_symbol_1228, MODE_ASK);
   gi_1276 = gia_1012[ai_0];
   gi_1280 = gia_1016[ai_0];
   gi_1284 = gia_1020[ai_0];
   gi_1288 = gia_1024[ai_0];
   gi_1292 = gia_1028[ai_0];
   gi_1296 = gia_1032[ai_0];
   gi_1300 = gia_1036[ai_0];
   gi_1304 = gia_1040[ai_0];
   gi_1308 = gia_1044[ai_0];
   gi_1312 = gia_1052[ai_0];
   gi_1316 = gia_1056[ai_0];
   gi_1320 = gia_1060[ai_0];
   gi_1324 = gia_1064[ai_0];
   gi_1328 = gia_1068[ai_0];
   gi_1332 = gia_1072[ai_0];
   gd_1336 = gda_1076[ai_0];
   gd_1344 = gda_1080[ai_0];
   gi_1352 = gia_1084[ai_0];
   gi_1356 = gia_1088[ai_0];
   gi_1360 = gia_1092[ai_0];
   gi_1364 = gia_1096[ai_0];
   gi_1368 = gia_1100[ai_0];
   gi_1372 = gia_1104[ai_0];
   gi_1376 = gia_1108[ai_0];
   gi_1380 = gia_1112[ai_0];
   gi_1384 = gia_1116[ai_0];
   gi_1388 = gia_1120[ai_0];
   gi_1392 = gia_1124[ai_0];
   gd_1396 = gda_1128[ai_0];
   gi_1404 = gda_1132[ai_0];
   gi_1408 = gda_1136[ai_0];
   gi_1412 = gia_1140[ai_0];
   gd_1416 = gda_1144[ai_0];
   gi_1424 = gia_1148[ai_0];
   gi_1428 = gia_1152[ai_0];
   gd_1432 = gda_1156[ai_0];
   gi_1440 = gia_1160[ai_0];
   gi_1444 = gia_1164[ai_0];
   gi_1448 = gia_1168[ai_0];
   gi_1452 = gia_1172[ai_0];
   gi_1456 = gia_1176[ai_0];
   gi_1460 = gia_1180[ai_0];
   gi_1464 = gia_1184[ai_0];
   gi_1468 = gia_1188[ai_0];
   gi_1472 = gia_1192[ai_0];
   gd_1476 = gda_1196[ai_0];
   gi_1484 = gia_1212[ai_0];
   gd_1488 = gda_1000[ai_0];
   gd_1496 = gda_1004[ai_0];
   gi_1504 = gia_1216[ai_0];
   gi_1508 = gia_1220[ai_0];
   gi_1512 = gia_1224[ai_0];
   return (1);
}

int deinit() {
   return (0);
}

int start() {
   if (!myCheckAllowWorking()) return (0);
   if (Day() != g_day_1520) myGetSymbolSettingsDay();
   for (int l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      g_symbol_1228 = gsa_968[l_index_0];
      if (IsTesting() || IsOptimization() && g_symbol_1228 != Symbol()) continue;
      if (!IsTesting() && MarketInfo(g_symbol_1228, MODE_TRADEALLOWED) == 0.0) continue;
      if (myGetSymbolParameters(l_index_0)==1) {
         if (myAnalizCurrentStateGeneral()==1) {
            if (myAnalizCurrentStateSymbol()==1) {
               if (gi_1684 == 0) {
                  if (MaxSpreadForTradeSymbol != 0)
                     if (MarketInfo(g_symbol_1228, MODE_SPREAD) > MaxSpreadForTradeSymbol) continue;
                  myCalculateIndicators();
                  myControlOpenOrdersSymbol();
                  if (gi_168 > 0)
                     if (OrdersTotal() >= gi_168) continue;
                  if (myAnalizCurrentStateGeneral()==1) {
                     if (myAnalizCurrentStateSymbol()==1) {
                        gd_1536 = myGetLotSize(l_index_0);
                        if (AccountFreeMargin() < 1000.0 * gd_1536)
                           if (gia_1668[gi_1748] + gia_1668[gi_1752] == 0) continue;
                        myTradeSymbol(l_index_0);
                     }
                  }
               }
            }
         }
      }
   }
   return (0);
}

void myTradeSymbol(int ai_0) {
   for (int l_count_4 = 0; l_count_4 < 2; l_count_4++) {
      if (gi_1504 != 0)
         if (gia_1668[gi_1748] + gia_1668[gi_1752] >= gi_1504) break;
      if (l_count_4 == 0) {
         if (gi_1268 == 0) continue;
         if (gia_988[ai_0] == 1 && gda_980[ai_0] <= 0.0) continue;
         if (Time[0] > D'02.08.2008 07:28' && Time[0] < D'09.10.2008 05:17')
            if (gda_980[ai_0] >= 0.0) continue;
         gi_1628 = gi_1748;
         gs_1644 = "BUY";
         g_price_1584 = g_ask_1260;
      } else {
         if (gi_1272 == 0) continue;
         if (gia_988[ai_0] == 1 && gda_984[ai_0] <= 0.0) continue;
         if (Time[0] > D'02.08.2008 07:28' && Time[0] < D'09.10.2008 05:17')
            if (gda_984[ai_0] >= 0.0) continue;
         gi_1628 = gi_1752;
         gs_1644 = "SELL";
         g_price_1584 = g_bid_1252;
      }
      gd_1592 = 100.0 * MathFloor(g_price_1584 / gd_1236 / 100.0) * gd_1236;
      if (gi_1484 == 1) {
         gi_1640 = FALSE;
         if (!gi_1640 && CR_UseCorrection) myCheckAndPrepareRO_Correction();
         if (!gi_1640 && gi_1448 == 1 && gi_1720) myCheckAndPrepareRO_Flat();
         if (!gi_1640 && gi_1376 == 1 && gi_1392 == 1 && MathAbs(gd_1688) > gd_1396) myCheckAndPrepareRO_Speed();
         if (gi_1640)
            if (!myCheckOrderBeforeAdding(gd_1552, gi_1628, gi_1524, g_price_1584)) gi_1640 = FALSE;
         if (gi_1640)
            if (!myCheckDistanceFromOneWayReal(gd_1552, gi_1628, gs_1644, gd_1600)) gi_1640 = FALSE;
         if (gi_1640)
            if (!myCheckHighLowLimit(gd_1552, gi_1628, gs_1644)) gi_1640 = FALSE;
         if (gi_1640)
            if (!myCheckOpenOrdersBeforeAdding(gd_1552, gi_1524, g_price_1584)) gi_1640 = FALSE;
         if (gi_1640) {
            gd_1544 = gd_1536;
            if (gi_1528 == 57320200) {
               if (gd_1476 > 0.0 && gd_1476 != 1.0) {
                  gd_1544 = glDoubleRound(gd_1536 * gd_1476, gda_1208[ai_0]);
                  if (gd_1544 > gda_1204[ai_0]) gd_1544 = gda_1204[ai_0];
               }
            } else {
               if (gi_1528 == 57320300) {
               }
            }
            g_ticket_1624 = myOrderSend(g_symbol_1228, gi_1524, gd_1544, gd_1552, 0, gd_1568, gd_1576, "", gi_1528, 0, Green);
            if (g_ticket_1624 > 0) {
               if (OrderSelect(g_ticket_1624, SELECT_BY_TICKET, MODE_TRADES)) {
                  if (!(myAnalizCurrentStateSymbol())) break;
                  continue;
               }
            }
         }
      }
      if (gia_1048[ai_0] == 1) myCheckAndOpenDO_FigureLevels();
   }
}

void myCheckAndOpenDO_FigureLevels() {
   for (int l_count_0 = 0; l_count_0 < 2; l_count_0++) {
      gi_1528 = 57320000;
      if (l_count_0 == 0) {
         if (gi_1628 == gi_1748) {
            if (gi_1312 < 0) continue;
            gi_1524 = 4;
            gi_1632 = gi_1764;
            gs_1644 = "BUY STOP";
            if (g_price_1584 < gd_1592 + gi_1312 * gd_1236) gd_1552 = gd_1592 + gi_1312 * gd_1236;
            else gd_1552 = gd_1592 + (gi_1312 + 100) * gd_1236;
         } else {
            if (gi_1320 < 0) continue;
            gi_1524 = 5;
            gi_1632 = gi_1768;
            gs_1644 = "SELL STOP";
            if (g_price_1584 < gd_1592 + gi_1320 * gd_1236) gd_1552 = gd_1592 - (100 - gi_1320) * gd_1236;
            else gd_1552 = gd_1592 + gi_1320 * gd_1236;
         }
      } else {
         if (gi_1628 == gi_1748) {
            if (gi_1316 < 0) continue;
            gi_1524 = 2;
            gi_1632 = gi_1756;
            gs_1644 = "BUY LIMIT";
            if (g_price_1584 < gd_1592 + gi_1316 * gd_1236) gd_1552 = gd_1592 - (100 - gi_1316) * gd_1236;
            else gd_1552 = gd_1592 + gi_1316 * gd_1236;
         } else {
            if (gi_1324 < 0) continue;
            gi_1524 = 3;
            gi_1632 = gi_1760;
            gs_1644 = "SELL LIMIT";
            if (g_price_1584 < gd_1592 + gi_1324 * gd_1236) gd_1552 = gd_1592 + gi_1324 * gd_1236;
            else gd_1552 = gd_1592 + (gi_1324 + 100) * gd_1236;
         }
      }
      if (gi_1628 == gi_1748) {
         gd_1576 = gd_1552 + gi_1276 * gd_1236;
         if (gi_1284 > 0) gd_1568 = gd_1552 - gi_1284 * gd_1236;
         else gd_1568 = 0;
      } else {
         gd_1576 = gd_1552 - gi_1280 * gd_1236;
         if (gi_1288 > 0) gd_1568 = gd_1552 + gi_1288 * gd_1236;
         else gd_1568 = 0;
      }
      gi_1636 = TRUE;
      if (gi_1636)
         if (!myCheckOrderBeforeAdding(gd_1552, gi_1628, gi_1524, g_price_1584)) gi_1636 = FALSE;
      if (gi_1636) {
         if (gi_1508 != 0)
            if (MathAbs(gd_1552 - g_price_1584) < gi_1508 * gd_1236) gi_1636 = FALSE;
         if (gi_1512 != 0)
            if (MathAbs(gd_1552 - g_price_1584) > gi_1512 * gd_1236) gi_1636 = FALSE;
      }
      if (gi_1636)
         if (gia_1668[gi_1628] > 0 && l_count_0 == 1) gi_1636 = FALSE;
      if (gi_1636) {
         if (gia_1668[gi_1632] > 0) {
            if (gi_1632 == gi_1764 || gi_1632 == gi_1760) gd_1608 = gda_1672[gi_1632];
            else gd_1608 = gda_1676[gi_1632];
            if (gi_940 != 0) gd_1616 = gi_940 * gd_1236;
            else gd_1616 = 1;
            if (gi_1632 == gi_1764 || gi_1632 == gi_1760) {
               if (gd_1552 > gd_1608 - gd_1616) gi_1636 = FALSE;
            } else
               if (gd_1552 < gd_1608 + gd_1616) gi_1636 = FALSE;
         }
      }
      if (gi_1636 && gia_1668[gi_1628] > 0) {
         if (myCheckDistanceFromOneWayReal(gd_1552, gi_1628, gs_1644, gd_1600)) {
            if ((gi_1628 == gi_1748 && gi_1352 == 1) || (gi_1628 == gi_1752 && gi_1356 == 1)) {
               gd_1576 = (gd_1552 + gd_1600) / 2.0;
               gi_1528 = 57320100;
            }
         } else gi_1636 = FALSE;
      }
      if (gi_1636 && gi_1360 == 1) {
         if (l_count_0 == 1) {
            if (gi_1628 == gi_1748 && gd_1696 < 0.0) gi_1636 = FALSE;
            if (gi_1628 == gi_1752 && gd_1696 > 0.0) gi_1636 = FALSE;
         }
      }
      if (gi_1636 && gi_1376 == 1) {
         if (l_count_0 == 1) {
            if (gi_1628 == gi_1748 && gd_1688 < 0.0) gi_1636 = FALSE;
            if (gi_1628 == gi_1752 && gd_1688 > 0.0) gi_1636 = FALSE;
         }
      }
      if (gi_1636 && gi_1412 > 0)
         if (!myCheckHighLowLimit(gd_1552, gi_1628, gs_1644)) gi_1636 = FALSE;
      if (gi_1636)
         if (!myCheckOpenOrdersBeforeAdding(gd_1552, gi_1524, g_price_1584)) gi_1636 = FALSE;
      if (gi_1636) {
         gd_1544 = gd_1536;
         g_ticket_1624 = myOrderSend(g_symbol_1228, gi_1524, gd_1544, gd_1552, 0, gd_1568, gd_1576, "", gi_1528, 0, Green);
         if (g_ticket_1624 > 0) {
            if (OrderSelect(g_ticket_1624, SELECT_BY_TICKET, MODE_TRADES))
               if (!(myAnalizCurrentStateSymbol())) break;
         }
      }
   }
}

void myCheckAndPrepareRO_Flat() {
   if (gi_1628 == gi_1748 && g_price_1584 > g_ilow_1724 && g_price_1584 <= g_ilow_1724 + gd_1740 / 4.0) {
      if (iOpen(g_symbol_1228, gia_1772[0], 0) >= iClose(g_symbol_1228, gia_1772[0], 1) && iClose(g_symbol_1228, gia_1772[0], 1) > iClose(g_symbol_1228, gia_1772[0], 2) &&
         iClose(g_symbol_1228, gia_1772[0], 2) > iClose(g_symbol_1228, gia_1772[0], 3)) {
         gi_1640 = TRUE;
         gi_1524 = 0;
         gd_1552 = g_price_1584;
         gd_1576 = gd_1552 + NormalizeDouble(gd_1740 / 2.0, gd_1244);
         if (gi_1276 > 0)
            if (gd_1576 > gd_1552 + gi_1276 * gd_1236) gd_1576 = gd_1552 + gi_1276 * gd_1236;
         if (gi_1472 > 0) gd_1568 = gd_1552 - gi_1472 * gd_1236;
         else {
            if (gi_1284 > 0) gd_1568 = gd_1552 - gi_1284 * gd_1236;
            else gd_1568 = 0;
         }
      }
   }
   if (gi_1628 == gi_1752 && g_price_1584 < g_ihigh_1732 && g_price_1584 >= g_ihigh_1732 - gd_1740 / 4.0) {
      if (iOpen(g_symbol_1228, gia_1772[0], 0) <= iClose(g_symbol_1228, gia_1772[0], 1) && iClose(g_symbol_1228, gia_1772[0], 1) < iClose(g_symbol_1228, gia_1772[0], 2) &&
         iClose(g_symbol_1228, gia_1772[0], 2) < iClose(g_symbol_1228, gia_1772[0], 3)) {
         gi_1640 = TRUE;
         gi_1524 = 1;
         gd_1552 = g_price_1584;
         gd_1576 = gd_1552 - NormalizeDouble(gd_1740 / 2.0, gd_1244);
         if (gi_1280 > 0)
            if (gd_1576 < gd_1552 - gi_1280 * gd_1236) gd_1576 = gd_1552 - gi_1280 * gd_1236;
         if (gi_1472 > 0) gd_1568 = gd_1552 + gi_1472 * gd_1236;
         else {
            if (gi_1288 > 0) gd_1568 = gd_1552 + gi_1288 * gd_1236;
            else gd_1568 = 0;
         }
      }
   }
   if (gi_1640) gi_1528 = 57320200;
}

void myCheckAndPrepareRO_Correction() {
   double l_ilow_4;
   double l_ihigh_12;
   double l_ilow_20 = 0;
   double l_ihigh_28 = 0;
   double l_ilow_36 = 0;
   double l_ihigh_44 = 0;
   for (int li_0 = 0; li_0 < CR_AnalizMove_CountBars; li_0++) {
      l_ilow_4 = iLow(g_symbol_1228, gia_1772[CR_AnalizMove_Period], li_0);
      l_ihigh_12 = iHigh(g_symbol_1228, gia_1772[CR_AnalizMove_Period], li_0);
      if (l_ilow_4 > 0.0)
         if (l_ilow_20 == 0.0 || l_ilow_4 < l_ilow_20) l_ilow_20 = l_ilow_4;
      if (l_ihigh_12 > 0.0)
         if (l_ihigh_28 == 0.0 || l_ihigh_12 > l_ihigh_28) l_ihigh_28 = l_ihigh_12;
   }
   for (li_0 = 0; li_0 < CR_AnalizFlat_CountBars; li_0++) {
      l_ilow_4 = iLow(g_symbol_1228, gia_1772[CR_AnalizFlat_Period], li_0);
      l_ihigh_12 = iHigh(g_symbol_1228, gia_1772[CR_AnalizFlat_Period], li_0);
      if (l_ilow_4 > 0.0)
         if (l_ilow_36 == 0.0 || l_ilow_4 < l_ilow_36) l_ilow_36 = l_ilow_4;
      if (l_ihigh_12 > 0.0)
         if (l_ihigh_44 == 0.0 || l_ihigh_12 > l_ihigh_44) l_ihigh_44 = l_ihigh_12;
   }
   if (l_ilow_20 == 0.0 || l_ihigh_28 == 0.0 || l_ilow_36 == 0.0 || l_ihigh_44 == 0.0) return;
   if (l_ihigh_28 - l_ilow_20 >= g_price_1584 * CR_WaitCorrectionAfterMove_PR / 100.0) {
      if (l_ihigh_44 - l_ilow_36 <= g_price_1584 * CR_WaitCorrectionAfterFlat_PR / 100.0) {
         if (gi_1628 == gi_1748 && g_price_1584 <= l_ilow_20 + g_price_1584 * CR_MaxDistanceFromBottom_PR / 100.0) {
            gi_1640 = TRUE;
            gi_1524 = 0;
            gd_1552 = g_price_1584;
            gd_1576 = gd_1552 + NormalizeDouble(g_price_1584 * CR_SizeCorrection_PR / 100.0, gd_1244);
            if (CR_StopLoss_PR > 0.0) gd_1568 = gd_1552 - NormalizeDouble(g_price_1584 * CR_StopLoss_PR / 100.0, gd_1244);
            else {
               if (gi_1284 > 0) gd_1568 = gd_1552 - gi_1284 * gd_1236;
               else gd_1568 = 0;
            }
         }
         if (gi_1628 == gi_1752 && g_price_1584 >= l_ihigh_28 - g_price_1584 * CR_MaxDistanceFromBottom_PR / 100.0) {
            gi_1640 = TRUE;
            gi_1524 = 1;
            gd_1552 = g_price_1584;
            gd_1576 = gd_1552 - NormalizeDouble(g_price_1584 * CR_SizeCorrection_PR / 100.0, gd_1244);
            if (CR_StopLoss_PR > 0.0) gd_1568 = gd_1552 + NormalizeDouble(g_price_1584 * CR_StopLoss_PR / 100.0, gd_1244);
            else {
               if (gi_1288 > 0) gd_1568 = gd_1552 + gi_1288 * gd_1236;
               else gd_1568 = 0;
            }
         }
         if (gi_1640) gi_1528 = 57320400;
      }
   }
}

void myCheckAndPrepareRO_Speed() {
   if (gi_1628 == gi_1748 && gd_1688 > 0.0) {
      gi_1640 = TRUE;
      gi_1524 = 0;
      gd_1552 = g_price_1584;
      if (gi_1404 == 1) gd_1576 = gd_1552 + MarketInfo(g_symbol_1228, MODE_STOPLEVEL) * gd_1236;
      else gd_1576 = gd_1552 + gi_1276 * gd_1236;
      if (gi_1408 > 0) gd_1568 = gd_1552 - gi_1408 * gd_1236;
      else {
         if (gi_1284 > 0) gd_1568 = gd_1552 - gi_1284 * gd_1236;
         else gd_1568 = 0;
      }
   }
   if (gi_1628 == gi_1752 && gd_1688 < 0.0) {
      gi_1640 = TRUE;
      gi_1524 = 1;
      gd_1552 = g_price_1584;
      if (gi_1404 == 1) gd_1576 = gd_1552 - MarketInfo(g_symbol_1228, MODE_STOPLEVEL) * gd_1236;
      else gd_1576 = gd_1552 - gi_1280 * gd_1236;
      if (gi_1408 > 0) gd_1568 = gd_1552 + gi_1408 * gd_1236;
      else {
         if (gi_1288 > 0) gd_1568 = gd_1552 + gi_1288 * gd_1236;
         else gd_1568 = 0;
      }
   }
   if (gi_1640) gi_1528 = 57320300;
}

bool myCheckOrderBeforeAdding(double ad_0, int ai_8, int ai_12, double ad_unused_16) {
   double ld_36;
   string ls_44;
   if (Time[0] > D'25.07.2008 07:28' && Time[0] < D'10.09.2008 05:17') return (FALSE);
   if (ai_8 == gi_1748) {
      if (gi_1268 == 0) return (FALSE);
      if (ai_12 == 0 && gi_1484 == 0) return (FALSE);
      if (gd_1488 > 0.0 && ad_0 >= gd_1488) return (FALSE);
   }
   if (ai_8 == gi_1752) {
      if (gi_1272 == 0) return (FALSE);
      if (ai_12 == 1 && gi_1484 == 0) return (FALSE);
      if (gd_1496 > 0.0 && ad_0 <= gd_1496) return (FALSE);
   }
   if (MaxOpenValPosition > 0.0) {
      if (StringLen(g_symbol_1228) == 6) {
         for (int l_count_28 = 0; l_count_28 < 2; l_count_28++) {
            ls_44 = StringSubstr(g_symbol_1228, 3 * l_count_28 + 0, 3);
            ld_36 = 0;
            for (int l_index_32 = 0; l_index_32 < gi_1652; l_index_32++) {
               if (gsa_1656[l_index_32] == ls_44) {
                  ld_36 = gda_1660[l_index_32] - gda_1664[l_index_32];
                  if (!((ai_8 == gi_1748 && l_count_28 == 1) || (ai_8 == gi_1752 && l_count_28 == 0))) break;
                  ld_36 = -ld_36;
                  break;
               }
            }
            if (ld_36 > gd_1536 * MaxOpenValPosition) return (FALSE);
         }
      }
   }
   return (TRUE);
}

bool myCheckOpenOrdersBeforeAdding(double ad_0, int ai_8, double ad_12) {
   int l_ord_total_32;
   int l_count_36;
   int l_cmd_40;
   int l_ticket_44;
   double ld_48;
   double ld_56;
   if (ai_8 == 0 || ai_8 == 2)
      if (!glDeleteAllDeferOrders(OP_BUYLIMIT, g_symbol_1228)) return (FALSE);
   if (ai_8 == 1 || ai_8 == 3)
      if (!glDeleteAllDeferOrders(OP_SELLLIMIT, g_symbol_1228)) return (FALSE);
   if (gi_1504 != 0) {
      l_count_36 = 0;
      l_ord_total_32 = OrdersTotal();
      for (int l_pos_20 = 0; l_pos_20 < l_ord_total_32; l_pos_20++) {
         if (OrderSelect(l_pos_20, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == g_symbol_1228)
               if (myIsOwnOrder()) l_count_36++;
         }
      }
      while (l_count_36 >= gi_1504) {
         ld_56 = 0;
         for (l_pos_20 = 0; l_pos_20 < l_ord_total_32; l_pos_20++) {
            if (OrderSelect(l_pos_20, SELECT_BY_POS, MODE_TRADES)) {
               if (OrderSymbol() == g_symbol_1228) {
                  if (myIsOwnOrder()) {
                     l_cmd_40 = OrderType();
                     if (l_cmd_40 == OP_BUYLIMIT || l_cmd_40 == OP_BUYSTOP) ld_48 = MathAbs(g_ask_1260 - OrderOpenPrice());
                     else {
                        if (!(l_cmd_40 == OP_SELLLIMIT || l_cmd_40 == OP_SELLSTOP)) continue;
                        ld_48 = MathAbs(g_bid_1252 - OrderOpenPrice());
                     }
                     if (ld_48 > ld_56) {
                        ld_56 = ld_48;
                        l_ticket_44 = OrderTicket();
                     }
                  }
               }
            }
         }
         if (ld_56 > MathAbs(ad_0 - ad_12)) {
            if (myOrderDelete(l_ticket_44)) {
               l_count_36--;
               l_ord_total_32 = OrdersTotal();
               continue;
            }
            return (FALSE);
         }
         return (FALSE);
      }
   }
   return (TRUE);
}

bool myCheckDistanceFromOneWayReal(double ad_0, int ai_8, string as_unused_12, double &ad_20) {
   double ld_28;
   if (gia_1668[ai_8] == 0) return (TRUE);
   if (ai_8 == gi_1748 && gi_1328 == 0) return (FALSE);
   if (ai_8 == gi_1752 && gi_1332 == 0) return (FALSE);
   if (ai_8 == gi_1748) {
      ad_20 = gda_1672[ai_8];
      ld_28 = gda_1676[ai_8] * gd_1336 / 100.0;
   } else {
      ad_20 = gda_1676[ai_8];
      ld_28 = gda_1676[ai_8] * gd_1344 / 100.0;
   }
   if (ai_8 == gi_1748) {
      if (ad_0 <= ad_20 - ld_28) return (TRUE);
      return (FALSE);
   }
   if (ad_0 < ad_20 + ld_28) return (FALSE);
   return (TRUE);
}

bool myCheckHighLowLimit(double ad_0, int ai_8, string as_unused_12) {
   for (int l_index_28 = 0; l_index_28 < gi_1412; l_index_28++) {
      switch (l_index_28) {
      case 0:
         gd_1712 = gd_1416;
         break;
      case 1:
         gd_1712 = gd_1432; break;
      
      if (ai_8 == gi_1748 && gda_1704[l_index_28] > 0.0 && ad_0 >= gda_1704[l_index_28] + ad_0 * gd_1712 / 100.0) return (FALSE);
      if (!(ai_8 == gi_1752 && gda_1708[l_index_28] > 0.0 && ad_0 <= gda_1708[l_index_28] - ad_0 * gd_1712 / 100.0)) continue;
      return (FALSE);
   }
   }
   return (TRUE);
}

double myGetLotSize(int ai_0) {
   double ld_ret_4;
   if (gda_1008[ai_0] > 0.0) ld_ret_4 = glDoubleRound(AccountFreeMargin() / 1000.0 * gda_1008[ai_0], gda_1208[ai_0]);
   else ld_ret_4 = gda_1200[ai_0];
   if (ld_ret_4 < gda_1200[ai_0]) ld_ret_4 = gda_1200[ai_0];
   if (ld_ret_4 > gda_1204[ai_0]) ld_ret_4 = gda_1204[ai_0];
   return (ld_ret_4);
}

int myAnalizCurrentStateGeneral() {
   int l_cmd_16;
   double l_ord_open_price_20;
   double l_ord_lots_28;
   string ls_36;
   int l_ord_total_12 = OrdersTotal();
   for (int l_pos_0 = 0; l_pos_0 < gi_1652; l_pos_0++) {
      gda_1660[l_pos_0] = 0;
      gda_1664[l_pos_0] = 0;
   }
   for (l_pos_0 = 0; l_pos_0 < l_ord_total_12; l_pos_0++) {
      if (!OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES)) return (0);
      if (myIsOwnOrder()) {
         l_cmd_16 = OrderType();
         l_ord_open_price_20 = OrderOpenPrice();
         l_ord_lots_28 = OrderLots();
         if (StringLen(OrderSymbol()) == 6) {
            for (int l_count_4 = 0; l_count_4 < 2; l_count_4++) {
               ls_36 = StringSubstr(OrderSymbol(), 3 * l_count_4 + 0, 3);
               for (int l_index_8 = 0; l_index_8 < gi_1652; l_index_8++) {
                  if (gsa_1656[l_index_8] == ls_36) {
                     if ((l_cmd_16 == OP_BUY && l_count_4 == 0) || (l_cmd_16 == OP_SELL && l_count_4 == 1)) {
                        gda_1660[l_index_8] += l_ord_lots_28;
                        break;
                     }
                     if (!((l_cmd_16 == OP_BUY && l_count_4 == 1) || (l_cmd_16 == OP_SELL && l_count_4 == 0))) break;
                     gda_1664[l_index_8] += l_ord_lots_28;
                     break;
                  }
               }
            }
         }
      }
   }
   return (1);
}

int myAnalizCurrentStateSymbol() {
   int l_cmd_16;
   int li_20;
   double l_ord_open_price_24;
   double l_ord_lots_32;
   int l_ord_total_12 = OrdersTotal();
   gi_1684 = FALSE;
   for (int l_pos_0 = 0; l_pos_0 < 6; l_pos_0++) {
      gda_1672[l_pos_0] = -1;
      gda_1676[l_pos_0] = -1;
      gda_1680[l_pos_0] = 0;
      gia_1668[l_pos_0] = 0;
   }
   for (l_pos_0 = 0; l_pos_0 < l_ord_total_12; l_pos_0++) {
      if (!OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES)) return (0);
      if (OrderSymbol() == g_symbol_1228) {
         if (myIsOwnOrder()) {
            l_cmd_16 = OrderType();
            l_ord_open_price_24 = OrderOpenPrice();
            l_ord_lots_32 = OrderLots();
            li_20 = myGetNormalOrderType(l_cmd_16);
            if (li_20 == -1) return (0);
            gia_1668[li_20]++;
            if (gda_1672[li_20] == -1.0 || l_ord_open_price_24 < gda_1672[li_20]) gda_1672[li_20] = l_ord_open_price_24;
            if (gda_1676[li_20] == -1.0 || l_ord_open_price_24 > gda_1676[li_20]) gda_1676[li_20] = l_ord_open_price_24;
            gda_1680[li_20] += l_ord_lots_32;
            if (OrderMagicNumber() == 57320900) gi_1684 = TRUE;
         }
      }
   }
   return (1);
}

int myGetSettingsFromString(string &asa_0[], string as_4, string as_12 = ";", string as_20 = "<def>", string as_28 = "") {
   int li_40;
   string ls_48;
   string l_str_concat_56;
   string ls_64;
   int l_count_44 = 0;
   ArrayResize(asa_0, gi_964);
   for (int l_index_36 = 0; l_index_36 < gi_964; l_index_36++) {
      l_str_concat_56 = StringConcatenate(gsa_968[l_index_36], ":");
      li_40 = StringFind(as_4, l_str_concat_56);
      if (li_40 != -1) ls_48 = as_4;
      else {
         li_40 = StringFind(as_28, l_str_concat_56);
         ls_48 = as_28;
      }
      if (li_40 != -1) {
         ls_64 = StringSubstr(ls_48, li_40 + StringLen(l_str_concat_56));
         li_40 = StringFind(ls_64, as_12);
         if (li_40 != -1) ls_64 = StringSubstr(ls_64, 0, li_40);
         asa_0[l_index_36] = glStringTrimAll(ls_64);
         l_count_44++;
      } else asa_0[l_index_36] = as_20;
   }
   return (l_count_44);
}

bool myCheckAllowWorking() {
   if (gi_1516) return (FALSE);
   if (!IsTradeAllowed()) return (FALSE);
   return (TRUE);
}

int myControlOpenOrdersSymbol() {
   int l_ord_total_12;
   int li_16;
   int li_20;
   int l_cmd_24;
   int l_magic_28;
   double l_ord_open_price_32;
   double l_ord_stoploss_40;
   double l_price_48;
   double l_str2dbl_56;
   double l_str2dbl_64;
   double ld_72;
   string ls_80;
   if (gi_912 == 1) {
      l_ord_total_12 = OrdersTotal();
      for (int l_pos_0 = 0; l_pos_0 < l_ord_total_12; l_pos_0++) {
         OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES);
         if (myIsOwnOrder()) {
            if (OrderStopLoss() == 0.0 && OrderTakeProfit() == 0.0) {
               ls_80 = OrderComment();
               li_16 = StringFind(ls_80, "{TP=");
               if (li_16 != -1) {
                  li_20 = StringFind(ls_80, "}", li_16);
                  if (li_20 != -1) {
                     l_str2dbl_56 = StrToDouble(StringSubstr(ls_80, li_16 + 4, li_20 - li_16 - 4));
                     li_16 = StringFind(ls_80, "{SL=");
                     if (li_16 != -1) {
                        li_20 = StringFind(ls_80, "}", li_16);
                        if (li_20 != -1) {
                           l_str2dbl_64 = StrToDouble(StringSubstr(ls_80, li_16 + 4, li_20 - li_16 - 4));
                           OrderModify(OrderTicket(), OrderOpenPrice(), l_str2dbl_64, l_str2dbl_56, 0);
                        }
                     }
                  }
               }
            }
         }
      }
   }
   if (gi_1292 > 0) {
      l_ord_total_12 = OrdersTotal();
      for (l_pos_0 = l_ord_total_12 - 1; l_pos_0 >= 0; l_pos_0--) {
         OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() == g_symbol_1228) {
            if (myIsOwnOrder()) {
               if (OrderType() == OP_BUY || OrderType() == OP_SELL)
                  if (TimeCurrent() - OrderOpenTime() > 60 * gi_1292) glOrderClose();
            }
         }
      }
   }
   if (gia_1668[gi_1748] != 0 && gia_1668[gi_1756] != 0) glDeleteAllDeferOrders(gi_1756, g_symbol_1228);
   if (gia_1668[gi_1752] != 0 && gia_1668[gi_1760] != 0) glDeleteAllDeferOrders(gi_1760, g_symbol_1228);
   if (gia_1668[gi_1748] != 0 && gia_1668[gi_1764] != 0 && gda_1676[gi_1764] >= gda_1672[gi_1748]) glDeleteAllDeferOrders(gi_1764, g_symbol_1228, gda_1672[gi_1748], 0);
   if (gia_1668[gi_1752] != 0 && gia_1668[gi_1768] != 0 && gda_1672[gi_1768] <= gda_1676[gi_1752]) glDeleteAllDeferOrders(gi_1768, g_symbol_1228, 0, gda_1676[gi_1752]);
   if (gia_1668[gi_1748] != 0 && gia_1668[gi_1752] != 0) {
      if ((gi_1296 != 0 && gi_1296 != gi_1276 || gi_1296 != gi_1280) || (gi_1300 != 0 && gi_1300 != gi_1284 || gi_1300 != gi_1288)) {
         ld_72 = (g_ask_1260 + g_bid_1252) / 2.0;
         l_ord_total_12 = OrdersTotal();
         for (l_pos_0 = 0; l_pos_0 < l_ord_total_12; l_pos_0++) {
            if (!OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES)) return (0);
            if (OrderSymbol() == g_symbol_1228) {
               if (myIsOwnOrder()) {
                  l_cmd_24 = OrderType();
                  l_ord_open_price_32 = OrderOpenPrice();
                  l_price_48 = OrderTakeProfit();
                  l_ord_stoploss_40 = OrderStopLoss();
                  l_magic_28 = OrderMagicNumber();
                  if (l_magic_28 != 57320100) {
                     if (l_cmd_24 == OP_BUY && l_ord_open_price_32 == gda_1672[gi_1748]) {
                        if (l_price_48 < l_ord_open_price_32 + gi_1296 * gd_1236)
                           if (OrderModify(OrderTicket(), l_ord_open_price_32, l_ord_stoploss_40, l_ord_open_price_32 + gi_1296 * gd_1236, 0)) l_price_48 = l_ord_open_price_32 + gi_1296 * gd_1236;
                        if (gi_1300 != 0 && l_ord_open_price_32 > gda_1676[gi_1752] && l_ord_open_price_32 - gda_1676[gi_1752] > 2.2 * gi_1300 * gd_1236 && MathAbs(l_ord_open_price_32 - ld_72) < MathAbs(gda_1676[gi_1752] - ld_72) &&
                           l_ord_stoploss_40 < l_ord_open_price_32 - gi_1300 * gd_1236)
                           if (OrderModify(OrderTicket(), l_ord_open_price_32, l_ord_open_price_32 - gi_1300 * gd_1236, l_price_48, 0)) l_ord_stoploss_40 = l_ord_open_price_32 - gi_1300 * gd_1236;
                     } else {
                        if (l_cmd_24 == OP_SELL && l_ord_open_price_32 == gda_1676[gi_1752]) {
                           if (l_price_48 > l_ord_open_price_32 - gi_1296 * gd_1236)
                              if (OrderModify(OrderTicket(), l_ord_open_price_32, l_ord_stoploss_40, l_ord_open_price_32 - gi_1296 * gd_1236, 0)) l_price_48 = l_ord_open_price_32 - gi_1296 * gd_1236;
                           if (gi_1300 != 0 && l_ord_open_price_32 < gda_1672[gi_1748] && gda_1672[gi_1748] - l_ord_open_price_32 > 2.2 * gi_1300 * gd_1236 && MathAbs(l_ord_open_price_32 - ld_72) < MathAbs(gda_1672[gi_1748] - ld_72) &&
                              l_ord_stoploss_40 > l_ord_open_price_32 + gi_1300 * gd_1236)
                              if (OrderModify(OrderTicket(), l_ord_open_price_32, l_ord_open_price_32 + gi_1300 * gd_1236, l_price_48, 0)) l_ord_stoploss_40 = l_ord_open_price_32 + gi_1300 * gd_1236;
                        }
                     }
                  }
               }
            }
         }
      }
   }
   if (gi_1360 == 1 && gd_1696 != 0.0) {
      if (gd_1696 > 0.0) glDeleteAllDeferOrders(gi_1760, g_symbol_1228);
      if (gd_1696 < 0.0) glDeleteAllDeferOrders(gi_1756, g_symbol_1228);
   }
   if (gi_1376 == 1 && gd_1688 != 0.0) {
      if (gd_1688 > 0.0 && gia_1668[gi_1760] > 0 && gda_1672[gi_1760] < g_bid_1252 + 20.0 * gd_1236) glDeleteAllDeferOrders(gi_1760, g_symbol_1228);
      if (gd_1688 < 0.0 && gia_1668[gi_1756] > 0 && gda_1676[gi_1756] > g_ask_1260 - 20.0 * gd_1236) glDeleteAllDeferOrders(gi_1756, g_symbol_1228);
   }
   if (gi_1412 > 0) {
      for (int l_index_8 = 0; l_index_8 < gi_1412; l_index_8++) {
         switch (l_index_8) {
         case 0:
            gd_1712 = gd_1416;
            break;
         case 1:
            gd_1712 = gd_1432; break;
         
         if (gia_1668[gi_1764] != 0 && gda_1704[l_index_8] > 0.0 && gda_1676[gi_1764] >= gda_1704[l_index_8] + gda_1704[l_index_8] * gd_1712 / 100.0) glDeleteAllDeferOrders(gi_1764, g_symbol_1228, gda_1704[l_index_8] + gda_1704[l_index_8] * gd_1712 / 100.0, 0);
         if (!(gia_1668[gi_1768] != 0 && gda_1708[l_index_8] > 0.0 && gda_1672[gi_1768] <= gda_1708[l_index_8] - gda_1708[l_index_8] * gd_1712 / 100.0)) continue;
         glDeleteAllDeferOrders(gi_1768, g_symbol_1228, 0, gda_1708[l_index_8] - gda_1708[l_index_8] * gd_1712 / 100.0);
      }
      }
   }
   l_ord_total_12 = OrdersTotal();
   if (gi_1304 > 0) {
      for (l_pos_0 = 0; l_pos_0 < l_ord_total_12; l_pos_0++) {
         OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() == g_symbol_1228) {
            if (myIsOwnOrder()) {
               if (OrderType() == OP_BUY) {
                  if (g_bid_1252 > OrderOpenPrice() + gd_1236 * gi_1304)
                     if (OrderStopLoss() == 0.0 || OrderStopLoss() < g_bid_1252 - gd_1236 * (gi_1304 + gi_1308)) OrderModify(OrderTicket(), OrderOpenPrice(), g_bid_1252 - gd_1236 * gi_1304, OrderTakeProfit(), 0);
               } else {
                  if (OrderType() == OP_SELL) {
                     if (g_ask_1260 < OrderOpenPrice() - gd_1236 * gi_1304)
                        if (OrderStopLoss() == 0.0 || OrderStopLoss() > g_ask_1260 + gd_1236 * (gi_1304 + gi_1308)) OrderModify(OrderTicket(), OrderOpenPrice(), g_ask_1260 + gd_1236 * gi_1304, OrderTakeProfit(), 0);
                  }
               }
            }
         }
      }
   }
   return (0);
}

void myCalculateIndicators() {
   gd_1696 = 0;
   if (gi_1360 == 1) myIndicator_Accelerator();
   gd_1688 = 0;
   if (gi_1376 == 1) myIndicator_Speed();
   if (gi_1412 > 0) myIndicator_HighLowLimit();
   if (gi_1448 == 1) myIndicator_Flat();
}

void myIndicator_Accelerator() {
   double lda_0[10][10];
   int lia_4[10];
   for (int l_index_8 = 0; l_index_8 < gi_1368; l_index_8++) {
      for (int li_12 = 0; li_12 < gi_1364; li_12++) lda_0[l_index_8][li_12] = iAC(g_symbol_1228, gia_1772[gi_1372 + l_index_8], li_12);
      if (lda_0[l_index_8][gi_1364 - 2] > lda_0[l_index_8][gi_1364 - 1]) lia_4[l_index_8] = 1;
      else {
         if (lda_0[l_index_8][gi_1364 - 2] < lda_0[l_index_8][gi_1364 - 1]) lia_4[l_index_8] = -1;
         else {
            lia_4[l_index_8] = 0;
            break;
         }
      }
      for (li_12 = gi_1364 - 3; li_12 >= 0; li_12--) {
         if (lia_4[l_index_8] == 1 && lda_0[l_index_8][li_12] <= lda_0[l_index_8][li_12 + 1]) {
            lia_4[l_index_8] = 0;
            break;
         }
         if (lia_4[l_index_8] == -1 && lda_0[l_index_8][li_12] >= lda_0[l_index_8][li_12 + 1]) {
            lia_4[l_index_8] = 0;
            break;
         }
      }
   }
   gd_1696 = lia_4[0];
   for (l_index_8 = 1; l_index_8 < gi_1368; l_index_8++) {
      if (lia_4[l_index_8] != gd_1696) {
         gd_1696 = 0;
         break;
      }
   }
   if (gd_1696 != 0.0) gd_1696 = lda_0[0][0] - lda_0[0][1];
}

void myIndicator_Speed() {
   double lda_0[10][10];
   int lia_4[10];
   double ld_8;
   double ld_16;
   for (int l_index_24 = 0; l_index_24 < gi_1384; l_index_24++) {
      for (int l_count_28 = 0; l_count_28 < gi_1380; l_count_28++) {
         ld_8 = (iHigh(g_symbol_1228, gia_1772[gi_1388 + l_index_24], l_count_28 + 2) + iLow(g_symbol_1228, gia_1772[gi_1388 + l_index_24], l_count_28 + 2) + 2.0 * iClose(g_symbol_1228, gia_1772[gi_1388 +
            l_index_24], l_count_28 + 2)) / 4.0;
         ld_16 = (iHigh(g_symbol_1228, gia_1772[gi_1388 + l_index_24], l_count_28 + 1) + iLow(g_symbol_1228, gia_1772[gi_1388 + l_index_24], l_count_28 + 1) + 2.0 * iClose(g_symbol_1228, gia_1772[gi_1388 +
            l_index_24], l_count_28 + 1)) / 4.0;
         if (ld_8 > 0.0) lda_0[l_index_24][l_count_28] = (ld_16 - ld_8) / ld_8;
         else lda_0[l_index_24][l_count_28] = 0;
      }
      if (l_index_24 == 0 && gi_1388 == 0) {
         if (g_bid_1252 > iOpen(g_symbol_1228, gia_1772[0], 0)) lia_4[0] = 1;
         else {
            if (g_bid_1252 < iOpen(g_symbol_1228, gia_1772[0], 0)) lia_4[0] = -1;
            else {
               if (lda_0[l_index_24][0] > 0.0) lia_4[l_index_24] = 1;
               else {
                  if (lda_0[l_index_24][0] < 0.0) lia_4[l_index_24] = -1;
                  else {
                     lia_4[l_index_24] = 0;
                     break;
                  }
               }
            }
         }
      } else {
         if (iOpen(g_symbol_1228, gia_1772[gi_1388 + l_index_24], 0) > iClose(g_symbol_1228, gia_1772[gi_1388 + l_index_24], 1)) lia_4[l_index_24] = 1;
         else {
            if (iOpen(g_symbol_1228, gia_1772[gi_1388 + l_index_24], 0) < iClose(g_symbol_1228, gia_1772[gi_1388 + l_index_24], 1)) lia_4[l_index_24] = -1;
            else {
               if (lda_0[l_index_24][0] > 0.0) lia_4[l_index_24] = 1;
               else {
                  if (lda_0[l_index_24][0] < 0.0) lia_4[l_index_24] = -1;
                  else {
                     lia_4[l_index_24] = 0;
                     break;
                  }
               }
            }
         }
      }
      if ((lda_0[l_index_24][gi_1380 - 1]) * lia_4[l_index_24] <= 0.0) {
         lia_4[l_index_24] = 0;
         break;
      }
      for (l_count_28 = gi_1380 - 2; l_count_28 >= 0; l_count_28--) {
         if (lia_4[l_index_24] == 1 && lda_0[l_index_24][l_count_28] <= lda_0[l_index_24][l_count_28 + 1]) {
            lia_4[l_index_24] = 0;
            break;
         }
         if (lia_4[l_index_24] == -1 && lda_0[l_index_24][l_count_28] >= lda_0[l_index_24][l_count_28 + 1]) {
            lia_4[l_index_24] = 0;
            break;
         }
      }
   }
   gd_1688 = lia_4[0];
   for (l_index_24 = 1; l_index_24 < gi_1384; l_index_24++) {
      if (lia_4[l_index_24] != gd_1688) {
         gd_1688 = 0;
         break;
      }
   }
   if (gd_1688 != 0.0) {
      ld_8 = iOpen(g_symbol_1228, gia_1772[0], 0);
      ld_16 = g_bid_1252;
      if (gi_1388 == 0 && ld_8 != ld_16 && ld_8 > 0.0) {
         gd_1688 = (ld_16 - ld_8) / ld_8;
         return;
      }
      gd_1688 = lda_0[0][0];
   }
}

void myIndicator_HighLowLimit() {
   int li_0;
   int li_4;
   double l_ilow_20;
   double l_ihigh_28;
   for (int l_index_16 = 0; l_index_16 < gi_1412; l_index_16++) {
      gda_1704[l_index_16] = 0;
      gda_1708[l_index_16] = 0;
      switch (l_index_16) {
      case 0:
         li_4 = gi_1424;
         li_0 = gi_1428;
         break;
      case 1:
         li_4 = gi_1440;
         li_0 = gi_1444;
          break;
      
      for (int li_8 = 0; li_8 < li_0; li_8++) {
         l_ilow_20 = iLow(g_symbol_1228, gia_1772[li_4], li_8);
         l_ihigh_28 = iHigh(g_symbol_1228, gia_1772[li_4], li_8);
         if (l_ilow_20 > 0.0)
            if (gda_1704[l_index_16] == 0.0 || l_ilow_20 < gda_1704[l_index_16]) gda_1704[l_index_16] = l_ilow_20;
         if (l_ihigh_28 > 0.0)
            if (gda_1708[l_index_16] == 0.0 || l_ihigh_28 > gda_1708[l_index_16]) gda_1708[l_index_16] = l_ihigh_28;
      }}
  
   }
}

void myIndicator_Flat() {
   double l_ilow_0;
   double l_ihigh_8;
   int l_count_16;
   int l_count_20;
   int li_24;
   gi_1720 = FALSE;
   g_ilow_1724 = 0;
   g_ihigh_1732 = 0;
   gd_1740 = 0;
   for (int li_28 = 0; li_28 < gi_1468; li_28++) {
      l_ilow_0 = iLow(g_symbol_1228, gia_1772[gi_1464], li_28);
      l_ihigh_8 = iHigh(g_symbol_1228, gia_1772[gi_1464], li_28);
      if (l_ilow_0 > 0.0)
         if (g_ilow_1724 == 0.0 || l_ilow_0 < g_ilow_1724) g_ilow_1724 = l_ilow_0;
      if (l_ihigh_8 > 0.0)
         if (g_ihigh_1732 == 0.0 || l_ihigh_8 > g_ihigh_1732) g_ihigh_1732 = l_ihigh_8;
   }
   gd_1740 = g_ihigh_1732 - g_ilow_1724;
   if (g_ihigh_1732 > 0.0 && g_ilow_1724 > 0.0 && gd_1740 >= gi_1452 * gd_1236 && gd_1740 <= gi_1456 * gd_1236) {
      l_count_16 = 0;
      l_count_20 = 0;
      li_24 = 0;
      for (li_28 = 0; li_28 < gi_1468; li_28++) {
         l_ilow_0 = iLow(g_symbol_1228, gia_1772[gi_1464], li_28);
         l_ihigh_8 = iHigh(g_symbol_1228, gia_1772[gi_1464], li_28);
         if (l_ilow_0 > 0.0 && l_ilow_0 < g_ilow_1724 + gd_1740 / 4.0 && li_24 >= 0) {
            li_24 = -1;
            l_count_16++;
         }
         if (l_ihigh_8 > 0.0 && l_ihigh_8 > g_ihigh_1732 - gd_1740 / 4.0 && li_24 <= 0) {
            li_24 = 1;
            l_count_20++;
         }
      }
      if (l_count_16 >= gi_1460 && l_count_20 >= gi_1460) gi_1720 = TRUE;
   }
}

bool myIsOwnOrder(int a_magic_0 = -1) {
   if (a_magic_0 == -1) a_magic_0 = OrderMagicNumber();
   string l_magic_4 = a_magic_0;
   if (StringFind(l_magic_4, "5732", 0) == 0) return (TRUE);
   return (FALSE);
}

int myGetNormalOrderType(int ai_0) {
   switch (ai_0) {
   case 0:
      return (gi_1748);
   case 1:
      return (gi_1752);
   case 2:
      return (gi_1756);
   case 4:
      return (gi_1764);
   case 3:
      return (gi_1760);
   case 5:
      return (gi_1768);
   }
   return (-1);
}

int myOrderSend(string a_symbol_0, int a_cmd_8, double a_lots_12, double a_price_20, int a_slippage_28, double ad_32, double ad_40, string as_48 = "", int a_magic_56 = 0, int a_datetime_60 = 0, color a_color_64 = -1) {
   double l_price_72;
   double l_price_80;
   string l_str_concat_88 = StringConcatenate(gs_gepard__948, as_48);
   if (gi_912 == 1) {
      l_price_80 = 0;
      l_price_72 = 0;
      l_str_concat_88 = StringConcatenate(l_str_concat_88, " {TP=", ad_40, "} {SL=", ad_32, "}");
   } else {
      l_price_80 = ad_40;
      l_price_72 = ad_32;
   }
   int l_ticket_68 = OrderSend(a_symbol_0, a_cmd_8, a_lots_12, a_price_20, a_slippage_28, l_price_72, l_price_80, l_str_concat_88, a_magic_56, a_datetime_60, a_color_64);
   if (l_ticket_68 > 0)
      if (OrderSelect(l_ticket_68, SELECT_BY_TICKET, MODE_TRADES)) return (1);
   return (0);
}

bool myOrderDelete(int a_ticket_0) {
   int l_ord_delete_4;
   l_ord_delete_4 = OrderDelete(a_ticket_0);
   return (l_ord_delete_4);
}

void myGetSymbolSettingsDay() {
   for (int l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      gda_980[l_index_0] = MarketInfo(gsa_968[l_index_0], MODE_SWAPLONG);
      gda_984[l_index_0] = MarketInfo(gsa_968[l_index_0], MODE_SWAPSHORT);
   }
   g_day_1520 = Day();
}

void GetSymbolsSettingsFromStrings() {
   string lsa_4[];
   ArrayResize(gia_988, gi_964);
   myGetSettingsFromString(lsa_4, gs_96);
   for (int l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_988[l_index_0] = gi_92;
      else gia_988[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_992, gi_964);
   myGetSettingsFromString(lsa_4, gs_104);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_992[l_index_0] = 1;
      else gia_992[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_996, gi_964);
   myGetSettingsFromString(lsa_4, gs_112);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_996[l_index_0] = 1;
      else gia_996[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1028, gi_964);
   myGetSettingsFromString(lsa_4, gs_256);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1028[l_index_0] = gi_252;
      else gia_1028[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1012, gi_964);
   myGetSettingsFromString(lsa_4, gs_196);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1012[l_index_0] = gi_192;
      else gia_1012[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1012[l_index_0] != 0) gia_1012[l_index_0] = MathMax(MarketInfo(gsa_968[l_index_0], MODE_STOPLEVEL), gia_1012[l_index_0]);
   }
   ArrayResize(gia_1016, gi_964);
   myGetSettingsFromString(lsa_4, gs_208);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1016[l_index_0] = gi_204;
      else gia_1016[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1016[l_index_0] != 0) gia_1016[l_index_0] = MathMax(MarketInfo(gsa_968[l_index_0], MODE_STOPLEVEL), gia_1016[l_index_0]);
   }
   ArrayResize(gia_1020, gi_964);
   myGetSettingsFromString(lsa_4, gs_232);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1020[l_index_0] = gi_228;
      else gia_1020[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1020[l_index_0] != 0) gia_1020[l_index_0] = MathMax(MarketInfo(gsa_968[l_index_0], MODE_STOPLEVEL), gia_1020[l_index_0]);
   }
   ArrayResize(gia_1024, gi_964);
   myGetSettingsFromString(lsa_4, gs_244);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1024[l_index_0] = gi_240;
      else gia_1024[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1024[l_index_0] != 0) gia_1024[l_index_0] = MathMax(MarketInfo(gsa_968[l_index_0], MODE_STOPLEVEL), gia_1024[l_index_0]);
   }
   ArrayResize(gia_1032, gi_964);
   myGetSettingsFromString(lsa_4, gs_268);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1032[l_index_0] = gi_264;
      else gia_1032[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1032[l_index_0] != 0) gia_1032[l_index_0] = MathMax(MarketInfo(gsa_968[l_index_0], MODE_STOPLEVEL), gia_1032[l_index_0]);
   }
   ArrayResize(gia_1036, gi_964);
   myGetSettingsFromString(lsa_4, gs_280);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1036[l_index_0] = gi_276;
      else gia_1036[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1036[l_index_0] != 0) gia_1036[l_index_0] = MathMax(MarketInfo(gsa_968[l_index_0], MODE_STOPLEVEL), gia_1036[l_index_0]);
   }
   ArrayResize(gia_1040, gi_964);
   myGetSettingsFromString(lsa_4, gs_292);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1040[l_index_0] = gi_288;
      else gia_1040[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1040[l_index_0] != 0) gia_1040[l_index_0] = MathMax(MarketInfo(gsa_968[l_index_0], MODE_STOPLEVEL), gia_1040[l_index_0]);
   }
   ArrayResize(gia_1044, gi_964);
   myGetSettingsFromString(lsa_4, gs_304);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1044[l_index_0] = gi_300;
      else gia_1044[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1044[l_index_0] < 0) gia_1044[l_index_0] = 0;
   }
   ArrayResize(gia_1048, gi_964);
   myGetSettingsFromString(lsa_4, gs_396);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1048[l_index_0] = gi_392;
      else gia_1048[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1052, gi_964);
   myGetSettingsFromString(lsa_4, gs_408);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1052[l_index_0] = gi_404;
      else gia_1052[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1052[l_index_0] > 100) gia_1052[l_index_0] = -1;
   }
   ArrayResize(gia_1056, gi_964);
   myGetSettingsFromString(lsa_4, gs_420);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1056[l_index_0] = gi_416;
      else gia_1056[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1056[l_index_0] > 100) gia_1056[l_index_0] = -1;
   }
   ArrayResize(gia_1060, gi_964);
   myGetSettingsFromString(lsa_4, gs_432);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1060[l_index_0] = gi_428;
      else gia_1060[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1060[l_index_0] > 100) gia_1060[l_index_0] = -1;
   }
   ArrayResize(gia_1064, gi_964);
   myGetSettingsFromString(lsa_4, gs_444);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1064[l_index_0] = gi_440;
      else gia_1064[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1064[l_index_0] > 100) gia_1064[l_index_0] = -1;
   }
   ArrayResize(gia_1068, gi_964);
   myGetSettingsFromString(lsa_4, gs_316);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1068[l_index_0] = gi_312;
      else gia_1068[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1072, gi_964);
   myGetSettingsFromString(lsa_4, gs_328);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1072[l_index_0] = gi_324;
      else gia_1072[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gda_1076, gi_964);
   myGetSettingsFromString(lsa_4, sMinDistanceRealOrdersB_PR);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1076[l_index_0] = dMinDistanceRealOrdersB_PR;
      else gda_1076[l_index_0] = StrToDouble(lsa_4[l_index_0]);
   }
   ArrayResize(gda_1080, gi_964);
   myGetSettingsFromString(lsa_4, sMinDistanceRealOrdersS_PR);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1080[l_index_0] = dMinDistanceRealOrdersS_PR;
      else gda_1080[l_index_0] = StrToDouble(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1084, gi_964);
   myGetSettingsFromString(lsa_4, gs_372);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1084[l_index_0] = gi_368;
      else gia_1084[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1088, gi_964);
   myGetSettingsFromString(lsa_4, gs_384);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1088[l_index_0] = gi_380;
      else gia_1088[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1092, gi_964);
   myGetSettingsFromString(lsa_4, gs_516);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1092[l_index_0] = gi_512;
      else gia_1092[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1096, gi_964);
   myGetSettingsFromString(lsa_4, gs_528);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1096[l_index_0] = gi_524;
      else gia_1096[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1096[l_index_0] < 2) gia_1096[l_index_0] = 2;
      if (gia_1096[l_index_0] > 10) gia_1096[l_index_0] = 10;
   }
   ArrayResize(gia_1100, gi_964);
   myGetSettingsFromString(lsa_4, gs_540);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1100[l_index_0] = gi_536;
      else gia_1100[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1100[l_index_0] < 1) gia_1100[l_index_0] = 1;
      if (gia_1100[l_index_0] > 5) gia_1100[l_index_0] = 5;
   }
   ArrayResize(gia_1104, gi_964);
   myGetSettingsFromString(lsa_4, gs_552);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1104[l_index_0] = gi_548;
      else gia_1104[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1108, gi_964);
   myGetSettingsFromString(lsa_4, gs_564);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1108[l_index_0] = gi_560;
      else gia_1108[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1112, gi_964);
   myGetSettingsFromString(lsa_4, gs_576);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1112[l_index_0] = gi_572;
      else gia_1112[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1112[l_index_0] < 2) gia_1112[l_index_0] = 2;
      if (gia_1112[l_index_0] > 10) gia_1112[l_index_0] = 10;
   }
   ArrayResize(gia_1116, gi_964);
   myGetSettingsFromString(lsa_4, gs_588);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1116[l_index_0] = gi_584;
      else gia_1116[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1116[l_index_0] < 1) gia_1116[l_index_0] = 1;
      if (gia_1116[l_index_0] > 5) gia_1116[l_index_0] = 5;
   }
   ArrayResize(gia_1120, gi_964);
   myGetSettingsFromString(lsa_4, gs_600);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1120[l_index_0] = gi_596;
      else gia_1120[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1124, gi_964);
   myGetSettingsFromString(lsa_4, gs_612);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1124[l_index_0] = gi_608;
      else gia_1124[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gda_1128, gi_964);
   myGetSettingsFromString(lsa_4, gs_628);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1128[l_index_0] = gd_620;
      else gda_1128[l_index_0] = StrToDouble(lsa_4[l_index_0]);
   }
   ArrayResize(gda_1132, gi_964);
   myGetSettingsFromString(lsa_4, gs_640);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1132[l_index_0] = gi_636;
      else gda_1132[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gda_1136, gi_964);
   myGetSettingsFromString(lsa_4, gs_652);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1136[l_index_0] = gi_648;
      else gda_1136[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gda_1136[l_index_0] != 0.0) gda_1136[l_index_0] = MathMax(MarketInfo(gsa_968[l_index_0], MODE_STOPLEVEL), gda_1136[l_index_0]);
   }
   ArrayResize(gia_1140, gi_964);
   myGetSettingsFromString(lsa_4, sCountHighLowLimits);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1140[l_index_0] = dCountHighLowLimits;
      else gia_1140[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1140[l_index_0] > 2) gia_1140[l_index_0] = 2;
   }
   ArrayResize(gda_1144, gi_964);
   myGetSettingsFromString(lsa_4, siHL_LimitDistance1_PR);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1144[l_index_0] = diHL_LimitDistance1_PR;
      else gda_1144[l_index_0] = StrToDouble(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1148, gi_964);
   myGetSettingsFromString(lsa_4, siHL_Period1);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1148[l_index_0] = diHL_Period1;
      else gia_1148[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1152, gi_964);
   myGetSettingsFromString(lsa_4, siHL_CountBars1);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1152[l_index_0] = diHL_CountBars1;
      else gia_1152[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gda_1156, gi_964);
   myGetSettingsFromString(lsa_4, siHL_LimitDistance2_PR);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1156[l_index_0] = diHL_LimitDistance2_PR;
      else gda_1156[l_index_0] = StrToDouble(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1160, gi_964);
   myGetSettingsFromString(lsa_4, siHL_Period2);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1160[l_index_0] = diHL_Period2;
      else gia_1160[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1164, gi_964);
   myGetSettingsFromString(lsa_4, siHL_CountBars2);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1164[l_index_0] = diHL_CountBars2;
      else gia_1164[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1168, gi_964);
   myGetSettingsFromString(lsa_4, sUseFlatIndicator);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1168[l_index_0] = dUseFlatIndicator;
      else gia_1168[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1172, gi_964);
   myGetSettingsFromString(lsa_4, gs_768);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1172[l_index_0] = gi_764;
      else gia_1172[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1176, gi_964);
   myGetSettingsFromString(lsa_4, gs_780);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1176[l_index_0] = gi_776;
      else gia_1176[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1180, gi_964);
   myGetSettingsFromString(lsa_4, siFL_MinExtremumsCount);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1180[l_index_0] = diFL_MinExtremumsCount;
      else gia_1180[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1184, gi_964);
   myGetSettingsFromString(lsa_4, siFL_Period);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1184[l_index_0] = diFL_Period;
      else gia_1184[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1188, gi_964);
   myGetSettingsFromString(lsa_4, siFL_CountBars);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1188[l_index_0] = diFL_CountBars;
      else gia_1188[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1192, gi_964);
   myGetSettingsFromString(lsa_4, siFL_StopLoss);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1192[l_index_0] = diFL_StopLoss;
      else gia_1192[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1192[l_index_0] != 0) gia_1192[l_index_0] = MathMax(MarketInfo(gsa_968[l_index_0], MODE_STOPLEVEL), gia_1192[l_index_0]);
   }
   ArrayResize(gda_1196, gi_964);
   myGetSettingsFromString(lsa_4, gs_844);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1196[l_index_0] = gd_836;
      else gda_1196[l_index_0] = StrToDouble(lsa_4[l_index_0]);
   }
   ArrayResize(gda_1008, gi_964);
   myGetSettingsFromString(lsa_4, sRisk);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1008[l_index_0] = dRisk;
      else gda_1008[l_index_0] = StrToDouble(lsa_4[l_index_0]);
   }
   ArrayResize(gda_1200, gi_964);
   myGetSettingsFromString(lsa_4, sMinLotSize);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1200[l_index_0] = dMinLotSize;
      else gda_1200[l_index_0] = StrToDouble(lsa_4[l_index_0]);
      if (gda_1200[l_index_0] != 0.0) gda_1200[l_index_0] = MathMax(MarketInfo(gsa_968[l_index_0], MODE_MINLOT), gda_1200[l_index_0]);
      else gda_1200[l_index_0] = MarketInfo(gsa_968[l_index_0], MODE_MINLOT);
   }
   ArrayResize(gda_1204, gi_964);
   myGetSettingsFromString(lsa_4, sMaxLotSize);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1204[l_index_0] = dMaxLotSize;
      else gda_1204[l_index_0] = StrToDouble(lsa_4[l_index_0]);
      if (gda_1204[l_index_0] != 0.0) gda_1204[l_index_0] = MathMin(MarketInfo(gsa_968[l_index_0], MODE_MAXLOT), gda_1204[l_index_0]);
      else gda_1204[l_index_0] = MarketInfo(gsa_968[l_index_0], MODE_MAXLOT);
   }
   ArrayResize(gda_1208, gi_964);
   myGetSettingsFromString(lsa_4, sStepLotSize);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1208[l_index_0] = dStepLotSize;
      else gda_1208[l_index_0] = StrToDouble(lsa_4[l_index_0]);
      if (gda_1208[l_index_0] != 0.0) gda_1208[l_index_0] = MathMax(MarketInfo(gsa_968[l_index_0], MODE_LOTSTEP), gda_1208[l_index_0]);
      else gda_1208[l_index_0] = MarketInfo(gsa_968[l_index_0], MODE_LOTSTEP);
   }
   ArrayResize(gia_1212, gi_964);
   myGetSettingsFromString(lsa_4, gs_904);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1212[l_index_0] = gi_900;
      else gia_1212[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gda_1000, gi_964);
   myGetSettingsFromString(lsa_4, gs_120, ";", "<def>", gs_128);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1000[l_index_0] = 0;
      else gda_1000[l_index_0] = StrToDouble(lsa_4[l_index_0]);
   }
   ArrayResize(gda_1004, gi_964);
   myGetSettingsFromString(lsa_4, gs_136, ";", "<def>", gs_144);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1004[l_index_0] = 0;
      else gda_1004[l_index_0] = StrToDouble(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1216, gi_964);
   myGetSettingsFromString(lsa_4, sMaxSymbolOrdersCount);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1216[l_index_0] = dMaxSymbolOrdersCount;
      else gia_1216[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1220, gi_964);
   myGetSettingsFromString(lsa_4, gs_920);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1220[l_index_0] = gi_916;
      else gia_1220[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1224, gi_964);
   myGetSettingsFromString(lsa_4, gs_932);
   for (l_index_0 = 0; l_index_0 < gi_964; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1224[l_index_0] = gi_928;
      else gia_1224[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
}

double glGetCurrentClosePrice() {
   double l_price_0;
   if (OrderSymbol() == Symbol()) {
      if (OrderType() == OP_BUY) l_price_0 = Bid;
      else l_price_0 = Ask;
   } else {
      if (OrderType() == OP_BUY) l_price_0 = MarketInfo(OrderSymbol(), MODE_BID);
      else l_price_0 = MarketInfo(OrderSymbol(), MODE_ASK);
   }
   return (l_price_0);
}

int glOrderClose(double a_price_0 = -1.0, double a_slippage_8 = 0.0) {
   int l_error_32;
   bool li_ret_36 = FALSE;
   if (a_price_0 == -1.0) a_price_0 = glGetCurrentClosePrice();
   for (int l_count_16 = 0; l_count_16 < 5; l_count_16++) {
      if (OrderClose(OrderTicket(), OrderLots(), a_price_0, a_slippage_8)) {
         li_ret_36 = TRUE;
         break;
      }
      l_error_32 = GetLastError();
      if (l_error_32 > 4000/* NO_MQLERROR */) break;
      Sleep(1000);
      RefreshRates();
      a_price_0 = glGetCurrentClosePrice();
   }
   return (li_ret_36);
}

bool glDeleteAllDeferOrders(int a_cmd_0 = -1, string a_symbol_4 = "", double ad_12 = 0.0, double ad_20 = 0.0, bool ai_28 = TRUE) {
   int l_cmd_48;
   double l_ord_open_price_52;
   bool li_ret_60 = TRUE;
   int l_ord_total_44 = OrdersTotal();
   for (int l_pos_32 = l_ord_total_44 - 1; l_pos_32 >= 0; l_pos_32--) {
      if (OrderSelect(l_pos_32, SELECT_BY_POS, MODE_TRADES)) {
         l_cmd_48 = OrderType();
         l_ord_open_price_52 = OrderOpenPrice();
         if (a_cmd_0 == -1 || l_cmd_48 == a_cmd_0 && a_symbol_4 == "" || OrderSymbol() == a_symbol_4) {
            if (ai_28)
               if (!(myIsOwnOrder())) continue;
            if (a_cmd_0 == -1)
               if (l_cmd_48 == OP_BUY || l_cmd_48 == OP_SELL) continue;
            if (ad_12 != 0.0 && l_ord_open_price_52 < ad_12) continue;
            if (ad_20 != 0.0 && l_ord_open_price_52 > ad_20) continue;
            if (!myOrderDelete(OrderTicket())) li_ret_60 = FALSE;
         }
      } else li_ret_60 = FALSE;
   }
   return (li_ret_60);
}

double glDoubleRound(double ad_0, double ad_8) {
   int li_20 = 1;
   if (ad_8 == 0.0) return (ad_0);
   while (ad_8 * li_20 < 1.0) li_20 = 10 * li_20;
   int li_16 = ad_8 * li_20;
   double ld_24 = MathFloor(ad_0 * li_20);
   if (MathAbs(ad_0 * li_20 - ld_24) > 0.5) ld_24++;
   double ld_32 = ld_24 / li_16;
   if (ld_32 != MathRound(ld_32)) {
      if (MathAbs(ld_32 - MathFloor(ld_32)) > 0.5) ld_32 = MathFloor(ld_32) + 1.0;
      else ld_32 = MathFloor(ld_32);
      ld_24 = ld_32 * li_16;
   }
   return (ld_24 / li_20);
}

int glSeparateStringInArray(string as_0, string &asa_8[], string as_12 = ";", bool ai_20 = TRUE) {
   int li_ret_32 = 0;
   ArrayResize(asa_8, 0);
   if (as_12 == " ") as_0 = glStringTrimAll(as_0);
   for (int li_24 = StringFind(as_0, as_12); li_24 != -1; li_24 = StringFind(as_0, as_12)) {
      li_ret_32++;
      ArrayResize(asa_8, li_ret_32);
      asa_8[li_ret_32 - 1] = StringSubstr(as_0, 0, li_24);
      if (as_12 == " ") as_0 = StringTrimLeft(as_0);
      else as_0 = StringSubstr(as_0, li_24 + StringLen(as_12));
   }
   if (as_0 != "") {
      li_ret_32++;
      ArrayResize(asa_8, li_ret_32);
      asa_8[li_ret_32 - 1] = as_0;
   }
   if (ai_20) for (int l_index_28 = 0; l_index_28 < li_ret_32; l_index_28++) asa_8[l_index_28] = glStringTrimAll(asa_8[l_index_28]);
   return (li_ret_32);
}

string glStringTrimAll(string as_0) {
   return (StringTrimLeft(StringTrimRight(as_0)));
}