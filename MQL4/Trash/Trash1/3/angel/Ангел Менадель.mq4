//+------------------------------------------------------------------+
//|                                               Ангел Менадель.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//Менадель — Ангел постоянства и стабильности. 
//Люди под покровительством этого Ангела обычно тесно связаны с прошлым,
// с семейными или территориальными корнями, они спокойны и уравновешенны.
// Любые формы подмены этих понятий для них неуместны и могут вести к неблагоприятным последствиям.
// Они верны определенной идее в жизни, даже если вокруг них все рушится;
// стараются передавать свои знания из поколения в поколение.
// Менадель и с ним Бог словно перемешивают карты судеб.
// Создатель пребывает в постоянном движении, в состоянии беспрерывной динамики,
// где человек играет роль «усилителя», а Ангел в свою очередь стремится прежде всего к спасению нашей души.
// Однако есть мнение, что существование Менаделя очевидно противоречит науке об Ангелах. 
//Это Ангел, который стремится привить нам чувство спокойствия, неподвижности в широком смысле слова.
// Тем не менее Божественные планы не могут быть осуществимы без движения вперед;
// оно необходимо не для того, чтобы разрушать, а для того, чтобы достигнуть уравновешенности — покоя и спокойствия в мире.
// Самобытность не может возникнуть ниоткуда и уйти в никуда в соответствии с неизменным консерватизмом мироздания,
// распределение коего может повлечь дисгармонию. Не ждите момента, когда вы окажетесь на последней стадии «разложения»,
// чтобы обратиться за помощью к Менаделю, особенно если это касается любовных отношений.
// Еще раз повторим: его действия предполагают в равной степени настоящую работу над вами и вашим ближайшим окружением,
// без которой существенный результат неосуществим. Менадель позволяет найти то, что мы потеряли (порой в другой форме),
// например: любовь, жизненное предназначение или цель. 
//Однако надо заметить, что наш Ангел-хранитель не выступает в роли духа, находящегося в услужении!
// Менадель может принести весть о человеке, которого мы давно потеряли из вида, он может быть просто другом,
// родственником или проявляться отголоском любви прошлых лет…

#property copyright "Copyright ©  Mobidic"
#property link      "Copyright ©  Ангел Менадель"

//+--------------------------------------------------------------------------------------------------------------+
//|    
//| 
//|   EURUSD, GBPUSD, USDCHF, USDJPY, USDCAD.  M15.  
//|  
//|  
//+--------------------------------------------------------------------------------------------------------------+

//+--------------------------------------------------------------------------------------------------------------+
//| Основные входные параметры. Тейк-профит, стоп-лосс, вывод в безубыток и размер лота.
//+--------------------------------------------------------------------------------------------------------------+

extern string Name = " Ангел Менадель ";
extern string Copy = "Copyright © Mobidic&virginiagreco@libero.it";
extern string Op2 = "Оптимизация для пары";
extern string Symbol_Op = "GBPUSD m15";
extern string Op = "Дата оптимизации";
extern datetime Date = D'12.12.2900'; //--- Сделал чисто для себя, чтобы видеть от какой даты оптимизация (дата забивается вручную)
extern string _TP = "Основные входные параметры";
//---
extern int TakeProfit = 1000; //--- (10 2 60)
extern int StopLoss = 40; //--- (100 10 200)
extern bool UseStopLevels = TRUE; //--- Включение стоповых ордеров. Если выключена, то работают только виртуальные тейки и лоссы.
//---
extern int SecureProfit = 5; //--- (0 1 5) Вывод в безубыток
extern int SecureProfitTriger = 30; //--- (10 2 30)
extern int MaxLossPoints = -200; //--- (-200 5 -20) Максимальная просадка для закрытия ордеров Buy и Sell при изменении сигнала (При просадке равной от - MaxLossPoints или меньше (например прибыль 0), ордер закроется)
//+--------------------------------------------------------------------------------------------------------------+
extern string  s2                   =  "======================================================="; 
extern string  parameters_trailing  = "0-off  1-Candle  2-Fractals  3-Velocity  4-Parabolic  >4-pips";
extern int     TrailingStopLoss     = 5;      // тралл убыточных сделок, если 0 off 
extern int     TrailingStopProfit   = 1;      // тралл прибыльных сделок, если 0 off 
extern int     StepTrall            = 100;      // шаг тралла - перемещать стоплосс не ближе чем StepTrall (step Thrall, moving not less than StepTrall n )
extern int     delta                = 0;      // отступ от фрактала свечи и др. (offset from the fractal or candles or Parabolic )
extern bool    only_Profit          = true;   // только перевод в безубыток без тралла (sweep only profitable orders )
extern bool    only_SL              = false;  // тралл только тех ордеров у которых установлен стоплосс (sweep only those orders that already have SL )
extern bool    SymbolAll            = false;  // тралл всех символов не только текущего окна (trail all the tools )
extern bool    GeneralNoLoss        = false;   // трал от портфельного профита ордеров (on general profitsextern )
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
extern string _MM = "Настройка MM";
//---
extern bool RecoveryMode = FALSE; //--- Включение режима восстановления депозита (увеличение лота если случился стоп-лосс)
extern double FixedLot = 0.1; //--- Фиксированный объём лота
extern double AutoMM = 3.0; //--- ММ включается если AutoMM > 0. Процент риска. При RecoveryMode = FALSE, менять нужно только это значение.
//--- При AutoMM = 20 и депозите в 1000$, лот будет равен 0,2. Далее лот будет увеличиваться исходя из свободных средств, то есть уже при депозите в 2000$ лот будет равен 0,4.
extern double AutoMM_Max = 5.0; //--- Максимальный риск
extern int MaxAnalizCount = 50; //--- Число закрытых ранее ордеров для анализа(Используется при RecoveryMode = True)
extern double Risk = 3.0; //--- Риск от депозита (Используется при RecoveryMode = True)
extern double MultiLotPercent = 6.1; //--- Коэффициент умножение лота (Используется при RecoveryMode = True)

