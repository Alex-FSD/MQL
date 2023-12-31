#property copyright "Copyright © 2021, Vladimir Hlystov"
#property link      "cmillion@narod.ru"
#property strict
#property description "1.советник отслеживает открытые позиции по всем или заданному инструменту. Складывает профит всех положительных позиций."
#property description "2 ищет самую убыточную позицию."
#property description "3 закрывает дальнюю и все положительные при достижении суммарного профита"
//-------------------------------------------------------------------
enum tt 
{
   tr2=0,    //по текущей валюте
   tr1=1,    //по всем символам
};
input double   CloseProfit  = 10;     //закрывать по суммарному профиту в валюте
input tt       Symbоl       = 1;     //суммируем профит
//-------------------------------------------------------------------
 int    Magic        = -1;     //все ордера (-1) или только с магиком
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
   double ProfitFar=0,OOP,Profit=0,ProfitPlus=0,Loss=0;
   int Ticket=0,tip;
   string Sym=NULL;
   for (int i=0; i<OrdersTotal(); i++)
   {    
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      { 
         if ((OrderSymbol()==Symbol() || Symbоl==1) && (Magic==OrderMagicNumber() || Magic==-1))
         { 
            tip = OrderType(); 
            OOP = NormalizeDouble(OrderOpenPrice(),Digits);
            Profit=OrderProfit()+OrderCommission()+OrderSwap();
            if (Profit>0) ProfitPlus+=Profit;
            else
            {
               if (Profit<=ProfitFar)             
               {  
                  ProfitFar=Profit; Ticket=OrderTicket(); Sym=OrderSymbol(); Loss=Profit;
               }                                         
            }
         }
      }
   }

   //---
   
   if (ProfitPlus+Loss>=CloseProfit && Loss<0) 
   {
      Alert("Перекрыт убыток ордера ",Ticket," (",StringConcatenate(DoubleToStr(ProfitPlus,2),DoubleToStr(Loss,2)),")");
      if (OrderSelect(Ticket, SELECT_BY_TICKET))
      {
         if (OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_BID),(int)MarketInfo(OrderSymbol(),MODE_DIGITS)),30,Blue))
         {
            CloseAll();
         }
      }
   }

   //---
   
   DrawLABEL("Loss"  ,1,5,0,Color(Loss>0,clrGray,clrRed),StringConcatenate("Убыточный ",Sym,"  " ,Ticket," | ",DoubleToStr(Loss,2),AC));
   DrawLABEL("Take"  ,1,5,0,Color(ProfitPlus>0,clrGreen,clrRed),StringConcatenate("Суммарный профит по ",Symbоl==1?"всем символам ":"текущей валюте ",DoubleToStr(ProfitPlus,2),AC));

   
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
   
   int Y=20;
   DrawLABEL("Loss" ,1,5,Y,clrGray,"Buy " );Y += font_size*2;
   DrawLABEL("Take" ,1,5,Y,clrGreen,"Profit ");Y += font_size*2;
   
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
            if ((OrderSymbol()==Symbol() || Symbоl==1) && (Magic==OrderMagicNumber() || Magic==-1))
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
            if ((OrderSymbol()==Symbol() || Symbоl==1) && (Magic==OrderMagicNumber() || Magic==-1))
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
         return(false);
      }
      Sleep(1000);
      RefreshRates();
   }
   return(true);
}
//--------------------------------------------------------------------



