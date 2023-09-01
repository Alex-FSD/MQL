//+------------------------------------------------------------------+
//|                                                    EarnForex.com |
//|                                        https://www.earnforex.com |
//|            							                       2011-2021 |
//+------------------------------------------------------------------+
#property copyright "www.EarnForex.com, 2011-2021"
#property version   "1.05"
#property link      "https://www.earnforex.com/metatrader-expert-advisors/ATR-Trailer/"

// Plain trailing stop EA with ATR-based stop-loss.

#define LONG 1
#define SHORT 2

extern int ATR_Period = 24;
extern int ATR_Multiplier = 3;
extern int StartWith = 1; // 1 - Short, 2 - Long
extern int Slippage = 100; 	// Tolerated slippage in pips
extern double Lots = 0.1;
extern bool ECN_Mode = false; // Set to true if stop-loss should be added only after Position Open
extern int TakeProfit = 0; // In your broker's pips

extern int Magic = 123123123;

// Global variables
bool HaveLongPosition;
bool HaveShortPosition;

int LastPosition = 0;

int init()
{
   LastPosition = 3 - StartWith;
   return(0);
}

//+------------------------------------------------------------------+
//| Expert Every Tick Function                                       |
//+------------------------------------------------------------------+
int start()
{
	double SL = 0, TP = 0;
	
	if (IsTradeAllowed() == false) return(0);
	
   // Getting the ATR values
   double ATR = iATR(NULL, 0, ATR_Period, 0);
   ATR *= ATR_Multiplier;

   if (ATR <= (MarketInfo(Symbol(), MODE_STOPLEVEL) + MarketInfo(Symbol(), MODE_SPREAD)) * Point) ATR = (MarketInfo(Symbol(), MODE_STOPLEVEL) + MarketInfo(Symbol(), MODE_SPREAD)) * Point;

  	// Check what position is currently open
 	GetPositionStates();
   
 	// Adjust SL and TP of the current position
 	if ((HaveLongPosition) || (HaveShortPosition)) AdjustSLTP(ATR);
   else
	{
   	// Buy condition
   	if (LastPosition == SHORT)
   	{
  			for (int i = 0; i < 10; i++)
  			{
  			   RefreshRates();
  				// Bid and Ask are swapped to preserve the probabilities and decrease/increase profit/loss size
  		   	if (!ECN_Mode)
  		   	{
               SL = NormalizeDouble(Bid - ATR, Digits);
               if (TakeProfit > 0) TP = NormalizeDouble(Bid + TakeProfit * Point, Digits);
  		   	}
  				int result = OrderSend(Symbol(), OP_BUY, Lots, Ask, Slippage, SL, TP, "ATR-Trader", Magic, 0, Blue); 
  				Sleep(1000);
            if (result == -1)
            {
               int e = GetLastError();
               Print(e);
            }
  				else return(0);
  			}
   	}
   	// Sell condition
   	else if (LastPosition == LONG)
   	{
  			for (i = 0; i < 10; i++)
  			{
  			   RefreshRates();
  				// Bid and Ask are swapped to preserve the probabilities and decrease/increase profit/loss size
  		      if (!ECN_Mode)
  		      {
               SL = NormalizeDouble(Ask + ATR, Digits);
               if (TakeProfit > 0) TP = NormalizeDouble(Ask - TakeProfit * Point, Digits);
            }
  				result = OrderSend(Symbol(), OP_SELL, Lots, Bid, Slippage, SL, TP, "ATR-Trader", Magic, 0, Red); 
  				Sleep(1000);
            if (result == -1)
            {
               e = GetLastError();
               Print(e);
            }
  				else return(0);
  			}
   	}
	}
	
	return(0);
}

//+------------------------------------------------------------------+
//| Check What Position is Currently Open										|
//+------------------------------------------------------------------+
void GetPositionStates()
{
   int total = OrdersTotal();
   for (int cnt = 0; cnt < total; cnt++)
   {
      if (OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES) == false) continue;
      if (OrderMagicNumber() != Magic) continue;
      if (OrderSymbol() != Symbol()) continue;

      if (OrderType() == OP_BUY)
      {
			HaveLongPosition = true;
			HaveShortPosition = false;
		}
      else if (OrderType() == OP_SELL)
      {
			HaveLongPosition = false;
			HaveShortPosition = true;
		}
   	if (HaveLongPosition) LastPosition = LONG;
   	else if (HaveShortPosition) LastPosition = SHORT;
   	return;
	}

   HaveLongPosition = false;
	HaveShortPosition = false;
}

//+------------------------------------------------------------------+
//| Adjust Stop-Loss and TakeProfit of the Open Position					|
//+------------------------------------------------------------------+
void AdjustSLTP(double SLparam)
{
   double TP = 0;
   
   int total = OrdersTotal();
   for (int cnt = 0; cnt < total; cnt++)
   {
      if (OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES) == false) continue;
      if (OrderMagicNumber() != Magic) continue;
      if (OrderSymbol() != Symbol()) continue;

      if (OrderType() == OP_BUY)
		{
		   RefreshRates();
			double SL = NormalizeDouble(Bid - SLparam, Digits);
			if (TakeProfit > 0) TP = NormalizeDouble(Bid + TakeProfit * Point, Digits);
			if (OrderTakeProfit() != 0) TP = NormalizeDouble(OrderTakeProfit(), Digits); // TP already set, no need to trail it.
			if ((SL > NormalizeDouble(OrderStopLoss(), Digits)) || (NormalizeDouble(OrderStopLoss(), Digits) == 0) || ((TP > 0) && (NormalizeDouble(OrderTakeProfit(), Digits) == 0)))
			{
				for (int i = 0; i < 10; i++)
				{
      		   bool result = OrderModify(OrderTicket(), OrderOpenPrice(), SL, TP, 0);
      		   if (result) return;
				}
			}
		}
      else if (OrderType() == OP_SELL)
		{ 
		   RefreshRates();
			SL = NormalizeDouble(Ask + SLparam, Digits);
			if (TakeProfit > 0) TP = NormalizeDouble(Ask - TakeProfit * Point, Digits);
			if (OrderTakeProfit() != 0) TP = NormalizeDouble(OrderTakeProfit(), Digits); // TP already set, no need to trail it.
			if ((SL < NormalizeDouble(OrderStopLoss(), Digits)) || (NormalizeDouble(OrderStopLoss(), Digits) == 0) || ((TP > 0) && (NormalizeDouble(OrderTakeProfit(), Digits) == 0)))
			{
				for (i = 0; i < 10; i++)
				{
      		   result = OrderModify(OrderTicket(), OrderOpenPrice(), SL, TP, 0);
      		   if (result) return;
				}
			}
		}
	}
}
//+------------------------------------------------------------------+

