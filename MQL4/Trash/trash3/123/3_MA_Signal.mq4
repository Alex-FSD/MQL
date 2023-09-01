//+------------------------------------------------------------------+
//|                                                  3_MA_Signal.mq4 |
//|                                                      TO StatBars |
//|                                            http://tradexperts.ru |
//+------------------------------------------------------------------+
#property copyright "TO StatBars"
#property link      "http://tradexperts.ru"

extern int Exit_Signal_MA_Summ = 2; // параметр не должен быть больше 3-х

extern int MA_1_Period = 21 ;
extern int MA_1_Method = 2 ;
extern int MA_1_Price = PRICE_MEDIAN ;

extern int MA_2_Period = 55 ;
extern int MA_2_Method = 2 ;
extern int MA_2_Price = PRICE_MEDIAN ;

extern int MA_3_Period = 144 ;
extern int MA_3_Method = 2 ;
extern int MA_3_Price = PRICE_MEDIAN ;

extern int TP = 1500;
extern int SL = 1500;
extern double lot = 0.1;
extern int Magic_Number = 6312651;

int init(){ return(0); }

int deinit(){ return(0); }

int start()
{
   double MA_1_1 = iMA( NULL, 0, MA_1_Period, 0, MA_1_Method, MA_1_Price, 1);
   double MA_1_2 = iMA( NULL, 0, MA_1_Period, 0, MA_1_Method, MA_1_Price, 2);
   
   double MA_2_1 = iMA( NULL, 0, MA_2_Period, 0, MA_2_Method, MA_2_Price, 1);
   double MA_2_2 = iMA( NULL, 0, MA_2_Period, 0, MA_2_Method, MA_2_Price, 2);
   
   double MA_3_1 = iMA( NULL, 0, MA_3_Period, 0, MA_3_Method, MA_3_Price, 1);
   double MA_3_2 = iMA( NULL, 0, MA_3_Period, 0, MA_3_Method, MA_3_Price, 2);
   int close_sig = 0;
   if( MA_1_1 > MA_1_2 && MA_2_1 > MA_2_2 && MA_3_1 > MA_3_2 )
   {
      // все 3 машки возрастают, покупаем
      if( Orders_Total_by_type( OP_BUY, Magic_Number, Symbol()) == 0)
      {
         OrderSend( Symbol(), OP_BUY , lot, Ask, 5*Point, Bid - SL*Point, Bid + TP*Point, "tradexperts.ru", Magic_Number,0, Aqua);
      }
   }
   if( MA_1_1 < MA_1_2 && MA_2_1 < MA_2_2 && MA_3_1 < MA_3_2 )
   {
      // ¬се 3 машки убывают продаЄм
      if( Orders_Total_by_type( OP_SELL, Magic_Number, Symbol()) == 0)
      {
         OrderSend( Symbol(), OP_SELL, lot, Bid, 5*Point, Ask + SL*Point, Ask - TP*Point, "tradexperts.ru", Magic_Number,0, Magenta);
      }
   }
   
   if( Exit_Signal_MA_Summ == 1 )
   {
      if( Orders_Total_by_type( OP_BUY, Magic_Number, Symbol()) != 0 )
      {
         // ≈сли хот€бы один из мувингов убывает закрываем ордер
         if( MA_1_1 < MA_1_2 || MA_2_1 < MA_2_2 || MA_3_1 < MA_3_2 )
            CloseOrder_by_type( OP_BUY, Magic_Number, Symbol());
      }
      if( Orders_Total_by_type( OP_SELL, Magic_Number, Symbol()) != 0 )
      {
         // ≈сли хот€бы один из мувингов убывает закрываем ордер
         if( MA_1_1 > MA_1_2 || MA_2_1 > MA_2_2 || MA_3_1 > MA_3_2 )
            CloseOrder_by_type( OP_SELL, Magic_Number, Symbol());
      }
   }
   else
   if( Exit_Signal_MA_Summ == 2 )
   {
      if( Orders_Total_by_type( OP_BUY, Magic_Number, Symbol()) != 0 )
      {
         // каждое из правил при выполнении даЄт единичку иначе 0
         close_sig = (MA_1_1 < MA_1_2) + (MA_2_1 < MA_2_2) + (MA_3_1 < MA_3_2) ; 
         // “.о. если хот€бы 2 мувинга убывают то сигнал будет 2 и больше
         if( close_sig >= 2 )
            CloseOrder_by_type( OP_BUY, Magic_Number, Symbol());
      }
      if( Orders_Total_by_type( OP_SELL, Magic_Number, Symbol()) != 0 )
      {
         // каждое из правил при выполнении даЄт единичку иначе 0
         close_sig = (MA_1_1 > MA_1_2) + (MA_2_1 > MA_2_2) + (MA_3_1 > MA_3_2) ; 
         // “.о. если хот€бы 2 мувинга возрастают то сигнал будет 2 и больше
         if( close_sig >= 2 )
            CloseOrder_by_type( OP_SELL, Magic_Number, Symbol());
      }
   }
   else
   if( Exit_Signal_MA_Summ == 3 )
   {
      if( MA_1_1 < MA_1_2 && MA_2_1 < MA_2_2 && MA_3_1 < MA_3_2 )
         CloseOrder_by_type( OP_BUY, Magic_Number, Symbol());
      if( MA_1_1 > MA_1_2 && MA_2_1 > MA_2_2 && MA_3_1 > MA_3_2 )
         CloseOrder_by_type( OP_SELL, Magic_Number, Symbol());
   }
   return(0);
}
//+------------------------------------------------------------------+

//---- ¬озвращает количество ордеров указанного типа ордеров ----//
int Orders_Total_by_type(int type, int mn, string sym)
{
   int num_orders=0;
   for(int i= OrdersTotal()-1;i>=0;i--)
   {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if( OrderMagicNumber() == mn && type == OrderType()
       && sym == OrderSymbol() && OrderComment() != "1" )
         num_orders++;
   }
   return(num_orders);
}

//---- «акрытие ордера по типу ----//
void CloseOrder_by_type( int type, int mn, string sym)
{
   for(int i= OrdersTotal()-1;i>=0;i--)
   {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderMagicNumber() == mn && sym==OrderSymbol() && OrderType() == type)
         if(OrderType()<=1)close(OrderTicket());
         else OrderDelete(OrderTicket());
   }
}

void close(int ticket)
{
   bool isClosed = false;
   int try = 0;
   
   if(OrderType()==0)
   isClosed = OrderClose(ticket, OrderLots(),OrderClosePrice(), 3, Black); 
   
   if(OrderType()==1)
   isClosed = OrderClose(ticket, OrderLots(),OrderClosePrice(), 3, Black); 
   
   while(!isClosed) 
   {
      Sleep(1000);
      try++;
      
      if(OrderType()==0)
      isClosed = OrderClose(ticket, OrderLots(),OrderClosePrice(), 3, Black); 
      
      if(OrderType()==1)
      isClosed = OrderClose(ticket, OrderLots(),OrderClosePrice(), 3, Black); 
      
      if(try > 3 || isClosed) break;
   }
   if(!isClosed) Print("Order ", ticket, " was NOT closed due to error:", GetLastError());
   return (isClosed);
}