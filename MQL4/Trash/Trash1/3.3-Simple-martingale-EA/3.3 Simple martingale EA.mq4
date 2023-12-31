//+------------------------------------------------------------------+
//|                                         3.4 Simple martingale EA |
//|                                   Copyright (c) DaVinci FX Group |
//|                                      https://www.davinci-fx.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) DaVinci FX Group"
#property link      "https://www.davinci-fx.com/"
#property version   "1.00"
#property strict

#include <..\Libraries\stdlib.mq4> //библиотека для расшифровки ошибок

extern string s0 = "<== General Settings ==>"; //>  >  >
extern double  Lot                  = 0.01;  //Start lot
extern int     Slippage             = 5;
extern double  TakeProfit           = 15;
extern string  Comments             = "DaVinci EA";
extern int     MagicNumber          = 654321;

extern string s1 = "<== Indicator Settings ==>"; //>  >  >
extern int     InpFastEMA           = 12;    //Fast EMA Period
extern int     InpSlowEMA           = 26;    //Slow EMA Period
extern int     InpSignalSMA         = 9;     //Signal SMA Period

extern string s2 = "<== Grid Settings ==>"; //>  >  >
extern double  GridDistance         = 20;    //Grid Distance
extern double  Multiplier           = 2;     //Lot Multiplier            
extern int     Averaging_Level      = 7;     //Averaging Level
extern int     BE_Level             = 5;     //Breakeven Level
extern double  BE_Step              = 1;     //Breakeven Step

datetime Update_Time = 0;

struct SetkaEnv{
   int      count_buy;
   int      count_sell;
   datetime lasttimeB, lasttimeS;
   double   last_distanceB, last_distanceS;
   double   firstlotB, firstlotS;
   double   lastlotB, lastlotS;
   double   avgB, avgS;
};
SetkaEnv env;
         
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {

   if (Digits == 3 || Digits == 5) {
      Slippage *= 10;
      TakeProfit *= 10;
      GridDistance *= 10;
      BE_Step *= 10;
   } 
     
   return(INIT_SUCCEEDED);  
}
  
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {

   draw_level("be_level_buy", 0, clrNONE);
   draw_level("be_level_sell", 0, clrNONE);
   
}
  
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
  
   //3 Блок: подсчет ордеров и работа с мартингейлом
   CheckMartingale(); 
   
   //удаляем линию БУ сетки с графика при отстуствии ордеров
   if(env.count_buy == 0) draw_level("be_level_buy", 0, clrNONE);
   if(env.count_sell == 0) draw_level("be_level_sell", 0, clrNONE);
   
   //2 Блок: модификация ТП открытых ордеров
   int _OrdersTotal = OrdersTotal();
   for(int pos = _OrdersTotal - 1; pos >= 0; pos--) { //цикл по всем открытым ордерам
      if(!OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)) continue; //выделение ордера для получения его данных
      if(OrderType() <= 2 && OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) { //проверка, чтобы ордер относился в нашему советнику
         if(OrderTakeProfit() == 0) { //если у ордера нет ТП, производим модификацию
            double TP = 0;
            
            if(OrderType() == OP_BUY) {
               double price = (env.avgB > 0 ? env.avgB : OrderOpenPrice());
               TP = NormalizeDouble(price+TakeProfit*Point,Digits);
            }
            else {
               double price = (env.avgS > 0 ? env.avgS : OrderOpenPrice());
               TP = NormalizeDouble(price-TakeProfit*Point,Digits);
            }
             
            if(!OrderModify(OrderTicket(), OrderOpenPrice(), 0, TP, 0, clrNONE)) { //модификация ордера
               int Error = GetLastError();
               Print("Ошибка модификации ордера ",Error,": ",ErrorDescription(Error)); //принт при ошибке модификации
            }
            else Print("Ордер #" + IntegerToString(OrderTicket()) + " успешно модифицирован");
         }
      }      
   }         
  
   //1 Блок: проверка условий на вход первого ордера
   if(Update_Time != iTime(NULL,0,0)) { //обновлять данные всех индикаторов раз в период
      Update_Time = iTime(NULL,0,0); //перезаписываем значение переменной для хранения времени текущей свечи
   
      //импорт данных индикатора MACD.
      double MACD1 = iMACD(NULL,0,InpFastEMA,InpSlowEMA,InpSignalSMA,PRICE_CLOSE,MODE_MAIN,1);
      double MACD2 = iMACD(NULL,0,InpFastEMA,InpSlowEMA,InpSignalSMA,PRICE_CLOSE,MODE_MAIN,2);
          
      if(env.count_buy == 0 && MACD1 >= 0 && MACD2 < 0 && MACD1 > MACD2) { //условие для открытия ордера на покупку
         OpenTrade(OP_BUY, 0); //открытие ордера на покупку
      }
      
      if(env.count_sell == 0 && MACD1 <= 0 && MACD2 > 0 && MACD1 < MACD2) { //условие для открытия ордера на продажу
         OpenTrade(OP_SELL, 0); //открытие ордера на продажу
      }
   }

   int Error = GetLastError(); //поиск ошибок по завершению тика
   if(Error != 0) Print("OnTick() Error ",Error,": ",ErrorDescription(Error));   
}

