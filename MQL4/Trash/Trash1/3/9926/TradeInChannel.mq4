//+--------------------------------------------------------------------------------------+
//|                                                                   TradeInChannel.mq4 |
//|                                                       Copyright � 2010, Korvin � Co. |
//|                                                             http://alecask.narod.ru/ |
//+--------------------------------------------------------------------------------------+
#property copyright "Copyright � 2010, Korvin � Co."
#property link      "http://alecask.narod.ru/"
#include <mylib_v3_3.mqh>
//#include <>
// - - - - - - - - - - - - - - - ��  ��������� - - - - - - - - - - - - - - - - - - - - - - 
extern bool   expert       = false;   // ������ � ������ �������
// - - - - - - - - - - - - - - - ������������  - - - - - - - - - - - - - - - - - - - - - -
extern int    MaxRisk      = 2;       // ������� ������������� �����
extern int    STOPLOSS     = 5;       // ��������� StopLoss 
extern int    TAKEPROFIT   = 5;       // ��������� TakeProfit
extern int    DELTA        = 5;       // ��������� ������ ���� ��������
extern double Factor       = 1.0;     // ���������� ��� ���� ��������
extern double FlipFACTOR   = 50.0;    // ���������� ��� ���� �������� �� FlipTrade
extern double TrailingStop = 25.0;    // ��������� TrailingStop, � % �� ������ ������
extern int    align        = 0;       // ����� ���������� �����
// - - - - - - - - - - - - - - - ��  ��������� - - - - - - - - - - - - - - - - - - - - - - 
extern bool   readpresets  = true;    // ��������� ������������� ��� ���������� ?
//extern
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    double    d;                                // d - ������ ��������� ������
       int    swap,tic,m,count,magic,TP,handle; //
       int    code       = 11;                  // �������������� ��� �������� = 11
    string    dir,fileName,ext;
      bool   SoundOn;                           // ���������/���������� �����
