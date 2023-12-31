//+------------------------------------------------------------------+
//|                                                     ATR_1.11.mq4 |
//|                        Copyright 2020, Medvedev Vitaliy.         |
//|                         https://www.mql5.com/ru/users/raduga5409 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Medvedev Vitaliy."
#property link      "https://www.mql5.com/ru/users/raduga5409"
#property version   "1.11"
#property strict

enum ONOFF
  {
   ONOFF_ON=1,//on
   ONOFF_OFF=0,//off
  };

enum E_WT24
  {
   h_0,  //0
   h_1,  //1
   h_2,  //2
   h_3,  //3
   h_4,  //4
   h_5,  //5
   h_6,  //6
   h_7,  //7
   h_8,  //8
   h_9,  //9
   h_10, //10
   h_11, //11
   h_12, //12
   h_13, //13
   h_14, //14
   h_15, //15
   h_16, //16
   h_17, //17
   h_18, //18
   h_19, //19
   h_20, //20
   h_21, //21
   h_22, //22
   h_23  //23
  };

enum E_WT60
  {
   ms_0,  //0
   ms_1,  //1
   ms_2,  //2
   ms_3,  //3
   ms_4,  //4
   ms_5,  //5
   ms_6,  //6
   ms_7,  //7
   ms_8,  //8
   ms_9,  //9

   ms_10, //10
   ms_11, //11
   ms_12, //12
   ms_13, //13
   ms_14, //14
   ms_15, //15
   ms_16, //16
   ms_17, //17
   ms_18, //18
   ms_19, //19

   ms_20, //20
   ms_21, //21
   ms_22, //22
   ms_23, //23
   ms_24, //24
   ms_25, //25
   ms_26, //26
   ms_27, //27
   ms_28, //28
   ms_29, //29

   ms_30, //30
   ms_31, //31
   ms_32, //32
   ms_33, //33
   ms_34, //34
   ms_35, //35
   ms_36, //36
   ms_37, //37
   ms_38, //38
   ms_39, //39

   ms_40, //40
   ms_41, //41
   ms_42, //42
   ms_43, //43
   ms_44, //44
   ms_45, //45
   ms_46, //46
   ms_47, //47
   ms_48, //48
   ms_49, //49

   ms_50, //50
   ms_51, //51
   ms_52, //52
   ms_53, //53
   ms_54, //54
   ms_55, //55
   ms_56, //56
   ms_57, //57
   ms_58, //58
   ms_59, //59
  };
  
//---
sinput string           iT_Note                 = " --== Work Time ==-- "; //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
input ONOFF             iWorkTimeIntraday       = false;                   //Work Time (on/off)
sinput string           iS_Note                 = " --- Start --- ";       //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
input E_WT24            iHourStart              = 0;                       //Hour
input E_WT60            iMinuteStart            = 0;                       //Minute
input E_WT60            iSecondStart            = 0;                       //Second
sinput string           iF_Note                 = " --- Finish --- ";      //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
input E_WT24            iHourFinish             = 0;                       //Hour
input E_WT60            iMinuteFinish           = 0;                       //Minute
input E_WT60            iSecondFinish           = 0;                       //Second
//---


extern int TakeProfit   = 300;
extern int ma_period    = 100;

extern int StopLoss     = 100;
extern int Magic        = 111;
extern double Lots      = 0.01;
extern double Risk      = 4; //процент риска от баланса
extern int Slippadge    = 30;
extern double k         = 2; //коэффициент размера нулевого бара (2; - В два раза больше среднего за пять последних баров)

extern int TrailingStop = 30;
extern int TrailingStep = 10;

double sl,tp, d, SL;
int ticket;
bool NewBar = false;

//+------------------------------------------------------------------+
//| ограничение по времени                                             |
//+------------------------------------------------------------------+
bool WorkTime()

  {
   static bool _WTP = false;
   static int s = iHourStart*60*60+iMinuteStart*60+iSecondStart;
   static int f = iHourFinish*60*60+iMinuteFinish*60+iSecondFinish;
   static int f2 = (iHourFinish+24)*60*60+iMinuteFinish*60+iSecondFinish;
   datetime TimeStart=iTime(_Symbol,PERIOD_D1,0)+s;
   datetime TimeFinish=iTime(_Symbol,PERIOD_D1,0)+f;

   if(s>f)
     {
      if(TimeCurrent()<TimeFinish)
        {
         TimeStart=iTime(_Symbol,PERIOD_D1,1)+s;
        }
      if(TimeCurrent()>TimeStart)
        {
         TimeFinish=iTime(_Symbol,PERIOD_D1,0)+f2;
        }
     }

   if(TimeStart<=TimeCurrent() && TimeCurrent()<TimeFinish)
     {
      if(!_WTP)
        {
         Print("   Working time has begun...");
         _WTP = true;
        }
      return(true);
     }
   if(_WTP)
     {
      _WTP = false;
      Print("   Working time are over...");
     }
   return(false);
  }


