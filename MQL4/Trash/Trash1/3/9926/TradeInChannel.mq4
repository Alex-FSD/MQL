//+--------------------------------------------------------------------------------------+
//|                                                                   TradeInChannel.mq4 |
//|                                                       Copyright © 2010, Korvin ® Co. |
//|                                                             http://alecask.narod.ru/ |
//+--------------------------------------------------------------------------------------+
#property copyright "Copyright © 2010, Korvin ® Co."
#property link      "http://alecask.narod.ru/"
#include <mylib_v3_3.mqh>
//#include <>
// - - - - - - - - - - - - - - - по  умолчанию - - - - - - - - - - - - - - - - - - - - - - 
extern bool   expert       = false;   // работа в режиме ЭКСПЕРТ
// - - - - - - - - - - - - - - - подгружаемые  - - - - - - - - - - - - - - - - - - - - - -
extern int    MaxRisk      = 2;       // задание максимального риска
extern int    STOPLOSS     = 5;       // установка StopLoss 
extern int    TAKEPROFIT   = 5;       // установка TakeProfit
extern int    DELTA        = 5;       // установка ширины зоны открытия
extern double Factor       = 1.0;     // расширение для зоны закрытия
extern double FlipFACTOR   = 50.0;    // расширение для зоны закрытия по FlipTrade
extern double TrailingStop = 25.0;    // включение TrailingStop, в % от ширины канала
extern int    align        = 0;       // сдвиг текстового блока
// - - - - - - - - - - - - - - - по  умолчанию - - - - - - - - - - - - - - - - - - - - - - 
extern bool   readpresets  = true;    // считывать предустановки или записывать ?
//extern
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    double    d;                                // d - ширина торгового канала
       int    swap,tic,m,count,magic,TP,handle; //
       int    code       = 11;                  // индивидуальный код эксперта = 11
    string    dir,fileName,ext;
      bool   SoundOn;                           // включение/выключение звука
