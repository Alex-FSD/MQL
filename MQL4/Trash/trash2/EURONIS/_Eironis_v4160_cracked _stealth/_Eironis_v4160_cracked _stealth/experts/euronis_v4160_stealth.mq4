
#property copyright "Copyright © 2008-2009, Sotnikov Denis (fxexpert@freemail.ru)"
#property link      "fxexpert@freemail.ru"

#include <WinUser32.mqh>

extern bool MarketInfoMode = FALSE;
extern string OrderOptions = "--------   Orders options  --------";
extern double Lots = 0.0;
extern int LotsPercent = 10;
extern int MaxLotsPercent = 30;
double MaxLot = 0.0;
extern bool ResetMaxBalance = FALSE;
double DeltaFreeMargin = 0.0;
extern string BalanceControlOptions = "------ BalanceControl options -----";
extern bool UseBalanceControl = TRUE;
extern bool SaveLotsValueAfterDD = FALSE;
extern int RestoreDepoMode = 1;
int gi_144 = 1;
extern bool AlwaysUseMaxLot = FALSE;
extern bool RestoreLostProfit = TRUE;
double DDSensitivity = 0.0;
int gi_164 = 3;
bool gi_168 = FALSE;
extern string CrossOverOptions = "-------- CrossOver options --------";
extern bool CheckCrossOver = FALSE;
extern bool CrossOverMode = FALSE;
bool gi_188 = FALSE;
bool gi_192 = FALSE;
int gi_196 = 3000;
int gi_200 = 250;
int gi_204 = 10000;
extern string TradeOptions = "--------   Trade  options  --------";
extern int SettingsNumber = 2;
extern int DDSettingsNumber = 0;
int gi_224 = 0;
int gi_228 = 8;
int gi_232 = 1;
bool gi_236 = FALSE;
int OpenKit = 1;
int StopLoss = 0;
int TakeProfit = 0;
extern bool InvisibleStopLoss = TRUE;
extern bool TrailingTakeProfit = TRUE;
bool g_str2int_260 = TRUE;
int g_str2int_264 = 0;
int g_str2int_268 = 20;
string gs_unused_272 = "--------";
extern int MinOrderLifeTime = 0;
bool g_str2int_284 = FALSE;
bool g_str2int_288 = FALSE;
int g_str2int_292 = 300;
bool g_str2int_296 = TRUE;
int g_str2int_300 = 60;
int gi_304 = 0;
int gi_308 = 0;
bool gi_312 = FALSE;
int g_slippage_316 = 2;
int g_slippage_320 = 2;
bool UseSpreadCorrection = FALSE;
bool ContinueAfterClose = FALSE;
bool g_str2int_332 = TRUE;
int WorkingSpreadValue = 0;
bool g_str2int_340 = FALSE;
bool g_str2int_344 = TRUE;
string gs_unused_348 = "--------";
bool g_str2int_356 = FALSE;
int gi_360 = 0;
bool g_str2int_364 = FALSE;
int gi_368 = 0;
bool g_str2int_372 = FALSE;
bool g_str2int_376 = TRUE;
string gs_unused_380 = "--------";
double gd_388 = 0.0;
int g_str2int_396 = 0;
int g_str2int_400 = 0;
string gs_unused_404 = "--------";
double gd_412 = 0.0;
int g_str2int_420 = 0;
double gd_424 = 0.0;
int g_str2int_432 = 0;
int g_str2int_436 = 0;
int g_str2int_440 = 0;
string gs_unused_444 = "--------";
bool DoubleChannels = TRUE;
int ChannelBars = 0;
int g_str2int_460 = 0;
int g_str2int_464 = 0;
int g_str2int_468 = 0;
int g_str2int_472 = 0;
int gi_476 = 0;
int gi_480 = 0;
int gi_484 = 0;
int gi_488 = 0;
int g_str2int_492 = 0;
bool g_str2int_496 = FALSE;
bool g_str2int_500 = FALSE;
bool g_str2int_504 = FALSE;
bool gi_508 = TRUE;
bool g_str2int_512 = FALSE;
bool g_str2int_516 = FALSE;
bool g_str2int_520 = FALSE;
string gs_unused_524 = "--------";
int g_period_532 = 0;
double gd_536 = 0.0;
int g_ma_method_544 = MODE_SMA;
int g_applied_price_548 = PRICE_CLOSE;
int g_str2int_552 = 0;
string gs_unused_556 = "--------";
int g_str2int_564 = 0;
double gd_568 = 0.0;
int g_str2int_576 = 0;
int g_str2int_580 = 0;
int g_str2int_584 = 0;
string gs_unused_588 = "--------";
double gd_596 = 0.0;
int g_str2int_604 = 0;
int g_str2int_608 = 0;
double gd_612 = 0.0;
int g_str2int_620 = 0;
int g_str2int_624 = 0;
string gs_unused_628 = "--------";
bool g_str2int_636 = FALSE;
int g_str2int_640 = 60;
int gi_644 = 0;
int g_str2int_648 = 100;
int gi_652 = 0;
int g_str2int_656 = 150;
int gi_660 = 0;
int g_str2int_664 = 200;
int gi_668 = 0;
int g_str2int_672 = 250;
int gi_676 = 0;
string gs_unused_680 = "--------";
bool g_str2int_688 = FALSE;
int g_timeframe_692 = 0;
int g_period_696 = 0;
int g_applied_price_700 = PRICE_CLOSE;
int g_timeframe_704 = 0;
int g_period_708 = 0;
int g_applied_price_712 = PRICE_CLOSE;
int gi_716 = 0;
int g_timeframe_720 = 0;
int g_period_724 = 0;
int g_applied_price_728 = PRICE_CLOSE;
int g_period_732 = 0;
double gd_736 = 0.0;
int g_ma_method_744 = MODE_SMA;
int g_applied_price_748 = PRICE_CLOSE;
int gi_752 = 0;
int g_str2int_756 = 0;
double g_str2dbl_760 = 0.0;
double g_str2dbl_768 = 0.0;
double g_str2dbl_776 = 0.0;
double g_str2dbl_784 = 0.0;
int g_str2int_792 = 0;
int g_str2int_796 = 0;
string gs_unused_800 = "--------";
extern int FletFilterLevel = 0;
extern int TrendFilterLevel = 0;
bool gi_816 = FALSE;
double gd_820 = 0.0;
double gd_828 = 0.0;
double gd_836 = 0.0;
extern string TimeOptions = "--------   Time   options  --------";
extern bool UseAutoTimeSettings = TRUE;
extern int TimeZone = 0;
extern int SWChangeMode = 0;
bool gi_864 = FALSE;
extern int TimeRiskFactor = 5;
int gi_872 = 0;
int gi_876 = 0;
extern bool BlockWeekBegin = TRUE;
extern bool BlockWeekEnd = TRUE;
bool gi_888 = FALSE;
int gi_892 = 0;
int gi_896 = 0;
extern bool TradeHourOptimization = FALSE;
extern int OpenHourAM = 0;
extern int CloseHourAM = 12;
extern int OpenHourPM = 12;
extern int CloseHourPM = 24;
int g_str2int_920 = -1;
int g_str2int_924 = -1;
bool gi_928 = TRUE;
bool gi_932 = FALSE;
string gs_unused_936 = "--------Transmite options--------";
bool gi_944 = FALSE;
bool TradeTransferOut = FALSE;
bool gi_unused_952 = FALSE;
int gi_unused_956 = 10;
bool gi_unused_960 = TRUE;
int gi_unused_964 = 10;
bool gi_unused_968 = FALSE;
string gs_unused_972 = "--------   News   options  --------";
bool gi_unused_980 = FALSE;
int gi_unused_984 = 5;
int gi_unused_988 = 30;
int gi_unused_992 = 60;
bool gi_unused_996 = TRUE;
bool gi_unused_1000 = TRUE;
bool gi_unused_1004 = TRUE;
bool gi_unused_1008 = TRUE;
bool gi_unused_1012 = TRUE;
bool gi_unused_1016 = TRUE;
bool gi_unused_1020 = TRUE;
bool gi_unused_1024 = TRUE;
bool gi_unused_1028 = TRUE;
extern string OtherOptions = "--------   Other  options  --------";
extern int PersonalMagicNumber = 0;
bool gi_1044 = TRUE;
extern bool ShowTimes = TRUE;
extern bool ShowInformation = TRUE;
bool gi_1056 = FALSE;
extern int InformationStringNumber = 15;
extern bool ShowStateInfo = TRUE;
bool gi_1068 = FALSE;
bool gi_1072 = FALSE;
bool gi_1076 = TRUE;
bool gi_1080 = TRUE;
bool gi_1084 = TRUE;
bool gi_1088 = FALSE;
bool gi_1092 = FALSE;
extern bool UseMailReport = FALSE;
extern int MailReportTimeHour = 6;
bool gi_1104 = FALSE;
bool gi_1108 = TRUE;
bool ErrorComment = FALSE;
double gd_1116 = 5.0;
bool gi_1124 = TRUE;
extern string Language = "rus";
extern string AdvancedOptions = "-------- Advanced options  --------";
extern bool CheckFreeMargin = FALSE;
extern bool CheckStopOutLevel = TRUE;
extern bool IncreaseFreezeLevel = FALSE;
bool gi_unused_1156 = TRUE;
bool gi_unused_1160 = TRUE;
extern bool CheckRepeatClosePrice = TRUE;
bool gi_1168 = FALSE;
bool gi_1172 = TRUE;
extern int MaxSpreadValue = 0;
int gi_unused_1180 = 2;
bool gi_1184 = TRUE;
int gi_1188;
int gi_unused_1192;
bool gi_1196;
int gi_unused_1200;
int gi_unused_1204;
int gi_unused_1208;
int dig;
int CorrectionSpreadValue;
int gi_1220;
int gi_unused_1224;
int gi_unused_1228;
int gi_unused_1232;
int gi_unused_1236;
int gi_unused_1240;
int gi_unused_1244;
int gi_unused_1248;
int gi_unused_1252;
int gi_unused_1256;
int gi_unused_1260;
int gi_unused_1264;
int gi_unused_1268;
int g_magic_1272;
int gi_unused_1276;
int gi_unused_1280;
int gi_unused_1284;
int g_minute_1288;
int gi_1292;
int gi_1296;
int gi_1300;
bool gi_1304;
int gi_1308;
int gi_1312;
int сумма_цифр_счёта;
int сумма_цифр_счёта_Char;
int сумма_цифр_AccountName;
int gi_1328;
int gi_unused_1332 = 0;
int gi_unused_1336 = 0;
int gi_unused_1340 = 10;
int gi_unused_1344;
int g_day_of_week_1348;
int gi_unused_1352;
int gi_unused_1356;
int gi_1360;
datetime g_time_1364;
int gi_1368;
int g_hour_1372;
int g_day_of_week_1376;
int gi_1380;
int g_month_1384;
int g_year_1388;
int g_count_1392;
int gi_1396;
int gi_1400;
int g_count_1404;
int gi_1408;
bool gi_1412;
bool gi_1416;
int gi_1420;
int CorrectionTime;
bool g_bars_1428;
int TradeTimeBuffer[5][10];
int gia_1436[500][10];
int сумма_цифр_счёта_KEY;
int сумма_цифр_счёта_Char_KEY;
int сумма_цифр_AccN_KEY;
int g_count_1452;
double gd_1456;
double gd_unused_1464;
double gd_1472;
double gd_1480;
double gd_1488;
double gd_1496;
double gd_1504;
double gd_unused_1512;
double gd_unused_1520;
double gd_unused_1528;
double gd_unused_1536;
double g_global_var_1544;
double gd_unused_1552;
double gd_unused_1560;
double gd_unused_1568;
double gd_unused_1576;
double ReceiveBuffer[1][6];
double CommandBuffer[1][8];
double OrderProfitBuffer[30];
int gi_unused_1596;
int gi_unused_1604;
int gi_unused_1608;
int gi_unused_1612;
bool gi_1616;
bool gi_1620;
int gi_unused_1624;
int gi_unused_1632;
bool gi_1636;
bool gi_1640;
int gi_unused_1644;
bool gi_1648;
bool gi_1652;
int gi_unused_1656;
int gi_unused_1660;
int gi_unused_1664;
bool gi_1668;
int gi_unused_1672;
bool gi_1676;
int gi_unused_1680;
bool gi_1684;
int gi_unused_1688;
int gi_unused_1692;
bool gi_1696;
bool gi_1700;
bool gi_1704;
bool gi_1712;
bool gi_1716;
bool gi_1720;
bool gi_1724;
int gi_unused_1728;
bool License;
bool gi_1736;
bool gi_1740;
int gi_unused_1744;
bool gi_1748;
bool gi_1752;
int gi_1756;
int gi_unused_1760;
int gi_unused_1764;
int gi_1768;
int gi_1772;
int gi_1776;
int gi_1780;
int gi_1784;
string gs_1788;
string gs_1796;
string gs_unused_1804;
string gs_unused_1812;
string gs_1820;
string gs_1828;
string gs_1836;
string gs_1844;
string VariablesString[7];
string InformationString[50];
string Массив_приемник[160][21];
string Массив_источник[160][21];
string ErrorArray[4300];
string LogFileString[20];
string gs_1876;
string gs_1884;
string gs_1892;
string KeyFileName;
string gs_1908;
string СУММА;
string g_var_name_1924;
string g_var_name_1932;
string g_var_name_1940;
string g_var_name_1948;
string g_var_name_1956;
string gs_1964;
string gs_1972;
string account_number;
string account_name;
double gd_1996;
double gd_2004;
double gd_2012;
double Point_Value;
int g_digits_2028;
string g_symbol_2032;
string g_symbol_2040;
string gs_2048;
string gs_2056;
int gi_2064;
int gi_2068;
int gi_2072;
int gi_2076;
int gi_2080;
double g_point_2084;
double g_point_2092;
double g_digits_2100;
double g_digits_2108;
double StopLevel_Value;
double gd_2124;
double gd_2132;
double gd_2140;
double gd_2148;
double gd_2156;
double g_bid_2164;
double g_ask_2172;
double g_bid_2180;
double g_ask_2188;
double g_spread_2196;
double g_spread_2204;
double gd_2212;
double gd_2220;
double gd_2228;
double gd_2236;
double gda_2244[48][5];
int g_count_2248;
double gda_2260[7][60];
int gia_2264[7][60];
int gia_2268[7][60];
string gsa_2272[7][60];
double gda_2276[50];
double gda_2280[50];
double gda_2284[50];
double gda_2288[50];
double gda_2292[50];
int gia_2296[50];
int gia_2300[50];
int g_datetime_2304;
int gi_2308;
int gi_2312;
int gi_2316;
bool gi_2320;
bool gi_2328;
bool gi_2332;
string gs_2336;
string gs_2344;
string gs_2352;
int gi_2360;
bool g_bars_2364;
double gda_2368[50];
int gia_2372[6];

int init() {
   Comment("");
   InitVariables();
  ClearBuffer("ReceiveBuffer", 0);
  ClearBuffer("CommandBuffer", 0);
  ClearBuffer("VariablesBuffer", 0);
  ClearBuffer("InformationBuffer", 0);
  ClearBuffer("LogFileBuffer", 0);
  ClearBuffer("ErrorArray", 0);
  ClearBuffer("LoadSettingsArray", 0);
  ClearBuffer("SettingsArray", 0);
  ClearBuffer("SpreadArray", 0);
  ClearBuffer("OSbuffer", 0);
  ClearBuffer("OSbuffer", 1);
  ClearBuffer("OSbuffer", 2);
  ClearBuffer("OSbuffer", 3);
  ClearBuffer("OSbuffer", 4);
  ClearBuffer("OSbuffer", 5);
  ClearBuffer("OSbuffer", 6);
   gi_1412 = MathRound(MarketInfo(Symbol(), MODE_SPREAD));
   gia_2268[0][2] = Time[0];
   gia_2268[1][2] = Time[0];
   gia_2268[2][2] = Time[0];
   gia_2268[3][2] = Time[0];
   gia_2268[4][2] = Time[0];
   gia_2268[5][2] = Time[0];
   gia_2268[6][2] = Time[0];
   if (gi_1184) HideTestIndicators(TRUE);
   if (!DoubleChannels) {
      g_str2int_460 = ChannelBars;
      g_str2int_468 = ChannelBars;
      g_str2int_472 = ChannelBars;
   }
   CheckPointDifference();
   if (IsOptimization() || IsTesting()) {
      gi_1080 = FALSE;
      if (!IsVisualMode()) {
         gi_1044 = FALSE;
         gi_1084 = FALSE;
      }
      if (TradeHourOptimization) {
         if (OpenHourAM > 23) OpenHourAM = 23;
         CloseHourAM = OpenHourAM + 1;
         OpenHourPM = 24;
         CloseHourPM = 24;
      }
   } else TradeHourOptimization = FALSE;
   CheckMarketInfo();
   CheckCrossOverMode();
   gd_1496 = NormalizeDouble(100000.0 * (0.95 * GetMaxLotsPercent(0)) / MarketInfo(Symbol(), MODE_LOTSIZE), 2);
   SetGlobalVariableNames();
   gi_1736 = function_51();
   InitErrorArray();
   function_49();
   LoadSettings();
   SetMaxLots();
   SetSettings(SettingsNumber, 1);
   SetTimeSettings(gi_872);
   CorrectGMTTime();
   StartRulls();
   License = CheckLicense();
   function_83(0, 0);
   if (ContinueAfterClose) {
      if (LotsPercent > 30 && Lots == 0.0) {
         ContinueAfterClose = FALSE;
         Comments(8, "Init()", "Невозможно установить ContinueAfterClose: LotsPercent>30", "Unable to set ContinueAfterClose: LotsPercent>30");
      }
   }
   MakeInitString();
   MakeTimeString();
   if (License) Comments(8, "Init()", "Инициализация завершена (Лицензия-НЕТ)", "Initialization completed (License-NO)");
   else Comments(8, "Init()", "Инициализация завершена (Лицензия-ОК)", "Initialization completed (License-OK)");
   function_53(" ");
   Print("Keys=" + gi_1296 + "." + gi_2360 + "." + gi_1408 + "." + gi_2080);
   return (0);
}

int start() {
   bool li_0 = TRUE;
   if (gi_1748 && !IsTesting() && !IsOptimization()) return (0);
   while (li_0) {
      gi_1368 = GetTickCount();
      CheckCrossOverMode();
      StartRulls();
      function_3();
      function_92();
      if (CrossOverMode && !IsStopped()) Sleep(gi_200);
      else li_0 = FALSE;
      if (IsStopped()) Comments(9, "start()", "IsStopped()", "IsStopped()");
      function_53(" ");
   }
   return (0);
}

int StateOfLastOrders() {
   string ls_unused_8;
   if (IsOptimization() || IsTesting()) return (0);
   string l_name_0 = gs_2344;
   int l_file_16 = FileOpen(l_name_0, FILE_CSV|FILE_READ, ';');
   if (l_file_16 < 1) return (0);
   bool li_24 = FALSE;
   for (int l_index_20 = 0; l_index_20 < 7; l_index_20++) {
      gia_2264[l_index_20][0] = StrToInteger(FileReadString(l_file_16));
      gia_2264[l_index_20][1] = StrToInteger(FileReadString(l_file_16));
      gsa_2272[l_index_20][0] = FileReadString(l_file_16);
      gsa_2272[l_index_20][1] = FileReadString(l_file_16);
      gsa_2272[l_index_20][2] = FileReadString(l_file_16);
      gda_2260[l_index_20][7] = StrToDouble(FileReadString(l_file_16));
      gia_2264[l_index_20][4] = StrToInteger(FileReadString(l_file_16));
      gia_2264[l_index_20][5] = StrToInteger(FileReadString(l_file_16));
      gia_2264[l_index_20][6] = StrToInteger(FileReadString(l_file_16));
      gia_2264[l_index_20][7] = StrToInteger(FileReadString(l_file_16));
      gia_2264[l_index_20][8] = StrToInteger(FileReadString(l_file_16));
      gia_2264[l_index_20][9] = StrToInteger(FileReadString(l_file_16));
      gia_2264[l_index_20][11] = StrToInteger(FileReadString(l_file_16));
      gia_2264[l_index_20][12] = StrToInteger(FileReadString(l_file_16));
      gia_2264[l_index_20][13] = StrToInteger(FileReadString(l_file_16));
      gia_2264[l_index_20][14] = StrToInteger(FileReadString(l_file_16));
      gda_2260[l_index_20][6] = StrToDouble(FileReadString(l_file_16));
      gda_2260[l_index_20][5] = StrToDouble(FileReadString(l_file_16));
      gia_2268[l_index_20][2] = StrToTime(FileReadString(l_file_16));
      gia_2268[l_index_20][3] = StrToTime(FileReadString(l_file_16));
      gia_2268[l_index_20][4] = StrToTime(FileReadString(l_file_16));
      gia_2268[l_index_20][5] = StrToTime(FileReadString(l_file_16));
      if (gia_2264[l_index_20][0] != 0) li_24 = TRUE;
   }
   if (li_24) Comments(8, "StateOfLastOrders()", "Загружены состояния прошлых ордеров", "Loaded the state of last orders");
   FileClose(l_file_16);
   return (1);
}

int function_2() {
   string ls_unused_12;
   bool li_0 = FALSE;
   string l_name_4 = gs_2344;
   if (IsOptimization() || IsTesting()) return (0);
   for (int l_index_24 = 0; l_index_24 < 7; l_index_24++)
      if (gia_2372[l_index_24] != gia_2264[l_index_24][0]) li_0 = TRUE;
   if (!li_0) return (0);
   int l_file_20 = FileOpen(l_name_4, FILE_CSV|FILE_WRITE, ';');
   if (l_file_20 < 1) return (0);
   for (l_index_24 = 0; l_index_24 < 7; l_index_24++) {
      FileWrite(l_file_20, gia_2264[l_index_24][0], gia_2264[l_index_24][1], gsa_2272[l_index_24][0], gsa_2272[l_index_24][1], gsa_2272[l_index_24][2], gda_2260[l_index_24][7], gia_2264[l_index_24][4], gia_2264[l_index_24][5], gia_2264[l_index_24][6], gia_2264[l_index_24][7], gia_2264[l_index_24][8], gia_2264[l_index_24][9], gia_2264[l_index_24][11], gia_2264[l_index_24][12], gia_2264[l_index_24][13], gia_2264[l_index_24][14], gda_2260[l_index_24][6], gda_2260[l_index_24][5], TimeToStr(gia_2268[l_index_24][2], TIME_DATE|TIME_SECONDS), TimeToStr(gia_2268[l_index_24][3], TIME_DATE|TIME_SECONDS), TimeToStr(gia_2268[l_index_24][4], TIME_DATE|TIME_SECONDS), TimeToStr(gia_2268[l_index_24][5], TIME_DATE|TIME_SECONDS));
      gia_2372[l_index_24] = gia_2264[l_index_24][0];
   }
   FileClose(l_file_20);
   return (1);
}

int function_3() {
   bool li_4 = FALSE;
   bool li_8 = FALSE;
   if (!gi_2328) {
      gi_2328 = TRUE;
      StateOfLastOrders();
   }
   for (int l_count_12 = 0; l_count_12 < 7; l_count_12++)
      if (isFindLostOrder(l_count_12)) function_69(l_count_12);
   int li_0 = 1;
   li_4 = FALSE;
   li_8 = FALSE;
   if (gi_144 != 0 && gi_1740) {
      if (gia_2264[0][0] != 0) {
         if (gi_144 == 1) {
            li_4 = TRUE;
            li_8 = TRUE;
         }
         if (gi_144 == 2) {
            if (gia_2264[0][1] == 0) li_8 = TRUE;
            if (gia_2264[0][1] == 1) li_4 = TRUE;
         }
         if (gi_144 == 3) {
            if (gia_2264[0][1] == 0) li_4 = TRUE;
            if (gia_2264[0][1] == 1) li_8 = TRUE;
         }
      }
   }
   function_68(li_0, li_4, li_8);
   li_0 = 0;
   li_4 = FALSE;
   li_8 = FALSE;
   if (gia_2264[1][0] == 0) {
      li_4 = TRUE;
      li_8 = TRUE;
   }
   function_68(li_0, li_4, li_8);
   bool li_16 = FALSE;
   bool li_20 = FALSE;
   li_0 = 2;
   li_4 = FALSE;
   li_8 = FALSE;
   if (gi_224 != 0 && !gi_1740) {
      if (gia_2264[0][0] == 96 && gia_2264[1][0] == 0) {
         if (gia_2264[0][10] <= (-1 * gi_228) && gi_232 > 0) {
            li_16 = FALSE;
            li_20 = FALSE;
            if (gia_2264[0][1] == 0) li_20 = TRUE;
            if (gia_2264[0][1] == 1) li_16 = TRUE;
            if (gi_224 == 1) {
               if (!li_16) li_4 = TRUE;
               if (!li_20) li_8 = TRUE;
            }
            if (gi_224 == 2) {
               if (gia_2264[0][1] == 0 && !li_20) li_8 = TRUE;
               if (gia_2264[0][1] == 1 && !li_16) li_4 = TRUE;
            }
            if (gi_224 == 3) {
               if (gia_2264[0][1] == 0) li_4 = TRUE;
               if (gia_2264[0][1] == 1) li_8 = TRUE;
            }
         }
      }
   }
   function_68(li_0, li_4, li_8);
   li_0 = 3;
   li_4 = FALSE;
   li_8 = FALSE;
   if (gi_224 != 0 && !gi_1740) {
      if (gia_2264[0][0] == 96 && gia_2264[1][0] == 0 && gia_2264[2][0] == 96) {
         if (gia_2264[0][10] <= (-2 * gi_228) && gi_232 > 1) {
            li_16 = FALSE;
            li_20 = FALSE;
            if (gia_2264[0][1] == 0) li_20 = TRUE;
            if (gia_2264[0][1] == 1) li_16 = TRUE;
            if (gi_224 == 1) {
               if (!li_16) li_4 = TRUE;
               if (!li_20) li_8 = TRUE;
            }
            if (gi_224 == 2) {
               if (gia_2264[0][1] == 0 && !li_20) li_8 = TRUE;
               if (gia_2264[0][1] == 1 && !li_16) li_4 = TRUE;
            }
            if (gi_224 == 3) {
               if (gia_2264[0][1] == 0) li_4 = TRUE;
               if (gia_2264[0][1] == 1) li_8 = TRUE;
            }
         }
      }
   }
   function_68(li_0, li_4, li_8);
   li_0 = 4;
   li_4 = FALSE;
   li_8 = FALSE;
   if (gi_224 != 0 && !gi_1740) {
      if (gia_2264[0][0] == 96 && gia_2264[1][0] == 0 && gia_2264[3][0] == 96) {
         if (gia_2264[0][10] <= (-3 * gi_228) && gi_232 > 2) {
            li_16 = FALSE;
            li_20 = FALSE;
            if (gia_2264[0][1] == 0) li_20 = TRUE;
            if (gia_2264[0][1] == 1) li_16 = TRUE;
            if (gi_224 == 1) {
               if (!li_16) li_4 = TRUE;
               if (!li_20) li_8 = TRUE;
            }
            if (gi_224 == 2) {
               if (gia_2264[0][1] == 0 && !li_20) li_8 = TRUE;
               if (gia_2264[0][1] == 1 && !li_16) li_4 = TRUE;
            }
            if (gi_224 == 3) {
               if (gia_2264[0][1] == 0) li_4 = TRUE;
               if (gia_2264[0][1] == 1) li_8 = TRUE;
            }
         }
      }
   }
   function_68(li_0, li_4, li_8);
   li_0 = 5;
   li_4 = FALSE;
   li_8 = FALSE;
   if (gi_224 != 0 && !gi_1740) {
      if (gia_2264[0][0] == 96 && gia_2264[1][0] == 0 && gia_2264[4][0] == 96) {
         if (gia_2264[0][10] <= (-4 * gi_228) && gi_232 > 3) {
            li_16 = FALSE;
            li_20 = FALSE;
            if (gia_2264[0][1] == 0) li_20 = TRUE;
            if (gia_2264[0][1] == 1) li_16 = TRUE;
            if (gi_224 == 1) {
               if (!li_16) li_4 = TRUE;
               if (!li_20) li_8 = TRUE;
            }
            if (gi_224 == 2) {
               if (gia_2264[0][1] == 0 && !li_20) li_8 = TRUE;
               if (gia_2264[0][1] == 1 && !li_16) li_4 = TRUE;
            }
            if (gi_224 == 3) {
               if (gia_2264[0][1] == 0) li_4 = TRUE;
               if (gia_2264[0][1] == 1) li_8 = TRUE;
            }
         }
      }
   }
   function_68(li_0, li_4, li_8);
   li_0 = 6;
   li_4 = FALSE;
   li_8 = FALSE;
   if (gi_224 != 0 && !gi_1740) {
      if (gia_2264[0][0] == 96 && gia_2264[1][0] == 0 && gia_2264[5][0] == 96) {
         if (gia_2264[0][10] <= (-5 * gi_228) && gi_232 > 4) {
            li_16 = FALSE;
            li_20 = FALSE;
            if (gia_2264[0][1] == 0) li_20 = TRUE;
            if (gia_2264[0][1] == 1) li_16 = TRUE;
            if (gi_224 == 1) {
               if (!li_16) li_4 = TRUE;
               if (!li_20) li_8 = TRUE;
            }
            if (gi_224 == 2) {
               if (gia_2264[0][1] == 0 && !li_20) li_8 = TRUE;
               if (gia_2264[0][1] == 1 && !li_16) li_4 = TRUE;
            }
            if (gi_224 == 3) {
               if (gia_2264[0][1] == 0) li_4 = TRUE;
               if (gia_2264[0][1] == 1) li_8 = TRUE;
            }
         }
      }
   }
   function_68(li_0, li_4, li_8);
   function_2();
   return (1);
}

bool isCloseOrder(int ai_0) {
   bool li_ret_4 = FALSE;
   if (gia_2264[ai_0][1] == 1 && !function_8(g_str2int_500)) {
      if ((g_str2int_356 && isChanneltoClose(1, g_str2int_468, g_str2int_516, gi_484, "MinProfit") && isProfitValuetoClose(ai_0, gi_360 - gi_1188 + CorrectionSpreadValue, "MinProfit")) || (!g_str2int_356 &&
         isChanneltoClose(1, g_str2int_468, g_str2int_516, gi_484, "ChannelClose")) || (isChanneltoClose(1, g_str2int_472, g_str2int_520, gi_488, "ChannelOff") && g_str2int_472 != 0) ||
         (g_str2int_364 && isProfitValuetoClose(ai_0, TimeProfit(ai_0), "OptProfit")) || isInvisibleStopLosstoClose(1)) li_ret_4 = TRUE;
   }
   if (gia_2264[ai_0][1] == 0 && !function_8(g_str2int_500)) {
      if ((g_str2int_356 && isChanneltoClose(0, g_str2int_468, g_str2int_516, gi_484, "MinProfit") && isProfitValuetoClose(ai_0, gi_360 - gi_1188 + CorrectionSpreadValue, "MinProfit")) || (!g_str2int_356 &&
         isChanneltoClose(0, g_str2int_468, g_str2int_516, gi_484, "ChannelClose")) || (isChanneltoClose(0, g_str2int_472, g_str2int_520, gi_488, "ChannelOff") && g_str2int_472 != 0) ||
         (g_str2int_364 && isProfitValuetoClose(ai_0, TimeProfit(ai_0), "OptProfit")) || isInvisibleStopLosstoClose(0)) li_ret_4 = TRUE;
   }
   return (li_ret_4);
}

int isMADistancetoOpen(int ai_0, int ai_unused_4, int ai_8, int ai_unused_12, double a_pips_16, int ai_24) {
   double ld_32;
   bool li_ret_28 = TRUE;
   if (ai_8 != 0) {
      ld_32 = gda_2368[1];
      if (ai_24 == 1) ld_32 = MathRound(ld_32 / Point) * Point;
      if (ai_24 == 2 && ai_0 == 1) ld_32 = MathFloor(ld_32 / Point) * Point;
      if (ai_24 == 2 && ai_0 == 0) ld_32 = MathCeil(ld_32 / Point) * Point;
      if (ai_24 == 3 && ai_0 == 0) ld_32 = MathFloor(ld_32 / Point) * Point;
      if (ai_24 == 3 && ai_0 == 1) ld_32 = MathCeil(ld_32 / Point) * Point;
      if (MathAbs(Bid - ld_32 + gi_2080 * gi_2360) <= a_pips_16 * Point) li_ret_28 = FALSE;
   }
   return (li_ret_28);
}

int isOpenOrder(int ai_0) {
   bool li_ret_4 = FALSE;
   if (!function_8(g_str2int_496) && !function_8(g_str2int_504) && !function_89(gi_508) && !gi_1700 && !gi_1648 && !gi_1712 && !gi_1704 && !gi_1716 && !gi_1720 && !gi_1752 &&
      !License) {
      if (ai_0 == 1) {
         if (!gi_1724) {
            if ((OpenKit == 0 || OpenKit == 1 && isMADistancetoOpen(1, g_ma_method_544, g_period_532, g_applied_price_548, gd_536, g_str2int_552) && isChanneltoOpen(1, g_str2int_460, g_str2int_512, gi_476)) ||
               (OpenKit == 0 || OpenKit == 2 && isMADistancetoOpen(1, g_str2int_620, g_str2int_608, g_str2int_624, gd_612, g_str2int_552) && isChanneltoOpen(1, g_str2int_464, g_str2int_512, gi_480)) ||
               (OpenKit == 4 && isRSItoOpen(1))) li_ret_4 = TRUE;
         }
      }
      if (ai_0 == 0) {
         if (!gi_1724) {
            if ((OpenKit == 0 || OpenKit == 1 && isMADistancetoOpen(0, g_ma_method_544, g_period_532, g_applied_price_548, gd_536, g_str2int_552) && isChanneltoOpen(0, g_str2int_460, g_str2int_512, gi_476)) ||
               (OpenKit == 0 || OpenKit == 2 && isMADistancetoOpen(0, g_str2int_620, g_str2int_608, g_str2int_624, gd_612, g_str2int_552) && isChanneltoOpen(0, g_str2int_464, g_str2int_512, gi_480)) ||
               (OpenKit == 4 && isRSItoOpen(0))) li_ret_4 = TRUE;
         }
      }
   }
   return (li_ret_4);
}

int isSpreadtoTrade() {
   bool li_ret_0 = FALSE;
   int li_4 = MathRound(gd_1996);
   if (gi_1412 != li_4 && gi_1068) {
      Comments(8, "isSpreadtoTrade()", "Изменилось значение спреда с " + gi_1412 + " на " + li_4, "Spread value change from " + gi_1412 + " to " + li_4);
      gi_1412 = li_4;
   }
   if ((!UseSpreadCorrection && li_4 <= MaxSpreadValue) || (UseSpreadCorrection && li_4 <= MaxSpreadValue)) li_ret_0 = TRUE;
   return (li_ret_0);
}

bool function_8(int ai_unused_0) {
   bool li_ret_4 = FALSE;
   return (li_ret_4);
}

