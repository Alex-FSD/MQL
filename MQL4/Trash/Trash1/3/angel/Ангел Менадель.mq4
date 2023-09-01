//+------------------------------------------------------------------+
//|                                               ����� ��������.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//�������� � ����� ����������� � ������������. 
//���� ��� ���������������� ����� ������ ������ ����� ������� � �������,
// � ��������� ��� ���������������� �������, ��� �������� � �������������.
// ����� ����� ������� ���� ������� ��� ��� ��������� � ����� ����� � ��������������� ������������.
// ��� ����� ������������ ���� � �����, ���� ���� ������ ��� ��� �������;
// ��������� ���������� ���� ������ �� ��������� � ���������.
// �������� � � ��� ��� ������ ������������ ����� �����.
// ��������� ��������� � ���������� ��������, � ��������� ������������ ��������,
// ��� ������� ������ ���� �����������, � ����� � ���� ������� ��������� ������ ����� � �������� ����� ����.
// ������ ���� ������, ��� ������������� �������� �������� ������������ ����� �� �������. 
//��� �����, ������� ��������� ������� ��� ������� �����������, ������������� � ������� ������ �����.
// ��� �� ����� ������������ ����� �� ����� ���� ����������� ��� �������� ������;
// ��� ���������� �� ��� ����, ����� ���������, � ��� ����, ����� ���������� ���������������� � ����� � ����������� � ����.
// ������������ �� ����� ���������� �������� � ���� � ������ � ������������ � ���������� �������������� ����������,
// ������������� ����� ����� ������� �����������. �� ����� �������, ����� �� ��������� �� ��������� ������ ������������,
// ����� ���������� �� ������� � ��������, �������� ���� ��� �������� �������� ���������.
// ��� ��� ��������: ��� �������� ������������ � ������ ������� ��������� ������ ��� ���� � ����� ��������� ����������,
// ��� ������� ������������ ��������� ������������. �������� ��������� ����� ��, ��� �� �������� (����� � ������ �����),
// ��������: ������, ��������� �������������� ��� ����. 
//������ ���� ��������, ��� ��� �����-��������� �� ��������� � ���� ����, ������������ � ���������!
// �������� ����� �������� ����� � ��������, �������� �� ����� �������� �� ����, �� ����� ���� ������ ������,
// ������������� ��� ����������� ���������� ����� ������� ���

#property copyright "Copyright �  Mobidic"
#property link      "Copyright �  ����� ��������"

//+--------------------------------------------------------------------------------------------------------------+
//|    
//| 
//|   EURUSD, GBPUSD, USDCHF, USDJPY, USDCAD.  M15.  
//|  
//|  
//+--------------------------------------------------------------------------------------------------------------+

//+--------------------------------------------------------------------------------------------------------------+
//| �������� ������� ���������. ����-������, ����-����, ����� � ��������� � ������ ����.
//+--------------------------------------------------------------------------------------------------------------+

extern string Name = " ����� �������� ";
extern string Copy = "Copyright � Mobidic&virginiagreco@libero.it";
extern string Op2 = "����������� ��� ����";
extern string Symbol_Op = "GBPUSD m15";
extern string Op = "���� �����������";
extern datetime Date = D'12.12.2900'; //--- ������ ����� ��� ����, ����� ������ �� ����� ���� ����������� (���� ���������� �������)
extern string _TP = "�������� ������� ���������";
//---
extern int TakeProfit = 1000; //--- (10 2 60)
extern int StopLoss = 40; //--- (100 10 200)
extern bool UseStopLevels = TRUE; //--- ��������� �������� �������. ���� ���������, �� �������� ������ ����������� ����� � �����.
//---
extern int SecureProfit = 5; //--- (0 1 5) ����� � ���������
extern int SecureProfitTriger = 30; //--- (10 2 30)
extern int MaxLossPoints = -200; //--- (-200 5 -20) ������������ �������� ��� �������� ������� Buy � Sell ��� ��������� ������� (��� �������� ������ �� - MaxLossPoints ��� ������ (�������� ������� 0), ����� ���������)
//+--------------------------------------------------------------------------------------------------------------+
extern string  s2                   =  "======================================================="; 
extern string  parameters_trailing  = "0-off  1-Candle  2-Fractals  3-Velocity  4-Parabolic  >4-pips";
extern int     TrailingStopLoss     = 5;      // ����� ��������� ������, ���� 0 off 
extern int     TrailingStopProfit   = 1;      // ����� ���������� ������, ���� 0 off 
extern int     StepTrall            = 100;      // ��� ������ - ���������� �������� �� ����� ��� StepTrall (step Thrall, moving not less than StepTrall n )
extern int     delta                = 0;      // ������ �� �������� ����� � ��. (offset from the fractal or candles or Parabolic )
extern bool    only_Profit          = true;   // ������ ������� � ��������� ��� ������ (sweep only profitable orders )
extern bool    only_SL              = false;  // ����� ������ ��� ������� � ������� ���������� �������� (sweep only those orders that already have SL )
extern bool    SymbolAll            = false;  // ����� ���� �������� �� ������ �������� ���� (trail all the tools )
extern bool    GeneralNoLoss        = false;   // ���� �� ������������ ������� ������� (on general profitsextern )
//+--------------------------------------------------------------------------------------------------------------+
string         parameters_Parabolic = "";
extern double  Step                 = 0.02;
extern double  Maximum              = 0.2;
extern int     Magic                = 0;
extern bool    visualization        = true;
extern int     VelocityPeriodBar    = 30;
extern double  K_Velocity           = 1.0;    //magnification stoploss of Velocity 
extern string  s3                   =  "=======================================================";
//+--------------------------------------------------------------------------------------------------------------+
extern string _MM = "��������� MM";
//---
extern bool RecoveryMode = FALSE; //--- ��������� ������ �������������� �������� (���������� ���� ���� �������� ����-����)
extern double FixedLot = 0.1; //--- ������������� ����� ����
extern double AutoMM = 3.0; //--- �� ���������� ���� AutoMM > 0. ������� �����. ��� RecoveryMode = FALSE, ������ ����� ������ ��� ��������.
//--- ��� AutoMM = 20 � �������� � 1000$, ��� ����� ����� 0,2. ����� ��� ����� ������������� ������ �� ��������� �������, �� ���� ��� ��� �������� � 2000$ ��� ����� ����� 0,4.
extern double AutoMM_Max = 5.0; //--- ������������ ����
extern int MaxAnalizCount = 50; //--- ����� �������� ����� ������� ��� �������(������������ ��� RecoveryMode = True)
extern double Risk = 3.0; //--- ���� �� �������� (������������ ��� RecoveryMode = True)
extern double MultiLotPercent = 6.1; //--- ����������� ��������� ���� (������������ ��� RecoveryMode = True)

//+--------------------------------------------------------------------------------------------------------------+
//| ������� �����������. ���-�� ����� ��� ������� ����������.
//+--------------------------------------------------------------------------------------------------------------+

extern string _Periods = "������� �����������";

//--- ������� ����������� (���� ����� ����� ��������, ��� ��� ��� ������ ���� ����)
extern int iMA_Period = 71; //--- (60 5 100)
extern int iCCI_Period = 35; //--- (10 2 30)
extern int iATR_Period = 37; //--- (10 2 30) (!) ����� �� ������
extern int iWPR_Period = 12; //--- (10 1 20)

//+--------------------------------------------------------------------------------------------------------------+
//| ��������� �� DLL
//+--------------------------------------------------------------------------------------------------------------+
//| EURUSD     | GBPUSD     | USDCHF     | USDJPY     | USDCAD     |
//+----------------------------------------------------------------
//| TP=26;     | TP=50;     | TP=17;     | TP=27;     | TP=14;     |
//| SL=120;    | SL=120;    | SL=120;    | SL=130;    | SL=150;    |
//| SP=1;      | SP=2;      | SP=0;      | SP=2;      | SP=2;      |
//| SPT=10;    | SPT=24;    | SPT=15;    | SPT=14;    | SPT=10;    |
//| MLP=-65;   | MLP=-200;  | MLP=-40;   | MLP=-80;   | MLP=-30;   |
//+----------------------------------------------------------------
//| MA=75;     | MA=75;     | MA=70;     | MA=85;     | MA=65;     |
//| CCI=18;    | CCI=12;    | CCI=14;    | CCI=12;    | CCI=12;    |
//| ATR=14;    | ATR=14;    | ATR=14;    | ATR=14;    | ATR=14;    |
//| WPR=11;    | WPR=12;    | WPR=12;    | WPR=12;    | WPR=16;    |
//+----------------------------------------------------------------
//| FATR=6;    | FATR=6;    | FATR=3;    | FATR=0;    | FATR=4;    |
//| FCCI=150;  | FCCI=290;  | FCCI=170;  | FCCI=2000; | FCCI=130;  |
//+----------------------------------------------------------------
//| MAFOA=15;  | MAFOA=12;  | MAFOA=8;   | MAFOA=5;   | MAFOA=5;   |
//| MAFOB=39;  | MAFOB=33;  | MAFOB=25;  | MAFOB=21;  | MAFOB=15;  |
//| WPRFOA=-99;| WPRFOA=-99;| WPRFOA=-95;| WPRFOA=-99;| WPRFOA=-99;|
//| WPRFOB=-95;| WPRFOB=-94;| WPRFOB=-92;| WPRFOB=-95;| WPRFOB=-89;|
//+----------------------------------------------------------------
//| MAFC=14;   | MAFC=18;   | MAFC=11;   | MAFC=14;   | MAFC=14;   |
//| WPRFC=-19; | WPRFC=-19; | WPRFC=-22; | WPRFC=-27; | WPRFC=-6;  |
//+--------------------------------------------------------------------------------------------------------------+

