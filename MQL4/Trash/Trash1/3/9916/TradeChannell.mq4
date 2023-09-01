//+------------------------------------------------------------------+
//|                                                TradeChannell.mq4 |
//|                                   Copyright � 2010, Korvin � Co. |
//|                                         http://alecask.narod.ru/ |
//+------------------------------------------------------------------+
#property copyright "Copyright � 2010, Korvin� Co."
#property link      "http://alecask.narod.ru/"
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|--------------- �������� "�������� � ������" ---------------------|
//| ��������  ����������  �  ������,  ��������  ���  ��������  ����� |
//| ��������� ���: "TradeCannel".                                    |
//| ��������  �����  �����������  ������  ����������  ��  ���������� |
//| ���������� � ���������� ������� �������� �������� �������.       |
//| ��������������� �����  �����������  ������ ���������� ���� ����� |
//| �������� ������� � ���������� ������� �������� �������� �������. |
//| ��������  �����  �����������  ������  ����������  ��  ���������� |
//| ��������� � ���������� ������� �������� ������ �������.          |
//| ��������������� �����  �����������  ������ ���������� ���� ����� |
//| �������� ������� � ���������� ������� �������� ������ �������.   |
//| ����� ������ ������  ���������  ��������  ����������  �� ������� |
//| ������. ������������ ����������� ������ ���� �����.              |
//| �������� Delta ���������� ���������� � ������� �� ����� �������� |
//| � ����� ��������  ������� ������� ������.  ���  ��������  ������ |
//| ����  Bid  ������ ���������� � ��������   [opr�Delta ; opr]; ��� |
//| ��������  ������  ����   Bid   ������  ����  ������  ���  ������ |
//| [cpr�Delta] � ����������� �� ���� ������ � ����������� ��������� |
//| ������, ���:                                                     |
//| opr - ������������  ��������  �����  �������� ������  �� ������� |
//|       ����;                                                      |
//| cpr - ������������  ��������  �����  �������� ������  �� ������� |
//|       ����;                                                      |
//| �������� StopLoss ������������ �� ������ ������ ������ �������.  |
//| �������� TakeProfit ������������ � 50 ������� �� ����� ��������. |
//|          �������������.                                          |
//| ��������   Risk   ���������� ������������  ����  ��� ����������� |
//| ������ � ������ ��� �������� ������������� ����. ��� ����������� |
//| ���������  �������������  �����  ������  �������  ��������  true |
//| ��������� ShowRisk.                                              |
//| �������� PoTrendu ���������� ����������� ��������  �� ��� ������ |
//| ����������� ������,  �������������  ���������  �������������� �� |
//| ������� ������  �  �� ���������  ������������  �����  �������� � |
//| �������� �������� �������.                                       |
//| ��������  �  ��������  �������   �����  ��������������  �������� |
//| ��������, ����  ��  �������� ��������  true  ��������� SoundOn � |
//| ��������� �������� �����  OrderSellOpen.wav , OrderBuyOpen.wav , |
//| � OrderClose.wav � �����: ������� ���������/sounds/....          |
//| �������� ������� ���������� �� ���������  ������������� ��� ���� |
//| ���� EURUSD; ��� ����� ���, ��� XAUUSD ��� USDJPY ����� �������� |
//| �������� ���������� � ���� � ����������������� ���������.        |
//|--------------------- ��������� ��� ������ -----------------------|
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                     Channell.mq4 |
//|                                   Copyright � 2010, Korvin � Co. |
//|                                         http://alecask.narod.ru/ |
//+------------------------------------------------------------------+
extern int    MaxRisk=2;         // ���������� ������������ ����
extern bool   ShowRisk=true;     // �������� �������� ����
extern bool   PoTrendu=true;     // ��������� �� ������?
extern int    StopLoss=50;       // ���������� StopLoss
extern int    Delta=5;           // ������ ���� ������������
extern int    DeltaFactor=2;     // ���������� ���� �������� �������
extern bool   SoundOn=true;      // �������� ����?
       int    tic = 0;           // ����� ��������� ������
       int    TakeProfit;
