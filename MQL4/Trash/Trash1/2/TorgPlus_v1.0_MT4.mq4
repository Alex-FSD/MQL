//+------------------------------------------------------------------+
//|                                               TorgPlus_v1.0.mq4  |
//|                         |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Reutskiy Dmitriy."
#property strict

extern string line1="||________________________________Input Parameters________________________________________||";
extern double lot = 0.01;
extern int intDays = 120; // дней из которых считается среднее
extern string line4 = "________________________Volatility 1 = middle; 2 = minimum_______________________________";
extern int intSpred = 2;
extern string line5 = "________________________Hours in flat period_______________________________";
extern int intFlatTime = 7;
extern string line6 = "________________________Moving avarage_______________________________";
extern int intIma1 = 10; // сокльзящяя средняя
extern int intIma2 = 20; // сокльзящяя средняя
extern int intIma3 = 30; // сокльзящяя средняя
extern string line7 = "________________________Procent start take profit_______________________________";
extern double dblPnt = 1;
extern string line8 = "________________________Procent - 4 take profit_______________________________";
extern int intProce = 10;

double dblLot, dblTP_Points,  dblBL, dblMin, dblMax, dblSum, dblSpred,dblMSpred,dblTP_buy,dblSL_buy,dblOP_buy, dblTP_sell,dblSL_sell,dblOP_sell, dblProfit, dblIma1 ,dblIma2,dblIma3;
int intConnectLoss, intOrd, intX, intY, intHR, intHR1, intHR3, intI, intBuffBuy,intBuffSell, intJ,intSum, intMagicNumber, max_profit,intCount_line,intK,intDm,intDt,ticket_buy, intSell,intBuy;
bool blSpredSymbol, blTorg, blDelline, blFlat, blBuyIma, blSellIma;
string strSpredSymbol, strNameObject, sManday, sTuesday, sWednesday, sFursday,sFriday ;
datetime LastTime, Bar_time,timeprev;



//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
{
   //---- параметры прямоугольника
 intX = 20;
 intY = 20;
   //------------------------
   //blDelline = false;
 dblProfit = 1-100;
 blTorg = true;
 dblLot = lot;
 intSell = 0;
 intBuy = 0;
 intDt = 1;
 return(0);
}

int deinit()
 {
//---
  dblMSpred = 2000;
  intK = 0;
  dblSpred = 0;
  blFlat = false;
//----
  return(0);
 }
