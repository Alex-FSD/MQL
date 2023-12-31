//+------------------------------------------------------------------+
//|                                                      Manager.mq4 |
//|                                                           Alexey |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Alexey"
#property link      ""
#property version   "1.00"
#property strict

#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>

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
extern int In_XSizeButton                          = 150;            //Ширина кнопок
extern int In_YSizeButton                          = 50;             //Высота кнопок
extern int In_XShiftButton                         = 155;            //Сдвиг кнопок по горизонтали
extern int In_YShiftButton                         = 55;             //Сдвиг кнопок по вертекали
extern color In_ColorBuy                           = clrDarkGreen;   //Цвет кнопки BUY
extern color In_ColorSell                          = clrOrangeRed;   //Цвет кнопки SELL
extern color In_ColorFont                          = clrWhite;       //Цвет шрифта кнопок
extern color In_SizeFont                           = 20;             //Размер шрифта кнопок
sinput EN_ChartTheme In_ChartColors                = 0;              //Изменение цветовой темы графика
sinput string dlm_3                             = "==================== Прочие настройки советника ====================";//==================== #3 ====================
sinput int magic                                   = 220122;         //Магическое число. Отличительное число сделок для советников
sinput int slippage                                = 50;             //Проскальзывание

double lots = 0.01;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CAppWindowButtons : public CAppDialog
  {
protected:

private:
   CButton           Button_Buy;                       // the button object
   CButton           Button_Sell;                       // the button object

public:
                     CAppWindowButtons(void);
                    ~CAppWindowButtons(void);
   //--- create
   virtual bool      Create(const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2);
   //--- chart event handler
   virtual bool      OnEvent(const int id, const long &lparam, const double &dparam, const string &sparam);

protected:
   //--- create dependent controls
   bool              CreateButton_Buy(void);
   bool              CreateButton_Sell(void);
   //--- handlers of the dependent controls events
   void              OnClickButton_Buy(void);
   void              OnClickButton_Sell(void);

  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
EVENT_MAP_BEGIN(CAppWindowButtons)
ON_EVENT(ON_CLICK, Button_Buy, OnClickButton_Buy)
ON_EVENT(ON_CLICK, Button_Sell, OnClickButton_Sell)
EVENT_MAP_END(CAppDialog)

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAppWindowButtons::CAppWindowButtons(void)
  {
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAppWindowButtons::~CAppWindowButtons(void)
  {
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppWindowButtons::Create(const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2)
  {
   if(!CAppDialog::Create(chart, name, subwin, x1, y1, x2, y2))
      return(false);
//--- create dependent controls
   if(!CreateButton_Buy())
      return(false);
   if(!CreateButton_Sell())
      return(false);
//--- succeed
   return(true);
  }


CAppWindowButtons Panel;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(!Panel.Create(0, "Manager", 0, 0, 15, 400, 400))
      return(INIT_FAILED);
   Panel.Run();
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
   ChartRedraw();
   return(INIT_SUCCEEDED);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Panel.Destroy(reason);
   ChartRedraw();
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,         // event ID
                  const long& lparam,   // event parameter of the long type
                  const double& dparam, // event parameter of the double type
                  const string& sparam) // event parameter of the string type
  {
   Panel.ChartEvent(id, lparam, dparam, sparam);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppWindowButtons::CreateButton_Buy(void)
  {
   int x1 = In_XSizeButton;
   int y1 = In_YSizeButton;
   int x2 = x1 + In_XShiftButton;
   int y2 = y1 + In_YShiftButton;
   if(!Button_Buy.Create(0, "Button_Buy", 0, x1, y1, x2, y2))
      return(false);
   if(!Button_Buy.Text("BUY"))
      return(false);
   if(!Button_Buy.Font("Arial"))
      return(false);
   if(!Button_Buy.FontSize(In_SizeFont))
      return(false);
   if(!Button_Buy.Color(In_ColorFont))
      return(false);
   if(!Button_Buy.ColorBackground(In_ColorBuy))
      return(false);
   if(!Button_Buy.ColorBorder(In_ColorBuy))
      return(false);
   if(!Add(Button_Buy))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppWindowButtons::CreateButton_Sell(void)
  {
   int x1 = In_XSizeButton;
   int y1 = In_YSizeButton + 10 + In_YSizeButton;
   int x2 = x1 + In_XShiftButton;
   int y2 = y1 + In_YShiftButton;
   if(!Button_Sell.Create(0, "Button_Sell", 0, x1, y1, x2, y2))
      return(false);
   if(!Button_Sell.Text("SELL"))
      return(false);
   if(!Button_Sell.Font("Arial"))
      return(false);
   if(!Button_Sell.FontSize(In_SizeFont))
      return(false);
   if(!Button_Sell.Color(In_ColorFont))
      return(false);
   if(!Button_Sell.ColorBackground(In_ColorSell))
      return(false);
   if(!Button_Sell.ColorBorder(In_ColorSell))
      return(false);
   if(!Add(Button_Sell))
      return(false);
   return(true);
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
void CAppWindowButtons::OnClickButton_Buy(void)
  {
   OpenOrder(OP_BUY, Ask);
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAppWindowButtons::OnClickButton_Sell(void)
  {
   OpenOrder(OP_SELL, Bid);
  }
//+------------------------------------------------------------------+
