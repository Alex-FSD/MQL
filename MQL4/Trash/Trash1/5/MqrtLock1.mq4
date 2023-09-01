//+------------------------------------------------------------------+
//|                                                 MartLock1 |
//+------------------------------------------------------------------+
#property copyright "Dmitriy Epshteyn"
#property link      "setkafx@mail.ru"
#property version   "1.00"
#property strict

extern string A1 = "Настройки индикаторов MA и RSI";
extern int    PeriodMA_slow = 30; 
// Период медленной MA
extern int    PeriodMA_fast = 20;
 // Период быстрой  МА
extern int ma_shift_slow =0; 
// Сдвиг медленной средней скользящей
extern int ma_shift_fast =0;
 // Сдвиг быстрой средней скользящей
extern int ma_method_slow = 1; 
// Метод усреднения медленной средней скользящей
extern int ma_method_fast = 1;
 // Метод усреднения быстрой средней скользящей
extern int ma_index = 0;
// Номер бара (МА), с которого берутся показатели средних скользящих 
// метод усреднения
// 0 - Простое усреднение
// 1 - Экспоненциальное усреднение
// 2 - Сглаженное усреднение
// 3 - Линейно-взвешенное усреднение
extern int applied_price_slow = 0; 
// Используемая цена (0-закрытия, 1-открытия...) медленной средней скользящей
extern int applied_price_fast = 0; 
// Используемая цена (0-закрытия, 1-открытия...) быстрой средней скользящей
// используемая цена
//0-Цена закрытия
//1-Цена открытия
//2-Максимальная за период цена
//3-Минимальная за период цена
//4-Медианная цена, (high+low)/2
//5-Типичная цена, (high+low+close)/3
//6-Средневзвешенная цена, (high+low+close+close)/4  
extern int RSI_Period = 14; 
// Период индикатора RSI
extern int RSI_applied_price = 0; 
// Используемая цена (0-закрытия, 1-открытия...) индикатора RSI
extern int RSI_up = 70; 
// Верхний уровень RSI
extern int RSI_down = 30;
 // Нижний уровень RSI
extern string A2 = "Настройки сетки ордеров";
extern int Timer_Minutes = 10;
// Минимальное кол-во минут, которое должно пройти после закрытия последнего ордера, чтобы мог открыться новый 
extern double Lots = 0.01;
 // Лот ордеров
extern double Koef = 2;
 // Множитель лота ордеров
extern int    Step = 10;
 // "Минимальная охранная зона" между ордерами в пунктах
extern int    Max_Orders = 5; 
// Максимальное кол-во однотипных ордеров
extern int    TP = 10; 
// Тейк профит усредняющей сетки ордеров
extern int    Shag = 4;
// Шаг модификации тейк профита пачки ордеров
extern string A3 = "Настройки локкирующих ордеров";
extern int    Step_Lock = 10;
 // Расстояние в пунктах, на котором от сетки открывается локкирующий ордер 
extern double Koef_Lock = 2;
 // Множитель лота лок. ордера, на который умножается сумма лотов противоположных ордеров
extern int    Max_Lock_Orders = 1;
 // Кол-во попыток открыть лок. ордер
