//+------------------------------------------------------------------+
//|                                                     NL Mause.mq4 |
//|                                                 Copyright © 2013 |
//|                                         http://cmillion.narod.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2013"
#property link      "http://cmillion.narod.ru"
double SumLot,Profit;
int n;
int start()
  {
   int Ticket;
   double OSL,OOP,NL=NLchek(),SL;
   string txt,txt1,txt2;
   string AC=" "+AccountCurrency();
   if (NL==0) return(0);
   
   DrawHLINE("NL", NL);
   
   while (ObjectFind("NL")!=-1)
   {
      double StopLevel = MarketInfo(Symbol(),MODE_STOPLEVEL)*Point;
      SL=ObjectGet("NL",OBJPROP_PRICE1);
      NL=NLchek();
      int p = (SL-NL)/Point;
      if (p>=0) txt1=StringConcatenate("Прибыль ордеров BUY = ",p," п ",DoubleToStr(p*SumLot*MarketInfo(Symbol(),MODE_TICKVALUE),2),AC);
      else txt1=StringConcatenate("Убыток ордеров BUY = ",p," п ",DoubleToStr(p*SumLot*MarketInfo(Symbol(),MODE_TICKVALUE),2),AC);
      drawtext("NLt", SL, txt1, Color(NL<SL,Lime,Red));
      if(NormalizeDouble(Bid-SL,Digits)<StopLevel && NormalizeDouble(SL-Ask,Digits)<StopLevel) {SL=0;ObjectSet("NL", OBJPROP_COLOR, Red);}
      Comment("Скрипт_NL ALL BUY Mous\n","\nОрдеров = ",n,"\nТекущий профит ",Profit,AC,"\n\nУдалите линию для того чтобы установить стопы на ее месте");
      Sleep(100);
      RefreshRates();
   }
   if (SL==0) return(0);
   if(NormalizeDouble(SL-Ask,Digits)>StopLevel) txt2=StringConcatenate("TP = ",DoubleToStr(SL,Digits));   
   if(NormalizeDouble(Bid-SL,Digits)>StopLevel) txt2=StringConcatenate("SL = ",DoubleToStr(SL,Digits)); 
   
   int ret=MessageBox(StringConcatenate("Установить ",txt2," всем ордерам BUY ?"),"", MB_YESNO|MB_TOPMOST);
   if (ret==IDYES)
   {
      RefreshRates();
      for(int i=OrdersTotal()-1;i>=0;i--)
      {
         if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
         if(OrderSymbol()!=Symbol()) continue;
         OOP=NormalizeDouble(OrderOpenPrice(),Digits);
         OSL=NormalizeDouble(OrderStopLoss(),Digits);
      
         Ticket = OrderTicket();
         if(OrderType()==OP_BUY)     
         {
            if(NormalizeDouble(Bid-SL,Digits)>StopLevel && SL!=OSL)     
            {
               if (OrderModify(Ticket,OOP,SL,NormalizeDouble(OrderTakeProfit(),Digits),0,White))
                  txt = StringConcatenate(txt,"\nВыставлен стоплосс ",DoubleToStr(SL,Digits)," BUY ордеру ",Ticket);
               else txt = StringConcatenate(txt,"\nОшибка ",GetLastError()," выставления стоплосс BUY ордеру ",Ticket);
            }
            if(NormalizeDouble(SL-Ask,Digits)>StopLevel && SL!=OSL)     
            {
               if (OrderModify(Ticket,OOP,NormalizeDouble(OrderStopLoss(),Digits),SL,0,White))
                  txt = StringConcatenate(txt,"\nВыставлен тейкпрофит ",DoubleToStr(SL,Digits)," BUY ордеру ",Ticket);
               else txt = StringConcatenate(txt,"\nОшибка ",GetLastError()," выставления тейкпрофит BUY ордеру ",Ticket);
            }
         }
      }   
      Comment(txt,"\nСкрипт_NL ALL BUY Mouse закончил свою работу ",TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS),"\nУстановлен ",txt2," всем ордерам BUY\n",txt1);
   } else Comment("");
   ObjectDelete("NLt");
   return(0);
  }
//+------------------------------------------------------------------+
void DrawHLINE(string name, double p)
{
   ObjectDelete(name);
   ObjectCreate(name, OBJ_HLINE, 0, 0, p);
   ObjectSet(name, OBJPROP_COLOR, Gold);
   ObjectSet(name, OBJPROP_STYLE, 0);
}
//+------------------------------------------------------------------+
double NLchek()
{
   double price,OL;
   SumLot=0;Profit=0;n=0;
   for (int i=OrdersTotal()-1; i>=0; i--)
   {                                               
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         if (OrderSymbol() == Symbol())
         {
            OL = OrderLots();
            if (OrderType()==OP_BUY)
            {
               price += OrderOpenPrice()*OL;
               SumLot+=OL;
               Profit+=OrderProfit();
               n++;
            }
         }
      }
   }
   if (SumLot==0) return(0);
   return(NormalizeDouble(price/SumLot,Digits));
}
//+------------------------------------------------------------------+
void drawtext(string NameLine, double p, string t,color c)
{
   ObjectDelete (NameLine);
   int i = WindowFirstVisibleBar()/3;
   ObjectCreate (NameLine, OBJ_TEXT,0,Time[i],p,0,0,0,0);
   ObjectSetText(NameLine, t,8,"Arial");
   ObjectSet    (NameLine, OBJPROP_COLOR, c);
}
//-------------------------------------------------------------------+
color Color(bool P,color a,color b)
{
   if (P) return(a);
   else return(b);
}
//------------------------------------------------------------------