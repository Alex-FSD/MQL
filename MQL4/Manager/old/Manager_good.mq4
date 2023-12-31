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
#include <Controls\Edit.mqh>
#include <Controls\Label.mqh>
#include <Controls\BmpButton.mqh>
#include <Controls\Defines.mqh>

enum EN_ChartTheme
  {
   enOffTheme               = 0, //Выключено (Не использовать тему)
   enLightTheme             = 1, //Светлая тема
   enDarkTheme              = 2  //Тёмная тема
  };

sinput string dlm_1                             = "==================== Настройки торговой панели ====================";//==================== #1 ====================
extern int In_SpinEdit_MaxValue                    = 5;             //Максимальное значение % риска
extern color In_ColorBuy                           = clrDarkGreen;   //Цвет кнопки BUY
extern color In_ColorSell                          = clrOrangeRed;   //Цвет кнопки SELL
extern color In_ColorFont                          = clrWhite;       //Цвет шрифта кнопок
extern int In_FontSizeButton                       = 20;             //Размер шрифта кнопок
sinput string dlm_2                             = "==================== Настройки информационной панели ====================";//==================== #2 ====================
extern int In_FontSizeGeneral                      = 10;             //Размер шрифта надписей
sinput string dlm_3                             = "==================== Настройки интерфейса ====================";//==================== #3 ====================
sinput EN_ChartTheme In_ChartColors                = 0;              //Изменение цветовой темы графика
sinput string dlm_4                             = "==================== Прочие настройки ====================";//==================== #4 ====================
extern int Magic = 29081996;
extern int Slippage = 50;

double Var_RiskPercent = 0.00;
int Var_StopLoss = 0;
double Var_Lots = 0.00;

int X_Button = 100;
int Y_Button = 50;

int X_Panel = 5;
int Y_Panel = 15;
int W_Panel = X_Panel + X_Button + 98;
int H_Panel = Y_Panel + Y_Button * 2 + 43;

int X_PanelInfo = 5;
int Y_PanelInfo = Y_Panel + H_Panel;
int W_PanelInfo = W_Panel;
int H_PanelInfo = Y_PanelInfo + 200;

int X1_PanelInfo = 5;
int X2_PanelInfo = 80;
int X3_PanelInfo = 140;

