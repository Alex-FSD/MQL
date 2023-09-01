//+--------------------------------------------------------------------------------------+
//|                                                                TradeChannel_v3_0.mq4 |
//|                                                       Copyright © 2010, Korvin ® Co. |
//|                                                             http://alecask.narod.ru/ |
//+--------------------------------------------------------------------------------------+
#property copyright "Copyright © 2010, Korvin ® Co."
#property link      "http://alecask.narod.ru/"
#include <mylib.mqh>
extern bool   expert     = false;
extern int    MaxRisk    = 2;
extern int    STOPLOSS   = 50;
extern int    TAKEPROFIT = 50;
extern int    DELTA      = 50;
extern double FACTOR     = 1.0;
extern int    align      = 230;
extern bool   SoundOn    = false;
int  swap,tic;
bool buy,sell;
//+--------------------------------------------------------------------------------------+
//| expert initialization function                                                       |
//+--------------------------------------------------------------------------------------+
int init() {
RefreshRates();
swap = MathRound((Ask-Bid)/Point); // Определим проскальзывание на графике
tic=0;
buy=false;
sell=false;

return(0);}
//+--------------------------------------------------------------------------------------+
//| expert deinitialization function                                                     |
//+--------------------------------------------------------------------------------------+
int deinit() {return(0);}
//+--------------------------------------------------------------------------------------+
//| expert start function                                                                |
//+--------------------------------------------------------------------------------------+
int start() {
Comment(""); // Очистим экран от предыдущих надписей
// Очистим экран от объектов, нарисованных в прошлом тике:
ObjectDelete("LineMiddle");
ObjectDelete("LineRealOpen");
ObjectDelete("LineRealClose");
ObjectDelete("LineStopLoss");
ObjectDelete("LineTakeProfit");
//ObjectDelete("");
// Если не пройден общий контроль - запретим торговлю.
  if (!RutineCheck()) {Comment (Span(200),"Торговля запрещена"); return(0);}
// Нарисован ли канал "TradeChannel" ...?
//------------------ С Т Р О К О В Ы Е   П Е Р Е М Е Н Н Ы Е -----------------------------
string name="TradeChannel"; string msg1,msg2,msg3,msg4,msg5,msg6,msg7,msg8;
//----------------------------------------------------------------------------------------
RefreshRates(); // Обновим данные и сделаем запросы по имени "TradeCannel"
 datetime t1=ObjectGet(name,OBJPROP_TIME1);
 datetime t2=ObjectGet(name,OBJPROP_TIME2);
 datetime t3=ObjectGet(name,OBJPROP_TIME3);
   double p1=ObjectGet(name,OBJPROP_PRICE1);
   double p2=ObjectGet(name,OBJPROP_PRICE2);
   double p3=ObjectGet(name,OBJPROP_PRICE3);
      int control=0; // контрольная цифра
      int s1 = iBarShift( NULL, 0, t1, control); // смещение бара цены p1
      int s2 = iBarShift( NULL, 0, t2, control); // смещение бара цены p2
      int s3 = iBarShift( NULL, 0, t3, control); // смещение бара цены p3
//---------------- Н А Р И С У Е М   Т О Р Г О В Ы Й   К А Н А Л -------------------------
// Если канала нет, попросим его нарисовать
int err=GetLastError();
 if (err==4202) {Comment(Span(187),"  Нарисуйте торговый канал и дайте ему имя \"TradeChannel\"."); return;}
//проверим что торговый канал нарисован правильно (слева-направо)
 if(t1>t2) {Comment(Span(219),"Расположите \"",name,"\" правильно!"); return(0);}
//Если канал нарисован верно - продолжим линии канала (свойство луч)
 ObjectSet(name,OBJPROP_RAY,true);
//-------------------- Ш И Р И Н А   Т О Р Г О В О Г О   К А Н А Л А --------------------+
double d = (p3-p1) - (p2-p1)*(s1-s3)/(s1-s2); //                                         |
//--------------- З Н А К   Ш И Р И Н Ы   Т О Р Г О В О Г О   К А Н А Л А ---------------+
int sign = MathRound(d/MathAbs(d));//                                                    |
//+--------------------------------------------------------------------------------------+
// Если канал восходящий - он зелёный, если нисходящий - красный.
if (p1<=p2) ObjectSet(name,OBJPROP_COLOR,Green);
else  ObjectSet(name,OBJPROP_COLOR,Red);
//---------- Н А Р И С У Е М   С Р Е Д Н Ю Ю   Л И Н И Ю   К А Н А Л А -------------------
double plm1=p1+d*0.5; double plm2=p2+d*0.5; // Параметры цены для рисования средней линии
ObjectCreate("LineMiddle",OBJ_TREND,0,t1,plm1,t2,plm2);
ObjectSet("LineMiddle",OBJPROP_STYLE,STYLE_DASHDOT);
ObjectSet("LineMiddle",OBJPROP_WIDTH,1);
ObjectSet("LineMiddle",OBJPROP_COLOR,Goldenrod);
//--------------- Т Е К У Щ Е Е   З Н А Ч Е Н И Е Линии открытия ордеров ----------------+
double LineOpen = ObjectGetValueByShift(name,0);
//--------------- Т Е К У Щ Е Е   З Н А Ч Е Н И Е Линии закрытия ордеров ----------------+
double LineClose = LineOpen+d;
//--------------- Т Е К У Щ Е Е   З Н А Ч Е Н И Е Средней линии -------------------------+
double LineMiddle = ObjectGetValueByShift("LineMiddle",0);
//------------- О П Р Е Д Е Л И М   Н А П Р А В Л Е Н И Е   Т О Р Г О В Л И --------------
bool trend, potrendu;
if (p2>=p1) {trend=true; msg3=" ВОСХОДЯЩИЙ ";}                 // тренд восходящий ...
else {trend=false; msg3=" НИСХОДЯЩИЙ ";}                       // или нисходящий ?
if ((trend && sign>=0)||
    (!trend && sign<0)) {potrendu=true; msg4=" ПО ТРЕНДУ ";}   // торговля по тренду ...
else {potrendu=false; msg4=" ПРОТИВ ТРЕНДА ";}                 // или против тренда ?
//------- П О К А Ж Е М   Г Д Е   Б У Д У Т   О Т К Р Ы В А Т Ь С Я   О Р Д Е Р А --------
double zona1;
if (d<0) zona1 = sign*DELTA*Point;
else zona1 = sign*(DELTA+swap)*Point;
double lro1=p1+zona1; double lro2=p2+zona1; // Параметры цены для 
    ObjectCreate("LineRealOpen",OBJ_TREND,0,t1,lro1,t2,lro2);
    ObjectSet("LineRealOpen",OBJPROP_STYLE,STYLE_DASH);
    ObjectSet("LineRealOpen",OBJPROP_WIDTH,1);
if ((trend && potrendu)||(!trend && !potrendu)) ObjectSet("LineRealOpen",OBJPROP_COLOR,Lime);
else  ObjectSet("LineRealOpen",OBJPROP_COLOR,DeepPink);
double LineRealOpen = ObjectGetValueByShift("LineRealOpen",0); // текущее значение линии
//------- П О К А Ж Е М   Г Д Е   Б У Д У Т   З А К Р Ы В А Т Ь С Я   О Р Д Е Р А --------
if (d<0) zona1 = sign*(DELTA+swap)*Point;
else zona1 = sign*DELTA*Point;
double lrc1=p1+d-zona1; double lrc2=p2+d-zona1; // Параметры цены для 
ObjectCreate("LineRealClose",OBJ_TREND,0,t1,lrc1,t2,lrc2);
ObjectSet("LineRealClose",OBJPROP_STYLE,STYLE_DASH);
ObjectSet("LineRealClose",OBJPROP_WIDTH,1);
if ((trend && potrendu)||(!trend && !potrendu)) ObjectSet("LineRealClose",OBJPROP_COLOR,DeepPink);
else ObjectSet("LineRealClose",OBJPROP_COLOR,Lime);
double LineRealClose = ObjectGetValueByShift("LineRealClose",0); // текущее значение линии
//-------------- Н А Й Д Е М   Р Е А Л Ь Н У Ю   Ш И Р И Н У   К А Н А Л А ---------------
int realwidth = sign*MathRound((LineRealClose-LineRealOpen)/Point);    // Закончим, если
if (realwidth<=0) {Comment("\n",Span(align),"  КАНАЛ СЛИШКОМ УЗОК"); return(0);}// узкий канал
//---- П О К А Ж Е М   Г Д Е   Б У Д Е Т   У С Т А Н А В Л И В А Т Ь С Я   STOP_LOSS -----
// Параметры цены для рисования LineStopLoss
double lsl1=p1-sign*STOPLOSS*Point; double lsl2=p2-sign*STOPLOSS*Point; 
ObjectCreate("LineStopLoss",OBJ_TREND,0,t1,lsl1,t2,lsl2);
ObjectSet("LineStopLoss",OBJPROP_STYLE,STYLE_DOT);
ObjectSet("LineStopLoss",OBJPROP_WIDTH,1);
ObjectSet("LineStopLoss",OBJPROP_COLOR,DeepPink);
double LineStopLoss = ObjectGetValueByShift("LineStopLoss",0); // текущее значение линии
//--- П О К А Ж Е М   Г Д Е   Б У Д Е Т   У С Т А Н А В Л И В А Т Ь С Я   TAKE_PROFIT ----
// Параметры цены для рисования LineTakeProfit
double ltp1=p1+d+sign*TAKEPROFIT*Point; double ltp2=p2+d+sign*TAKEPROFIT*Point; 
ObjectCreate("LineTakeProfit",OBJ_TREND,0,t1,ltp1,t2,ltp2);
ObjectSet("LineTakeProfit",OBJPROP_STYLE,STYLE_DOT);
ObjectSet("LineTakeProfit",OBJPROP_WIDTH,1);
ObjectSet("LineTakeProfit",OBJPROP_COLOR,DodgerBlue);
double LineTakeProfit = ObjectGetValueByShift("LineTakeProfit",0); // текущее значение линии
//------------------------- Б Л О К   В Ы В О Д А   Т Е К С Т А -------------------------
   if (!expert) {msg1="*** ИНДИКАТОР ***";}
   else {msg1="**** ЭКСПЕРТ ****";}
     if (!expert) msg5="\n"+Span(align)+"Линия открытия: "+DoubleToStr(LineOpen,Digits)+
                       "\n"+Span(align)+"Линия закрытия:  "+DoubleToStr(LineClose,Digits);
     else {
         if (tic==0) {msg5="\n"+Span(align)+"Цена открытия: "+DoubleToStr(LineOpen,Digits)+
                           "\n"+Span(align)+"Цена закрытия: "+DoubleToStr(LineClose,Digits);
                      msg6="";}
         else {msg5="\n"+Span(align)+"Цена закрытия: "+DoubleToStr(LineClose,Digits);
               msg6="\n"+Span(align)+"Ордер: "+tic;}
     }
Comment("\n",Span(align),msg1,
        "\n",Span(align),msg3," КАНАЛ",
        "\n",Span(align),"Торговля:  ",msg4,
        "\n",Span(align),"Ширина канала:   ",MathAbs(MathRound(d/Point))," / ",realwidth,
        msg5,
        "\n",Span(align),"Средняя линия:   ",DoubleToStr(LineMiddle,Digits),
        "\n",Span(align),"Уровень SL:        ",DoubleToStr(LineStopLoss,Digits),
        "\n",Span(align),"Уровень TP:        ",DoubleToStr(LineTakeProfit,Digits)
//        "\n",Span(align),"",
       );
if (!expert) return(0);              // для режима ИНДИКАТОР ничего больше не надо, УХОДИМ
//----- В С Ё   Н И Ж Е С Л Е Д У Ю Щ Е Е  -  Д Л Я   Р Е Ж И М А   "Э К С П Е Р Т" ------
//+------------------------------------------------------------------+ 
//|                                Блок управления ордерами          |
//+------------------------------------------------------------------+
//подсчитаем кол-во открытых ордеров
 int oBuy=0,oSell=0;
 for(int i=OrdersTotal()-1;i>=0;i--)
   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
     if(OrderSymbol()==Symbol())
       {if(OrderType()==OP_BUY) oBuy++;
        if(OrderType()==OP_SELL) oSell++;}
    if(oBuy+oSell==0) tic=0;
//если есть ордера и цена подошла к линии закрытия - закроем ордер
 double tp=0.0;
 double sl=0.0;
 double Lot=GetLot(MaxRisk);
    if (tic>0 && Lot!=0 && buy && Bid>=LineClose-DELTA*Point && Bid<=LineClose) {
        CloseOrder(tic); tic=0; PlaySound("OrderClose.wav"); Sleep(500);}
    if (tic>0 && Lot!=0 && sell && Bid<=LineClose+DELTA*Point && Bid>=LineClose) {
        CloseOrder(tic); tic=0; PlaySound("OrderClose.wav"); Sleep(500);}
//если нет ордеров и цена подошла к линии открытия - откроем ордер
tp=0;
sl=0;
Lot=GetLot(MaxRisk);
 if(Lot==0.0) {Alert("Недостаточно средств!");return(0);}
//+----------------------------------------------------- ПОКУПКА ---+
// если нет открытых ордеров и цена в зоне открытия
if (tic==0 && Bid>=LineOpen && Bid<=LineOpen+DELTA*Point)
   {if(TAKEPROFIT!=0) tp=LineTakeProfit;
    if(STOPLOSS>0)    sl=LineStopLoss;
    tic=NewOrder(OP_BUY,Lot,Ask,tp,sl); buy = true;
        if (SoundOn&&tic>0) PlaySound("OrderBuyOpen.wav"); Sleep(500);
   }
//+----------------------------------------------------- ПРОДАЖА ---+
// если нет открытых ордеров и цена в зоне открытия
if (tic==0 && Bid<=LineOpen && Bid>=LineOpen-DELTA*Point)
   {if(TAKEPROFIT!=0) tp=LineTakeProfit;
    if(STOPLOSS>0)    sl=LineStopLoss;
    tic=NewOrder(OP_SELL,Lot,Bid,tp,sl); sell = true;
       if (SoundOn&&tic>0) PlaySound("OrderSellOpen.wav"); Sleep(500);
   }
//+------------------------------------------- И З М Е Н Е Н И Е ---+
// переставим StopLoss на безубыток, если цена на пересекла среднюю линию:
  if (tic!=0 && ((buy && Bid>=LineMiddle && sl<(OrderStopLoss()-DELTA*Point))||(sell && Bid<=LineMiddle && sl<(OrderStopLoss()+DELTA*Point)))) {
    OrderSelect(tic,SELECT_BY_TICKET,MODE_TRADES);
    sl=LineRealOpen; tp=LineTakeProfit; EditOrder(tic,sl,tp); PlaySound("StopLoss.wav"); Sleep(500);
  }
//+ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +
// переставим TakeProfit, если его значение изменилось на 2*DETLA пунктов
    if (tic!=0 && ((buy && (LineTakeProfit>=OrderTakeProfit()+2*DELTA*Point))||(sell && (LineTakeProfit<=OrderTakeProfit()-2*DELTA*Point)))) {
    OrderSelect(tic,SELECT_BY_TICKET,MODE_TRADES);
    sl=0; tp=LineTakeProfit; EditOrder(tic,sl,tp); Sleep(500);
  }
//+--------------------------------------------------------------------------------------+
//+--------------------------------------------------------------------------------------+
return(0);}//                   К О Н Е Ц   Р А Б О Т Ы
//+--------------------------------------------------------------------------------------+

