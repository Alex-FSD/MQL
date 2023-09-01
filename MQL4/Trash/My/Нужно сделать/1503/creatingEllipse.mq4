//+------------------------------------------------------------------+
//|                                              creatingEllipse.mq4 |
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
   ObjectsDeleteAll();
   // очистим график перед рисованием
   
   ObjectCreate("ellipse",OBJ_ELLIPSE,0,Time[100],Low[100],Time[0],High[0]);
   
   ObjectSet("ellipse",OBJPROP_SCALE,1.0);
   // изменяем соотношение сторон
   ObjectSet("ellipse",OBJPROP_COLOR,Gold);
   // заодно и цвет поменяем

   return(0);
}
//+------------------------------------------------------------------+