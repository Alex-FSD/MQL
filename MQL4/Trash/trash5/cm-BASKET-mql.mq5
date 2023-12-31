//+------------------------------------------------------------------+
//|                                            SMARTHEDGE basket.mq4 |
//|                                Copyright 2019, cmillion@narod.ru |
//|                                           http://www.cmillion.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, cmillion@narod.ru"
#property link      "http://www.cmillion.ru"
string ver = "BASKET 1.1";
#property version   "1.1"
#property strict
#property description "Советник управляющий счетом. Показывает какие пары инструментов сейчас торгуются на данном счете."
#property description "Показывает прибыль полученную по каждой паре за определенное время. Помогает переключаться между множества открытых окон"
#property description "Advisor managing individual. Shows which pairs of instruments are currently traded on this account."
#ifdef __MQL5__
MqlTick tick;
MqlTradeRequest request;
MqlTradeResult result;
MqlTradeCheckResult check;
ENUM_ORDER_TYPE_FILLING FillingMode=ORDER_FILLING_RETURN;
#endif   
//+------------------------------------------------------------------+
input color    colorfon    = clrIvory;
input double   WindSizeX   = 1.2;
input double   WindSizeY   = 1.0;
input color    colorGREEN  = clrLime;
input color    colorRED    = clrPink;
input bool     SendMailInfo= true;
input int      ReOpen      = false;
input double   AutoClose   = 0.0;

