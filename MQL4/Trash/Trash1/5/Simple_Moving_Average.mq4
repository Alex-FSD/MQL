//+-----------------------------------------------------------------------------------------------+
//|                                                                     Simple Moving Average.mq4 |
//|                                                                 Copyright 2016, Andrey Minaev |
//|                                                     https://www.mql5.com/ru/users/id.scorpion |
//+-----------------------------------------------------------------------------------------------+
#property copyright "Copyright 2016, Andrey Minaev"
#property link      "https://www.mql5.com/ru/users/id.scorpion"
#property version   "1.00"
#property strict

// Параметры советника
extern string sParametersEA = "";     // Параметры советника
extern double dLots         = 0.01;   // Количество лотов
extern int    iStopLoss     = 30;     // Уровень убытка (в пунктах)
extern int    iTakeProfit   = 30;     // Уровень прибыли (в пунктах)
extern int    iSlippage     = 3;      // Проскальзование (в пунктах)
extern int    iMagic        = 1;      // Индентификатор советника
// Параметры индикатора
extern string sParametersMA = "";     // Параметры индикатора 
extern int    iPeriodMA     = 14;     // Период усреднения
// Глобальные переменные
double dMA;
//+-----------------------------------------------------------------------------------------------+
int OnInit()
{
   // Если брокер использует 3 или 5 знаков после запятой, то умножаем на 10 
   if(Digits == 3 || Digits == 5)
   {
      iStopLoss   *= 10;
      iTakeProfit *= 10;
      iSlippage   *= 10;
   }
   
   return(INIT_SUCCEEDED);
}
//+-----------------------------------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   
}
//+-----------------------------------------------------------------------------------------------+
void OnTick()
{
   // Получим значение индикатора
   dMA = iMA(Symbol(), 0, iPeriodMA, 0, MODE_SMA, PRICE_CLOSE, 0);
   
   // Если нет открытых ордеров, то входим в условие
   if(bCheckOrders() == true)
   {
      // Если появился сигнал на покупку, то откроем ордер на покупку
      if(bSignalBuy() == true)
         vOrderOpenBuy();
      
      // Если появился сигнал на продажу, то откроем ордер на продажу
      if(bSignalSell() == true)
         vOrderOpenSell();      
   }
}
//+-----------------------------------------------------------------------------------------------+
//|                                                             Функция проверки открытых оредров |
//+-----------------------------------------------------------------------------------------------+
bool bCheckOrders()
{
   // Переберем в цикле ордера, для проверки открытых ордеров данным советником
   for(int i = 0; i <= OrdersTotal(); i++)
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == iMagic)
            return(false);
            
   return(true);
}
//+-----------------------------------------------------------------------------------------------+
//|                                                             Функция поиска сигнала на покупку |
//+-----------------------------------------------------------------------------------------------+
bool bSignalBuy()
{
   if(dMA > Open[1] && dMA < Close[1])
      return(true);
      
   return(false);
}
//+-----------------------------------------------------------------------------------------------+
//|                                                             Функция поиска сигнала на продажу |
//+-----------------------------------------------------------------------------------------------+
bool bSignalSell()
{
   if(dMA < Open[1] && dMA > Close[1])
      return(true);
      
   return(false);
}
//+-----------------------------------------------------------------------------------------------+
//|                                                            Функция открытия ордера на покупку |
//+-----------------------------------------------------------------------------------------------+
void vOrderOpenBuy()
{
   int iOTi = 0;   // Тикет ордера 
   
   iOTi = OrderSend(Symbol(), OP_BUY, dLots, Ask, iSlippage, 0, 0, "", iMagic, 0, clrNONE);
   
   // Проверим открылся ли ордер
   if(iOTi > 0)
      // Есди да, то выставим уровни убытка и прибыли
      vOrderModify(iOTi);
   else
      // Если нет, то получим ошибку
      vError(GetLastError());
}
//+-----------------------------------------------------------------------------------------------+
//|                                                            Функция открытия ордера на продажу |
//+-----------------------------------------------------------------------------------------------+
void vOrderOpenSell()
{
   int iOTi = 0;   // Тикет ордера 
   
   iOTi = OrderSend(Symbol(), OP_SELL, dLots, Bid, iSlippage, 0, 0, "", iMagic, 0, clrNONE);
   
   // Проверим открылся ли ордер
   if(iOTi > 0)
      // Есди да, то выставим уровни убытка и прибыли
      vOrderModify(iOTi);
   else
      // Если нет, то получим ошибку
      vError(GetLastError());
}
//+-----------------------------------------------------------------------------------------------+
//|                                                                    Функция модификации ордера |
//+-----------------------------------------------------------------------------------------------+
void vOrderModify(int iOTi)
{  
   int    iOTy = -1;   // Тип ордера
   double dOOP = 0;    // Цена открытия ордера
   double dOSL = 0;    // Стоп Лосс
   int    iMag = 0;    // Идентификатор советника
   
   double dSL = 0;     // Уровень убытка
   double dTP = 0;     // Уровень прибыли
   
   // Выберем по тикету открытый ордер, получим некоторые значения
   if(OrderSelect(iOTi, SELECT_BY_TICKET, MODE_TRADES))
   {
      iOTy = OrderType();
      dOOP = OrderOpenPrice();
      dOSL = OrderStopLoss();
      iMag = OrderMagicNumber();
   }
   
   // Если ордер открыл данный советник, то входим в условие
   if(OrderSymbol() == Symbol() && OrderMagicNumber() == iMag)
   {
      // Если Стоп Лосс текущего ордера равен нулю, то модифицируем ордер
      if(dOSL == 0)
      {
         if(iOTy == OP_BUY)
         {
            dSL = NormalizeDouble(dOOP - iStopLoss * Point, Digits);
            dTP = NormalizeDouble(dOOP + iTakeProfit * Point, Digits);
            
            bool bOM = OrderModify(iOTi, dOOP, dSL, dTP, 0, clrNONE);       
         }
         
         if(iOTy == OP_SELL)
         {
            dSL = NormalizeDouble(dOOP + iStopLoss * Point, Digits);
            dTP = NormalizeDouble(dOOP - iTakeProfit * Point, Digits);
            
            bool bOM = OrderModify(iOTi, dOOP, dSL, dTP, 0, clrNONE);       
         }         
      }  
   } 
}
//+-----------------------------------------------------------------------------------------------+
//|                                                                      Функция обработки ошибок |
//+-----------------------------------------------------------------------------------------------+
void vError(int iErr)
{
   switch(iErr)
   {
      case 129:   // Неправильная цена
      case 135:   // Цена изменилась
      case 136:   // Нет цен
      case 138:   // Новые цены
         Sleep(1000);
         RefreshRates();
         break;
      
      case 137:   // Брокер занят
      case 146:   // Подсистема торговли занята        
         Sleep(3000);
         RefreshRates();
         break;
   }
}
//+-----------------------------------------------------------------------------------------------+