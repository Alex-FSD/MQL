//+------------------------------------------------------------------+
//|                                                   Pyramiding.mq4 |
//|                                  Copyright 2020, Trade Like A Pro|
//|                                                  https://tlap.com|
//+------------------------------------------------------------------+
#property copyright "Trade Like A Pro"
#property link      "https://tlap.com"
#property strict

// перечисление, используемое в параметрах для определения типа прогрессии
enum  progr
  {
   mlNone,             // отключено
   mlArithmetical,     // арифметическая
   mlGeometric         // геометрическая
  };


// структура для хранения информации об открытых советником ордерах
struct state
  {
   double            BuyTopPrice;         // цена открытия самого верхнего ордера Buy
   double            SellBottomPrice;     // цена открытия самого нижнего ордера Sell

   double            BuyTopSL;            // стоплосс самого верхнего ордера Buy
   double            BuyBottomSL;         // стоплосс самого нижнего ордера Buy
   double            SellTopSL;           // стоплосс самого верхнего ордера Sell
   double            SellBottomSL;        // стоплосс самого нижнего ордера Sell

   datetime          BuyStopStart;        // время установки пирамиды (открытия самого первого ордера Buy Stop в сетке)
   datetime          SellStopStart;       // время установки пирамиды (открытия самого первого ордера Sell Stop в сетке)

   int               BuyCount;            // количество ордеров Buy
   int               SellCount;           // количество ордеров Sell

   int               BuyStopCount;        // количество ордеров Buy Stop
   int               SellStopCount;       // количество ордеров Sell Stop
  };

sinput string  section01              = "============ Money Management ============";//·
input  double  Lots                   = 0.01;                                        // Фиксированный/стартовый лот
sinput string  delimiter0102          = NULL;                                        //·
input  progr   LotsMultMode           = mlNone;                                      // Режим увеличения/уменьшения лота(прогрессия) ›››
input  double  LotsMultiplicatorAr    = 0.0;                                         // Разность арифметической прогрессии
input  double  LotsMultiplicatorGm    = 1.5;                                         // Знаменатель геометрической прогрессии
sinput string  section02              = "================= Сигнал =================";//·
input  int     StochasticPeriod       = 5;                                           // Период стохастика
input  int     StochasticSlowing      = 3;                                           // Замедление
input  int     StochasticLevelDn      = 20;                                          // Уровень перепроданности(перекупленности - зеркально)
sinput string  section03              = "======== Общие параметры торговли ========";//·
input  int     DistanceToGrid         = 100;                                         // На каком расстоянии от цены строить сетку
input  int     AfterSignaBarsCount    = 0;                                           // Сколько баров ждать активации сетки(0-до обратного сигнала)
sinput string  delimiter0301          = NULL;                                        //·
input  int     Magic                  = 1100;                                        // Magic Number (идентификатор ордеров)
input  int     Slippage               = 30;                                          // Максимально допустимое проскальзывание
sinput string  section04              = "============ Параметры сетки =============";//·
input  int     OrdersAmount           = 15;                                          // Количество отложенных ордеров в сетке
sinput string  delimiter0401          = NULL;                                        //·
input  int     GridStep               = 300;                                         // Фиксированный/стартовый шаг сетки
input  progr   StepMultMode           = mlNone;                                      // Режим расширения/уменьшения шага(прогрессия) ›››
input  double  StepMultiplicatorAr    = 10.0;                                        // Разность арифметической прогрессии
input  double  StepMultiplicatorGm    = 1.5;                                         // Знаменатель геометрической прогрессии
sinput string  delimiter0402          = NULL;                                        //·
input  double  StopLossRatio          = 1.0;                                         // Отношение Stop Loss к шагу
input  int     TakeProfit             = 300;                                         // Общий тейкпрофит



const int BarsInSeconds=(AfterSignaBarsCount-1)*PeriodSeconds(); // ожидание активации в секундах


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
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
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   state State;

