
//+------------------------------------------------------------------+
//|                                                  BrokenArrow.mq4 |
//|                                     Copyright © 2010, NutCracher |
//|                                              forex-way@yandex.ru |
//|                                              http://wellforex.ru |
//-------------------------------------------------------------------+

#property copyright "Copyright © 2010, http://wellforex.ru"
#property link      "forex-way@yandex.ru"
extern string   ParamertSet = "Параметры эксперта";
extern double   ma_period = 30;                //Период Envelopes
extern double   deviation = 0.28;              //Девиация Envelopes    
extern double   Hide      = 33;                //Длина тени
extern double   dR        = 15;                //Отступ от границы канала
extern int      Stop      = 36;                //Стоплосс
extern string   BrokerSet = "Установки ДЦ";  
extern int      NumberOfDigit=5;               //Количество знаков в котировках торгового сервера: 4 или 5
extern string   MMSet = "Управление капиталом";
extern bool     MM=false;                      // Включение ММ
extern double   MMRisk=0.1;                    // Риск-фактор
extern double   Lots = 0.1;                    //Лот по умолчанию
#define MAGICMA  20050610

double Range_Hi, Range_Low, Bar_Low, Bar_Hi, Bar_Open, Bar_Close;
double SL, TP, Body, Bar_Hide_Hi, Bar_Hide_Low;
bool Buy, Sell;
int Dec=10;

double MoneyManagement ( bool flag, double risk)
{
   double Lotsi=Lots;
	    
   if ( flag ) Lotsi=NormalizeDouble(AccountFreeMargin()*risk/1000,2);   
   if (Lotsi<0.1) Lotsi=0.1;  
   return(Lotsi);
}   

int CalculateCurrentOrders(string symbol)
  {
   int buys=0,sells=0;

   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MAGICMA)
        {
         if(OrderType()==OP_BUY)  buys++;
         if(OrderType()==OP_SELL) sells++;
        }
     }
   if(buys>0) return(buys);
   else       return(-sells);
  }

void CheckForOpen()
  {
   int res;

   if(Volume[0]>1) return;
    Sell=false;
    Buy=false;
    Range_Hi=iEnvelopes(Symbol(), PERIOD_H1, ma_period ,MODE_SMA,0,PRICE_CLOSE,deviation,MODE_UPPER,1);
    Range_Low=iEnvelopes(Symbol(), PERIOD_H1, ma_period ,MODE_SMA,0,PRICE_CLOSE,deviation,MODE_LOWER,1);
    Bar_Low=iLow(Symbol(),PERIOD_H1,1);
    Bar_Hi=iHigh(Symbol(),PERIOD_H1,1);
    Bar_Open=iOpen(Symbol(),PERIOD_H1,1);
    Bar_Close=iClose(Symbol(),PERIOD_H1,1);
    if (Bar_Open>=Bar_Close) 
    {
    Body=Bar_Open-Bar_Close;
    Bar_Hide_Low=Bar_Close-Bar_Low;
    Bar_Hide_Hi=Bar_Hi-Bar_Open;
    } 
    else 
    {
    Body=Bar_Close-Bar_Open;
    Bar_Hide_Low=Bar_Open-Bar_Low;
    Bar_Hide_Hi=Bar_Hi-Bar_Close;
    }
  
    if (Bar_Hide_Low>Hide*Dec*Point)
    {
    Buy=True;

    SL=Bid-Stop*Dec*Point;
    TP=Range_Hi+dR*Dec*Point;
    if (TP-Bid<10*Dec*Point) TP=Bid+60*Dec*Point;
    }
    if (Bar_Hide_Hi>Hide*Dec*Point)
    {
    Sell=True;
    SL=Ask+Stop*Dec*Point;
    TP=Range_Low-dR*Dec*Point;
    if (Ask-TP<10*Dec*Point) TP=Ask-60*Dec*Point;

    }
        
      if (Buy)
      {
   
      res=OrderSend(Symbol(),OP_BUY,Lots,Ask,3*Dec,SL,TP,"",MAGICMA,0,Blue);
      if(res>0)
           {
            if(OrderSelect(res,SELECT_BY_TICKET,MODE_TRADES)) Print("BUY по цене : ",OrderOpenPrice());
            Buy=false;
           }
         else 
         {
         Print("Error opening BUY order : ",GetLastError()); 
         }
 
         ObjectCreate("Arrow"+TimeCurrent(), OBJ_ARROW,0,0,0,0,0);
         ObjectSet   ("Arrow"+TimeCurrent(), OBJPROP_COLOR, DodgerBlue);
         ObjectSet   ("Arrow"+TimeCurrent(), OBJPROP_ARROWCODE, SYMBOL_ARROWUP);
         ObjectSet   ("Arrow"+TimeCurrent(), OBJPROP_TIME1,TimeCurrent());
         ObjectSet   ("Arrow"+TimeCurrent(), OBJPROP_PRICE1,Bar_Low);

      }
      if (Sell)
      {

      res=OrderSend(Symbol(),OP_SELL,Lots,Bid,3*Dec,SL,TP,"",MAGICMA,0,Red);
      if(res>0)
           {
            if(OrderSelect(res,SELECT_BY_TICKET,MODE_TRADES)) Print("SELL по цене : ",OrderOpenPrice());
            Sell=false;
           }
         else 
         {
         Print("Error opening SELL order : ",GetLastError()); 
         }
         ObjectCreate("Arrow"+TimeCurrent(), OBJ_ARROW,0,0,0,0,0);
         ObjectSet   ("Arrow"+TimeCurrent(), OBJPROP_COLOR, DeepPink);
         ObjectSet   ("Arrow"+TimeCurrent(), OBJPROP_ARROWCODE, SYMBOL_ARROWDOWN);
         ObjectSet   ("Arrow"+TimeCurrent(), OBJPROP_TIME1,TimeCurrent());
         ObjectSet   ("Arrow"+TimeCurrent(), OBJPROP_PRICE1,Bar_Hi);
        }
        return; 
      return;

      }


int start()
  {
 if (NumberOfDigit==4) Dec=1;
 if (NumberOfDigit==5) Dec=10;   
 if (MM) Lots = MoneyManagement (MM,MMRisk);

   if(Bars<100 || IsTradeAllowed()==false) return(0);
   if(CalculateCurrentOrders(Symbol())==0 ) CheckForOpen();
   
   return(0);
  }

