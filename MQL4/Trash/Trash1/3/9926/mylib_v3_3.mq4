//+--------------------------------------------------------------------------------------+
//|                                                                       mylib_v3_3.mq4 |
//|                                                       Copyright � 2010, Korvin � Co. |
//|                                                             http://alecask.narod.ru/ |
//+--------------------------------------------------------------------------------------+
// bool RutineCheck()
// double GetLot(int Risk)
// double GetLot(int Risk)
// int NewOrder(int Cmd,double Lot,double PR=0,double TP=0,double SL=0)
// void DelOrders(int Cmd
// void DelOrder(int tic)
// void EditOrder(int tic,double sl, double tp)
// void CloseOrder(int tic)
// string Span(int n=0)
// int ErrorFix ()
//
#property copyright "Copyright c 2010, MQL ��� ����."
#property link      "http://mql4you.ru"
#property library
extern int  TakeProfit=0;
extern int  StopLoss=0;
//+--------------------------------------------------------------------------------------+
//|                                                                   �������� ��������  |
//+--------------------------------------------------------------------------------------+
bool RutineCheck() {
   bool trade = true;
if(DayOfWeek()==0||DayOfWeek()==6) trade=false;  // � ��������
                                                 // �� ��������
if(!IsTradeAllowed()) trade=false;               // ��������� ��� ����
                                                 // �������� �����
return(trade);}
//+--------------------------------------------------------------------------------------+
//|                              ��������� ������������� ������� ���� ��� �������� ����� |
//+--------------------------------------------------------------------------------------+
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
//+--------------------------------------------------------------------------------------+
//|                                                               �������� ������ ������ |
//+--------------------------------------------------------------------------------------+
int NewOrder(int Cmd, double Lot, double PR=0, double TP=0, double SL=0, int magic=0)
{
while(!IsTradeAllowed()) Sleep(100);
 if(Cmd==OP_BUY)
   {PR=NormalizeDouble(Ask,Digits);
    if(TP==0 && TakeProfit>0) TP=PR+TakeProfit*Point;
    if(SL==0 && StopLoss>0) SL=PR-StopLoss*Point;}
 if(Cmd==OP_SELL)
   {PR=NormalizeDouble(Bid,Digits);
    if(TP==0 && TakeProfit>0) TP=PR-TakeProfit*Point;
    if(SL==0 && StopLoss>0) SL=PR+StopLoss*Point;}
 int tic=OrderSend(Symbol(),Cmd,Lot,PR,3,SL,TP,"",magic,0,CLR_NONE);
 if(tic<0) Print("������ �������� ������: ",GetLastError());
return(tic);}
//+--------------------------------------------------------------------------------------+
//|                                             �������� ������� �� ���� ������ SELL/BUY |
//+--------------------------------------------------------------------------------------+
void DelOrders(int Cmd)
{for(int i=OrdersTotal()-1;i>=0;i--)
   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
     if(OrderType()==Cmd) DelOrder(OrderTicket());
return;}
//+--------------------------------------------------------------------------------------+
//|                                                     �������� ������ �� ������ ������ |
//+--------------------------------------------------------------------------------------+
void DelOrder(int tic)
{while(!IsTradeAllowed()) Sleep(100);
 if(OrderSelect(tic,SELECT_BY_TICKET))
   if(!OrderDelete(OrderTicket(),CLR_NONE))
     Print("������ �������� ������: ",GetLastError());
return;}
//+--------------------------------------------------------------------------------------+
//|                     ��������� � ��������� �� ������ ������ StopLoss �/��� TakeProfit |
//+--------------------------------------------------------------------------------------+
void EditOrder(int tic,double sl, double tp)
{while(!IsTradeAllowed()) Sleep(100);
 if(OrderSelect(tic,SELECT_BY_TICKET))
   if(sl==0) sl=OrderStopLoss();
   if(tp==0) tp=OrderTakeProfit();
   if(!OrderModify(OrderTicket(),OrderOpenPrice(),sl,tp,0,CLR_NONE))
     Print("������ �������������� ������: ",GetLastError());
return;}
//+--------------------------------------------------------------------------------------+
//|                                                 �������� ���������� �� ������ ������ |
//+--------------------------------------------------------------------------------------+
void CloseOrder(int tic)
{double PR=0;
 while(!IsTradeAllowed()) Sleep(100);
 if(OrderType()==OP_BUY)  PR=NormalizeDouble(Bid,Digits);
 if(OrderType()==OP_SELL) PR=NormalizeDouble(Ask,Digits);
 if(OrderSelect(tic,SELECT_BY_TICKET))
   if(!OrderClose(OrderTicket(),OrderLots(),PR,3,CLR_NONE))
     Print("������ �������� ������: ",GetLastError());
return;}
//+--------------------------------------------------------------------------------------+
//|                                                            ����� � ������ n �������� |
//+--------------------------------------------------------------------------------------+
string Span(int n=0) {
  string s = "\n";
    while (n>0) {s=s+" "; n--;}
    return (s);
    }
