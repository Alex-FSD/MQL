//+------------------------------------------------------------------+
//|                                                cm_тени свечи.mq4 |
//|    длина свечи 50, тень снизу 30, ставим байстоп над свечей 10 п |
//|                              Copyright © 2012, Khlystov Vladimir |
//|                                         http://cmillion.narod.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012-2020, cmillion@narod.ru"
#property link      "http://cmillion.ru"
#property strict
#property description "Советник открывает отложенные ордера при появлении свечи типа молот (с большой тенью)."
#property description "SL советник ставит за тень на расстоянии SL пунктов от него. TP равен размеру тени минус TP"
#property description "Доп функции: трал, безубыток, фильтр по времени"
//--------------------------------------------------------------------
extern string  ver="cm_Shadow Candles 2.0";
input ENUM_TIMEFRAMES TIMEFRAMES = 0;
extern int     candllevel           = 50;     //Размер свечи не менее
extern int     candllshadow         = 180;    //тень свечи % от тела свечи (не менее)
extern int     Step                 = 0;      //расстояние от свечи до отложенного ордера
extern int     BarLife              = 3;      //на протяжении какого числа свечей живет отложенный ордер
extern int     StopLoss             = 20,     //SL по Low/High +- pips
               TakeProfit           = 0;      //TP по тени - pips
extern int     TrailingStop         = 0;      //длина тралла, если 0 то нет тралла
extern int     TrailingStart        = 0;      //когда включать трал, например после достижения 40 п прибыл
extern int     TrailingStep            = 0;      //шаг тралла - перемещать стоплосс не ближе чем TrailingStep
extern int     NoLoss               = 0,      //перевод в безубыток при заданном кол-ве пунктов прибыли, если 0 то нет перевода в безубыток
               MinProfitNoLoss      = 10;     //минимальная прибыль при переводе вбезубыток
extern int     MaxOrders            = 5;      //максимальное кол-во однонаправленных ордеров в рынке
extern int     Magic                = 0;      //магик
extern double  Lot                  = 0.0;
extern double  RiskPercent          = 5;          //процент от баланса для расчета лота
extern int     slippage             = 30;     //Максимально допустимое отклонение цены для рыночных ордеров
extern int     TimeStart            = 0 ,     //ограничение времени работы советника
               TimeEnd              = 24;     //не открываем ордера и закрываем отложки если время не между TimeStart и TimeEnd
//--------------------------------------------------------------------
 int     DigitsLot            = 2;           //кол-во знаков после запятой в размере лота (2 - 0,01) (1 - 0,1)