//+--------------------------------------------------------------------------------------------------------------+
//| Периоды индикаторов. Кол-во баров для каждого индикатора.
//+--------------------------------------------------------------------------------------------------------------+

extern string _Periods = "Периоды индикаторов";

//--- Периоды индикаторов (Тоже можно будет заоптить, так как для каждой пары свои)
extern int iMA_Period = 71; //--- (60 5 100)
extern int iCCI_Period = 35; //--- (10 2 30)
extern int iATR_Period = 37; //--- (10 2 30) (!) Можно не оптить
extern int iWPR_Period = 12; //--- (10 1 20)

//+--------------------------------------------------------------------------------------------------------------+
//| Настройки из DLL
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
//| Параметры оптимизации для правил открытия и закрытия позиции.
//+--------------------------------------------------------------------------------------------------------------+
extern string _Add_Op = "Расширенные параметры оптимизации";
//---
extern string _AddOpenFilters = "---";
//---
extern int FilterATR = 6; //--- (0 1 10) Проверка на вход по ATR для Buy и Sell (if (iATR_Signal <= FilterATR * pp) return (0);) (!) Можно не оптить
extern double iCCI_OpenFilter = 360; //--- (100 10 400) Фильтр по iCCI для Buy и Sell. При оптимизации под JPY рекомендуемо оптить по правилу (100 50 4000)
//---
extern string _OpenOrderFilters = "---";
//---
extern int iMA_Filter_Open_a = 53; //--- (4 2 20) Фильтр МА для открытия Buy и Sell (Пунты)
extern int iMA_Filter_Open_b = 5; //--- (14 2 50) Фильтр МА для открытия Buy и Sell (Пунты)
extern int iWPR_Filter_Open_a = -99; //--- (-100 1 0) Фильтр WPR для открытия Buy и Sell
extern int iWPR_Filter_Open_b = -94; //--- (-100 1 0) Фильтр WPR для открытия Buy и Sell
//---
extern string _CloseOrderFilters = "---";
//---
extern int Price_Filter_Close = 85; //--- (10 2 20) Фильтр цены открытия для закрытия Buy и Sell (Пунты)
extern int iWPR_Filter_Close = -5; //--- (0 1 -100) Фильтр WPR для закрытия Buy и Sell

//+--------------------------------------------------------------------------------------------------------------+
//| Расширенные настройки
//+--------------------------------------------------------------------------------------------------------------+

extern string _Add = "Расширенные настройки";
extern bool LongTrade = TRUE; //--- Выключатель длинных позиций
extern bool ShortTrade = TRUE; //--- Выключатель коротких позиций
extern int MagicNumber = 33315;
extern double MaxSpread = 15;
extern double Slippage = 2;
extern bool WriteLog = TRUE; //--- //--- Включение всплывающих окон в терминале.
extern bool WriteDebugLog = TRUE; //--- Включение всплывающих окон об ошибках в терминале.
extern bool PrintLogOnChart = TRUE; //--- Включение комментариев на графике (при тестировании выключается автоматически)
extern bool HideTestInd = true;

//+--------------------------------------------------------------------------------------------------------------+
//| Блок дополнительных переменных
//+--------------------------------------------------------------------------------------------------------------+

double pp;
int pd;
double cf;
string EASymbol; //--- Текущий символ
double CloseSlippage = 3; //--- Проскальзывание для закрытия ордера
int SP;
int CloseSP;
int MaximumTrades = 1;
double NDMaxSpread; //--- Максимальный спред ввиде пунктов
bool CheckSpreadRule; //--- Правило для проверки спреда перед открытием (Останавливает зацикливание сообщений о превышенном спреде)
string OpenOrderComment = "Ангел Менадель";
int RandomOpenTimePercent = 0; //--- Используется при занятом потоке комманд терминала, своебразная рендомная пауза. Выражается в секундах.
//---

//--- Параметры для автолота
double MinLot = 0.01;
double MaxLot = 0.01;
double LotStep = 0.01;
int LotValue = 100000;
double FreeMargin = 1000.0;
double LotPrice = 1;
double LotSize;

//--- Параметры на открытие

int iWPR_Filter_OpenLong_a;
int iWPR_Filter_OpenLong_b;
int iWPR_Filter_OpenShort_a;
int iWPR_Filter_OpenShort_b;

//--- Параметры на закрытие

int iWPR_Filter_CloseLong;
int iWPR_Filter_CloseShort;