int isErrorCloseOrder(int ai_0, int a_cmd_4) {
   int l_bool_28;
   int li_32;
   string ls_44;
   double l_price_52;
   double l_ord_open_price_60;
   double l_ord_open_price_68;
   double l_ord_profit_76;
   double l_ord_profit_84;
   string ls_92;
   string ls_100;
   int l_datetime_108;
   int l_datetime_112;
   int l_cmd_116;
   int l_cmd_120;
   double l_ord_lots_124;
   double l_ord_lots_132;
   color l_color_140;
   bool li_144;
   bool li_148;
   bool li_ret_8 = FALSE;
   int li_unused_12 = 0;
   int li_unused_16 = 0;
   int li_unused_20 = 1;
   int l_pos_24 = 0;
   int l_error_40 = -1;
   if (TimeCurrent() - gia_2268[ai_0][5] < gi_196 * gia_2264[ai_0][14] / 1000) return (li_ret_8);
   li_unused_16 = 1;
   int li_36 = GetTickCount();
   if (a_cmd_4 == OP_BUY) ls_44 = "Buy";
   if (a_cmd_4 == OP_SELL) ls_44 = "Sell";
   if (CrossOverMode) ls_44 = "cross-" + ls_44;
   if (function_11()) return (li_ret_8);
   if (!CrossOverMode) {
      li_32 = OrdersTotal() - 1;
      for (l_pos_24 = li_32; l_pos_24 >= 0; l_pos_24--) {
         l_bool_28 = OrderSelect(l_pos_24, SELECT_BY_POS, MODE_TRADES);
         if (l_bool_28 > FALSE && OrderMagicNumber() == g_magic_1272 && OrderSymbol() == Symbol() && StringFind(OrderComment(), gsa_2272[ai_0][4]) >= 0) break;
      }
      if (l_bool_28 <= FALSE) {
         Comments(9, "isErrorCloseOrder()", "Close ticket=0 (" + l_bool_28 + "): " + PrintError(GetLastError()), "Close ticket=0 (" + l_bool_28 + "): " + PrintError(GetLastError()));
         return (li_ret_8);
      }
      a_cmd_4 = OrderType();
      if (a_cmd_4 == OP_BUY) {
         if (gd_2012 >= gda_2260[ai_0][3] && gda_2260[ai_0][3] > 0.0) return (li_ret_8);
         CheckCrossOverMode();
         li_ret_8 = FALSE;
         if ((gd_2012 >= gda_2260[ai_0][5] && CheckRepeatClosePrice) || !CheckRepeatClosePrice) li_ret_8 = TRUE;
         if (li_ret_8) gia_2264[ai_0][14]++;
         if (li_ret_8 && gia_2264[ai_0][3] < MinOrderLifeTime && MinOrderLifeTime > 0) {
            li_ret_8 = FALSE;
            l_error_40 = 4300;
         }
         if (li_ret_8 && !IsTradeAllowed()) {
            l_error_40 = 4;
            li_ret_8 = FALSE;
         }
         if (li_ret_8) {
            if (gia_2264[ai_0][14] > 1) {
               Comments(8, "isErrorCloseOrder()", "Повтор закрытия ордера " + ls_44 + gsa_2272[ai_0][4] + " (" + DoubleToStr(gd_2012, g_digits_2028) + "/" + DoubleToStr(gda_2260[ai_0][5], g_digits_2028) +
                  "), попытка " + gia_2264[ai_0][14], "Try to reclose " + ls_44 + gsa_2272[ai_0][4] + " (" + DoubleToStr(gda_2260[ai_0][5], g_digits_2028) + "), trial " + gia_2264[ai_0][14]);
            }
            if (!OrderClose(OrderTicket(), OrderLots(), Bid, g_slippage_320, Blue)) {
               l_error_40 = GetLastError();
               li_ret_8 = FALSE;
            }
         }
      }
      if (a_cmd_4 == OP_SELL) {
         if (gd_2004 <= gda_2260[ai_0][3] && gda_2260[ai_0][3] > 0.0) return (li_ret_8);
         CheckCrossOverMode();
         li_ret_8 = FALSE;
         if ((gd_2004 <= gda_2260[ai_0][5] && CheckRepeatClosePrice) || !CheckRepeatClosePrice) li_ret_8 = TRUE;
         if (li_ret_8) gia_2264[ai_0][14]++;
         if (li_ret_8 && gia_2264[ai_0][3] < MinOrderLifeTime && MinOrderLifeTime > 0) {
            li_ret_8 = FALSE;
            l_error_40 = 4300;
         }
         if (li_ret_8 && !IsTradeAllowed()) {
            l_error_40 = 4;
            li_ret_8 = FALSE;
         }
         if (li_ret_8) {
            if (gia_2264[ai_0][14] > 1) {
               Comments(8, "isErrorCloseOrder()", "Повтор закрытия ордера " + ls_44 + gsa_2272[ai_0][4] + " (" + DoubleToStr(gd_2004, g_digits_2028) + "/" + DoubleToStr(gda_2260[ai_0][5], g_digits_2028) +
                  "), попытка " + gia_2264[ai_0][14], "Try to reclose " + ls_44 + gsa_2272[ai_0][4] + " (" + DoubleToStr(gda_2260[ai_0][5], g_digits_2028) + "), trial " + gia_2264[ai_0][14]);
            }
            if (!OrderClose(OrderTicket(), OrderLots(), Ask, g_slippage_320, Red)) {
               l_error_40 = GetLastError();
               li_ret_8 = FALSE;
            }
         }
      }
   } else {
      ls_92 = "";
      ls_100 = "";
      li_144 = FALSE;
      li_148 = FALSE;
      li_32 = OrdersTotal() - 1;
      for (l_pos_24 = li_32; l_pos_24 >= 0; l_pos_24--) {
         l_bool_28 = OrderSelect(l_pos_24, SELECT_BY_POS, MODE_TRADES);
         if (l_bool_28 > FALSE && OrderMagicNumber() == g_magic_1272 && OrderSymbol() == g_symbol_2032 && StringFind(OrderComment(), gsa_2272[ai_0][4]) >= 0) {
            l_ord_profit_76 = OrderProfit();
            ls_92 = OrderTicket();
            li_144 = TRUE;
            li_ret_8 = FALSE;
            break;
         }
      }
      if (l_bool_28 <= FALSE) Comments(9, "isErrorCloseOrder()", "crL Close OrderSelect=0", "crL Close OrderSelect=0");
      if (ls_92 != "") {
         li_36 = GetTickCount();
         function_93(0);
         while (!li_ret_8) {
            CheckCrossOverMode();
            if (OrderType() == OP_SELL) l_price_52 = g_ask_2172;
            else l_price_52 = g_bid_2164;
            if (OrderType() == OP_SELL) l_color_140 = Red;
            else l_color_140 = Blue;
            Comments(9, "", ls_44 + gsa_2272[ai_0][4] + " закрываем ордер по " + gs_2048 + " " + OrderType() + "(" + OrderTicket() + "," + OrderLots() + "," + l_price_52 +
               ")", ls_44 + gsa_2272[ai_0][4] + " close cross orders " + gs_2048 + " " + OrderType() + "(" + OrderTicket() + "," + OrderLots() + "," + l_price_52 + ")");
            if (IsTradeAllowed()) {
               if (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(l_price_52, g_digits_2100), g_slippage_320 / dig * gi_2072, l_color_140)) li_ret_8 = TRUE;
               l_error_40 = GetLastError();
            }
            if (li_ret_8) {
               l_ord_open_price_60 = OrderOpenPrice();
               l_ord_profit_76 = OrderProfit();
               l_datetime_108 = OrderOpenTime();
               l_cmd_116 = OrderType();
               l_ord_lots_124 = OrderLots();
               break;
            }
            if (function_93(gi_204)) return (0);
            gia_2264[ai_0][14]++;
            Sleep(gi_196);
            if (gia_2264[ai_0][14] > 0) {
               Comments(8, "isErrorCloseOrder()", "Повтор закрытия ордера  " + g_symbol_2032 + " (" + DoubleToStr(gda_2260[ai_0][5], g_digits_2028) + "), попытка " + gia_2264[ai_0][14], "Try to reclose  " +
                  g_symbol_2032 + " (" + DoubleToStr(gda_2260[ai_0][5], g_digits_2028) + "), trial " + gia_2264[ai_0][14]);
            }
         }
      }
      for (l_pos_24 = li_32; l_pos_24 >= 0; l_pos_24--) {
         l_bool_28 = OrderSelect(l_pos_24, SELECT_BY_POS, MODE_TRADES);
         if (l_bool_28 > FALSE && OrderMagicNumber() == g_magic_1272 && OrderSymbol() == g_symbol_2040 && StringFind(OrderComment(), gsa_2272[ai_0][4]) >= 0) {
            l_ord_profit_84 = OrderProfit();
            ls_100 = OrderTicket();
            li_ret_8 = FALSE;
            li_148 = TRUE;
            break;
         }
      }
      if (l_bool_28 <= FALSE) Comments(9, "isErrorCloseOrder()", "crR Close ticket=0", "crR Close ticket=0");
      if (ls_100 != "") {
         function_93(0);
         while (!li_ret_8) {
            CheckCrossOverMode();
            ls_100 = OrderTicket();
            if (OrderType() == OP_SELL) l_price_52 = g_ask_2188;
            else l_price_52 = g_bid_2180;
            if (OrderType() == OP_SELL) l_color_140 = Red;
            else l_color_140 = Blue;
            Comments(9, "", ls_44 + gsa_2272[ai_0][4] + " закрываем ордер по " + gs_2056 + " " + OrderType() + "(" + OrderTicket() + "," + OrderLots() + "," + l_price_52 +
               ")", ls_44 + gsa_2272[ai_0][4] + " close cross orders " + gs_2056 + " " + OrderType() + "(" + OrderTicket() + "," + OrderLots() + "," + l_price_52 + ")");
            if (IsTradeAllowed()) {
               if (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(l_price_52, g_digits_2108), g_slippage_320 / dig * gi_2076, l_color_140)) li_ret_8 = TRUE;
               l_error_40 = GetLastError();
            }
            if (li_ret_8) {
               l_ord_open_price_68 = OrderOpenPrice();
               l_ord_profit_84 = OrderProfit();
               l_datetime_112 = OrderOpenTime();
               l_cmd_120 = OrderType();
               l_ord_lots_132 = OrderLots();
               li_148 = TRUE;
               break;
            }
            if (function_93(gi_204)) return (0);
            gia_2264[ai_0][14]++;
            Sleep(gi_196);
            if (gia_2264[ai_0][14] > 0) {
               Comments(8, "isErrorCloseOrder()", "Повтор закрытия ордера  " + g_symbol_2040 + " (" + DoubleToStr(gda_2260[ai_0][5], g_digits_2028) + "), попытка " + gia_2264[ai_0][14], "Try to reclose  " +
                  g_symbol_2040 + " (" + DoubleToStr(gda_2260[ai_0][5], g_digits_2028) + "), trial " + gia_2264[ai_0][14]);
            }
         }
      }
   }
   gia_2264[ai_0][12] = GetTickCount() - li_36;
   if (li_ret_8) {
      if (CrossOverMode) {
         if (li_144 && li_148) {
            gda_2260[ai_0][1] = function_70(l_ord_open_price_60, l_ord_open_price_68);
            gda_2260[ai_0][2] = 0.0;
            gda_2260[ai_0][3] = 0.0;
            gda_2260[ai_0][4] = l_ord_profit_76 + l_ord_profit_84;
            gia_2268[ai_0][0] = 0;
            if (l_datetime_108 > l_datetime_112) gia_2268[ai_0][1] = l_datetime_108;
            else gia_2268[ai_0][1] = l_datetime_112;
            gia_2264[ai_0][1] = function_71(l_cmd_116, l_cmd_120);
            gia_2264[ai_0][2] = OrderMagicNumber();
            gsa_2272[ai_0][0] = ls_92 + "/" + ls_100;
            gsa_2272[ai_0][1] = g_symbol_2032 + "/" + g_symbol_2040;
            gsa_2272[ai_0][2] = gs_2048 + "/" + gs_2056;
            gda_2260[ai_0][7] = l_ord_lots_124;
            gia_2264[ai_0][3] = TimeCurrent() - gia_2268[ai_0][1];
            if (gia_2264[ai_0][1] == 1) gia_2264[ai_0][4] = MathRound((gda_2260[ai_0][1] - gda_2260[ai_0][6]) / Point_Value);
            if (gia_2264[ai_0][1] == 0) gia_2264[ai_0][4] = MathRound((gda_2260[ai_0][6] - gda_2260[ai_0][1]) / Point_Value);
            gia_2268[ai_0][3] = Time[0];
            gia_2264[ai_0][7] = gd_1996;
            gia_2264[ai_0][8] = gi_1220;
            gia_2264[ai_0][12] = GetTickCount() - li_36;
            li_ret_8 = TRUE;
         }
      } else {
         gda_2260[ai_0][1] = OrderOpenPrice();
         gda_2260[ai_0][2] = OrderStopLoss();
         gda_2260[ai_0][3] = OrderTakeProfit();
         gda_2260[ai_0][4] = OrderProfit();
         gia_2268[ai_0][1] = OrderOpenTime();
         gia_2264[ai_0][1] = OrderType();
         gia_2264[ai_0][2] = OrderMagicNumber();
         gsa_2272[ai_0][0] = OrderTicket();
         gsa_2272[ai_0][1] = OrderSymbol();
         gsa_2272[ai_0][2] = gs_1836;
         gda_2260[ai_0][7] = OrderLots();
         if (gia_2264[ai_0][1] == 1) gia_2264[ai_0][4] = MathRound((gda_2260[ai_0][1] - gda_2260[ai_0][6]) / Point_Value);
         if (gia_2264[ai_0][1] == 0) gia_2264[ai_0][4] = MathRound((gda_2260[ai_0][6] - gda_2260[ai_0][1]) / Point_Value);
         gia_2268[ai_0][3] = Time[0];
         gia_2264[ai_0][7] = gd_1996;
         gia_2264[ai_0][8] = gi_1220;
         gia_2264[ai_0][12] = GetTickCount() - li_36;
         li_ret_8 = TRUE;
         gi_unused_1624 = 0;
      }
   } else {
      if (!gi_1696) {
         if (l_error_40 > -1) {
            if (l_error_40 == 4/* SERVER_BUSY */) {
               if (!ErrorComment) {
                  Comments(8, "isErrorCloseOrder()", "Ошибка закрытия ордера " + ls_44 + gsa_2272[ai_0][4] + " (" + DoubleToStr(gda_2260[ai_0][5], g_digits_2028) + "): торговый поток занят", "Error to close " +
                     ls_44 + gsa_2272[ai_0][4] + " order" + " (" + DoubleToStr(gda_2260[ai_0][5], g_digits_2028) + "): trade context busy");
               }
            } else {
               if (l_error_40 == 4300) {
                  Comments(8, "isErrorCloseOrder()", "Ошибка закрытия ордера " + ls_44 + gsa_2272[ai_0][4] + " (" + DoubleToStr(gda_2260[ai_0][5], g_digits_2028) + "): продолжительность сделки менее " +
                     MinOrderLifeTime + "с", "Error to close " + ls_44 + gsa_2272[ai_0][4] + " order" + " (" + DoubleToStr(gda_2260[ai_0][5], g_digits_2028) + "): order lifetime is less then " + MinOrderLifeTime + "c");
               } else {
                  Comments(8, "isErrorCloseOrder()", "Ошибка закрытия ордера " + ls_44 + gsa_2272[ai_0][4] + " (" + DoubleToStr(gda_2260[ai_0][5], g_digits_2028) + "): " + PrintError(l_error_40), "Error to close " +
                     ls_44 + gsa_2272[ai_0][4] + " order" + " (" + DoubleToStr(gda_2260[ai_0][5], g_digits_2028) + "): " + PrintError(l_error_40));
               }
            }
         }
      }
   }
   return (li_ret_8);
}

bool SendOrder(int ai_0, int a_cmd_4, int ai_8, int ai_12) {
   int li_28;
   string ls_92;
   int l_cmd_100;
   int l_cmd_104;
   double l_lots_108;
   double l_lots_116;
   double l_ord_open_price_124;
   double l_ord_open_price_132;
   int l_ticket_140;
   int l_ticket_144;
   color l_color_148;
   int l_ticket_16 = 0;
   int l_error_24 = 9999;
   bool li_ret_32 = FALSE;
   bool li_36 = TRUE;
   bool li_40 = TRUE;
   if (TimeCurrent() - gia_2268[ai_0][4] < gi_196 * gia_2264[ai_0][13] / 1000) return (li_ret_32);
   double ld_unused_52 = gd_2004;
   double ld_unused_60 = gd_2012;
   double l_price_68 = ai_8 / 10.0;
   double l_price_76 = ai_12 / 10.0;
   string ls_84 = "";
   if (a_cmd_4 == OP_BUY) ls_92 = "Buy";
   if (a_cmd_4 == OP_SELL) ls_92 = "Sell";
   if (CrossOverMode) ls_92 = "cross-" + ls_92;
   double l_lots_44 = LotsForTrade(gs_1836);
   if (!CrossOverMode) {
      if (l_price_68 != 0.0 && !InvisibleStopLoss) {
         if (l_price_68 < StopLevel_Value) l_price_68 = StopLevel_Value;
         if (a_cmd_4 == OP_BUY) l_price_68 = NormalizeDouble(gd_2012 + l_price_68 * Point_Value, g_digits_2028);
         if (a_cmd_4 == OP_SELL) l_price_68 = NormalizeDouble(gd_2012 + l_price_68 * Point_Value, g_digits_2028);
      }
      if (l_price_76 != 0.0) {
         if (l_price_76 < StopLevel_Value) l_price_76 = StopLevel_Value;
         if (a_cmd_4 == OP_BUY) l_price_76 = NormalizeDouble(gd_2012 - l_price_76 * Point_Value, g_digits_2028);
         if (a_cmd_4 == OP_SELL) l_price_76 = NormalizeDouble(gd_2012 - l_price_76 * Point_Value, g_digits_2028);
      }
      if (g_str2int_260 && !TradeTransferOut) {
         l_price_68 = 0;
         l_price_76 = 0;
      }
   }
   if ((TimeCurrent() - gia_2268[ai_0][4]) / 60 > g_str2int_300) {
      Comments(8, "SendOrder()", "Не удалось повторить открытие ордера " + ls_92 + gsa_2272[ai_0][4] + ", истекло время ожидания повтора", "Unable to reopen " + ls_92 +
         gsa_2272[ai_0][4] + " order, time is over");
     ClearBuffer("OSbuffer", ai_0);
      return (li_ret_32);
   }
   if (a_cmd_4 == OP_BUY) li_28 = MathRound((gd_2012 - gda_2260[ai_0][6]) / Point_Value);
   if (a_cmd_4 == OP_SELL) li_28 = MathRound((gda_2260[ai_0][6] - gd_2004) / Point_Value);
   if (li_28 >= gi_368 && gi_368 > 0) {
      Comments(8, "SendOrder()", "Не удалось повторить открытие ордера " + ls_92 + gsa_2272[ai_0][4] + ", профит отработан (" + DoubleToStr(gda_2260[ai_0][6], g_digits_2028) +
         ")", "Unable to reopen " + ls_92 + gsa_2272[ai_0][4] + " order, profit worked by (" + DoubleToStr(gda_2260[ai_0][6], g_digits_2028) + ")");
     ClearBuffer("OSbuffer", ai_0);
      return (li_ret_32);
   }
   if (a_cmd_4 == OP_BUY)
      if (gd_2004 > gda_2260[ai_0][6]) return (li_ret_32);
   if (a_cmd_4 == OP_SELL)
      if (gd_2012 < gda_2260[ai_0][6]) return (li_ret_32);
   gia_2264[ai_0][13]++;
   if (gia_2264[ai_0][13] > 1) {
      if (a_cmd_4 == OP_BUY) {
         Comments(8, "SendOrder()", "Повтор открытия ордера " + ls_92 + gsa_2272[ai_0][4] + " (" + DoubleToStr(gd_2004, g_digits_2028) + "/" + DoubleToStr(gda_2260[ai_0][6], g_digits_2028) +
            "), попытка " + gia_2264[ai_0][13], "Try to reopen " + ls_92 + gsa_2272[ai_0][4] + " (" + DoubleToStr(gda_2260[ai_0][6], g_digits_2028) + "), trial " + gia_2264[ai_0][13]);
      }
      if (a_cmd_4 == OP_SELL) {
         Comments(8, "SendOrder()", "Повтор открытия ордера " + ls_92 + gsa_2272[ai_0][4] + " (" + DoubleToStr(gd_2012, g_digits_2028) + "/" + DoubleToStr(gda_2260[ai_0][6], g_digits_2028) +
            "), попытка " + gia_2264[ai_0][13], "Try to reopen " + ls_92 + gsa_2272[ai_0][4] + " (" + DoubleToStr(gda_2260[ai_0][6], g_digits_2028) + "), trial " + gia_2264[ai_0][13]);
      }
   }
   if (l_lots_44 <= 0.0) {
      Comments(8, "SendOrder()", "Ошибка открытия ордера " + ls_92 + gsa_2272[ai_0][4] + " : Недостаточно денег", "Error open " + ls_92 + gsa_2272[ai_0][4] + " order : Not enough money");
      return (FALSE);
   }
   if (!IsTradeAllowed()) {
      if (!ErrorComment) Comments(8, "SendOrder()", "Ошибка открытия ордера " + ls_92 + gsa_2272[ai_0][4] + " : торговый поток занят", "Error open " + ls_92 + gsa_2272[ai_0][4] + " order : trade context busy");
      return (FALSE);
   }
   int li_20 = GetTickCount();
   if (!CrossOverMode) {
      l_ticket_16 = -1;
      if (a_cmd_4 == OP_BUY) l_ticket_16 = OrderSend(Symbol(), a_cmd_4, l_lots_44, Ask, g_slippage_316, l_price_68, l_price_76, "", g_magic_1272, 0, Blue);
      if (a_cmd_4 == OP_SELL) l_ticket_16 = OrderSend(Symbol(), a_cmd_4, l_lots_44, Bid, g_slippage_316, l_price_68, l_price_76, "", g_magic_1272, 0, Red);
      if (l_ticket_16 >= 0) {
         if (OrderSelect(l_ticket_16, SELECT_BY_TICKET, MODE_TRADES)) {
            gda_2260[ai_0][0] = 0.0;
            gda_2260[ai_0][1] = OrderOpenPrice();
            gda_2260[ai_0][2] = OrderStopLoss();
            gda_2260[ai_0][3] = OrderTakeProfit();
            gda_2260[ai_0][4] = OrderProfit();
            gia_2268[ai_0][1] = OrderOpenTime();
            if (a_cmd_4 == OP_BUY) gia_2264[ai_0][10] = MathRound((gd_2012 - OrderOpenPrice()) / Point_Value);
            if (a_cmd_4 == OP_SELL) gia_2264[ai_0][10] = MathRound((OrderOpenPrice() - gd_2004) / Point_Value);
            gia_2264[ai_0][1] = OrderType();
            gia_2264[ai_0][2] = OrderMagicNumber();
            gsa_2272[ai_0][0] = OrderTicket();
            gsa_2272[ai_0][1] = OrderSymbol();
            gsa_2272[ai_0][2] = gs_1836;
            gda_2260[ai_0][7] = OrderLots();
            gda_2260[ai_0][5] = 0.0;
            gia_2268[ai_0][0] = OrderCloseTime();
            gia_2268[ai_0][2] = Time[0];
            gia_2268[ai_0][5] = 0;
            gia_2264[ai_0][3] = 0;
            if (a_cmd_4 == OP_SELL) gia_2264[ai_0][4] = MathRound((gda_2260[ai_0][1] - gda_2260[ai_0][6]) / Point_Value);
            if (a_cmd_4 == OP_BUY) gia_2264[ai_0][4] = MathRound((gda_2260[ai_0][6] - gda_2260[ai_0][1]) / Point_Value);
            gia_2264[ai_0][5] = 0;
            gia_2264[ai_0][6] = gd_1996;
            gia_2264[ai_0][7] = 0;
            gia_2264[ai_0][8] = gi_1220;
            gia_2264[ai_0][9] = 0;
            gia_2264[ai_0][11] = GetTickCount() - li_20;
            gia_2264[ai_0][12] = 0;
            gia_2264[ai_0][14] = 0;
            if (a_cmd_4 == OP_BUY) gi_1188 = MathRound((gda_2260[ai_0][1] - gda_2260[ai_0][6]) / Point_Value);
            if (a_cmd_4 == OP_SELL) gi_1188 = MathRound((gda_2260[ai_0][6] - gda_2260[ai_0][1]) / Point_Value);
            gi_unused_1228 = Bars;
            gd_unused_1528 = 0;
            if (gi_312) {
               if (gi_1188 > gi_368) gi_1188 = gi_368;
               ls_84 = ls_84 + ", SlippageCorrection=" + (-1 * gi_1188);
            } else gi_1188 = 0;
            if (UseSpreadCorrection) ls_84 = ls_84 + ", SpreadDifference=" + gi_1220;
            Comments(8, "SendOrder()", "Открыт " + ls_92 + gsa_2272[ai_0][4] + " ордер : " + DoubleToStr(gda_2260[ai_0][1], g_digits_2028) + " (" + DoubleToStr(gda_2260[ai_0][6], g_digits_2028) +
               ")" + ", Lots=" + DoubleToStr(gda_2260[ai_0][7], 2) + ", Slippage=" + gia_2264[ai_0][4] + ", Spread=" + gia_2264[ai_0][6] + ls_84, "" + ls_92 + gsa_2272[ai_0][4] + " order opened : " + DoubleToStr(gda_2260[ai_0][1], g_digits_2028) + " (" + DoubleToStr(gda_2260[ai_0][6], g_digits_2028) + ")" + ", Lots=" + DoubleToStr(gda_2260[ai_0][7], 2) + ", Slippage=" + gia_2264[ai_0][4] + ", Spread=" + gia_2264[ai_0][6] + ls_84);
            li_ret_32 = TRUE;
         } else Comments(9, "SendOrder()", "Open OrderSelect=0 (" + l_ticket_16 + "): " + PrintError(GetLastError()), "Open OrderSelect=0 (" + l_ticket_16 + "): " + PrintError(GetLastError()));
      } else l_error_24 = GetLastError();
   } else {
      li_ret_32 = FALSE;
      CheckCrossOverMode();
      l_cmd_100 = function_72(g_symbol_2032, a_cmd_4);
      l_cmd_104 = function_72(g_symbol_2040, a_cmd_4);
      l_lots_108 = LotsForTrade(g_symbol_2032);
      l_lots_116 = LotsForTrade(g_symbol_2040);
      if (l_cmd_100 == OP_SELL) l_color_148 = Red;
      else l_color_148 = Blue;
      Comments(9, "", "Открываем ордер по левой паре (" + g_symbol_2032 + "," + l_cmd_100 + "," + l_lots_108 + "," + function_73(g_symbol_2032, a_cmd_4) + ")", "Open left pair order (" +
         g_symbol_2032 + "," + l_cmd_100 + "," + l_lots_108 + "," + function_73(g_symbol_2032, a_cmd_4) + ")");
      l_ticket_16 = -1;
      l_ticket_16 = OrderSend(g_symbol_2032, l_cmd_100, l_lots_108, function_73(g_symbol_2032, a_cmd_4), g_slippage_316 / dig * gi_2072, 0, 0, "", g_magic_1272, 0, l_color_148);
      l_error_24 = GetLastError();
      if (l_ticket_16 >= 0) {
         li_ret_32 = FALSE;
         function_93(0);
         while (!li_ret_32) {
            if (OrderSelect(l_ticket_16, SELECT_BY_TICKET, MODE_TRADES)) {
               l_ord_open_price_124 = OrderOpenPrice();
               l_ticket_140 = OrderTicket();
               li_ret_32 = TRUE;
            } else {
               Comments(9, "SendOrder()", "crL Open OrderSelect=0 (" + l_ticket_16 + "): " + PrintError(GetLastError()), "crL Open OrderSelect=0 (" + l_ticket_16 + "): " +
                  PrintError(GetLastError()));
               if (function_93(gi_204)) return (FALSE);
               Sleep(500);
            }
         }
         li_ret_32 = FALSE;
         l_ticket_16 = -1;
         function_93(0);
         while (!li_ret_32) {
            CheckCrossOverMode();
            Comments(9, "", "Открываем ордер по правой паре " + l_cmd_104 + "(" + g_symbol_2040 + "," + l_cmd_104 + "," + l_lots_116 + "," + function_73(g_symbol_2040, a_cmd_4) +
               ")", "Open right pair order " + l_cmd_104 + "(" + g_symbol_2040 + "," + l_cmd_104 + "," + l_lots_116 + "," + function_73(g_symbol_2040, a_cmd_4) + ")");
            if (l_cmd_104 == OP_SELL) l_color_148 = Red;
            else l_color_148 = Blue;
            l_ticket_16 = OrderSend(g_symbol_2040, l_cmd_104, l_lots_116, function_73(g_symbol_2040, a_cmd_4), g_slippage_316 / dig * gi_2076, 0, 0, "", g_magic_1272, 0, l_color_148);
            l_error_24 = GetLastError();
            if (l_ticket_16 < 0) {
               Comments(9, "", "SELL по правой паре не открылся : " + PrintError(l_error_24), "SELL right pair order is not opened : " + PrintError(l_error_24));
               gia_2264[ai_0][13]++;
               if (function_93(gi_204)) return (FALSE);
               Sleep(gi_196);
            } else li_ret_32 = TRUE;
         }
         li_ret_32 = FALSE;
         function_93(0);
         while (!li_ret_32) {
            if (OrderSelect(l_ticket_16, SELECT_BY_TICKET, MODE_TRADES)) {
               li_ret_32 = TRUE;
               l_ord_open_price_132 = OrderOpenPrice();
               l_ticket_144 = OrderTicket();
               gda_2260[ai_0][1] = function_70(l_ord_open_price_124, l_ord_open_price_132);
               gda_2260[ai_0][4] = 0.0;
               gia_2268[ai_0][1] = OrderOpenTime();
               if (a_cmd_4 == OP_BUY) gia_2264[ai_0][10] = MathRound((gd_2012 - gda_2260[ai_0][1]) / Point_Value);
               if (a_cmd_4 == OP_SELL) gia_2264[ai_0][10] = MathRound((gda_2260[ai_0][1] - gd_2004) / Point_Value);
               gia_2264[ai_0][1] = a_cmd_4;
               gia_2264[ai_0][2] = OrderMagicNumber();
               gsa_2272[ai_0][0] = l_ticket_140 + "/" + l_ticket_144;
               gsa_2272[ai_0][1] = g_symbol_2032 + "/" + g_symbol_2040;
               gsa_2272[ai_0][2] = gs_2048 + "/" + gs_2056;
               gda_2260[ai_0][7] = l_lots_108;
               gia_2268[ai_0][2] = Time[0];
               gia_2264[ai_0][3] = 0;
               if (a_cmd_4 == OP_SELL) gia_2264[ai_0][4] = MathRound((gda_2260[ai_0][1] - gda_2260[ai_0][6]) / Point_Value);
               if (a_cmd_4 == OP_BUY) gia_2264[ai_0][4] = MathRound((gda_2260[ai_0][6] - gda_2260[ai_0][1]) / Point_Value);
               gia_2264[ai_0][6] = gd_1996;
               gia_2264[ai_0][8] = gi_1220;
               gia_2264[ai_0][11] = GetTickCount() - li_20;
               if (a_cmd_4 == OP_BUY) gi_1188 = MathRound((gda_2260[ai_0][1] - gda_2260[ai_0][6]) / Point_Value);
               if (a_cmd_4 == OP_SELL) gi_1188 = MathRound((gda_2260[ai_0][6] - gda_2260[ai_0][1]) / Point_Value);
               gi_unused_1228 = Bars;
               gd_unused_1528 = 0;
               if (gi_312) {
                  if (gi_1188 > gi_368) gi_1188 = gi_368;
                  ls_84 = ls_84 + ", SlippageCorrection=" + (-1 * gi_1188);
               } else gi_1188 = 0;
               if (UseSpreadCorrection) ls_84 = ls_84 + ", SpreadDifference=" + gi_1220;
               Comments(8, "SendOrder()", "Открыт " + ls_92 + gsa_2272[ai_0][4] + " ордер : " + DoubleToStr(gda_2260[ai_0][1], g_digits_2028) + " (" + DoubleToStr(gda_2260[ai_0][6], g_digits_2028) +
                  ")" + ", Lots=" + DoubleToStr(gda_2260[ai_0][7], 2) + ", Slippage=" + gia_2264[ai_0][4] + ", Spread=" + gia_2264[ai_0][6] + ls_84, "" + ls_92 + gsa_2272[ai_0][4] + " order opened : " + DoubleToStr(gda_2260[ai_0][1], g_digits_2028) + " (" + DoubleToStr(gda_2260[ai_0][6], g_digits_2028) + ")" + ", Lots=" + DoubleToStr(gda_2260[ai_0][7], 2) + ", Slippage=" + gia_2264[ai_0][4] + ", Spread=" + gia_2264[ai_0][6] + ls_84);
            } else {
               Comments(9, "SendOrder()", "crR Open OrderSelect=0 (" + l_ticket_16 + "): " + PrintError(GetLastError()), "crR Open OrderSelect=0 (" + l_ticket_16 + "): " +
                  PrintError(GetLastError()));
               if (function_93(gi_204)) return (FALSE);
               Sleep(500);
            }
         }
      } else Comments(9, "", "SELL по левой паре не открылся", "SELL left pair order is not opened");
   }
   if (!li_ret_32) {
      if (g_str2int_296) {
         if (li_36) {
            Comments(8, "SendOrder()", "Ошибка открытия ордера " + ls_92 + gsa_2272[ai_0][4] + ", ожидание повтора : " + PrintError(l_error_24) + " (" + DoubleToStr(gda_2260[ai_0][6], g_digits_2028) +
               ")", "Error open " + ls_92 + gsa_2272[ai_0][4] + " order, waiting for repeat : " + PrintError(l_error_24) + " (" + DoubleToStr(gda_2260[ai_0][6], g_digits_2028) + ")");
         } else {
            if (!ErrorComment) {
               Comments(8, "SendOrder()", "Ошибка открытия ордера " + ls_92 + gsa_2272[ai_0][4] + ", ожидание повтора : торговый поток занят", "Error open " + ls_92 + gsa_2272[ai_0][4] +
                  " order, waiting for repeat : trade context busy");
            }
         }
      } else {
         if (li_36) {
            if (li_40) {
               Comments(8, "SendOrder()", "Ошибка открытия ордера " + ls_92 + gsa_2272[ai_0][4] + " : " + PrintError(l_error_24) + " (" + DoubleToStr(gda_2260[ai_0][6], g_digits_2028) +
                  ")", "Error open " + ls_92 + gsa_2272[ai_0][4] + " order : " + PrintError(l_error_24) + " (" + DoubleToStr(gda_2260[ai_0][6], g_digits_2028) + ")");
            } else Comments(8, "SendOrder()", "Ошибка открытия ордера " + ls_92 + gsa_2272[ai_0][4] + " : изменилась цена", "Error open " + ls_92 + gsa_2272[ai_0][4] + " order : rate changed");
         } else
            if (!ErrorComment) Comments(8, "SendOrder()", "Ошибка открытия ордера " + ls_92 + gsa_2272[ai_0][4] + " : торговый поток занят", "Error open " + ls_92 + gsa_2272[ai_0][4] + " order : trade context busy");
      }
   }
   return (li_ret_32);
}

bool function_11() {
   double ld_4;
   double ld_12;
   bool li_ret_0 = FALSE;
   if (g_str2int_344) {
      if (OrderStopLoss() != 0.0 || OrderTakeProfit() != 0.0) {
         if (OrderType() == OP_BUY) ld_4 = gd_2012;
         if (OrderType() == OP_SELL) ld_4 = gd_2004;
         ld_12 = gd_2124 * Point_Value;
         if (OrderStopLoss() != 0.0 && ld_12 > MathAbs(ld_4 - OrderStopLoss())) li_ret_0 = TRUE;
         if (OrderTakeProfit() != 0.0 && ld_12 > MathAbs(ld_4 - OrderTakeProfit())) li_ret_0 = TRUE;
      }
   }
   return (li_ret_0);
}

