//+------------------------------------------------------------------+
//|                                                      Manager.mq4 |
//|                                                           Alexey |
//+------------------------------------------------------------------+
#property copyright "Alexey"
#property link      ""
#property version   "2.01"
#property strict

#include <Controls\Defines.mqh>
#undef CONTROLS_FONT_SIZE
#define CONTROLS_FONT_SIZE In_FontSizeGeneral
#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>
#include <Controls\Edit.mqh>
#include <Controls\Label.mqh>
#include <Controls\BmpButton.mqh>

enum EN_IProfit
  {
   enFree                   = 0, //Free Margin
   enBalance                = 1, //Balance
   enEquity                 = 2  //Equity
  };

enum EN_ISafe
  {
   enSafe1                  = 1, //1 Order
   enSafe2                  = 2, //2 Order
   enSafe3                  = 3  //3 Order
  };

enum EN_ChartTheme
  {
   enOffTheme               = 0, //Off (Don't use theme)
   enLightTheme             = 1, //Light theme
   enDarkTheme              = 2  //Dark theme
  };

enum EN_CalcResult
  {
   enForAllSymbol           = 0, //For all symbols
   enByCurrSymbol           = 1, //By current symbol
  };

sinput string dlm_1                             = "========== Trading panel settings ==========";//========== #1 ==========
input int In_SpinEdit_MaxValue                    = 5;              //Max risk value, %
input EN_IProfit In_IProfit                       = 0;              //Percentage calculation ...
input EN_ISafe In_ISafe                           = 1;              //Number of orders for "safe" ...
sinput string dlm_2                             = "========== Information panel settings ==========";//========== #2 ==========
input EN_CalcResult In_CalcResult                 = 0;              //Calculation of results ...
sinput string dlm_3                             = "========== Interface settings ==========";//========== #3 ==========
input int In_FontSizeGeneral                      = 10;             //Labels font size
input color In_ColorBuy                           = clrDarkGreen;   //Button color "BUY"
input color In_ColorSell                          = clrOrangeRed;   //Button color "SELL"
input color In_ColorFont                          = clrWhite;       //Button font color
input EN_ChartTheme In_ChartColors                = 0;              //Сolor theme chart
sinput string dlm_4                             = "========== Other settings ==========";//========== #4 ==========
input int Slippage                                = 3;              //Slippage
input int Magic                                   = 29081996;       //Magic

string Date_license = "";
string SymbolOfCurrency = "";

double Var_RiskPercent = 0.00;
int Var_StopLoss = 0;
double Var_Lots = 0.00;

int X_Button = 100;
int Y_Button = 50;

int X_Panel = 5;
int Y_Panel = 20;
int W_Panel = X_Panel + X_Button + 98;
int H_Panel = Y_Panel + Y_Button * 2 + 43;

int X_PanelInfo = 5;
int Y_PanelInfo = Y_Panel + H_Panel;
int W_PanelInfo = W_Panel + (W_Panel / 2);
int H_PanelInfo = Y_PanelInfo + 210;

int X1_PanelInfo = 5;
int X2_PanelInfo = 115;
int X3_PanelInfo = 215;

int Y1_PanelInfo = 20;
int Y2_PanelInfo = 40;
int Y3_PanelInfo = 60;
int Y4_PanelInfo = 80;
int Y5_PanelInfo = 100;
int Y6_PanelInfo = 120;
int Y7_PanelInfo = 140;


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
   CButton           Button_D;
   CButton           Button_W;
   CButton           Button_M;

   CLabel            Label_Result;
   CLabel            Label_Currency;
   CLabel            Label_Percent;

   CLabel            Label_info_01;
   CLabel            Label_info_02;
   CLabel            Label_info_03;
   CLabel            Label_info_04;
   CLabel            Label_info_05;
   CLabel            Label_info_06;
   CLabel            Label_info_07;

   CLabel            Label_info_11;
   CLabel            Label_info_12;
   CLabel            Label_info_13;
   CLabel            Label_info_14;
   CLabel            Label_info_15;
   CLabel            Label_info_16;
   CLabel            Label_info_17;

   CLabel            Label_info_21;
   CLabel            Label_info_22;
   CLabel            Label_info_23;
   CLabel            Label_info_24;
   CLabel            Label_info_25;
   CLabel            Label_info_26;
   CLabel            Label_info_27;
public:
                     CAppPanelInfo(void);
                    ~CAppPanelInfo(void);
   virtual bool      Create(const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2);
   virtual bool      OnEvent(const int id, const long &lparam, const double &dparam, const string &sparam);
