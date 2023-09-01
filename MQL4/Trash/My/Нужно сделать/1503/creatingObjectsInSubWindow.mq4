//+------------------------------------------------------------------+
//|                                   creatingObjectsInSubWindow.mq4 |
//|                                                     Antonuk Oleg |
//|                                            antonukoleg@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Antonuk Oleg"
#property link      "antonukoleg@gmail.com"

#property indicator_separate_window
#property indicator_minimum 1
#property indicator_maximum 10

bool initFinished=false;
// добавляем переменную, которая будет запоминать состояние инициализации.
// false - инициализации еще не было
// true - была

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{
   ObjectsDeleteAll();
   // удаляем все объекты
   
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   if(initFinished==false)
   {
      IndicatorShortName("NiceLine");

      int windowIndex=WindowFind("NiceLine");
   
      if(windowIndex<0)
      {
         // если номер подокна равен -1, то возникла ошибка
         Print("Can\'t find window");
         return(0);
      }  

      ObjectCreate("line",OBJ_HLINE,windowIndex,0,5.0);
      // рисуем линию в подокне нашего индикатора
               
      ObjectSet("line",OBJPROP_COLOR,GreenYellow);
      ObjectSet("line",OBJPROP_WIDTH,3);
 
      WindowRedraw();      
      // перерисовываем окно, чтобы увидить линиию   
      
      initFinished=true;
      // рисование закончено
   }
   
   return(0);
}
//+------------------------------------------------------------------+