// получаем информацию об открытых советником ордерах и помещаем её в структуру State
   RefreshState(State);

// проверяем, сформировался ли новый бар
   if(IsNewBar())
     {
      // если сформирован новый бар, опрашиваем индикаторы с помощью вызова функции GetSignal()
      // и записываем результат в переменную TradeSignal
      int TradeSignal=GetSignal();

      // на открытии нового бара нет ни отложенных ни рыночных ордеров
      if(State.BuyCount==0 && State.SellCount==0 && State.BuyStopCount==0 && State.SellStopCount==0)
        {
         // если при этом сформирован торговый сигнал, строим пирамиду указанного типа
         if(TradeSignal!=EMPTY)
            BuildPyramid(TradeSignal);
         // выходим, так как дальнейшая обработка не имеет смысла, так как
         // либо никаких ордеров нет вовсе, либо мы только что построили пирамиду
         return;
        }

      // если с момента построения сетки было сформировано больше AfterSignaBarsCount баров,
      // или был сформирован противоположный сигнал, удаляем сетку
      if((State.BuyStopCount>0 && State.BuyCount==0 &&
          ((AfterSignaBarsCount>0 && State.BuyStopStart>0 && iTime(_Symbol,_Period,0)-State.BuyStopStart>=BarsInSeconds) || TradeSignal==OP_SELL))
         ||
         (State.SellStopStart>0 && State.SellCount==0 &&
          ((AfterSignaBarsCount>0 && State.SellStopStart>0 && iTime(_Symbol,_Period,0)-State.SellStopStart>=BarsInSeconds) || TradeSignal==OP_BUY)))
        {
         // удаляем отложенные ордера
         DeletePendingOrders();
         return;
        }
     }

// есть открытые ордера BUY или SELL, значит построена пирамида,
// и какие-то отложенные ордера сработали
   if(State.BuyCount>0 || State.SellCount>0)
     {
      // обновляем общий Stop Loss рыночных ордеров пирамиды, если требуется
      CommonStopLoss(State);
      return;
     }

// сетка ордеров закрылась по общему стоп-лоссу, удаляем оставшиеся отложки
   if((State.BuyStopCount>0 && State.BuyStopCount<OrdersAmount && State.BuyCount==0) ||
      (State.SellStopCount>0 && State.SellStopCount<OrdersAmount && State.SellCount==0))
     {
      // удаляем отложенные ордера
      DeletePendingOrders();
     }
  }

//+------------------------------------------------------------------+
//| Функция возвращает:                                              |
//| OP_BUY (сигнал на покупку), если стохастик входит в зону         |
//| перепроданности (пересекает нижний сигнальный уровень            |
//| сверху вниз)                                                     |
//| OP_SELL (сигнал на продажу), если стохастик входит в зону        |
//| перекупленности (пересекает верхний сигнальный уровень           |
//| снизу вверх)                                                     |
//| EMPTY - сигнала нет                                              |
//+------------------------------------------------------------------+
int GetSignal()
  {
// получаем значение стохастика на баре с индексом 1
   double StochasticOnFirstBar=iStochastic(_Symbol,_Period,StochasticPeriod,1,StochasticSlowing,MODE_SMA,0,MODE_MAIN,1);

// стохастик пересекает нижний сигнальный уровень сверху вниз
   if(StochasticOnFirstBar<StochasticLevelDn)
     {
      // для экономии ресурсов получаем значение стохастика на баре с индексом 2 только после того,
      // как убедились, что первая часть условия выполняется
      if(iStochastic(_Symbol,_Period,StochasticPeriod,1,StochasticSlowing,MODE_SMA,0,MODE_MAIN,2)>StochasticLevelDn)
         return(OP_BUY);
     }
// стохастик пересекает верхний сигнальный уровень снизу вверх
   if(StochasticOnFirstBar>100-StochasticLevelDn)
     {
      // для экономии ресурсов получаем значение стохастика на баре с индексом 2 только после того,
      // как убедились, что первая часть условия выполняется
      if(iStochastic(_Symbol,_Period,StochasticPeriod,1,StochasticSlowing,MODE_SMA,0,MODE_MAIN,2)<100-StochasticLevelDn)
         return(OP_SELL);
     }

// в любом другом случае возвращаем EMPTY
   return(EMPTY);
  }