//+--------------------------------------------------------------------------------------------------------------+
//| ��������� ����������� ��� ������ �������� � �������� �������.
//+--------------------------------------------------------------------------------------------------------------+
extern string _Add_Op = "����������� ��������� �����������";
//---
extern string _AddOpenFilters = "---";
//---
extern int FilterATR = 6; //--- (0 1 10) �������� �� ���� �� ATR ��� Buy � Sell (if (iATR_Signal <= FilterATR * pp) return (0);) (!) ����� �� ������
extern double iCCI_OpenFilter = 360; //--- (100 10 400) ������ �� iCCI ��� Buy � Sell. ��� ����������� ��� JPY ������������ ������ �� ������� (100 50 4000)
//---
extern string _OpenOrderFilters = "---";
//---
extern int iMA_Filter_Open_a = 53; //--- (4 2 20) ������ �� ��� �������� Buy � Sell (�����)
extern int iMA_Filter_Open_b = 5; //--- (14 2 50) ������ �� ��� �������� Buy � Sell (�����)
extern int iWPR_Filter_Open_a = -99; //--- (-100 1 0) ������ WPR ��� �������� Buy � Sell
extern int iWPR_Filter_Open_b = -94; //--- (-100 1 0) ������ WPR ��� �������� Buy � Sell
//---
extern string _CloseOrderFilters = "---";
//---
extern int Price_Filter_Close = 85; //--- (10 2 20) ������ ���� �������� ��� �������� Buy � Sell (�����)
extern int iWPR_Filter_Close = -5; //--- (0 1 -100) ������ WPR ��� �������� Buy � Sell

//+--------------------------------------------------------------------------------------------------------------+
//| ����������� ���������
//+--------------------------------------------------------------------------------------------------------------+

extern string _Add = "����������� ���������";
extern bool LongTrade = TRUE; //--- ����������� ������� �������
extern bool ShortTrade = TRUE; //--- ����������� �������� �������
extern int MagicNumber = 33315;
extern double MaxSpread = 15;
extern double Slippage = 2;
extern bool WriteLog = TRUE; //--- //--- ��������� ����������� ���� � ���������.
extern bool WriteDebugLog = TRUE; //--- ��������� ����������� ���� �� ������� � ���������.
extern bool PrintLogOnChart = TRUE; //--- ��������� ������������ �� ������� (��� ������������ ����������� �������������)
extern bool HideTestInd = true;

//+--------------------------------------------------------------------------------------------------------------+
//| ���� �������������� ����������
//+--------------------------------------------------------------------------------------------------------------+

double pp;
int pd;
double cf;
string EASymbol; //--- ������� ������
double CloseSlippage = 3; //--- ��������������� ��� �������� ������
int SP;
int CloseSP;
int MaximumTrades = 1;
double NDMaxSpread; //--- ������������ ����� ����� �������
bool CheckSpreadRule; //--- ������� ��� �������� ������ ����� ��������� (������������� ������������ ��������� � ����������� ������)
string OpenOrderComment = "����� ��������";
int RandomOpenTimePercent = 0; //--- ������������ ��� ������� ������ ������� ���������, ����������� ��������� �����. ���������� � ��������.
//---

//--- ��������� ��� ��������
double MinLot = 0.01;
double MaxLot = 0.01;
double LotStep = 0.01;
int LotValue = 100000;
double FreeMargin = 1000.0;
double LotPrice = 1;
double LotSize;

//--- ��������� �� ��������

int iWPR_Filter_OpenLong_a;
int iWPR_Filter_OpenLong_b;
int iWPR_Filter_OpenShort_a;
int iWPR_Filter_OpenShort_b;

//--- ��������� �� ��������

int iWPR_Filter_CloseLong;
int iWPR_Filter_CloseShort;

//---
color OpenBuyColor = Blue;
color OpenSellColor = Red;
color CloseBuyColor = DodgerBlue;
color CloseSellColor = DeepPink;
//---
bool SoundAlert = FALSE; //--- �������� ���������� �� ��������/�������� ������
string SoundFileAtOpen = "alert.wav";
string SoundFileAtClose = "alert.wav";
int Dist = 1; //--- �������������� ������ �������� ���� ����� �������� ������.
bool OpenAddOrderRule = FALSE; //--- ��� ��������� ������ �������� ����� ������ �� ����� �� ����� �����������. ���������� ���� �� ������ ���������� ��������, �� �� ������ ����� �������� ����� �������� �� ������.
//---
int  STOPLEVEL,n,DIGITS;
double BID,ASK,POINT;
string  SymbolTral,TekSymbol;
string txt;
//+--------------------------------------------------------------------------------------------------------------+
//| INIT. ������������� ��������� ����������, �������� �������� �� �������.
//+--------------------------------------------------------------------------------------------------------------+
void init() {
//+--------------------------------------------------------------------------------------------------------------+
   
   //---
   if (IsTesting() && !IsVisualMode()) PrintLogOnChart = FALSE; //--- ���� ���������, �� ����������� ����������� �� �������
   if (!PrintLogOnChart) Comment("EA Angel");
   //---
   EASymbol = Symbol(); //--- ������������� �������� �������
   //---
   if (Digits < 4) {
      pp = 0.01;
      pd = 2;
      cf = 0.009;
   } else {
      pp = 0.0001;
      pd = 4;
      cf = 0.00009;
   }
   //---
   SP = Slippage * MathPow(10, Digits - pd); //--- ������ ��������������� ���� ��� ���������
   CloseSP = CloseSlippage * MathPow(10, Digits - pd);
   NDMaxSpread = NormalizeDouble(MaxSpread * pp, pd + 1); //--- �������������� �������� MaxSpread � ������
   //---
   if (ObjectFind("BKGR") >= 0) ObjectDelete("BKGR");
   if (ObjectFind("BKGR2") >= 0) ObjectDelete("BKGR2");
   if (ObjectFind("BKGR3") >= 0) ObjectDelete("BKGR3");
   if (ObjectFind("BKGR4") >= 0) ObjectDelete("BKGR4");
   if (ObjectFind("LV") >= 0) ObjectDelete("LV");
   //---
   
   //--- ������������� ���������� ��� MM
   
   MinLot = MarketInfo(Symbol(), MODE_MINLOT);
   MaxLot = MarketInfo(Symbol(), MODE_MAXLOT);
   LotValue = MarketInfo(Symbol(), MODE_LOTSIZE);
   LotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
   FreeMargin = MarketInfo(Symbol(), MODE_MARGINREQUIRED);
   
   //--- ��������� �������� ��������� ���� ����������� ������� ������ �� ���������� ������ �������.
   double SymbolBid = 0;
   if (StringSubstr(AccountCurrency(), 0, 3) == "JPY") {
      SymbolBid = MarketInfo("USDJPY" + StringSubstr(Symbol(), 6), MODE_BID);
      if (SymbolBid > 0.1) LotPrice = SymbolBid;
      else LotPrice = 84;
   }
   //---
   if (StringSubstr(AccountCurrency(), 0, 3) == "GBP") {
      SymbolBid = MarketInfo("GBPUSD" + StringSubstr(Symbol(), 6), MODE_BID);
      if (SymbolBid > 0.1) LotPrice = 1 / SymbolBid;
      else LotPrice = 0.6211180124;
   }
   //---
   if (StringSubstr(AccountCurrency(), 0, 3) == "EUR") {
      SymbolBid = MarketInfo("EURUSD" + StringSubstr(Symbol(), 6), MODE_BID);
      if (SymbolBid > 0.1) LotPrice = 1 / SymbolBid;
      else LotPrice = 0.7042253521;
   }
   
   //--- ��������� �� ��������
   
   iWPR_Filter_OpenLong_a = iWPR_Filter_Open_a;
   iWPR_Filter_OpenLong_b = iWPR_Filter_Open_b;
   iWPR_Filter_OpenShort_a = -100 - iWPR_Filter_Open_a;
   iWPR_Filter_OpenShort_b = -100 - iWPR_Filter_Open_b;

   //--- ��������� �� ��������
   
   iWPR_Filter_CloseLong = iWPR_Filter_Close;
   iWPR_Filter_CloseShort = -100 - iWPR_Filter_Close;
   
   //---
   //return (0);
   
}

//+--------------------------------------------------------------------------------------------------------------+
//| DEINIT. �������� �������� �� �������.
//+--------------------------------------------------------------------------------------------------------------+
int deinit() {
//+--------------------------------------------------------------------------------------------------------------+

   if (ObjectFind("BKGR") >= 0) ObjectDelete("BKGR");
   if (ObjectFind("BKGR2") >= 0) ObjectDelete("BKGR2");
   if (ObjectFind("BKGR3") >= 0) ObjectDelete("BKGR3");
   if (ObjectFind("BKGR4") >= 0) ObjectDelete("BKGR4");
   if (ObjectFind("LV") >= 0) ObjectDelete("LV");
   //---
   ObjectDelete("SL Buy");
   ObjectDelete("STOPLEVEL-");
   ObjectDelete("SL Sell");
   ObjectDelete("STOPLEVEL+");
   ObjectDelete("NoLossSell");
   ObjectDelete("NoLossSell_");
   ObjectDelete("NoLossBuy");
   ObjectDelete("NoLossBuy_");
   
   return (0);
   
}

