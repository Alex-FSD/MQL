//---- Входные параметры---------------
extern string Long="Параметры длинных позиций";
extern int    PeriodMA1=20;
extern int    Час_Открытия1 = 16;
extern int    Час_Закрытия1 = 8;
extern string Short="Параметры коротких позиций";
extern int    PeriodMA2=20;
extern int    Час_Открытия2 = 6;
extern int    Час_Закрытия2 = 13;
extern string ТР="Выставляем ТР в процентах от цены";
extern double Процент_TP=0.6; 
extern string профит="закрываем позицию пересечение МА выше/ниже открытия на ... пунктов";
extern int    ProfitPips=35;
extern string трэнд="Настройка трэнда";
extern int    Period_MA=200;
extern int    n_MA=2;
extern string lot="Настройка величины лота";
extern double Lots=0.01;
extern string ММ="Настройка управления капиталлом";
extern double Loss = 0.02;    // Величина убытка в процентах на одну сделку
extern int    режимММ=0; //выбор режима 0-нет ММ 1-убыток % от капиталла 2- величина позиции % от баланса
extern string x1="Для дилинговых центров с 5 знаками x умножить на 10";
extern int    x=10;
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
static datetime    dt;
static bool   permission_long = true, permission_short = true; // разрешение длинных и коротких позиций
int start()
  {
  double a;// переменные а-убыток в пипсах
  int n=1; // Задает диапазон в часах на открытие
  int total,cnt;
  int TP=0;
  int magik_Buy=13;
  int magik_Sell=14;
  int кол_дл=0, кол_кор=0;
  double MA11=iMA(NULL,0,PeriodMA1,0,MODE_SMA,PRICE_MEDIAN,1);
  double MA12=iMA(NULL,0,PeriodMA1,0,MODE_SMA,PRICE_MEDIAN,2);
  double MA21=iMA(NULL,0,PeriodMA2,0,MODE_SMA,PRICE_MEDIAN,1);
  double MA22=iMA(NULL,0,PeriodMA2,0,MODE_SMA,PRICE_MEDIAN,2);
  double Medium1=iMA(NULL,0,1,0,MODE_SMA,PRICE_MEDIAN,1);
  double Medium2=iMA(NULL,0,1,0,MODE_SMA,PRICE_MEDIAN,2);
  double MA_Long1=iMA(NULL,0,Period_MA,0,MODE_EMA,PRICE_MEDIAN,1);
  double MA_Long_n=iMA(NULL,0,Period_MA,0,MODE_EMA,PRICE_MEDIAN,n_MA);
  
  if(dt!=iTime(NULL,PERIOD_D1,0)) // Определяет открытия нового дня 
  {
  permission_long = true;         // Разрешаем открытие длинных позиций на этот день
  permission_short = true;        // Разрешаем открытие коротких позиций на этот день
  dt=iTime(NULL,PERIOD_D1,0);     // Запоминаем время открытия дневной свечи
  }
  total=OrdersTotal();
  for(cnt=0;cnt<total;cnt++)
      {
         OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         if(OrderType()<=OP_SELL &&   // check for opened position 
         OrderSymbol()==Symbol())  // check for symbol
         {
         if(OrderMagicNumber()==magik_Buy) кол_дл=кол_дл+1;
         if(OrderMagicNumber()==magik_Sell) кол_кор=кол_кор+1;
         }
      }
        
     for(cnt=0;cnt<total;cnt++)
      {
         OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         if(OrderType()<=OP_SELL &&   // check for opened position 
         OrderSymbol()==Symbol())  // check for symbol
         {
         // ---------------------Закрытие-------------------------------------------------
         if(OrderType()==OP_BUY && OrderMagicNumber()==magik_Buy)
         {
            if(Hour()==Час_Закрытия1)
            {
               OrderClose(OrderTicket(),OrderLots(),Bid,3*x,Red);
               Sleep(60000); // Задержка в 60 секунд
               return(0);
            }
            if(Medium1>MA11 && Medium2<=MA12 && Bid-OrderOpenPrice()>ProfitPips*x*Point)
            {
               OrderClose(OrderTicket(),OrderLots(),Bid,3*x,Red);
               Sleep(60000); // Задержка в 60 секунд
               return(0);
            }
            
         }
         //-------------------Закрытие----------------------------------------------------  
         if(OrderType()==OP_SELL && OrderMagicNumber()==magik_Sell)
         {
            if(Hour()==Час_Закрытия2)
            {
               OrderClose(OrderTicket(),OrderLots(),Ask,3*x,Red);
               Sleep(60000); // Задержка в 60 секунд
               return(0);
            }
            if(Medium1<MA21 && Medium2>=MA22 && OrderOpenPrice()-Ask>ProfitPips*x*Point)
            {
               OrderClose(OrderTicket(),OrderLots(),Ask,3*x,Red);
               Sleep(60000); // Задержка в 60 секунд
               return(0);
            }
         }               
  
         }
      }
   if((Hour()==Час_Открытия1 || Hour()==Час_Открытия1+n) && permission_long==true && кол_дл<1) // если нет позиций
     {
      // открытие длинной позиции
      if(Medium1>MA11 && MA11>MA12 && MA_Long1>MA_Long_n)
        {
        a=MathAbs(Ask*0.01);
        Lots=ValueLot(a);
        TP=Расчет_TP(Ask,Процент_TP);
        if(buy(TP,magik_Buy,Lots)!=-1) permission_long = false;
        Sleep(60000); // Задержка в 60 секунд
        return(0);
        }
      }
   if((Hour()==Час_Открытия2 || Hour()==Час_Открытия2+n) && permission_short == true && кол_кор<1) // если нет позиций
     {   
      // открытие короткой позиции
      if(Medium1<MA21 && MA21<MA22 && MA_Long1<MA_Long_n)
        {
         a=MathAbs(Bid*0.01);
         Lots=ValueLot(a);
         TP=Расчет_TP(Bid,Процент_TP);
         if(sell(TP,magik_Sell,Lots)!=-1) permission_short = false;
         Sleep(60000); // Задержка в 60 секунд
         return(0);
        }
     }
//---------------------------------------------------------------------------------------   
return(0);
}
double Расчет_TP(double A,double B)
   {
   int x=0;
   double y=A*B/100;
   x=MathRound(y/Point);
   if (x<30*x) x=30*x;
   return(x); 
   }