//���� SoundOn ����� �����: OrderClose.wav OrderBuyOpen.wav OrderSellOpen.wav StopLoss.wav
//----------------------------------------------------------------------------------------
//
//+#######################################################################################
//|######################### expert initialization function ##############################
//+#######################################################################################
int init() {
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
         magic = GetMagic(code);//                             ��� "7" ��� @TradeInChannel
// - - - - - - - - - - - - - - - � � � � � � � � � � � � � - - - - - - - - - - - - - - - -
//                          ��������� ����� ����� �������������
dir = "@TradeInChannel";//                                ���������� ������ �������������
ext = ".dat";//                                           ���������� ��� ������ �������������
switch (Period()) {
       case     1 : fileName = dir+"/"+Symbol()+"_M1"+ext;  break;
       case     5 : fileName = dir+"/"+Symbol()+"_M5"+ext;  break;
       case    15 : fileName = dir+"/"+Symbol()+"_M15"+ext; break;
       case    30 : fileName = dir+"/"+Symbol()+"_M30"+ext; break;
       case    60 : fileName = dir+"/"+Symbol()+"_H1"+ext;  break;
       case   240 : fileName = dir+"/"+Symbol()+"_H4"+ext;  break;
       case  1440 : fileName = dir+"/"+Symbol()+"_D1"+ext;  break;
       case  1080 : fileName = dir+"/"+Symbol()+"_W1"+ext;  break;
       case 43200 : fileName = dir+"/"+Symbol()+"_MN1"+ext; break;
       }//                   ����� ��������� ����� ����� �������������
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       handle       = FileOpen(fileName,FILE_CSV|FILE_READ,";");
// ���� ���� ���������� � ��������� ������ ������������� - ������ ��
if (readpresets && handle>=1) {
       MaxRisk       = StrToInteger(FileReadString(handle,1));
       STOPLOSS      = StrToInteger(FileReadString(handle,2));
       TAKEPROFIT    = StrToInteger(FileReadString(handle,3));
       DELTA         = StrToInteger(FileReadString(handle,4));
       Factor        = StrToDouble(FileReadString(handle,5));
       FlipFACTOR    = StrToDouble(FileReadString(handle,6));
       TrailingStop  = StrToDouble(FileReadString(handle,7));
       align         = StrToInteger(FileReadString(handle,8));
       readpresets   = StrToInteger(FileReadString(handle,9));
                      FileClose(handle);
       Comment(Span(align-10)+"���������� ������ �������������"); Sleep(800);
       }//                                  ����� ������ �������������
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
else {// �� ���� ��������� ������� - ������� �������� ���������, ��� ����� �������������
       handle       = FileOpen(fileName,FILE_CSV|FILE_WRITE,";");
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
FileWrite(handle,MaxRisk,STOPLOSS,TAKEPROFIT,DELTA,Factor,FlipFACTOR,TrailingStop,
          align,readpresets);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       Comment(Span(align-10)+"��������� ����� �������������"); Sleep(800);
       FileClose(handle);
       }//                                  ����� ������ �������������
//----------------------------------------------------------------------------------------
return(0);}//              ����� ������������ �������������
//+#######################################################################################
//|######################## expert deinitialization function #############################
//+#######################################################################################
int deinit() {
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ObjectDelete("LineMiddle");                                        // ������� �����  
ObjectDelete("LineRealOpen");                                      // �� ��������,
ObjectDelete("LineRealClose");                                     // ������������ 
ObjectDelete("LineStopLoss");                                      // ���������,
ObjectDelete("LineTakeProfit");                                    // ����� ������ ������.
//ObjectDelete("");
//----------------------------------------------------------------------------------------
return(0);}//          ����� ������������ ���������������
//+#######################################################################################
//|########################### expert start function  ####################################
//+#######################################################################################
int start() {
// - - - - - - - - � � � � � � � � � / � � � � � � � � � �   � � � � � - - - - - - - - - -
if (GlobalVariableCheck("Sound") && GlobalVariableGet("Sound")!=0) SoundOn = true;
else SoundOn = false;
//if (SoundOn) PlaySound("StopLoss.wav");// #####
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          swap = MathRound((Ask-Bid)/Point);//        ��������� ��������������� �� �������
Comment(""); //                                       ������� ����� �� ���������� ��������
//                                 ������� ����� �� ��������, ������������ � ������� ����:
ObjectDelete("LineMiddle");
ObjectDelete("LineRealOpen");
ObjectDelete("LineRealClose");
ObjectDelete("LineStopLoss");
ObjectDelete("LineTakeProfit");
//ObjectDelete("");
//                                     ���� �� ������� ����� �������� - �������� ��������.
  if (!RutineCheck()) {Comment (Span(align),"!!! �������� ��������� !!!"); return(0);}
//                                                  ��������� �� ����� "TradeChannel" ...?
//------------------ � � � � � � � � �   � � � � � � � � � � -----------------------------
string name="TradeChannel"; string msg1,msg2,msg3,msg4,msg5,msg6,msg7,msg8,msg9;
//----------------------------------------------------------------------------------------
RefreshRates(); // ������� ������ � ������� ������� �� ����� "TradeCannel"
 datetime t1=ObjectGet(name,OBJPROP_TIME1);
 datetime t2=ObjectGet(name,OBJPROP_TIME2);
 datetime t3=ObjectGet(name,OBJPROP_TIME3);
   double p1=ObjectGet(name,OBJPROP_PRICE1);
   double p2=ObjectGet(name,OBJPROP_PRICE2);
   double p3=ObjectGet(name,OBJPROP_PRICE3);
     bool exact=0; // ����������� �����
      int s1 = iBarShift( NULL, 0, t1, exact); //                    �������� ���� ���� p1
      int s2 = iBarShift( NULL, 0, t2, exact); //                    �������� ���� ���� p2
      int s3 = iBarShift( NULL, 0, t3, exact); //                    �������� ���� ���� p3
//---------------- � � � � � � � �   � � � � � � � �   � � � � � -------------------------
// ���� ������ ���, �������� ��� ����������
int err=GetLastError();
 if (err==4202) {
    Comment(Span(187),"  ��������� �������� ����� � ����� ��� ��� \"TradeChannel\".");
 return;
 }
//                         �������� ��� �������� ����� ��������� ��������� (�����-�������)
 if(t1>t2) {Comment(Span(219),"����������� \"",name,"\" ���������!"); return(0);}
//                      ���� ����� ��������� ����� - ��������� ����� ������ (�������� ���)
 ObjectSet(name,OBJPROP_RAY,true);
//-------------------- � � � � � �   � � � � � � � � �   � � � � � � --------------------+
d = (p3-p1) - (p2-p1)*(s1-s3)/(s1-s2); //                                                |
//--------------- � � � �   � � � � � �   � � � � � � � � �   � � � � � � ---------------+
int sign = MathRound(d/MathAbs(d));//                                                    |
//+--------------------------------------------------------------------------------------+
//                          ���� ����� ���������� - �� ������, ���� ���������� - �������.
if (p1<=p2) ObjectSet(name,OBJPROP_COLOR,MediumSeaGreen);
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
if (p2>=p1) {trend=true; msg3=" ���������� ";}                   // ����� ���������� ...
else {trend=false; msg3=" ���������� ";}                         // ��� ���������� ?
if ((trend && sign>=0)||
    (!trend && sign<0)) {potrendu=true; msg4=" �� ������ ";}     // �������� �� ������ ...
else {potrendu=false; msg4=" ������ ������ ";}                   // ��� ������ ������ ?
// - - - - - - - - �   � � � � �   Take Profit   � � � � � � � � ? - - - - - - - - - - - -
//                                  ��� ������ �� ������
if (potrendu) TP = TAKEPROFIT;
//                               ��� ������ ������ ������
else TP    = (-1)*MathCeil((1 - 0.01*FlipFACTOR)*MathAbs(d/Point));
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
double LineRealOpen = ObjectGetValueByShift("LineRealOpen",0); //   ������� �������� �����
//------- � � � � � � �   � � �   � � � � �   � � � � � � � � � � �   � � � � � � --------
if (d<0) zona1 = sign*(DELTA+swap)*Point;
else zona1 = sign*DELTA*Point;//                                        ��������� ���� ���
double lrc1=p1+d-zona1*Factor; double lrc2=p2+d-zona1*Factor; //            ����� ��������  
ObjectCreate("LineRealClose",OBJ_TREND,0,t1,lrc1,t2,lrc2);
ObjectSet("LineRealClose",OBJPROP_STYLE,STYLE_DASH);
ObjectSet("LineRealClose",OBJPROP_WIDTH,1);
if ((trend && potrendu)||(!trend && !potrendu)) ObjectSet("LineRealClose",OBJPROP_COLOR,DeepPink);
else ObjectSet("LineRealClose",OBJPROP_COLOR,Lime);
double LineRealClose = ObjectGetValueByShift("LineRealClose",0); // ������� �������� �����
//-------------- � � � � � �   � � � � � � � �   � � � � � �   � � � � � � ---------------
int realwidth = sign*MathRound((LineRealClose-LineRealOpen)/Point);//       ��������, ����
if (realwidth<=0) {Comment(Span(align),"  ����� ������� ����"); return(0);}//  ����� �����
//---- � � � � � � �   � � �   � � � � �   � � � � � � � � � � � � � � �   STOP_LOSS -----
//                                               ��������� ���� ��� ��������� LineStopLoss
double lsl1=p1-sign*STOPLOSS*Point; double lsl2=p2-sign*STOPLOSS*Point; 
ObjectCreate("LineStopLoss",OBJ_TREND,0,t1,lsl1,t2,lsl2);
ObjectSet("LineStopLoss",OBJPROP_STYLE,STYLE_DOT);
ObjectSet("LineStopLoss",OBJPROP_WIDTH,1);
ObjectSet("LineStopLoss",OBJPROP_COLOR,DeepPink);
double LineStopLoss = ObjectGetValueByShift("LineStopLoss",0);//    ������� �������� �����
//--- � � � � � � �   � � �   � � � � �   � � � � � � � � � � � � � � �   TAKE_PROFIT ----
// ��������� ���� ��� ��������� LineTakeProfit
double ltp1=p1+d+sign*TP*Point; double ltp2=p2+d+sign*TP*Point; 
ObjectCreate("LineTakeProfit",OBJ_TREND,0,t1,ltp1,t2,ltp2);
ObjectSet("LineTakeProfit",OBJPROP_STYLE,STYLE_DOT);
ObjectSet("LineTakeProfit",OBJPROP_WIDTH,1);
ObjectSet("LineTakeProfit",OBJPROP_COLOR,DodgerBlue);
double LineTakeProfit = ObjectGetValueByShift("LineTakeProfit",0);// ������� �������� �����
//----------------------���������� ���-�� �������� ������� ------------------------------
 int oBuy=0,oSell=0; msg8="";
 for(int i=OrdersTotal()-1;i>=0;i--)
  {
  if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) {
     if((OrderSymbol()==Symbol()) && (magic==OrderMagicNumber())) {
       if (OrderType()==OP_BUY) oBuy++;
       if (OrderType()==OP_SELL) oSell++;
        if (oBuy+oSell==0) {tic=0; msg8=Span(align-5)+"��� ����������� ������� ";}
        if (oBuy+oSell==1) {tic=OrderTicket(); msg8=Span(align-5)+"���������� ������� "+tic;}
        if (oBuy+oSell>1)  {msg8=Span(align-5)+"������ ������  ������"+
                                 Span(align-5)+"�� ���� �������� ����";}
      }
    }
  }