//+--------------------------------------------------------------------------------------------------------------+
//| START. �������� �� ������, � ����� ����� ������� Scalper.
//+--------------------------------------------------------------------------------------------------------------+
int start() {
//+--------------------------------------------------------------------------------------------------------------+
   string Simb;
   SymbolTral = Symbol();
   txt="  Set TrailingStop  ";
   if (TrailingStopProfit==1) txt=StringConcatenate(txt,"  by candles","\n"); 
   if (TrailingStopProfit==2) txt=StringConcatenate(txt,"  by Fractals","\n"); 
   if (TrailingStopProfit==3) txt=StringConcatenate(txt,"  by Velocity","\n"); 
   if (TrailingStopProfit==4) txt=StringConcatenate(txt,"  by Parabolic","\n"); 
   if (TrailingStopProfit> 4) txt=StringConcatenate(txt,"  by ",TrailingStopProfit," pips","\n"); 
   if (Magic==0) txt=StringConcatenate(txt,"  Magic all","\n"); 
   else  txt=StringConcatenate(txt,"  Magic ",Magic,"\n");
   if (SymbolAll) {txt=StringConcatenate(txt,"  All Symbol","\n");Simb="  All Symbols";}
   else  Simb=StringConcatenate("  ",SymbolTral);

   if (GeneralNoLoss) txt=StringConcatenate(txt,"  sweep of the level without loss","\n");
   if (only_Profit) txt=StringConcatenate(txt,"  only profitable orders","\n");
   if (TrailingStopLoss!=0) txt=StringConcatenate(txt,"  Trailing unprofitable positions ",TrailingStopLoss,"\n");
   if (only_SL) txt=StringConcatenate(txt,"  only orders with exhibited SL","\n");
   
   RefreshRates();
   STOPLEVEL=MarketInfo(SymbolTral,MODE_STOPLEVEL);
   if (TrailingStopProfit<STOPLEVEL && TrailingStopProfit>4) TrailingStopProfit=STOPLEVEL;
   
   TrailingStop();
//---
   if (PrintLogOnChart) ShowComments (); //--- ��������� ������������ �� �������
   //---
   SetStops();
   CloseOrders(); //--- ������������� �������
   ModifyOrders(); //--- ����� � ���������
   
   //--- ������������� ������ �����
   if (AutoMM > 0.0 && (!RecoveryMode)) LotSize = MathMax(MinLot, MathMin(MaxLot, MathCeil(MathMin(AutoMM_Max, AutoMM) / LotPrice / 100.0 * AccountFreeMargin() / LotStep / (LotValue / 100)) * LotStep));
   if (AutoMM > 0.0 && RecoveryMode) LotSize = CalcLots(); //--- ���� ������� RecoveryMode ���������� CalcLots
   if (AutoMM == 0.0) LotSize = FixedLot;
   
   //--- �������� ������� ������������ ������ ��� ���������� M15
   if(iBars(Symbol(), PERIOD_M15) < iMA_Period || iBars(Symbol(), PERIOD_M15) < iWPR_Period || iBars(Symbol(), PERIOD_M15) < iATR_Period || iBars(Symbol(), PERIOD_M15) < iCCI_Period)
   {
      Print("������������ ������������ ������ ��� ��������");
      return (0);
   }
   //---
   if (DayOfWeek() == 1 && iVolume(NULL, PERIOD_D1, 0) < 5.0) return (0);
   if (StringLen(EASymbol) < 6) return (0);   
   //---
   if ((!IsTesting()) && IsStopped()) return (0);
   if ((!IsTesting()) && !IsTradeAllowed()) return (0);
   if ((!IsTesting()) && IsTradeContextBusy()) return (0);
   //---
   HideTestIndicators(HideTestInd);
   //---
   Scalper();
   //---
   return (0);
}
//--------------------------------------------------------------------
void TrailingStop()
{
   int tip,Ticket;
   bool error,OrderSelec;
   double StLo,OSL,OOP,NoLoss;
   n=0;
   for (int i=OrdersTotal(); i>=0; i--) 
   {  if (OrderSelect(i, SELECT_BY_POS)==true)
      {  tip = OrderType();
         TekSymbol=OrderSymbol();
         if (tip<2 && (TekSymbol==SymbolTral || SymbolAll) && (OrderMagicNumber()==Magic || Magic==0))
         {
            POINT  = MarketInfo(TekSymbol,MODE_POINT);
            DIGITS = MarketInfo(TekSymbol,MODE_DIGITS);
            BID    = MarketInfo(TekSymbol,MODE_BID);
            ASK    = MarketInfo(TekSymbol,MODE_ASK);
            OSL    = OrderStopLoss();
            OOP    = OrderOpenPrice();
            Ticket = OrderTicket();
            if (tip==OP_BUY)             
            {  n++;
               if (GeneralNoLoss) NoLoss = TProfit(1,TekSymbol);
               OrderSelec = OrderSelect(i, SELECT_BY_POS);
               if (OSL > OOP && TrailingStopLoss!=0) StLo = SlLastBar(1,BID,TrailingStopLoss); 
               else StLo = SlLastBar(1,BID,TrailingStopProfit); 
               if ((StLo < NoLoss || NoLoss==0) && GeneralNoLoss) continue;
               if (StLo < OOP && only_Profit && !GeneralNoLoss) continue;
               if (OSL  >= OOP && TrailingStopLoss==0) continue;
               if (OSL  == 0 && only_SL) continue;
               if (StLo > OSL+StepTrall*POINT)
               {  error=OrderModify(Ticket,OOP,NormalizeDouble(StLo,DIGITS),OrderTakeProfit(),0,White);
                  if (!error) Print(TekSymbol,"  Error order ",Ticket," TrailingStop ",GetLastError(),"   ",SymbolTral,"   SL ",StLo);
                  else Comment(TekSymbol,"  TrailingStop ",Ticket," ",TimeToStr(TimeCurrent(),TIME_MINUTES));
               }
            }                                         
            if (tip==OP_SELL)        
            {  n++;
               if (GeneralNoLoss) NoLoss = TProfit(-1,TekSymbol); 
               OrderSelec = OrderSelect(i, SELECT_BY_POS);
               if (OSL < OOP && TrailingStopLoss!=0) StLo = SlLastBar(-1,ASK,TrailingStopLoss);  
               else StLo = SlLastBar(-1,ASK,TrailingStopProfit);  
               if (StLo > NoLoss && GeneralNoLoss) continue;
               if (StLo==0) continue;        
               if (StLo > OOP && only_Profit && !GeneralNoLoss) continue;
               if (OSL  <= OOP && TrailingStopLoss==0) continue;
               if (OSL  == 0 && only_SL) continue;
               if (StLo < OSL-StepTrall*POINT || OSL==0 )
               {  error=OrderModify(Ticket,OOP,NormalizeDouble(StLo,DIGITS),OrderTakeProfit(),0,White);
                  
                  if (!error) Print(TekSymbol,"  Error order ",Ticket," TrailingStop ",GetLastError(),"   ",SymbolTral,"   SL ",StLo);
                  else Comment(TekSymbol,"  TrailingStop "+Ticket," ",TimeToStr(TimeCurrent(),TIME_MINUTES));
               }
            } 
         }
      }
   }
}
//--------------------------------------------------------------------
double SlLastBar(int tip,double price,double Trailing)
{
   double fr=0;
   int jj,ii;
   if (Trailing>4)
   {
      if (tip==1) fr = price - Trailing*POINT;  
      else        fr = price + Trailing*POINT;  
   }
   else
   {
      //------------------------------------------------------- by Fractals
      if (Trailing==2)
      {
         if (tip== 1)
         {
            for (ii=1; ii<100; ii++) 
            {
               fr = iFractals(TekSymbol,0,MODE_LOWER,ii);
               if (fr!=0) {fr-=delta*POINT; if (price-STOPLEVEL*POINT > fr) break;}
               else fr=0;
            }
            ObjectDelete("FR Buy");
            ObjectCreate("FR Buy",OBJ_ARROW,0,Time[ii],fr+Point,0,0,0,0);                     
            ObjectSet   ("FR Buy",OBJPROP_ARROWCODE,218);
            ObjectSet   ("FR Buy",OBJPROP_COLOR, Red);
         }
         if (tip==-1)
         {
            for (jj=1; jj<100; jj++) 
            {
               fr = iFractals(TekSymbol,0,MODE_UPPER,jj);
               if (fr!=0) {fr+=delta*POINT; if (price+STOPLEVEL*POINT < fr) break;}
               else fr=0;
            }
            ObjectDelete("FR Sell");
            ObjectCreate("FR Sell",OBJ_ARROW,0,Time[jj],fr,0,0,0,0);                     
            ObjectSet   ("FR Sell",OBJPROP_ARROWCODE,217);
            ObjectSet   ("FR Sell",OBJPROP_COLOR, Red);
         }
      }
      //------------------------------------------------------- by candles
      if (Trailing==1)
      {
         if (tip== 1)
         {
            for (ii=1; ii<500; ii++) 
            {
               fr = iLow(TekSymbol,0,ii)-delta*POINT;
               if (fr!=0) if (price-STOPLEVEL*POINT > fr) break;
               else fr=0;
            }
            ObjectDelete("FR Buy");
            ObjectCreate("FR Buy",OBJ_ARROW,0,Time[ii],fr+Point,0,0,0,0);                     
            ObjectSet   ("FR Buy",OBJPROP_ARROWCODE,159);
            ObjectSet   ("FR Buy",OBJPROP_COLOR, Red);
         }
         if (tip==-1)
         {
            for (jj=1; jj<500; jj++) 
            {
               fr = iHigh(TekSymbol,0,jj)+delta*POINT;
               if (fr!=0) if (price+STOPLEVEL*POINT < fr) break;
               else fr=0;
            }
            ObjectDelete("FR Sell");
            ObjectCreate("FR Sell",OBJ_ARROW,0,Time[jj],fr,0,0,0,0);                     
            ObjectSet   ("FR Sell",OBJPROP_ARROWCODE,159);
            ObjectSet   ("FR Sell",OBJPROP_COLOR, Red);
         }
      }   
      //------------------------------------------------------- by Velocity
      if (Trailing==3)
      {
         double Velocity_0 = iCustom(TekSymbol,0,"Velocity",VelocityPeriodBar,2,0);
         double Velocity_1 = iCustom(TekSymbol,0,"Velocity",VelocityPeriodBar,2,1);
         if (tip== 1)
         {
            if(Velocity_0>Velocity_1) fr = price - (delta-Velocity_0+Velocity_1)*POINT*K_Velocity;
            else fr=0;
         }
         if (tip==-1)
         {
            if(Velocity_1>Velocity_0) fr = price + (delta+Velocity_1-Velocity_0)*POINT*K_Velocity;
            else fr=0;
         }
      }
      //------------------------------------------------------- by PSAR
      if (Trailing==4)
      {
         double PSAR = iSAR(TekSymbol,0,Step,Maximum,0);
         if (tip== 1)
         {
            if(price-STOPLEVEL*POINT > PSAR) fr = PSAR - delta*POINT;
            else fr=0;
         }
         if (tip==-1)
         {
            if(price+STOPLEVEL*POINT < PSAR) fr = PSAR + delta*POINT;
            else fr=0;
         }
      }
   }
   //-------------------------------------------------------
   if (visualization && TekSymbol==SymbolTral)
   {
      if (tip== 1)
      {  
         if (fr!=0){
         ObjectDelete("SL Buy");
         ObjectCreate("SL Buy",OBJ_ARROW,0,Time[0]+Period()*60,fr,0,0,0,0);                     
         ObjectSet   ("SL Buy",OBJPROP_ARROWCODE,6);
         ObjectSet   ("SL Buy",OBJPROP_COLOR, Blue);}
         if (STOPLEVEL>0){
         ObjectDelete("STOPLEVEL-");
         ObjectCreate("STOPLEVEL-",OBJ_ARROW,0,Time[0]+Period()*60,price-STOPLEVEL*POINT,0,0,0,0);                     
         ObjectSet   ("STOPLEVEL-",OBJPROP_ARROWCODE,4);
         ObjectSet   ("STOPLEVEL-",OBJPROP_COLOR, Blue);}
      }
      if (tip==-1)
      {
         if (fr!=0){
         ObjectDelete("SL Sell");
         ObjectCreate("SL Sell",OBJ_ARROW,0,Time[0]+Period()*60,fr,0,0,0,0);
         ObjectSet   ("SL Sell",OBJPROP_ARROWCODE,6);
         ObjectSet   ("SL Sell", OBJPROP_COLOR, Pink);}
         if (STOPLEVEL>0){
         ObjectDelete("STOPLEVEL+");
         ObjectCreate("STOPLEVEL+",OBJ_ARROW,0,Time[0]+Period()*60,price+STOPLEVEL*POINT,0,0,0,0);                     
         ObjectSet   ("STOPLEVEL+",OBJPROP_ARROWCODE,4);
         ObjectSet   ("STOPLEVEL+",OBJPROP_COLOR, Pink);}
      }
   }
   return(fr);
}
//-------------------------------------------------------------------- calculation of total (general) TP
double TProfit(int tip,string Symb)
{
   int b,s;
   double price,price_b,price_s,lot,SLb,SLs,lot_s,lot_b;
   for (int j=0; j<OrdersTotal(); j++)
   {  if (OrderSelect(j,SELECT_BY_POS,MODE_TRADES)==true)
      {  if ((Magic==OrderMagicNumber() || Magic==0) && OrderSymbol()==Symb)
         {
            price = OrderOpenPrice();
            lot   = OrderLots();
            if (OrderType()==OP_BUY ) {price_b += price*lot; lot_b+=lot; b++;}                     
            if (OrderType()==OP_SELL) {price_s += price*lot; lot_s+=lot; s++;}
         }  
      }  
   }
   //--------------------------------------
   if (visualization && Symb==SymbolTral)
   {
      ObjectDelete("NoLossBuy");
      ObjectDelete("NoLossBuy_");
      ObjectDelete("NoLossSell");
      ObjectDelete("NoLossSell_");
   }
   if (b!=0) 
   {  SLb = price_b/lot_b;
      if (visualization && Symb==SymbolTral){
         ObjectCreate("NoLossBuy",OBJ_ARROW,0,Time[0]+Period()*60*5,SLb,0,0,0,0);                     
         ObjectSet   ("NoLossBuy",OBJPROP_ARROWCODE,6);
         ObjectSet   ("NoLossBuy",OBJPROP_COLOR, Blue);         
         ObjectCreate("NoLossBuy_",OBJ_ARROW,0,Time[0]+Period()*60*5,SLb,0,0,0,0);                     
         ObjectSet   ("NoLossBuy_",OBJPROP_ARROWCODE,200);
         ObjectSet   ("NoLossBuy_",OBJPROP_COLOR, Blue);}
   }
   if (s!=0) 
   {  SLs = price_s/lot_s;
      if (visualization && Symb==SymbolTral){
         ObjectCreate("NoLossSell",OBJ_ARROW,0,Time[0]+Period()*60*5,SLs,0,0,0,0);                     
         ObjectSet   ("NoLossSell",OBJPROP_ARROWCODE,6);
         ObjectSet   ("NoLossSell",OBJPROP_COLOR, Pink);         
         ObjectCreate("NoLossSell_",OBJ_ARROW,0,Time[0]+Period()*60*5,SLs,0,0,0,0);                     
         ObjectSet   ("NoLossSell_",OBJPROP_ARROWCODE,202);
         ObjectSet   ("NoLossSell_",OBJPROP_COLOR, Pink);}
   }
  if (tip== 1) return(SLb);
  if (tip==-1) return(SLs);
  
 return(0); 
}
//--------------------------------------------------------------------
//+--------------------------------------------------------------------------------------------------------------+
//| Scalper. �������� �������. ������� ������������ �������� ������, ����� �������� �������� �� ����.
//+--------------------------------------------------------------------------------------------------------------+
void Scalper() {
//+--------------------------------------------------------------------------------------------------------------+
    
   //--- ��������� � ����������� ������
   if (MaxSpreadFilter()) {
      if (!CheckSpreadRule && WriteDebugLog) {
         //---
         Print("�������� ������ �������� ��-�� �������� ������.");
         Print("������� ����� = ", DoubleToStr((Ask - Bid) / pp, 1), ",  MaxSpread = ", DoubleToStr(MaxSpread, 1));
         Print("������� ����� ��������� �����, ����� ����� ������ ����������.");
         }
         //---
      CheckSpreadRule = TRUE;
      //---
      } else {
      //---
      CheckSpreadRule = FALSE;
      if (OpenLongSignal() && OpenTradeCount() && LongTrade) OpenPosition(OP_BUY);
      if (OpenShortSignal() && OpenTradeCount() && ShortTrade) OpenPosition(OP_SELL);
      //---
   } //--- �������� if (MaxSpreadFilter)
}

