//+------------------------------------------------------------------+
//|                                             FPA=TrailingStop.mq4 |
//|                                 Copyright 2013, Forex Peace Army |
//|                                    http://www.forexpeacearmy.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2013 © Peter @ Forex Peace Army"
#property link "http://www.forexpeacearmy.com"

extern double Break_Even_Trigger_in_Pips = 30.0;
extern double Break_Even_in_Pips = 1.0;
extern double Trailing_Stop_in_Pips = 20.0;
extern bool Trail_before_break_even = false;  // true or false
extern bool Apply_to_all_symbols = false;     // true or false

double minimal_stop_step_in_pips = 0.5;
string label_font_type = "Calibri";
int error_font_size = 12;
color error_message_color = OrangeRed;
int warning_font_size = 12;
color warning_message_color = SpringGreen;
int warning_display_time_seconds = 12;

double pip_value = 0.0;
int pip_digits = 0;
double stop_level_in_pips = 0.0;
bool error_state = false;
datetime last_warning_time = 0;

string error_message_name = "TrailingStop - Error Message";
string warning_message_name = "TrailingStop - Warning Message";

string error_title__input_parameters = "Trailing Stop EA has just confused 8(";
string error__title_order_modify = "Trailing Stop: problem while modifying order";
string error__be_params_reserved = "BE trigger is closer than BE itself.";
string error__be_params_are_too_close = "Can\'t set BE level so close to market price.";
string error__ts_must_be_positive = "Trailing level must be positive by all means.";
string error__ts_is_too_close = "Can\'t set trailing stop so close to market price.";
string warning__inactive_settings = "BE is turned off and no trailing until BE. Manual s/l needed.";

#define CORNER_UPPERLEFT     0
#define CORNER_UPPERRIGHT    1
#define CORNER_LOWERLEFT     2
#define CORNER_LOWERRIGHT    3

// --- test order parameters ---
string test_time_strs[] = { "2013.06.03 09:45", "2013.06.05 05:00" };
int    test_orders[]    = { OP_BUY,             OP_BUY };
double test_lots[]      = { 0.1,                0.1 };
bool test_placed[];
datetime test_times[];

//+------------------------------------------------------------------+
//+- Builtins: init(), deinit(), start() ----------------------------+
//+------------------------------------------------------------------+
int init()
  {
   pip_value = MathPow(10.0, MathFloor(MathLog(Bid / 2.0) / MathLog(10.0)) - 3);
   pip_digits = MathRound(MathLog(pip_value / Point) / MathLog(10.0));
   stop_level_in_pips = NormalizeDouble(MarketInfo(Symbol(), MODE_STOPLEVEL) * Point / pip_value, pip_digits);
   validate_external_parameters();
   initialize_test_scenario();
   return(0);
  }
//+------------------------------------------------------------------+
int deinit()
  {
   make_sure_error_message_hidden();
   make_sure_warning_msg_hidden();
   return(0);
  }
//+------------------------------------------------------------------+
int start()
  {
   do_test_scenario_activities();
   check_trade_levels_to_set_stop();
   check_warning_display_time();
   return(0);
  }
//+------------------------------------------------------------------+
//+- Specific modules -----------------------------------------------+
//+------------------------------------------------------------------+
void validate_external_parameters()
  {
   error_state = false;
   if ((Break_Even_Trigger_in_Pips > 0.0) && (Break_Even_Trigger_in_Pips < Break_Even_in_Pips))
     {
      write_error_message(error_title__input_parameters, error__be_params_reserved);
      error_state = true;
      return;
     }
    else
      if ((Break_Even_Trigger_in_Pips > 0.0) && (Break_Even_Trigger_in_Pips - stop_level_in_pips < Break_Even_in_Pips))
        {
         write_error_message(error_title__input_parameters, error__be_params_are_too_close);
         error_state = true;
         return;
        }
   if (Trailing_Stop_in_Pips <= 0)
     {
      write_error_message(error_title__input_parameters, error__ts_must_be_positive);
      error_state = true;
      return;
     }
    else
      if (Trailing_Stop_in_Pips < stop_level_in_pips)
        {
         write_error_message(error_title__input_parameters, error__ts_is_too_close);
         error_state = true;
         return;
        }
   if ((Break_Even_Trigger_in_Pips <= 0.0) && (!Trail_before_break_even))
     {
      write_warning_message(warning_message_name, warning__inactive_settings);
      return;
     }
   error_state = false;
  }
