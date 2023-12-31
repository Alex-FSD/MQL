//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright   "Equity Monitor - original by Xupypr - remake by Transcendreamer"
#property description "Monitoring balance, equity, margin, profitability and drawdown"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#property indicator_separate_window
#property indicator_buffers 6
#property indicator_color1 SteelBlue
#property indicator_color2 OrangeRed
#property indicator_color3 SlateGray
#property indicator_color4 ForestGreen
#property indicator_color5 Silver
#property indicator_color6 Gray
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 1
#property indicator_width4 1
#property indicator_width5 1
#property indicator_width6 1
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
extern string           ______FILTERS______="______FILTERS______";
extern bool             Only_Trading=false;
extern bool             Only_Current=false;
extern bool             Only_Buys=false;
extern bool             Only_Sells=false;
extern bool             Only_Magics=false;
extern int              Magic_From=0;
extern int              Magic_To=0;
extern string           Only_Symbols="";
extern string           Only_Comment="";
extern string           ______PERIOD______="______PERIOD______";
extern datetime         Draw_Begin=D'2012.01.01 00:00';
extern datetime         Draw_End=D'2035.01.01 00:00';
enum   reporting        {day,week,month,quarter,halfyear,year,history};
extern reporting        Report_Period=history;
extern string           ______ALERTS______="______ALERTS______";
extern double           Equity_Min_Alert=0;
extern double           Equity_Max_Alert=0;
extern bool             Push_Alerts=false;
extern string           ______LINES______="______LINES______";
extern bool             Show_Equity=true;
extern bool             Show_Balance=true;
extern bool             Show_Margin=false;
extern bool             Show_Free=false;
extern bool             Show_Orders=false;
extern bool             Show_Zero=false;
extern bool             Show_Info=true;
extern bool             Show_Verticals=true;
extern string           ______OTHER______="______OTHER______";
extern ENUM_BASE_CORNER Text_Corner=CORNER_LEFT_UPPER;
extern color            Text_Color=Magenta;
extern string           Text_Font="Verdana";
extern int              Text_Size=11;
extern double           Chart_Grid_Size=0;
extern string           Write_Data_File="";
extern string           Export_History="";
extern string           Import_History="";
extern double           Hedge_Margin_Rate=0;
extern string           FX_prefix="";
extern string           FX_postfix="";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string   ShortName,CalcCurrency;
int      DrawBeginBar,DrawEndBar;
double   Equity[],Balance[],Margin[],Free[],Orders[],Zero[];
double   ResultBalance,ResultProfit,IntervalProfit,IntervalBalance,GrowthRatio;
double   ProfitLoss,SumMargin,LotValue;
double   PeakProfit,PeakEquity,MaxDrawdown,RelDrawdown;
double   SumProfit,SumLoss,NetProfit;
double   RecoveryFactor,ProfitFactor,Profitability;
string   Instrument[],Comments[],SymbolNames[];
int      TotalSymbols,OrdersCount;
int      IndexOrderSymbol[],IndexOrderOpenTime[][2];
double   SymbolLong[],SymbolShort[],Spread[],SymbolHedge[],SymbolMargin[];
datetime OpenTime[],CloseTime[];
bool     Filter[];
int      OpenBar[],CloseBar[],Type[],Ticket[],Magic[];
double   Lots[],OpenPrice[],ClosePrice[],Commission[],Swap[],CumSwap[],DaySwap[],Profit[];
datetime StartTime,FinishTime;
int      TotalOrders,TotalHistory,TotalOpen;
string   MissingSymbols;
bool     alert_upper_active,alert_lower_active;
bool     using_filters;
string   name_prefix;
bool     error,restart;
int      window;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {

   error=false;
   restart=true;
   window=ChartWindowFind();
   name_prefix="Monitor_N"+string(window);

   if(Period()>PERIOD_D1) 
     {
      error=true;
      Alert("Period must be D1 or lower."); 
      return(INIT_PARAMETERS_INCORRECT); 
     }

   using_filters=false;
   if(Only_Symbols!="")    using_filters=true;
   if(Only_Comment!="")    using_filters=true;
   if(Only_Current)        using_filters=true;
   if(Only_Buys)           using_filters=true;
   if(Only_Sells)          using_filters=true;
   if(Only_Magics)         using_filters=true;

   if(!using_filters)
      ShortName="Total"; else ShortName="";
   if(Only_Symbols!="")
      ShortName=StringConcatenate(ShortName," ",Only_Symbols);
   else if(Only_Current)
      ShortName=StringConcatenate(ShortName," ",Symbol());
   if(Only_Magics)
      ShortName=StringConcatenate(ShortName," #",Magic_From,":",Magic_To);
   if(Only_Comment!="")
      ShortName=StringConcatenate(ShortName," [",Only_Comment,"]");
   if(Only_Buys && !Only_Sells)
      ShortName=StringConcatenate(ShortName," Buys");
   if(Only_Sells && !Only_Buys)
      ShortName=StringConcatenate(ShortName," Sells");
   if(Only_Trading)
      ShortName=StringConcatenate(ShortName," Trading");

   SetIndexBuffer(0,Equity);
   SetIndexBuffer(1,Balance);
   SetIndexBuffer(2,Margin);
   SetIndexBuffer(3,Free);
   SetIndexBuffer(4,Orders);
   SetIndexBuffer(5,Zero);
   SetIndexLabel(0,"Equity");
   SetIndexLabel(1,"Balance");
   SetIndexLabel(2,"Margin");
   SetIndexLabel(3,"Free");
   SetIndexLabel(4,"Orders");
   SetIndexLabel(5,"Zero");
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexStyle(4,DRAW_HISTOGRAM);
   SetIndexStyle(5,DRAW_LINE);

   if(Show_Equity)   ShortName=StringConcatenate(ShortName," Equity");
   if(Show_Balance)  ShortName=StringConcatenate(ShortName," Balance");
   if(Show_Margin)   ShortName=StringConcatenate(ShortName," Margin");
   if(Show_Free)     ShortName=StringConcatenate(ShortName," Free");
   if(Show_Orders)   ShortName=StringConcatenate(ShortName," Orders");
   IndicatorShortName(ShortName);

   if(Equity_Max_Alert!=0) alert_upper_active=true; else alert_upper_active=false;
   if(Equity_Min_Alert!=0) alert_lower_active=true; else alert_lower_active=false;

   IndicatorDigits(2);
   return(INIT_SUCCEEDED);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   DeleteObjects();
   return;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   if(error) return(0);

   if(CheckNewBar()) restart=true;
   if(CheckNewBalance()) restart=true;
   if(CheckNewAccount()) restart=true;

   if(restart)
     {
      RunCleaning();
      CalculateHistoryBars();
      restart=false;
     }

   CalculateLastBar();
   ShowStatistics();
   RunMonitoring();

   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RunCleaning()
  {
   DeleteObjects();
   ArrayInitialize(Balance,EMPTY_VALUE);
   ArrayInitialize(Equity,EMPTY_VALUE);
   ArrayInitialize(Margin,EMPTY_VALUE);
   ArrayInitialize(Free,EMPTY_VALUE);
   ArrayInitialize(Zero,EMPTY_VALUE);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeleteObjects()
  {
   int objects=ObjectsTotal()-1;
   for(int i=objects;i>=0;i--)
     {
      string name=ObjectName(i);
      if(StringFind(name,name_prefix)!=-1) ObjectDelete(name);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CalculateHistoryBars()
  {

   if(!OrderSelect(0,SELECT_BY_POS,MODE_HISTORY)) {restart=true;return;}

   DrawBeginBar=iBarShift(NULL,0,Draw_Begin);
   DrawEndBar=iBarShift(NULL,0,Draw_End);
   if(DrawEndBar==-1) DrawEndBar=0;

   if(Import_History!="") ImportData(); else PrepareData();

   int handle=PrepareFile();

   ResultBalance=0;
   ResultProfit=0;
   IntervalBalance=0;
   IntervalProfit=0;
   SumProfit=0;
   SumLoss=0;
   GrowthRatio=1;
   PeakProfit=0;
   PeakEquity=0;
   MaxDrawdown=0;
   RelDrawdown=0;
   StartTime=0;
   FinishTime=0;

   DrawBeginBar=MathMin(OpenBar[0],DrawBeginBar);
   CalcCurrency=AccountCurrency();
   MissingSymbols="";
   int start_from=0;

   GetStartBalance();

   for(int i=DrawBeginBar; i>=DrawEndBar; i--)
     {

      ProfitLoss=0;
      SumMargin=0;
      OrdersCount=0;
      ArrayInitialize(SymbolLong,0);
      ArrayInitialize(SymbolShort,0);

      for(int j=start_from; j<TotalOrders; j++)
        {

         int k=IndexOrderOpenTime[j][1];
         int m=IndexOrderOpenTime[start_from][1];

         if(!Filter[k]) continue;

         if(OpenBar[k]<i) break;
         if(CloseBar[m]>i) start_from++;

         if(CloseBar[k]==i && ClosePrice[k]!=0)
           {
            if(CloseTime[k]>FinishTime) FinishTime=CloseTime[k];
            double result=Swap[k]+Commission[k]+Profit[k];
            ResultProfit+=result;
            ResultBalance+=result;
            IntervalProfit+=result;
            if(result>0) SumProfit+=result; else SumLoss+=result;
           }

         else if(OpenBar[k]>=i && CloseBar[k]<=i)
           {

            if(Type[k]>5)
              {
               ResultBalance+=Profit[k];
               if(IntervalProfit!=0 && IntervalBalance!=0)
                  GrowthRatio*=(1+(IntervalProfit/IntervalBalance));
               IntervalBalance=ResultBalance;
               IntervalProfit=0;
               if(i>DrawBeginBar) continue;
               if(!Show_Verticals) continue;
               string text=StringConcatenate(Instrument[k],": ",DoubleToStr(Profit[k],2)," ",CalcCurrency);
               CreateLine("Balance "+TimeToStr(OpenTime[k]),OBJ_VLINE,1,OrangeRed,STYLE_DOT,false,text,Time[i],0);
               continue;
              }

            if(i>DrawBeginBar) continue;
            if(!CheckSymbol(k)) continue;

            if(StartTime==0) StartTime=MathMax(OpenTime[k],Time[i]);

            int bar=iBarShift(Instrument[k],0,Time[i]);
            int day_bar=TimeDayOfWeek(iTime(Instrument[k],0,bar));
            int day_next_bar=TimeDayOfWeek(iTime(Instrument[k],0,bar+1));
            if(day_bar!=day_next_bar && OpenBar[k]!=bar)
              {
               int mode=(int)MarketInfo(Instrument[k],MODE_PROFITCALCMODE);
               if(mode==0)
                 {
                  if(TimeDayOfWeek(iTime(Instrument[k],0,bar))==4) CumSwap[k]+=3*DaySwap[k];
                  else CumSwap[k]+=DaySwap[k];
                 }
               else
                 {
                  if(TimeDayOfWeek(iTime(Instrument[k],0,bar))==1) CumSwap[k]+=3*DaySwap[k];
                  else CumSwap[k]+=DaySwap[k];
                 }
              }

            if(Type[k]==OP_BUY)
              {
               OrdersCount++;
               SymbolLong[IndexOrderSymbol[k]]+=Lots[k];
               LotValue=ContractValue(Instrument[k],Time[i],Period(),CalcCurrency);
               ProfitLoss+=Commission[k]+CumSwap[k]+(iClose(Instrument[k],0,bar)-OpenPrice[k])*Lots[k]*LotValue;
              }
            if(Type[k]==OP_SELL)
              {
               OrdersCount++;
               SymbolShort[IndexOrderSymbol[k]]+=Lots[k];
               LotValue=ContractValue(Instrument[k],Time[i],Period(),CalcCurrency);
               ProfitLoss+=Commission[k]+CumSwap[k]+(OpenPrice[k]-iClose(Instrument[k],0,bar)-Spread[k])*Lots[k]*LotValue;
              }

           }

        }

      if(i>DrawBeginBar) continue;

      for(int k=0;k<TotalSymbols;k++)
        {
         double hedged=MathMin(SymbolLong[k],SymbolShort[k])*2;
         double unhedged=SymbolLong[k]+SymbolShort[k]-hedged;
         SumMargin+=(hedged*SymbolHedge[k]+unhedged)*SymbolMargin[k];
        }

      if(i==MathMin(DrawBeginBar,OpenBar[0])) PeakEquity=ResultBalance;

      if(Show_Equity)
      if(Only_Trading)  {Equity[i]=NormalizeDouble(ResultProfit+ProfitLoss,2);}
      else              {Equity[i]=NormalizeDouble(ResultBalance+ProfitLoss,2);}
      if(Show_Balance)  {Balance[i]=NormalizeDouble(Only_Trading?ResultProfit:ResultBalance,2);}
      if(Show_Margin)   {Margin[i]=NormalizeDouble(SumMargin,2);}
      if(Show_Free)     {Free[i]=NormalizeDouble(ResultBalance+ProfitLoss-SumMargin,2);}
      if(Show_Orders)   {Orders[i]=OrdersCount;}
      if(Show_Zero)     {Zero[i]=0;}
      if(Show_Info)     {GetDrawdown();}

      if(ProfitLoss!=0) FinishTime=Time[i]+PeriodSeconds(PERIOD_CURRENT);

      WriteData(handle,i);

     }

   if(IntervalProfit!=0 && IntervalBalance!=0)
      GrowthRatio*=(1+(IntervalProfit/IntervalBalance));
   IntervalBalance=ResultBalance;
   IntervalProfit=0;

   if(Write_Data_File!="" && handle>0) FileClose(handle);

   if(Equity_Min_Alert!=0)
      CreateLine("Alert-Min",OBJ_HLINE,1,Silver,STYLE_DOT,false,"Min equity alert",0,Equity_Min_Alert);
   if(Equity_Max_Alert!=0)
      CreateLine("Alert-Max",OBJ_HLINE,1,Silver,STYLE_DOT,false,"Max equity alert",0,Equity_Max_Alert);

   if(Chart_Grid_Size!=0) DrawChartGrid();

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CalculateLastBar()
  {

   if(DrawEndBar>0) return;
   if(Import_History!="") return;

   ProfitLoss=0;
   SumMargin=0;
   OrdersCount=0;
   TotalOpen=OrdersTotal();
   ArrayInitialize(SymbolLong,0);
   ArrayInitialize(SymbolShort,0);
   IndexSymbols(false);

   if(TotalOpen>0)
      for(int i=0; i<TotalOpen; i++)
        {
         if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
         if(!FilterOrder(0,true)) continue;
         ProfitLoss+=OrderProfit()+OrderSwap()+OrderCommission();
         int type=OrderType();
         if(type==OP_BUY)  SymbolLong[IndexOrderSymbol[i]]+=OrderLots();
         if(type==OP_SELL) SymbolShort[IndexOrderSymbol[i]]+=OrderLots();
         OrdersCount++;
        }

   for(int k=0; k<TotalSymbols; k++)
     {
      double hedged=MathMin(SymbolLong[k],SymbolShort[k])*2;
      double unhedged=SymbolLong[k]+SymbolShort[k]-hedged;
      SumMargin+=(hedged*SymbolHedge[k]+unhedged)*SymbolMargin[k];
     }

   if(Show_Equity)
   if(Only_Trading)  {Equity[0]=NormalizeDouble(ResultProfit+ProfitLoss,2);}
   else              {Equity[0]=NormalizeDouble(ResultBalance+ProfitLoss,2);}
   if(Show_Balance)  {Balance[0]=NormalizeDouble(Only_Trading?ResultProfit:ResultBalance,2);}
   if(Show_Margin)   {Margin[0]=NormalizeDouble(SumMargin,2);}
   if(Show_Free)     {Free[0]=NormalizeDouble(ResultBalance+ProfitLoss-SumMargin,2);}
   if(Show_Orders)   {Orders[0]=OrdersCount;}
   if(Show_Zero)     {Zero[0]=0;}
   if(Show_Info)     {GetDrawdown();}

   if(Show_Balance)
      CreateLine("Equity Level",OBJ_HLINE,1,SteelBlue,STYLE_DOT,false,"",0,Equity[0]);
   if(Show_Equity)
      CreateLine("Balance Level",OBJ_HLINE,1,Crimson,STYLE_DOT,false,"",0,Balance[0]);
   if(Show_Margin)
      CreateLine("Margin Level",OBJ_HLINE,1,Crimson,STYLE_DOT,false,"",0,Margin[0]);
   if(Show_Free)
      CreateLine("Free Level",OBJ_HLINE,1,Crimson,STYLE_DOT,false,"",0,Free[0]);
   if(Show_Orders)
      CreateLine("Orders Level",OBJ_HLINE,1,Crimson,STYLE_DOT,false,"",0,Orders[0]);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ShowStatistics()
  {

   if(!Show_Info) return;

   double                     periods=double(FinishTime-StartTime);
   if(Report_Period==day)     periods=periods/24/60/60;
   if(Report_Period==week)    periods=periods/7/24/60/60;
   if(Report_Period==month)   periods=periods/30/24/60/60;
   if(Report_Period==quarter) periods=periods/90/24/60/60;
   if(Report_Period==halfyear)periods=periods/365*2/24/60/60;
   if(Report_Period==year)    periods=periods/365/24/60/60;
   if(Report_Period==history) periods=1;
   if(      periods==0)       periods=1;

   NetProfit=(SumProfit+SumLoss)/periods;
   Profitability=100*(GrowthRatio-1)/periods;
   string text=StringConcatenate(": ",DoubleToStr(NetProfit,2)," ",CalcCurrency," (",DoubleToStr(Profitability,2),"%)");

   if(Report_Period==day)     CreateLabel("Net Profit / Day",text,20);
   if(Report_Period==week)    CreateLabel("Net Profit / Week",text,20);
   if(Report_Period==month)   CreateLabel("Net Profit / Month",text,20);
   if(Report_Period==quarter) CreateLabel("Net Profit / Quarter",text,20);
   if(Report_Period==halfyear)CreateLabel("Net Profit / Half-year",text,20);
   if(Report_Period==year)    CreateLabel("Net Profit / Year",text,20);
   if(Report_Period==history) CreateLabel("Total Net Profit",text,20);

   text=StringConcatenate(": ",DoubleToStr(MaxDrawdown,2)," "+CalcCurrency," (",DoubleToStr(RelDrawdown*100,2),"%)");
   CreateLabel("Max Drawdown",text,40);

   if(MaxDrawdown!=0) RecoveryFactor=(SumProfit+SumLoss)/MaxDrawdown;
   text=StringConcatenate(": ",DoubleToStr(RecoveryFactor,2));
   CreateLabel("Recovery Factor",text,60);

   if(SumLoss!=0) ProfitFactor=-SumProfit/SumLoss;
   text=StringConcatenate(": ",DoubleToStr(ProfitFactor,2));
   CreateLabel("Profit Factor",text,80);

   if(StringLen(MissingSymbols)>0)
      CreateLabel("Missing symbols:",MissingSymbols,100);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RunMonitoring()
  {
   if(alert_upper_active)
      if(Equity[0]!=EMPTY_VALUE)
         if(Equity[0]>=Equity_Max_Alert)
           {
            string message=StringConcatenate("Account #",AccountNumber()," equity alert: ",Equity[0]," ",CalcCurrency);
            Alert(message);
            if(Push_Alerts) SendNotification(message);
            alert_upper_active=false;
           }
   if(alert_lower_active)
      if(Equity[0]!=EMPTY_VALUE)
         if(Equity[0]<=Equity_Min_Alert)
           {
            string message=StringConcatenate("Account #",AccountNumber()," equity alert: ",Equity[0]," ",CalcCurrency);
            Alert(message);
            if(Push_Alerts) SendNotification(message);
            alert_lower_active=false;
           }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PrepareData()
  {

   TotalHistory=OrdersHistoryTotal();
   TotalOpen=OrdersTotal();
   TotalOrders=TotalHistory+TotalOpen;

   ArrayResize(IndexOrderOpenTime,TotalOrders);
   ArrayResize(Ticket,TotalOrders);
   ArrayResize(OpenTime,TotalOrders);
   ArrayResize(CloseTime,TotalOrders);
   ArrayResize(OpenBar,TotalOrders);
   ArrayResize(CloseBar,TotalOrders);
   ArrayResize(Type,TotalOrders);
   ArrayResize(Lots,TotalOrders);
   ArrayResize(Instrument,TotalOrders);
   ArrayResize(OpenPrice,TotalOrders);
   ArrayResize(ClosePrice,TotalOrders);
   ArrayResize(Commission,TotalOrders);
   ArrayResize(Swap,TotalOrders);
   ArrayResize(CumSwap,TotalOrders);
   ArrayResize(DaySwap,TotalOrders);
   ArrayResize(Profit,TotalOrders);
   ArrayResize(Spread,TotalOrders);
   ArrayResize(Magic,TotalOrders);
   ArrayResize(Comments,TotalOrders);
   ArrayResize(Filter,TotalOrders);

   for(int i=0; i<TotalHistory; i++)
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
         ReadOrder(i);

   for(int i=0; i<TotalOpen; i++)
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         ReadOrder(TotalHistory+i);

   ArraySort(IndexOrderOpenTime);

   PrepareSymbols();
   IndexSymbols(true);

   ExportData();

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ReadOrder(int n)
  {

   Ticket[n]=OrderTicket();
   Type[n]=OrderType();
   Lots[n]=OrderLots();

   if(Type[n]>5)  Instrument[n]=OrderComment();
   else           Instrument[n]=OrderSymbol();

   OpenPrice[n]=OrderOpenPrice();
   OpenTime[n]=OrderOpenTime();
   OpenBar[n]=iBarShift(NULL,0,OpenTime[n]);

   CloseTime[n]=OrderCloseTime();
   if(CloseTime[n]!=0)
     {
      CloseBar[n]=iBarShift(NULL,0,CloseTime[n]);
      ClosePrice[n]=OrderClosePrice();
     }
   else
     {
      CloseBar[n]=0;
      ClosePrice[n]=0;
     }

   IndexOrderOpenTime[n][0]=(int)OpenTime[n];
   IndexOrderOpenTime[n][1]=n;

   Spread[n]=MarketInfo(Instrument[n],MODE_ASK)-MarketInfo(Instrument[n],MODE_BID);
   Commission[n]=OrderCommission();
   Swap[n]=OrderSwap();
   Profit[n]=OrderProfit();

   Magic[n]=OrderMagicNumber();
   Comments[n]=OrderComment();

   CumSwap[n]=0;
   int swapdays=0;

   for(int bar=OpenBar[n]-1; bar>=CloseBar[n]; bar--)
     {
      if(TimeDayOfWeek(iTime(NULL,0,bar))!=TimeDayOfWeek(iTime(NULL,0,bar+1)))
        {
         int mode=(int)MarketInfo(Instrument[n],MODE_PROFITCALCMODE);
         if(mode==0)
           {
            if(TimeDayOfWeek(iTime(NULL,0,bar))==4) swapdays+=3;
            else swapdays++;
           }
         else
           {
            if(TimeDayOfWeek(iTime(NULL,0,bar))==1) swapdays+=3;
            else swapdays++;
           }
        }
     }

   if(swapdays>0) DaySwap[n]=Swap[n]/swapdays; else DaySwap[n]=0.0;

   if(Lots[n]==0)
     {
      string ticket=StringSubstr(Comments[n],StringFind(Comments[n],"#")+1);
      if(OrderSelect(StrToInteger(ticket),SELECT_BY_TICKET,MODE_HISTORY)) Lots[n]=OrderLots();
     }

   Filter[n]=FilterOrder(n,false);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool FilterOrder(int n,bool active)
  {
   if(active)
     {
      if(OrderType()>5) return(true);
      if(OrderType()>1) return(false);
      if(Only_Magics) if(OrderMagicNumber()<Magic_From) return(false);
      if(Only_Magics) if(OrderMagicNumber()>Magic_To)   return(false);
      if(Only_Comment!="") if(StringFind(OrderComment(),Only_Comment)==-1) return(false);
      if(Only_Symbols!="") if(StringFind(Only_Symbols,OrderSymbol())==-1)  return(false);
      if(Only_Symbols=="") if(Only_Current) if(OrderSymbol()!=Symbol())    return(false);
      if(Only_Buys  && OrderType()!=OP_BUY)  return(false);
      if(Only_Sells && OrderType()!=OP_SELL) return(false);
      return(true);
     }
   else
     {
      if(Type[n]>5) return(true);
      if(Type[n]>1) return(false);
      if(Only_Magics) if(Magic[n]<Magic_From) return(false);
      if(Only_Magics) if(Magic[n]>Magic_To)   return(false);
      if(Only_Comment!="") if(StringFind(Comments[n],Only_Comment)==-1) return(false);
      if(Only_Symbols!="") if(StringFind(Only_Symbols,Instrument[n])==-1)  return(false);
      if(Only_Symbols=="") if(Only_Current) if(Instrument[n]!=Symbol())    return(false);
      if(Only_Buys  && Type[n]!=OP_BUY)  return(false);
      if(Only_Sells && Type[n]!=OP_SELL) return(false);
      return(true);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ExportData()
  {
   if(Export_History!="")
     {
      int id=FileOpen(Export_History,FILE_CSV|FILE_WRITE);
      if(id<0) Alert("Error #",GetLastError()," while opening export file.");
      else
        {
         FileWrite(id,"Ticket","Open","Position","Volume","Symbol",
                   "Entry","Close","Exit","Commission","Swap","Profit","Magic","Comment");
         for(int j=0;j<TotalOrders;j++)
           {
            string ticket=IntegerToString(Ticket[j]);
            string open_time=TimeToString(OpenTime[j],TIME_DATE|TIME_MINUTES);
            string type="BALANCE";
            if(Type[j]==OP_BUY) type="BUY";
            if(Type[j]==OP_SELL) type="SELL";
            string lots=DoubleToString(Lots[j],2);
            string instrument=Instrument[j];
            int digits=(int)MarketInfo(Instrument[j],MODE_DIGITS);
            string open_price=DoubleToString(OpenPrice[j],digits);
            string close_time=TimeToString(CloseTime[j],TIME_DATE|TIME_MINUTES);
            string close_price=DoubleToString(ClosePrice[j],digits);
            string commission=DoubleToString(Commission[j],2);
            string swap=DoubleToString(Swap[j],2);
            string profit=DoubleToString(Profit[j],2);
            FileWrite(id,ticket,open_time,type,lots,instrument,
                      open_price,close_time,close_price,commission,swap,profit,Magic[j],Comments[j]);
           }
         FileClose(id);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ImportData()
  {

   if(Import_History=="") return;

   TotalOrders=0;
   TotalHistory=0;
   TotalOpen=0;

   int id=FileOpen(Import_History,FILE_CSV|FILE_READ);

   if(id<0)
     {
      Alert("Error #",GetLastError()," while opening import file.");
      Import_History="";
      return;
     }

   while(true)
     {

      string ticket=FileReadString(id);
      string open_time=FileReadString(id);
      string type=FileReadString(id);
      string lots=FileReadString(id);
      string instrument=FileReadString(id);
      string open_price=FileReadString(id);
      string close_time=FileReadString(id);
      string close_price=FileReadString(id);
      string commission=FileReadString(id);
      string swap=FileReadString(id);
      string profit=FileReadString(id);
      string magic=FileReadString(id);
      string comments=FileReadString(id);

      if(ticket=="Ticket") continue;

      TotalOrders++;
      TotalHistory++;

      ArrayResize(IndexOrderOpenTime,TotalOrders);
      ArrayResize(Ticket,TotalOrders);
      ArrayResize(OpenTime,TotalOrders);
      ArrayResize(CloseTime,TotalOrders);
      ArrayResize(OpenBar,TotalOrders);
      ArrayResize(CloseBar,TotalOrders);
      ArrayResize(Type,TotalOrders);
      ArrayResize(Lots,TotalOrders);
      ArrayResize(Instrument,TotalOrders);
      ArrayResize(OpenPrice,TotalOrders);
      ArrayResize(ClosePrice,TotalOrders);
      ArrayResize(Commission,TotalOrders);
      ArrayResize(Swap,TotalOrders);
      ArrayResize(CumSwap,TotalOrders);
      ArrayResize(DaySwap,TotalOrders);
      ArrayResize(Profit,TotalOrders);
      ArrayResize(Spread,TotalOrders);
      ArrayResize(Magic,TotalOrders);
      ArrayResize(Comments,TotalOrders);
      ArrayResize(Filter,TotalOrders);

      int n=TotalOrders-1;

      if(type=="BUY") Type[n]=OP_BUY;
      else if(type=="SELL") Type[n]=OP_SELL;
      else Type[n]=6;

      Ticket[n]=(int)StringToInteger(ticket);
      Lots[n]=StringToDouble(lots);
      Instrument[n]=instrument;

      OpenPrice[n]=StringToDouble(open_price);
      OpenTime[n]=StringToTime(open_time);
      OpenBar[n]=iBarShift(NULL,0,OpenTime[n]);

      CloseTime[n]=StringToTime(close_time);
      if(CloseTime[n]!=0)
        {
         CloseBar[n]=iBarShift(NULL,0,CloseTime[n]);
         ClosePrice[n]=StringToDouble(close_price);
        }
      else
        {
         CloseBar[n]=0;
         ClosePrice[n]=0;
        }

      Spread[n]=MarketInfo(Instrument[n],MODE_ASK)-MarketInfo(Instrument[n],MODE_BID);
      Commission[n]=StringToDouble(commission);
      Swap[n]=StringToDouble(swap);
      Profit[n]=StringToDouble(profit);

      Magic[n]=(int)StringToInteger(magic);
      Comments[n]=comments;

      IndexOrderOpenTime[n][0]=(int)OpenTime[n];
      IndexOrderOpenTime[n][1]=n;

      CumSwap[n]=0;
      int swapdays=0;

      for(int bar=OpenBar[n]-1; bar>=CloseBar[n]; bar--)
        {
         if(TimeDayOfWeek(iTime(NULL,0,bar))!=TimeDayOfWeek(iTime(NULL,0,bar+1)))
           {
            int mode=(int)MarketInfo(Instrument[n],MODE_PROFITCALCMODE);
            if(mode==0)
              {
               if(TimeDayOfWeek(iTime(NULL,0,bar))==4) swapdays+=3;
               else swapdays++;
              }
            else
              {
               if(TimeDayOfWeek(iTime(NULL,0,bar))==1) swapdays+=3;
               else swapdays++;
              }
           }
        }

      if(swapdays>0) DaySwap[n]=Swap[n]/swapdays; else DaySwap[n]=0.0;

      Filter[n]=FilterOrder(n,false);

      if(FileIsEnding(id)) break;

     }

   FileClose(id);

   ArraySort(IndexOrderOpenTime);

   PrepareSymbols();
   IndexSymbols(true);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PrepareSymbols()
  {
   TotalSymbols=SymbolsTotal(true);

   ArrayResize(SymbolNames,TotalSymbols);
   ArrayResize(SymbolHedge,TotalSymbols);
   ArrayResize(SymbolMargin,TotalSymbols);
   ArrayResize(SymbolLong,TotalSymbols);
   ArrayResize(SymbolShort,TotalSymbols);

   for(int i=0;i<TotalSymbols;i++)
     {
      SymbolNames[i]=SymbolName(i,true);
      if(Hedge_Margin_Rate>0) SymbolHedge[i]=Hedge_Margin_Rate/100;
      else SymbolHedge[i]=MarketInfo(SymbolNames[i],MODE_MARGINHEDGED)/MarketInfo(SymbolNames[i],MODE_LOTSIZE);
      SymbolMargin[i]=MarketInfo(SymbolNames[i],MODE_MARGINREQUIRED);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void IndexSymbols(bool first_run)
  {

   if(first_run)
     {
      ArrayResize(IndexOrderSymbol,TotalOrders);
      for(int j=0; j<TotalOrders; j++)
         if(Type[j]<=5)
            for(int i=0; i<TotalSymbols; i++)
               if(SymbolNames[i]==Instrument[j])
                 {
                  IndexOrderSymbol[j]=i;
                  break;
                 }
     }

   if(!first_run)
     {
      ArrayResize(IndexOrderSymbol,TotalOpen);
      for(int j=0; j<TotalOpen; j++)
        {
         if(!OrderSelect(j,SELECT_BY_POS,MODE_TRADES)) continue;
         if(!FilterOrder(0,true)) continue;
         for(int i=0; i<TotalSymbols; i++)
            if(SymbolNames[i]==OrderSymbol())
              {
               IndexOrderSymbol[j]=i;
               break;
              }
        }
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GetDrawdown()
  {
   if(ResultProfit+ProfitLoss>=PeakProfit)
     {
      PeakProfit=ResultProfit+ProfitLoss;
      PeakEquity=ResultBalance+ProfitLoss;
     }
   double current_drawdown=PeakProfit-ResultProfit-ProfitLoss;
   if(current_drawdown>MaxDrawdown)
     {
      MaxDrawdown=current_drawdown;
      if(PeakEquity==0) PeakEquity=DBL_MAX;
      RelDrawdown=current_drawdown/PeakEquity;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GetStartBalance()
  {
   if(Only_Trading || Import_History!="")
     {ResultBalance=0;return;}

   ResultBalance=AccountBalance();
   double sum=0;

   for(int j=0; j<TotalOrders; j++)
      if(CloseTime[j]!=0)
         if(CloseBar[j]<=DrawBeginBar)
            sum+=(Swap[j]+Commission[j]+Profit[j]);

   ResultBalance-=sum;
   IntervalBalance=ResultBalance;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ContractValue(string symbol,datetime time,int period,string currency)
  {
   double value=MarketInfo(symbol,MODE_LOTSIZE);
   string quote=SymbolInfoString(symbol,SYMBOL_CURRENCY_PROFIT);

   if(quote!="USD")
     {
      string direct=StringConcatenate(FX_prefix,quote,"USD",FX_postfix);
      if(MarketInfo(direct,MODE_POINT)!=0)
        {
         int shift=iBarShift(direct,period,time);
         double price=iClose(direct,period,shift);
         if(price>0) value*=price;
        }
      else
        {
         string indirect=FX_prefix+"USD"+quote+FX_postfix;
         int shift=iBarShift(indirect,period,time);
         double price=iClose(indirect,period,shift);
         if(price>0) value/=price;
        }
     }

   if(currency!="USD")
     {
      string direct=StringConcatenate(FX_prefix,currency,"USD",FX_postfix);
      if(MarketInfo(direct,MODE_POINT)!=0)
        {
         int shift=iBarShift(direct,period,time);
         double price=iClose(direct,period,shift);
         if(price>0) value/=price;
        }
      else
        {
         string indirect=StringConcatenate(FX_prefix,"USD",currency,FX_postfix);
         int shift=iBarShift(indirect,period,time);
         double price=iClose(indirect,period,shift);
         if(price>0) value*=price;
        }
     }

   return(value);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreateLabel(string name,string str,int y)
  {
   string objectname=StringConcatenate(name_prefix," ",name);
   if(ObjectFind(objectname)==-1)
     {
      ObjectCreate(objectname,OBJ_LABEL,window,0,0);
      ObjectSet(objectname,OBJPROP_XDISTANCE,10);
      ObjectSet(objectname,OBJPROP_YDISTANCE,y);
      ObjectSet(objectname,OBJPROP_COLOR,indicator_color1);
      ObjectSet(objectname,OBJPROP_CORNER,Text_Corner);
      ObjectSet(objectname,OBJPROP_COLOR,Text_Color);
     }
   ObjectSetText(objectname,name+str,Text_Size,Text_Font);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreateLine(string name,int type,int width,color clr,int style,bool ray,string str,
                datetime time1,double price1,datetime time2=0,double price2=0)
  {
   string objectname=StringConcatenate(name_prefix," ",name);
   if(ObjectFind(objectname)==-1)
     {
      ObjectCreate(objectname,type,window,time1,price1,time2,price2);
      ObjectSet(objectname,OBJPROP_WIDTH,width);
      ObjectSet(objectname,OBJPROP_RAY,ray);
     }
   ObjectSetText(objectname,str);
   ObjectSet(objectname,OBJPROP_COLOR,clr);
   ObjectSet(objectname,OBJPROP_TIME1,time1);
   ObjectSet(objectname,OBJPROP_PRICE1,price1);
   ObjectSet(objectname,OBJPROP_TIME2,time2);
   ObjectSet(objectname,OBJPROP_PRICE2,price2);
   ObjectSet(objectname,OBJPROP_STYLE,style);
   ObjectSet(objectname,OBJPROP_SELECTABLE,false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawChartGrid()
  {

   if(Chart_Grid_Size==0) return;

   double max=-1.7976931348623158e+308,min=1.7976931348623158e+308;
   for(int j=Bars-1; j>=0; j--)
     {
      double A=Balance[j];
      double B=Equity[j];
      if(A==EMPTY_VALUE && B==EMPTY_VALUE) continue;
      if(A==EMPTY_VALUE) A=B;
      if(B==EMPTY_VALUE) B=A;
      if(MathMax(A,B)>max) max=MathMax(A,B);
      if(MathMin(A,B)<min) min=MathMin(A,B);
     }

   if(Show_Margin) if(min>0) min=0;
   if(Show_Zero) if(min>0) min=0;

   double level=0;
   while(level<max)
     {
      level+=Chart_Grid_Size;
      string name=StringConcatenate("Level:",DoubleToString(level,2));
      CreateLine(name,OBJ_HLINE,1,Silver,STYLE_DOT,false,name,0,level);
     }

   level=0;
   while(level>min)
     {
      level-=Chart_Grid_Size;
      string name=StringConcatenate("Level:",DoubleToString(level,2));
      CreateLine(name,OBJ_HLINE,1,Silver,STYLE_DOT,false,name,0,level);
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int PrepareFile()
  {
   if(Write_Data_File=="") return(-1);
   string filename=StringConcatenate(AccountNumber(),"_",Period(),".csv");
   int handle=FileOpen(filename,FILE_CSV|FILE_WRITE);
   if(handle<0) { Alert("Error #",GetLastError()," while opening data file."); return(handle); }
   uint bytes=FileWrite(handle,"Date","Time","Equity","Balance");
   if(bytes<=0) Print("Error #",GetLastError()," while writing data file.");
   return(handle);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WriteData(int handle,int i)
  {
   if(Write_Data_File=="") return;
   if(handle<=0) return;
   string date=TimeToStr(Time[i],TIME_DATE);
   string time=TimeToStr(Time[i],TIME_MINUTES);
   uint bytes=FileWrite(handle,date,time,ResultBalance+ProfitLoss,ResultBalance);
   if(bytes<=0) Print("Error #",GetLastError()," while writing data file.");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CheckSymbol(int j)
  {
   if(MarketInfo(Instrument[j],MODE_POINT)!=0) return(true);
   if(StringFind(MissingSymbols,Instrument[j])==-1)
     {
      MissingSymbols=StringConcatenate(MissingSymbols," ",Instrument[j]);
      Print("Missing symbols in Market Watch: "+Instrument[j]);
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CheckNewAccount()
  {
   static int account=-1;
   if(account==AccountNumber()) return(false);
   account=AccountNumber();
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CheckNewBar()
  {
   static datetime time;
   if(Time[0]==time) return(false);
   time=Time[0];
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CheckNewBalance()
  {
   static double balance;
   if(AccountBalance()==balance) return(false);
   balance=AccountBalance();
   return(true);
  }
//+------------------------------------------------------------------+