//•для SoundOn нужны файлы: OrderClose.wav OrderBuyOpen.wav OrderSellOpen.wav StopLoss.wav
//----------------------------------------------------------------------------------------
//
//+#######################################################################################
//|######################### expert initialization function ##############################
//+#######################################################################################
int init() {
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
         magic = GetMagic(code);//                             Код "7" для @TradeInChannel
// - - - - - - - - - - - - - - - П Р Е Д У С Т А Н О В К И - - - - - - - - - - - - - - - -
//                          генерация имени файла предустановок
dir = "@TradeInChannel";//                                директория файлов предустановок
ext = ".dat";//                                           расширение имён файлов предустановок
switch (Period()) {
       case     1 : fileName = dir+"/"+Symbol()+"_M1"+ext;  break;
       case     5 : fileName = dir+"/"+Symbol()+"_M5"+ext;  break;
       case    15 : fileName = dir+"/"+Symbol()+"_M15"+ext; break;
       case    30 : fileName = dir+"/"+Symbol()+"_M30"+ext; break;
       case    60 : fileName = dir+"/"+Symbol()+"_H1"+ext;  break;
       case   240 : fileName = dir+"/"+Symbol()+"_H4"+ext;  break;
       case  1440 : fileName = dir+"/"+Symbol()+"_D1"+ext;  break;
       case  1080 : fileName = dir+"/"+Symbol()+"_W1"+ext;  break;
       case 43200 : fileName = dir+"/"+Symbol()+"_MN1"+ext; break;
       }//                   конец генерации имени файла предустановок
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       handle       = FileOpen(fileName,FILE_CSV|FILE_READ,";");
// если файл существует и разрешено читать предустановки - читаем их
if (readpresets && handle>=1) {
       MaxRisk       = StrToInteger(FileReadString(handle,1));
       STOPLOSS      = StrToInteger(FileReadString(handle,2));
       TAKEPROFIT    = StrToInteger(FileReadString(handle,3));
       DELTA         = StrToInteger(FileReadString(handle,4));
       Factor        = StrToDouble(FileReadString(handle,5));
       FlipFACTOR    = StrToDouble(FileReadString(handle,6));
       TrailingStop  = StrToDouble(FileReadString(handle,7));
       align         = StrToInteger(FileReadString(handle,8));
       readpresets   = StrToInteger(FileReadString(handle,9));
                      FileClose(handle);
       Comment(Span(align-10)+"Используем старые предустановки"); Sleep(800);
       }//                                  конец чтения предустановок
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
else {// во всех остальных случаях - запишем заданные установки, как новые предустановки
       handle       = FileOpen(fileName,FILE_CSV|FILE_WRITE,";");
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
FileWrite(handle,MaxRisk,STOPLOSS,TAKEPROFIT,DELTA,Factor,FlipFACTOR,TrailingStop,
          align,readpresets);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       Comment(Span(align-10)+"Сохраняем новые предустановки"); Sleep(800);
       FileClose(handle);
       }//                                  конец записи предустановок
//----------------------------------------------------------------------------------------
return(0);}//              конец подпрограммы инициализации
//+#######################################################################################
//|######################## expert deinitialization function #############################
//+#######################################################################################
int deinit() {
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ObjectDelete("LineMiddle");                                        // Очистим экран  
ObjectDelete("LineRealOpen");                                      // от объектов,
ObjectDelete("LineRealClose");                                     // нарисованных 
ObjectDelete("LineStopLoss");                                      // экспертом,
ObjectDelete("LineTakeProfit");                                    // кроме самого канала.
//ObjectDelete("");
//----------------------------------------------------------------------------------------
return(0);}//          конец подпрограммы деинициализации
//+#######################################################################################
//|########################### expert start function  ####################################
//+#######################################################################################
int start() {
// - - - - - - - - В К Л Ю Ч Е Н И Е / В Ы К Л Ю Ч Е Н И Е   З В У К А - - - - - - - - - -
if (GlobalVariableCheck("Sound") && GlobalVariableGet("Sound")!=0) SoundOn = true;
else SoundOn = false;
//if (SoundOn) PlaySound("StopLoss.wav");// #####
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          swap = MathRound((Ask-Bid)/Point);//        Определим проскальзывание на графике
Comment(""); //                                       Очистим экран от предыдущих надписей
//                                 Очистим экран от объектов, нарисованных в прошлом тике:
ObjectDelete("LineMiddle");
ObjectDelete("LineRealOpen");
ObjectDelete("LineRealClose");
ObjectDelete("LineStopLoss");
ObjectDelete("LineTakeProfit");
//ObjectDelete("");
//                                     Если не пройден общий контроль - запретим торговлю.
  if (!RutineCheck()) {Comment (Span(align),"!!! Торговля запрещена !!!"); return(0);}
//                                                  Нарисован ли канал "TradeChannel" ...?
//------------------ С Т Р О К О В Ы Е   П Е Р Е М Е Н Н Ы Е -----------------------------
string name="TradeChannel"; string msg1,msg2,msg3,msg4,msg5,msg6,msg7,msg8,msg9;
//----------------------------------------------------------------------------------------
RefreshRates(); // Обновим данные и сделаем запросы по имени "TradeCannel"
 datetime t1=ObjectGet(name,OBJPROP_TIME1);
 datetime t2=ObjectGet(name,OBJPROP_TIME2);
 datetime t3=ObjectGet(name,OBJPROP_TIME3);
   double p1=ObjectGet(name,OBJPROP_PRICE1);
   double p2=ObjectGet(name,OBJPROP_PRICE2);
   double p3=ObjectGet(name,OBJPROP_PRICE3);
     bool exact=0; // контрольная цифра
      int s1 = iBarShift( NULL, 0, t1, exact); //                    смещение бара цены p1
      int s2 = iBarShift( NULL, 0, t2, exact); //                    смещение бара цены p2
      int s3 = iBarShift( NULL, 0, t3, exact); //                    смещение бара цены p3
//---------------- Н А Р И С У Е М   Т О Р Г О В Ы Й   К А Н А Л -------------------------
// Если канала нет, попросим его нарисовать
int err=GetLastError();
 if (err==4202) {
    Comment(Span(187),"  Нарисуйте торговый канал и дайте ему имя \"TradeChannel\".");
 return;
 }
//                         проверим что торговый канал нарисован правильно (слева-направо)
 if(t1>t2) {Comment(Span(219),"Расположите \"",name,"\" правильно!"); return(0);}
//                      Если канал нарисован верно - продолжим линии канала (свойство луч)
 ObjectSet(name,OBJPROP_RAY,true);
//-------------------- Ш И Р И Н А   Т О Р Г О В О Г О   К А Н А Л А --------------------+
d = (p3-p1) - (p2-p1)*(s1-s3)/(s1-s2); //                                                |
//--------------- З Н А К   Ш И Р И Н Ы   Т О Р Г О В О Г О   К А Н А Л А ---------------+
int sign = MathRound(d/MathAbs(d));//                                                    |
//+--------------------------------------------------------------------------------------+
//                          Если канал восходящий - он зелёный, если нисходящий - красный.
if (p1<=p2) ObjectSet(name,OBJPROP_COLOR,MediumSeaGreen);
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
if (p2>=p1) {trend=true; msg3=" ВОСХОДЯЩИЙ ";}                   // тренд восходящий ...
else {trend=false; msg3=" НИСХОДЯЩИЙ ";}                         // или нисходящий ?
if ((trend && sign>=0)||
    (!trend && sign<0)) {potrendu=true; msg4=" ПО ТРЕНДУ ";}     // торговля по тренду ...
else {potrendu=false; msg4=" ПРОТИВ ТРЕНДА ";}                   // или против тренда ?
// - - - - - - - - С   К А К И М   Take Profit   Р А Б О Т А Т Ь ? - - - - - - - - - - - -
//                                  для работы по тренду
if (potrendu) TP = TAKEPROFIT;
//                               для работы против тренда
else TP    = (-1)*MathCeil((1 - 0.01*FlipFACTOR)*MathAbs(d/Point));
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
double LineRealOpen = ObjectGetValueByShift("LineRealOpen",0); //   текущее значение линии
//------- П О К А Ж Е М   Г Д Е   Б У Д У Т   З А К Р Ы В А Т Ь С Я   О Р Д Е Р А --------
if (d<0) zona1 = sign*(DELTA+swap)*Point;
else zona1 = sign*DELTA*Point;//                                        Параметры цены для
double lrc1=p1+d-zona1*Factor; double lrc2=p2+d-zona1*Factor; //            линии закрытия  
ObjectCreate("LineRealClose",OBJ_TREND,0,t1,lrc1,t2,lrc2);
ObjectSet("LineRealClose",OBJPROP_STYLE,STYLE_DASH);
ObjectSet("LineRealClose",OBJPROP_WIDTH,1);
if ((trend && potrendu)||(!trend && !potrendu)) ObjectSet("LineRealClose",OBJPROP_COLOR,DeepPink);
else ObjectSet("LineRealClose",OBJPROP_COLOR,Lime);
double LineRealClose = ObjectGetValueByShift("LineRealClose",0); // текущее значение линии
//-------------- Н А Й Д Е М   Р Е А Л Ь Н У Ю   Ш И Р И Н У   К А Н А Л А ---------------
int realwidth = sign*MathRound((LineRealClose-LineRealOpen)/Point);//       Закончим, если
if (realwidth<=0) {Comment(Span(align),"  КАНАЛ СЛИШКОМ УЗОК"); return(0);}//  узкий канал
//---- П О К А Ж Е М   Г Д Е   Б У Д Е Т   У С Т А Н А В Л И В А Т Ь С Я   STOP_LOSS -----
//                                               Параметры цены для рисования LineStopLoss
double lsl1=p1-sign*STOPLOSS*Point; double lsl2=p2-sign*STOPLOSS*Point; 
ObjectCreate("LineStopLoss",OBJ_TREND,0,t1,lsl1,t2,lsl2);
ObjectSet("LineStopLoss",OBJPROP_STYLE,STYLE_DOT);
ObjectSet("LineStopLoss",OBJPROP_WIDTH,1);
ObjectSet("LineStopLoss",OBJPROP_COLOR,DeepPink);
double LineStopLoss = ObjectGetValueByShift("LineStopLoss",0);//    текущее значение линии
//--- П О К А Ж Е М   Г Д Е   Б У Д Е Т   У С Т А Н А В Л И В А Т Ь С Я   TAKE_PROFIT ----
// Параметры цены для рисования LineTakeProfit
double ltp1=p1+d+sign*TP*Point; double ltp2=p2+d+sign*TP*Point; 
ObjectCreate("LineTakeProfit",OBJ_TREND,0,t1,ltp1,t2,ltp2);
ObjectSet("LineTakeProfit",OBJPROP_STYLE,STYLE_DOT);
ObjectSet("LineTakeProfit",OBJPROP_WIDTH,1);
ObjectSet("LineTakeProfit",OBJPROP_COLOR,DodgerBlue);
double LineTakeProfit = ObjectGetValueByShift("LineTakeProfit",0);// текущее значение линии
//----------------------подсчитаем кол-во открытых ордеров ------------------------------
 int oBuy=0,oSell=0; msg8="";
 for(int i=OrdersTotal()-1;i>=0;i--)
  {
  if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) {
     if((OrderSymbol()==Symbol()) && (magic==OrderMagicNumber())) {
       if (OrderType()==OP_BUY) oBuy++;
       if (OrderType()==OP_SELL) oSell++;
        if (oBuy+oSell==0) {tic=0; msg8=Span(align-5)+"НЕТ УПРАВЛЯЕМЫХ ОРДЕРОВ ";}
        if (oBuy+oSell==1) {tic=OrderTicket(); msg8=Span(align-5)+"УПРАВЛЕНИЕ ОРДЕРОМ "+tic;}
        if (oBuy+oSell>1)  {msg8=Span(align-5)+"БОЛЬШЕ ОДНОГО  ОРДЕРА"+
                                 Span(align-5)+"ПО ЭТОЙ ВАЛЮТНОЙ ПАРЕ";}
      }
    }
  }
