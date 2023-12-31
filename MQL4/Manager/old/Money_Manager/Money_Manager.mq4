//+------------------------------------------------------------------+
//|                                                Money_manager.mq4 |
//|                                                           Alexey |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Alexey"
#property link      ""
#property version   "1.00"
#property strict

enum EN_Corner
  {
   en_Left_Upper                                   = 0, //В левом верхнем углу графика
   en_Right_Upper                                  = 1, //В правом верхнем углу графика
   en_Left_Lower                                   = 2, //В левом нижнем углу графика
   en_Right_Lower                                  = 3, //В правом нижнем углу графика
  };

enum EN_ChartTheme
  {
   enOffTheme               = 0, //Выключено (Не использовать тему)
   enLightTheme             = 1, //Светлая тема
   enDarkTheme              = 2  //Тёмная тема
  };

sinput string dlm_1                             = "==================== Основные настройки ====================";//==================== #1 ====================
extern double In_RiskPercent                       = 1;              //Процент риска
extern int In_StopLoss                             = 200;            //Размер стоп-лосса
sinput string dlm_2                             = "==================== Настройки интерфейса ====================";//==================== #2 ====================
extern EN_Corner In_Corner                         = 3;              //Расположение объектов (Угол)
extern int In_XSizeButton                          = 150;            //Ширина объектов
extern int In_YSizeButton                          = 50;             //Высота объектов
extern int In_XShiftButton                         = 155;            //Сдвиг объектов по горизонтали
extern int In_YShiftButton                         = 55;             //Сдвиг объектов по вертекали
extern color In_ColorBuy                           = clrDarkGreen;   //Цвет кнопки BUY
extern color In_ColorSell                          = clrOrangeRed;   //Цвет кнопки SELL
extern color In_ColorFont                          = clrWhite;       //Цвет шрифта кнопок
sinput EN_ChartTheme In_ChartColors                = 0;              //Изменение цветовой темы графика
sinput string dlm_3                             = "==================== Прочие настройки советника ====================";//==================== #3 ====================
sinput int magic                                   = 220122;         //Магическое число. Отличительное число сделок для советников
sinput int slippage                                = 50;             //Проскальзывание