extern int    SL_Lock = 10; 
// Стоп лосс локкирующего ордера
extern string A4 = "Настройки закрытия сетки ордеров по убытку и по суммарному тралу профита";
extern double Loss_Close = 50; 
// Убыток в валюте депозита, при котором происходит закрытие ордеров в текущем торговом цикле
extern double Max_Profit_Tral = 30; 
// Максимальная сумма профита торгового цикла, при достижении которой начинает работать трал суммарного профита
extern double Trailing_Value = 10; 
// Если максимально зафиксированная сумма профита уменьшится на эту сумму, все ордера - закрываем.
extern string A5 = "Прочее";
extern int    Slip   = 30;
// Проскальзывание
extern int    Magic  = 1;
// Номер ордеров
extern int    Magic2  = 2;
// Номер локкирующих ордеров
extern bool   Info_Panel = true;
// Вкл/выкл информационную панель
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
datetime  first_time = TimeCurrent(); // время первого открытого рыночного ордера
double opB=2000000; double opS=0;
double KrainiyB  =0; // рыночный бай с наибольшей ценой открытия
double KrainiyS  =2000000; // рыночный сел с наименьшей ценой открытия 
double LotBsum=0; // сумма лотов бай ордеров
double LotSsum=0; // сумма лотов селл ордеров
double LotBmax=0; // макс лот бай ордеров
double LotSmax=0; // макс лот селл ордеров
double ProfitB=0, ProfitS=0;
double bMod = Ask;
double sMod = Bid;
static double zoneb = NormalizeDouble(Step*Point,Digits);
static double zones = NormalizeDouble(Step*Point,Digits);
int bZone=0, sZone=0;
double stops = MarketInfo(Symbol(),MODE_STOPLEVEL)*Point;
    int b=0,s=0,n=0,bs=0,ss=0,b1=0,s1=0, total=OrdersTotal();
  for(int i1=total-1; i1>=0; i1--)
     if(OrderSelect(i1, SELECT_BY_POS))
         if(OrderSymbol()==Symbol()      )
         if (OrderMagicNumber()==Magic)
       {
        if(OrderType()==OP_BUY)
         {b++;n++;
          ProfitB+=OrderProfit()+OrderSwap()+OrderCommission();
          LotBsum+=OrderLots();              
          double openB  =OrderOpenPrice ();
          double LotB=OrderLots();
          if(openB<opB) {opB=openB;} // внутренний бай ордер
          if(openB>KrainiyB) {KrainiyB=openB;} // крайний бай ордер
          if(LotB>LotBmax) {LotBmax=LotB;} // максимальный лот сетки бай ордеров
          if ((bMod-OrderOpenPrice()<=zoneb && bMod-OrderOpenPrice()>=0) || (OrderOpenPrice()-bMod<=zoneb && OrderOpenPrice()-bMod>=0)) {bZone++;}
          if (OrderOpenTime()>Time[0]) {b1++;}
          if (OrderOpenTime()<first_time) {first_time=OrderOpenTime();}
          }
        if(OrderType()==OP_SELL)
         {s++;n++;
           ProfitS+=OrderProfit()+OrderSwap()+OrderCommission();
           LotSsum+=OrderLots();
           double openS  =OrderOpenPrice ();
           double LotS=OrderLots();
           if(openS>opS) {opS=openS;} // внутренний селл ордер
           if(openS<KrainiyS) {KrainiyS=openS;}// крайний селл ордер
           if(LotS>LotSmax) {LotSmax=LotS;} // максимальный лот сетки селл ордеров
           if ((OrderOpenPrice()-sMod<=zones && OrderOpenPrice()-sMod>=0) || (sMod-OrderOpenPrice()<=zones && sMod-OrderOpenPrice()>=0)) {sZone++;}
           if (OrderOpenTime()>Time[0]) {s1++;}
           if (OrderOpenTime()<first_time) {first_time=OrderOpenTime();}
         }
       }
//---------------лоты----------------------
double lots_step=MarketInfo(Symbol(),MODE_LOTSTEP);
int lots_digits = 0;
//----
   if(lots_step==0.01)
      {lots_digits=2;}
//----
   if(lots_step==0.1)
      {lots_digits=1;}
//----
   if(lots_step==1.0)
      {lots_digits=0;}
//-
double Lot_b=0, Lot_s=0;
if (b==0)    {Lot_b=Lots;} 
if (s==0)    {Lot_s=Lots;}
if (b>0)     {Lot_b=NormalizeDouble(MathCeil((LotBmax*Koef)/lots_step)*lots_step,lots_digits);}
if (Lot_b<MarketInfo(Symbol(),MODE_MINLOT)) {Lot_b=MarketInfo(Symbol(),MODE_MINLOT);}

if (s>0)     {Lot_s=NormalizeDouble(MathCeil((LotSmax*Koef)/lots_step)*lots_step,lots_digits);}
if (Lot_s<MarketInfo(Symbol(),MODE_MINLOT)) {Lot_s=MarketInfo(Symbol(),MODE_MINLOT);}

if (Lot_b>MarketInfo(Symbol(),MODE_MAXLOT)) {Lot_b=MarketInfo(Symbol(),MODE_MAXLOT);}
if (Lot_s>MarketInfo(Symbol(),MODE_MAXLOT)) {Lot_s=MarketInfo(Symbol(),MODE_MAXLOT);}


double One_Lot=MarketInfo(Symbol(),MODE_MARGINREQUIRED);
bool open_buy = true, open_sell = true;
if (AccountFreeMargin()<One_Lot*Lot_b) {open_buy=false;} // не хватает денег открыть лот
if (AccountFreeMargin()<One_Lot*Lot_s) {open_sell=false;} // не хватает денег открыть лот
if (open_buy==false||open_sell==false) {Comment("Not enough money to open a Lot_b=",DoubleToStr(Lot_b,2), "   Lot_s=",DoubleToStr(Lot_s,2));}