//+------------------------------------------------------------------+
void check_trade_levels_to_set_stop()
  {
   if ( ! error_state)
      for(int i = 0; i < OrdersTotal(); i++)
         if (OrderSelect(i, SELECT_BY_POS))
            if (Apply_to_all_symbols || (OrderSymbol() == Symbol()))
               if ((OrderType() == OP_BUY) || (OrderType() == OP_SELL))
                 {
                  if (is_trailing_distance_met())
                     if (Trail_before_break_even || order_is_in_be_or_further())
                        if ( ! trailing_widens_the_stop())
                           set_stop_from_market_price(Trailing_Stop_in_Pips);
                  if ( ! order_is_in_be_or_further())
                     if (order_is_triggered_by_be())
                        set_stop_to_be();
                 }
  }
//+------------------------------------------------------------------+
bool order_is_in_be_or_further()
  {
   if (OrderType() == OP_BUY)
      return(NormalizeDouble(OrderStopLoss() - OrderOpenPrice(), Digits) >= NormalizeDouble(Break_Even_in_Pips * pip_value, Digits));
   if (OrderType() == OP_SELL)
      return((OrderStopLoss() != 0.0) && (NormalizeDouble(OrderOpenPrice() - OrderStopLoss(), Digits) >= NormalizeDouble(Break_Even_in_Pips * pip_value, Digits)));
   return(true);
  }
//+------------------------------------------------------------------+
bool order_is_triggered_by_be()
  {
   if (Break_Even_Trigger_in_Pips <= 0.0)
      return(false);
   if (OrderType() == OP_BUY)
      return(NormalizeDouble(Bid - OrderOpenPrice(), Digits) >= NormalizeDouble(Break_Even_Trigger_in_Pips * pip_value, Digits));
   if (OrderType() == OP_SELL)
      return(NormalizeDouble(OrderOpenPrice() - Ask, Digits) >= NormalizeDouble(Break_Even_Trigger_in_Pips * pip_value, Digits));
   return(false);
  }
//+------------------------------------------------------------------+
bool is_trailing_distance_met()
  {
   if (OrderType() == OP_BUY)
      return(NormalizeDouble(Bid - OrderStopLoss(), Digits) >= NormalizeDouble((Trailing_Stop_in_Pips + minimal_stop_step_in_pips) * pip_value, Digits));
   if (OrderType() == OP_SELL)
      return((OrderStopLoss() == 0.0) || (NormalizeDouble(OrderStopLoss() - Ask, Digits) >= NormalizeDouble((Trailing_Stop_in_Pips + minimal_stop_step_in_pips) * pip_value, Digits)));
   return(false);
  }
//+------------------------------------------------------------------+
bool trailing_widens_the_stop()
  {
   if (OrderType() == OP_BUY)
      return(NormalizeDouble(Bid - OrderStopLoss(), Digits) < NormalizeDouble(Trailing_Stop_in_Pips * pip_value, Digits));
   if (OrderType() == OP_SELL)
      return((OrderStopLoss() != 0.0) && (NormalizeDouble(OrderStopLoss() - Ask, Digits) < NormalizeDouble(Trailing_Stop_in_Pips * pip_value, Digits)));
   return(true);
  }
//+------------------------------------------------------------------+
void set_stop_to_be()
  {
   double new_stop_level = 0.0;
   if (OrderType() == OP_BUY)
      new_stop_level = NormalizeDouble(OrderOpenPrice() + Break_Even_in_Pips * pip_value, Digits);
   if (OrderType() == OP_SELL)
      new_stop_level = NormalizeDouble(OrderOpenPrice() - Break_Even_in_Pips * pip_value, Digits);
   if (new_stop_level > 0.0)
      if ( ! OrderModify(OrderTicket(), 0.0, new_stop_level, OrderTakeProfit(), 0))
         write_error_message(error__title_order_modify, TimeToStr(TimeCurrent(), TIME_MINUTES|TIME_SECONDS) + " > " + get_error_message(GetLastError()));
  }
//+------------------------------------------------------------------+
void set_stop_from_market_price(double distance_in_pips)
  {
   double new_stop_level = 0.0;
   if (OrderType() == OP_BUY)
      new_stop_level = NormalizeDouble(Bid - distance_in_pips * pip_value, Digits);
   if (OrderType() == OP_SELL)
      new_stop_level = NormalizeDouble(Ask + distance_in_pips * pip_value, Digits);
   if (new_stop_level > 0.0)
      if ( ! OrderModify(OrderTicket(), 0.0, new_stop_level, OrderTakeProfit(), 0))
         write_error_message(error__title_order_modify, TimeToStr(TimeCurrent(), TIME_MINUTES|TIME_SECONDS) + " > " + get_error_message(GetLastError()));
  }
//+------------------------------------------------------------------+
void make_sure_error_message_hidden()
  {
   object_hide(error_message_name + " 1");
   object_hide(error_message_name + " 2");
  }
//+------------------------------------------------------------------+
void make_sure_warning_msg_hidden()
  {
   object_hide(warning_message_name + " 1");
   object_hide(warning_message_name + " 2");
  }
