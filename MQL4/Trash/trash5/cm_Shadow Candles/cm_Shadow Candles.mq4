//+------------------------------------------------------------------+
//|                                                cm_тени свечи.mq4 |
//|    длина свечи 50, тень снизу 30, ставим байстоп над свечей 10 п |
//|                              Copyright © 2012, Khlystov Vladimir |
//|                                         http://cmillion.narod.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012, cmillion@narod.ru"
#property link      "http://cmillion.narod.ru"
//--------------------------------------------------------------------
extern int     Размер_свечи         = 20;     //не менее
extern int     Тень_свечи           = 130;    //не менее в процентах от тела свечи
extern int     Step                 = 10;     //расстояние от свечи до ордера
extern int     BarLife              = 3;      //на протяжении какого числа свечей живет отложенный ордер
extern int     Stoploss             = 10,     //стоплосс, если 0 то не изменяется
               Takeprofit           = 40;     //тейкпрофит, если 0 то не изменяется
extern int     TrailingStop         = 0;      //длинна тралла, если 0 то нет тралла
extern int     TrailingStart        = 0;      //когда включать тралл, например после достижения 40 п прибыл
extern int     StepTrall            = 0;      //шаг тралла - перемещать стоплосс не ближе чем StepTrall
extern int     NoLoss               = 0,      //перевод в безубыток при заданном кол-ве пунктов прибыли, если 0 то нет перевода в безубыток
               MinProfitNoLoss      = 10;     //минимальная прибыль при переводе вбезубыток
extern int     MaxOrders            = 5;      //максимальное кол-во однонаправленных ордеров в рынке
extern int     Magic                = 0;      //магик
extern double  Lot                  = 0.1;
extern int     slippage             = 30;     //Максимально допустимое отклонение цены для рыночных ордеров (ордеров на покупку или продажу).
extern int     TimeStart            = 0 ,     //ограничение времени работы советника
               TimeEnd              = 24;     //не открываем ордера и закрываем отложки если время не между TimeStart и TimeEnd