//+--------------------------------------------------------------------------------------------------------------+
//| OpenPosition. ������� �������� �������.
//+--------------------------------------------------------------------------------------------------------------+
int OpenPosition(int OpType) {
//+--------------------------------------------------------------------------------------------------------------+

   int RandomOpenTime; //--- �������� �� ������� �� ��������
   double DistLevel; //--- ���� ������� ��� �������. ���������� ��� �������� ��������� ��������
   color OpenColor; //--- ���� �������� �������. ���� Buy �� �������, ���� Sell �� �������
   int OpenOrder; //--- �������� �������
   int OpenOrderError; //--- ������ ��������
   string OpTypeString; //--- �������������� ���� ������� � ��������� ��������
   double OpenPrice; //--- ���� ��������
   //---
   double TP, SL;
   double OrderTP = NormalizeDouble (TakeProfit * pp , pd); //--- ����������� ����-������ � ��� Points
   double OrderSL = NormalizeDouble (StopLoss * pp , pd); //--- ����������� ����-���� � ��� Points
     
   //--- �������� � �������� ����� ����������
   if (RandomOpenTimePercent > 0) {
      MathSrand(TimeLocal());
      RandomOpenTime = MathRand() % RandomOpenTimePercent;
      
      if (WriteLog) {
      Print("DelayRandomiser: �������� ", RandomOpenTime, " ������.");
      }
      
      Sleep(1000 * RandomOpenTime);
   } //--- �������� if (RandomOpenTimePerc
   
   double OpenLotSize = LotSize; //--- ������ ������ �������
   
   //--- ���� �� ������ �������, ���������� ������
   if (AccountFreeMarginCheck(EASymbol, OpType, OpenLotSize) <= 0.0 || GetLastError() == 134/* NOT_ENOUGH_MONEY */) {
      //---
      if (WriteDebugLog) {
      //---
         Print("��� �������� ������ ������������ ��������� �����.");
         Comment("��� �������� ������ ������������ ��������� �����.");
      //---
      }
      return (-1);
   } //--- �������� if (AccountFreeMarginCheck  
   
   RefreshRates();
   
   //--- ���� ������� �������, ��
   if (OpType == OP_BUY) {
      OpenPrice = NormalizeDouble(Ask, Digits);
      OpenColor = OpenBuyColor;
      
      //---
      if (UseStopLevels) { //--- ���� �������� ����-������ (����-���� � ����-������)
      
      TP = NormalizeDouble(OpenPrice + OrderTP, Digits); //--- �� ����������� ����-������
      SL = NormalizeDouble(OpenPrice - OrderSL, Digits); //--- � ����-����
      //---
      } else {TP = 0; SL = 0;}
   
   //--- ���� �������� �������, ��   
   } else {
      OpenPrice = NormalizeDouble(Bid, Digits);
      OpenColor = OpenSellColor;
      
      //---
      if (UseStopLevels) {
       
      TP = NormalizeDouble(OpenPrice - OrderTP, Digits);
      SL = NormalizeDouble(OpenPrice + OrderSL, Digits);
      }
      //---
      else {TP = 0; SL = 0;}
   }
   
   TP = 0; SL = 0;
   
   int MaximumTradesCount = MaximumTrades; //--- ������� �������� �������
   while (MaximumTradesCount > 0 && OpenTradeCount()) { //--- ���� MaximumTrades ����� ������ 1-��, �� ���������� ��������
      //---
      OpenOrder = OrderSend(EASymbol, OpType, OpenLotSize, OpenPrice, SP, SL, TP, OpenOrderComment, MagicNumber, 0, OpenColor);
      //---
      Sleep(MathRand() / 1000); //--- �������� � ��������� ������ ����� ��������
      //---
      if (OpenOrder < 0) { //--- ���� ����� �� ��������, ��
         OpenOrderError = GetLastError(); //--- ���������� ������
         //---
         if (WriteDebugLog) {
            if (OpType == OP_BUY) OpTypeString = "OP_BUY";
            else OpTypeString = "OP_SELL";
            Print("��������: OrderSend(", OpTypeString, ") ������ = ", ErrorDescription(OpenOrderError)); //--- ��� ������ �� �������
         } //--- �������� if (WriteDebugLog)
         
         //---
         if (OpenOrderError != 136/* OFF_QUOTES */) break; //--- ���� ��� ���, �� ���������� ����
         if (!(OpenAddOrderRule)) break; //--- ���� ��� ���������� �� �������� �������, �� ���������� ����
         //---
         Sleep(6000); //--- ������ �����
         RefreshRates(); //--- � ��������� ���������
         //---
         if (OpType == OP_BUY) DistLevel = NormalizeDouble(Ask, Digits); //--- �������� ����� ���� ������� � �������
         else DistLevel = NormalizeDouble(Bid, Digits);
         //---
         if (NormalizeDouble(MathAbs((DistLevel - OpenPrice) / pp), 0) > Dist) break; //--- ������� ���������� ���������� �������� ������� ����� ������� ������ � ����� ��������, ����� ���������� ���������� � �������� �� ��������� ���������� Dist
         //---
         OpenPrice = DistLevel; //--- �������� ����� �������� OpenPrice
         MaximumTradesCount--; //--- � �������� -1 �� �������� MaximumTrades
         
         //--- ���� ������� ������ ����, �� ������ ��������� � ���, ��� ����� ������� �����.
         if (MaximumTradesCount > 0) {
            if (WriteLog) {
            Print("... �������� ������� �����.");
         } } //--- �������� if (MaximumTradesCount
         //---
         } //--- �������� if (OpenOrder < 0)
         
         //--- �, ���� �� OpenOrder > 0, �� 
         else {
         if (OrderSelect(OpenOrder, SELECT_BY_TICKET)) OpenPrice = OrderOpenPrice();
         //---
         if (!(SoundAlert)) break; //--- ������������� �����, ���� �� �������
         PlaySound(SoundFileAtOpen);
         break;
      } //--- �������� else { ��� OpenOrder > 0
   } //--- �������� ����� while (MaximumTradesCount > 0)
   //---
   return (OpenOrder);
}

