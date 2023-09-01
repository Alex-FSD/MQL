//+------------------------------------------------------------------+
//|                                                TradeChannell.mq4 |
//|                                   Copyright © 2010, Korvin ® Co. |
//|                                         http://alecask.narod.ru/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, Korvin® Co."
#property link      "http://alecask.narod.ru/"
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|--------------- Советник "Торговля в канале" ---------------------|
//| Торговля  происходит  в  канале,  которому  при  создании  нужно |
//| присвоить имя: "TradeCannel".                                    |
//| Основная  линия  нисходящего  канала  проводится  по  нисходящим |
//| максимумам и определяет уровень открытия коротких позиций.       |
//| Вспомогательная линия  нисходящего  канала проводится ниже линии |
//| открытия ордеров и определяет уровень закрытия коротких позиций. |
//| Основная  линия  восходящего  канала  проводится  по  восходящим |
//| минимумам и определяет уровень открытия длиных позиций.          |
//| Вспомогательная линия  восходящего  канала проводится выше линии |
//| открытия ордеров и определяет уровень закрытия длиных позиций.   |
//| Какие именно ордера  открывать  советник  определяет  по наклону |
//| канала. Одновременно открывается ТОЛЬКО ОДИН ордер.              |
//| Параметр Delta определяет расстояние в пунктах до линии открытия |
//| и линии закрытия  ордеров изнутри канала.  При  открытии  ордера |
//| цена  Bid  должна находиться в пределах   [opr±Delta ; opr]; при |
//| закрытии  ордера  цена   Bid   должна  быть  больше  или  меньше |
//| [cpr±Delta] в зависимости от типа ордера и направления торгового |
//| канала, где:                                                     |
//| opr - рассчитанное  значение  линии  открытия ордера  на текущем |
//|       баре;                                                      |
//| cpr - рассчитанное  значение  линии  закрытия ордера  на текущем |
//|       баре;                                                      |
//| Параметр StopLoss выставляется на случай пробоя канала вручную.  |
//| Параметр TakeProfit выставляется в 50 пунктах от линии закрытия. |
//|          автоматически.                                          |
//| Параметр   Risk   определяет максимальный  риск  при открываемой |
//| сделке и служит для рассчёта максимального лота. Для отображения |
//| реального  рассчитанного  риска  сделки  задайте  значение  true |
//| параметру ShowRisk.                                              |
//| Параметр PoTrendu определяет направление торговли  ПО или ПРОТИВ |
//| направления тренда,  определяемого  экспертом  самостоятельно по |
//| наклону канала  и  по взаимному  расположению  линий  открытия и |
//| закрытия торговых ордеров.                                       |
//| Открытие  и  закрытие  ордеров   может  сопровождаться  звуковым |
//| сигналом, если  Вы  зададите значение  true  параметру SoundOn и |
//| загрузите звуковые файлы  OrderSellOpen.wav , OrderBuyOpen.wav , |
//| и OrderClose.wav в папку: КАТАЛОГ ТЕРМИНАЛА/sounds/....          |
//| Значения внешних переменных по умолчанию  предназначены для пары |
//| типа EURUSD; для таких пар, как XAUUSD или USDJPY проще изменить |
//| значения параметров в коде и перекомпилировать советника.        |
//|--------------------- Попутного Вам тренда -----------------------|
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                     Channell.mq4 |
//|                                   Copyright © 2010, Korvin ® Co. |
//|                                         http://alecask.narod.ru/ |
//+------------------------------------------------------------------+
extern int    MaxRisk=2;         // Задаваемый максимальный риск
extern bool   ShowRisk=true;     // Показать реальный риск
extern bool   PoTrendu=true;     // Торговать по тренду?
extern int    StopLoss=50;       // Установить StopLoss
extern int    Delta=5;           // Ширина зоны срабатывания
extern int    DeltaFactor=2;     // Расширение зоны закрытия ордеров
extern bool   SoundOn=true;      // Включить звук?
       int    tic = 0;           // Номер открытого ордера
       int    TakeProfit;