//------------------------- Б Л О К   В Ы В О Д А   Т Е К С Т А -------------------------
        msg9 = Span(align)+"    FlipFACTOR:   "+DoubleToStr(FlipFACTOR,2)+" %"+
        Span(align)+"      TrailingStop:   "+DoubleToStr(TrailingStop,2)+" %";
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   if (!expert) {msg1="******* ИНДИКАТОР *******";}
   else {msg1="******** ЭКСПЕРТ ********";}
     if (!expert) msg5=Span(align)+"Линия открытия: "+DoubleToStr(LineRealOpen,Digits)+
                       Span(align)+"Линия закрытия:  "+DoubleToStr(LineRealClose,Digits);
     if (oBuy+oSell!=0) {
           msg5=Span(align)+"Цена закрытия: "+DoubleToStr(LineRealClose,Digits);
           msg6=Span(align-2)+"- - - - - - - - - - - - - - - - - - - - - -"+
                Span(align)+" Ордер № : "+OrderTicket()+
                Span(align-2)+"- - - - - - - - - - - - - - - - - - - - - -";}
Comment(Span(align-5),msg1,
        Span(align),msg3," КАНАЛ",
        Span(align),"Торговля:  ",msg4,
        Span(align),"Ширина канала:   ",MathAbs(MathRound(d/Point))," / ",realwidth,
        Span(align),"               Своп:  ",swap," пунктов",
        msg9,msg6,msg5,
        Span(align),"Средняя линия:   ",DoubleToStr(LineMiddle,Digits),
        Span(align),"Уровень SL:        ",DoubleToStr(LineStopLoss,Digits),
        Span(align),"Уровень TP:        ",DoubleToStr(LineTakeProfit,Digits),
        Span(align-5),"=====================", msg8
//      Span(align),"",
       );