int orders=0,AN,Y=0,X=0,dY=0,dX=0,n=0;
bool LANGUAGE=false;
double tOrders[100][3];
double History[100][6];
string NameAccount,Symbl[100];
double ProfitAll[7];
//+------------------------------------------------------------------+
void OnTimer(){ OnTick();}
void OnTick()
{
   //-----------------------------------------------------------------------//
   //                                                                       //
   //                                                                       //
   //                        контроль позиций                              //
   //                                                                       //
   //                                                                       //
   //-----------------------------------------------------------------------//

   ArrayInitialize(tOrders,0);
   double Profit=0,ProfitALL=0;
   int OT=0,i,j;
   string Symb;

   #ifdef __MQL4__ //---------------------------- MT4 ---------------------------------------------------  
   for (i=OrdersTotal()-1; i>=0; i--)
   {                                               
      if (!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
      Symb = OrderSymbol();
      Profit=OrderProfit()+OrderSwap()+OrderCommission();
      if (OrderType()==OP_BUY) OT=1; else OT=-1;
   #endif
         
   #ifdef __MQL5__ //--------------------------- MT5 ---------------------------------------------------  
   for(i=PositionsTotal()-1; i>=0; i--)
   {
      Symb=PositionGetSymbol(i);
      Profit=PositionGetDouble(POSITION_PROFIT)+PositionGetDouble(POSITION_SWAP)+GetPositionCommission()*2;
      if (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY) OT=1; else OT=-1;
   #endif
         
   //-------------------------------------------------------------------
   
      ProfitALL+=Profit;
      j=Insrt(Symb);
      if (n<j) n=j;
      tOrders[j][0]+=Profit;// [0] профит по всему инструменту
      if (OT>0) tOrders[j][1]++;// [1] число buy 
      if (OT<0) tOrders[j][2]++;// [1] число sell 
   }
   
   //Comment(n," ",ProfitALL);
   //EditCreate(0,"cm _1",0,0,0,50,20,IntegerToString(n),"Arial",8,ALIGN_CENTER,true,CORNER_LEFT_UPPER,clrWhite,clrBlue);
   //EditCreate(0,"cm _4",0,55,0,70,20,DoubleToString(ProfitALL,2),"Arial",8,ALIGN_CENTER,true,CORNER_LEFT_UPPER,clrWhite,clrBlue);
   //----------------------------------------------------------------------------------//
   //                                                                                  //
   //                           Закрытие по суммарному профиту                         //
   //                                                                                  //
   //----------------------------------------------------------------------------------//

   if (AutoClose!=0 && ProfitALL!=0 && ProfitALL>=AutoClose)
   {
      if (SendMailInfo) SendMail(IntegerToString(AN)," basket close all");
      CloseAll();   
   }
   
   //----------------------------------------------------------------------------------//
   //                                                                                  //
   //                   выводим таблицу профитов по инструментам                       //
   //                                                                                  //
   //----------------------------------------------------------------------------------//
   
   string name,SN;
   Y=25;
   int DY=19;
   for(j=0;j<=n;j++)//всего инструментов с открытыми позициями
   {
      SN=IntegerToString(j);
      name=StrCon("cm Insrt",SN);X=0;
      EditCreate(0,name,0,X,Y+DY*j,100,20,Symbl[j],"Arial",8,ALIGN_CENTER,true,CORNER_LEFT_UPPER,clrBlack,clrWhite);//имя инструмента
      name=StrCon(name,"Profit");X+=105;
      EditCreate(0,name,0,X,Y+DY*j,70,20,DoubleToString(tOrders[j][0],2),"Arial",8,ALIGN_CENTER,true,CORNER_LEFT_UPPER,clrBlack,//профит по инструменту
      tOrders[j][0]>0?colorGREEN:tOrders[j][0]<0?colorRED:clrWhite);

      name=StrCon("cm OrdersB ",SN);X+=75;
      EditCreate(0,name,0,X,Y+DY*j,30,20,DoubleToString(tOrders[j][1],0),"Arial",8,ALIGN_CENTER,true,CORNER_LEFT_UPPER,clrBlack,clrWhite);

      name=StrCon("cm OrdersS ",SN);X+=29;
      EditCreate(0,name,0,X,Y+DY*j,30,20,DoubleToString(tOrders[j][2],0),"Arial",8,ALIGN_CENTER,true,CORNER_LEFT_UPPER,clrBlack,clrWhite);

      for(i=0;i<6;i++)//суммы профитов по дням неделям мес
      {
         EditCreate(0,StrCon("cm HP"+IntegerToString(i)+IntegerToString(j)),0,X+35+75*i,Y+DY*j,70,20,DoubleToString(History[j][i],2),"Arial",8,ALIGN_CENTER,true,CORNER_LEFT_UPPER,clrBlack,
                                                                                                    History[j][i]>0?colorGREEN:History[j][i]<0?colorRED:clrWhite);
      }

      /*name=name," History ";
      EditCreate(0,name,0,X+130,Y+DY*j,70,20,DoubleToString(History[j][0],2),"Arial",8,ALIGN_CENTER,true,CORNER_LEFT_UPPER,clrBlack,//история сегодня
      History[j][0]>0?colorGREEN:History[j][0]<0?colorRED:clrWhite);
      name=StrCon(name," 2");
      EditCreate(0,name,0,X+205,Y+DY*j,70,20,DoubleToString(History[j][1],2),"Arial",8,ALIGN_CENTER,true,CORNER_LEFT_UPPER,clrBlack,//история по вчера
      History[j][1]>0?colorGREEN:History[j][1]<0?colorRED:clrWhite);
      name=StrCon(name," 3");
      EditCreate(0,name,0,X+280,Y+DY*j,70,20,DoubleToString(History[j][2],2),"Arial",8,ALIGN_CENTER,true,CORNER_LEFT_UPPER,clrBlack,//история по инструменту
      History[j][2]>0?colorGREEN:History[j][2]<0?colorRED:clrWhite);
      name=StrCon(name," 4");
      EditCreate(0,name,0,X+355,Y+DY*j,70,20,DoubleToString(History[j][3],2),"Arial",8,ALIGN_CENTER,true,CORNER_LEFT_UPPER,clrBlack,//история по инструменту
      History[j][3]>0?colorGREEN:History[j][3]<0?colorRED:clrWhite);
      name=StrCon(name," 5");
      EditCreate(0,name,0,X+430,Y+DY*j,70,20,DoubleToString(History[j][4],2),"Arial",8,ALIGN_CENTER,true,CORNER_LEFT_UPPER,clrBlack,//история по инструменту
      History[j][4]>0?colorGREEN:History[j][4]<0?colorRED:clrWhite);
      name=StrCon(name," 6");
      EditCreate(0,name,0,X+505,Y+DY*j,70,20,DoubleToString(History[j][5],2),"Arial",8,ALIGN_CENTER,true,CORNER_LEFT_UPPER,clrBlack,//история по инструменту
      History[j][5]>0?colorGREEN:History[j][5]<0?colorRED:clrWhite);*/
   }

   //----------------------------------------------------------------------------------//
   //                                                                                  //
   //                             Нижняя шапка ИТОГО                                   //
   //                                                                                  //
   //----------------------------------------------------------------------------------//
   X=0;
   EditCreate(0,"cm ALL",0,X,Y+5+DY*j,100,20,"© https://cmillion.ru","Arial",8,ALIGN_CENTER,false,CORNER_LEFT_UPPER,clrGray,clrWhite);X+=105;
   EditCreate(0,"cm ProfitALL",0,X,Y+5+DY*j,70,20,DoubleToString(ProfitALL,2),"Arial",8,ALIGN_CENTER,true,CORNER_LEFT_UPPER,clrBlack,ProfitALL>0?colorGREEN:ProfitALL<0?colorRED:clrWhite);
   //EditCreate(0,"cm HistoryALL",0,X+130,Y+5+DY*j,70,20,DoubleToString(HistoryALL,2),"Arial",8,ALIGN_CENTER,true,CORNER_LEFT_UPPER,clrWhite,clrBlue);

   X+=104;
   for(i=0;i<6;i++)//суммы профитов по дням неделям мес
   {
      EditCreate(0,"cm ProfitAll"+IntegerToString(i),0,X+35+75*i,Y+5+DY*j,70,20,DoubleToString(ProfitAll[i],2),"Arial",8,ALIGN_CENTER,true,CORNER_LEFT_UPPER,clrBlack,ProfitAll[i]>0?colorGREEN:ProfitAll[i]<0?colorRED:clrWhite);
   }
   if (orders!=OrdersTotal()) History();
   orders=OrdersTotal();
}
//+------------------------------------------------------------------+
int Insrt(string Sym)
{
   int j=0;
   for(j=0;j<100;j++)
   {
      if (Sym==Symbl[j] || Symbl[j]==NULL) break;
   }
   if (j>99) j=99;
   Symbl[j]=Sym;
   return(j);
}
//+------------------------------------------------------------------+
bool EditCreate(const long             chart_ID=0,               // ID графика 
                const string           name="Edit",              // имя объекта 
                const int              sub_window=0,             // номер подокна 
                const int              x=0,                      // координата по оси X 
                const int              y=0,                      // координата по оси Y 
                const int              width=50,                 // ширина 
                const int              height=18,                // высота 
                const string           text="Text",              // текст 
                const string           font="Arial",             // шрифт 
                const int              font_size=8,             // размер шрифта 
                const ENUM_ALIGN_MODE  align=ALIGN_RIGHT,       // способ выравнивания 
                const bool             read_only=true,           // возможность редактировать 
                const ENUM_BASE_CORNER corner=CORNER_RIGHT_LOWER, // угол графика для привязки 
                const color            clr=clrBlack,             // цвет текста 
                const color            back_clr=clrWhite,        // цвет фона 
                const color            border_clr=clrNONE,       // цвет границы 
                const bool             back=false,               // на заднем плане 
                const bool             selection=false,          // выделить для перемещений 
                const bool             hidden=true,              // скрыт в списке объектов 
                const long             z_order=0)                // приоритет на нажатие мышью 
  { 
   ResetLastError(); 
   if (ObjectFind(chart_ID,name)!=-1) ObjectDelete(chart_ID,name);
   if(!ObjectCreate(chart_ID,name,OBJ_EDIT,sub_window,0,0)) 
     { 
      Print(__FUNCTION__, 
            ": не удалось создать объект ",name,"! Код ошибки = ",GetLastError()); 
      return(false); 
     } 
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,(int)(dX+x*WindSizeX)); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,(int)(dY+y*WindSizeY)); 
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,(int)(width*WindSizeX)); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,(int)(height*WindSizeY)); 
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text); 
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font); 
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size); 
   ObjectSetInteger(chart_ID,name,OBJPROP_ALIGN,align); 
   ObjectSetInteger(chart_ID,name,OBJPROP_READONLY,read_only); 
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner); 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr); 
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr); 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
bool ButtonCreate(const long              chart_ID=0,               // ID графика
                  const string            name="Button",            // имя кнопки
                  const int               sub_window=0,             // номер подокна
                  const long               x=0,                      // координата по оси X
                  const long               y=0,                      // координата по оси Y
                  const int               width=50,                 // ширина кнопки
                  const int               height=18,                // высота кнопки
                  const string            text="Button",            // текст
                  const string            font="Arial",             // шрифт
                  const int               font_size=10,             // размер шрифта
                  const color             clr=clrRed,               // цвет текста
                  const color             clrfon=clrBlack,          // цвет фона
                  const color             border_clr=clrNONE,       // цвет границы
                  const bool              state=false,
                  const ENUM_BASE_CORNER  CORNER=CORNER_RIGHT_LOWER)
  {
   if (ObjectFind(chart_ID,name)==-1)
   {
      ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0);
      ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,(int)(height*WindSizeY));
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,CORNER);
      ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
      ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,0);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,0);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,0);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,1);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,1);
   }
      ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state);
      ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,(int)(width*WindSizeX));
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,clrfon);
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,(int)(dX+x*WindSizeX));
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,(int)(dY+y*WindSizeY));
   return(true);
}
//----------------------
bool RectLabelCreate(const long             chart_ID=0,               // ID графика
                     const string           name="RectLabel",         // имя метки
                     const int              sub_window=0,             // номер подокна
                     const long              x=0,                     // координата по оси X
                     const long              y=0,                     // координата по оси y
                     const int              width=50,                 // ширина
                     const int              height=18,                // высота
                     const color            back_clr=clrNONE,         // цвет фона
                     const color            clr=clrNONE,              // цвет плоской границы (Flat)
                     const ENUM_LINE_STYLE  style=STYLE_SOLID,        // стиль плоской границы
                     const int              line_width=1,             // толщина плоской границы
                     const bool             back=false,               // на заднем плане
                     const bool             selection=false,          // выделить для перемещений
                     const bool             hidden=true,              // скрыт в списке объектов
                     const long             z_order=0,
                     const int              CORNER=CORNER_LEFT_LOWER)                // приоритет на нажатие мышью
  {
   ResetLastError();
   if (ObjectFind(chart_ID,name)==-1)
   {
      ObjectCreate(chart_ID,name,OBJ_RECTANGLE_LABEL,sub_window,0,0);
   }
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_TYPE,BORDER_FLAT);
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,CORNER);
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,line_width);
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,(int)(width*WindSizeX));
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,(int)(height*WindSizeY));
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,(int)(dX+x*WindSizeX));
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,(int)(dY+y*WindSizeY));
   return(true);
}
//--------------------------------------------------------------------
bool LabelCreate(const long              chart_ID=0,               // ID графика 
                 const string            name="Label",             // имя метки 
                 const int               sub_window=0,             // номер подокна 
                 const int               x=0,                      // координата по оси X 
                 const int               y=0,                      // координата по оси Y 
                 const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // угол графика для привязки 
                 const string            text="Label",             // текст 
                 const string            font="Arial",             // шрифт 
                 const int               font_size=10,             // размер шрифта 
                 const color             clr=clrBlack,             // цвет 
                 const double            angle=0.0,                // наклон текста 
                 const ENUM_ANCHOR_POINT anchor=ANCHOR_RIGHT_UPPER,// способ привязки 
                 const bool              back=false,               // на заднем плане 
                 const bool              selection=false,          // выделить для перемещений 
                 const bool              hidden=true,              // скрыт в списке объектов 
                 const long              z_order=0)                // приоритет на нажатие мышью 
  { 
   ResetLastError(); 
   if(ObjectFind(chart_ID,name)==-1) 
   { 
      if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0)) 
      { 
         return(false); 
      } 
   } 
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,(int)(dX+x*WindSizeX)); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,(int)(dY+y*WindSizeY)); 
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner); 
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text); 
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font); 
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size); 
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle); 
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor); 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
void OnDeinit(const int reason)
{
   ObjectsDeleteAll(0);
   EventKillTimer();
   /*if (reason!=REASON_RECOMPILE && reason!=REASON_CHARTCHANGE) 
   { 
      ObjectsDeleteAll(0,"kn");
      ObjectsDeleteAll(0,"cm");
   }*/
}
//-------------------------------------------------------------------
bool Liz()
{
   if(AccountInfoInteger(ACCOUNT_TRADE_MODE)!=ACCOUNT_TRADE_MODE_REAL) return(true);

   if (AN==0) return(true);
   if (StringFind(NameAccount,"Хлыстов Владимир Степанович")!=-1) return(true);
   if (StringFind(NameAccount,"Владимир Степанович Хлыстов")!=-1) return(true);
   
   return(false);
}
//+------------------------------------------------------------------+ 
void History()
{
   double Profit=0;
   datetime OCT;
   ulong Ticket;
   int i,j;
   string Symb;
   ArrayInitialize(ProfitAll,0);
   ArrayInitialize(History,0);
   #ifdef __MQL4__ //---------------------------- MT4 ---------------------------------------------------  
   for (i=OrdersHistoryTotal()-1; i>=0; i--)
   {                                               
      if (!OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)) continue;
      if (OrderType()!=OP_BUY && OrderType()!=OP_SELL) continue;
      Symb  = OrderSymbol();
      Profit=OrderProfit()+OrderSwap()+OrderCommission();
      OOT = OrderOpenTime();
      OCT = OrderCloseTime();
      Profit = OrderProfit()+OrderSwap()+OrderCommission();
    #endif
         
  #ifdef __MQL5__ //--------------------------- MT5 ---------------------------------------------------  
   ulong order_ticket;           // тикет ордера,по которому была совершена сделка 
   long deal_type ;              // тип торговой операции 
   long position_ID;             // идентификатор позиции 
   datetime from_date=0;          // с самого начала 
   datetime to_date=TimeCurrent();// по текущий момент 
   HistorySelect(from_date,to_date); 
   int deals=HistoryDealsTotal(); 
   for(i=0;i<deals;i++) 
   { 
      Ticket=                    HistoryDealGetTicket(i); 
      order_ticket=              HistoryDealGetInteger(Ticket,DEAL_ORDER); 
      deal_type=                 HistoryDealGetInteger(Ticket,DEAL_TYPE); 
      Symb=                      HistoryDealGetString(Ticket,DEAL_SYMBOL); 
      position_ID=               HistoryDealGetInteger(Ticket,DEAL_POSITION_ID); 
      if(deal_type!=DEAL_TYPE_BUY && deal_type!=DEAL_TYPE_SELL) continue;
      Profit=HistoryDealGetDouble(Ticket,DEAL_PROFIT)+HistoryDealGetDouble(Ticket,DEAL_COMMISSION)+HistoryDealGetDouble(Ticket,DEAL_SWAP); 
      OCT=(datetime)HistoryDealGetInteger(Ticket,DEAL_TIME);
   #endif


      if (OCT==0) continue;
      if(Profit==0) continue;
      
      j=Insrt(Symb);
      if (n<j) n=j;
      
      if (OCT>=iTime(NULL,PERIOD_D1,0))         {History[j][0]+=Profit;ProfitAll[0]+=Profit;}//сегодня
      else
      {
         if (OCT>=iTime(NULL,PERIOD_D1,1))      {History[j][1]+=Profit;ProfitAll[1]+=Profit;}//вчера
         else
         {
            if (OCT>=iTime(NULL,PERIOD_D1,2))   {History[j][2]+=Profit;ProfitAll[2]+=Profit;}//позавчера
         }
      }
      if (OCT>=iTime(NULL,PERIOD_W1,0))         {History[j][3]+=Profit;ProfitAll[3]+=Profit;}//неделя
      if (OCT>=iTime(NULL,PERIOD_MN1,0))        {History[j][4]+=Profit;ProfitAll[4]+=Profit;}//месяц
                                                 History[j][5]+=Profit;ProfitAll[5]+=Profit; // [1] накопленный профит по всему инструменту
      
   }
}
//+------------------------------------------------------------------+
#ifdef __MQL5__   
double GetPositionCommission(void)
  {
   double Commission=::PositionGetDouble(POSITION_COMMISSION);
// На случай, если POSITION_COMMISSION не работает
   if(Commission==0)
     {
      ulong Ticket=GetPositionDealIn();

      if(Ticket>0)
        {
         const double LotsIn=::HistoryDealGetDouble(Ticket,DEAL_VOLUME);
         if(LotsIn>0)
            Commission=::HistoryDealGetDouble(Ticket,DEAL_COMMISSION)*::PositionGetDouble(POSITION_VOLUME)/LotsIn;
        }
     }
   return(Commission);
  }
