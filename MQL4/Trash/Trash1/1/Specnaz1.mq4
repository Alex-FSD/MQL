//+------------------------------------------------------------------+
//|                                                      Specnaz 1.0 |
//|                                 Copyright 2017, Sergey Eroshenko |
//|                                      Skype: sergey_eroshenko_nsk |
//+------------------------------------------------------------------+
#property copyright "Sergey Eroshenko"
#property description "Skype: sergey_eroshenko_nsk"

int T=8,ticket,count_sell,count_buy,day_trig=1;
double lots,TP_sell,TP_buy;
double Mas_Sell[100][4],Mas_Buy[100][4];
datetime H;
input double TakeProfit=200;  // Take Profit (pips)
input double risk=1;          // Relative volume
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   lots=MathFloor(AccountBalance()/1000)/(100/risk);
   H=TimeHour(TimeCurrent());

//////////////Блок открытия и корректировки ордеров. Ежедневно во время T ///////////////////////////////

   if(H==T-1 && day_trig==1) day_trig=0; //Триггер нового дня
   if(H==T && day_trig==0)               //Если время Т и новый день наступил открываем Buy и Sell по текущим ценам 
     {
      ticket=OrderSend(Symbol(),OP_SELL,lots,Bid,3,0,0,"",0,0,Red);
      if(ticket>0)
        {
         if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
            Print("SELL order opened : ",OrderOpenPrice());
        }
      else
         Print("Error opening SELL order : ",GetLastError());

      ticket=OrderSend(Symbol(),OP_BUY,lots,Ask,3,0,0,"",0,0,Red);
      if(ticket>0)
        {
         if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
            Print("BUY order opened : ",OrderOpenPrice());
        }
      else
         Print("Error opening SELL order : ",GetLastError());
      Counter();
      TP_calc();
      TP_corr();
      day_trig=1;
     }
//////////////Блок открытия и корректировки ордеров ОКОНЧЕН//////////////////////////////////////////////
  }
//////////////Функция определения количества открытых сделок и их цен, по типам Sell И Buy. Создает два массива 
void Counter()
  {
   count_sell=0;                       // Обнуление счётчика ордеров
   count_buy=0;                        // Обнуление счётчика ордеров
   ArrayInitialize(Mas_Sell,0);        // Обнуление массива Sell
   ArrayInitialize(Mas_Buy,0);         // Обнуление массива Buy

   for(int i=0; i<=OrdersTotal(); i++) // Подсчет ордеров Sell
     {
      if((OrderSelect(i,SELECT_BY_POS)==true)         // Если есть следующ.
         && (OrderType()==OP_SELL))                   // и если ордер Sell
        {
         count_sell++;                                // Колич. ордеров Sell
         Mas_Sell[count_sell][1]=OrderOpenPrice();    // Цена сделки
         Mas_Sell[count_sell][2]=OrderTicket();       // Номер ордера
         Mas_Sell[count_sell][3]=OrderMagicNumber();  // Магическое число 
        }
     }

   for(int j=0; j<=OrdersTotal(); j++) // Подсчет ордеров Buy
     {
      if((OrderSelect(j,SELECT_BY_POS)==true)       // Если есть следующ.
         && (OrderType()==OP_BUY))                  // и если ордер Buy
        {
         count_buy++;                               // Колич. ордеров Buy
         Mas_Buy[count_buy][1]=OrderOpenPrice();    // Цена сделки
         Mas_Buy[count_buy][2]=OrderTicket();       // Номер ордера
         Mas_Buy[count_buy][3]=OrderMagicNumber();  // Магическое число 
        }
     }
  }
//////////////Функция рассчета TakeProfit для сделок Sell и Buy//////////////////////////   
void TP_calc()
  {
   double summ_sell_price,
   summ_buy_price;

   summ_sell_price=0;
   summ_buy_price=0;

   for(int i=0; i<=count_sell; i++) // Суммирование цен Sell
     {
      summ_sell_price=summ_sell_price+Mas_Sell[i][1];
     }

   for(int j=0; j<=count_buy; j++) // Суммирование цен Buy
     {
      summ_buy_price=summ_buy_price+Mas_Buy[j][1];
     }

   TP_sell=summ_sell_price/count_sell-TakeProfit*Point;
   TP_buy=summ_buy_price/count_buy+TakeProfit*Point;
  }
//////////////Функция модификации TakeProfit по всем ордерам/////////////////////////////   
void TP_corr()
  {
   for(int i=0; i<=OrdersTotal(); i++) // Изменение TakeProfit ордеров Sell
     {
      if((OrderSelect(i,SELECT_BY_POS)==true)    // Если есть следующ.
         && (OrderType()==OP_SELL))              // и если ордер Sell
        {
         bool res=OrderModify(OrderTicket(),OrderOpenPrice(),0,TP_sell,0,Blue);
         if(!res)
            Print("Ошибка модификации ордера. Код ошибки=",GetLastError());
        }
     }

   for(int j=0; j<=OrdersTotal(); j++) // Изменение TakeProfit ордеров Buy
     {
      if((OrderSelect(j,SELECT_BY_POS)==true)    // Если есть следующ.
         && (OrderType()==OP_BUY))               // и если ордер Buy
        {
         bool res2=OrderModify(OrderTicket(),OrderOpenPrice(),0,TP_buy,0,Blue);
         if(!res2)
            Print("Ошибка модификации ордера. Код ошибки=",GetLastError());
        }
     }
  }
//+------------------------------------------------------------------+