void OnTick()
{ 

//+------------------------------------------------------------------+
//| Work Time function                                               |
//+------------------------------------------------------------------+
   Trailing();

//--- file include
//#include <Work Time.mqh>

//--- example of a function call
if(iWorkTimeIntraday && !WorkTime()) return;

//--- example of a function call
if(iWorkTimeIntraday && WorkTime())
  {

//---вход с нового бара---
   
   FunNew_Bar();
   if(NewBar == false)
      return;

//+------------------------------------------------------------------+
double ma0 = iMA(Symbol(),0, ma_period, 0, 0, PRICE_CLOSE, 0);


double a0,a1,a2,a3,a4,a5;

      a0 = iHigh(Symbol() ,0,1)-iLow(Symbol() ,0,1);
      a1 = iHigh(Symbol() ,0,2)-iLow(Symbol() ,0,2);
      a2 = iHigh(Symbol() ,0,3)-iLow(Symbol() ,0,3);
      a3 = iHigh(Symbol() ,0,4)-iLow(Symbol() ,0,4);
      a4 = iHigh(Symbol() ,0,5)-iLow(Symbol() ,0,5);
      a5 = iHigh(Symbol() ,0,6)-iLow(Symbol() ,0,6);
//---
double atr = (a1+a2+a3+a4+a5)/5; // Рассчёт АТR по Герчику
//--- 

   if (CountSell()+ CountBuy() == 0 && a0 > atr*k && Open[1]>Close[1] && !(High[1]>ma0 && Low[1]<ma0))// Условие для открытия ЛОНГ
   {
  
      ticket = OrderSend(Symbol(), OP_BUY,LotsByRisk(OP_BUY, Risk),Ask,Slippadge,0,0,"",Magic,0,Green);
      if (ticket > 0)
      {
  //       tp = NormalizeDouble(Ask + TakeProfit*Point, Digits);
         sl = NormalizeDouble(Ask - StopLoss*Point, Digits);
         if (OrderSelect(ticket, SELECT_BY_TICKET))
         if(!OrderModify(ticket, OrderOpenPrice(), sl, tp,0))
            Print("Order Buy Not Modify");
      }
   }  
      
   if (CountSell()+ CountBuy() == 0 && a0 > atr*k && Open[1]<Close[1] && !(High[1]>ma0 && Low[1]<ma0))// Условие для открытия ШОРТ
   {
      ticket = OrderSend(Symbol(), OP_SELL,LotsByRisk(OP_SELL, Risk),Bid,Slippadge,0,0,"",Magic,0,Red);
      if (ticket > 0)
      {
 //        tp = NormalizeDouble(Bid - TakeProfit*Point, Digits); // С Тралом, TakeProfit не нужен.
         sl = NormalizeDouble(Bid + StopLoss*Point, Digits);
         if (OrderSelect(ticket, SELECT_BY_TICKET))
         if(!OrderModify(ticket, OrderOpenPrice(), sl, tp,0))
            Print("Order Sell Not Modify");
         
      }
      
   }
 }       
//--- Счётчик открытых ордеров ---//
}
int CountSell()
  {
   int count = 0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if(OrderSymbol() == Symbol()&&
            OrderMagicNumber() == Magic &&
            (OrderType() == OP_SELL || OP_SELLSTOP))
            count++;
        }
     }
   return(count);
  }

int CountBuy()
  {
   int count = 0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if(OrderSymbol() == Symbol()&&
            OrderMagicNumber() == Magic &&
            (OrderType() == OP_SELL || OP_SELLSTOP))
            count++;
        }
     }
   return(count);
  }
//---  Вход с нового бара
 void FunNew_Bar()
  {
   static datetime NewTime = 0;
   NewBar = false;
   if(NewTime!=Time[0])
     {
      NewTime = Time[0];
      NewBar = true;
     }
  }
//---  Трэйлинг стоп ---//
void Trailing()
{
   for (int i = 0; i<OrdersTotal(); i++)
   {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol()==Symbol() && OrderMagicNumber() == Magic)
         {
            if(OrderType() == OP_BUY)
            {
               if(Bid - OrderOpenPrice() > TrailingStop*Point)
               {
                  if(OrderStopLoss()<Bid - (TrailingStop + TrailingStep)*Point)
                  {
                     SL = NormalizeDouble(Bid - TrailingStop*Point, Digits);
                     if(OrderStopLoss()!= SL)
                     if (!OrderModify(OrderTicket(), OrderOpenPrice(), SL, 0, 0))
                     Print("Error mod tral buy");
                  }
               }
            }
            if(OrderType()== OP_SELL)
            {
               if(OrderOpenPrice()-Ask > TrailingStop*Point)
               {
                  if(OrderStopLoss()>Ask + (TrailingStop + TrailingStep)*Point)
                  {
                     SL = NormalizeDouble(Ask + TrailingStop*Point, Digits);
                     if(OrderStopLoss()!= SL)
                     if (!OrderModify(OrderTicket(), OrderOpenPrice(), SL, 0, 0))
                     Print("Error mod tral sell");
                  }
               }
            }
         }
      }
   }
}
//--- Вычислитель процента риска ---//
double LotsByRisk(int op_type, double risk)
{
   double lot_min  = MarketInfo(Symbol(), MODE_MINLOT);
   double lot_max  = MarketInfo(Symbol(), MODE_MAXLOT);
   double lot_step = MarketInfo(Symbol(), MODE_LOTSTEP);
   double lotcost  = MarketInfo(Symbol(), MODE_TICKVALUE);
   
   double lot       = 0;
   double UsdPerPip = 0;
   
   lot = AccountBalance()*risk/100;
   UsdPerPip = lot/StopLoss;
   
   lot = NormalizeDouble(UsdPerPip/lotcost, 2);
   lot = NormalizeDouble(lot/lot_step, 0)* lot_step;
   
   if (lot < lot_min) lot = lot_min;
   if (lot > lot_max) lot = lot_max;
   
   if (AccountFreeMarginCheck(Symbol(), op_type, lot) < 10 || GetLastError()==ERR_NOT_ENOUGH_MONEY)return(-1);
   return(lot);   
}
//---
