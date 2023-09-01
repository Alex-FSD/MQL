//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

#property copyright   "Box-Master (by Transcendreamer)"
#property description "Stop-Reverse Auto-Trading Bot"
#property strict

input double BOX_VALUE        =10;
input double TARGET_LEVEL     =2;
input double BREAKEVEN_LEVEL  =999;
input double REVERSE_MULT     =1;
input int    REVERSE_LIMIT    =2;
input int    GAP_PROTECT      =500;
input int    LOT_DIGITS       =2;
input double LOT_DIVIDER      =1;
input int    ORDER_ATTEMPTS   =20;
input int    ORDER_PAUSE      =1000;
input bool   STOP_REVERSE     =false;

#ifdef __MQL5__
input ENUM_ORDER_TYPE_FILLING FILLING_TYPE=ORDER_FILLING_FOK;
#endif

input ENUM_BASE_CORNER        TEXT_CORNER=CORNER_RIGHT_UPPER;
input color                   TEXT_COLOR=clrRed;

string   FONTNAME="Verdana";
int      FONTSIZE=10;
int      SPACING=18;
int      YOFFSET=18;
int      XOFFSET=5;

datetime saved_time;
int      total_boxes,total_lines;
double   current=0,previous=0;
double   box_profit,box_volume;
int      box_reversals;
bool     box_breakeven_buy,box_breakeven_sell;

double   border_upper[],border_lower[];
double   target_upper[],target_lower[];
double   breakeven_upper[],breakeven_lower[];
double   lot_min[],lot_max[];
double   off_level[];