int accTotal1=OrdersHistoryTotal();
int orders=0;
for(int h_1=accTotal1-1;h_1>=0;h_1--)
     if(OrderSelect(h_1,SELECT_BY_POS,MODE_HISTORY))
     if(OrderSymbol()==Symbol()      )
     if (OrderMagicNumber()==Magic) 
      {
      if (OrderCloseTime()>=Time[0]) {orders++;}
      if (OrderCloseTime()<Time[0]) {break;}
      }
datetime last_time_closed = 0;
for(int h_2=accTotal1-1;h_2>=0;h_2--)
     if(OrderSelect(h_2,SELECT_BY_POS,MODE_HISTORY))
     if(OrderSymbol()==Symbol()      )
     if (OrderMagicNumber()==Magic) 
      {
      if (OrderCloseTime()>0) {last_time_closed=OrderCloseTime(); break;}
      }

bool open_time = false;
if (Timer_Minutes==0) {open_time=true;}
if (Timer_Minutes>0&&TimeCurrent()-last_time_closed>=Timer_Minutes*60) {open_time=true;}
//___________индикаторы и сигнал_______________ 
double MA_slow=NormalizeDouble(iMA(NULL,0,PeriodMA_slow,ma_shift_slow,ma_method_slow,applied_price_slow,ma_index),Digits);
double MA_fast=NormalizeDouble(iMA(NULL,0,PeriodMA_fast,ma_shift_fast,ma_method_fast,applied_price_fast,ma_index),Digits);
double RSI1 = iRSI(Symbol(),0,RSI_Period,RSI_applied_price,1);   
double RSI2 = iRSI(Symbol(),0,RSI_Period,RSI_applied_price,2);
int sig = 0;
if (MA_fast>MA_slow&&RSI2<RSI_down&&RSI1>RSI_down) {sig=1;} // покупаем
if (MA_fast<MA_slow&&RSI2>RSI_up&&RSI1<RSI_up)     {sig=2;} // продаем
//-----Открываем стартовый ордер--------
if (n==0&&sig==1&&open_buy==true&&orders==0&&open_time==true)  {int open = OrderSend(Symbol(),OP_BUY,Lot_b,Ask,Slip,0,0,NULL,Magic,0,0);} 
if (n==0&&sig==2&&open_sell==true&&orders==0&&open_time==true)  {int open = OrderSend(Symbol(),OP_SELL,Lot_s,Bid,Slip,0,0,NULL,Magic,0,0);} 
//____усредняем____
if (b>0&&b<Max_Orders&&bZone==0&&Ask<opB&&open_buy==true&&b1==0&&Volume[0]<5)  {int open = OrderSend(Symbol(),OP_BUY,Lot_b,Ask,Slip,0,0,NULL,Magic,0,0);} 
if (s>0&&s<Max_Orders&&sZone==0&&Bid>opS&&open_sell==true&&s1==0&&Volume[0]<5)  {int open = OrderSend(Symbol(),OP_SELL,Lot_s,Bid,Slip,0,0,NULL,Magic,0,0);} 


//-------расчет тейк профит пачки ордеров, лок (цикл пересчета ордеров локов)--------- 

double TickValue=MarketInfo(Symbol(),MODE_TICKVALUE);
double BuyLevel=0,SellLevel=0;
 if (LotBsum>0) {BuyLevel=NormalizeDouble(Bid-(ProfitB/(TickValue*LotBsum)*Point),Digits);}     
 if (LotSsum>0) {SellLevel=NormalizeDouble(Ask+(ProfitS/(TickValue*LotSsum)*Point),Digits);} 
double tp = NormalizeDouble(TP*Point,Digits);
double b_tp = NormalizeDouble(BuyLevel+tp,Digits);
double s_tp = NormalizeDouble(SellLevel-tp,Digits);

double shag = NormalizeDouble(Shag*Point,Digits);
double ProfitB_Lock=0, ProfitS_Lock=0;
int b_lock=0,s_lock=0;
double sl_lock = NormalizeDouble(SL_Lock*Point,Digits);

