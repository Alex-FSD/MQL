//+------------------------------------------------------------------+
//|                                                      Manager.mq4 |
//|                                                           Alexey |
//+------------------------------------------------------------------+
#property copyright "-> Telegram channel <-"
#property link      "https://t.me/+MpNV-f8Mrv8zZTNi"
#property version   "2.13"
#property description    "Risk Money Manager"
#property description    "© Alexey, 2020"
//
#property strict

#include <Controls\Defines.mqh>
#undef CONTROLS_FONT_SIZE
#undef CONTROLS_FONT_NAME
#define CONTROLS_FONT_SIZE Var_FontSizeGeneral
#define CONTROLS_FONT_NAME Var_FontGeneral
//
#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>
#include <Controls\Edit.mqh>
#include <Controls\Label.mqh>
#include <Controls\BmpButton.mqh>
#include <Controls\ComboBox.mqh>
#include <Controls\SpinEdit.mqh>
#include <Controls\RadioButton.mqh>


enum EN_ChartTheme
  {
   enOffTheme               = 0, //Off (Don't use theme)
   enLightTheme             = 1, //Light theme
   enDarkTheme              = 2  //Dark theme
  };


string set_FixOff_Ru              = "Выкл";
string set_FixOne_Ru              = "Использовать 1% риска";
string set_FixOff_En              = "Off";
string set_FixOne_En              = "Use 1% risk value";
int In_SEdit_FixValue             = 1;              //Fix risk value, % ...
int In_SpinEdit_MaxValue          = 5;              //Max risk value, %

int In_FSGeneral                  = 10;             //Labels font size

string set_En = "English";
string set_Ru = "Русский";
int In_Languages                  = 1;              //Interface language ...

string set_Free_Ru                = "Свободная маржа";
string set_Balance_Ru             = "Баланс";
string set_Equity_Ru              = "Средства";
string set_Free_En                = "Free Margin";
string set_Balance_En             = "Balance";
string set_Equity_En              = "Equity";
int In_IProfit                    = 0;              //Percentage calculation ...

string set_Current_Safe           = "";
string set_Safe1_Ru               = "1 Ордер";
string set_Safe2_Ru               = "2 Ордера";
string set_Safe3_Ru               = "3 Ордера";
string set_Safe1_En               = "1 Order";
string set_Safe2_En               = "2 Order";
string set_Safe3_En               = "3 Order";
int In_ISafe                      = 0;              //Number of orders for "safe" ...

string set_ISafe_Off_Ru           = "Выкл";
string set_ISafe_Off_En           = "Off";
string set_ISafe_On_Ru            = "Вкл";
string set_ISafe_On_En            = "On";
int In_ISafe_OnOff                = 0;

int In_CalcResult                 = 0;              //Calculation of results ...

//

input color In_ColorBuy                           = clrDarkGreen;   //Button color "BUY"
input color In_ColorSell                          = clrOrangeRed;   //Button color "SELL"
input color In_ColorFont                          = clrWhite;       //Button font color
input EN_ChartTheme In_ChartColors                = 0;              //Сolor theme chart ...
input int Slippage                                = 3;              //Slippage
input int Magic                                   = 290896;         //Magic (ID Expert)

struct struct_Settings
  {
   int               s_Languages;
   int               s_FontSizeGeneral;
   int               s_FixRiskValue;
   int               s_MaxRiskValue;
   int               s_IProfit;
   int               s_ISafe;
  };

struct_Settings str_Settings;

int var_CountVolumeStep = (int)MathCeil(MathAbs(MathLog(SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP)) / MathLog(10)));

bool var_CheckMenu;

string var_Current_Symbol = "";

string Date_license = "";
string SymbolOfCurrency = "";

double Var_RiskPercent = 0.00;
int Var_StopLoss = 0;
double Var_Lots = 0.00;

int Var_FontSizeGeneral = 10;
string Var_FontGeneral = "Segoe UI";
string Var_FontBoldGeneral = "Segoe UI Black";

int X_Button = 100;
int Y_Button = 50;

int X_Panel = 3;
int Y_Panel = 18;
int W_Panel = X_Panel + X_Button + 100;
int H_Panel = Y_Panel + Y_Button * 2 + 39;

int X_PanelInfo = 3;
int Y_PanelInfo = 3 + H_Panel;
int W_PanelInfo = X_PanelInfo + 450;
int H_PanelInfo = Y_PanelInfo + 238;

int X_PanelSettings = 3 + W_PanelInfo;
int Y_PanelSettings = 3 + H_Panel;
int W_PanelSettings = X_PanelSettings + 450;
int H_PanelSettings = Y_PanelSettings + 238;

int X1_PanelInfo = 5;
int X2_PanelInfo = X1_PanelInfo + 120;
int X3_PanelInfo = X2_PanelInfo + 100;
int X4_PanelInfo = X3_PanelInfo + 100;

int Y1_PanelInfo = 20;
int Y2_PanelInfo = Y1_PanelInfo + 20;
int Y3_PanelInfo = Y2_PanelInfo + 20;
int Y4_PanelInfo = Y3_PanelInfo + 20;
int Y5_PanelInfo = Y4_PanelInfo + 20;
int Y6_PanelInfo = Y5_PanelInfo + 20;
int Y7_PanelInfo = Y6_PanelInfo + 20;