//------------------------- � � � �   � � � � � �   � � � � � � -------------------------
        msg9 = Span(align)+"    FlipFACTOR:   "+DoubleToStr(FlipFACTOR,2)+" %"+
        Span(align)+"      TrailingStop:   "+DoubleToStr(TrailingStop,2)+" %";
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   if (!expert) {msg1="******* ��������� *******";}
   else {msg1="******** ������� ********";}
     if (!expert) msg5=Span(align)+"����� ��������: "+DoubleToStr(LineRealOpen,Digits)+
                       Span(align)+"����� ��������:  "+DoubleToStr(LineRealClose,Digits);
     if (oBuy+oSell!=0) {
           msg5=Span(align)+"���� ��������: "+DoubleToStr(LineRealClose,Digits);
           msg6=Span(align-2)+"- - - - - - - - - - - - - - - - - - - - - -"+
                Span(align)+" ����� � : "+OrderTicket()+
                Span(align-2)+"- - - - - - - - - - - - - - - - - - - - - -";}
Comment(Span(align-5),msg1,
        Span(align),msg3," �����",
        Span(align),"��������:  ",msg4,
        Span(align),"������ ������:   ",MathAbs(MathRound(d/Point))," / ",realwidth,
        Span(align),"               ����:  ",swap," �������",
        msg9,msg6,msg5,
        Span(align),"������� �����:   ",DoubleToStr(LineMiddle,Digits),
        Span(align),"������� SL:        ",DoubleToStr(LineStopLoss,Digits),
        Span(align),"������� TP:        ",DoubleToStr(LineTakeProfit,Digits),
        Span(align-5),"=====================", msg8
//      Span(align),"",
       );