//+--------------------------------------------------------------------------------------------------------------+
//| ModifyOrders. ����������� ������� � ���������.
//+--------------------------------------------------------------------------------------------------------------+
void ModifyOrders() {
//+--------------------------------------------------------------------------------------------------------------+

   bool TicketModify; //--- �������� ������
   int total = OrdersTotal() - 1;
   int ModifyError = GetLastError();
   int ModifyTicketID = OrderTicket();
   string ModifyOrderType = OrderType();
   //---
   for (int i = total; i >= 0; i--) { //--- ������� �������� �������
      if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         if (WriteDebugLog) Print("��������� ������ �� ����� ������� ������. �������: ", ErrorDescription(ModifyError));
      
      } else {
      
      //--- ����������� ������ �� �������
      if (OrderType() == OP_BUY) {
         if (OrderMagicNumber() == MagicNumber && OrderSymbol() == EASymbol) {
            if (Bid - OrderOpenPrice() > SecureProfitTriger * pp && MathAbs(OrderOpenPrice() + SecureProfit * pp - OrderStopLoss()) >= Point) {
            //--- ������������ �����
            TicketModify = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice() + SecureProfit * pp, Digits), OrderTakeProfit(), 0, Blue);
            if (!TicketModify)
               if (WriteDebugLog) Print("��������� ������ �� ����� ����������� ������ (", ModifyOrderType, ",", ModifyTicketID, "). �������: ", ErrorDescription(ModifyError));
            }
         }
      } //--- �������� if (OrderType() == OP_BUY)
      
      //--- ����������� ������ �� �������
      if (OrderType() == OP_SELL) {
         if (OrderMagicNumber() == MagicNumber && OrderSymbol() == EASymbol) {
            if (OrderOpenPrice() - Ask > SecureProfitTriger * pp && MathAbs(OrderOpenPrice() - SecureProfit * pp - OrderStopLoss()) >= Point) {
            //--- ������������ �����
            TicketModify = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice() - SecureProfit * pp, Digits), OrderTakeProfit(), 0, Red);
            if (!TicketModify)
               if (WriteDebugLog) Print("��������� ������ �� ����� ����������� ������ (", ModifyOrderType, ",", ModifyTicketID, "). �������: ", ErrorDescription(ModifyError));
               
               }
            }
         } //--- �������� if (OrderType() == OP_SELL)
      }
   } //--- �������� for (int i = total - 1; i >= 0; i--)
}

//+--------------------------------------------------------------------------------------------------------------+
//| CloseTrades. ����������� ����-������ � ����-����.
//| ���� �������� ������� UseStopLevels, �� ������������ ��� ������� ���������� ��������.
//+--------------------------------------------------------------------------------------------------------------+
void CloseOrders() {
//+--------------------------------------------------------------------------------------------------------------+
   int total = OrdersTotal() - 1;
   int OpenLongOrdersCount = 0;
   int OpenShortOrdersCount = 0;
   int MaxCount = 3;
   int CloseError = GetLastError();
   int CloseTicketID = OrderTicket();
   string CloseOrderType = OrderType();
   
   //---
   for (int i = total; i >= 0; i--) { //--- ������� �������� �������
      if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         if (WriteDebugLog) Print("��������� ������ �� ����� ������� ������. �������: ", ErrorDescription(CloseError));
      
      } else {
      
      //--- �������� �� ������� ��� ����� ������� �� �������
      if (OrderType() == OP_BUY) {
      OpenLongOrdersCount++;
         if (OrderMagicNumber() == MagicNumber && OrderSymbol() == EASymbol) {
            if (Bid >= OrderOpenPrice() + TakeProfit * pp || Bid <= OrderOpenPrice() - StopLoss * pp || CloseLongSignal(OrderOpenPrice(), ExistPosition())) {
               //---
               for (int MinCount = 1; MinCount <= MathMax(1, MaxCount); MinCount++) {
               RefreshRates();
               if (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), CloseSP, CloseBuyColor)) {
               OpenLongOrdersCount--; //--- �������� �������
               break;
               //---        
               } else {
               if (WriteDebugLog) Print("��������� ������ �� ����� �������� ������ (",CloseOrderType, ",", CloseTicketID, "). �������: ", ErrorDescription(CloseError));
                  }
               //---
               }
            }
         }
      } //--- �������� if (OrderType() == OP_BUY)
      
      //--- �������� �� ������� ��� ����� ������� �� �������
      if (OrderType() == OP_SELL) {
      OpenShortOrdersCount++;
         if (OrderMagicNumber() == MagicNumber && OrderSymbol() == EASymbol) {
            if (Ask <= OrderOpenPrice() - TakeProfit * pp || Ask >= OrderOpenPrice() + StopLoss * pp || CloseShortSignal(OrderOpenPrice(), ExistPosition())) {
               //---
               for (MinCount = 1; MinCount <= MathMax(1, MaxCount); MinCount++) {
               RefreshRates();
               if (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), CloseSP, CloseSellColor)) {
               OpenShortOrdersCount--; //--- �������� �������
               break;
               //---
               } else {
                  if (WriteDebugLog) Print("��������� ������ �� ����� �������� ������ (",CloseOrderType, ",", CloseTicketID, "). �������: ", ErrorDescription(CloseError));
                     }
                 //---
                  }
               }
            }
         } //--- �������� if (OrderType() == OP_SELL)
      } 
   } //--- �������� for (int i = total - 1; i >= 0; i--) {
}