//---
color OpenBuyColor = Blue;
color OpenSellColor = Red;
color CloseBuyColor = DodgerBlue;
color CloseSellColor = DeepPink;
//---
bool SoundAlert = FALSE; //--- Звуковое оповещение об открытии/закрытии сделки
string SoundFileAtOpen = "alert.wav";
string SoundFileAtClose = "alert.wav";
int Dist = 1; //--- Дополнительный фильтр проверки цены после открытия ордера.
bool OpenAddOrderRule = FALSE; //--- При включении данной торговли новые ордера не будут не будут открываться. Необходима если вы решили остановить торговлю, но не хотите чтобы советник терял открытые им ордера.
//---
int  STOPLEVEL,n,DIGITS;
double BID,ASK,POINT;
string  SymbolTral,TekSymbol;
string txt;
//+--------------------------------------------------------------------------------------------------------------+
//| INIT. Инициализация некоторых переменных, удаление объектов на графике.
//+--------------------------------------------------------------------------------------------------------------+
void init() {
//+--------------------------------------------------------------------------------------------------------------+
   
   //---
   if (IsTesting() && !IsVisualMode()) PrintLogOnChart = FALSE; //--- Если тестируем, то отключаются комментарии на графике
   if (!PrintLogOnChart) Comment("EA Angel");
   //---
   EASymbol = Symbol(); //--- Инициализация текущено символа
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
   SP = Slippage * MathPow(10, Digits - pd); //--- Расчет проскальзывания цены для пятизнака
   CloseSP = CloseSlippage * MathPow(10, Digits - pd);
   NDMaxSpread = NormalizeDouble(MaxSpread * pp, pd + 1); //--- Преобразование значения MaxSpread в пункты
   //---
   if (ObjectFind("BKGR") >= 0) ObjectDelete("BKGR");
   if (ObjectFind("BKGR2") >= 0) ObjectDelete("BKGR2");
   if (ObjectFind("BKGR3") >= 0) ObjectDelete("BKGR3");
   if (ObjectFind("BKGR4") >= 0) ObjectDelete("BKGR4");
   if (ObjectFind("LV") >= 0) ObjectDelete("LV");
   //---
   
   //--- Инициализация параметров для MM
   
   MinLot = MarketInfo(Symbol(), MODE_MINLOT);
   MaxLot = MarketInfo(Symbol(), MODE_MAXLOT);
   LotValue = MarketInfo(Symbol(), MODE_LOTSIZE);
   LotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
   FreeMargin = MarketInfo(Symbol(), MODE_MARGINREQUIRED);
   
   //--- Получение значения стоимости лота конкретного символа исходя из парамтеров вашего брокера.
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
   
   //--- Параметры на открытие
   
   iWPR_Filter_OpenLong_a = iWPR_Filter_Open_a;
   iWPR_Filter_OpenLong_b = iWPR_Filter_Open_b;
   iWPR_Filter_OpenShort_a = -100 - iWPR_Filter_Open_a;
   iWPR_Filter_OpenShort_b = -100 - iWPR_Filter_Open_b;

   //--- Параметры на закрытие
   
   iWPR_Filter_CloseLong = iWPR_Filter_Close;
   iWPR_Filter_CloseShort = -100 - iWPR_Filter_Close;
   
   //---
   //return (0);
   
}