if (!expert) return(0); //              ��� ������ ��������� ������ ������ �� ����, ������
//----- � � �   � � � � � � � � � � � � �  -  � � �   � � � � � �   "� � � � � � �" ------
//+--------------------------------------------------------------------------------------+
//|                                ���� ���������� ��������                              |
//+--------------------------------------------------------------------------------------+
//+------------------------------------------------------------------------- �������� ---+
//                        ���� ���� ������ � ���� ������� � ����� �������� - ������� �����
 double tp=0.0;
 double sl=0.0;
 double Lot=GetLot(MaxRisk);
    if (oBuy+oSell!=0 && tic>0 && Lot!=0 && (OrderType()==OP_BUY) &&
        Bid>=LineClose-Factor*DELTA*Point && Bid<=LineClose) {
        CloseOrder(tic); tic=0; PlaySound("OrderClose.wav"); Sleep(500);}
    if (oBuy+oSell!=0 && tic>0 && Lot!=0 && (OrderType()==OP_SELL) &&
        Bid<=LineClose+Factor*DELTA*Point && Bid>=LineClose) {
        CloseOrder(tic); tic=0; PlaySound("OrderClose.wav"); Sleep(500);}
//                        ���� ��� ������� � ���� ������� � ����� �������� - ������� �����
tp=0;
sl=0;
Lot=GetLot(MaxRisk);
 if(Lot==0.0) {Alert("������������ �������!");return(0);}
