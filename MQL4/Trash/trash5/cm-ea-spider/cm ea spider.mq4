//---------------------------------------------------------------------------
#property copyright "Copyright © 2017, http://cmillion.ru"
#property link      "cmillion@narod.ru"
#property strict
#property description "Выше МА открываем только buystop, ниже только sellstop." 
#property description "У каждого ордера выставляем стоплосс тейкпрофит и трал." 
#property description "Отложенные ордера тянем за ценой на заданном расстоянии до срабатывания." 
//---------------------------------------------------------------------------
input ENUM_TIMEFRAMES    timeframe     = 0;           // Таймфрейм MA 
extern int               period        =100;          // период MA
extern int               ma_shift      =0;            //сдвиг MA
input ENUM_MA_METHOD     ma_method     =0;            // метод MA 1
input ENUM_APPLIED_PRICE applied_price = PRICE_CLOSE;  //Используемая цена MA 1
extern int     Stoploss          = 100,   //стоплосс
               Takeprofit        = 100;   //тейкпрофит
extern int     TrailingStop      = 5,     //трейлингстоп, если 0, то нет трейлинга
               TrailingStart     = 1,     //старт трейлинга
               TrailingStep      = 1;     //шаг трала
extern int     TrailingStopOrder = 10;    //расстояние до стоп ордера
extern int     TrailingStepOrder = 2;     //шаг перемещения стоп ордера
extern double  Lot               = 0.01;  //лот
extern int     Magic             = 1000;  //уникальный номер ордеров этого советника для ордеров Buy 
//--------------------------------------------------------------------
string AC;
double STOPLEVEL;
int slippage=50;
//--------------------------------------------------------------------
int OnInit()
{
   if (Digits==3 || Digits==5)
   {
      Stoploss*=10;
      Takeprofit*=10;
      TrailingStop*=10;
      TrailingStart*=10;
      TrailingStep*=10;
      TrailingStopOrder*=10;
      TrailingStepOrder*=10;
   }
   AC = " "+AccountCurrency();
   ChartSetInteger(0,CHART_BRING_TO_TOP,true);
   ChartSetInteger(0,CHART_COLOR_BACKGROUND,clrWhite);
   ChartSetInteger(0,CHART_SHOW_ASK_LINE,true);
   ChartSetInteger(0,CHART_COLOR_ASK,clrRed);
   ChartSetInteger(0,CHART_SHOW_BID_LINE,true);
   ChartSetInteger(0,CHART_COLOR_BID,clrBlue);
   ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,clrRed);
   ChartSetInteger(0,CHART_COLOR_CHART_DOWN,clrRed);
   ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,clrBlue);
   ChartSetInteger(0,CHART_COLOR_CHART_UP,clrBlue);
   ChartSetInteger(0,CHART_COLOR_CHART_LINE,clrBlack);
   ChartSetInteger(0,CHART_COLOR_FOREGROUND,clrBlack);
   ChartSetInteger(0,CHART_FOREGROUND,false);//Ценовой график на переднем плане
   ChartSetInteger(0,CHART_SHIFT,true);//Режим отступа ценового графика от правого края
   ChartSetInteger(0,CHART_AUTOSCROLL,true);//Режим автоматического перехода к правому краю графика
   ChartSetInteger(0,CHART_SHOW_LAST_LINE,true);//РОтображение значения Last горизонтальной линией на графике
   ChartSetInteger(0,CHART_COLOR_LAST,clrBlue);
   ChartSetInteger(0,CHART_SHOW_GRID,false);
   return(INIT_SUCCEEDED);
}
//--------------------------------------------------------------------
void OnTick()
{
   if (!IsTradeAllowed()) 
   {
      DrawLABEL("cm IsTradeAllowed","Торговля запрещена",5,15,clrRed,1);
      return;
   }
   else DrawLABEL("cm IsTradeAllowed","Торговля разрешена",5,15,clrGreen,1);

   //---
   STOPLEVEL=MarketInfo(Symbol(),MODE_STOPLEVEL);
   int tip,TicketBuyStop=0,TicketSellStop=0;
   double SL,TP,StLo,OSL,OTP,OOP,Profit=0,PriceSellStop=0,PriceBuyStop=0,ProfitB=0,ProfitS=0;
   int i,b=0,s=0;
   for (i=0; i<OrdersTotal(); i++)
   {    
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         if (OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
         { 
            tip = OrderType(); 
            OOP = NormalizeDouble(OrderOpenPrice(),Digits);
            OSL = NormalizeDouble(OrderStopLoss(),Digits);
            OTP = NormalizeDouble(OrderTakeProfit(),Digits);
            Profit+=OrderProfit()+OrderSwap()+OrderCommission();
            SL=OSL;TP=OTP;
            if (tip==OP_BUYSTOP) 
            {  
               TicketBuyStop=OrderTicket();
               PriceBuyStop = OOP;
            }                                         
            if (tip==OP_SELLSTOP) 
            {
               TicketSellStop=OrderTicket();
               PriceSellStop = OOP;
            }                                         
            if (tip==OP_BUY)             
            {  
               if (Stoploss!=0   && Bid<=OOP - Stoploss   * Point) {if (OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Bid,Digits),slippage,clrNONE)) continue;}
               if (Takeprofit!=0 && Bid>=OOP + Takeprofit * Point) {if (OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Bid,Digits),slippage,clrNONE)) continue;}
               ProfitB+=Profit;
               b++; 
               if (OSL==0 && Stoploss>=STOPLEVEL && Stoploss!=0)
               {
                  SL = NormalizeDouble(OOP - Stoploss   * Point,Digits);
               } 
               if (OTP==0 && Takeprofit>=STOPLEVEL && Takeprofit!=0)
               {
                  TP = NormalizeDouble(OOP + Takeprofit * Point,Digits);
               } 
               if (TrailingStop>=STOPLEVEL && TrailingStop!=0 && (Bid - OOP)/Point>=TrailingStart)
               {
                  StLo = NormalizeDouble(Bid - TrailingStop*Point,Digits); 
                  if (StLo >= OOP && StLo > OSL+TrailingStep*Point) SL = StLo;
               }
               if (SL != OSL || TP != OTP)
               {  
                  if (!OrderModify(OrderTicket(),OOP,SL,TP,0,clrNONE)) Print("Error OrderModify <<",Error(GetLastError()),">> ");
               }
            }                                         
            if (tip==OP_SELL)        
            {
               ProfitS+=Profit;
               s++;
               if (Stoploss!=0   && Ask>=OOP + Stoploss   * Point) {if (OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Ask,Digits),slippage,clrNONE)) continue;}
               if (Takeprofit!=0 && Ask<=OOP - Takeprofit * Point) {if (OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Ask,Digits),slippage,clrNONE)) continue;}
               if (OSL==0 && Stoploss>=STOPLEVEL && Stoploss!=0)
               {
                  SL = NormalizeDouble(OOP + Stoploss   * Point,Digits);
               }
               if (OTP==0 && Takeprofit>=STOPLEVEL && Takeprofit!=0)
               {
                  TP = NormalizeDouble(OOP - Takeprofit * Point,Digits);
               }
               if (TrailingStop>=STOPLEVEL && TrailingStop!=0 && (OOP - Ask)/Point>=TrailingStart)
               {
                  StLo = NormalizeDouble(Ask + TrailingStop*Point,Digits); 
                  if (StLo <= OOP && (StLo < OSL-TrailingStep*Point || OSL==0)) SL = StLo;
               }
               if (SL != OSL || TP != OTP)
               {  
                  if (!OrderModify(OrderTicket(),OOP,SL,TP,0,clrNONE)) Print("Error OrderModify <<",Error(GetLastError()),">> ");
               }
            } 
         }
      }
   } 
   //---
   DrawLABEL("cm Balance",StringConcatenate("Balance ",DoubleToStr(AccountBalance(),2),AC),5,30,clrBlack,1);
   DrawLABEL("cm Equity",StringConcatenate("Equity ",DoubleToStr(AccountEquity(),2),AC),5,45,clrBlack,1);
   DrawLABEL("cm FreeMargin",StringConcatenate("Free Margin ",DoubleToStr(AccountFreeMargin(),2),AC),5,60,clrBlack,1);
   DrawLABEL("cm Profit",StringConcatenate("Profit ",DoubleToStr(Profit,2),AC),5,75,Color(Profit>=0,clrGreen,clrRed),1);
   //---
   double Price,MA100 = iMA(NULL,timeframe,period,ma_shift,ma_method,applied_price,0);
   if (Bid>MA100)
   {
      if (TicketSellStop>0) 
         if(OrderDelete(TicketSellStop)) Print("Error ",GetLastError(),"   Delete ",TicketSellStop);
      Price=NormalizeDouble(Ask+TrailingStopOrder*Point,Digits);
      if (TicketBuyStop!=0)
      {
         if (Price < NormalizeDouble(PriceBuyStop-TrailingStepOrder*Point,Digits))
         {
            if (!OrderModify(TicketBuyStop,Price,0,0,0,clrBlue)) 
               Print("Error ",GetLastError(),"   Order Modify ",PriceBuyStop,"->",Price);
         }
      }
      else SendOrder(OP_BUYSTOP,Lot,Price);
   }
   else
   {
      if (TicketBuyStop>0) 
         if(OrderDelete(TicketBuyStop)) Print("Error ",GetLastError(),"   Delete ",TicketBuyStop);
      Price=NormalizeDouble(Bid-TrailingStopOrder*Point,Digits);
      if (TicketSellStop!=0)
      {
         if (Price > NormalizeDouble(PriceSellStop+TrailingStepOrder*Point,Digits))
         {
            if (!OrderModify(TicketSellStop,Price,0,0,0,clrRed)) 
               Print("Error ",GetLastError(),"   Order Modify ",PriceSellStop,"->",Price);
         }
      }
      else SendOrder(OP_SELLSTOP,Lot,Price);
   }
}
//--------------------------------------------------------------------
void OnDeinit(const int reason)
{
   if (!IsTesting()) ObjectsDeleteAll(0,"cm");
}
//--------------------------------------------------------------------
color Color(bool P,color a,color b)
{
   if (P) return(a);
   else return(b);
}
//------------------------------------------------------------------
bool SendOrder(int tip, double lot, double price)
{
   int error=0,nn=0;
   while(true)
   {
      RefreshRates();
      if (tip==OP_BUYSTOP)  error = OrderSend(Symbol(),OP_BUYSTOP,lot,NormalizeDouble(price,Digits),slippage,0,0,NULL,Magic,0,CLR_NONE);
      if (tip==OP_SELLSTOP) error = OrderSend(Symbol(),OP_SELLSTOP,lot,NormalizeDouble(price,Digits),slippage,0,0,NULL,Magic,0,CLR_NONE);
      if (tip==OP_BUY)      error = OrderSend(Symbol(),OP_BUY,lot,NormalizeDouble(price,Digits),slippage,0,0,NULL,Magic,0,CLR_NONE);
      if (tip==OP_SELL)     error = OrderSend(Symbol(),OP_SELL,lot,NormalizeDouble(price,Digits),slippage,0,0,NULL,Magic,0,CLR_NONE);
      
      if (error==-1)
      {
         Print("OrderSend Error ",GetLastError()," Lot ",lot);
         Sleep(1000);
      }
      else return(1);
      nn++;
      if (nn>10) return(0);
   }
   return(0);
}
//--------------------------------------------------------------------
void DrawLABEL(string name, string Name, int X, int Y, color clr, int C)
{
   if (ObjectFind(name)==-1)
   {
      ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
      ObjectSet(name, OBJPROP_CORNER, C);
      ObjectSet(name, OBJPROP_XDISTANCE, X);
      ObjectSet(name, OBJPROP_YDISTANCE, Y);
   }
   ObjectSetText(name,Name,8,"Arial",clr);
}
//--------------------------------------------------------------------
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