//+--------------------------------------------------------------------------------------------------------------+
//| OpenLongSignal. ������ �� �������� ������� �������.
//+--------------------------------------------------------------------------------------------------------------+
bool OpenLongSignal() {
//+--------------------------------------------------------------------------------------------------------------+

bool result = false;
bool result1 = false;
bool result2 = false;
bool result3 = false;

//--- ������ �������� �������� �� ����
double iClose_Signal = iClose(NULL, PERIOD_M15, 1);
double iMA_Signal = iMA(NULL, PERIOD_M15, iMA_Period, 0, MODE_SMMA, PRICE_CLOSE, 1);
double iWPR_Signal = iWPR(NULL, PERIOD_M15, iWPR_Period, 1);
double iATR_Signal = iATR(NULL, PERIOD_M15, iATR_Period, 1);
double iCCI_Signal = iCCI(NULL, PERIOD_M15, iCCI_Period, PRICE_TYPICAL, 1);
//---
double iMA_Filter_a = NormalizeDouble(iMA_Filter_Open_a*pp,pd);
double iMA_Filter_b = NormalizeDouble(iMA_Filter_Open_b*pp,pd);
double BidPrice = Bid; //--- (iClose_Signal >= BidPrice) ��������� ��� ������ � Bid (� �� � Ask, ��� ������ ����), ��� ��� ���� �������� ����� iClose_Signal ����������� �� ��������� �������� Bid
//---

//--- ������� ������ �� ��� � ��� ��������
if (iATR_Signal <= FilterATR * pp) return (0);
//---
if (iClose_Signal - iMA_Signal > iMA_Filter_a && iClose_Signal - BidPrice >= - cf && iWPR_Filter_OpenLong_a > iWPR_Signal) result1 = true;
else result1 = false;
//---
if (iClose_Signal - iMA_Signal > iMA_Filter_b && iClose_Signal - BidPrice >= - cf && - iCCI_OpenFilter > iCCI_Signal) result2 = true;
else result2 = false;
//---
if (iClose_Signal - iMA_Signal > iMA_Filter_b && iClose_Signal - BidPrice >= - cf && iWPR_Filter_OpenLong_b > iWPR_Signal) result3 = true;
else result3 = false;
//---
if (result1 == true || result2 == true || result3 == true) result = true;
else result = false;
//---
return (result);

}

//+--------------------------------------------------------------------------------------------------------------+
//| OpenShortSignal. ������ �� �������� �������� �������.
//+--------------------------------------------------------------------------------------------------------------+
bool OpenShortSignal() {
//+--------------------------------------------------------------------------------------------------------------+

bool result = false;
bool result1 = false;
bool result2 = false;
bool result3 = false;

//--- ������ �������� �������� �� ����
double iClose_Signal = iClose(NULL, PERIOD_M15, 1);
double iMA_Signal = iMA(NULL, PERIOD_M15, iMA_Period, 0, MODE_SMMA, PRICE_CLOSE, 1);
double iWPR_Signal = iWPR(NULL, PERIOD_M15, iWPR_Period, 1);
double iATR_Signal = iATR(NULL, PERIOD_M15, iATR_Period, 1);
double iCCI_Signal = iCCI(NULL, PERIOD_M15, iCCI_Period, PRICE_TYPICAL, 1);
//---
double iMA_Filter_a = NormalizeDouble(iMA_Filter_Open_a*pp,pd);
double iMA_Filter_b = NormalizeDouble(iMA_Filter_Open_b*pp,pd);
double BidPrice = Bid;
//---

//--- ������� ������ �� ��� � ��� ��������
if (iATR_Signal <= FilterATR * pp) return (0);
//---
if (iMA_Signal - iClose_Signal > iMA_Filter_a && iClose_Signal - BidPrice <= cf && iWPR_Signal > iWPR_Filter_OpenShort_a) result1 = true;
else result1 = false;
//---
if (iMA_Signal - iClose_Signal > iMA_Filter_b && iClose_Signal - BidPrice <= cf && iCCI_Signal > iCCI_OpenFilter) result2 = true;
else result2 = false;
//---
if (iMA_Signal - iClose_Signal > iMA_Filter_b && iClose_Signal - BidPrice <= cf && iWPR_Signal > iWPR_Filter_OpenShort_b) result3 = true;
else result3 = false;
//---
if (result1 == true || result2 == true || result3 == true) result = true;
else result = false;
//---
return (result);

}

//+--------------------------------------------------------------------------------------------------------------+
//| CloseLongSignal. ������ �� �������� ������� �������.
//+--------------------------------------------------------------------------------------------------------------+
bool CloseLongSignal(double OrderPrice, int CheckOrders) {
//+--------------------------------------------------------------------------------------------------------------+

bool result = false;
bool result1 = false;
bool result2 = false;
//---
double iWPR_Signal = iWPR(NULL, PERIOD_M15, iWPR_Period, 1);
double iClose_Signal = iClose(NULL, PERIOD_M15, 1);
double iOpen_CloseSignal = iOpen(NULL, PERIOD_M1, 1);
double iClose_CloseSignal = iClose(NULL, PERIOD_M1, 1);
//---
double MaxLoss = NormalizeDouble(-MaxLossPoints * pp,pd);
//---
double Price_Filter = NormalizeDouble(Price_Filter_Close*pp,pd);
double BidPrice = Bid;
//---

//---
if (OrderPrice - BidPrice <= MaxLoss && iClose_Signal - BidPrice <= cf && iWPR_Signal > iWPR_Filter_CloseLong && CheckOrders == 1) result1 = true;
else result1 = false;
//---
if (iOpen_CloseSignal > iClose_CloseSignal && BidPrice - OrderPrice >= Price_Filter && CheckOrders == 1) result2 = true;
else result2 = false;
//---
if (result1 == true || result2 == true) result = true;
else result = false;
//---
return (result);

}

//+--------------------------------------------------------------------------------------------------------------+
//| CloseShortSignal. ������ �� �������� �������� �������.
//+--------------------------------------------------------------------------------------------------------------+
bool CloseShortSignal(double OrderPrice, int CheckOrders) {
//+--------------------------------------------------------------------------------------------------------------+

bool result = false;
bool result1 = false;
bool result2 = false;
//---
double iWPR_Signal = iWPR(NULL, PERIOD_M15, iWPR_Period, 1);
double iClose_Signal = iClose(NULL, PERIOD_M15, 1);
double iOpen_CloseSignal = iOpen(NULL, PERIOD_M1, 1);
double iClose_CloseSignal = iClose(NULL, PERIOD_M1, 1);
//---
double MaxLoss = NormalizeDouble(-MaxLossPoints*pp,pd);
//---
double Price_Filter = NormalizeDouble(Price_Filter_Close*pp,pd);
double BidPrice = Bid;
double AskPrice = Ask;
//---

//---
if (AskPrice - OrderPrice <= MaxLoss && iClose_Signal - BidPrice >= - cf && iWPR_Signal < iWPR_Filter_CloseShort && CheckOrders == 1) result1 = true;
else result1 = false;
//---
if (iOpen_CloseSignal < iClose_CloseSignal && OrderPrice - AskPrice >= Price_Filter && CheckOrders == 1) result2 = true;
else result2 = false;
//---
if (result1 == true || result2 == true) result = true;
else result = false;
//---
return (result);

}

