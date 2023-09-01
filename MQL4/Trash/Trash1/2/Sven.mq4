//+------------------------------------------------------------------+
//|                                                         Sven.mq4 |
//|                                  Copyright 2020, Maksim Neimerik |
//|                         https://www.mql5.com/ru/users/istrebitel |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Maksim Neimerik"
#property link      "https://www.mql5.com/ru/users/istrebitel"
#property version   "1.00"
#property strict

extern string time="09:00";//Time Start
extern double lot=0.01;//Lot
extern int TP=100;//Take Profit
extern bool Averaging=true;
extern double LotMult=1.1;//Lot multiplier
extern int step=200;//Step
extern int Magic=777;
extern int Slippage=10;

double TakeProfit=0,Step=0;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   if(_Digits==2||_Digits==4)
   {
      TP/=10;
      step/=10;
      Slippage/=10;
   }
   
   TakeProfit=NormalizeDouble(TP*Point(),_Digits);
   Step=NormalizeDouble(step*Point(),_Digits);
   
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   Run();
}
//+------------------------------------------------------------------+
void Run()
{
   if(TimeToStr(TimeCurrent(),TIME_MINUTES)==time)
   {
      if(CountOrders(0)==0)OpenOrder(0,lot);
      if(CountOrders(1)==0||Average(1))OpenOrder(1,lot);
   }
   if(Averaging)
   {
      if(Average(0))OpenOrder(0,NormalizeDouble(CountLots(0)*LotMult,2));
      if(Average(1))OpenOrder(1,NormalizeDouble(CountLots(1)*LotMult,2));
   }
   if(CountOrders(0)+CountOrders(1)!=0)Modify();
}
//+------------------------------------------------------------------+
void OpenOrder(int type,double lots)
{
   int Ticket=0;
   double price=0;
   if(type==0)
   {
      price=NormalizeDouble(Ask,_Digits);
   }
   if(type==1)
   {
      price=NormalizeDouble(Bid,_Digits);
   }
   
   if(!CheckVolumeValue(lots))return;
   
   Ticket=OrderSend(Symbol(),type,lots,price,Slippage,0,0,"Sven",Magic,0);
   if(Ticket<=0)
   {
      Print("Order ",type," not open! Error = ",GetLastError());
   }
}
//+------------------------------------------------------------------+
int CountOrders(int type)
{
   int res=0;
   for(int i=OrdersTotal()-1; i>=0; i--)
   {
      if(OrderSelect(i,SELECT_BY_POS))
      {
         if(OrderSymbol()==Symbol())
         {
            if(OrderMagicNumber()==Magic)
            {
               if(OrderType()==type)res++;
            }
         }
      }
   }  
   return (res);
}
//+------------------------------------------------------------------+
double CountLots(int type)
{
   double res=0;
   for(int i=OrdersTotal()-1; i>=0; i--)
   {
      if(OrderSelect(i,SELECT_BY_POS))
      {
         if(OrderSymbol()==Symbol())
         {
            if(OrderMagicNumber()==Magic)
            {
               if(OrderType()==type)res=res+OrderLots();
            }
         }
      }
   }  
   return (res);
}
//+------------------------------------------------------------------+
bool Average(int type)
{
   bool res=false;
   datetime tb=0,ts=0;
   for(int i=OrdersTotal()-1; i>=0; i--)
   {
      if(OrderSelect(i,SELECT_BY_POS))
      {
         if(OrderSymbol()==Symbol())
         {
            if(OrderMagicNumber()==Magic)
            {
               if(OrderType()==0&&type==0)
               {
                  if(OrderOpenTime()>tb)
                  {
                     if(Ask<=OrderOpenPrice()-Step)res=true;
                     tb=OrderOpenTime();
                  }
               }
               if(OrderType()==1&&type==1)
               {
                  if(OrderOpenTime()>ts)
                  {
                     if(Bid>=OrderOpenPrice()+Step)res=true;
                     ts=OrderOpenTime();
                  }
               }
            }
         }
      }
   }  
   return(res);
}
//+------------------------------------------------------------------+
void Modify()
{
   double BuyLots=0,SellLots=0,BuyProfit=0,SellProfit=0,BuyLevel=0,SellLevel=0,TickValue=0;
   int Total=OrdersTotal();
   for (int i=Total-1;i>=0;i--)
   {
      if (OrderSelect(i,SELECT_BY_POS))
      {
         if (OrderSymbol()!=Symbol()) continue;
         if (OrderMagicNumber()!=Magic) continue;
         if (OrderType()==OP_BUY)
         {
            BuyLots=BuyLots+OrderLots();
            BuyProfit=BuyProfit+OrderProfit()+OrderCommission()+OrderSwap();
         }
         if (OrderType()==OP_SELL)
         {
            SellLots=SellLots+OrderLots();
            SellProfit=SellProfit+OrderProfit()+OrderCommission()+OrderSwap();
         }
      }
   }
   TickValue=MarketInfo(Symbol(),MODE_TICKVALUE);
   if(BuyLots>0)BuyLevel=NormalizeDouble(Bid-(BuyProfit/(TickValue*BuyLots)*Point),Digits);
   if(SellLots>0)SellLevel=NormalizeDouble(Ask+(SellProfit/(TickValue*SellLots)*Point),Digits);
   if(BuyLevel!=0)
   {
      for(int i=OrdersTotal()-1; i>=0; i--)
      {
         if(OrderSelect(i,SELECT_BY_POS))
         {
            if(OrderSymbol()==Symbol())
            {
               if(OrderMagicNumber()==Magic)
               {
                  if(OrderType()==0&&OrderTakeProfit()!=BuyLevel+TakeProfit)
                  {
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),BuyLevel+TakeProfit,0))Print("Order #",OrderTicket()," not modify! Error = ",GetLastError());
                  }
               }
            }
         }
      }  
   }
   if(SellLevel!=0)
   {
      for(int i=OrdersTotal()-1; i>=0; i--)
      {
         if(OrderSelect(i,SELECT_BY_POS))
         {
            if(OrderSymbol()==Symbol())
            {
               if(OrderMagicNumber()==Magic)
               {
                  if(OrderType()==1&&OrderTakeProfit()!=SellLevel-TakeProfit)
                  {
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),SellLevel-TakeProfit,0))Print("Order #",OrderTicket()," not modify! Error = ",GetLastError());
                  }
               }
            }
         }
      }  
   }
}
//+------------------------------------------------------------------+
bool CheckVolumeValue(double volume)
{
   double min_volume=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN);
   if(volume<min_volume)
     {
      Print("Volume is less than the minimum");
      return(false);
     }
   
   double max_volume=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MAX);
   if(volume>max_volume)
     {
      Print("Volume is greater than the maximum");
      return(false);
     }
   
   double volume_step=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_STEP);
   
   int ratio=(int)MathRound(volume/volume_step);
   if(MathAbs(ratio*volume_step-volume)>0.0000001)
     {
      Print("Wrong lot size");
      return(false);
     }
     
   if(volume*MarketInfo(Symbol(),MODE_MARGINREQUIRED)>AccountEquity())
     {
      Print("Trade stop is not enough free margin to begin");
      return(false);
     }
   return(true);
}
//+-------------------------------------------by-Maksim-Neimerik------+