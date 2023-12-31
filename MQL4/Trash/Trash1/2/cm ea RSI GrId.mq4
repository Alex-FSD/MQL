//+------------------------------------------------------------------+
//|                               Copyright © 2020, Хлыстов Владимир |
//|                                                cmillion@narod.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2020, http://cmillion.ru"
#property link      "cmillion@narod.ru"
#property strict
#property description "Советник открывает первую позицию по индикатору RSI"
#property description "При пробое заданного значения RSI открывается первый ордер."
#property description "Далее по ходу цены с шагом и коэффициентом открываются новые ордера."
#property description "Стоп лосс для первого ордера равен размеру шага."
#property description "стоп последующих % от пройденногорасстояния ценой от первого ордера."
#property description "Тейк-профит считается от первого ордера."

//--------------------------------------------------------------------
input int    Magic            = 0;//магик
input ENUM_TIMEFRAMES TF_RSI  = 0;//TF индикатора RSI 
input int    period_RSI       = 17;//Период индикатора RSI 
input int    RSI_level_BUY    = 30;//Пробитие RSI снизу для Buy
input int    RSI_level_SELL   = 70;//Пробитие RSI сверху для Sell
input int    MinStep          = 100;//шаг
input double K_Lot            = 1.0;//Коэффициент лота
input int    StopLossPercent  = 30;//Стоп %
input int    Takeprofit       = 2000;//Тейк
input double FixLot           = 0.01;//Фиксированный начальный лот
input double LotPercent       = 0.1;//процент от баланса для расчета первого лота   
 int    slippage         = 40;//проскальзывание цены при открытии