int isOrderClose(int ai_0) {
   string ls_16;
   string ls_40;
   string ls_48;
   string ls_unused_56;
   string ls_unused_64;
   string ls_72;
   string ls_unused_80;
   string ls_unused_88;
   double l_ord_open_price_96;
   double ld_104;
   double ld_112;
   double l_ord_profit_120;
   double l_ord_open_price_128;
   double l_ord_profit_136;
   double l_ord_lots_144;
   double l_ord_lots_152;
   int l_cmd_160;
   int l_cmd_168;
   int l_datetime_176;
   int l_datetime_180;
   int l_datetime_184;
   int l_datetime_188;
   bool li_192;
   bool li_196;
   string l_name_200;
   int l_file_208;
   string ls_212;
   string ls_unused_220;
   int l_str2int_4 = 0;
   double l_global_var_8 = 0.0;
   string ls_24 = "";
   string ls_32 = "";
   if (!CrossOverMode) {
      if (gia_2264[ai_0][0] == 98) {
         if (OrderSelect(StrToInteger(gsa_2272[ai_0][0]), SELECT_BY_TICKET)) {
            if (OrderCloseTime() > 0) {
               gia_2264[ai_0][1] = OrderType();
               if (gia_2264[ai_0][1] == 0) ls_40 = "Buy";
               if (gia_2264[ai_0][1] == 1) ls_40 = "Sell";
               gda_2260[ai_0][0] = OrderClosePrice();
               gda_2260[ai_0][1] = OrderOpenPrice();
               gda_2260[ai_0][2] = OrderStopLoss();
               gda_2260[ai_0][3] = OrderTakeProfit();
               gda_2260[ai_0][4] = OrderProfit();
               gia_2268[ai_0][0] = OrderCloseTime();
               gia_2268[ai_0][1] = OrderOpenTime();
               gia_2264[ai_0][3] = gia_2268[ai_0][0] - gia_2268[ai_0][1];
               gia_2264[ai_0][2] = OrderMagicNumber();
               gsa_2272[ai_0][0] = OrderTicket();
               gsa_2272[ai_0][1] = OrderSymbol();
               gsa_2272[ai_0][2] = gs_1836;
               gda_2260[ai_0][7] = OrderLots();
               l_str2int_4 = StrToInteger(gsa_2272[ai_0][0]);
               l_global_var_8 = GlobalVariableGet(g_var_name_1924);
               ls_32 = MarginControl(l_str2int_4);
               if (!RestoreLostProfit) ls_32 = "";
               if (gia_2264[ai_0][1] == 1) {
                  gia_2264[ai_0][10] = MathRound((gda_2260[ai_0][1] - gda_2260[ai_0][0]) / Point_Value);
                  gia_2264[ai_0][4] = MathRound((gda_2260[ai_0][1] - gda_2260[ai_0][6]) / Point_Value);
                  gia_2264[ai_0][5] = MathRound((gda_2260[ai_0][5] - gda_2260[ai_0][0]) / Point_Value);
               }
               if (gia_2264[ai_0][1] == 0) {
                  gia_2264[ai_0][10] = MathRound((gda_2260[ai_0][0] - gda_2260[ai_0][1]) / Point_Value);
                  gia_2264[ai_0][4] = MathRound((gda_2260[ai_0][6] - gda_2260[ai_0][1]) / Point_Value);
                  gia_2264[ai_0][5] = MathRound((gda_2260[ai_0][0] - gda_2260[ai_0][5]) / Point_Value);
               }
               ls_16 = " (Slippage o/c=" + gia_2264[ai_0][4] + "/" + gia_2264[ai_0][5] + ", Spread o/c=" + gia_2264[ai_0][6] + "/" + gia_2264[ai_0][7] + ", ProfitPoint=" + gia_2264[ai_0][10] +
                  ls_32 + ")";
               Comments(8, "isOrderClose()", "Ордер " + ls_40 + gsa_2272[ai_0][4] + " закрыт : " + DoubleToStr(gda_2260[ai_0][0], g_digits_2028) + " (" + DoubleToStr(gda_2260[ai_0][5], g_digits_2028) +
                  ") Slippage=" + gia_2264[ai_0][5] + ls_16, ls_40 + gsa_2272[ai_0][4] + " order closed : " + DoubleToStr(gda_2260[ai_0][0], g_digits_2028) + " (" + DoubleToStr(gda_2260[ai_0][5], g_digits_2028) + "), Slippage=" + gia_2264[ai_0][5] + ls_16);
               function_13(ai_0, 98);
            }
         } else {
            Comments(9, "isOrderClose()", "isOrderClose OrderSelect=0 (" + gsa_2272[ai_0][0] + "): " + PrintError(GetLastError()), "isOrderClose OrderSelect=0 (" + gsa_2272[ai_0][0] +
               "): " + PrintError(GetLastError()));
         }
      }
      if (gia_2264[ai_0][0] == 94) {
         if (OrderSelect(StrToInteger(gsa_2272[ai_0][0]), SELECT_BY_TICKET)) {
            if (OrderCloseTime() > 0) {
               gia_2264[ai_0][1] = OrderType();
               if (gia_2264[ai_0][1] == 0) ls_40 = "Buy";
               if (gia_2264[ai_0][1] == 1) ls_40 = "Sell";
               if (CrossOverMode) ls_40 = "cross-" + ls_40;
               gda_2260[ai_0][0] = OrderClosePrice();
               gda_2260[ai_0][1] = OrderOpenPrice();
               gda_2260[ai_0][2] = OrderStopLoss();
               gda_2260[ai_0][3] = OrderTakeProfit();
               gda_2260[ai_0][4] = OrderProfit();
               gia_2268[ai_0][0] = OrderCloseTime();
               gia_2268[ai_0][1] = OrderOpenTime();
               gia_2264[ai_0][3] = gia_2268[ai_0][0] - gia_2268[ai_0][1];
               gia_2264[ai_0][2] = OrderMagicNumber();
               gsa_2272[ai_0][0] = OrderTicket();
               gsa_2272[ai_0][1] = OrderSymbol();
               gsa_2272[ai_0][2] = gs_1836;
               gda_2260[ai_0][7] = OrderLots();
               gia_2264[ai_0][7] = 0;
               gia_2264[ai_0][5] = 0;
               l_str2int_4 = StrToInteger(gsa_2272[ai_0][0]);
               l_global_var_8 = GlobalVariableGet(g_var_name_1924);
               ls_32 = MarginControl(l_str2int_4);
               if (!RestoreLostProfit) ls_32 = "";
               if (gia_2264[ai_0][1] == 1) {
                  gia_2264[ai_0][10] = MathRound((gda_2260[ai_0][1] - gda_2260[ai_0][0]) / Point_Value);
                  gia_2264[ai_0][4] = MathRound((gda_2260[ai_0][1] - gda_2260[ai_0][6]) / Point_Value);
               }
               if (gia_2264[ai_0][1] == 0) {
                  gia_2264[ai_0][10] = MathRound((gda_2260[ai_0][0] - gda_2260[ai_0][1]) / Point_Value);
                  gia_2264[ai_0][4] = MathRound((gda_2260[ai_0][6] - gda_2260[ai_0][1]) / Point_Value);
               }
               ls_24 = "";
               if (StringFind(OrderComment(), "[tp]", 0) >= 0 || (OrderClosePrice() == OrderTakeProfit() && OrderTakeProfit() != 0.0)) {
                  ls_16 = " (Slippage o/c=" + gia_2264[ai_0][4] + "/..., Spread o/c=" + gia_2264[ai_0][6] + "/..., ProfitPoint=" + gia_2264[ai_0][10] + ls_32 + ")";
                  Comments(8, "isOrderClose()", "Ордер " + ls_40 + gsa_2272[ai_0][4] + " закрыт по TakeProfit (" + DoubleToStr(gda_2260[ai_0][0], g_digits_2028) + " (" + DoubleToStr(gda_2260[ai_0][5], g_digits_2028) +
                     "), Slippage=" + gia_2264[ai_0][5] + ls_16, ls_40 + gsa_2272[ai_0][4] + " order closed by TakeProfit (" + DoubleToStr(gda_2260[ai_0][0], g_digits_2028) + " (" + DoubleToStr(gda_2260[ai_0][5], g_digits_2028) + "), Slippage=" + gia_2264[ai_0][5] + ls_16);
                  ls_24 = "TP";
                  OrderProfitBuffer[28] += 1.0;
                  if (gi_932) {
                     gi_1648 = TRUE;
                     GlobalVariableSet(g_var_name_1940, gi_1380);
                     Comments(8, "isOrderClose()", "Торговля заблокирована: Ордер закрыт по TakeProfit", "Trade stoped: Order closed by TakeProfit");
                  }
               }
               if (StringFind(OrderComment(), "[sl]", 0) >= 0 || (OrderClosePrice() == OrderStopLoss() && OrderStopLoss() != 0.0)) {
                  ls_16 = " (Slippage o/c=" + gia_2264[ai_0][4] + "/..., Spread o/c=" + gia_2264[ai_0][6] + "/..., ProfitPoint=" + gia_2264[ai_0][10] + ls_32 + ")";
                  Comments(8, "isOrderClose()", "Ордер " + ls_40 + gsa_2272[ai_0][4] + " закрыт по StopLoss (" + DoubleToStr(gda_2260[ai_0][0], g_digits_2028) + " (" + DoubleToStr(gda_2260[ai_0][5], g_digits_2028) +
                     "), Slippage=" + gia_2264[ai_0][5] + ls_16, ls_40 + gsa_2272[ai_0][4] + " order closed by StopLoss (" + DoubleToStr(gda_2260[ai_0][0], g_digits_2028) + " (" + DoubleToStr(gda_2260[ai_0][5], g_digits_2028) + "), Slippage=" + gia_2264[ai_0][5] + ls_16);
                  ls_24 = "SL";
                  OrderProfitBuffer[27] += 1.0;
                  if (gi_928) {
                     gi_1648 = TRUE;
                     GlobalVariableSet(g_var_name_1940, gi_1380);
                     Comments(8, "isOrderClose()", "Торговля заблокирована: Ордер закрыт по StopLoss", "Trade stoped: Order closed by StopLoss");
                  }
               }
               if (StringFind(OrderComment(), "[isl]", 0) >= 0) {
                  ls_16 = " (Slippage o/c=" + gia_2264[ai_0][4] + "/..., Spread o/c=" + gia_2264[ai_0][6] + "/..., ProfitPoint=" + gia_2264[ai_0][10] + ls_32 + ")";
                  Comments(8, "isOrderClose()", "Ордер " + ls_40 + gsa_2272[ai_0][4] + " закрыт по iStopLoss (" + DoubleToStr(gda_2260[ai_0][0], g_digits_2028) + " (" + DoubleToStr(gda_2260[ai_0][5], g_digits_2028) +
                     "), Slippage=" + gia_2264[ai_0][5] + ls_16, ls_40 + gsa_2272[ai_0][4] + " order closed by iStopLoss (" + DoubleToStr(gda_2260[ai_0][0], g_digits_2028) + " (" + DoubleToStr(gda_2260[ai_0][5], g_digits_2028) + "), Slippage=" + gia_2264[ai_0][5] + ls_16);
                  ls_24 = "iSL";
                  OrderProfitBuffer[27] += 1.0;
                  if (gi_928) {
                     gi_1648 = TRUE;
                     GlobalVariableSet(g_var_name_1940, gi_1380);
                     Comments(8, "isOrderClose()", "Торговля заблокирована: Ордер закрыт по iStopLoss", "Trade stoped: Order closed by iStopLoss");
                  }
               }
               if (ls_24 == "") {
                  ls_16 = " (Slippage o/c=" + gia_2264[ai_0][4] + "/..., Spread o/c=" + gia_2264[ai_0][6] + "/..., ProfitPoint=" + gia_2264[ai_0][10] + ls_32 + ")";
                  Comments(8, "isOrderClose()", "Ордер " + ls_40 + gsa_2272[ai_0][4] + " закрыт вручную (" + DoubleToStr(gda_2260[ai_0][0], g_digits_2028) + " (" + DoubleToStr(gda_2260[ai_0][5], g_digits_2028) +
                     "), Slippage=" + gia_2264[ai_0][5] + ls_16, ls_40 + gsa_2272[ai_0][4] + " order closed by hand (" + DoubleToStr(gda_2260[ai_0][0], g_digits_2028) + " (" + DoubleToStr(gda_2260[ai_0][5], g_digits_2028) + "), Slippage=" + gia_2264[ai_0][5] + ls_16);
                  ls_24 = "H";
                  OrderProfitBuffer[29] += 1.0;
                  if (gi_1172) {
                     gi_1648 = TRUE;
                     GlobalVariableSet(g_var_name_1940, gi_1380);
                     Comments(8, "isOrderClose()", "Торговля заблокирована: Ордер закрыт вручную", "Trade stoped: Order closed by hand");
                  }
               }
               function_13(ai_0, 94);
            }
         } else {
            Comments(9, "isOrderClose()", "isOrderOutClose OrderSelect=0 (" + gsa_2272[ai_0][0] + "): " + PrintError(GetLastError()), "isOrderOutClose OrderSelect=0 (" + gsa_2272[ai_0][0] +
               "): " + PrintError(GetLastError()));
         }
      }
   } else {
      li_192 = FALSE;
      li_196 = FALSE;
      if (gia_2264[ai_0][0] == 98 || gia_2264[ai_0][0] == 94) {
         ls_48 = StrToInteger(StringSubstr(gsa_2272[ai_0][0], 0, StringFind(gsa_2272[ai_0][0], "/", 0)));
         if (OrderSelect(StrToInteger(ls_48), SELECT_BY_TICKET)) {
            if (OrderCloseTime() > 0) {
               ls_48 = OrderTicket();
               ls_unused_56 = g_symbol_2032;
               ls_unused_64 = gs_2048;
               l_ord_open_price_96 = OrderOpenPrice();
               ld_104 = OrderClosePrice();
               l_ord_lots_152 = OrderLots();
               l_ord_profit_120 = OrderProfit();
               l_cmd_160 = OrderType();
               l_datetime_176 = OrderOpenTime();
               l_datetime_184 = OrderCloseTime();
               li_192 = TRUE;
               ls_72 = StringSubstr(gsa_2272[ai_0][0], StringFind(gsa_2272[ai_0][0], "/", 0) + 1, 0);
               if (OrderSelect(StrToInteger(ls_72), SELECT_BY_TICKET)) {
                  if (OrderCloseTime() > 0) {
                     ls_72 = OrderTicket();
                     ls_unused_80 = g_symbol_2040;
                     ls_unused_88 = gs_2056;
                     l_ord_open_price_128 = OrderOpenPrice();
                     ld_112 = OrderClosePrice();
                     l_ord_lots_144 = OrderLots();
                     l_ord_profit_136 = OrderProfit();
                     l_cmd_168 = OrderType();
                     l_datetime_180 = OrderOpenTime();
                     l_datetime_188 = OrderCloseTime();
                     li_196 = TRUE;
                  }
               } else Comments(9, "isOrderClose()", "crR isOrderClose ticket=0 (" + ls_72 + "): " + PrintError(GetLastError()), "crR isOrderClose ticket=0 (" + ls_72 + "): " + PrintError(GetLastError()));
            }
         } else Comments(9, "isOrderClose()", "crL isOrderClose ticket=0 (" + ls_48 + "): " + PrintError(GetLastError()), "crL isOrderClose ticket=0 (" + ls_48 + "): " + PrintError(GetLastError()));
         if (li_192 && li_196) {
            gda_2260[ai_0][1] = function_70(l_ord_open_price_96, l_ord_open_price_128);
            gda_2260[ai_0][2] = 0.0;
            gda_2260[ai_0][3] = 0.0;
            gda_2260[ai_0][4] = l_ord_profit_120 + l_ord_profit_136;
            if (l_datetime_176 > l_datetime_180) gia_2268[ai_0][1] = l_datetime_176;
            else gia_2268[ai_0][1] = l_datetime_180;
            gia_2264[ai_0][1] = function_71(l_cmd_160, l_cmd_168);
            gia_2264[ai_0][2] = OrderMagicNumber();
            gsa_2272[ai_0][0] = ls_48 + "/" + ls_72;
            gsa_2272[ai_0][1] = g_symbol_2032 + "/" + g_symbol_2040;
            gsa_2272[ai_0][2] = gs_2048 + "/" + gs_2056;
            gda_2260[ai_0][7] = l_ord_lots_152;
            if (l_datetime_184 > l_datetime_188) gia_2268[ai_0][0] = l_datetime_184;
            else gia_2268[ai_0][0] = l_datetime_188;
            gda_2260[ai_0][0] = function_70(ld_104, ld_112);
            gia_2264[ai_0][3] = gia_2268[ai_0][0] - gia_2268[ai_0][1];
            if (gia_2264[ai_0][1] == 1) {
               gia_2264[ai_0][10] = MathRound((gda_2260[ai_0][1] - gda_2260[ai_0][0]) / Point_Value);
               gia_2264[ai_0][4] = MathRound((gda_2260[ai_0][1] - gda_2260[ai_0][6]) / Point_Value);
               if (gia_2264[ai_0][0] == 98) gia_2264[ai_0][5] = MathRound((gda_2260[ai_0][5] - gda_2260[ai_0][0]) / Point_Value);
            }
            if (gia_2264[ai_0][1] == 0) {
               gia_2264[ai_0][10] = MathRound((gda_2260[ai_0][0] - gda_2260[ai_0][1]) / Point_Value);
               gia_2264[ai_0][4] = MathRound((gda_2260[ai_0][6] - gda_2260[ai_0][1]) / Point_Value);
               if (gia_2264[ai_0][0] == 98) gia_2264[ai_0][5] = MathRound((gda_2260[ai_0][0] - gda_2260[ai_0][5]) / Point_Value);
            }
            if (gia_2264[ai_0][1] == 0) ls_40 = "Buy";
            if (gia_2264[ai_0][1] == 1) ls_40 = "Sell";
            if (CrossOverMode) ls_40 = "cross-" + ls_40;
            l_str2int_4 = 1;
            l_global_var_8 = GlobalVariableGet(g_var_name_1924);
            ls_32 = MarginControl(l_str2int_4);
            if (!RestoreLostProfit) ls_32 = "";
            if (gia_2264[ai_0][0] == 98) {
               ls_16 = " (Slippage o/c=" + gia_2264[ai_0][4] + "/" + gia_2264[ai_0][5] + ", Spread o/c=" + gia_2264[ai_0][6] + "/" + gia_2264[ai_0][7] + ", ProfitPoint=" + gia_2264[ai_0][10] +
                  ls_32 + ")";
               Comments(8, "isOrderClose()", "Ордер " + ls_40 + gsa_2272[ai_0][4] + " закрыт : " + DoubleToStr(gda_2260[ai_0][0], g_digits_2028) + " (" + DoubleToStr(gda_2260[ai_0][5], g_digits_2028) +
                  "), Slippage=" + gia_2264[ai_0][5] + ls_16, ls_40 + gsa_2272[ai_0][4] + " order closed : " + DoubleToStr(gda_2260[ai_0][0], g_digits_2028) + " (" + DoubleToStr(gda_2260[ai_0][5], g_digits_2028) + "), Slippage=" + gia_2264[ai_0][5] + ls_16);
               function_13(ai_0, 98);
            }
            if (gia_2264[ai_0][0] == 94) {
               ls_24 = "H";
               ls_16 = " (Slippage o/c=" + gia_2264[ai_0][4] + "/..., Spread o/c=" + gia_2264[ai_0][6] + "/..., ProfitPoint=" + gia_2264[ai_0][10] + ls_32 + ")";
               Comments(8, "isOrderClose()", "Ордер " + ls_40 + gsa_2272[ai_0][4] + " закрыт вручную (" + DoubleToStr(gda_2260[ai_0][0], g_digits_2028) + " (" + DoubleToStr(gda_2260[ai_0][5], g_digits_2028) +
                  "), Slippage=" + gia_2264[ai_0][5] + ls_16, ls_40 + gsa_2272[ai_0][4] + " order closed by hand (" + DoubleToStr(gda_2260[ai_0][0], g_digits_2028) + " (" + DoubleToStr(gda_2260[ai_0][5], g_digits_2028) + "), Slippage=" + gia_2264[ai_0][5] + ls_16);
               OrderProfitBuffer[29] += 1.0;
               if (gi_1172) {
                  gi_1648 = TRUE;
                  GlobalVariableSet(g_var_name_1940, gi_1380);
                  Comments(8, "isOrderClose()", "Торговля заблокирована: Ордер закрыт вручную", "Trade stoped: Order closed by hand");
               }
               function_13(ai_0, 94);
            }
         } else return (0);
      }
   }
   if (l_str2int_4 > 0) {
      if (!IsOptimization()) {
         l_name_200 = gs_1892 + ".csv";
         if (gi_1684 && IsTesting()) {
            gi_1684 = FALSE;
            FileDelete(l_name_200);
         }
         l_file_208 = FileOpen(l_name_200, FILE_CSV|FILE_WRITE|FILE_READ, ';');
         if (l_file_208 < 1) {
            Comments(8, "isOrderClose()", "Невозможно записать данные в файл " + l_name_200 + " :" + PrintError(GetLastError()), "Can not write to file " + l_name_200 + " :" +
               PrintError(GetLastError()));
         } else {
            if (FileSize(l_file_208) <= 0) {
               FileWrite(l_file_208, "Ticket", "Type", "Size", "Item", "", "", "", "Open", "", "", "TakeProfit", "StopLoss", "", "", "", "Close", "", "", "ProfitP", "Profit$", "Profit%", "LifeTime", "Balance", "MaxBalance", "Expert");
               FileWrite(l_file_208, "", "", "", "", "Time", "Delay", "Price", "Repeat", "Slippage", "Spread(Diff)", "", "", "Time", "Delay", "Price", "Repeat", "Slippage", "Spread(Diff)", "", "", "", "", "", "", "");
            }
            FileSeek(l_file_208, 0, SEEK_END);
            ls_212 = "";
            if (ls_24 == "") ls_24 = gia_2264[ai_0][5];
            if (gia_2264[ai_0][1] == 1) ls_212 = "sell";
            if (gia_2264[ai_0][1] == 0) ls_212 = "buy";
            if (CrossOverMode) ls_212 = "cr_" + ls_212;
            FileWrite(l_file_208, gsa_2272[ai_0][0], ls_212 + gsa_2272[ai_0][4], " " + DoubleToStr(gda_2260[ai_0][7], 2) + " (" + DoubleToStr(gda_2260[ai_0][7] * MarketInfo(Symbol(), MODE_LOTSIZE) / (AccountBalance() - gda_2260[ai_0][4]), 0) +
               "%/" + DoubleToStr(gda_2260[ai_0][7] * MarketInfo(Symbol(), MODE_LOTSIZE) / l_global_var_8, 0) + "%)", gsa_2272[ai_0][2], TimeToStr(gia_2268[ai_0][1], TIME_DATE|TIME_SECONDS) + " (" + NameDayOfWeek(gia_2268[ai_0][1]) + ")", gia_2264[ai_0][11], " " + DoubleToStr(gda_2260[ai_0][1], g_digits_2028), gia_2264[ai_0][13], gia_2264[ai_0][4], gia_2264[ai_0][6] + " (" + gia_2264[ai_0][8] + ")", " " + DoubleToStr(gda_2260[ai_0][3], g_digits_2028), " " + DoubleToStr(gda_2260[ai_0][2], g_digits_2028), TimeToStr(gia_2268[ai_0][0], TIME_DATE|TIME_SECONDS) + " (" + NameDayOfWeek(gia_2268[ai_0][0]) + ")", gia_2264[ai_0][12], " " + DoubleToStr(gda_2260[ai_0][0], g_digits_2028), gia_2264[ai_0][14], ls_24, gia_2264[ai_0][7] + " (" + gia_2264[ai_0][9] + ")", DoubleToStr(gia_2264[ai_0][10], 0), " " + DoubleToStr(gda_2260[ai_0][4], 2), " " + DoubleToStr(100.0 * gda_2260[ai_0][4] / (AccountBalance() - gda_2260[ai_0][4]), 1), gia_2264[ai_0][3], " " + DoubleToStr(AccountBalance(), 2), " " + DoubleToStr(GlobalVariableGet(g_var_name_1924), 2), WindowExpertName());
            FileClose(l_file_208);
         }
      }
     ClearBuffer("OSbuffer", ai_0);
   }
   return (l_str2int_4);
}

int function_13(int ai_0, int ai_4) {
   string l_name_8;
   color l_color_16;
   color l_color_20;
   int li_24;
   if (!IsOptimization()) {
      if (ai_4 == 95) {
         if (gia_2264[ai_0][1] == 0) {
            li_24 = 1;
            l_color_20 = Blue;
            l_name_8 = "Open " + gsa_2272[ai_0][0] + " buy  " + gs_1836 + " " + DoubleToStr(gda_2260[ai_0][7], 2) + " at " + DoubleToStr(gda_2260[ai_0][1], g_digits_2028);
            if (CrossOverMode) l_name_8 = "Open " + gsa_2272[ai_0][0] + " crbuy  " + gs_2048 + "/" + gs_2056 + " " + DoubleToStr(gda_2260[ai_0][7], 2) + " at " + DoubleToStr(gda_2260[ai_0][1], g_digits_2028);
         }
         if (gia_2264[ai_0][1] == 1) {
            li_24 = 2;
            l_color_20 = Red;
            l_name_8 = "Open " + gsa_2272[ai_0][0] + " sell  " + gs_1836 + " " + DoubleToStr(gda_2260[ai_0][7], 2) + " at " + DoubleToStr(gda_2260[ai_0][1], g_digits_2028);
            if (CrossOverMode) l_name_8 = "Open " + gsa_2272[ai_0][0] + " crsell  " + gs_2048 + "/" + gs_2056 + " " + DoubleToStr(gda_2260[ai_0][7], 2) + " at " + DoubleToStr(gda_2260[ai_0][1], g_digits_2028);
         }
         if (!ObjectCreate(l_name_8, OBJ_ARROW, 0, gia_2268[ai_0][1], gda_2260[ai_0][1])) Comments(9, "function_13()", "ObjectCreate ошибка: " + PrintError(GetLastError()), "ObjectCreate error: " + PrintError(GetLastError()));
         if (!ObjectSet(l_name_8, OBJPROP_ARROWCODE, li_24)) {
            Comments(9, "function_13()", "ObjectSet(OBJPROP_ARROWCODE," + li_24 + ") ошибка: " + PrintError(GetLastError()), "ObjectSet(OBJPROP_ARROWCODE," + li_24 + ") error: " +
               PrintError(GetLastError()));
         }
         if (!ObjectSet(l_name_8, OBJPROP_COLOR, l_color_20)) {
            Comments(9, "function_13()", "ObjectSet(OBJPROP_COLOR," + l_color_16 + ") ошибка: " + PrintError(GetLastError()), "ObjectSet(OBJPROP_COLOR," + l_color_16 + ") error: " +
               PrintError(GetLastError()));
         }
      }
      if (ai_4 == 94 || ai_4 == 98) {
         if (gia_2264[ai_0][1] == 0) {
            li_24 = 3;
            l_color_16 = Blue;
            l_color_20 = Blue;
            l_name_8 = "Close " + gsa_2272[ai_0][0] + " buy  " + gs_1836 + " " + DoubleToStr(gda_2260[ai_0][7], 2) + " at " + DoubleToStr(gda_2260[ai_0][0], g_digits_2028);
            if (CrossOverMode) l_name_8 = "Close " + gsa_2272[ai_0][0] + " crbuy  " + gs_2048 + "/" + gs_2056 + " " + DoubleToStr(gda_2260[ai_0][7], 2) + " at " + DoubleToStr(gda_2260[ai_0][0], g_digits_2028);
         }
         if (gia_2264[ai_0][1] == 1) {
            li_24 = 3;
            l_color_16 = Red;
            l_color_20 = Red;
            l_name_8 = "Close " + gsa_2272[ai_0][0] + " sell  " + gs_1836 + " " + DoubleToStr(gda_2260[ai_0][7], 2) + " at " + DoubleToStr(gda_2260[ai_0][0], g_digits_2028);
            if (CrossOverMode) l_name_8 = "Close " + gsa_2272[ai_0][0] + " crsell  " + gs_2048 + "/" + gs_2056 + " " + DoubleToStr(gda_2260[ai_0][7], 2) + " at " + DoubleToStr(gda_2260[ai_0][0], g_digits_2028);
         }
         if (ai_4 == 94) l_color_20 = Black;
         if (!ObjectCreate(l_name_8, OBJ_ARROW, 0, gia_2268[ai_0][0], gda_2260[ai_0][0])) Comments(9, "function_13()", "ObjectCreate ошибка: " + PrintError(GetLastError()), "ObjectCreate error: " + PrintError(GetLastError()));
         if (!ObjectSet(l_name_8, OBJPROP_ARROWCODE, li_24)) {
            Comments(9, "function_13()", "ObjectSet(OBJPROP_ARROWCODE," + li_24 + ") ошибка: " + PrintError(GetLastError()), "ObjectSet(OBJPROP_ARROWCODE," + li_24 + ") error: " +
               PrintError(GetLastError()));
         }
         if (!ObjectSet(l_name_8, OBJPROP_COLOR, l_color_20)) {
            Comments(9, "function_13()", "ObjectSet(OBJPROP_COLOR," + l_color_16 + ") ошибка: " + PrintError(GetLastError()), "ObjectSet(OBJPROP_COLOR," + l_color_16 + ") error: " +
               PrintError(GetLastError()));
         }
         l_name_8 = gsa_2272[ai_0][0] + DoubleToStr(gda_2260[ai_0][1], g_digits_2028) + "->" + DoubleToStr(gda_2260[ai_0][0], g_digits_2028);
         ObjectCreate(l_name_8, OBJ_TREND, 0, gia_2268[ai_0][1], gda_2260[ai_0][1], gia_2268[ai_0][0], gda_2260[ai_0][0]);
         ObjectSet(l_name_8, OBJPROP_STYLE, STYLE_DOT);
         ObjectSet(l_name_8, OBJPROP_WIDTH, 1);
         ObjectSet(l_name_8, OBJPROP_RAY, FALSE);
         ObjectSet(l_name_8, OBJPROP_COLOR, l_color_16);
      }
   }
   return (1);
}

string NameDayOfWeek(int ai_0) {
   if (TimeDayOfWeek(ai_0) == 0) return ("вс");
   if (TimeDayOfWeek(ai_0) == 1) return ("пн");
   if (TimeDayOfWeek(ai_0) == 2) return ("вт");
   if (TimeDayOfWeek(ai_0) == 3) return ("ср");
   if (TimeDayOfWeek(ai_0) == 4) return ("чт");
   if (TimeDayOfWeek(ai_0) == 5) return ("пт");
   if (TimeDayOfWeek(ai_0) == 6) return ("сб");
   return ("");
}

bool isNewBar() {
   bool li_ret_0 = FALSE;
   if (Time[0] != g_time_1364) {
      g_time_1364 = Time[0];
      li_ret_0 = TRUE;
   }
   return (li_ret_0);
}

bool isNewHour() {
   bool li_ret_0 = FALSE;
   if (Hour() != gi_1360) {
      gi_1360 = Hour();
      li_ret_0 = TRUE;
   }
   return (li_ret_0);
}

bool isNewDayOfWeek() {
   bool li_ret_0 = FALSE;
   if (DayOfWeek() != g_day_of_week_1348) {
      g_day_of_week_1348 = DayOfWeek();
      li_ret_0 = TRUE;
   }
   return (li_ret_0);
}

int GMTSWDifference() {
   bool li_ret_0 = FALSE;
   if (SWChangeMode == 1 || SWChangeMode == 3) {
      if (TimeCurrent() > gi_1768 && TimeCurrent() < gi_1780) li_ret_0 = TRUE;
      if (TimeCurrent() > gi_1784 && TimeCurrent() < gi_1772) li_ret_0 = TRUE;
   }
   if (SWChangeMode == 2)
      if (TimeCurrent() > gi_1768 || TimeCurrent() < gi_1772) li_ret_0 = TRUE;
   return (li_ret_0);
}

int StartRulls() {
   int li_0;
   if (isNewDayOfWeek()) {
      li_0 = CorrectionTime;
      CorrectionTime = GMTSWDifference();
      if (li_0 != CorrectionTime) {
         MakeInitString();
         if (CorrectionTime >= 0) Comments(8, "GMTSWDifference()", "Новое значение коррекции времени: Correction+" + CorrectionTime, "New value of time correcton: Correction+" + CorrectionTime);
         if (CorrectionTime < 0) Comments(8, "GMTSWDifference()", "Новое значение коррекции времени: Correction" + CorrectionTime, "New value of time correcton: Correction" + CorrectionTime);
      }
   }
   gi_1756 = isTimeCorrection(TimeCurrent());
   g_hour_1372 = TimeHour(gi_1756);
   g_day_of_week_1376 = TimeDayOfWeek(gi_1756);
   gi_1380 = TimeDay(gi_1756);
   g_month_1384 = TimeMonth(gi_1756);
   g_year_1388 = TimeYear(gi_1756);
   if (g_minute_1288 != TimeMinute(gi_1756)) {
      g_minute_1288 = TimeMinute(gi_1756);
      if (Language == "eng") gs_1908 = "Trade time CET " + TimeToStr(gi_1756, TIME_MINUTES);
      else gs_1908 = "Торговое время CET (MSK-2) " + TimeToStr(gi_1756, TIME_MINUTES);
      gs_1908 = gs_1908 
      + "\n";
      Comments(7, "", "", "");
   }
   function_81();
   function_78();
   CheckSpreadDifference();
   function_86(g_period_532, 1, g_ma_method_544, g_applied_price_548);
   double l_ima_4 = iMA(NULL, 0, g_period_532, 0, g_ma_method_544, g_applied_price_548, 1);
   if (IsOptimization() && !TradeHourOptimization) {
      if (OpenHourAM > 12) return (0);
      if (CloseHourAM > 12) return (0);
      if (OpenHourPM < 12) return (0);
      if (CloseHourPM < 12) return (0);
      if (OpenHourAM > CloseHourAM || OpenHourPM > CloseHourPM) return (0);
   }
   MarginControl(0);
   int li_12 = gi_1752;
   gi_1752 = FALSE;
   if (!CheckHystory()) gi_1752 = TRUE;
   if (!li_12 && gi_1752) Comments(8, "CheckHystory()", "Торговля заблокирована: Ожидается загрузка истории", "Trade stoped: No history");
   if (li_12 && !gi_1752) Comments(8, "CheckHystory()", "Торговля разрешена: История загружена", "Trade allowed: History loaded");
   li_12 = gi_1720;
   gi_1720 = FALSE;
   if (!isVolatilitytoTrade()) gi_1720 = TRUE;
   li_12 = gi_1700;
   gi_1700 = FALSE;
   if (!isSpreadtoTrade()) gi_1700 = TRUE;
   if (!li_12 && gi_1700 && gi_1068) {
      Comments(8, "isSpreadtoTrade()", "Торговля заблокирована: Превышен размер спреда (Spread=" + DoubleToStr(MarketInfo(Symbol(), MODE_SPREAD), 0) + ")", "Trade stoped: High spread value (Spread=" +
         DoubleToStr(MarketInfo(Symbol(), MODE_SPREAD), 0) + ")");
   }
   if (li_12 && !gi_1700 && gi_1068) {
      Comments(8, "isSpreadtoTrade()", "Торговля разрешена (Spread=" + DoubleToStr(MarketInfo(Symbol(), MODE_SPREAD), 0) + ")", "Trade allowed (Spread=" + DoubleToStr(MarketInfo(Symbol(), MODE_SPREAD), 0) +
         ")");
   }
   DrawDownAction(g_hour_1372);
   if (isNewBar()) gd_1496 = NormalizeDouble(100000.0 * (0.95 * GetMaxLotsPercent(0)) / MarketInfo(Symbol(), MODE_LOTSIZE), 2);
   if (isNewHour()) {
      SendMailReport();
      li_12 = gi_1724;
      gi_1724 = FALSE;
      if (!isTimetoTrade(gi_1756)) gi_1724 = TRUE;
      if (!li_12 && gi_1724) {
         Comments(8, "isTimetoTrade()", "Торговля заблокирована: Торговое время вышло", "Trade stoped: Trade time is over");
         gi_1648 = FALSE;
      }
      if (li_12 && !gi_1724) {
         gi_1416 = FALSE;
         Comments(8, "isTimetoTrade()", "Торговля разрешена: Торговое время началось", "Trade allowed: Trade time is started");
      }
   }
   CheckBlockByStopsDate();
   if (!gi_1652 && gi_1648) {
      Comments(8, "CheckBlockByStopsDate()", "Торговля заблокирована до следующей торговой сессии", "Trade is disabled until the next trading session");
      isBufferCleared();
   }
   gi_1652 = gi_1648;
   return (1);
}

int CheckSpreadDifference() {
   bool li_ret_0 = FALSE;
   if (UseSpreadCorrection) {
      gi_1220 = MathRound(WorkingSpreadValue - gd_1996);
      if (gi_1640) CorrectionSpreadValue = gi_1196;
      if (gi_1636) CorrectionSpreadValue = gi_1220;
   } else CorrectionSpreadValue = 0;
   return (li_ret_0);
}