//+------------------------------------------------------------------+
void CheckMartingale() { //функция анализа ордеров мартингейла
 
   ZeroMemory(env); //обнуляем данные структуры
   
   int _OrdersTotal = OrdersTotal();
   for(int pos = _OrdersTotal - 1; pos >= 0; pos--) {
      if(!OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)) {
		   Print(__FUNCTION__ + ": не удалось выделить ордер! " + ErrorDescription(GetLastError()));
		   continue;
      }
      if(OrderType() <= 2 && OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
         if(OrderType() == OP_BUY) {
            env.count_buy++;
            
            if(env.firstlotB == 0 || OrderLots() < env.firstlotB) env.firstlotB = OrderLots();
            
            if(OrderOpenTime() > env.lasttimeB) {
               env.lasttimeB = OrderOpenTime();
               env.last_distanceB = OrderOpenPrice()-Ask;
               env.lastlotB =  OrderLots();
            }    
         }
         else if(OrderType() == OP_SELL) {
            env.count_sell++;
            
            if(env.firstlotS == 0 || OrderLots() < env.firstlotS) env.firstlotS = OrderLots();
            
            if(OrderOpenTime() > env.lasttimeS) {
               env.lasttimeS = OrderOpenTime();
               env.last_distanceS = Bid-OrderOpenPrice();
               env.lastlotS =  OrderLots();
            }
         }
      }
   }
     
   if(env.last_distanceB != 0 || env.last_distanceS != 0) { //если есть открытые ордера
      if(env.lasttimeB > 0 && env.last_distanceB >= GridDistance*Point) {
         if(OpenTrade(OP_BUY,Multiplier)) { //Открытие следующего ордера сетки на покупку
            env.count_buy++; //прибавление ордера к счетчику
            Modify_grid(OP_BUY); //модификация целей ордера после открытия
         }
      }
      if(env.lasttimeS > 0 && env.last_distanceS >= GridDistance*Point) {
         if(OpenTrade(OP_SELL,Multiplier)) { //Открытие следующего ордера сетки на продажу
            env.count_sell++; //прибавление ордера к счетчику
            Modify_grid(OP_SELL); //модификация целей ордера после открытия
         }
      }
   }
}

//+------------------------------------------------------------------+
bool Modify_grid(int OP_TYPE) { //модифицировать сетку ордеров после открытия нового ордера

   double NewTP = CountGridTP(OP_TYPE); //подсчет нового ТП и уровня БУ

   int cnt = (OP_TYPE == OP_BUY ? env.count_buy : env.count_sell); //счетчик
   string be_level = (OP_TYPE == OP_BUY ? "be_level_buy" : "be_level_sell");
   double avg = (OP_TYPE == OP_BUY ? env.avgB : env.avgS); //уровень БУ
   
   //рисуем линию БУ
   if(cnt > 1) draw_level(be_level, avg, clrDarkGoldenrod);
   else draw_level(be_level, 0, clrNONE);
   
   if(NewTP > 0) {
      for(int i=0;i<=OrdersTotal()-1;i++) {
         if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
         if(OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber || OrderType() != OP_TYPE) continue;
         if(OrderTakeProfit() != NewTP) {
            for(int k=0;k<5;k++) {
               if(OrderModify(OrderTicket(), OrderOpenPrice(), 0, NewTP, 0, clrNONE)) { //модификация ТП ордера
                  break; //прерывание цикла
               } 
               RefreshRates();
               Sleep(3000); //сон 3 секунды
            }
         }
      }
   }
   
   return(false);

}