//+------------------------------------------------------------------+
//| ############### Блок инициализации переменных ################## |
//+------------------------------------------------------------------+
int init() {Comment("");return(0);}
//+------------------------------------------------------------------+
//| ############### Блок деинициализации переменных ################ |
//+------------------------------------------------------------------+
int deinit() {Comment("");return(0);} // Очистка терминала
//+------------------------------------------------------------------+
//| ############# Основная функция обработки событий ############### |
//+------------------------------------------------------------------+
int start()
  {
//+------------------------------------------------------------------+
//|                                   Рутинные проверки              |
//+------------------------------------------------------------------+
if(DayOfWeek()==0 || DayOfWeek()==6) return(0); // в выходные
                                                // не работаем
if(!IsTradeAllowed()) return(0);                // пропустим тик если
                                                // терминал занят
//+------------------------------------------------------------------+
//|                                   Блок сбора и оработки данных   |
//+------------------------------------------------------------------+
string tRend=""; string Spaces="\n                          ";
string name="TradeChannel"; string str1; string str2; string str3;
RefreshRates();
//проверим что торговый канал нарисован правильно (по движению цены)
 datetime t1=ObjectGet(name,OBJPROP_TIME1);
 datetime t2=ObjectGet(name,OBJPROP_TIME2);
 datetime t3=ObjectGet(name,OBJPROP_TIME3);
int err=GetLastError();
 if (err==4202) {Comment(err,"  Нарисуйте торговый канал и дайте ему имя \"TradeChannel\"."); return;}
 if(t1>t2)
   {Comment("Неправильно нарисован торговый канал!");
    return(0);}
//продолжим линии канала (свойство луч)
 ObjectSet(name,OBJPROP_RAY,true);
//определим тренд (вверх или вниз)
 bool trend=false;
 double p1=ObjectGet(name,OBJPROP_PRICE1);
 double p2=ObjectGet(name,OBJPROP_PRICE2);
 double p3=ObjectGet(name,OBJPROP_PRICE3);
if(p1<p2) trend=true;
 if(trend) tRend=" Восходящий ";
 else tRend=" Нисходящий ";
Comment(p1,"   ",p2,"   ",tRend);
double opr=ObjectGetValueByShift(name,0);// определим текущее значение
                                         // линии открытия ордеров opr,
// найдём текущее значение линии закрытия ордеров cpr,
  int control=0; // контрольная цифра
  int s1 = iBarShift( NULL, 0, t1, control); // смещение бара цены p1
  int s2 = iBarShift( NULL, 0, t2, control); // смещение бара цены p2
  int s3 = iBarShift( NULL, 0, t3, control); // смещение бара цены p3
// рассчёт коэффициентов уравнения линии открытия ордеров
  double A=p2-p1; double B=s1-s2; double C=s2*p1-s1*p2;
// рассчёт расстояния между линиями покупки и продажи
  double d=(A*s3+B*p3+C)/MathSqrt(MathPow(A,2.0)+MathPow(B,2.0))/MathCos(MathArctan(A/B));
  double cpr=opr+d; // текущее значение цены продажи
  int    TakeProfit=d/Point+50;
//---------------------------------- блок рассчёта реального риска ---
double Free =AccountFreeMargin();
double One_Lot =MarketInfo(Symbol(),MODE_MARGINREQUIRED);
double Step =MarketInfo(Symbol(),MODE_LOTSTEP);
double Min_Lot =MarketInfo(Symbol(),MODE_MINLOT);
double Max_Lot =MarketInfo(Symbol(),MODE_MAXLOT);
double Lot =MathFloor(Free*MaxRisk/100/One_Lot/Step)*Step;
if(Lot<Min_Lot) Lot=Min_Lot;
if(Lot>Max_Lot) Lot=Max_Lot;
double MyRisk = MathFloor(Lot*10000*One_Lot/Free)/100;
//------------------------- блок формирования служебной информации ---
    if (tic>0) str1="\n\x95 Открыт ордер № "+tic;
    else str1="";
    if (ShowRisk) str2="\n\x95 Максимальный риск: "+DoubleToStr(MyRisk,2)+" %";
    else str2="";
    if (PoTrendu) str3="\n\x95 Режим работы: по тренду";
    else str3="\n\x95 Режим работы: против тренда";
    if (MathAbs(d/Point)<=15) Comment("Name=",name,"  Слишком узкий канал для торговли, всего ",
                                      DoubleToStr(d/Point,0)," пунктов.");
      Comment("\n\x97 ",tRend,"\"",name,"\" \x97",str1,str2,
              " \n\x95 Ширина канала ",MathRound(d/Point)," пунктов,\n\x97 Текущие: \x97\n\x95 Цена открытия ордеров: ",
              DoubleToStr(opr,5),"\n\x95 Цена закрытия ордеров: ",DoubleToStr(cpr,5),
              "\n\x97 Будущие: \x97\n\x95 Stop Loss: ",DoubleToStr((opr-StopLoss*Point),5),
              "\n\x95 Take Profit: ",DoubleToStr((opr+TakeProfit*Point),5));
//+------------------------------------------------------------------+

//подсчитаем кол-во ордеров
 int oBuy=0,oSell=0;
 for(int i=OrdersTotal()-1;i>=0;i--)
   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
     if(OrderSymbol()==Symbol())
       {if(OrderType()==OP_BUY) oBuy++;
        if(OrderType()==OP_SELL) oSell++;}
    if(oBuy+oSell==0) tic=0;
//+------------------------------------------------------------------+
//|                                   Блок закрытия ордеров          |
//+------------------------------------------------------------------+
//если есть ордера и цена подошла к линии закрытия - закроем ордер
 double tp=0,sl=0;
        Lot=GetLot(MaxRisk);
 if(tic>0 && Lot!=0 && Bid<=cpr && Bid>=cpr-DeltaFactor*Delta*Point) {
     CloseOrder(tic); tic=0; PlaySound("OrderClose.wav"); Sleep(5000);}
//+------------------------------------------------------------------+
//|                                   Блок открытия ордеров          |
//+------------------------------------------------------------------+
//если нет ордеров и цена подошла к линии открытия - откроем ордер
tp=0;
sl=0;
Lot=GetLot(MaxRisk);
 if(Lot==0.0) {Alert("Недостаточно средств!");return(0);}
 //+----------------------------------------------------- ПОКУПКА ---+
if((oBuy+oSell==0 && trend && PoTrendu && Bid>=opr && Bid<=opr+Delta*Point)||
  (oBuy+oSell==0 && !trend && !PoTrendu && Bid>=opr && Bid<=opr+Delta*Point))
   {if(TakeProfit>0) tp=Ask+TakeProfit*Point;
    if(StopLoss>0) sl=Ask-StopLoss*Point;
    tic=NewOrder(OP_BUY,Lot,Ask,tp,sl);
        if (SoundOn&&tic>0) PlaySound("OrderBuyOpen.wav"); Sleep(5000);
   }
 //+----------------------------------------------------- ПРОДАЖА ---+
if((oBuy+oSell==0 && !trend && PoTrendu && Ask<=opr && Ask>=opr-Delta*Point)||
  (oBuy+oSell==0 && trend && !PoTrendu && Ask<=opr && Ask>=opr-Delta*Point))
   {if(TakeProfit>0) tp=Bid-TakeProfit*Point;
    if(StopLoss>0) sl=Bid+StopLoss*Point;
    tic=NewOrder(OP_SELL,Lot,Bid,tp,sl);
       if (SoundOn&&tic>0) PlaySound("OrderSellOpen.wav"); Sleep(5000);
   }
//==================================================== конец блока ==
   return(0);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| ################# Блок подпрограмм пользователя ################ |
//+------------------------------------------------------------------+
double GetLot(int Risk)
{double Free    =AccountFreeMargin();
 double One_Lot =MarketInfo(Symbol(),MODE_MARGINREQUIRED);
 double Min_Lot =MarketInfo(Symbol(),MODE_MINLOT);
 double Max_Lot =MarketInfo(Symbol(),MODE_MAXLOT);
 double Step    =MarketInfo(Symbol(),MODE_LOTSTEP);
 double Lot     =MathFloor(Free*Risk/100/One_Lot/Step)*Step;
 if(Lot<Min_Lot) Lot=Min_Lot;
 if(Lot>Max_Lot) Lot=Max_Lot;
 if(Lot*One_Lot>Free) return(0.0);
return(Lot);}
//+------------------------------------------------------------------+
int NewOrder(int Cmd,double Lot,double PR=0,double TP=0,double SL=0)
{while(!IsTradeAllowed()) Sleep(100);
 if(Cmd==OP_BUY)
   {PR=NormalizeDouble(Ask,Digits);
    if(TP==0 && TakeProfit>0) TP=PR+TakeProfit*Point;
    if(SL==0 && StopLoss>0) SL=PR-StopLoss*Point;}
 if(Cmd==OP_SELL)
   {PR=NormalizeDouble(Bid,Digits);
    if(TP==0 && TakeProfit>0) TP=PR-TakeProfit*Point;
    if(SL==0 && StopLoss>0) SL=PR+StopLoss*Point;}
 int tic=OrderSend(Symbol(),Cmd,Lot,PR,3,SL,TP,"",0,0,CLR_NONE);
 if(tic<0) Print("Ошибка открытия ордера: ",GetLastError());
return(tic);}
//+------------------------------------------------------------------+
void CloseOrder(int tic)
{double PR=0;
 while(!IsTradeAllowed()) Sleep(100);
 if(OrderType()==OP_BUY)  PR=NormalizeDouble(Bid,Digits);
 if(OrderType()==OP_SELL) PR=NormalizeDouble(Ask,Digits);
 if(OrderSelect(tic,SELECT_BY_TICKET))
   if(!OrderClose(OrderTicket(),OrderLots(),PR,3,CLR_NONE))
     Print("Ошибка закрытия ордера: ",GetLastError());
return;}
//+------------------------------------------------------------------+