//+------------------------------------------------------------------+
//| Строит пирамиду из отложенных ордеров                            |
//| Buy Stop, если параметр signal равен OP_BUY                      |
//| Sell Stop, если параметр signal равен OP_SELL                    |
//| на расстоянии DistanceToGrid от текущей цены                     |
//+------------------------------------------------------------------+
void BuildPyramid(int signal)
  {
// определяем корректную величину Stop Level
   int StopLevel=GetTrueStopLevel();

// если расстояние, на котором предполагается строить пирамиду меньше Stop Level,
// то устанавливаем его значение, равным Stop Level
   int Distance=(DistanceToGrid<StopLevel)?StopLevel:DistanceToGrid;
   int Com;//тип отложенного ордера


// проверим корректность лотов перед установкой сетки
   if((Lots<SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN)) ||
      (Lots>SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX)))
     {
      Print("Некорректное значение стартового торгового объёма, пирамида не будет построена");
      return;
     }

   if(LotsMultMode>mlNone)
     {
      double LastOrderLots=NormalizeDouble(GetProgressionMember(LotsMultMode,OrdersAmount-1,((LotsMultMode==mlArithmetical)?LotsMultiplicatorAr:LotsMultiplicatorGm),Lots),2);
      if((LastOrderLots<SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN)) ||
         (LastOrderLots>SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX)))
        {
         Print("Обнаружены некорректные значения торгового объёма, пирамида не будет построена");
         return;
        }
     }

// проверим корректность шага перед выставлением последнего ордера пирамиды
   if((GridStep<StopLevel)  ||
      (StepMultMode>mlNone &&
       (int)GetProgressionMember(StepMultMode,OrdersAmount-1,((StepMultMode==mlArithmetical)?StepMultiplicatorAr:StepMultiplicatorGm),GridStep)<StopLevel))
     {
      Print("Обнаружены некорректные значения шага, пирамида не будет построена");
      return;
     }

// проверим корректность Stop Loss
   if((int(StopLossRatio*GridStep)<StopLevel) ||
      (StepMultMode>mlNone &&
       int(StopLossRatio*GetProgressionMember(StepMultMode,OrdersAmount-1,((StepMultMode==mlArithmetical)?StepMultiplicatorAr:StepMultiplicatorGm),GridStep))<StopLevel))
     {
      Print("Обнаружены некорректные значения Stop Loss, пирамида не будет построена");
      return;
     }

// проверим корректность Take Profit
   if(TakeProfit>0 && TakeProfit<StopLevel)
     {
      Print("Общий Take Profit ",TakeProfit," меньше минимально допустимого значения ", StopLevel,", пирамида не будет построена");
      return;
     }

   double Price, Sign, Step=GridStep;

   MqlTick tick;
   if(!SymbolInfoTick(_Symbol,tick))
      return;

// определяем стартовую цену и тип отложенных ордеров
   if(signal==OP_BUY)
     {
      Price=tick.ask;
      Sign=1.0;
      Com=OP_BUYSTOP;
     }
   else
      if(signal==OP_SELL)
        {
         Price=tick.bid;
         Sign=-1.0;
         Com=OP_SELLSTOP;
        }
      else
         return;

