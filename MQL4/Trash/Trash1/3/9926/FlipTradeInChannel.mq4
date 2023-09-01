//+------------------------------------------------------------------+
//|                                           FlipTradeInChannel.mq4 |
//|                                   Copyright © 2010, Korvin ® Co. |
//|                                         http://alecask.narod.ru/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, Korvin ® Co."
#property link      "http://alecask.narod.ru/"
//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
// определим переменные
bool   trend,potrendu;
double TP,TPbak;
string varName; 
// Получим установленные параметры цены для нарисованного "TradeChannel"
double p1    = ObjectGet("TradeChannel",OBJPROP_PRICE1);
double p2    = ObjectGet("TradeChannel",OBJPROP_PRICE2);
double p3    = ObjectGet("TradeChannel",OBJPROP_PRICE3);
double t1    = ObjectGet("TradeChannel",OBJPROP_TIME1);
double t2    = ObjectGet("TradeChannel",OBJPROP_TIME2);
double t3    = ObjectGet("TradeChannel",OBJPROP_TIME3);
// Получим значения смещений для цен p1, p2 и p3
  bool exact = false;                             // нужна особая точность?
   int s1    = iBarShift( NULL, 0, t1, exact);    // смещение бара цены p1
   int s2    = iBarShift( NULL, 0, t2, exact);    // смещение бара цены p2
   int s3    = iBarShift( NULL, 0, t3, exact);    // смещение бара цены p3
// Вычислим ширину торгового канала d и его знак
double d     = (p3-p1) - (p2-p1)*(s1-s3)/(s1-s2); // 
   int sign  = MathRound(d/MathAbs(d));           // 
// разберёмся как задана торговля
if (p2>=p1)  trend=true;                          // тренд восходящий ...
else trend=false;                                 // или нисходящий ?
if ((trend && sign>=0)||
    (!trend && sign<0)) potrendu=true;            // торговля по тренду ...
else  potrendu=false;                             // или против тренда ?
// Присвоим новые значения цен p1, p2 и p3 для "TradeChannel"
       p1    = p1+d;
       p2    = p2+d;
       p3    = p3-d;
// Передадим эти значения в объект "TradeChannel"
       while (!exact) exact = ObjectSet("TradeChannel",OBJPROP_PRICE1,p1);
       exact = false;
       while (!exact) exact = ObjectSet("TradeChannel",OBJPROP_PRICE2,p2);
       exact = false;
       while (!exact) exact = ObjectSet("TradeChannel",OBJPROP_PRICE3,p3);
   return(0);
  }
//+------------------------------------------------------------------+