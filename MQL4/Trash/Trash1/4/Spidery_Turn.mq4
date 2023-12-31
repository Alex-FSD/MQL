//+------------------------------------------------------------------+
//|                                                 Spidery_Turn.mq4 |
//|                                         Copyright © 2010, Andres |
//|                                                  http://mql5.su/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, Andres"
#property link      "http://mql5.su/"
#property version   "1.0"

//------- Внешние параметры советника --------------------------------
extern double Lots                = 0.1;         // Размер торгуемого лота
extern int    SLandTP             = 12;          // Размер SL и TP
extern int    MinMultTPnextCycle  = 6;           // Размер мин. множителя TP для сл. цикла
extern int    OpenHour_1          = 8;           // Час открытия ордера 1
extern int    OpenMinute_1        = 0;           // Минуты открытия ордера 1
extern int    OpenHour_2          = 16;          // Час открытия ордера 2
extern int    OpenMinute_2        = 30;          // Минуты открытия ордера 2
 bool   InvisibleOrders = true;            // Использовать невидимые ордера
extern int    Slippage            = 3;           // Проскальзывание


//---- Глобальные переменные советника -------------------------------
int StopLoss;                                    // Значение SL
int TakeProfit;                                  // Значение TP
int dig_ret = 1;                                 // Множитель для 5-ти знака
string name = "Spidery Turn ";                   // Название советника
int magic;                                       // Магик номер ордеров
string comment;                                  // Комментарий к ордеру
string opentime_1, opentime_2;                   // Время в формате текста
bool work=true;                                  // Эксперт будет работать
int Tip[2];                                      // Массив типов открываемых поз.
int distTP;                                      // Максимальная дист. до ТП
int nocyc;                                       // Счетчик пустых циклов
int numcyc;                                      // Перем. поз. с наиб. расст. до ТП