//+------------------------------------------------------------------+
//| start function                                            |
//+------------------------------------------------------------------+
int start()
{

 
if(!CheckVolumeValue(lot)) return 0; 
 
blSpredSymbol=SymbolInfoInteger(Symbol(),SYMBOL_SPREAD_FLOAT);
strSpredSymbol=StringFormat("Spred %s = %I64d", blSpredSymbol?"random":"fixed",SymbolInfoInteger(Symbol(),SYMBOL_SPREAD));
    
//---------------- считае спред по истории --------------//
if(dblSpred == 0) // первый запуск
 {
  int Min_Dist=MarketInfo(Symbol(),MODE_STOPLEVEL); // Ищем наименьшую минимальную волатильность
  if(intSpred == 1) dblSpred = f_dbl_spred( intDays,"dblAvargeSpred"); // используем спред 1 =  средний; 
  else dblSpred = f_dbl_spred( intDays,"dblMinSpred"); // иначе = минимальный (2,3...)
 }
   
   // увеличение лота в случае пробития деапазона минимального флета
if(CountTrades(1) == 1 ) // проверка открыт sell
 {
  //Изменяем значение стоп лосса для покупк - минимальное значение
  if(Close[0] < dblSL_buy) dblSL_buy = Close[0]; // новый бай стоп
  if(Close[0] >  dblSL_sell) // если пробили стоп
   {
    CloseThisSymbolAll(); // закрываем ордера
    dblTP_Points =  Closed_ord()*(-1); //прибавляем потерю в пунктах
    intOrd = intSell + intBuy;
    if(intOrd > 2){dblTP_Points = dblTP_Points - dblTP_Points*intProce/100;} // если ордеров больше 3-х то уменьшаем тейк в процентах
    dblTP_buy = Close[0] + dblTP_Points*Point;
            
    if(CountTrades(2) == 0) // проверка ордеров на продажу
    {   
     // пытаемся выставить ордер
     ticket_buy=OrderSend(Symbol(),OP_BUY,lot,Ask,3,0,dblTP_buy,"My order ",intMagicNumber,0,Blue); //dblSL_buy
     if(ticket_buy<0)
      {
       Print("OrderSend failed with error #",GetLastError());
       return(0);
      }
       else
      {
       intBuy++;    // количество ордеров
       lot = lot*2; // увеличиваем лот
       //рисуем новый стоп лосс
       f_Drow_Trend_line(iTime(0,PERIOD_H1,0),iTime(0,PERIOD_H1,intFlatTime),dblSL_sell,dblSL_sell,Blue,STYLE_SOLID,1);
      }
    } 
   }
 }
      
if(CountTrades(2) == 1 ) // проверка открыт buy если тру то открываем селл
 {
  if(Close[0] > dblSL_sell) dblSL_sell = Close[0]; // новый стоп при налчии ордера на бай
  if(Close[0] < dblSL_buy) // если пробили предыдущий стоп
   {
    CloseThisSymbolAll();// закрываем ордера
    dblTP_Points =  Closed_ord()*(-1) ; // потеря ордера в пунктах
    intOrd = intSell + intBuy;
    if(intOrd > 2){dblTP_Points = dblTP_Points - dblTP_Points*intProce/100;}   
    dblTP_sell = Close[0] - dblTP_Points*Point; // новый селл
    if(CountTrades(1) == 0) // проверка ордеров на продажу
     {
      // пытаемся выставить ордер
      ticket_buy=OrderSend(Symbol(),OP_SELL,lot,Bid,3,0,dblTP_sell,"My order ",intMagicNumber,0,Red);// dblSL_sell
      if(ticket_buy<0)
       {
        Print("OrderSend failed with error #",GetLastError());
        return(0);
       }
      else
       {
        intSell++; // количество Sell
        lot = lot*2; // количество buy
        f_Drow_Trend_line(iTime(0,PERIOD_H1,0),iTime(0,PERIOD_H1,intFlatTime),dblSL_buy,dblSL_buy,Blue,STYLE_SOLID,1);
       }
      }
    } 
 }
      
   // раз в час переставлять стоп если торгуем с плавающим
   /*
   if(!blTakeStop) {
         if(Hour() != intHR)
            {
               even_point();
               intHR = Hour();
            }    
    }
   */
   
if(CountTrades(6) == 0) // если нет ордеров CountTrades(6) == 0  
 {
  // раз в час, если нет флета
  if(Hour() != intHR1 && !blFlat ) 
   {
    dblMin = iLow(0,PERIOD_H1,intFlatTime); // Минимум флетовой свечи (диапазон intFlatTime)
    dblMax = iHigh(0,PERIOD_H1,intFlatTime); // Максимум флетовой свечи (диапазон intFlatTime)
    blFlat = true; // есть флет 
    // проверяем пробивалась ли свеча закрытой свечей
    for(intI = intFlatTime-1; intI > 0; intI--) // диапазон флета intFlatTime
     {
      if(iClose(0,PERIOD_H1,intI) > dblMax || iOpen(0,PERIOD_H1,intI)> dblMax || iClose(0,PERIOD_H1,intI) < dblMin || iOpen(0,PERIOD_H1,intI)< dblMin) blFlat = false;
     }
      if(blFlat) // если флет остался true рисуем линии флета
       { 
        dblBL = (dblMax - dblMin)/Point;
        f_Drow_Trend_line(iTime(0,PERIOD_H1,0),iTime(0,PERIOD_H1,intFlatTime),dblMin,dblMin,Blue,STYLE_SOLID,1);// чертим линию на 9 баров
        f_Drow_Trend_line(iTime(0,PERIOD_H1,0),iTime(0,PERIOD_H1,intFlatTime),dblMax,dblMax,Blue,STYLE_SOLID,1);// чертим линию на 9 баров
        dblTP_buy =  dblMax + dblBL*Point;   // dblMin + NormalizeDouble(dblSpred*dblPnt,0)*Point; //  dblSpred Какой спред используем минимальный
        dblSL_buy = dblMin;
        f_Drow_Trend_line(iTime(0,PERIOD_H1,0),iTime(0,PERIOD_H1,15),dblTP_buy,dblTP_buy,Red,STYLE_SOLID,1);
        dblTP_sell = dblMin - dblBL*Point;  // dblMax - NormalizeDouble(dblSpred*dblPnt,0)*Point; // На 200 пунктов сдвинули тp
        dblSL_sell =  dblMax;
        f_Drow_Trend_line(iTime(0,PERIOD_H1,0),iTime(0,PERIOD_H1,15),dblTP_sell,dblTP_sell,Red,STYLE_SOLID,1);// dblTP_sell
        dblTP_Points = NormalizeDouble(dblSpred*dblPnt,0); // Тейк профит в пунктах
        // проверяем развернутые ima для половины флета
        blBuyIma = true; // средние развернуты в верх
        blSellIma = true; // средние развернуты вниз
        for(intI = 0  ; intI < NormalizeDouble(intFlatTime/2,0); intI++)//         
         {
          dblIma1 = iMA(NULL,0,intIma1,0,MODE_SMA,PRICE_CLOSE,intI);
          dblIma2 = iMA(NULL,0,intIma2,0,MODE_SMA,PRICE_CLOSE,intI);
          dblIma3 = iMA(NULL,0,intIma3,0,MODE_SMA,PRICE_CLOSE,intI);
          if(!(dblIma1 > dblIma2 && dblIma2 > dblIma3)){ blBuyIma = false; }
          if(!(dblIma1 < dblIma2 && dblIma2 < dblIma3)){ blSellIma = false; }
         }  
                 // blDelline == true; // удаление линий
        }
      intHR1 = Hour();
    } 
 
   
 if(Hour() >= 0 && Hour() <= 23) // если вермя с 0 до 23
  {
   if(intOrd > 0)
    {
     dblProfit = Closed_ord();
    }
  // выставление первых оредров
   if(iClose(0,PERIOD_H1,0) > dblMax  && dblProfit < 1  && dblBL*2 < dblSpred  && blFlat && blBuyIma  ) 
    { 
     if(CountTrades(7) < 1)
      {
       // по текущей цене
       ticket_buy=OrderSend(Symbol(),OP_BUY,lot,Ask,3,0,dblTP_buy,"My order ",intMagicNumber,0,Blue); //dblSL_buy
       if(ticket_buy<0)
        {
         Print("OrderSend failed with error #",GetLastError());
         return(0);
        }
      else
       {
        // рисуем линии диапазона добавить
        intBuy++;  // количество ордеров
        lot = lot*2;//if(lot != 0.8)
       }
      }
     }
   if(iClose(0,PERIOD_H1,0) < dblMin && dblProfit < 1   && dblBL*2 < dblSpred  && blFlat && blSellIma )  
    { 
     if(CountTrades(8) < 1)
      {
      // выставляем оредр
       ticket_buy=OrderSend(Symbol(),OP_SELL,lot,Bid,3,0,dblTP_sell,"My order ",intMagicNumber,0,Red);// dblSL_sell
       if(ticket_buy<0)
        {
         Print("OrderSend failed with error #",GetLastError());
         return(0);
        }
       else
        {
         intSell++;
         lot = lot*2;
        }
       }
     }
   intOrd = intSell + intBuy;
   if(iClose(0,PERIOD_H1,0) < dblMin  || iClose(0,PERIOD_H1,0) > dblMax ) blFlat = false; 
  }
   
 if(Hour() == 23 && intOrd > 0)  // c 23 по 24 удаляем линии если нет ордеров
  {
     // удаляем линии 
     // for(intI=0 ; intI <= intCount_line; intI++)
     //   {
     //    ObjectDelete("line_" + IntegerToString(intI));
     //   } 
   dblProfit = 1-100; // разрешить торговлю
   intOrd=0;
   intBuffBuy = intBuffBuy + intBuy;
   intBuffSell = intBuffSell + intSell;
   intSell = 0;
   intBuy = 0;
   blTorg = true;
   //blDelline = false;
   if(intSpred == 1) dblSpred = f_dbl_spred( intDays,"dblAvargeSpred"); // используем спред 1 =  средний; 2(else) = минимальный
   else dblSpred = f_dbl_spred( intDays,"dblMinSpred");
   //----------------------------
   lot = dblLot; // обнулили лот
   intDt = 1;   //intCount_line = 0; // обнулить при удалении линий;
   //--------------
  }
 } 
 
 //был выставлен ордер. в эти 24 часа
 
//-------------------------------------------------------//
// Min_Dist=MarketInfo(Symbol(),MODE_SPREAD);
// Str_time = TimeToStr(TimeCurrent(),TIME_MINUTES);

//--------------------Графическая часть----------------------//
if(Hour() != intHR)
 {
// пытаемся создать обьект прямоугольника
  if(ObjectFind(0,"objRect") < 0) // если нет прямоугольника
   {
    if(!ObjectCreate(0,"objRect",OBJ_RECTANGLE_LABEL,0,0,0))
     {
      Print(__FUNCTION__,"не удалось создать текстовую метку. Код ошибки =",GetLastError());
      //return(false);
     }
    else // если получилось создать обьект
     { 
      ObjectSetInteger(0,"objRect",OBJPROP_XDISTANCE,intX); //x
      ObjectSetInteger(0,"objRect",OBJPROP_YDISTANCE,intY); //y
      ObjectSetInteger(0,"objRect",OBJPROP_BGCOLOR,clrWhite); // цвет фона
      ObjectSetInteger(0,"objRect",OBJPROP_XSIZE,270); // ширина
      ObjectSetInteger(0,"objRect",OBJPROP_YSIZE,190); // высота
      ObjectSetInteger(0,"objRect",OBJPROP_CORNER,CORNER_LEFT_UPPER); // угол
      ObjectSetInteger(0,"objRect",OBJPROP_BORDER_TYPE,BORDER_FLAT); // тип рамки
      ObjectSetInteger(0,"objRect",OBJPROP_COLOR,clrOrange); // цвет рамки
      ObjectSetInteger(0,"objRect",OBJPROP_STYLE,STYLE_SOLID); // стиль рамки
      ObjectSetInteger(0,"objRect",OBJPROP_WIDTH,3); // ширина рамки
      ObjectSetInteger(0,"objRect",OBJPROP_BACK,false);// на передний план
     }
   }
       
  for(intI = 1; intI<=7; intI++) // проверяем наличие надписей objText1,2,3,4,5
   {
    if(ObjectFind(0,"objText" + intI) < 0) // если надпись отсутствуюет
     {
      // создаем 
      strNameObject = "objText" + intI;
      ObjectCreate(strNameObject, OBJ_LABEL, 0, 0, 0); 
      ObjectSet(strNameObject, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSet(strNameObject, OBJPROP_XDISTANCE, intX+10);
      ObjectSet(strNameObject, OBJPROP_YDISTANCE, intY+intI*20); 
      // заполняем 
      if(intI==1) ObjectSetText(strNameObject,"__TorgPlusMT4__ v1.0"  ,12,"Arial",clrBlack);
      if(intI==2) ObjectSetText(strNameObject,"Day volatility " + dblSpred  ,12,"Arial",clrBlack);
      if(intI==3) ObjectSetText(strNameObject,"Buys  " + intBuffBuy   ,12,"Arial",clrBlack);
      if(intI==4) ObjectSetText(strNameObject,"Sells " + intBuffSell  ,12,"Arial",clrBlack);
      if(intI==5) ObjectSetText(strNameObject,"Current lot " + lot  ,12,"Arial",clrBlack);
      if(intI==6) ObjectSetText(strNameObject,"Balance " + AccountBalance()  ,12,"Arial",clrBlack); 
      if(intI==7) ObjectSetText(strNameObject,"Spred " + strSpredSymbol  ,12,"Arial",clrBlack); 
      //if(intI==8) ObjectSetText(strNameObject,"Connection losses " + intConnectLoss  ,12,"Arial",clrBlack);   
     }  
    else //  существует 
     {
      strNameObject = "objText" + intI;
      if(intI==1) ObjectSetText(strNameObject,"__TorgPlusMT4__ v1.0"  ,12,"Arial",clrBlack);
      if(intI==2) ObjectSetText(strNameObject,"Min Spred " + dblSpred  ,12,"Arial",clrBlack);
      if(intI==3) ObjectSetText(strNameObject,"Sells  " + intBuffBuy   ,12,"Arial",clrBlack);
      if(intI==4) ObjectSetText(strNameObject,"Buys " + intBuffSell  ,12,"Arial",clrBlack);
      if(intI==5) ObjectSetText(strNameObject,"Current lot " + lot  ,12,"Arial",clrBlack);
      if(intI==6) ObjectSetText(strNameObject,"Balance " + AccountBalance()  ,12,"Arial",clrBlack);
      // if(intI==8) ObjectSetText(strNameObject,"Connection losses " + intConnectLoss  ,12,"Arial",clrBlack);
     }   
   }
  intHR = Hour();// присваиваем значение часа
 }  
 // спред пересчитываем каждый тик
ObjectSetText("objText7","Spred " + strSpredSymbol  ,12,"Arial",clrBlack);
return(0);
}

//+---------------------Функции------------------------------------+
// Рассчитывает спред
// Будем рассчитывать исходя из 3-х месяцев
// 120 дней = пол года
double f_dbl_spred(int intDs,string param)
  {
   int  FintK = 0;
   int  Fi = 0;
   
   double Fdbl, FdblArr[300], FdblMSpred, FdblSum, FdblSpredAV , FintK1;

   for(Fi = 0; Fi<intDs; Fi++)
     {
      Fdbl = iHigh(0,PERIOD_D1,Fi) - iLow(0,PERIOD_D1,Fi);
      Fdbl = Fdbl/Point;
      FdblArr[FintK] = Fdbl;
      FintK++; // количество дней в спреде
     }
     
   FdblMSpred = FdblArr[1];
   for(Fi = 1; Fi <  FintK; Fi++)
     {
      if(FdblMSpred > FdblArr[Fi])
         FdblMSpred = FdblArr[Fi] ;
     }

   for(Fi = 0; Fi<intDs; Fi++)
     {
      FdblSum =  FdblSum + FdblArr[Fi];
     }
     
   FintK1 = FintK;    
   FdblSpredAV = NormalizeDouble(FdblSum/FintK1,0);
   
   if(param == "intK")
     {
      return FintK1;
     }
   if(param == "dblMinSpred")
     {
      return FdblMSpred;
     }
   if(param == "dblAvargeSpred")
     {
      return FdblSpredAV;
     }
   else return 0;
}


// Подсчитывает ордера  param = 1,2,3,4
// 1 - open ords
// 2 - open sell
// 3 - open buy
// 4 - pending order
// 5 - pending buy
// 6 - pending sell
// 7 or other => whole sum
int CountTrades(int param)
{
   int FintFBuyStop = 0,FintSellStop = 0, FintBuy = 0, FintSell=0;

   for(int trade = OrdersTotal() - 1; trade >= 0; trade--)
     {
      OrderSelect(trade, SELECT_BY_POS, MODE_TRADES);
      if(OrderMagicNumber() != intMagicNumber) continue;
      if(OrderMagicNumber() == intMagicNumber)
      if(OrderType() == OP_BUYSTOP) FintFBuyStop++;
      if(OrderType() == OP_SELLSTOP)  FintSellStop++;
      if(OrderType() == OP_BUY)  FintBuy++;
      if(OrderType() == OP_SELL) FintSell++;
     }

    if(param == 0)  return (FintBuy + FintSell);
     //return 0;
    if(param == 1)  return (FintSell);
    if(param == 2)  return (FintBuy);
    if(param == 3)  return (FintSellStop + FintFBuyStop);
    if(param == 4)  return (FintSellStop);
    if(param == 5)  return (FintSellStop);
    if(param == 6)  return (FintBuy + FintSell + FintSellStop + FintFBuyStop);
    if(param == 7)  return (FintFBuyStop + FintBuy);
    if(param == 8)  return (FintSellStop + FintSell);
    if(param > 8)   return (FintBuy + FintSell + FintSellStop + FintSellStop);
    else return 0;
}





//+------------------------------------------------------------------+
//|--------------------f_Drow_Trend_line-----------------------------+                                                  |
//+------------------------------------------------------------------+
// возвращает true если удалось нарисовать линию тренда
bool f_Drow_Trend_line(datetime FdtT1, datetime FdtT2, double FdblP1, double FdblP2, color FclrCLine, const ENUM_LINE_STYLE Fstyle, int FwidthL)
  {
// начальное время
// конечное время
// начальная цена
// конечная цена
// цвет clrRed
// стиль STYLE_SOLID
// ширина 1
   intCount_line++; // глобальная переменная количества линий
   string FNameL = "line_" + intCount_line;
   ResetLastError();
   if(!ObjectCreate(0,FNameL,OBJ_TREND,0,FdtT1,FdblP1,FdtT2,FdblP2))
     {
      Print(__FUNCTION__, ": не удалось создать линию тренда! Код ошибки = ",GetLastError());
      return(false);
     }
   ObjectSetInteger(0,FNameL,OBJPROP_COLOR,FclrCLine);      //установим цвет линии
   ObjectSetInteger(0,FNameL,OBJPROP_STYLE,Fstyle);         //установим стиль отображения линии
   ObjectSetInteger(0,FNameL,OBJPROP_WIDTH,FwidthL);        //установим толщину линии
   ObjectSetInteger(0,FNameL,OBJPROP_BACK,true);           //отобразим на переднем (false) или заднем (true) плане
   ObjectSetInteger(0,FNameL,OBJPROP_RAY_RIGHT,false); //включим (true) или отключим (false) режим продолжения отображения линии вправо
   ObjectSetInteger(0,FNameL,OBJPROP_HIDDEN,false);    //скроем (true) или отобразим (false) имя графического объекта в списке объектов
//ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);  //установим приоритет на получение события нажатия мыши на графике
//--- успешное выполнение
   return(true);
  }



//+------------------------------------------------------------------+
//|------------------Drow_line------------------------------------                                                          |
//+------------------------------------------------------------------+
void Drow_line(double PR, color color_line)
  {
   intCount_line++;
   string Line_name = "line_" + intCount_line;
   bool Line = ObjectCreate(Line_name,OBJ_HLINE,0,0,PR);
   ObjectSet(Line_name,OBJPROP_COLOR,color_line); // цвет LimeGreen
   ObjectSet(Line_name,OBJPROP_WIDTH,1); //толщина
  }
//----Finde hight Close price
double hight_price(int Bars_period)
  {
   double max_close = Close[1];
   for(int i = 1; i<=Bars_period; i++)
     {
      if(Close[i] > max_close)
         max_close = Close[i];

     }
   return max_close;
  }



//----Closed orders
double Closed_ord()
  {
// for (int trade = OrdersTotal(); trade >= 0; trade--) {
   OrderSelect(OrdersHistoryTotal()-1, SELECT_BY_POS, MODE_HISTORY);
   if(OrderSymbol() == Symbol() && OrderMagicNumber() == intMagicNumber)
     {
      if(OrderType() == OP_BUY)
        {
         return ((OrderClosePrice() - OrderOpenPrice())/Point);
        }   
      if(OrderType() == OP_SELL)
        {
         return ((OrderOpenPrice() - OrderClosePrice())/Point);
        }
       else {return 0;}
     }
    else {return 0;}

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseThisSymbolAll()
  {
   for(int trade = OrdersTotal() - 1; trade >= 0; trade--)
     {
      OrderSelect(trade, SELECT_BY_POS, MODE_TRADES);
      if(OrderSymbol() == Symbol())
        {
         if(OrderMagicNumber() == intMagicNumber)
           {
            if(OrderType() == OP_BUY)
               OrderClose(OrderTicket(),OrderLots(),Bid,2);
            if(OrderType() == OP_SELL)
               OrderClose(OrderTicket(),OrderLots(),Ask,2);
           }
       // Sleep(1000);
        }
     }
  }

//+------------------------------------------------------------------+
//|  Проверяет объем ордера на корректность                          |
//+------------------------------------------------------------------+
bool CheckVolumeValue(double volume)
  {
//--- минимально допустимый объем для торговых операций
   string description;
   double min_volume=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN);
   if(volume<min_volume)
     {
      description=StringFormat("Объем меньше минимально допустимого SYMBOL_VOLUME_MIN=%.2f",min_volume);
      return(false);
     }

//--- максимально допустимый объем для торговых операций
   double max_volume=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MAX);
   if(volume>max_volume)
     {
      description=StringFormat("Объем больше максимально допустимого SYMBOL_VOLUME_MAX=%.2f",max_volume);
      return(false);
     }

//--- получим минимальную градацию объема
   double volume_step=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_STEP);

   int ratio=(int)MathRound(volume/volume_step);
   if(MathAbs(ratio*volume_step-volume)>0.0000001)
     {
      description=StringFormat("Объем не является кратным минимальной градации SYMBOL_VOLUME_STEP=%.2f, ближайший корректный объем %.2f",
                               volume_step,ratio*volume_step);
      return(false);
     }
   description="Корректное значение объема";
   return(true);
  }