//+------------------------------------------------------------------+
double CountGridTP(int OPType) { //подсчет уровня БУ сетки и нового ТП
   
   int count = 0;
   double Price_Lot=0, SumLots=0;
   
   for(int i=0;i<=OrdersTotal()-1;i++) { //цикл по всем ордерам 
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         if(OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber || OrderType() != OPType) continue;
         Price_Lot += OrderOpenPrice()*OrderLots();
         SumLots += OrderLots();
         count++; //счетчик ордеров
      }
   }
   
   if(SumLots != 0) {
      //находим уровень БУ
      if(OPType == OP_BUY) env.avgB = Price_Lot/SumLots; 
      else env.avgS = Price_Lot/SumLots; 
      
      double TP_pips = TakeProfit*Point; 
           
      if(BE_Level != 0 && count >= BE_Level) { //выставление безубытка если количество колен больше, чем в настройках
         Print(__FUNCTION__ + ": Тейк профит корзины пересчитан и будет переведен в безубыток с отступом " + DoubleToStr(BE_Step,0) + " пунктов.");
         TP_pips = BE_Step*Point;
      }   
   
      double NewTP = NormalizeDouble(OPType == OP_BUY ? env.avgB + TP_pips : env.avgS - TP_pips, Digits); //опеределение нового ТП сетки ордеров
      
      return(NewTP);
   }
   
   return(0);
}

//+------------------------------------------------------------------+
void draw_level(string name, double price, color clr){ //отрисовка горизонтальной линии на графике
   
   if(price<=0){ //если цена отсутствует
      if(ObjectFind(0,name) != -1) ObjectDelete(0,name); //удаление объекта
   }
   else{
      if(ObjectFind(0,name) < 0) ObjectCreate(0,name, OBJ_HLINE, 0, 0, price); //создание объекта
      else ObjectSetDouble(0,name, OBJPROP_PRICE, price); //назнаение объекту цены
      ObjectSetInteger(0,name, OBJPROP_STYLE, STYLE_DOT); //назнаение объекту стиля отображения
      ObjectSetInteger(0,name, OBJPROP_COLOR, clr); //назнаение объекту цвета
   }
}

//+------------------------------------------------------------------+
bool OpenTrade(int OP_Type, double mult) { //функция для открытия рыночного ордера  
   
   int counter = 0;
   double lot = Lot, price = 0;
   double first_lot = 0, last_lot = 0;
   color  col_type = clrNONE;
   string op_str = "";
   
   if(OP_Type == OP_BUY) {
      price = Ask; //определение цены для открытия рыночного ордера
      col_type = clrBlue; //определение цвета стрелки ордера
      op_str = "на покупку"; //определение текста для принта
      counter = env.count_buy;
      first_lot = env.firstlotB;
      last_lot  = env.lastlotB; 
   }
   else {
      price = Bid; //определение цены для открытия рыночного ордера
      col_type = clrRed; //определение цвета стрелки ордера
      op_str = "на продажу"; //определение текста для принта
      counter = env.count_sell;
      first_lot = env.firstlotS; 
      last_lot  = env.lastlotS; 
   }
   
   if(mult > 0) { //задаем лот для следующего ордера сетки
      if(Averaging_Level > 0 && counter >= Averaging_Level-1) lot = NormalizeDouble(last_lot, 2);
      else lot = NormalizeDouble(first_lot * MathPow(Multiplier, counter), 2); //увеличиваем лот для сетки
   }
   
   int ticket = OrderSend(Symbol(), OP_Type, lot, price, Slippage, 0, 0, Comments + "(" + IntegerToString(counter+1) + ")", MagicNumber, 0, col_type); //открытие ордера
   if(ticket > 0) { //Если ордер был открыт
      Print("Ордер #" + IntegerToString(ticket) + " успешно открыт");
      return(true);
   }
   else { //при ошибке открытия ордера
      int Error = GetLastError();
      if(mult == 0) Update_Time = 0;
      Print("Ошибка открытия ордера ",Error,": ",ErrorDescription(Error));
   }
   return(false);
}