int  DigitsLot = 2;
//--------------------------------------------------------------------
double MINLOT,MAXLOT;
double STOPLEVEL;
//+------------------------------------------------------------------+ 
int OnInit()
{
   MINLOT=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN);
   MAXLOT=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MAX);
   string val=" "+AccountInfoString(ACCOUNT_CURRENCY);

   RectLabelCreate(0,"cmrl BalanceW",0,195,10,195,65);
   DrawLABEL("cm Balance",DoubleToString(0,2),40,20,clrBlack);
   DrawLABEL("cm Equity",DoubleToString(AccountInfoDouble(ACCOUNT_EQUITY),2),40,35,clrBlack);
   DrawLABEL("cm FreeMargin",DoubleToString(AccountInfoDouble(ACCOUNT_MARGIN_FREE),2),40,50,clrBlack);

   DrawLABEL("cmrl Balance","Balance",190,20,clrBlack,ANCHOR_LEFT);
   DrawLABEL("cmrl Equity","Equity",190,35,clrBlack,ANCHOR_LEFT);
   DrawLABEL("cmrl FreeMargin","FreeMargin",190,50,clrBlack,ANCHOR_LEFT);
   DrawLABEL("cmrl Profit","Profit",190,65,clrBlack,ANCHOR_LEFT);

   DrawLABEL("cmrl val Balance",val,5,20,clrBlack);
   DrawLABEL("cmrl val Equity",val,5,35,clrBlack);
   DrawLABEL("cmrl val FreeMargin",val,5,50,clrBlack);
   DrawLABEL("cm Take","",5,65,clrBlack);
   
   return(INIT_SUCCEEDED);
}
//-------------------------------------------------------------------
void OnTick()
{
   if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) 
      Alert("Проверьте в настройках терминала разрешение на автоматическую торговлю!"); 
   else 
   { 
      if(!MQLInfoInteger(MQL_TRADE_ALLOWED)) 
         Alert("Автоматическая торговля запрещена в свойствах программы для ",__FILE__); 
   }
   if(!AccountInfoInteger(ACCOUNT_TRADE_EXPERT)) 
      Alert("Автоматическая торговля запрещена для счета ",AccountInfoInteger(ACCOUNT_LOGIN), 
      " на стороне торгового сервера");
      
   if(!AccountInfoInteger(ACCOUNT_TRADE_ALLOWED)) 
      Comment("Торговля запрещена для счета ",AccountInfoInteger(ACCOUNT_LOGIN), 
      ".\n Возможно, подключение к торговому счету произведено по инвест паролю.", 
      "\n Проверьте журнал терминала, есть ли там такая запись:", 
      "\n\'",AccountInfoInteger(ACCOUNT_LOGIN),"\': trading has been disabled - investor mode.");

   if(AccountInfoInteger(ACCOUNT_TRADE_MODE)==ACCOUNT_TRADE_MODE_REAL && !IsTesting() && AccountNumber()!=3707228)
   {
      if (TerminalInfoString(TERMINAL_LANGUAGE)=="Russian")
      {
         Comment("Работа советника на реальном счете запрещена!, обратитесь к разработчику за ключем cmillion@narod.ru");
         Alert("Работа советника на реальном счете запрещена!, обратитесь к разработчику за ключем cmillion@narod.ru");
      }
      else
      {
         Comment ("Advisor Work on a real account is prohibited! please contact the developer for the key cmillion@narod.ru");
         Alert ("Advisor Work on a real account is prohibited! please contact the developer for the key cmillion@narod.ru");
      }
      return;
   }

   STOPLEVEL=(int)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL);

   double OSL,OTP,OOP,Profit=0,ProfitB=0,ProfitS=0;
   int i,b=0,s=0;
   long tip;
   //----
   double MaxOrderBuy=0,MinOrderSell=0,MinOrderBuy=0,MaxOrderSell=0,OL=0;
   double MinLotB=0,MinLotS=0;
   for (i=0; i<OrdersTotal(); i++)
   {    
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      { 
         if (OrderSymbol()==Symbol() && Magic==OrderMagicNumber())
         { 
            tip = OrderType(); 
            OOP = NormalizeDouble(OrderOpenPrice(),Digits);
            OL = OrderLots(); 
            Profit = OrderProfit()+OrderSwap()+OrderCommission();
            if (tip==OP_BUY)             
            {  
               if (MinLotB>OL || MinLotB==0) MinLotB=OL;
               b++;
               if (MaxOrderBuy < OOP || MaxOrderBuy==0) MaxOrderBuy = OOP;
               if (MinOrderBuy > OOP || MinOrderBuy==0) MinOrderBuy = OOP;
               ProfitB += Profit; 
            }                                         
            if (tip==OP_SELL)        
            {
               if (MinLotS>OL || MinLotS==0) MinLotS=OL;
               s++;
               if (MinOrderSell > OOP || MinOrderSell==0) MinOrderSell = OOP;
               if (MaxOrderSell < OOP || MaxOrderSell==0) MaxOrderSell = OOP;
               ProfitS += Profit; 
            } 
         }  
      }  
   }
   //----
   Profit = ProfitB + ProfitS;
   double AB = AccountInfoDouble(ACCOUNT_BALANCE);
   double Drawdown=100*Profit/AB;
   //---
   ObjectSetString(0,"cm Balance"   ,OBJPROP_TEXT,DoubleToString(AB,2));
   ObjectSetString(0,"cm Equity"    ,OBJPROP_TEXT,DoubleToString(AccountInfoDouble(ACCOUNT_EQUITY),2));
   ObjectSetString(0,"cm FreeMargin",OBJPROP_TEXT,DoubleToString(AccountInfoDouble(ACCOUNT_MARGIN_FREE),2));
   ObjectSetString(0,"cm Take"        ,OBJPROP_TEXT,DoubleToString(Profit,2)+" "+DoubleToString(Drawdown,2)+"%");
   ObjectSetInteger(0,"cm Take"      ,OBJPROP_COLOR,Profit>0?clrGreen:clrRed);
   
   //---
   
   double TPb=0,TPs=0;
   if (Takeprofit>0)
   {
      if (b>0) TPb = NormalizeDouble(MinOrderBuy+Takeprofit*_Point,_Digits);
      if (s>0) TPs = NormalizeDouble(MaxOrderSell-Takeprofit*_Point,_Digits);
   }
   
   //---
   
   double SLb=0,SLs=0;
   if (b>0) 
   {
      if (b==1) SLb = NormalizeDouble(MinOrderBuy - MinStep*_Point,_Digits);
      else SLb = NormalizeDouble(Ask-(Ask-MinOrderBuy)/100*StopLossPercent,_Digits);
   }
   if (s>0) 
   {
      if (s==1) SLs = NormalizeDouble(MaxOrderSell + MinStep*_Point,_Digits);
      else SLs = NormalizeDouble(Bid+(MaxOrderSell-Bid)/100*StopLossPercent,_Digits);
   }
   
   DrawArrow("cm SL Buy",  SLb, iTime(NULL,0,0), clrBlue);
   DrawArrow("cm SL Sell", SLs, iTime(NULL,0,0), clrRed);

   //---

   if (b+s > 0) 
   {
      for (i=0; i<OrdersTotal(); i++)
      {    
         if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         { 
            if (OrderSymbol()==Symbol() && Magic==OrderMagicNumber())
            { 
               tip = OrderType(); 
               OSL = NormalizeDouble(OrderStopLoss(),Digits);
               OTP = NormalizeDouble(OrderTakeProfit(),Digits);
               OOP = NormalizeDouble(OrderOpenPrice(),Digits);
               if (tip==OP_BUY)             
               {  
                  if (SLb > OSL || TPb != OTP)
                  {  
                     if (!OrderModify(OrderTicket(),OOP,SLb,TPb,0,clrNONE)) 
                        Print("Error OrderModify <<",(GetLastError()),">> ");
                  }
               }                                         
               if (tip==OP_SELL)        
               {
                  if (SLs < OSL || TPs != OTP)
                  {  
                     if (!OrderModify(OrderTicket(),OOP,SLs,TPs,0,clrNONE)) 
                        Print("Error OrderModify <<",(GetLastError()),">> ");
                  }
               } 
            }
         }
      }
   }   
   //---
   ObjectSetString(0,"cmkn close Buy",OBJPROP_TEXT,DoubleToString(ProfitB,2)+" Close Buy");
   ObjectSetString(0,"cmkn close Sell",OBJPROP_TEXT,DoubleToString(ProfitS,2)+" Close Sell");
   ObjectSetString(0,"cmkn close All",OBJPROP_TEXT,DoubleToString(Profit,2)+" Close All");

   ObjectSetInteger(0,"cmkn close Buy",OBJPROP_COLOR,ProfitB<0?clrRed:clrGreen);
   ObjectSetInteger(0,"cmkn close Sell",OBJPROP_COLOR,ProfitS<0?clrRed:clrGreen);
   ObjectSetInteger(0,"cmkn close All",OBJPROP_COLOR,Profit<0?clrRed:clrGreen);

   //---
   
   double Lots=0,RSI1=0,RSI0=0;
   //---
   if (b==0 || s==0)
   {
      RSI0= iRSI (NULL,TF_RSI,period_RSI,PRICE_CLOSE,0);
      RSI1= iRSI (NULL,TF_RSI,period_RSI,PRICE_CLOSE,1);
   }
   //---
   if ((MaxOrderBuy+MinStep*Point<=Ask && b>0) || (RSI1<=RSI_level_BUY && RSI0>RSI_level_BUY  && b==0))
   {
      if (b==0) 
      {
         Lots=LOT();
      }
      else
      {
         Lots=NormalizeDouble(MinLotB*MathPow(K_Lot,b),DigitsLot);
      }
   
      SendOrder(OP_BUY, Lots, NormalizeDouble(Ask,Digits)); 
   }
   //---
   if ((MinOrderSell-MinStep*Point>=Bid && s>0) || (RSI1>=RSI_level_SELL && RSI0<RSI_level_SELL && s==0))
   {
      if (s==0) 
      {
         Lots=LOT();
      }
      else
      {
         Lots=NormalizeDouble(MinLotS*MathPow(K_Lot,s),DigitsLot);
      }

      SendOrder(OP_SELL, Lots, NormalizeDouble(Ask,Digits)); 
   }
}
//--------------------------------------------------------------------
color Color(bool P,color a,color b)
{
   if (P) return(a);
   else return(b);
}
//------------------------------------------------------------------
void DrawLABEL(string name, string Name, int X, int Y, color clr,ENUM_ANCHOR_POINT align=ANCHOR_RIGHT)
{
   if (ObjectFind(0,name)==-1)
   {
      ObjectCreate(0,name, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0,name,OBJPROP_CORNER, CORNER_RIGHT_UPPER);
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE, X);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE, Y);
      ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
      ObjectSetInteger(0,name,OBJPROP_SELECTED,false);
      ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
      ObjectSetInteger(0,name,OBJPROP_ANCHOR,align); 
      ObjectSetInteger(0,name,OBJPROP_COLOR,clr); 
      ObjectSetString(0,name,OBJPROP_FONT,"Arial"); 
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,8); 
      ObjectSetDouble(0,name,OBJPROP_ANGLE,0); 
   }
   ObjectSetString(0,name,OBJPROP_TEXT,Name); 
}
//--------------------------------------------------------------------
void OnDeinit(const int reason)
{
   ObjectsDeleteAll(0,"cm");
   Comment("");
}
//+------------------------------------------------------------------+
bool RectLabelCreate(const long             chart_ID=0,               // ID графика
                     const string           name="RectLabel",         // имя метки
                     const int              sub_window=0,             // номер подокна
                     const long              x=0,                     // координата по оси X
                     const long              y=0,                     // координата по оси y
                     const int              width=50,                 // ширина
                     const int              height=18,                // высота
                     const color            back_clr=clrWhite,        // цвет фона
                     const color            clr=clrBlack,             // цвет плоской границы (Flat)
                     const ENUM_LINE_STYLE  style=STYLE_SOLID,        // стиль плоской границы
                     const int              line_width=1,             // толщина плоской границы
                     const bool             back=false,               // на заднем плане
                     const bool             selection=false,          // выделить для перемещений
                     const bool             hidden=true,              // скрыт в списке объектов
                     const long             z_order=0)                // приоритет на нажатие мышью
  {
   ResetLastError();
   if (ObjectFind(chart_ID,name)==-1)
   {
      ObjectCreate(chart_ID,name,OBJ_RECTANGLE_LABEL,sub_window,0,0);
      ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_TYPE,BORDER_FLAT);
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
      ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
      ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,line_width);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
      //ObjectSetInteger(chart_ID,name,OBJPROP_ALIGN,ALIGN_RIGHT); 
   }
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
   return(true);
}
//--------------------------------------------------------------------
string Error(int code)
{
   switch(code)
   {
      case 0:   return("Нет ошибок");
      case 1:   return("Нет ошибки, но результат неизвестен");                            
      case 2:   return("Общая ошибка");                                                   
      case 3:   return("Неправильные параметры");                                         
      case 4:   return("Торговый сервер занят");                                          
      case 5:   return("Старая версия клиентского терминала");                            
      case 6:   return("Нет связи с торговым сервером");                                  
      case 7:   return("Недостаточно прав");                                              
      case 8:   return("Слишком частые запросы");                                         
      case 9:   return("Недопустимая операция нарушающая функционирование сервера");      
      case 64:  return("Счет заблокирован");                                              
      case 65:  return("Неправильный номер счета");                                       
      case 128: return("Истек срок ожидания совершения сделки");                          
      case 129: return("Неправильная цена");                                              
      case 130: return("Неправильные стопы");                                             
      case 131: return("Неправильный объем");                                             
      case 132: return("Рынок закрыт");                                                   
      case 133: return("Торговля запрещена");                                               
      case 134: return("Недостаточно денег для совершения операции");                     
      case 135: return("Цена изменилась");                                                
      case 136: return("Нет цен");                                                        
      case 137: return("Брокер занят");                                                   
      case 138: return("Новые цены");                                                     
      case 139: return("Ордер заблокирован и уже обрабатывается");                        
      case 140: return("Разрешена только покупка");                                       
      case 141: return("Слишком много запросов");                                         
      case 145: return("Модификация запрещена, так как ордер слишком близок к рынку");    
      case 146: return("Подсистема торговли занята");                                     
      case 147: return("Использование даты истечения ордера запрещено брокером");         
      case 148: return("Количество открытых и отложенных ордеров достигло предела, установленного брокером.");
      default:   return("Ошибка неизвестна");
   }
}
//--------------------------------------------------------------------
bool EditCreate(const long             chart_ID=0,               // ID графика 
                const string           name="Edit",              // имя объекта 
                const int              sub_window=0,             // номер подокна 
                const int              x=0,                      // координата по оси X 
                const int              y=0,                      // координата по оси Y 
                const int              width=50,                 // ширина 
                const int              height=18,                // высота 
                const string           text="Text",              // текст 
                const string           font="Arial",             // шрифт 
                const int              font_size=8,             // размер шрифта 
                const ENUM_ALIGN_MODE  align=ALIGN_RIGHT,       // способ выравнивания 
                const bool             read_only=true,           // возможность редактировать 
                const ENUM_BASE_CORNER corner=CORNER_RIGHT_UPPER, // угол графика для привязки 
                const color            clr=clrBlack,             // цвет текста 
                const color            back_clr=clrWhite,        // цвет фона 
                const color            border_clr=clrNONE,       // цвет границы 
                const bool             back=false,               // на заднем плане 
                const bool             selection=false,          // выделить для перемещений 
                const bool             hidden=true,              // скрыт в списке объектов 
                const long             z_order=0)                // приоритет на нажатие мышью 
  { 
   ResetLastError(); 
   if(!ObjectCreate(chart_ID,name,OBJ_EDIT,sub_window,0,0)) 
     { 
      Print(__FUNCTION__, 
            ": не удалось создать объект ",name,"! Код ошибки = ",GetLastError()); 
      return(false); 
     } 
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y); 
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height); 
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text); 
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font); 
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size); 
   ObjectSetInteger(chart_ID,name,OBJPROP_ALIGN,align); 
   ObjectSetInteger(chart_ID,name,OBJPROP_READONLY,read_only); 
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner); 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr); 
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr); 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
string Text(bool P,string a,string b)
{
   if (P) return(a);
   else return(b);
}
//------------------------------------------------------------------
double LOT()
{
   if (FixLot!=0) return(FixLot);
   double LOT = NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE)*LotPercent/10000,DigitsLot);
   if (LOT>MAXLOT) LOT = MAXLOT;
   if (LOT<MINLOT) LOT = MINLOT;
   return(LOT);
}
//------------------------------------------------------------------
bool DrawArrow(const string          name="RightPrice", // имя ценовой метки 
               double                price=0,           // цена точки привязки 
               datetime              time=0,            // время точки привязки 
               const color           clr=clrRed,        // цвет ценовой метки 
               const ENUM_LINE_STYLE style=STYLE_SOLID, // стиль окаймляющей линии 
               const int             width=1,           // размер ценовой метки 
               const bool            back=false,        // на заднем плане 
               const bool            selection=true,    // выделить для перемещений 
               const bool            hidden=true,       // скрыт в списке объектов 
               const long            z_order=0)         // приоритет на нажатие мышью 
  { 
   if(ObjectFind(0,name)<0)
   { 
      if(!ObjectCreate(0,name,OBJ_ARROW_RIGHT_PRICE,0,time,price)) 
      { 
         return(false); 
      } 
      ObjectSetInteger(0,name,OBJPROP_COLOR,clr); 
      ObjectSetInteger(0,name,OBJPROP_STYLE,style); 
      ObjectSetInteger(0,name,OBJPROP_WIDTH,width); 
      ObjectSetInteger(0,name,OBJPROP_BACK,back); 
      ObjectSetInteger(0,name,OBJPROP_SELECTABLE,selection); 
      ObjectSetInteger(0,name,OBJPROP_SELECTED,selection); 
      ObjectSetInteger(0,name,OBJPROP_HIDDEN,hidden); 
      ObjectSetInteger(0,name,OBJPROP_ZORDER,z_order); 
   }
   ObjectSetInteger(0,name,OBJPROP_TIME,time); 
   ObjectSetDouble(0,name,OBJPROP_PRICE,price); 
   return(true); 
  } 