//+------------------------------------------------------------------+
void write_error_message(string title, string message)
  {
   refresh_chart_label(error_message_name + " 1", title, error_message_color, label_font_type, error_font_size, 0, CORNER_LOWERLEFT, 12, 36);
   refresh_chart_label(error_message_name + " 2", message, error_message_color, label_font_type, error_font_size, 0, CORNER_LOWERLEFT, 12, 18);
  }
//+------------------------------------------------------------------+
void write_warning_message(string title, string message)
  {
   refresh_chart_label(warning_message_name + " 1", title, warning_message_color, label_font_type, warning_font_size, 0, CORNER_LOWERLEFT, 12, 36);
   refresh_chart_label(warning_message_name + " 2", message, warning_message_color, label_font_type, warning_font_size, 0, CORNER_LOWERLEFT, 12, 18);
   last_warning_time = kind_of_current_time();
  }
//+------------------------------------------------------------------+
void check_warning_display_time()
  {
   if (last_warning_time + warning_display_time_seconds < kind_of_current_time())
      make_sure_warning_msg_hidden();
  }
//+------------------------------------------------------------------+
//+- Test functions -------------------------------------------------+
//+------------------------------------------------------------------+
void initialize_test_scenario()
  {
   ArrayResize(test_placed, ArraySize(test_time_strs));
   ArrayResize(test_times, ArraySize(test_time_strs));
   for(int i = 0; i < ArraySize(test_time_strs); i++)
     {
      test_placed[i] = false;
      test_times[i] = StrToTime(test_time_strs[i]);
     }
  }
//+------------------------------------------------------------------+
void do_test_scenario_activities()
  {
   if (IsTesting())
     {
      for(int i = 0; i < ArraySize(test_times); i++)
         if ( ! test_placed[i])
            if ((Time[0] >= test_times[i]) && (Time[1] < test_times[i]))
              {
               if (test_orders[i] == OP_BUY)
                  OrderSend(Symbol(), OP_BUY, test_lots[i], Ask, 7, 0.0, 0.0);
               if (test_orders[i] == OP_SELL)
                  OrderSend(Symbol(), OP_SELL, test_lots[i], Bid, 7, 0.0, 0.0);
               test_placed[i] = true;
              }
      for(i = 0; i < 500000; i++) {}
     }
  }
//+------------------------------------------------------------------+
//+- Library functions ----------------------------------------------+
//+------------------------------------------------------------------+
void refresh_chart_label(string label_name, string label_text, int clr, string font, int size, int window, int corner, int distance_x, int distance_y)
  {
   if (ObjectFind(label_name) == -1)
     {
      ObjectCreate(label_name, OBJ_LABEL, 0, 0, 0);
     }
   ObjectSetText(label_name, label_text, size, font, clr);
   ObjectSet(label_name, OBJPROP_CORNER, corner);
   ObjectSet(label_name, OBJPROP_XDISTANCE, distance_x);
   ObjectSet(label_name, OBJPROP_YDISTANCE, distance_y);
  }
//+------------------------------------------------------------------+
void object_hide(string object_name)
  {
   if (ObjectFind(object_name) != -1)
      ObjectDelete(object_name);
  }
//+------------------------------------------------------------------+
datetime kind_of_current_time()
  {
   if (!IsTesting())
      return(TimeCurrent());
    else
      return(Time[0]);
  }