//+--------------------------------------------------------------------------------------------------------------+
//| DEINIT. Удаление объектов на графике.
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
//| START. Проверка на ошибки, а также старт функции Scalper.
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
   if (PrintLogOnChart) ShowComments (); //--- Включение комментариев на графике
   //---
   SetStops();
   CloseOrders(); //--- Сопровождение ордеров
   ModifyOrders(); //--- Вывод в безубыток
   
   //--- Инициализация объёма сдеки
   if (AutoMM > 0.0 && (!RecoveryMode)) LotSize = MathMax(MinLot, MathMin(MaxLot, MathCeil(MathMin(AutoMM_Max, AutoMM) / LotPrice / 100.0 * AccountFreeMargin() / LotStep / (LotValue / 100)) * LotStep));
   if (AutoMM > 0.0 && RecoveryMode) LotSize = CalcLots(); //--- Если включен RecoveryMode используем CalcLots
   if (AutoMM == 0.0) LotSize = FixedLot;
   
   //--- Проверка наличия исторических данных для таймфрейма M15
   if(iBars(Symbol(), PERIOD_M15) < iMA_Period || iBars(Symbol(), PERIOD_M15) < iWPR_Period || iBars(Symbol(), PERIOD_M15) < iATR_Period || iBars(Symbol(), PERIOD_M15) < iCCI_Period)
   {
      Print("Недостаточно исторических данных для торговли");
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
//| Scalper. Основная функция. Сначало производится проверка спреда, далее проверка сигналов на вход.
//+--------------------------------------------------------------------------------------------------------------+
void Scalper() {
//+--------------------------------------------------------------------------------------------------------------+
    
   //--- Сообщение о превышенном спреде
   if (MaxSpreadFilter()) {
      if (!CheckSpreadRule && WriteDebugLog) {
         //---
         Print("Торговый сигнал пропущен из-за большого спреда.");
         Print("Текущий спред = ", DoubleToStr((Ask - Bid) / pp, 1), ",  MaxSpread = ", DoubleToStr(MaxSpread, 1));
         Print("Эксперт будет пробовать позже, когда спред станет допустимым.");
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
   } //--- Закрытие if (MaxSpreadFilter)
}

//+--------------------------------------------------------------------------------------------------------------+
//| OpenPosition. Функция открытия позиции.
//+--------------------------------------------------------------------------------------------------------------+
int OpenPosition(int OpType) {
//+--------------------------------------------------------------------------------------------------------------+

   int RandomOpenTime; //--- Задержка по времени на открытие
   double DistLevel; //--- Цена покупки или продажи. Необходима для проверки дистанции открытия
   color OpenColor; //--- Цвет открытия позиции. Если Buy то голубая, если Sell то красная
   int OpenOrder; //--- Открытие позиции
   int OpenOrderError; //--- Ошибка открытия
   string OpTypeString; //--- Преобразования вида позиции в текстовое значение
   double OpenPrice; //--- Цена открытия
   //---
   double TP, SL;
   double OrderTP = NormalizeDouble (TakeProfit * pp , pd); //--- Преобразуем тейк-профит в вид Points
   double OrderSL = NormalizeDouble (StopLoss * pp , pd); //--- Преобразуем стоп-лосс в вид Points
     
   //--- Задержка в секундах между открытиями
   if (RandomOpenTimePercent > 0) {
      MathSrand(TimeLocal());
      RandomOpenTime = MathRand() % RandomOpenTimePercent;
      
      if (WriteLog) {
      Print("DelayRandomiser: задержка ", RandomOpenTime, " секунд.");
      }
      
      Sleep(1000 * RandomOpenTime);
   } //--- Закрытие if (RandomOpenTimePerc
   
   double OpenLotSize = LotSize; //--- Расчет объёма позиции
   
   //--- Если не хватет средств, возвращаем ошибку
   if (AccountFreeMarginCheck(EASymbol, OpType, OpenLotSize) <= 0.0 || GetLastError() == 134/* NOT_ENOUGH_MONEY */) {
      //---
      if (WriteDebugLog) {
      //---
         Print("Для открытия ордера недостаточно свободной маржи.");
         Comment("Для открытия ордера недостаточно свободной маржи.");
      //---
      }
      return (-1);
   } //--- Закрытие if (AccountFreeMarginCheck  
   
   RefreshRates();
   
   //--- Если длинная позиция, то
   if (OpType == OP_BUY) {
      OpenPrice = NormalizeDouble(Ask, Digits);
      OpenColor = OpenBuyColor;
      
      //---
      if (UseStopLevels) { //--- Если включены стоп-уровни (стоп-лосс и тейк-профит)
      
      TP = NormalizeDouble(OpenPrice + OrderTP, Digits); //--- То расчитывает тейк-профит
      SL = NormalizeDouble(OpenPrice - OrderSL, Digits); //--- и стоп-лосс
      //---
      } else {TP = 0; SL = 0;}
   
   //--- Если короткая позиция, то   
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
   
   int MaximumTradesCount = MaximumTrades; //--- Счетчик открытых позиций
   while (MaximumTradesCount > 0 && OpenTradeCount()) { //--- Если MaximumTrades равно хотябы 1-му, то происходит открытие
      //---
      OpenOrder = OrderSend(EASymbol, OpType, OpenLotSize, OpenPrice, SP, SL, TP, OpenOrderComment, MagicNumber, 0, OpenColor);
      //---
      Sleep(MathRand() / 1000); //--- Задержка в несколько секунд после открытия
      //---
      if (OpenOrder < 0) { //--- Если ордер не открылся, то
         OpenOrderError = GetLastError(); //--- Возвращаем ошибку
         //---
         if (WriteDebugLog) {
            if (OpType == OP_BUY) OpTypeString = "OP_BUY";
            else OpTypeString = "OP_SELL";
            Print("Открытие: OrderSend(", OpTypeString, ") ошибка = ", ErrorDescription(OpenOrderError)); //--- Код ошибки на Русском
         } //--- Закрытие if (WriteDebugLog)
         
         //---
         if (OpenOrderError != 136/* OFF_QUOTES */) break; //--- Если нет цен, то прекращаем цикл
         if (!(OpenAddOrderRule)) break; //--- Если нет разрешения на открытие позиции, то прекращаем цикл
         //---
         Sleep(6000); //--- Делаем паузу
         RefreshRates(); //--- и обновляем котировки
         //---
         if (OpType == OP_BUY) DistLevel = NormalizeDouble(Ask, Digits); //--- Получаем новые цены покупки и продажи
         else DistLevel = NormalizeDouble(Bid, Digits);
         //---
         if (NormalizeDouble(MathAbs((DistLevel - OpenPrice) / pp), 0) > Dist) break; //--- Вначале возвращает абсолютное значение разницы между текущим курсом и ценой открытия, далее сравнивает полученное с значение со значением переменной Dist
         //---
         OpenPrice = DistLevel; //--- Получаем новое значение OpenPrice
         MaximumTradesCount--; //--- И вычитаем -1 из счетчика MaximumTrades
         
         //--- Если счетчик больше нуля, то выдаем сообщение о том, что можно открыть ордер.
         if (MaximumTradesCount > 0) {
            if (WriteLog) {
            Print("... Возможно открыть ордер.");
         } } //--- Закрытие if (MaximumTradesCount
         //---
         } //--- Закрытие if (OpenOrder < 0)
         
         //--- А, если же OpenOrder > 0, то 
         else {
         if (OrderSelect(OpenOrder, SELECT_BY_TICKET)) OpenPrice = OrderOpenPrice();
         //---
         if (!(SoundAlert)) break; //--- Проигрываение звука, если он включен
         PlaySound(SoundFileAtOpen);
         break;
      } //--- Закрытие else { при OpenOrder > 0
   } //--- Закрытие цикла while (MaximumTradesCount > 0)
   //---
   return (OpenOrder);
}

//+--------------------------------------------------------------------------------------------------------------+
//| ModifyOrders. Модификация ордеров в безубыток.
//+--------------------------------------------------------------------------------------------------------------+
void ModifyOrders() {
//+--------------------------------------------------------------------------------------------------------------+

   bool TicketModify; //--- Закрытие ордера
   int total = OrdersTotal() - 1;
   int ModifyError = GetLastError();
   int ModifyTicketID = OrderTicket();
   string ModifyOrderType = OrderType();
   //---
   for (int i = total; i >= 0; i--) { //--- Счетчик открытых ордеров
      if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         if (WriteDebugLog) Print("Произошла ошибка во время выборки ордера. Причина: ", ErrorDescription(ModifyError));
      
      } else {
      
      //--- Модификация ордера на покупку
      if (OrderType() == OP_BUY) {
         if (OrderMagicNumber() == MagicNumber && OrderSymbol() == EASymbol) {
            if (Bid - OrderOpenPrice() > SecureProfitTriger * pp && MathAbs(OrderOpenPrice() + SecureProfit * pp - OrderStopLoss()) >= Point) {
            //--- Модифицируем ордер
            TicketModify = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice() + SecureProfit * pp, Digits), OrderTakeProfit(), 0, Blue);
            if (!TicketModify)
               if (WriteDebugLog) Print("Произошла ошибка во время модификации ордера (", ModifyOrderType, ",", ModifyTicketID, "). Причина: ", ErrorDescription(ModifyError));
            }
         }
      } //--- Закрытие if (OrderType() == OP_BUY)
      
      //--- Модификация ордера на продажу
      if (OrderType() == OP_SELL) {
         if (OrderMagicNumber() == MagicNumber && OrderSymbol() == EASymbol) {
            if (OrderOpenPrice() - Ask > SecureProfitTriger * pp && MathAbs(OrderOpenPrice() - SecureProfit * pp - OrderStopLoss()) >= Point) {
            //--- Модифицируем ордер
            TicketModify = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice() - SecureProfit * pp, Digits), OrderTakeProfit(), 0, Red);
            if (!TicketModify)
               if (WriteDebugLog) Print("Произошла ошибка во время модификации ордера (", ModifyOrderType, ",", ModifyTicketID, "). Причина: ", ErrorDescription(ModifyError));
               
               }
            }
         } //--- Закрытие if (OrderType() == OP_SELL)
      }
   } //--- Закрытие for (int i = total - 1; i >= 0; i--)
}