//--------------------------------------------------------------------
ulong GetPositionDealIn(const ulong HistoryTicket=0)
  {
   ulong Ticket=0;

   if((HistoryTicket==0) ? ::HistorySelectByPosition(::PositionGetInteger(POSITION_TICKET)) : ::HistorySelectByPosition(HistoryTicket))
     {
      const int Total=::HistoryDealsTotal();

      for(int i=0; i<Total; i++)
        {
         const ulong TicketDeal=::HistoryDealGetTicket(i);

         if(TicketDeal>0)
            if((ENUM_DEAL_ENTRY)::HistoryDealGetInteger(TicketDeal,DEAL_ENTRY)==DEAL_ENTRY_IN)
              {
               Ticket=TicketDeal;
               break;
              }
        }
     }
   return(Ticket);
  }
//+------------------------------------------------------------------+
#endif
string StrCon(string t1=NULL,string t2=NULL,string t3=NULL,string t4=NULL,string t5=NULL,string t6=NULL,string t7=NULL,string t8=NULL,string t9=NULL,string t10=NULL,string t11=NULL)
{
   string str;
   #ifdef __MQL4__ str=StringConcatenate(#endif  
   #ifdef __MQL5__ StringConcatenate(str,#endif t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11);
   return(str);
}
//+------------------------------------------------------------------+ 
string AC;
int OnInit()
{
   AN=(int)AccountInfoInteger(ACCOUNT_LOGIN);
   NameAccount=AccountInfoString(ACCOUNT_NAME);
   AC = " "+AccountInfoString(ACCOUNT_CURRENCY);
   History();
   EventSetTimer(1);
   LANGUAGE=TerminalInfoString(TERMINAL_LANGUAGE)=="Russian";
   ChartSetInteger(0,CHART_COLOR_FOREGROUND,colorfon);//Цвет осей, шкалы и строки OHLC
   
   ChartSetInteger(0,CHART_COLOR_BACKGROUND,colorfon);
   ChartSetInteger(0,CHART_FOREGROUND,false);//Ценовой график на переднем плане
   ChartSetInteger(0,CHART_SHOW_GRID,false);
   
   ChartSetInteger(0,CHART_BRING_TO_TOP,true);
   ChartSetInteger(0,CHART_SHOW_ASK_LINE,false);
   ChartSetInteger(0,CHART_SHOW_BID_LINE,false);
   
   ChartSetInteger(0,CHART_SHOW_OHLC,false);//Отображение в левом верхнем углу значений OHLC
   ChartSetInteger(0,CHART_SHOW_LAST_LINE,false);
   ChartSetInteger(0,CHART_SHOW_GRID,false);
   ChartSetInteger(0,CHART_SHOW_VOLUMES,false);
   ChartSetInteger(0,CHART_SHOW_OBJECT_DESCR,false);
   ChartSetInteger(0,CHART_CONTEXT_MENU,false);//Включение/отключение доступа к контекстному меню по нажатию правой клавиши мышки. 
   ChartSetInteger(0,CHART_CROSSHAIR_TOOL,false);//перекрести
   ChartSetInteger(0,CHART_MOUSE_SCROLL,false);//Прокрутка графика левой кнопкой мышки по горизонтали.
   ChartSetInteger(0,CHART_SHOW_ONE_CLICK,false);

#ifdef __MQL5__
   ChartSetInteger(0,CHART_SHOW,false);//Признак отрисовки ценового графика
   FillingMode=ORDER_FILLING_RETURN;// Данный режим используется для рыночных
   int FILLING_MODE=(int)SymbolInfoInteger(_Symbol, SYMBOL_FILLING_MODE);
   if ((SYMBOL_FILLING_IOC & FILLING_MODE)==SYMBOL_FILLING_IOC) FillingMode=ORDER_FILLING_IOC;// Все или частично
   if ((SYMBOL_FILLING_FOK & FILLING_MODE)==SYMBOL_FILLING_FOK) FillingMode=ORDER_FILLING_FOK;//может быть исполнен исключительно в указанном объеме
#endif   
   ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,colorfon);
   ChartSetInteger(0,CHART_COLOR_CHART_DOWN,colorfon);
   ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,colorfon);
   ChartSetInteger(0,CHART_COLOR_CHART_UP,colorfon);
   ChartSetInteger(0,CHART_COLOR_CHART_LINE,colorfon);
   ChartSetInteger(0,CHART_COLOR_STOP_LEVEL,colorfon);
   ChartSetInteger(0,CHART_COLOR_LAST,colorfon);
   ChartSetInteger(0,CHART_SHOW_TRADE_LEVELS,colorfon);
   ChartSetInteger(0,CHART_DRAG_TRADE_LEVELS,false);
   ChartSetInteger(0,CHART_SHOW_DATE_SCALE,false);
   ChartSetInteger(0,CHART_SHOW_PRICE_SCALE,false);
   ChartSetInteger(0,CHART_COLOR_VOLUME,colorfon);

   ChartSetInteger(0,CHART_HEIGHT_IN_PIXELS,100);
   X=0;Y=0;
   EditCreate(0,"cm _1",0,X,Y,100,20,ver,"ARIAL BLACK",8,ALIGN_CENTER,true,CORNER_LEFT_UPPER,clrWhite,clrBlue);
   X+=105;
   EditCreate(0,"cm _2",0,X,Y,70,20,"Profit","Arial",8,ALIGN_CENTER,true,CORNER_LEFT_UPPER,clrWhite,clrBlue);X+=75;
   EditCreate(0,"cm _b",0,X,Y,30,20,"buy","Arial",8,ALIGN_CENTER,true,CORNER_LEFT_UPPER,clrWhite,clrBlue);X+=29;
   EditCreate(0,"cm _s",0,X,Y,30,20,"sell","Arial",8,ALIGN_CENTER,true,CORNER_LEFT_UPPER,clrWhite,clrBlue);X+=35;
   EditCreate(0,"cm _3",0,X,Y,70,20,"Сегодня","Arial",8,ALIGN_CENTER,true,CORNER_LEFT_UPPER,clrWhite,clrBlue);X+=75;
   EditCreate(0,"cm _4",0,X,Y,70,20,TimeToString(iTime(NULL,PERIOD_D1,1),TIME_DATE),"Arial",8,ALIGN_CENTER,true,CORNER_LEFT_UPPER,clrWhite,clrBlue);X+=75;
   EditCreate(0,"cm _5",0,X,Y,70,20,TimeToString(iTime(NULL,PERIOD_D1,2),TIME_DATE),"Arial",8,ALIGN_CENTER,true,CORNER_LEFT_UPPER,clrWhite,clrBlue);X+=75;
   EditCreate(0,"cm _6",0,X,Y,70,20,"Неделя","Arial",8,ALIGN_CENTER,true,CORNER_LEFT_UPPER,clrWhite,clrBlue);X+=75;
   EditCreate(0,"cm _7",0,X,Y,70,20,"Месяц","Arial",8,ALIGN_CENTER,true,CORNER_LEFT_UPPER,clrWhite,clrBlue);X+=75;
   EditCreate(0,"cm _8",0,X,Y,70,20,"Всего","Arial",8,ALIGN_CENTER,true,CORNER_LEFT_UPPER,clrWhite,clrBlue);
   ChartSetInteger(0,CHART_BRING_TO_TOP,true);

   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
