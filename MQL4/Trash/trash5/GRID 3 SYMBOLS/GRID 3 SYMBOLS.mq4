#property copyright "Programming © 2015, http://cmillion.ru"
#property link      "cmillion@narod.ru"
#property strict
#property description "Советник выставляет стоп 3 сети из ордеров по трем указанным парам"
#property description "Как только суммарный профит по всем позициям превысит указанный уровень,"
#property description "советник закрывает все и по новой переоткрывает сети"

extern      string Symbol1 = "EURUSD";
extern      string Symbol2 = "GBPUSD";
extern      string Symbol3 = "EURJPY";

extern      int    Step01 = 4;
extern      int    Orders = 14;
extern      int    Step02 = 6;
extern      double Lot    = 0.01;
extern      double Profit = 10.0;
extern      int    Magic  = 123;
//-------------------------------
string AC;
int OnInit()
  {
   if (Symbol()!=Symbol1 || Symbol()!=Symbol2 || Symbol()!=Symbol3) Symbol1 = Symbol();
   AC = StringConcatenate(" ", AccountCurrency());
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
      Comment("Советник закончил свою работу");
  }
//+------------------------------------------------------------------+
void OnTick()
{
   int i,n1=0,n2=0,n3=0;
   double profit1=0,profit2=0,profit3=0;
   string symbol;
   for (i=0; i<OrdersTotal(); i++)
   {    
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      { 
         if (OrderMagicNumber()==Magic)
         { 
            symbol=OrderSymbol();
            if (symbol==Symbol1)
            { 
               profit1+=OrderProfit()+OrderSwap()+OrderCommission();
               n1++;
            }
            if (symbol==Symbol2)
            { 
               profit2+=OrderProfit()+OrderSwap()+OrderCommission();
               n2++;
            }
            if (symbol==Symbol3)
            { 
               profit3+=OrderProfit()+OrderSwap()+OrderCommission();
               n3++;
            }
         }
      }
   }
   if (n1+n2+n3==0)
   {
      double PointEURUSD = MarketInfo(Symbol1,MODE_POINT);
      double PointGBPUSD = MarketInfo(Symbol2,MODE_POINT);
      double PointEURJPY = MarketInfo(Symbol3,MODE_POINT);
      
      double OpenEURUSD = iClose(Symbol1,PERIOD_M30,0);

      if (OrderSend (Symbol1, OP_BUYSTOP,  Lot, OpenEURUSD+Step01*PointEURUSD, 3, 0,0, "GRID", Magic,0,CLR_NONE)
      ==-1) Comment("OrderSend ",Symbol1," Error ",GetLastError());
      if (OrderSend (Symbol1, OP_SELLSTOP, Lot, OpenEURUSD-Step01*PointEURUSD, 3, 0,0, "GRID", Magic,0,CLR_NONE)
      ==-1) Comment("OrderSend ",Symbol1," Error ",GetLastError());
      RefreshRates();
      
      double OpenGBPUSD = iClose(Symbol2,PERIOD_M30,0);

      if (OrderSend (Symbol2, OP_BUYSTOP,  Lot, OpenGBPUSD+Step01*PointGBPUSD, 3, 0,0, "GRID", Magic,0,CLR_NONE)
      ==-1) Comment("OrderSend ",Symbol2," Error ",GetLastError());
      if (OrderSend (Symbol2, OP_SELLSTOP, Lot, OpenGBPUSD-Step01*PointGBPUSD, 3, 0,0, "GRID", Magic,0,CLR_NONE)
      ==-1) Comment("OrderSend ",Symbol2," Error ",GetLastError());
       RefreshRates();
     
      double OpenEURJPY = iClose(Symbol3,PERIOD_M30,0);

      if (OrderSend (Symbol3, OP_BUYSTOP,  Lot, OpenEURJPY+Step01*PointEURJPY, 3, 0,0, "GRID", Magic,0,CLR_NONE)
      ==-1) Comment("OrderSend ",Symbol3," Error ",GetLastError());
      if (OrderSend (Symbol3, OP_SELLSTOP, Lot, OpenEURJPY-Step01*PointEURJPY, 3, 0,0, "GRID", Magic,0,CLR_NONE)
      ==-1) Comment("OrderSend ",Symbol3," Error ",GetLastError());
      RefreshRates();
      
      for (i=1; i<=Orders; i++) 
      {
            if (OrderSend (Symbol1, OP_BUYSTOP,  Lot, OpenEURUSD+Step01*PointEURUSD+i*Step02*PointEURUSD, 3, 0,0, "GRID", Magic,0,CLR_NONE)
            ==-1) Comment("OrderSend ",Symbol1," Error ",GetLastError());
            if (OrderSend (Symbol1, OP_SELLSTOP, Lot, OpenEURUSD-Step01*PointEURUSD-i*Step02*PointEURUSD, 3, 0,0, "GRID", Magic,0,CLR_NONE)
            ==-1) Comment("OrderSend ",Symbol1," Error ",GetLastError());
            
            if (OrderSend (Symbol2, OP_BUYSTOP,  Lot, OpenGBPUSD+Step01*PointGBPUSD+i*Step02*PointGBPUSD, 3, 0,0, "GRID", Magic,0,CLR_NONE)
            ==-1) Comment("OrderSend ",Symbol2," Error ",GetLastError());
            if (OrderSend (Symbol2, OP_SELLSTOP, Lot, OpenGBPUSD-Step01*PointGBPUSD-i*Step02*PointGBPUSD, 3, 0,0, "GRID", Magic,0,CLR_NONE)
            ==-1) Comment("OrderSend ",Symbol2," Error ",GetLastError());
            
            if (OrderSend (Symbol3, OP_BUYSTOP,  Lot, OpenEURJPY+Step01*PointEURJPY+i*Step02*PointEURJPY, 3, 0,0, "GRID", Magic,0,CLR_NONE)
            ==-1) Comment("OrderSend ",Symbol3," Error ",GetLastError());
            if (OrderSend (Symbol3, OP_SELLSTOP, Lot, OpenEURJPY-Step01*PointEURJPY-i*Step02*PointEURJPY, 3, 0,0, "GRID", Magic,0,CLR_NONE)
            ==-1) Comment("OrderSend ",Symbol3," Error ",GetLastError());
      }
   }
   else
   {
      if (profit1+profit2+profit3 > Profit) DeleteAllOrders();
      Comment(n1," orders  ",Symbol1," Profit = ",DoubleToStr(profit1,2),AC,"\n",
              n2," orders  ",Symbol2," Profit = ",DoubleToStr(profit2,2),AC,"\n",
              n3," orders  ",Symbol3," Profit = ",DoubleToStr(profit3,2),AC,"\n",
              n1+n2+n3," orders, Profit = ",DoubleToStr(profit1+profit2+profit3,2),AC,"\nClose ",DoubleToStr(Profit,2),AC);
   }
   return;
}
//-------------------------------
void DeleteAllOrders() 
{
   string symbol;
   bool error=true;
   int j,nn=0;
   while(true)
   {
      for (j = OrdersTotal()-1; j >= 0; j--)
      {
         if (OrderSelect(j, SELECT_BY_POS))
         {
            symbol=OrderSymbol();
            if ((symbol==Symbol1 || symbol==Symbol2 || symbol==Symbol3) && OrderMagicNumber() == Magic)
            {
               int DIGITS = (int)MarketInfo(symbol,MODE_DIGITS);
               double ASK = NormalizeDouble(MarketInfo(symbol,MODE_ASK),DIGITS);
               double BID = NormalizeDouble(MarketInfo(symbol,MODE_BID),DIGITS);
               double POINT = MarketInfo(symbol,MODE_POINT);
               int OT = OrderType();
               int Ticket=OrderTicket();
               if (OT==OP_BUY) 
               {
                  error=OrderClose(Ticket,OrderLots(),BID,50,Red);
               }
               if (OT==OP_SELL) 
               {
                  error=OrderClose(Ticket,OrderLots(),ASK,50,Red);
               }
               if (OT>1) 
                  if (!OrderDelete(Ticket))
                     Comment("Ордер ",Ticket," ошибка удаления ",GetLastError());
               
               if (!error) 
               {
                  int err = GetLastError();
                  if (err<2) continue;
                  if (err==129) 
                  {  Comment("Неправильная цена ",TimeToStr(TimeCurrent(),TIME_SECONDS));
                     Sleep(5000);
                     RefreshRates();
                     continue;
                  }
                  if (err==146) 
                  {
                     int ret1=MessageBox("Подсистема торговли занята"," ", 
                         MB_RETRYCANCEL|MB_TOPMOST|MB_ICONWARNING);
                     if (ret1==IDCANCEL) return;
                     j++;
                     if (IsTradeContextBusy()) Sleep(2000);
                     continue;
                  }
                  Comment("Ошибка ",err," закрытия ордера N ",Ticket,"     ",TimeToStr(TimeCurrent(),TIME_SECONDS));
               }
            }
         }
      }
      int n=0;
      for (j = 0; j < OrdersTotal(); j++)
      {
         if (OrderSelect(j, SELECT_BY_POS))
         {
            symbol=OrderSymbol();
            if ((symbol==Symbol1 || symbol==Symbol2 || symbol==Symbol3) && OrderMagicNumber() == Magic)
            {
               n++;
            }
         }  
      }
      if (n==0) break;
      nn++;
      if (nn>10) {Comment("Не удалось закрыть все сделки, осталось еще ",n);break;}
      Sleep(1000);
      RefreshRates();
   }
}
//-------------------------------