int SendMailReport() {
   double l_global_var_8;
   double l_global_var_16;
   double ld_24;
   string ls_80;
   bool li_ret_0 = FALSE;
   bool li_4 = TRUE;
   string ls_32 = "";
   int l_error_40 = 0;
   int li_44 = TimeCurrent() - 3600 * (TimeZone + CorrectionTime);
   double ld_48 = 1.0 * TimeHour(li_44);
   double ld_56 = 1.0 * TimeDay(li_44);
   string ls_64 = " ";
   string ls_72 = "";
   if (UseMailReport) {
      if (!gi_1616) {
         gi_1616 = TRUE;
         if (!GlobalVariableCheck(g_var_name_1948) || !GlobalVariableCheck(g_var_name_1956) || IsTesting() || IsOptimization()) {
            if (GlobalVariableSet(g_var_name_1948, AccountBalance()) == 0 || GlobalVariableSet(g_var_name_1956, TimeDay(li_44 - 86400)) == 0) {
               Comments(8, "SendMailReport()", "Невозможно установить глоб. переменные для отправки отчета на e-mail", "Can not set global variables to send e-mail");
               UseMailReport = FALSE;
            }
         }
      }
      l_global_var_16 = GlobalVariableGet(g_var_name_1948);
      l_global_var_8 = GlobalVariableGet(g_var_name_1956);
      if ((l_global_var_8 != ld_56 && ld_56 != 6.0 && ld_56 != 0.0 && ld_48 >= 1.0 * MailReportTimeHour) || (AccountMargin() == 0.0 && gi_1620)) {
         if (AccountMargin() == 0.0 && gi_1620) {
            gi_1620 = FALSE;
            li_4 = FALSE;
         }
         ls_80 = gs_1844 + " " + AccountNumber();
         ls_32 = ls_32 + ls_80 + ls_64;
         ls_32 = ls_32 + TimeToStr(li_44, TIME_DATE|TIME_MINUTES) + " GMT" + ls_64;
         ls_32 = ls_32 + "Balance: " + DoubleToStr(AccountBalance(), 2) + AccountCurrency() + ls_64;
         ld_24 = AccountBalance() - l_global_var_16;
         ls_72 = "";
         if (AccountMargin() != 0.0) {
            gi_1620 = TRUE;
            if (AccountEquity() > AccountBalance()) ls_72 = "+";
            ls_32 = ls_32 + "Trades: " + ls_72 + DoubleToStr(AccountEquity() - AccountBalance(), 2) + AccountCurrency() + ls_64;
         }
         ls_72 = "";
         if (ld_24 > 0.0) ls_72 = "+";
         if (li_4) ls_32 = ls_32 + "DayProfit: " + ls_72 + DoubleToStr(ld_24, 2) + AccountCurrency();
         if (!IsTesting() && !IsOptimization()) {
            GetLastError();
            SendMail("report", ls_32);
            l_error_40 = GetLastError();
         }
         if (l_error_40 != 0/* NO_ERROR */) {
            Comments(8, "SendMailReport()", "Не удалось отправить отчет на e-mail: " + PrintError(l_error_40), "Can not send e-mail: " + PrintError(l_error_40));
            UseMailReport = FALSE;
         } else {
            Comments(8, "SendMailReport()", "Отправлен отчет на e-mail", "E-mail report sent");
            if (li_4) {
               GlobalVariableSet(g_var_name_1956, ld_56);
               GlobalVariableSet(g_var_name_1948, AccountBalance());
            }
            li_ret_0 = TRUE;
         }
      }
   }
   gi_2080 = StrToInteger(StringSubstr(g_var_name_1956, StringFind(g_var_name_1956, CharToStr(77), 0) - 2, 1)) - StrToInteger(Массив_источник[18][1]);
   return (li_ret_0);
}

int isProfitValuetoClose(int ai_0, int ai_4, string as_8) {
   bool li_ret_16 = FALSE;
   if (gia_2264[ai_0][10] >= ai_4) li_ret_16 = TRUE;
   if (li_ret_16 && as_8 != "MinProfit") {
      Comments(9, "!Test!", as_8 + " isProfitValuetoClose(" + ai_4 + "), CurOrdPrP=" + DoubleToStr(gd_1504, 2) + ", OptPV=" + gi_368 + ", SlCor=" + gi_1188 + ", SprCor=" + CorrectionSpreadValue, as_8 +
         " isProfitValuetoClose(" + ai_4 + "), CurOrdPrP=" + DoubleToStr(gd_1504, 2) + ", OptPV=" + gi_368 + ", SlCor=" + gi_1188 + ", SprCor=" + CorrectionSpreadValue);
   }
   return (li_ret_16);
}

int isInvisibleStopLosstoClose(int ai_0) {
   bool li_ret_4 = FALSE;
   if (InvisibleStopLoss) {
      if (StopLoss != 0) {
         if ((gd_1504 <= (-1 * StopLoss) + CorrectionSpreadValue && ai_0 == 1) || (gd_1504 <= (-1 * StopLoss) && ai_0 == 0)) {
            li_ret_4 = TRUE;
            gi_1696 = TRUE;
         }
      }
   }
   if (li_ret_4) {
      Comments(9, "!Test!", "isInvisibleStopLosstoClose(" + ai_0 + "), CurOrdPrP=" + DoubleToStr(gd_1504, 0) + ", SprCor=" + CorrectionSpreadValue, "isInvisibleStopLosstoClose(" + ai_0 + "), CurOrdPrP=" + DoubleToStr(gd_1504, 0) +
         ", SprCor=" + CorrectionSpreadValue);
   }
   return (li_ret_4);
}

bool isChanneltoOpen(int ai_0, int ChannelBOpen, int ai_8, int ai_12) {
   double ld_40;
   bool li_ret_16 = FALSE;
   double ld_24 = 0.0;
   double ld_32 = 0.0;
   if (ChannelBOpen == WHOLE_ARRAY) return (li_ret_16);
   if (gi_188) {
      for (int li_20 = 1; li_20 <= ChannelBOpen; li_20++)
         if (ld_24 < gda_2276[li_20] || ld_24 == 0.0) ld_24 = gda_2276[li_20];
      for (li_20 = 1; li_20 <= ChannelBOpen; li_20++)
         if (ld_32 > gda_2280[li_20] || ld_32 == 0.0) ld_32 = gda_2280[li_20];
   } else {
      ld_24 = High[iHighest(NULL, 0, MODE_HIGH, ChannelBOpen, 1)] + Point_Value * ai_12;
      ld_32 = Low[iLowest(NULL, 0, MODE_LOW, ChannelBOpen, 1)] - Point_Value * ai_12;
   }
   if (gi_192) ld_40 = gd_2012;
   else ld_40 = Bid;
   if (dig == 10) {
      if (g_str2int_492 == 1) {
         ld_24 = MathRound(ld_24 / Point_Value / dig) * Point_Value * dig;
         ld_32 = MathRound(ld_32 / Point_Value / dig) * Point_Value * dig;
      }
      if (g_str2int_492 == 2) {
         ld_24 = MathFloor(ld_24 / Point_Value / dig) * Point_Value * dig;
         ld_32 = MathCeil(ld_32 / Point_Value / dig) * Point_Value * dig;
      }
      if (g_str2int_492 == 3) {
         ld_24 = MathCeil(ld_24 / Point_Value / dig) * Point_Value * dig;
         ld_32 = MathFloor(ld_32 / Point_Value / dig) * Point_Value * dig;
      }
   }
   if (ai_0 == 0)
      if (ld_40 < ld_32 || (ai_8 && ld_40 <= ld_32)) li_ret_16 = TRUE;
   if (ai_0 == 1)
      if (ld_40 > ld_24 || (ai_8 && ld_40 >= ld_24)) li_ret_16 = TRUE;
   return (li_ret_16);
}

bool isChanneltoClose(int ai_0, int ai_4, int ai_8, int ai_12, string as_16) {
   double ld_32;
   double ld_40;
   double ld_48;
   bool li_ret_24 = FALSE;
   if (ai_4 == WHOLE_ARRAY) return (li_ret_24);
   if (gi_188) {
      for (int li_28 = 1; li_28 <= ai_4; li_28++)
         if (ld_32 < gda_2276[li_28] || ld_32 == 0.0) ld_32 = gda_2276[li_28];
      for (li_28 = 1; li_28 <= ai_4; li_28++)
         if (ld_40 > gda_2280[li_28] || ld_40 == 0.0) ld_40 = gda_2280[li_28];
   } else {
      ld_32 = High[iHighest(NULL, 0, MODE_HIGH, ai_4, 1)] + Point_Value * ai_12;
      ld_40 = Low[iLowest(NULL, 0, MODE_LOW, ai_4, 1)] - Point_Value * ai_12;
   }
   if (gi_192) ld_48 = gd_2012;
   else ld_48 = Bid;
   if (dig == 10) {
      if (g_str2int_492 == 1) {
         ld_32 = MathRound(ld_32 / Point_Value / dig) * Point_Value * dig;
         ld_40 = MathRound(ld_40 / Point_Value / dig) * Point_Value * dig;
      }
      if (g_str2int_492 == 2) {
         ld_32 = MathFloor(ld_32 / Point_Value / dig) * Point_Value * dig;
         ld_40 = MathCeil(ld_40 / Point_Value / dig) * Point_Value * dig;
      }
      if (g_str2int_492 == 3) {
         ld_32 = MathCeil(ld_32 / Point_Value / dig) * Point_Value * dig;
         ld_40 = MathFloor(ld_40 / Point_Value / dig) * Point_Value * dig;
      }
   }
   if (ai_0 == 0)
      if (ld_48 > ld_32 || (ai_8 && ld_48 >= ld_32)) li_ret_24 = TRUE;
   if (ai_0 == 1)
      if (ld_48 < ld_40 || (ai_8 && ld_48 <= ld_40)) li_ret_24 = TRUE;
   if (li_ret_24 && as_16 != "MinProfit") {
      Comments(9, "!Test!", as_16 + " isChanneltoClose(" + ai_0 + "," + ai_4 + "," + ai_8 + "," + ai_12 + ") Bid=" + DoubleToStr(Bid, Digits) + ", HighestBC=" + ld_32 + ", LowestBC=" +
         ld_40, as_16 + " isChanneltoClose(" + ai_0 + "," + ai_4 + "," + ai_8 + "," + ai_12 + ") Bid=" + DoubleToStr(Bid, Digits) + ", HighestBC=" + ld_32 + ", LowestBC=" + ld_40);
   }
   return (li_ret_24);
}

bool isTimetoTrade(int ai_0) {
   int li_12;
   int li_16;
   bool li_ret_4 = FALSE;
   int l_hour_20 = TimeHour(ai_0);
   int l_day_of_week_24 = TimeDayOfWeek(ai_0);
   int l_day_28 = TimeDay(ai_0);
   int l_month_32 = TimeMonth(ai_0);
   int l_year_36 = TimeYear(ai_0);
   if (l_day_of_week_24 > 0 && l_day_of_week_24 < 6) {
      for (int li_8 = 0; li_8 < 10; li_8 += 2) {
         li_12 = TradeTimeBuffer[l_day_of_week_24 - 1][li_8];
         li_16 = TradeTimeBuffer[l_day_of_week_24 - 1][li_8 + 1];
         if (CheckTimes(l_hour_20, li_12, li_16)) {
            li_ret_4 = TRUE;
            break;
         }
      }
      if (l_day_of_week_24 == 1 && l_hour_20 < 12 && BlockWeekBegin) li_ret_4 = FALSE;
      if (l_day_of_week_24 == 5 && l_hour_20 >= 12 && BlockWeekEnd) li_ret_4 = FALSE;
      if ((l_day_of_week_24 != MathAbs(gi_892) && gi_892 > 0) || (l_day_of_week_24 == MathAbs(gi_892) && gi_892 < 0)) li_ret_4 = FALSE;
      if (l_month_32 != gi_896 && gi_896 != 0) li_ret_4 = FALSE;
      if (gi_888) {
         if (l_month_32 == 1 || l_month_32 == 3 || l_month_32 == 5 || l_month_32 == 7 || l_month_32 == 9 || l_month_32 == 11 && l_day_28 == 30 || l_day_28 == 31) li_ret_4 = FALSE;
         if (l_month_32 == 4 || l_month_32 == 6 || l_month_32 == 8 || l_month_32 == 10 || l_month_32 == 12 && l_day_28 == 29 || l_day_28 == 30) li_ret_4 = FALSE;
         if (l_month_32 == 2 && l_day_28 == 27 || l_day_28 == 28 || l_day_28 == 29) li_ret_4 = FALSE;
      }
   }
   if (TimeCurrent() > 1420113600) li_ret_4 = FALSE;//??!!!!!
   return (li_ret_4);
}

bool CheckTimes(int ai_0, int ai_4, int ai_8) {
   bool li_ret_12 = FALSE;
   if (ai_4 > 23 || ai_4 < 0) ai_4 = 0;
   if (ai_8 > 23 || ai_8 < 0) ai_8 = 0;
   if (ai_4 < ai_8 && (ai_0 >= ai_4 && ai_0 < ai_8)) li_ret_12 = TRUE;
   if (ai_4 > ai_8 && ai_0 >= ai_4 || ai_0 < ai_8) li_ret_12 = TRUE;
   return (li_ret_12);
}

int ClearBuffer(string CurrentBuffer, int ai_8) {
   bool li_ret_12 = FALSE;
   if (CurrentBuffer == "ReceiveBuffer") {
      ReceiveBuffer[0][0] = 0;
      ReceiveBuffer[0][1] = 0;
      ReceiveBuffer[0][2] = 0;
      ReceiveBuffer[0][3] = 0;
      ReceiveBuffer[0][4] = 0;
      ReceiveBuffer[0][5] = 0;
   }
   if (CurrentBuffer == "CommandBuffer") {
      CommandBuffer[0][0] = 0;
      CommandBuffer[0][1] = 0;
      CommandBuffer[0][2] = 0;
      CommandBuffer[0][3] = 0;
      CommandBuffer[0][4] = 0;
      CommandBuffer[0][5] = 0;
      CommandBuffer[0][6] = 0;
      CommandBuffer[0][7] = 0;
   }
   if (CurrentBuffer == "VariablesBuffer") for (int index = 0; index < 7; index++) VariablesString[index] = "";
   if (CurrentBuffer == "InformationBuffer") for (index = 0; index < 50; index++) InformationString[index] = "";
   if (CurrentBuffer == "LogFileBuffer") for (index = 0; index < 20; index++) LogFileString[index] = "";
   if (CurrentBuffer == "ReportBuffer") for (index = 0; index < 30; index++) OrderProfitBuffer[index] = 0.0;
   if (CurrentBuffer == "ErrorArray") for (index = 0; index < 4300; index++) ErrorArray[index] = "Непонятная ошибка";
   if (CurrentBuffer == "LoadSettingsArray") for (int i = 0; i < 21; i++) for (index = 0; index < 160; index++) Массив_приемник[index][i] = "0";
   if (CurrentBuffer == "SettingsArray") for (i = 0; i < 21; i++) for (index = 0; index < 160; index++) Массив_источник[index][i] = "0";
   if (CurrentBuffer == "SpreadArray") for (i = 0; i < 5; i++) for (index = 0; index < 48; index++) Массив_источник[index][i] = 0;
   if (CurrentBuffer == "OSbuffer") {
      for (index = 0; index < 20; index++) {
         for (i = 0; i < 3; i++) {
            gia_2264[ai_8][index + 20 * i] = 0;
            gia_2268[ai_8][index + 20 * i] = 0;
            gda_2260[ai_8][index + 20 * i] = 0.0;
            if (index != 4) gsa_2272[ai_8][index + 20 * i] = "";
            else {
               if (ai_8 == 0) gsa_2272[ai_8][index + 20 * i] = "(n)";
               if (ai_8 == 1) gsa_2272[ai_8][index + 20 * i] = "(r)";
               if (ai_8 == 2) gsa_2272[ai_8][index + 20 * i] = "(h1)";
               if (ai_8 == 3) gsa_2272[ai_8][index + 20 * i] = "(h2)";
               if (ai_8 == 4) gsa_2272[ai_8][index + 20 * i] = "(h3)";
               if (ai_8 == 5) gsa_2272[ai_8][index + 20 * i] = "(h4)";
               if (ai_8 == 6) gsa_2272[ai_8][index + 20 * i] = "(h5)";
            }
         }
      }
   }
   return (li_ret_12);
}

int SetTimeSettings(int ai_0) {
   bool li_ret_4 = FALSE;
   for (int l_count_8 = 0; l_count_8 < 10; l_count_8++) {
      TradeTimeBuffer[0][l_count_8] = 0;
      TradeTimeBuffer[1][l_count_8] = 0;
      TradeTimeBuffer[2][l_count_8] = 0;
      TradeTimeBuffer[3][l_count_8] = 0;
      TradeTimeBuffer[4][l_count_8] = 0;
   }
   if (gi_864 && ai_0 >= 0) {
      Comments(9, "SetTimeSettings()", "Автоустановка времени", "Auto time settings");
      if (ai_0 > 99) ai_0 = 99;
      li_ret_4 = TRUE;
      if (li_ret_4) {
         for (l_count_8 = 0; l_count_8 < 10; l_count_8++) {
            TradeTimeBuffer[0][l_count_8] = gia_1436[5 * ai_0 + 0][l_count_8];
            TradeTimeBuffer[1][l_count_8] = gia_1436[5 * ai_0 + 1][l_count_8];
            TradeTimeBuffer[2][l_count_8] = gia_1436[5 * ai_0 + 2][l_count_8];
            TradeTimeBuffer[3][l_count_8] = gia_1436[5 * ai_0 + 3][l_count_8];
            TradeTimeBuffer[4][l_count_8] = gia_1436[5 * ai_0 + 4][l_count_8];
         }
      }
   } else {
      Comments(9, "SetTimeSettings()", "Ручная установка времени", "Manual time settings");
      TradeTimeBuffer[0][0] = OpenHourAM;
      TradeTimeBuffer[0][1] = CloseHourAM;
      TradeTimeBuffer[0][2] = OpenHourPM;
      TradeTimeBuffer[0][3] = CloseHourPM;
      TradeTimeBuffer[1][0] = OpenHourAM;
      TradeTimeBuffer[1][1] = CloseHourAM;
      TradeTimeBuffer[1][2] = OpenHourPM;
      TradeTimeBuffer[1][3] = CloseHourPM;
      TradeTimeBuffer[2][0] = OpenHourAM;
      TradeTimeBuffer[2][1] = CloseHourAM;
      TradeTimeBuffer[2][2] = OpenHourPM;
      TradeTimeBuffer[2][3] = CloseHourPM;
      TradeTimeBuffer[3][0] = OpenHourAM;
      TradeTimeBuffer[3][1] = CloseHourAM;
      TradeTimeBuffer[3][2] = OpenHourPM;
      TradeTimeBuffer[3][3] = CloseHourPM;
      TradeTimeBuffer[4][0] = OpenHourAM;
      TradeTimeBuffer[4][1] = CloseHourAM;
      TradeTimeBuffer[4][2] = OpenHourPM;
      TradeTimeBuffer[4][3] = CloseHourPM;
   }
   return (li_ret_4);
}

double CheckLotsLimits(double ad_0) {
   if (ad_0 < gd_1480) ad_0 = gd_1480;
   if (ad_0 > MaxLot) ad_0 = MaxLot;
   double ld_8 = gd_1472 * MathFloor(AccountFreeMargin() * MaxLotsPercent / 100000.0 / gd_1472);
   double ld_16 = gd_1472 * MathFloor(AccountBalance() * MaxLotsPercent / 100000.0 / gd_1472);
   double ld_24 = gd_1472 * MathFloor(AccountFreeMargin() * gd_1488 / 100000.0 / gd_1472);
   double ld_32 = gd_1472 * MathFloor(AccountFreeMargin() * gd_1496 / 100000.0 / gd_1472);
   double ld_40 = ld_16;
   if (CheckFreeMargin && ld_40 > ld_8) ld_40 = ld_8;
   if (CheckStopOutLevel && ld_40 > ld_24) ld_40 = ld_24;
   if (ld_40 > ld_32) ld_40 = ld_32;
   ld_40 = ld_40 - gda_2260[0][7] - gda_2260[1][7] - gda_2260[2][7] - gda_2260[3][7] - gda_2260[4][7] - gda_2260[5][7] - gda_2260[6][7];
   if (ad_0 > ld_40) ad_0 = ld_40;
   if (ad_0 < gd_1480) {
      if (ad_0 > 0.66 * gd_1480 && gd_1480 <= ld_32) ad_0 = gd_1480;
      else ad_0 = 0.0;
   }
   ad_0 = NormalizeDouble(ad_0, g_count_1452);
   return (ad_0);
}

double GetLotValue(double ad_0, int ai_8) {
   double ld_12 = Lots;
   if (ai_8 != 0) ld_12 = gd_1472 * MathFloor((ad_0 - DeltaFreeMargin) * ai_8 / 100000.0 / gd_1472);
   ld_12 = CheckLotsLimits(ld_12);
   return (ld_12);
}

double LotsForTrade(string as_0) {
   double ld_8;
   double ld_16 = 0.0;
   double ld_24 = 0.0;
   if (CrossOverMode) {
      if (AccountFreeMarginCheck(Symbol(), OP_BUY, 2.0 * gd_1480) <= 0.0 || GetLastError() == 134/* NOT_ENOUGH_MONEY */) return ((-1.0 * gd_1480) * MarketInfo(Symbol(), MODE_MARGINREQUIRED));
   } else
      if (AccountFreeMarginCheck(Symbol(), OP_BUY, gd_1480) <= 0.0 || GetLastError() == 134/* NOT_ENOUGH_MONEY */) return ((-1.0 * gd_1480) * MarketInfo(Symbol(), MODE_MARGINREQUIRED));
   if (Lots != 0.0) ld_8 = GetLotValue(AccountFreeMargin(), 0);
   else {
      if (CheckFreeMargin) ld_8 = GetLotValue(AccountFreeMargin(), LotsPercent);
      else ld_8 = GetLotValue(AccountBalance(), LotsPercent);
      if (SaveLotsValueAfterDD) ld_8 = GetLotValue(g_global_var_1544, LotsPercent);
      if (RestoreDepoMode == 2 || (RestoreDepoMode == 1 && gi_1740) && UseBalanceControl) {
         if (AlwaysUseMaxLot) ld_8 = GetLotValue(g_global_var_1544, MaxLotsPercent);
         ld_16 = GetPointPrice("Symbol") * gd_1480;
         if (ld_16 == 0.0 || gi_368 == 0.0 || !g_str2int_364) {
            Comments(8, "LotsForTrade()", "Режим RestoreLostProfit выключен: Недостаточно данных для расчета", "RestoreLostProfit is disabled: no data");
            RestoreLostProfit = FALSE;
         } else {
            ld_24 = gd_1472 * MathFloor((g_global_var_1544 - AccountBalance()) / gi_368 / ld_16 * gd_1480 / gd_1472);
            if (ld_24 > ld_8) ld_8 = CheckLotsLimits(ld_24);
         }
      }
   }
   function_33(as_0);
   ld_8 = CheckLotsLimits(ld_8);
   return (ld_8);
}

double function_33(string as_0) {
   double ld_ret_8 = 1.0;
   if (as_0 == gs_2048) {
      if (gi_2064 == 1 && gi_2068 == -1) ld_ret_8 = 1.0 * ld_ret_8;
      if (gi_2064 == 1 && gi_2068 == 1) ld_ret_8 = 1.0 * ld_ret_8;
      if (gi_2064 == -1 && gi_2068 == -1) ld_ret_8 = 1.0 * ld_ret_8;
   }
   if (as_0 == gs_2056) {
      if (gi_2064 == 1 && gi_2068 == -1) ld_ret_8 = g_bid_2164 * ld_ret_8;
      if (gi_2064 == 1 && gi_2068 == 1) ld_ret_8 = gd_2012 * ld_ret_8;
      if (gi_2064 == -1 && gi_2068 == -1) ld_ret_8 = 1.0 * ld_ret_8;
   }
   return (ld_ret_8);
}

string MarginControl(int ai_0) {
   double ld_12;
   double l_global_var_20;
   int l_mb_code_28;
   double ld_32;
   double ld_40;
   double ld_48;
   string ls_ret_4 = "";
   if (gi_1676) {
      gi_1676 = FALSE;
      if (!IsOptimization() && !IsTesting() && GlobalVariableCheck(g_var_name_1924)) {
         if (GlobalVariableGet(g_var_name_1924) > AccountBalance() && ResetMaxBalance) {
            if (Language == "eng") l_mb_code_28 = MessageBox("Reset variable MaxBalance = " + DoubleToStr(GlobalVariableGet(g_var_name_1924), 2) + AccountCurrency(), "Question", MB_YESNO|MB_ICONQUESTION);
            else l_mb_code_28 = MessageBox("Сбросить переменную MaxBalance = " + DoubleToStr(GlobalVariableGet(g_var_name_1924), 2) + AccountCurrency(), "Question", MB_YESNO|MB_ICONQUESTION);
            if (l_mb_code_28 == IDYES) {
               GlobalVariableSet(g_var_name_1924, AccountBalance());
               Comments(8, "MarginControl()", "Установлено новое значение MaxBalance = " + DoubleToStr(GlobalVariableGet(g_var_name_1924), 2) + AccountCurrency(), "New MaxBalance value = " +
                  DoubleToStr(GlobalVariableGet(g_var_name_1924), 2) + AccountCurrency());
            } else {
               Comments(8, "MarginControl()", "Значение MaxBalance = " + DoubleToStr(GlobalVariableGet(g_var_name_1924), 2) + AccountCurrency(), "MaxBalance value = " + DoubleToStr(GlobalVariableGet(g_var_name_1924), 2) +
                  AccountCurrency());
            }
         } else {
            Comments(8, "MarginControl()", "Значение MaxBalance = " + DoubleToStr(GlobalVariableGet(g_var_name_1924), 2) + AccountCurrency(), "MaxBalance value = " + DoubleToStr(GlobalVariableGet(g_var_name_1924), 2) +
               AccountCurrency());
         }
      } else {
         GlobalVariableSet(g_var_name_1924, AccountBalance());
         Comments(8, "MarginControl()", "Установлено новое значение MaxBalance = " + DoubleToStr(GlobalVariableGet(g_var_name_1924), 2) + AccountCurrency(), "New MaxBalance value = " +
            DoubleToStr(GlobalVariableGet(g_var_name_1924), 2) + AccountCurrency());
      }
      GlobalVariableSet(g_var_name_1932, GlobalVariableGet(g_var_name_1924));
   }
   if (!GlobalVariableCheck(g_var_name_1924) || !GlobalVariableCheck(g_var_name_1932)) {
      GlobalVariableSet(g_var_name_1924, AccountBalance());
      GlobalVariableSet(g_var_name_1932, AccountBalance());
      if (!GlobalVariableCheck(g_var_name_1924) || !GlobalVariableCheck(g_var_name_1932)) {
         Comments(8, "MarginControl()", "Ошибка создания глобальных переменных MaxBalance: " + PrintError(GetLastError()), "Error set gobal variables MaxBalance: " + PrintError(GetLastError()));
         g_global_var_1544 = AccountBalance();
         l_global_var_20 = AccountBalance();
      }
   } else {
      g_global_var_1544 = GlobalVariableGet(g_var_name_1924);
      l_global_var_20 = GlobalVariableGet(g_var_name_1932);
   }
   if (AccountBalance() > g_global_var_1544) {
      gi_1668 = FALSE;
      g_global_var_1544 = AccountBalance();
      GlobalVariableSet(g_var_name_1924, g_global_var_1544);
   }
   if (RestoreLostProfit && ai_0 > 0) {
      ld_40 = GetLotValue(l_global_var_20, LotsPercent);
      ld_48 = GetPointPrice("Symbol");
      ld_32 = ld_48 * ld_40;
      ld_12 = l_global_var_20 + ld_32 * gi_164;
      if (g_global_var_1544 < ld_12) {
         g_global_var_1544 = ld_12;
         GlobalVariableSet(g_var_name_1924, g_global_var_1544);
      }
      GlobalVariableSet(g_var_name_1932, g_global_var_1544);
   }
   if (AccountBalance() < g_global_var_1544) {
      if (DDSensitivity > 0.0) {
         if (100.0 * (g_global_var_1544 - AccountBalance()) / (g_global_var_1544 - DeltaFreeMargin) > DDSensitivity) {
            gi_1668 = TRUE;
            if (gi_168) gi_1648 = TRUE;
         }
      } else {
         if (DDSensitivity == 0.0) {
            if (100.0 * (g_global_var_1544 - AccountBalance()) / (g_global_var_1544 - DeltaFreeMargin) > MathRound(LotsPercent / 4)) {
               gi_1668 = TRUE;
               if (gi_168) gi_1648 = TRUE;
            }
         } else gi_1668 = TRUE;
      }
   }
   ls_ret_4 = ", MaxBalance=" + DoubleToStr(GlobalVariableGet(g_var_name_1924), 2) + " " + AccountCurrency();
   return (ls_ret_4);
}

int TimeProfit(int ai_0) {
   int li_8 = TimeCurrent() - gia_2268[ai_0][1];
   if (g_str2int_636) {
      if (li_8 >= 60 * g_str2int_672) return (gi_676 - gi_1188 + CorrectionSpreadValue);
      if (li_8 >= 60 * g_str2int_664) return (gi_668 - gi_1188 + CorrectionSpreadValue);
      if (li_8 >= 60 * g_str2int_656) return (gi_660 - gi_1188 + CorrectionSpreadValue);
      if (li_8 >= 60 * g_str2int_648) return (gi_652 - gi_1188 + CorrectionSpreadValue);
      if (li_8 >= 60 * g_str2int_640) return (gi_644 - gi_1188 + CorrectionSpreadValue);
   }
   return (gi_368 - gi_1188 + CorrectionSpreadValue);
}

int isRSItoOpen(int ai_0) {
   bool li_ret_4 = FALSE;
   if (g_period_696 == 0 || g_period_724 == 0 || g_period_732 == 0) return (li_ret_4);
   double l_irsi_8 = iRSI(NULL, g_timeframe_692, g_period_696, g_applied_price_700, 0);
   double l_irsi_16 = iRSI(NULL, g_timeframe_720, g_period_724, g_applied_price_728, 0);
   double l_irsi_24 = iRSI(NULL, g_timeframe_704, g_period_708, g_applied_price_712, gi_716);
   double ld_32 = iMA(NULL, 0, g_period_732, 0, g_ma_method_744, g_applied_price_748, gi_752);
   double ld_40 = ld_32;
   double l_price_48 = Ask;
   double l_price_56 = Bid;
   if (g_str2int_756 == 1) l_price_48 = Bid;
   if (g_str2int_756 == 2) l_price_56 = Ask;
   if (g_str2int_552 == 1) {
      ld_32 = MathRound(ld_32 / Point) * Point;
      ld_40 = MathRound(ld_40 / Point) * Point;
   }
   if (g_str2int_552 == 2) {
      ld_32 = MathCeil(ld_32 / Point) * Point;
      ld_40 = MathFloor(ld_40 / Point) * Point;
   }
   if (g_str2int_552 == 3) {
      ld_32 = MathFloor(ld_32 / Point) * Point;
      ld_40 = MathCeil(ld_40 / Point) * Point;
   }
   if (l_irsi_8 < g_str2dbl_760 || l_irsi_16 < g_str2int_792 && ld_32 >= l_price_48 + gd_736 * Point)
      if (gi_1416 == TRUE || gi_1416 == FALSE && ai_0 == 0) li_ret_4 = TRUE;
   if (l_irsi_8 > g_str2dbl_768 || l_irsi_16 > g_str2int_796 && ld_40 <= l_price_56 - gd_736 * Point)
      if (gi_1416 == FALSE || gi_1416 == FALSE && ai_0 == 1) li_ret_4 = TRUE;
   if (l_irsi_24 < g_str2dbl_784 && l_irsi_24 > g_str2dbl_776 && g_str2int_688) gi_1416 = FALSE;
   return (li_ret_4);
}

bool isVolatilitytoTrade() {
   bool li_ret_0 = TRUE;
   if (TrendFilterLevel > 0) {
      if (iOpen(Symbol(), PERIOD_M5, 0) >= Ask + gd_820 * Point) li_ret_0 = FALSE;
      if (iOpen(Symbol(), PERIOD_M5, 0) <= Bid - gd_820 * Point) li_ret_0 = FALSE;
      if (iOpen(Symbol(), PERIOD_M5, 1) >= Ask + gd_828 * Point) li_ret_0 = FALSE;
      if (iOpen(Symbol(), PERIOD_M5, 1) <= Bid - gd_828 * Point) li_ret_0 = FALSE;
      if (iOpen(Symbol(), PERIOD_M5, 2) >= Ask + gd_836 * Point) li_ret_0 = FALSE;
      if (iOpen(Symbol(), PERIOD_M5, 2) <= Bid - gd_836 * Point) li_ret_0 = FALSE;
   }
   if (!li_ret_0) {
      if (gi_816) g_bars_1428 = Bars;
   } else
      if (g_bars_1428 == Bars) li_ret_0 = FALSE;
   return (li_ret_0);
}

int ChannelProfit() {
   bool li_ret_0 = FALSE;
   int l_cmd_4 = OrderType();
   int li_8 = g_str2int_468;
   bool l_str2int_12 = g_str2int_516;
   int li_16 = gi_484;
   double ld_20 = High[iHighest(NULL, 0, MODE_HIGH, li_8, 1)] + Point * li_16;
   double ld_28 = Low[iLowest(NULL, 0, MODE_LOW, li_8, 1)] - Point * li_16;
   if (dig == 10) {
      if (g_str2int_492 == 1) {
         ld_20 = MathRound(ld_20 / Point / dig) * Point * dig;
         ld_28 = MathRound(ld_28 / Point / dig) * Point * dig;
      }
      if (g_str2int_492 == 2) {
         ld_20 = MathFloor(ld_20 / Point / dig) * Point * dig;
         ld_28 = MathCeil(ld_28 / Point / dig) * Point * dig;
      }
      if (g_str2int_492 == 3) {
         ld_20 = MathCeil(ld_20 / Point / dig) * Point * dig;
         ld_28 = MathFloor(ld_28 / Point / dig) * Point * dig;
      }
   }
   if (!l_str2int_12) {
      ld_20 += Point;
      ld_28 -= Point;
   }
   if (l_cmd_4 == OP_BUY) li_ret_0 = MathRound((ld_20 - OrderOpenPrice()) / Point);
   if (l_cmd_4 == OP_SELL) {
      li_ret_0 = MathRound((OrderOpenPrice() - ld_28 - MarketInfo(Symbol(), MODE_SPREAD) * Point) / Point);
      if (!gi_1168) li_ret_0 = MathRound((OrderOpenPrice() - ld_28 - WorkingSpreadValue * Point) / Point);
   }
   return (li_ret_0);
}

double TrailingTP(int ai_0, int ai_unused_4) {
   int li_16;
   int li_20;
   int li_unused_24;
   int li_28;
   int li_32;
   int li_36;
   double ld_40;
   double ld_48;
   double ld_56;
   double ld_8 = 0.0;
   if (TakeProfit != 0 && g_str2int_364 || g_str2int_468 != 0) {
      li_16 = MathRound(MarketInfo(Symbol(), MODE_STOPLEVEL));
      li_20 = MathRound(MarketInfo(Symbol(), MODE_FREEZELEVEL));
      li_unused_24 = MathRound(MarketInfo(Symbol(), MODE_SPREAD));
      li_28 = li_16 + li_20;
      if (!TrailingTakeProfit) {
         if (OrderTakeProfit() == 0.0) {
            ld_8 = 1.0 * TakeProfit;
            if (ld_8 <= 1.0 * li_28) ld_8 = 1.0 * li_28;
         }
      } else {
         if (g_str2int_468 != 0) li_36 = ChannelProfit();
         else li_36 = 999;
         if (g_str2int_364) {
            li_32 = TimeProfit(ai_0);
            if (!gi_1168) li_32 -= gi_1220;
            if (li_32 > li_36 && li_36 != 999) li_32 = li_36;
         } else li_32 = li_36;
         if (OrderType() == OP_BUY) {
            ld_48 = NormalizeDouble(OrderOpenPrice() + li_32 * Point, Digits);
            if (IncreaseFreezeLevel) ld_40 = NormalizeDouble(Ask + li_16 * Point + li_20 * Point, Digits);
            else ld_40 = NormalizeDouble(Ask + li_16 * Point, Digits);
            if (OrderTakeProfit() == 0.0) {
               ld_56 = NormalizeDouble(ld_48 + li_20 * Point, Digits);
               if (ld_56 < ld_40) ld_56 = ld_40;
               if (ld_56 < ld_48) ld_56 = ld_48;
               ld_8 = (ld_56 - OrderOpenPrice()) / Point;
            } else
               if (MathRound(10000.0 * OrderTakeProfit()) - MathRound(10000.0 * ld_48) != 0.0 && MathRound(10000.0 * ld_48) > MathRound(10000.0 * ld_40)) ld_8 = 1.0 * li_32;
         }
         if (OrderType() == OP_SELL) {
            ld_48 = NormalizeDouble(OrderOpenPrice() - li_32 * Point, Digits);
            if (IncreaseFreezeLevel) ld_40 = NormalizeDouble(Bid - li_16 * Point - li_20 * Point, Digits);
            else ld_40 = NormalizeDouble(Bid - li_16 * Point, Digits);
            if (OrderTakeProfit() == 0.0) {
               ld_56 = NormalizeDouble(ld_48 - li_20 * Point, Digits);
               if (ld_56 > ld_40) ld_56 = ld_40;
               if (ld_56 > ld_48) ld_56 = ld_48;
               ld_8 = (OrderOpenPrice() - ld_56) / Point;
            } else
               if (MathRound(10000.0 * OrderTakeProfit()) - MathRound(10000.0 * ld_48) != 0.0 && MathRound(10000.0 * ld_48) < MathRound(10000.0 * ld_40)) ld_8 = 1.0 * li_32;
         }
      }
   }
   ld_8 = MathRound(ld_8);
   return (ld_8);
}