protected:
   virtual void      Minimize(void);
   virtual color     GetColorProfit(double n);
   virtual void      GetProfit(ENUM_TIMEFRAMES tf);
   virtual void      TotalProfit(ENUM_TIMEFRAMES tf, int in_sym, double &ProfitValue1, double &ProfitValue2, double &ProfitValue3, double &ProfitValue4, double &ProfitValue5, double &ProfitValue6, double &ProfitValue7, double &ChangeDeposits1, double &ChangeDeposits2, double &ChangeDeposits3, double &ChangeDeposits4, double &ChangeDeposits5, double &ChangeDeposits6, double &ChangeDeposits7);
   virtual void      SetInfoPanel(ENUM_TIMEFRAMES tf, double &vc1, double &vc2, double &vc3, double &vc4, double &vc5, double &vc6, double &vc7, double & vp1, double &vp2, double &vp3, double &vp4, double &vp5, double &vp6, double &vp7);

   bool              CreateButton_D(void);
   bool              CreateButton_W(void);
   bool              CreateButton_M(void);

   bool              CreateLabel_Result(void);
   bool              CreateLabel_Currency(void);
   bool              CreateLabel_Percent(void);

   bool              CreateLabel_info_01(void);
   bool              CreateLabel_info_02(void);
   bool              CreateLabel_info_03(void);
   bool              CreateLabel_info_04(void);
   bool              CreateLabel_info_05(void);
   bool              CreateLabel_info_06(void);
   bool              CreateLabel_info_07(void);

   bool              CreateLabel_info_11(void);
   bool              CreateLabel_info_12(void);
   bool              CreateLabel_info_13(void);
   bool              CreateLabel_info_14(void);
   bool              CreateLabel_info_15(void);
   bool              CreateLabel_info_16(void);
   bool              CreateLabel_info_17(void);

   bool              CreateLabel_info_21(void);
   bool              CreateLabel_info_22(void);
   bool              CreateLabel_info_23(void);
   bool              CreateLabel_info_24(void);
   bool              CreateLabel_info_25(void);
   bool              CreateLabel_info_26(void);
   bool              CreateLabel_info_27(void);


   void              OnClickButton_D(void);
   void              OnClickButton_W(void);
   void              OnClickButton_M(void);
  };


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
EVENT_MAP_BEGIN(CAppPanelInfo)
ON_NAMED_EVENT(ON_CLICK, Button_D, OnClickButton_D)
ON_NAMED_EVENT(ON_CLICK, Button_W, OnClickButton_W)
ON_NAMED_EVENT(ON_CLICK, Button_M, OnClickButton_M)
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
   if(!CreateButton_D())
      return(false);
   if(!CreateButton_W())
      return(false);
   if(!CreateButton_M())
      return(false);
   if(!CreateLabel_Result())
      return(false);
   if(!CreateLabel_Currency())
      return(false);
   if(!CreateLabel_Percent())
      return(false);
   if(!CreateLabel_info_01())
      return(false);
   if(!CreateLabel_info_02())
      return(false);
   if(!CreateLabel_info_03())
      return(false);
   if(!CreateLabel_info_04())
      return(false);
   if(!CreateLabel_info_05())
      return(false);
   if(!CreateLabel_info_06())
      return(false);
   if(!CreateLabel_info_07())
      return(false);
   if(!CreateLabel_info_11())
      return(false);
   if(!CreateLabel_info_12())
      return(false);
   if(!CreateLabel_info_13())
      return(false);
   if(!CreateLabel_info_14())
      return(false);
   if(!CreateLabel_info_15())
      return(false);
   if(!CreateLabel_info_16())
      return(false);
   if(!CreateLabel_info_17())
      return(false);
   if(!CreateLabel_info_21())
      return(false);
   if(!CreateLabel_info_22())
      return(false);
   if(!CreateLabel_info_23())
      return(false);
   if(!CreateLabel_info_24())
      return(false);
   if(!CreateLabel_info_25())
      return(false);
   if(!CreateLabel_info_26())
      return(false);
   if(!CreateLabel_info_27())
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
   Date_license = "17.04.2022";
   if(TimeCurrent() > StrToTime(Date_license))
     {
      Alert("License has expired");
      ExpertRemove();
     }
   if(AccountNumber() != 250404118)
     {
      Alert("This account is not allowed to use");
      ExpertRemove();
     }
//
   if(AccountInfoString(ACCOUNT_CURRENCY) == "USD")
     {
      SymbolOfCurrency = "$";
     }
   else
      if(AccountInfoString(ACCOUNT_CURRENCY) == "EUR")
        {
         SymbolOfCurrency = "€";
        }
      else
         if(AccountInfoString(ACCOUNT_CURRENCY) == "RUR")
           {
            SymbolOfCurrency = "₽";
           }
         else
           {
            SymbolOfCurrency = "";
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
      ChartSetInteger(0, CHART_FOREGROUND, false);
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
      ChartSetInteger(0, CHART_FOREGROUND, false);
     }
//
   Comment("");
//
   ObjectCreate(0, "Date_license", OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, "Date_license", OBJPROP_XDISTANCE, 100);
   ObjectSetInteger(0, "Date_license", OBJPROP_YDISTANCE, 15);
   ObjectSetInteger(0, "Date_license", OBJPROP_CORNER, CORNER_RIGHT_UPPER);
   ObjectSetString(0, "Date_license", OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, "Date_license", OBJPROP_FONTSIZE, In_FontSizeGeneral - 2);
   ObjectSetInteger(0, "Date_license", OBJPROP_COLOR, ChartGetInteger(0, CHART_COLOR_FOREGROUND, 0));
   ObjectSetInteger(0, "Date_license", OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, "Date_license", OBJPROP_SELECTED, false);
   ObjectSetInteger(0, "Date_license", OBJPROP_HIDDEN, true);
   ObjectSetString(0, "Date_license", OBJPROP_TEXT, "License " + Date_license);
//
   ChartRedraw();
//
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
//
   Comment("");
//
   ObjectDelete(0, "Date_license");