if (!expert) return(0); //              для режима ИНДИКАТОР ничего больше не надо, УХОДИМ
//----- В С Ё   Н И Ж Е С Л Е Д У Ю Щ Е Е  -  Д Л Я   Р Е Ж И М А   "Э К С П Е Р Т" ------
//+--------------------------------------------------------------------------------------+
//|                                Блок управления ордерами                              |
//+--------------------------------------------------------------------------------------+
//+------------------------------------------------------------------------- ЗАКРЫТИЕ ---+
//                        если есть ордера и цена подошла к линии закрытия - закроем ордер
 double tp=0.0;
 double sl=0.0;
 double Lot=GetLot(MaxRisk);
    if (oBuy+oSell!=0 && tic>0 && Lot!=0 && (OrderType()==OP_BUY) &&
        Bid>=LineClose-Factor*DELTA*Point && Bid<=LineClose) {
        CloseOrder(tic); tic=0; PlaySound("OrderClose.wav"); Sleep(500);}
    if (oBuy+oSell!=0 && tic>0 && Lot!=0 && (OrderType()==OP_SELL) &&
        Bid<=LineClose+Factor*DELTA*Point && Bid>=LineClose) {
        CloseOrder(tic); tic=0; PlaySound("OrderClose.wav"); Sleep(500);}
