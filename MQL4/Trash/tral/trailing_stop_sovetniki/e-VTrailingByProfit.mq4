//+----------------------------------------------------------------------------+
//|                                                   e-VTrailingByProfit.mq4  |
//|                                                    Ким Игорь В. aka KimIV  |
//|                                                       http://www.kimiv.ru  |
//|                                                                            |
//|  15.11.2009  Виртуальный трейлинг по суммарному профиту выбранных позиций. |
//|  05.01.2011  Заменил параметр ProfitTrailing на TrailingStart.             |
//+----------------------------------------------------------------------------+
#property copyright "Ким Игорь В. aka KimIV"
#property link      "http://www.kimiv.ru"

//------- Константы ------------------------------------------------------------
#define BEGIN_PROFIT -999999999        // Начальный профит

//------- Внешние параметры советника ------------------------------------------
extern string _P_Expert = "---------- Параметры советника";
extern int    NumberAccount  = 0;           // Номер торгового счёта
extern string symbol         = "";          // Торговый инструмент
                                            //   ""  - любой
                                            //   "0" - текущий
extern int    Operation      = -1;          // Торговая операция:
                                            //   -1 - любая
                                            //    0 - OP_BUY
                                            //    1 - OP_SELL
extern int    MagicNumber    = -1;          // Идентификатор
                                            //   -1 - любой
extern double TrailingStart  = 0;           // Уровень профита - Стартовый уровень трала
extern double TrailingStop   = 47;          // Фиксированный размер трала в валюте депозита
extern double TrailingStep   = 1.5;         // Шаг трала в валюте депозита

extern string _P_Performance = "---------- Параметры исполнения";
extern bool   ShowComment   = True;              // Показывать комментарий
extern bool   PrintEnable   = True;              // Разрешить печать в журнал
extern bool   AllMessages   = True;              // Протоколировать все сообщения
extern bool   UseSound      = False;             // Использовать звуковой сигнал
extern string SoundSuccess  = "ok.wav";          // Звук успеха
extern string SoundError    = "timeout.wav";     // Звук ошибки
extern int    Slippage      = 2;                 // Проскальзывание цены
extern int    NumberOfTry   = 3;                 // Количество попыток

//------- Глобальные переменные советника --------------------------------------
bool   gbDisabled  = False;            // Флаг блокировки советника
bool   gbNoInit    = False;            // Флаг неудачной инициализации
color  clCloseBuy  = Blue;             // Цвет значка закрытия покупки
color  clCloseSell = Red;              // Цвет значка закрытия продажи
double gdProfit    = BEGIN_PROFIT;     // Суммарный профит выбранных позиций

//------- Поключение внешних модулей -------------------------------------------
#include <stdlib.mqh>


