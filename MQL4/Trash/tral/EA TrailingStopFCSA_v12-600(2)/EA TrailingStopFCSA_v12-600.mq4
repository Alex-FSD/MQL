//+------------------------------------------------------------------+
//|                                          TrailingStopFrCnSAR.mq4 |
//|                              Copyright © 2014, Khlystov Vladimir |
//|                                         http://cmillion.narod.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2014, cmillion@narod.ru"
#property link      "http://cmillion.narod.ru"
//--------------------------------------------------------------------
extern string  parameters_trailing  = "0-off  1-Candle  2-Fractals  3-ATR  4-Parabolic  >4-pips";
extern int     TrailingStop         = 1;      // тралл убыточных сделок, если 0 off 
extern int     StepTrall            = 0;      // шаг тралла - перемещать стоплосс не ближе чем StepTrall
extern int     delta                = 0;      // отступ от фрактала свечи и др.
extern bool    only_NoLoss          = false;  // только перевод в безубыток без тралла
extern bool    GeneralNoLoss        = true;   // трал от портфельного профита ордеров
extern int     TF_Tralling          = 15;     // таймфрейм свечей, SAR или фракталов для тралла

string         parameters_Parabolic = "";
extern double  Step                 = 0.02;
extern double  Maximum              = 0.2;

string         parameters_ATR = "";
extern int     period_ATR           = 14;     // период ATR для трейлинга  

extern int     Magic                = 0;

extern bool    visualization        = true;
extern int     font_size            = 10;       //размер шрифта
extern int     Corner               = 1;        //угол вывода информации
extern color   text_color           = Lime;     //цвет вывода информации

