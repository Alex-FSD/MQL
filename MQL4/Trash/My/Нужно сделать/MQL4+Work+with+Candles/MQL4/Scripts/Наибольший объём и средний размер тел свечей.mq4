//+------------------------------------------------------------------+
//|                 Наибольший объём и средний размер тел свечей.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#property script_show_inputs

input string Pair               = "USDJPY";       // Символ
input ENUM_TIMEFRAMES TimeFrame = PERIOD_CURRENT; // Таймфрейм


//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   ShowBarsParameters(Pair,TimeFrame);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ShowBarsParameters(string symbol, int timeframe)
  {
   Comment("");
   long VolumeMax=0; // максимальный объём
   int VolumeMaxIndex=0;// индекс бара с максимальным объёмом

   double BodySum=0;  // суммарная величина тел свечей

   for(int i=iBars(symbol,timeframe)-1; i>=0; i--)
     {
      if(VolumeMax<iVolume(symbol,timeframe,i))
        {
         VolumeMax=iVolume(symbol,timeframe,i);
         VolumeMaxIndex=i;
        }
      BodySum+=MathAbs(iOpen(symbol,timeframe,i)-iClose(symbol,timeframe,i));
     }
   Comment("На графике ",symbol,"(",timeframe,") всего: ", iBars(symbol,timeframe)," баров","\n",
           "Максимальное значение объема ",VolumeMax," получено ",
           iTime(symbol,timeframe,VolumeMaxIndex)," на баре №",VolumeMaxIndex,"\n",
           "Средняя величина тел свечей в пунктах: ", int(BodySum/SymbolInfoDouble(symbol,SYMBOL_POINT))/iBars(symbol,timeframe));

  }
//+------------------------------------------------------------------+