int  STOPLEVEL;
double PriceDeleteB,PriceDeleteS;
datetime TimeOpen;
//--------------------------------------------------------------------
double MINLOT,MAXLOT;
//-------------------------------------------------------------------- 
int OnInit()
{ 
   MINLOT = MarketInfo(Symbol(),MODE_MINLOT);
   MAXLOT = MarketInfo(Symbol(),MODE_MAXLOT);
   if (Digits==3 || Digits==5)
   {
      Step*=10;
      StopLoss*=10;
      TakeProfit*=10;
      TrailingStop*=10;
      TrailingStart*=10;
      TrailingStep*=10;
      NoLoss*=10;
      MinProfitNoLoss*=10;
   }
   return(INIT_SUCCEEDED);
}
//-------------------------------------------------------------------
void OnTick()
{
   if (!IsTradeAllowed()) 
   {
      Comment("Торговля запрещена IsTradeAllowed",12,"Arial",Crimson);
      return;
   }
   //---
   int TekHour = Hour();
   bool Trade;
   if ( TimeStart < TimeEnd && TekHour >= TimeStart && TekHour < TimeEnd ) Trade=true; 
   else 
   {
      if ( TimeStart > TimeEnd && (TekHour >= TimeStart || TekHour < TimeEnd)) Trade=true; //торговля ночью
      else Trade=false;
   }
   if (!Trade)
   {
      Comment("Торговля запрещена по времени ");
   }
   else Comment(ver);
   //---
   STOPLEVEL=(int)MarketInfo(Symbol(),MODE_STOPLEVEL);
   double OSL,StLo,PriceB=0,PriceS=0,OOP,SL;
   int b=0,s=0,TicketB=0,TicketS=0,OT;
   for (int i=0; i<OrdersTotal(); i++)
   {    
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         if (OrderSymbol()==Symbol() && Magic==OrderMagicNumber())
         { 
            OT = OrderType(); 
            OSL = NormalizeDouble(OrderStopLoss(),Digits);
            OOP = NormalizeDouble(OrderOpenPrice(),Digits);
            SL=OSL;
            if (OT==OP_BUY)             
            {  
               b++;
               if (OSL<OOP && NoLoss>STOPLEVEL && NoLoss!=0)
               {
                  StLo = NormalizeDouble(OOP+MinProfitNoLoss*Point,Digits); 
                  if (StLo > OSL && StLo <= NormalizeDouble(Bid - NoLoss * Point,Digits)) SL = StLo;
               }
               
               if (TrailingStop>STOPLEVEL && TrailingStop!=0 && (Bid - OOP)/Point >= TrailingStart)
               {
                  StLo = NormalizeDouble(Bid - TrailingStop*Point,Digits); 
                  if (StLo>=OOP && StLo > OSL+TrailingStep*Point) SL = StLo;
               }
               
               if (SL > OSL)
               {  
                  if (!OrderModify(OrderTicket(),OOP,SL,OrderTakeProfit(),0,White)) Print("Error ",GetLastError(),"   Order Modify Buy   SL ",OSL,"->",SL);
                  else Print("Order Buy Modify   SL ",OSL,"->",SL);
               }
            }                                         
            if (OT==OP_SELL)        
            {
               s++;
               if ((OSL>OOP || OSL==0) && NoLoss>STOPLEVEL && NoLoss!=0)
               {
                  StLo = NormalizeDouble(OOP-MinProfitNoLoss*Point,Digits); 
                  if ((StLo < OSL || OSL==0) && StLo >= NormalizeDouble(Ask + NoLoss * Point,Digits)) SL = StLo;
               }
               
               if (TrailingStop>STOPLEVEL && TrailingStop!=0 && (OOP - Ask)/Point >= TrailingStart)
               {
                  StLo = NormalizeDouble(Ask + TrailingStop*Point,Digits); 
                  if (StLo<=OOP && (StLo < OSL-TrailingStep*Point || OSL==0)) SL = StLo;
               }
               
               if ((SL < OSL || OSL==0) && SL!=0)
               {  
                  if (!OrderModify(OrderTicket(),OOP,SL,OrderTakeProfit(),0,White)) Print("Error ",GetLastError(),"   Order Modify Sell   SL ",OSL,"->",SL);
                  else Print("Order Sell Modify   SL ",OSL,"->",SL);
               }
            } 
            if (OT==OP_BUYSTOP)  {PriceB=OOP; TicketB=OrderTicket();}     
            if (OT==OP_SELLSTOP) {PriceS=OOP; TicketS=OrderTicket();}  
         }
      }
   }
   bool err;
   if (!Trade)
   {
      if (b+s==0) 
      {
         if (TicketS>0) err=OrderDelete(TicketS);
         if (TicketB>0) err=OrderDelete(TicketB);
         return;
      }
   }
   
   double Price;
   double body = MathAbs(iOpen(NULL,TIMEFRAMES,1)-iClose(NULL,TIMEFRAMES,1))/Point;
   double shadowUp = (iHigh(NULL,TIMEFRAMES,1)-iOpen(NULL,TIMEFRAMES,1))/Point;
   double shadowDn = (iOpen(NULL,TIMEFRAMES,1)-iLow(NULL,TIMEFRAMES,1))/Point;
   double StopLevel = STOPLEVEL*Point+Point;
   
   int S=0;
   if ((iHigh(NULL,TIMEFRAMES,1)-iLow(NULL,TIMEFRAMES,1))/Point>=candllevel)
   {
      if (iOpen(NULL,TIMEFRAMES,1)<iClose(NULL,TIMEFRAMES,1) && shadowDn>=body/100*candllshadow && shadowDn>shadowUp) {S= 1;Candle(Blue);}
      if (iOpen(NULL,TIMEFRAMES,1)>iClose(NULL,TIMEFRAMES,1) && shadowUp>=body/100*candllshadow && shadowDn<shadowUp) {S=-1;Candle(Red);}
   }
   
   if (PriceDeleteB>Bid && PriceDeleteB!=0) 
   {
      if (TicketB>0) {err=OrderDelete(TicketB);PriceDeleteB=0;return;}
   }
   double TP;
   if (TicketB==0 && S==1 && TimeOpen!=iTime(NULL,TIMEFRAMES,0))
   {
      if (TicketS>0) err=OrderDelete(TicketS);
      Price = NormalizeDouble(iHigh(NULL,TIMEFRAMES,1)+Step * Point,Digits);
      if (Price<NormalizeDouble(Ask+StopLevel,Digits)) Price=NormalizeDouble(Ask+StopLevel,Digits);
      SL = NormalizeDouble(iLow(NULL,TIMEFRAMES,1) - StopLoss * Point,Digits);
      if (SL>NormalizeDouble(Price-StopLevel,Digits)) SL=NormalizeDouble(Price-StopLevel,Digits);
      TP = NormalizeDouble(Price + (shadowDn-TakeProfit) * Point,Digits);
      if (TP<NormalizeDouble(Price+StopLevel,Digits)) TP=NormalizeDouble(Price+StopLevel,Digits);
      if (SendOrder(OP_BUYSTOP,LOT(),Price,SL,TP,TimeCurrent()+Period()*60*BarLife)) TimeOpen=iTime(NULL,TIMEFRAMES,0);
   }
   if (PriceDeleteS<Bid && PriceDeleteS!=0) 
   {
      if (TicketS>0) {err=OrderDelete(TicketS);PriceDeleteS=0;return;}
   }

   if (TicketS==0 && S==-1 && TimeOpen!=iTime(NULL,TIMEFRAMES,0))
   {
      if (TicketB>0) err=OrderDelete(TicketB);
      Price = NormalizeDouble(iLow(NULL,TIMEFRAMES,1) - Step * Point,Digits);
      if (Price>NormalizeDouble(Bid-StopLevel,Digits)) Price=NormalizeDouble(Bid-StopLevel,Digits);
      SL = NormalizeDouble(iHigh(NULL,TIMEFRAMES,1) + StopLoss * Point,Digits);
      if (SL<NormalizeDouble(Price+StopLevel,Digits)) SL=NormalizeDouble(Price+StopLevel,Digits);
      TP = NormalizeDouble(Price - (shadowUp-TakeProfit) * Point,Digits);
      if (TP>NormalizeDouble(Price-StopLevel,Digits)) TP=NormalizeDouble(Price-StopLevel,Digits);
      if (SendOrder(OP_SELLSTOP,LOT(),Price,SL,TP,TimeCurrent()+Period()*60*BarLife)) TimeOpen=iTime(NULL,TIMEFRAMES,0);
   }
}
//--------------------------------------------------------------------
bool SendOrder(int tip, double lots, double price, double sl=0, double tp=0,datetime t=0)
{
   if(!IsNewOrderAllowed()) return(false);
   lots=CheckVolumeValue(lots);
   if(lots>MAXLOT) lots = MAXLOT;
   if(lots<MINLOT) lots = MINLOT;
   int tipe;
   if (tip==OP_BUY || tip==OP_BUYSTOP || tip==OP_BUYLIMIT) tipe=OP_BUY;
   else tipe=OP_SELL;
   if (AccountFreeMarginCheck(Symbol(),tipe,lots)<0)
   {
      Alert("Недостаточно средств");
      return(false);
   }
   for (int i=0; i<10; i++)
   {    
      if (OrderSend(Symbol(),tip, lots,price,slippage,sl,tp,NULL,Magic,t,clrNONE)!=-1) return(true);
         Alert(" попытка ",i," Ошибка открытия ордера ",Strtip(tip)," <<",Error(GetLastError()),">>  lot=",lots,"  pr=",price," sl=",sl," tp=",tp);
      Sleep(500);
      RefreshRates();
      if (IsStopped()) return(false);
   }
   return(false);
}
//------------------------------------------------------------------
string Strtip(int tip)
{
   switch(tip) 
   { 
   case OP_BUY:      return("BUY"); 
   case OP_SELL:     return("SELL"); 
   case OP_BUYSTOP:  return("BUYSTOP"); 
   case OP_SELLSTOP: return("SELLSTOP"); 
   case OP_BUYLIMIT: return("BUYLIMIT"); 
   case OP_SELLLIMIT:return("SELLLIMIT"); 
   }
   return("error"); 
}
//------------------------------------------------------------------
void Candle(color C)
{
   string NameLine=StringConcatenate("cndl ",TimeToStr(iTime(NULL,TIMEFRAMES,1),TIME_DATE|TIME_MINUTES));

   ObjectDelete(NameLine);
   ObjectCreate(NameLine,OBJ_TREND,0,iTime(NULL,TIMEFRAMES,1),iLow(NULL,TIMEFRAMES,1),iTime(NULL,TIMEFRAMES,1),iHigh(NULL,TIMEFRAMES,1));
   ObjectSet(NameLine, OBJPROP_COLOR,C); 
   ObjectSet(NameLine, OBJPROP_STYLE, 0);
   ObjectSet(NameLine, OBJPROP_WIDTH, 1);
   ObjectSet(NameLine, OBJPROP_RAY,   false);
   
   NameLine=StringConcatenate(NameLine," тело");

   ObjectDelete(NameLine);
   ObjectCreate(NameLine,OBJ_TREND,0,iTime(NULL,TIMEFRAMES,1),iOpen(NULL,TIMEFRAMES,1),iTime(NULL,TIMEFRAMES,1),iClose(NULL,TIMEFRAMES,1));
   ObjectSet(NameLine, OBJPROP_COLOR,C); 
   ObjectSet(NameLine, OBJPROP_STYLE, 0);
   ObjectSet(NameLine, OBJPROP_WIDTH, 5);
   ObjectSet(NameLine, OBJPROP_RAY,   false);
}
//--------------------------------------------------------------------
double LOT()
{
   if (Lot!=0) return(Lot);
   double LOT = NormalizeDouble(AccountBalance()*RiskPercent/100/MarketInfo(Symbol(),MODE_MARGINREQUIRED),DigitsLot);
   if (LOT>MAXLOT) LOT = MAXLOT;
   if (LOT<MINLOT) LOT = MINLOT;
   return(LOT);
}
//------------------------------------------------------------------
void OnDeinit(const int reason)
{
   if (!IsTesting()) ObjectsDeleteAll(0,"cndl");
   Comment("");
}
//+------------------------------------------------------------------+
bool IsNewOrderAllowed()
{
   int max_allowed_orders=(int)AccountInfoInteger(ACCOUNT_LIMIT_ORDERS);
   if(max_allowed_orders==0) return(true);
   if(OrdersTotal()<max_allowed_orders) return(true);
   return(false);
}
//+------------------------------------------------------------------+
double CheckVolumeValue(double volume)
{
   double min_volume=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN);
   if(volume<min_volume) return(min_volume);
   double max_volume=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MAX);
   if(volume>max_volume) return(max_volume);
   double volume_step=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_STEP);//--- градация объема
   int ratio=(int)MathRound(volume/volume_step);
   if(MathAbs(ratio*volume_step-volume)>0.0000001) return(ratio*volume_step);
   return(volume);
}
//+------------------------------------------------------------------+
string Error(int code)
{
   switch(code)
   {
      case 0:   return("Нет ошибок");
      case 1:   return("Нет ошибки, но результат неизвестен");                            
      case 2:   return("Общая ошибка");                                                   
      case 3:   return("Неправильные параметры");                                         
      case 4:   return("Торговый сервер занят");                                          
      case 5:   return("Старая версия клиентского терминала");                            
      case 6:   return("Нет связи с торговым сервером");                                  
      case 7:   return("Недостаточно прав");                                              
      case 8:   return("Слишком частые запросы");                                         
      case 9:   return("Недопустимая операция нарушающая функционирование сервера");      
      case 64:  return("Счет заблокирован");                                              
      case 65:  return("Неправильный номер счета");                                       
      case 128: return("Истек срок ожидания совершения сделки");                          
      case 129: return("Неправильная цена");                                              
      case 130: return("Неправильные стопы");                                             
      case 131: return("Неправильный объем");                                             
      case 132: return("Рынок закрыт");                                                   
      case 133: return("Торговля запрещена");                                               
      case 134: return("Недостаточно денег для совершения операции");                     
      case 135: return("Цена изменилась");                                                
      case 136: return("Нет цен");                                                        
      case 137: return("Брокер занят");                                                   
      case 138: return("Новые цены");                                                     
      case 139: return("Ордер заблокирован и уже обрабатывается");                        
      case 140: return("Разрешена только покупка");                                       
      case 141: return("Слишком много запросов");                                         
      case 145: return("Модификация запрещена, так как ордер слишком близок к рынку");    
      case 146: return("Подсистема торговли занята");                                     
      case 147: return("Использование даты истечения ордера запрещено брокером");         
      case 148: return("Количество открытых и отложенных ордеров достигло предела, установленного брокером.");
      case 4000: return("Нет ошибки");                                                      
      case 4001: return("Неправильный указатель функции");                                  
      case 4002: return("Индекс массива - вне диапазона");                                  
      case 4003: return("Нет памяти для стека функций");                                    
      case 4004: return("Переполнение стека после рекурсивного вызова");                    
      case 4005: return("На стеке нет памяти для передачи параметров");                     
      case 4006: return("Нет памяти для строкового параметра");                             
      case 4007: return("Нет памяти для временной строки");                                 
      case 4008: return("Неинициализированная строка");                                     
      case 4009: return("Неинициализированная строка в массиве");                           
      case 4010: return("Нет памяти для строкового массива");                               
      case 4011: return("Слишком длинная строка");                                          
      case 4012: return("Остаток от деления на ноль");                                      
      case 4013: return("Деление на ноль");                                                 
      case 4014: return("Неизвестная команда");                                             
      case 4015: return("Неправильный переход");                                            
      case 4016: return("Неинициализированный массив");                                     
      case 4017: return("Вызовы DLL не разрешены");                                         
      case 4018: return("Невозможно загрузить библиотеку");                                 
      case 4019: return("Невозможно вызвать функцию");                                      
      case 4020: return("Вызовы внешних библиотечных функций не разрешены");                
      case 4021: return("Недостаточно памяти для строки, возвращаемой из функции");         
      case 4022: return("Система занята");                                                  
      case 4050: return("Неправильное количество параметров функции");                      
      case 4051: return("Недопустимое значение параметра функции");                         
      case 4052: return("Внутренняя ошибка строковой функции");                             
      case 4053: return("Ошибка массива");                                                  
      case 4054: return("Неправильное использование массива-таймсерии");                    
      case 4055: return("Ошибка пользовательского индикатора");                             
      case 4056: return("Массивы несовместимы");                                            
      case 4057: return("Ошибка обработки глобальныех переменных");                         
      case 4058: return("Глобальная переменная не обнаружена");                             
      case 4059: return("Функция не разрешена в тестовом режиме");                          
      case 4060: return("Функция не разрешена");                                            
      case 4061: return("Ошибка отправки почты");                                           
      case 4062: return("Ожидается параметр типа string");                                  
      case 4063: return("Ожидается параметр типа integer");                                 
      case 4064: return("Ожидается параметр типа double");                                  
      case 4065: return("В качестве параметра ожидается массив");                           
      case 4066: return("Запрошенные исторические данные в состоянии обновления");          
      case 4067: return("Ошибка при выполнении торговой операции");                         
      case 4099: return("Конец файла");                                                     
      case 4100: return("Ошибка при работе с файлом");                                      
      case 4101: return("Неправильное имя файла");                                          
      case 4102: return("Слишком много открытых файлов");                                   
      case 4103: return("Невозможно открыть файл");                                         
      case 4104: return("Несовместимый режим доступа к файлу");                             
      case 4105: return("Ни один ордер не выбран");                                         
      case 4106: return("Неизвестный символ");                                              
      case 4107: return("Неправильный параметр цены для торговой функции");                 
      case 4108: return("Неверный номер тикета");                                           
      case 4109: return("Торговля не разрешена. Необходимо включить опцию Разрешить советнику торговать в свойствах эксперта.");            
      case 4110: return("Длинные позиции не разрешены. Необходимо проверить свойства эксперта.");           
      case 4111: return("Короткие позиции не разрешены. Необходимо проверить свойства эксперта.");          
      case 4200: return("Объект уже существует");                                           
      case 4201: return("Запрошено неизвестное свойство объекта");                          
      case 4202: return("Объект не существует");                                            
      case 4203: return("Неизвестный тип объекта");                                         
      case 4204: return("Нет имени объекта");                                               
      case 4205: return("Ошибка координат объекта");                                        
      case 4206: return("Не найдено указанное подокно");                                    
      default:   return("Ошибка неизвестна ");
   }
}
//--------------------------------------------------------------------