//+-------------------------------------------------------------------------- ������� ---+
//                                        ���� ��� �������� ������� � ���� � ���� ��������
RefreshRates();
if (oBuy+oSell==0 && Bid>=LineOpen && Bid<=LineOpen+DELTA*Point)
   {if(TP!=0) tp=LineTakeProfit;
    if(STOPLOSS>0)    sl=LineStopLoss;
    tic=NewOrder(OP_BUY,Lot,Ask,tp,sl,magic);
      if (ErrorFix(0)>=2) return(0);
       sl=0; tp=0;
        if (SoundOn&&tic>0) PlaySound("OrderBuyOpen.wav"); Sleep(500);
   }
//+-------------------------------------------------------------------------- ������� ---+
//                                        ���� ��� �������� ������� � ���� � ���� ��������
if (oBuy+oSell==0 && Bid<=LineOpen && Bid>=LineOpen-DELTA*Point)
   {if(TP!=0) tp=LineTakeProfit;
    if(STOPLOSS>0)    sl=LineStopLoss;
    tic=NewOrder(OP_SELL,Lot,Bid,tp,sl,magic);
      if (ErrorFix(0)>=2) return(0);
       sl=0; tp=0;
         if (SoundOn&&tic>0) PlaySound("OrderSellOpen.wav"); Sleep(500);
   }
//+---------------------------------------------------------------- � � � � � � � � � ---+
//                  ���������� StopLoss �� ���������, ���� ���� �� ��������� ������� �����
// � �������� ��� �� ������ #####
  if (oBuy+oSell!=0 && tic>0 && potrendu) {OrderSelect(tic,SELECT_BY_TICKET,MODE_TRADES);
  if (((OrderType()==OP_BUY) && Bid>=0.01*TrailingStop*d && LineOpen>OrderStopLoss()) ||
     ((OrderType()==OP_SELL) && Bid<=0.01*TrailingStop*d && LineOpen<OrderStopLoss())) {
    tp=LineTakeProfit;
    sl=LineRealOpen+sign*Point;
      EditOrder(tic,sl,tp);
        if (ErrorFix(0)>=2) return(0);
    PlaySound("StopLoss.wav"); Sleep(500);
  }}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//                          ���������� TakeProfit, ���� ��� �������� ���������� �� 1 �����
    if (oBuy+oSell!=0 && tic!=0 && ((LineTakeProfit>=OrderTakeProfit()+Point) ||
       (LineTakeProfit<=OrderTakeProfit()-Point))) {
          OrderSelect(tic,SELECT_BY_TICKET,MODE_TRADES);
          sl=0;
          tp=LineTakeProfit;
          EditOrder(tic,sl,tp);
          sl=OrderStopLoss();
          Sleep(500);
  }
//+#######################################################################################
return(0);}//####################### � � � � �   � � � � � � #############################
//+#######################################################################################


