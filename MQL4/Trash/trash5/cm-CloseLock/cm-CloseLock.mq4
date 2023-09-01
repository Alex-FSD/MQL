#property copyright "Copyright © 2015, Vladimir Hlystov"
#property link      "cmillion@narod.ru"
#property strict
//-------------------------------------------------------------------
input double CloseProfit  = 0;     //закрывать по суммарному профиту в валюте
input int    Magic        = 0;     //все ордера (-1) или только с магиком
input bool   Symbоl       = 0;     //все символы или только по текущей валюте
//-------------------------------------------------------------------
string AC;
int font_size=10;
color text_color=Aqua;
//-------------------------------------------------------------------
void OnTick()
{
   if (!IsTradeAllowed()) 
   {
      DrawLABEL("Торговля",0,0,0,Red,"Торговля запрещена");
      return;
   } 
   else DrawLABEL("Торговля",0,0,0,Lime,"Торговля разрешена");

   //---

   double MaxOrderBuy=0,MinOrderSell=0;
   double OOP,Profit=0,ProfitPlus=0,LossBuy=0,LossSell=0;
   int TicketB=0,TicketS=0,tip;
   string SymB=NULL,SymS=NULL;
   for (int i=0; i<OrdersTotal(); i++)
   {    
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      { 
         if ((OrderSymbol()==Symbol() || Symbоl) && (Magic==OrderMagicNumber() || Magic==-1))
         { 
            tip = OrderType(); 
            OOP = NormalizeDouble(OrderOpenPrice(),Digits);
            Profit=OrderProfit()+OrderCommission()+OrderSwap();
            if (Profit>0) ProfitPlus+=Profit;
            if (tip==OP_BUY)             
            {  
               if (MaxOrderBuy < OOP || MaxOrderBuy==0) {MaxOrderBuy = OOP; TicketB=OrderTicket(); SymB=OrderSymbol(); LossBuy=Profit;}
            }                                         
            if (tip==OP_SELL)        
            {
               if (MinOrderSell > OOP || MinOrderSell==0) {MinOrderSell = OOP; TicketS=OrderTicket(); SymS=OrderSymbol(); LossSell=Profit;}
            } 
         }
      }
   }

   //---
   
   if (ProfitPlus+LossBuy>=CloseProfit && LossBuy<0) 
   {
      if (OrderSelect(TicketB, SELECT_BY_TICKET))
      {
         if (OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_BID),(int)MarketInfo(OrderSymbol(),MODE_DIGITS)),30,Blue))
         {
            CloseAll();
            Alert("Перекрыт убыток ордера ",TicketB," ",StringConcatenate(DoubleToStr(ProfitPlus,2),"+",DoubleToStr(LossBuy,2)));
         }
      }
   }
   
   //---
   
   if (ProfitPlus+LossSell>=CloseProfit && LossSell<0) 
   {
      if (OrderSelect(TicketS, SELECT_BY_TICKET))
      {
         if (OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_ASK),(int)MarketInfo(OrderSymbol(),MODE_DIGITS)),30,Red))
         {
            CloseAll();
            Alert("Перекрыт убыток ордера ",TicketS," ",StringConcatenate(DoubleToStr(ProfitPlus,2),"+",DoubleToStr(LossSell,2)));
         }
      }
   }
   
   //---
   
   double AB = AccountBalance();
   
   //---
   
   DrawLABEL("Balance"        ,1,5,0,Aqua,StringConcatenate("Balance ",DoubleToStr(AB,2),AC));
   DrawLABEL("Equity"         ,1,5,0,Aqua,StringConcatenate("Equity ",DoubleToStr(AccountEquity(),2),AC));
   DrawLABEL("FreeMargin"     ,1,5,0,Aqua,StringConcatenate("FreeMargin ",DoubleToStr(AccountFreeMargin(),2),AC));
   DrawLABEL("Take"           ,1,5,0,Color(ProfitPlus>0,Lime,Red),StringConcatenate("Profit ",DoubleToStr(ProfitPlus,2),AC));

   DrawLABEL("Убыточный Buy"  ,1,5,0,Color(LossBuy>0,Lime,Red),StringConcatenate(SymB," Buy " ,TicketB," | ",DoubleToStr(LossBuy,2),AC));
   DrawLABEL("Убыточный Sell" ,1,5,0,Color(LossSell>0,Lime,Red),StringConcatenate(SymS," Sell ",TicketS," | ",DoubleToStr(LossSell,2),AC));
   
}
//------------------------------------------------------------------
void OnDeinit(const int reason)
{
   if (!IsTesting()) 
   {
      ObjectsDeleteAll(0);
   }
}
//-------------------------------------------------------------------
void DrawLABEL(string name, int CORNER, int X, int Y, color clr, string Name)
{
   if (ObjectFind(name)==-1)
   {
      ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
      ObjectSet(name, OBJPROP_CORNER, CORNER);
      ObjectSet(name, OBJPROP_XDISTANCE, X);
      ObjectSet(name, OBJPROP_YDISTANCE, Y);
   }
   ObjectSetText(name,Name,font_size,"Arial",clr);
}
//+------------------------------------------------------------------+
int OnInit()
{
   AC = StringConcatenate(" ", AccountCurrency());
   
   int Y=15;
   DrawLABEL("Торговля"  ,1,5,Y,Red,"Торговля ");Y += font_size*2;
   DrawLABEL("Balance"   ,1,5,Y,text_color,StringConcatenate("Balance ",DoubleToStr(AccountBalance(),2),AC));Y += font_size*2;
   DrawLABEL("Equity"    ,1,5,Y,text_color,StringConcatenate("Equity ",DoubleToStr(AccountEquity(),2),AC));Y += font_size*2;
   DrawLABEL("FreeMargin",1,5,Y,text_color,StringConcatenate("FreeMargin ",DoubleToStr(AccountFreeMargin(),2),AC));Y += font_size*3;

   DrawLABEL("Убыточный Sell" ,1,5,Y,text_color,"Buy " );Y += font_size*2;
   DrawLABEL("Убыточный Buy"  ,1,5,Y,text_color,"Sell ");Y += font_size*3;

   DrawLABEL("Take"           ,1,5,Y,Lime,"Profit ");Y += font_size*2;
   
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
void Text(color COLOR,double Price,string Name,int a)
{
   string name = StringConcatenate(TimeToStr(TimeCurrent(),TIME_SECONDS)," ",Name);
   ObjectDelete(name);
   ObjectCreate(name, OBJ_TEXT,0,Time[0],Price,0,0,0,0);
   ObjectSet(name, OBJPROP_ANGLE, a);
   ObjectSetText(name, Name,font_size, "Times New Roman", COLOR);
}
//+------------------------------------------------------------------+
color Color(bool P,color a,color b)
{
   if (P) return(a);
   else return(b);
}
//------------------------------------------------------------------
bool CloseAll()
{
   bool error=true;
   int err,nn=0,OT,j;
   double Profit;
   while(true)
   {
      for (j = OrdersTotal()-1; j >= 0; j--)
      {
         if (OrderSelect(j, SELECT_BY_POS))
         {
            if ((OrderSymbol()==Symbol() || Symbоl) && (Magic==OrderMagicNumber() || Magic==-1))
            {
               Profit=OrderProfit()+OrderCommission()+OrderSwap();
               if (Profit<0) continue;
               OT = OrderType();
               if (OT>1) error=OrderDelete(OrderTicket());
               if (OT==OP_BUY) 
               {
                  error=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_BID),(int)MarketInfo(OrderSymbol(),MODE_DIGITS)),30,Blue);
               }
               if (OT==OP_SELL) 
               {
                  error=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_ASK),(int)MarketInfo(OrderSymbol(),MODE_DIGITS)),30,Red);
               }
               if (!error) 
               {
                  err = GetLastError();
                  if (err<2) continue;
                  if (err==129) 
                  {
                     RefreshRates();
                     continue;
                  }
                  if (err==146) 
                  {
                     if (IsTradeContextBusy()) Sleep(2000);
                     continue;
                  }
                  Print("Ошибка ",err," закрытия ордера N ",OrderTicket(),"     ",TimeToStr(TimeCurrent(),TIME_SECONDS));
               }
            }
         }
      }
      int n=0;
      for (j = 0; j < OrdersTotal(); j++)
      {
         if (OrderSelect(j, SELECT_BY_POS))
         {
            if ((OrderSymbol()==Symbol() || Symbоl) && (Magic==OrderMagicNumber() || Magic==-1))
            {
               Profit=OrderProfit()+OrderCommission()+OrderSwap();
               if (Profit<0) continue;
               n++;
            }
         }  
      }
      if (n==0) break;
      nn++;
      if (nn>10) 
      {
         Alert(Symbol()," Не удалось закрыть все сделки, осталось еще ",n);
         return(0);
      }
      Sleep(1000);
      RefreshRates();
   }
   return(1);
}
//--------------------------------------------------------------------



