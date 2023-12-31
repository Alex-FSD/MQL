//+-------------------------------------------------------------------------------------------------------------------------------------------------+
//| Разработчик: Минаев Андрей                                                                                                                      |
//| Советник:    Stochastic.mq4                                                                                                                     |
//| Сайт:        safe-forex.ru                                                                                                                      |
//| Почта:       minaev.work@mail.ru                                                                                                                |
//| Скайп:       live:minaev.work                                                                                                                   |
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
#property copyright "Safe-Forex.ru"
#property link      "https://safe-forex.ru"
#property strict

input string         settings      = "";          // Настройки советника
input int            magic         = 111;         // Магик
input double         fixVolume     = 0.1;         // Объем
input int            takeProfit    = 20;          // Прибыль
input int            stopLoss      = 20;          // Убыток
input int            buyLevel      = 20;          // Уровень покупки
input int            sellLevel     = 80;          // Уровень продажи

input string         stochSettings = "";          // Настройки индикатора Stochastic Oscillator
input int            stochPeriodK  = 5;           // Период %K
input int            stochPeriodD  = 3;           // Период %D
input int            stochSlowing  = 3;           // Замедление
input ENUM_STO_PRICE stochPrice    = STO_LOWHIGH; // Цены
input ENUM_MA_METHOD stochMethod   = MODE_SMA;    // Метод

datetime newCandle;     // новая свеча на текущем графике
bool     allowOpenBuy,  // разрешение открыть позицию Buy
         allowOpenSell; // разрешение открыть позицию Sell
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
int OnInit(void)
{
   return INIT_SUCCEEDED;
}
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
void OnDeinit(const int reason)
{
}
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
void OnTick(void)
{
   if(newCandle!=Time[0]) CheckSignalExist(); newCandle=Time[0];
   
   if(allowOpenBuy) OpenPosition(OP_BUY);
   if(allowOpenSell) OpenPosition(OP_SELL);
}
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
//| Функция открывает позицию по текущей цене                                                                                                       |
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
void OpenPosition(int type)
{
   double price=0.0;
   if(type==OP_BUY) price=Ask;
   if(type==OP_SELL) price=Bid;
   
   int ticket=OrderSend(_Symbol,type,fixVolume,price,0,0,0,"",magic,0);
   
   if(ticket>0)
   {
      if(type==OP_BUY)
      {
         Print("Открылась позиция Buy, тикет: ",ticket);
         allowOpenBuy=false;
         SetStopOrders(ticket);
      }
      if(type==OP_SELL)
      {
         Print("Открылась позиция Sell, тикет: ",ticket);
         allowOpenSell=false;
         SetStopOrders(ticket);
      }
   }
   if(ticket<0)
   {
      if(type==OP_BUY) Print("Позиция Buy не открылась, ошибка: ",GetLastError());
      if(type==OP_SELL) Print("Позиция Sell не открылась, ошибка: ",GetLastError());
   }
}
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
//| Функция устанавливает стоп ордера                                                                                                               |
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
void SetStopOrders(int ticket)
{
   double stopLevel=MarketInfo(_Symbol,MODE_STOPLEVEL),
          spread   =MarketInfo(_Symbol,MODE_SPREAD),
          tp       =takeProfit,
          sl       =stopLoss;
   
   stopLevel+=spread;
   
   if(tp<stopLevel)
   {
      tp=stopLevel;
      Print("Установлена минимальная дистанция для прибыли");
   }
   if(sl<stopLevel)
   {
      sl=stopLevel;
      Print("Установлена минимальная дистанция для убытка");
   }
   if(OrderSelect(ticket,SELECT_BY_TICKET))
   {
      int    type=OrderType();
      double opp =OrderOpenPrice();
      
      if(type==OP_BUY)  {tp=opp+tp*_Point; sl=opp-sl*_Point;}
      if(type==OP_SELL) {tp=opp-tp*_Point; sl=opp+sl*_Point;}
      
      if(OrderModify(ticket,opp,sl,tp,0))
      {
         if(type==OP_BUY) Print("Установились уровни прибыли и убытка для позиции Buy, тикет: ",ticket);
         if(type==OP_SELL) Print("Установились уровни прибыли и убытка для позиции Sell, тикет: ",ticket);
      }
      else {
         if(type==OP_BUY) Print("Уровни прибыли и убытка для позиции Buy не установились, тикет: ",ticket,", ошибка: ",GetLastError());
         if(type==OP_SELL) Print("Уровни прибыли и убытка для позиции Sell не установились, тикет: ",ticket,", ошибка: ",GetLastError());
      }
   }
}
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
//| Функция проверяет наличие сигнала                                                                                                               |
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
void CheckSignalExist(void)
{
   double mainLine1=iStochastic(_Symbol,PERIOD_CURRENT,stochPeriodK,stochPeriodD,stochSlowing,stochMethod,stochPrice,MODE_MAIN,1),
          mainLine2=iStochastic(_Symbol,PERIOD_CURRENT,stochPeriodK,stochPeriodD,stochSlowing,stochMethod,stochPrice,MODE_MAIN,2),
          signLine1=iStochastic(_Symbol,PERIOD_CURRENT,stochPeriodK,stochPeriodD,stochSlowing,stochMethod,stochPrice,MODE_SIGNAL,1),
          signLine2=iStochastic(_Symbol,PERIOD_CURRENT,stochPeriodK,stochPeriodD,stochSlowing,stochMethod,stochPrice,MODE_SIGNAL,2);
   
   if(mainLine1>signLine1 && mainLine2<signLine2 && mainLine1<buyLevel && mainLine2<buyLevel && signLine1<buyLevel && signLine2<buyLevel)
   {
      Print("Появился сигнал для открытия позиции Buy");
      if(GetPositionsNumber()==0)
      {
         allowOpenBuy=true;
         Print("Разрешено открыть позицию Buy");
      }
   }
   if(mainLine1<signLine1 && mainLine2>signLine2 && mainLine1>sellLevel && mainLine2>sellLevel && signLine1>sellLevel && signLine2>sellLevel)
   {
      Print("Появился сигнал для открытия позиции Sell");
      if(GetPositionsNumber()==0)
      {
         allowOpenSell=true;
         Print("Разрешено открыть позицию Sell");
      }
   }
}
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
//| Функция возвращает количество открытых позиций                                                                                                  |
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
int GetPositionsNumber(void)
{
   int number=0;
   for(int i=0; i<OrdersTotal(); i++)
      if(OrderSelect(i,SELECT_BY_POS))
         if(OrderSymbol()==_Symbol && OrderMagicNumber()==magic)
            number++;
   return number;
}
//+-------------------------------------------------------------------------------------------------------------------------------------------------+