// ордера Buy Stop выставляются выше от цены, а Sell Stop - ниже
   Price+=Sign*Distance*_Point;

   for(int i=0; i<OrdersAmount; i++)
     {
      // вычисляем лот для очередного ордера сетки
      double TradeLots;
      // увеличиваем или уменьшаем текущий лот в зависимости от типа прогрессии
      if(LotsMultMode>mlNone)
         TradeLots=GetProgressionMember(LotsMultMode,i,((LotsMultMode==mlArithmetical)?LotsMultiplicatorAr:LotsMultiplicatorGm),Lots);
      else
         TradeLots=Lots;

      double StopLoss,StopLossInPoints;
      // вычисляем StopLoss пропорционально шагу Step
      StopLossInPoints=StopLossRatio*Step;

      // Stop Loss для ордеров Buy Stop располагается ниже цены открытия, для Sell Stop - выше
      StopLoss=Price+EMPTY*Sign*StopLossInPoints*_Point;

      // пять попыток выставить очередной ордер пирамиды
      for(int j=0; j<5; j++)
        {
         if(OrderSend(_Symbol,Com,NormalizeDouble(TradeLots,2),NormalizeDouble(Price,_Digits),Slippage,NormalizeDouble(StopLoss,_Digits),0,NULL,Magic,0,OrderColor(Com))!=EMPTY)
            break;
         else
            Sleep(1000);
        }

      // увеличиваем или уменьшаем текущий шаг в зависимости от типа прогрессии
      if(StepMultMode>mlNone)
         Step=GetProgressionMember(StepMultMode,i,((StepMultMode==mlArithmetical)?StepMultiplicatorAr:StepMultiplicatorGm),GridStep);

      // ордера Buy Stop выставляются выше от цены, а Sell Stop - ниже
      Price+=Sign*Step*_Point;

     }
// устанавливаем общий тейкпрофит только что выставленным отложенным ордерам
   if(TakeProfit>0)
     {
      double tp=NormalizeDouble(Price+Sign*(TakeProfit<StopLevel?StopLevel:TakeProfit)*_Point,_Digits);

      for(int i=OrdersTotal()-1; i>=0; i--)
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderMagicNumber()==Magic && OrderSymbol()==_Symbol && OrderType()>OP_SELL)
           {
            if(NormalizeDouble(OrderTakeProfit(),_Digits)!=tp)
              {
               for(int j=0; j<5; j++)
                  if(OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),tp,0))
                     break;
                  else
                     Sleep(1000);
              }
           }
     }
  }

//+------------------------------------------------------------------+
//| Обновляет общий стоплосс рыночных ордеров пирамиды, то есть      |
//| устанавливает стоплоссы всех рыночных ордеров на один уровень    |
//+------------------------------------------------------------------+
void CommonStopLoss(state &Orders)
  {
   int type;
   bool refresh;
   double sl;

// из рыночных ордеров имеются только Buy, значит изначально была выставлена пирамида отложенных Buy Stop ордеров
   if(Orders.BuyCount>0 && Orders.SellCount==0)
     {
      type=OP_BUY;
      // стоплосс самого верхнего ордера Buy не совпадает со стоплосс самого нижнего, значит необходимо
      // установить всем ордерам стоплосс самого верхнего, иными словами, "подтянуть" в безубыток
      refresh=(NormalizeDouble(Orders.BuyTopSL,_Digits)!=NormalizeDouble(Orders.BuyBottomSL,_Digits));
      sl=NormalizeDouble(Orders.BuyTopSL,_Digits);
     }
   else
      // из рыночных ордеров имеются только Sell, значит изначально была выставлена пирамида отложенных Sell Stop ордеров
      if(Orders.BuyCount==0 && Orders.SellCount>0)
        {
         type=OP_SELL;
         // стоплосс самого верхнего ордера Sell не совпадает со стоплосс самого нижнего, значит необходимо
         // установить всем ордерам стоплосс самого нижнего, иными словами, "подтянуть" в безубыток
         refresh=(NormalizeDouble(Orders.SellTopSL,_Digits)!=NormalizeDouble(Orders.SellBottomSL,_Digits));
         sl=NormalizeDouble(Orders.SellBottomSL,_Digits);
        }
      else
         return;

   if(refresh)
      for(int i=OrdersTotal()-1; i>=0; i--)
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderMagicNumber()==Magic && OrderSymbol()==_Symbol && OrderType()==type)
           {
            if(NormalizeDouble(OrderStopLoss(),_Digits)!=sl)
              {
               for(int j=0; j<5; j++)
                  if(OrderModify(OrderTicket(),OrderOpenPrice(),sl,OrderTakeProfit(),0))
                     break;
                  else
                     Sleep(1000);
              }
           }
  }

