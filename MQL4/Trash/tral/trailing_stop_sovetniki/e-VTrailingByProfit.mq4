//+----------------------------------------------------------------------------+
//|                                                   e-VTrailingByProfit.mq4  |
//|                                                    ��� ����� �. aka KimIV  |
//|                                                       http://www.kimiv.ru  |
//|                                                                            |
//|  15.11.2009  ����������� �������� �� ���������� ������� ��������� �������. |
//|  05.01.2011  ������� �������� ProfitTrailing �� TrailingStart.             |
//+----------------------------------------------------------------------------+
#property copyright "��� ����� �. aka KimIV"
#property link      "http://www.kimiv.ru"

//------- ��������� ------------------------------------------------------------
#define BEGIN_PROFIT -999999999        // ��������� ������

//------- ������� ��������� ��������� ------------------------------------------
extern string _P_Expert = "---------- ��������� ���������";
extern int    NumberAccount  = 0;           // ����� ��������� �����
extern string symbol         = "";          // �������� ����������
                                            //   ""  - �����
                                            //   "0" - �������
extern int    Operation      = -1;          // �������� ��������:
                                            //   -1 - �����
                                            //    0 - OP_BUY
                                            //    1 - OP_SELL
extern int    MagicNumber    = -1;          // �������������
                                            //   -1 - �����
extern double TrailingStart  = 0;           // ������� ������� - ��������� ������� �����
extern double TrailingStop   = 47;          // ������������� ������ ����� � ������ ��������
extern double TrailingStep   = 1.5;         // ��� ����� � ������ ��������

extern string _P_Performance = "---------- ��������� ����������";
extern bool   ShowComment   = True;              // ���������� �����������
extern bool   PrintEnable   = True;              // ��������� ������ � ������
extern bool   AllMessages   = True;              // ��������������� ��� ���������
extern bool   UseSound      = False;             // ������������ �������� ������
extern string SoundSuccess  = "ok.wav";          // ���� ������
extern string SoundError    = "timeout.wav";     // ���� ������
extern int    Slippage      = 2;                 // ��������������� ����
extern int    NumberOfTry   = 3;                 // ���������� �������

//------- ���������� ���������� ��������� --------------------------------------
bool   gbDisabled  = False;            // ���� ���������� ���������
bool   gbNoInit    = False;            // ���� ��������� �������������
color  clCloseBuy  = Blue;             // ���� ������ �������� �������
color  clCloseSell = Red;              // ���� ������ �������� �������
double gdProfit    = BEGIN_PROFIT;     // ��������� ������ ��������� �������

//------- ���������� ������� ������� -------------------------------------------
#include <stdlib.mqh>


//+----------------------------------------------------------------------------+
//|                                                                            |
//|  ����������˨���� �������                                                  |
//|                                                                            |
//+----------------------------------------------------------------------------+
//|  expert initialization function                                            |
//+----------------------------------------------------------------------------+
void init() {
  gbNoInit=False;
  if (!IsTradeAllowed()) {
    Message("��� ���������� ������ ��������� ����������\n"+
            "��������� ��������� ���������");
    gbNoInit=True; return;
  }
  if (!IsLibrariesAllowed()) {
    Message("��� ���������� ������ ��������� ����������\n"+
            "��������� ������ �� ������� ���������");
    gbNoInit=True; return;
  }
  if (!IsTesting()) {
    if (IsExpertEnabled()) Message("�������� ����� ������� ��������� �����");
    else Message("������ ������ \"��������� ������ ����������\"");
  }
}

//+----------------------------------------------------------------------------+
//|  expert deinitialization function                                          |
//+----------------------------------------------------------------------------+
void deinit() { if (!IsTesting()) Comment(""); }