//+----------------------------------------------------------------------------+
//|                                                                            |
//|  ПРЕДОПРЕДЕЛЁННЫЕ ФУНКЦИИ                                                  |
//|                                                                            |
//+----------------------------------------------------------------------------+
//|  expert initialization function                                            |
//+----------------------------------------------------------------------------+
void init() {
  gbNoInit=False;
  if (!IsTradeAllowed()) {
    Message("Для нормальной работы советника необходимо\n"+
            "Разрешить советнику торговать");
    gbNoInit=True; return;
  }
  if (!IsLibrariesAllowed()) {
    Message("Для нормальной работы советника необходимо\n"+
            "Разрешить импорт из внешних экспертов");
    gbNoInit=True; return;
  }
  if (!IsTesting()) {
    if (IsExpertEnabled()) Message("Советник будет запущен следующим тиком");
    else Message("Отжата кнопка \"Разрешить запуск советников\"");
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
    Message("Критическая ошибка! Советник ОСТАНОВЛЕН!"); return;
  }
  if (gbNoInit) {
    Message("Не удалось инициализировать советник!"); return;
  }
  if (!IsTesting()) {
    if (NumberAccount>0 && NumberAccount!=AccountNumber()) {
      Message("ЗАПРЕЩЕНА работа на счёте "+AccountNumber());
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
//|  ПОЛЬЗОВАТЕЛЬСКИЕ ФУНКЦИИ                                                  |
//|                                                                            |
//+----------------------------------------------------------------------------+
//|  Автор    : Ким Игорь В. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  Версия  : 19.02.2008                                                      |
//|  Описание: Закрытие одной предварительно выбранной позиции                 |
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
  } else Print("Некорректная торговая операция. Close ",GetNameOP(OrderType()));
}

//+----------------------------------------------------------------------------+
//|  Автор    : Ким Игорь В. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  Версия   : 19.02.2008                                                     |
//|  Описание : Закрытие позиций по рыночной цене сначала прибыльных           |
//+----------------------------------------------------------------------------+
//|  Параметры:                                                                |
//|    sy - наименование инструмента   (""   - любой символ,                   |
//|                                     NULL - текущий символ)                 |
//|    op - операция                   (-1   - любая позиция)                  |
//|    mn - MagicNumber                (-1   - любой магик)                    |
//+----------------------------------------------------------------------------+
void ClosePosFirstProfit(string sy="", int op=-1, int mn=-1) {
  int i, k=OrdersTotal();
  if (sy=="0") sy=Symbol();

  // Сначала закрываем прибыльные позиции
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
  // Потом все остальные
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
//|  Автор    : Ким Игорь В. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  Версия   : 06.03.2008                                                     |
//|  Описание : Возвращает флаг существования позиций                          |
//+----------------------------------------------------------------------------+
//|  Параметры:                                                                |
//|    sy - наименование инструмента   (""   - любой символ,                   |
//|                                     NULL - текущий символ)                 |
//|    op - операция                   (-1   - любая позиция)                  |
//|    mn - MagicNumber                (-1   - любой магик)                    |
//|    ot - время открытия             ( 0   - любое время открытия)           |
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
//|  Автор    : Ким Игорь В. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  Версия   : 01.09.2005                                                     |
//|  Описание : Возвращает наименование торговой операции                      |
//+----------------------------------------------------------------------------+
//|  Параметры:                                                                |
//|    op - идентификатор торговой операции                                    |
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
//|  Автор    : Ким Игорь В. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  Версия   : 19.02.2008                                                     |
//|  Описание : Возвращает суммарный профит открытых позиций в валюте депозита |
//+----------------------------------------------------------------------------+
//|  Параметры:                                                                |
//|    sy - наименование инструмента   (""   - любой символ,                   |
//|                                     NULL - текущий символ)                 |
//|    op - операция                   (-1   - любая позиция)                  |
//|    mn - MagicNumber                (-1   - любой магик)                    |
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
//|  Автор    : Ким Игорь В. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  Версия   : 01.02.2008                                                     |
//|  Описание : Возвращает одно из двух значений взависимости от условия.      |
//+----------------------------------------------------------------------------+
string IIFs(bool condition, string ifTrue, string ifFalse) {
  if (condition) return(ifTrue); else return(ifFalse);
}

//+----------------------------------------------------------------------------+
//|  Автор    : Ким Игорь В. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  Версия   : 01.09.2005                                                     |
//|  Описание : Вывод сообщения в коммент и в журнал                           |
//+----------------------------------------------------------------------------+
//|  Параметры:                                                                |
//|    m - текст сообщения                                                     |
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
//|  Автор    : Ким Игорь В. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  Версия   : 01.09.2005                                                     |
//|  Описание : Возвращает строку в ВЕРХНЕМ регистре                           |
//+----------------------------------------------------------------------------+
string StringUpper(string s) {
  int c, i, k=StringLen(s), n;
  for (i=0; i<k; i++) {
    n=0;
    c=StringGetChar(s, i);
    if (c>96 && c<123) n=c-32;    // a-z -> A-Z
    if (c>223 && c<256) n=c-32;   // а-я -> А-Я
    if (c==184) n=168;            //  ё  ->  Ё
    if (n>0) s=StringSetChar(s, i, n);
  }
  return(s);
}
//+----------------------------------------------------------------------------+