//+------------------------------------------------------------------+
//| ############### ���� ������������� ���������� ################## |
//+------------------------------------------------------------------+
int init() {Comment("");return(0);}
//+------------------------------------------------------------------+
//| ############### ���� ��������������� ���������� ################ |
//+------------------------------------------------------------------+
int deinit() {Comment("");return(0);} // ������� ���������
//+------------------------------------------------------------------+
//| ############# �������� ������� ��������� ������� ############### |
//+------------------------------------------------------------------+
int start()
  {
//+------------------------------------------------------------------+
//|                                   �������� ��������              |
//+------------------------------------------------------------------+
if(DayOfWeek()==0 || DayOfWeek()==6) return(0); // � ��������
                                                // �� ��������
if(!IsTradeAllowed()) return(0);                // ��������� ��� ����
                                                // �������� �����
//+------------------------------------------------------------------+
//|                                   ���� ����� � �������� ������   |
//+------------------------------------------------------------------+
string tRend=""; string Spaces="\n                          ";
string name="TradeChannel"; string str1; string str2; string str3;
RefreshRates();
//�������� ��� �������� ����� ��������� ��������� (�� �������� ����)
 datetime t1=ObjectGet(name,OBJPROP_TIME1);
 datetime t2=ObjectGet(name,OBJPROP_TIME2);
 datetime t3=ObjectGet(name,OBJPROP_TIME3);
int err=GetLastError();
 if (err==4202) {Comment(err,"  ��������� �������� ����� � ����� ��� ��� \"TradeChannel\"."); return;}
 if(t1>t2)
   {Comment("����������� ��������� �������� �����!");
    return(0);}
//��������� ����� ������ (�������� ���)
 ObjectSet(name,OBJPROP_RAY,true);
//��������� ����� (����� ��� ����)
 bool trend=false;
 double p1=ObjectGet(name,OBJPROP_PRICE1);
 double p2=ObjectGet(name,OBJPROP_PRICE2);
 double p3=ObjectGet(name,OBJPROP_PRICE3);
if(p1<p2) trend=true;
 if(trend) tRend=" ���������� ";
 else tRend=" ���������� ";
Comment(p1,"   ",p2,"   ",tRend);
double opr=ObjectGetValueByShift(name,0);// ��������� ������� ��������
                                         // ����� �������� ������� opr,
// ����� ������� �������� ����� �������� ������� cpr,
  int control=0; // ����������� �����
  int s1 = iBarShift( NULL, 0, t1, control); // �������� ���� ���� p1
  int s2 = iBarShift( NULL, 0, t2, control); // �������� ���� ���� p2
  int s3 = iBarShift( NULL, 0, t3, control); // �������� ���� ���� p3
// ������� ������������� ��������� ����� �������� �������
  double A=p2-p1; double B=s1-s2; double C=s2*p1-s1*p2;
// ������� ���������� ����� ������� ������� � �������
  double d=(A*s3+B*p3+C)/MathSqrt(MathPow(A,2.0)+MathPow(B,2.0))/MathCos(MathArctan(A/B));
  double cpr=opr+d; // ������� �������� ���� �������
  int    TakeProfit=d/Point+50;
//---------------------------------- ���� �������� ��������� ����� ---
double Free =AccountFreeMargin();
double One_Lot =MarketInfo(Symbol(),MODE_MARGINREQUIRED);
double Step =MarketInfo(Symbol(),MODE_LOTSTEP);
double Min_Lot =MarketInfo(Symbol(),MODE_MINLOT);
double Max_Lot =MarketInfo(Symbol(),MODE_MAXLOT);
double Lot =MathFloor(Free*MaxRisk/100/One_Lot/Step)*Step;
if(Lot<Min_Lot) Lot=Min_Lot;
if(Lot>Max_Lot) Lot=Max_Lot;
double MyRisk = MathFloor(Lot*10000*One_Lot/Free)/100;
//------------------------- ���� ������������ ��������� ���������� ---
    if (tic>0) str1="\n\x95 ������ ����� � "+tic;
    else str1="";
    if (ShowRisk) str2="\n\x95 ������������ ����: "+DoubleToStr(MyRisk,2)+" %";
    else str2="";
    if (PoTrendu) str3="\n\x95 ����� ������: �� ������";
    else str3="\n\x95 ����� ������: ������ ������";
    if (MathAbs(d/Point)<=15) Comment("Name=",name,"  ������� ����� ����� ��� ��������, ����� ",
                                      DoubleToStr(d/Point,0)," �������.");
      Comment("\n\x97 ",tRend,"\"",name,"\" \x97",str1,str2,
              " \n\x95 ������ ������ ",MathRound(d/Point)," �������,\n\x97 �������: \x97\n\x95 ���� �������� �������: ",
              DoubleToStr(opr,5),"\n\x95 ���� �������� �������: ",DoubleToStr(cpr,5),
              "\n\x97 �������: \x97\n\x95 Stop Loss: ",DoubleToStr((opr-StopLoss*Point),5),
              "\n\x95 Take Profit: ",DoubleToStr((opr+TakeProfit*Point),5));
//+------------------------------------------------------------------+

//���������� ���-�� �������
 int oBuy=0,oSell=0;
 for(int i=OrdersTotal()-1;i>=0;i--)
   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
     if(OrderSymbol()==Symbol())
       {if(OrderType()==OP_BUY) oBuy++;
        if(OrderType()==OP_SELL) oSell++;}
    if(oBuy+oSell==0) tic=0;
//+------------------------------------------------------------------+
//|                                   ���� �������� �������          |
//+------------------------------------------------------------------+
//���� ���� ������ � ���� ������� � ����� �������� - ������� �����
 double tp=0,sl=0;
        Lot=GetLot(MaxRisk);
 if(tic>0 && Lot!=0 && Bid<=cpr && Bid>=cpr-DeltaFactor*Delta*Point) {
     CloseOrder(tic); tic=0; PlaySound("OrderClose.wav"); Sleep(5000);}
//+------------------------------------------------------------------+
//|                                   ���� �������� �������          |
//+------------------------------------------------------------------+
//���� ��� ������� � ���� ������� � ����� �������� - ������� �����
tp=0;
sl=0;
Lot=GetLot(MaxRisk);
 if(Lot==0.0) {Alert("������������ �������!");return(0);}
 //+----------------------------------------------------- ������� ---+
if((oBuy+oSell==0 && trend && PoTrendu && Bid>=opr && Bid<=opr+Delta*Point)||
  (oBuy+oSell==0 && !trend && !PoTrendu && Bid>=opr && Bid<=opr+Delta*Point))
   {if(TakeProfit>0) tp=Ask+TakeProfit*Point;
    if(StopLoss>0) sl=Ask-StopLoss*Point;
    tic=NewOrder(OP_BUY,Lot,Ask,tp,sl);
        if (SoundOn&&tic>0) PlaySound("OrderBuyOpen.wav"); Sleep(5000);
   }
 //+----------------------------------------------------- ������� ---+
if((oBuy+oSell==0 && !trend && PoTrendu && Ask<=opr && Ask>=opr-Delta*Point)||
  (oBuy+oSell==0 && trend && !PoTrendu && Ask<=opr && Ask>=opr-Delta*Point))
   {if(TakeProfit>0) tp=Bid-TakeProfit*Point;
    if(StopLoss>0) sl=Bid+StopLoss*Point;
    tic=NewOrder(OP_SELL,Lot,Bid,tp,sl);
       if (SoundOn&&tic>0) PlaySound("OrderSellOpen.wav"); Sleep(5000);
   }
//==================================================== ����� ����� ==
   return(0);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| ################# ���� ����������� ������������ ################ |
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