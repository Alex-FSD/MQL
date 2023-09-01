//+--------------------------------------------------------------------------------------+
//|                                                                TradeChannel_v3_0.mq4 |
//|                                                       Copyright � 2010, Korvin � Co. |
//|                                                             http://alecask.narod.ru/ |
//+--------------------------------------------------------------------------------------+
#property copyright "Copyright � 2010, Korvin � Co."
#property link      "http://alecask.narod.ru/"
#include <mylib.mqh>
extern bool   expert     = false;
extern int    MaxRisk    = 2;
extern int    STOPLOSS   = 50;
extern int    TAKEPROFIT = 50;
extern int    DELTA      = 50;
extern double FACTOR     = 1.0;
extern int    align      = 230;
extern bool   SoundOn    = false;
int  swap,tic;
bool buy,sell;
//+--------------------------------------------------------------------------------------+
//| expert initialization function                                                       |
//+--------------------------------------------------------------------------------------+
int init() {
RefreshRates();
swap = MathRound((Ask-Bid)/Point); // ��������� ��������������� �� �������
tic=0;
buy=false;
sell=false;

return(0);}
//+--------------------------------------------------------------------------------------+
//| expert deinitialization function                                                     |
//+--------------------------------------------------------------------------------------+
int deinit() {return(0);}
//+--------------------------------------------------------------------------------------+
//| expert start function                                                                |
//+--------------------------------------------------------------------------------------+
int start() {
Comment(""); // ������� ����� �� ���������� ��������
// ������� ����� �� ��������, ������������ � ������� ����:
ObjectDelete("LineMiddle");
ObjectDelete("LineRealOpen");
ObjectDelete("LineRealClose");
ObjectDelete("LineStopLoss");
ObjectDelete("LineTakeProfit");
//ObjectDelete("");
// ���� �� ������� ����� �������� - �������� ��������.
  if (!RutineCheck()) {Comment (Span(200),"�������� ���������"); return(0);}
// ��������� �� ����� "TradeChannel" ...?
//------------------ � � � � � � � � �   � � � � � � � � � � -----------------------------
string name="TradeChannel"; string msg1,msg2,msg3,msg4,msg5,msg6,msg7,msg8;
//----------------------------------------------------------------------------------------
RefreshRates(); // ������� ������ � ������� ������� �� ����� "TradeCannel"
 datetime t1=ObjectGet(name,OBJPROP_TIME1);
 datetime t2=ObjectGet(name,OBJPROP_TIME2);
 datetime t3=ObjectGet(name,OBJPROP_TIME3);
   double p1=ObjectGet(name,OBJPROP_PRICE1);
   double p2=ObjectGet(name,OBJPROP_PRICE2);
   double p3=ObjectGet(name,OBJPROP_PRICE3);
      int control=0; // ����������� �����
      int s1 = iBarShift( NULL, 0, t1, control); // �������� ���� ���� p1
      int s2 = iBarShift( NULL, 0, t2, control); // �������� ���� ���� p2
      int s3 = iBarShift( NULL, 0, t3, control); // �������� ���� ���� p3
//---------------- � � � � � � � �   � � � � � � � �   � � � � � -------------------------
// ���� ������ ���, �������� ��� ����������
int err=GetLastError();
 if (err==4202) {Comment(Span(187),"  ��������� �������� ����� � ����� ��� ��� \"TradeChannel\"."); return;}
//�������� ��� �������� ����� ��������� ��������� (�����-�������)
 if(t1>t2) {Comment(Span(219),"����������� \"",name,"\" ���������!"); return(0);}
//���� ����� ��������� ����� - ��������� ����� ������ (�������� ���)
 ObjectSet(name,OBJPROP_RAY,true);
//-------------------- � � � � � �   � � � � � � � � �   � � � � � � --------------------+
double d = (p3-p1) - (p2-p1)*(s1-s3)/(s1-s2); //                                         |
//--------------- � � � �   � � � � � �   � � � � � � � � �   � � � � � � ---------------+
int sign = MathRound(d/MathAbs(d));//                                                    |
//+--------------------------------------------------------------------------------------+
// ���� ����� ���������� - �� ������, ���� ���������� - �������.
if (p1<=p2) ObjectSet(name,OBJPROP_COLOR,Green);
else  ObjectSet(name,OBJPROP_COLOR,Red);
//---------- � � � � � � � �   � � � � � � �   � � � � �   � � � � � � -------------------
double plm1=p1+d*0.5; double plm2=p2+d*0.5; // ��������� ���� ��� ��������� ������� �����
ObjectCreate("LineMiddle",OBJ_TREND,0,t1,plm1,t2,plm2);
ObjectSet("LineMiddle",OBJPROP_STYLE,STYLE_DASHDOT);
ObjectSet("LineMiddle",OBJPROP_WIDTH,1);
ObjectSet("LineMiddle",OBJPROP_COLOR,Goldenrod);
//--------------- � � � � � � �   � � � � � � � � ����� �������� ������� ----------------+
double LineOpen = ObjectGetValueByShift(name,0);
//--------------- � � � � � � �   � � � � � � � � ����� �������� ������� ----------------+
double LineClose = LineOpen+d;
//--------------- � � � � � � �   � � � � � � � � ������� ����� -------------------------+
double LineMiddle = ObjectGetValueByShift("LineMiddle",0);
//------------- � � � � � � � � �   � � � � � � � � � � �   � � � � � � � � --------------
bool trend, potrendu;
if (p2>=p1) {trend=true; msg3=" ���������� ";}                 // ����� ���������� ...
else {trend=false; msg3=" ���������� ";}                       // ��� ���������� ?
if ((trend && sign>=0)||
    (!trend && sign<0)) {potrendu=true; msg4=" �� ������ ";}   // �������� �� ������ ...
else {potrendu=false; msg4=" ������ ������ ";}                 // ��� ������ ������ ?
//------- � � � � � � �   � � �   � � � � �   � � � � � � � � � � �   � � � � � � --------
double zona1;
if (d<0) zona1 = sign*DELTA*Point;
else zona1 = sign*(DELTA+swap)*Point;
double lro1=p1+zona1; double lro2=p2+zona1; // ��������� ���� ��� 
    ObjectCreate("LineRealOpen",OBJ_TREND,0,t1,lro1,t2,lro2);
    ObjectSet("LineRealOpen",OBJPROP_STYLE,STYLE_DASH);
    ObjectSet("LineRealOpen",OBJPROP_WIDTH,1);
if ((trend && potrendu)||(!trend && !potrendu)) ObjectSet("LineRealOpen",OBJPROP_COLOR,Lime);
else  ObjectSet("LineRealOpen",OBJPROP_COLOR,DeepPink);
double LineRealOpen = ObjectGetValueByShift("LineRealOpen",0); // ������� �������� �����
//------- � � � � � � �   � � �   � � � � �   � � � � � � � � � � �   � � � � � � --------
if (d<0) zona1 = sign*(DELTA+swap)*Point;
else zona1 = sign*DELTA*Point;
double lrc1=p1+d-zona1; double lrc2=p2+d-zona1; // ��������� ���� ��� 
ObjectCreate("LineRealClose",OBJ_TREND,0,t1,lrc1,t2,lrc2);
ObjectSet("LineRealClose",OBJPROP_STYLE,STYLE_DASH);
ObjectSet("LineRealClose",OBJPROP_WIDTH,1);
if ((trend && potrendu)||(!trend && !potrendu)) ObjectSet("LineRealClose",OBJPROP_COLOR,DeepPink);
else ObjectSet("LineRealClose",OBJPROP_COLOR,Lime);
double LineRealClose = ObjectGetValueByShift("LineRealClose",0); // ������� �������� �����
//-------------- � � � � � �   � � � � � � � �   � � � � � �   � � � � � � ---------------
int realwidth = sign*MathRound((LineRealClose-LineRealOpen)/Point);    // ��������, ����
if (realwidth<=0) {Comment("\n",Span(align),"  ����� ������� ����"); return(0);}// ����� �����
//---- � � � � � � �   � � �   � � � � �   � � � � � � � � � � � � � � �   STOP_LOSS -----
// ��������� ���� ��� ��������� LineStopLoss
double lsl1=p1-sign*STOPLOSS*Point; double lsl2=p2-sign*STOPLOSS*Point; 
ObjectCreate("LineStopLoss",OBJ_TREND,0,t1,lsl1,t2,lsl2);
ObjectSet("LineStopLoss",OBJPROP_STYLE,STYLE_DOT);
ObjectSet("LineStopLoss",OBJPROP_WIDTH,1);
ObjectSet("LineStopLoss",OBJPROP_COLOR,DeepPink);
double LineStopLoss = ObjectGetValueByShift("LineStopLoss",0); // ������� �������� �����
//--- � � � � � � �   � � �   � � � � �   � � � � � � � � � � � � � � �   TAKE_PROFIT ----
// ��������� ���� ��� ��������� LineTakeProfit
double ltp1=p1+d+sign*TAKEPROFIT*Point; double ltp2=p2+d+sign*TAKEPROFIT*Point; 
ObjectCreate("LineTakeProfit",OBJ_TREND,0,t1,ltp1,t2,ltp2);
ObjectSet("LineTakeProfit",OBJPROP_STYLE,STYLE_DOT);
ObjectSet("LineTakeProfit",OBJPROP_WIDTH,1);
ObjectSet("LineTakeProfit",OBJPROP_COLOR,DodgerBlue);
double LineTakeProfit = ObjectGetValueByShift("LineTakeProfit",0); // ������� �������� �����
//------------------------- � � � �   � � � � � �   � � � � � � -------------------------
   if (!expert) {msg1="*** ��������� ***";}
   else {msg1="**** ������� ****";}
     if (!expert) msg5="\n"+Span(align)+"����� ��������: "+DoubleToStr(LineOpen,Digits)+
                       "\n"+Span(align)+"����� ��������:  "+DoubleToStr(LineClose,Digits);
     else {
         if (tic==0) {msg5="\n"+Span(align)+"���� ��������: "+DoubleToStr(LineOpen,Digits)+
                           "\n"+Span(align)+"���� ��������: "+DoubleToStr(LineClose,Digits);
                      msg6="";}
         else {msg5="\n"+Span(align)+"���� ��������: "+DoubleToStr(LineClose,Digits);
               msg6="\n"+Span(align)+"�����: "+tic;}
     }
Comment("\n",Span(align),msg1,
        "\n",Span(align),msg3," �����",
        "\n",Span(align),"��������:  ",msg4,
        "\n",Span(align),"������ ������:   ",MathAbs(MathRound(d/Point))," / ",realwidth,
        msg5,
        "\n",Span(align),"������� �����:   ",DoubleToStr(LineMiddle,Digits),
        "\n",Span(align),"������� SL:        ",DoubleToStr(LineStopLoss,Digits),
        "\n",Span(align),"������� TP:        ",DoubleToStr(LineTakeProfit,Digits)
//        "\n",Span(align),"",
       );
if (!expert) return(0);              // ��� ������ ��������� ������ ������ �� ����, ������
//----- � � �   � � � � � � � � � � � � �  -  � � �   � � � � � �   "� � � � � � �" ------
//+------------------------------------------------------------------+ 
//|                                ���� ���������� ��������          |
//+------------------------------------------------------------------+
//���������� ���-�� �������� �������
 int oBuy=0,oSell=0;
 for(int i=OrdersTotal()-1;i>=0;i--)
   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
     if(OrderSymbol()==Symbol())
       {if(OrderType()==OP_BUY) oBuy++;
        if(OrderType()==OP_SELL) oSell++;}
    if(oBuy+oSell==0) tic=0;
//���� ���� ������ � ���� ������� � ����� �������� - ������� �����
 double tp=0.0;
 double sl=0.0;
 double Lot=GetLot(MaxRisk);
    if (tic>0 && Lot!=0 && buy && Bid>=LineClose-DELTA*Point && Bid<=LineClose) {
        CloseOrder(tic); tic=0; PlaySound("OrderClose.wav"); Sleep(500);}
    if (tic>0 && Lot!=0 && sell && Bid<=LineClose+DELTA*Point && Bid>=LineClose) {
        CloseOrder(tic); tic=0; PlaySound("OrderClose.wav"); Sleep(500);}
//���� ��� ������� � ���� ������� � ����� �������� - ������� �����
tp=0;
sl=0;
Lot=GetLot(MaxRisk);
 if(Lot==0.0) {Alert("������������ �������!");return(0);}
//+----------------------------------------------------- ������� ---+
// ���� ��� �������� ������� � ���� � ���� ��������
if (tic==0 && Bid>=LineOpen && Bid<=LineOpen+DELTA*Point)
   {if(TAKEPROFIT!=0) tp=LineTakeProfit;
    if(STOPLOSS>0)    sl=LineStopLoss;
    tic=NewOrder(OP_BUY,Lot,Ask,tp,sl); buy = true;
        if (SoundOn&&tic>0) PlaySound("OrderBuyOpen.wav"); Sleep(500);
   }
//+----------------------------------------------------- ������� ---+
// ���� ��� �������� ������� � ���� � ���� ��������
if (tic==0 && Bid<=LineOpen && Bid>=LineOpen-DELTA*Point)
   {if(TAKEPROFIT!=0) tp=LineTakeProfit;
    if(STOPLOSS>0)    sl=LineStopLoss;
    tic=NewOrder(OP_SELL,Lot,Bid,tp,sl); sell = true;
       if (SoundOn&&tic>0) PlaySound("OrderSellOpen.wav"); Sleep(500);
   }
//+------------------------------------------- � � � � � � � � � ---+
// ���������� StopLoss �� ���������, ���� ���� �� ��������� ������� �����:
  if (tic!=0 && ((buy && Bid>=LineMiddle && sl<(OrderStopLoss()-DELTA*Point))||(sell && Bid<=LineMiddle && sl<(OrderStopLoss()+DELTA*Point)))) {
    OrderSelect(tic,SELECT_BY_TICKET,MODE_TRADES);
    sl=LineRealOpen; tp=LineTakeProfit; EditOrder(tic,sl,tp); PlaySound("StopLoss.wav"); Sleep(500);
  }
//+ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +
// ���������� TakeProfit, ���� ��� �������� ���������� �� 2*DETLA �������
    if (tic!=0 && ((buy && (LineTakeProfit>=OrderTakeProfit()+2*DELTA*Point))||(sell && (LineTakeProfit<=OrderTakeProfit()-2*DELTA*Point)))) {
    OrderSelect(tic,SELECT_BY_TICKET,MODE_TRADES);
    sl=0; tp=LineTakeProfit; EditOrder(tic,sl,tp); Sleep(500);
  }
//+--------------------------------------------------------------------------------------+
//+--------------------------------------------------------------------------------------+
return(0);}//                   � � � � �   � � � � � �
//+--------------------------------------------------------------------------------------+

