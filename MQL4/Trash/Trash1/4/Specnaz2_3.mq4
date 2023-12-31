//+------------------------------------------------------------------+
//|                                                      Specnaz 2.3 |
//|                                 Copyright 2017, Sergey Eroshenko |
//+------------------------------------------------------------------+
#property copyright "Sergey Eroshenko"

int T=8,ticket,count_sell,count_buy,sell_p,buy_p,day_trig=1;
int dop_buy,dop_sell,lock_sell=0,lock_buy=0,trig_u_p_sell=0,trig_u_p_buy=0;
double summ_sell_price,summ_buy_price,TP_unlock_sell=0,TP_unlock_buy=0;
double TP_sell,TP_buy,buy_stop=0,sell_stop=0;
double Mas_Sell[1000][4],Mas_Buy[1000][4];
datetime H;
input double lots=0.01;
input int TakeProfit=200;
input int dly=1000; // Lock level
input int flat=400; // Unlock level

double start_balance=AccountBalance();
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnInit()
  {
   Counter();
   TP_calc();
   Print("Balance = ",start_balance);
   Print("Lots = ",lots);
   Print("Открытых покупок = ",count_buy," , открытых продаж = ",count_sell);
   Print("TP_sell= ",TP_sell," , TP_buy = ",TP_buy);
   if(count_sell==0 && count_buy>0) sell_stop=TP_sell-dly*Point;//Запоминаем цену для замка 
   if(count_buy==0 && count_sell>0) buy_stop=TP_sell+dly*Point;//Запоминаем цену для замка
   Print("sell_stop= ",sell_stop," , buy_stop = ",buy_stop);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   H=TimeHour(TimeCurrent());

//////////////Блок открытия ордеров. Ежедневно во время T ///////////////////////////////
   if(H==T-1 && day_trig==1)
     {
      day_trig=0; //Триггер нового дня
      Counter();
     }

   if(H==T && day_trig==0)//Если время Т и новый день наступил открываем Buy и Sell по текущим ценам 
     {
      ticket=0;
      ticket=OrderSend(Symbol(),OP_SELL,lots,Bid,30,0,0,"",0,0,Red);
      if(ticket>0)
        {
         if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
            Print("SELL order opened : ",OrderOpenPrice());
        }
      else
         Print("Error opening SELL order : ",GetLastError());

      ticket=0;
      ticket=OrderSend(Symbol(),OP_BUY,lots,Ask,30,0,0,"",0,0,Red);
      if(ticket>0)
        {
         if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
            Print("BUY order opened : ",OrderOpenPrice());
        }
      else
         Print("Error opening Buy order : ",GetLastError());

      Counter();
      TP_calc();
      day_trig=1;
      Print("Открытых покупок = ",count_buy," , открытых продаж = ",count_sell);
      Print("TP_sell= ",TP_sell," , TP_buy = ",TP_buy);
     }
//////////////Блок открытия ордеров ОКОНЧЕН//////////////////////////

//////////////Блок закрытия ордеров//////////////////////////////////
   if(count_sell>0 && Ask<=TP_sell && TP_sell>0 && lock_sell==0)
     {
      Cls_Sell();
      sell_stop=TP_sell-dly*Point;//Запоминаем цену для замка
      Print("Закрыта цепочка продаж");
     }

   if(count_buy>0 && Bid>=TP_buy && TP_buy>0 && lock_buy==0)
     {
      Cls_Buy();
      buy_stop=TP_buy+dly*Point;//Запоминаем цену для замка
      Print("Закрыта цепочка покупок");
     }
//////////////Блок закрытия ордерорв ОКОНЧЕН/////////////////////////

//////////////Блок установки замков//////////////////////////////////
   if(Bid<sell_stop && sell_stop!=0 && lock_sell==0)// Открытие продаж по заданной цене
     {
      Balance_sell();
      Print("Balance sell");
      lock_sell=1;
     }
//   
   if(Ask>buy_stop && buy_stop!=0 && lock_buy==0)// Открытие покупок по заданной цене
     {
      Balance_buy();
      Print("Balance buy");
      lock_buy=1;
     }
//////////////Блок установки замков окончен//////////////////////////

//////////////Блок размыкания замков/////////////////////////////////
   if(lock_sell==1 && Bid>TP_buy-flat*Point && trig_u_p_sell==0)//Если стоит замок из продаж и цена вошла в коридор к покупкам 
     {
      Counter();
      TP_calc();
      TP_unlock_sell=TP_sell;//Задаем цену для размыкания замка продаж
      Print("Задана цена размыкания замка продаж = ",TP_unlock_sell);
      trig_u_p_sell=1;
     }
//    
   if(Bid<=TP_unlock_sell && TP_unlock_sell!=0)//Если цена опустилась до уровня размыкания замка продаж
     {
      Cls_Sell();//Закрываем продажи
      TP_unlock_sell=0;//Убираем цену размыкания замка продаж
      lock_sell=0;//Открываем триггер замка продаж
      Print("Разомкнут замок со стороны продаж по цене = ",Bid);
      trig_u_p_sell=0;
      sell_stop=TP_unlock_sell-dly*Point;//Запоминаем цену для замка     
     }
////
   if(lock_buy==1 && Ask<TP_sell+flat*Point && trig_u_p_buy==0)//Если стоит замок из покупок и цена вошла в коридор к продажам 
     {
      Counter();
      TP_calc();
      TP_unlock_buy=TP_buy;//Задаем цену для размыкания замка покупок
      Print("Задана цена размыкания замка покупок = ",TP_unlock_buy);
      trig_u_p_buy=1;
     }
//    
   if(Ask>=TP_unlock_buy && TP_unlock_buy!=0)//Если цена поднялась до уровня размыкания замка покупок
     {
      Cls_Buy();//Закрываем покупки
      TP_unlock_buy=0;//Убираем цену размыкания замка покупок
      lock_buy=0;//Открываем триггер замка покупок
      Print("Разомкнут замок со стороны покупок по цене = ",Ask);
      trig_u_p_buy=0;
      buy_stop=TP_unlock_buy+dly*Point;//Запоминаем цену для замка     
     }
//////////////Блок размыкания замков окончен/////////////////////////////////
  }