//+------------------------------------------------------------------+
string get_error_message(int error_code)
  {
   switch(error_code)
     {
      case 0: return("Server: No error returned (0)");
      case 1: return("Server: No error returned, but the result is unknown (1)");
      case 2: return("Server: Common error (2)");
      case 3: return("Server: Invalid trade parameters (3)");
      case 4: return("Server: Trade server is busy (4)");
      case 5: return("Server: Old version of the client terminal (5)");
      case 6: return("Server: No connection with trade server (6)");
      case 7: return("Server: Not enough rights (7)");
      case 8: return("Server: Too frequent requests (8)");
      case 9: return("Server: Malfunctional trade operation (9)");
      case 64: return("Server: Account disabled (64)");
      case 65: return("Server: Invalid account (65)");
      case 128: return("Server: Trade timeout (128)");
      case 129: return("Server: Invalid price (129)");
      case 130: return("Server: Invalid stops (130)");
      case 131: return("Server: Invalid trade volume (131)");
      case 132: return("Server: Market is closed (132)");
      case 133: return("Server: Trade is disabled (133)");
      case 134: return("Server: Not enough money (134)");
      case 135: return("Server: Price changed (135)");
      case 136: return("Server: Off quotes (136)");
      case 137: return("Server: Broker is busy (137)");
      case 138: return("Server: Requote (138)");
      case 139: return("Server: Order is locked (139)");
      case 140: return("Server: Long positions only allowed (140)");
      case 141: return("Server: Too many requests (141)");
      case 145: return("Server: Modification denied because order too close to market (145)");
      case 146: return("Server: Trade context is busy (146)");
      case 147: return("Server: Expirations are denied by broker (147)");
      case 148: return("Server: The amount of open and pending orders has reached the limit set by the broker (148)");
      case 4000: return("Runtime: No error (4000)");
      case 4001: return("Runtime: Wrong function pointer (4001)");
      case 4002: return("Runtime: Array index is out of range (4002)");
      case 4003: return("Runtime: No memory for function call stack (4003)");
      case 4004: return("Runtime: Recursive stack overflow (4004)");
      case 4005: return("Runtime: Not enough stack for parameter (4005)");
      case 4006: return("Runtime: No memory for parameter string (4006)");
      case 4007: return("Runtime: No memory for temp string (4007)");
      case 4008: return("Runtime: Not initialized string (4008)");
      case 4009: return("Runtime: Not initialized string in array (4009)");
      case 4010: return("Runtime: No memory for array string (4010)");
      case 4011: return("Runtime: Too long string (4011)");
      case 4012: return("Runtime: Remainder from zero divide (4012)");
      case 4013: return("Runtime: Zero divide (4013)");
      case 4014: return("Runtime: Unknown command (4014)");
      case 4015: return("Runtime: Wrong jump (never generated error (4015)");
      case 4016: return("Runtime: Not initialized array (4016)");
      case 4017: return("Runtime: DLL calls are not allowed (4017)");
      case 4018: return("Runtime: Cannot load library (4018)");
      case 4019: return("Runtime: Cannot call function (4019)");
      case 4020: return("Runtime: Expert function calls are not allowed (4020)");
      case 4021: return("Runtime: Not enough memory for temp string returned from function (4021)");
      case 4022: return("Runtime: System is busy (never generated error (4022)");
      case 4050: return("Runtime: Invalid function parameters count (4050)");
      case 4051: return("Runtime: Invalid function parameter value (4051)");
      case 4052: return("Runtime: String function internal error (4052)");
      case 4053: return("Runtime: Some array error (4053)");
      case 4054: return("Runtime: Incorrect series array using (4054)");
      case 4055: return("Runtime: Custom indicator error (4055)");
      case 4056: return("Runtime: Arrays are incompatible (4056)");
      case 4057: return("Runtime: Global variables processing error (4057)");
      case 4058: return("Runtime: Global variable not found (4058)");
      case 4059: return("Runtime: Function is not allowed in testing mode (4059)");
      case 4060: return("Runtime: Function is not confirmed (4060)");
      case 4061: return("Runtime: Send mail error (4061)");
      case 4062: return("Runtime: String parameter expected (4062)");
      case 4063: return("Runtime: Integer parameter expected (4063)");
      case 4064: return("Runtime: Double parameter expected (4064)");
      case 4065: return("Runtime: Array as parameter expected (4065)");
      case 4066: return("Runtime: Requested history data in updating state (4066)");
      case 4067: return("Runtime: Some error in trading function (4067)");
      case 4099: return("Runtime: End of file (4099)");
      case 4100: return("Runtime: Some file error (4100)");
      case 4101: return("Runtime: Wrong file name (4101)");
      case 4102: return("Runtime: Too many opened files (4102)");
      case 4103: return("Runtime: Cannot open file (4103)");
      case 4104: return("Runtime: Incompatible access to a file (4104)");
      case 4105: return("Runtime: No order selected (4105)");
      case 4106: return("Runtime: Unknown symbol (4106)");
      case 4107: return("Runtime: Invalid price (4107)");
      case 4108: return("Runtime: Invalid ticket (4108)");
      case 4109: return("Runtime: Trade is not allowed. Enable checkbox \"Allow live trading\" in the expert properties (4109)");
      case 4110: return("Runtime: Longs are not allowed. Check the expert properties (4110)");
      case 4111: return("Runtime: Shorts are not allowed. Check the expert properties (4111)");
      case 4200: return("Runtime: Object exists already (4200)");
      case 4201: return("Runtime: Unknown object property (4201)");
      case 4202: return("Runtime: Object does not exist (4202)");
      case 4203: return("Runtime: Unknown object type (4203)");
      case 4204: return("Runtime: No object name (4204)");
      case 4205: return("Runtime: Object coordinates error (4205)");
      case 4206: return("Runtime: No specified subwindow (4206)");
      case 4207: return("Runtime: Some error in object function (4207)");
      default: return("Unknown error code: " + error_code);
     }
  }
//+------------------------------------------------------------------+

