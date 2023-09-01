//+------------------------------------------------------------------+
//|                                                        MyLib.mq4 |
//|                                  Copyright c 2010, MQL для тебя. |
//|                                                http://mql4you.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright c 2010, MQL для тебя."
#property link      "http://mql4you.ru"
//+------------------------------------------------------------------+
#import "MyLib.ex4"
//+------------------------------------------------------------------+
bool   RutineCheck();
double GetLot(int Risk);
int    NewOrder(int Cmd,double Lot,double PR=0,double TP=0,double SL=0);
void   DelOrders(int Cmd);
void   DelOrder(int tic);
void   EditOrder(int tic,double sl, double tp);
void   CloseOrder(int tic);
string Span(int n=0);

//+------------------------------------------------------------------+