//////////////Тело программы окончено/////////////////////////////////

//+------------------------------------------------------------------+
//|Функция определения количества открытых сделок и их цен,          |
//|по типам Sell И Buy. Создает два массива.                         |
//+------------------------------------------------------------------+
void Counter()
  {
   count_sell=0;                       // Обнуление счётчика ордеров
   count_buy=0;                        // Обнуление счётчика ордеров
   ArrayInitialize(Mas_Sell,0);        // Обнуление массива Sell
   ArrayInitialize(Mas_Buy,0);         // Обнуление массива Buy

   for(int i=0; i<=OrdersTotal(); i++) // Подсчет ордеров Sell
     {
      if((OrderSelect(i,SELECT_BY_POS)==true)         //Если есть следующ.
         && (OrderType()==OP_SELL))                      // и если ордер Sell
        {
         count_sell++;                                // Колич. ордеров Sell
         Mas_Sell[count_sell][1]=OrderOpenPrice();    // Цена сделки
         Mas_Sell[count_sell][2]=OrderTicket();       // Номер ордера
         Mas_Sell[count_sell][3]=OrderMagicNumber();  // Магическое число 
        }
     }

   for(int j=0; j<=OrdersTotal(); j++) // Подсчет ордеров Buy
     {
      if((OrderSelect(j,SELECT_BY_POS)==true)       //Если есть следующ.
         && (OrderType()==OP_BUY))                     // и если ордер Buy
        {
         count_buy++;                               // Колич. ордеров Buy
         Mas_Buy[count_buy][1]=OrderOpenPrice();    // Цена сделки
         Mas_Buy[count_buy][2]=OrderTicket();       // Номер ордера
         Mas_Buy[count_buy][3]=OrderMagicNumber();  // Магическое число 
        }
     }
  }
//+------------------------------------------------------------------+
//|Функция рассчета TakeProfit для сделок Sell и Buy                 |
//+------------------------------------------------------------------+
void TP_calc()
  {
   summ_sell_price=0;
   summ_buy_price=0;
   TP_sell=0;
   TP_buy=0;

   if(count_sell>0)
     {
      for(int i=0; i<=count_sell; i++) // Суммирование цен Sell
        {
         summ_sell_price=summ_sell_price+Mas_Sell[i][1];
        }
      TP_sell=summ_sell_price/count_sell-TakeProfit*Point;
     }

   if(count_buy>0)
     {
      for(int j=0; j<=count_buy; j++) // Суммирование цен Buy
        {
         summ_buy_price=summ_buy_price+Mas_Buy[j][1];
        }

      TP_buy=summ_buy_price/count_buy+TakeProfit*Point;
     }
  }