//--------------------------------------------------------------------
int STOPLEVEL,n;
//--------------------------------------------------------------------
int init()
{
   int Y = font_size+font_size/2;
   TF_Tralling = next_period(TF_Tralling);
   if (visualization) 
   {
      Comment("Start EA TrailingStop ",TimeToStr(TimeCurrent(),TIME_SECONDS));
      string txt;
      ObjectCreate("info1",OBJ_LABEL,0,0,0);
      ObjectSet("info1",OBJPROP_CORNER,2);      
      ObjectSet("info1",OBJPROP_XDISTANCE,0); 
      ObjectSet("info1",OBJPROP_YDISTANCE,5);
      ObjectSetText("info1","Copyright © 2010, http://cmillion.narod.ru",8,"Arial",Gold);
      
      int name=0;
      string NameOb="Object"+name;
      ObjectCreate("info",OBJ_LABEL,0,0,0);
      ObjectSet("info",OBJPROP_CORNER,Corner);      
      ObjectSet("info",OBJPROP_XDISTANCE,5); 
      ObjectSet("info",OBJPROP_YDISTANCE, Y); Y += font_size+font_size/2;
      ObjectSetText("info","ордеров",font_size,"Arial",text_color);

      if (GeneralNoLoss)
      {
         ObjectCreate(NameOb, OBJ_LABEL, 0, 0, 0);
         ObjectSet(NameOb, OBJPROP_CORNER, Corner);
         ObjectSet(NameOb, OBJPROP_XDISTANCE, 5);
         ObjectSet(NameOb, OBJPROP_YDISTANCE, Y); Y += font_size+font_size/2;
         ObjectSetText(NameOb,"Работа от общего безубытка",font_size,"Arial",text_color);name++;NameOb="Object"+name;
      }
      if (TrailingStop==1) txt=StringConcatenate("По свечам ",StrPer(TF_Tralling)," +- ",delta); 
      if (TrailingStop==2) txt=StringConcatenate("По фракталам ",StrPer(TF_Tralling)," ",StrPer(TF_Tralling)," +- ",delta); 
      if (TrailingStop==3) txt=StringConcatenate("По ATR (",period_ATR,") ",StrPer(TF_Tralling),"+- ",delta); 
      if (TrailingStop==4) txt=StringConcatenate("По параболику (",Step,",",Maximum,") ",StrPer(TF_Tralling)," +- ",delta); 
      if (TrailingStop> 4) txt=StringConcatenate("По пипсам ",TrailingStop," п"); 
      ObjectCreate(NameOb, OBJ_LABEL, 0, 0, 0);
      ObjectSet(NameOb, OBJPROP_CORNER, Corner);
      ObjectSet(NameOb, OBJPROP_XDISTANCE, 5);
      ObjectSet(NameOb, OBJPROP_YDISTANCE, Y); Y += font_size+font_size/2;
      ObjectSetText(NameOb,txt,font_size,"Arial",text_color);name++;NameOb="Object"+name;

      if (Magic==0) txt="Magic all"; 
      else  txt=StringConcatenate("Magic ",Magic,"\n");

      ObjectCreate(NameOb, OBJ_LABEL, 0, 0, 0);
      ObjectSet(NameOb, OBJPROP_CORNER, Corner);
      ObjectSet(NameOb, OBJPROP_XDISTANCE, 5);
      ObjectSet(NameOb, OBJPROP_YDISTANCE, Y); Y += font_size+font_size/2;
      ObjectSetText(NameOb,txt,font_size,"Arial",text_color);name++;NameOb="Object"+name;
      
      if (only_NoLoss)
      {
         ObjectCreate(NameOb, OBJ_LABEL, 0, 0, 0);
         ObjectSet(NameOb, OBJPROP_CORNER, Corner);
         ObjectSet(NameOb, OBJPROP_XDISTANCE, 5);
         ObjectSet(NameOb, OBJPROP_YDISTANCE, Y); Y += font_size+font_size/2;
         ObjectSetText(NameOb,"Только безубыток",font_size,"Arial",text_color);name++;NameOb="Object"+name;
      }
   }
   return(0);
}
//--------------------------------------------------------------------
int start()                                  
{      
   if (!IsTradeAllowed()) 
   {
      Comment("Торговля запрещена ",TimeToStr(TimeCurrent(),TIME_MINUTES));
      return(0);
   } 
   int b,s;
   double price,price_b,price_s,lot,NLb,NLs,lot_s,lot_b;
   for (int j=0; j<OrdersTotal(); j++)
   {  if (OrderSelect(j,SELECT_BY_POS,MODE_TRADES)==true)
      {  if ((Magic==OrderMagicNumber() || Magic==0) && OrderSymbol()==Symbol())
         {
            price = OrderOpenPrice();
            lot   = OrderLots();
            if (OrderType()==OP_BUY ) {price_b += price*lot; lot_b+=lot; b++;}                     
            if (OrderType()==OP_SELL) {price_s += price*lot; lot_s+=lot; s++;}
         }  
      }  
   }
   //--------------------------------------
   if (visualization)
   {
      ObjectDelete("NoLossBuy");
      ObjectDelete("NoLossBuy_");
      ObjectDelete("NoLossSell");
      ObjectDelete("NoLossSell_");
   }
   if (b!=0) 
   {  NLb = price_b/lot_b;
      if (visualization)
      {
         ObjectCreate("NoLossBuy",OBJ_ARROW,0,Time[0]+Period()*60*5,NLb,0,0,0,0);                     
         ObjectSet   ("NoLossBuy",OBJPROP_ARROWCODE,6);
         ObjectSet   ("NoLossBuy",OBJPROP_COLOR, Blue);         
         ObjectCreate("NoLossBuy_",OBJ_ARROW,0,Time[0]+Period()*60*5,NLb,0,0,0,0);                     
         ObjectSet   ("NoLossBuy_",OBJPROP_ARROWCODE,200);
         ObjectSet   ("NoLossBuy_",OBJPROP_COLOR, Blue);}
   }
   if (s!=0) 
   {  NLs = price_s/lot_s;
      if (visualization)
      {
         ObjectCreate("NoLossSell",OBJ_ARROW,0,Time[0]+Period()*60*5,NLs,0,0,0,0);                     
         ObjectSet   ("NoLossSell",OBJPROP_ARROWCODE,6);
         ObjectSet   ("NoLossSell",OBJPROP_COLOR, Pink);         
         ObjectCreate("NoLossSell_",OBJ_ARROW,0,Time[0]+Period()*60*5,NLs,0,0,0,0);                     
         ObjectSet   ("NoLossSell_",OBJPROP_ARROWCODE,202);
         ObjectSet   ("NoLossSell_",OBJPROP_COLOR, Pink);}
   }
   RefreshRates();
   STOPLEVEL=MarketInfo(Symbol(),MODE_STOPLEVEL);
   if (TrailingStop<STOPLEVEL && TrailingStop>4) TrailingStop=STOPLEVEL;
   int tip,Ticket;
   bool error;
   double StLo,OSL,OOP;
   n=0;
   for (int i=OrdersTotal(); i>=0; i--) 
   {  if (OrderSelect(i, SELECT_BY_POS)==true)
      {  tip = OrderType();
         if (tip<2 && (OrderSymbol()==Symbol()) && (OrderMagicNumber()==Magic || Magic==0))
         {
            OSL    = OrderStopLoss();
            OOP    = OrderOpenPrice();
            Ticket = OrderTicket();
            if (tip==OP_BUY)             
            {  n++;
               StLo = SlLastBar(1,Bid,TrailingStop); 
               if ((StLo < NLb && GeneralNoLoss) || (StLo < OOP && !GeneralNoLoss)) continue;
               if (OSL  >= OOP && only_NoLoss) continue;
               if (StLo > OSL+StepTrall*Point)
               {  error=OrderModify(Ticket,OOP,NormalizeDouble(StLo,Digits),OrderTakeProfit(),0,White);
                  if (!error) Comment("TrailingStop Error ",GetLastError(),"  order ",Ticket,"   SL ",StLo);
                  else Comment("TrailingStop ",Ticket," ",TimeToStr(TimeCurrent(),TIME_MINUTES));
               }
            }                                         
            if (tip==OP_SELL)        
            {  n++;
               StLo = SlLastBar(-1,Ask,TrailingStop);  
               if ((StLo > NLs && GeneralNoLoss) || (StLo > OOP && !GeneralNoLoss)) continue;
               if (OSL  <= OOP && only_NoLoss) continue;
               if (StLo < OSL-StepTrall*Point || OSL==0 )
               {  error=OrderModify(Ticket,OOP,NormalizeDouble(StLo,Digits),OrderTakeProfit(),0,White);
                  
                  if (!error) Comment("TrailingStop Error ",GetLastError(),"  order ",Ticket,"   SL ",StLo);
                  else Comment("TrailingStop "+Ticket," ",TimeToStr(TimeCurrent(),TIME_MINUTES));
               }
            } 
         }
      }
   }
   if (n==0) ObjectSetText("info","Нет ордеров",font_size,"Arial",text_color);
   else ObjectSetText("info",StringConcatenate(n, " орд."),font_size,"Arial",text_color);
   return(0);
}
//--------------------------------------------------------------------
int deinit()
{      
   if (!visualization) return(0);
   Comment("Closing EA TrailingStop ",TimeToStr(TimeCurrent(),TIME_SECONDS));
   ObjectDelete("info");
   ObjectDelete("info1");
   ObjectDelete("SL Buy");
   ObjectDelete("STOPLEVEL-");
   ObjectDelete("SL Sell");
   ObjectDelete("STOPLEVEL+");
   ObjectDelete("NoLossSell");
   ObjectDelete("NoLossSell_");
   ObjectDelete("NoLossBuy");
   ObjectDelete("NoLossBuy_");
   for (int i=0; i<=20; i++) ObjectDelete("Object"+DoubleToStr(i,0));
   return(0);
}
//--------------------------------------------------------------------
double SlLastBar(int tip,double price,double Trailing)
{
   double fr=0;
   int jj,ii;
   if (Trailing>4)
   {
      if (tip==1) fr = price - Trailing*Point;  
      else        fr = price + Trailing*Point;  
   }
   else
   {
      //------------------------------------------------------- by Fractals
      if (Trailing==2)
      {
         if (tip== 1)
         {
            for (ii=1; ii<100; ii++) 
            {
               fr = iFractals(Symbol(),TF_Tralling,MODE_LOWER,ii);
               if (fr!=0) {fr-=delta*Point; if (price-STOPLEVEL*Point > fr) break;}
               else fr=0;
            }
            ObjectDelete("FR Buy");
            ObjectCreate("FR Buy",OBJ_ARROW,0,Time[ii],fr+Point,0,0,0,0);                     
            ObjectSet   ("FR Buy",OBJPROP_ARROWCODE,218);
            ObjectSet   ("FR Buy",OBJPROP_COLOR, Red);
         }
         if (tip==-1)
         {
            for (jj=1; jj<100; jj++) 
            {
               fr = iFractals(Symbol(),TF_Tralling,MODE_UPPER,jj);
               if (fr!=0) {fr+=delta*Point; if (price+STOPLEVEL*Point < fr) break;}
               else fr=0;
            }
            ObjectDelete("FR Sell");
            ObjectCreate("FR Sell",OBJ_ARROW,0,Time[jj],fr,0,0,0,0);                     
            ObjectSet   ("FR Sell",OBJPROP_ARROWCODE,217);
            ObjectSet   ("FR Sell",OBJPROP_COLOR, Red);
         }
      }
      //------------------------------------------------------- by candles
      if (Trailing==1)
      {
         if (tip== 1)
         {
            for (ii=1; ii<500; ii++) 
            {
               fr = iLow(Symbol(),TF_Tralling,ii)-delta*Point;
               if (fr!=0) if (price-STOPLEVEL*Point > fr) break;
               else fr=0;
            }
            ObjectDelete("FR Buy");
            ObjectCreate("FR Buy",OBJ_ARROW,0,iTime(Symbol(),TF_Tralling,ii),fr+Point,0,0,0,0);                     
            ObjectSet   ("FR Buy",OBJPROP_ARROWCODE,159);
            ObjectSet   ("FR Buy",OBJPROP_COLOR, Red);
         }
         if (tip==-1)
         {
            for (jj=1; jj<500; jj++) 
            {
               fr = iHigh(Symbol(),TF_Tralling,jj)+delta*Point;
               if (fr!=0) if (price+STOPLEVEL*Point < fr) break;
               else fr=0;
            }
            ObjectDelete("FR Sell");
            ObjectCreate("FR Sell",OBJ_ARROW,0,iTime(Symbol(),TF_Tralling,jj),fr,0,0,0,0);                     
            ObjectSet   ("FR Sell",OBJPROP_ARROWCODE,159);
            ObjectSet   ("FR Sell",OBJPROP_COLOR, Red);
         }
      }   
      //------------------------------------------------------- by ATR
      if (Trailing==3)
      {
         if (tip== 1)
         {
            fr = NormalizeDouble(Bid - iATR(Symbol(),TF_Tralling,period_ATR,0) - delta*Point,Digits);
         }
         if (tip==-1)
         {
            fr = NormalizeDouble(Ask + iATR(Symbol(),TF_Tralling,period_ATR,0) + delta*Point,Digits);
         }
      }
      //------------------------------------------------------- by PSAR
      if (Trailing==4)
      {
         double PSAR = iSAR(Symbol(),TF_Tralling,Step,Maximum,0);
         if (tip== 1)
         {
            if(price-STOPLEVEL*Point > PSAR) fr = PSAR - delta*Point;
            else fr=0;
         }
         if (tip==-1)
         {
            if(price+STOPLEVEL*Point < PSAR) fr = PSAR + delta*Point;
            else fr=0;
         }
      }
   }
   //-------------------------------------------------------
   if (visualization)
   {
      if (tip== 1)
      {  
         if (fr!=0){
         ObjectDelete("SL Buy");
         ObjectCreate("SL Buy",OBJ_ARROW,0,Time[0]+Period()*60,fr,0,0,0,0);                     
         ObjectSet   ("SL Buy",OBJPROP_ARROWCODE,6);
         ObjectSet   ("SL Buy",OBJPROP_COLOR, Blue);}
         if (STOPLEVEL>0){
         ObjectDelete("STOPLEVEL-");
         ObjectCreate("STOPLEVEL-",OBJ_ARROW,0,Time[0]+Period()*60,price-STOPLEVEL*Point,0,0,0,0);                     
         ObjectSet   ("STOPLEVEL-",OBJPROP_ARROWCODE,4);
         ObjectSet   ("STOPLEVEL-",OBJPROP_COLOR, Blue);}
      }
      if (tip==-1)
      {
         if (fr!=0){
         ObjectDelete("SL Sell");
         ObjectCreate("SL Sell",OBJ_ARROW,0,Time[0]+Period()*60,fr,0,0,0,0);
         ObjectSet   ("SL Sell",OBJPROP_ARROWCODE,6);
         ObjectSet   ("SL Sell", OBJPROP_COLOR, Pink);}
         if (STOPLEVEL>0){
         ObjectDelete("STOPLEVEL+");
         ObjectCreate("STOPLEVEL+",OBJ_ARROW,0,Time[0]+Period()*60,price+STOPLEVEL*Point,0,0,0,0);                     
         ObjectSet   ("STOPLEVEL+",OBJPROP_ARROWCODE,4);
         ObjectSet   ("STOPLEVEL+",OBJPROP_COLOR, Pink);}
      }
   }
   return(fr);
}
//--------------------------------------------------------------------
int next_period(int per)
{
   if (per > 43200)  return(0); 
   if (per > 10080)  return(43200); 
   if (per > 1440)   return(10080); 
   if (per > 240)    return(1440); 
   if (per > 60)     return(240); 
   if (per > 30)     return(60);
   if (per > 15)     return(30); 
   if (per >  5)     return(15); 
   if (per >  1)     return(5);   
   if (per == 1)     return(1);   
   if (per == 0)     return(Period());   
   return(0);
}
//+------------------------------------------------------------------+
string StrPer(int per)
{
   if (per == 1)     return("M1");
   if (per == 5)     return("M5");
   if (per == 15)    return("M15");
   if (per == 30)    return("M30");
   if (per == 60)    return("H1");
   if (per == 240)   return("H4");
   if (per == 1440)  return("D1");
   if (per == 10080) return("W1");
   if (per == 43200) return("MN1");
return("ошибка периода");
}
//+------------------------------------------------------------------+