double lots = 0.01;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//   if(AccountNumber() != 250352231)
//     {
//     ExpertRemove();
//     }
   CreateButton("B", In_XShiftButton, In_YShiftButton + 5 + In_YSizeButton, "BUY", In_ColorBuy);
   CreateButton("S", In_XShiftButton, In_YShiftButton, "SELL", In_ColorSell);
   ChartRedraw();
   if(In_ChartColors == 1)
     {
      ChartSetInteger(0, CHART_SHIFT, true);
      ChartSetInteger(0, CHART_AUTOSCROLL, true);
      ChartSetInteger(0, CHART_SHOW_GRID, false);
      ChartSetInteger(0, CHART_SHOW_ASK_LINE, true);
      ChartSetInteger(0, CHART_MODE, CHART_CANDLES);
      ChartSetInteger(0, CHART_SHOW_PERIOD_SEP, false);
      ChartSetInteger(0, CHART_COLOR_BACKGROUND, clrWhiteSmoke);
      ChartSetInteger(0, CHART_COLOR_FOREGROUND, clrBlack);
      ChartSetInteger(0, CHART_COLOR_GRID, clrSilver);
      ChartSetInteger(0, CHART_COLOR_CHART_UP, clrDarkGreen);
      ChartSetInteger(0, CHART_COLOR_CHART_DOWN, clrBrown);
      ChartSetInteger(0, CHART_COLOR_CANDLE_BULL, clrLimeGreen);
      ChartSetInteger(0, CHART_COLOR_CANDLE_BEAR, clrTomato);
      ChartSetInteger(0, CHART_COLOR_CHART_LINE, clrBlack);
      ChartSetInteger(0, CHART_COLOR_VOLUME, clrGreen);
      ChartSetInteger(0, CHART_COLOR_ASK, clrOrangeRed);
      ChartSetInteger(0, CHART_COLOR_STOP_LEVEL, clrOrangeRed);
     }
   if(In_ChartColors == 2)
     {
      ChartSetInteger(0, CHART_SHIFT, true);
      ChartSetInteger(0, CHART_AUTOSCROLL, true);
      ChartSetInteger(0, CHART_SHOW_GRID, false);
      ChartSetInteger(0, CHART_SHOW_ASK_LINE, true);
      ChartSetInteger(0, CHART_MODE, CHART_CANDLES);
      ChartSetInteger(0, CHART_SHOW_PERIOD_SEP, false);
      ChartSetInteger(0, CHART_COLOR_BACKGROUND, C'19,23,34');
      ChartSetInteger(0, CHART_COLOR_FOREGROUND, clrWhiteSmoke);
      ChartSetInteger(0, CHART_COLOR_GRID, C'64,64,80');
      ChartSetInteger(0, CHART_COLOR_CHART_UP, C'70,255,70');
      ChartSetInteger(0, CHART_COLOR_CHART_DOWN, C'255,69,70');
      ChartSetInteger(0, CHART_COLOR_CANDLE_BULL, clrDarkGreen);
      ChartSetInteger(0, CHART_COLOR_CANDLE_BEAR, C'89,37,41');
      ChartSetInteger(0, CHART_COLOR_CHART_LINE, clrYellow);
      ChartSetInteger(0, CHART_COLOR_VOLUME, clrGreen);
      ChartSetInteger(0, CHART_COLOR_ASK, clrOrangeRed);
      ChartSetInteger(0, CHART_COLOR_STOP_LEVEL, clrOrangeRed);
     }
   return(INIT_SUCCEEDED);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ObjectDelete(0, "B");
   ObjectDelete(0, "S");
   ChartRedraw();
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreateButton(string name, int x, int y, string text, color clr)
  {
   ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, In_XSizeButton);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, In_YSizeButton);
   ObjectSetInteger(0, name, OBJPROP_CORNER, In_Corner);
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetString(0, name, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 20);
   ObjectSetInteger(0, name, OBJPROP_COLOR, In_ColorFont);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, clr);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, clr);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CalculateLotSize()
  {
   double LotValue = MarketInfo(Symbol(), MODE_TICKVALUE);
   double Free = AccountFreeMargin();
   double Min_Lot = MarketInfo(Symbol(), MODE_MINLOT);
   double Max_Lot = MarketInfo(Symbol(), MODE_MAXLOT);
   double Step = MarketInfo(Symbol(), MODE_LOTSTEP);
   double Lot = MathFloor((Free * In_RiskPercent / 100) / (In_StopLoss * LotValue) / Step) * Step;
   if(Lot < Min_Lot)
      Lot = Min_Lot;
   if(Lot > Max_Lot)
      Lot = Max_Lot;
   lots = Lot;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OpenOrder(int type, double price)
  {
   int r = 0;
   double pr, sl, tp = 0.0;
   CalculateLotSize();
   pr = NormalizeDouble(price, Digits);
   if(type == OP_BUY)
     {
      sl = pr - (In_StopLoss * Point());
      tp = pr + (3 * In_StopLoss * Point());
      r = OrderSend(NULL, type, lots, pr, slippage, sl, tp, "Manager", magic, 0, clrNONE);
     }
   if(type == OP_SELL)
     {
      sl = pr + (In_StopLoss * Point());
      tp = pr - (3 * In_StopLoss * Point());
      r = OrderSend(NULL, type, lots, pr, slippage, sl, tp, "Manager", magic, 0, clrNONE);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   if(id == CHARTEVENT_OBJECT_CLICK)
     {
      if(sparam == "B")
        {
         OpenOrder(OP_BUY, Ask);
         ObjectSetInteger(0, "B", OBJPROP_STATE, false);
        }
      if(sparam == "S")
        {
         OpenOrder(OP_SELL, Bid);
         ObjectSetInteger(0, "S", OBJPROP_STATE, false);
        }
     }
  }
//+------------------------------------------------------------------+