int Y1_PanelSettings = 10;
int Y2_PanelSettings = Y1_PanelSettings + 25;
int Y3_PanelSettings = Y2_PanelSettings + 25;
int Y4_PanelSettings = Y3_PanelSettings + 25;
int Y5_PanelSettings = Y4_PanelSettings + 25;
int Y6_PanelSettings = Y5_PanelSettings + 25;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CAppPanelSettings : public CAppDialog
  {
public:
   CComboBox         ComboBox_Language;
   CSpinEdit         SpinEdit_FontSize;
   CComboBox         ComboBox_RiskValue;
   CSpinEdit         SpinEdit_RiskValue;
   CComboBox         ComboBox_IProfit;
   CComboBox         ComboBox_ISafe;

   CLabel            Label_ComboBox_Language;
   CLabel            Label_SpinEdit_FontSize;
   CLabel            Label_ComboBox_RiskValue;
   CLabel            Label_SpinEdit_RiskValue;
   CLabel            Label_ComboBox_IProfit;
   CLabel            Label_ComboBox_ISafe;

   CButton           Button_Apply;
   CButton           Button_Exit;

public:
                     CAppPanelSettings(void);
                    ~CAppPanelSettings(void);
   virtual bool      Create(const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2);
   virtual bool      OnEvent(const int id, const long &lparam, const double &dparam, const string &sparam);
protected:
   virtual void      Minimize(void);

   bool              CreateComboBox_Language(void);
   bool              CreateSpinEdit_FontSize(void);
   bool              CreateComboBox_RiskValue(void);
   bool              CreateSpinEdit_RiskValue(void);
   bool              CreateComboBox_IProfit(void);
   bool              CreateComboBox_ISafe(void);

   bool              CreateLabel_ComboBox_Language(void);
   bool              CreateLabel_SpinEdit_FontSize(void);
   bool              CreateLabel_ComboBox_RiskValue(void);
   bool              CreateLabel_SpinEdit_RiskValue(void);
   bool              CreateLabel_ComboBox_IProfit(void);
   bool              CreateLabel_ComboBox_ISafe(void);


   bool              CreateButton_Apply(void);
   bool              CreateButton_Exit(void);


   void              OnClickButton_Apply(void);
   void              OnClickButton_Exit(void);
  };


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
EVENT_MAP_BEGIN(CAppPanelSettings)
ON_NAMED_EVENT(ON_CLICK, Button_Apply, OnClickButton_Apply)
ON_NAMED_EVENT(ON_CLICK, Button_Exit, OnClickButton_Exit)
EVENT_MAP_END(CAppDialog)


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAppPanelSettings::CAppPanelSettings(void)
  {
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAppPanelSettings::~CAppPanelSettings(void)
  {
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelSettings::Create(const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2)
  {
   if(!CAppDialog::Create(chart, name, subwin, x1, y1, x2, y2))
      return(false);
   if(!CreateComboBox_Language())
      return(false);
   if(!CreateSpinEdit_FontSize())
      return(false);
   if(!CreateComboBox_RiskValue())
      return(false);
   if(!CreateSpinEdit_RiskValue())
      return(false);
   if(!CreateComboBox_IProfit())
      return(false);
   if(!CreateComboBox_ISafe())
      return(false);
   if(!CreateLabel_ComboBox_Language())
      return(false);
   if(!CreateLabel_SpinEdit_FontSize())
      return(false);
   if(!CreateLabel_ComboBox_RiskValue())
      return(false);
   if(!CreateLabel_SpinEdit_RiskValue())
      return(false);
   if(!CreateLabel_ComboBox_IProfit())
      return(false);
   if(!CreateLabel_ComboBox_ISafe())
      return(false);
   if(!CreateButton_Apply())
      return(false);
   if(!CreateButton_Exit())
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAppPanelSettings::Minimize(void)
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


CAppPanelSettings *PanelSettings;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CAppPanel : public CAppDialog
  {
public:
   CButton           Button_Buy;
   CButton           Button_Sell;
   CEdit             Edit_Risk;
   CEdit             Edit_SL;
   CLabel            Label_Risk;
   CLabel            Label_SL;
   CLabel            Label_SafeTP;
   CBmpButton        EditButton_Up;
   CBmpButton        EditButton_Down;
   CComboBox         ComboBox_SafeTP;

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
   bool              CreateLabel_SafeTP(void);
   bool              CreateEditButton_Up(void);
   bool              CreateEditButton_Down(void);
   bool              CreateComboBox_SafeTP(void);

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
if(In_SEdit_FixValue == 0)
  {
   ON_NAMED_EVENT(ON_CLICK, EditButton_Up, OnClickEditButton_Up)
   ON_NAMED_EVENT(ON_CLICK, EditButton_Down, OnClickEditButton_Down)
  }
//
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
   if(!CreateLabel_SafeTP())
      return(false);
   if(!CreateEditButton_Up())
      return(false);
   if(!CreateEditButton_Down())
      return(false);
   if(!CreateComboBox_SafeTP())
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
public:
   CRadioButton      RadioButton_ForAllSymbol;
   CRadioButton      RadioButton_ByCurrSymbol;

   CButton           Button_D;
   CButton           Button_W;
   CButton           Button_M;

   CLabel            Label_Result;
   CLabel            Label_Currency;
   CLabel            Label_Percent;
   CLabel            Label_ProfitRate;

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

   CLabel            Label_info_31;
   CLabel            Label_info_32;
   CLabel            Label_info_33;
   CLabel            Label_info_34;
   CLabel            Label_info_35;
   CLabel            Label_info_36;
   CLabel            Label_info_37;
public:
                     CAppPanelInfo(void);
                    ~CAppPanelInfo(void);
   virtual bool      Create(const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2);
   virtual bool      OnEvent(const int id, const long &lparam, const double &dparam, const string &sparam);
protected:
   virtual void      Minimize(void);
   virtual void      GetProfit(ENUM_TIMEFRAMES tf);
   virtual void      TotalProfit(ENUM_TIMEFRAMES tf, int in_sym, double &PV1, double &PV2, double &PV3, double &PV4, double &PV5, double &PV6, double &PV7, double &CD1, double &CD2, double &CD3, double &CD4, double &CD5, double &CD6, double &CD7,  int &PR1, int &PR2, int &PR3, int &PR4, int &PR5, int &PR6, int &PR7, int &LR1, int &LR2, int &LR3, int &LR4, int &LR5, int &LR6, int &LR7);
   virtual void      SetInfoPanel(ENUM_TIMEFRAMES tf, double &vc1, double &vc2, double &vc3, double &vc4, double &vc5, double &vc6, double &vc7, double & vp1, double &vp2, double &vp3, double &vp4, double &vp5, double &vp6, double &vp7, int &vPR1, int &vPR2, int &vPR3, int &vPR4, int &vPR5, int &vPR6, int &vPR7, int &vLR1, int &vLR2, int &vLR3, int &vLR4, int &vLR5, int &vLR6, int &vLR7, double &vRate1_per, double &vRate2_per, double &vRate3_per, double &vRate4_per, double &vRate5_per, double &vRate6_per, double &vRate7_per);

   bool              CreateRadioButton_ForAllSymbol(void);
   bool              CreateRadioButton_ByCurrSymbol(void);

   bool              CreateButton_D(void);
   bool              CreateButton_W(void);
   bool              CreateButton_M(void);

   bool              CreateLabel_Result(void);
   bool              CreateLabel_Currency(void);
   bool              CreateLabel_Percent(void);
   bool              CreateLabel_ProfitRate(void);

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

   bool              CreateLabel_info_31(void);
   bool              CreateLabel_info_32(void);
   bool              CreateLabel_info_33(void);
   bool              CreateLabel_info_34(void);
   bool              CreateLabel_info_35(void);
   bool              CreateLabel_info_36(void);
   bool              CreateLabel_info_37(void);


   void              OnClickRadioButton_ForAllSymbol(void);
   void              OnClickRadioButton_ByCurrSymbol(void);

   void              OnClickButton_D(void);
   void              OnClickButton_W(void);
   void              OnClickButton_M(void);
  };


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
EVENT_MAP_BEGIN(CAppPanelInfo)
ON_NAMED_EVENT(ON_CHANGE, RadioButton_ForAllSymbol, OnClickRadioButton_ForAllSymbol)
ON_NAMED_EVENT(ON_CHANGE, RadioButton_ByCurrSymbol, OnClickRadioButton_ByCurrSymbol)
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
   if(!CreateRadioButton_ForAllSymbol())
      return(false);
   if(!CreateRadioButton_ByCurrSymbol())
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
   if(!CreateLabel_ProfitRate())
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
   if(!CreateLabel_info_31())
      return(false);
   if(!CreateLabel_info_32())
      return(false);
   if(!CreateLabel_info_33())
      return(false);
   if(!CreateLabel_info_34())
      return(false);
   if(!CreateLabel_info_35())
      return(false);
   if(!CreateLabel_info_36())
      return(false);
   if(!CreateLabel_info_37())
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
bool CreateGeneralPanel(void)
  {
   int XSIZE_GeneralButton = 115;
   int YSIZE_GeneralButton = 20;
//
   int XDISTANCE_GeneralButton = XSIZE_GeneralButton + 2;
   int YDISTANCE_GeneralButton = 18;
//
   if(ObjectCreate(0, "GeneralButtonMinMax", OBJ_BUTTON, 0, 0, 0))
     {
      ObjectSetInteger(0, "GeneralButtonMinMax", OBJPROP_XDISTANCE, XDISTANCE_GeneralButton);
      ObjectSetInteger(0, "GeneralButtonMinMax", OBJPROP_YDISTANCE, YDISTANCE_GeneralButton);
      ObjectSetInteger(0, "GeneralButtonMinMax", OBJPROP_XSIZE, XSIZE_GeneralButton);
      ObjectSetInteger(0, "GeneralButtonMinMax", OBJPROP_YSIZE, YSIZE_GeneralButton);
      ObjectSetInteger(0, "GeneralButtonMinMax", OBJPROP_CORNER, CORNER_RIGHT_UPPER);
      if(In_Languages == 0)
        {
         ObjectSetString(0, "GeneralButtonMinMax", OBJPROP_TEXT, "Minimize ...");
        }
      else
         if(In_Languages == 1)
           {
            ObjectSetString(0, "GeneralButtonMinMax", OBJPROP_TEXT, "Свернуть ...");
           }
      ObjectSetString(0, "GeneralButtonMinMax", OBJPROP_FONT, Var_FontGeneral);
      ObjectSetInteger(0, "GeneralButtonMinMax", OBJPROP_FONTSIZE, Var_FontSizeGeneral - 1);
      ObjectSetInteger(0, "GeneralButtonMinMax", OBJPROP_COLOR, clrBlack);
      ObjectSetInteger(0, "GeneralButtonMinMax", OBJPROP_BGCOLOR, clrWhiteSmoke);
      ObjectSetInteger(0, "GeneralButtonMinMax", OBJPROP_BORDER_COLOR, clrBlack);
      ObjectSetInteger(0, "GeneralButtonMinMax", OBJPROP_BACK, false);
      ObjectSetInteger(0, "GeneralButtonMinMax", OBJPROP_STATE, false);
      ObjectSetInteger(0, "GeneralButtonMinMax", OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, "GeneralButtonMinMax", OBJPROP_SELECTED, false);
      ObjectSetInteger(0, "GeneralButtonMinMax", OBJPROP_HIDDEN, true);
      ObjectSetInteger(0, "GeneralButtonMinMax", OBJPROP_ZORDER, 1);
     }
   else
     {
      return(false);
     }
   if(ObjectCreate(0, "GeneralButtonPanel", OBJ_BUTTON, 0, 0, 0))
     {
      ObjectSetInteger(0, "GeneralButtonPanel", OBJPROP_XDISTANCE, XDISTANCE_GeneralButton);
      ObjectSetInteger(0, "GeneralButtonPanel", OBJPROP_YDISTANCE, ObjectGetInteger(0, "GeneralButtonMinMax", OBJPROP_YDISTANCE) + YSIZE_GeneralButton + 1);
      ObjectSetInteger(0, "GeneralButtonPanel", OBJPROP_XSIZE, XSIZE_GeneralButton);
      ObjectSetInteger(0, "GeneralButtonPanel", OBJPROP_YSIZE, YSIZE_GeneralButton);
      ObjectSetInteger(0, "GeneralButtonPanel", OBJPROP_CORNER, CORNER_RIGHT_UPPER);
      if(In_Languages == 0)
        {
         ObjectSetString(0, "GeneralButtonPanel", OBJPROP_TEXT, "Trade panel");
        }
      else
         if(In_Languages == 1)
           {
            ObjectSetString(0, "GeneralButtonPanel", OBJPROP_TEXT, "Торговая панель");
           }
      ObjectSetString(0, "GeneralButtonPanel", OBJPROP_FONT, Var_FontGeneral);
      ObjectSetInteger(0, "GeneralButtonPanel", OBJPROP_FONTSIZE, Var_FontSizeGeneral - 1);
      ObjectSetInteger(0, "GeneralButtonPanel", OBJPROP_COLOR, clrBlack);
      ObjectSetInteger(0, "GeneralButtonPanel", OBJPROP_BGCOLOR, clrWhiteSmoke);
      ObjectSetInteger(0, "GeneralButtonPanel", OBJPROP_BORDER_COLOR, clrBlack);
      ObjectSetInteger(0, "GeneralButtonPanel", OBJPROP_BACK, false);
      ObjectSetInteger(0, "GeneralButtonPanel", OBJPROP_STATE, false);
      ObjectSetInteger(0, "GeneralButtonPanel", OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, "GeneralButtonPanel", OBJPROP_SELECTED, false);
      ObjectSetInteger(0, "GeneralButtonPanel", OBJPROP_HIDDEN, true);
      ObjectSetInteger(0, "GeneralButtonPanel", OBJPROP_ZORDER, 1);
     }
   else
     {
      return(false);
     }
   if(ObjectCreate(0, "GeneralButtonPanelInfo", OBJ_BUTTON, 0, 0, 0))
     {
      ObjectSetInteger(0, "GeneralButtonPanelInfo", OBJPROP_XDISTANCE, XDISTANCE_GeneralButton);
      ObjectSetInteger(0, "GeneralButtonPanelInfo", OBJPROP_YDISTANCE, ObjectGetInteger(0, "GeneralButtonPanel", OBJPROP_YDISTANCE) + YSIZE_GeneralButton + 1);
      ObjectSetInteger(0, "GeneralButtonPanelInfo", OBJPROP_XSIZE, XSIZE_GeneralButton);
      ObjectSetInteger(0, "GeneralButtonPanelInfo", OBJPROP_YSIZE, YSIZE_GeneralButton);
      ObjectSetInteger(0, "GeneralButtonPanelInfo", OBJPROP_CORNER, CORNER_RIGHT_UPPER);
      if(In_Languages == 0)
        {
         ObjectSetString(0, "GeneralButtonPanelInfo", OBJPROP_TEXT, "Info panel");
        }
      else
         if(In_Languages == 1)
           {
            ObjectSetString(0, "GeneralButtonPanelInfo", OBJPROP_TEXT, "Инфо панель");
           }
      ObjectSetString(0, "GeneralButtonPanelInfo", OBJPROP_FONT, Var_FontGeneral);
      ObjectSetInteger(0, "GeneralButtonPanelInfo", OBJPROP_FONTSIZE, Var_FontSizeGeneral - 1);
      ObjectSetInteger(0, "GeneralButtonPanelInfo", OBJPROP_COLOR, clrBlack);
      ObjectSetInteger(0, "GeneralButtonPanelInfo", OBJPROP_BGCOLOR, clrWhiteSmoke);
      ObjectSetInteger(0, "GeneralButtonPanelInfo", OBJPROP_BORDER_COLOR, clrBlack);
      ObjectSetInteger(0, "GeneralButtonPanelInfo", OBJPROP_BACK, false);
      ObjectSetInteger(0, "GeneralButtonPanelInfo", OBJPROP_STATE, false);
      ObjectSetInteger(0, "GeneralButtonPanelInfo", OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, "GeneralButtonPanelInfo", OBJPROP_SELECTED, false);
      ObjectSetInteger(0, "GeneralButtonPanelInfo", OBJPROP_HIDDEN, true);
      ObjectSetInteger(0, "GeneralButtonPanelInfo", OBJPROP_ZORDER, 1);
     }
   else
     {
      return(false);
     }
   if(ObjectCreate(0, "GeneralButtonPanelSettings", OBJ_BUTTON, 0, 0, 0))
     {
      ObjectSetInteger(0, "GeneralButtonPanelSettings", OBJPROP_XDISTANCE, XDISTANCE_GeneralButton);
      ObjectSetInteger(0, "GeneralButtonPanelSettings", OBJPROP_YDISTANCE, ObjectGetInteger(0, "GeneralButtonPanelInfo", OBJPROP_YDISTANCE) + YSIZE_GeneralButton + 1);
      ObjectSetInteger(0, "GeneralButtonPanelSettings", OBJPROP_XSIZE, XSIZE_GeneralButton);
      ObjectSetInteger(0, "GeneralButtonPanelSettings", OBJPROP_YSIZE, YSIZE_GeneralButton);
      ObjectSetInteger(0, "GeneralButtonPanelSettings", OBJPROP_CORNER, CORNER_RIGHT_UPPER);
      if(In_Languages == 0)
        {
         ObjectSetString(0, "GeneralButtonPanelSettings", OBJPROP_TEXT, "Settings");
        }
      else
         if(In_Languages == 1)
           {
            ObjectSetString(0, "GeneralButtonPanelSettings", OBJPROP_TEXT, "Настройки");
           }
      ObjectSetString(0, "GeneralButtonPanelSettings", OBJPROP_FONT, Var_FontGeneral);
      ObjectSetInteger(0, "GeneralButtonPanelSettings", OBJPROP_FONTSIZE, Var_FontSizeGeneral - 1);
      ObjectSetInteger(0, "GeneralButtonPanelSettings", OBJPROP_COLOR, clrBlack);
      ObjectSetInteger(0, "GeneralButtonPanelSettings", OBJPROP_BGCOLOR, clrWhiteSmoke);
      ObjectSetInteger(0, "GeneralButtonPanelSettings", OBJPROP_BORDER_COLOR, clrBlack);
      ObjectSetInteger(0, "GeneralButtonPanelSettings", OBJPROP_BACK, false);
      ObjectSetInteger(0, "GeneralButtonPanelSettings", OBJPROP_STATE, false);
      ObjectSetInteger(0, "GeneralButtonPanelSettings", OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, "GeneralButtonPanelSettings", OBJPROP_SELECTED, false);
      ObjectSetInteger(0, "GeneralButtonPanelSettings", OBJPROP_HIDDEN, true);
      ObjectSetInteger(0, "GeneralButtonPanelSettings", OBJPROP_ZORDER, 1);
     }
   else
     {
      return(false);
     }
   return(true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   LoadSettings();
//
   Date_license = "31.05.2023";
   if(TimeCurrent() > StrToTime(Date_license))
     {
      if(In_Languages == 0)
        {
         MessageBox("License has expired", "License", MB_OK | MB_ICONWARNING);
        }
      else
         if(In_Languages == 1)
           {
            MessageBox("Срок лицензии истек", "Лицензия", MB_OK | MB_ICONWARNING);
           }
      ExpertRemove();
     }
   if(AccountNumber() != 143086866)
     {
      if(In_Languages == 0)
        {
         MessageBox("This account is not allowed to use expert", "Account", MB_OK | MB_ICONWARNING);
        }
      else
         if(In_Languages == 1)
           {
            MessageBox("Этот аккаунт не может использовать советник", "Аккаунт", MB_OK | MB_ICONWARNING);
           }
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
   double var_FSG = 0.0;
   int var_DPI = TerminalInfoInteger(TERMINAL_SCREEN_DPI);
   if(72 > var_DPI >= 72)
     {
      var_FSG = In_FSGeneral * 1.2;
     }
   else
      if(var_DPI >= 96)
        {
         var_FSG = In_FSGeneral;
        }
      else
         if(var_DPI >= 120)
           {
            var_FSG = In_FSGeneral * 0.8;
           }
         else
            if(var_DPI >= 144)
              {
               var_FSG = In_FSGeneral * 0.7;
              }
   Var_FontSizeGeneral = (int)MathRound(var_FSG);
//
   var_CheckMenu = true;
   if(!CreateGeneralPanel())
     {
      return(INIT_FAILED);
     }
//
   Panel = new CAppPanel();
   if(!Panel.Create(0, "Trade panel", 0, X_Panel, Y_Panel, W_Panel, H_Panel))
      return(INIT_FAILED);
   if(In_Languages == 0)
     {
      Panel.Caption("Trade panel");
     }
   else
      if(In_Languages == 1)
        {
         Panel.Caption("Торговая панель");
        }
   Panel.Run();
   Panel.IniFileLoad();
//
   if(set_Current_Safe == "")
     {
      Panel.ComboBox_SafeTP.Select(0);
     }
   else
     {
      ObjectSetString(0, "ComboBox_SafeTPEdit", OBJPROP_TEXT, set_Current_Safe);
     }
//
   PanelInfo = new CAppPanelInfo();
   if(!PanelInfo.Create(0, "Info panel", 0, X_PanelInfo, Y_PanelInfo, W_PanelInfo, H_PanelInfo))
      return(INIT_FAILED);
   if(In_Languages == 0)
     {
      PanelInfo.Caption("Info panel");
     }
   else
      if(In_Languages == 1)
        {
         PanelInfo.Caption("Инфо панель");
        }
   PanelInfo.Run();
   PanelInfo.IniFileLoad();
   PanelInfo.Hide();
//
   PanelSettings = new CAppPanelSettings();
   if(!PanelSettings.Create(0, "Settings", 0, X_PanelSettings, Y_PanelSettings, W_PanelSettings, H_PanelSettings))
      return(INIT_FAILED);
   if(In_Languages == 0)
     {
      PanelSettings.Caption("Settings");
     }
   else
      if(In_Languages == 1)
        {
         PanelSettings.Caption("Настройки");
        }
   PanelSettings.Run();
   PanelSettings.IniFileLoad();
   PanelSettings.Hide();
//
   if(In_CalcResult == 0)
      ObjectSetInteger(0, "RadioButton_ForAllSymbolButton", OBJPROP_STATE, true);
   if(In_CalcResult == 1)
      ObjectSetInteger(0, "RadioButton_ByCurrSymbolButton", OBJPROP_STATE, true);
//
   ObjectSetInteger(0, "RadioButton_ForAllSymbolLabel", OBJPROP_BGCOLOR, clrWhite);
   ObjectSetInteger(0, "RadioButton_ForAllSymbolLabel", OBJPROP_BORDER_COLOR, clrWhite);
   ObjectSetInteger(0, "RadioButton_ByCurrSymbolLabel", OBJPROP_BGCOLOR, clrWhite);
   ObjectSetInteger(0, "RadioButton_ByCurrSymbolLabel", OBJPROP_BORDER_COLOR, clrWhite);
//
   ObjectSetInteger(0, Panel.Name() + "ClientBack", OBJPROP_BGCOLOR, clrWhite);
   ObjectSetInteger(0, Panel.Name() + "ClientBack", OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, Panel.Name() + "ClientBack", OBJPROP_BORDER_COLOR, clrNONE);
   ObjectSetInteger(0, Panel.Name() + "Back", OBJPROP_BORDER_COLOR, clrNONE);
   ObjectSetInteger(0, Panel.Name() + "Border", OBJPROP_COLOR, clrNONE);
   ObjectSetInteger(0, Panel.Name() + "Border", OBJPROP_BORDER_COLOR, clrNONE);
//
   ObjectSetInteger(0, PanelInfo.Name() + "ClientBack", OBJPROP_BGCOLOR, clrWhite);
   ObjectSetInteger(0, PanelInfo.Name() + "ClientBack", OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, PanelInfo.Name() + "ClientBack", OBJPROP_BORDER_COLOR, clrNONE);
   ObjectSetInteger(0, PanelInfo.Name() + "Back", OBJPROP_BORDER_COLOR, clrNONE);
   ObjectSetInteger(0, PanelInfo.Name() + "Border", OBJPROP_COLOR, clrNONE);
   ObjectSetInteger(0, PanelInfo.Name() + "Border", OBJPROP_BORDER_COLOR, clrNONE);
//
   ObjectSetInteger(0, PanelSettings.Name() + "ClientBack", OBJPROP_BGCOLOR, clrWhite);
   ObjectSetInteger(0, PanelSettings.Name() + "ClientBack", OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, PanelSettings.Name() + "ClientBack", OBJPROP_BORDER_COLOR, clrNONE);
   ObjectSetInteger(0, PanelSettings.Name() + "Back", OBJPROP_BORDER_COLOR, clrNONE);
   ObjectSetInteger(0, PanelSettings.Name() + "Border", OBJPROP_COLOR, clrNONE);
   ObjectSetInteger(0, PanelSettings.Name() + "Border", OBJPROP_BORDER_COLOR, clrNONE);
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
   if(In_Languages == 0)
     {
      ObjectSetInteger(0, "Date_license", OBJPROP_XDISTANCE, 150);
     }
   else
      if(In_Languages == 1)
        {
         ObjectSetInteger(0, "Date_license", OBJPROP_XDISTANCE, 150);
        }
   ObjectSetInteger(0, "Date_license", OBJPROP_YDISTANCE, 2);
   ObjectSetInteger(0, "Date_license", OBJPROP_CORNER, CORNER_RIGHT_UPPER);
   ObjectSetString(0, "Date_license", OBJPROP_FONT, Var_FontGeneral);
   ObjectSetInteger(0, "Date_license", OBJPROP_FONTSIZE, Var_FontSizeGeneral - 3);
   ObjectSetInteger(0, "Date_license", OBJPROP_COLOR, ChartGetInteger(0, CHART_COLOR_FOREGROUND, 0));
   ObjectSetInteger(0, "Date_license", OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, "Date_license", OBJPROP_SELECTED, false);
   ObjectSetInteger(0, "Date_license", OBJPROP_HIDDEN, true);
   if(In_Languages == 0)
     {
      ObjectSetString(0, "Date_license", OBJPROP_TEXT, "License " + Date_license);
     }
   else
      if(In_Languages == 1)
        {
         ObjectSetString(0, "Date_license", OBJPROP_TEXT, "Лицензия " + Date_license);
        }
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
   if(reason == REASON_ACCOUNT)
     {
      ExpertRemove();
     }
   if(reason == REASON_CHARTCHANGE)
     {
      set_Current_Safe = ObjectGetString(0, "ComboBox_SafeTPEdit", OBJPROP_TEXT);
      Panel.IniFileSave();
      PanelInfo.IniFileSave();
      PanelSettings.IniFileSave();
     }
   else
      set_Current_Safe = "";
   Panel.Destroy(reason);
   PanelInfo.Destroy(reason);
   PanelSettings.Destroy(reason);
   delete(Panel);
   delete(PanelInfo);
   delete(PanelSettings);
//
   Comment("");
//
   ObjectDelete(0, "Date_license");
   ObjectDelete(0, "GeneralButtonMinMax");
   ObjectDelete(0, "GeneralButtonPanel");
   ObjectDelete(0, "GeneralButtonPanelInfo");
   ObjectDelete(0, "GeneralButtonPanelSettings");
//
   ChartRedraw();
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MinMaxMenu()
  {
   if(var_CheckMenu)
     {
      ObjectSetInteger(0, "GeneralButtonPanel", OBJPROP_TIMEFRAMES, EMPTY);
      ObjectSetInteger(0, "GeneralButtonPanelInfo", OBJPROP_TIMEFRAMES, EMPTY);
      ObjectSetInteger(0, "GeneralButtonPanelSettings", OBJPROP_TIMEFRAMES, EMPTY);
      //
      if(In_Languages == 0)
        {
         ObjectSetString(0, "GeneralButtonMinMax", OBJPROP_TEXT, "Maximize ...");
        }
      else
         if(In_Languages == 1)
           {
            ObjectSetString(0, "GeneralButtonMinMax", OBJPROP_TEXT, "Развернуть ...");
           }
      var_CheckMenu = false;
     }
   else
     {
      ObjectSetInteger(0, "GeneralButtonPanel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
      ObjectSetInteger(0, "GeneralButtonPanelInfo", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
      ObjectSetInteger(0, "GeneralButtonPanelSettings", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
      //
      if(In_Languages == 0)
        {
         ObjectSetString(0, "GeneralButtonMinMax", OBJPROP_TEXT, "Minimize ...");
        }
      else
         if(In_Languages == 1)
           {
            ObjectSetString(0, "GeneralButtonMinMax", OBJPROP_TEXT, "Свернуть ...");
           }
      var_CheckMenu = true;
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long& lparam,
                  const double& dparam,
                  const string& sparam)
  {
//
   if(((sparam == Panel.Name() + "Close") || (sparam == PanelInfo.Name() + "Close") || (sparam == PanelSettings.Name() + "Close")) || ((sparam == Panel.Name() + "MinMax") || (sparam == PanelInfo.Name() + "MinMax") || (sparam == PanelSettings.Name() + "MinMax")))
     {
      if((id == CHARTEVENT_OBJECT_CLICK) && ((sparam == Panel.Name() + "Close") || (sparam == Panel.Name() + "MinMax")))
        {
         Panel.Hide();
         ChartRedraw();
         return;
        }
      if((id == CHARTEVENT_OBJECT_CLICK) && ((sparam == PanelInfo.Name() + "Close") || (sparam == PanelInfo.Name() + "MinMax")))
        {
         PanelInfo.Hide();
         ChartRedraw();
         return;
        }
      if((id == CHARTEVENT_OBJECT_CLICK) && ((sparam == PanelSettings.Name() + "Close") || (sparam == PanelSettings.Name() + "MinMax")))
        {
         PanelSettings.Hide();
         ChartRedraw();
         return;
        }
     }
   if((id == CHARTEVENT_OBJECT_CLICK) && (sparam == "GeneralButtonMinMax"))
     {
      ObjectSetInteger(0, "GeneralButtonMinMax", OBJPROP_STATE, false);
      //
      MinMaxMenu();
      //
      ChartRedraw();
      return;
     }
   if((id == CHARTEVENT_OBJECT_CLICK) && (sparam == "GeneralButtonPanel"))
     {
      ObjectSetInteger(0, "GeneralButtonPanel", OBJPROP_STATE, false);
      if(Panel.IsVisible())
        {
         Panel.Hide();
        }
      else
        {
         Panel.Show();
        }
      if(In_SEdit_FixValue == 1)
        {
         ObjectSetInteger(0, "EditButton_Up", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
         ObjectSetInteger(0, "EditButton_Down", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        }
      if(In_ISafe_OnOff == 0)
        {
         ObjectSetInteger(0, "Label_SafeTP", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
         Panel.ComboBox_SafeTP.Hide();
        }
      ChartRedraw();
      return;
     }
   if((id == CHARTEVENT_OBJECT_CLICK) && (sparam == "GeneralButtonPanelInfo"))
     {
      ObjectSetInteger(0, "GeneralButtonPanelInfo", OBJPROP_STATE, false);
      if(PanelInfo.IsVisible())
        {
         PanelInfo.Hide();
        }
      else
        {
         PanelInfo.Show();
        }
      ChartRedraw();
      return;
     }
   if((id == CHARTEVENT_OBJECT_CLICK) && (sparam == "GeneralButtonPanelSettings"))
     {
      ObjectSetInteger(0, "GeneralButtonPanelSettings", OBJPROP_STATE, false);
      if(PanelSettings.IsVisible())
        {
         LoadSettings();
         PanelSettings.Hide();
        }
      else
        {
         LoadSettings();
         PanelSettings.Show();
        }
      ChartRedraw();
      return;
     }
//
   if((sparam == "ComboBox_SafeTPListItem0") || (sparam == "Button_Sell") || (sparam == "Button_Buy"))
     {
      Panel.ChartEvent(id, lparam, dparam, sparam);
      return;
     }
//
   if((sparam == "ComboBox_LanguageEdit") || (sparam == "ComboBox_LanguageDrop") || (sparam == "ComboBox_LanguageListBack") || (sparam == "ComboBox_LanguageListItem0") || (sparam == "ComboBox_LanguageListItem1") || (sparam == "SpinEdit_FontSizeEdit"))
     {
      PanelSettings.ChartEvent(id, lparam, dparam, sparam);
      return;
     }
//
   if((sparam == "Button_D") || (sparam == "Button_W") || (sparam == "Button_M"))
     {
      PanelInfo.ChartEvent(id, lparam, dparam, sparam);
      return;
     }
//
   if((sparam == "RadioButton_ForAllSymbol") || (sparam == "RadioButton_ByCurrSymbol") || (sparam == "RadioButton_ForAllSymbolButton") || (sparam == "RadioButton_ByCurrSymbolButton") || (sparam == "RadioButton_ForAllSymbolLabel") || (sparam == "RadioButton_ByCurrSymbolLabel"))
     {
      PanelInfo.ChartEvent(id, lparam, dparam, sparam);
      return;
     }
//
   if((sparam == "Button_Apply") || (sparam == "Button_Exit"))
     {
      PanelSettings.ChartEvent(id, lparam, dparam, sparam);
      return;
     }
//
   Panel.ChartEvent(id, lparam, dparam, sparam);
   PanelInfo.ChartEvent(id, lparam, dparam, sparam);
   PanelSettings.ChartEvent(id, lparam, dparam, sparam);
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
void CAppPanelInfo::TotalProfit(ENUM_TIMEFRAMES tf, int in_sym, double &PV1, double &PV2, double &PV3, double &PV4, double &PV5, double &PV6, double &PV7, double &CD1, double &CD2, double &CD3, double &CD4, double &CD5, double &CD6, double &CD7,  int &PR1, int &PR2, int &PR3, int &PR4, int &PR5, int &PR6, int &PR7, int &LR1, int &LR2, int &LR3, int &LR4, int &LR5, int &LR6, int &LR7)
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
                 {
                  PV1 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
                  if(!((((OrderType() >= 2) && (OrderType() <= 5)) && ((OrderProfit() + OrderSwap() + OrderCommission()) == 0)) || (Symbol() == "profit")))
                     if((OrderProfit() + OrderSwap() + OrderCommission()) >= 0)
                        PR1++;
                     else
                        LR1--;
                 }
               else
                  CD1 += NormalizeDouble(OrderProfit(), 2);
            if(OrderCloseTime() >= GetDateTF(tf, 1) + PS && OrderCloseTime() < GetDateTF(tf, 0) + PS)
               if(OrderType() <= 5)
                 {
                  PV2 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
                  if(!((((OrderType() >= 2) && (OrderType() <= 5)) && ((OrderProfit() + OrderSwap() + OrderCommission()) == 0)) || (Symbol() == "profit")))
                     if((OrderProfit() + OrderSwap() + OrderCommission()) >= 0)
                        PR2++;
                     else
                        LR2--;
                 }
               else
                  CD2 += NormalizeDouble(OrderProfit(), 2);
            if(OrderCloseTime() >= GetDateTF(tf, 2) + PS && OrderCloseTime() < GetDateTF(tf, 1) + PS)
               if(OrderType() <= 5)
                 {
                  PV3 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
                  if(!((((OrderType() >= 2) && (OrderType() <= 5)) && ((OrderProfit() + OrderSwap() + OrderCommission()) == 0)) || (Symbol() == "profit")))
                     if((OrderProfit() + OrderSwap() + OrderCommission()) >= 0)
                        PR3++;
                     else
                        LR3--;
                 }
               else
                  CD3 += NormalizeDouble(OrderProfit(), 2);
            if(OrderCloseTime() >= GetDateTF(tf, 3) + PS && OrderCloseTime() < GetDateTF(tf, 2) + PS)
               if(OrderType() <= 5)
                 {
                  PV4 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
                  if(!((((OrderType() >= 2) && (OrderType() <= 5)) && ((OrderProfit() + OrderSwap() + OrderCommission()) == 0)) || (Symbol() == "profit")))
                     if((OrderProfit() + OrderSwap() + OrderCommission()) >= 0)
                        PR4++;
                     else
                        LR4--;
                 }
               else
                  CD4 += NormalizeDouble(OrderProfit(), 2);
            if(OrderCloseTime() >= GetDateTF(tf, 4) + PS && OrderCloseTime() < GetDateTF(tf, 3) + PS)
               if(OrderType() <= 5)
                 {
                  PV5 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
                  if(!((((OrderType() >= 2) && (OrderType() <= 5)) && ((OrderProfit() + OrderSwap() + OrderCommission()) == 0)) || (Symbol() == "profit")))
                     if((OrderProfit() + OrderSwap() + OrderCommission()) >= 0)
                        PR5++;
                     else
                        LR5--;
                 }
               else
                  CD5 += NormalizeDouble(OrderProfit(), 2);
            if(OrderCloseTime() >= GetDateTF(tf, 5) + PS && OrderCloseTime() < GetDateTF(tf, 4) + PS)
               if(OrderType() <= 5)
                 {
                  PV6 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
                  if(!((((OrderType() >= 2) && (OrderType() <= 5)) && ((OrderProfit() + OrderSwap() + OrderCommission()) == 0)) || (Symbol() == "profit")))
                     if((OrderProfit() + OrderSwap() + OrderCommission()) >= 0)
                        PR6++;
                     else
                        LR6--;
                 }
               else
                  CD6 += NormalizeDouble(OrderProfit(), 2);
            if(OrderCloseTime() >= GetDateTF(tf, 6) + PS && OrderCloseTime() < GetDateTF(tf, 5) + PS)
               if(OrderType() <= 5)
                 {
                  PV7 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
                  if(!((((OrderType() >= 2) && (OrderType() <= 5)) && ((OrderProfit() + OrderSwap() + OrderCommission()) == 0)) || (Symbol() == "profit")))
                     if((OrderProfit() + OrderSwap() + OrderCommission()) >= 0)
                        PR7++;
                     else
                        LR7--;
                 }
               else
                  CD7 += NormalizeDouble(OrderProfit(), 2);
           }
         else
            if(in_sym == 1)
              {
               if(OrderCloseTime() >= GetDateTF(tf, 0) + PS)
                  if(OrderType() <= 5)
                    {
                     if(OrderSymbol() == Symbol())
                       {
                        PV1 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
                        if(!((((OrderType() >= 2) && (OrderType() <= 5)) && ((OrderProfit() + OrderSwap() + OrderCommission()) == 0)) || (Symbol() == "profit")))
                           if((OrderProfit() + OrderSwap() + OrderCommission()) >= 0)
                              PR1++;
                           else
                              LR1--;
                       }
                    }
                  else
                     CD1 += NormalizeDouble(OrderProfit(), 2);
               if(OrderCloseTime() >= GetDateTF(tf, 1) + PS && OrderCloseTime() < GetDateTF(tf, 0) + PS)
                  if(OrderType() <= 5)
                     if(OrderSymbol() == Symbol())
                       {
                          {
                           PV2 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
                           if(!((((OrderType() >= 2) && (OrderType() <= 5)) && ((OrderProfit() + OrderSwap() + OrderCommission()) == 0)) || (Symbol() == "profit")))
                              if((OrderProfit() + OrderSwap() + OrderCommission()) >= 0)
                                 PR2++;
                              else
                                 LR2--;
                          }
                       }
                     else
                        CD2 += NormalizeDouble(OrderProfit(), 2);
               if(OrderCloseTime() >= GetDateTF(tf, 2) + PS && OrderCloseTime() < GetDateTF(tf, 1) + PS)
                  if(OrderType() <= 5)
                     if(OrderSymbol() == Symbol())
                       {
                          {
                           PV3 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
                           if(!((((OrderType() >= 2) && (OrderType() <= 5)) && ((OrderProfit() + OrderSwap() + OrderCommission()) == 0)) || (Symbol() == "profit")))
                              if((OrderProfit() + OrderSwap() + OrderCommission()) >= 0)
                                 PR3++;
                              else
                                 LR3--;
                          }
                       }
                     else
                        CD3 += NormalizeDouble(OrderProfit(), 2);
               if(OrderCloseTime() >= GetDateTF(tf, 3) + PS && OrderCloseTime() < GetDateTF(tf, 2) + PS)
                  if(OrderType() <= 5)
                     if(OrderSymbol() == Symbol())
                       {
                          {
                           PV4 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
                           if(!((((OrderType() >= 2) && (OrderType() <= 5)) && ((OrderProfit() + OrderSwap() + OrderCommission()) == 0)) || (Symbol() == "profit")))
                              if((OrderProfit() + OrderSwap() + OrderCommission()) >= 0)
                                 PR4++;
                              else
                                 LR4--;
                          }
                       }
                     else
                        CD4 += NormalizeDouble(OrderProfit(), 2);
               if(OrderCloseTime() >= GetDateTF(tf, 4) + PS && OrderCloseTime() < GetDateTF(tf, 3) + PS)
                  if(OrderType() <= 5)
                     if(OrderSymbol() == Symbol())
                       {
                          {
                           PV5 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
                           if(!((((OrderType() >= 2) && (OrderType() <= 5)) && ((OrderProfit() + OrderSwap() + OrderCommission()) == 0)) || (Symbol() == "profit")))
                              if((OrderProfit() + OrderSwap() + OrderCommission()) >= 0)
                                 PR5++;
                              else
                                 LR5--;
                          }
                       }
                     else
                        CD5 += NormalizeDouble(OrderProfit(), 2);
               if(OrderCloseTime() >= GetDateTF(tf, 5) + PS && OrderCloseTime() < GetDateTF(tf, 4) + PS)
                  if(OrderType() <= 5)
                     if(OrderSymbol() == Symbol())
                       {
                          {
                           PV6 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
                           if(!((((OrderType() >= 2) && (OrderType() <= 5)) && ((OrderProfit() + OrderSwap() + OrderCommission()) == 0)) || (Symbol() == "profit")))
                              if((OrderProfit() + OrderSwap() + OrderCommission()) >= 0)
                                 PR6++;
                              else
                                 LR6--;
                          }
                       }
                     else
                        CD6 += NormalizeDouble(OrderProfit(), 2);
               if(OrderCloseTime() >= GetDateTF(tf, 6) + PS && OrderCloseTime() < GetDateTF(tf, 5) + PS)
                  if(OrderType() <= 5)
                     if(OrderSymbol() == Symbol())
                       {
                          {
                           PV7 += NormalizeDouble(OrderProfit() + OrderSwap() + OrderCommission(), 2);
                           if(!((((OrderType() >= 2) && (OrderType() <= 5)) && ((OrderProfit() + OrderSwap() + OrderCommission()) == 0)) || (Symbol() == "profit")))
                              if((OrderProfit() + OrderSwap() + OrderCommission()) >= 0)
                                 PR7++;
                              else
                                 LR7--;
                          }
                       }
                     else
                        CD7 += NormalizeDouble(OrderProfit(), 2);
              }
        }
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAppPanelInfo::GetProfit(ENUM_TIMEFRAMES tf)
  {
   double PV1 = 0.0;
   double PV2 = 0.0;
   double PV3 = 0.0;
   double PV4 = 0.0;
   double PV5 = 0.0;
   double PV6 = 0.0;
   double PV7 = 0.0;
//
   double CD1 = 0.0;
   double CD2 = 0.0;
   double CD3 = 0.0;
   double CD4 = 0.0;
   double CD5 = 0.0;
   double CD6 = 0.0;
   double CD7 = 0.0;
//
   int PR1 = 0;
   int PR2 = 0;
   int PR3 = 0;
   int PR4 = 0;
   int PR5 = 0;
   int PR6 = 0;
   int PR7 = 0;
//
   int LR1 = 0;
   int LR2 = 0;
   int LR3 = 0;
   int LR4 = 0;
   int LR5 = 0;
   int LR6 = 0;
   int LR7 = 0;
//
   TotalProfit(tf, 0, PV1, PV2, PV3, PV4, PV5, PV6, PV7, CD1, CD2, CD3, CD4, CD5, CD6, CD7, PR1, PR2, PR3, PR4, PR5, PR6, PR7, LR1, LR2, LR3, LR4, LR5, LR6, LR7);
//
   double InitialDeposit1 = NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE) - CD1 - PV1, 2);
   double InitialDeposit2 = NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE) - CD1 - CD2 - PV1 - PV2, 2);
   double InitialDeposit3 = NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE) - CD1 - CD2 - CD3 - PV1 - PV2 - PV3, 2);
   double InitialDeposit4 = NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE) - CD1 - CD2 - CD3 - CD4 - PV1 - PV2 - PV3 - PV4, 2);
   double InitialDeposit5 = NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE) - CD1 - CD2 - CD3 - CD4 - CD5 - PV1 - PV2 - PV3 - PV4 - PV5, 2);
   double InitialDeposit6 = NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE) - CD1 - CD2 - CD3 - CD4 - CD5 - CD6 - PV1 - PV2 - PV3 - PV4 - PV5 - PV6, 2);
   double InitialDeposit7 = NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE) - CD1 - CD2 - CD3 - CD4 - CD5 - CD6 - CD7 - PV1 - PV2 - PV3 - PV4 - PV5 - PV6 - PV7, 2);
