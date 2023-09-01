//+------------------------------------------------------------------+
//|                                                 settingLines.mq4 |
//|                                                     Antonuk Oleg |
//|                                            antonukoleg@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Antonuk Oleg"
#property link      "antonukoleg@gmail.com"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int  start()
{
   double price=iHigh(Symbol(),PERIOD_D1,0);

   ObjectCreate("highLine",OBJ_HLINE,0,0,price);
   price=iLow(Symbol(),PERIOD_D1,0);
   ObjectCreate("lowLine",OBJ_HLINE,0,0,price);
   
   ObjectSet("highLine",OBJPROP_COLOR,LimeGreen);
   // изменяем цвет верхней линии
   ObjectSet("highLine",OBJPROP_WIDTH,3);
   // теперь линия будет толщиной в 3 пикселя
   
   ObjectSet("lowLine",OBJPROP_COLOR,Crimson);
   // изменяем цвет нижней линии
   ObjectSet("lowLine",OBJPROP_STYLE,STYLE_DOT);
   // теперь линия будет толщиной в 3 пикселя   

   return(0);
}
//+------------------------------------------------------------------+