//+-------------------------------------------------------------------------------------------------------------------------------------------------+
//| Разработчик: Минаев Андрей                                                                                                                      |
//| Советник:    Week Grid.mql4                                                                                                                     |
//| Почта:       minaev.work@mail.ru                                                                                                                |
//| Скайп:       live:minaev.work                                                                                                                   |
//| Сайт:        safe-forex.ru                                                                                                                      |
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
#property copyright "Safe-Forex.ru"
#property link      "https://safe-forex.ru"
#property strict

extern int    magic         = 123; // Магик
extern double fixVolume     = 0.1; // Объем
extern double maxCandleSize = 200; // Максимальный размер недельной свечи
extern double minCandleSize = 100; // Минимальный размер недельной свечи
extern double profitInCurr  = 10;  // Прибыль
extern double gridStep      = 50;  // Шаг сетки

datetime newWeek;
bool     allowOpenBuy,
         allowOpenSell;
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
   CheckSignalExist();
   CheckPositionsProfit();
   
   if(allowOpenBuy) OpenPosition(OP_BUY);
   if(allowOpenSell) OpenPosition(OP_SELL);
   
   if(CountPositionsNumber(OP_BUY)>0)
   {
      double dist=(GetLastOpenPrice(OP_BUY)-Ask)/_Point;
      if(gridStep<=dist)
      {
         allowOpenBuy=true;
         Print("Разрешено открыть позицию Buy");
      }
   }
   if(CountPositionsNumber(OP_SELL)>0)
   {
      double dist=(Bid-GetLastOpenPrice(OP_SELL))/_Point;
      if(gridStep<=dist)
      {
         allowOpenSell=true;
         Print("Разрешено открыть позицию Sell");
      }
   }
}
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
//| Функция открывает позицию по текущей цене                                                                                                       |
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
void OpenPosition(int type)
{
   double price=0.0;
   if(type==OP_BUY)  price=Ask;
   if(type==OP_SELL) price=Bid;
   
   int ticket=OrderSend(_Symbol,type,fixVolume,price,0,0,0,"",magic,0);
   
   if(ticket>0)
   {
      if(type==OP_BUY)
      {
         allowOpenBuy=false;
         Print("Открылась позиция Buy, тикет: ",ticket);
      }
      if(type==OP_SELL)
      {
         allowOpenSell=false;
         Print("Открылась позиция Sell, тикет: ",ticket);
      }
   }
   if(ticket<0)
   {
      if(type==OP_BUY)  Print("Позиция Buy не открылась, ошибка: ", GetLastError());
      if(type==OP_SELL) Print("Позиция Sell не открылась, ошибка: ",GetLastError());
   }
}
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
//| Функция закрывает позицию по текущей цене                                                                                                       |
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
void ClosePosition(void)
{
   for(int i=OrdersTotal()-1; i>=0; i--)
      if(OrderSelect(i,SELECT_BY_POS))
         if(OrderSymbol()==_Symbol && OrderMagicNumber()==magic)
         {
            if(OrderType()==OP_BUY)
               if(OrderClose(OrderTicket(),OrderLots(),Bid,0))
                  Print("Закрылась позиция Buy, тикет: ", OrderTicket());
               else
                  Print("Позиция Buy не закрылась, тикет: ", OrderTicket(),", ошибка: ",GetLastError());
                  
            if(OrderType()==OP_SELL)
               if(OrderClose(OrderTicket(),OrderLots(),Ask,0))
                  Print("Закрылась позиция Sell, тикет: ", OrderTicket());
               else
                  Print("Позиция Sell не закрылась, тикет: ", OrderTicket(),", ошибка: ",GetLastError());
         }
}
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
//| Функция возвращает цену открытия последней позиции                                                                                              |
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
double GetLastOpenPrice(int type)
{
   double price=0;
   for(int i=0; i<OrdersTotal(); i++)
      if(OrderSelect(i,SELECT_BY_POS))
         if(OrderSymbol()==_Symbol && OrderMagicNumber()==magic && OrderType()==type)
            price=OrderOpenPrice();
   return price;
}
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
//| Функция подсчитывает количество открытых позиций                                                                                                |
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
int CountPositionsNumber(int type)
{
   int number=0;
   for(int i=0; i<OrdersTotal(); i++)
      if(OrderSelect(i,SELECT_BY_POS))
         if(OrderSymbol()==_Symbol && OrderMagicNumber()==magic && OrderType()==type)
            number++;
   return number;
}
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
//| Функция проверяет профит открытых позиций                                                                                                       |
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
void CheckPositionsProfit(void)
{
   if(AccountBalance()+profitInCurr<=AccountEquity()) ClosePosition();
}
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
//| Функция проверяет наличие сигнала                                                                                                               |
//+-------------------------------------------------------------------------------------------------------------------------------------------------+
void CheckSignalExist(void)
{
   datetime currWeek=iTime(_Symbol,PERIOD_W1,0);
   if(newWeek==currWeek) return;
   newWeek=currWeek;
   
   if(CountPositionsNumber(OP_BUY)>0 || CountPositionsNumber(OP_SELL)>0) return;
   
   double open=iOpen(_Symbol,PERIOD_W1,1),
          close=iClose(_Symbol,PERIOD_W1,1),
          candleSize=0;
   
   candleSize=MathAbs(open-close)/_Point;
   
   if(minCandleSize<candleSize && candleSize<maxCandleSize)
   {
      if(open>close)
      {
         allowOpenBuy=true;
         Print("Разрешено открыть позицию Buy");
      }
      if(open<close)
      {
         allowOpenSell=true;
         Print("Разрешено открыть позицию Sell");
      }
   }
}
//+-------------------------------------------------------------------------------------------------------------------------------------------------+