//
   if(In_CalcResult == 1)
     {
      PV1 = 0.0;
      PV2 = 0.0;
      PV3 = 0.0;
      PV4 = 0.0;
      PV5 = 0.0;
      PV6 = 0.0;
      PV7 = 0.0;
      //
      CD1 = 0.0;
      CD2 = 0.0;
      CD3 = 0.0;
      CD4 = 0.0;
      CD5 = 0.0;
      CD6 = 0.0;
      CD7 = 0.0;
      //
      PR1 = 0;
      PR2 = 0;
      PR3 = 0;
      PR4 = 0;
      PR5 = 0;
      PR6 = 0;
      PR7 = 0;
      //
      LR1 = 0;
      LR2 = 0;
      LR3 = 0;
      LR4 = 0;
      LR5 = 0;
      LR6 = 0;
      LR7 = 0;
      //
      TotalProfit(tf, 1, PV1, PV2, PV3, PV4, PV5, PV6, PV7, CD1, CD2, CD3, CD4, CD5, CD6, CD7, PR1, PR2, PR3, PR4, PR5, PR6, PR7, LR1, LR2, LR3, LR4, LR5, LR6, LR7);
     }
//
   double PV1_per = 0.0;
   double PV2_per = 0.0;
   double PV3_per = 0.0;
   double PV4_per = 0.0;
   double PV5_per = 0.0;
   double PV6_per = 0.0;
   double PV7_per = 0.0;
//
   if(InitialDeposit1 != 0)
     {
      PV1_per = NormalizeDouble(PV1 / InitialDeposit1 * 100, 3);
     }
   if(InitialDeposit2 != 0)
     {
      PV2_per = NormalizeDouble(PV2 / InitialDeposit2 * 100, 3);
     }
   if(InitialDeposit3 != 0)
     {
      PV3_per = NormalizeDouble(PV3 / InitialDeposit3 * 100, 3);
     }
   if(InitialDeposit4 != 0)
     {
      PV4_per = NormalizeDouble(PV4 / InitialDeposit4 * 100, 3);
     }
   if(InitialDeposit5 != 0)
     {
      PV5_per = NormalizeDouble(PV5 / InitialDeposit5 * 100, 3);
     }
   if(InitialDeposit6 != 0)
     {
      PV6_per = NormalizeDouble(PV6 / InitialDeposit6 * 100, 3);
     }
   if(InitialDeposit7 != 0)
     {
      PV7_per = NormalizeDouble(PV7 / InitialDeposit7 * 100, 3);
     }
//
   if(PV1_per < -100)
     {
      PV1_per = 0.0;
     }
   if(PV2_per < -100)
     {
      PV2_per = 0.0;
     }
   if(PV3_per < -100)
     {
      PV3_per = 0.0;
     }
   if(PV4_per < -100)
     {
      PV4_per = 0.0;
     }
   if(PV5_per < -100)
     {
      PV5_per = 0.0;
     }
   if(PV6_per < -100)
     {
      PV6_per = 0.0;
     }
   if(PV7_per < -100)
     {
      PV7_per = 0.0;
     }
//
   double Rate1_per = 0.0;
   double Rate2_per = 0.0;
   double Rate3_per = 0.0;
   double Rate4_per = 0.0;
   double Rate5_per = 0.0;
   double Rate6_per = 0.0;
   double Rate7_per = 0.0;
//
   int Count_PR1_LP1 = MathAbs(PR1) + MathAbs(LR1);
   int Count_PR2_LP2 = MathAbs(PR2) + MathAbs(LR2);
   int Count_PR3_LP3 = MathAbs(PR3) + MathAbs(LR3);
   int Count_PR4_LP4 = MathAbs(PR4) + MathAbs(LR4);
   int Count_PR5_LP5 = MathAbs(PR5) + MathAbs(LR5);
   int Count_PR6_LP6 = MathAbs(PR6) + MathAbs(LR6);
   int Count_PR7_LP7 = MathAbs(PR7) + MathAbs(LR7);
//
   if(Count_PR1_LP1 != 0)
     {
      Rate1_per = NormalizeDouble((double)PR1 / Count_PR1_LP1 * 100, 2);
     }
   if(Count_PR2_LP2 != 0)
     {
      Rate2_per = NormalizeDouble((double)PR2 / Count_PR2_LP2 * 100, 2);
     }
   if(Count_PR3_LP3 != 0)
     {
      Rate3_per = NormalizeDouble((double)PR3 / Count_PR3_LP3 * 100, 2);
     }
   if(Count_PR4_LP4 != 0)
     {
      Rate4_per = NormalizeDouble((double)PR4 / Count_PR4_LP4 * 100, 2);
     }
   if(Count_PR5_LP5 != 0)
     {
      Rate5_per = NormalizeDouble((double)PR5 / Count_PR5_LP5 * 100, 2);
     }
   if(Count_PR6_LP6 != 0)
     {
      Rate6_per = NormalizeDouble((double)PR6 / Count_PR6_LP6 * 100, 2);
     }
   if(Count_PR7_LP7 != 0)
     {
      Rate7_per = NormalizeDouble((double)PR7 / Count_PR7_LP7 * 100, 2);
     }