//+--------------------------------------------------------------------------------------------------------------+
//| CloseTrades. Виртуальный тейк-профит и стоп-лосс.
//| Если включена функция UseStopLevels, то используется как функция резервного закрытия.
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
   for (int i = total; i >= 0; i--) { //--- Счетчик открытых ордеров
      if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         if (WriteDebugLog) Print("Произошла ошибка во время выборки ордера. Причина: ", ErrorDescription(CloseError));
      
      } else {
      
      //--- Закрытие по профиту или лоссу ордеров на покупку
      if (OrderType() == OP_BUY) {
      OpenLongOrdersCount++;
         if (OrderMagicNumber() == MagicNumber && OrderSymbol() == EASymbol) {
            if (Bid >= OrderOpenPrice() + TakeProfit * pp || Bid <= OrderOpenPrice() - StopLoss * pp || CloseLongSignal(OrderOpenPrice(), ExistPosition())) {
               //---
               for (int MinCount = 1; MinCount <= MathMax(1, MaxCount); MinCount++) {
               RefreshRates();
               if (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), CloseSP, CloseBuyColor)) {
               OpenLongOrdersCount--; //--- Обнуляем счетчик
               break;
               //---        
               } else {
               if (WriteDebugLog) Print("Произошла ошибка во время закрытия ордера (",CloseOrderType, ",", CloseTicketID, "). Причина: ", ErrorDescription(CloseError));
                  }
               //---
               }
            }
         }
      } //--- Закрытие if (OrderType() == OP_BUY)
      
      //--- Закрытие по профиту или лоссу ордеров на продажу
      if (OrderType() == OP_SELL) {
      OpenShortOrdersCount++;
         if (OrderMagicNumber() == MagicNumber && OrderSymbol() == EASymbol) {
            if (Ask <= OrderOpenPrice() - TakeProfit * pp || Ask >= OrderOpenPrice() + StopLoss * pp || CloseShortSignal(OrderOpenPrice(), ExistPosition())) {
               //---
               for (MinCount = 1; MinCount <= MathMax(1, MaxCount); MinCount++) {
               RefreshRates();
               if (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), CloseSP, CloseSellColor)) {
               OpenShortOrdersCount--; //--- Обнуляем счетчик
               break;
               //---
               } else {
                  if (WriteDebugLog) Print("Произошла ошибка во время закрытия ордера (",CloseOrderType, ",", CloseTicketID, "). Причина: ", ErrorDescription(CloseError));
                     }
                 //---
                  }
               }
            }
         } //--- Закрытие if (OrderType() == OP_SELL)
      } 
   } //--- Закрытие for (int i = total - 1; i >= 0; i--) {
}