//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init() {
  if (Digits==5 || Digits==3) dig_ret=10;        // Проверка брокера на 5-ти знак
  if (IsTesting()) name = "Test "+name;          // Для тестирования изменяем имя
  StopLoss = SLandTP;                            // Присваиваем знач. SL
  TakeProfit = SLandTP;                          // Присваиваем знач. TP
  comment = name + Symbol() + Period();          // Генерация комментария к ордеру
  magic = makeMagicNumber(comment);              // Генерация магик ордера
  opentime_1 = TimeToText(OpenHour_1, OpenMinute_1);       // Перевод времени в текст
  opentime_2 = TimeToText(OpenHour_2, OpenMinute_2);       // Перевод времени в текст
  if (GlobalVariableGet(comment+" CY.#") > 2)    // Если есть позиции
    ArrayResize(Tip, GlobalVariableGet(comment+" CY.#"));  // Актуализируем размер массива
  return(0);
}
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit() {
  Comment("");
  DelCommentForChart();
  if (IsTesting()) {
    for (int i=0; i<100-1; i++) {
      GlobalVariableDel(comment+" TM."+i);
      GlobalVariableDel(comment+" TP."+i);
    }
    GlobalVariableDel(comment+" CY.#");
  }
  return(0);
}
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start() {
  int reduction_tp;                              // Величина уменьшения ТП
  int newnum;                                    // Номер нового цикла
  int newsize;                                   // Новый размер массива
  nocyc = 0;                                     // Обнуляем счетчик пустых циклов
  if (work==false) {                             // Критическая ошибка
      Alert("Эксперт ", comment, "не работает");
      return;                                    // Выход из start()
  }
  for (int i=0; i<ArraySize(Tip)-1; i++) {
    if (ExistPosition(i)) {                      // Проверяем наличие откр. поз.
      if (PurposeStopLoss(StopLoss*dig_ret, i)) {// Если дошла до СЛ
        if (ClosePosition(true, i)) {      // Закрываем позицию
          if (OpenPosition(Tip[i], i))           // Открываем встречную позицию
            GlobalVariableSet(comment+" TP."+i, (GlobalVariableGet(comment+" TP."+i)-PurposeProfitLastOrder(i)));
          break;
        }
      }
      if (PurposeTakeProfit(GlobalVariableGet(comment+" TP."+i), i)) // Если дошла до ТП
        if (ClosePosition(false, i)) {    // Закрываем позицию
          numcyc=DefinitionMaxDistanceTP();      // Находим поз. с наиб. расст. до ТП
          reduction_tp=TotalOrdersProfit(i);     // Вычисляем вел. уменьш. ТП
          if (reduction_tp <= Slippage*dig_ret)
            reduction_tp=TakeProfit*dig_ret;     // Если она полож. то присваиваем отр.
          GlobalVariableSet(comment+" TP."+numcyc,
            (GlobalVariableGet(comment+" TP."+numcyc)-reduction_tp));
          GlobalVariableDel(comment+" TP."+i);   // Вычисляем уменьшение ТП и удаляем тек. перем.
          if (i!=0 && i==ArraySize(Tip)-2) {     // Если цикл последний и не единственный
            while(ArraySize(Tip)!=i+1) ArrayResize(Tip, i+1);        // Уменьшаем размер массива Tip на 1
            GlobalVariableSet(comment+" CY.#", i+1);
          }
          break;
        }
      numcyc=DefinitionMaxDistanceTP();          // Обновляем переменную distTP
      if (GlobalVariableGet(comment+" TP."+i) >= MinMultTPnextCycle*TakeProfit*dig_ret ||
        distTP >= (MinMultTPnextCycle-1)*TakeProfit*dig_ret)         // или дист. до макс. ТП велика
        if (i==CriterionOrNumber(TakeProfit*dig_ret, Slippage*dig_ret)) {      // Если есть крит. откр. встречной позиции
          newnum=ArraySize(Tip)-1;               // Запоминаем номер нового цикла
          Print("i=", i, " newnum=", newnum);
          if (OpenPosition(Tip[newnum], newnum)) {         // Открываем поз. нового цикла
            GlobalVariableSet(comment+" TP."+newnum, TakeProfit*dig_ret);
            GlobalVariableSet(comment+" TM."+newnum, TimeCurrent()); // Ставим текущее время переменной
            newsize=ArraySize(Tip)+1;
            while(ArraySize(Tip)!=newsize) ArrayResize(Tip, newsize);          // Увеличиваем размер массива Tip на 1
            GlobalVariableSet(comment+" CY.#", ArraySize(Tip));
          }
        }
    }
    else nocyc+=1;
  }
  CommentForChart();
  if (ArraySize(Tip) == nocyc+1) {                         // Если все циклы пустые...
    for (int j=0; j<ArraySize(Tip)-1; j++)
      GlobalVariableSet(comment+" TM."+j, TimeCurrent());  // Ставим текущее время всех переменных
    while(ArraySize(Tip)!=2) ArrayResize(Tip, 2);          // Возвращаем размер массива Tip равным 2
    GlobalVariableSet(comment+" CY.#", 2);
    DelCommentForChart();
  }
  if (TimeToStr(TimeCurrent(), TIME_MINUTES)==opentime_1 && ArraySize(Tip)==2)
    if (OpenPosition(PositionDirection(), 0)) {
      GlobalVariableSet(comment+" TP."+0, TakeProfit*dig_ret);       // Присваиваем гл. пер. зачение ТП
      GlobalVariableSet(comment+" TM."+0, TimeCurrent());  // Ставим текущее время переменной
    }
  if (TimeToStr(TimeCurrent(), TIME_MINUTES)==opentime_2 && ArraySize(Tip)==2)
    if (OpenPosition(PositionDirection(), 0)) {
      GlobalVariableSet(comment+" TP."+0, TakeProfit*dig_ret);       // Присваиваем гл. пер. зачение ТП
      GlobalVariableSet(comment+" TM."+0, TimeCurrent());  // Ставим текущее время переменной
    }

   

  return(0);
}
//+------------------------------------------------------------------+
//| Проверка сработки Тейк Профита                                   |
//| Параметры:                                                       |
//|   TP   - Take Profit ордера                                      |
//|   cyc  - номер цикла позиций                                     |
//+------------------------------------------------------------------+
bool PurposeTakeProfit(double TP, int cyc) {
  double tp;
  for (int i=0; i<OrdersTotal(); i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      if (OrderSymbol()==Symbol() && OrderMagicNumber()==magic+cyc) {
        if (OrderType()==OP_BUY) {
          tp = OrderOpenPrice()+TP*Point;
          if (Bid >= tp) return(true);
        }
        if (OrderType()==OP_SELL) {
          tp = OrderOpenPrice()-TP*Point;
          if (Ask <= tp) return(true);
        }
      }
    }
  }
  return(false);
}  
//+------------------------------------------------------------------+
//| Проверка сработки Стоп Лосса                                     |
//| Параметры:                                                       |
//|   SL   - Stop Loss ордера                                        |
//|   cyc  - номер цикла позиций                                     |
//+------------------------------------------------------------------+
bool PurposeStopLoss(int SL, int cyc) {
  double sl;
  for (int i=0; i<OrdersTotal(); i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      if (OrderSymbol()==Symbol() && OrderMagicNumber()==magic+cyc) {
        if (OrderType()==OP_BUY) {
          sl = OrderOpenPrice()-SL*Point;
          if (Bid <= sl) return(true);
        }
        if (OrderType()==OP_SELL) {
          sl = OrderOpenPrice()+SL*Point;
          if (Ask >= sl) return(true);
        }
      }
    }
  }
  return(false);
}  
//+------------------------------------------------------------------+
//| Проверка Прибыли последнего закрытого ордера                     |
//| Параметры:                                                       |
//|   cyc  - номер цикла позиций                                     |
//+------------------------------------------------------------------+
int PurposeProfitLastOrder(int cyc) {
  datetime tto;
  int tpo;
  for (int i=0; i<OrdersHistoryTotal(); i++) {
    if (OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) {
      Print ("Ошибка при доступе к исторической базе #",GetLastError());
      return(-StopLoss*dig_ret);
    }
    if (OrderSymbol()!=Symbol() || OrderMagicNumber()!=magic+cyc)
      continue;
    if (OrderSymbol()==Symbol() && OrderMagicNumber()==magic+cyc) {
      if (OrderCloseTime()>GlobalVariableGet(comment+" TM."+cyc)) {
        if (OrderCloseTime()>tto) {
          tto=OrderCloseTime();
          if (OrderType()==OP_BUY) tpo=NormalizeDouble((OrderClosePrice()-OrderOpenPrice())/Point,0);
          if (OrderType()==OP_SELL) tpo=NormalizeDouble((OrderOpenPrice()-OrderClosePrice())/Point,0);
        }
      }
    }
  }
  return(tpo);           
}
//+------------------------------------------------------------------+
//| Проверка Прибыли всех ордеров цикла                              |
//| Параметры:                                                       |
//|   cyc  - номер цикла позиций                                     |
//+------------------------------------------------------------------+
int TotalOrdersProfit(int cyc) {
  int tpo, ttpo;
  for (int i=0; i<OrdersHistoryTotal(); i++) {
    if (OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) {
      Print ("Ошибка при доступе к исторической базе #",GetLastError());
      return(TakeProfit*dig_ret);
    }
    if (OrderSymbol()!=Symbol() || OrderMagicNumber()!=magic+cyc)
      continue;
    if (OrderSymbol()==Symbol() && OrderMagicNumber()==magic+cyc) {
      if (OrderCloseTime()>GlobalVariableGet(comment+" TM."+cyc)) {
        if (OrderType()==OP_BUY) {
          tpo=NormalizeDouble((OrderClosePrice()-OrderOpenPrice())/Point,0);
          ttpo=ttpo+tpo;
        }
        if (OrderType()==OP_SELL) {
          tpo=NormalizeDouble((OrderOpenPrice()-OrderClosePrice())/Point,0);
          ttpo=ttpo+tpo;
        }
      }
    }
  }
  return(ttpo);           
}
//+------------------------------------------------------------------+
//| Определение цикла с наибольшим расстоянием до ТП                 |
//+------------------------------------------------------------------+
int DefinitionMaxDistanceTP() {
  double dtp;
  double tp;
  int number;
  for (int j=0; j<ArraySize(Tip)-1; j++) {
    for (int i=0; i<OrdersTotal(); i++) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
        if (OrderSymbol()==Symbol() && OrderMagicNumber()==magic+j) {
          if (OrderType()==OP_BUY) {
            tp = OrderOpenPrice()+GlobalVariableGet(comment+" TP."+j)*Point;   // Определяем ТП позиции
            if (dtp < tp-Bid) {                  // Проверяем расстояние до ТП поз.
              dtp = tp - Bid;                    // Запоминаем новое расст. до ТП поз.
              number = j;
            }
          }
          if (OrderType()==OP_SELL) {
            tp = OrderOpenPrice()-GlobalVariableGet(comment+" TP."+j)*Point;   // Определяем ТП позиции
            if (dtp < Ask-tp) {                  // Проверяем расстояние до ТП поз.
              dtp = Ask - tp;                    // Запоминаем новое расст. до ТП поз.
              number = j;
            }
          }
        }
      }
    }
  }
  distTP = NormalizeDouble(dtp/Point,0);         // Запоминаем макс. дист до ТП
  return(number);
}
//+------------------------------------------------------------------+
//| Опред. критерия неоткрытия встречной позиции или номера цикла    |
//| Параметры:                                                       |
//|   tp    - Дистанция для открытия встречной позиции               |
//|   slp   - Дельта для открытия встречной позиции                  |
//+------------------------------------------------------------------+
int CriterionOrNumber(int tp, int slp) {
  double max, min;
  datetime tm;
  int number;
  for (int j=0; j<ArraySize(Tip)-1; j++) {
    for (int i=0; i<OrdersTotal(); i++) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
        if (OrderSymbol()==Symbol() && OrderMagicNumber()==magic+j) {
          if (OrderType()==OP_BUY) {
            if (OrderOpenTime()>tm) {
              tm=OrderOpenTime();                // Ищем последнюю открытую поз...
              number = j;                        // ...и запоминаем её цикл
            }
            if (OrderOpenPrice()>max) max=OrderOpenPrice();          // Ищем верхний ордер buy
          }
          if (OrderType()==OP_SELL) {
            if (OrderOpenTime()>tm) {
              tm=OrderOpenTime();                // Ищем последнюю открытую поз...
              number = j;                        // ...и запоминаем её цикл
            }
            if (OrderOpenPrice()<min || min==0) min=OrderOpenPrice();// Ищем нижний ордер sell
          }
        }
      }
    }
  }
  if ((Bid > max+tp*Point && Bid < max+(tp+slp)*Point && min==0) ||
    (Ask < min-tp*Point && Ask > min-(tp+slp)*Point && max==0)) return(number);
  else return(-1);                               // В случае несовп. крит. открытия возвр. -1
}
//+------------------------------------------------------------------+
//| Определение направления первой позиции                           |
//+------------------------------------------------------------------+
int PositionDirection() {
  if ((Close[1]-Open[1]) > 0) return(OP_BUY);
  else return(OP_SELL);
}
//+------------------------------------------------------------------+
//| Генерация магик номера                                           |
//| Параметры:                                                       |
//|   str   - любой уникальный текст                                 |
//+------------------------------------------------------------------+
int makeMagicNumber(string str) {
  int i,s;
  for (i=0; i<StringLen(str); i++) {
    s = s + StringGetChar(str,i) * i * 32;
  }
  return(s);
}
//+------------------------------------------------------------------+
//| Преобразование времени в текст                                   |
//| Параметры:                                                       |
//|   Time_Hour     - часы                                           |
//|   Time_Minute   - минуты                                         |
//+------------------------------------------------------------------+
string TimeToText(int Time_Hour, int Time_Minute) {
  string Time_H_M, Time_H, Time_M;          // Время в текстовом формате

  if (Time_Hour >= 10 && Time_Hour <= 23) Time_H=DoubleToStr(Time_Hour, 0);
  else {
    if (Time_Hour >= 0 && Time_Hour <= 9) Time_H="0"+DoubleToStr(Time_Hour, 0);
    else {
      Alert("Неверный параметр OpenHour");
      work=false;
    }
  }
  if (Time_Minute >= 10 && Time_Minute <= 59) Time_M=DoubleToStr(Time_Minute, 0);
  else {
    if (Time_Minute >= 0 && Time_Minute <= 9) Time_M="0"+DoubleToStr(Time_Minute, 0);
    else {
      Alert("Неверный параметр OpenMinute");
      work=false;
    }
  }
  Time_H_M=Time_H+":"+Time_M;

  return(Time_H_M);
}
/*
//+------------------------------------------------------------------+
//| Возвращает флаг существования ордера или позиции по номеру       |
//+------------------------------------------------------------------+
bool ExistOrder(int mn) {
  bool Exist=False;
  for (int i=0; i<OrdersTotal(); i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      if (OrderSymbol()==Symbol() && OrderMagicNumber()==magic+mn) {
        Exist=True; break;
      }
    }
  }
  return(Exist);
}
*/
//+------------------------------------------------------------------+
//| Возвращает флаг существования позиции по номеру                  |
//+------------------------------------------------------------------+
bool ExistPosition(int mn) {
  bool Exist=False;
  for (int i=0; i<OrdersTotal(); i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      if (OrderSymbol()==Symbol() && OrderMagicNumber()==magic+mn) {
        if (OrderType()==OP_BUY) {
          Tip[ArraySize(Tip)-1]=OP_SELL;         // Обновление Типа поз. нового цикла
          Exist=True; break;
        }
        if (OrderType()==OP_SELL) {
          Tip[ArraySize(Tip)-1]=OP_BUY;          // Обновление Типа поз. нового цикла
          Exist=True; break;
        }
      }
    }
  }
  return(Exist);
}
//+------------------------------------------------------------------+
//| Закрытие позиции                                                 |
//| Параметры:                                                       |
//|   errproc - флаг повторения попыки закрытия при некрит. ошибке   |
//|   cyc     - номер цикла позиций                                  |
//+------------------------------------------------------------------+
bool ClosePosition(bool errproc, int cyc) {
  int ticket;
  bool ans=false;
  for (int i=0; i<OrdersTotal(); i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      if (OrderSymbol()==Symbol() && OrderMagicNumber()==magic+cyc) {
        while(true) {                            // Цикл закрытия поз.
          if (OrderType()==OP_BUY) {             // Открыта позиция Buy
            ticket = OrderTicket();
            Print ("Попытка закрыть ",Symbol()," Buy #",ticket,". Ожидание ответа..");
            RefreshRates();                      // Обновление данных
            ans=OrderClose(ticket,OrderLots(),Bid,Slippage*dig_ret,LightBlue);
            if (ans==true) {                     // Получилось :)
              Print ("Закрыт ордер ",Symbol()," Buy #",ticket);
              Tip[cyc]=OP_SELL;                  // Запоминаем тип следующей поз.
              return(ans);                       // Выход из функции
            }
            if (Fun_Error(GetLastError())==1)    // Обработка ошибок
              if (errproc) continue;             // Повторная попытка
            return(ans);                         // Выход из функции
          }
          if (OrderType()==OP_SELL) {            // Открыта позиция Sell
            ticket = OrderTicket();
            Print ("Попытка закрыть ",Symbol()," Sell #",ticket,". Ожидание ответа..");
            RefreshRates();                      // Обновление данных
            ans=OrderClose(ticket,OrderLots(),Ask,Slippage*dig_ret,LightCoral);
            if (ans==true) {                     // Получилось :)
              Print ("Закрыт ордер ",Symbol()," Sell #",ticket);
              Tip[cyc]=OP_BUY;                   // Запоминаем тип следующей поз.
              return(ans);                       // Выход из функции
            }
            if (Fun_Error(GetLastError())==1)    // Обработка ошибок
              if (errproc) continue;             // Повторная попытка
            return(ans);                         // Выход из функции
          }
          break;                                 // Выход из while
        }
      }
    }
  }
  return(ans);
}
//+------------------------------------------------------------------+
//| Открытие позиции                                                 |
//| Параметры:                                                       |
//|   opn     - направление позиции                                  |
//|   cyc     - номер цикла позиций                                  |
//+------------------------------------------------------------------+
bool OpenPosition(int opn, int cyc) {
  int ticket;
  while(true) {                                  // Цикл открытия поз.
    if (!ExistPosition(cyc) && opn==OP_BUY) {    // Открытых поз. нет + критерий откр. Buy
      RefreshRates();                            // Обновление данных
      Print ("Попытка открыть ",Symbol()," Buy. Ожидание ответа..");
      ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage*dig_ret,0,0,comment+" #"+cyc,magic+cyc,0,Blue);
      if (ticket > 0) {                          // Получилось :)
        Print ("Открыт ордер ",Symbol()," Buy #",ticket);
        return(true);                            // Выход из функции
      }
      if (Fun_Error(GetLastError())==1)          // Обработка ошибок
        continue;                                // Повторная попытка
      return(false);                             // Выход из функции
    }
    if (!ExistPosition(cyc) && opn==OP_SELL) {   // Открытых поз. нет + критерий откр. Sell
      RefreshRates();                            // Обновление данных
      Print ("Попытка открыть ",Symbol()," Sell. Ожидание ответа..");
      ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage*dig_ret,0,0,comment+" #"+cyc,magic+cyc,0,Red);
      if (ticket > 0) {                          // Получилось :)
        Print ("Открыт ордер ",Symbol()," Sell #",ticket);
        return(true);                            // Выход из функции
      }
      if (Fun_Error(GetLastError())==1)          // Обработка ошибок
        continue;                                // Повторная попытка
      return(false);                             // Выход из функции
    }
    break;                                       // Выход из while
  }
  return(false);                                 // Выход из функции
}
//+------------------------------------------------------------------+
//| Функция обработки ошибок                                         |
//| Параметры:                                                       |
//|   Error     - код ошибки                                         |
//+------------------------------------------------------------------+
int Fun_Error(int Error) {                       // Ф-ия обработ ошибок
  switch(Error) {                                // Преодолимые ошибки            
    case  4: Print("Торговый сервер занят. Пробуем ещё раз..");
      Sleep(3000);                               // Простое решение
      return(1);                                 // Выход из функции
    case  6: Print("Нет связи с торговым сервером. Пробуем ещё раз..");
      Sleep(3000);                               // Простое решение
      return(1);                                 // Выход из функции
    case 128:Print("Истек срок ожидания совершения сделки..");
      return(1);                                 // Выход из функции
    case 129:Print("Неправильная цена. Пробуем ещё раз..");
      RefreshRates();                            // Обновим данные
      return(1);                                 // Выход из функции
    case 135:
    case 138:Print("Цена изменилась. Пробуем ещё раз..");
      RefreshRates();                            // Обновим данные
      return(1);                                 // Выход из функции
    case 136:Print("Нет цен. Ждём новый тик..");
      while(RefreshRates()==false)               // До нового тика
        Sleep(1);                                // Задержка в цикле
      return(1);                                 // Выход из функции
    case 137:Print("Брокер занят. Пробуем ещё раз..");
      Sleep(3000);                               // Простое решение
      return(1);                                 // Выход из функции
    case 146:Print("Подсистема торговли занята. Пробуем ещё..");
      Sleep(500);                                // Простое решение
      return(1);                                 // Выход из функции
      // Критические ошибки
    case  2: Print("Общая ошибка.");
      return(0);                                 // Выход из функции
    case  5: Print("Старая версия терминала.");
      work=false;                                // Больше не работать
      return(0);                                 // Выход из функции
    case 64: Print("Счет заблокирован.");
      work=false;                                // Больше не работать
      return(0);                                 // Выход из функции
    case 133:Print("Торговля запрещена.");
      return(0);                                 // Выход из функции
    case 134:Print("Недостаточно денег для совершения операции.");
      return(0);                                 // Выход из функции
    default: Print("Возникла ошибка #",Error);   // Другие варианты   
      return(0);                                 // Выход из функции
  }
}
//+------------------------------------------------------------------+
//| Функция комментария на графике                                   |
//+------------------------------------------------------------------+
void CommentForChart() {
  color colortext;                               // Переменная цвета текста
  int mempos = -1;
  int yescyc = GlobalVariableGet(comment+" CY.#")-nocyc-1;
  Comment("                       "+comment+
    "\n\n                       Количество циклов в работе = "+DoubleToStr(yescyc, 0)+
    "\n                       Расстояние до максимального ТП серии = "+DoubleToStr(distTP, 0)+" пипса(ов)");
  for (int i=0; i<yescyc; i++) {                 // Цикл по кол-ву ордеров в работе
    colortext = Goldenrod;                       // Возвращаем цвет текста
    for (int j=0; j<ArraySize(Tip)-1; j++) {     // Цикл по кол-ву циклов
      if (GlobalVariableGet(comment+" TP."+j)!=0 && j>mempos) {      // Если ТП сущ. и не обрабатывался
        ObjectGet("Cycle TP."+i,OBJPROP_COLOR);            // Запрос цвета
        if (GetLastError()==4202) {                        // Если объекта нет :(
          ObjectCreate("Cycle TP."+i, OBJ_LABEL, 0, 0, 0);           // Создание объекта
          ObjectSet("Cycle TP."+i, OBJPROP_CORNER, 0);               // Привязка угол
          ObjectSet("Cycle TP."+i, OBJPROP_XDISTANCE, 73);           // Координата Х
          ObjectSet("Cycle TP."+i, OBJPROP_YDISTANCE, 63+i*12);      // Координата Y
        }
        if (j==numcyc && yescyc>1) colortext = OrangeRed;  // Если макс. ТП, изменяем цвет текста
        ObjectSetText("Cycle TP."+i,"Текущий ТП "+j+"-го цикла = "+
          DoubleToStr(GlobalVariableGet(comment+" TP."+j), 0)+" пипса(ов)",7,"Arial",colortext);
        mempos = j;                              // Запоминаем номер тек. ТП
        break;
      }
    }
  }
  ObjectDelete("Cycle TP."+yescyc);
  WindowRedraw();
}
//+------------------------------------------------------------------+
//| Функция удаления комментария на графике                          |
//+------------------------------------------------------------------+
void DelCommentForChart() {
  for (int i=0; i<100-1; i++)
    ObjectDelete("Cycle TP."+i);
}
//+------------------------------------------------------------------+