static int stat_orders;

   for(int i2=total-1; i2>=0; i2--)
     if(OrderSelect(i2, SELECT_BY_POS))
         if(OrderSymbol()==Symbol()) // выставим тейки пачке ордеров, найдем локкирующий ордер
     {
       if (OrderType()==OP_BUY)
       {
       if (n!=stat_orders&&OrderTakeProfit()==0&&OrderMagicNumber()==Magic&&BuyLevel>0&&Ask<b_tp-stops&&OrderTakeProfit()!=b_tp) 
       {bool mod = OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),b_tp,0,0);}   
       if (n!=stat_orders&&OrderMagicNumber()==Magic&&BuyLevel>0&&Ask<b_tp-stops&&OrderTakeProfit()!=b_tp&&MathAbs(OrderTakeProfit()-b_tp)>=shag) 
       {bool mod = OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),b_tp,0,0);}   
       
     
       if (OrderMagicNumber()==Magic2) {b_lock++;ProfitB_Lock+=OrderProfit()+OrderSwap()+OrderCommission();}
      if (OrderMagicNumber()==Magic2&&OrderStopLoss()==0&&Bid>NormalizeDouble(OrderOpenPrice()-sl_lock+stops,Digits)&&OrderStopLoss()!=NormalizeDouble(OrderOpenPrice()-sl_lock,Digits)) 
      {bool mod = OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()-sl_lock,Digits),OrderTakeProfit(),0,0);}   
       }
       if (OrderType()==OP_SELL)
       {
       if (n!=stat_orders&&OrderTakeProfit()==0&&OrderMagicNumber()==Magic&&SellLevel>0&&Bid>s_tp+stops&&OrderTakeProfit()!=s_tp) 
       {bool mod = OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),s_tp,0,0);}   
       if (n!=stat_orders&&OrderMagicNumber()==Magic&&SellLevel>0&&Bid>s_tp+stops&&OrderTakeProfit()!=s_tp&&MathAbs(OrderTakeProfit()-s_tp)>=shag) 
       {bool mod = OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),s_tp,0,0);}   
       
     
       if (OrderMagicNumber()==Magic2) {s_lock++;ProfitB_Lock+=OrderProfit()+OrderSwap()+OrderCommission();}
      if (OrderMagicNumber()==Magic2&&OrderStopLoss()==0&&Ask<NormalizeDouble(OrderOpenPrice()+sl_lock-stops,Digits)&&OrderStopLoss()!=NormalizeDouble(OrderOpenPrice()+sl_lock,Digits)) 
      {bool mod = OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()+sl_lock,Digits),OrderTakeProfit(),0,0);}   
       
       }
     }   
     
        
stat_orders=n;
//---лот локкирующего ордера----
//----- считаем кол-во закрытых лок. ордеров, их профит----
int lock_orders=0;
double Profit_Lock_Closed=0;
for(int l_1=accTotal1-1;l_1>=0;l_1--)
     if(OrderSelect(l_1,SELECT_BY_POS,MODE_HISTORY))
     if(OrderSymbol()==Symbol()      )
     if (OrderMagicNumber()==Magic2) 
      {
      if (OrderCloseTime()>=first_time) {lock_orders++;Profit_Lock_Closed+=OrderProfit()+OrderSwap()+OrderCommission();}
      if (OrderCloseTime()<=first_time) {break;}
      }

double Lot_b_Lock = NormalizeDouble(MathCeil((LotSsum*Koef_Lock)/lots_step)*lots_step,lots_digits); 
double Lot_s_Lock = NormalizeDouble(MathCeil((LotBsum*Koef_Lock)/lots_step)*lots_step,lots_digits); 

if (Lot_b_Lock>MarketInfo(Symbol(),MODE_MAXLOT)) {Lot_b_Lock=MarketInfo(Symbol(),MODE_MAXLOT);}
if (Lot_s_Lock>MarketInfo(Symbol(),MODE_MAXLOT)) {Lot_s_Lock=MarketInfo(Symbol(),MODE_MAXLOT);}
 
double step_lock = NormalizeDouble(Step_Lock*Point,Digits);

if (s>=Max_Orders&&b_lock==0&&Bid>opS+step_lock&&lock_orders<Max_Lock_Orders) {int open = OrderSend(Symbol(),OP_BUY,Lot_b_Lock,Ask,Slip,0,0,NULL,Magic2,0,0);}
if (b>=Max_Orders&&s_lock==0&&Ask<opB-step_lock&&lock_orders<Max_Lock_Orders) {int open = OrderSend(Symbol(),OP_SELL,Lot_s_Lock,Bid,Slip,0,0,NULL,Magic2,0,0);}