//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int GetMagic(int code)
  {
  string str;   int i=0, magic;
  while (i<=StringLen(Symbol())) {
    str = StringGetChar(Symbol(),i);
    magic = magic+MathPow(code,i)*StrToInteger(str);
  i++;}
return(magic);}
//+--------------------------------------------------------------------------------------+
//|                                                             ������� ��������� ������ |
//+--------------------------------------------------------------------------------------+
int ErrorFix(int errcode)
{
errcode=GetLastError();
//---- ���� ������, ������������ �������� ��������:
switch (errcode) {
//--------------------------------------
// 0 - ��� ������;
// 1 - ������ ��������� �������;
// 2 - ������, ��������� �������������;
// 3 - ����������� ������;
//--------------------------------------
   case 0:   errcode=0; break; // "��� ������" - ���������
   case 1:   errcode=1; Print("��� ������, �� ��������� ����������"); Sleep(500); break;
   case 2:   errcode=1; Print("����� ������"); Sleep(500); break;
   case 3:   errcode=2; Print("������������ ���������");  break;
   case 4:   errcode=1; Print("�������� ������ �����"); Sleep(500); break;
   case 5:   errcode=2; Print("������ ������ ����������� ���������");
   case 6:   errcode=1; Print("��� ����� � �������� ��������"); Sleep(500); break;
   case 7:   errcode=2; Print("������������ ����"); break;
   case 8:   errcode=1; Print("������� ������ �������"); Sleep(5000); break;
   case 9:   errcode=3; Print("������������ �������� ���������� ���������������� �������"); break;
   case 64:  errcode=2; Print("���� ������������"); break;
   case 65:  errcode=2; Print("������������ ����� �����"); break;
   case 128: errcode=1; Print("����� ���� �������� ���������� ������"); Sleep(500); break;
   case 129: errcode=2; Print("������������ ����"); break;
   case 130: errcode=2; Print("������������ �����"); break;
   case 131: errcode=2; Print("������������ �����"); break;
   case 132: errcode=1; Print(TimeToStr(TimeLocal(),TIME_DATE|TIME_MINUTES)," ����� ������, ��� ��� ���."); Sleep(3600000); break;
   case 133: errcode=1; Print(TimeToStr(TimeLocal(),TIME_DATE|TIME_MINUTES),"�������� ���������, ��� 10 �����."); Sleep(600000); break;  
   case 134: errcode=2; Print("������������ ����� ��� ���������� ��������"); break;
   case 135: errcode=2; Print("���� ����������"); break;
   case 136: errcode=1; Print("��� ���"); Sleep(500); break;
   case 137: errcode=1; Print("������ �����"); Sleep(500); break;
   case 138: errcode=2; Print("����� ����"); Sleep(500); break;
   case 139: errcode=1; Print("����� ������������ � ��� ��������������"); Sleep(5000); break;
   case 140: errcode=2; Print("��������� ������ �������"); break;
   case 141: errcode=1; Print("������� ����� ��������");  Sleep(5000); break;
   case 145: errcode=1; Print("����������� ���������, ��� ��� ����� ������� ������ � �����");  Sleep(500); break;
   case 146: errcode=1; Print("���������� �������� ������");  Sleep(500); break;
   case 147: errcode=2; Print("������������� ���� ��������� ������ ��������� ��������"); break;
   case 148: errcode=2; Print("���������� �������� � ���������� �������\n�������� �������, �������������� ��������."); break;
//---- ���� ������ ���������� MQL4-���������:
   case 4000: errcode=0; break;
   case 4001: errcode=1; Print("������������ ��������� �������"); break;
   case 4002: errcode=1; Print("������ ������� - ��� ���������"); break;
   case 4003: errcode=1; Print("��� ������ ��� ����� �������"); break;
   case 4004: errcode=1; Print("������������ ����� ����� ������������ ������"); break;
   case 4005: errcode=1; Print("�� ����� ��� ������ ��� �������� ����������"); break;
   case 4006: errcode=1; Print("��� ������ ��� ���������� ���������"); break;
   case 4007: errcode=1; Print("��� ������ ��� ��������� ������"); break;
   case 4008: errcode=1; Print("�������������������� ������"); break;
   case 4009: errcode=1; Print("�������������������� ������ � �������"); break;
   case 4010: errcode=1; Print("��� ������ ��� ���������� �������"); break;
   case 4011: errcode=1; Print("������� ������� ������"); break;
   case 4012: errcode=1; Print("������� �� ������� �� ����"); break;
   case 4013: errcode=1; Print("������� �� ����"); break;
   case 4014: errcode=1; Print("����������� �������"); break;
   case 4015: errcode=1; Print("������������ �������"); break;
   case 4016: errcode=1; Print("�������������������� ������"); break;
   case 4017: errcode=1; Print("������ DLL �� ���������"); break;
   case 4018: errcode=1; Print("���������� ��������� ����������"); break;
   case 4019: errcode=1; Print("���������� ������� �������"); break;
   case 4020: errcode=1; Print("������ ������� ������������ ������� �� ���������"); break;
   case 4021: errcode=1; Print("������������ ������ ��� ������, ������������ �� �������"); break;
   case 4022: errcode=1; Print("������� ������"); break;
   case 4050: errcode=1; Print("������������ ���������� ���������� �������"); break;
   case 4051: errcode=1; Print("������������ �������� ��������� �������"); break;
   case 4052: errcode=1; Print("���������� ������ ��������� �������"); break;
   case 4053: errcode=1; Print("������ �������"); break;
   case 4054: errcode=1; Print("������������ ������������� �������-���������"); break;
   case 4055: errcode=1; Print("������ ����������������� ����������"); break;
   case 4056: errcode=1; Print("������� ������������"); break;
   case 4057: errcode=1; Print("������ ��������� ����������� ����������"); break;
   case 4058: errcode=1; Print("���������� ���������� �� ����������"); break;
   case 4059: errcode=1; Print("������� �� ��������� � �������� ������"); break;
   case 4060: errcode=1; Print("������� �� ���������"); break;
   case 4061: errcode=1; Print("������ �������� �����"); break;
   case 4062: errcode=1; Print("��������� �������� ���� string"); break;
   case 4063: errcode=1; Print("��������� �������� ���� integer"); break;
   case 4064: errcode=1; Print("��������� �������� ���� double"); break;
   case 4065: errcode=1; Print("� �������� ��������� ��������� ������"); break;
   case 4066: errcode=1; Print("����������� ������������ ������ � ��������� ����������"); break;
   case 4067: errcode=1; Print("������ ��� ���������� �������� ��������"); break;
   case 4099: errcode=1; Print("����� �����"); break;
   case 4100: errcode=1; Print("������ ��� ������ � ������"); break;
   case 4101: errcode=1; Print("������������ ��� �����"); break;
   case 4102: errcode=1; Print("������� ����� �������� ������"); break;
   case 4103: errcode=1; Print("���������� ������� ����"); break;
   case 4104: errcode=1; Print("������������� ����� ������� � �����"); break;
   case 4105: errcode=1; Print("�� ���� ����� �� ������"); break;
   case 4106: errcode=1; Print("����������� ������"); break;
   case 4107: errcode=1; Print("������������ �������� ���� ��� �������� �������"); break;
   case 4108: errcode=1; Print("�������� ����� ������"); break;
   case 4109: errcode=1; Print("�������� �� ���������. ���������� �������� ����� ��������� ��������� ��������� � ��������� ��������."); break;
   case 4110: errcode=1; Print("������� ������� �� ���������. ���������� ��������� �������� ��������."); break;
   case 4111: errcode=1; Print("�������� ������� �� ���������. ���������� ��������� �������� ��������."); break;
   case 4200: errcode=1; Print("������ ��� ����������"); break;
   case 4201: errcode=1; Print("��������� ����������� �������� �������"); break;
   case 4202: errcode=1; Print("������ �� ����������"); break;
   case 4203: errcode=1; Print("����������� ��� �������"); break;
   case 4204: errcode=1; Print("��� ����� �������"); break;
   case 4205: errcode=1; Print("������ ��������� �������"); break;
   case 4206: errcode=1; Print("�� ������� ��������� �������"); break;
   default:   errcode=1; Print("������ ��� ������ � ��������"); break;
}return(errcode);}
//+--------------------------------------------------------------------------------------+
//| ������� |
//+--------------------------------------------------------------------------------------+
//+--------------------------------------------------------------------------------------+
//||
//+--------------------------------------------------------------------------------------+

//+--------------------------------------------------------------------------------------+
//|             � � � � �   � � � � � � � � � �   � � � � � � � � � � �                  |
//+--------------------------------------------------------------------------------------+