//
   SetInfoPanel(tf, PV1, PV2, PV3, PV4, PV5, PV6, PV7, PV1_per, PV2_per, PV3_per, PV4_per, PV5_per, PV6_per, PV7_per, PR1, PR2, PR3, PR4, PR5, PR6, PR7, LR1, LR2, LR3, LR4, LR5, LR6, LR7, Rate1_per, Rate2_per, Rate3_per, Rate4_per, Rate5_per, Rate6_per, Rate7_per);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string NameOfMonth(const datetime time)
  {
   MqlDateTime dt;
   string month = "";
   TimeToStruct(time, dt);
   if(In_Languages == 0)
     {
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
     }
   else
      if(In_Languages == 1)
        {
         switch(dt.mon)
           {
            case 1:
               month = "Январь";
               break;
            case 2:
               month = "Февраль";
               break;
            case 3:
               month = "Март";
               break;
            case 4:
               month = "Апрель";
               break;
            case 5:
               month = "Май";
               break;
            case 6:
               month = "Июнь";
               break;
            case 7:
               month = "Июль";
               break;
            case 8:
               month = "Август";
               break;
            case 9:
               month = "Сентябрь";
               break;
            case 10:
               month = "Октябрь";
               break;
            case 11:
               month = "Ноябрь";
               break;
            default:
               month = "Декабрь";
               break;
           }
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
   string var_Month = "";
   TimeToStruct(time, dt);
   var_Month = IntegerToString(dt.mon, 2, '0');
//---
   return var_Month;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string DayOfWeek(const datetime time)
  {
   MqlDateTime dt;
   string day = "";
   TimeToStruct(time, dt);
   if(In_Languages == 0)
     {
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
     }
   else
      if(In_Languages == 1)
        {
         switch(dt.day_of_week)
           {
            case 0:
               day = "Воскресенье";
               break;
            case 1:
               day = "Понедельник";
               break;
            case 2:
               day = "Вторник";
               break;
            case 3:
               day = "Среда";
               break;
            case 4:
               day = "Четверг";
               break;
            case 5:
               day = "Пятница";
               break;
            default:
               day = "Суббота";
               break;
           }
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
   string weeks = "";
   TimeToStruct(time, dt);
   weeks = IntegerToString(dt.day, 2, '0') + "." + IntegerToString(dt.mon, 2, '0');
//---
   return weeks;
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
string GetSymbolPlusDbl(double n, int n2)
  {
   string NPlus = DoubleToString(n, n2);
   if(n > 0)
      NPlus = "+" + NPlus;
   return(NPlus);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string GetSymbolPlusInt(int n)
  {
   string NPlus = IntegerToString(n);
   if(n > 0)
      NPlus = "+" + NPlus;
   return(NPlus);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAppPanelInfo::SetInfoPanel(ENUM_TIMEFRAMES tf, double &vc1, double &vc2, double &vc3, double &vc4, double &vc5, double &vc6, double &vc7, double & vp1, double &vp2, double &vp3, double &vp4, double &vp5, double &vp6, double &vp7, int &vPR1, int &vPR2, int &vPR3, int &vPR4, int &vPR5, int &vPR6, int &vPR7, int &vLR1, int &vLR2, int &vLR3, int &vLR4, int &vLR5, int &vLR6, int &vLR7, double &vRate1_per, double &vRate2_per, double &vRate3_per, double &vRate4_per, double &vRate5_per, double &vRate6_per, double &vRate7_per)
  {
   if(tf == PERIOD_D1)
     {
      Label_info_01.Text(NumberOfDay(GetDateTF(tf, 0)) + " " + DayOfWeek(GetDateTF(tf, 0)));
      Label_info_02.Text(NumberOfDay(GetDateTF(tf, 1)) + " " + DayOfWeek(GetDateTF(tf, 1)));
      Label_info_03.Text(NumberOfDay(GetDateTF(tf, 2)) + " " + DayOfWeek(GetDateTF(tf, 2)));
      Label_info_04.Text(NumberOfDay(GetDateTF(tf, 3)) + " " + DayOfWeek(GetDateTF(tf, 3)));
      Label_info_05.Text(NumberOfDay(GetDateTF(tf, 4)) + " " + DayOfWeek(GetDateTF(tf, 4)));
      Label_info_06.Text(NumberOfDay(GetDateTF(tf, 5)) + " " + DayOfWeek(GetDateTF(tf, 5)));
      Label_info_07.Text(NumberOfDay(GetDateTF(tf, 6)) + " " + DayOfWeek(GetDateTF(tf, 6)));
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
      Label_info_01.Text(NumberOfMonth(GetDateTF(tf, 0)) + " " + NameOfMonth(GetDateTF(tf, 0)));
      Label_info_02.Text(NumberOfMonth(GetDateTF(tf, 1)) + " " + NameOfMonth(GetDateTF(tf, 1)));
      Label_info_03.Text(NumberOfMonth(GetDateTF(tf, 2)) + " " + NameOfMonth(GetDateTF(tf, 2)));
      Label_info_04.Text(NumberOfMonth(GetDateTF(tf, 3)) + " " + NameOfMonth(GetDateTF(tf, 3)));
      Label_info_05.Text(NumberOfMonth(GetDateTF(tf, 4)) + " " + NameOfMonth(GetDateTF(tf, 4)));
      Label_info_06.Text(NumberOfMonth(GetDateTF(tf, 5)) + " " + NameOfMonth(GetDateTF(tf, 5)));
      Label_info_07.Text(NumberOfMonth(GetDateTF(tf, 6)) + " " + NameOfMonth(GetDateTF(tf, 6)));
     }
//
   Label_info_11.Text(GetSymbolPlusDbl(vc1, 2) + " " + SymbolOfCurrency);
   Label_info_12.Text(GetSymbolPlusDbl(vc2, 2) + " " + SymbolOfCurrency);
   Label_info_13.Text(GetSymbolPlusDbl(vc3, 2) + " " + SymbolOfCurrency);
   Label_info_14.Text(GetSymbolPlusDbl(vc4, 2) + " " + SymbolOfCurrency);
   Label_info_15.Text(GetSymbolPlusDbl(vc5, 2) + " " + SymbolOfCurrency);
   Label_info_16.Text(GetSymbolPlusDbl(vc6, 2) + " " + SymbolOfCurrency);
   Label_info_17.Text(GetSymbolPlusDbl(vc7, 2) + " " + SymbolOfCurrency);
//
   Label_info_21.Text(GetSymbolPlusDbl(vp1, 3) + " %");
   Label_info_22.Text(GetSymbolPlusDbl(vp2, 3) + " %");
   Label_info_23.Text(GetSymbolPlusDbl(vp3, 3) + " %");
   Label_info_24.Text(GetSymbolPlusDbl(vp4, 3) + " %");
   Label_info_25.Text(GetSymbolPlusDbl(vp5, 3) + " %");
   Label_info_26.Text(GetSymbolPlusDbl(vp6, 3) + " %");
   Label_info_27.Text(GetSymbolPlusDbl(vp7, 3) + " %");
//
   Label_info_31.Text(GetSymbolPlusInt(vPR1) + "/" + GetSymbolPlusInt(vLR1) + " (" + DoubleToStr(vRate1_per, 2) + " %)");
   Label_info_32.Text(GetSymbolPlusInt(vPR2) + "/" + GetSymbolPlusInt(vLR2) + " (" + DoubleToStr(vRate2_per, 2) + " %)");
   Label_info_33.Text(GetSymbolPlusInt(vPR3) + "/" + GetSymbolPlusInt(vLR3) + " (" + DoubleToStr(vRate3_per, 2) + " %)");
   Label_info_34.Text(GetSymbolPlusInt(vPR4) + "/" + GetSymbolPlusInt(vLR4) + " (" + DoubleToStr(vRate4_per, 2) + " %)");
   Label_info_35.Text(GetSymbolPlusInt(vPR5) + "/" + GetSymbolPlusInt(vLR5) + " (" + DoubleToStr(vRate5_per, 2) + " %)");
   Label_info_36.Text(GetSymbolPlusInt(vPR6) + "/" + GetSymbolPlusInt(vLR6) + " (" + DoubleToStr(vRate6_per, 2) + " %)");
   Label_info_37.Text(GetSymbolPlusInt(vPR7) + "/" + GetSymbolPlusInt(vLR7) + " (" + DoubleToStr(vRate7_per, 2) + " %)");
//
   Label_info_11.Color(GetColorProfit(vc1));
   Label_info_12.Color(GetColorProfit(vc2));
   Label_info_13.Color(GetColorProfit(vc3));
   Label_info_14.Color(GetColorProfit(vc4));
   Label_info_15.Color(GetColorProfit(vc5));
   Label_info_16.Color(GetColorProfit(vc6));
   Label_info_17.Color(GetColorProfit(vc7));
//
   Label_info_21.Color(GetColorProfit(vc1));
   Label_info_22.Color(GetColorProfit(vc2));
   Label_info_23.Color(GetColorProfit(vc3));
   Label_info_24.Color(GetColorProfit(vc4));
   Label_info_25.Color(GetColorProfit(vc5));
   Label_info_26.Color(GetColorProfit(vc6));
   Label_info_27.Color(GetColorProfit(vc7));
//
   Label_info_31.Color(GetColorProfit(vc1));
   Label_info_32.Color(GetColorProfit(vc2));
   Label_info_33.Color(GetColorProfit(vc3));
   Label_info_34.Color(GetColorProfit(vc4));
   Label_info_35.Color(GetColorProfit(vc5));
   Label_info_36.Color(GetColorProfit(vc6));
   Label_info_37.Color(GetColorProfit(vc7));
//
   ChartRedraw();
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void LoadSettings(void)
  {
   string InpFileName = "Manager_Settings.dat";
   ResetLastError();
   int file_handle = FileOpen(InpFileName, FILE_READ | FILE_BIN);
   if(file_handle != INVALID_HANDLE)
     {
      while(!FileIsEnding(file_handle))
        {
         FileReadStruct(file_handle, str_Settings);
        }
      FileClose(file_handle);
     }
   else
     {
      str_Settings.s_Languages = In_Languages;
      str_Settings.s_FontSizeGeneral = In_FSGeneral;
      str_Settings.s_FixRiskValue = In_SEdit_FixValue;
      str_Settings.s_MaxRiskValue = In_SpinEdit_MaxValue;
      str_Settings.s_IProfit = In_IProfit;
      str_Settings.s_ISafe = In_ISafe_OnOff;
     }
//
   string s_language = "";
   if(str_Settings.s_Languages == 0)
     {
      s_language = set_En;
     }
   else
      if(str_Settings.s_Languages == 1)
        {
         s_language = set_Ru;
        }
   ObjectSetString(0, "ComboBox_LanguageEdit", OBJPROP_TEXT, s_language);
   ObjectSetString(0, "SpinEdit_FontSizeEdit", OBJPROP_TEXT, IntegerToString(str_Settings.s_FontSizeGeneral));
   In_Languages = str_Settings.s_Languages;
   In_FSGeneral = str_Settings.s_FontSizeGeneral;
//
   string s_risk_value = "";
   if(str_Settings.s_FixRiskValue == 0)
     {
      if(In_Languages == 0)
        {
         s_risk_value = set_FixOff_En;
        }
      else
         if(In_Languages == 1)
           {
            s_risk_value = set_FixOff_Ru;
           }
     }
   else
      if(str_Settings.s_FixRiskValue == 1)
        {
         if(In_Languages == 0)
           {
            s_risk_value = set_FixOne_En;
           }
         else
            if(In_Languages == 1)
              {
               s_risk_value = set_FixOne_Ru;
              }
        }
   ObjectSetString(0, "ComboBox_RiskValueEdit", OBJPROP_TEXT, s_risk_value);
   ObjectSetString(0, "SpinEdit_RiskValueEdit", OBJPROP_TEXT, IntegerToString(str_Settings.s_MaxRiskValue));
   In_SEdit_FixValue = str_Settings.s_FixRiskValue;
   In_SpinEdit_MaxValue = str_Settings.s_MaxRiskValue;
//
   string s_iprofit = "";
   if(str_Settings.s_IProfit == 0)
     {
      if(In_Languages == 0)
        {
         s_iprofit = set_Free_En;
        }
      else
         if(In_Languages == 1)
           {
            s_iprofit = set_Free_Ru;
           }
     }
   else
      if(str_Settings.s_IProfit == 1)
        {
         if(In_Languages == 0)
           {
            s_iprofit = set_Balance_En;
           }
         else
            if(In_Languages == 1)
              {
               s_iprofit = set_Balance_Ru;
              }
        }
      else
         if(str_Settings.s_IProfit == 2)
           {
            if(In_Languages == 0)
              {
               s_iprofit = set_Equity_En;
              }
            else
               if(In_Languages == 1)
                 {
                  s_iprofit = set_Equity_Ru;
                 }
           }
   ObjectSetString(0, "ComboBox_IProfitEdit", OBJPROP_TEXT, s_iprofit);
   In_IProfit = str_Settings.s_IProfit;
//
   string s_isafe = "";
   if(str_Settings.s_ISafe == 0)
     {
      if(In_Languages == 0)
        {
         s_isafe = set_ISafe_Off_En;
        }
      else
         if(In_Languages == 1)
           {
            s_isafe = set_ISafe_Off_Ru;
           }
     }
   else
      if(str_Settings.s_ISafe == 1)
        {
         if(In_Languages == 0)
           {
            s_isafe = set_ISafe_On_En;
           }
         else
            if(In_Languages == 1)
              {
               s_isafe = set_ISafe_On_Ru;
              }
        }
   ObjectSetString(0, "ComboBox_ISafeEdit", OBJPROP_TEXT, s_isafe);
   In_ISafe_OnOff = str_Settings.s_ISafe;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SaveSettings(void)
  {
   string s_language = ObjectGetString(0, "ComboBox_LanguageEdit", OBJPROP_TEXT);
   if(s_language == set_En)
     {
      str_Settings.s_Languages = 0;
     }
   else
      if(s_language == set_Ru)
        {
         str_Settings.s_Languages = 1;
        }
   str_Settings.s_FontSizeGeneral = StrToInteger(ObjectGetString(0, "SpinEdit_FontSizeEdit", OBJPROP_TEXT));
//
   string s_risk_value = ObjectGetString(0, "ComboBox_RiskValueEdit", OBJPROP_TEXT);
   if((s_risk_value == set_FixOff_En) || (s_risk_value == set_FixOff_Ru))
     {
      str_Settings.s_FixRiskValue = 0;
     }
   else
      if((s_risk_value == set_FixOne_En) || (s_risk_value == set_FixOne_Ru))
        {
         str_Settings.s_FixRiskValue = 1;
        }
   str_Settings.s_MaxRiskValue = StrToInteger(ObjectGetString(0, "SpinEdit_RiskValueEdit", OBJPROP_TEXT));
//
   string s_iprofit = ObjectGetString(0, "ComboBox_IProfitEdit", OBJPROP_TEXT);
   if((s_iprofit == set_Free_En) || (s_iprofit == set_Free_Ru))
     {
      str_Settings.s_IProfit = 0;
     }
   else
      if((s_iprofit == set_Balance_En) || (s_iprofit == set_Balance_Ru))
        {
         str_Settings.s_IProfit = 1;
        }
      else
         if((s_iprofit == set_Equity_En) || (s_iprofit == set_Equity_Ru))
           {
            str_Settings.s_IProfit = 2;
           }
//
   string s_isafe = ObjectGetString(0, "ComboBox_ISafeEdit", OBJPROP_TEXT);
   if((s_isafe == set_ISafe_Off_En) || (s_isafe == set_ISafe_Off_Ru))
     {
      str_Settings.s_ISafe = 0;
     }
   else
      if((s_isafe == set_ISafe_On_En) || (s_isafe == set_ISafe_On_Ru))
        {
         str_Settings.s_ISafe = 1;
        }
//
   string InpFileName = "Manager_Settings.dat";
   ResetLastError();
   int file_handle = FileOpen(InpFileName, FILE_READ | FILE_WRITE | FILE_BIN);
   if(file_handle != INVALID_HANDLE)
     {
      FileWriteStruct(file_handle, str_Settings);
      FileClose(file_handle);
     }
   else
     {
      if(In_Languages == 0)
        {
         int MSBoxResult = MessageBox("\nError #" + (string)GetLastError() +
                                      "An error occurred while saving the settings", "Error", MB_OK | MB_ICONWARNING);
        }
      else
         if(In_Languages == 1)
           {
            int MSBoxResult = MessageBox("\nОшибка #" + (string)GetLastError() +
                                         "Произошла ошибка во время сохранения настроек", "Ошибка", MB_OK | MB_ICONWARNING);
           }
     }
   In_Languages = str_Settings.s_Languages;
   In_FSGeneral = str_Settings.s_FontSizeGeneral;
   In_SEdit_FixValue = str_Settings.s_FixRiskValue;
   In_SpinEdit_MaxValue = str_Settings.s_MaxRiskValue;
   In_IProfit = str_Settings.s_IProfit;
   In_ISafe_OnOff = str_Settings.s_ISafe;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RefreshExpert(void)
  {
   OnDeinit(5);
   OnInit();
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAppPanelSettings::OnClickButton_Apply(void)
  {
   SaveSettings();
//
   if(In_Languages == 0)
     {
      int MSBoxResult = MessageBox("Settings saved successfully!", "Settings", MB_OK | MB_ICONINFORMATION);
     }
   else
      if(In_Languages == 1)
        {
         int MSBoxResult = MessageBox("Настройки успешно сохранены!", "Настройки", MB_OK | MB_ICONINFORMATION);
        }
//
   PanelSettings.Hide();
//
   RefreshExpert();
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAppPanelSettings::OnClickButton_Exit(void)
  {
   LoadSettings();
//
   PanelSettings.Hide();
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelSettings::CreateComboBox_Language(void)
  {
   int x1 = X_PanelSettings / 2 - 6;
   int y1 = Y1_PanelSettings;
   int x2 = X_PanelSettings - 23;
   int y2 = y1 + 20;
   ComboBox_Language.ListViewItems(2);
   if(!ComboBox_Language.Create(0, "ComboBox_Language", 0, x1, y1, x2, y2))
      return(false);
   if(!Add(ComboBox_Language))
      return(false);
   if(!ComboBox_Language.ItemAdd(set_En))
      return(false);
   if(!ComboBox_Language.ItemAdd(set_Ru))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelSettings::CreateSpinEdit_FontSize(void)
  {
   int x1 = X_PanelSettings / 2 - 6;
   int y1 = Y2_PanelSettings;
   int x2 = X_PanelSettings - 23;
   int y2 = y1 + 20;
   if(!SpinEdit_FontSize.Create(0, "SpinEdit_FontSize", 0, x1, y1, x2, y2))
      return(false);
   if(!Add(SpinEdit_FontSize))
      return(false);
   SpinEdit_FontSize.MinValue(1);
   SpinEdit_FontSize.MaxValue(100);
   SpinEdit_FontSize.Value(10);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelSettings::CreateComboBox_RiskValue(void)
  {
   int x1 = X_PanelSettings / 2 - 6;
   int y1 = Y3_PanelSettings;
   int x2 = X_PanelSettings - 23;
   int y2 = y1 + 20;
   ComboBox_RiskValue.ListViewItems(2);
   if(!ComboBox_RiskValue.Create(0, "ComboBox_RiskValue", 0, x1, y1, x2, y2))
      return(false);
   if(!Add(ComboBox_RiskValue))
      return(false);
   if(In_Languages == 0)
     {
      if(!ComboBox_RiskValue.ItemAdd(set_FixOff_En))
         return(false);
      if(!ComboBox_RiskValue.ItemAdd(set_FixOne_En))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!ComboBox_RiskValue.ItemAdd(set_FixOff_Ru))
            return(false);
         if(!ComboBox_RiskValue.ItemAdd(set_FixOne_Ru))
            return(false);
        }
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelSettings::CreateSpinEdit_RiskValue(void)
  {
   int x1 = X_PanelSettings / 2 - 6;
   int y1 = Y4_PanelSettings;
   int x2 = X_PanelSettings - 23;
   int y2 = y1 + 20;
   if(!SpinEdit_RiskValue.Create(0, "SpinEdit_RiskValue", 0, x1, y1, x2, y2))
      return(false);
   if(!Add(SpinEdit_RiskValue))
      return(false);
   SpinEdit_RiskValue.MinValue(1);
   SpinEdit_RiskValue.MaxValue(100);
   SpinEdit_RiskValue.Value(5);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelSettings::CreateComboBox_IProfit(void)
  {
   int x1 = X_PanelSettings / 2 - 6;
   int y1 = Y5_PanelSettings;
   int x2 = X_PanelSettings - 23;
   int y2 = y1 + 20;
   ComboBox_IProfit.ListViewItems(3);
   if(!ComboBox_IProfit.Create(0, "ComboBox_IProfit", 0, x1, y1, x2, y2))
      return(false);
   if(!Add(ComboBox_IProfit))
      return(false);
   if(In_Languages == 0)
     {
      if(!ComboBox_IProfit.ItemAdd(set_Free_En))
         return(false);
      if(!ComboBox_IProfit.ItemAdd(set_Balance_En))
         return(false);
      if(!ComboBox_IProfit.ItemAdd(set_Equity_En))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!ComboBox_IProfit.ItemAdd(set_Free_Ru))
            return(false);
         if(!ComboBox_IProfit.ItemAdd(set_Balance_Ru))
            return(false);
         if(!ComboBox_IProfit.ItemAdd(set_Equity_Ru))
            return(false);
        }
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelSettings::CreateComboBox_ISafe(void)
  {
   int x1 = X_PanelSettings / 2 - 6;
   int y1 = Y6_PanelSettings;
   int x2 = X_PanelSettings - 23;
   int y2 = y1 + 20;
   ComboBox_ISafe.ListViewItems(2);
   if(!ComboBox_ISafe.Create(0, "ComboBox_ISafe", 0, x1, y1, x2, y2))
      return(false);
   if(!Add(ComboBox_ISafe))
      return(false);
   if(In_Languages == 0)
     {
      if(!ComboBox_ISafe.ItemAdd(set_ISafe_Off_En))
         return(false);
      if(!ComboBox_ISafe.ItemAdd(set_ISafe_On_En))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!ComboBox_ISafe.ItemAdd(set_ISafe_Off_Ru))
            return(false);
         if(!ComboBox_ISafe.ItemAdd(set_ISafe_On_Ru))
            return(false);
        }
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelSettings::CreateLabel_ComboBox_Language(void)
  {
   int x1 = 10;
   int y1 = Y1_PanelSettings;
   int x2 = x1 + 10;
   int y2 = y1 + 10;
   if(!Label_ComboBox_Language.Create(0, "Label_ComboBox_Language", 0, x1, y1, x2, y2))
      return(false);
   if(In_Languages == 0)
     {
      if(!Label_ComboBox_Language.Text("Language ..."))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!Label_ComboBox_Language.Text("Язык ..."))
            return(false);
        }
   if(!Label_ComboBox_Language.FontSize(Var_FontSizeGeneral))
      return(false);
   if(!Label_ComboBox_Language.Font(Var_FontGeneral))
      return(false);
   if(!Add(Label_ComboBox_Language))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelSettings::CreateLabel_SpinEdit_FontSize(void)
  {
   int x1 = 10;
   int y1 = Y2_PanelSettings;
   int x2 = x1 + 10;
   int y2 = y1 + 10;
   if(!Label_SpinEdit_FontSize.Create(0, "Label_SpinEdit_FontSize", 0, x1, y1, x2, y2))
      return(false);
   if(In_Languages == 0)
     {
      if(!Label_SpinEdit_FontSize.Text("Font size"))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!Label_SpinEdit_FontSize.Text("Размер шрифта"))
            return(false);
        }
   if(!Label_SpinEdit_FontSize.FontSize(Var_FontSizeGeneral))
      return(false);
   if(!Label_SpinEdit_FontSize.Font(Var_FontGeneral))
      return(false);
   if(!Add(Label_SpinEdit_FontSize))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelSettings::CreateLabel_ComboBox_RiskValue(void)
  {
   int x1 = 10;
   int y1 = Y3_PanelSettings;
   int x2 = x1 + 10;
   int y2 = y1 + 10;
   if(!Label_ComboBox_RiskValue.Create(0, "Label_ComboBox_RiskValue", 0, x1, y1, x2, y2))
      return(false);
   if(In_Languages == 0)
     {
      if(!Label_ComboBox_RiskValue.Text("Fixed risk value ..."))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!Label_ComboBox_RiskValue.Text("Фиксированное значение риска ..."))
            return(false);
        }
   if(!Label_ComboBox_RiskValue.FontSize(Var_FontSizeGeneral))
      return(false);
   if(!Label_ComboBox_RiskValue.Font(Var_FontGeneral))
      return(false);
   if(!Add(Label_ComboBox_RiskValue))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelSettings::CreateLabel_SpinEdit_RiskValue(void)
  {
   int x1 = 10;
   int y1 = Y4_PanelSettings;
   int x2 = x1 + 10;
   int y2 = y1 + 10;
   if(!Label_SpinEdit_RiskValue.Create(0, "Label_SpinEdit_RiskValue", 0, x1, y1, x2, y2))
      return(false);
   if(In_Languages == 0)
     {
      if(!Label_SpinEdit_RiskValue.Text("Maximum risk value"))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!Label_SpinEdit_RiskValue.Text("Максимальное значение риска"))
            return(false);
        }
   if(!Label_SpinEdit_RiskValue.FontSize(Var_FontSizeGeneral))
      return(false);
   if(!Label_SpinEdit_RiskValue.Font(Var_FontGeneral))
      return(false);
   if(!Add(Label_SpinEdit_RiskValue))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelSettings::CreateLabel_ComboBox_IProfit(void)
  {
   int x1 = 10;
   int y1 = Y5_PanelSettings;
   int x2 = x1 + 10;
   int y2 = y1 + 10;
   if(!Label_ComboBox_IProfit.Create(0, "Label_ComboBox_IProfit", 0, x1, y1, x2, y2))
      return(false);
   if(In_Languages == 0)
     {
      if(!Label_ComboBox_IProfit.Text("Calculate risk from ..."))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!Label_ComboBox_IProfit.Text("Рассчитывать риск от ..."))
            return(false);
        }
   if(!Label_ComboBox_IProfit.FontSize(Var_FontSizeGeneral))
      return(false);
   if(!Label_ComboBox_IProfit.Font(Var_FontGeneral))
      return(false);
   if(!Add(Label_ComboBox_IProfit))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelSettings::CreateLabel_ComboBox_ISafe(void)
  {
   int x1 = 10;
   int y1 = Y6_PanelSettings;
   int x2 = x1 + 10;
   int y2 = y1 + 10;
   if(!Label_ComboBox_ISafe.Create(0, "Label_ComboBox_ISafe", 0, x1, y1, x2, y2))
      return(false);
   if(In_Languages == 0)
     {
      if(!Label_ComboBox_ISafe.Text("Use the 'Safe' method ..."))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!Label_ComboBox_ISafe.Text("Использовать метод 'Сейф' ..."))
            return(false);
        }
   if(!Label_ComboBox_ISafe.FontSize(Var_FontSizeGeneral))
      return(false);
   if(!Label_ComboBox_ISafe.Font(Var_FontGeneral))
      return(false);
   if(!Add(Label_ComboBox_ISafe))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelSettings::CreateButton_Apply(void)
  {
   int x1 = 5;
   int y1 = PanelSettings.Height() - 58;
   int x2 = x1 + ((W_PanelSettings - X_PanelSettings - 23) / 2);
   int y2 = y1 + 25;
   if(!Button_Apply.Create(0, "Button_Apply", 0, x1, y1, x2, y2))
      return(false);
   if(In_Languages == 0)
     {
      if(!Button_Apply.Text("Apply"))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!Button_Apply.Text("Применить"))
            return(false);
        }
   if(!Button_Apply.Font(Var_FontGeneral))
      return(false);
   if(!Button_Apply.FontSize(Var_FontSizeGeneral))
      return(false);
   if(!Add(Button_Apply))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelSettings::CreateButton_Exit(void)
  {
   int x1 = Button_Apply.Width() + 10;
   int y1 = PanelSettings.Height() - 58;
   int x2 = x1 + ((W_PanelSettings - X_PanelSettings - 23) / 2);
   int y2 = y1 + 25;
   if(!Button_Exit.Create(0, "Button_Exit", 0, x1, y1, x2, y2))
      return(false);
   if(In_Languages == 0)
     {
      if(!Button_Exit.Text("Exit"))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!Button_Exit.Text("Выход"))
            return(false);
        }
   if(!Button_Exit.Font(Var_FontGeneral))
      return(false);
   if(!Button_Exit.FontSize(Var_FontSizeGeneral))
      return(false);
   if(!Add(Button_Exit))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAppPanelInfo::OnClickRadioButton_ForAllSymbol(void)
  {
   if(RadioButton_ByCurrSymbol.State() == true)
     {
      RadioButton_ByCurrSymbol.State(false);
     }
   In_CalcResult = 0;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAppPanelInfo::OnClickRadioButton_ByCurrSymbol(void)
  {
   if(RadioButton_ForAllSymbol.State() == true)
     {
      RadioButton_ForAllSymbol.State(false);
     }
   In_CalcResult = 1;
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
bool CAppPanelInfo::CreateRadioButton_ForAllSymbol(void)
  {
   int x1 = 3;
   int y1 = 3;
   int x2 = x1 + ((W_PanelInfo - 20) / 2);
   int y2 = y1 + 20;
   if(!RadioButton_ForAllSymbol.Create(0, "RadioButton_ForAllSymbol", 0, x1, y1, x2, y2))
      return(false);
   if(In_Languages == 0)
     {
      if(!RadioButton_ForAllSymbol.Text("For all symbols"))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!RadioButton_ForAllSymbol.Text("Для всех символов"))
            return(false);
        }
   if(!Add(RadioButton_ForAllSymbol))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateRadioButton_ByCurrSymbol(void)
  {
   int x1 = 3 + RadioButton_ForAllSymbol.Width();
   int y1 = 3;
   int x2 = x1 + ((W_PanelInfo - 20) / 2);
   int y2 = y1 + 20;
   if(!RadioButton_ByCurrSymbol.Create(0, "RadioButton_ByCurrSymbol", 0, x1, y1, x2, y2))
      return(false);
   if(In_Languages == 0)
     {
      if(!RadioButton_ByCurrSymbol.Text("By current symbol"))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!RadioButton_ByCurrSymbol.Text("Для текущего символа"))
            return(false);
        }
   if(!Add(RadioButton_ByCurrSymbol))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateButton_D(void)
  {
   int x1 = 0;
   int y1 = RadioButton_ForAllSymbol.Height() + 5;
   int x2 = x1 + ((W_PanelInfo - 13) / 3);
   int y2 = y1 + 20;
   if(!Button_D.Create(0, "Button_D", 0, x1, y1, x2, y2))
      return(false);
   if(In_Languages == 0)
     {
      if(!Button_D.Text("Day"))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!Button_D.Text("День"))
            return(false);
        }
   if(!Button_D.Font(Var_FontGeneral))
      return(false);
   if(!Button_D.FontSize(Var_FontSizeGeneral))
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
   int y1 = RadioButton_ForAllSymbol.Height() + 5;
   int x2 = x1 + ((W_PanelInfo - 13) / 3);
   int y2 = y1 + 20;
   if(!Button_W.Create(0, "Button_W", 0, x1, y1, x2, y2))
      return(false);
   if(In_Languages == 0)
     {
      if(!Button_W.Text("Week"))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!Button_W.Text("Неделя"))
            return(false);
        }
   if(!Button_W.Font(Var_FontGeneral))
      return(false);
   if(!Button_W.FontSize(Var_FontSizeGeneral))
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
   int y1 = RadioButton_ForAllSymbol.Height() + 5;
   int x2 = x1 + ((W_PanelInfo - 13) / 3);
   int y2 = y1 + 20;
   if(!Button_M.Create(0, "Button_M", 0, x1, y1, x2, y2))
      return(false);
   if(In_Languages == 0)
     {
      if(!Button_M.Text("Month"))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!Button_M.Text("Месяц"))
            return(false);
        }
   if(!Button_M.Font(Var_FontGeneral))
      return(false);
   if(!Button_M.FontSize(Var_FontSizeGeneral))
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
   int y1 = RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_Result.Create(0, "Label_Result", 0, x1, y1, x2, y2))
      return(false);
   if(In_Languages == 0)
     {
      if(!Label_Result.Text("Result"))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!Label_Result.Text("Результат"))
            return(false);
        }
   if(!Label_Result.FontSize(Var_FontSizeGeneral))
      return(false);
   if(!Label_Result.Font(Var_FontBoldGeneral))
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
   int y1 = RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_Currency.Create(0, "Label_Currency", 0, x1, y1, x2, y2))
      return(false);
   if(In_Languages == 0)
     {
      if(!Label_Currency.Text("Currency"))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!Label_Currency.Text("Валюта"))
            return(false);
        }
   if(!Label_Currency.FontSize(Var_FontSizeGeneral))
      return(false);
   if(!Label_Currency.Font(Var_FontBoldGeneral))
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
   int y1 = RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_Percent.Create(0, "Label_Percent", 0, x1, y1, x2, y2))
      return(false);
   if(In_Languages == 0)
     {
      if(!Label_Percent.Text("Percent"))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!Label_Percent.Text("Процент"))
            return(false);
        }
   if(!Label_Percent.FontSize(Var_FontSizeGeneral))
      return(false);
   if(!Label_Percent.Font(Var_FontBoldGeneral))
      return(false);
   if(!Add(Label_Percent))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_ProfitRate(void)
  {
   int x1 = X4_PanelInfo;
   int y1 = RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_ProfitRate.Create(0, "Label_ProfitRate", 0, x1, y1, x2, y2))
      return(false);
   if(In_Languages == 0)
     {
      if(!Label_ProfitRate.Text("Profit rate"))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!Label_ProfitRate.Text("Доля прибыли"))
            return(false);
        }
   if(!Label_ProfitRate.FontSize(Var_FontSizeGeneral))
      return(false);
   if(!Label_ProfitRate.Font(Var_FontBoldGeneral))
      return(false);
   if(!Add(Label_ProfitRate))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_info_01(void)
  {
   int x1 = X1_PanelInfo;
   int y1 = Y1_PanelInfo + RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_01.Create(0, "Label_info_01", 0, x1, y1, x2, y2))
      return(false);
   if(In_Languages == 0)
     {
      if(!Label_info_01.Text("Time frame"))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!Label_info_01.Text("Период"))
            return(false);
        }
   if(!Label_info_01.FontSize(Var_FontSizeGeneral))
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
   int y1 = Y2_PanelInfo + RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_02.Create(0, "Label_info_02", 0, x1, y1, x2, y2))
      return(false);
   if(In_Languages == 0)
     {
      if(!Label_info_02.Text("Time frame"))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!Label_info_02.Text("Период"))
            return(false);
        }
   if(!Label_info_02.FontSize(Var_FontSizeGeneral))
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
   int y1 = Y3_PanelInfo + RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_03.Create(0, "Label_info_03", 0, x1, y1, x2, y2))
      return(false);
   if(In_Languages == 0)
     {
      if(!Label_info_03.Text("Time frame"))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!Label_info_03.Text("Период"))
            return(false);
        }
   if(!Label_info_03.FontSize(Var_FontSizeGeneral))
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
   int y1 = Y4_PanelInfo + RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_04.Create(0, "Label_info_04", 0, x1, y1, x2, y2))
      return(false);
   if(In_Languages == 0)
     {
      if(!Label_info_04.Text("Time frame"))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!Label_info_04.Text("Период"))
            return(false);
        }
   if(!Label_info_04.FontSize(Var_FontSizeGeneral))
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
   int y1 = Y5_PanelInfo + RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_05.Create(0, "Label_info_05", 0, x1, y1, x2, y2))
      return(false);
   if(In_Languages == 0)
     {
      if(!Label_info_05.Text("Time frame"))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!Label_info_05.Text("Период"))
            return(false);
        }
   if(!Label_info_05.FontSize(Var_FontSizeGeneral))
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
   int y1 = Y6_PanelInfo + RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_06.Create(0, "Label_info_06", 0, x1, y1, x2, y2))
      return(false);
   if(In_Languages == 0)
     {
      if(!Label_info_06.Text("Time frame"))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!Label_info_06.Text("Период"))
            return(false);
        }
   if(!Label_info_06.FontSize(Var_FontSizeGeneral))
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
   int y1 = Y7_PanelInfo + RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_07.Create(0, "Label_info_07", 0, x1, y1, x2, y2))
      return(false);
   if(In_Languages == 0)
     {
      if(!Label_info_07.Text("Time frame"))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!Label_info_07.Text("Период"))
            return(false);
        }
   if(!Label_info_07.FontSize(Var_FontSizeGeneral))
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
   int y1 = Y1_PanelInfo + RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_11.Create(0, "Label_info_11", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_11.Text(AccountInfoString(ACCOUNT_CURRENCY) + " " + SymbolOfCurrency))
      return(false);
   if(!Label_info_11.FontSize(Var_FontSizeGeneral))
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
   int y1 = Y2_PanelInfo + RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_12.Create(0, "Label_info_12", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_12.Text(AccountInfoString(ACCOUNT_CURRENCY) + " " + SymbolOfCurrency))
      return(false);
   if(!Label_info_12.FontSize(Var_FontSizeGeneral))
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
   int y1 = Y3_PanelInfo + RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_13.Create(0, "Label_info_13", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_13.Text(AccountInfoString(ACCOUNT_CURRENCY) + " " + SymbolOfCurrency))
      return(false);
   if(!Label_info_13.FontSize(Var_FontSizeGeneral))
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
   int y1 = Y4_PanelInfo + RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_14.Create(0, "Label_info_14", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_14.Text(AccountInfoString(ACCOUNT_CURRENCY) + " " + SymbolOfCurrency))
      return(false);
   if(!Label_info_14.FontSize(Var_FontSizeGeneral))
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
   int y1 = Y5_PanelInfo + RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_15.Create(0, "Label_info_15", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_15.Text(AccountInfoString(ACCOUNT_CURRENCY) + " " + SymbolOfCurrency))
      return(false);
   if(!Label_info_15.FontSize(Var_FontSizeGeneral))
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
   int y1 = Y6_PanelInfo + RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_16.Create(0, "Label_info_16", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_16.Text(AccountInfoString(ACCOUNT_CURRENCY) + " " + SymbolOfCurrency))
      return(false);
   if(!Label_info_16.FontSize(Var_FontSizeGeneral))
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
   int y1 = Y7_PanelInfo + RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_17.Create(0, "Label_info_17", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_17.Text(AccountInfoString(ACCOUNT_CURRENCY) + " " + SymbolOfCurrency))
      return(false);
   if(!Label_info_17.FontSize(Var_FontSizeGeneral))
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
   int y1 = Y1_PanelInfo + RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_21.Create(0, "Label_info_21", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_21.Text("%"))
      return(false);
   if(!Label_info_21.FontSize(Var_FontSizeGeneral))
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
   int y1 = Y2_PanelInfo + RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_22.Create(0, "Label_info_22", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_22.Text("%"))
      return(false);
   if(!Label_info_22.FontSize(Var_FontSizeGeneral))
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
   int y1 = Y3_PanelInfo + RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_23.Create(0, "Label_info_23", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_23.Text("%"))
      return(false);
   if(!Label_info_23.FontSize(Var_FontSizeGeneral))
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
   int y1 = Y4_PanelInfo + RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_24.Create(0, "Label_info_24", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_24.Text("%"))
      return(false);
   if(!Label_info_24.FontSize(Var_FontSizeGeneral))
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
   int y1 = Y5_PanelInfo + RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_25.Create(0, "Label_info_25", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_25.Text("%"))
      return(false);
   if(!Label_info_25.FontSize(Var_FontSizeGeneral))
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
   int y1 = Y6_PanelInfo + RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_26.Create(0, "Label_info_26", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_26.Text("%"))
      return(false);
   if(!Label_info_26.FontSize(Var_FontSizeGeneral))
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
   int y1 = Y7_PanelInfo + RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_27.Create(0, "Label_info_27", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_27.Text("%"))
      return(false);
   if(!Label_info_27.FontSize(Var_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_27))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_info_31(void)
  {
   int x1 = X4_PanelInfo;
   int y1 = Y1_PanelInfo + RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_31.Create(0, "Label_info_31", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_31.Text("0/0 (0%)"))
      return(false);
   if(!Label_info_31.FontSize(Var_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_31))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_info_32(void)
  {
   int x1 = X4_PanelInfo;
   int y1 = Y2_PanelInfo + RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_32.Create(0, "Label_info_32", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_32.Text("0/0 (0%)"))
      return(false);
   if(!Label_info_32.FontSize(Var_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_32))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_info_33(void)
  {
   int x1 = X4_PanelInfo;
   int y1 = Y3_PanelInfo + RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_33.Create(0, "Label_info_33", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_33.Text("0/0 (0%)"))
      return(false);
   if(!Label_info_33.FontSize(Var_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_33))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_info_34(void)
  {
   int x1 = X4_PanelInfo;
   int y1 = Y4_PanelInfo + RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_34.Create(0, "Label_info_34", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_34.Text("0/0 (0%)"))
      return(false);
   if(!Label_info_34.FontSize(Var_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_34))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_info_35(void)
  {
   int x1 = X4_PanelInfo;
   int y1 = Y5_PanelInfo + RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_35.Create(0, "Label_info_35", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_35.Text("0/0 (0%)"))
      return(false);
   if(!Label_info_35.FontSize(Var_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_35))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_info_36(void)
  {
   int x1 = X4_PanelInfo;
   int y1 = Y6_PanelInfo + RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_36.Create(0, "Label_info_36", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_36.Text("0/0 (0%)"))
      return(false);
   if(!Label_info_36.FontSize(Var_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_36))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanelInfo::CreateLabel_info_37(void)
  {
   int x1 = X4_PanelInfo;
   int y1 = Y7_PanelInfo + RadioButton_ForAllSymbol.Height() + Button_D.Height() + 8;
   int x2 = x1 + 10;
   int y2 = y1 + 5;
   if(!Label_info_37.Create(0, "Label_info_37", 0, x1, y1, x2, y2))
      return(false);
   if(!Label_info_37.Text("0/0 (0%)"))
      return(false);
   if(!Label_info_37.FontSize(Var_FontSizeGeneral))
      return(false);
   if(!Add(Label_info_37))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanel::CreateButton_Buy(void)
  {
   int x1 = W_Panel - 114;
   int y1 = 3;
   int x2 = x1 + X_Button;
   int y2 = y1 + Y_Button;
   if(!Button_Buy.Create(0, "Button_Buy", 0, x1, y1, x2, y2))
      return(false);
   if(!Button_Buy.Text("BUY"))
      return(false);
   if(!Button_Buy.Font(Var_FontBoldGeneral))
      return(false);
   if(!Button_Buy.FontSize(Var_FontSizeGeneral * 2))
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
   int x1 = W_Panel - 114;
   int y1 = 3 + 5 + Y_Button;
   int x2 = x1 + X_Button;
   int y2 = y1 + Y_Button;
   if(!Button_Sell.Create(0, "Button_Sell", 0, x1, y1, x2, y2))
      return(false);
   if(!Button_Sell.Text("SELL"))
      return(false);
   if(!Button_Sell.Font(Var_FontBoldGeneral))
      return(false);
   if(!Button_Sell.FontSize(Var_FontSizeGeneral * 2))
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
bool CAppPanel::CreateLabel_Risk(void)
  {
   int x1 = 3;
   int y1 = 1;
   int x2 = 10;
   int y2 = 10;
   if(!Label_Risk.Create(0, "Label_Risk", 0, x1, y1, x2, y2))
      return(false);
   if(In_Languages == 0)
     {
      if(!Label_Risk.Text("Risk, %"))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!Label_Risk.Text("Риск, %"))
            return(false);
        }
   if(!Label_Risk.FontSize(Var_FontSizeGeneral))
      return(false);
   if(!Add(Label_Risk))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanel::CreateEdit_Risk(void)
  {
   int x1 = 3;
   int y1 = 18;
   int x2 = x1 + 66;
   if(In_SEdit_FixValue == 1)
      x2 = x1 + 83;
   int y2 = y1 + 20;
   if(!Edit_Risk.Create(0, "Edit_Risk", 0, x1, y1, x2, y2))
      return(false);
   if(!Edit_Risk.Text(DoubleToStr(Var_RiskPercent, 2)))
      return(false);
   if(!Edit_Risk.FontSize(Var_FontSizeGeneral))
      return(false);
   if(In_SEdit_FixValue == 1)
     {
      Var_RiskPercent = 1.00;
      if(!Edit_Risk.Text("1.00"))
         return(false);
      if(!Edit_Risk.ReadOnly(true))
         return(false);
     }
   if(!Add(Edit_Risk))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanel::CreateLabel_SL(void)
  {
   int x1 = 3;
   int y1 = 36;
   int x2 = 10;
   int y2 = 10;
   if(!Label_SL.Create(0, "Label_SL", 0, x1, y1, x2, y2))
      return(false);
   if(In_Languages == 0)
     {
      if(!Label_SL.Text("Stop Loss"))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!Label_SL.Text("Стоп-лосс"))
            return(false);
        }
   if(!Label_SL.FontSize(Var_FontSizeGeneral))
      return(false);
   if(!Add(Label_SL))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanel::CreateEdit_SL(void)
  {
   int x1 = 3;
   int y1 = 53;
   int x2 = x1 + 83;
   int y2 = y1 + 20;
   if(!Edit_SL.Create(0, "Edit_SL", 0, x1, y1, x2, y2))
      return(false);
   if(!Edit_SL.Text(IntegerToString(Var_StopLoss)))
      return(false);
   if(!Edit_SL.FontSize(Var_FontSizeGeneral))
      return(false);
   if(!Add(Edit_SL))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanel::CreateLabel_SafeTP(void)
  {
   int x1 = 3;
   int y1 = 71;
   int x2 = 10;
   int y2 = 10;
   if(!Label_SafeTP.Create(0, "Label_SafeTP", 0, x1, y1, x2, y2))
      return(false);
   if(In_Languages == 0)
     {
      if(!Label_SafeTP.Text("'Safe' ..."))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!Label_SafeTP.Text("'Сейф' ..."))
            return(false);
        }
   if(!Label_SafeTP.FontSize(Var_FontSizeGeneral))
      return(false);
   if(!Add(Label_SafeTP))
      return(false);
   if(In_ISafe_OnOff == 0)
      if(!Label_SafeTP.Hide())
         return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanel::CreateComboBox_SafeTP(void)
  {
   int x1 = 3;
   int y1 = 88;
   int x2 = x1 + 83;
   int y2 = y1 + 20;
   ComboBox_SafeTP.ListViewItems(3);
   if(!ComboBox_SafeTP.Create(0, "ComboBox_SafeTP", 0, x1, y1, x2, y2))
      return(false);
   if(!Add(ComboBox_SafeTP))
      return(false);
   if(In_Languages == 0)
     {
      if(!ComboBox_SafeTP.ItemAdd(set_Safe1_En))
         return(false);
      if(!ComboBox_SafeTP.ItemAdd(set_Safe2_En))
         return(false);
      if(!ComboBox_SafeTP.ItemAdd(set_Safe3_En))
         return(false);
     }
   else
      if(In_Languages == 1)
        {
         if(!ComboBox_SafeTP.ItemAdd(set_Safe1_Ru))
            return(false);
         if(!ComboBox_SafeTP.ItemAdd(set_Safe2_Ru))
            return(false);
         if(!ComboBox_SafeTP.ItemAdd(set_Safe3_Ru))
            return(false);
        }
   if(!ComboBox_SafeTP.Select(0))
      return(false);
   if(In_ISafe_OnOff == 0)
      if(!ComboBox_SafeTP.Hide())
         return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CAppPanel::CreateEditButton_Up(void)
  {
   int x1 = 70;
   int y1 = 12;
   int x2 = x1 + 16;
   int y2 = y1 + 16;
   if(!EditButton_Up.Create(0, "EditButton_Up", 0, x1, y1, x2, y2))
      return(false);
   if(!EditButton_Up.BmpNames("::res\\Up.bmp", "::res\\UpDisable.bmp"))
      return(false);
   if(In_SEdit_FixValue == 1)
      if(!EditButton_Up.Hide())
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
   int x1 = 70;
   int y1 = 28;
   int x2 = x1 + 16;
   int y2 = y1 + 16;
   if(!EditButton_Down.Create(0, "EditButton_Down", 0, x1, y1, x2, y2))
      return(false);
   if(!EditButton_Down.BmpNames("::res\\Down.bmp", "::res\\DownDisable.bmp"))
      return(false);
   if(In_SEdit_FixValue == 1)
      if(!EditButton_Down.Hide())
         return(false);
   if(!Add(EditButton_Down))
      return(false);
   return(true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CalculateLotSize()
  {
   double iprofit = 0.0;
   if(In_IProfit == 0)
     {
      if(AccountFreeMargin() <= AccountBalance())
        {
         iprofit = AccountFreeMargin();
        }
      else
        {
         iprofit = AccountBalance();
        }
     }
   else
      if(In_IProfit == 1)
        {
         iprofit = AccountBalance();
        }
      else
         if(In_IProfit == 2)
           {
            if(AccountEquity() <= AccountBalance())
              {
               iprofit = AccountEquity();
              }
            else
              {
               iprofit = AccountBalance();
              }
           }
   double LotValue = MarketInfo(Symbol(), MODE_TICKVALUE);
   double Min_Lot = MarketInfo(Symbol(), MODE_MINLOT);
   double Max_Lot = MarketInfo(Symbol(), MODE_MAXLOT);
   double Step = MarketInfo(Symbol(), MODE_LOTSTEP);
   double Lot = MathFloor((iprofit * Var_RiskPercent / 100) / (Var_StopLoss * LotValue) / Step) * Step;
   int MSBoxResult = 0;
//
   if(Lot < Min_Lot)
     {
      if(In_Languages == 0)
        {
         MSBoxResult = MessageBox("Insufficient funds for the given parameters:" +
                                  "\nBalance = " + DoubleToString(iprofit, 2) + " " + SymbolOfCurrency +
                                  "\nRisk = " + DoubleToString(Var_RiskPercent, 2) + " % " + "StopLoss = " + IntegerToString(Var_StopLoss) +
                                  "\nRequired balance = " + DoubleToString((Min_Lot * LotValue * Var_StopLoss) * 100 / Var_RiskPercent, 2) + " " + SymbolOfCurrency +
                                  "\n\nThe calculated lot size of this deal\n is less than the allowed value (" + DoubleToString(Lot, 2) + " < " + DoubleToString(Min_Lot, 2) + ") " +
                                  "\n\nTo open a trade, the minimum\n volume value will be set (" + DoubleToString(Min_Lot, 2) + ") " +
                                  "\n\nWhich will also lead to an\n increase in the established risk " + DoubleToString(Var_RiskPercent, 2) + " % " +
                                  "\n\nYour Acceptable Risk = " + DoubleToString((iprofit * Var_RiskPercent / 100), 2) + " " + SymbolOfCurrency + " (" + DoubleToString(Var_RiskPercent, 2) + " %)" +
                                  "\nRisk if you continue = " + DoubleToString((Min_Lot * LotValue * Var_StopLoss), 2) + " " + SymbolOfCurrency + " (" + DoubleToString((Min_Lot * LotValue * Var_StopLoss) * 100 / iprofit, 2) + " %)" +
                                  "\n\nDo you want to continue?", "Attention", MB_YESNO | MB_ICONWARNING);
        }
      else
         if(In_Languages == 1)
           {
            MSBoxResult = MessageBox("Недостаточно средств, для заданных параметров:" +
                                     "\nБаланс = " + DoubleToString(iprofit, 2) + " " + SymbolOfCurrency +
                                     "\nРиск = " + DoubleToString(Var_RiskPercent, 2) + " % " + "Стоп-лосс = " + IntegerToString(Var_StopLoss) +
                                     "\nНеобходимый баланс = " + DoubleToString((Min_Lot * LotValue * Var_StopLoss) * 100 / Var_RiskPercent, 2) + " " + SymbolOfCurrency +
                                     "\n\n\nРассчитанный объём лота данной сделки \nменьше допустимого значения (" + DoubleToString(Lot, 2) + " < " + DoubleToString(Min_Lot, 2) + ") " +
                                     "\n\nДля открытия сделки будет установленно \nминимальное значение объёма (" + DoubleToString(Min_Lot, 2) + ") " +
                                     "\n\nЧто так же приведёт к \nпривышению установленного риска " + DoubleToString(Var_RiskPercent, 2) + " % " +
                                     "\n\nВаш допустимый риск = " + DoubleToString((iprofit * Var_RiskPercent / 100), 2) + " " + SymbolOfCurrency + " (" + DoubleToString(Var_RiskPercent, 2) + " %)" +
                                     "\nРиск если вы продолжите = " + DoubleToString((Min_Lot * LotValue * Var_StopLoss), 2) + " " + SymbolOfCurrency + " (" + DoubleToString((Min_Lot * LotValue * Var_StopLoss) * 100 / iprofit, 2) + " %)" +
                                     "\n\nХотите продолжить?", "Внимание", MB_YESNO | MB_ICONWARNING);
           }
      if(MSBoxResult == IDYES)
        {
         Lot = Min_Lot;
        }
      else
         if(MSBoxResult == IDNO)
           {
            Lot = 0;
           }
     }
//
   if(In_ISafe == 1)
     {
      if(Lot < (Min_Lot + Min_Lot))
        {
         if(In_Languages == 0)
           {
            MSBoxResult = MessageBox("Insufficient funds for the given parameters:" +
                                     "\nBalance = " + DoubleToString(iprofit, 2) + " " + SymbolOfCurrency +
                                     "\nRisk = " + DoubleToString(Var_RiskPercent, 2) + " % " + "StopLoss = " + IntegerToString(Var_StopLoss) +
                                     "\nRequired balance = " + DoubleToString((Min_Lot * LotValue * Var_StopLoss) * 100 / Var_RiskPercent, 2) + " " + SymbolOfCurrency +
                                     "\n\nThe calculated lot size of this deal\n is less than the allowed value (" + DoubleToString(Lot, 2) + " < " + DoubleToString(Min_Lot, 2) + ") " +
                                     "\n\nTo open a trade, the minimum\n volume value will be set (" + DoubleToString(Min_Lot, 2) + ") " +
                                     "\n\nWhich will also lead to an\n increase in the established risk " + DoubleToString(Var_RiskPercent, 2) + " % " +
                                     "\n\nYour Acceptable Risk = " + DoubleToString((iprofit * Var_RiskPercent / 100), 2) + " " + SymbolOfCurrency + " (" + DoubleToString(Var_RiskPercent, 2) + " %)" +
                                     "\nRisk if you continue = " + DoubleToString((Min_Lot * LotValue * Var_StopLoss), 2) + " " + SymbolOfCurrency + " (" + DoubleToString((Min_Lot * LotValue * Var_StopLoss) * 100 / iprofit, 2) + " %)" +
                                     "\n\nDo you want to continue?", "Attention", MB_YESNO | MB_ICONWARNING);
           }
         else
            if(In_Languages == 1)
              {
               MSBoxResult = MessageBox("Недостаточно средств, для заданных параметров:" +
                                        "\nБаланс = " + DoubleToString(iprofit, 2) + " " + SymbolOfCurrency +
                                        "\nРиск = " + DoubleToString(Var_RiskPercent, 2) + " % " + "Стоп-лосс = " + IntegerToString(Var_StopLoss) +
                                        "\nНеобходимый баланс = " + DoubleToString(((Min_Lot + Min_Lot) * LotValue * Var_StopLoss) * 100 / Var_RiskPercent, 2) + " " + SymbolOfCurrency +
                                        "\n\n\nРассчитанный объём лота данной сделки \nменьше допустимого значения (" + DoubleToString(Lot, 2) + " < " + DoubleToString((Min_Lot + Min_Lot), 2) + ") " +
                                        "\n\nДля открытия сделки будет установленно \nминимальное значение объёма (" + DoubleToString((Min_Lot + Min_Lot), 2) + ") " +
                                        "\n\nЧто так же приведёт к \nпривышению установленного риска " + DoubleToString(Var_RiskPercent, 2) + " % " +
                                        "\n\nВаш допустимый риск = " + DoubleToString((iprofit * Var_RiskPercent / 100), 2) + " " + SymbolOfCurrency + " (" + DoubleToString(Var_RiskPercent, 2) + " %)" +
                                        "\nРиск если вы продолжите = " + DoubleToString(((Min_Lot + Min_Lot) * LotValue * Var_StopLoss), 2) + " " + SymbolOfCurrency + " (" + DoubleToString(((Min_Lot + Min_Lot) * LotValue * Var_StopLoss) * 100 / iprofit, 2) + " %)" +
                                        "\n\nХотите продолжить?", "Внимание", MB_YESNO | MB_ICONWARNING);
              }
         if(MSBoxResult == IDYES)
           {
            Lot = (Min_Lot + Min_Lot);
           }
         else
            if(MSBoxResult == IDNO)
              {
               Lot = 0;
              }
        }
     }
   else
      if(In_ISafe == 2)
        {
         if(Lot < (Min_Lot + Min_Lot + Min_Lot + Min_Lot))
           {
            if(In_Languages == 0)
              {
               MSBoxResult = MessageBox("Insufficient funds for the given parameters:" +
                                        "\nBalance = " + DoubleToString(iprofit, 2) + " " + SymbolOfCurrency +
                                        "\nRisk = " + DoubleToString(Var_RiskPercent, 2) + " % " + "StopLoss = " + IntegerToString(Var_StopLoss) +
                                        "\nRequired balance = " + DoubleToString((Min_Lot * LotValue * Var_StopLoss) * 100 / Var_RiskPercent, 2) + " " + SymbolOfCurrency +
                                        "\n\nThe calculated lot size of this deal\n is less than the allowed value (" + DoubleToString(Lot, 2) + " < " + DoubleToString(Min_Lot, 2) + ") " +
                                        "\n\nTo open a trade, the minimum\n volume value will be set (" + DoubleToString(Min_Lot, 2) + ") " +
                                        "\n\nWhich will also lead to an\n increase in the established risk " + DoubleToString(Var_RiskPercent, 2) + " % " +
                                        "\n\nYour Acceptable Risk = " + DoubleToString((iprofit * Var_RiskPercent / 100), 2) + " " + SymbolOfCurrency + " (" + DoubleToString(Var_RiskPercent, 2) + " %)" +
                                        "\nRisk if you continue = " + DoubleToString((Min_Lot * LotValue * Var_StopLoss), 2) + " " + SymbolOfCurrency + " (" + DoubleToString((Min_Lot * LotValue * Var_StopLoss) * 100 / iprofit, 2) + " %)" +
                                        "\n\nDo you want to continue?", "Attention", MB_YESNO | MB_ICONWARNING);
              }
            else
               if(In_Languages == 1)
                 {
                  MSBoxResult = MessageBox("Недостаточно средств, для заданных параметров:" +
                                           "\nБаланс = " + DoubleToString(iprofit, 2) + " " + SymbolOfCurrency +
                                           "\nРиск = " + DoubleToString(Var_RiskPercent, 2) + " % " + "Стоп-лосс = " + IntegerToString(Var_StopLoss) +
                                           "\nНеобходимый баланс = " + DoubleToString(((Min_Lot + Min_Lot + Min_Lot + Min_Lot) * LotValue * Var_StopLoss) * 100 / Var_RiskPercent, 2) + " " + SymbolOfCurrency +
                                           "\n\n\nРассчитанный объём лота данной сделки \nменьше допустимого значения (" + DoubleToString(Lot, 2) + " < " + DoubleToString((Min_Lot + Min_Lot + Min_Lot + Min_Lot), 2) + ") " +
                                           "\n\nДля открытия сделки будет установленно \nминимальное значение объёма (" + DoubleToString((Min_Lot + Min_Lot + Min_Lot + Min_Lot), 2) + ") " +
                                           "\n\nЧто так же приведёт к \nпривышению установленного риска " + DoubleToString(Var_RiskPercent, 2) + " % " +
                                           "\n\nВаш допустимый риск = " + DoubleToString((iprofit * Var_RiskPercent / 100), 2) + " " + SymbolOfCurrency + " (" + DoubleToString(Var_RiskPercent, 2) + " %)" +
                                           "\nРиск если вы продолжите = " + DoubleToString(((Min_Lot + Min_Lot + Min_Lot + Min_Lot) * LotValue * Var_StopLoss), 2) + " " + SymbolOfCurrency + " (" + DoubleToString(((Min_Lot + Min_Lot + Min_Lot + Min_Lot) * LotValue * Var_StopLoss) * 100 / iprofit, 2) + " %)" +
                                           "\n\nХотите продолжить?", "Внимание", MB_YESNO | MB_ICONWARNING);
                 }
            if(MSBoxResult == IDYES)
              {
               Lot = (Min_Lot + Min_Lot + Min_Lot + Min_Lot);
              }
            else
               if(MSBoxResult == IDNO)
                 {
                  Lot = 0;
                 }
           }
        }
//
   if(Lot > Max_Lot)
     {
      if(In_Languages == 0)
        {
         MSBoxResult = MessageBox("The lot size of this deal\n is larger than the allowed value (" + DoubleToString(Lot, 2) + " > " + DoubleToString(Max_Lot, 2) + ") " +
                                  "\n\nTo open a trade, the maximum\n value of the volume will be set (" + DoubleToString(Max_Lot, 2) + "). " +
                                  "\n\nDo you want to continue?", "Attention", MB_YESNO | MB_ICONWARNING);
        }
      else
         if(In_Languages == 1)
           {
            MSBoxResult = MessageBox("Объём лота данной сделки больше \nдопустимого значения (" + DoubleToString(Lot, 2) + " > " + DoubleToString(Max_Lot, 2) + ") " +
                                     "\n\nДля открытия сделки будет установленно \nмаксимальное значение объёма (" + DoubleToString(Max_Lot, 2) + "). " +
                                     "\n\nХотите продолжить?", "Внимание", MB_YESNO | MB_ICONWARNING);
           }
      if(MSBoxResult == IDYES)
        {
         Lot = Max_Lot;
        }
      else
         if(MSBoxResult == IDNO)
           {
            Lot = Lot;
           }
     }
//
   Var_Lots = NormalizeDouble(Lot, var_CountVolumeStep);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OpenOrder(int type, double price)
  {
   int ticket;
   string strErr = "";
   double sl = 0.0;
   double tp1 = 0.0;
   double tp2 = 0.0;
   double tp3 = 0.0;
   double Var_Lots1 = 0.0;
   double Var_Lots2 = 0.0;
   double Var_Lots3 = 0.0;
//
   if(In_ISafe_OnOff == 1)
     {
      string s_isafetp = ObjectGetString(0, "ComboBox_SafeTPEdit", OBJPROP_TEXT);
      if((s_isafetp == set_Safe1_En) || (s_isafetp == set_Safe1_Ru))
        {
         In_ISafe = 0;
        }
      else
         if((s_isafetp == set_Safe2_En) || (s_isafetp == set_Safe2_Ru))
           {
            In_ISafe = 1;
           }
         else
            if((s_isafetp == set_Safe3_En) || (s_isafetp == set_Safe3_Ru))
              {
               In_ISafe = 2;
              }
     }
   else
     {
      In_ISafe = 0;
     }
//
   CalculateLotSize();
//
   if(Var_Lots == 0)
      return;
//
   if(In_ISafe == 0)
     {
      Var_Lots1 = NormalizeDouble(Var_Lots, var_CountVolumeStep);
      if(type == OP_BUY)
        {
         sl = price - (Var_StopLoss * Point());
         tp1 = price + (3 * Var_StopLoss * Point());
         ticket = OrderSend(NULL, OP_BUY, Var_Lots1, price, Slippage, sl, tp1, "Manager", Magic, 0, clrNONE);
         if(ticket < 0)
           {
            if(In_Languages == 0)
              {
               strErr = "(Lot=" + DoubleToString(Var_Lots1, 2) + ") (Price=" + DoubleToString(price, Digits()) + ") (Stop=" + DoubleToString(sl, Digits()) + ") (Take=" + DoubleToString(tp1, Digits()) + ")";
               MessageBox((GetError("Open", GetLastError()) + "\r\n" + strErr), "Error", MB_OK | MB_ICONWARNING);
              }
            else
               if(In_Languages == 1)
                 {
                  strErr = "(Лот=" + DoubleToString(Var_Lots1, 2) + ") (Цена=" + DoubleToString(price, Digits()) + ") (Стоп=" + DoubleToString(sl, Digits()) + ") (Тейк=" + DoubleToString(tp1, Digits()) + ")";
                  MessageBox((GetError("Open", GetLastError()) + "\r\n" + strErr), "Ошибка", MB_OK | MB_ICONWARNING);
                 }
           }
        }
      if(type == OP_SELL)
        {
         sl = price + (Var_StopLoss * Point());
         tp1 = price - (3 * Var_StopLoss * Point());
         ticket = OrderSend(NULL, OP_SELL, Var_Lots1, price, Slippage, sl, tp1, "Manager", Magic, 0, clrNONE);
         if(ticket < 0)
           {
            if(In_Languages == 0)
              {
               strErr = "(Lot=" + DoubleToString(Var_Lots1, 2) + ") (Price=" + DoubleToString(price, Digits()) + ") (Stop=" + DoubleToString(sl, Digits()) + ") (Take=" + DoubleToString(tp1, Digits()) + ")";
               MessageBox((GetError("Open", GetLastError()) + "\r\n" + strErr), "Error", MB_OK | MB_ICONWARNING);
              }
            else
               if(In_Languages == 1)
                 {
                  strErr = "(Лот=" + DoubleToString(Var_Lots1, 2) + ") (Цена=" + DoubleToString(price, Digits()) + ") (Стоп=" + DoubleToString(sl, Digits()) + ") (Тейк=" + DoubleToString(tp1, Digits()) + ")";
                  MessageBox((GetError("Open", GetLastError()) + "\r\n" + strErr), "Ошибка", MB_OK | MB_ICONWARNING);
                 }
           }
        }
     }
   else
      if(In_ISafe == 1)
        {
         Var_Lots2 = NormalizeDouble(Var_Lots / 2, var_CountVolumeStep);
         Var_Lots1 = NormalizeDouble(Var_Lots - Var_Lots2, var_CountVolumeStep);
         if(type == OP_BUY)
           {
            sl = price - (Var_StopLoss * Point());
            tp1 = price + (3 * Var_StopLoss * Point());
            tp2 = price + (2 * Var_StopLoss * Point());
            ticket = OrderSend(NULL, OP_BUY, Var_Lots1, price, Slippage, sl, tp1, "Manager", Magic, 0, clrNONE);
            if(ticket < 0)
              {
               if(In_Languages == 0)
                 {
                  strErr = "(Lot=" + DoubleToString(Var_Lots1, 2) + ") (Price=" + DoubleToString(price, Digits()) + ") (Stop=" + DoubleToString(sl, Digits()) + ") (Take=" + DoubleToString(tp1, Digits()) + ")";
                  MessageBox((GetError("Open", GetLastError()) + "\r\n" + strErr), "Error", MB_OK | MB_ICONWARNING);
                 }
               else
                  if(In_Languages == 1)
                    {
                     strErr = "(Лот=" + DoubleToString(Var_Lots1, 2) + ") (Цена=" + DoubleToString(price, Digits()) + ") (Стоп=" + DoubleToString(sl, Digits()) + ") (Тейк=" + DoubleToString(tp1, Digits()) + ")";
                     MessageBox((GetError("Open", GetLastError()) + "\r\n" + strErr), "Ошибка", MB_OK | MB_ICONWARNING);
                    }
              }
            ticket = OrderSend(NULL, OP_BUY, Var_Lots2, price, Slippage, sl, tp2, "Manager", Magic, 0, clrNONE);
            if(ticket < 0)
              {
               if(In_Languages == 0)
                 {
                  strErr = "(Lot=" + DoubleToString(Var_Lots2, 2) + ") (Price=" + DoubleToString(price, Digits()) + ") (Stop=" + DoubleToString(sl, Digits()) + ") (Take=" + DoubleToString(tp2, Digits()) + ")";
                  MessageBox((GetError("Open", GetLastError()) + "\r\n" + strErr), "Ошибка", MB_OK | MB_ICONWARNING);
                 }
               else
                  if(In_Languages == 1)
                    {
                     strErr = "(Лот=" + DoubleToString(Var_Lots2, 2) + ") (Цена=" + DoubleToString(price, Digits()) + ") (Стоп=" + DoubleToString(sl, Digits()) + ") (Тейк=" + DoubleToString(tp2, Digits()) + ")";
                     MessageBox((GetError("Open", GetLastError()) + "\r\n" + strErr), "Ошибка", MB_OK | MB_ICONWARNING);
                    }
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
               if(In_Languages == 0)
                 {
                  strErr = "(Lot=" + DoubleToString(Var_Lots1, 2) + ") (Price=" + DoubleToString(price, Digits()) + ") (Stop=" + DoubleToString(sl, Digits()) + ") (Take=" + DoubleToString(tp1, Digits()) + ")";
                  MessageBox((GetError("Open", GetLastError()) + "\r\n" + strErr), "Error", MB_OK | MB_ICONWARNING);
                 }
               else
                  if(In_Languages == 1)
                    {
                     strErr = "(Лот=" + DoubleToString(Var_Lots1, 2) + ") (Цена=" + DoubleToString(price, Digits()) + ") (Стоп=" + DoubleToString(sl, Digits()) + ") (Тейк=" + DoubleToString(tp1, Digits()) + ")";
                     MessageBox((GetError("Open", GetLastError()) + "\r\n" + strErr), "Ошибка", MB_OK | MB_ICONWARNING);
                    }
              }
            ticket = OrderSend(NULL, OP_SELL, Var_Lots2, price, Slippage, sl, tp2, "Manager", Magic, 0, clrNONE);
            if(ticket < 0)
              {
               if(In_Languages == 0)
                 {
                  strErr = "(Lot=" + DoubleToString(Var_Lots2, 2) + ") (Price=" + DoubleToString(price, Digits()) + ") (Stop=" + DoubleToString(sl, Digits()) + ") (Take=" + DoubleToString(tp2, Digits()) + ")";
                  MessageBox((GetError("Open", GetLastError()) + "\r\n" + strErr), "Error", MB_OK | MB_ICONWARNING);
                 }
               else
                  if(In_Languages == 1)
                    {
                     strErr = "(Лот=" + DoubleToString(Var_Lots2, 2) + ") (Цена=" + DoubleToString(price, Digits()) + ") (Стоп=" + DoubleToString(sl, Digits()) + ") (Тейк=" + DoubleToString(tp2, Digits()) + ")";
                     MessageBox((GetError("Open", GetLastError()) + "\r\n" + strErr), "Ошибка", MB_OK | MB_ICONWARNING);
                    }
              }
           }
        }
      else
         if(In_ISafe == 2)
           {
            Var_Lots3 = NormalizeDouble(Var_Lots / 2, var_CountVolumeStep);
            Var_Lots2 = NormalizeDouble((Var_Lots - Var_Lots3) / 2, var_CountVolumeStep);
            Var_Lots1 = NormalizeDouble(Var_Lots - Var_Lots3 - Var_Lots2, var_CountVolumeStep);
            if(type == OP_BUY)
              {
               sl = price - (Var_StopLoss * Point());
               tp1 = price + (3 * Var_StopLoss * Point());
               tp2 = price + (2 * Var_StopLoss * Point());
               tp3 = price + (1 * Var_StopLoss * Point());
               ticket = OrderSend(NULL, OP_BUY, Var_Lots1, price, Slippage, sl, tp1, "Manager", Magic, 0, clrNONE);
               if(ticket < 0)
                 {
                  if(In_Languages == 0)
                    {
                     strErr = "(Lot=" + DoubleToString(Var_Lots1, 2) + ") (Price=" + DoubleToString(price, Digits()) + ") (Stop=" + DoubleToString(sl, Digits()) + ") (Take=" + DoubleToString(tp1, Digits()) + ")";
                     MessageBox((GetError("Open", GetLastError()) + "\r\n" + strErr), "Error", MB_OK | MB_ICONWARNING);
                    }
                  else
                     if(In_Languages == 1)
                       {
                        strErr = "(Лот=" + DoubleToString(Var_Lots1, 2) + ") (Цена=" + DoubleToString(price, Digits()) + ") (Стоп=" + DoubleToString(sl, Digits()) + ") (Тейк=" + DoubleToString(tp1, Digits()) + ")";
                        MessageBox((GetError("Open", GetLastError()) + "\r\n" + strErr), "Ошибка", MB_OK | MB_ICONWARNING);
                       }
                 }
               ticket = OrderSend(NULL, OP_BUY, Var_Lots2, price, Slippage, sl, tp2, "Manager", Magic, 0, clrNONE);
               if(ticket < 0)
                 {
                  if(In_Languages == 0)
                    {
                     strErr = "(Lot=" + DoubleToString(Var_Lots2, 2) + ") (Price=" + DoubleToString(price, Digits()) + ") (Stop=" + DoubleToString(sl, Digits()) + ") (Take=" + DoubleToString(tp2, Digits()) + ")";
                     MessageBox((GetError("Open", GetLastError()) + "\r\n" + strErr), "Error", MB_OK | MB_ICONWARNING);
                    }
                  else
                     if(In_Languages == 1)
                       {
                        strErr = "(Лот=" + DoubleToString(Var_Lots2, 2) + ") (Цена=" + DoubleToString(price, Digits()) + ") (Стоп=" + DoubleToString(sl, Digits()) + ") (Тейк=" + DoubleToString(tp2, Digits()) + ")";
                        MessageBox((GetError("Open", GetLastError()) + "\r\n" + strErr), "Ошибка", MB_OK | MB_ICONWARNING);
                       }
                 }
               ticket = OrderSend(NULL, OP_BUY, Var_Lots3, price, Slippage, sl, tp3, "Manager", Magic, 0, clrNONE);
               if(ticket < 0)
                 {
                  if(In_Languages == 0)
                    {
                     strErr = "(Lot=" + DoubleToString(Var_Lots3, 2) + ") (Price=" + DoubleToString(price, Digits()) + ") (Stop=" + DoubleToString(sl, Digits()) + ") (Take=" + DoubleToString(tp3, Digits()) + ")";
                     MessageBox((GetError("Open", GetLastError()) + "\r\n" + strErr), "Error", MB_OK | MB_ICONWARNING);
                    }
                  else
                     if(In_Languages == 1)
                       {
                        strErr = "(Лот=" + DoubleToString(Var_Lots3, 2) + ") (Цена=" + DoubleToString(price, Digits()) + ") (Стоп=" + DoubleToString(sl, Digits()) + ") (Тейк=" + DoubleToString(tp3, Digits()) + ")";
                        MessageBox((GetError("Open", GetLastError()) + "\r\n" + strErr), "Ошибка", MB_OK | MB_ICONWARNING);
                       }
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
                  if(In_Languages == 0)
                    {
                     strErr = "(Lot=" + DoubleToString(Var_Lots1, 2) + ") (Price=" + DoubleToString(price, Digits()) + ") (Stop=" + DoubleToString(sl, Digits()) + ") (Take=" + DoubleToString(tp1, Digits()) + ")";
                     MessageBox((GetError("Open", GetLastError()) + "\r\n" + strErr), "Error", MB_OK | MB_ICONWARNING);
                    }
                  else
                     if(In_Languages == 1)
                       {
                        strErr = "(Лот=" + DoubleToString(Var_Lots1, 2) + ") (Цена=" + DoubleToString(price, Digits()) + ") (Стоп=" + DoubleToString(sl, Digits()) + ") (Тейк=" + DoubleToString(tp1, Digits()) + ")";
                        MessageBox((GetError("Open", GetLastError()) + "\r\n" + strErr), "Ошибка", MB_OK | MB_ICONWARNING);
                       }
                 }
               ticket = OrderSend(NULL, OP_SELL, Var_Lots2, price, Slippage, sl, tp2, "Manager", Magic, 0, clrNONE);
               if(ticket < 0)
                 {
                  if(In_Languages == 0)
                    {
                     strErr = "(Lot=" + DoubleToString(Var_Lots2, 2) + ") (Price=" + DoubleToString(price, Digits()) + ") (Stop=" + DoubleToString(sl, Digits()) + ") (Take=" + DoubleToString(tp2, Digits()) + ")";
                     MessageBox((GetError("Open", GetLastError()) + "\r\n" + strErr), "Error", MB_OK | MB_ICONWARNING);
                    }
                  else
                     if(In_Languages == 1)
                       {
                        strErr = "(Лот=" + DoubleToString(Var_Lots2, 2) + ") (Цена=" + DoubleToString(price, Digits()) + ") (Стоп=" + DoubleToString(sl, Digits()) + ") (Тейк=" + DoubleToString(tp2, Digits()) + ")";
                        MessageBox((GetError("Open", GetLastError()) + "\r\n" + strErr), "Ошибка", MB_OK | MB_ICONWARNING);
                       }
                 }
               ticket = OrderSend(NULL, OP_SELL, Var_Lots3, price, Slippage, sl, tp3, "Manager", Magic, 0, clrNONE);
               if(ticket < 0)
                 {
                  if(In_Languages == 0)
                    {
                     strErr = "(Lot=" + DoubleToString(Var_Lots3, 2) + ") (Price=" + DoubleToString(price, Digits()) + ") (Stop=" + DoubleToString(sl, Digits()) + ") (Take=" + DoubleToString(tp3, Digits()) + ")";
                     MessageBox((GetError("Open", GetLastError()) + "\r\n" + strErr), "Error", MB_OK | MB_ICONWARNING);
                    }
                  else
                     if(In_Languages == 1)
                       {
                        strErr = "(Лот=" + DoubleToString(Var_Lots3, 2) + ") (Цена=" + DoubleToString(price, Digits()) + ") (Стоп=" + DoubleToString(sl, Digits()) + ") (Тейк=" + DoubleToString(tp3, Digits()) + ")";
                        MessageBox((GetError("Open", GetLastError()) + "\r\n" + strErr), "Ошибка", MB_OK | MB_ICONWARNING);
                       }
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
   int d;
   d = StrToInteger(Edit_SL.Text());
   if(d < 0)
     {
      Edit_SL.Text(IntegerToString(0));
     }
   else
     {
      Edit_SL.Text(IntegerToString(d));
     }
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
      if(Var_RiskPercent <= 0)
        {
         if(In_Languages == 0)
           {
            MessageBox("'Risk' value cannot be 0", "Error", MB_OK | MB_ICONWARNING);
           }
         else
            if(In_Languages == 1)
              {
               MessageBox("Значение 'Риск' не может быть 0", "Ошибка", MB_OK | MB_ICONWARNING);
              }
        }
      else
         if(Var_StopLoss <= 0)
           {
            if(In_Languages == 0)
              {
               MessageBox("'Stop Loss' value cannot be 0", "Error", MB_OK | MB_ICONWARNING);
              }
            else
               if(In_Languages == 1)
                 {
                  MessageBox("Значение 'Стоп-лосс' не может быть 0", "Ошибка", MB_OK | MB_ICONWARNING);
                 }
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
      if(Var_RiskPercent <= 0)
        {
         if(In_Languages == 0)
           {
            MessageBox("'Risk' value cannot be 0", "Error", MB_OK | MB_ICONWARNING);
           }
         else
            if(In_Languages == 1)
              {
               MessageBox("Значение 'Риск' не может быть 0", "Ошибка", MB_OK | MB_ICONWARNING);
              }
        }
      else
         if(Var_StopLoss <= 0)
           {
            if(In_Languages == 0)
              {
               MessageBox("'Stop Loss' value cannot be 0", "Error", MB_OK | MB_ICONWARNING);
              }
            else
               if(In_Languages == 1)
                 {
                  MessageBox("Значение 'Стоп-лосс' не может быть 0", "Ошибка", MB_OK | MB_ICONWARNING);
                 }
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
   Var_RiskPercent = StrToDouble(Edit_Risk.Text());
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string GetError(string From, int GLError)
  {
   string s;
   if(In_Languages == 0)
     {
      if(From == "Open")
        {
         From = "Open order. ";
        }
      s = From + "Error #" + IntegerToString(GLError) + "\r\n" + GetErrorString(GLError);
     }
   else
      if(In_Languages == 1)
        {
         if(From == "Open")
           {
            From = "Открытие сделки. ";
           }
         s = From + "Ошибка #" + IntegerToString(GLError) + "\r\n" + GetErrorString(GLError);
        }
   return(s);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string GetErrorString(int error_code)
  {
   string error_string;
   if(In_Languages == 0)
     {
      switch(error_code)
        {
         case 0:
            error_string = "no error returned";
            break;
         case 1:
            error_string = "no error returned, but the result is unknown";
            break;
         case 2:
            error_string = "common error";
            break;
         case 3:
            error_string = "invalid trade parameters";
            break;
         case 4:
            error_string = "trade server is busy";
            break;
         case 5:
            error_string = "old version of the client terminal";
            break;
         case 6:
            error_string = "no connection with trade server";
            break;
         case 7:
            error_string = "not enough rights";
            break;
         case 8:
            error_string = "too frequent requests";
            break;
         case 9:
            error_string = "malfunctional trade operation";
            break;
         case 64:
            error_string = "account disabled";
            break;
         case 65:
            error_string = "invalid account";
            break;
         case 128:
            error_string = "trade timeout";
            break;
         case 129:
            error_string = "invalid price";
            break;
         case 130:
            error_string = "invalid stops";
            break;
         case 131:
            error_string = "invalid trade volume";
            break;
         case 132:
            error_string = "market is closed";
            break;
         case 133:
            error_string = "trade is disabled";
            break;
         case 134:
            error_string = "not enough money";
            break;
         case 135:
            error_string = "price changed";
            break;
         case 136:
            error_string = "off quotes";
            break;
         case 137:
            error_string = "broker is busy";
            break;
         case 138:
            error_string = "requote";
            break;
         case 139:
            error_string = "order is locked";
            break;
         case 140:
            error_string = "long positions only allowed";
            break;
         case 141:
            error_string = "too many requests";
            break;
         case 145:
            error_string = "modification denied because an order is too close to market";
            break;
         case 146:
            error_string = "trade context is busy";
            break;
         case 147:
            error_string = "expirations are denied by broker";
            break;
         case 148:
            error_string = "the amount of opened and pending orders has reached the limit set by a broker";
            break;
         case 4000:
            error_string = "no error";
            break;
         case 4001:
            error_string = "wrong function pointer";
            break;
         case 4002:
            error_string = "array index is out of range";
            break;
         case 4003:
            error_string = "no memory for function call stack";
            break;
         case 4004:
            error_string = "recursive stack overflow";
            break;
         case 4005:
            error_string = "not enough stack for parameter";
            break;
         case 4006:
            error_string = "no memory for parameter string";
            break;
         case 4007:
            error_string = "no memory for temp string";
            break;
         case 4008:
            error_string = "not initialized string";
            break;
         case 4009:
            error_string = "not initialized string in an array";
            break;
         case 4010:
            error_string = "no memory for an array string";
            break;
         case 4011:
            error_string = "too long string";
            break;
         case 4012:
            error_string = "remainder from zero divide";
            break;
         case 4013:
            error_string = "zero divide";
            break;
         case 4014:
            error_string = "unknown command";
            break;
         case 4015:
            error_string = "wrong jump";
            break;
         case 4016:
            error_string = "not initialized array";
            break;
         case 4017:
            error_string = "DLL calls are not allowed";
            break;
         case 4018:
            error_string = "cannot load library";
            break;
         case 4019:
            error_string = "cannot call function";
            break;
         case 4020:
            error_string = "EA function calls are not allowed";
            break;
         case 4021:
            error_string = "not enough memory for a string returned from a function";
            break;
         case 4022:
            error_string = "system is busy";
            break;
         case 4050:
            error_string = "invalid function parameters count";
            break;
         case 4051:
            error_string = "invalid function parameter value";
            break;
         case 4052:
            error_string = "string function internal error";
            break;
         case 4053:
            error_string = "some array error";
            break;
         case 4054:
            error_string = "incorrect series array using";
            break;
         case 4055:
            error_string = "custom indicator error";
            break;
         case 4056:
            error_string = "arrays are incompatible";
            break;
         case 4057:
            error_string = "global variables processing error";
            break;
         case 4058:
            error_string = "global variable not found";
            break;
         case 4059:
            error_string = "function is not allowed in testing mode";
            break;
         case 4060:
            error_string = "function is not confirmed";
            break;
         case 4061:
            error_string = "mail sending error";
            break;
         case 4062:
            error_string = "string parameter expected";
            break;
         case 4063:
            error_string = "integer parameter expected";
            break;
         case 4064:
            error_string = "double parameter expected";
            break;
         case 4065:
            error_string = "array as parameter expected";
            break;
         case 4066:
            error_string = "requested history data in updating state";
            break;
         case 4067:
            error_string = "some error in trade operation execution";
            break;
         case 4099:
            error_string = "end of a file";
            break;
         case 4100:
            error_string = "some file error";
            break;
         case 4101:
            error_string = "wrong file name";
            break;
         case 4102:
            error_string = "too many opened files";
            break;
         case 4103:
            error_string = "cannot open file";
            break;
         case 4104:
            error_string = "incompatible access to a file";
            break;
         case 4105:
            error_string = "no order selected";
            break;
         case 4106:
            error_string = "unknown symbol";
            break;
         case 4107:
            error_string = "invalid price param";
            break;
         case 4108:
            error_string = "invalid ticket";
            break;
         case 4109:
            error_string = "trade is not allowed";
            break;
         case 4110:
            error_string = "longs are not allowed";
            break;
         case 4111:
            error_string = "shorts are not allowed";
            break;
         case 4200:
            error_string = "object already exists";
            break;
         case 4201:
            error_string = "unknown object property";
            break;
         case 4202:
            error_string = "object does not exist";
            break;
         case 4203:
            error_string = "unknown object type";
            break;
         case 4204:
            error_string = "no object name";
            break;
         case 4205:
            error_string = "object coordinates error";
            break;
         case 4206:
            error_string = "no specified subwindow";
            break;
         case 4207:
            error_string = "ERR_SOME_OBJECT_ERROR";
            break;
         default:
            error_string = "error is not known";
        }
     }
   else
      if(In_Languages == 1)
        {
         switch(error_code)
           {
            case 0:
               error_string = "Нет ошибки";
               break;
            case 1:
               error_string = "Нет ошибки, но результат неизвестен";
               break;
            case 2:
               error_string = "Общая ошибка";
               break;
            case 3:
               error_string = "Неправильные параметры";
               break;
            case 4:
               error_string = "Торговый сервер занят";
               break;
            case 5:
               error_string = "Старая версия клиентского терминала";
               break;
            case 6:
               error_string = "Нет связи с торговым сервером";
               break;
            case 7:
               error_string = "Недостаточно прав";
               break;
            case 8:
               error_string = "Слишком частые запросы";
               break;
            case 9:
               error_string = "Недопустимая операция нарушающая функционирование сервера";
               break;
            case 64:
               error_string = "Счет заблокирован";
               break;
            case 65:
               error_string = "Неправильный номер счета";
               break;
            case 128:
               error_string = "Истек срок ожидания совершения сделки";
               break;
            case 129:
               error_string = "Неправильная цена";
               break;
            case 130:
               error_string = "Неправильные стопы";
               break;
            case 131:
               error_string = "Неправильный объем";
               break;
            case 132:
               error_string = "Рынок закрыт";
               break;
            case 133:
               error_string = "Торговля запрещена";
               break;
            case 134:
               error_string = "Недостаточно денег для совершения операции";
               break;
            case 135:
               error_string = "Цена изменилась";
               break;
            case 136:
               error_string = "Нет цен";
               break;
            case 137:
               error_string = "Брокер занят";
               break;
            case 138:
               error_string = "Новые цены (Реквота)";
               break;
            case 139:
               error_string = "Ордер заблокирован и уже обрабатывается";
               break;
            case 140:
               error_string = "Разрешена только покупка";
               break;
            case 141:
               error_string = "Слишком много запросов";
               break;
            case 145:
               error_string = "Модификация запрещена, так как ордер слишком близок к рынку";
               break;
            case 146:
               error_string = "Подсистема торговли занята";
               break;
            case 147:
               error_string = "Использование даты истечения ордера запрещено брокером";
               break;
            case 148:
               error_string = "Количество открытых и отложенных ордеров достигло предела, установленного брокером";
               break;
            case 4000:
               error_string = "Нет ошибки";
               break;
            case 4001:
               error_string = "Неправильный указатель функции";
               break;
            case 4002:
               error_string = "Индекс массива - вне диапазона";
               break;
            case 4003:
               error_string = "Нет памяти для стека функций";
               break;
            case 4004:
               error_string = "Переполнение стека после рекурсивного вызова";
               break;
            case 4005:
               error_string = "На стеке нет памяти для передачи параметров";
               break;
            case 4006:
               error_string = "Нет памяти для строкового параметра";
               break;
            case 4007:
               error_string = "Нет памяти для временной строки";
               break;
            case 4008:
               error_string = "Неинициализированная строка";
               break;
            case 4009:
               error_string = "Неинициализированная строка в массиве";
               break;
            case 4010:
               error_string = "Нет памяти для строкового массива";
               break;
            case 4011:
               error_string = "Слишком длинная строка";
               break;
            case 4012:
               error_string = "Остаток от деления на ноль";
               break;
            case 4013:
               error_string = "Деление на ноль";
               break;
            case 4014:
               error_string = "Неизвестная команда";
               break;
            case 4015:
               error_string = "Неправильный переход";
               break;
            case 4016:
               error_string = "Неинициализированный массив";
               break;
            case 4017:
               error_string = "Вызовы DLL не разрешены";
               break;
            case 4018:
               error_string = "Невозможно загрузить библиотеку";
               break;
            case 4019:
               error_string = "Невозможно вызвать функцию";
               break;
            case 4020:
               error_string = "Вызовы внешних библиотечных функций не разрешены";
               break;
            case 4021:
               error_string = "Недостаточно памяти для строки, возвращаемой из функции";
               break;
            case 4022:
               error_string = "Система занята";
               break;
            case 4050:
               error_string = "Неправильное количество параметров функции";
               break;
            case 4051:
               error_string = "Недопустимое значение параметра функции";
               break;
            case 4052:
               error_string = "Внутренняя ошибка строковой функции";
               break;
            case 4053:
               error_string = "Ошибка массива";
               break;
            case 4054:
               error_string = "Неправильное использование массива-таймсерии";
               break;
            case 4055:
               error_string = "Ошибка пользовательского индикатора";
               break;
            case 4056:
               error_string = "Массивы несовместимы";
               break;
            case 4057:
               error_string = "Ошибка обработки глобальныех переменных";
               break;
            case 4058:
               error_string = "Глобальная переменная не обнаружена";
               break;
            case 4059:
               error_string = "Функция не разрешена в тестовом режиме";
               break;
            case 4060:
               error_string = "Функция не подтверждена";
               break;
            case 4061:
               error_string = "Ошибка отправки почты";
               break;
            case 4062:
               error_string = "Ожидается параметр типа string";
               break;
            case 4063:
               error_string = "Ожидается параметр типа integer";
               break;
            case 4064:
               error_string = "Ожидается параметр типа double";
               break;
            case 4065:
               error_string = "В качестве параметра ожидается массив";
               break;
            case 4066:
               error_string = "Запрошенные исторические данные в состоянии обновления";
               break;
            case 4067:
               error_string = "Ошибка при выполнении торговой операции";
               break;
            case 4099:
               error_string = "Конец файла";
               break;
            case 4100:
               error_string = "Ошибка при работе с файлом";
               break;
            case 4101:
               error_string = "Неправильное имя файла";
               break;
            case 4102:
               error_string = "Слишком много открытых файлов";
               break;
            case 4103:
               error_string = "Невозможно открыть файл";
               break;
            case 4104:
               error_string = "Несовместимый режим доступа к файлу";
               break;
            case 4105:
               error_string = "Ни один ордер не выбран";
               break;
            case 4106:
               error_string = "Неизвестный символ";
               break;
            case 4107:
               error_string = "Неправильный параметр цены для торговой функции";
               break;
            case 4108:
               error_string = "Неверный номер тикета";
               break;
            case 4109:
               error_string = "Торговля не разрешена";
               break;
            case 4110:
               error_string = "Длинные позиции не разрешены";
               break;
            case 4111:
               error_string = "Короткие позиции не разрешены";
               break;
            case 4200:
               error_string = "Объект уже существует";
               break;
            case 4201:
               error_string = "Запрошено неизвестное свойство объекта";
               break;
            case 4202:
               error_string = "Объект не существует";
               break;
            case 4203:
               error_string = "Неизвестный тип объекта";
               break;
            case 4204:
               error_string = "Нет имени объекта";
               break;
            case 4205:
               error_string = "Ошибка координат объекта";
               break;
            case 4206:
               error_string = "Не найдено указанное подокно";
               break;
            case 4207:
               error_string = "Ошибка при работе с объектом";
               break;
            default:
               error_string = "Неизвестная ошибка";
           }
        }
   return(error_string);
  }
//+------------------------------------------------------------------+