//+------------------------------------------------------------------+
//|Функция модификации TakeProfit по всем ордерам                    |
//+------------------------------------------------------------------+
void TP_corr()
  {
   for(int i=0; i<=OrdersTotal(); i++) // Изменение TakeProfit ордеров Sell
     {
      if((OrderSelect(i,SELECT_BY_POS)==true) //Если есть следующ.
         && (OrderTakeProfit()!=TP_sell)
         && (OrderType()==OP_SELL)) // и если ордер Sell
        {
         if(TP_sell<Ask)
           {
            bool res=OrderModify(OrderTicket(),OrderOpenPrice(),0,TP_sell,0,Blue);
            if(!res) Print("Ошибка модификации SELL. Код ошибки=",GetLastError());
           }
         if(TP_sell>Ask)
           {
            res=OrderModify(OrderTicket(),OrderOpenPrice(),TP_sell,0,0,Blue);
            if(!res) Print("Ошибка модификации SELL. Код ошибки=",GetLastError());
           }
        }
     }

   for(int j=0; j<=OrdersTotal(); j++) // Изменение TakeProfit ордеров Buy
     {
      if((OrderSelect(j,SELECT_BY_POS)==true) //Если есть следующ.
         && (OrderTakeProfit()!=TP_buy)
         && (OrderType()==OP_BUY)) // и если ордер Buy
        {
         if(TP_buy>Bid)
           {
            bool res2=OrderModify(OrderTicket(),OrderOpenPrice(),0,TP_buy,0,Blue);
            if(!res2) Print("Ошибка модификации BUY. Код ошибки=",GetLastError());
           }
         if(TP_buy<Bid)
           {
            res2=OrderModify(OrderTicket(),OrderOpenPrice(),TP_buy,0,0,Blue);
            if(!res2) Print("Ошибка модификации BUY. Код ошибки=",GetLastError());
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|Функция закрытия всех открытых Sell                               |
//+------------------------------------------------------------------+
void Cls_Sell()
  {
   Counter();
   for(int i=0; i<=count_sell; i++) //
     {
      ticket=Mas_Sell[i][2];
      if(OrderSelect(ticket,SELECT_BY_TICKET)==true) //Если есть следующ.
        {
         bool res=OrderClose(ticket,OrderLots(),Ask,50,Blue);
        }
     }
  }
//+------------------------------------------------------------------+
//|Функция закрытия всех открытых Buy                                |
//+------------------------------------------------------------------+
void Cls_Buy()
  {
   Counter();
   for(int i=0; i<=count_buy; i++) //
     {
      ticket=Mas_Buy[i][2];
      if(OrderSelect(ticket,SELECT_BY_TICKET)==true) //Если есть следующ.
        {
         bool res=OrderClose(ticket,OrderLots(),Bid,50,Blue);
        }
     }
  }
//+------------------------------------------------------------------+
//|Функция открытия балансирующей цепочки продаж                     |
//+------------------------------------------------------------------+
void Balance_sell()
  {
   Counter();
   buy_p=count_buy-count_sell;

   for(int i=1; i<=(buy_p); i++)
     {
      ticket=0;
      ticket=OrderSend(Symbol(),OP_SELL,lots,Bid,30,0,0,"",0,0,Red);
      if(ticket>0)
        {
         if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
            Print("SELL order opened : ",OrderOpenPrice());
        }
      else
         Print("Error opening SELL order : ",GetLastError());
     }
  }
//+------------------------------------------------------------------+
//|Функция открытия балансирующей цепочки покупок                    |
//+------------------------------------------------------------------+
void Balance_buy()
  {
   Counter();
   sell_p=count_sell-count_buy;

   for(int j=1; j<=(sell_p); j++)
     {
      ticket=0;
      ticket=OrderSend(Symbol(),OP_BUY,lots,Ask,30,0,0,"",0,0,Red);
      if(ticket>0)
        {
         if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
            Print("BUY order opened : ",OrderOpenPrice());
        }
      else
         Print("Error opening BUY order : ",GetLastError());
     }
  }
//+------------------------------------------------------------------+
//|функция открытия доп ордеров                                      |
//+------------------------------------------------------------------+
void Open_dop()
  {
   TP_calc();
   if(Bid<summ_sell_price/count_sell-TakeProfit*Point)
     {
      ticket=OrderSend(Symbol(),OP_SELL,lots,Bid,30,TP_buy,Bid-TakeProfit*Point,"",0,0,Red);
      if(ticket>0)
        {
         if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
            Print("Открыта дополнительная продажа ",OrderOpenPrice());
         dop_buy=1;
        }
      else
         Print("Error opening SELL order : ",GetLastError());
     }

   if(Ask>summ_buy_price/count_buy+TakeProfit*Point)
     {
      ticket=OrderSend(Symbol(),OP_BUY,lots,Ask,30,TP_sell,Ask+TakeProfit*Point,"",0,0,Red);
      if(ticket>0)
        {
         if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
            Print("Открыта дополнительная покупка ",OrderOpenPrice());
         dop_sell=1;
        }
      else
         Print("Error opening Buy order : ",GetLastError());
     }
  }
//+------------------------------------------------------------------+
