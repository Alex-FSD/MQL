//+------------------------------------------------------------------+
//|                               Copyright © 2011, Хлыстов Владимир |
//|                                                cmillion@narod.ru |
//+------------------------------------------------------------------+
#property copyright   "Copyright © 2020, http://cmillion.ru"
#property link        "cmillion@narod.ru"
#property strict
#property description "Трейлинг SL"
#property description "При открытии рыночного ордера автоматически выставляется уровень stoploss в соответствии со значением SL1 и takeprofit в соответствии со значением TP."
#property description "Для Buy ордеров:"
#property description "При увеличении цены, stoploss переустанавливается в соотвествии со значением SL1, пока не будет достигнуто заданное значение прибыли Pr (в пунктах). "
#property description "При достижении заданного значения прибыли Pr - stoploss далее переустанавливается в соотвествии со значением SL2"
#property description "При при уменьшении цены stoploss не изменяется."
#property description "Для Sell зеркально"
 //3.1 При уменьшении цены, stoploss переустанавливается в соотвествии со значением SL1, пока не будет достигнуто заданное значение прибыли Pr (в пунктах).
 //3.2 При достижении заданного значения прибыли Pr - stoploss далее переустанавливается в соотвествии со значением SL2
 //3.3 При увеличении цены stoploss не изменяется
//--------------------------------------------------------------------
extern int _TP  = 100; //уровень выставления TP, если 0, то TP не выставляется
extern int _SL1 = 10; //уровень выставления SL1, если 0, то SL1 не выставляется
extern int _SL2 = 50; //уровень выставления SL2, если 0, то SL2 не выставляется
extern int _PR  = 20; //профит при котором выставляем SL2
//--------------------------------------------------------------------
void OnTick()
{
   double STOPLEVEL=MarketInfo(Symbol(),MODE_STOPLEVEL);
   double stoploss,OSL,OTP,OOP,SL=0,sl=0,TP=0;
   int i,b=0,s=0,OT=-1;
   for (i=0; i<OrdersTotal(); i++)
   {    
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      { 
         if (OrderSymbol()==Symbol())
         { 
            OT = OrderType(); 
            OSL = NormalizeDouble(OrderStopLoss(),Digits);
            OTP = NormalizeDouble(OrderTakeProfit(),Digits);
            OOP = NormalizeDouble(OrderOpenPrice(),Digits);
            SL=OSL;TP=OTP;
            if (OT==OP_BUY)             
            {  
               b++;
               if (_TP!=0)
               {
                  if (NormalizeDouble(OOP + _TP * Point,Digits)>OOP+STOPLEVEL*Point) 
                     TP = NormalizeDouble(OOP + _TP * Point,Digits);
               } 
               else TP=0;
               if (_SL1!=0 || _SL2!=0)
               {
                  if ((Bid-OOP)/Point>_PR) stoploss = _SL2;
                  else stoploss = _SL1;
                  
                  if (stoploss>0)
                  {
                     sl = NormalizeDouble(Bid - stoploss*Point,Digits); 
                     if (sl > OSL) SL = sl;
                  }
                  if ((SL - Ask)/Point<STOPLEVEL) SL = OSL;
               }
               else SL=0;
               if (SL != OSL || TP != OTP)
               {  
                  if (!OrderModify(OrderTicket(),OOP,SL,TP,0,clrNONE)) 
                     Print("Error OrderModify <<",(GetLastError()),">> ");
               }
            }                                         
            if (OT==OP_SELL)        
            {
               s++;
               if (_TP!=0)
               {
                  if (NormalizeDouble(OOP - _TP * Point,Digits)<OOP-STOPLEVEL*Point) 
                     TP = NormalizeDouble(OOP - _TP * Point,Digits);
               }
               else TP=0;
               if (_SL1!=0 && _SL2!=0)
               {
                  if ((OOP-Ask)/Point>_PR) stoploss = _SL2;
                  else stoploss = _SL1;
                  
                  if (stoploss>0)
                  {
                     sl = NormalizeDouble(Ask + stoploss*Point,Digits); 
                     if (sl < OSL || OSL==0) SL = sl;
                  }
                  if ((Bid - SL)/Point<STOPLEVEL) SL = OSL;
               }
               if (SL != OSL || TP != OTP)
               {  
                  if (!OrderModify(OrderTicket(),OOP,SL,TP,0,clrNONE)) 
                     Print("Error OrderModify <<",(GetLastError()),">> ");
               }
            } 
         }
      }
   } 
   if (IsTesting())
   {
      if (b==0 && CheckMoneyForTrade(_Symbol,MarketInfo(Symbol(),MODE_MINLOT),1)) SendOrder(OP_BUY, MarketInfo(Symbol(),MODE_MINLOT), NormalizeDouble(Ask,Digits)); 
      if (s==0 && CheckMoneyForTrade(_Symbol,MarketInfo(Symbol(),MODE_MINLOT),-1)) SendOrder(OP_SELL, MarketInfo(Symbol(),MODE_MINLOT), NormalizeDouble(Bid,Digits)); 
   }
}
//--------------------------------------------------------------------
bool CheckMoneyForTrade(string symb,double lots, int OT)
  {
   ENUM_ORDER_TYPE type;
   if (OT==1) type=ORDER_TYPE_BUY;
   else type=ORDER_TYPE_SELL;
   double free_margin=AccountFreeMarginCheck(symb,type,lots);
   if(free_margin<0)
     {
      string oper=(type==OP_BUY)? "Buy":"Sell";
      Print("Not enough money for ", oper," ",lots, " ", symb, " Error code=",GetLastError());
      return(false);
     }
   return(true);
  }
//--------------------------------------------------------------------
bool SendOrder(int OT, double lots, double price, double sl=0, double tp=0)
{
   if (OT<2)
   {
      if (AccountFreeMarginCheck(Symbol(),OT,lots)<0) return(false);
   }
   for (int i=0; i<10; i++)
   {    
      if (OrderSend(Symbol(),OT, lots,price,100,sl,tp,NULL,0,0,clrNONE)!=-1) return(true);
      Sleep(500);
      RefreshRates();
   }
   return(false);
}
//------------------------------------------------------------------
string Strtip(int OT)
{
   switch(OT) 
   { 
   case OP_BUY:
      return("BUY"); 
   case OP_SELL:
      return("SELL"); 
   case OP_BUYSTOP:
      return("BUYSTOP"); 
   case OP_SELLSTOP:
      return("SELLSTOP"); 
   case OP_BUYLIMIT:
      return("BUYLIMIT"); 
   case OP_SELLLIMIT:
      return("SELLLIMIT"); 
   }
   return("error"); 
}
//------------------------------------------------------------------