//+----------------------------------------------------------------------------+
//|  expert start function                                                     |
//+----------------------------------------------------------------------------+
void start() {
  if (gbDisabled) {
    Message("����������� ������! �������� ����������!"); return;
  }
  if (gbNoInit) {
    Message("�� ������� ���������������� ��������!"); return;
  }
  if (!IsTesting()) {
    if (NumberAccount>0 && NumberAccount!=AccountNumber()) {
      Message("��������� ������ �� ����� "+AccountNumber());
      return;
    } else Comment("");
  }

  string sy=StringUpper(symbol);
  if (ExistPositions(sy, Operation, MagicNumber)) {
    double pr=GetProfitOpenPosInCurrency(sy, Operation, MagicNumber);
    if (pr-TrailingStop>=TrailingStart) {
      if (gdProfit<pr-TrailingStop-TrailingStep) gdProfit=pr-TrailingStop;
    }
  } else gdProfit=BEGIN_PROFIT;
  if (gdProfit>=pr) {
    for (int i=0; i<NumberOfTry; i++) ClosePosFirstProfit(sy, Operation, MagicNumber);
  }
  if (!IsTesting() && ShowComment) {
    string st="NumberAccount="+DoubleToStr(NumberAccount, 0)
             +"  Symbol="+IIFs(symbol=="", "All", IIFs(symbol=="0", Symbol(), StringUpper(symbol)))
             +"  Operation="+IIFs(Operation<0, "All", GetNameOP(Operation))
             +"  MagicNumber="+IIFs(MagicNumber<0, "All", DoubleToStr(MagicNumber, 0))
             +"\n"
             +"TrailingStart="+DoubleToStr(TrailingStart, 2)+" "+AccountCurrency()
             +"TrailingStop="+DoubleToStr(TrailingStop, 2)+" "+AccountCurrency()
             +"  TrailingStep="+DoubleToStr(TrailingStep, 2)+" "+AccountCurrency()
             +"\n"
             +"Current Stop="+IIFs(gdProfit>BEGIN_PROFIT, DoubleToStr(gdProfit, 2)+" "+AccountCurrency(), "None")
             +"  Current Profit="+DoubleToStr(pr, 2)+" "+AccountCurrency()
             ;
    Comment(st);
  } else Comment("");
}


//+----------------------------------------------------------------------------+
//|                                                                            |
//|  ���������������� �������                                                  |
//|                                                                            |
//+----------------------------------------------------------------------------+
//|  �����    : ��� ����� �. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  ������  : 19.02.2008                                                      |
//|  ��������: �������� ����� �������������� ��������� �������                 |
//+----------------------------------------------------------------------------+
void ClosePosBySelect() {
  bool   fc;
  color  clClose;
  double ll, pa, pb, pp;
  int    err, it;

  if (OrderType()==OP_BUY || OrderType()==OP_SELL) {
    for (it=1; it<=NumberOfTry; it++) {
      if (!IsTesting() && (!IsExpertEnabled() || IsStopped())) break;
      while (!IsTradeAllowed()) Sleep(5000);
      RefreshRates();
      pa=MarketInfo(OrderSymbol(), MODE_ASK);
      pb=MarketInfo(OrderSymbol(), MODE_BID);
      if (OrderType()==OP_BUY) {
        pp=pb; clClose=clCloseBuy;
      } else {
        pp=pa; clClose=clCloseSell;
      }
      ll=OrderLots();
      fc=OrderClose(OrderTicket(), ll, pp, Slippage, clClose);
      if (fc) {
        if (UseSound) PlaySound(SoundSuccess); break;
      } else {
        err=GetLastError();
        if (UseSound) PlaySound(SoundError);
        if (err==146) while (IsTradeContextBusy()) Sleep(1000*11);
        Print("Error(",err,") Close ",GetNameOP(OrderType())," ",
              ErrorDescription(err),", try ",it);
        Print(OrderTicket(),"  Ask=",pa,"  Bid=",pb,"  pp=",pp);
        Print("sy=",OrderSymbol(),"  ll=",ll,"  sl=",OrderStopLoss(),
              "  tp=",OrderTakeProfit(),"  mn=",OrderMagicNumber());
        Sleep(1000*5);
      }
    }
  } else Print("������������ �������� ��������. Close ",GetNameOP(OrderType()));
}

//+----------------------------------------------------------------------------+
//|  �����    : ��� ����� �. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  ������   : 19.02.2008                                                     |
//|  �������� : �������� ������� �� �������� ���� ������� ����������           |
//+----------------------------------------------------------------------------+
//|  ���������:                                                                |
//|    sy - ������������ �����������   (""   - ����� ������,                   |
//|                                     NULL - ������� ������)                 |
//|    op - ��������                   (-1   - ����� �������)                  |
//|    mn - MagicNumber                (-1   - ����� �����)                    |
//+----------------------------------------------------------------------------+
void ClosePosFirstProfit(string sy="", int op=-1, int mn=-1) {
  int i, k=OrdersTotal();
  if (sy=="0") sy=Symbol();

  // ������� ��������� ���������� �������
  for (i=k-1; i>=0; i--) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      if ((OrderSymbol()==sy || sy=="") && (op<0 || OrderType()==op)) {
        if (OrderType()==OP_BUY || OrderType()==OP_SELL) {
          if (mn<0 || OrderMagicNumber()==mn) {
            if (OrderProfit()+OrderSwap()>0) ClosePosBySelect();
          }
        }
      }
    }
  }
  // ����� ��� ���������
  k=OrdersTotal();
  for (i=k-1; i>=0; i--) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      if ((OrderSymbol()==sy || sy=="") && (op<0 || OrderType()==op)) {
        if (OrderType()==OP_BUY || OrderType()==OP_SELL) {
          if (mn<0 || OrderMagicNumber()==mn) ClosePosBySelect();
        }
      }
    }
  }
}