int Y1_PanelInfo = 20;
int Y2_PanelInfo = 40;
int Y3_PanelInfo = 60;
int Y4_PanelInfo = 80;
int Y5_PanelInfo = 100;
int Y6_PanelInfo = 120;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CAppPanel : public CAppDialog
  {
private:
   CButton           Button_Buy;
   CButton           Button_Sell;
   CEdit             Edit_Risk;
   CEdit             Edit_SL;
   CLabel            Label_Risk;
   CLabel            Label_SL;
   CBmpButton        EditButton_Up;
   CBmpButton        EditButton_Down;

public:
                     CAppPanel(void);
                    ~CAppPanel(void);
   virtual bool      Create(const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2);
   virtual bool      OnEvent(const int id, const long &lparam, const double &dparam, const string &sparam);
protected:
   virtual void      Minimize(void);

   bool              CreateButton_Buy(void);
   bool              CreateButton_Sell(void);
   bool              CreateEdit_Risk(void);
   bool              CreateEdit_SL(void);
   bool              CreateLabel_Risk(void);
   bool              CreateLabel_SL(void);
   bool              CreateEditButton_Up(void);
   bool              CreateEditButton_Down(void);

   void              OnClickButton_Buy(void);
   void              OnClickButton_Sell(void);
   void              OnClickEditButton_Up(void);
   void              OnClickEditButton_Down(void);
   void              Edit_Risk_EndEdit(void);
   void              Edit_SL_EndEdit(void);
  };


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
EVENT_MAP_BEGIN(CAppPanel)
ON_NAMED_EVENT(ON_CLICK, EditButton_Up, OnClickEditButton_Up)
ON_NAMED_EVENT(ON_CLICK, EditButton_Down, OnClickEditButton_Down)
ON_NAMED_EVENT(ON_CLICK, Button_Buy, OnClickButton_Buy)
ON_NAMED_EVENT(ON_CLICK, Button_Sell, OnClickButton_Sell)
ON_NAMED_EVENT(ON_END_EDIT, Edit_Risk, Edit_Risk_EndEdit)
ON_NAMED_EVENT(ON_END_EDIT, Edit_SL, Edit_SL_EndEdit)
EVENT_MAP_END(CAppDialog)


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAppPanel::CAppPanel(void)
  {
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAppPanel::~CAppPanel(void)
  {
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanel::Create(const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2)
  {
   if(!CAppDialog::Create(chart, name, subwin, x1, y1, x2, y2))
      return(false);
   if(!CreateButton_Buy())
      return(false);
   if(!CreateButton_Sell())
      return(false);
   if(!CreateEdit_Risk())
      return(false);
   if(!CreateEdit_SL())
      return(false);
   if(!CreateLabel_Risk())
      return(false);
   if(!CreateLabel_SL())
      return(false);
   if(!CreateEditButton_Up())
      return(false);
   if(!CreateEditButton_Down())
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAppPanel::Minimize(void)
  {
   int var_left = m_min_rect.left;
   int var_top = m_min_rect.top;
   int var_right = m_min_rect.right;
   int var_bottom = m_min_rect.bottom;
   int var_Width = m_min_rect.Width();
   int var_Height = m_min_rect.Height();
//
   if((var_left == 10) && (var_top == 10))
     {
      m_min_rect.left = Panel.Left();
      m_min_rect.top = Panel.Top();
      m_min_rect.right = m_min_rect.left + var_Width;
      m_min_rect.bottom = m_min_rect.top + var_Height;
     }
//
   CAppDialog::Minimize();
  }


CAppPanel *Panel;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CAppPanelInfo : public CAppDialog
  {
private:
   CButton           Button_Refresh;

   CLabel            Label_Result;
   CLabel            Label_Currency;
   CLabel            Label_Percent;

   CLabel            Label_D;
   CLabel            Label_E;
   CLabel            Label_TW;
   CLabel            Label_LW;
   CLabel            Label_TM;
   CLabel            Label_LM;

   CLabel            Label_D1;
   CLabel            Label_E1;
   CLabel            Label_TW1;
   CLabel            Label_LW1;
   CLabel            Label_TM1;
   CLabel            Label_LM1;

   CLabel            Label_D2;
   CLabel            Label_E2;
   CLabel            Label_TW2;
   CLabel            Label_LW2;
   CLabel            Label_TM2;
   CLabel            Label_LM2;
public:
                     CAppPanelInfo(void);
                    ~CAppPanelInfo(void);
   virtual bool      Create(const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2);
   virtual bool      OnEvent(const int id, const long &lparam, const double &dparam, const string &sparam);
protected:
   virtual void      Minimize(void);

   bool              CreateButton_Refresh(void);

   bool              CreateLabel_Result(void);
   bool              CreateLabel_Currency(void);
   bool              CreateLabel_Percent(void);

   bool              CreateLabel_D(void);
   bool              CreateLabel_E(void);
   bool              CreateLabel_TW(void);
   bool              CreateLabel_LW(void);
   bool              CreateLabel_TM(void);
   bool              CreateLabel_LM(void);

   bool              CreateLabel_D1(void);
   bool              CreateLabel_E1(void);
   bool              CreateLabel_TW1(void);
   bool              CreateLabel_LW1(void);
   bool              CreateLabel_TM1(void);
   bool              CreateLabel_LM1(void);

   bool              CreateLabel_D2(void);
   bool              CreateLabel_E2(void);
   bool              CreateLabel_TW2(void);
   bool              CreateLabel_LW2(void);
   bool              CreateLabel_TM2(void);
   bool              CreateLabel_LM2(void);


   void              OnClickButton_Refresh(void);
  };


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
EVENT_MAP_BEGIN(CAppPanelInfo)
ON_NAMED_EVENT(ON_CLICK, Button_Refresh, OnClickButton_Refresh)
EVENT_MAP_END(CAppDialog)


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAppPanelInfo::CAppPanelInfo(void)
  {
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAppPanelInfo::~CAppPanelInfo(void)
  {
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::Create(const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2)
  {
   if(!CAppDialog::Create(chart, name, subwin, x1, y1, x2, y2))
      return(false);
   if(!CreateButton_Refresh())
      return(false);
   if(!CreateLabel_Result())
      return(false);
   if(!CreateLabel_Currency())
      return(false);
   if(!CreateLabel_Percent())
      return(false);
   if(!CreateLabel_D())
      return(false);
   if(!CreateLabel_E())
      return(false);
   if(!CreateLabel_TW())
      return(false);
   if(!CreateLabel_LW())
      return(false);
   if(!CreateLabel_TM())
      return(false);
   if(!CreateLabel_LM())
      return(false);
   if(!CreateLabel_D1())
      return(false);
   if(!CreateLabel_E1())
      return(false);
   if(!CreateLabel_TW1())
      return(false);
   if(!CreateLabel_LW1())
      return(false);
   if(!CreateLabel_TM1())
      return(false);
   if(!CreateLabel_LM1())
      return(false);
   if(!CreateLabel_D2())
      return(false);
   if(!CreateLabel_E2())
      return(false);
   if(!CreateLabel_TW2())
      return(false);
   if(!CreateLabel_LW2())
      return(false);
   if(!CreateLabel_TM2())
      return(false);
   if(!CreateLabel_LM2())
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAppPanelInfo::Minimize(void)
  {
   int var_left = m_min_rect.left;
   int var_top = m_min_rect.top;
   int var_right = m_min_rect.right;
   int var_bottom = m_min_rect.bottom;
   int var_Width = m_min_rect.Width();
   int var_Height = m_min_rect.Height();
//
   if((var_left == 10) && (var_top == 10))
     {
      m_min_rect.left = PanelInfo.Left();
      m_min_rect.top = PanelInfo.Top();
      m_min_rect.right = m_min_rect.left + var_Width;
      m_min_rect.bottom = m_min_rect.top + var_Height;
     }
//
   CAppDialog::Minimize();
  }


CAppPanelInfo *PanelInfo;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(TimeCurrent() > StrToTime("28.02.2022"))
     {
      Alert("License has expired");
      ExpertRemove();
     }
   if(AccountNumber() != 250352231)
     {
      Alert("This account is not allowed to use");
      ExpertRemove();
     }
//
   Panel = new CAppPanel();
   if(!Panel.Create(0, "Manager", 0, X_Panel, Y_Panel, W_Panel, H_Panel))
      return(INIT_FAILED);
   Panel.Run();
   Panel.IniFileLoad();
//
   PanelInfo = new CAppPanelInfo();
   if(!PanelInfo.Create(0, "Info", 0, X_PanelInfo, Y_PanelInfo, W_PanelInfo, H_PanelInfo))
      return(INIT_FAILED);
   PanelInfo.Run();
   PanelInfo.IniFileLoad();
//
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
   if(reason == REASON_CHARTCHANGE)
     {
      Panel.IniFileSave();
      PanelInfo.IniFileSave();
     }
   Panel.Destroy(reason);
   PanelInfo.Destroy(reason);
   delete(Panel);
   delete(PanelInfo);
   ChartRedraw();
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long& lparam,
                  const double& dparam,
                  const string& sparam)
  {
   Panel.ChartEvent(id, lparam, dparam, sparam);
   PanelInfo.ChartEvent(id, lparam, dparam, sparam);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
color GetColorProfit(double n)
  {
   color NColor = clrBlack;
   if(n > 0)
      NColor = clrGreen;
   if(n < 0)
      NColor = clrRed;
   return(NColor);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetWithdraw(ENUM_TIMEFRAMES timeframe = PERIOD_CURRENT, int starbar = 0, int endbar = 0)
  {
   double withdraw = 0;
   for(int i = OrdersHistoryTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
        {
         if(OrderType() > 5 && OrderProfit() + OrderCommission() + OrderSwap() < 0)
           {
            if(OrderCloseTime() >= iTime(Symbol(), timeframe, starbar) && (OrderCloseTime() < iTime(Symbol(), timeframe, endbar) || endbar == -1))
               withdraw -= OrderProfit() + OrderCommission() + OrderSwap();
           }
        }
     }
   return(withdraw);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetDeposits(ENUM_TIMEFRAMES timeframe = PERIOD_CURRENT, int starbar = 0, int endbar = 0)
  {
   double deposits = 0;
   for(int i = OrdersHistoryTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
        {
         if(OrderType() > 5 && OrderProfit() + OrderCommission() + OrderSwap() >= 0)
           {
            if(OrderCloseTime() >= iTime(Symbol(), timeframe, starbar) && (OrderCloseTime() < iTime(Symbol(), timeframe, endbar) || endbar == -1))
               deposits += OrderProfit() + OrderCommission() + OrderSwap();
           }
        }
     }
   return(deposits);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TotalProfit(double &today, double &yesterday, double &ThisWeek, double &LastWeek, double &thismonth, double &lastmonth)
  {
   for(int i = 0; i < OrdersHistoryTotal(); i++)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
        {
         if(OrderType() <= 5)
           {
            if(OrderCloseTime() >= iTime(Symbol(), PERIOD_D1, 0))
               today += OrderProfit() + OrderSwap() + OrderCommission();
            if(OrderCloseTime() >= iTime(Symbol(), PERIOD_D1, 1) && OrderCloseTime() < iTime(Symbol(), PERIOD_D1, 0))
               yesterday += OrderProfit() + OrderSwap() + OrderCommission();
            if(OrderCloseTime() >= iTime(Symbol(), PERIOD_W1, 0))
               ThisWeek += OrderProfit() + OrderSwap() + OrderCommission();
            if(OrderCloseTime() >= iTime(Symbol(), PERIOD_W1, 1) && OrderCloseTime() < iTime(Symbol(), PERIOD_W1, 0))
               LastWeek += OrderProfit() + OrderSwap() + OrderCommission();
            if(OrderCloseTime() >= iTime(Symbol(), PERIOD_MN1, 0))
               thismonth += OrderProfit() + OrderSwap() + OrderCommission();
            if(OrderCloseTime() >= iTime(Symbol(), PERIOD_MN1, 1) && OrderCloseTime() < iTime(Symbol(), PERIOD_MN1, 0))
               lastmonth += OrderProfit() + OrderSwap() + OrderCommission();
           }
        }
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAppPanelInfo::OnClickButton_Refresh(void)
  {
   double Today, Yesterday, ThisWeek, LastWeek, ThisMonth, LastMonth;
   TotalProfit(Today, Yesterday, ThisWeek, LastWeek, ThisMonth, LastMonth);
   double today_percent = NormalizeDouble(Today / (AccountInfoDouble(ACCOUNT_BALANCE) - GetWithdraw(PERIOD_D1, 0, -1) - GetDeposits(PERIOD_D1, 0, -1) - Today) * 100, 2);
   double yesterday_percent = NormalizeDouble(Yesterday / (AccountInfoDouble(ACCOUNT_BALANCE) - GetWithdraw(PERIOD_D1, 1, 0) - GetDeposits(PERIOD_D1, 1, 0) - Today - Yesterday) * 100, 2);
   double thisweek_percent = NormalizeDouble(ThisWeek / (AccountInfoDouble(ACCOUNT_BALANCE) - GetWithdraw(PERIOD_W1, 0, -1) - GetDeposits(PERIOD_W1, 0, -1) - ThisWeek) * 100, 2);
   double lastweek_percent = NormalizeDouble(LastWeek / (AccountInfoDouble(ACCOUNT_BALANCE) - GetWithdraw(PERIOD_W1, 1, 0) - GetDeposits(PERIOD_W1, 1, 0) - ThisWeek - LastWeek) * 100, 2);
   double thismonth_percent = NormalizeDouble(ThisMonth / (AccountInfoDouble(ACCOUNT_BALANCE) - GetWithdraw(PERIOD_MN1, 0, -1) - GetDeposits(PERIOD_MN1, 0, -1) - ThisMonth) * 100, 2);
   double lastmonth_percent =  NormalizeDouble(LastMonth / (AccountInfoDouble(ACCOUNT_BALANCE) - GetWithdraw(PERIOD_MN1, 1, 0) - GetDeposits(PERIOD_MN1, 1, 0) - ThisMonth - LastMonth) * 100, 2);
//
   Label_D1.Text(DoubleToStr(Today, 2));
   Label_E1.Text(DoubleToStr(Yesterday, 2));
   Label_TW1.Text(DoubleToStr(ThisWeek, 2));
   Label_LW1.Text(DoubleToStr(LastWeek, 2));
   Label_TM1.Text(DoubleToStr(ThisMonth, 2));
   Label_LM1.Text(DoubleToStr(LastMonth, 2));
   Label_D2.Text(DoubleToStr(today_percent, 2) + "%");
   Label_E2.Text(DoubleToStr(yesterday_percent, 2) + "%");
   Label_TW2.Text(DoubleToStr(thisweek_percent, 2) + "%");
   Label_LW2.Text(DoubleToStr(lastweek_percent, 2) + "%");
   Label_TM2.Text(DoubleToStr(thismonth_percent, 2) + "%");
   Label_LM2.Text(DoubleToStr(lastmonth_percent, 2) + "%");
//
   Label_D1.Color(GetColorProfit(Today));
   Label_E1.Color(GetColorProfit(Yesterday));
   Label_TW1.Color(GetColorProfit(ThisWeek));
   Label_LW1.Color(GetColorProfit(LastWeek));
   Label_TM1.Color(GetColorProfit(ThisMonth));
   Label_LM1.Color(GetColorProfit(LastMonth));
   Label_D2.Color(GetColorProfit(today_percent));
   Label_E2.Color(GetColorProfit(yesterday_percent));
   Label_TW2.Color(GetColorProfit(thisweek_percent));
   Label_LW2.Color(GetColorProfit(lastweek_percent));
   Label_TM2.Color(GetColorProfit(thismonth_percent));
   Label_LM2.Color(GetColorProfit(lastmonth_percent));
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateButton_Refresh(void)
  {
   int x1 = 0;
   int y1 = 0;
   int x2 = x1 + W_PanelInfo - 13;
   int y2 = y1 + 25;
   if(!Button_Refresh.Create(0, "Button_Refresh", 0, x1, y1, x2, y2))
      return(false);
   if(!Button_Refresh.Text("Refresh"))
      return(false);
   if(!Button_Refresh.Font("Arial"))
      return(false);
   if(!Button_Refresh.FontSize(11))
      return(false);
   if(!Add(Button_Refresh))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_Result(void)
  {
   int x1 = X1_PanelInfo;
   int y1 = Button_Refresh.Height() + 5;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_Result.Create(0, "Label_Result", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_Result.Text("Result"))
      return(false);
   if(!Label_Result.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Label_Result.Font("Arial Black"))
      return(false);
   if(!Add(Label_Result))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_Currency(void)
  {
   int x1 = X2_PanelInfo;
   int y1 = Button_Refresh.Height() + 5;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_Currency.Create(0, "Label_Currency", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_Currency.Text("Cur"))
      return(false);
   if(!Label_Currency.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Label_Currency.Font("Arial Black"))
      return(false);
   if(!Add(Label_Currency))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_Percent(void)
  {
   int x1 = X3_PanelInfo;
   int y1 = Button_Refresh.Height() + 5;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_Percent.Create(0, "Label_Percent", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_Percent.Text("Per"))
      return(false);
   if(!Label_Percent.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Label_Percent.Font("Arial Black"))
      return(false);
   if(!Add(Label_Percent))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_D(void)
  {
   int x1 = X1_PanelInfo;
   int y1 = Y1_PanelInfo + Button_Refresh.Height() + 5;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_D.Create(0, "Label_D", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_D.Text("Today"))
      return(false);
   if(!Label_D.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_D))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_E(void)
  {
   int x1 = X1_PanelInfo;
   int y1 = Y2_PanelInfo + Button_Refresh.Height() + 5;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_E.Create(0, "Label_E", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_E.Text("Yesterday"))
      return(false);
   if(!Label_E.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_E))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_TW(void)
  {
   int x1 = X1_PanelInfo;
   int y1 = Y3_PanelInfo + Button_Refresh.Height() + 5;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_TW.Create(0, "Label_TW", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_TW.Text("This week"))
      return(false);
   if(!Label_TW.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_TW))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_LW(void)
  {
   int x1 = X1_PanelInfo;
   int y1 = Y4_PanelInfo + Button_Refresh.Height() + 5;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_LW.Create(0, "Label_LW", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_LW.Text("Last week"))
      return(false);
   if(!Label_LW.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_LW))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_TM(void)
  {
   int x1 = X1_PanelInfo;
   int y1 = Y5_PanelInfo + Button_Refresh.Height() + 5;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_TM.Create(0, "Label_TM", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_TM.Text("This month"))
      return(false);
   if(!Label_TM.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_TM))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_LM(void)
  {
   int x1 = X1_PanelInfo;
   int y1 = Y6_PanelInfo + Button_Refresh.Height() + 5;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_LM.Create(0, "Label_LM", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_LM.Text("Last month"))
      return(false);
   if(!Label_LM.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_LM))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_D1(void)
  {
   int x1 = X2_PanelInfo;
   int y1 = Y1_PanelInfo + Button_Refresh.Height() + 5;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_D1.Create(0, "Label_D1", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_D1.Text(AccountCurrency()))
      return(false);
   if(!Label_D1.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_D1))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_E1(void)
  {
   int x1 = X2_PanelInfo;
   int y1 = Y2_PanelInfo + Button_Refresh.Height() + 5;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_E1.Create(0, "Label_E1", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_E1.Text(AccountCurrency()))
      return(false);
   if(!Label_E1.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_E1))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_TW1(void)
  {
   int x1 = X2_PanelInfo;
   int y1 = Y3_PanelInfo + Button_Refresh.Height() + 5;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_TW1.Create(0, "Label_TW1", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_TW1.Text(AccountCurrency()))
      return(false);
   if(!Label_TW1.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_TW1))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_LW1(void)
  {
   int x1 = X2_PanelInfo;
   int y1 = Y4_PanelInfo + Button_Refresh.Height() + 5;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_LW1.Create(0, "Label_LW1", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_LW1.Text(AccountCurrency()))
      return(false);
   if(!Label_LW1.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_LW1))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_TM1(void)
  {
   int x1 = X2_PanelInfo;
   int y1 = Y5_PanelInfo + Button_Refresh.Height() + 5;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_TM1.Create(0, "Label_TM1", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_TM1.Text(AccountCurrency()))
      return(false);
   if(!Label_TM1.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_TM1))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_LM1(void)
  {
   int x1 = X2_PanelInfo;
   int y1 = Y6_PanelInfo + Button_Refresh.Height() + 5;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_LM1.Create(0, "Label_LM1", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_LM1.Text(AccountCurrency()))
      return(false);
   if(!Label_LM1.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_LM1))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_D2(void)
  {
   int x1 = X3_PanelInfo;
   int y1 = Y1_PanelInfo + Button_Refresh.Height() + 5;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_D2.Create(0, "Label_D2", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_D2.Text("%"))
      return(false);
   if(!Label_D2.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_D2))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_E2(void)
  {
   int x1 = X3_PanelInfo;
   int y1 = Y2_PanelInfo + Button_Refresh.Height() + 5;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_E2.Create(0, "Label_E2", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_E2.Text("%"))
      return(false);
   if(!Label_E2.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_E2))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_TW2(void)
  {
   int x1 = X3_PanelInfo;
   int y1 = Y3_PanelInfo + Button_Refresh.Height() + 5;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_TW2.Create(0, "Label_TW2", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_TW2.Text("%"))
      return(false);
   if(!Label_TW2.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_TW2))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_LW2(void)
  {
   int x1 = X3_PanelInfo;
   int y1 = Y4_PanelInfo + Button_Refresh.Height() + 5;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_LW2.Create(0, "Label_LW2", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_LW2.Text("%"))
      return(false);
   if(!Label_LW2.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_LW2))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_TM2(void)
  {
   int x1 = X3_PanelInfo;
   int y1 = Y5_PanelInfo + Button_Refresh.Height() + 5;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_TM2.Create(0, "Label_TM2", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_TM2.Text("%"))
      return(false);
   if(!Label_TM2.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_TM2))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_LM2(void)
  {
   int x1 = X3_PanelInfo;
   int y1 = Y6_PanelInfo + Button_Refresh.Height() + 5;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_LM2.Create(0, "Label_LM2", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_LM2.Text("%"))
      return(false);
   if(!Label_LM2.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_LM2))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanel::CreateButton_Buy(void)
  {
   int x1 = 85;
   int y1 = 5;
   int x2 = x1 + X_Button;
   int y2 = y1 + Y_Button;
   if(!Button_Buy.Create(0, "Button_Buy", 0, x1, y1, x2, y2))
      return(false);
   if(!Button_Buy.Text("BUY"))
      return(false);
   if(!Button_Buy.Font("Arial Black"))
      return(false);
   if(!Button_Buy.FontSize(In_FontSizeButton))
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
bool CAppPanel::CreateButton_Sell(void)
  {
   int x1 = 85;
   int y1 = 5 + 5 + Y_Button;
   int x2 = x1 + X_Button;
   int y2 = y1 + Y_Button;
   if(!Button_Sell.Create(0, "Button_Sell", 0, x1, y1, x2, y2))
      return(false);
   if(!Button_Sell.Text("SELL"))
      return(false);
   if(!Button_Sell.Font("Arial Black"))
      return(false);
   if(!Button_Sell.FontSize(In_FontSizeButton))
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
bool CAppPanel::CreateEdit_Risk(void)
  {
   int x1 = 5;
   int y1 = 25;
   int x2 = x1 + 58;
   int y2 = y1 + 30;
   if(!Edit_Risk.Create(0, "Edit_Risk", 0, x1, y1, x2, y2))
      return(false);
   if(!Edit_Risk.Text(DoubleToStr(Var_RiskPercent, 2)))
      return(false);
   if(!Edit_Risk.FontSize(16))
      return(false);
   if(!Add(Edit_Risk))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanel::CreateEdit_SL(void)
  {
   int x1 = 5;
   int y1 = 20 + 5 + 5 + Y_Button;
   int x2 = x1 + 75;
   int y2 = y1 + 30;
   if(!Edit_SL.Create(0, "Edit_SL", 0, x1, y1, x2, y2))
      return(false);
   if(!Edit_SL.Text(IntegerToString(Var_StopLoss)))
      return(false);
   if(!Edit_SL.FontSize(16))
      return(false);
   if(!Add(Edit_SL))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanel::CreateLabel_Risk(void)
  {
   int x1 = 5;
   int y1 = 5;
   int x2 = 10;
   int y2 = 65;
   if(!Label_Risk.Create(0, "Label_Risk", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_Risk.Text("Risk, %"))
      return(false);
   if(!Label_Risk.FontSize(11))
      return(false);
   if(!Add(Label_Risk))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanel::CreateEditButton_Up(void)
  {
   int x1 = 64;
   int y1 = 24;
   int x2 = x1 + 16;
   int y2 = y1 + 16;
   if(!EditButton_Up.Create(0, "EditButton_Up", 0, x1, y1, x2, y2))
      return(false);
   if(!EditButton_Up.BmpNames("::res\\Up.bmp", "::res\\UpDisable.bmp"))
      return(false);
   if(!Add(EditButton_Up))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanel::CreateEditButton_Down(void)
  {
   int x1 = 64;
   int y1 = 40;
   int x2 = x1 + 16;
   int y2 = y1 + 16;
   if(!EditButton_Down.Create(0, "EditButton_Down", 0, x1, y1, x2, y2))
      return(false);
   if(!EditButton_Down.BmpNames("::res\\Down.bmp", "::res\\DownDisable.bmp"))
      return(false);
   if(!Add(EditButton_Down))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanel::CreateLabel_SL(void)
  {
   int x1 = 5;
   int y1 = 5 + 5 + Y_Button;
   int x2 = 10;
   int y2 = 50;
   if(!Label_SL.Create(0, "Label_SL", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_SL.Text("StopLoss"))
      return(false);
   if(!Label_SL.FontSize(11))
      return(false);
   if(!Add(Label_SL))
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
   double Lot = MathFloor((Free * Var_RiskPercent / 100) / (Var_StopLoss * LotValue) / Step) * Step;
   if(Lot < Min_Lot)
      Lot = Min_Lot;
   if(Lot > Max_Lot)
      Lot = Max_Lot;
   Var_Lots = Lot;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OpenOrder(int type, double price)
  {
   int ticket;
   double sl, tp = 0.0;
   CalculateLotSize();
   if(type == OP_BUY)
     {
      sl = price - (Var_StopLoss * Point());
      tp = price + (3 * Var_StopLoss * Point());
      ticket = OrderSend(NULL, OP_BUY, Var_Lots, price, Slippage, sl, tp, "Manager", Magic, 0, clrNONE);
      if(ticket < 0)
        {
         Alert("OrderSend Error #", GetLastError());
        }
     }
   if(type == OP_SELL)
     {
      sl = price + (Var_StopLoss * Point());
      tp = price - (3 * Var_StopLoss * Point());
      ticket = OrderSend(NULL, OP_SELL, Var_Lots, price, Slippage, sl, tp, "Manager", Magic, 0, clrNONE);
      if(ticket < 0)
        {
         Alert("OrderSend Error #", GetLastError());
        }
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAppPanel::Edit_Risk_EndEdit(void)
  {
   double d;
   d = StrToDouble(Edit_Risk.Text());
   if(d > In_SpinEdit_MaxValue)
     {
      Edit_Risk.Text(DoubleToStr(In_SpinEdit_MaxValue, 2));
     }
   else
      if(d < 0.00)
        {
         Edit_Risk.Text(DoubleToStr(0.00, 2));
        }
      else
        {
         Edit_Risk.Text(DoubleToStr(d, 2));
        }
   Var_RiskPercent = StrToDouble(Edit_Risk.Text());
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAppPanel::Edit_SL_EndEdit(void)
  {
   Var_StopLoss = StrToInteger(Edit_SL.Text());
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAppPanel::OnClickButton_Buy(void)
  {
   if((Var_RiskPercent > 0) && (Var_StopLoss > 0))
     {
      OpenOrder(OP_BUY, Ask);
     }
   else
     {
      Alert("Error: 'Risk'/'StopLoss' value cannot be 0");
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAppPanel::OnClickButton_Sell(void)
  {
   if((Var_RiskPercent > 0) && (Var_StopLoss > 0))
     {
      OpenOrder(OP_SELL, Bid);
     }
   else
     {
      Alert("Error: 'Risk'/'StopLoss' value cannot be 0");
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAppPanel::OnClickEditButton_Up(void)
  {
   double d;
   d = StrToDouble(Edit_Risk.Text()) + 0.1;
   if(d > In_SpinEdit_MaxValue)
     {
      Edit_Risk.Text(DoubleToStr(In_SpinEdit_MaxValue, 2));
     }
   else
      if(d < 0.00)
        {
         Edit_Risk.Text(DoubleToStr(0.00, 2));
        }
      else
        {
         Edit_Risk.Text(DoubleToStr(d, 2));
        }
   Var_RiskPercent = StrToDouble(Edit_Risk.Text());
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAppPanel::OnClickEditButton_Down(void)
  {
   double d;
   d = StrToDouble(Edit_Risk.Text()) - 0.1;
   if(d > In_SpinEdit_MaxValue)
     {
      Edit_Risk.Text(DoubleToStr(In_SpinEdit_MaxValue, 2));
     }
   else
      if(d < 0.00)
        {
         Edit_Risk.Text(DoubleToStr(0.00, 2));
        }
      else
        {
         Edit_Risk.Text(DoubleToStr(d, 2));
        }
  }
//+------------------------------------------------------------------+