//+--------------------------------------------------------------------------------------------------------------+
//| CalcLots. ������� ������� ������ ����.
//| ��� AutoMM > 0.0 && RecoveryMode ������� CalcLots ����������� ����� ���� ������������ ��������� �������.
//| 
//| ����� ������ ���� ������������� ������ �� ����� �������� � ������� �������. �� ���� ���������� ���� ������
//| ������� �� ������ �� ��������� �������, �� � �� ����� �������� � ������� ���������� �������.
//| 
//| ������ �������� ��, ������� ������������ ��� ������ �� ������������ ����� ����-������ ��� ����������
//| ��������� RecoveryMode, �� ����, ��� ������� ����� �������� ����� �������������� ��������.
//+--------------------------------------------------------------------------------------------------------------+
double CalcLots() {
//+--------------------------------------------------------------------------------------------------------------+

   double SumProfit; //--- ��������� ������
   int OldOrdersCount; //--- ������� ���-�� �������� ���������� �������
   double loss; //--- ��������
   int LossOrdersCount; //--- ����� ����� � �������
   double pr; //--- ������
   int ProfitOrdersCount; //--- ���-�� ���������� ������� � �������
   double LastPr; //--- ���������� �������� ������
   int LastCount; //--- ���������� �������� �������� �������
   double MultiLot = 1; //---  ��������� �������� ��������� ����
   //---
   
   //--- ���� �� �������, ��
   if (MultiLotPercent > 0.0 && AutoMM > 0.0) {
      
      //--- �������� ��������
      SumProfit = 0;
      OldOrdersCount = 0;
      loss = 0;
      LossOrdersCount = 0;
      pr = 0;
      ProfitOrdersCount = 0;
      //---
      
      //--- �������� �������� ����� ������
      for (int i = OrdersHistoryTotal() - 1; i >= 0; i--) {
         if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) {
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
               OldOrdersCount++; //--- ������� ������
               SumProfit += OrderProfit(); //--- � ��������� ������
               
               //--- ���� ��������� ������ ������ pr (��� ������ ������ 0)
               if (SumProfit > pr) {
                  //--- �������������� ������ � ������� ���������� �������
                  pr = SumProfit;
                  ProfitOrdersCount = OldOrdersCount;
               }
               //--- ���� ��������� ������ ������ loss (��� ������ ������ 0)
               if (SumProfit < loss) {
                  //--- �������������� �������� � ������� ��������� �������
                  loss = SumProfit;
                  LossOrdersCount = OldOrdersCount;
               }
               //--- ���� ������� ���-�� ������������ ������� ������ ��� ����� MaxAnalizCount (50), �� � ������� ������� ������ ���������� ������ � ������ ��������.
               if (OldOrdersCount >= MaxAnalizCount) break;
            }
         }
      } //--- �������� for (int i = OrdersHistoryTotal() - 1; i >= 0; i--) {
      
      
      //--- ���� ����� ���������� ������� ������ ��� ����� ����� �����, �� ����������� �������� ��������� ���� MultiLot
      if (ProfitOrdersCount <= LossOrdersCount) MultiLot = MathPow(MultiLotPercent, LossOrdersCount);
      
      //--- ���� ���, ��
      else {
         
         //--- �������������� ��������� �� �������
         SumProfit = pr;
         OldOrdersCount = ProfitOrdersCount;
         LastPr = pr;
         LastCount = ProfitOrdersCount;
         
         //--- �������� �������� ����� ������ (����� ����� ���������� �������)
         for (i = OrdersHistoryTotal() - ProfitOrdersCount - 1; i >= 0; i--) {
            if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) {
               if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
                  //--- ���� ������� ����� 50 ������� ����������� ��������
                  if (OldOrdersCount >= MaxAnalizCount) break;
                  //---
                  OldOrdersCount++; //--- ������� ���-�� �������
                  SumProfit += OrderProfit(); //--- � ������
                  
                  //--- ���� ����� ������ ������ ����������� (LastPr), ��
                  if (SumProfit < LastPr) {
                     //--- ������������������ �������� ������� � ���-�� �������
                     LastPr = SumProfit;
                     LastCount = OldOrdersCount;
                  }
               }
            }
         } //--- �������� for (i = OrdersHistoryTotal() - ProfitOrdersCount - 1; i >= 0; i--) {
         
         //--- ���� �������� �������� LastCount ����� �������� ���������� ������� ��� ������� ������ ����� �������, ��
         if (LastCount == ProfitOrdersCount || LastPr == pr) MultiLot = MathPow(MultiLotPercent, LossOrdersCount); //--- ����������� �������� ��������� ���� MultiLot
         
         //--- ���� ���, ��
         else {
            //--- ����� ������������� (loss - pr) �� ������������� (LastPr - pr) � ���������� � ������, ����� ����������� ��������� ���� MultiLot
            if (MathAbs(loss - pr) / MathAbs(LastPr - pr) >= (Risk + 100.0) / 100.0) MultiLot = MathPow(MultiLotPercent, LossOrdersCount);
            else MultiLot = MathPow(MultiLotPercent, LastCount);
         }
      }
   } //--- �������� if (MultiLotPercent > 0.0 && AutoMM > 0.0) {
   
   //--- �������� ��������� ����� ����, ������ �� ����������� ���� ��������
   for (double OpLot = MathMax(MinLot, MathMin(MaxLot, MathCeil(MathMin(AutoMM_Max, MultiLot * AutoMM) / 100.0 * AccountFreeMargin() / LotStep / (LotValue / 100)) * LotStep)); OpLot >= 2.0 * MinLot &&
      1.05 * (OpLot * FreeMargin) >= AccountFreeMargin(); OpLot -= MinLot) {
   }
   return (OpLot);
}

//+--------------------------------------------------------------------------------------------------------------+
//| MaxSpreadFilter. ������� ��� ������� ������� ������ � ��������� ��� �� ��������� MaxSpread.
//| ���� ������� ����� ��������, �� ���������� TRUE.
//+--------------------------------------------------------------------------------------------------------------+
bool MaxSpreadFilter() {
//+--------------------------------------------------------------------------------------------------------------+

   RefreshRates();
   if (NormalizeDouble(Ask - Bid, Digits) > NDMaxSpread) return (TRUE);
   //---
   else return (FALSE);
}

//+--------------------------------------------------------------------------------------------------------------+
//| ExistPosition. ������� �������� �������� �������.
//| ���� ������ ����� ���������� True, ���� ���, ���� ���������� (False, 0) �� ��������.
//+--------------------------------------------------------------------------------------------------------------+
int ExistPosition() {
//+--------------------------------------------------------------------------------------------------------------+

   int trade = OrdersTotal() - 1;
   for (int i = trade; i >= 0; i--) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderMagicNumber() == MagicNumber) {
            if (OrderSymbol() == EASymbol)
               if (OrderType() <= OP_SELL) return (1);
         }
      }
   }
   //---
   return (0);
}

//+--------------------------------------------------------------------------------------------------------------+
//| OpenTradeCount. ������� �������� �������. ���� ����� �������� ������� ������ ��� ����� MaximumTrades, ��
//| ���� ������ �� ��������.
//+--------------------------------------------------------------------------------------------------------------+
bool OpenTradeCount() {
//+--------------------------------------------------------------------------------------------------------------+

   int count = 0;
   int trade = OrdersTotal() - 1;
   for (int i = trade; i >= 0; i--) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
         if (OrderMagicNumber() == MagicNumber && OrderSymbol() == EASymbol) count++;
   }
   //---
   if (count >= MaximumTrades) return (False);
   else return (True);
}