//+----------------------------------------------------------------------------+
//|  �����    : ��� ����� �. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  ������   : 06.03.2008                                                     |
//|  �������� : ���������� ���� ������������� �������                          |
//+----------------------------------------------------------------------------+
//|  ���������:                                                                |
//|    sy - ������������ �����������   (""   - ����� ������,                   |
//|                                     NULL - ������� ������)                 |
//|    op - ��������                   (-1   - ����� �������)                  |
//|    mn - MagicNumber                (-1   - ����� �����)                    |
//|    ot - ����� ��������             ( 0   - ����� ����� ��������)           |
//+----------------------------------------------------------------------------+
bool ExistPositions(string sy="", int op=-1, int mn=-1, datetime ot=0) {
  int i, k=OrdersTotal();

  if (sy=="0") sy=Symbol();
  for (i=0; i<k; i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      if (OrderSymbol()==sy || sy=="") {
        if (OrderType()==OP_BUY || OrderType()==OP_SELL) {
          if (op<0 || OrderType()==op) {
            if (mn<0 || OrderMagicNumber()==mn) {
              if (ot<=OrderOpenTime()) return(True);
            }
          }
        }
      }
    }
  }
  return(False);
}

//+----------------------------------------------------------------------------+
//|  �����    : ��� ����� �. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  ������   : 01.09.2005                                                     |
//|  �������� : ���������� ������������ �������� ��������                      |
//+----------------------------------------------------------------------------+
//|  ���������:                                                                |
//|    op - ������������� �������� ��������                                    |
//+----------------------------------------------------------------------------+
string GetNameOP(int op) {
  switch (op) {
    case OP_BUY      : return("Buy");
    case OP_SELL     : return("Sell");
    case OP_BUYLIMIT : return("BuyLimit");
    case OP_SELLLIMIT: return("SellLimit");
    case OP_BUYSTOP  : return("BuyStop");
    case OP_SELLSTOP : return("SellStop");
    default          : return("Unknown Operation");
  }
}

//+----------------------------------------------------------------------------+
//|  �����    : ��� ����� �. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  ������   : 19.02.2008                                                     |
//|  �������� : ���������� ��������� ������ �������� ������� � ������ �������� |
//+----------------------------------------------------------------------------+
//|  ���������:                                                                |
//|    sy - ������������ �����������   (""   - ����� ������,                   |
//|                                     NULL - ������� ������)                 |
//|    op - ��������                   (-1   - ����� �������)                  |
//|    mn - MagicNumber                (-1   - ����� �����)                    |
//+----------------------------------------------------------------------------+
double GetProfitOpenPosInCurrency(string sy="", int op=-1, int mn=-1) {
  double p=0;
  int    i, k=OrdersTotal();

  if (sy=="0") sy=Symbol();
  for (i=0; i<k; i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      if ((OrderSymbol()==sy || sy=="") && (op<0 || OrderType()==op)) {
        if (OrderType()==OP_BUY || OrderType()==OP_SELL) {
          if (mn<0 || OrderMagicNumber()==mn) {
            p+=OrderProfit()+OrderCommission()+OrderSwap();
          }
        }
      }
    }
  }
  return(p);
}

//+----------------------------------------------------------------------------+
//|  �����    : ��� ����� �. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  ������   : 01.02.2008                                                     |
//|  �������� : ���������� ���� �� ���� �������� ������������ �� �������.      |
//+----------------------------------------------------------------------------+
string IIFs(bool condition, string ifTrue, string ifFalse) {
  if (condition) return(ifTrue); else return(ifFalse);
}

//+----------------------------------------------------------------------------+
//|  �����    : ��� ����� �. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  ������   : 01.09.2005                                                     |
//|  �������� : ����� ��������� � ������� � � ������                           |
//+----------------------------------------------------------------------------+
//|  ���������:                                                                |
//|    m - ����� ���������                                                     |
//+----------------------------------------------------------------------------+
void Message(string m) {
  static string prevMessage="";
  Comment(m);
  if (StringLen(m)>0 && PrintEnable) {
    if (AllMessages || prevMessage!=m) {
      prevMessage=m;
      Print(m);
    }
  }
}

//+----------------------------------------------------------------------------+
//|  �����    : ��� ����� �. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  ������   : 01.09.2005                                                     |
//|  �������� : ���������� ������ � ������� ��������                           |
//+----------------------------------------------------------------------------+
string StringUpper(string s) {
  int c, i, k=StringLen(s), n;
  for (i=0; i<k; i++) {
    n=0;
    c=StringGetChar(s, i);
    if (c>96 && c<123) n=c-32;    // a-z -> A-Z
    if (c>223 && c<256) n=c-32;   // �-� -> �-�
    if (c==184) n=168;            //  �  ->  �
    if (n>0) s=StringSetChar(s, i, n);
  }
  return(s);
}
//+----------------------------------------------------------------------------+

