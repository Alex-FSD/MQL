//+------------------------------------------------------------------+
//|                                                        MyLib.mq4 |
//|                                  Copyright c 2010, MQL ��� ����. |
//|                                                http://mql4you.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright c 2010, MQL ��� ����."
#property link      "http://mql4you.ru"
#property library
extern int  TakeProfit=0;
extern int  StopLoss=0;
//+------------------------------------------------------------------+
//|                                               �������� ��������  |
//+------------------------------------------------------------------+
bool RutineCheck() {
   bool trade = true;
if(DayOfWeek()==0||DayOfWeek()==6) trade=false;  // � ��������
                                                 // �� ��������
if(!IsTradeAllowed()) trade=false;               // ��������� ��� ����
                                                 // �������� �����
return(trade);}
//+------------------------------------------------------------------+
//|          ��������� ������������� ������� ���� ��� �������� ����� |
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
//|                                           �������� ������ ������ |
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
 if(tic<0) Print("������ �������� ������: ",GetLastError());
return(tic);}
//+------------------------------------------------------------------+
//|                         �������� ������� �� ���� ������ SELL/BUY |
//+------------------------------------------------------------------+
void DelOrders(int Cmd)
{for(int i=OrdersTotal()-1;i>=0;i--)
   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
     if(OrderType()==Cmd) DelOrder(OrderTicket());
return;}
//+------------------------------------------------------------------+
//|                                 �������� ������ �� ������ ������ |
//+------------------------------------------------------------------+
void DelOrder(int tic)
{while(!IsTradeAllowed()) Sleep(100);
 if(OrderSelect(tic,SELECT_BY_TICKET))
   if(!OrderDelete(OrderTicket(),CLR_NONE))
     Print("������ �������� ������: ",GetLastError());
return;}
//+------------------------------------------------------------------+
//| ��������� � ��������� �� ������ ������ StopLoss �/��� TakeProfit |
//+------------------------------------------------------------------+
void EditOrder(int tic,double sl, double tp)
{while(!IsTradeAllowed()) Sleep(100);
 if(OrderSelect(tic,SELECT_BY_TICKET))
   if(sl==0) sl=OrderStopLoss();
   if(tp==0) tp=OrderTakeProfit();
   if(!OrderModify(OrderTicket(),OrderOpenPrice(),sl,tp,0,CLR_NONE))
     Print("������ �������������� ������: ",GetLastError());
return;}
//+------------------------------------------------------------------+
//|                             �������� ���������� �� ������ ������ |
//+------------------------------------------------------------------+
void CloseOrder(int tic)
{double PR=0;
 while(!IsTradeAllowed()) Sleep(100);
 if(OrderType()==OP_BUY)  PR=NormalizeDouble(Bid,Digits);
 if(OrderType()==OP_SELL) PR=NormalizeDouble(Ask,Digits);
 if(OrderSelect(tic,SELECT_BY_TICKET))
   if(!OrderClose(OrderTicket(),OrderLots(),PR,3,CLR_NONE))
     Print("������ �������� ������: ",GetLastError());
return;}
//+------------------------------------------------------------------+
//|                                        ����� � ������ n �������� |
//+------------------------------------------------------------------+
string Span(int n=0) {
  string s = "";
    while (n>0) {s=s+" "; n--;}
    return (s);
    }
//+------------------------------------------------------------------+
//||
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|     � � � � �   � � � � � � � � � �   � � � � � � � � � � �      |
//+------------------------------------------------------------------+