//
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
datetime GetDateTF(ENUM_TIMEFRAMES tf, int shift)
  {
   MqlDateTime str1;
   TimeCurrent(str1);
//
   str1.hour = 0;
   str1.min = 0;
   str1.sec = 0;
//
   if(tf == PERIOD_MN1)
     {
      str1.day = 1;
      str1.mon = str1.mon - shift;
      if(str1.mon < 1)
        {
         str1.year = str1.year - 1;
         str1.mon = 12 + str1.mon;
        }
     }
//
   datetime dt1 = StructToTime(str1);
//
   if(tf == PERIOD_D1)
     {
      dt1 = dt1 - PeriodSeconds(tf) * shift;
     }
//
   if(tf == PERIOD_W1)
     {
      dt1 = dt1 - (PeriodSeconds(tf) * shift) - PeriodSeconds(PERIOD_W1);
     }
//
   return(dt1);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAppPanelInfo::TotalProfit(ENUM_TIMEFRAMES tf, int in_sym, double &ProfitValue1, double &ProfitValue2, double &ProfitValue3, double &ProfitValue4, double &ProfitValue5, double &ProfitValue6, double &ProfitValue7, double &ChangeDeposits1, double &ChangeDeposits2, double &ChangeDeposits3, double &ChangeDeposits4, double &ChangeDeposits5, double &ChangeDeposits6, double &ChangeDeposits7)
  {
   int PS = 0;
   if(tf == PERIOD_W1)
     {
      PS = PeriodSeconds(PERIOD_D1);
     }
//
   for(int i = 0; i < OrdersHistoryTotal(); i++)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
        {
         if(in_sym == 0)
           {
            if(OrderCloseTime() >= GetDateTF(tf, 0) + PS)
               if(OrderType() <= 5)
                  ProfitValue1 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
               else
                  ChangeDeposits1 += NormalizeDouble(OrderProfit(), 2);
            if(OrderCloseTime() >= GetDateTF(tf, 1) + PS && OrderCloseTime() < GetDateTF(tf, 0) + PS)
               if(OrderType() <= 5)
                  ProfitValue2 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
               else
                  ChangeDeposits2 += NormalizeDouble(OrderProfit(), 2);
            if(OrderCloseTime() >= GetDateTF(tf, 2) + PS && OrderCloseTime() < GetDateTF(tf, 1) + PS)
               if(OrderType() <= 5)
                  ProfitValue3 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
               else
                  ChangeDeposits3 += NormalizeDouble(OrderProfit(), 2);
            if(OrderCloseTime() >= GetDateTF(tf, 3) + PS && OrderCloseTime() < GetDateTF(tf, 2) + PS)
               if(OrderType() <= 5)
                  ProfitValue4 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
               else
                  ChangeDeposits4 += NormalizeDouble(OrderProfit(), 2);
            if(OrderCloseTime() >= GetDateTF(tf, 4) + PS && OrderCloseTime() < GetDateTF(tf, 3) + PS)
               if(OrderType() <= 5)
                  ProfitValue5 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
               else
                  ChangeDeposits5 += NormalizeDouble(OrderProfit(), 2);
            if(OrderCloseTime() >= GetDateTF(tf, 5) + PS && OrderCloseTime() < GetDateTF(tf, 4) + PS)
               if(OrderType() <= 5)
                  ProfitValue6 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
               else
                  ChangeDeposits6 += NormalizeDouble(OrderProfit(), 2);
            if(OrderCloseTime() >= GetDateTF(tf, 6) + PS && OrderCloseTime() < GetDateTF(tf, 5) + PS)
               if(OrderType() <= 5)
                  ProfitValue7 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
               else
                  ChangeDeposits7 += NormalizeDouble(OrderProfit(), 2);
           }
         else
            if(in_sym == 1)
              {
               if(OrderCloseTime() >= GetDateTF(tf, 0) + PS)
                  if(OrderType() <= 5)
                    {
                     if(OrderSymbol() == Symbol())
                       {
                        ProfitValue1 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
                       }
                    }
                  else
                     ChangeDeposits1 += NormalizeDouble(OrderProfit(), 2);
               if(OrderCloseTime() >= GetDateTF(tf, 1) + PS && OrderCloseTime() < GetDateTF(tf, 0) + PS)
                  if(OrderType() <= 5)
                     if(OrderSymbol() == Symbol())
                       {
                          {
                           ProfitValue2 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
                          }
                       }
                     else
                        ChangeDeposits2 += NormalizeDouble(OrderProfit(), 2);
               if(OrderCloseTime() >= GetDateTF(tf, 2) + PS && OrderCloseTime() < GetDateTF(tf, 1) + PS)
                  if(OrderType() <= 5)
                     if(OrderSymbol() == Symbol())
                       {
                          {
                           ProfitValue3 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
                          }
                       }
                     else
                        ChangeDeposits3 += NormalizeDouble(OrderProfit(), 2);
               if(OrderCloseTime() >= GetDateTF(tf, 3) + PS && OrderCloseTime() < GetDateTF(tf, 2) + PS)
                  if(OrderType() <= 5)
                     if(OrderSymbol() == Symbol())
                       {
                          {
                           ProfitValue4 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
                          }
                       }
                     else
                        ChangeDeposits4 += NormalizeDouble(OrderProfit(), 2);
               if(OrderCloseTime() >= GetDateTF(tf, 4) + PS && OrderCloseTime() < GetDateTF(tf, 3) + PS)
                  if(OrderType() <= 5)
                     if(OrderSymbol() == Symbol())
                       {
                          {
                           ProfitValue5 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
                          }
                       }
                     else
                        ChangeDeposits5 += NormalizeDouble(OrderProfit(), 2);
               if(OrderCloseTime() >= GetDateTF(tf, 5) + PS && OrderCloseTime() < GetDateTF(tf, 4) + PS)
                  if(OrderType() <= 5)
                     if(OrderSymbol() == Symbol())
                       {
                          {
                           ProfitValue6 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
                          }
                       }
                     else
                        ChangeDeposits6 += NormalizeDouble(OrderProfit(), 2);
               if(OrderCloseTime() >= GetDateTF(tf, 6) + PS && OrderCloseTime() < GetDateTF(tf, 5) + PS)
                  if(OrderType() <= 5)
                     if(OrderSymbol() == Symbol())
                       {
                          {
                           ProfitValue7 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
                          }
                       }
                     else
                        ChangeDeposits7 += NormalizeDouble(OrderProfit(), 2);
              }
        }
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAppPanelInfo::GetProfit(ENUM_TIMEFRAMES tf)
  {
   double ProfitValue1 = 0.0;
   double ProfitValue2 = 0.0;
   double ProfitValue3 = 0.0;
   double ProfitValue4 = 0.0;
   double ProfitValue5 = 0.0;
   double ProfitValue6 = 0.0;
   double ProfitValue7 = 0.0;
//
   double ChangeDeposits1 = 0.0;
   double ChangeDeposits2 = 0.0;
   double ChangeDeposits3 = 0.0;
   double ChangeDeposits4 = 0.0;
   double ChangeDeposits5 = 0.0;
   double ChangeDeposits6 = 0.0;
   double ChangeDeposits7 = 0.0;
//
   TotalProfit(tf, 0, ProfitValue1, ProfitValue2, ProfitValue3, ProfitValue4, ProfitValue5, ProfitValue6, ProfitValue7, ChangeDeposits1, ChangeDeposits2, ChangeDeposits3, ChangeDeposits4, ChangeDeposits5, ChangeDeposits6, ChangeDeposits7);
//
   double InitialDeposit1 = NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE) - ChangeDeposits1 - ProfitValue1, 2);
   double InitialDeposit2 = NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE) - ChangeDeposits1 - ChangeDeposits2 - ProfitValue1 - ProfitValue2, 2);
   double InitialDeposit3 = NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE) - ChangeDeposits1 - ChangeDeposits2 - ChangeDeposits3 - ProfitValue1 - ProfitValue2 - ProfitValue3, 2);
   double InitialDeposit4 = NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE) - ChangeDeposits1 - ChangeDeposits2 - ChangeDeposits3 - ChangeDeposits4 - ProfitValue1 - ProfitValue2 - ProfitValue3 - ProfitValue4, 2);
   double InitialDeposit5 = NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE) - ChangeDeposits1 - ChangeDeposits2 - ChangeDeposits3 - ChangeDeposits4 - ChangeDeposits5 - ProfitValue1 - ProfitValue2 - ProfitValue3 - ProfitValue4 - ProfitValue5, 2);
   double InitialDeposit6 = NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE) - ChangeDeposits1 - ChangeDeposits2 - ChangeDeposits3 - ChangeDeposits4 - ChangeDeposits5 - ChangeDeposits6 - ProfitValue1 - ProfitValue2 - ProfitValue3 - ProfitValue4 - ProfitValue5 - ProfitValue6, 2);
   double InitialDeposit7 = NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE) - ChangeDeposits1 - ChangeDeposits2 - ChangeDeposits3 - ChangeDeposits4 - ChangeDeposits5 - ChangeDeposits6 - ChangeDeposits7 - ProfitValue1 - ProfitValue2 - ProfitValue3 - ProfitValue4 - ProfitValue5 - ProfitValue6 - ProfitValue7, 2);