int sell(int TP, int magik_Sell, double Lot)         //Функция входа в короткую сторону
   {
   int t=-1;
   t=OrderSend(Symbol(),OP_SELL,Lot,Bid,3*x,0,Bid-TP*Point,"order_sell",magik_Sell,0,Red);
   return(t);
   }

int buy(int TP, int magik_Buy, double Lot)           //Функция входа в длинную сторону
   {
   int t=-1;
   t=OrderSend(Symbol(),OP_BUY,Lot,Ask,3*x,0,Ask+TP*Point,"order_buy",magik_Buy,0,Green);
   return(t);
   }
double ValueLot (double A)
   {
   RefreshRates();
   double ticvalue=MarketInfo(Symbol(),MODE_TICKVALUE);
   double minlot=MarketInfo(Symbol(),MODE_MINLOT);   
   double maxlot=MarketInfo(Symbol(),MODE_MAXLOT);
   double standartlot=MarketInfo(Symbol(),MODE_LOTSIZE);
   double x=0;
   if (режимММ==0) x=Lots;
   if(режимММ==1) x=NormalizeDouble(MathFloor((AccountFreeMargin()*Loss*Point)/(ticvalue*A*minlot))*minlot,2);
   if(режимММ==2) x=NormalizeDouble(minlot*((AccountFreeMargin()*Loss)/(1000*minlot)),2);
   if(режимММ==3)
   {
   double bb=MathSqrt(AccountFreeMargin()/1000);
   x=NormalizeDouble(bb*Loss,2);
   }
   if(x>=maxlot) x=maxlot;
   if(x<=minlot) x=minlot;   
   return(x);
   }
  