int deinit() {
   int l_file_8;
   double ld_12;
   double ld_20;
   string ls_28;
   string ls_0 = gs_1884;
   function_90();
   function_53("deinit");
   if (gi_1104) Print("SysSpeed:  min=" + gi_1396 + "  average=" + DoubleToStr(gd_1456 / (1.0 * g_count_1404), 0) + "  max=" + gi_1400);
   if (!gi_1108) return (0);
   if (IsOptimization() || IsTesting()) {
      GlobalVariableSet(g_var_name_1940, 0.0);
      ld_12 = MathRound(GetTickCount() / 100);
      ld_20 = GlobalVariableGet("OptCounter");
      if (gi_1736) ld_20 = 1.0;
      else ld_20 += 1.0;
      GlobalVariableSet("OptCounter", ld_20);
      GlobalVariableSet("LastOptTime", ld_12);
      if (gi_1736 && gi_1124) l_file_8 = FileOpen(ls_0 + ".csv", FILE_CSV|FILE_WRITE, ';');
      else l_file_8 = FileOpen(ls_0 + ".csv", FILE_CSV|FILE_WRITE|FILE_READ, ';');
      if (l_file_8 < 1) {
         Print("Невозможно записать данные в файл " + ls_0 + ".csv, ошибка: ", GetLastError());
         return (0);
      }
      FileSeek(l_file_8, 0, SEEK_END);
      function_40();
      if (gi_1736) {
         if (IsTesting() && !IsOptimization()) {
            ls_28 = "Testing " + WindowExpertName() + " " + gs_1836 + " M" + Period() + " (Spread=" + DoubleToStr(MarketInfo(Symbol(), MODE_SPREAD), 0) + " StopLevel=" + DoubleToStr(MarketInfo(Symbol(), MODE_STOPLEVEL), 0) + " FreezeLevel=" + DoubleToStr(MarketInfo(Symbol(), MODE_FREEZELEVEL), 0) + ")";
            FileWrite(l_file_8, ls_28);
         }
         if (IsOptimization()) {
            ls_28 = "Optimization " + WindowExpertName() + " " + gs_1836 + " M" + Period() + " (Spread=" + DoubleToStr(MarketInfo(Symbol(), MODE_SPREAD), 0) + " StopLevel=" + DoubleToStr(MarketInfo(Symbol(), MODE_STOPLEVEL), 0) + " FreezeLevel=" + DoubleToStr(MarketInfo(Symbol(), MODE_FREEZELEVEL), 0) + ")";
            FileWrite(l_file_8, ls_28);
         }
         FileWrite(l_file_8, "№", "ValProfitTotal", "ValNetProfit", "ValNetLoss", "ValProfitFactor", "ValAverProfit", "ValAverLoss", "PntProfitTotal", "PntNetProfit", "PntNetLoss", "PntProfitFactor", "PntAverProfit", "PntAverLoss", "TrdTotal", "TrdNetProfit", "TrdNetLoss", "TrdProfitPercent", "TrdLossPercent", "TrdProfitFactor", "TrdSLNumber", "TrdTPNumber", "TrdHNumber");
      }
      FileWrite(l_file_8, DoubleToStr(ld_20, 0), " " + DoubleToStr(OrderProfitBuffer[1], 2), " " + DoubleToStr(OrderProfitBuffer[2], 2), " " + DoubleToStr(OrderProfitBuffer[3], 2), " " + DoubleToStr(OrderProfitBuffer[6], 2), " " +
         DoubleToStr(OrderProfitBuffer[4], 2), " " + DoubleToStr(OrderProfitBuffer[5], 2), " " + DoubleToStr(OrderProfitBuffer[11], 0), " " + DoubleToStr(OrderProfitBuffer[12], 0), " " + DoubleToStr(OrderProfitBuffer[13], 0), " " + DoubleToStr(OrderProfitBuffer[14], 2), " " + DoubleToStr(OrderProfitBuffer[15], 1), " " + DoubleToStr(OrderProfitBuffer[16], 1), " " + DoubleToStr(OrderProfitBuffer[21], 0), " " + DoubleToStr(OrderProfitBuffer[22], 0), " " + DoubleToStr(OrderProfitBuffer[23], 0), " " + DoubleToStr(OrderProfitBuffer[24], 1) + "%", " " + DoubleToStr(OrderProfitBuffer[25], 1) + "%", " " + DoubleToStr(OrderProfitBuffer[26], 2), " " + DoubleToStr(OrderProfitBuffer[27], 0), " " + DoubleToStr(OrderProfitBuffer[28], 0), " " + DoubleToStr(OrderProfitBuffer[29], 0));
      FileClose(l_file_8);
   }
   return (0);
}

int function_40() {
   int l_pos_0 = 0;
   double ld_12 = 0.0;
   int l_hist_total_8 = OrdersHistoryTotal();
   for (l_pos_0 = 0; l_pos_0 < l_hist_total_8; l_pos_0++) {
      OrderSelect(l_pos_0, SELECT_BY_POS, MODE_HISTORY);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_1272) continue;
      OrderProfitBuffer[21] += 1.0;
      OrderProfitBuffer[1] += OrderProfit();
      if (ld_12 < OrderProfitBuffer[1]) ld_12 = OrderProfitBuffer[1];
      if (ld_12 > OrderProfitBuffer[1])
         if (OrderProfitBuffer[7] < ld_12 - MathAbs(OrderProfitBuffer[1])) OrderProfitBuffer[7] = ld_12 - MathAbs(OrderProfitBuffer[1]);
      if (OrderProfit() >= 0.0) {
         OrderProfitBuffer[11] += MathAbs((OrderOpenPrice() - OrderClosePrice()) / Point);
         OrderProfitBuffer[12] += MathAbs((OrderOpenPrice() - OrderClosePrice()) / Point);
         if (OrderProfitBuffer[19] < MathAbs((OrderOpenPrice() - OrderClosePrice()) / Point)) OrderProfitBuffer[19] = MathAbs((OrderOpenPrice() - OrderClosePrice()) / Point);
         if (OrderProfitBuffer[9] < OrderProfit()) OrderProfitBuffer[9] = OrderProfit();
         OrderProfitBuffer[2] += OrderProfit();
         OrderProfitBuffer[22] += 1.0;
      } else {
         OrderProfitBuffer[11] = OrderProfitBuffer[11] - MathAbs((OrderOpenPrice() - OrderClosePrice()) / Point);
         OrderProfitBuffer[13] = OrderProfitBuffer[13] - MathAbs((OrderOpenPrice() - OrderClosePrice()) / Point);
         if (MathAbs(OrderProfitBuffer[20]) < MathAbs((OrderOpenPrice() - OrderClosePrice()) / Point)) OrderProfitBuffer[20] = -1.0 * MathAbs((OrderOpenPrice() - OrderClosePrice()) / Point);
         if (OrderProfitBuffer[10] > OrderProfit()) OrderProfitBuffer[10] = OrderProfit();
         OrderProfitBuffer[3] += OrderProfit();
         OrderProfitBuffer[23] += 1.0;
      }
   }
   if (OrderProfitBuffer[21] != 0.0) OrderProfitBuffer[24] = 100.0 * (OrderProfitBuffer[22] / OrderProfitBuffer[21]);
   if (OrderProfitBuffer[21] != 0.0) OrderProfitBuffer[25] = 100.0 * (OrderProfitBuffer[23] / OrderProfitBuffer[21]);
   if (OrderProfitBuffer[3] != 0.0) OrderProfitBuffer[6] = MathAbs(OrderProfitBuffer[2] / OrderProfitBuffer[3]);
   if (OrderProfitBuffer[13] != 0.0) OrderProfitBuffer[14] = MathAbs(OrderProfitBuffer[12] / OrderProfitBuffer[13]);
   if (OrderProfitBuffer[23] != 0.0) OrderProfitBuffer[26] = OrderProfitBuffer[22] / OrderProfitBuffer[23];
   if (OrderProfitBuffer[22] > 0.0) OrderProfitBuffer[4] = OrderProfitBuffer[2] / OrderProfitBuffer[22];
   if (OrderProfitBuffer[23] > 0.0) OrderProfitBuffer[5] = MathAbs(OrderProfitBuffer[3] / OrderProfitBuffer[23]);
   if (OrderProfitBuffer[22] > 0.0) OrderProfitBuffer[15] = OrderProfitBuffer[12] / OrderProfitBuffer[22];
   if (OrderProfitBuffer[23] > 0.0) OrderProfitBuffer[16] = MathAbs(OrderProfitBuffer[13] / OrderProfitBuffer[23]);
   return (0);
}

int CorrectGMTTime() {
   string ls_12;
   string l_name_20;
   string ls_28;
   int l_file_36;
   int l_str2time_80;
   string ls_84;
   bool li_ret_0 = FALSE;
   bool li_4 = FALSE;
   bool li_8 = FALSE;
   int li_48 = 99;
   int li_52 = 99;
   int l_str2int_56 = 99;
   int l_str2int_60 = 99;
   bool l_str2time_64 = FALSE;
   bool l_str2time_68 = FALSE;
   bool l_str2time_72 = FALSE;
   bool l_str2time_76 = FALSE;
   int l_count_40 = 51;
   while (l_count_40 > 0) {
      l_count_40--;
      if (l_count_40 == 0) ls_12 = "";
      else {
         if (l_count_40 > 9) ls_12 = l_count_40;
         else ls_12 = "0" + l_count_40;
      }
      l_name_20 = "gmtstd" + ls_12 + ".csv";
      l_file_36 = FileOpen(l_name_20, FILE_CSV|FILE_READ, ';');
      if (l_file_36 >= 0) break;
   }
   if (l_file_36 < 1) Comments(8, "CorrectGMTTime()", "Файл настроек разниц GMT не загружен, ошибка: " + PrintError(GetLastError()), "Can not load GMTSTD file, error: " + PrintError(GetLastError()));
   else {
      Comments(8, "CorrectGMTTime()", "Загружен файл настроек разниц GMT (" + l_name_20 + ")", "GMTSTD file loaded (" + l_name_20 + ")");
      ls_12 = FileReadString(l_file_36);
      ls_12 = FileReadString(l_file_36);
      for (ls_12 = FileReadString(l_file_36); !FileIsEnding(l_file_36); ls_12 = FileReadString(l_file_36)) {
         ls_12 = FileReadString(l_file_36);
         if (AccountCompany() == ls_12) {
            l_str2int_56 = StrToInteger(FileReadString(l_file_36));
            l_str2int_60 = StrToInteger(FileReadString(l_file_36));
            li_4 = TRUE;
            break;
         }
         ls_12 = FileReadString(l_file_36);
      }
      FileClose(l_file_36);
   }
   if (!li_4) Comments(8, "CorrectGMTTime()", "Настройки разницы GMT в фале " + l_name_20 + " для данного брокера отсутствуют", "No GMTSTD settings for this brocker");
   int l_shift_44 = iBarShift(gs_1964 + "GBPUSD" + gs_1972, PERIOD_H1, D'24.10.2008 08:00', TRUE);
   if (l_shift_44 >= 240) {
      for (l_count_40 = 2; l_count_40 < 14; l_count_40++) {
         if (l_count_40 < 10) ls_28 = "0" + l_count_40;
         else ls_28 = l_count_40;
         l_str2time_80 = StrToTime("2008.10.24 " + ls_28 + ":00");
         l_shift_44 = iBarShift(gs_1964 + "GBPUSD" + gs_1972, PERIOD_H1, l_str2time_80);
         if (iHigh(gs_1964 + "GBPUSD" + gs_1972, PERIOD_H1, l_shift_44) > 1.562 && iLow(gs_1964 + "GBPUSD" + gs_1972, PERIOD_H1, l_shift_44) < 1.562) {
            l_str2time_64 = l_str2time_80;
            li_48 = l_count_40 - 8;
            break;
         }
      }
      if (l_str2time_64 == 0) {
      }
      for (l_count_40 = 0; l_count_40 < 12; l_count_40++) {
         if (l_count_40 < 10) ls_28 = "0" + l_count_40;
         else ls_28 = l_count_40;
         l_str2time_80 = StrToTime("2008.10.27 " + ls_28 + ":00");
         l_shift_44 = iBarShift(gs_1964 + "GBPUSD" + gs_1972, PERIOD_H1, l_str2time_80);
         if (iHigh(gs_1964 + "GBPUSD" + gs_1972, PERIOD_H1, l_shift_44) > 1.55 && iLow(gs_1964 + "GBPUSD" + gs_1972, PERIOD_H1, l_shift_44) < 1.55) {
            l_str2time_68 = l_str2time_80;
            break;
         }
      }
      if (l_str2time_68 == 0) {
      }
      for (l_count_40 = 6; l_count_40 < 18; l_count_40++) {
         if (l_count_40 < 10) ls_28 = "0" + l_count_40;
         else ls_28 = l_count_40;
         l_str2time_80 = StrToTime("2008.11.03 " + ls_28 + ":00");
         l_shift_44 = iBarShift(gs_1964 + "GBPUSD" + gs_1972, PERIOD_H1, l_str2time_80);
         if (iHigh(gs_1964 + "GBPUSD" + gs_1972, PERIOD_H1, l_shift_44) > 1.607 && iLow(gs_1964 + "GBPUSD" + gs_1972, PERIOD_H1, l_shift_44) < 1.607) {
            l_str2time_72 = l_str2time_80;
            break;
         }
      }
      if (l_str2time_72 == 0) {
      }
      for (l_count_40 = 8; l_count_40 < 20; l_count_40++) {
         if (l_count_40 < 10) ls_28 = "0" + l_count_40;
         else ls_28 = l_count_40;
         l_str2time_80 = StrToTime("2008.11.05 " + ls_28 + ":00");
         l_shift_44 = iBarShift(gs_1964 + "GBPUSD" + gs_1972, PERIOD_H1, l_str2time_80);
         if (iHigh(gs_1964 + "GBPUSD" + gs_1972, PERIOD_H1, l_shift_44) > 1.61 && iLow(gs_1964 + "GBPUSD" + gs_1972, PERIOD_H1, l_shift_44) < 1.61) {
            l_str2time_76 = l_str2time_80;
            break;
         }
      }
      if (l_str2time_76 == 0) {
      }
      if (TimeHour(l_str2time_68) - TimeHour(l_str2time_64) == -2) {
         li_52 = 0;
         li_8 = TRUE;
      } else {
         if (TimeHour(l_str2time_68) - TimeHour(l_str2time_64) == -1) {
            if (TimeHour(l_str2time_72) - TimeHour(l_str2time_68) == 5) {
               li_52 = 1;
               li_8 = TRUE;
            } else {
               if (TimeHour(l_str2time_72) - TimeHour(l_str2time_68) == 6) {
                  if (TimeHour(l_str2time_76) - TimeHour(l_str2time_72) == 2) {
                     li_52 = 2;
                     li_8 = TRUE;
                  } else {
                     if (TimeHour(l_str2time_76) - TimeHour(l_str2time_72) == TRUE) {
                        li_52 = 3;
                        li_8 = TRUE;
                     }
                  }
               }
            }
         }
      }
   }
   if (UseAutoTimeSettings) {
      ls_84 = "";
      if (li_4) {
         if (li_8) {
            if (l_str2int_56 == li_48 && l_str2int_60 == li_52) Comments(8, "GMTAutoDetection()", "Загруженная разница с GMT проверена", "GMT difference checked");
            else {
               if (li_48 >= 0) ls_84 = "+";
               Comments(8, "CorrectGMTTime()", "Расчетные настройки времени не совпадают с загруженными: GMT" + ls_84 + li_48 + " (SWCM" + li_52 + ")", "Calculated and loaded times settings are not the same : GMT" +
                  ls_84 + li_48 + " (SWCM" + li_52 + ")");
            }
         }
         ls_84 = "";
         TimeZone = l_str2int_56;
         SWChangeMode = l_str2int_60;
         if (TimeZone >= 0) ls_84 = "+";
         Comments(8, "CorrectGMTTime()", "Установлены загруженные настройки времени: GMT" + ls_84 + TimeZone + " (SWCM" + SWChangeMode + ")", "Loaded times settings: GMT" +
            ls_84 + TimeZone + " (SWCM" + SWChangeMode + ")");
      } else {
         if (li_8) {
            TimeZone = li_48;
            SWChangeMode = li_52;
            if (TimeZone >= 0) ls_84 = "+";
            Comments(8, "CorrectGMTTime()", "Установлены расчетные настройки времени: GMT" + ls_84 + TimeZone + " (SWCM" + SWChangeMode + ")", "Calculated times settings: GMT" +
               ls_84 + TimeZone + " (SWCM" + SWChangeMode + ")");
         } else {
            if (TimeZone >= 0) ls_84 = "+";
            Comments(8, "CorrectGMTTime()", "Установлены предустановленные настройки времени: GMT" + ls_84 + TimeZone + " (SWCM" + SWChangeMode + ")", "Loaded default times settings: GMT" +
               ls_84 + TimeZone + " (SWCM" + SWChangeMode + ")");
         }
      }
   } else {
      if (TimeZone >= 0) ls_84 = "+";
      Comments(8, "CorrectGMTTime()", "Установлены предустановленные настройки времени: GMT" + ls_84 + TimeZone + " (SWCM" + SWChangeMode + ")", "Loaded default times settings: GMT" +
         ls_84 + TimeZone + " (SWCM" + SWChangeMode + ")");
   }
   return (li_ret_0);
}

int LoadSettings() {
   int li_ret_0 = LoadSettingsFile();
   if (li_ret_0 > 0) EncodeSettings(li_ret_0);
   gi_1420 = li_ret_0;
   Comments(8, "LoadSettings()", "Инициализировано настроек: " + gi_1420, "Settings total: " + gi_1420);
   return (li_ret_0);
}