//+------------------------------------------------------------------+
//| Обновляет информацию об открытых ордерах и заполняет ею          |
//| элементы структуры Orders                                        |
//+------------------------------------------------------------------+
void RefreshState(state &Orders)
  {
   bool flagIncorrect;
   do
     {
      flagIncorrect=false;
      ZeroMemory(Orders); //обнуляем все элементы структуры
      for(int i=OrdersTotal()-1; i>=0; i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
            if(OrderSymbol()==_Symbol && OrderMagicNumber()==Magic)
              {
               double op,sl;
               switch(OrderType())
                 {
                  case OP_BUY:
                     Orders.BuyCount++;
                     op=OrderOpenPrice();
                     sl=OrderStopLoss();

                     // определяем стоплосс самого верхнего ордера Buy
                     if(Orders.BuyTopPrice<op)
                       {
                        Orders.BuyTopPrice=op;
                        Orders.BuyTopSL=OrderStopLoss();
                       }

                     // определяем стоплосс самого нижнего ордера Buy
                     if(Orders.BuyBottomSL==0 || Orders.BuyBottomSL>sl)
                        Orders.BuyBottomSL=sl;

                     break;

                  case OP_SELL:
                     Orders.SellCount++;
                     op=OrderOpenPrice();
                     sl=OrderStopLoss();

                     // определяем стоплосс самого нижнего ордера Sell
                     if(Orders.SellBottomPrice==0 || Orders.SellBottomPrice>op)
                       {
                        Orders.SellBottomPrice=op;
                        Orders.SellBottomSL=OrderStopLoss();
                       }

                     // определяем стоплосс самого верхнего ордера Sell
                     if(Orders.SellTopSL<sl)
                        Orders.SellTopSL=sl;
                     break;

                  case OP_BUYSTOP:
                     Orders.BuyStopCount++;
                     if(OrderOpenTime()<Orders.BuyStopStart || Orders.BuyStopStart==0)
                        Orders.BuyStopStart=OrderOpenTime();// находим время открытия самого первого ордера buy stop
                     break;

                  case OP_SELLSTOP:
                     Orders.SellStopCount++;
                     if(OrderOpenTime()<Orders.SellStopStart || Orders.SellStopStart==0)
                        Orders.SellStopStart=OrderOpenTime();// находим время открытия самого первого ордера sell stop
                     break;
                 }
              }

         // что-то пошло не так, есть разнонаправленные ордера, удалим и закроем все
         if((Orders.BuyCount>0 || Orders.BuyStopCount>0) && (Orders.SellCount>0 || Orders.SellStopCount>0))
           {
            if(Orders.BuyCount>0 || Orders.SellCount>0)
               CloseOrders();
            if(Orders.BuyStopCount>0 || Orders.SellStopCount>0)
               DeletePendingOrders();
            Sleep(1000);
            // надо сделать еще одну итерацию цикла do...while, вдруг у нас остались неудалённые и незакрытые ордера
            flagIncorrect=true;
            break;// выход из цикла for
           }
        }
     }
   while(flagIncorrect && !IsStopped());

  }

//+------------------------------------------------------------------+
//| Возвращает n-ый член арифметической или геометрической прогрессии|
//|                                                                  |
//| mode          - тип прогрессии: арифметическая или геометрическая|
//| n             - порядковый номер члена прогрессии                |
//| multiplicator - разность/знаменатель прогрессии                  |
//| initial       - первый член прогрессии                           |
//+------------------------------------------------------------------+
double GetProgressionMember(progr mode,int n,double multiplicator,double initial)
  {
   switch(mode)
     {
      case mlArithmetical: // арифметическая прогрессия
         return(initial+((multiplicator>0 || multiplicator<0)?multiplicator:initial)*n);
         break;
      case mlGeometric: // геометрическая прогрессия
         return(initial*MathPow(multiplicator,n));
         break;
      default:
         return(initial);
         break;
     }
  }