//--------------------------------------------------------------------
int  STOPLEVEL;
double PriceDeleteB,PriceDeleteS;
datetime TimeOpen;
//--------------------------------------------------------------------
int start()                                  
{
   if (!IsTradeAllowed()) 
   {
      Comment("Торговля запрещена IsTradeAllowed",12,"Arial",Crimson);
      return(0);
   }
   //---
   int TekHour = Hour();
   bool Trade;
   if ( TimeStart < TimeEnd && TekHour >= TimeStart && TekHour < TimeEnd ) Trade=true; 
   else 
   {
      if ( TimeStart > TimeEnd && (TekHour >= TimeStart || TekHour < TimeEnd)) Trade=true; //торговля ночью
      else Trade=false;
   }
   if (!Trade)
   {
      Comment("Торговля запрещена по времени ");
   }
   //---
   STOPLEVEL=MarketInfo(Symbol(),MODE_STOPLEVEL);
   double OSL,StLo,PriceB,PriceS,OOP,SL;
   int b,s,TicketB,TicketS,OT;
   for (int i=0; i<OrdersTotal(); i++)
   {    
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         if (OrderSymbol()==Symbol() && Magic==OrderMagicNumber())
         { 
            OT = OrderType(); 
            OSL = NormalizeDouble(OrderStopLoss(),Digits);
            OOP = NormalizeDouble(OrderOpenPrice(),Digits);
            SL=OSL;
            if (OT==OP_BUY)             
            {  
               b++;
               if (OSL<OOP && NoLoss>=STOPLEVEL)
               {
                  StLo = NormalizeDouble(OOP+MinProfitNoLoss*Point,Digits); 
                  if (StLo > OSL && StLo <= NormalizeDouble(Bid - NoLoss * Point,Digits)) SL = StLo;
               }
               
               if (TrailingStop>=STOPLEVEL && TrailingStop!=0 && (Bid - OOP)/Point >= TrailingStart)
               {
                  StLo = NormalizeDouble(Bid - TrailingStop*Point,Digits); 
                  if (StLo>=OOP && StLo > OSL+StepTrall*Point) SL = StLo;
               }
               
               if (SL > OSL)
               {  
                  if (!OrderModify(OrderTicket(),OOP,SL,OrderTakeProfit(),0,White)) Print("Error ",GetLastError(),"   Order Modify Buy   SL ",OSL,"->",SL);
                  else Print("Order Buy Modify   SL ",OSL,"->",SL);
               }
            }                                         
            if (OT==OP_SELL)        
            {
               s++;
               if ((OSL>OOP || OSL==0) && NoLoss>=STOPLEVEL)
               {
                  StLo = NormalizeDouble(OOP-MinProfitNoLoss*Point,Digits); 
                  if ((StLo < OSL || OSL==0) && StLo >= NormalizeDouble(Ask + NoLoss * Point,Digits)) SL = StLo;
               }
               
               if (TrailingStop>=STOPLEVEL && TrailingStop!=0 && (OOP - Ask)/Point >= TrailingStart)
               {
                  StLo = NormalizeDouble(Ask + TrailingStop*Point,Digits); 
                  if (StLo<=OOP && (StLo < OSL-StepTrall*Point || OSL==0)) SL = StLo;
               }
               
               if ((SL < OSL || OSL==0) && SL!=0)
               {  
                  if (!OrderModify(OrderTicket(),OOP,SL,OrderTakeProfit(),0,White)) Print("Error ",GetLastError(),"   Order Modify Sell   SL ",OSL,"->",SL);
                  else Print("Order Sell Modify   SL ",OSL,"->",SL);
               }
            } 
            if (OT==OP_BUYSTOP)  {PriceB=OOP; TicketB=OrderTicket();}     
            if (OT==OP_SELLSTOP) {PriceS=OOP; TicketS=OrderTicket();}  
         }
      }
   }
   int err;
   if (!Trade)
   {
      if (b+s==0) 
      {
         if (TicketS>0) err=OrderDelete(TicketS);
         if (TicketB>0) err=OrderDelete(TicketB);
         return(0);
      }
   }
   
   double Price;
   double Тело = MathAbs(Open[1]-Close[1])/Point;
   double ВерхняяТень = (High[1]-Open[1])/Point;
   double НижняяТень = (Open[1]-Low[1])/Point;
   double StopLevel = STOPLEVEL*Point;
   
   int S;
   if ((High[1]-Low[1])/Point>=Размер_свечи)
   {
      if (Open[1]<Close[1] && НижняяТень>=Тело/100*Тень_свечи  && НижняяТень>ВерхняяТень) {S= 1;Candle(Blue);}
      if (Open[1]>Close[1] && ВерхняяТень>=Тело/100*Тень_свечи && НижняяТень<ВерхняяТень) {S=-1;Candle(Red);}
   }
   
   if (PriceDeleteB>Bid && PriceDeleteB!=0) 
   {
      if (TicketB>0) {err=OrderDelete(TicketB);PriceDeleteB=0;return(0);}
   }
   double TP;
   if (TicketB==0 && S==1 && TimeOpen!=Time[0])
   {
      if (TicketS>0) err=OrderDelete(TicketS);
      Price = NormalizeDouble(High[1]+Step * Point,Digits);
      if (Price<NormalizeDouble(Ask+StopLevel,Digits)) Price=NormalizeDouble(Ask+StopLevel,Digits);
      if (Stoploss>=STOPLEVEL && Stoploss!=0) SL = NormalizeDouble(Price - Stoploss * Point,Digits); else SL=0;
      if (Takeprofit>=STOPLEVEL && Takeprofit!=0) TP = NormalizeDouble(Price + Takeprofit * Point,Digits); else TP=0;
      if (OrderSend(Symbol(),OP_BUYSTOP,Lot,Price,slippage,SL,TP,"news",Magic,TimeCurrent()+Period()*60*BarLife,CLR_NONE)!=-1) {PriceDeleteB=Low[1];TimeOpen=Time[0];}
      else Print("OrderSend Error SetStop ",GetLastError(),"  Ask ",DoubleToStr(Ask,Digits),"  Price ",DoubleToStr(Price,Digits),"  SL ",DoubleToStr(SL,Digits),"  TP ",DoubleToStr(TP,Digits));
   }
   if (PriceDeleteS<Bid && PriceDeleteS!=0) 
   {
      if (TicketS>0) {err=OrderDelete(TicketS);PriceDeleteS=0;return(0);}
   }

   if (TicketS==0 && S==-1 && TimeOpen!=Time[0])
   {
      if (TicketB>0) err=OrderDelete(TicketB);
      Price = NormalizeDouble(Low[1] - Step * Point,Digits);
      if (Price>NormalizeDouble(Bid-StopLevel,Digits)) Price=NormalizeDouble(Bid-StopLevel,Digits);
      if (Stoploss>=STOPLEVEL && Stoploss!=0) SL = NormalizeDouble(Price + Stoploss * Point,Digits); else SL=0;
      if (Takeprofit>=STOPLEVEL && Takeprofit!=0) TP = NormalizeDouble(Price - Takeprofit * Point,Digits); else TP=0;
      if (OrderSend(Symbol(),OP_SELLSTOP,Lot,Price,slippage,SL,TP,"news",Magic,TimeCurrent()+Period()*60*BarLife,CLR_NONE)!=-1) {PriceDeleteS=High[1];TimeOpen=Time[0];}
      else Print("OrderSend Error SetStop ",GetLastError(),"  Bid ",DoubleToStr(Bid,Digits),"  Price ",DoubleToStr(Price,Digits),"  SL ",DoubleToStr(SL,Digits),"  TP ",DoubleToStr(TP,Digits));
   }
return(0);
}
//--------------------------------------------------------------------
void Candle(color C)
{
   string NameLine=TimeToStr(Time[1],TIME_DATE|TIME_MINUTES);

   ObjectDelete(NameLine);
   ObjectCreate(NameLine,OBJ_TREND,0,Time[1],Low[1],Time[1],High[1]);
   ObjectSet(NameLine, OBJPROP_COLOR,C); 
   ObjectSet(NameLine, OBJPROP_STYLE, 0);
   ObjectSet(NameLine, OBJPROP_WIDTH, 1);
   ObjectSet(NameLine, OBJPROP_RAY,   false);
   
   NameLine=StringConcatenate(NameLine," тело");

   ObjectDelete(NameLine);
   ObjectCreate(NameLine,OBJ_TREND,0,Time[1],Open[1],Time[1],Close[1]);
   ObjectSet(NameLine, OBJPROP_COLOR,C); 
   ObjectSet(NameLine, OBJPROP_STYLE, 0);
   ObjectSet(NameLine, OBJPROP_WIDTH, 5);
   ObjectSet(NameLine, OBJPROP_RAY,   false);
}
//--------------------------------------------------------------------