double Circle_Profit = ProfitB+ProfitS+ProfitB_Lock+ProfitS_Lock+Profit_Lock_Closed;
static double max_profit;
static int tral_start; // 0 - не включился, 1 - включился при совпадении условий
if (n==0) {max_profit=0;tral_start=0;}
if (n>0&&Circle_Profit>Max_Profit_Tral&&Circle_Profit>max_profit) {max_profit=Circle_Profit; tral_start=1;}
if (tral_start==1&&Circle_Profit<=max_profit-Trailing_Value) {CloseAll();Print("_______________________________ЗАКРЫТИЕ ПРОФИТА_______________________");}

if (Circle_Profit<-1*Loss_Close) {CloseAll();Print("______________________________________ЗАКРЫТИЕ УБЫТКА___________________________________");}

//if (Info_Panel==true)  {Comment("Профит открытых ордеров=",DoubleToStr(ProfitB+ProfitS,2),"\r\n","Профит локкирующего ордера=",DoubleToStr(ProfitB_Lock+ProfitS_Lock,2),"\r\n","Профит закрытых локкирующих ордеров=",DoubleToStr(Profit_Lock_Closed,2),"\r\n","Профит текущего цикла=",DoubleToStr(Circle_Profit,2),"\r\n","Максимальный профит трала=",DoubleToStr(max_profit,2));}
Comment("TickValue=",TickValue, "     spred=",Ask-Bid);
  }
//+------------------------------------------------------------------+
bool CloseAll() // закрыть все ордера
{
   bool error=true;
   int err,nn1,OT;
   string Symb;
   while(true)
   {
      for (int jj = OrdersTotal()-1; jj >= 0; jj--)
      {
         if (OrderSelect(jj, SELECT_BY_POS))
         {
            Symb = OrderSymbol();
            if ((Symb==Symbol()&&OrderMagicNumber()==Magic)||(Symb==Symbol()&&OrderMagicNumber()==Magic2))
            {
               OT = OrderType();
               if (OT>1) 
               {
                  bool del = OrderDelete(OrderTicket());
               }
               if (OT==OP_BUY) 
               {
                  error=OrderClose(OrderTicket(),OrderLots(),Bid,Slip,Blue);
                  if (error) Alert(Symb,"  Закрыт ордер N ",OrderTicket(),"  прибыль ",OrderProfit(),
                                     "     ",TimeToStr(TimeCurrent(),TIME_SECONDS));
               }
               if (OT==OP_SELL) 
               {
                  error=OrderClose(OrderTicket(),OrderLots(),Ask,Slip,Red);
                  if (error) Alert(Symb,"  Закрыт ордер N ",OrderTicket(),"  прибыль ",OrderProfit(),
                                     "     ",TimeToStr(TimeCurrent(),TIME_SECONDS));
               }
               if (!error) 
               {
                  err = GetLastError();
                  if (err<2) continue;
                  if (err==129) 
                  {  Comment("Неправильная цена ",TimeToStr(TimeCurrent(),TIME_MINUTES));
                     Sleep(5000);
                     RefreshRates();
                     continue;
                  }
                  if (err==146) 
                  {
                     if (IsTradeContextBusy()) Sleep(2000);
                     continue;
                  }
                  Comment("Ошибка ",err," закрытия ордера N ",OrderTicket(),
                          "     ",TimeToStr(TimeCurrent(),TIME_MINUTES));
               }
            }
         }
      }
      int n1=0;
      for (int jj = 0; jj < OrdersTotal(); jj++)
      {
         if (OrderSelect(jj, SELECT_BY_POS))
         {
            if ((Symb==Symbol()&&OrderMagicNumber()==Magic)||(Symb==Symbol()&&OrderMagicNumber()==Magic2))// || AllSymbol) && (Magic==0 || Magic==OrderMagicNumber()))
            {
               OT = OrderType();
               if (OT==OP_BUY || OT==OP_SELL) n1++;
            }
         }  
      }
      if (n1==0) break;
      nn1++;
      if (nn1>10) {Alert(Symb,"  Не удалось закрыть все сделки, осталось еще ",n1);return(0);}
      Sleep(1000);
      RefreshRates();
   }
   return(1);
//______________________________________________________________________________________________________________________

     
   
  }