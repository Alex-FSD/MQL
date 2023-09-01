//+------------------------------------------------------------------+
//|                                             LastKissSellLeft.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

int res;
double Lots = 1;
double High100 = 0.00;
double Low0 = 0.00;
double TP = 0.00;
double SL = 0.00;



void OnTick()
  {    
      OnSellOrder();     
  }