//
   if(In_CalcResult == 1)
     {
      ProfitValue1 = 0.0;
      ProfitValue2 = 0.0;
      ProfitValue3 = 0.0;
      ProfitValue4 = 0.0;
      ProfitValue5 = 0.0;
      ProfitValue6 = 0.0;
      ProfitValue7 = 0.0;
      //
      ChangeDeposits1 = 0.0;
      ChangeDeposits2 = 0.0;
      ChangeDeposits3 = 0.0;
      ChangeDeposits4 = 0.0;
      ChangeDeposits5 = 0.0;
      ChangeDeposits6 = 0.0;
      ChangeDeposits7 = 0.0;
      //
      TotalProfit(tf, 1, ProfitValue1, ProfitValue2, ProfitValue3, ProfitValue4, ProfitValue5, ProfitValue6, ProfitValue7, ChangeDeposits1, ChangeDeposits2, ChangeDeposits3, ChangeDeposits4, ChangeDeposits5, ChangeDeposits6, ChangeDeposits7);
     }
//
   double ProfitValue1_percent = 0.0;
   double ProfitValue2_percent = 0.0;
   double ProfitValue3_percent = 0.0;
   double ProfitValue4_percent = 0.0;
   double ProfitValue5_percent = 0.0;
   double ProfitValue6_percent = 0.0;
   double ProfitValue7_percent = 0.0;
//
   if(InitialDeposit1 > 0)
     {
      ProfitValue1_percent = NormalizeDouble(ProfitValue1 / InitialDeposit1 * 100, 3);
     }
   if(InitialDeposit2 > 0)
     {
      ProfitValue2_percent = NormalizeDouble(ProfitValue2 / InitialDeposit2 * 100, 3);
     }
   if(InitialDeposit3 > 0)
     {
      ProfitValue3_percent = NormalizeDouble(ProfitValue3 / InitialDeposit3 * 100, 3);
     }
   if(InitialDeposit4 > 0)
     {
      ProfitValue4_percent = NormalizeDouble(ProfitValue4 / InitialDeposit4 * 100, 3);
     }
   if(InitialDeposit5 > 0)
     {
      ProfitValue5_percent = NormalizeDouble(ProfitValue5 / InitialDeposit5 * 100, 3);
     }
   if(InitialDeposit6 > 0)
     {
      ProfitValue6_percent = NormalizeDouble(ProfitValue6 / InitialDeposit6 * 100, 3);
     }
   if(InitialDeposit7 > 0)
     {
      ProfitValue7_percent = NormalizeDouble(ProfitValue7 / InitialDeposit7 * 100, 3);
     }
//
   SetInfoPanel(tf, ProfitValue1, ProfitValue2, ProfitValue3, ProfitValue4, ProfitValue5, ProfitValue6, ProfitValue7, ProfitValue1_percent, ProfitValue2_percent, ProfitValue3_percent, ProfitValue4_percent, ProfitValue5_percent, ProfitValue6_percent, ProfitValue7_percent);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