int Slippage = 1000;
#ifdef __MQL4__
bool CloseAll(string Symbol1="ALL")
{
   bool error=true;
   int j,err,nn=0,OT;
   string Symb;
   double Profit=0,OOP;
   while(!IsStopped())
   {
      for (j = OrdersTotal()-1; j >= 0; j--)
      {
         if (OrderSelect(j, SELECT_BY_POS))
         {
            Symb = OrderSymbol();
            if (Symb == Symbol1 || Symbol1=="ALL")
            {
               OT = OrderType();
               OOP=OrderOpenPrice();
               Profit=OrderProfit()+OrderSwap()+OrderCommission();
               if (OT>1) 
               {
                  error=OrderDelete(OrderTicket());
               }
               if (OT==OP_BUY) 
               {
                  error=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(MarketInfo(Symb,MODE_BID),(int)MarketInfo(Symb,MODE_DIGITS)),Slippage,Blue);
               }
               if (OT==OP_SELL) 
               {
                  error=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(MarketInfo(Symb,MODE_ASK),(int)MarketInfo(Symb,MODE_DIGITS)),Slippage,Red);
               }
               if (!error) 
               {
                  err = GetLastError();
                  if (err<2) continue;
                  if (err==129) 
                  {
                     Sleep(5000);
                     RefreshRates();
                     continue;
                  }
                  if (err==146) 
                  {
                     if (IsTradeContextBusy()) Sleep(2000);
                     continue;
                  }
               }
            }
         }
      }
      int k=0;
      for (j = 0; j < OrdersTotal(); j++)
      {
         if (OrderSelect(j, SELECT_BY_POS))
         {
            Symb = OrderSymbol();
            if (Symb == Symbol1 || Symbol1=="ALL")
            {
               k++;
            }
         }  
      }
      if (k==0) break;
      nn++;
      if (nn>10) {/*ALERT(StringConcatenate(Symb,LANGUAGE?"  Не удалось закрыть все сделки, осталось еще ":"Failed to close all transactions, there is still ",k));*/return(false);}
      Sleep(1000);
      RefreshRates();
   }
   ObjectsDeleteAll(0,"cm");
   OnInit();
   return(true);
}
#endif 
//--------------------------------------------------------------------
#ifdef __MQL5__
bool CloseAll(string Symbol1="ALL")
{
   bool error=true;
   int i,err,nn=0;
   long OT;
   string Symb;
   int k=0;
   double Profit=0;
   while(!IsStopped())
   {
      k=0;
      for (i = PositionsTotal()-1; i >= 0; i--)
      {
         Symb=PositionGetSymbol(i);
         if (Symb != Symbol1 && Symbol1!="ALL") continue;
         Profit=PositionGetDouble(POSITION_PROFIT)+PositionGetDouble(POSITION_SWAP)+GetPositionCommission()*2;
         
         OT = PositionGetInteger(POSITION_TYPE);

         ZeroMemory(request);
         ZeroMemory(result);
         request.deviation = Slippage;
         request.volume=PositionGetDouble(POSITION_VOLUME);
         request.position  = PositionGetInteger(POSITION_TICKET);
         request.action=TRADE_ACTION_DEAL;
         request.comment="";
         request.type_filling = FillingMode;
         request.symbol = Symb;
         request.magic  = PositionGetInteger(POSITION_MAGIC);


         k++;
         
         if (OT==POSITION_TYPE_BUY) 
         {
            request.price=SymbolInfoDouble(Symb,SYMBOL_BID);
            request.type=ORDER_TYPE_SELL;
         }
         if (OT==POSITION_TYPE_SELL) 
         {
            request.price=SymbolInfoDouble(Symb,SYMBOL_ASK);
            request.type=ORDER_TYPE_BUY;
         }
         if(!OrderSend(request,result))
         {
            err = GetLastError();
            if (err<2) continue;
            Print("Ошибка ",err," закрытия ордера N ",request.position,"     ",TimeToString(TimeCurrent(),TIME_SECONDS));
         }
      }
      if (k==0) break;
      nn++;
      if (nn>10) return(false);
      Sleep(1000);
   }
   return(true);
}
#endif 
//--------------------------------------------------------------------
void OnChartEvent(const int id, 
                  const long &lparam, 
                  const double &dparam, 
                  const string &name) 
{ 
   int i,j,ret=IDYES;
   long ch,prevChart=0; 
   if(id==CHARTEVENT_OBJECT_CLICK) 
   { 
      string txt,Symb=NULL;
      if (StringFind(name,"cm Insrt")!=-1)
      {
         i=StringFind(name,"Profit");
         if (i==-1)//нажата кнопка имени валютной пары
         {
            Symb=ObjectGetString(0,name,OBJPROP_TEXT);
            i=-1;
            while(i<100)// у нас наверняка не больше 100 открытых графиков 
            { 
               ch=ChartNext(prevChart);
               if (ch==ChartID()) {prevChart=ch;continue;}//текущий график пропустим
               if(ch<0) break;          // достигли конца списка графиков 
               prevChart=ch;// запомним идентификатор текущего графика для ChartNext() 
               if (ChartSymbol(ch)==Symb) 
               {
                  ChartSetInteger(ch,CHART_BRING_TO_TOP,true);
                  if (ChartGetInteger(0,CHART_WIDTH_IN_PIXELS)<ChartGetInteger(ch,CHART_WIDTH_IN_PIXELS)) ChartSetInteger(0 ,CHART_BRING_TO_TOP,true);
                  
                  break;
               }
               i++;
            }
         }
         else
         {
            txt=StringSubstr(name,8,i-8);
            j=(int)StringToInteger(txt);
            Symb=Symbl[j];
            txt=ObjectGetString(0,name,OBJPROP_TEXT);
            if (Symb!=NULL)
            {
               txt=StrCon(LANGUAGE?"закрыть все позиции ":"close all pozichions ",Symb," ",txt,AC);
               ret=MessageBox(StrCon(LANGUAGE?"Вы действительно хотите закрыть ":"Are you sure you want to close ",Symb," ?"),txt,MB_YESNO|MB_TOPMOST);
               if (ret==IDYES)
               {
                  CloseAll(Symb);
               }
            }
         }
      }
      if (name=="cm ProfitALL")
      {
         txt=StrCon(LANGUAGE?"закрыть все позиции по счету":"close all pozichions ",DoubleToString(AccountInfoDouble(ACCOUNT_PROFIT),2),AC);
         ret=MessageBox((LANGUAGE?"Вы действительно хотите все закрыть?":"Are you sure you want to close everything?"),txt,MB_YESNO|MB_TOPMOST);
         if (ret==IDYES)
         {
            CloseAll();
         }
      }
   }     
} 
//-------------------------------------------------------------------//      