//+--------------------------------------------------------------------------------------------------------------+
//| OpenLongSignal. Сигнал на открытие длинной позиции.
//+--------------------------------------------------------------------------------------------------------------+
bool OpenLongSignal() {
//+--------------------------------------------------------------------------------------------------------------+

bool result = false;
bool result1 = false;
bool result2 = false;
bool result3 = false;

//--- Расчет основных сигналов на вход
double iClose_Signal = iClose(NULL, PERIOD_M15, 1);
double iMA_Signal = iMA(NULL, PERIOD_M15, iMA_Period, 0, MODE_SMMA, PRICE_CLOSE, 1);
double iWPR_Signal = iWPR(NULL, PERIOD_M15, iWPR_Period, 1);
double iATR_Signal = iATR(NULL, PERIOD_M15, iATR_Period, 1);
double iCCI_Signal = iCCI(NULL, PERIOD_M15, iCCI_Period, PRICE_TYPICAL, 1);
//---
double iMA_Filter_a = NormalizeDouble(iMA_Filter_Open_a*pp,pd);
double iMA_Filter_b = NormalizeDouble(iMA_Filter_Open_b*pp,pd);
double BidPrice = Bid; //--- (iClose_Signal >= BidPrice) Сравнение идёт именно с Bid (а не с Ask, как должно быть), так как цена закрытия свечи iClose_Signal формируется на основании значения Bid
//---

//--- Сверяем сигнал по АТР с его фильтром
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
//| OpenShortSignal. Сигнал на открытие короткой позиции.
//+--------------------------------------------------------------------------------------------------------------+
bool OpenShortSignal() {
//+--------------------------------------------------------------------------------------------------------------+

bool result = false;
bool result1 = false;
bool result2 = false;
bool result3 = false;

//--- Расчет основных сигналов на вход
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

//--- Сверяем сигнал по АТР с его фильтром
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
//| CloseLongSignal. Сигнал на закрытие длинной позиции.
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
//| CloseShortSignal. Сигнал на закрытие короткой позиции.
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
//| CalcLots. Функция расчета обьема лота.
//| При AutoMM > 0.0 && RecoveryMode функция CalcLots расчитывает объём лота относительно свободных средств.
//| 
//| Также расчет лота производиться исходя из числа открытых в прошлом ордеров. То есть увеличение лота теперь
//| зависит не только от свободных средств, но и от числа открытых в прошлом советником ордеров.
//| 
//| Помимо простого ММ, функция рассчитывает лот исходя из произошедших ранее стоп-лоссов при включенном
//| параметре RecoveryMode, то есть, при желании можно включить режим восстановления депозита.
//+--------------------------------------------------------------------------------------------------------------+
double CalcLots() {
//+--------------------------------------------------------------------------------------------------------------+

   double SumProfit; //--- Суммарный профит
   int OldOrdersCount; //--- Текущее кол-во закрытых советником ордеров
   double loss; //--- Просадка
   int LossOrdersCount; //--- Число лосей в прошлом
   double pr; //--- Профит
   int ProfitOrdersCount; //--- Кол-во прибыльных ордеров ы прошлом
   double LastPr; //--- Предыдущее значение профит
   int LastCount; //--- Предыдущее значение счетчика ордеров
   double MultiLot = 1; //---  Обнуление значения умножения лота
   //---
   
   //--- Если ММ включен, то
   if (MultiLotPercent > 0.0 && AutoMM > 0.0) {
      
      //--- Обнуляем значения
      SumProfit = 0;
      OldOrdersCount = 0;
      loss = 0;
      LossOrdersCount = 0;
      pr = 0;
      ProfitOrdersCount = 0;
      //---
      
      //--- Выбираем закрытие ранее ордера
      for (int i = OrdersHistoryTotal() - 1; i >= 0; i--) {
         if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) {
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
               OldOrdersCount++; //--- Считаем ордера
               SumProfit += OrderProfit(); //--- и суммарный профит
               
               //--- Если суммарный профит больше pr (для начала больше 0)
               if (SumProfit > pr) {
                  //--- Инициализируем профит и счетчик прибыльных ордеров
                  pr = SumProfit;
                  ProfitOrdersCount = OldOrdersCount;
               }
               //--- Если суммарный профит меньше loss (для начала больше 0)
               if (SumProfit < loss) {
                  //--- Инициализируем просадку и счетчик убыточных ордеров
                  loss = SumProfit;
                  LossOrdersCount = OldOrdersCount;
               }
               //--- Если текущее кол-во подсчитанных ордеров больше или равно MaxAnalizCount (50), то в будущем считаем только свеженькие ордера а старые вычитаем.
               if (OldOrdersCount >= MaxAnalizCount) break;
            }
         }
      } //--- Закрытие for (int i = OrdersHistoryTotal() - 1; i >= 0; i--) {
      
      
      //--- Если число прибыльных ордеров меньше или равно числу лосей, то расчитываем значение умножения лота MultiLot
      if (ProfitOrdersCount <= LossOrdersCount) MultiLot = MathPow(MultiLotPercent, LossOrdersCount);
      
      //--- Если нет, то
      else {
         
         //--- Инициализируем параметры по профиту
         SumProfit = pr;
         OldOrdersCount = ProfitOrdersCount;
         LastPr = pr;
         LastCount = ProfitOrdersCount;
         
         //--- Выбираем закрытие ранее ордера (минус число прибыльных ордеров)
         for (i = OrdersHistoryTotal() - ProfitOrdersCount - 1; i >= 0; i--) {
            if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) {
               if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
                  //--- Если выбрано более 50 ордеров прекразщаем выбирать
                  if (OldOrdersCount >= MaxAnalizCount) break;
                  //---
                  OldOrdersCount++; //--- Считаем кол-во ордеров
                  SumProfit += OrderProfit(); //--- и профит
                  
                  //--- Если новый профит меньше предыдущего (LastPr), то
                  if (SumProfit < LastPr) {
                     //--- Переинициализируем значения профита и кол-во ордеров
                     LastPr = SumProfit;
                     LastCount = OldOrdersCount;
                  }
               }
            }
         } //--- Закрытие for (i = OrdersHistoryTotal() - ProfitOrdersCount - 1; i >= 0; i--) {
         
         //--- Если значение счетчика LastCount равно счетчику прибыльных ордеров или прошлый профит равен текщему, то
         if (LastCount == ProfitOrdersCount || LastPr == pr) MultiLot = MathPow(MultiLotPercent, LossOrdersCount); //--- расчитываем значение умножения лота MultiLot
         
         //--- Если нет, то
         else {
            //--- Делим положительный (loss - pr) на положительный (LastPr - pr) и сравниваем с риском, после расчитываем умножение лота MultiLot
            if (MathAbs(loss - pr) / MathAbs(LastPr - pr) >= (Risk + 100.0) / 100.0) MultiLot = MathPow(MultiLotPercent, LossOrdersCount);
            else MultiLot = MathPow(MultiLotPercent, LastCount);
         }
      }
   } //--- Закрытие if (MultiLotPercent > 0.0 && AutoMM > 0.0) {
   
   //--- Получаем финальный объём лота, исходя из выполненных выше действий
   for (double OpLot = MathMax(MinLot, MathMin(MaxLot, MathCeil(MathMin(AutoMM_Max, MultiLot * AutoMM) / 100.0 * AccountFreeMargin() / LotStep / (LotValue / 100)) * LotStep)); OpLot >= 2.0 * MinLot &&
      1.05 * (OpLot * FreeMargin) >= AccountFreeMargin(); OpLot -= MinLot) {
   }
   return (OpLot);
}