//+--------------------------------------------------------------------------------------------------------------+
//| ShowComments. ������� ��� ����������� ������������ �� �������.
//+--------------------------------------------------------------------------------------------------------------+
void ShowComments() {
//+--------------------------------------------------------------------------------------------------------------+

string ComSpacer = ""; //--- "/n"
datetime MyOpDate = TIME_DATE; //--- ����� � ����������� ���� ����������� (������)
//---
ComSpacer = ComSpacer
      + "\n  " 
      + "\n "
      + "\n  EA Angel "
      + "\n  Copyright �  forexeapro.com "  
      + "\n "
      + "\n -----------------------------------------------"
      + "\n  Sets for: " + Symbol_Op
      + "\n  Optimization date: " + TimeToStr (Date, MyOpDate)
      + "\n -----------------------------------------------" 
      + "\n  SL = " + StopLoss + " pips / TP = " + TakeProfit + " pips" 
   + "\n  Spread = " + DoubleToStr((Ask - Bid) / pp, 1) + " pips";
   if (NormalizeDouble(Ask - Bid, Digits) > NDMaxSpread) ComSpacer = ComSpacer + " - TOO HIGH";
   else ComSpacer = ComSpacer + " - NORMAL";
   ComSpacer = ComSpacer 
   + "\n -----------------------------------------------";
   if (AutoMM > 0.0) {
      ComSpacer = ComSpacer 
         + "\n  AutoMM - ENABLED" 
      + "\n  Risk = " + DoubleToStr(AutoMM, 1) + "%";
   }
   ComSpacer = ComSpacer 
   + "\n  Trading Lots = " + DoubleToStr(LotSize, 2);
   ComSpacer = ComSpacer 
   + "\n -----------------------------------------------";
   if (UseStopLevels) {
      ComSpacer = ComSpacer 
      + "\n  Stop Levels - ENABLED";
   } else {
      ComSpacer = ComSpacer 
      + "\n  Stop Levels - DISABLED";
   }
      if (RecoveryMode) {
      ComSpacer = ComSpacer 
      + "\n  Recovery Mode - ENABLED";
   } else {
      ComSpacer = ComSpacer 
      + "\n  Recovery Mode - DISABLED";
   }
   ComSpacer = ComSpacer 
   + "\n -----------------------------------------------"
   + "\n" + txt
   + " -----------------------------------------------";
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

   Comment(ComSpacer);
   
   if (ObjectFind("LV") < 0) {
      ObjectCreate("LV", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("LV", "EA Angel", 9, "Tahoma Bold", White);
      ObjectSet("LV", OBJPROP_CORNER, 0);
      ObjectSet("LV", OBJPROP_BACK, FALSE);
      ObjectSet("LV", OBJPROP_XDISTANCE, 13);
      ObjectSet("LV", OBJPROP_YDISTANCE, 23);
   }
   if (ObjectFind("BKGR") < 0) {
      ObjectCreate("BKGR", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("BKGR", "g", 110, "Webdings", DarkViolet 	);
      ObjectSet("BKGR", OBJPROP_CORNER, 0);
      ObjectSet("BKGR", OBJPROP_BACK, TRUE);
      ObjectSet("BKGR", OBJPROP_XDISTANCE, 5);
      ObjectSet("BKGR", OBJPROP_YDISTANCE, 15);
   }
   if (ObjectFind("BKGR2") < 0) {
      ObjectCreate("BKGR2", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("BKGR2", "g", 110, "Webdings", MidnightBlue);
      ObjectSet("BKGR2", OBJPROP_BACK, TRUE);
      ObjectSet("BKGR2", OBJPROP_XDISTANCE, 5);
      ObjectSet("BKGR2", OBJPROP_YDISTANCE, 60);
   }
   if (ObjectFind("BKGR3") < 0) {
      ObjectCreate("BKGR3", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("BKGR3", "g", 110, "Webdings", MidnightBlue);
      ObjectSet("BKGR3", OBJPROP_CORNER, 0);
      ObjectSet("BKGR3", OBJPROP_BACK, TRUE);
      ObjectSet("BKGR3", OBJPROP_XDISTANCE, 5);
      ObjectSet("BKGR3", OBJPROP_YDISTANCE, 45);
   }
   if (ObjectFind("BKGR4") < 0) {
      ObjectCreate("BKGR4", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("BKGR4", "g", 110, "Webdings", MidnightBlue);
      ObjectSet("BKGR4", OBJPROP_CORNER, 0);
      ObjectSet("BKGR4", OBJPROP_BACK, TRUE);
      ObjectSet("BKGR4", OBJPROP_XDISTANCE, 5);
      ObjectSet("BKGR4", OBJPROP_YDISTANCE, 154);//84
   }
}

//+--------------------------------------------------------------------------------------------------------------+
//| ErrorDescription. ���������� �������� ������ �� � ������.
//+--------------------------------------------------------------------------------------------------------------+
string ErrorDescription(int error) {
//+--------------------------------------------------------------------------------------------------------------+

   string ErrorNumber;
   //---
   switch (error) {
   case 0:
   case 1:     ErrorNumber = "��� ������, �� ��������� ����������";                        break;
   case 2:     ErrorNumber = "����� ������";                                               break;
   case 3:     ErrorNumber = "������������ ���������";                                     break;
   case 4:     ErrorNumber = "�������� ������ �����";                                      break;
   case 5:     ErrorNumber = "������ ������ ����������� ���������";                        break;
   case 6:     ErrorNumber = "��� ����� � �������� ��������";                              break;
   case 7:     ErrorNumber = "������������ ����";                                          break;
   case 8:     ErrorNumber = "������� ������ �������";                                     break;
   case 9:     ErrorNumber = "������������ �������� ���������� ���������������� �������";  break;
   case 64:    ErrorNumber = "���� ������������";                                          break;
   case 65:    ErrorNumber = "������������ ����� �����";                                   break;
   case 128:   ErrorNumber = "����� ���� �������� ���������� ������";                      break;
   case 129:   ErrorNumber = "������������ ����";                                          break;
   case 130:   ErrorNumber = "������������ �����";                                         break;
   case 131:   ErrorNumber = "������������ �����";                                         break;
   case 132:   ErrorNumber = "����� ������";                                               break;
   case 133:   ErrorNumber = "�������� ���������";                                         break;
   case 134:   ErrorNumber = "������������ ����� ��� ���������� ��������";                 break;
   case 135:   ErrorNumber = "���� ����������";                                            break;
   case 136:   ErrorNumber = "��� ���";                                                    break;
   case 137:   ErrorNumber = "������ �����";                                               break;
   case 138:   ErrorNumber = "����� ���� - ������";                                        break;
   case 139:   ErrorNumber = "����� ������������ � ��� ��������������";                    break;
   case 140:   ErrorNumber = "��������� ������ �������";                                   break;
   case 141:   ErrorNumber = "������� ����� ��������";                                     break;
   case 145:   ErrorNumber = "����������� ���������, ��� ��� ����� ������� ������ � �����";break;
   case 146:   ErrorNumber = "���������� �������� ������";                                 break;
   case 147:   ErrorNumber = "������������� ���� ��������� ������ ��������� ��������";     break;
   case 148:   ErrorNumber = "���������� �������� � ���������� ������� �������� ������� "; break;
   //---- 
   case 4000:  ErrorNumber = "��� ������";                                                 break;
   case 4001:  ErrorNumber = "������������ ��������� �������";                             break;
   case 4002:  ErrorNumber = "������ ������� - ��� ���������";                             break;
   case 4003:  ErrorNumber = "��� ������ ��� ����� �������";                               break;
   case 4004:  ErrorNumber = "������������ ����� ����� ������������ ������";               break;
   case 4005:  ErrorNumber = "�� ����� ��� ������ ��� �������� ����������";                break;
   case 4006:  ErrorNumber = "��� ������ ��� ���������� ���������";                        break;
   case 4007:  ErrorNumber = "��� ������ ��� ��������� ������";                            break;
   case 4008:  ErrorNumber = "�������������������� ������";                                break;
   case 4009:  ErrorNumber = "�������������������� ������ � �������";                      break;
   case 4010:  ErrorNumber = "��� ������ ��� ���������� �������";                          break;
   case 4011:  ErrorNumber = "������� ������� ������";                                     break;
   case 4012:  ErrorNumber = "������� �� ������� �� ����";                                 break;
   case 4013:  ErrorNumber = "������� �� ����";                                            break;
   case 4014:  ErrorNumber = "����������� �������";                                        break;
   case 4015:  ErrorNumber = "������������ �������";                                       break;
   case 4016:  ErrorNumber = "�������������������� ������";                                break;
   case 4017:  ErrorNumber = "������ DLL �� ���������";                                    break;
   case 4018:  ErrorNumber = "���������� ��������� ����������";                            break;
   case 4019:  ErrorNumber = "���������� ������� �������";                                 break;
   case 4020:  ErrorNumber = "������ ������� ������������ ������� �� ���������";           break;
   case 4021:  ErrorNumber = "������������ ������ ��� ������, ������������ �� �������";    break;
   case 4022:  ErrorNumber = "������� ������";                                             break;
   case 4050:  ErrorNumber = "������������ ���������� ���������� �������";                 break;
   case 4051:  ErrorNumber = "������������ �������� ��������� �������";                    break;
   case 4052:  ErrorNumber = "���������� ������ ��������� �������";                        break;
   case 4053:  ErrorNumber = "������ �������";                                             break;
   case 4054:  ErrorNumber = "������������ ������������� �������-���������";               break;
   case 4055:  ErrorNumber = "������ ����������������� ����������";                        break;
   case 4056:  ErrorNumber = "������� ������������";                                       break;
   case 4057:  ErrorNumber = "������ ��������� ����������� ����������";                    break;
   case 4058:  ErrorNumber = "���������� ���������� �� ����������";                        break;
   case 4059:  ErrorNumber = "������� �� ��������� � �������� ������";                     break;
   case 4060:  ErrorNumber = "������� �� ������������";                                    break;
   case 4061:  ErrorNumber = "������ �������� �����";                                      break;
   case 4062:  ErrorNumber = "��������� �������� ���� string";                             break;
   case 4063:  ErrorNumber = "��������� �������� ���� integer";                            break;
   case 4064:  ErrorNumber = "��������� �������� ���� double";                             break;
   case 4065:  ErrorNumber = "� �������� ��������� ��������� ������";                      break;
   case 4066:  ErrorNumber = "����������� ������������ ������ � ��������� ����������";     break;
   case 4067:  ErrorNumber = "������ ��� ���������� �������� ��������";                    break;
   case 4099:  ErrorNumber = "����� �����";                                                break;
   case 4100:  ErrorNumber = "������ ��� ������ � ������";                                 break;
   case 4101:  ErrorNumber = "������������ ��� �����";                                     break;
   case 4102:  ErrorNumber = "������� ����� �������� ������";                              break;
   case 4103:  ErrorNumber = "���������� ������� ����";                                    break;
   case 4104:  ErrorNumber = "������������� ����� ������� � �����";                        break;
   case 4105:  ErrorNumber = "�� ���� ����� �� ������";                                    break;
   case 4106:  ErrorNumber = "����������� ������";                                         break;
   case 4107:  ErrorNumber = "������������ �������� ���� ��� �������� �������";            break;
   case 4108:  ErrorNumber = "�������� ����� ������";                                      break;
   case 4109:  ErrorNumber = "�������� �� ���������";                                      break;
   case 4110:  ErrorNumber = "������� ������� �� ���������";                               break;
   case 4111:  ErrorNumber = "�������� ������� �� ���������";                              break;
   case 4200:  ErrorNumber = "������ ��� ����������";                                      break;
   case 4201:  ErrorNumber = "��������� ����������� �������� �������";                     break;
   case 4202:  ErrorNumber = "������ �� ����������";                                       break;
   case 4203:  ErrorNumber = "����������� ��� �������";                                    break;
   case 4204:  ErrorNumber = "��� ����� �������";                                          break;
   case 4205:  ErrorNumber = "������ ��������� �������";                                   break;
   case 4206:  ErrorNumber = "�� ������� ��������� �������";                               break;
   case 4207:  ErrorNumber = "������ ��� ������ � ��������";                               break;
   default:    ErrorNumber = "����������� ������";
   }
   //---
   return (ErrorNumber);
}

void SetStops() {
//+--------------------------------------------------------------------------------------------------------------+
   if (!UseStopLevels) return;
   int trade = OrdersTotal() - 1; double TP, SL, OrderTP, OrderSL;

   for (int i = trade; i >= 0; i--) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderMagicNumber() == MagicNumber && OrderSymbol() == EASymbol) {
         double OpenPrice = OrderOpenPrice(); int OpType = OrderType();
         OrderTP = NormalizeDouble (TakeProfit * pp , pd); //--- ����������� ����-������ � ��� Points
         OrderSL = NormalizeDouble (StopLoss * pp , pd); //--- ����������� ����-���� � ��� Points

         if (OpType == OP_BUY) {
               //--- ���� ������� �������, ��
            TP = NormalizeDouble(OpenPrice + OrderTP, Digits); //--- �� ����������� ����-������
            SL = NormalizeDouble(OpenPrice - OrderSL, Digits); //--- � ����-����
         } else if (OpType == OP_SELL){
               //--- ���� �������� �������, ��   
            TP = NormalizeDouble(OpenPrice - OrderTP, Digits);
            SL = NormalizeDouble(OpenPrice + OrderSL, Digits);
         }
         if (TakeProfit==0) TP=0; if (StopLoss==0) SL=0;
         if ((OrderStopLoss()==0 && SL>0) || (OrderTakeProfit()==0 && TP>0)) 
           bool OrderModif = OrderModify(OrderTicket(), OpenPrice, SL, TP, OrderExpiration());
      }
   }
   //---
}


