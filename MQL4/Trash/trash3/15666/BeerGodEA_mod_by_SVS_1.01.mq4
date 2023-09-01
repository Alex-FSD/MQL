//+------------------------------------------------------------------+
//|                                         BeerGodEA mod by SVS.mq4 |
//|                                              Copyright 2016, SVS |
//|   http://forum.tradelikeapro.ru/index.php?action=profile;u=77648 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, SVS"
#property link      "http://forum.tradelikeapro.ru/index.php?action=profile;u=77648"
#property version   "1.01"
#property strict

#include <stdlib.mqh>
#include <WinUser32.mqh>
//--- enum parameters
enum Martin_Type
  {
   Off=0,//Off - Выключен
   Clasic=1, //Classic - Мартингейл + его подварианты см. Auto_Multipleer
   Parlay=2, //Parlay - Парлай
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum Auto_Multipler
  {
   Unused=0,//Unused - не используется
   Balance_Mod=1,//Balance Mod - расчет относительно просадки баланса
   Point_Mod=2,//Point Mod - расчет относительно потерянных пунктов к последним прибыльным до мартина
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum AutoMM
  {
   Fixed=0,//Fixed - Автоматика отключена
   Risk_Control=1,//Расчет лота по риску
   Trall_Lot,//Trall_Lot - Подъем/снижение лота каждые n баланса.
  };
//--- input parameters
input AutoMM Type_Calculation=Fixed; //AutoMM - Включать Money Management
input double Risk=5.0;//Risk - Максимальный риск на сделку
input double Start_Balance=1000;//Start_Balance - Введите начальный баланс. Работает только в режиме Trall_Lot
input double Step_Balance=500;//Step_Balance - Шаг баланса через каждые сколько подтягивать/спускать лот. Работает только в режиме Trall_Lot
extern double Start_Lot=0.01; //Start_Lot - Введите лот
input bool Start_Lot_Minimal=False;//Start_Lot_Minimal - Не опускать лот ниже чем Start_Lot
input double StopLoss=0;//StopLoss - Стоп
input bool Allow_trade_after_stop=False;//Allow_trade_after_stop - Разрешить торговлю после Стопа лосса не дожидаясь обратного сигнала
input double TakeProfit=0;//TakeProfit - Тэйк
input bool Allow_trade_after_take=True;//Allow_trade_after_take - Разрешить торговлю после Тэйк профита не дожидаясь обратного сигнала
input int Period_MA=20; //Period_MA - Период МА
input int TimeBarOpen=0; //TimeBarOpen - Минут после открытия бара.
input int Slippage=1;  //Slippage - Проскальзывание
input int Profit_Min=1;//Profit_Min - Минимальный профит в пунктах
input int Loss_Min=1;//Loss_Min - Минимальные потери в пунктах
input Martin_Type Strategy=Off;//Martin_Type Strategy - Выбор стратегии мартина
input Auto_Multipler Multipler_Mod=Unused; //Auto_Multipler - Авторасчет множителя в классическом режиме. !!!Опасный режим!!!
input bool Reset_Martin_if_win=False;//Reset_Martin_if_win - Вернуть лот в начальное положение если есть 1 победа.
extern double Martin_multiplier=2.0; //Martin_multiplier - Множитель мартина
input int Parlay_max=3;//Parlay_max - Если выбрали метод Парлая. Максимальное кол-во умножений до сброса.
input int Magic=100;

//============== Переменные ==========================================
double version=1.01;
string GetNameOP="BeerGodEA mod by SVS"; // комент в открытом ордере
datetime TimeBar_t; // текущее время свечи
double sv_close; // цена закрытия свечи
double MA_1_t; // МА текущая
double MA_1_p; // МА предыдущая
bool NewBuy; // сигнал открытия покупки
bool NewSell; // сигнал открытия продажи
double Lot=Start_Lot;
double Profit_Point=0;
double Loss_Point=0;
double Balance=AccountBalance();
int ticket=-1;
bool Block_Buy=False;
bool Block_Sell=False;
int Parlay_Count=0;
double Lot_min=Start_Lot;
double Lot_variable=Start_Lot;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   if(IsExpertEnabled())
     {
      Comment("Советник будет запущен после генерации бара");
     }
   else
     {
      Comment("Отжата кнопка \"Разрешить запуск советников\"");
     }
   if(Multipler_Mod>0)
      Martin_multiplier=1.0;
   Money_Management();
   Lot=Lot_variable;
   if(OrderExist())
      ticket=OrderTicket();
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//|                   Параметры тестирования                         |
//+------------------------------------------------------------------+

double OnTester()
  {
   double ret=0.0;
   if(TesterStatistics(STAT_EQUITY_DD)>0)
      ret=TesterStatistics(STAT_PROFIT)/TesterStatistics(STAT_EQUITY_DD);
   else ret=0;
   return(ret);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   TimeBar_t=(TimeCurrent()-Time[0])/60; // время в минутах с открытия свечи
   if(TimeBar_t==TimeBarOpen)
     {
      Informer();    // Комментарий в угол окна  
      Money_Management();
      Obtaining_data();
      Data_handling();
      Open_Order();
      Close_Order();
     }
   Control_Order();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Informer()
  {
   string Signal;
   if(!NewBuy && !NewSell)
      Signal="No Signal";
   else if(NewBuy)
      Signal="Buy Signal";
   else if(NewSell)
      Signal="Sell Signal";
   if(ticket>-1)
     {
      if(OrderType()==OP_BUY)
         Comment("BerGodEA mod by SVS v",version," by SVS\n",
                 "Last Tick: ",TimeToStr(CurTime(),TIME_DATE|TIME_SECONDS),"\n",
                 "Signal: ",Signal,"\n",
                 "Current order: ",ticket,"\n",
                 "Lot_min: ",Lot_min,"\n",
                 "Lot_variable: ",Lot_variable,"\n",
                 "Lot: ",Lot,"\n",
                 "Type order: Buy\n",
                 "Distance to TakeProfit: ",TakeProfit-OrderOpenPrice(),"\n",
                 "Distance to StopLoss: ",OrderOpenPrice()-StopLoss,"\n",
                 "Block_Buy: ",Block_Buy,"\n",
                 "Block_Sell: ",Block_Sell,"\n",
                 "Martin multiplier: ",Martin_multiplier,"\n",
                 "Parlay count: ",Parlay_Count);
      else if(OrderType()==OP_SELL)
         Comment("Drifter v",version," by SVS\n",
                 "Last Tick: ",TimeToStr(CurTime(),TIME_DATE|TIME_SECONDS),"\n",
                 "Signal: ",Signal,"\n",
                 "Current order: ",ticket,"\n",
                 "Lot_min: ",Lot_min,"\n",
                 "Lot_variable: ",Lot_variable,"\n",
                 "Lot: ",Lot,"\n",
                 "Type order: Sell\n",
                 "Distance to TakeProfit: ",OrderOpenPrice()-TakeProfit,"\n",
                 "Distance to StopLoss: ",StopLoss-OrderOpenPrice(),"\n",
                 "Block_Buy: ",Block_Buy,"\n",
                 "Block_Sell: ",Block_Sell,"\n",
                 "Martin multiplier: ",Martin_multiplier,"\n",
                 "Parlay count: ",Parlay_Count);
     }
   else
      Comment("Drifter v",version," by SVS\n",
              "Last Tick: ",TimeToStr(CurTime(),TIME_DATE|TIME_SECONDS),"\n",
              "Signal: ",Signal,"\n",
              "Current order: ",ticket,"\n",
              "Lot_min: ",Lot_min,"\n",
              "Lot_variable: ",Lot_variable,"\n",
              "Lot: ",Lot,"\n",
              "Type order: NULL\n",
              "Distance to TakeProfit: NULL\n",
              "Distance to StopLoss: NULL\n",
              "Block_Buy: ",Block_Buy,"\n",
              "Block_Sell: ",Block_Sell,"\n",
              "Martin multiplier: ",Martin_multiplier,"\n",
              "Parlay count: ",Parlay_Count);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Money_Management()
  {
   switch(Type_Calculation)
     {
      case 0:
         break;
      case 1:
        {
         double Free=AccountFreeMargin();
         double LotVal=MarketInfo(Symbol(),MODE_TICKVALUE);//стоимость 1 пункта 1 лота
         double Min_Lot =MarketInfo(Symbol(),MODE_MINLOT);
         double Max_Lot =MarketInfo(Symbol(),MODE_MAXLOT);
         double Step    =MarketInfo(Symbol(),MODE_LOTSTEP);
         Lot_variable=MathFloor((Free*Risk/100)/((StopLoss+(MarketInfo(Symbol(),MODE_SPREAD)))*LotVal)/Step)*Step;
         if(Lot_variable<Min_Lot)  Lot_variable=Min_Lot;
         if(Lot_variable>Max_Lot)  Lot_variable=Max_Lot;
         if(Start_Lot_Minimal && (Lot_variable<Lot_min)) Lot_variable=Lot_min;
         break;
        }
      case 2:
        {
         int AB=(int)(AccountBalance());
         int SB=(int)(Step_Balance);
         if(AB<SB)
            AB+=SB;
         Lot_variable=Lot_min+(Lot_min*(Step_Balance/Start_Balance)*(((AB-(AB%SB))-Start_Balance)/Step_Balance));
         if(Start_Lot_Minimal && (Lot_variable<Lot_min))
            Lot_variable=Lot_min;
         if(Strategy==0)
            Lot=Lot_variable;
         break;
        }
     }
  }
//+------------------------------------------------------------------+
//|                        Получение данных                          |
//+------------------------------------------------------------------+
void Obtaining_data()
  {
   MA_1_t=iMA(NULL,0,Period_MA,0,MODE_SMA,PRICE_CLOSE,0); // МА_1 текущая
   MA_1_p=iMA(NULL,0,Period_MA,0,MODE_SMA,PRICE_CLOSE,1); // МА_1 предыдущая
                                                          //TimeBar_t=(TimeCurrent()-Time[0])/60; // время в минутах с открытия свечи
   sv_close=iClose(NULL,0,1); // цена закрытия свечи на предыдущем баре
   RefreshRates();
  }
//+------------------------------------------------------------------+
//|                        Обработка данных                          |
//+------------------------------------------------------------------+
void Data_handling()
  {
   if((Ask<MA_1_t) && (MA_1_t<MA_1_p) && (Ask<sv_close) && (TimeBar_t==TimeBarOpen))
     {
      NewBuy=True;
      Block_Sell=False;
     }
   else NewBuy=False; // условие BUY
   if((Bid>MA_1_t) && (MA_1_t>MA_1_p) && (Bid>sv_close) && (TimeBar_t==TimeBarOpen))
     {
      NewSell=True;
      Block_Buy=False;
     }
   else NewSell=False; // условие Sell
  }
//+------------------------------------------------------------------+
//|                        Открытие ордеров                          |
//+------------------------------------------------------------------+
void Open_Order()
  {
   if((NewBuy==True) && (OrderExist()==False) && (Block_Buy==False))
     {
      while(!IsTradeAllowed()) Sleep(100);
      ticket=OrderSend(Symbol(),OP_BUY,Lot,Ask,Slippage,0,0,GetNameOP,Magic,0,LightSkyBlue);
      if(ticket==-1)
         Print("void Open_Order(): NewBuy: OrderSend() error - ",ErrorDescription(GetLastError()));
     }
   if((NewSell==True) && (OrderExist()==False) && (Block_Sell==False))
     {
      while(!IsTradeAllowed()) Sleep(100);
      ticket=OrderSend(Symbol(),OP_SELL,Lot,Bid,Slippage,0,0,GetNameOP,Magic,0,HotPink);
      if(ticket==-1)
         Print("void Open_Order(): NewBuy: OrderSend() error - ",ErrorDescription(GetLastError()));
     }
  }
//+------------------------------------------------------------------+
//|                        Контроль ордеров                          |
//+------------------------------------------------------------------+
void Control_Order()
  {
   if(ticket==-1) return;
   if(!OrderSelect(ticket,SELECT_BY_TICKET))
      Print("void Control_Order(): OrderSelect() error - ",ErrorDescription(GetLastError()));
   if(OrderType()==OP_BUY)
     {
      if(StopLoss>0)
         if((OrderOpenPrice()-Bid)>=(StopLoss*Point))
           {
            CloseAllLossBuy();
            if(!Allow_trade_after_stop)
               Block_Buy=True;
            Informer();
            return;
           }
      if(TakeProfit>0)
         if((Ask-OrderOpenPrice())>=(TakeProfit*Point))
           {
            CloseAllProfitBuy();
            if(!Allow_trade_after_take)
               Block_Buy=True;
            Informer();
            return;
           }
     }
   else if((OrderType()==OP_SELL))
     {
      if(StopLoss>0)
         if((Ask-OrderOpenPrice())>=(StopLoss*Point))
           {
            CloseAllLossSell();
            if(!Allow_trade_after_stop)
               Block_Sell=True;
            Informer();
            return;
           }
      if(TakeProfit>0)
         if((OrderOpenPrice()-Bid)>=(TakeProfit*Point))
           {
            CloseAllProfitSell();
            if(!Allow_trade_after_take)
               Block_Sell=True;
            Informer();
            return;
           }
     }
  }
//+------------------------------------------------------------------+
//|                           Закрытие ордеров                       |
//+------------------------------------------------------------------+

void Close_Order()
  {
   if(NewBuy==True)
     {
      CloseAllProfitSell();
      CloseAllLossSell();
     }
   if(NewSell==True)
     {
      CloseAllProfitBuy();
      CloseAllLossBuy();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OrderExist()
  {
   bool exists=False;
   for(int i=OrdersTotal()-1; i>=0; i--)
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if((OrderSymbol()==Symbol()) && (OrderMagicNumber()==Magic))
           {
            exists=True;
            return (exists);
           }
        }
   else
     {
      Print("OrderSelect() error - ",ErrorDescription(GetLastError()));
     }

   return (exists);
  }
//+------------------------------------------------------------------+
//|                 Закрыть прибыльные ордера                        |
//+------------------------------------------------------------------+
void CloseAllProfitBuy()

  {
   int Profit1=Profit_Min;
   int col1=Gold;
   double bid1,open1;
   double point1;
   for(int i1=OrdersTotal()-1; i1>=0; i1--)
     {
      if(!OrderSelect(i1,SELECT_BY_POS,MODE_TRADES)) break;
      if(OrderType()==OP_BUY)
        {
         point1=MarketInfo(Symbol(),MODE_POINT);
         if(point1==0) break;
         bid1=MathRound(MarketInfo(OrderSymbol(),MODE_BID)/point1);
         open1=MathRound(OrderOpenPrice()/point1);
         if(bid1-open1<Profit1) continue;
         while(!IsTradeAllowed()) Sleep(100);
         if(!OrderClose(OrderTicket(),OrderLots(),bid1*point1,Slippage,col1))
            Print("void CloseAllProfitBuy(): OrderType=OP_BUY: OrderClose() error - ",ErrorDescription(GetLastError()));
         else
           {
            ticket=-1;
            if(Lot==Start_Lot)
               Profit_Point=bid1-open1;
            if((Strategy==1) && ((AccountBalance()>=Balance) || Reset_Martin_if_win))
              {
               Lot=Lot_variable;
               Balance=AccountBalance();
              }
            else if(Strategy==2)
              {
               Parlay_Count++;
               if(Parlay_Count<Parlay_max)
                  Lot=Lot*Martin_multiplier;
               else
                 {
                  Parlay_Count=0;
                  Lot=Lot_variable;
                 }
              }
            if(AccountBalance()>Balance)
              {
               Balance=AccountBalance();
               if(Multipler_Mod>0)
                  Martin_multiplier=1.0;
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                       Закрыть SELL в профите                     |
//+------------------------------------------------------------------+
void CloseAllProfitSell()

  {
   int Profit2=Profit_Min;
   int col2=Gold;
   double ask2,open2;
   double point2;
   for(int i2=OrdersTotal()-1; i2>=0; i2--)
     {
      if(!OrderSelect(i2,SELECT_BY_POS,MODE_TRADES)) break;
      if(OrderType()==OP_SELL)
        {
         point2=MarketInfo(Symbol(),MODE_POINT);
         if(point2==0) break;
         ask2=MathRound(MarketInfo(OrderSymbol(),MODE_ASK)/point2);
         open2=MathRound(OrderOpenPrice()/point2);
         if(open2-ask2<Profit2) continue;
         while(!IsTradeAllowed()) Sleep(100);
         if(!OrderClose(OrderTicket(),OrderLots(),ask2*point2,Slippage,col2))
            Print("void CloseAllProfitSell(): OrderType=OP_SELL: OrderClose() error - ",ErrorDescription(GetLastError()));
         else
           {
            ticket=-1;
            if(Lot==Start_Lot)
               Profit_Point=open2-ask2;
            if((Strategy==1) && ((AccountBalance()>=Balance) || Reset_Martin_if_win))
              {
               Lot=Lot_variable;
               Balance=AccountBalance();
              }
            else if(Strategy==2)
              {
               Parlay_Count++;
               if(Parlay_Count<Parlay_max)
                  Lot=Lot*Martin_multiplier;
               else
                 {
                  Parlay_Count=0;
                  Lot=Lot_variable;
                 }
              }
            if(AccountBalance()>Balance)
              {
               Balance=AccountBalance();
               if(Multipler_Mod>0)
                  Martin_multiplier=1.0;
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                       Закрыть убыточные ордера                   |
//+------------------------------------------------------------------+
void CloseAllLossBuy()
  {
   int Stop4=Loss_Min;
//   int slip=2;
   double bid4,open4;
   double point4;
   for(int i4=OrdersTotal()-1; i4>=0; i4--)
     {
      if(!OrderSelect(i4,SELECT_BY_POS,MODE_TRADES)) break;
      if(OrderType()==OP_BUY)
        {
         point4=MarketInfo(Symbol(),MODE_POINT);
         if(point4==0) break;
         bid4=MathRound(MarketInfo(Symbol(),MODE_BID)/point4);
         open4=MathRound(OrderOpenPrice()/point4);
         if(open4-bid4<Stop4) continue;
         while(!IsTradeAllowed()) Sleep(100);
         if(!OrderClose(OrderTicket(),OrderLots(),bid4*point4,Slippage,Red))
            Print("void CloseAllLossBuy(): OrderType=OP_BUY: OrderClose() error - ",ErrorDescription(GetLastError()));
         else
           {
            ticket=-1;
            if(Strategy==1)
              {
               if(Multipler_Mod==1)
                 {
                  if((AccountBalance()>0) && (AccountBalance()<Balance))
                    {
                     if(Martin_multiplier<(Balance/AccountBalance()))
                        Martin_multiplier=Balance/AccountBalance();
                    }
                 }
               else if(Multipler_Mod==2)
                 {
                  Loss_Point+=open4-bid4;
                  if(Profit_Point!=0)
                     if((Loss_Point/Profit_Point)>=1)
                        Martin_multiplier=Loss_Point/Profit_Point;
                 }
               Lot=Lot*Martin_multiplier;
              }
            else if(Strategy==2)
              {
               Parlay_Count=0;
               Lot=Lot_variable;
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                  Закрыть SELL в убытке                           |
//+------------------------------------------------------------------+
void CloseAllLossSell()
  {
   int Stop5=Loss_Min;
//   int slip=2;
   double ask5,open5;
   double point5;
   for(int i5=OrdersTotal()-1; i5>=0; i5--)
     {
      if(!OrderSelect(i5,SELECT_BY_POS,MODE_TRADES)) break;
      if(OrderType()==OP_SELL)
        {
         point5=MarketInfo(Symbol(),MODE_POINT);
         if(point5==0) break;
         ask5=MathRound(MarketInfo(Symbol(),MODE_ASK)/point5);
         open5=MathRound(OrderOpenPrice()/point5);
         if(ask5-open5<Stop5) continue;
         while(!IsTradeAllowed()) Sleep(100);
         if(!OrderClose(OrderTicket(),OrderLots(),ask5*point5,Slippage,Red))
            Print("void CloseAllLossSell(): OrderType=OP_SELL: OrderClose() error - ",ErrorDescription(GetLastError()));
         else
           {
            ticket=-1;
            if(Strategy==1)
              {
               if(Multipler_Mod==1)
                 {
                  if((AccountBalance()>0) && (AccountBalance()<Balance))
                    {
                     if(Martin_multiplier<(Balance/AccountBalance()))
                        Martin_multiplier=Balance/AccountBalance();
                    }
                 }
               else if(Multipler_Mod==2)
                 {
                  Loss_Point+=ask5-open5;
                  if(Profit_Point!=0)
                     if((Loss_Point/Profit_Point)>=1)
                        Martin_multiplier=Loss_Point/Profit_Point;
                 }
               Lot=Lot*Martin_multiplier;
              }
            else if(Strategy==2)
              {
               Parlay_Count=0;
               Lot=Lot_variable;
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