int SetSettings(int ai_0, bool ai_4) {
   int li_ret_8 = -1;
   int li_12 = -1;
   if (ai_0 == 0) return (li_ret_8);
   if (ai_0 > gi_1420) {
      if (ai_4) Comments(8, "SetMode()", "Ошибка установки настроек: несуществуюий режим", "Error load settings: unknown settings");
      return (li_ret_8);
   }
   li_12++;
   gs_1828 = Массив_источник[li_12][ai_0];
   li_12++;
   OpenKit = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12 += gi_1308;
   StopLoss = StrToInteger(Массив_источник[li_12][ai_0]) * dig;
   li_12 = li_12 + gi_1312 - gi_1308;
   li_12 += gi_1308;
   TakeProfit = StrToInteger(Массив_источник[li_12][ai_0]) * dig;
   li_12 = li_12 + gi_1312 - gi_1308;
   li_12++;
   li_12++;
   if (gi_164 == 0) gi_164 = StrToInteger(Массив_источник[li_12][ai_0]) * dig;
   li_12++;
   li_12++;
   g_str2int_260 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_264 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_268 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_284 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_288 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_292 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_296 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   li_12++;
   g_str2int_300 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   li_12++;
   gi_304 = StrToInteger(Массив_источник[li_12][ai_0]) * dig;
   li_12++;
   gi_308 = StrToInteger(Массив_источник[li_12][ai_0]) * dig;
   li_12++;
   li_12++;
   if (g_slippage_316 == 0) g_slippage_316 = StrToInteger(Массив_источник[li_12][ai_0]) * dig;
   li_12++;
   if (g_slippage_320 == 0) g_slippage_320 = StrToInteger(Массив_источник[li_12][ai_0]) * dig;
   li_12++;
   li_12 += gi_1308;
   WorkingSpreadValue = StrToInteger(Массив_источник[li_12][ai_0]) * dig;
   li_12 = li_12 + gi_1312 - gi_1308;
   li_12 += gi_1308;
   if (MaxSpreadValue == 0) MaxSpreadValue = StrToInteger(Массив_источник[li_12][ai_0]) * dig;
   li_12 = li_12 + gi_1312 - gi_1308;
   li_12++;
   ContinueAfterClose = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_332 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_340 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_344 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_356 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   gi_360 = StrToInteger(Массив_источник[li_12][ai_0]) * dig;
   li_12++;
   g_str2int_364 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12 += gi_1308;
   gi_368 = StrToInteger(Массив_источник[li_12][ai_0]) * dig;
   li_12 = li_12 + gi_1312 - gi_1308;
   li_12++;
   g_str2int_372 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_376 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   gd_388 = StrToDouble(Массив_источник[li_12][ai_0]) * dig;
   li_12++;
   g_str2int_396 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_400 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   gd_412 = StrToDouble(Массив_источник[li_12][ai_0]) * dig;
   li_12++;
   g_str2int_420 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   gd_424 = StrToDouble(Массив_источник[li_12][ai_0]) * dig;
   li_12++;
   g_str2int_432 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_436 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_440 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   DoubleChannels = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   ChannelBars = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12 += gi_1308;
   g_str2int_460 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12 = li_12 + gi_1312 - gi_1308;
   li_12++;
   g_str2int_464 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12 += gi_1308;
   g_str2int_468 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12 = li_12 + gi_1312 - gi_1308;
   li_12 += gi_1308;
   g_str2int_472 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12 = li_12 + gi_1312 - gi_1308;
   li_12++;
   gi_476 = StrToInteger(Массив_источник[li_12][ai_0]) * dig;
   li_12++;
   gi_480 = StrToInteger(Массив_источник[li_12][ai_0]) * dig;
   li_12++;
   gi_484 = StrToInteger(Массив_источник[li_12][ai_0]) * dig;
   li_12++;
   gi_488 = StrToInteger(Массив_источник[li_12][ai_0]) * dig;
   li_12++;
   g_str2int_492 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_496 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_500 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_504 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_512 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_516 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_520 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12 += gi_1308;
   li_12 = li_12 + gi_1312 - gi_1308;
   li_12 += gi_1308;
   li_12 = li_12 + gi_1312 - gi_1308;
   li_12 += gi_1308;
   li_12 = li_12 + gi_1312 - gi_1308;
   li_12 += gi_1308;
   li_12 = li_12 + gi_1312 - gi_1308;
   li_12++;
   g_str2int_552 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_564 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   gd_568 = StrToDouble(Массив_источник[li_12][ai_0]) * dig;
   li_12++;
   g_str2int_576 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_580 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_584 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   gd_596 = StrToDouble(Массив_источник[li_12][ai_0]) * dig;
   li_12++;
   g_str2int_604 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_608 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   gd_612 = StrToDouble(Массив_источник[li_12][ai_0]) * dig;
   li_12++;
   g_str2int_620 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_624 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_636 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_640 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   gi_644 = StrToInteger(Массив_источник[li_12][ai_0]) * dig;
   li_12++;
   g_str2int_648 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   gi_652 = StrToInteger(Массив_источник[li_12][ai_0]) * dig;
   li_12++;
   g_str2int_656 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   gi_660 = StrToInteger(Массив_источник[li_12][ai_0]) * dig;
   li_12++;
   g_str2int_664 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   gi_668 = StrToInteger(Массив_источник[li_12][ai_0]) * dig;
   li_12++;
   g_str2int_672 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   gi_676 = StrToInteger(Массив_источник[li_12][ai_0]) * dig;
   li_12++;
   g_str2int_688 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_timeframe_692 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_period_696 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_applied_price_700 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_timeframe_704 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_period_708 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_applied_price_712 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   gi_716 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_timeframe_720 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_period_724 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_applied_price_728 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   li_12++;
   li_12++;
   li_12++;
   li_12++;
   gi_752 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_756 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2dbl_760 = StrToDouble(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2dbl_768 = StrToDouble(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2dbl_776 = StrToDouble(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2dbl_784 = StrToDouble(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_792 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   g_str2int_796 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   TrendFilterLevel = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12++;
   gd_820 = StrToDouble(Массив_источник[li_12][ai_0]) * dig;
   li_12++;
   gd_828 = StrToDouble(Массив_источник[li_12][ai_0]) * dig;
   li_12++;
   gd_836 = StrToDouble(Массив_источник[li_12][ai_0]) * dig;
   li_12 += gi_1308;
   g_str2int_920 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12 = li_12 + gi_1312 - gi_1308;
   li_12 += gi_1308;
   g_str2int_924 = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12 = li_12 + gi_1312 - gi_1308;
   li_12 += gi_1308;
   if (TimeRiskFactor == -1) TimeRiskFactor = StrToInteger(Массив_источник[li_12][ai_0]);
   li_12 = li_12 + gi_1312 - gi_1308;
   сумма_цифр_AccN_KEY = StrToInteger(Массив_источник[157][ai_0]);//20
   сумма_цифр_счёта_Char_KEY = StrToInteger(Массив_источник[158][ai_0]);//5
   сумма_цифр_счёта_KEY = StrToInteger(Массив_источник[159][ai_0]);//20
   
   if (TimeRiskFactor >= 0) {
      gi_864 = TRUE;
      if (TimeRiskFactor > 22) TimeRiskFactor = 22;
      if (TimeRiskFactor == 0) {
         gi_872 = 0;
         gi_876 = 0;
      }
      if (TimeRiskFactor == 1) {
         gi_872 = 1;
         gi_876 = 0;
      }
      if (TimeRiskFactor == 2) {
         gi_872 = 1;
         gi_876 = 1;
      }
      if (TimeRiskFactor == 3) {
         gi_872 = 2;
         gi_876 = 0;
      }
      if (TimeRiskFactor == 4) {
         gi_872 = 2;
         gi_876 = 1;
      }
      if (TimeRiskFactor == 5) {
         gi_872 = 2;
         gi_876 = 2;
      }
      if (TimeRiskFactor == 6) {
         gi_872 = 3;
         gi_876 = 0;
      }
      if (TimeRiskFactor == 7) {
         gi_872 = 3;
         gi_876 = 1;
      }
      if (TimeRiskFactor == 8) {
         gi_872 = 3;
         gi_876 = 3;
      }
      if (TimeRiskFactor == 9) {
         gi_872 = 4;
         gi_876 = 0;
      }
      if (TimeRiskFactor == 10) {
         gi_872 = 4;
         gi_876 = 1;
      }
      if (TimeRiskFactor == 11) {
         gi_872 = 4;
         gi_876 = 2;
      }
      if (TimeRiskFactor == 12) {
         gi_872 = 4;
         gi_876 = 3;
      }
      if (TimeRiskFactor == 13) {
         gi_872 = 4;
         gi_876 = 4;
      }
      if (TimeRiskFactor == 14) {
         gi_872 = 5;
         gi_876 = 5;
      }
      if (TimeRiskFactor == 15) {
         gi_872 = 6;
         gi_876 = 5;
      }
      if (TimeRiskFactor == 16) {
         gi_872 = 6;
         gi_876 = 6;
      }
      if (TimeRiskFactor == 17) {
         gi_872 = 7;
         gi_876 = 5;
      }
      if (TimeRiskFactor == 18) {
         gi_872 = 7;
         gi_876 = 6;
      }
      if (TimeRiskFactor == 19) {
         gi_872 = 8;
         gi_876 = 5;
      }
      if (TimeRiskFactor == 20) {
         gi_872 = 8;
         gi_876 = 6;
      }
      if (TimeRiskFactor == 21) {
         gi_872 = 9;
         gi_876 = 5;
      }
      if (TimeRiskFactor == 22) {
         gi_872 = 9;
         gi_876 = 6;
      }
   }
   int lia_16[9] = {0, 8, 10, 6, 8, 10, 4, 6, 8,
   10};
   int lia_20[9] = {0, 2, 2, 3, 3, 3, 4, 4, 4,
   4};
   g_period_532 = lia_16[FletFilterLevel];
   g_period_732 = lia_16[FletFilterLevel];
   g_ma_method_544 = 1;
   g_ma_method_744 = 1;
   gd_536 = lia_20[FletFilterLevel];
   gd_736 = lia_20[FletFilterLevel];
   g_applied_price_548 = 6;
   g_applied_price_748 = 6;
   if (!DoubleChannels) {
      g_str2int_460 = ChannelBars;
      g_str2int_468 = ChannelBars;
      g_str2int_472 = ChannelBars;
   }
   li_ret_8 = ai_0;
   if (ai_4) Comments(8, "SetMode()", "Установлены настройки: " + gs_1828, "Load settings: " + gs_1828);
   return (li_ret_8);
}

int MakeTimeString() {
   bool li_24;
   bool li_ret_4 = FALSE;
   if (!gi_1044 || !ShowTimes) return (li_ret_4);
   gs_1796 = "00 " + "01 " + "02 " + "03 " + "04 " + "05 " + "06 " + "07 " + "08 " + "09 " + "10 " + "11 " + "12 " + "13 " + "14 " + "15 " + "16 " + "17 " + "18 " + "19 " + "20 " + "21 " + "22 " + "23 " + "24 " 
   + "\n";
   int li_28 = TimeCurrent() - 86400 * DayOfWeek() - 3600 * Hour() - 60 * Minute() - Seconds() + 86400 + 1800;
   for (int li_8 = 1; li_8 < 6; li_8++) {
      gs_1796 = gs_1796 + " |";
      for (int i = 0; i < 24; i++) {
         for (int li_0 = 0; li_0 < 10; li_0 += 2) {
            li_24 = FALSE;
            if (isTimetoTrade(li_28)) {
               li_24 = TRUE;
               break;
            }
         }
         if (li_24) gs_1796 = gs_1796 + ":::|";
         else gs_1796 = gs_1796 + "   |";
         li_28 += 3600;
      }
      gs_1796 = gs_1796 
      + "\n";
   }
   return (li_ret_4);
}

int MakeInitString() {
   if (!gi_1044) return (0);
   gs_1788 = "";
   string ls_0 = " GMT";
   string ls_8 = "";
   if (TimeZone >= 0) ls_0 = ls_0 + "+" + TimeZone;
   else ls_0 = ls_0 + "" + TimeZone;
   if (CorrectionTime > 0) ls_0 = ls_0 + " (Corr+" + CorrectionTime + ")";
   if (CorrectionTime < 0) ls_0 = ls_0 + " (Corr" + CorrectionTime + ")";
   if (CorrectionTime == 0) ls_0 = ls_0 + " (Corr " + CorrectionTime + ")";
   gs_1788 = gs_1788 + AccountCompany() + " (" + AccountNumber() + "): " + AccountName() + " (magic " + ((g_magic_1272 - gi_1292)) + "+" + gi_1292 + ")" + ls_0 + ls_8 
   + "\n";
   string ls_16 = "Cross (normal) Mode";
   if (CrossOverMode) ls_16 = "Cross Over Mode";
   if (MarketInfoMode) ls_16 = "Market Information Mode";
   gs_1788 = gs_1788 + ls_16 
   + "\n";
   if (TradeTransferOut && !gi_944) {
      gs_1788 = gs_1788 + "Режим передачи данных" 
      + "\n";
   }
   if (!TradeTransferOut && gi_944) {
      gs_1788 = gs_1788 + "Режим приема данных" 
      + "\n";
   }
   return (0);
}

int Comments(int ai_0, string as_4, string as_12, string as_20) {
   if (Language == "eng") as_12 = as_20;
   bool li_ret_28 = FALSE;
   string ls_40 = "";
   if (ai_0 == 8 || ai_0 == 9) {
      if (gi_1056) as_12 = as_4 + ": " + as_12;
      if (ai_0 == 8 || (ai_0 == 9 && gi_1072)) {
         if (gi_1084) {
            ls_40 = ls_40 + TimeToStr(TimeCurrent(), TIME_SECONDS) + " : ";
            if (gi_1088) ls_40 = ls_40 + "euronis";
            if (gi_1092) ls_40 = ls_40 + "(" + g_magic_1272 + ")";
            if (gi_1088 || gi_1092) ls_40 = ls_40 + ": ";
            Print(ls_40 + as_12);
         }
         ls_40 = "";
         if (gi_1044) {
            if (ShowTimes) ls_40 = ls_40 + gs_1796;
            if (ShowInformation) {
               g_count_1392++;
               if (g_count_1392 > InformationStringNumber) {
                  g_count_1392 = InformationStringNumber;
                  if (InformationStringNumber > 1) for (int l_index_32 = 0; l_index_32 < InformationStringNumber - 1; l_index_32++) InformationString[l_index_32] = InformationString[l_index_32 + 1];
               }
               InformationString[g_count_1392 - 1] = TimeToStr(TimeCurrent(), TIME_SECONDS) + " : " + as_12;
               for (l_index_32 = 0; l_index_32 < InformationStringNumber; l_index_32++) {
                  ls_40 = ls_40 + InformationString[l_index_32];
                  if (l_index_32 < InformationStringNumber - 1) {
                     ls_40 = ls_40 
                     + "\n";
                  }
               }
            }
            gs_1820 = ls_40;
            if (ShowStateInfo) {
               ls_40 = ls_40 
                  + "\n" 
                  + VariablesString[0] 
                  + "\n" 
                  + VariablesString[1] 
                  + "\n" 
                  + VariablesString[2] 
                  + "\n" 
                  + VariablesString[3] 
                  + "\n" 
                  + VariablesString[4] 
                  + "\n" 
                  + VariablesString[5] 
                  + "\n" 
               + VariablesString[6];
            }
            Comment(gs_1788 + gs_1908 + ls_40);
         }
      }
      if (gi_1080) {
         for (l_index_32 = 0; l_index_32 < 20; l_index_32++) {
            if (LogFileString[l_index_32] == "") {
               LogFileString[l_index_32] = TimeToStr(TimeCurrent(), TIME_SECONDS) + " : " + as_12;
               if (l_index_32 != 19) break;
               function_53(" ");
               break;
            }
         }
      }
   }
   if (ai_0 == 0 || ai_0 == 1 || ai_0 == 2 || ai_0 == 3 || ai_0 == 4 || ai_0 == 5 || ai_0 == 6) {
      VariablesString[ai_0] = as_12;
      if (gi_1044) {
         ls_40 = gs_1820;
         if (ShowStateInfo) {
            ls_40 = ls_40 
               + "\n" 
               + VariablesString[0] 
               + "\n" 
               + VariablesString[1] 
               + "\n" 
               + VariablesString[2] 
               + "\n" 
               + VariablesString[3] 
               + "\n" 
               + VariablesString[4] 
               + "\n" 
               + VariablesString[5] 
               + "\n" 
            + VariablesString[6];
         }
         Comment(gs_1788 + gs_1908 + ls_40);
      }
   }
   if (ai_0 == 7) {
      if (gi_1044) {
         ls_40 = gs_1820;
         if (ShowStateInfo) {
            ls_40 = ls_40 
               + "\n" 
               + VariablesString[0] 
               + "\n" 
               + VariablesString[1] 
               + "\n" 
               + VariablesString[2] 
               + "\n" 
               + VariablesString[3] 
               + "\n" 
               + VariablesString[4] 
               + "\n" 
               + VariablesString[5] 
               + "\n" 
            + VariablesString[6];
         }
         Comment(gs_1788 + gs_1908 + ls_40);
      }
   }
   return (li_ret_28);
}

string PrintError(int ai_0) {
   if (ai_0 > 4299 || ai_0 < 0) ai_0 = 4299;
   string ls_ret_4 = ai_0 + " " + ErrorArray[ai_0];
   return (ls_ret_4);
}

void InitErrorArray() {
   if (Language == "eng") {
      ErrorArray[0] = "No error returned";
      ErrorArray[1] = "No error returned, but the result is unknown";
      ErrorArray[2] = "Common error";
      ErrorArray[3] = "Invalid trade parameters";
      ErrorArray[4] = "Trade server is busy";
      ErrorArray[5] = "Old version of the client terminal";
      ErrorArray[6] = "No connection with trade server";
      ErrorArray[7] = "Not enough rights";
      ErrorArray[8] = "Too frequent requests";
      ErrorArray[9] = "Malfunctional trade operation";
      ErrorArray[64] = "Account disabled";
      ErrorArray[65] = "Invalid account";
      ErrorArray[128] = "Trade timeout";
      ErrorArray[129] = "Invalid price";
      ErrorArray[130] = "Invalid stops";
      ErrorArray[131] = "Invalid trade volume";
      ErrorArray[132] = "Market is closed";
      ErrorArray[133] = "Trade is disabled";
      ErrorArray[134] = "Not enough money";
      ErrorArray[135] = "Price changed";
      ErrorArray[136] = "Off quotes";
      ErrorArray[137] = "Broker is busy";
      ErrorArray[138] = "Requote";
      ErrorArray[139] = "Order is locked";
      ErrorArray[140] = "Long positions only allowed";
      ErrorArray[141] = "Too many requests";
      ErrorArray[145] = "Modification denied because an order is too close to market";
      ErrorArray[146] = "Trade context is busy";
      ErrorArray[147] = "Expirations are denied by broker";
      ErrorArray[148] = "The amount of opened and pending orders has reached the limit set by a broker";
      ErrorArray[4000] = "No error";
      ErrorArray[4001] = "Wrong function pointer";
      ErrorArray[4002] = "Array index is out of range";
      ErrorArray[4003] = "No memory for function call stack";
      ErrorArray[4004] = "Recursive stack overflow";
      ErrorArray[4005] = "На стеке нет памяти для передачи параметров";
      ErrorArray[4006] = "Not enough stack for parameter";
      ErrorArray[4007] = "No memory for parameter string";
      ErrorArray[4008] = "Not initialized string";
      ErrorArray[4009] = "Not initialized string in an array";
      ErrorArray[4010] = "No memory for an array string";
      ErrorArray[4011] = "Too long string";
      ErrorArray[4012] = "Remainder from zero divide";
      ErrorArray[4013] = "Zero divide";
      ErrorArray[4014] = "Unknown command";
      ErrorArray[4015] = "Wrong jump";
      ErrorArray[4016] = "Not initialized array";
      ErrorArray[4017] = "DLL calls are not allowed";
      ErrorArray[4018] = "Cannot load library";
      ErrorArray[4019] = "Cannot call function";
      ErrorArray[4020] = "EA function calls are not allowed";
      ErrorArray[4021] = "Not enough memory for a string returned from a function";
      ErrorArray[4022] = "System is busy";
      ErrorArray[4050] = "Invalid function parameters count";
      ErrorArray[4051] = "Invalid function parameter value";
      ErrorArray[4052] = "String function internal error";
      ErrorArray[4053] = "Some array error";
      ErrorArray[4054] = "Incorrect series array using";
      ErrorArray[4055] = "Custom indicator error";
      ErrorArray[4056] = "Arrays are incompatible";
      ErrorArray[4057] = "Global variables processing error";
      ErrorArray[4058] = "Global variable not found";
      ErrorArray[4059] = "Function is not allowed in testing mode";
      ErrorArray[4060] = "Function is not confirmed";
      ErrorArray[4061] = "Mail sending error";
      ErrorArray[4062] = "String parameter expected";
      ErrorArray[4063] = "Integer parameter expected";
      ErrorArray[4064] = "Double parameter expected";
      ErrorArray[4065] = "Array as parameter expected";
      ErrorArray[4066] = "Requested history data in updating state";
      ErrorArray[4067] = "Some error in trade operation execution";
      ErrorArray[4099] = "End of a file";
      ErrorArray[4100] = "Some file error";
      ErrorArray[4101] = "Wrong file name";
      ErrorArray[4102] = "Too many opened files";
      ErrorArray[4103] = "Cannot open file";
      ErrorArray[4104] = "Incompatible access to a file";
      ErrorArray[4105] = "No order selected";
      ErrorArray[4106] = "Unknown symbol";
      ErrorArray[4107] = "Invalid price";
      ErrorArray[4108] = "Invalid ticket";
      ErrorArray[4109] = "Trade is not allowed";
      ErrorArray[4110] = "Longs are not allowed";
      ErrorArray[4111] = "Shorts are not allowed";
      ErrorArray[4200] = "Object already exists";
      ErrorArray[4201] = "Unknown object property";
      ErrorArray[4202] = "Object does not exist";
      ErrorArray[4203] = "Unknown object type";
      ErrorArray[4204] = "No object name";
      ErrorArray[4205] = "Object coordinates error";
      ErrorArray[4206] = "No specified subwindow";
      ErrorArray[4207] = "Some error in object operation";
      ErrorArray[4299] = "Error code is out of range";
      return;
   }
   ErrorArray[0] = "Нет ошибки";
   ErrorArray[1] = "Нет ошибки, но результат неизвестен";
   ErrorArray[2] = "Общая ошибка";
   ErrorArray[3] = "Неправильные параметры";
   ErrorArray[4] = "Торговый сервер занят";
   ErrorArray[5] = "Старая версия клиентского терминала";
   ErrorArray[6] = "Нет связи с торговым сервером";
   ErrorArray[7] = "Недостаточно прав";
   ErrorArray[8] = "Слишком частые запросы";
   ErrorArray[9] = "Недопустимая операция нарушающая функционирование сервера";
   ErrorArray[64] = "Счет заблокирован";
   ErrorArray[65] = "Неправильный номер счета";
   ErrorArray[128] = "Истек срок ожидания совершения сделки";
   ErrorArray[129] = "Неправильная цена";
   ErrorArray[130] = "Неправильные стопы";
   ErrorArray[131] = "Неправильный объем";
   ErrorArray[132] = "Рынок закрыт";
   ErrorArray[133] = "Торговля запрещена";
   ErrorArray[134] = "Недостаточно денег для совершения операции";
   ErrorArray[135] = "Цена изменилась";
   ErrorArray[136] = "Нет цен";
   ErrorArray[137] = "Брокер занят";
   ErrorArray[138] = "Новые цены";
   ErrorArray[139] = "Ордер заблокирован и уже обрабатывается";
   ErrorArray[140] = "Разрешена только покупка";
   ErrorArray[141] = "Слишком много запросов";
   ErrorArray[145] = "Модификация запрещена, так как ордер слишком близок к рынку";
   ErrorArray[146] = "Подсистема торговли занята";
   ErrorArray[147] = "Использование даты истечения ордера запрещено брокером";
   ErrorArray[148] = "Количество открытых и отложенных ордеров достигло предела, установленного брокером";
   ErrorArray[4000] = "Нет ошибки";
   ErrorArray[4001] = "Неправильный указатель функции";
   ErrorArray[4002] = "Индекс массива - вне диапазона";
   ErrorArray[4003] = "Нет памяти для стека функций";
   ErrorArray[4004] = "Переполнение стека после рекурсивного вызова";
   ErrorArray[4005] = "На стеке нет памяти для передачи параметров";
   ErrorArray[4006] = "Нет памяти для строкового параметра";
   ErrorArray[4007] = "Нет памяти для временной строки";
   ErrorArray[4008] = "Неинициализированная строка";
   ErrorArray[4009] = "Неинициализированная строка в массиве";
   ErrorArray[4010] = "Нет памяти для строкового массива";
   ErrorArray[4011] = "Слишком длинная строка";
   ErrorArray[4012] = "Остаток от деления на ноль";
   ErrorArray[4013] = "Деление на ноль";
   ErrorArray[4014] = "Неизвестная команда";
   ErrorArray[4015] = "Неправильный переход";
   ErrorArray[4016] = "Неинициализированный массив";
   ErrorArray[4017] = "Вызовы DLL не разрешены";
   ErrorArray[4018] = "Невозможно загрузить библиотеку";
   ErrorArray[4019] = "Невозможно вызвать функцию";
   ErrorArray[4020] = "Вызовы внешних библиотечных функций не разрешены";
   ErrorArray[4021] = "Недостаточно памяти для строки, возвращаемой из функции";
   ErrorArray[4022] = "Система занята";
   ErrorArray[4050] = "Неправильное количество параметров функции";
   ErrorArray[4051] = "Недопустимое значение параметра функции";
   ErrorArray[4052] = "Внутренняя ошибка строковой функции";
   ErrorArray[4053] = "Ошибка массива";
   ErrorArray[4054] = "Неправильное использование массива-таймсерии";
   ErrorArray[4055] = "Ошибка пользовательского индикатора";
   ErrorArray[4056] = "Массивы несовместимы";
   ErrorArray[4057] = "Ошибка обработки глобальныех переменных";
   ErrorArray[4058] = "Глобальная переменная не обнаружена";
   ErrorArray[4059] = "Функция не разрешена в тестовом режиме";
   ErrorArray[4060] = "Функция не разрешена";
   ErrorArray[4061] = "Ошибка отправки почты";
   ErrorArray[4062] = "Ожидается параметр типа string";
   ErrorArray[4063] = "Ожидается параметр типа integer";
   ErrorArray[4064] = "Ожидается параметр типа double";
   ErrorArray[4065] = "В качестве параметра ожидается массив";
   ErrorArray[4066] = "Запрошенные исторические данные в состоянии обновления";
   ErrorArray[4067] = "Ошибка при выполнении торговой операции";
   ErrorArray[4099] = "Конец файла";
   ErrorArray[4100] = "Ошибка при работе с файлом";
   ErrorArray[4101] = "Неправильное имя файла";
   ErrorArray[4102] = "Слишком много открытых файлов";
   ErrorArray[4103] = "Невозможно открыть файл";
   ErrorArray[4104] = "Несовместимый режим доступа к файлу";
   ErrorArray[4105] = "Ни один ордер не выбран";
   ErrorArray[4106] = "Неизвестный символ";
   ErrorArray[4107] = "Неправильный параметр цены для торговой функции";
   ErrorArray[4108] = "Неверный номер тикета";
   ErrorArray[4109] = "Торговля не разрешена. Необходимо включить опцию Разрешить советнику торговать в свойствах эксперта";
   ErrorArray[4110] = "Длинные позиции не разрешены. Необходимо проверить свойства эксперта";
   ErrorArray[4111] = "Короткие позиции не разрешены. Необходимо проверить свойства эксперта";
   ErrorArray[4200] = "Объект уже существует";
   ErrorArray[4201] = "Запрошено неизвестное свойство объекта";
   ErrorArray[4202] = "Объект не существует";
   ErrorArray[4203] = "Неизвестный тип объекта";
   ErrorArray[4204] = "Нет имени объекта";
   ErrorArray[4205] = "Ошибка координат объекта";
   ErrorArray[4206] = "Не найдено указанное подокно";
   ErrorArray[4207] = "Ошибка при работе с объектом";
   ErrorArray[4299] = "Код ошибки вне диапазона";
}

int function_49() {
   int lia_0[500][10] = {0, 0, 0, 0, 0, 0, 0, 0, 23, 24,
   0, 0, 0, 0, 0, 0, 0, 0, 23, 24,
   0, 0, 0, 0, 0, 0, 0, 0, 23, 24,
   0, 0, 0, 0, 0, 0, 0, 0, 23, 24,
   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
   0, 0, 0, 0, 0, 0, 0, 0, 23, 24,
   0, 2, 0, 0, 0, 0, 0, 0, 23, 24,
   0, 2, 0, 0, 0, 0, 0, 0, 23, 24,
   0, 2, 0, 0, 0, 0, 0, 0, 23, 24,
   0, 2, 0, 0, 0, 0, 0, 0, 0, 0,
   0, 0, 0, 0, 0, 0, 0, 0, 21, 24,
   0, 2, 0, 0, 0, 0, 0, 0, 21, 24,
   0, 2, 0, 0, 0, 0, 0, 0, 21, 24,
   0, 2, 0, 0, 0, 0, 0, 0, 21, 24,
   0, 2, 0, 0, 0, 0, 0, 0, 0, 0,
   0, 0, 0, 0, 0, 0, 0, 0, 23, 24,
   0, 6, 0, 0, 0, 0, 0, 0, 23, 24,
   0, 6, 0, 0, 0, 0, 0, 0, 23, 24,
   0, 6, 0, 0, 0, 0, 0, 0, 23, 24,
   0, 6, 0, 0, 0, 0, 0, 0, 0, 0,
   0, 0, 0, 0, 0, 0, 0, 0, 21, 24,
   0, 7, 0, 0, 0, 0, 0, 0, 21, 24,
   0, 7, 0, 0, 0, 0, 0, 0, 21, 24,
   0, 7, 0, 0, 0, 0, 0, 0, 21, 24,
   0, 7, 0, 0, 0, 0, 0, 0, 0, 0,
   0, 0, 0, 0, 0, 0, 19, 21, 24, 24,
   0, 0, 0, 0, 0, 0, 19, 21, 24, 24,
   0, 0, 0, 0, 0, 0, 19, 21, 24, 24,
   0, 0, 0, 0, 0, 0, 19, 21, 24, 24,
   0, 0, 0, 0, 0, 0, 19, 20, 24, 24,
   0, 0, 0, 0, 0, 0, 18, 21, 24, 24,
   0, 0, 0, 0, 0, 0, 18, 21, 24, 24,
   0, 0, 0, 0, 0, 0, 18, 21, 24, 24,
   0, 0, 0, 0, 0, 0, 18, 21, 24, 24,
   0, 0, 0, 0, 0, 0, 18, 20, 24, 24,
   0, 0, 0, 0, 6, 9, 18, 21, 24, 24,
   0, 0, 0, 0, 6, 9, 18, 21, 24, 24,
   0, 0, 0, 0, 6, 9, 18, 21, 24, 24,
   0, 0, 0, 0, 6, 9, 18, 21, 24, 24,
   0, 0, 0, 0, 6, 9, 18, 20, 24, 24,
   0, 0, 0, 0, 6, 12, 17, 21, 24, 24,
   0, 0, 0, 0, 6, 12, 17, 21, 24, 24,
   0, 0, 0, 0, 6, 12, 17, 21, 24, 24,
   0, 0, 0, 0, 6, 12, 17, 21, 24, 24,
   0, 0, 0, 0, 6, 12, 17, 20, 24, 24,
   0, 0, 0, 0, 6, 14, 17, 21, 24, 24,
   0, 0, 0, 0, 6, 14, 17, 21, 24, 24,
   0, 0, 0, 0, 6, 14, 17, 21, 24, 24,
   0, 0, 0, 0, 6, 14, 17, 21, 24, 24,
   0, 0, 0, 0, 6, 14, 17, 20, 24, 24};
   ArrayCopy(gia_1436, lia_0, 0, 0, WHOLE_ARRAY);
   return (0);
}

int function_51() {
   double l_global_var_12;
   bool li_ret_0 = FALSE;
   double ld_4 = MathRound(GetTickCount() / 100);
   if (IsOptimization() || IsTesting()) {
      if (GlobalVariableCheck("LastOptTime")) {
         l_global_var_12 = GlobalVariableGet("LastOptTime");
         GlobalVariableSet("LastOptTime", ld_4);
         if (l_global_var_12 > ld_4) ld_4 += 86400.0;
         if (ld_4 - l_global_var_12 > gd_1116) li_ret_0 = TRUE;
      } else {
         GlobalVariableSet("LastOptTime", ld_4);
         li_ret_0 = TRUE;
      }
      if (!GlobalVariableCheck("OptCounter")) GlobalVariableSet("OptCounter", 0.0);
   }
   return (li_ret_0);
}

int CheckBlockByStopsDate() {
   bool li_ret_0 = FALSE;
   gi_2360 = MathAbs(StringFind(g_var_name_1940, CharToStr(84)));
   if (GlobalVariableGet(g_var_name_1940) == 1.0 * gi_1380 && g_hour_1372 < 16 && !gi_1724 && !gi_1648) gi_1648 = TRUE;
   return (li_ret_0);
}

int function_53(string as_0) {
   int l_file_32;
   bool li_ret_8 = FALSE;
   int l_index_12 = 0;
   string ls_16 = "";
   if (gi_1380 < 10) ls_16 = ls_16 + "0";
   ls_16 = ls_16 + gi_1380;
   if (g_month_1384 < 10) ls_16 = ls_16 + "0";
   ls_16 = ls_16 + g_month_1384 + g_year_1388;
   ls_16 = ls_16 + "_" + gs_1876;
   gi_1408 = StrToInteger(StringSubstr(ls_16, StringFind(ls_16, CharToStr(95), 11) - 1, 1)) - StrToInteger(Массив_источник[10][1]);
   string ls_24 = "CET: ";
   if (gi_1408 != 0) ls_24 = ls_24 + " ";
   if (gi_1380 < 10) ls_24 = ls_24 + "0";
   ls_24 = ls_24 + gi_1380 + ".";
   if (g_month_1384 < 10) ls_24 = ls_24 + "0";
   ls_24 = ls_24 + g_month_1384 + "." + g_year_1388 + " ";
   ls_24 = ls_24 + TimeToStr(gi_1756, TIME_SECONDS);
   ls_24 = ls_24 + " TT: ";
   if (Day() < 10) ls_24 = ls_24 + "0";
   ls_24 = ls_24 + Day() + ".";
   if (Month() < 10) ls_24 = ls_24 + "0";
   ls_24 = ls_24 + Month() + "." + Year() + " ";
   if (!gi_1080) return (li_ret_8);
   if (LogFileString[0] != "" || as_0 == "deinit") {
      l_file_32 = FileOpen(ls_16, FILE_CSV|FILE_WRITE|FILE_READ, ';');
      if (l_file_32 < 1) {
         Print("Невозможно записать данные в файл " + ls_16 + ", ошибка: ", GetLastError());
         return (li_ret_8);
      }
      FileSeek(l_file_32, 0, SEEK_END);
      if (as_0 == "deinit") FileWrite(l_file_32, ls_24 + TimeToStr(TimeCurrent(), TIME_SECONDS) + " : ----------------------------deinit------------------------------");
      else {
         for (l_index_12 = 0; l_index_12 < 20; l_index_12++) {
            if (LogFileString[l_index_12] == "") break;
            FileWrite(l_file_32, ls_24 + LogFileString[l_index_12]);
            LogFileString[l_index_12] = "";
         }
      }
      FileClose(l_file_32);
      li_ret_8 = TRUE;
   }
   return (li_ret_8);
}

int CheckPointDifference() {
   if (Point == 0.00001 || Point == 0.001) dig = 10;
   else dig = 1;
   StopLoss *= dig;
   TakeProfit *= dig;
   gi_164 *= dig;
   gi_228 *= dig;
   gi_360 *= dig;
   gi_368 *= dig;
   gd_388 *= dig;
   gd_412 *= dig;
   gd_424 *= dig;
   gi_476 *= dig;
   gi_480 *= dig;
   gi_484 *= dig;
   gi_488 *= dig;
   gd_536 *= dig;
   gd_568 *= dig;
   gd_596 *= dig;
   gd_612 *= dig;
   gd_736 *= dig;
   WorkingSpreadValue *= dig;
   MaxSpreadValue *= dig;
   gd_820 *= dig;
   gd_828 *= dig;
   gd_836 *= dig;
   gi_304 *= dig;
   gi_308 *= dig;
   gi_644 *= dig;
   gi_652 *= dig;
   gi_660 *= dig;
   gi_668 *= dig;
   gi_676 *= dig;
   g_slippage_316 *= dig;
   g_slippage_320 *= dig;
   return (0);
}

int CheckMarketInfo() {
   if (MarketInfoMode) {
      TimeRiskFactor = -2;
      OpenHourAM = 0;
      CloseHourAM = 0;
      OpenHourPM = 24;
      CloseHourPM = 24;
      ShowTimes = FALSE;
      ShowInformation = TRUE;
      InformationStringNumber = 15;
      ShowStateInfo = TRUE;
      gi_1068 = FALSE;
      gi_1072 = FALSE;
      gi_1076 = TRUE;
      gi_1080 = TRUE;
      gi_1084 = TRUE;
      CrossOverMode = TRUE;
   }
   if (IsOptimization() || IsTesting()) {
      CrossOverMode = FALSE;
      CheckCrossOver = FALSE;
   }
   if (CrossOverMode) {
      CheckCrossOver = TRUE;
      gi_188 = TRUE;
      gi_192 = TRUE;
   }
   gs_1836 = GetSymbol();
   if (gs_1836 == "") {
      Comments(8, "CheckMarketInfo()", "Торговля заблокирована: неизвестная валютная пара " + Symbol(), "Trade is disable: Unknown symbol " + Symbol());
      gi_1748 = TRUE;
   }
   if (gs_1964 != "" || gs_1972 != "") Comments(8, "CheckMarketInfo()", "Обнаружены добавочные символы к названию валютной пары " + Symbol(), "Found additive to the Symbol name " + Symbol());
   isCheckCrossOver();
   gs_1844 = StringSubstr(AccountCompany(), 0, StringFind(AccountCompany(), " ", 0));
   gi_1292 = PersonalMagicNumber;
   if (CrossOverMode) g_magic_1272 = PersonalMagicNumber + StringGetChar(gs_2048, 0) + StringGetChar(gs_2056, 0) + StringGetChar(gs_2048, 1) + StringGetChar(gs_2056, 1) + StringGetChar(gs_2048, 2) + StringGetChar(gs_2056, 2) + StringGetChar(gs_2048, 3) + StringGetChar(gs_2056, 3) + StringGetChar(gs_2048, 4) + StringGetChar(gs_2056, 4) + StringGetChar(gs_2048, 5) + StringGetChar(gs_2056, 5) + Period();
   else g_magic_1272 = PersonalMagicNumber + StringGetChar(gs_1836, 0) + StringGetChar(gs_1836, 1) + StringGetChar(gs_1836, 2) + StringGetChar(gs_1836, 3) + StringGetChar(gs_1836, 4) + StringGetChar(gs_1836, 5) + Period();

   сумма_цифр_счёта = 18;
   сумма_цифр_счёта_Char = 306;
   gi_1328 = 0;
   сумма_цифр_AccountName = 1372;
  
   for (int li_4 = 0; li_4 < StringLen(AccountServer()); li_4++) gi_1328 += StringGetChar(AccountServer(), li_4);
   gd_1472 = NormalizeDouble(MarketInfo(Symbol(), MODE_LOTSTEP), 2);
   gd_1480 = NormalizeDouble(MarketInfo(Symbol(), MODE_MINLOT), 2);
   MaxLot = NormalizeDouble(MarketInfo(Symbol(), MODE_MAXLOT), 2);
   for (g_count_1452 = 0; g_count_1452 < 10; g_count_1452++)
      if (10 * g_count_1452 * gd_1472 >= 1.0) break;
   for (gi_1768 = StrToTime(Year() + ".10.31"); TimeDayOfWeek(gi_1768) != 0; gi_1768 -= 86400) {
   }
   gi_1780 = gi_1768 + 604800;
   for (gi_1772 = StrToTime(Year() + ".03.31"); TimeDayOfWeek(gi_1772) != 0; gi_1772 -= 86400) {
   }
   for (gi_1776 = StrToTime((Year() + 1) + ".03.31"); TimeDayOfWeek(gi_1776) != 0; gi_1776 -= 86400) {
   }
   gi_1784 = gi_1772 - 1814400;
   gs_1876 = gs_1844 + AccountNumber() + "_" + gs_1836 + g_magic_1272 + ".log";
   gs_1884 = "TestReport_" + gs_1844 + AccountNumber() + "_" + gs_1836 + g_magic_1272;
   gs_1892 = "TradeReport_" + gs_1844 + AccountNumber() + "_" + gs_1836 + g_magic_1272;
   KeyFileName = AccountNumber() + StringSubstr(WindowExpertName(), StringFind(WindowExpertName(), "_", 0), 6) + ".key";
   gs_2336 = "cr" + gs_1836 + Period() + "server" + gi_1328 + ".hst";
   gs_2344 = "os" + AccountNumber() + "_" + gs_1836 + g_magic_1272 + ".ost";
   gi_1312 = 3;
   gi_1308 = 1;
   if (gs_1836 == "EURCHF") gi_1308 = 2;
   if (gs_1836 == "AUDNZD") gi_1308 = 3;
   if (Lots != 0.0) {
      UseBalanceControl = FALSE;
      Comments(8, "CheckMarketInfo()", "Режим BalanceControl выключен: Lots не равен 0", "BalanceControl is disabled: Lots is not zero");
   }
   СУММА = сумма_цифр_счёта + сумма_цифр_счёта_Char + сумма_цифр_AccountName;
   return (1);
}

int SetGlobalVariableNames() {
   g_var_name_1940 = AccountNumber() + "StopDay" + gs_1836 + g_magic_1272;
   g_var_name_1948 = AccountNumber() + "MailReportLB";
   g_var_name_1956 = AccountNumber() + "MailReportLD";
   gs_2352 = "Init" + gs_1836 + g_magic_1272;
   g_var_name_1924 = "MaxBalance";
   g_var_name_1932 = "LB";
   if (IsTesting() || IsOptimization()) {
      g_var_name_1940 = "Test" + g_var_name_1940;
      g_var_name_1948 = "Test" + g_var_name_1948;
      g_var_name_1956 = "Test" + g_var_name_1956;
      g_var_name_1924 = "Test" + g_var_name_1924;
      g_var_name_1932 = "Test" + g_var_name_1932;
   } else {
      g_var_name_1924 = AccountNumber() + g_var_name_1924;
      g_var_name_1932 = AccountNumber() + g_var_name_1932;
   }
   return (0);
}

double GetPointPrice(string as_0) {
   int l_count_16;
   string l_symbol_36;
   string ls_44;
   string ls_52;
   string ls_unused_60;
   string l_symbol_68;
   string ls_76;
   string ls_84;
   string ls_92;
   double ld_ret_8 = 0.0;
   string ls_20 = StringSubstr(gs_1836, 0, 3);
   string ls_28 = StringSubstr(gs_1836, 3, 0);
   double ld_100 = 1.0;
   double ld_108 = 1.0;
   double ld_unused_116 = 1.0;
   if (as_0 != "LotDepo") {
      l_count_16 = 0;
      ld_100 = 0.0;
      while (l_count_16 < 20) {
         if (ls_28 != "USD") {
            ls_44 = "USD" + ls_28;
            ls_52 = ls_28 + "USD";
            l_symbol_36 = gs_1964 + ls_44 + gs_1972;
            ls_92 = ls_44;
            ld_100 = MarketInfo(l_symbol_36, MODE_BID);
            if (ld_100 > 0.0) ld_100 = 1 / ld_100;
            else {
               l_symbol_36 = gs_1964 + ls_52 + gs_1972;
               ls_92 = ls_52;
               ld_100 = MarketInfo(l_symbol_36, MODE_BID);
            }
         } else {
            l_symbol_36 = gs_1964 + ls_20 + "USD" + gs_1972;
            ls_92 = ls_20 + "USD";
            ld_100 = MarketInfo(l_symbol_36, MODE_BID);
         }
         if (ld_100 > 0.0) break;
         l_count_16++;
         Sleep(1000);
      }
      ld_100 = function_58(ls_44, ls_52, ls_92, ld_100);
      if (ld_100 <= 0.0) Comments(8, "GetPointPrice()", "Невозможно инициализировать пару: " + ls_44 + "/" + ls_52, "Unable to init pair: " + ls_44 + "/" + ls_52);
      if (AccountCurrency() != "USD") {
         l_count_16 = 0;
         ld_108 = 0.0;
         while (l_count_16 < 20) {
            ls_76 = "USD" + AccountCurrency();
            ls_84 = AccountCurrency() + "USD";
            l_symbol_68 = gs_1964 + ls_76 + gs_1972;
            ls_92 = ls_76;
            ld_108 = MarketInfo(l_symbol_68, MODE_BID);
            if (ld_108 <= 0.0) {
               l_symbol_68 = gs_1964 + ls_84 + gs_1972;
               ls_92 = ls_84;
               ld_108 = MarketInfo(l_symbol_68, MODE_BID);
               if (ld_108 > 0.0) ld_108 = 1 / ld_108;
            }
            if (ld_108 > 0.0) break;
            l_count_16++;
            Sleep(1000);
         }
         ld_108 = function_58(ls_76, ls_84, ls_92, ld_108);
         if (ld_108 <= 0.0) Comments(8, "GetPointPrice()", "Невозможно инициализировать пару: " + ls_76 + "/" + ls_84, "Unable to init pair: " + ls_76 + "/" + ls_84);
      }
   } else {
      if (ls_20 != "USD") {
         l_count_16 = 0;
         ld_100 = 0.0;
         while (l_count_16 < 20) {
            ls_44 = "USD" + ls_20;
            ls_52 = ls_20 + "USD";
            l_symbol_36 = gs_1964 + ls_44 + gs_1972;
            ls_92 = ls_44;
            ld_100 = MarketInfo(l_symbol_36, MODE_BID);
            if (ld_100 > 0.0) ld_100 = 1 / ld_100;
            else {
               l_symbol_36 = gs_1964 + ls_52 + gs_1972;
               ls_92 = ls_52;
               ld_100 = MarketInfo(l_symbol_36, MODE_BID);
            }
            if (ld_100 > 0.0) break;
            l_count_16++;
            Sleep(1000);
         }
         ld_100 = function_58(ls_44, ls_52, ls_92, ld_100);
         if (ld_100 <= 0.0) Comments(8, "GetPointPrice()", "Невозможно инициализировать пару: " + ls_44 + "/" + ls_52, "Unable to init pair: " + ls_44 + "/" + ls_52);
      }
      if (AccountCurrency() != "USD") {
         l_count_16 = 0;
         ld_108 = 0.0;
         while (l_count_16 < 20) {
            ls_76 = "USD" + AccountCurrency();
            ls_84 = AccountCurrency() + "USD";
            l_symbol_68 = gs_1964 + ls_76 + gs_1972;
            ls_92 = ls_76;
            ld_108 = MarketInfo(l_symbol_68, MODE_BID);
            if (ld_108 <= 0.0) {
               l_symbol_68 = gs_1964 + ls_84 + gs_1972;
               ls_92 = ls_84;
               ld_108 = MarketInfo(l_symbol_68, MODE_BID);
               if (ld_108 > 0.0) ld_108 = 1 / ld_108;
            }
            if (ld_108 > 0.0) break;
            l_count_16++;
            Sleep(1000);
         }
         ld_108 = function_58(ls_76, ls_84, ls_92, ld_108);
         if (ld_108 <= 0.0) Comments(8, "GetPointPrice()", "Невозможно инициализировать пару: " + ls_76 + "/" + ls_84, "Unable to init pair: " + ls_76 + "/" + ls_84);
      }
   }
   if (as_0 == "Symbol") ld_ret_8 = MarketInfo(Symbol(), MODE_LOTSIZE) * Point_Value * ld_100 * ld_108;
   if (as_0 == "LotDepo") ld_ret_8 = 1.0;
   if (as_0 == "DepoUSD") ld_ret_8 = ld_108;
   if (ld_ret_8 <= 0.0) {
      Comments(8, "GetPointPrice()", "Невозможно определить цену пункта по данной валютной паре", "Unable to calculate the point price");
      Comments(9, "GetPointPrice()", "Ошибка: PriceUSD=" + ld_100 + " PriceDepo=" + ld_108 + " (Mode=" + as_0 + " result=" + ld_ret_8 + ")", "Error: PriceUSD=" + ld_100 +
         " PriceDepo=" + ld_108 + " (Mode=" + as_0 + " result=" + ld_ret_8 + ")");
      gi_1748 = TRUE;
   }
   return (ld_ret_8);
}

double function_58(string as_0, string as_8, string as_16, double ad_24) {
   double ld_ret_32 = ad_24;
   if (!IsOptimization() && !IsTesting()) {
      if (ad_24 > 0.0) GlobalVariableSet("z" + as_16, ad_24);
   } else {
      if (ad_24 <= 0.0) {
         if (GlobalVariableGet("z" + as_0) > 0.0) ld_ret_32 = GlobalVariableGet("z" + as_0);
         if (GlobalVariableGet("z" + as_8) > 0.0) ld_ret_32 = GlobalVariableGet("z" + as_8);
      }
   }
   return (ld_ret_32);
}

int DrawDownAction(int ai_0) {
   bool li_ret_4 = FALSE;
   gi_1740 = FALSE;
   if (!gi_1724 && ai_0 == g_str2int_920 || ai_0 == g_str2int_924) {
      gi_1740 = TRUE;
      if (gi_1304 != DDSettingsNumber && DDSettingsNumber != 0) {
         gi_1304 = DDSettingsNumber;
         SetSettings(DDSettingsNumber, 1);
         MakeInitString();
      }
   } else {
      if (gi_1304 != SettingsNumber) {
         gi_1304 = SettingsNumber;
         SetSettings(SettingsNumber, 1);
         MakeInitString();
      }
   }
   if (UseBalanceControl) {
      if (gi_1668) {
         if (gi_1300 != gi_876) {
            gi_1300 = gi_876;
            SetTimeSettings(gi_876);
            MakeTimeString();
            gi_1360--;
            Comments(8, "DrawDownAction()", "Установлено торговое время с мин. рисками", "Low risk trade time");
         }
      } else {
         if (gi_1300 != gi_872) {
            gi_1300 = gi_872;
            SetTimeSettings(gi_872);
            MakeTimeString();
            gi_1360--;
            Comments(8, "DrawDownAction()", "Установлено торговое время с макс. рисками", "High risk trade time");
         }
      }
   }
   return (li_ret_4);
}

int CheckLicense() {
   bool li_ret_0 = FALSE;
   if (сумма_цифр_счёта != сумма_цифр_счёта_KEY) li_ret_0 = TRUE;
   if (сумма_цифр_счёта_Char != сумма_цифр_счёта_Char_KEY) li_ret_0 = TRUE;
   if (сумма_цифр_AccountName != сумма_цифр_AccN_KEY) li_ret_0 = TRUE;
   return (li_ret_0);
}

int GetMaxLotsPercent(int ai_0) {
   int li_ret_4 = 0;
   double ld_8 = MarketInfo(Symbol(), MODE_MARGINREQUIRED);
   if (CrossOverMode) ld_8 = function_33(g_symbol_2032) * MarketInfo(g_symbol_2032, MODE_MARGINREQUIRED) + function_33(g_symbol_2040) * MarketInfo(g_symbol_2040, MODE_MARGINREQUIRED);
   li_ret_4 = AccountStopoutLevel() * ld_8 / 100.0 + ai_0 * GetPointPrice("Symbol");
   if (li_ret_4 < ld_8) li_ret_4 = ld_8;
   if (li_ret_4 > 0) li_ret_4 = MathFloor(MarketInfo(Symbol(), MODE_LOTSIZE) * GetPointPrice("LotDepo") / li_ret_4);
   return (li_ret_4);
}

int SetMaxLots() {
   int li_4;
   SetSettings(SettingsNumber, 0);
   int li_ret_0 = GetMaxLotsPercent(StopLoss);
   if (UseBalanceControl && DDSettingsNumber != SettingsNumber) {
      SetSettings(DDSettingsNumber, 0);
      li_4 = GetMaxLotsPercent(StopLoss);
      if (li_ret_0 > li_4) li_ret_0 = li_4;
   }
   if (li_ret_0 == 0) {
      Comments(8, "SetMaxLots()", "Невозможно посчитать максимально-возможное значение лота MaxLotsPercent", "Unable to calculate the MaxLotsPercent");
      return (li_ret_0);
   }
   gd_1488 = li_ret_0;
   if (MaxLotsPercent == 0) {
      MaxLotsPercent = li_ret_0;
      Comments(8, "SetMaxLots()", "Установлено значение переменной MaxLotsPercent=" + MaxLotsPercent, "New value of MaxLotsPercent=" + MaxLotsPercent);
      if (LotsPercent > li_ret_0) {
         LotsPercent = li_ret_0;
         Comments(8, "SetMaxLots()", "Изменено значение переменной LotsPercent=" + LotsPercent, "Changed value of LotsPercent=" + LotsPercent);
      }
   } else {
      Comments(8, "SetMaxLots()", "Максимальный лот для правильной работы советника в данном режиме должен быть не более " + li_ret_0 + " % от депозита", "Maximal lot value to work in this mode must be not more then " +
         li_ret_0 + " % from depo");
   }
   LotsPercent = 100000 * LotsPercent / MarketInfo(Symbol(), MODE_LOTSIZE);
   MaxLotsPercent = 100000 * MaxLotsPercent / MarketInfo(Symbol(), MODE_LOTSIZE);
   gd_1488 = 100000.0 * gd_1488 / MarketInfo(Symbol(), MODE_LOTSIZE);
   if (gd_1488 <= 0.0) gd_1488 = MaxLotsPercent;
   return (li_ret_0);
}

string GetSymbol() {
   int li_8;
   string ls_ret_0 = "";
   string lsa_20[28] = {"EUR", "USD", "CHF", "GBP", "CAD", "JPY", "AUD", "NZD", "NOK", "RUB", "RUR", "SEK", "SGD", "DKK", "ZAR", "UAH", "MXN", "HKD", "TRY", "PLN", "HUF", "PHP", "MTL", "HRK", "LVL", "CZK", "ILS", "LTL"};
   for (int li_16 = 0; li_16 < StringLen(Symbol()) - 3; li_16++) {
      for (int l_index_12 = 0; l_index_12 < 28; l_index_12++) {
         li_8 = StringFind(Symbol(), lsa_20[l_index_12], li_16);
         if (li_8 == li_16) {
            ls_ret_0 = StringSubstr(Symbol(), li_8, 6);
            if (StringFind(Symbol(), ls_ret_0, 0) != 0) gs_1964 = StringSubstr(Symbol(), 0, StringFind(Symbol(), ls_ret_0, 0));
            if (StringLen(Symbol()) == StringLen(gs_1964) + StringLen(ls_ret_0)) break;
            gs_1972 = StringSubstr(Symbol(), StringLen(gs_1964) + StringLen(ls_ret_0), 0);
            break;
         }
      }
      if (ls_ret_0 != "") break;
   }
   return (ls_ret_0);
}

int EncodeSettings(int ai_0) {
   double l_str2int_20 = 0.0;
   int li_28 = 0;
   ArrayCopy(Массив_приемник, Массив_источник, 0, 0, WHOLE_ARRAY);
   for (int li_12 = 0; li_12 < StringLen(СУММА); li_12++) li_28 += StrToInteger(StringSubstr(СУММА, li_12, 1));
   for (int l_count_8 = 0; l_count_8 <= ai_0; l_count_8++) for (int l_index_4 = 0; l_index_4 < 160; l_index_4++) Массив_приемник[l_index_4][l_count_8] = StrToInteger(Массив_приемник[l_index_4][l_count_8]) - l_index_4 - l_count_8;
   for (li_12 = 0; li_12 < StringLen(СУММА); li_12++) {
      l_str2int_20 = StrToInteger(StringSubstr(СУММА, li_12, 1));
      if (l_str2int_20 != 0.0) {
         if (l_str2int_20 / 2.0 != MathFloor(l_str2int_20 / 2.0)) {
            if (l_str2int_20 < 4.0) {
               for (int l_count_16 = 0; l_count_16 < li_28; l_count_16++) {
                  ArrayCopy(Массив_источник, Массив_приемник, 0, 0, WHOLE_ARRAY);
                  for (l_index_4 = 158; l_index_4 >= 0; l_index_4--) for (l_count_8 = 0; l_count_8 <= ai_0; l_count_8++) Массив_приемник[l_index_4 + 1][l_count_8] = Массив_приемник[l_index_4][l_count_8];
                  for (l_count_8 = 0; l_count_8 <= ai_0; l_count_8++) Массив_приемник[0][l_count_8] = Массив_источник[159][l_count_8];
               }
            } else {
               for (l_count_16 = 0; l_count_16 < li_28; l_count_16++) {
                  ArrayCopy(Массив_источник, Массив_приемник, 0, 0, WHOLE_ARRAY);
                  for (l_index_4 = 1; l_index_4 < 160; l_index_4++) for (l_count_8 = 0; l_count_8 <= ai_0; l_count_8++) Массив_приемник[l_index_4 - 1][l_count_8] = Массив_приемник[l_index_4][l_count_8];
                  for (l_count_8 = 0; l_count_8 <= ai_0; l_count_8++) Массив_приемник[159][l_count_8] = Массив_источник[0][l_count_8];
               }
            }
         } else {
            if (l_str2int_20 > 5.0) {
               for (l_count_16 = 0; l_count_16 < li_28; l_count_16++) {
                  ArrayCopy(Массив_источник, Массив_приемник, 0, 0, WHOLE_ARRAY);
                  for (l_count_8 = ai_0 - 1; l_count_8 >= 0; l_count_8--) for (l_index_4 = 0; l_index_4 < 160; l_index_4++) Массив_приемник[l_index_4][l_count_8 + 1] = Массив_приемник[l_index_4][l_count_8];
                  for (l_index_4 = 0; l_index_4 <= 160; l_index_4++) Массив_приемник[l_index_4][0] = Массив_источник[l_index_4][ai_0];
               }
            } else {
               for (l_count_16 = 0; l_count_16 < li_28; l_count_16++) {
                  ArrayCopy(Массив_источник, Массив_приемник, 0, 0, WHOLE_ARRAY);
                  for (l_count_8 = 1; l_count_8 <= ai_0; l_count_8++) for (l_index_4 = 0; l_index_4 < 160; l_index_4++) Массив_приемник[l_index_4][l_count_8 - 1] = Массив_приемник[l_index_4][l_count_8];
                  for (l_index_4 = 0; l_index_4 <= 160; l_index_4++) Массив_приемник[l_index_4][ai_0] = Массив_источник[l_index_4][0];
               }
            }
         }
      }
   }
   ArrayCopy(Массив_источник, Массив_приемник, 0, 0, WHOLE_ARRAY);
   if (StrToInteger(Массив_источник[0][0]) > 0) ai_0 = 0;
   return (ai_0);
}

int LoadSettingsFile() {
   int l_file_12;
   string ls_16;
   string l_name_24;
   bool li_ret_0 = FALSE;
   
   int li_4 = StrToInteger(StringSubstr(WindowExpertName(), StringFind(WindowExpertName(), "_", 0) + 2, 4)) + 1;
   while (li_4 > 4160) {
      li_4--;
      if (li_4 == 0) ls_16 = "";
      else {
         if (li_4 > 9) ls_16 = li_4;
         else ls_16 = "0" + li_4;
      }
      l_name_24 = "v" + li_4 + ".key";
      l_file_12 = FileOpen(l_name_24, FILE_CSV|FILE_READ, ';');
      if (l_file_12 >= 0) break;
   }
   if (l_file_12 < 1) {
      Comments(8, "LoadSettings()", "Ключевой файл не загружен, ошибка: " + PrintError(GetLastError()), "Can not load the key file, error: " + PrintError(GetLastError()));
      return (0);
   }
   
      //Comments(8, "LoadSettings()", "Загружен ключевой файл (" + l_name_24 + ")", "Loaded the key file (" + l_name_24 + ")");
   int li_8 = -1;
   while (!FileIsLineEnding(l_file_12)) {
      li_8++;
      Массив_приемник[0][li_8] = FileReadString(l_file_12);
   }
   li_ret_0 = li_8;
   li_4 = 1;
   li_8 = -1;
   while (!FileIsEnding(l_file_12)) {
      li_8++;
      Массив_приемник[li_4][li_8] = FileReadString(l_file_12);
      if (li_8 == li_ret_0) {
         li_8 = -1;
         li_4++;
      }
   }
   FileClose(l_file_12);
   ArrayCopy(Массив_источник, Массив_приемник, 0, 0, WHOLE_ARRAY);
   return (li_ret_0);
}

bool CheckHystory() {
   bool li_ret_0 = TRUE;
   for (int li_4 = 1; li_4 < 20; li_4++) {
   }
   return (li_ret_0);
}

int InitVariables() {
   gi_1188 = 0;
   gi_unused_1192 = 0;
   gi_1196 = FALSE;
   gi_unused_1200 = 0;
   gi_unused_1204 = 0;
   gi_unused_1208 = 0;
   dig = 0;
   CorrectionSpreadValue = 0;
   gi_1220 = 0;
   gi_unused_1224 = 0;
   gi_unused_1228 = 0;
   gi_unused_1232 = -1;
   gi_unused_1236 = -1;
   gi_unused_1240 = 25;
   gi_unused_1244 = 0;
   gi_unused_1248 = 0;
   gi_unused_1252 = 0;
   gi_unused_1256 = 0;
   gi_unused_1260 = 0;
   gi_unused_1264 = 0;
   gi_unused_1268 = 0;
   g_magic_1272 = 0;
   сумма_цифр_счёта = 0;
   сумма_цифр_счёта_Char = 0;
   сумма_цифр_AccountName = 0;
   gi_1328 = 0;
   gi_unused_1276 = 0;
   gi_unused_1280 = 0;
   gi_unused_1284 = 0;
   g_minute_1288 = 0;
   gi_1292 = 0;
   gi_1300 = -1;
   gi_1304 = FALSE;
   gi_1308 = 0;
   gi_1312 = 0;
   gi_unused_1332 = 0;
   gi_unused_1336 = 0;
   gi_unused_1340 = 10;
   gi_unused_1344 = 0;
   g_day_of_week_1348 = -1;
   gi_unused_1352 = 25;
   gi_unused_1356 = -1;
   gi_1360 = -1;
   g_time_1364 = -1;
   gi_1368 = 0;
   g_hour_1372 = 0;
   g_day_of_week_1376 = 0;
   gi_1380 = 0;
   g_month_1384 = 0;
   g_year_1388 = 0;
   g_count_1392 = 0;
   gi_1396 = 999;
   gi_1400 = 0;
   g_count_1404 = 0;
   gi_1412 = FALSE;
   gi_1416 = FALSE;
   gi_1420 = 0;
   CorrectionTime = 0;
   g_bars_1428 = FALSE;
   сумма_цифр_счёта_KEY = 0;
   сумма_цифр_счёта_Char_KEY = 0;
   сумма_цифр_AccN_KEY = 0;
   g_bars_2364 = FALSE;
   gd_1456 = 0.0;
   gd_unused_1464 = 0.0;
   gd_1472 = 0.0;
   gd_1480 = 0.0;
   gd_1488 = 0.0;
   gd_1496 = 0.0;
   gd_1504 = 0.0;
   gd_unused_1512 = 0.0;
   gd_unused_1520 = 0.0;
   gd_unused_1528 = 0.0;
   gd_unused_1536 = 0.0;
   g_global_var_1544 = 0.0;
   gd_unused_1552 = 0.0;
   gd_unused_1560 = 0.0;
   gd_unused_1568 = Bid;
   gd_unused_1576 = Ask;
   gi_unused_1596 = 0;
   gi_unused_1604 = 0;
   gi_unused_1608 = 0;
   gi_unused_1612 = 0;
   gi_1616 = FALSE;
   gi_1620 = FALSE;
   gi_unused_1624 = 0;
   gi_unused_1632 = 1;
   gi_1636 = FALSE;
   gi_1640 = FALSE;
   gi_unused_1644 = 0;
   gi_1648 = FALSE;
   gi_1652 = FALSE;
   gi_unused_1656 = 0;
   gi_unused_1660 = 0;
   gi_unused_1664 = 0;
   gi_1668 = FALSE;
   g_str2int_332 = FALSE;
   gi_unused_1672 = 0;
   gi_1676 = TRUE;
   gi_unused_1680 = 1;
   gi_1684 = TRUE;
   gi_unused_1688 = 0;
   gi_unused_1692 = 0;
   gi_1696 = FALSE;
   gi_1700 = FALSE;
   gi_1704 = FALSE;
   gi_1712 = FALSE;
   gi_1716 = FALSE;
   gi_1720 = FALSE;
   gi_1724 = FALSE;
   gi_unused_1728 = 0;
   License = FALSE;
   gi_1736 = FALSE;
   gi_1740 = FALSE;
   gi_unused_1744 = 0;
   gi_1748 = FALSE;
   gi_1752 = FALSE;
   gi_2328 = FALSE;
   gi_2332 = FALSE;
   gi_1756 = 0;
   gi_unused_1760 = 0;
   gi_unused_1764 = 0;
   gi_1768 = 0;
   gi_1772 = 0;
   gi_1776 = 0;
   gi_1780 = 0;
   gi_1784 = 0;
   gs_1788 = "";
   gs_1796 = "";
   gs_unused_1804 = "";
   gs_unused_1812 = "";
   gs_1820 = "";
   gs_1828 = "";
   gs_1836 = "";
   gs_1844 = "";
   gs_1876 = "";
   gs_1884 = "";
   gs_1892 = "";
   KeyFileName = "";
   gs_1908 = "";
   СУММА = "";
   g_var_name_1924 = "";
   g_var_name_1932 = "";
   g_var_name_1940 = "";
   g_var_name_1948 = "";
   g_var_name_1956 = "";
   gs_1964 = "";
   gs_1972 = "";
   account_number = "";
   account_name = "";
   g_spread_2196 = 1000000.0;
   g_spread_2204 = 0.0;
   gd_2212 = 0.0;
   gd_2220 = 1000000.0;
   gd_2228 = 0.0;
   gd_2236 = 0.0;
   g_count_2248 = 0;
   for (int l_index_0 = 0; l_index_0 < 7; l_index_0++) gia_2372[l_index_0] = 0;
   return (1);
}

int function_68(int ai_0, int ai_4, int ai_8) {
   bool li_ret_12 = FALSE;
   if (gia_2264[ai_0][0] == 0) {
      if (isFindLostOrder(ai_0)) {
         function_69(ai_0);
         gia_2264[ai_0][0] = 96;
         gi_1416 = gia_2264[ai_0][1];
      } else {
        ClearBuffer("OSbuffer", ai_0);
         if (isOpenOrder(0) || (!gi_236 && ai_0 > 1) && ai_8) {
            gia_2264[ai_0][0] = 95;
            gia_2264[ai_0][1] = 0;
            gda_2260[ai_0][6] = gd_2004;
            gia_2268[ai_0][4] = TimeCurrent();
         } else {
            if (isOpenOrder(1) || (!gi_236 && ai_0 > 1) && ai_4) {
               gia_2264[ai_0][0] = 95;
               gia_2264[ai_0][1] = 1;
               gda_2260[ai_0][6] = gd_2012;
               gia_2268[ai_0][4] = TimeCurrent();
            }
         }
      }
   }
   if (gia_2264[ai_0][0] == 95) {
      if (isFindLostOrder(ai_0)) {
         function_69(ai_0);
         gia_2264[ai_0][0] = 96;
      } else {
         if (SendOrder(ai_0, gia_2264[ai_0][1], StopLoss, TakeProfit)) {
            gi_1416 = gia_2264[ai_0][1];
            gia_2264[ai_0][0] = 96;
            function_13(ai_0, 95);
         }
      }
   }
   if (gia_2264[ai_0][0] == 96) {
      if (!isFindLostOrder(ai_0)) gia_2264[ai_0][0] = 94;
      else {
         function_69(ai_0);
         isRSItoOpen(0);
         if (gia_2264[ai_0][1] == 0) {
            if (isCloseOrder(ai_0)) {
               gda_2260[ai_0][5] = gd_2012;
               gia_2268[ai_0][5] = TimeCurrent();
               gia_2264[ai_0][0] = 98;
            }
         }
         if (gia_2264[ai_0][1] == 1) {
            if (isCloseOrder(ai_0)) {
               gda_2260[ai_0][5] = gd_2004;
               gia_2268[ai_0][5] = TimeCurrent();
               gia_2264[ai_0][0] = 98;
            }
         }
      }
   }
   if (gia_2264[ai_0][0] == 98 || gia_2264[ai_0][0] == 94) {
      if (isFindLostOrder(ai_0)) {
         function_69(ai_0);
         gia_2264[ai_0][0] = 98;
         if (!isErrorCloseOrder(ai_0, gia_2264[ai_0][1])) gia_2264[ai_0][0] = 94;
      } else {
         if (isOrderClose(ai_0) > 0) {
            gia_2264[ai_0][0] = 0;
            gi_1416 = FALSE;
         }
      }
   }
   return (li_ret_12);
}

int function_69(int ai_0) {
   int l_bool_12;
   int li_16;
   string l_ticket_24;
   string ls_unused_32;
   string ls_unused_40;
   string l_ticket_48;
   string ls_unused_56;
   string ls_unused_64;
   double l_ord_open_price_72;
   double l_ord_profit_80;
   double l_ord_open_price_88;
   double l_ord_profit_96;
   double l_ord_lots_104;
   double l_ord_lots_112;
   int l_cmd_120;
   int l_cmd_128;
   int l_datetime_136;
   int l_datetime_140;
   bool li_144;
   bool li_148;
   bool li_ret_4 = FALSE;
   if (!CrossOverMode) {
      li_16 = OrdersTotal() - 1;
      for (int l_pos_8 = li_16; l_pos_8 >= 0; l_pos_8--) {
         l_bool_12 = OrderSelect(l_pos_8, SELECT_BY_POS, MODE_TRADES);
         if (l_bool_12 > FALSE && OrderMagicNumber() == g_magic_1272) {
            if (OrderSymbol() == Symbol() && StringFind(OrderComment(), gsa_2272[ai_0][4]) >= 0) {
               gda_2260[ai_0][0] = OrderClosePrice();
               gda_2260[ai_0][1] = OrderOpenPrice();
               gda_2260[ai_0][2] = OrderStopLoss();
               gda_2260[ai_0][3] = OrderTakeProfit();
               gda_2260[ai_0][4] = OrderProfit();
               gia_2268[ai_0][0] = OrderCloseTime();
               gia_2268[ai_0][1] = OrderOpenTime();
               gia_2264[ai_0][1] = OrderType();
               gia_2264[ai_0][2] = OrderMagicNumber();
               gsa_2272[ai_0][0] = OrderTicket();
               gsa_2272[ai_0][1] = OrderSymbol();
               gsa_2272[ai_0][2] = gs_1836;
               gda_2260[ai_0][7] = OrderLots();
               if (gda_2260[ai_0][0] > 0.0) {
                  if (gia_2264[ai_0][1] == 1) gia_2264[ai_0][10] = MathRound((gda_2260[ai_0][1] - gd_2004) / Point_Value);
                  if (gia_2264[ai_0][1] == 0) gia_2264[ai_0][10] = MathRound((gd_2012 - gda_2260[ai_0][1]) / Point_Value);
               } else {
                  if (gia_2264[ai_0][1] == 1) gia_2264[ai_0][10] = MathRound((gda_2260[ai_0][1] - gda_2260[ai_0][0]) / Point_Value);
                  if (gia_2264[ai_0][1] == 0) gia_2264[ai_0][10] = MathRound((gda_2260[ai_0][0] - gda_2260[ai_0][1]) / Point_Value);
                  gia_2264[ai_0][3] = TimeCurrent() - gia_2268[ai_0][1];
               }
               li_ret_4 = TRUE;
            }
         }
      }
   } else {
      li_144 = FALSE;
      li_148 = FALSE;
      li_16 = OrdersTotal() - 1;
      for (l_pos_8 = li_16; l_pos_8 >= 0; l_pos_8--) {
         l_bool_12 = OrderSelect(l_pos_8, SELECT_BY_POS, MODE_TRADES);
         if (l_bool_12 > FALSE && OrderMagicNumber() == g_magic_1272 && OrderSymbol() == g_symbol_2032 && StringFind(OrderComment(), gsa_2272[ai_0][4]) >= 0) {
            l_ticket_24 = OrderTicket();
            ls_unused_32 = g_symbol_2032;
            ls_unused_40 = gs_2048;
            l_ord_open_price_72 = OrderOpenPrice();
            l_ord_lots_112 = OrderLots();
            l_ord_profit_80 = OrderProfit();
            l_cmd_120 = OrderType();
            l_datetime_136 = OrderOpenTime();
            li_144 = TRUE;
         }
      }
      for (l_pos_8 = li_16; l_pos_8 >= 0; l_pos_8--) {
         l_bool_12 = OrderSelect(l_pos_8, SELECT_BY_POS, MODE_TRADES);
         if (l_bool_12 > FALSE && OrderMagicNumber() == g_magic_1272 && OrderSymbol() == g_symbol_2040 && StringFind(OrderComment(), gsa_2272[ai_0][4]) >= 0) {
            l_ticket_48 = OrderTicket();
            ls_unused_56 = g_symbol_2040;
            ls_unused_64 = gs_2056;
            l_ord_open_price_88 = OrderOpenPrice();
            l_ord_lots_104 = OrderLots();
            l_ord_profit_96 = OrderProfit();
            l_cmd_128 = OrderType();
            l_datetime_140 = OrderOpenTime();
            li_148 = TRUE;
         }
      }
      if (li_144 && li_148) {
         gda_2260[ai_0][1] = function_70(l_ord_open_price_72, l_ord_open_price_88);
         gda_2260[ai_0][2] = 0.0;
         gda_2260[ai_0][3] = 0.0;
         gda_2260[ai_0][4] = l_ord_profit_80 + l_ord_profit_96;
         gia_2268[ai_0][0] = 0;
         if (l_datetime_136 > l_datetime_140) gia_2268[ai_0][1] = l_datetime_136;
         else gia_2268[ai_0][1] = l_datetime_140;
         gia_2264[ai_0][1] = function_71(l_cmd_120, l_cmd_128);
         gia_2264[ai_0][2] = OrderMagicNumber();
         gsa_2272[ai_0][0] = l_ticket_24 + "/" + l_ticket_48;
         gsa_2272[ai_0][1] = g_symbol_2032 + "/" + g_symbol_2040;
         gsa_2272[ai_0][2] = gs_2048 + "/" + gs_2056;
         gda_2260[ai_0][7] = l_ord_lots_112;
         gia_2264[ai_0][3] = TimeCurrent() - gia_2268[ai_0][1];
         if (gia_2264[ai_0][1] == 1) {
            gia_2264[ai_0][10] = MathRound((gda_2260[ai_0][1] - gd_2004) / Point_Value);
            gia_2264[ai_0][4] = MathRound((gda_2260[ai_0][1] - gda_2260[ai_0][6]) / Point_Value);
         }
         if (gia_2264[ai_0][1] == 0) {
            gia_2264[ai_0][10] = MathRound((gd_2012 - gda_2260[ai_0][1]) / Point_Value);
            gia_2264[ai_0][4] = MathRound((gda_2260[ai_0][6] - gda_2260[ai_0][1]) / Point_Value);
         }
         li_ret_4 = TRUE;
      }
   }
   return (li_ret_4);
}

double function_70(double ad_0, double ad_8) {
   double ld_ret_16 = 0.0;
   if (gi_2064 == 1 && gi_2068 == -1) ld_ret_16 = ad_0 * ad_8;
   if (gi_2064 == 1 && gi_2068 == 1) ld_ret_16 = ad_0 / ad_8;
   if (gi_2064 == -1 && gi_2068 == -1) ld_ret_16 = ad_8 / ad_0;
   return (ld_ret_16);
}

int function_71(int ai_0, int ai_4) {
   int li_ret_8 = -1;
   if (gi_2064 == 1 && gi_2068 == -1) {
      if (ai_0 == 0 && ai_4 == 0) li_ret_8 = 0;
      if (ai_0 == 1 && ai_4 == 1) li_ret_8 = 1;
   }
   if (gi_2064 == 1 && gi_2068 == 1) {
      if (ai_0 == 0 && ai_4 == 1) li_ret_8 = 0;
      if (ai_0 == 1 && ai_4 == 0) li_ret_8 = 1;
   }
   if (gi_2064 == -1 && gi_2068 == -1) {
      if (ai_0 == 1 && ai_4 == 0) li_ret_8 = 0;
      if (ai_0 == 0 && ai_4 == 1) li_ret_8 = 1;
   }
   return (li_ret_8);
}

int function_72(string a_symbol_0, int ai_8) {
   int li_ret_12 = -1;
   if (gi_2064 == 1 && gi_2068 == -1) {
      if (ai_8 == 0 && a_symbol_0 == g_symbol_2032) li_ret_12 = 0;
      if (ai_8 == 0 && a_symbol_0 == g_symbol_2040) li_ret_12 = 0;
      if (ai_8 == 1 && a_symbol_0 == g_symbol_2032) li_ret_12 = 1;
      if (ai_8 == 1 && a_symbol_0 == g_symbol_2040) li_ret_12 = 1;
   }
   if (gi_2064 == 1 && gi_2068 == 1) {
      if (ai_8 == 0 && a_symbol_0 == g_symbol_2032) li_ret_12 = 0;
      if (ai_8 == 0 && a_symbol_0 == g_symbol_2040) li_ret_12 = 1;
      if (ai_8 == 1 && a_symbol_0 == g_symbol_2032) li_ret_12 = 1;
      if (ai_8 == 1 && a_symbol_0 == g_symbol_2040) li_ret_12 = 0;
   }
   if (gi_2064 == -1 && gi_2068 == -1) {
      if (ai_8 == 0 && a_symbol_0 == g_symbol_2032) li_ret_12 = 1;
      if (ai_8 == 0 && a_symbol_0 == g_symbol_2040) li_ret_12 = 0;
      if (ai_8 == 1 && a_symbol_0 == g_symbol_2032) li_ret_12 = 0;
      if (ai_8 == 1 && a_symbol_0 == g_symbol_2040) li_ret_12 = 1;
   }
   return (li_ret_12);
}

double function_73(string a_symbol_0, int ai_8) {
   double l_price_12 = 0.0;
   if (gi_2064 == 1 && gi_2068 == -1) {
      if (ai_8 == 0 && a_symbol_0 == g_symbol_2032) l_price_12 = g_ask_2172;
      if (ai_8 == 0 && a_symbol_0 == g_symbol_2040) l_price_12 = g_ask_2188;
      if (ai_8 == 1 && a_symbol_0 == g_symbol_2032) l_price_12 = g_bid_2164;
      if (ai_8 == 1 && a_symbol_0 == g_symbol_2040) l_price_12 = g_bid_2180;
   }
   if (gi_2064 == 1 && gi_2068 == 1) {
      if (ai_8 == 0 && a_symbol_0 == g_symbol_2032) l_price_12 = g_ask_2172;
      if (ai_8 == 0 && a_symbol_0 == g_symbol_2040) l_price_12 = g_bid_2180;
      if (ai_8 == 1 && a_symbol_0 == g_symbol_2032) l_price_12 = g_bid_2164;
      if (ai_8 == 1 && a_symbol_0 == g_symbol_2040) l_price_12 = g_ask_2188;
   }
   if (gi_2064 == -1 && gi_2068 == -1) {
      if (ai_8 == 0 && a_symbol_0 == g_symbol_2032) l_price_12 = g_bid_2164;
      if (ai_8 == 0 && a_symbol_0 == g_symbol_2040) l_price_12 = g_ask_2188;
      if (ai_8 == 1 && a_symbol_0 == g_symbol_2032) l_price_12 = g_ask_2172;
      if (ai_8 == 1 && a_symbol_0 == g_symbol_2040) l_price_12 = g_bid_2180;
   }
   if (a_symbol_0 == g_symbol_2032) l_price_12 = NormalizeDouble(l_price_12, g_digits_2100);
   if (a_symbol_0 == g_symbol_2040) l_price_12 = NormalizeDouble(l_price_12, g_digits_2108);
   return (l_price_12);
}

bool isFindLostOrder(int ai_0) {
   int l_bool_12;
   int li_16;
   bool li_24;
   bool li_28;
   int l_ticket_32;
   int l_ticket_36;
   double l_price_40;
   bool li_ret_4 = FALSE;
   if (!CrossOverMode) {
      li_16 = OrdersTotal() - 1;
      for (int l_pos_8 = li_16; l_pos_8 >= 0; l_pos_8--) {
         l_bool_12 = OrderSelect(l_pos_8, SELECT_BY_POS, MODE_TRADES);
         if (l_bool_12 > FALSE && OrderMagicNumber() == g_magic_1272 && OrderSymbol() == Symbol() && StringFind(OrderComment(), gsa_2272[ai_0][4]) >= 0) {
            isOrder(ai_0, OrderType());
            li_ret_4 = TRUE;
            break;
         }
      }
   } else {
      li_24 = FALSE;
      li_28 = FALSE;
      l_ticket_32 = 0;
      l_ticket_36 = 0;
      li_16 = OrdersTotal() - 1;
      for (l_pos_8 = li_16; l_pos_8 >= 0; l_pos_8--) {
         if (OrderSelect(l_pos_8, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderMagicNumber() == g_magic_1272 && OrderSymbol() == g_symbol_2040 && StringFind(OrderComment(), gsa_2272[ai_0][4]) >= 0) {
               l_ticket_36 = OrderTicket();
               li_28 = TRUE;
               break;
            }
         }
      }
      for (l_pos_8 = li_16; l_pos_8 >= 0; l_pos_8--) {
         if (OrderSelect(l_pos_8, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderMagicNumber() == g_magic_1272 && OrderSymbol() == g_symbol_2032 && StringFind(OrderComment(), gsa_2272[ai_0][4]) >= 0) {
               l_ticket_32 = OrderTicket();
               li_24 = TRUE;
               break;
            }
         }
      }
      if (li_24 && li_28) li_ret_4 = TRUE;
      else {
         if (li_24 || li_28) {
            if (li_24) {
               OrderSelect(l_ticket_32, SELECT_BY_TICKET);
               if (OrderType() == OP_SELL) l_price_40 = g_ask_2172;
               else l_price_40 = g_bid_2164;
            }
            if (li_28) {
               OrderSelect(l_ticket_36, SELECT_BY_TICKET);
               if (OrderType() == OP_SELL) l_price_40 = g_ask_2188;
               else l_price_40 = g_bid_2180;
            }
            if (IsTradeAllowed()) {
               if (OrderClose(OrderTicket(), OrderLots(), l_price_40, g_slippage_320 / dig * gi_2072, Black)) {
                  if (gi_1172) {
                     gi_1648 = TRUE;
                     GlobalVariableSet(g_var_name_1940, gi_1380);
                     Comments(8, "isFindLostOrder()", "Торговля заблокирована: Закрыт потерянный ордер", "Trade stoped: Closed lost order");
                  } else Comments(8, "isFindLostOrder()", "Закрыт потерянный ордер", "Closed lost order");
               } else Comments(8, "isFindLostOrder()", "Не удалось закрыть потерянный ордер", "Can not close lost order");
            }
         }
      }
      function_83(ai_0, li_ret_4);
   }
   return (li_ret_4);
}

int CheckCrossOverMode() {
   double ld_4;
   double ld_12;
   bool li_ret_0 = FALSE;
   RefreshRates();
   StopLevel_Value = MarketInfo(Symbol(), MODE_STOPLEVEL);
   gd_2124 = MarketInfo(Symbol(), MODE_FREEZELEVEL);
   Point_Value = MarketInfo(Symbol(), MODE_POINT);
   g_digits_2028 = MarketInfo(Symbol(), MODE_DIGITS);
   if (CheckCrossOver) {
      ld_4 = function_76(gs_2048);
      ld_12 = function_76(gs_2056);
      if (ld_4 > 0.0 && ld_12 > 0.0) {
         gd_2132 = MarketInfo(g_symbol_2032, MODE_SPREAD);
         gd_2140 = MarketInfo(g_symbol_2040, MODE_SPREAD);
         gd_2148 = gd_2132 * MarketInfo(g_symbol_2032, MODE_POINT);
         gd_2156 = gd_2140 * MarketInfo(g_symbol_2040, MODE_POINT);
         g_bid_2164 = MarketInfo(g_symbol_2032, MODE_BID);
         g_ask_2172 = MarketInfo(g_symbol_2032, MODE_ASK);
         g_bid_2180 = MarketInfo(g_symbol_2040, MODE_BID);
         g_ask_2188 = MarketInfo(g_symbol_2040, MODE_ASK);
         if (gi_2064 == 1 && gi_2068 == -1) {
            gd_2004 = g_ask_2172 * g_ask_2188;
            gd_2012 = g_bid_2164 * g_bid_2180;
         }
         if (gi_2064 == 1 && gi_2068 == 1) {
            gd_2004 = g_ask_2172 / g_bid_2180;
            gd_2012 = g_bid_2164 / g_ask_2188;
         }
         if (gi_2064 == -1 && gi_2068 == -1) {
            gd_2004 = g_ask_2188 / g_bid_2164;
            gd_2012 = g_bid_2180 / g_ask_2172;
         }
         gd_1996 = (gd_2004 - gd_2012) / Point_Value;
         li_ret_0 = TRUE;
      } else {
         if (CheckCrossOver) {
            Comments(8, "CheckCrossOverMode()", "Режим CheckCrossOver выключен: недосаточно данных по долларовым парам " + g_symbol_2032 + " и " + g_symbol_2040, "CheckCrossOver is disable: no USD pairs data " +
               g_symbol_2032 + " and " + g_symbol_2032);
         }
         CheckCrossOver = FALSE;
         if (CrossOverMode) {
            Comments(8, "CheckCrossOverMode()", "Режим CrossOverMode выключен: недосаточно данных по долларовым парам " + g_symbol_2032 + " и " + g_symbol_2040, "CrossOverMode is disable: no USD pairs data " +
               g_symbol_2032 + " and " + g_symbol_2032);
         }
         CrossOverMode = FALSE;
      }
   }
   if (!CheckCrossOver) {
      gd_2132 = 0.0;
      gd_2140 = 0.0;
      gd_2148 = 0.0;
      gd_2156 = 0.0;
      g_bid_2164 = 0.0;
      g_ask_2172 = 0.0;
      g_bid_2180 = 0.0;
      g_ask_2188 = 0.0;
      gd_2004 = Ask;
      gd_2012 = Bid;
      gd_1996 = MarketInfo(Symbol(), MODE_SPREAD);
   }
   return (li_ret_0);
}

double function_76(string a_symbol_0) {
   double ld_ret_8 = MarketInfo(a_symbol_0, MODE_BID);
   if (ld_ret_8 <= 0.0) ld_ret_8 = GlobalVariableGet("z" + a_symbol_0);
   else
      if (!IsTesting() && !IsOptimization()) GlobalVariableSet("z" + a_symbol_0, ld_ret_8);
   if (ld_ret_8 <= 0.0) ld_ret_8 = 1.0;
   return (ld_ret_8);
}

int isCheckCrossOver() {
   string l_symbol_20;
   string ls_28;
   string ls_36;
   double l_bid_44;
   bool li_ret_0 = FALSE;
   string ls_4 = StringSubstr(gs_1836, 0, 3);
   string ls_12 = StringSubstr(gs_1836, 3, 0);
   int l_count_52 = 0;
   if (CheckCrossOver) {
      if (ls_12 != "USD" && ls_4 != "USD") {
         while (l_count_52 < 4) {
            ls_28 = "USD" + ls_4;
            ls_36 = ls_4 + "USD";
            l_symbol_20 = gs_1964 + ls_28 + gs_1972;
            l_bid_44 = MarketInfo(l_symbol_20, MODE_BID);
            if (l_bid_44 > 0.0) {
               gs_2048 = ls_28;
               gi_2064 = -1;
            } else {
               l_symbol_20 = gs_1964 + ls_36 + gs_1972;
               l_bid_44 = MarketInfo(l_symbol_20, MODE_BID);
               if (l_bid_44 > 0.0) {
                  gs_2048 = ls_36;
                  gi_2064 = 1;
               }
            }
            if (gs_2048 != "") {
               ls_28 = "USD" + ls_12;
               ls_36 = ls_12 + "USD";
               l_symbol_20 = gs_1964 + ls_28 + gs_1972;
               l_bid_44 = MarketInfo(l_symbol_20, MODE_BID);
               if (l_bid_44 > 0.0) {
                  gs_2056 = ls_28;
                  gi_2068 = -1;
               } else {
                  l_symbol_20 = gs_1964 + ls_36 + gs_1972;
                  l_bid_44 = MarketInfo(l_symbol_20, MODE_BID);
                  if (l_bid_44 > 0.0) {
                     gs_2056 = ls_36;
                     gi_2068 = 1;
                  }
               }
               if (gs_2056 != "") li_ret_0 = TRUE;
            }
            if (!(!li_ret_0)) break;
            l_count_52++;
            Sleep(1000);
         }
         g_symbol_2032 = gs_1964 + gs_2048 + gs_1972;
         g_symbol_2040 = gs_1964 + gs_2056 + gs_1972;
      } else {
         if (CheckCrossOver) Comments(8, "isCheckCrossOver()", "Режим CheckCrossOver возможен только на кросс-курсах", "CheckCrossOver mode works only on cross-pairs");
         if (CrossOverMode) Comments(8, "isCheckCrossOver()", "Режим CrossOverMode возможен только на кросс-курсах", "CrossOverMode mode works only on cross-pairs");
      }
      if (!li_ret_0) {
         if (CheckCrossOver) Comments(8, "isCheckCrossOver()", "Режим CheckCrossOver выключен: Невозможно инициализировать долларовые пары", "CheckCrossOver is disable: Unable to init USD pairs");
         CheckCrossOver = FALSE;
         if (CrossOverMode) Comments(8, "isCheckCrossOver()", "Режим CrossOverMode выключен: Невозможно инициализировать долларовые пары", "CrossOverMode is disable: Unable to init USD pairs");
         CrossOverMode = FALSE;
      } else {
         Comments(8, "isCheckCrossOver()", "Инициализированы долларовые пары: " + g_symbol_2032 + " и " + g_symbol_2040, "Init USD pairs: " + g_symbol_2032 + " and " + g_symbol_2040);
         g_point_2084 = MarketInfo(g_symbol_2032, MODE_POINT);
         g_point_2092 = MarketInfo(g_symbol_2040, MODE_POINT);
         if (g_point_2084 == 0.00001 || g_point_2084 == 0.001) gi_2072 = 10;
         else gi_2072 = 1;
         if (g_point_2092 == 0.00001 || g_point_2092 == 0.001) gi_2076 = 10;
         else gi_2076 = 1;
         g_digits_2100 = MarketInfo(g_symbol_2032, MODE_DIGITS);
         g_digits_2108 = MarketInfo(g_symbol_2040, MODE_DIGITS);
      }
   }
   return (li_ret_0);
}

int function_78() {
   string ls_0 = "";
   double l_spread_8 = MarketInfo(Symbol(), MODE_SPREAD);
   string ls_16 = "";
   string ls_24 = "";
   string ls_32 = "";
   string ls_40 = "";
   g_count_2248++;
   if (g_spread_2196 > l_spread_8) g_spread_2196 = l_spread_8;
   if (g_spread_2204 < l_spread_8) g_spread_2204 = l_spread_8;
   gd_2212 += l_spread_8;
   if (gd_2220 > gd_1996) gd_2220 = gd_1996;
   if (gd_2228 < gd_1996) gd_2228 = gd_1996;
   gd_2236 += gd_1996;
   if (!IsOptimization() && !IsTesting() && gi_1076) {
      if (gda_2244[g_hour_1372][4] == 0.0) {
         gda_2244[g_hour_1372][0] = gd_1996;
         gda_2244[g_hour_1372][3] = gd_1996;
         gda_2244[g_hour_1372][1] = gd_1996;
         gda_2244[g_hour_1372][4] = 1.0;
         gda_2244[g_hour_1372 + 24][0] = l_spread_8;
         gda_2244[g_hour_1372 + 24][3] = l_spread_8;
         gda_2244[g_hour_1372 + 24][1] = l_spread_8;
         gda_2244[g_hour_1372 + 24][4] = 1.0;
      } else {
         gda_2244[g_hour_1372][4] += 1.0;
         if (gda_2244[g_hour_1372][0] > gd_1996) gda_2244[g_hour_1372][0] = gd_1996;
         if (gda_2244[g_hour_1372][3] < gd_1996) gda_2244[g_hour_1372][3] = gd_1996;
         gda_2244[g_hour_1372][1] += gd_1996;
         gda_2244[g_hour_1372 + 24][4] += 1.0;
         if (gda_2244[g_hour_1372 + 24][0] > l_spread_8) gda_2244[g_hour_1372 + 24][0] = l_spread_8;
         if (gda_2244[g_hour_1372 + 24][3] < l_spread_8) gda_2244[g_hour_1372 + 24][3] = l_spread_8;
         gda_2244[g_hour_1372 + 24][1] += l_spread_8;
      }
      gda_2244[g_hour_1372][2] = gda_2244[g_hour_1372][1] / gda_2244[g_hour_1372][4];
      gda_2244[g_hour_1372 + 24][2] = gda_2244[g_hour_1372 + 24][1] / gda_2244[g_hour_1372 + 24][4];
      ls_16 = "\n" 
      + StringConcatenate("00:", DoubleToStr(gda_2244[24][0], 0), "/", DoubleToStr(gda_2244[24][2], 1), "/", DoubleToStr(gda_2244[24][3], 0), "/", DoubleToStr(gda_2244[24][4], 0), "  ", "01:", DoubleToStr(gda_2244[25][0], 0), "/", DoubleToStr(gda_2244[25][2], 1), "/", DoubleToStr(gda_2244[25][3], 0), "/", DoubleToStr(gda_2244[25][4], 0), "  ", "02:", DoubleToStr(gda_2244[26][0], 0), "/", DoubleToStr(gda_2244[26][2], 1), "/", DoubleToStr(gda_2244[26][3], 0), "/", DoubleToStr(gda_2244[26][4], 0), "  ", "03:", DoubleToStr(gda_2244[27][0], 0), "/", DoubleToStr(gda_2244[27][2], 1), "/", DoubleToStr(gda_2244[27][3], 0), "/", DoubleToStr(gda_2244[27][4], 0), "  ", "04:", DoubleToStr(gda_2244[28][0], 0), "/", DoubleToStr(gda_2244[28][2], 1), "/", DoubleToStr(gda_2244[28][3], 0), "/", DoubleToStr(gda_2244[28][4], 0), "  ", "05:", DoubleToStr(gda_2244[29][0], 0), "/", DoubleToStr(gda_2244[29][2], 1), "/", DoubleToStr(gda_2244[29][3], 0), "/", DoubleToStr(gda_2244[29][4], 0), "  ");
      ls_16 = ls_16 + StringConcatenate("06:", DoubleToStr(gda_2244[30][0], 0), "/", DoubleToStr(gda_2244[30][2], 1), "/", DoubleToStr(gda_2244[30][3], 0), "/", DoubleToStr(gda_2244[30][4], 0), "  ", "07:", DoubleToStr(gda_2244[31][0], 0), "/", DoubleToStr(gda_2244[31][2], 1), "/", DoubleToStr(gda_2244[31][3], 0), "/", DoubleToStr(gda_2244[31][4], 0), "  ", "08:", DoubleToStr(gda_2244[32][0], 0), "/", DoubleToStr(gda_2244[32][2], 1), "/", DoubleToStr(gda_2244[32][3], 0), "/", DoubleToStr(gda_2244[32][4], 0), "  ", "09:", DoubleToStr(gda_2244[33][0], 0), "/", DoubleToStr(gda_2244[33][2], 1), "/", DoubleToStr(gda_2244[33][3], 0), "/", DoubleToStr(gda_2244[33][4], 0), "  ", "10:", DoubleToStr(gda_2244[34][0], 0), "/", DoubleToStr(gda_2244[34][2], 1), "/", DoubleToStr(gda_2244[34][3], 0), "/", DoubleToStr(gda_2244[34][4], 0), "  ", "11:", DoubleToStr(gda_2244[35][0], 0), "/", DoubleToStr(gda_2244[35][2], 1), "/", DoubleToStr(gda_2244[35][3], 0), "/", DoubleToStr(gda_2244[35][4], 0));
      ls_16 = ls_16 + StringConcatenate("\n", "12:", DoubleToStr(gda_2244[36][0], 0), "/", DoubleToStr(gda_2244[36][2], 1), "/", DoubleToStr(gda_2244[36][3], 0), "/", DoubleToStr(gda_2244[36][4], 0), "  ", "13:", DoubleToStr(gda_2244[37][0], 0), "/", DoubleToStr(gda_2244[37][2], 1), "/", DoubleToStr(gda_2244[37][3], 0), "/", DoubleToStr(gda_2244[37][4], 0), "  ", "14:", DoubleToStr(gda_2244[38][0], 0), "/", DoubleToStr(gda_2244[38][2], 1), "/", DoubleToStr(gda_2244[38][3], 0), "/", DoubleToStr(gda_2244[38][4], 0), "  ", "15:", DoubleToStr(gda_2244[39][0], 0), "/", DoubleToStr(gda_2244[39][2], 1), "/", DoubleToStr(gda_2244[39][3], 0), "/", DoubleToStr(gda_2244[39][4], 0), "  ", "16:", DoubleToStr(gda_2244[40][0], 0), "/", DoubleToStr(gda_2244[40][2], 1), "/", DoubleToStr(gda_2244[40][3], 0), "/", DoubleToStr(gda_2244[40][4], 0), "  ", "17:", DoubleToStr(gda_2244[41][0], 0), "/", DoubleToStr(gda_2244[41][2], 1), "/", DoubleToStr(gda_2244[41][3], 0), "/", DoubleToStr(gda_2244[41][4], 0), "  ", "18:", DoubleToStr(gda_2244[42][0], 0), "/", DoubleToStr(gda_2244[42][2], 1), "/", DoubleToStr(gda_2244[42][3], 0), "/", DoubleToStr(gda_2244[42][4], 0), "  ");
      ls_16 = ls_16 + StringConcatenate("19:", DoubleToStr(gda_2244[43][0], 0), "/", DoubleToStr(gda_2244[43][2], 1), "/", DoubleToStr(gda_2244[43][3], 0), "/", DoubleToStr(gda_2244[43][4], 0), "  ", "20:", DoubleToStr(gda_2244[44][0], 0), "/", DoubleToStr(gda_2244[44][2], 1), "/", DoubleToStr(gda_2244[44][3], 0), "/", DoubleToStr(gda_2244[44][4], 0), "  ", "21:", DoubleToStr(gda_2244[45][0], 0), "/", DoubleToStr(gda_2244[45][2], 1), "/", DoubleToStr(gda_2244[45][3], 0), "/", DoubleToStr(gda_2244[45][4], 0), "  ", "22:", DoubleToStr(gda_2244[46][0], 0), "/", DoubleToStr(gda_2244[46][2], 1), "/", DoubleToStr(gda_2244[46][3], 0), "/", DoubleToStr(gda_2244[46][4], 0), "  ", "23:", DoubleToStr(gda_2244[47][0], 0), "/", DoubleToStr(gda_2244[47][2], 1), "/", DoubleToStr(gda_2244[47][3], 0), "/", DoubleToStr(gda_2244[47][4], 0));
      ls_24 = "\n" 
      + StringConcatenate("00:", DoubleToStr(gda_2244[0][0], 0), "/", DoubleToStr(gda_2244[0][2], 1), "/", DoubleToStr(gda_2244[0][3], 0), "/", DoubleToStr(gda_2244[0][4], 0), "  ", "01:", DoubleToStr(gda_2244[1][0], 0), "/", DoubleToStr(gda_2244[1][2], 1), "/", DoubleToStr(gda_2244[1][3], 0), "/", DoubleToStr(gda_2244[1][4], 0), "  ", "02:", DoubleToStr(gda_2244[2][0], 0), "/", DoubleToStr(gda_2244[2][2], 1), "/", DoubleToStr(gda_2244[2][3], 0), "/", DoubleToStr(gda_2244[2][4], 0), "  ", "03:", DoubleToStr(gda_2244[3][0], 0), "/", DoubleToStr(gda_2244[3][2], 1), "/", DoubleToStr(gda_2244[3][3], 0), "/", DoubleToStr(gda_2244[3][4], 0), "  ", "04:", DoubleToStr(gda_2244[4][0], 0), "/", DoubleToStr(gda_2244[4][2], 1), "/", DoubleToStr(gda_2244[4][3], 0), "/", DoubleToStr(gda_2244[4][4], 0), "  ", "05:", DoubleToStr(gda_2244[5][0], 0), "/", DoubleToStr(gda_2244[5][2], 1), "/", DoubleToStr(gda_2244[5][3], 0), "/", DoubleToStr(gda_2244[5][4], 0), "  ");
      ls_24 = ls_24 + StringConcatenate("06:", DoubleToStr(gda_2244[6][0], 0), "/", DoubleToStr(gda_2244[6][2], 1), "/", DoubleToStr(gda_2244[6][3], 0), "/", DoubleToStr(gda_2244[6][4], 0), "  ", "07:", DoubleToStr(gda_2244[7][0], 0), "/", DoubleToStr(gda_2244[7][2], 1), "/", DoubleToStr(gda_2244[7][3], 0), "/", DoubleToStr(gda_2244[7][4], 0), "  ", "08:", DoubleToStr(gda_2244[8][0], 0), "/", DoubleToStr(gda_2244[8][2], 1), "/", DoubleToStr(gda_2244[8][3], 0), "/", DoubleToStr(gda_2244[8][4], 0), "  ", "09:", DoubleToStr(gda_2244[9][0], 0), "/", DoubleToStr(gda_2244[9][2], 1), "/", DoubleToStr(gda_2244[9][3], 0), "/", DoubleToStr(gda_2244[9][4], 0), "  ", "10:", DoubleToStr(gda_2244[10][0], 0), "/", DoubleToStr(gda_2244[10][2], 1), "/", DoubleToStr(gda_2244[10][3], 0), "/", DoubleToStr(gda_2244[10][4], 0), "  ", "11:", DoubleToStr(gda_2244[11][0], 0), "/", DoubleToStr(gda_2244[11][2], 1), "/", DoubleToStr(gda_2244[11][3], 0), "/", DoubleToStr(gda_2244[11][4], 0));
      ls_24 = ls_24 + StringConcatenate("\n", "12:", DoubleToStr(gda_2244[12][0], 0), "/", DoubleToStr(gda_2244[12][2], 1), "/", DoubleToStr(gda_2244[12][3], 0), "/", DoubleToStr(gda_2244[12][4], 0), "  ", "13:", DoubleToStr(gda_2244[13][0], 0), "/", DoubleToStr(gda_2244[13][2], 1), "/", DoubleToStr(gda_2244[13][3], 0), "/", DoubleToStr(gda_2244[13][4], 0), "  ", "14:", DoubleToStr(gda_2244[14][0], 0), "/", DoubleToStr(gda_2244[14][2], 1), "/", DoubleToStr(gda_2244[14][3], 0), "/", DoubleToStr(gda_2244[14][4], 0), "  ", "15:", DoubleToStr(gda_2244[15][0], 0), "/", DoubleToStr(gda_2244[15][2], 1), "/", DoubleToStr(gda_2244[15][3], 0), "/", DoubleToStr(gda_2244[15][4], 0), "  ", "16:", DoubleToStr(gda_2244[16][0], 0), "/", DoubleToStr(gda_2244[16][2], 1), "/", DoubleToStr(gda_2244[16][3], 0), "/", DoubleToStr(gda_2244[16][4], 0), "  ", "17:", DoubleToStr(gda_2244[17][0], 0), "/", DoubleToStr(gda_2244[17][2], 1), "/", DoubleToStr(gda_2244[17][3], 0), "/", DoubleToStr(gda_2244[17][4], 0), "  ", "18:", DoubleToStr(gda_2244[18][0], 0), "/", DoubleToStr(gda_2244[18][2], 1), "/", DoubleToStr(gda_2244[18][3], 0), "/", DoubleToStr(gda_2244[18][4], 0), "  ");
      ls_24 = ls_24 + StringConcatenate("19:", DoubleToStr(gda_2244[19][0], 0), "/", DoubleToStr(gda_2244[19][2], 1), "/", DoubleToStr(gda_2244[19][3], 0), "/", DoubleToStr(gda_2244[19][4], 0), "  ", "20:", DoubleToStr(gda_2244[20][0], 0), "/", DoubleToStr(gda_2244[20][2], 1), "/", DoubleToStr(gda_2244[20][3], 0), "/", DoubleToStr(gda_2244[20][4], 0), "  ", "21:", DoubleToStr(gda_2244[21][0], 0), "/", DoubleToStr(gda_2244[21][2], 1), "/", DoubleToStr(gda_2244[21][3], 0), "/", DoubleToStr(gda_2244[21][4], 0), "  ", "22:", DoubleToStr(gda_2244[22][0], 0), "/", DoubleToStr(gda_2244[22][2], 1), "/", DoubleToStr(gda_2244[22][3], 0), "/", DoubleToStr(gda_2244[22][4], 0), "  ", "23:", DoubleToStr(gda_2244[23][0], 0), "/", DoubleToStr(gda_2244[23][2], 1), "/", DoubleToStr(gda_2244[23][3], 0), "/", DoubleToStr(gda_2244[23][4], 0));
   }
   ls_32 = gs_1836 + " spread " + DoubleToStr(MarketInfo(Symbol(), MODE_SPREAD), 1) + "  (min=" + DoubleToStr(g_spread_2196, 1) + "   avrg=" + DoubleToStr(gd_2212 / g_count_2248, 1) + "   max=" + DoubleToStr(g_spread_2204, 1) + ")" + ls_16;
   if (CheckCrossOver) {
      if (gd_1996 - MarketInfo(Symbol(), MODE_SPREAD) > 0.0) ls_0 = "   +";
      if (gd_1996 - MarketInfo(Symbol(), MODE_SPREAD) == 0.0) ls_0 = "     ";
      if (gd_1996 - MarketInfo(Symbol(), MODE_SPREAD) < 0.0) ls_0 = "   ";
      ls_40 = "\n" 
      + StringSubstr(gs_1836, 0, 3) + "-USD-" + StringSubstr(gs_1836, 3, 3) + " spread " + DoubleToStr(gd_1996, 1) + ls_0 + DoubleToStr(gd_1996 - MarketInfo(Symbol(), MODE_SPREAD), 1) + "  (min=" + DoubleToStr(gd_2220, 1) + "   avrg=" + DoubleToStr(gd_2236 / g_count_2248, 1) + "   max=" + DoubleToStr(gd_2228, 1) + ")" + ls_24;
   }
   Comments(0, "", ls_32 + ls_40, ls_32 + ls_40);
   return (1);
}

int isOrder(int ai_0, int ai_4) {
   double SL;
   double TP;
   if (!CrossOverMode) {
      if (ai_4 == 0) {
         SL = 1.0 * StopLoss;
         TP = TrailingTP(ai_0, 0);
         if (InvisibleStopLoss) SL = 0.0;
         if ((SL != 0.0 && OrderStopLoss() == 0.0) || TP != 0.0 && !TradeTransferOut) {
            if (SL != 0.0) {
               if (SL < StopLevel_Value) SL = StopLevel_Value;
               SL = NormalizeDouble(OrderOpenPrice() - SL * Point_Value, g_digits_2028);
            }
            if (TP != 0.0) TP = NormalizeDouble(OrderOpenPrice() + TP * Point_Value, g_digits_2028);
            if (IsTradeAllowed()) {
               if (!OrderModify(OrderTicket(), OrderOpenPrice(), SL, TP, 0, Red)) Comments(8, "isBuyOrder()", "Невозможно установить SL или TP: " + PrintError(GetLastError()), "Unable to set SL or TP: " + PrintError(GetLastError()));
            } else
               if (!ErrorComment) Comments(8, "isBuyOrder()", "Невозможно установить SL или TP: торговый поток занят", "Unable to set SL or TP: Trade context busy");
         }
      }
      if (ai_4 == 1) {
         SL = 1.0 * StopLoss;
         TP = TrailingTP(ai_0, 1);
         if (InvisibleStopLoss) SL = 0.0;
         if ((SL != 0.0 && OrderStopLoss() == 0.0) || TP != 0.0 && !TradeTransferOut) {
            if (SL != 0.0) {
               if (SL < StopLevel_Value) SL = StopLevel_Value;
               SL = NormalizeDouble(OrderOpenPrice() + SL * Point_Value, g_digits_2028);
            }
            if (TP != 0.0) TP = NormalizeDouble(OrderOpenPrice() - TP * Point_Value, g_digits_2028);
            if (IsTradeAllowed()) {
               if (!OrderModify(OrderTicket(), OrderOpenPrice(), SL, TP, 0, Red)) Comments(8, "isBuyOrder()", "Невозможно установить SL или TP: " + PrintError(GetLastError()), "Unable to set SL or TP: " + PrintError(GetLastError()));
            } else
               if (!ErrorComment) Comments(8, "isSellOrder()", "Невозможно установить SL или TP: торговый поток занят", "Unable to set SL or TP: Trade context busy");
         }
      }
   }
   return (1);
}

int isTimeCorrection(int ai_0) {
   return (ai_0 + 7200 - 3600 * (TimeZone + CorrectionTime));
}

int function_81() {
   string ls_24;
   int l_file_32;
   string l_name_36;
   datetime lt_unused_44;
   bool li_48;
   bool li_52;
   bool li_ret_0 = FALSE;
   string ls_16 = gs_2336;
   gi_1296 = MathAbs(StrToInteger(StringSubstr(ls_16, StringFind(ls_16, CharToStr(46), 0) - 1, 1)) - StrToInteger(Массив_источник[20][1]));
   if (!CheckCrossOver && gi_2320) return (li_ret_0);
   double ld_4 = NormalizeDouble(gd_2012, Digits);
   if (!gi_2320) {
      gi_2320 = TRUE;
      l_name_36 = "cr" + gs_1836 + Period() + " Time: ";
      for (int l_index_12 = 0; l_index_12 < Bars; l_index_12++) ObjectDelete(l_name_36 + TimeToStr(Time[l_index_12]));
      l_name_36 = "crBid";
      ObjectDelete(l_name_36);
      l_name_36 = "crAsk";
      ObjectDelete(l_name_36);
      if (!CheckCrossOver) return (li_ret_0);
      gi_2308 = WindowBarsPerChart() * 2;
      if (gi_2308 < 50) gi_2308 = 50;
      ArrayResize(gda_2276, gi_2308);
      ArrayResize(gda_2280, gi_2308);
      ArrayResize(gda_2284, gi_2308);
      ArrayResize(gda_2288, gi_2308);
      ArrayResize(gda_2292, gi_2308);
      ArrayResize(gia_2300, gi_2308);
      ArrayResize(gia_2296, gi_2308);
      ArrayInitialize(gda_2276, 0.0);
      ArrayInitialize(gda_2280, 0.0);
      ArrayInitialize(gda_2284, 0.0);
      ArrayInitialize(gda_2288, 0.0);
      ArrayInitialize(gda_2292, 0.0);
      lt_unused_44 = Time[0];
      for (l_index_12 = 0; l_index_12 < gi_2308; l_index_12++) {
         gia_2296[l_index_12] = 0;
         gia_2300[l_index_12] = Time[l_index_12];
      }
      gda_2284[0] = ld_4;
      li_48 = TRUE;
      l_file_32 = FileOpen(ls_16, FILE_CSV|FILE_WRITE|FILE_READ, ';');
      if (l_file_32 < 1) {
         Print("Невозможно открыть файл " + ls_16 + ", ошибка: ", GetLastError());
         li_48 = FALSE;
      }
      for (l_index_12 = gi_2308 - 1; l_index_12 > 0; l_index_12--) {
         li_52 = FALSE;
         if (li_48) {
            FileSeek(l_file_32, 0, SEEK_SET);
            while (!FileIsEnding(l_file_32)) {
               ls_24 = FileReadString(l_file_32);
               if (StrToTime(ls_24) == gia_2300[l_index_12] && !gi_1296) {
                  gda_2284[l_index_12] = StrToDouble(FileReadString(l_file_32));
                  gda_2288[l_index_12] = StrToDouble(FileReadString(l_file_32));
                  gda_2280[l_index_12] = StrToDouble(FileReadString(l_file_32));
                  gda_2276[l_index_12] = StrToDouble(FileReadString(l_file_32));
                  gda_2292[l_index_12] = StrToDouble(FileReadString(l_file_32));
                  gia_2296[l_index_12] = StrToInteger(FileReadString(l_file_32));
                  li_52 = TRUE;
                  break;
               }
               FileReadString(l_file_32);
               FileReadString(l_file_32);
               FileReadString(l_file_32);
               FileReadString(l_file_32);
               FileReadString(l_file_32);
               FileReadString(l_file_32);
            }
         }
         if (!li_52) {
            gda_2284[l_index_12] = Open[l_index_12];
            gda_2288[l_index_12] = Close[l_index_12];
            gda_2280[l_index_12] = Low[l_index_12];
            gda_2276[l_index_12] = High[l_index_12];
            gda_2292[l_index_12] = Volume[l_index_12];
            gia_2296[l_index_12] = 65280;
         }
         if (gia_2296[l_index_12] != 65280) function_82(l_index_12, gia_2296[l_index_12]);
      }
      if (li_48) FileClose(l_file_32);
      if (Time[0] == StrToTime(Year() + ".01.01 0:00") + 60.0 * GlobalVariableGet("z" + gs_1836 + "crTime0")) {
         gda_2288[0] = GlobalVariableGet("z" + gs_1836 + "crClose0");
         gda_2276[0] = GlobalVariableGet("z" + gs_1836 + "crHigh0");
         gda_2280[0] = GlobalVariableGet("z" + gs_1836 + "crLow0");
         gda_2292[0] = GlobalVariableGet("z" + gs_1836 + "crVolume0");
         gia_2296[0] = GlobalVariableGet("z" + gs_1836 + "crColor0");
      }
   } else {
      if (WindowBarsPerChart() > gi_2312) {
      }
      if (Time[0] != gia_2300[0]) {
         function_85(0);
         for (l_index_12 = gi_2308 - 1; l_index_12 > 0; l_index_12--) {
            gda_2276[l_index_12] = gda_2276[l_index_12 - 1];
            gda_2280[l_index_12] = gda_2280[l_index_12 - 1];
            gda_2284[l_index_12] = gda_2284[l_index_12 - 1];
            gda_2288[l_index_12] = gda_2288[l_index_12 - 1];
            gda_2292[l_index_12] = gda_2292[l_index_12 - 1];
            gia_2300[l_index_12] = gia_2300[l_index_12 - 1];
         }
         gia_2300[0] = Time[0];
         gda_2276[0] = ld_4;
         gda_2280[0] = ld_4;
         gda_2284[0] = ld_4;
         gda_2288[0] = ld_4;
         gda_2292[0] = 0.0;
      }
      gda_2288[0] = ld_4;
      if (gda_2276[0] < ld_4) gda_2276[0] = ld_4;
      if (gda_2280[0] > ld_4 || gda_2280[0] == 0.0) gda_2280[0] = ld_4;
      gda_2292[0] = MathAbs((gda_2288[0] - gda_2284[0]) / Point_Value);
      gia_2296[0] = 65535;
      function_84();
      function_82(0, gia_2296[0]);
      GlobalVariableSet("z" + gs_1836 + "crClose0", gda_2288[0]);
      GlobalVariableSet("z" + gs_1836 + "crHigh0", gda_2276[0]);
      GlobalVariableSet("z" + gs_1836 + "crLow0", gda_2280[0]);
      GlobalVariableSet("z" + gs_1836 + "crVolume0", gda_2292[0]);
      GlobalVariableSet("z" + gs_1836 + "crColor0", gia_2296[0]);
      GlobalVariableSet("z" + gs_1836 + "crTime0", MathFloor((Time[0] - StrToTime(Year() + ".01.01 0:00")) / 60));
   }
   return (li_ret_0);
}

int function_82(int ai_0, int a_color_4) {
   string l_name_8;
   if (CheckCrossOver) {
      l_name_8 = "cr" + gs_1836 + Period() + " Time: " + TimeToStr(gia_2300[ai_0]);
      ObjectDelete(l_name_8);
      ObjectCreate(l_name_8, OBJ_TREND, 0, gia_2300[ai_0], gda_2280[ai_0], gia_2300[ai_0], gda_2276[ai_0]);
      ObjectSet(l_name_8, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(l_name_8, OBJPROP_WIDTH, 1);
      ObjectSet(l_name_8, OBJPROP_RAY, FALSE);
      ObjectSet(l_name_8, OBJPROP_COLOR, a_color_4);
   }
   return (1);
}

int function_83(int ai_0, int ai_4) {
   string l_name_8;
   if (!IsOptimization() && !IsTesting()) {
      if (!gi_2332) {
         gi_2332 = TRUE;
         l_name_8 = "cross_buy";
         ObjectDelete(l_name_8);
         l_name_8 = "cross_sell";
         ObjectDelete(l_name_8);
         return (0);
      }
      if (gia_2264[ai_0][1] == 0) l_name_8 = "cross_buy";
      if (gia_2264[ai_0][1] == 1) l_name_8 = "cross_sell";
      l_name_8 = l_name_8 + " " + gsa_2272[ai_0][1];
      ObjectDelete(l_name_8);
      if (ai_4 && gda_2260[ai_0][1] > 0.0) {
         ObjectCreate(l_name_8, OBJ_HLINE, 0, 0, NormalizeDouble(gda_2260[ai_0][1], Digits));
         ObjectSet(l_name_8, OBJPROP_STYLE, STYLE_DASHDOT);
         ObjectSet(l_name_8, OBJPROP_WIDTH, 1);
         ObjectSet(l_name_8, OBJPROP_COLOR, Lime);
      }
   }
   return (1);
}

int function_84() {
   string l_name_0;
   if (CheckCrossOver) {
      l_name_0 = "crBid";
      ObjectDelete(l_name_0);
      ObjectCreate(l_name_0, OBJ_HLINE, 0, 0, NormalizeDouble(gd_2012, Digits));
      ObjectSet(l_name_0, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(l_name_0, OBJPROP_WIDTH, 1);
      ObjectSet(l_name_0, OBJPROP_COLOR, Yellow);
      l_name_0 = "crAsk";
      ObjectDelete(l_name_0);
      ObjectCreate(l_name_0, OBJ_HLINE, 0, 0, NormalizeDouble(gd_2004, Digits));
      ObjectSet(l_name_0, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(l_name_0, OBJPROP_WIDTH, 1);
      ObjectSet(l_name_0, OBJPROP_COLOR, DeepPink);
   }
   return (1);
}

int function_85(int ai_0) {
   string ls_20;
   bool li_ret_4 = FALSE;
   bool li_8 = FALSE;
   string l_name_12 = gs_2336;
   int l_file_28 = FileOpen(l_name_12, FILE_CSV|FILE_WRITE|FILE_READ, ';');
   if (l_file_28 < 1) Print("Невозможно открыть файл " + l_name_12 + ", ошибка: ", GetLastError());
   else {
      FileSeek(l_file_28, 0, SEEK_SET);
      while (!FileIsEnding(l_file_28)) {
         gi_2316 = FileTell(l_file_28);
         ls_20 = FileReadString(l_file_28);
         if (StrToTime(ls_20) == gia_2300[ai_0]) break;
         FileReadString(l_file_28);
         FileReadString(l_file_28);
         FileReadString(l_file_28);
         FileReadString(l_file_28);
         FileReadString(l_file_28);
         FileReadString(l_file_28);
      }
      if (!li_8) {
         gi_2316 = FileTell(l_file_28);
         FileSeek(l_file_28, 0, SEEK_END);
         FileWrite(l_file_28, TimeToStr(gia_2300[ai_0]), DoubleToStr(gda_2284[ai_0], Digits), DoubleToStr(gda_2288[ai_0], Digits), DoubleToStr(gda_2280[ai_0], Digits), DoubleToStr(gda_2276[ai_0], Digits), DoubleToStr(gda_2292[ai_0], 0), gia_2296[ai_0]);
      }
      FileClose(l_file_28);
   }
   return (li_ret_4);
}

int function_86(int ai_0, int ai_unused_4, int ai_8, int ai_12) {
   double lda_20[10];
   double ld_24;
   double ld_32;
   double ld_40;
   double ld_48;
   int l_count_56;
   int li_64;
   int li_68;
   int li_16 = 0;
   if (ai_0 < 1) ai_0 = 13;
   if (Bars <= ai_0 || g_bars_2364 == Bars) return (0);
   li_16 = g_bars_2364;
   g_bars_2364 = Bars;
   if (li_16 < 0) return (0);
   if (li_16 > 0) li_16--;
   ArrayResize(lda_20, Bars);
   ArrayCopy(lda_20, gda_2368, 1, 0, WHOLE_ARRAY);
   ArrayResize(gda_2368, Bars);
   ArrayCopy(gda_2368, lda_20, 0, 0, WHOLE_ARRAY);
   if (ai_8 == 0) {
      ld_24 = 0.0;
      li_64 = Bars - li_16 - 1;
      if (li_64 < ai_0) li_64 = ai_0;
      l_count_56 = 1;
      while (l_count_56 < ai_0) {
         ld_24 += function_87(li_64, ai_12);
         l_count_56++;
         li_64--;
      }
      while (li_64 >= 0) {
         ld_24 += function_87(li_64, ai_12);
         gda_2368[li_64] = ld_24 / ai_0;
         ld_24 -= function_87(li_64 + ai_0 - 1, ai_12);
         li_64--;
      }
      if (li_16 < 1) for (l_count_56 = 1; l_count_56 < ai_0; l_count_56++) gda_2368[Bars - l_count_56] = 0;
   }
   if (ai_8 == 1) {
      ld_32 = 2.0 / (ai_0 + 1);
      li_64 = Bars - 2;
      if (li_16 > 2) li_64 = Bars - li_16 - 1;
      while (li_64 >= 0) {
         if (li_64 == Bars - 2) gda_2368[li_64 + 1] = function_87(li_64 + 1, ai_12);
         gda_2368[li_64] = function_87(li_64, ai_12) * ld_32 + (gda_2368[li_64 + 1]) * (1 - ld_32);
         li_64--;
      }
   }
   if (ai_8 == 2) {
      ld_24 = 0.0;
      li_64 = Bars - li_16 + 1;
      li_64 = Bars - ai_0;
      if (li_64 > Bars - li_16) li_64 = Bars - li_16;
      while (li_64 >= 0) {
         if (li_64 == Bars - ai_0) {
            l_count_56 = 0;
            for (int li_60 = li_64; l_count_56 < ai_0; li_60++) {
               ld_24 += function_87(li_60, ai_12);
               gda_2368[li_60] = 0;
               l_count_56++;
            }
         } else ld_24 = (gda_2368[li_64 + 1]) * (ai_0 - 1) + function_87(li_64, ai_12);
         gda_2368[li_64] = ld_24 / ai_0;
         li_64--;
      }
   }
   if (ai_8 >= 3) {
      ld_24 = 0.0;
      ld_40 = 0.0;
      li_68 = 0;
      li_64 = Bars - li_16 - 1;
      if (li_64 < ai_0) li_64 = ai_0;
      l_count_56 = 1;
      while (l_count_56 <= ai_0) {
         ld_48 = function_87(li_64, ai_12);
         ld_24 += ld_48 * l_count_56;
         ld_40 += ld_48;
         li_68 += l_count_56;
         l_count_56++;
         li_64--;
      }
      li_64++;
      l_count_56 = li_64 + ai_0;
      while (li_64 >= 0) {
         gda_2368[li_64] = ld_24 / li_68;
         if (li_64 == 0) break;
         li_64--;
         l_count_56--;
         ld_48 = function_87(li_64, ai_12);
         ld_24 = ld_24 - ld_40 + ld_48 * ai_0;
         ld_40 -= function_87(l_count_56, ai_12);
         ld_40 += ld_48;
      }
      if (li_16 < 1) for (l_count_56 = 1; l_count_56 < ai_0; l_count_56++) gda_2368[Bars - l_count_56] = 0;
   }
   return (1);
}

double function_87(int ai_0, int ai_4) {
   double ld_ret_8 = 0.0;
   if (CrossOverMode) {
      if (ai_4 == 0) ld_ret_8 = gda_2288[ai_0];
      if (ai_4 == 1) ld_ret_8 = gda_2284[ai_0];
      if (ai_4 == 2) ld_ret_8 = gda_2276[ai_0];
      if (ai_4 == 3) ld_ret_8 = gda_2280[ai_0];
      if (ai_4 == 4) ld_ret_8 = (gda_2276[ai_0] + gda_2280[ai_0]) / 2.0;
      if (ai_4 == 5) ld_ret_8 = (gda_2276[ai_0] + gda_2280[ai_0] + gda_2288[ai_0]) / 3.0;
      if (ai_4 == 6) ld_ret_8 = (gda_2276[ai_0] + gda_2280[ai_0] + gda_2288[ai_0] + gda_2288[ai_0]) / 4.0;
   } else {
      if (ai_4 == 0) ld_ret_8 = Close[ai_0];
      if (ai_4 == 1) ld_ret_8 = Open[ai_0];
      if (ai_4 == 2) ld_ret_8 = High[ai_0];
      if (ai_4 == 3) ld_ret_8 = Low[ai_0];
      if (ai_4 == 4) ld_ret_8 = (High[ai_0] + Low[ai_0]) / 2.0;
      if (ai_4 == 5) ld_ret_8 = (High[ai_0] + Low[ai_0] + Close[ai_0]) / 3.0;
      if (ai_4 == 6) ld_ret_8 = (High[ai_0] + Low[ai_0] + Close[ai_0] + Close[ai_0]) / 4.0;
   }
   return (ld_ret_8);
}

bool function_89(bool ai_0) {
   bool li_ret_4 = FALSE;
   if (ai_0) {
      for (int l_index_8 = 0; l_index_8 < 7; l_index_8++)
         if (gia_2268[l_index_8][2] == Time[0]) li_ret_4 = TRUE;
   }
   return (li_ret_4);
}

int function_90() {
   switch (UninitializeReason()) {
   case 0:
      Comments(9, "function_90()", "Скрипт самостоятельно завершил свою работу", "Скрипт самостоятельно завершил свою работу");
      break;
   case REASON_CHARTCLOSE:
      Comments(9, "function_90()", "Символ или период графика был изменен", "Символ или период графика был изменен");
      break;
   case REASON_REMOVE:
      Comments(9, "function_90()", "Программа удалена с графика", "Программа удалена с графика");
      break;
   case REASON_RECOMPILE:
      Comments(9, "function_90()", "Программа перекомпилирована", "Программа перекомпилирована");
      break;
   case REASON_CHARTCHANGE:
      Comments(9, "function_90()", "Символ или период графика был изменен", "Символ или период графика был изменен");
      break;
   case REASON_PARAMETERS:
      Comments(9, "function_90()", "Входные параметры были изменены пользователем", "Входные параметры были изменены пользователем");
      break;
   case REASON_ACCOUNT:
      Comments(9, "function_90()", "Активирован другой счет", "Активирован другой счет");
   }
   return (1);
}

int isBufferCleared() {
   bool li_ret_0 = FALSE;
   for (int l_index_4 = 0; l_index_4 < 7; l_index_4++) {
      if (gia_2264[l_index_4][0] == 95) {
        ClearBuffer("OSbuffer", l_index_4);
         li_ret_0 = TRUE;
         Comments(9, "isBufferCleared()", "Очищен буфер " + l_index_4, "Buffer cleared " + l_index_4);
      }
   }
   return (li_ret_0);
}

int function_92() {
   int li_0;
   if (gi_1104) {
      li_0 = GetTickCount() - gi_1368;
      if (gi_1396 > li_0) gi_1396 = li_0;
      if (gi_1400 < li_0) gi_1400 = li_0;
      g_count_1404++;
      gd_1456 += 1.0 * li_0;
      if (gi_1044 == 0) Comment("SysSpeed:  min=" + gi_1396 + "  average=" + DoubleToStr(gd_1456 / (1.0 * g_count_1404), 0) + "  max=" + gi_1400 + "   current=" + li_0);
   }
   return (1);
}

bool function_93(int ai_0) {
   bool li_ret_4 = FALSE;
   if (ai_0 == 0) g_datetime_2304 = TimeCurrent();
   else {
      if (ai_0 > 0) {
         if (TimeCurrent() - g_datetime_2304 >= ai_0 / 1000 && !gi_1296) {
            Comments(9, "function_93()", "function_93(" + ai_0 + ")", "function_93(" + ai_0 + ")");
            li_ret_4 = TRUE;
         }
      }
   }
   return (li_ret_4);
}