color CAppPanelInfo::GetColorProfit(double n)
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
string NameOfMonth(const datetime time)
  {
   MqlDateTime dt;
   string month = "";
   TimeToStruct(time, dt);
   switch(dt.mon)
     {
      case 1:
         month = "January";
         break;
      case 2:
         month = "February";
         break;
      case 3:
         month = "March";
         break;
      case 4:
         month = "April";
         break;
      case 5:
         month = "May";
         break;
      case 6:
         month = "June";
         break;
      case 7:
         month = "July";
         break;
      case 8:
         month = "August";
         break;
      case 9:
         month = "September";
         break;
      case 10:
         month = "October";
         break;
      case 11:
         month = "November";
         break;
      default:
         month = "December";
         break;
     }
//---
   return month;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string NumberOfMonth(const datetime time)
  {
   MqlDateTime dt;
   string Month = "";
   TimeToStruct(time, dt);
   Month = IntegerToString(dt.mon, 2, '0');
//---
   return Month;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string DayOfWeek(const datetime time)
  {
   MqlDateTime dt;
   string day = "";
   TimeToStruct(time, dt);
   switch(dt.day_of_week)
     {
      case 0:
         day = "Sunday";
         break;
      case 1:
         day = "Monday";
         break;
      case 2:
         day = "Tuesday";
         break;
      case 3:
         day = "Wednesday";
         break;
      case 4:
         day = "Thursday";
         break;
      case 5:
         day = "Friday";
         break;
      default:
         day = "Saturday";
         break;
     }
//---
   return day;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string NumberOfDay(const datetime time)
  {
   MqlDateTime dt;
   string day = "";
   TimeToStruct(time, dt);
   day = IntegerToString(dt.day, 2, '0');
//---
   return day;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string NumberOfWeeks(const datetime time)
  {
   MqlDateTime dt;
   string Weeks = "";
   TimeToStruct(time, dt);
   Weeks = IntegerToString(dt.day, 2, '0') + "." + IntegerToString(dt.mon, 2, '0');
//---
   return Weeks;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string GetSymbolPlus(double n, int n2)
  {
   string NPlus = DoubleToString(n, n2);
   if(n > 0)
      NPlus = "+" + NPlus;
   return(NPlus);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAppPanelInfo::SetInfoPanel(ENUM_TIMEFRAMES tf, double &vc1, double &vc2, double &vc3, double &vc4, double &vc5, double &vc6, double &vc7, double & vp1, double &vp2, double &vp3, double &vp4, double &vp5, double &vp6, double &vp7)
  {
   if(tf == PERIOD_D1)
     {
      Label_info_01.Text(NumberOfDay(GetDateTF(tf, 0)) + "| " + DayOfWeek(GetDateTF(tf, 0)));
      Label_info_02.Text(NumberOfDay(GetDateTF(tf, 1)) + "| " + DayOfWeek(GetDateTF(tf, 1)));
      Label_info_03.Text(NumberOfDay(GetDateTF(tf, 2)) + "| " + DayOfWeek(GetDateTF(tf, 2)));
      Label_info_04.Text(NumberOfDay(GetDateTF(tf, 3)) + "| " + DayOfWeek(GetDateTF(tf, 3)));
      Label_info_05.Text(NumberOfDay(GetDateTF(tf, 4)) + "| " + DayOfWeek(GetDateTF(tf, 4)));
      Label_info_06.Text(NumberOfDay(GetDateTF(tf, 5)) + "| " + DayOfWeek(GetDateTF(tf, 5)));
      Label_info_07.Text(NumberOfDay(GetDateTF(tf, 6)) + "| " + DayOfWeek(GetDateTF(tf, 6)));
     }
   if(tf == PERIOD_W1)
     {
      Label_info_01.Text(NumberOfWeeks(GetDateTF(tf, 0) + PeriodSeconds(PERIOD_D1)) + " - " + NumberOfWeeks(GetDateTF(PERIOD_D1, 0)));
      Label_info_02.Text(NumberOfWeeks(GetDateTF(tf, 1) + PeriodSeconds(PERIOD_D1)) + " - " + NumberOfWeeks(GetDateTF(tf, 0)));
      Label_info_03.Text(NumberOfWeeks(GetDateTF(tf, 2) + PeriodSeconds(PERIOD_D1)) + " - " + NumberOfWeeks(GetDateTF(tf, 1)));
      Label_info_04.Text(NumberOfWeeks(GetDateTF(tf, 3) + PeriodSeconds(PERIOD_D1)) + " - " + NumberOfWeeks(GetDateTF(tf, 2)));
      Label_info_05.Text(NumberOfWeeks(GetDateTF(tf, 4) + PeriodSeconds(PERIOD_D1)) + " - " + NumberOfWeeks(GetDateTF(tf, 3)));
      Label_info_06.Text(NumberOfWeeks(GetDateTF(tf, 5) + PeriodSeconds(PERIOD_D1)) + " - " + NumberOfWeeks(GetDateTF(tf, 4)));
      Label_info_07.Text(NumberOfWeeks(GetDateTF(tf, 6) + PeriodSeconds(PERIOD_D1)) + " - " + NumberOfWeeks(GetDateTF(tf, 5)));
     }
   if(tf == PERIOD_MN1)
     {
      Label_info_01.Text(NumberOfMonth(GetDateTF(tf, 0)) + "| " + NameOfMonth(GetDateTF(tf, 0)));
      Label_info_02.Text(NumberOfMonth(GetDateTF(tf, 1)) + "| " + NameOfMonth(GetDateTF(tf, 1)));
      Label_info_03.Text(NumberOfMonth(GetDateTF(tf, 2)) + "| " + NameOfMonth(GetDateTF(tf, 2)));
      Label_info_04.Text(NumberOfMonth(GetDateTF(tf, 3)) + "| " + NameOfMonth(GetDateTF(tf, 3)));
      Label_info_05.Text(NumberOfMonth(GetDateTF(tf, 4)) + "| " + NameOfMonth(GetDateTF(tf, 4)));
      Label_info_06.Text(NumberOfMonth(GetDateTF(tf, 5)) + "| " + NameOfMonth(GetDateTF(tf, 5)));
      Label_info_07.Text(NumberOfMonth(GetDateTF(tf, 6)) + "| " + NameOfMonth(GetDateTF(tf, 6)));
     }
//
   Label_info_11.Text(GetSymbolPlus(vc1, 2) + " " + SymbolOfCurrency);
   Label_info_12.Text(GetSymbolPlus(vc2, 2) + " " + SymbolOfCurrency);
   Label_info_13.Text(GetSymbolPlus(vc3, 2) + " " + SymbolOfCurrency);
   Label_info_14.Text(GetSymbolPlus(vc4, 2) + " " + SymbolOfCurrency);
   Label_info_15.Text(GetSymbolPlus(vc5, 2) + " " + SymbolOfCurrency);
   Label_info_16.Text(GetSymbolPlus(vc6, 2) + " " + SymbolOfCurrency);
   Label_info_17.Text(GetSymbolPlus(vc7, 2) + " " + SymbolOfCurrency);
//
   Label_info_21.Text(GetSymbolPlus(vp1, 3) + "%");
   Label_info_22.Text(GetSymbolPlus(vp2, 3) + "%");
   Label_info_23.Text(GetSymbolPlus(vp3, 3) + "%");
   Label_info_24.Text(GetSymbolPlus(vp4, 3) + "%");
   Label_info_25.Text(GetSymbolPlus(vp5, 3) + "%");
   Label_info_26.Text(GetSymbolPlus(vp6, 3) + "%");
   Label_info_27.Text(GetSymbolPlus(vp7, 3) + "%");
//
   Label_info_11.Color(GetColorProfit(vc1));
   Label_info_12.Color(GetColorProfit(vc2));
   Label_info_13.Color(GetColorProfit(vc3));
   Label_info_14.Color(GetColorProfit(vc4));
   Label_info_15.Color(GetColorProfit(vc5));
   Label_info_16.Color(GetColorProfit(vc6));
   Label_info_17.Color(GetColorProfit(vc7));
//
   Label_info_21.Color(GetColorProfit(vp1));
   Label_info_22.Color(GetColorProfit(vp2));
   Label_info_23.Color(GetColorProfit(vp3));
   Label_info_24.Color(GetColorProfit(vp4));
   Label_info_25.Color(GetColorProfit(vp5));
   Label_info_26.Color(GetColorProfit(vp6));
   Label_info_27.Color(GetColorProfit(vp7));
//
   ChartRedraw();
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAppPanelInfo::OnClickButton_D(void)
  {
   GetProfit(PERIOD_D1);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAppPanelInfo::OnClickButton_W(void)
  {
   GetProfit(PERIOD_W1);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAppPanelInfo::OnClickButton_M(void)
  {
   GetProfit(PERIOD_MN1);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateButton_D(void)
  {
   int x1 = 0;
   int y1 = 0;
   int x2 = x1 + ((W_PanelInfo - 13) / 3);
   int y2 = y1 + 20;
   if(!Button_D.Create(0, "Button_D", 0, x1, y1, x2, y2))
      return(false);
   if(!Button_D.Text("Day"))
      return(false);
   if(!Button_D.Font("Arial Black"))
      return(false);
   if(!Button_D.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Button_D))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateButton_W(void)
  {
   int x1 = Button_D.Width();
   int y1 = 0;
   int x2 = x1 + ((W_PanelInfo - 13) / 3);
   int y2 = y1 + 20;
   if(!Button_W.Create(0, "Button_W", 0, x1, y1, x2, y2))
      return(false);
   if(!Button_W.Text("Week"))
      return(false);
   if(!Button_W.Font("Arial Black"))
      return(false);
   if(!Button_W.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Button_W))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateButton_M(void)
  {
   int x1 = Button_D.Width() * 2;
   int y1 = 0;
   int x2 = x1 + ((W_PanelInfo - 13) / 3);
   int y2 = y1 + 20;
   if(!Button_M.Create(0, "Button_M", 0, x1, y1, x2, y2))
      return(false);
   if(!Button_M.Text("Month"))
      return(false);
   if(!Button_M.Font("Arial Black"))
      return(false);
   if(!Button_M.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Button_M))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_Result(void)
  {
   int x1 = X1_PanelInfo;
   int y1 = Button_D.Height() + 2;
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
   int y1 = Button_D.Height() + 2;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_Currency.Create(0, "Label_Currency", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_Currency.Text("Currency"))
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
   int y1 = Button_D.Height() + 2;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_Percent.Create(0, "Label_Percent", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_Percent.Text("Percent"))
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
bool CAppPanelInfo::CreateLabel_info_01(void)
  {
   int x1 = X1_PanelInfo;
   int y1 = Y1_PanelInfo + Button_D.Height();
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_01.Create(0, "Label_info_01", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_01.Text("Time frame"))
      return(false);
   if(!Label_info_01.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_01))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_info_02(void)
  {
   int x1 = X1_PanelInfo;
   int y1 = Y2_PanelInfo + Button_D.Height();
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_02.Create(0, "Label_info_02", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_02.Text("Time frame"))
      return(false);
   if(!Label_info_02.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_02))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_info_03(void)
  {
   int x1 = X1_PanelInfo;
   int y1 = Y3_PanelInfo + Button_D.Height();
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_03.Create(0, "Label_info_03", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_03.Text("Time frame"))
      return(false);
   if(!Label_info_03.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_03))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_info_04(void)
  {
   int x1 = X1_PanelInfo;
   int y1 = Y4_PanelInfo + Button_D.Height();
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_04.Create(0, "Label_info_04", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_04.Text("Time frame"))
      return(false);
   if(!Label_info_04.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_04))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_info_05(void)
  {
   int x1 = X1_PanelInfo;
   int y1 = Y5_PanelInfo + Button_D.Height();
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_05.Create(0, "Label_info_05", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_05.Text("Time frame"))
      return(false);
   if(!Label_info_05.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_05))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_info_06(void)
  {
   int x1 = X1_PanelInfo;
   int y1 = Y6_PanelInfo + Button_D.Height();
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_06.Create(0, "Label_info_06", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_06.Text("Time frame"))
      return(false);
   if(!Label_info_06.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_06))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_info_07(void)
  {
   int x1 = X1_PanelInfo;
   int y1 = Y7_PanelInfo + Button_D.Height();
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_07.Create(0, "Label_info_07", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_07.Text("Time frame"))
      return(false);
   if(!Label_info_07.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_07))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_info_11(void)
  {
   int x1 = X2_PanelInfo;
   int y1 = Y1_PanelInfo + Button_D.Height();
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_11.Create(0, "Label_info_11", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_11.Text(AccountInfoString(ACCOUNT_CURRENCY)))
      return(false);
   if(!Label_info_11.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_11))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_info_12(void)
  {
   int x1 = X2_PanelInfo;
   int y1 = Y2_PanelInfo + Button_D.Height();
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_12.Create(0, "Label_info_12", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_12.Text(AccountInfoString(ACCOUNT_CURRENCY)))
      return(false);
   if(!Label_info_12.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_12))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_info_13(void)
  {
   int x1 = X2_PanelInfo;
   int y1 = Y3_PanelInfo + Button_D.Height();
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_13.Create(0, "Label_info_13", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_13.Text(AccountInfoString(ACCOUNT_CURRENCY)))
      return(false);
   if(!Label_info_13.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_13))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_info_14(void)
  {
   int x1 = X2_PanelInfo;
   int y1 = Y4_PanelInfo + Button_D.Height();
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_14.Create(0, "Label_info_14", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_14.Text(AccountInfoString(ACCOUNT_CURRENCY)))
      return(false);
   if(!Label_info_14.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_14))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_info_15(void)
  {
   int x1 = X2_PanelInfo;
   int y1 = Y5_PanelInfo + Button_D.Height();
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_15.Create(0, "Label_info_15", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_15.Text(AccountInfoString(ACCOUNT_CURRENCY)))
      return(false);
   if(!Label_info_15.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_15))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_info_16(void)
  {
   int x1 = X2_PanelInfo;
   int y1 = Y6_PanelInfo + Button_D.Height();
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_16.Create(0, "Label_info_16", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_16.Text(AccountInfoString(ACCOUNT_CURRENCY)))
      return(false);
   if(!Label_info_16.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_16))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_info_17(void)
  {
   int x1 = X2_PanelInfo;
   int y1 = Y7_PanelInfo + Button_D.Height();
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_17.Create(0, "Label_info_17", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_17.Text(AccountInfoString(ACCOUNT_CURRENCY)))
      return(false);
   if(!Label_info_17.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_17))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_info_21(void)
  {
   int x1 = X3_PanelInfo;
   int y1 = Y1_PanelInfo + Button_D.Height();
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_21.Create(0, "Label_info_21", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_21.Text("%"))
      return(false);
   if(!Label_info_21.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_21))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_info_22(void)
  {
   int x1 = X3_PanelInfo;
   int y1 = Y2_PanelInfo + Button_D.Height();
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_22.Create(0, "Label_info_22", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_22.Text("%"))
      return(false);
   if(!Label_info_22.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_22))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_info_23(void)
  {
   int x1 = X3_PanelInfo;
   int y1 = Y3_PanelInfo + Button_D.Height();
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_23.Create(0, "Label_info_23", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_23.Text("%"))
      return(false);
   if(!Label_info_23.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_23))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_info_24(void)
  {
   int x1 = X3_PanelInfo;
   int y1 = Y4_PanelInfo + Button_D.Height();
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_24.Create(0, "Label_info_24", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_24.Text("%"))
      return(false);
   if(!Label_info_24.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_24))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_info_25(void)
  {
   int x1 = X3_PanelInfo;
   int y1 = Y5_PanelInfo + Button_D.Height();
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_25.Create(0, "Label_info_25", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_25.Text("%"))
      return(false);
   if(!Label_info_25.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_25))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_info_26(void)
  {
   int x1 = X3_PanelInfo;
   int y1 = Y6_PanelInfo + Button_D.Height();
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_26.Create(0, "Label_info_26", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_26.Text("%"))
      return(false);
   if(!Label_info_26.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_26))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_info_27(void)
  {
   int x1 = X3_PanelInfo;
   int y1 = Y7_PanelInfo + Button_D.Height();
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_27.Create(0, "Label_info_27", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_27.Text("%"))
      return(false);
   if(!Label_info_27.FontSize(In_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_27))
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
   if(!Button_Buy.FontSize(In_FontSizeGeneral * 2))
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
   if(!Button_Sell.FontSize(In_FontSizeGeneral * 2))
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
   if(!Edit_Risk.FontSize(In_FontSizeGeneral + 2))
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
   if(!Edit_SL.FontSize(In_FontSizeGeneral + 2))
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
   if(!Label_Risk.FontSize(In_FontSizeGeneral + 2))
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
   if(!Label_SL.FontSize(In_FontSizeGeneral + 2))
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
   double iprofit = 0.0;
   if(In_IProfit == enFree)
     {
      iprofit = AccountFreeMargin();
     }
   else
      if(In_IProfit == enBalance)
        {
         iprofit = AccountBalance();
        }
      else
         if(In_IProfit == enEquity)
           {
            iprofit = AccountEquity();
           }
   double LotValue = MarketInfo(Symbol(), MODE_TICKVALUE);
   double Min_Lot = MarketInfo(Symbol(), MODE_MINLOT);
   double Max_Lot = MarketInfo(Symbol(), MODE_MAXLOT);
   double Step = MarketInfo(Symbol(), MODE_LOTSTEP);
   double Lot = MathFloor((iprofit * Var_RiskPercent / 100) / (Var_StopLoss * LotValue) / Step) * Step;
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
   double sl = 0.0;
   double tp1 = 0.0;
   double tp2 = 0.0;
   double tp3 = 0.0;
   double Var_Lots1 = 0.0;
   double Var_Lots2 = 0.0;
   double Var_Lots3 = 0.0;
   CalculateLotSize();
   if(In_ISafe == 1)
     {
      Var_Lots1 = Var_Lots;
      if(type == OP_BUY)
        {
         sl = price - (Var_StopLoss * Point());
         tp1 = price + (3 * Var_StopLoss * Point());
         ticket = OrderSend(NULL, OP_BUY, Var_Lots1, price, Slippage, sl, tp1, "Manager", Magic, 0, clrNONE);
         if(ticket < 0)
           {
            Alert("OrderSend Error #", GetLastError());
           }
        }
      if(type == OP_SELL)
        {
         sl = price + (Var_StopLoss * Point());
         tp1 = price - (3 * Var_StopLoss * Point());
         ticket = OrderSend(NULL, OP_SELL, Var_Lots1, price, Slippage, sl, tp1, "Manager", Magic, 0, clrNONE);
         if(ticket < 0)
           {
            Alert("OrderSend Error #", GetLastError());
           }
        }
     }
   else
      if(In_ISafe == 2)
        {
         Var_Lots2 = NormalizeDouble(Var_Lots / 2, 2);
         Var_Lots1 = Var_Lots - Var_Lots2;
         if(type == OP_BUY)
           {
            sl = price - (Var_StopLoss * Point());
            tp1 = price + (3 * Var_StopLoss * Point());
            tp2 = price + (2 * Var_StopLoss * Point());
            ticket = OrderSend(NULL, OP_BUY, Var_Lots1, price, Slippage, sl, tp1, "Manager", Magic, 0, clrNONE);
            if(ticket < 0)
              {
               Alert("OrderSend Error #", GetLastError());
              }
            ticket = OrderSend(NULL, OP_BUY, Var_Lots2, price, Slippage, sl, tp2, "Manager", Magic, 0, clrNONE);
            if(ticket < 0)
              {
               Alert("OrderSend Error #", GetLastError());
              }
           }
         if(type == OP_SELL)
           {
            sl = price + (Var_StopLoss * Point());
            tp1 = price - (3 * Var_StopLoss * Point());
            tp2 = price - (2 * Var_StopLoss * Point());
            ticket = OrderSend(NULL, OP_SELL, Var_Lots1, price, Slippage, sl, tp1, "Manager", Magic, 0, clrNONE);
            if(ticket < 0)
              {
               Alert("OrderSend Error #", GetLastError());
              }
            ticket = OrderSend(NULL, OP_SELL, Var_Lots2, price, Slippage, sl, tp2, "Manager", Magic, 0, clrNONE);
            if(ticket < 0)
              {
               Alert("OrderSend Error #", GetLastError());
              }
           }
        }
      else
         if(In_ISafe == 3)
           {
            Var_Lots3 = NormalizeDouble(Var_Lots / 3, 2);
            Var_Lots2 = NormalizeDouble((Var_Lots - Var_Lots3) / 2, 2);
            Var_Lots1 = NormalizeDouble(Var_Lots - Var_Lots3 - Var_Lots2, 2);
            if(type == OP_BUY)
              {
               sl = price - (Var_StopLoss * Point());
               tp1 = price + (3 * Var_StopLoss * Point());
               tp2 = price + (2 * Var_StopLoss * Point());
               tp3 = price + (1 * Var_StopLoss * Point());
               ticket = OrderSend(NULL, OP_BUY, Var_Lots1, price, Slippage, sl, tp1, "Manager", Magic, 0, clrNONE);
               if(ticket < 0)
                 {
                  Alert("OrderSend Error #", GetLastError());
                 }
               ticket = OrderSend(NULL, OP_BUY, Var_Lots2, price, Slippage, sl, tp2, "Manager", Magic, 0, clrNONE);
               if(ticket < 0)
                 {
                  Alert("OrderSend Error #", GetLastError());
                 }
               ticket = OrderSend(NULL, OP_BUY, Var_Lots3, price, Slippage, sl, tp3, "Manager", Magic, 0, clrNONE);
               if(ticket < 0)
                 {
                  Alert("OrderSend Error #", GetLastError());
                 }
              }
            if(type == OP_SELL)
              {
               sl = price + (Var_StopLoss * Point());
               tp1 = price - (3 * Var_StopLoss * Point());
               tp2 = price - (2 * Var_StopLoss * Point());
               tp3 = price - (1 * Var_StopLoss * Point());
               ticket = OrderSend(NULL, OP_SELL, Var_Lots1, price, Slippage, sl, tp1, "Manager", Magic, 0, clrNONE);
               if(ticket < 0)
                 {
                  Alert("OrderSend Error #", GetLastError());
                 }
               ticket = OrderSend(NULL, OP_SELL, Var_Lots2, price, Slippage, sl, tp2, "Manager", Magic, 0, clrNONE);
               if(ticket < 0)
                 {
                  Alert("OrderSend Error #", GetLastError());
                 }
               ticket = OrderSend(NULL, OP_SELL, Var_Lots3, price, Slippage, sl, tp3, "Manager", Magic, 0, clrNONE);
               if(ticket < 0)
                 {
                  Alert("OrderSend Error #", GetLastError());
                 }
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