//+--------------------------------------------------------------------------------------------------------------+
//| MaxSpreadFilter. Функция для расчета размера спреда и сравнения его со значением MaxSpread.
//| Если текущий спред превышен, то возвращаем TRUE.
//+--------------------------------------------------------------------------------------------------------------+
bool MaxSpreadFilter() {
//+--------------------------------------------------------------------------------------------------------------+

   RefreshRates();
   if (NormalizeDouble(Ask - Bid, Digits) > NDMaxSpread) return (TRUE);
   //---
   else return (FALSE);
}

//+--------------------------------------------------------------------------------------------------------------+
//| ExistPosition. Функция проверки открытых ордеров.
//| Если открыт ордер возвращает True, если нет, дает разрешение (False, 0) на открытие.
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
//| OpenTradeCount. Счетчик открытых ордеров. Если число открытых ордеров больше или равно MaximumTrades, то
//| идет запрет на торговлю.
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
//| ShowComments. Функция для отображения комментариев на графике.
//+--------------------------------------------------------------------------------------------------------------+
void ShowComments() {
//+--------------------------------------------------------------------------------------------------------------+

string ComSpacer = ""; //--- "/n"
datetime MyOpDate = TIME_DATE; //--- Вывод в комментарий даты оптимизации (формат)
//---
ComSpacer = ComSpacer
      + "\n  " 
      + "\n "
      + "\n  EA Angel "
      + "\n  Copyright ©  forexeapro.com "  
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
//| ErrorDescription. Возвращает описание ошибки по её номеру.
//+--------------------------------------------------------------------------------------------------------------+
string ErrorDescription(int error) {
//+--------------------------------------------------------------------------------------------------------------+

   string ErrorNumber;
   //---
   switch (error) {
   case 0:
   case 1:     ErrorNumber = "Нет ошибки, но результат неизвестен";                        break;
   case 2:     ErrorNumber = "Общая ошибка";                                               break;
   case 3:     ErrorNumber = "Неправильные параметры";                                     break;
   case 4:     ErrorNumber = "Торговый сервер занят";                                      break;
   case 5:     ErrorNumber = "Старая версия клиентского терминала";                        break;
   case 6:     ErrorNumber = "Нет связи с торговым сервером";                              break;
   case 7:     ErrorNumber = "Недостаточно прав";                                          break;
   case 8:     ErrorNumber = "Слишком частые запросы";                                     break;
   case 9:     ErrorNumber = "Недопустимая операция нарушающая функционирование сервера";  break;
   case 64:    ErrorNumber = "Счет заблокирован";                                          break;
   case 65:    ErrorNumber = "Неправильный номер счета";                                   break;
   case 128:   ErrorNumber = "Истек срок ожидания совершения сделки";                      break;
   case 129:   ErrorNumber = "Неправильная цена";                                          break;
   case 130:   ErrorNumber = "Неправильные стопы";                                         break;
   case 131:   ErrorNumber = "Неправильный объем";                                         break;
   case 132:   ErrorNumber = "Рынок закрыт";                                               break;
   case 133:   ErrorNumber = "Торговля запрещена";                                         break;
   case 134:   ErrorNumber = "Недостаточно денег для совершения операции";                 break;
   case 135:   ErrorNumber = "Цена изменилась";                                            break;
   case 136:   ErrorNumber = "Нет цен";                                                    break;
   case 137:   ErrorNumber = "Брокер занят";                                               break;
   case 138:   ErrorNumber = "Новые цены - Реквот";                                        break;
   case 139:   ErrorNumber = "Ордер заблокирован и уже обрабатывается";                    break;
   case 140:   ErrorNumber = "Разрешена только покупка";                                   break;
   case 141:   ErrorNumber = "Слишком много запросов";                                     break;
   case 145:   ErrorNumber = "Модификация запрещена, так как ордер слишком близок к рынку";break;
   case 146:   ErrorNumber = "Подсистема торговли занята";                                 break;
   case 147:   ErrorNumber = "Использование даты истечения ордера запрещено брокером";     break;
   case 148:   ErrorNumber = "Количество открытых и отложенных ордеров достигло предела "; break;
   //---- 
   case 4000:  ErrorNumber = "Нет ошибки";                                                 break;
   case 4001:  ErrorNumber = "Неправильный указатель функции";                             break;
   case 4002:  ErrorNumber = "Индекс массива - вне диапазона";                             break;
   case 4003:  ErrorNumber = "Нет памяти для стека функций";                               break;
   case 4004:  ErrorNumber = "Переполнение стека после рекурсивного вызова";               break;
   case 4005:  ErrorNumber = "На стеке нет памяти для передачи параметров";                break;
   case 4006:  ErrorNumber = "Нет памяти для строкового параметра";                        break;
   case 4007:  ErrorNumber = "Нет памяти для временной строки";                            break;
   case 4008:  ErrorNumber = "Неинициализированная строка";                                break;
   case 4009:  ErrorNumber = "Неинициализированная строка в массиве";                      break;
   case 4010:  ErrorNumber = "Нет памяти для строкового массива";                          break;
   case 4011:  ErrorNumber = "Слишком длинная строка";                                     break;
   case 4012:  ErrorNumber = "Остаток от деления на ноль";                                 break;
   case 4013:  ErrorNumber = "Деление на ноль";                                            break;
   case 4014:  ErrorNumber = "Неизвестная команда";                                        break;
   case 4015:  ErrorNumber = "Неправильный переход";                                       break;
   case 4016:  ErrorNumber = "Неинициализированный массив";                                break;
   case 4017:  ErrorNumber = "Вызовы DLL не разрешены";                                    break;
   case 4018:  ErrorNumber = "Невозможно загрузить библиотеку";                            break;
   case 4019:  ErrorNumber = "Невозможно вызвать функцию";                                 break;
   case 4020:  ErrorNumber = "Вызовы внешних библиотечных функций не разрешены";           break;
   case 4021:  ErrorNumber = "Недостаточно памяти для строки, возвращаемой из функции";    break;
   case 4022:  ErrorNumber = "Система занята";                                             break;
   case 4050:  ErrorNumber = "Неправильное количество параметров функции";                 break;
   case 4051:  ErrorNumber = "Недопустимое значение параметра функции";                    break;
   case 4052:  ErrorNumber = "Внутренняя ошибка строковой функции";                        break;
   case 4053:  ErrorNumber = "Ошибка массива";                                             break;
   case 4054:  ErrorNumber = "Неправильное использование массива-таймсерии";               break;
   case 4055:  ErrorNumber = "Ошибка пользовательского индикатора";                        break;
   case 4056:  ErrorNumber = "Массивы несовместимы";                                       break;
   case 4057:  ErrorNumber = "Ошибка обработки глобальныех переменных";                    break;
   case 4058:  ErrorNumber = "Глобальная переменная не обнаружена";                        break;
   case 4059:  ErrorNumber = "Функция не разрешена в тестовом режиме";                     break;
   case 4060:  ErrorNumber = "Функция не подтверждена";                                    break;
   case 4061:  ErrorNumber = "Ошибка отправки почты";                                      break;
   case 4062:  ErrorNumber = "Ожидается параметр типа string";                             break;
   case 4063:  ErrorNumber = "Ожидается параметр типа integer";                            break;
   case 4064:  ErrorNumber = "Ожидается параметр типа double";                             break;
   case 4065:  ErrorNumber = "В качестве параметра ожидается массив";                      break;
   case 4066:  ErrorNumber = "Запрошенные исторические данные в состоянии обновления";     break;
   case 4067:  ErrorNumber = "Ошибка при выполнении торговой операции";                    break;
   case 4099:  ErrorNumber = "Конец файла";                                                break;
   case 4100:  ErrorNumber = "Ошибка при работе с файлом";                                 break;
   case 4101:  ErrorNumber = "Неправильное имя файла";                                     break;
   case 4102:  ErrorNumber = "Слишком много открытых файлов";                              break;
   case 4103:  ErrorNumber = "Невозможно открыть файл";                                    break;
   case 4104:  ErrorNumber = "Несовместимый режим доступа к файлу";                        break;
   case 4105:  ErrorNumber = "Ни один ордер не выбран";                                    break;
   case 4106:  ErrorNumber = "Неизвестный символ";                                         break;
   case 4107:  ErrorNumber = "Неправильный параметр цены для торговой функции";            break;
   case 4108:  ErrorNumber = "Неверный номер тикета";                                      break;
   case 4109:  ErrorNumber = "Торговля не разрешена";                                      break;
   case 4110:  ErrorNumber = "Длинные позиции не разрешены";                               break;
   case 4111:  ErrorNumber = "Короткие позиции не разрешены";                              break;
   case 4200:  ErrorNumber = "Объект уже существует";                                      break;
   case 4201:  ErrorNumber = "Запрошено неизвестное свойство объекта";                     break;
   case 4202:  ErrorNumber = "Объект не существует";                                       break;
   case 4203:  ErrorNumber = "Неизвестный тип объекта";                                    break;
   case 4204:  ErrorNumber = "Нет имени объекта";                                          break;
   case 4205:  ErrorNumber = "Ошибка координат объекта";                                   break;
   case 4206:  ErrorNumber = "Не найдено указанное подокно";                               break;
   case 4207:  ErrorNumber = "Ошибка при работе с объектом";                               break;
   default:    ErrorNumber = "Неизвестная ошибка";
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
         OrderTP = NormalizeDouble (TakeProfit * pp , pd); //--- Преобразуем тейк-профит в вид Points
         OrderSL = NormalizeDouble (StopLoss * pp , pd); //--- Преобразуем стоп-лосс в вид Points

         if (OpType == OP_BUY) {
               //--- Если длинная позиция, то
            TP = NormalizeDouble(OpenPrice + OrderTP, Digits); //--- То расчитывает тейк-профит
            SL = NormalizeDouble(OpenPrice - OrderSL, Digits); //--- и стоп-лосс
         } else if (OpType == OP_SELL){
               //--- Если короткая позиция, то   
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


