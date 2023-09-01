//+--------------------------------------------------------------------------------------+
//|                                                                       mylib_v3_3.mq4 |
//|                                                       Copyright © 2010, Korvin ® Co. |
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
#property copyright "Copyright c 2010, MQL для тебя."
#property link      "http://mql4you.ru"
#property library
extern int  TakeProfit=0;
extern int  StopLoss=0;
//+--------------------------------------------------------------------------------------+
//|                                                                   Рутинные проверки  |
//+--------------------------------------------------------------------------------------+
bool RutineCheck() {
   bool trade = true;
if(DayOfWeek()==0||DayOfWeek()==6) trade=false;  // в выходные
                                                 // не работаем
if(!IsTradeAllowed()) trade=false;               // пропустим тик если
                                                 // терминал занят
return(trade);}
//+--------------------------------------------------------------------------------------+
//|                              Получение максимального размера лота при заданном риске |
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
//|                                                               Открытие нового ордера |
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
 if(tic<0) Print("Ошибка открытия ордера: ",GetLastError());
return(tic);}
//+--------------------------------------------------------------------------------------+
//|                                             Удаление ордеров по типу ордера SELL/BUY |
//+--------------------------------------------------------------------------------------+
void DelOrders(int Cmd)
{for(int i=OrdersTotal()-1;i>=0;i--)
   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
     if(OrderType()==Cmd) DelOrder(OrderTicket());
return;}
//+--------------------------------------------------------------------------------------+
//|                                                     Удаление ордера по номеру тикета |
//+--------------------------------------------------------------------------------------+
void DelOrder(int tic)
{while(!IsTradeAllowed()) Sleep(100);
 if(OrderSelect(tic,SELECT_BY_TICKET))
   if(!OrderDelete(OrderTicket(),CLR_NONE))
     Print("Ошибка удаления ордера: ",GetLastError());
return;}
//+--------------------------------------------------------------------------------------+
//|                     Изменение в выбранном по номеру ордере StopLoss и/или TakeProfit |
//+--------------------------------------------------------------------------------------+
void EditOrder(int tic,double sl, double tp)
{while(!IsTradeAllowed()) Sleep(100);
 if(OrderSelect(tic,SELECT_BY_TICKET))
   if(sl==0) sl=OrderStopLoss();
   if(tp==0) tp=OrderTakeProfit();
   if(!OrderModify(OrderTicket(),OrderOpenPrice(),sl,tp,0,CLR_NONE))
     Print("Ошибка редактирования ордера: ",GetLastError());
return;}
//+--------------------------------------------------------------------------------------+
//|                                                 Закрытие выбранного по номеру ордера |
//+--------------------------------------------------------------------------------------+
void CloseOrder(int tic)
{double PR=0;
 while(!IsTradeAllowed()) Sleep(100);
 if(OrderType()==OP_BUY)  PR=NormalizeDouble(Bid,Digits);
 if(OrderType()==OP_SELL) PR=NormalizeDouble(Ask,Digits);
 if(OrderSelect(tic,SELECT_BY_TICKET))
   if(!OrderClose(OrderTicket(),OrderLots(),PR,3,CLR_NONE))
     Print("Ошибка закрытия ордера: ",GetLastError());
return;}
//+--------------------------------------------------------------------------------------+
//|                                                            Вывод в строке n пробелов |
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
//|                                                             Функция обработки ошибок |
//+--------------------------------------------------------------------------------------+
int ErrorFix(int errcode)
{
errcode=GetLastError();
//---- Коды ошибок, возвращаемые торговым сервером:
switch (errcode) {
//--------------------------------------
// 0 - нет ошибок;
// 1 - ошибки требующие выждать;
// 2 - ошибки, требующие вмешательства;
// 3 - критические ошибки;
//--------------------------------------
   case 0:   errcode=0; break; // "Нет ошибок" - продолжим
   case 1:   errcode=1; Print("Нет ошибки, но результат неизвестен"); Sleep(500); break;
   case 2:   errcode=1; Print("Общая ошибка"); Sleep(500); break;
   case 3:   errcode=2; Print("Неправильные параметры");  break;
   case 4:   errcode=1; Print("Торговый сервер занят"); Sleep(500); break;
   case 5:   errcode=2; Print("Старая версия клиентского терминала");
   case 6:   errcode=1; Print("Нет связи с торговым сервером"); Sleep(500); break;
   case 7:   errcode=2; Print("Недостаточно прав"); break;
   case 8:   errcode=1; Print("Слишком частые запросы"); Sleep(5000); break;
   case 9:   errcode=3; Print("Недопустимая операция нарушающая функционирование сервера"); break;
   case 64:  errcode=2; Print("Счет заблокирован"); break;
   case 65:  errcode=2; Print("Неправильный номер счета"); break;
   case 128: errcode=1; Print("Истек срок ожидания совершения сделки"); Sleep(500); break;
   case 129: errcode=2; Print("Неправильная цена"); break;
   case 130: errcode=2; Print("Неправильные стопы"); break;
   case 131: errcode=2; Print("Неправильный объем"); break;
   case 132: errcode=1; Print(TimeToStr(TimeLocal(),TIME_DATE|TIME_MINUTES)," Рынок закрыт, ждём ещё час."); Sleep(3600000); break;
   case 133: errcode=1; Print(TimeToStr(TimeLocal(),TIME_DATE|TIME_MINUTES),"Торговля запрещена, ждём 10 минут."); Sleep(600000); break;  
   case 134: errcode=2; Print("Недостаточно денег для совершения операции"); break;
   case 135: errcode=2; Print("Цена изменилась"); break;
   case 136: errcode=1; Print("Нет цен"); Sleep(500); break;
   case 137: errcode=1; Print("Брокер занят"); Sleep(500); break;
   case 138: errcode=2; Print("Новые цены"); Sleep(500); break;
   case 139: errcode=1; Print("Ордер заблокирован и уже обрабатывается"); Sleep(5000); break;
   case 140: errcode=2; Print("Разрешена только покупка"); break;
   case 141: errcode=1; Print("Слишком много запросов");  Sleep(5000); break;
   case 145: errcode=1; Print("Модификация запрещена, так как ордер слишком близок к рынку");  Sleep(500); break;
   case 146: errcode=1; Print("Подсистема торговли занята");  Sleep(500); break;
   case 147: errcode=2; Print("Использование даты истечения ордера запрещено брокером"); break;
   case 148: errcode=2; Print("Количество открытых и отложенных ордеров\nдостигло предела, установленного брокером."); break;
//---- Коды ошибок выполнения MQL4-программы:
   case 4000: errcode=0; break;
   case 4001: errcode=1; Print("Неправильный указатель функции"); break;
   case 4002: errcode=1; Print("Индекс массива - вне диапазона"); break;
   case 4003: errcode=1; Print("Нет памяти для стека функций"); break;
   case 4004: errcode=1; Print("Переполнение стека после рекурсивного вызова"); break;
   case 4005: errcode=1; Print("На стеке нет памяти для передачи параметров"); break;
   case 4006: errcode=1; Print("Нет памяти для строкового параметра"); break;
   case 4007: errcode=1; Print("Нет памяти для временной строки"); break;
   case 4008: errcode=1; Print("Неинициализированная строка"); break;
   case 4009: errcode=1; Print("Неинициализированная строка в массиве"); break;
   case 4010: errcode=1; Print("Нет памяти для строкового массива"); break;
   case 4011: errcode=1; Print("Слишком длинная строка"); break;
   case 4012: errcode=1; Print("Остаток от деления на ноль"); break;
   case 4013: errcode=1; Print("Деление на ноль"); break;
   case 4014: errcode=1; Print("Неизвестная команда"); break;
   case 4015: errcode=1; Print("Неправильный переход"); break;
   case 4016: errcode=1; Print("Неинициализированный массив"); break;
   case 4017: errcode=1; Print("Вызовы DLL не разрешены"); break;
   case 4018: errcode=1; Print("Невозможно загрузить библиотеку"); break;
   case 4019: errcode=1; Print("Невозможно вызвать функцию"); break;
   case 4020: errcode=1; Print("Вызовы внешних библиотечных функций не разрешены"); break;
   case 4021: errcode=1; Print("Недостаточно памяти для строки, возвращаемой из функции"); break;
   case 4022: errcode=1; Print("Система занята"); break;
   case 4050: errcode=1; Print("Неправильное количество параметров функции"); break;
   case 4051: errcode=1; Print("Недопустимое значение параметра функции"); break;
   case 4052: errcode=1; Print("Внутренняя ошибка строковой функции"); break;
   case 4053: errcode=1; Print("Ошибка массива"); break;
   case 4054: errcode=1; Print("Неправильное использование массива-таймсерии"); break;
   case 4055: errcode=1; Print("Ошибка пользовательского индикатора"); break;
   case 4056: errcode=1; Print("Массивы несовместимы"); break;
   case 4057: errcode=1; Print("Ошибка обработки глобальныех переменных"); break;
   case 4058: errcode=1; Print("Глобальная переменная не обнаружена"); break;
   case 4059: errcode=1; Print("Функция не разрешена в тестовом режиме"); break;
   case 4060: errcode=1; Print("Функция не разрешена"); break;
   case 4061: errcode=1; Print("Ошибка отправки почты"); break;
   case 4062: errcode=1; Print("Ожидается параметр типа string"); break;
   case 4063: errcode=1; Print("Ожидается параметр типа integer"); break;
   case 4064: errcode=1; Print("Ожидается параметр типа double"); break;
   case 4065: errcode=1; Print("В качестве параметра ожидается массив"); break;
   case 4066: errcode=1; Print("Запрошенные исторические данные в состоянии обновления"); break;
   case 4067: errcode=1; Print("Ошибка при выполнении торговой операции"); break;
   case 4099: errcode=1; Print("Конец файла"); break;
   case 4100: errcode=1; Print("Ошибка при работе с файлом"); break;
   case 4101: errcode=1; Print("Неправильное имя файла"); break;
   case 4102: errcode=1; Print("Слишком много открытых файлов"); break;
   case 4103: errcode=1; Print("Невозможно открыть файл"); break;
   case 4104: errcode=1; Print("Несовместимый режим доступа к файлу"); break;
   case 4105: errcode=1; Print("Ни один ордер не выбран"); break;
   case 4106: errcode=1; Print("Неизвестный символ"); break;
   case 4107: errcode=1; Print("Неправильный параметр цены для торговой функции"); break;
   case 4108: errcode=1; Print("Неверный номер тикета"); break;
   case 4109: errcode=1; Print("Торговля не разрешена. Необходимо включить опцию Разрешить советнику торговать в свойствах эксперта."); break;
   case 4110: errcode=1; Print("Длинные позиции не разрешены. Необходимо проверить свойства эксперта."); break;
   case 4111: errcode=1; Print("Короткие позиции не разрешены. Необходимо проверить свойства эксперта."); break;
   case 4200: errcode=1; Print("Объект уже существует"); break;
   case 4201: errcode=1; Print("Запрошено неизвестное свойство объекта"); break;
   case 4202: errcode=1; Print("Объект не существует"); break;
   case 4203: errcode=1; Print("Неизвестный тип объекта"); break;
   case 4204: errcode=1; Print("Нет имени объекта"); break;
   case 4205: errcode=1; Print("Ошибка координат объекта"); break;
   case 4206: errcode=1; Print("Не найдено указанное подокно"); break;
   default:   errcode=1; Print("Ошибка при работе с объектом"); break;
}return(errcode);}
//+--------------------------------------------------------------------------------------+
//| Функция |
//+--------------------------------------------------------------------------------------+
//+--------------------------------------------------------------------------------------+
//||
//+--------------------------------------------------------------------------------------+

//+--------------------------------------------------------------------------------------+
//|             К О Н Е Ц   Б И Б Л И О Т Е К И   П О Д П Р О Г Р А М М                  |
//+--------------------------------------------------------------------------------------+