//+------------------------------------------------------------------+
//| Удаляет все отложенные ордера типа type открытые по текущему     |
//| символу, имеющих "магический номер" magic                        |
//+------------------------------------------------------------------+
void DeletePendingOrders(int type=EMPTY, int magic=EMPTY)
  {
   for(int i=OrdersTotal()-1; i>=0; i--)
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol()==_Symbol)
            if((OrderType()>OP_SELL && type==EMPTY) || (type>OP_SELL && OrderType()==type))
               if(magic==EMPTY || (magic!=EMPTY && OrderMagicNumber()==magic))
                  for(int j=0; j<5; j++)
                    {
                     if(OrderDelete(OrderTicket()))
                        break;
                     Sleep(1000);
                    }
  }
//+------------------------------------------------------------------+
//| Закрывает все рыночные ордера, открытые по текущему символу,     |
//| имеющие тип type и "магический номер" magic                      |
//+------------------------------------------------------------------+
void CloseOrders(int type=EMPTY, int magic=EMPTY)
  {
   for(int i=OrdersTotal()-1; i>=0; i--)
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         if((OrderType()==type || type<0) && (magic==EMPTY || (magic!=EMPTY && OrderMagicNumber()==magic)))
            if(OrderSymbol()==_Symbol)
               ClosePosBySelect();
  }
//+------------------------------------------------------------------+
//| Закрывает выбранный ордер                                        |
//+------------------------------------------------------------------+
void ClosePosBySelect()
  {
   int ordType=OrderType();
   if(ordType<OP_BUYLIMIT)
      //for(int i=0; i<3; i++)
      while(!IsStopped())
        {
         if(!IsTesting() && !IsExpertEnabled())
            break;
         while(!IsTradeAllowed())
            Sleep(5000);
         RefreshRates();
         //double ordProfit=OrderProfit()+OrderCommission()+OrderSwap();
         ResetLastError();
         if(OrderClose(OrderTicket(),OrderLots(),((ordType==OP_BUY)?Bid:Ask),Slippage,((ordType==OP_BUY)?clrBlue:clrRed)))
            break;
         else
            if(GetLastError()==146)
               while(IsTradeContextBusy())
                  Sleep(11000);
            else
               Sleep(5000);
        }
   else
      Print("Некорректная торговая операция");
  }

//+------------------------------------------------------------------+
//| Возвращает корректный Stop Level                                 |
//+------------------------------------------------------------------+
int GetTrueStopLevel()
  {
   int StopLevel=int(MathMax(MarketInfo(_Symbol,MODE_STOPLEVEL),SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL))+
                     SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE)/_Point);

   if(StopLevel==0)
     {
      MqlTick tick;
      StopLevel=int(((SymbolInfoTick(_Symbol,tick) && tick.bid>0 && tick.ask>0)?tick.ask-tick.bid:Ask-Bid)/_Point)*2;
     }
   return(StopLevel);
  }

//+------------------------------------------------------------------+
//| Новый бар на на текущем таймфрейме                               |
//+------------------------------------------------------------------+
bool IsNewBar()
  {
   static datetime last_bar=0;
   datetime null_bar=iTime(_Symbol,_Period,0);
   if(last_bar!=null_bar)
     {
      last_bar=null_bar;
      return(true);
     }
   return(false);
  }

//+------------------------------------------------------------------+
//| Возвращает цвет в зависимости от типа ордера                     |
//+------------------------------------------------------------------+
color OrderColor(int cmd,color buy=clrBlue,color sell=clrRed)
  {
   return(cmd%2==0?buy:sell);
  }

//+------------------------------------------------------------------+