bool     box_active[],line_active[];
bool     box_buy[],box_sell[],box_only[];
bool     box_trend[],box_timing[];
string   box_name[],line_name[];
string   box_comment[],line_comment[];
int      box_magic[],line_magic[];
datetime box_time[];


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   clean_old();
   scan_lines();
   scan_boxes();
   return(INIT_SUCCEEDED);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   clean_old();
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {

   if(id==CHARTEVENT_OBJECT_CLICK)
      for(int i=0; i<total_boxes; i++)
         if(sparam=="STATUS_"+box_name[i])
            if(MessageBox("BOX "+box_comment[i]+" WILL BE CLOSED",NULL,MB_OKCANCEL|MB_ICONINFORMATION)==IDOK)
              {
               Print("MANUAL CLOSING BOX "+box_comment[i]);
               close_all(box_magic[i]);
               off_box(i);
               return;
              }
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      clean_old();
      scan_lines();
      scan_boxes();
     }
   if(id==CHARTEVENT_OBJECT_CHANGE)
     {
      clean_old();
      scan_lines();
      scan_boxes();
     }
   if(id==CHARTEVENT_OBJECT_CREATE)
     {
      clean_old();
      scan_lines();
      scan_boxes();
     }
   if(id==CHARTEVENT_OBJECT_DELETE)
     {
      clean_old();
      scan_lines();
      scan_boxes();
     }
   if(id==CHARTEVENT_OBJECT_DRAG)
     {
      clean_old();
      scan_lines();
      scan_boxes();
     }
   if(id==CHARTEVENT_OBJECT_ENDEDIT)
     {
      clean_old();
      scan_lines();
      scan_boxes();
     }

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   datetime time=iTime(NULL,0,0);
   if(time!=saved_time)
     {
      move_boxes();
      scan_boxes();
      saved_time=time;
     }
   current=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(previous==0)
     {
      previous=current;
      return;
     }
   check_time();
   check_lines();
   check_boxes();
   previous=current;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void clean_old()
  {
   for(int i=ObjectsTotal(0,-1,-1)-1; i>=0; i--)
     {
      string name=ObjectName(0,i,-1,-1);
      if(StringFind(name,"STATUS_")!=-1)
         ObjectDelete(0,name);
      if(StringFind(name,"TARGET_UPPER_")!=-1)
         ObjectDelete(0,name);
      if(StringFind(name,"TARGET_LOWER_")!=-1)
         ObjectDelete(0,name);
      if(StringFind(name,"BREAKEVEN_UPPER_")!=-1)
         ObjectDelete(0,name);
      if(StringFind(name,"BREAKEVEN_LOWER_")!=-1)
         ObjectDelete(0,name);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void scan_boxes()
  {

   total_boxes=0;
   int count=ObjectsTotal(0,0,OBJ_RECTANGLE);

   for(int i=0; i<count; i++)
     {

      string name=ObjectName(0,i,0,OBJ_RECTANGLE);
      int pos=StringFind(name,"BOX");
      if(pos==-1)
         continue;

      total_boxes++;
      ArrayResize(box_active,total_boxes);
      ArrayResize(box_buy,total_boxes);
      ArrayResize(box_sell,total_boxes);
      ArrayResize(box_only,total_boxes);
      ArrayResize(box_trend,total_boxes);
      ArrayResize(box_timing,total_boxes);
      ArrayResize(box_time,total_boxes);
      ArrayResize(border_upper,total_boxes);
      ArrayResize(border_lower,total_boxes);
      ArrayResize(target_upper,total_boxes);
      ArrayResize(target_lower,total_boxes);
      ArrayResize(breakeven_upper,total_boxes);
      ArrayResize(breakeven_lower,total_boxes);
      ArrayResize(box_name,total_boxes);
      ArrayResize(box_magic,total_boxes);
      ArrayResize(box_comment,total_boxes);
      ArrayResize(lot_min,total_boxes);
      ArrayResize(lot_max,total_boxes);

      double value=BOX_VALUE;
      int left=StringFind(name,"[");
      int right=StringFind(name,"]");
      if(left!=-1 && right!=-1 && left<right)
         value=StringToDouble(StringSubstr(name,left+1,right-left-1));

      box_name[i]    =name;
      box_active[i]  =true;
      box_buy[i]     =(StringFind(name,"BUY")!=-1);
      box_sell[i]    =(StringFind(name,"SELL")!=-1);
      box_only[i]    =(StringFind(name,"ONLY")!=-1);
      box_trend[i]   =(StringFind(name,"TREND")!=-1);
      box_timing[i]  =(StringFind(name,"TIME")!=-1);
      box_comment[i] =(StringSubstr(name,pos+3));
      box_magic[i]   =(int)StringToInteger(box_comment[i]);

      double  price0=ObjectGetDouble(0,name,OBJPROP_PRICE,0);
      double  price1=ObjectGetDouble(0,name,OBJPROP_PRICE,1);
      long    time0=ObjectGetInteger(0,name,OBJPROP_TIME,0);
      long    time1=ObjectGetInteger(0,name,OBJPROP_TIME,1);

      double upper=(price0>price1)?price0:price1;
      double lower=(price0<price1)?price0:price1;
      double width=upper-lower;

      border_upper[i]=NormalizeDouble(upper,_Digits);
      border_lower[i]=NormalizeDouble(lower,_Digits);
      target_upper[i]=NormalizeDouble(upper+width*TARGET_LEVEL,_Digits);
      target_lower[i]=NormalizeDouble(lower-width*TARGET_LEVEL,_Digits);
      breakeven_upper[i]=NormalizeDouble(upper+width*BREAKEVEN_LEVEL,_Digits);
      breakeven_lower[i]=NormalizeDouble(lower-width*BREAKEVEN_LEVEL,_Digits);

      int line_width=(int)ObjectGetInteger(0,name,OBJPROP_WIDTH,0);
      int line_style=(int)ObjectGetInteger(0,name,OBJPROP_STYLE,0);
      color line_color=(color)ObjectGetInteger(0,name,OBJPROP_COLOR,0);
      ObjectSetString(0,name,OBJPROP_TEXT,name);

      string name_target_upper="TARGET_UPPER_"+box_comment[i];
      string name_target_lower="TARGET_LOWER_"+box_comment[i];
      string name_breakeven_upper="BREAKEVEN_UPPER_"+box_comment[i];
      string name_breakeven_lower="BREAKEVEN_LOWER_"+box_comment[i];

      make_level(name_target_upper,time0,time1,target_upper[i],line_color,line_width,line_style);
      make_level(name_target_lower,time0,time1,target_lower[i],line_color,line_width,line_style);
      make_level(name_breakeven_upper,time0,time1,breakeven_upper[i],line_color,line_width,STYLE_DOT);
      make_level(name_breakeven_lower,time0,time1,breakeven_lower[i],line_color,line_width,STYLE_DOT);

      double ts=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
      double tv=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);

      lot_min[i]=value/(width/ts*tv)/LOT_DIVIDER;
      lot_max[i]=lot_min[i]*MathPow(REVERSE_MULT,REVERSE_LIMIT);

      box_time[i]=(datetime)time1;
      update_status(i);

     }

   Print(total_boxes," TOTAL BOXES SCANNED");
   ChartRedraw(0);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void make_level(string name,datetime time0, datetime time1,double price,color colour,int width,int style)
  {
   ObjectCreate(0,name,OBJ_TREND,0,0,0);
   ObjectSetDouble(0,name,OBJPROP_PRICE,0,price);
   ObjectSetDouble(0,name,OBJPROP_PRICE,1,price);
   ObjectSetInteger(0,name,OBJPROP_TIME,0,time0);
   ObjectSetInteger(0,name,OBJPROP_TIME,1,time1);
   ObjectSetInteger(0,name,OBJPROP_COLOR,colour);
   ObjectSetInteger(0,name,OBJPROP_WIDTH,width);
   ObjectSetInteger(0,name,OBJPROP_STYLE,style);
   ObjectSetInteger(0,name,OBJPROP_RAY,false);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void move_boxes()
  {
   for(int i=0; i<total_boxes; i++)
      if(box_trend[i])
        {
         string trend_name="TREND"+box_comment[i];
         if(ObjectFind(0,trend_name)<0)
            continue;
         double p0=ObjectGetDouble(0,trend_name,OBJPROP_PRICE,0);
         double p1=ObjectGetDouble(0,trend_name,OBJPROP_PRICE,1);
         datetime t0=(int)ObjectGetInteger(0,trend_name,OBJPROP_TIME,0);
         datetime t1=(int)ObjectGetInteger(0,trend_name,OBJPROP_TIME,1);
         int seconds=PeriodSeconds(PERIOD_CURRENT);
         double shift=0;
         if(t1!=t0)
            shift=(p1-p0)/(t1-t0)*seconds;
         p0=ObjectGetDouble(0,box_name[i],OBJPROP_PRICE,0)+shift;
         p1=ObjectGetDouble(0,box_name[i],OBJPROP_PRICE,1)+shift;
         t0=(int)ObjectGetInteger(0,box_name[i],OBJPROP_TIME,0)+seconds;
         t1=(int)ObjectGetInteger(0,box_name[i],OBJPROP_TIME,1)+seconds;
         ObjectSetDouble(0,box_name[i],OBJPROP_PRICE,0,p0);
         ObjectSetDouble(0,box_name[i],OBJPROP_PRICE,1,p1);
         ObjectSetInteger(0,box_name[i],OBJPROP_TIME,0,t0);
         ObjectSetInteger(0,box_name[i],OBJPROP_TIME,1,t1);
        }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void scan_lines()
  {
   int count=ObjectsTotal(0,0,OBJ_HLINE);
   total_lines=0;

   for(int i=0; i<count; i++)
     {
      string name=ObjectName(0,i,0,OBJ_HLINE);
      int pos=StringFind(name,"OFF");
      if(pos==-1)
         continue;

      total_lines++;
      ArrayResize(line_name,total_lines);
      ArrayResize(line_active,total_lines);

      line_name[i]      =name;
      line_active[i]    =true;
      line_comment[i]   =StringSubstr(name,pos+3);
      line_magic[i]     =(int)StringToInteger(line_comment[i]);
      off_level[i]      =NormalizeDouble(ObjectGetDouble(0,name,OBJPROP_PRICE),_Digits);
     }

   Print(total_lines," TOTAL LINES SCANNED");
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void check_time()
  {
   for(int i=0; i<total_boxes; i++)
     {
      if(!box_active[i])
         continue;
      if(!box_timing[i])
         continue;
      if(TimeCurrent()>box_time[i])
         off_box(i);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void check_lines()
  {
   for(int i=0; i<total_lines; i++)
     {
      if(!line_active[i])
         continue;

      if(current>off_level[i])
         if(previous>off_level[i])
            continue;

      if(current<off_level[i])
         if(previous<off_level[i])
            continue;

      for(int j=0; j<total_boxes; j++)
         if(box_magic[j]==line_magic[i])
           {
            off_box(j);
            off_line(i);
           }
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void check_boxes()
  {

   for(int i=0; i<total_boxes; i++)
     {
      if(!box_active[i])
         continue;

      box_volume=get_volume(box_magic[i]);
      box_profit=get_profit(box_magic[i]);
      box_reversals=(int)GlobalVariableGet("REVERSALS_"+box_name[i]);
      box_breakeven_buy=GlobalVariableCheck("BREAKEVEN_BUY_"+box_name[i]);
      box_breakeven_sell=GlobalVariableCheck("BREAKEVEN_SELL_"+box_name[i]);

      check_box_close(i);
      check_box_breakeven(i);
      check_box_open(i);
      check_box_reverse(i);
      update_status(i);
     }

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void check_box_close(int i)
  {

   if(current>=target_upper[i])
      if(box_volume>0)
        {
         Print("UPPER LIMIT CLOSING FOR BOX ",box_comment[i]);
         close_all(box_magic[i]);
         off_box(i);
         return;
        }

   if(current<=target_lower[i])
      if(box_volume<0)
        {
         Print("LOWER LIMIT CLOSING FOR BOX ",box_comment[i]);
         close_all(box_magic[i]);
         off_box(i);
         return;
        }

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void check_box_breakeven(int i)
  {

   if(box_breakeven_buy)
      if(current<=border_upper[i])
         if(box_volume>0)
           {
            Print("BUY BREAKEVEN CLOSING FOR BOX ",box_comment[i]);
            close_all(box_magic[i]);
            off_box(i);
            return;
           }

   if(box_breakeven_sell)
      if(current>=border_lower[i])
         if(box_volume<0)
           {
            Print("SELL BREAKEVEN CLOSING FOR BOX ",box_comment[i]);
            close_all(box_magic[i]);
            off_box(i);
            return;
           }

   if(!box_breakeven_buy)
      if(current>=breakeven_upper[i])
        {
         Print("BUY BREAKEVEN ACTIVATED FOR BOX ",box_comment[i]);
         box_breakeven_buy=true;
         GlobalVariableSet("BREAKEVEN_BUY_"+box_name[i],1);
        }

   if(!box_breakeven_sell)
      if(current<=breakeven_lower[i])
        {
         Print("SELL BREAKEVEN ACTIVATED FOR BOX ",box_comment[i]);
         box_breakeven_sell=true;
         GlobalVariableSet("BREAKEVEN_SELL_"+box_name[i],1);
        }

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void check_box_open(int i)
  {

   if(box_volume!=0)
      return;

   if(!box_sell[i])
      if(current>=border_upper[i])
         if(previous<border_upper[i])
            if(current<=border_upper[i]+GAP_PROTECT*_Point)
              {
               Print("OPENING LONG FOR BOX ",box_comment[i]);
               Print("VOLUME: ",DoubleToString(lot_min[i],LOT_DIGITS));
               do_open(lot_min[i],box_magic[i],box_comment[i]);
               return;
              }

   if(!box_buy[i])
      if(current<=border_lower[i])
         if(previous>border_lower[i])
            if(current>=border_lower[i]-GAP_PROTECT*_Point)
              {
               Print("OPENING SHORT FOR BOX ",box_comment[i]);
               Print("VOLUME: ",DoubleToString(lot_min[i],LOT_DIGITS));
               do_open(-lot_min[i],box_magic[i],box_comment[i]);
               return;
              }

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void check_box_reverse(int i)
  {

   if(box_reversals>=REVERSE_LIMIT)
     {
      Print("FULL STOP FOR BOX ",box_comment[i]);
      close_all(box_magic[i]);
      off_box(i);
      return;
     }

   if(box_volume<0)
      if(current>=border_upper[i])
         if(previous<border_upper[i])
            if(box_only[i]&&box_sell[i])
              {
               Print("STOPPING FOR BOX ",box_comment[i]);
               close_all(box_magic[i]);
               GlobalVariableSet("REVERSALS_"+box_name[i],++box_reversals);
               return;
              }
            else
              {
               double new_volume=get_new_volume(i);
               Print("REVERSING UP FOR BOX ",box_comment[i]);
               Print("VOLUME: ",new_volume);
               if(STOP_REVERSE)
                  close_all(box_magic[i]);
               do_open(new_volume,box_magic[i],box_comment[i]);;
               GlobalVariableSet("REVERSALS_"+box_name[i],++box_reversals);
               return;
              }

   if(box_volume>0)
      if(current<=border_lower[i])
         if(previous>border_lower[i])
            if(box_only[i]&&box_buy[i])
              {
               Print("STOPPING FOR BOX ",box_comment[i]);
               close_all(box_magic[i]);
               GlobalVariableSet("REVERSALS_"+box_name[i],++box_reversals);
               return;
              }
            else
              {
               double new_volume=get_new_volume(i);
               Print("REVERSING DOWN FOR BOX ",box_comment[i]);
               Print("VOLUME: ",new_volume);
               if(STOP_REVERSE)
                  close_all(box_magic[i]);
               do_open(new_volume,box_magic[i],box_comment[i]);
               GlobalVariableSet("REVERSALS_"+box_name[i],++box_reversals);
               return;
              }

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void update_status(int i)
  {

   if(!box_active[i])
      return;

   string name="STATUS_"+box_name[i];
   string text_min=DoubleToString(lot_min[i],LOT_DIGITS);
   string text_max=DoubleToString(lot_max[i],LOT_DIGITS);
   string text_vol=DoubleToString(box_volume,LOT_DIGITS);
   string text_pnl=DoubleToString(box_profit,2);
   string text_rev=IntegerToString(box_reversals);

   string text_brk="---";
   if(box_breakeven_buy)
      text_brk="BUY";
   if(box_breakeven_sell)
      text_brk="SELL";

   string text=box_name[i]+
               "  LOTS:"+text_min+"-"+text_max+
               "  VOL:"+text_vol+
               "  P/L:"+text_pnl+
               "  REV:"+text_rev+
               "  B/E:"+text_brk;

   ENUM_ANCHOR_POINT text_anchor=0;
   if(TEXT_CORNER==CORNER_LEFT_LOWER)
      text_anchor=ANCHOR_LEFT_LOWER;
   if(TEXT_CORNER==CORNER_LEFT_UPPER)
      text_anchor=ANCHOR_LEFT_UPPER;
   if(TEXT_CORNER==CORNER_RIGHT_LOWER)
      text_anchor=ANCHOR_RIGHT_LOWER;
   if(TEXT_CORNER==CORNER_RIGHT_UPPER)
      text_anchor=ANCHOR_RIGHT_UPPER;

   ObjectCreate(0,name,OBJ_LABEL,0,0,0);
   ObjectSetString(0,name,OBJPROP_TEXT,text);
   ObjectSetString(0,name,OBJPROP_FONT,FONTNAME);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FONTSIZE);
   ObjectSetInteger(0,name,OBJPROP_COLOR, TEXT_COLOR);
   ObjectSetInteger(0,name,OBJPROP_CORNER,TEXT_CORNER);
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,text_anchor);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,XOFFSET);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,YOFFSET+i*SPACING);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double get_new_volume(int i)
  {
   double new_volume=-box_volume*REVERSE_MULT;
   if(!STOP_REVERSE)
      new_volume=new_volume-box_volume;
   return(new_volume);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void off_box(int i)
  {

   Print("SWITCHING OFF BOX ",box_comment[i]);
   GlobalVariableDel("REVERSALS_"+box_name[i]);
   GlobalVariableDel("BREAKEVEN_BUY_"+box_name[i]);
   GlobalVariableDel("BREAKEVEN_SELL_"+box_name[i]);
   box_active[i]=false;

   string new_name="box"+box_comment[i];
   if(box_buy[i])
      new_name="buy_"+new_name;
   if(box_sell[i])
      new_name="sell_"+new_name;
   if(box_only[i])
      new_name="only_"+new_name;
   if(box_trend[i])
      new_name="trend_"+new_name;
   if(box_timing[i])
      new_name="time_"+new_name;

   ObjectDelete(0,"STATUS_"+box_name[i]);
   ObjectSetString(0,box_name[i],OBJPROP_TEXT,"");
   ObjectSetString(0,box_name[i],OBJPROP_NAME,new_name);
   ObjectDelete(0,"TARGET_UPPER_"+box_comment[i]);
   ObjectDelete(0,"TARGET_LOWER_"+box_comment[i]);
   ObjectDelete(0,"BREAKEVEN_UPPER_"+box_comment[i]);
   ObjectDelete(0,"BREAKEVEN_LOWER_"+box_comment[i]);
   ChartRedraw(0);

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void off_line(int i)
  {
   Print("SWITCHING OFF LINE ",line_comment[i]);
   line_active[i]=false;
   string new_name="off"+line_comment[i];
   ObjectSetString(0,box_name[i],OBJPROP_NAME,new_name);
   ChartRedraw(0);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double get_volume(long magic)
  {

#ifdef __MQL5__

   double volume=0;
   int positions=PositionsTotal();
   for(int k=0; k<positions; k++)
     {
      ulong ticket=PositionGetTicket(k);
      if(!PositionSelectByTicket(ticket))
         continue;
      if(PositionGetInteger(POSITION_MAGIC)!=magic)
         continue;
      long type=PositionGetInteger(POSITION_TYPE);
      if(type==POSITION_TYPE_BUY)
         volume+=PositionGetDouble(POSITION_VOLUME);
      if(type==POSITION_TYPE_SELL)
         volume-=PositionGetDouble(POSITION_VOLUME);
     }
   return(volume);

#else

   double volume=0;
   int orders=OrdersTotal();
   for(int k=0; k<orders; k++)
     {
      bool select=OrderSelect(k,SELECT_BY_POS,MODE_TRADES);
      if(!select)
         continue;
      if(OrderMagicNumber()!=magic)
         continue;
      int order_type=OrderType();
      if(order_type==OP_BUY)
         volume+=OrderLots();
      if(order_type==OP_SELL)
         volume-=OrderLots();
     }
   return(volume);

#endif

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double get_profit(int magic)
  {

#ifdef __MQL5__

   double profit=0;
   int positions=PositionsTotal();
   for(int k=0; k<positions; k++)
     {
      ulong ticket=PositionGetTicket(k);
      if(!PositionSelectByTicket(ticket))
         continue;
      if(PositionGetInteger(POSITION_MAGIC)!=magic)
         continue;
      profit+=PositionGetDouble(POSITION_PROFIT);
      profit+=PositionGetDouble(POSITION_SWAP);
      profit+=PositionGetDouble(POSITION_COMMISSION);
     }
   return(profit);

#else

   double profit=0;
   int orders=OrdersTotal();
   for(int k=0; k<orders; k++)
     {
      bool select=OrderSelect(k,SELECT_BY_POS,MODE_TRADES);
      if(!select)
         continue;
      if(OrderMagicNumber()!=magic)
         continue;
      profit+=OrderProfit()+OrderSwap()+OrderCommission();
     }
   return(profit);

#endif

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool do_open(double volume,int magic,string comment)
  {

#ifdef __MQL5__

   bool check=false;
   for(int i=0; i<ORDER_ATTEMPTS; i++)
     {
      MqlTradeRequest request= {0};
      MqlTradeResult result= {0};
      if(volume>0)
        {
         request.type=ORDER_TYPE_BUY;
         request.price=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
         request.volume=NormalizeDouble(volume,LOT_DIGITS);
        }
      else
         if(volume<0)
           {
            request.type=ORDER_TYPE_SELL;
            request.price=SymbolInfoDouble(_Symbol,SYMBOL_BID);
            request.volume=NormalizeDouble(-volume,LOT_DIGITS);
           }
         else
            return(false);
      request.symbol=_Symbol;
      request.action=TRADE_ACTION_DEAL;
      request.type_filling=FILLING_TYPE;
      request.magic=magic;
      request.comment=comment;
      check=OrderSend(request,result);
      if(check)
         break;
      Print("TRADING ERROR CODE "+(string)result.retcode);
      Sleep(ORDER_PAUSE);
     }
   if(!check)
      Alert("OPENING FAILED FOR MAGIC "+string(magic));
   return(check);

#else

   int ticket=-1;
   bool check=false;
   for(int i=0; i<ORDER_ATTEMPTS; i++)
     {
      if(volume>0)
         ticket=OrderSend(_Symbol,OP_BUY,NormalizeDouble(volume,LOT_DIGITS),Ask,0,0,0,comment,magic,0,clrLime);
      else
         if(volume<0)
            ticket=OrderSend(_Symbol,OP_SELL,NormalizeDouble(-volume,LOT_DIGITS),Bid,0,0,0,comment,magic,0,clrRed);
      if(ticket!=-1)
        {
         check=true;
         break;
        }
      Print("TRADING ERROR CODE ",GetLastError());
      Sleep(ORDER_PAUSE);
      RefreshRates();
     }
   if(!check)
      Alert("OPENING FAILED FOR MAGIC "+string(magic));
   return(check);

#endif

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool do_close(ulong ticket,int magic,double volume)
  {

#ifdef __MQL5__

   bool check=false;
   for(int i=0; i<ORDER_ATTEMPTS; i++)
     {
      MqlTradeRequest request= {0};
      MqlTradeResult result= {0};
      if(!PositionSelectByTicket(ticket))
         continue;
      request.position=ticket;
      request.magic=magic;
      request.action=TRADE_ACTION_DEAL;
      request.type_filling=FILLING_TYPE;
      request.volume=(volume>0)?NormalizeDouble(volume,LOT_DIGITS):PositionGetDouble(POSITION_VOLUME);
      request.symbol=PositionGetString(POSITION_SYMBOL);
      if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
        {
         request.type=ORDER_TYPE_SELL;
         request.price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
        }
      else
        {
         request.type=ORDER_TYPE_BUY;
         request.price=SymbolInfoDouble(Symbol(),SYMBOL_ASK);
        }
      check=OrderSend(request,result);
      if(check)
         break;
      Print("TRADING ERROR CODE "+(string)result.retcode);
      Sleep(ORDER_PAUSE);
     }
   if(!check)
      Alert("CLOSING FAILED FOR MAGIC "+string(magic));
   return(check);

#else

   bool check=false;
   for(int i=0; i<ORDER_ATTEMPTS; i++)
     {
      double lots=volume>0?volume:OrderLots();
      if(OrderType()==OP_BUY)
         check=OrderClose((int)ticket,lots,Bid,0,clrMagenta);
      if(OrderType()==OP_SELL)
         check=OrderClose((int)ticket,lots,Ask,0,clrMagenta);
      if(check)
         break;
      Print("TRADING ERROR CODE ",GetLastError());
      Sleep(ORDER_PAUSE);
      RefreshRates();
     }
   if(!check)
      Alert("CLOSING FAILED FOR MAGIC "+string(magic));
   return(check);

#endif

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void close_all(int magic)
  {

#ifdef __MQL5__

   for(int k=PositionsTotal()-1; k>=0; k--)
     {
      ulong ticket=PositionGetTicket(k);
      if(!PositionSelectByTicket(ticket))
         continue;
      if(PositionGetInteger(POSITION_MAGIC)!=magic)
         continue;
      if(PositionGetString(POSITION_SYMBOL)!=Symbol())
         continue;
      do_close(ticket,magic,0);
     }

#else

   for(int k=OrdersTotal()-1; k>=0; k--)
     {
      bool select=OrderSelect(k,SELECT_BY_POS,MODE_TRADES);
      if(!select)
         continue;
      if(OrderMagicNumber()!=magic)
         continue;
      if(OrderSymbol()!=Symbol())
         continue;
      do_close(OrderTicket(),magic,0);
     }

#endif

  }

//+------------------------------------------------------------------+