//                        если нет ордеров и цена подошла к линии открытия - откроем ордер
tp=0;
sl=0;
Lot=GetLot(MaxRisk);
 if(Lot==0.0) {Alert("Недостаточно средств!");return(0);}
//+-------------------------------------------------------------------------- ПОКУПКА ---+
//                                        если нет открытых ордеров и цена в зоне открытия
RefreshRates();
if (oBuy+oSell==0 && Bid>=LineOpen && Bid<=LineOpen+DELTA*Point)
   {if(TP!=0) tp=LineTakeProfit;
    if(STOPLOSS>0)    sl=LineStopLoss;
    tic=NewOrder(OP_BUY,Lot,Ask,tp,sl,magic);
      if (ErrorFix(0)>=2) return(0);
       sl=0; tp=0;
        if (SoundOn&&tic>0) PlaySound("OrderBuyOpen.wav"); Sleep(500);
   }
//+-------------------------------------------------------------------------- ПРОДАЖА ---+
//                                        если нет открытых ордеров и цена в зоне открытия
if (oBuy+oSell==0 && Bid<=LineOpen && Bid>=LineOpen-DELTA*Point)
   {if(TP!=0) tp=LineTakeProfit;
    if(STOPLOSS>0)    sl=LineStopLoss;
    tic=NewOrder(OP_SELL,Lot,Bid,tp,sl,magic);
      if (ErrorFix(0)>=2) return(0);
       sl=0; tp=0;
         if (SoundOn&&tic>0) PlaySound("OrderSellOpen.wav"); Sleep(500);
   }
//+---------------------------------------------------------------- И З М Е Н Е Н И Е ---+
//                  переставим StopLoss на безубыток, если цена на пересекла среднюю линию
// и торговля идёт ПО ТРЕНДУ #####
  if (oBuy+oSell!=0 && tic>0 && potrendu) {OrderSelect(tic,SELECT_BY_TICKET,MODE_TRADES);
  if (((OrderType()==OP_BUY) && Bid>=0.01*TrailingStop*d && LineOpen>OrderStopLoss()) ||
     ((OrderType()==OP_SELL) && Bid<=0.01*TrailingStop*d && LineOpen<OrderStopLoss())) {
    tp=LineTakeProfit;
    sl=LineRealOpen+sign*Point;
      EditOrder(tic,sl,tp);
        if (ErrorFix(0)>=2) return(0);
    PlaySound("StopLoss.wav"); Sleep(500);
  }}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//                          переставим TakeProfit, если его значение изменилось на 1 пункт
    if (oBuy+oSell!=0 && tic!=0 && ((LineTakeProfit>=OrderTakeProfit()+Point) ||
       (LineTakeProfit<=OrderTakeProfit()-Point))) {
          OrderSelect(tic,SELECT_BY_TICKET,MODE_TRADES);
          sl=0;
          tp=LineTakeProfit;
          EditOrder(tic,sl,tp);
          sl=OrderStopLoss();
          Sleep(500);
  }
//+#######################################################################################
return(0);}//####################### К О Н Е Ц   Р А Б О Т Ы #############################
//+#######################################################################################