//+------------------------------------------------------------------+
bool IsNewOrderAllowed()
  {
   int max_allowed_orders=(int)AccountInfoInteger(ACCOUNT_LIMIT_ORDERS);
   if(max_allowed_orders==0)
      return(true);
   if(OrdersTotal()<max_allowed_orders)
      return(true);
   return(false);
  }
//+------------------------------------------------------------------+
double CheckVolumeValue(double volume)
  {
   double min_volume=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN);
   if(volume<min_volume)
     {
      return(min_volume);
     }

   double max_volume=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MAX);
   if(volume>max_volume)
     {
      return(max_volume);
     }

   double volume_step=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_STEP);

   int ratio=(int)MathRound(volume/volume_step);
   if(MathAbs(ratio*volume_step-volume)>0.0000001)
     {
      return(ratio*volume_step);
     }
   return(volume);
  }
//+------------------------------------------------------------------+
bool SendOrder(int tip, double lots, double price, double sl=0, double tp=0)
{
   if(!IsNewOrderAllowed()) return(false);
   lots=CheckVolumeValue(lots);
   if(lots>MAXLOT) lots = MAXLOT;
   if(lots<MINLOT) lots = MINLOT;
   if (tip<2)
   {
      if (AccountFreeMarginCheck(Symbol(),tip,lots)<0)
      {
         Alert("Недостаточно средств");
         return(false);
      }
   }
   for (int i=0; i<10; i++)
   {    
      if (OrderSend(Symbol(),tip, lots,price,slippage,sl,tp,NULL,Magic,0,clrNONE)!=-1) return(true);
         Alert(" попытка ",i," Ошибка открытия ордера ",Strtip(tip)," <<",Error(GetLastError()),">>  lot=",lots,"  pr=",price," sl=",sl," tp=",tp);
      Sleep(500);
      RefreshRates();
      if (IsStopped()) return(false);
   }
   return(false);
}
//------------------------------------------------------------------
string Strtip(int tip)
{
   switch(tip) 
   { 
   case OP_BUY:      return("BUY"); 
   case OP_SELL:     return("SELL"); 
   case OP_BUYSTOP:  return("BUYSTOP"); 
   case OP_SELLSTOP: return("SELLSTOP"); 
   case OP_BUYLIMIT: return("BUYLIMIT"); 
   case OP_SELLLIMIT:return("SELLLIMIT"); 
   }
   return("error"); 
}
//------------------------------------------------------------------
