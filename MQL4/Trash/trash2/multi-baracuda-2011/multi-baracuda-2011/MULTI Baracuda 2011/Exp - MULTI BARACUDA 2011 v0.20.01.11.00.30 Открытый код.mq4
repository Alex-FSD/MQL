#property copyright "Copyright © 2010, BARACUDA MULTI 2011"
#property link      "http://www.expforex.com"
#include <stdlib.mqh>
// ==========================================================================================================================================================================================================
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// 
//                             ¬ Ќ ≈ Ў Ќ » ≈    ѕ ≈ – ≈ ћ ≈ Ќ Ќ џ ≈
// 
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ==========================================================================================================================================================================================================
extern string  сlose="= 1 - профит, 2 -пункты ,3 -%эквити ,4 -%баланс";
extern int     TypeofClose=2;  //закрывает  1 по балансу
extern bool CloseProfit=true;// «акрывать+
extern double prifitessss=10;
extern bool CloseLOss=false;// «акрывать-
extern double lossessss=-70;// ≈сли общий счет опуститс€ меньше чем значение - все позиции закроютс€

extern string SymbolToWork_=" Ќастройки ¬алютных пар";
extern bool AUTO_SET_SYMBOL_TO_DEPOSIT=true; // јвтоматически определ€ет сколько пар можно играть в зависимости от депозита
extern int AUTO_SET_PERCENT=50;              // % от депо на которые играем
extern string SymbolToWork_1="EURUSD";
extern string SymbolToWork_2="EURCHF";
extern string SymbolToWork_3="USDCHF";
extern string SymbolToWork_4="USDJPY";
extern string SymbolToWork_5="GBPCHF";
extern string SymbolToWork_6="GBPJPY";
extern string SymbolToWork_7="EURGBP";
extern string SymbolToWork_8="GBPUSD";
string Symbolt;
extern int MAX_GRID_COUNT=5; // ћаксимальное количество дополнительных позиций в сетке
extern int GridSetPips=10;   // –ассто€ние между €чейками в сетке
int GreedShag=5;      // ≈сли парамтеры равны 0 - то рассто€ние между €чейками = —пред * GreedShag
extern string trade_="Ќастройки торговли";
extern bool CorectStopLevelwServers=true; //  орректировка значений стопов StopLoss TakeProfit StopOrderDeltaifUSE TrailingStop на минимально возможный уровень, при этом параметры следует установить на -1
extern int Magic=777;                     // ћагический номер
extern int StopLoss=0;                    // —топлосс, 0 - не используетс€
extern int TakeProfit=0;                  // “ейкпрофит , 0 - не используетс€
extern int Slippage=0;                    // ѕроскальзывание
extern bool MarketWatch=false;            // –ежим торговли по MarketWatch true  = сначала выставл€ютс€ позиции/ордера без стопов, потом происходит модификаци€ - дл€ некоторых брокеров
extern int StopOrderDeltaifUSE=1;         // ƒистанци€ дл€ отложенных ордеров
extern bool ClosePosifChange=false;        // «акрывать позиции при обратном сигнале
bool ONlyOnePosbySignal=true;      // »грать только или бай и / или селл 1 позицией
extern string autolot_="Ќастройки автолота";
extern double Lots=0.1;                   // ‘иксирвоанный лот 
extern bool DynamicLot=true;             // ƒинамический лот
extern double LotBalancePcnt=0.1;          // % от депозита
double MinLot = 0.1;               // ћинимальный лот при расчете
extern double MaxLot = 5;                 // ћаксимальный лот при расчете
double Martin=1; // ≈сли 1 то не используетс€,  оэффициент мартина на следующую сделку после убытончой

 string Trailing_="Ќастройки трейлингстопа";
 bool TrailingStopUSE=false;        // »спользовать трейлингстоп 
 bool IfProfTrail=false;            // »спользовать только д€л профитных позиций - режим безубытка
 int TrailingStop=0;                // ƒистанци€ трейлинга = 0 - минимально допустимый
 int TrailingStep=1;                // Ўаг дистанции


int timeCheckSignal[8]; // ¬рем€ открыти€ позиции
double sl,tp; // ƒл€ вычислени€ стопов 
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

// ==========================================================================================================================================================================================================
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// 
//                             ‘ ” Ќ   ÷ » я      S T A R T ( )   
// 
// ∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆∆
// ==========================================================================================================================================================================================================
int kol_symbol;
string asd_info_start;

//—читаем
int Calculate()
{   // јвтоматически считаем сколько символов доступно дл€ торговли
if (!AUTO_SET_SYMBOL_TO_DEPOSIT )kol_symbol=8;
if (AUTO_SET_SYMBOL_TO_DEPOSIT && !IsTesting() )
{
int Lot_1_pair=MathRound(GetSizeLot("EURUSD",AUTO_SET_PERCENT,true)/(GetSizeLot("EURUSD",LotBalancePcnt,true)*(1+MAX_GRID_COUNT)));
if (Lot_1_pair>8)kol_symbol=8; else kol_symbol=Lot_1_pair;
}
if (!IsTesting() )asd_info_start="\n  оличество пар на депозит: "+kol_symbol+"\n ћакс лотов на "+kol_symbol+" пар: "+DoubleToStr(GetSizeLot("GBPUSD",AUTO_SET_PERCENT,true),3)+"\n ћакс лотов на 1 пару: "+DoubleToStr(GetSizeLot("GBPUSD",LotBalancePcnt,true)*(1+MAX_GRID_COUNT),3)+"\n";
if (IsTesting() )kol_symbol=1;
}


int start()
  {

   string asd="\n\n “оргующие пары:";
   
asd=asd+asd_info_start;
// начинаем мультиторговлю
   for(int i=1;i<=kol_symbol;i++)
     {
      if(!IsTesting())
        {
         if(i==1)Symbolt=SymbolToWork_1;
         if(i==2)Symbolt=SymbolToWork_2;
         if(i==3)Symbolt=SymbolToWork_3;
         if(i==4)Symbolt=SymbolToWork_4;
         if(i==5)Symbolt=SymbolToWork_5;
         if(i==6)Symbolt=SymbolToWork_6;
         if(i==7)Symbolt=SymbolToWork_7;
         if(i==8)Symbolt=SymbolToWork_8;
         if(Symbolt=="")continue;
        }

      if(IsTesting() && i==1)Symbolt=Symbol();
      if(IsTesting() && i!=1)continue;





      if(CorectStopLevelwServers)
        {
         if(StopOrderDeltaifUSE!=0 && StopOrderDeltaifUSE<MarketInfo(Symbolt,MODE_STOPLEVEL))StopOrderDeltaifUSE=MarketInfo(Symbolt,MODE_STOPLEVEL);
         if(TrailingStop!=0 && TrailingStop<MarketInfo(Symbol(),MODE_STOPLEVEL))TrailingStop=MarketInfo(Symbolt,MODE_STOPLEVEL);
         if(StopLoss!=0 && StopLoss<MarketInfo(Symbolt,MODE_STOPLEVEL))StopLoss=MarketInfo(Symbolt,MODE_STOPLEVEL);
         if(TakeProfit!=0 && TakeProfit<MarketInfo(Symbolt,MODE_STOPLEVEL))TakeProfit=MarketInfo(Symbolt,MODE_STOPLEVEL);
        }

      if(GridSetPips==0)GridSetPips=MarketInfo(Symbolt,MODE_SPREAD)*GreedShag;
      if(StopOrderDeltaifUSE==0)StopOrderDeltaifUSE=MarketInfo(Symbolt,MODE_SPREAD)*GreedShag;
      if(TrailingStopUSE)SimpleTrailing(Symbolt,-1,Magic);

     startCloseBlock3(Symbolt);


      if(isTradeToDayHISTORY(Symbolt,-1,Magic))asd=asd+" \n —имвол="+Symbolt+" YES trade         "+"    ол.поз.минус="+NumberOfLossPosToday(Symbolt,-1,Magic)+"    ол.поз.плюс="+NumberOfProfPosToday(Symbolt,-1,Magic)+"   Profit="+DoubleToStr(InfoProfPosToday(Symbolt,-1,Magic),2)+"   Lots="+DoubleToStr(InfoLotsPosToday(Symbolt,-1,Magic),2);
      if(!isTradeToDayHISTORY(Symbolt,-1,Magic)&& MarketInfo(Symbolt,MODE_BID)<iHigh(Symbolt,PERIOD_D1,1) && MarketInfo(Symbolt,MODE_BID)>iLow(Symbolt,PERIOD_D1,1))asd=asd+" \n —имвол="+Symbolt+" NO trade         "+"    ол.поз.минус="+NumberOfLossPosToday(Symbolt,-1,Magic)+"    ол.поз.плюс="+NumberOfProfPosToday(Symbolt,-1,Magic)+"   Profit="+DoubleToStr(InfoProfPosToday(Symbolt,-1,Magic),2)+"   Lots="+DoubleToStr(InfoLotsPosToday(Symbolt,-1,Magic),2);
      if(!isTradeToDay(Symbolt,-1,Magic)&& (MarketInfo(Symbolt,MODE_BID)>iHigh(Symbolt,PERIOD_D1,1) || MarketInfo(Symbolt,MODE_BID)<iLow(Symbolt,PERIOD_D1,1)))asd=asd+" \n —имвол="+Symbolt+" NO trade Today "+"   ол.поз.минус="+NumberOfLossPosToday(Symbolt,-1,Magic)+"    ол.поз.плюс="+NumberOfProfPosToday(Symbolt,-1,Magic)+"   Profit="+DoubleToStr(InfoProfPosToday(Symbolt,-1,Magic),2)+"   Lots="+DoubleToStr(InfoLotsPosToday(Symbolt,-1,Magic),2);
      if(timeCheckSignal[i]!=iTime(Symbolt,PERIOD_D1,0) && !isTradeToDay(Symbolt,-1,Magic) && !ExO(Symbolt,-1,Magic) && !EPs(Symbolt,-1,Magic)
      && MarketInfo(Symbolt,MODE_BID)<iHigh(Symbolt,PERIOD_D1,1) && MarketInfo(Symbolt,MODE_BID)>iLow(Symbolt,PERIOD_D1,1))
        {
         DxO(Symbolt,-1,Magic);
         double price;
         if(MarketInfo(Symbolt,MODE_BID)<iHigh(Symbolt,PERIOD_D1,1))price=iHigh(Symbolt,PERIOD_D1,1);else price=MarketInfo(Symbolt,MODE_BID);

         //¬ычисл€ем стоплосс
         if(StopLoss!=0)sl=price+StopOrderDeltaifUSE*MarketInfo(Symbolt,MODE_POINT)-StopLoss*MarketInfo(Symbolt,MODE_POINT); else sl=0;
         // ¬џчисл€ем тейкпрофит
         if(TakeProfit!=0)tp=price+StopOrderDeltaifUSE*MarketInfo(Symbolt,MODE_POINT)+TakeProfit*MarketInfo(Symbolt,MODE_POINT); else tp=0;
         if( ((ONlyOnePosbySignal && !ExO(Symbolt,OP_BUYSTOP,Magic) && !EPs(Symbolt,-1,Magic)) || !ONlyOnePosbySignal)  )
           {
            SetOrder(Symbolt,OP_BUYSTOP,GetSizeLot(Symbolt,LotBalancePcnt,DynamicLot),price+StopOrderDeltaifUSE*MarketInfo(Symbolt,MODE_POINT),sl,tp,Magic,"MultiBaracuda 2011");
            timeCheckSignal[i]=iTime(Symbolt,PERIOD_D1,0);
           }



         //¬ычисл€ем стоплосс
         if(MarketInfo(Symbolt,MODE_BID)>iLow(Symbolt,PERIOD_D1,1))price=iLow(Symbolt,PERIOD_D1,1);else price=MarketInfo(Symbolt,MODE_BID);
         if(StopLoss!=0)sl=price-StopOrderDeltaifUSE*MarketInfo(Symbolt,MODE_POINT)+StopLoss*MarketInfo(Symbolt,MODE_POINT); else sl=0;
         // ¬џчисл€ем тейкпрофит
         if(TakeProfit!=0)tp=price-StopOrderDeltaifUSE*MarketInfo(Symbolt,MODE_POINT)-TakeProfit*MarketInfo(Symbolt,MODE_POINT); else tp=0;
         //«акрываем противоположную позицию
         //+------------------------------------------------------------------+
         //ќткрываем ќрдер
         //+------------------------------------------------------------------+
         if((ONlyOnePosbySignal && !ExO(Symbolt,OP_SELLSTOP,Magic) && !EPs(Symbolt,-1,Magic)) || !ONlyOnePosbySignal)
           {
            SetOrder(Symbolt,OP_SELLSTOP,GetSizeLot(Symbolt,LotBalancePcnt,DynamicLot),price-StopOrderDeltaifUSE*MarketInfo(Symbolt,MODE_POINT),sl,tp,Magic,"MultiBaracuda 2011");
            timeCheckSignal[i]=iTime(Symbolt,PERIOD_D1,0);
           }

        }

      if(EPs(Symbolt,OP_BUY,Magic)) {DxO(Symbolt,-1,Magic);}
      if(EPs(Symbolt,OP_SELL,Magic)){DxO(Symbolt,-1,Magic);}




      if(EPs(Symbolt,OP_BUY,Magic)&& EPsCOUNT(Symbolt,OP_BUY,Magic)<MAX_GRID_COUNT  
      &&  MarketInfo(Symbolt,MODE_BID)<GetMinPriceFromOpenPos(Symbolt,OP_BUY,Magic)-GridSetPips*MarketInfo(Symbolt,MODE_POINT)-MarketInfo(Symbolt,MODE_SPREAD)*MarketInfo(Symbolt,MODE_POINT)
      ){DxO(Symbolt,OP_SELLSTOP,Magic); EPs(Symbolt,OP_BUY,Magic);  Print(Symbolt+" Grid ticket:"+OrderTicket());
            
            //¬ычисл€ем стоплосс
            if(StopLoss!=0)sl=MarketInfo(Symbolt,MODE_BID)-StopLoss*MarketInfo(Symbolt,MODE_POINT); else sl=0;
            // ¬џчисл€ем тейкпрофит
            if(TakeProfit!=0)tp=MarketInfo(Symbolt,MODE_ASK)+TakeProfit*MarketInfo(Symbolt,MODE_POINT); else tp=0;
            //+------------------------------------------------------------------+
            //«акрываем противоположную позицию
            //+------------------------------------------------------------------+
            if(ClosePosifChange){CPD(Symbolt,OP_SELL,Magic);DxO(Symbolt,OP_SELLSTOP,Magic);}

            //+------------------------------------------------------------------+
            //ќткрываем позицию
            //+------------------------------------------------------------------+

            OPs(Symbolt,OP_BUY,GetSizeLot(Symbolt,LotBalancePcnt,DynamicLot),sl,tp,Magic,"MultiBaracuda 2011-Grid");
      
      }
      
      
      
      if(EPs(Symbolt,OP_SELL,Magic)&& EPsCOUNT(Symbolt,OP_SELL,Magic)<MAX_GRID_COUNT 
      && MarketInfo(Symbolt,MODE_ASK)>GetMaxPriceFromOpenPos(Symbolt,OP_SELL,Magic)+GridSetPips*MarketInfo(Symbolt,MODE_POINT)+MarketInfo(Symbolt,MODE_SPREAD)*MarketInfo(Symbolt,MODE_POINT)
      ){DxO(Symbolt,OP_BUYSTOP,Magic);  EPs(Symbolt,OP_SELL,Magic); Print(Symbolt+" Grid ticket:"+OrderTicket());
       //+------------------------------------------------------------------+
            // ѕровер€ем если не используем отложки то
            //+------------------------------------------------------------------+
            //¬ычисл€ем стоплосс
            if(StopLoss!=0)sl=MarketInfo(Symbolt,MODE_ASK)+StopLoss*MarketInfo(Symbolt,MODE_POINT); else sl=0;
            // ¬џчисл€ем тейкпрофит
            if(TakeProfit!=0)tp=MarketInfo(Symbolt,MODE_BID)-TakeProfit*MarketInfo(Symbolt,MODE_POINT); else tp=0;
            //«акрываем противоположную позицию
            if(ClosePosifChange){CPD(Symbolt,OP_BUY,Magic);DxO(Symbolt,OP_BUYSTOP,Magic);}

            //+------------------------------------------------------------------+
            //ќткрываем позицию
            //+------------------------------------------------------------------+
            OPs(Symbolt,OP_SELL,GetSizeLot(Symbolt,LotBalancePcnt,DynamicLot),sl,tp,Magic,"MultiBaracuda 2011-Grid");     
      
      
      }




     }
   asd=asd+"\n\n ќбщее: \n  оличество убыточных позиций сегодн€="+NumberOfLossPosToday("",-1,Magic);
   asd=asd+"\n  оличество прибыльных позиций сегодн€="+NumberOfProfPosToday("",-1,Magic);
   asd=asd+"\n –езультат торгов сегодн€="+DoubleToStr(InfoProfPosToday("",-1,Magic),2);
   asd=asd+"\n «акрыто лотов сегодн€="+DoubleToStr(InfoLotsPosToday("",-1,Magic),2);

   Comment(asd);

   return(0);
  }

bool DxO(string sy="",int op=-1,int mn=-1,datetime ot=0)
  {
   int i,k=OrdersTotal(),ty;
   string Autor=" јвтор функции дл€ шаблона : www.expforex.at.ua";

   if(sy=="0") sy=Symbol();
   for(i=k-1;i>=0;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         ty=OrderType();
         if(ty>1 && ty<6)
           {
            if((OrderSymbol()==sy || sy=="") && (op<0 || ty==op))
              {
               if(mn<0 || OrderMagicNumber()==mn)
                 {
                  if(ot<=OrderOpenTime()) {OrderDelete(OrderTicket(),0);}
                 }
              }
           }
        }
     }
   return(False);
  }
void ModifyOrder(double pp=-1,double sl=0,double tp=0,datetime ex=0)
  {
   bool   fm;
   double op,pa,pb,os,ot;
   int    dg=MarketInfo(OrderSymbol(),MODE_DIGITS),er,it;
   string Autor=" јвтор функции дл€ шаблона : www.expforex.at.ua";

   if(pp<=0) pp=OrderOpenPrice();
   if(sl<0 ) sl=OrderStopLoss();
   if(tp<0 ) tp=OrderTakeProfit();

   pp=NormalizeDouble(pp, dg);
   sl=NormalizeDouble(sl, dg);
   tp=NormalizeDouble(tp, dg);
   op=NormalizeDouble(OrderOpenPrice() , dg);
   os=NormalizeDouble(OrderStopLoss()  , dg);
   ot=NormalizeDouble(OrderTakeProfit(), dg);

   if(pp!=op || sl!=os || tp!=ot)
     {
      for(it=1; it<=3; it++)
        {
         if(!IsTesting() && (!IsExpertEnabled() || IsStopped())) break;
         while(!IsTradeAllowed()) Sleep(5000);
         RefreshRates();
         fm=OrderModify(OrderTicket(),pp,sl,tp,ex);
         if(fm)
           {
            break;
              } else {
            er=GetLastError();
            pa=MarketInfo(OrderSymbol(), MODE_ASK);
            pb=MarketInfo(OrderSymbol(), MODE_BID);
            Sleep(1000*10);
           }
        }
     }
  }

bool ExO(string sy="",int op=-1,int mn=-1,datetime ot=0)
  {
   int i,k=OrdersTotal(),ty;
   string Autor=" јвтор функции дл€ шаблона : www.expforex.at.ua";

   if(sy=="0") sy=Symbol();
   for(i=0;i<k;i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         ty=OrderType();
         if(ty>1 && ty<6)
           {
            if((OrderSymbol()==sy || sy=="") && (op<0 || ty==op))
              {
               if(mn<0 || OrderMagicNumber()==mn)
                 {
                  if(OrderCloseTime()==0) if(ot<=OrderOpenTime()) return(True);
                 }
              }
           }
        }
     }
   return(False);
  }

int SetOrder(string sy,int op,double ll,double pp,
             double sl=0,double tp=0,int mn=0,string lsComm="")
  {
   color    clOpen;
   datetime ot;
   double   pa,pb,mp;
   int      err,it,ticket,msl;
   string Autor=" јвтор функции дл€ шаблона : www.expforex.at.ua";

   if(sy=="" || sy=="0") sy=Symbol();
   msl=MarketInfo(sy,MODE_STOPLEVEL);

   for(it=1; it<=5; it++)
     {
      if(!IsTesting() && (!IsExpertEnabled() || IsStopped()))
        {
         Print("SetOrder(): ќстановка работы функции");
         break;
        }
      while(!IsTradeAllowed()) Sleep(5000);
      RefreshRates();
      ot=TimeCurrent();
      if(!MarketWatch)ticket=OrderSend(sy,op,ll,NormalizeDouble(pp,MarketInfo(sy,MODE_DIGITS)),Slippage,NormalizeDouble(sl,MarketInfo(sy,MODE_DIGITS)),NormalizeDouble(tp,MarketInfo(sy,MODE_DIGITS)),lsComm,mn,0,clOpen);
      if(MarketWatch)

        {
         ticket=OrderSend(sy,op,ll,NormalizeDouble(pp,MarketInfo(sy,MODE_DIGITS)),Slippage,0,0,lsComm,mn,0,clOpen);
         if(SBT(ticket)) ModifyOrder(-1,sl,tp);
        }

      if(ticket>0)
        {

         return(ticket);
         break;
           } else {
         err=GetLastError();
         if(err==128 || err==142 || err==143)
           {
            Sleep(1000*66);

            continue;
           }
         mp=MarketInfo(sy, MODE_POINT);
         pa=MarketInfo(sy, MODE_ASK);
         pb=MarketInfo(sy, MODE_BID);
         if(pa==0 && pb==0) Alert("SetOrder(): ѕроверьте в обзоре рынка наличие символа "+sy);
         // Ќеправильные стопы
         if(err==130)
           {
            switch(op)
              {
               case OP_BUYLIMIT:
                  if(pp>pa-msl*mp) pp=pa-msl*mp;
                  if(sl>pp-(msl+1)*mp) sl=pp-(msl+1)*mp;
                  if(tp>0 && tp<pp+(msl+1)*mp) tp=pp+(msl+1)*mp;
                  break;
               case OP_BUYSTOP:
                  if(pp<pa+(msl+1)*mp) pp=pa+(msl+1)*mp;
                  if(sl>pp-(msl+1)*mp) sl=pp-(msl+1)*mp;
                  if(tp>0 && tp<pp+(msl+1)*mp) tp=pp+(msl+1)*mp;
                  break;
               case OP_SELLLIMIT:
                  if(pp<pb+msl*mp) pp=pb+msl*mp;
                  if(sl>0 && sl<pp+(msl+1)*mp) sl=pp+(msl+1)*mp;
                  if(tp>pp-(msl+1)*mp) tp=pp-(msl+1)*mp;
                  break;
               case OP_SELLSTOP:
                  if(pp>pb-msl*mp) pp=pb-msl*mp;
                  if(sl>0 && sl<pp+(msl+1)*mp) sl=pp+(msl+1)*mp;
                  if(tp>pp-(msl+1)*mp) tp=pp-(msl+1)*mp;
                  break;
              }
            Alert("SetOrder(): —корректированы ценовые уровни"+sy+"--op-"+op+"--ll-"+ll+"--pp-"+pp+"---"+Slippage+"--sl-"+sl+"--tp-"+tp+"---"+lsComm+"---"+mn+"---"+0+"---"+clOpen);

           }
         // Ѕлокировка работы советника
         if(err==2 || err==64 || err==65 || err==133)
           {
            break;
           }
         // ƒлительна€ пауза
         if(err==4 || err==131 || err==132)
           {
            Sleep(1000*300); break;
           }
         // —лишком частые запросы (8) или слишком много запросов (141)
         if(err==8 || err==141) Sleep(1000*100);
         if(err==139 || err==140 || err==148) break;
         // ќжидание освобождени€ подсистемы торговли
         if(err==146) while(IsTradeContextBusy()) Sleep(1000*11);
         // ќбнуление даты истечени€
         if(err!=135 && err!=138) Sleep(1000*7.7);
        }
     }
  }


bool SBT(int ti,string sy="",int op=-1,int mn=-1)
  {
   int i,k=OrdersTotal();
   string Autor=" јвтор функции дл€ шаблона : www.expforex.at.ua";

   if(sy=="0") sy=Symbol();
   for(i=0;i<k;i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if((OrderSymbol()==sy || sy=="") && (op<0 || OrderType()==op))
           {
            if((mn<0 || OrderMagicNumber()==mn) && OrderTicket()==ti) return(True);
           }
        }
     }
   return(False);
  }

int OPs(string sy,int op,double ll,double sl=0,double tp=0,int mn=0,string coomment="")
  {
   color    clOpen;
   datetime ot;
   double   pp,pa,pb;
   int      dg,err,it,ticket=0;
   string   lsComm="";
   if(sy=="" || sy=="0") sy=Symbol();
   if(op==OP_BUY) clOpen=Red; else clOpen=Green;
   string Autor=" јвтор функции дл€ шаблона : www.expforex.at.ua";

   for(it=1;it<=3;it++)
     {
      if(!IsTesting() && (!IsExpertEnabled() || IsStopped())) break;
      while(!IsTradeAllowed()) Sleep(5000);
      RefreshRates();
      dg=MarketInfo(sy, MODE_DIGITS);
      pa=MarketInfo(sy, MODE_ASK);
      pb=MarketInfo(sy, MODE_BID);
      if(op==OP_BUY) pp=pa; else pp=pb;
      pp=NormalizeDouble(pp, dg);
      ot=TimeCurrent();
      if(!MarketWatch) ticket=OrderSend(sy,op,ll,pp,1,sl,tp,coomment,mn,0,clOpen);
      if(MarketWatch)

        {
         ticket=OrderSend(sy,op,ll,pp,1,0,0,coomment,mn,0,clOpen);
         if(SBT(ticket)) ModifyOrder(-1,sl,tp);
        }

      if(ticket>0)
        {
         break;
           } else {
         err=GetLastError();
         if(err==128 || err==142 || err==143)
           {
            Sleep(1000*66.666);
           }
         // ¬ывод сообщени€ об ошибке
         Alert("Error(",err,") opening position: ",ErrorDescription(err),", try ",it);
         Alert("Ask=",pa," Bid=",pb," sy=",sy," ll=",ll," op=",op,
               " pp=",pp," sl=",sl," tp=",tp," mn=",mn);
         if(pa==0 && pb==0) Alert("ѕроверьте в ќбзоре рынка наличие символа "+sy);
         // Ѕлокировка работы советника
         if(err==2 || err==64 || err==65 || err==133)
           {
            break;
           }
         // ƒлительна€ пауза
         if(err==4 || err==131 || err==132)
           {
            Sleep(1000*300); break;
           }
         if(err==140 || err==148 || err==4110 || err==4111) break;
         if(err==141) Sleep(1000*100);
         if(err==145) Sleep(1000*17);
         if(err==146) while(IsTradeContextBusy()) Sleep(1000*11);
         if(err!=135) Sleep(1000*7.7);
        }
     }
   return(ticket);
  }

bool EPs(string sy="",int op=-1,int mn=-1)
  {
   string Autor=" јвтор функции дл€ шаблона : www.expforex.at.ua";

   int i,k=OrdersTotal();

   for(i=0;i<k;i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==sy)
           {
            if(OrderType()==OP_BUY || OrderType()==OP_SELL)
              {
               if(op<0 || OrderType()==op)
                 {
                  if(mn<0 || OrderMagicNumber()==mn)
                    {
                     if(OrderCloseTime()==0)return(True);
                    }
                 }
              }
           }
        }
     }
   return(False);
  }
  
  
  

int EPsCOUNT(string sy="",int op=-1,int mn=-1)
  {
   string Autor=" јвтор функции дл€ шаблона : www.expforex.at.ua";

   int i,k=OrdersTotal();
   int count;
   for(i=0;i<k;i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==sy)
           {
            if(OrderType()==OP_BUY || OrderType()==OP_SELL)
              {
               if(op<0 || OrderType()==op)
                 {
                  if(mn<0 || OrderMagicNumber()==mn)
                    {
                     if(OrderCloseTime()==0)count++;
                    }
                 }
              }
           }
        }
     }
   return(count);
  }  
  
  
double lastlot;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetSizeLot(string Symbolt2="",int LotBalancePcnt2=0, bool DynamicLot2=true) //‘ункци€ возвращает значение лотов, 
  {
   string Autor=" јвтор функции дл€ шаблона : www.expforex.at.ua";

   string Valdepo=AccountCurrency();
//если включен ћћ то значение лотов, 
   double Lot2,MinLots,MaxLots;
   int lotdig;
      int lotdigits;
   double minlot = MarketInfo( Symbolt2, MODE_MINLOT);
   if(minlot>=1 ) lotdigits = 0;
   if(minlot>=0.1 && minlot<1 ) lotdigits = 1;
   if(minlot>=0.01 && minlot<0.1 ) lotdigits = 2;
   if(minlot>=0.001 && minlot<0.01 ) lotdigits = 3;

   if(MarketInfo(Symbolt2,MODE_LOTSTEP)==0.01)lotdig=2; else lotdig=1;
   if(Valdepo=="USD")
     {
      if(StringSubstr(Symbolt2,0,3)=="USD")Lot2=NormalizeDouble(AccountFreeMargin()*LotBalancePcnt2*AccountLeverage()/100/MarketInfo(Symbolt2,MODE_LOTSIZE),lotdigits);
      else if(StringSubstr(Symbolt2,3,3)=="USD")Lot2=NormalizeDouble(AccountFreeMargin()*LotBalancePcnt2*AccountLeverage()/Ask/100/MarketInfo(Symbolt2,MODE_LOTSIZE),lotdigits);
      else
        {
         double pr=MarketInfo(StringSubstr(Symbolt2,0,3)+"USD",MODE_ASK);
         if(pr!=0)Lot2=NormalizeDouble(AccountFreeMargin()*LotBalancePcnt2*AccountLeverage()/pr/100/MarketInfo(Symbolt2,MODE_LOTSIZE),lotdigits);
         else Lot2=NormalizeDouble(AccountFreeMargin()*LotBalancePcnt2*AccountLeverage()/100/MarketInfo(Symbolt2,MODE_LOTSIZE),lotdigits);
        }
     }
   if(Valdepo=="EUR")
     {
      if(StringSubstr(Symbolt2,0,3)=="EUR")Lot2=NormalizeDouble(AccountFreeMargin()*LotBalancePcnt2*AccountLeverage()/100/MarketInfo(Symbolt2,MODE_LOTSIZE),lotdigits);
      else
        {
         pr=MarketInfo("EUR"+StringSubstr(Symbolt2,0,3),MODE_BID);
         if(pr!=0)Lot2=NormalizeDouble(AccountFreeMargin()*LotBalancePcnt2*AccountLeverage()*pr/100/MarketInfo(Symbolt2,MODE_LOTSIZE),lotdigits);
         else Lot2=NormalizeDouble(AccountFreeMargin()*LotBalancePcnt2*AccountLeverage()/100/MarketInfo(Symbolt2,MODE_LOTSIZE),lotdigits);
        }
     }
     
   
   
   
   MinLots=minlot;
   MaxLots=MaxLot;
   if(!DynamicLot2)Lot2=Lots;
   if(Lot2 < MinLots) Lot2 = MinLots;
   if(Lot2 > MaxLots) Lot2 = MaxLots;
   return(NormalizeDouble(Lot2,lotdigits));
  }

void CPBS()
  {
   bool   fc;
   color  clClose;
   double ll,pa,pb,pp;
   int    err,it;
   string Autor=" јвтор функции дл€ шаблона : www.expforex.at.ua";

   if(OrderType()==OP_BUY || OrderType()==OP_SELL)
     {
      for(it=1; it<=5; it++)
        {
         if(!IsTesting() && (!IsExpertEnabled() || IsStopped())) break;
         while(!IsTradeAllowed()) Sleep(5000);
         RefreshRates();
         pa=MarketInfo(OrderSymbol(), MODE_ASK);
         pb=MarketInfo(OrderSymbol(), MODE_BID);
         if(OrderType()==OP_BUY)
           {
            pp=pb;
              } else {
            pp=pa;
           }
         ll=OrderLots();
         fc=OrderClose(OrderTicket(), ll, pp, 1, clClose);
         if(fc)
           {
            break;
              } else {
            err=GetLastError();
            if(err==146) while(IsTradeContextBusy()) Sleep(1000*11);
            Sleep(1000*5);
           }
        }
     }
  }

void CPD(string sy="",int op=-1,int mn=-1)
  {
   int i,k=OrdersTotal();
   string Autor=" јвтор функции дл€ шаблона : www.expforex.at.ua";

   if(sy=="0") sy=Symbol();
   for(i=k-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if((OrderSymbol()==sy || sy=="") && (op<0 || OrderType()==op))
           {
            if(OrderType()==OP_BUY || OrderType()==OP_SELL)
              {
               if(mn<0 || OrderMagicNumber()==mn) CPBS();
              }
           }
        }
     }
  }

void SimpleTrailing(string sy="",int op=-1,int mn=-1)
  {
   double po,pp;
   int    i,k=OrdersTotal();
   string Autor=" јвтор функции дл€ шаблона : www.expforex.at.ua";

   if(sy=="0") sy=Symbol();
   if(TrailingStop==0)TrailingStop=MarketInfo(Symbol(),MODE_STOPLEVEL);
   for(i=0;i<k;i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if((OrderSymbol()==sy || sy=="") && (op<0 || OrderType()==op))
           {
            po=MarketInfo(OrderSymbol(),MODE_POINT);
            if(mn<0 || OrderMagicNumber()==mn)
              {
               if(OrderType()==OP_BUY)
                 {
                  pp=MarketInfo(OrderSymbol(),MODE_BID);
                  if((!IfProfTrail && OrderProfit()>0) || pp-OrderOpenPrice()>TrailingStop*po)
                    {
                     if(OrderStopLoss()<pp-(TrailingStop+TrailingStep-1)*po)
                       {
                        ModifyOrder(-1,pp-TrailingStop*po,-1);
                       }
                    }
                 }
               if(OrderType()==OP_SELL)
                 {
                  pp=MarketInfo(OrderSymbol(),MODE_ASK);
                  if((!IfProfTrail && OrderProfit()>0) || OrderOpenPrice()-pp>TrailingStop*po)
                    {
                     if(OrderStopLoss()>pp+(TrailingStop+TrailingStep-1)*po || OrderStopLoss()==0)
                       {
                        ModifyOrder(-1,pp+TrailingStop*po,-1);
                       }
                    }
                 }
              }
           }
        }
     }
  }
#property link      "http://www.expforex.com"
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   Stamp();
//----
Calculate();


if (Digits==5 || Digits==3)
{
StopOrderDeltaifUSE=StopOrderDeltaifUSE*10;
GridSetPips=GridSetPips*10;

if (TypeofClose==2 && prifitessss>0)prifitessss=prifitessss*10;
if (TypeofClose==2 && lossessss<0)lossessss=lossessss*10;
}

   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Stamp()
  {
   ObjectCreate("Original",OBJ_LABEL,0,0,0);
   ObjectSetText("Original"," MULTI BARACUDA 2011 - www.expforex.com ",12,"Arial Bold",Chartreuse);
   ObjectSet("Original",OBJPROP_CORNER,0);
   ObjectSet("Original",OBJPROP_XDISTANCE,0);
   ObjectSet("Original",OBJPROP_YDISTANCE,10);

  }
//+------------------------------------------------------------------+


#property link      "http://www.expforex.com"
//+------------------------------------------------------------------+


double price;
int    ordertype;
bool   result,first;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int startCloseBlock3(string Symbo="")
  {
   double ask,bid,open,Prc,Prc2,point,buy_e,sell_e,Equity,_close;
   int Pips,buy_p,sell_p,flag=0;
   string com,mg;
   string  sy;
   sy=Symbo;
   if(Symbo=="")sy=Symbol();
//-------------------------------смотрим открытые----------------------------------------------------------

   for(int Q=0;Q<OrdersTotal();Q++)
     {
      if(OrderSelect(Q,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol()==sy)
           {
            if(OrderMagicNumber()==Magic)
              {
               if(OrderType()==OP_SELL)
                 {
                  point=MarketInfo(OrderSymbol(),MODE_POINT);
                  ask=MathRound(MarketInfo(OrderSymbol(),MODE_ASK)/point);
                  open=MathRound(OrderOpenPrice()/point);
                  sell_e+=OrderProfit()+OrderSwap();
                  sell_p+=(open-ask);
                 }
               if(OrderType()==OP_BUY)
                 {
                  point=MarketInfo(OrderSymbol(),MODE_POINT);
                  bid=MathRound(MarketInfo(OrderSymbol(),MODE_BID)/point);
                  open=MathRound(OrderOpenPrice()/point);
                  buy_e+=OrderProfit()+OrderSwap();
                  buy_p+=(bid-open);
                 }
              }
            //-----------------------------------считаем--------------------------------------------------------------- 
            Pips=(buy_p+sell_p);
            Equity=(buy_e+sell_e);
            Prc=NormalizeDouble((Equity*100)/AccountEquity(),2);
            Prc2=NormalizeDouble((Equity*100)/AccountBalance(),2);
            //----------------------------------выбираем---------------------------------------------------------------
            switch(TypeofClose)
              {
               case 1: _close=Equity; com = "балансу"; break;
               case 2: _close=Pips; com = "пунктам"; break;
               case 3: _close=Prc; com = "%эквити"; break;
               case 4: _close=Prc2; com = "%баланс"; break;
               default: com="Ќ≈ ” ј«јЌќ"; break;
              }
            //-------------------- омментарии--------------------------------------------------------------------------- 

           }
     }
     
//---------------------------услови€ дл€ закрыти€--------------------------------------------------------------------- 
   if(_close>=prifitessss && CloseProfit){  flag=1; }
   if(_close<=lossessss && CloseLOss){  flag=1; }
//-----------------------------все позиции закрываем------------------------------------------------------------------
   if(flag>0)
     {
      CPD(Symbo,-1,Magic);
     }

   return(0);
  }
int NumberOfLossPosToday(string sy="",int op=-1,int mn=-1) 
  {
   datetime t;
   int      i,k=OrdersHistoryTotal(),kp=0;

   if(sy=="0") sy=Symbol();
   for(i=0; i<k; i++) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)) 
        {
         if(OrderSymbol()==sy || sy=="") 
           {
            if(OrderType()==OP_BUY || OrderType()==OP_SELL) 
              {
               if(op<0 || OrderType()==op) 
                 {
                  if(mn<0 || OrderMagicNumber()==mn) 
                    {
                     t=OrderCloseTime();
                     if(Year()==TimeYear(t) && DayOfYear()==TimeDayOfYear(t)) 
                       {
                        if(OrderProfit()<0) kp++;
                       }
                    }
                 }
              }
           }
        }
     }
   return(kp);
  }
int NumberOfProfPosToday(string sy="",int op=-1,int mn=-1) 
  {
   datetime t;
   int      i,k=OrdersHistoryTotal(),kp=0;

   if(sy=="0") sy=Symbol();
   for(i=0; i<k; i++) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)) 
        {
         if(OrderSymbol()==sy || sy=="") 
           {
            if(OrderType()==OP_BUY || OrderType()==OP_SELL) 
              {
               if(op<0 || OrderType()==op) 
                 {
                  if(mn<0 || OrderMagicNumber()==mn) 
                    {
                     t=OrderCloseTime();
                     if(Year()==TimeYear(t) && DayOfYear()==TimeDayOfYear(t)) 
                       {
                        if(OrderProfit()>0) kp++;
                       }
                    }
                 }
              }
           }
        }
     }
   return(kp);
  }
double InfoProfPosToday(string sy="",int op=-1,int mn=-1) 
  {
   datetime t;
   int      i,k=OrdersHistoryTotal(),kp=0;
   double prof;
   if(sy=="0") sy=Symbol();
   for(i=0; i<k; i++) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)) 
        {
         if(OrderSymbol()==sy || sy=="") 
           {
            if(OrderType()==OP_BUY || OrderType()==OP_SELL) 
              {
               if(op<0 || OrderType()==op) 
                 {
                  if(mn<0 || OrderMagicNumber()==mn) 
                    {
                     t=OrderCloseTime();
                     if(Year()==TimeYear(t) && DayOfYear()==TimeDayOfYear(t)) 
                       {
                        prof=prof+OrderProfit()+OrderSwap();
                       }
                    }
                 }
              }
           }
        }
     }
   return(prof);
  }
double InfoLotsPosToday(string sy="",int op=-1,int mn=-1) 
  {
   datetime t;
   int      i,k=OrdersHistoryTotal(),kp=0;
   double prof;
   if(sy=="0") sy=Symbol();
   for(i=0; i<k; i++) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)) 
        {
         if(OrderSymbol()==sy || sy=="") 
           {
            if(OrderType()==OP_BUY || OrderType()==OP_SELL) 
              {
               if(op<0 || OrderType()==op) 
                 {
                  if(mn<0 || OrderMagicNumber()==mn) 
                    {
                     t=OrderCloseTime();
                     if(Year()==TimeYear(t) && DayOfYear()==TimeDayOfYear(t)) 
                       {
                        prof=prof+OrderLots();
                       }
                    }
                 }
              }
           }
        }
     }
   return(prof);
  }

bool isTradeToDay(string sy="",int op=-1,int mn=-1) 
  {
   int i,k=OrdersHistoryTotal();

   if(sy=="0") sy=Symbol();
   for(i=0; i<k; i++) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)) 
        {
         if(OrderSymbol()==sy || sy=="") 
           {
            if(OrderType()==OP_BUY || OrderType()==OP_SELL) 
              {
               if(op<0 || OrderType()==op) 
                 {
                  if(mn<0 || OrderMagicNumber()==mn) 
                    {
                     if(TimeDay(OrderOpenTime())==Day()
                        && TimeMonth(OrderOpenTime())==Month()
                        && TimeYear(OrderOpenTime())==Year()) return(True);
                    }
                 }
              }
           }
        }
     }
   k=OrdersTotal();
   for(i=0; i<k; i++) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) 
        {
         if(OrderSymbol()==sy || sy=="") 
           {
            if(OrderType()==OP_BUY || OrderType()==OP_SELL) 
              {
               if(op<0 || OrderType()==op) 
                 {
                  if(mn<0 || OrderMagicNumber()==mn) 
                    {
                     if(TimeDay(OrderOpenTime())==Day()
                        && TimeMonth(OrderOpenTime())==Month()
                        && TimeYear(OrderOpenTime())==Year()) return(True);
                    }
                 }
              }
           }
        }
     }
   return(False);
  }
  
  
bool isTradeToDayHISTORY(string sy="",int op=-1,int mn=-1) 
  {
   int i,k=OrdersHistoryTotal();

   if(sy=="0") sy=Symbol();
   for(i=0; i<k; i++) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)) 
        {
         if(OrderSymbol()==sy || sy=="") 
           {
            if(OrderType()==OP_BUY || OrderType()==OP_SELL) 
              {
               if(op<0 || OrderType()==op) 
                 {
                  if(mn<0 || OrderMagicNumber()==mn) 
                    {
                     if(TimeDay(OrderOpenTime())==Day()
                        && TimeMonth(OrderOpenTime())==Month()
                        && TimeYear(OrderOpenTime())==Year()) return(True);
                    }
                 }
              }
           }
        }
     }
     return(False);
  }
  
  
  
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetMinPriceFromOpenPos(string sy="",int op=-1,int mn=-1) 
  {
   double l=0;
   int    i,k=OrdersTotal();

   if(sy=="0") sy=Symbol();
   for(i=0; i<k; i++) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) 
        {
         if(OrderSymbol()==sy || sy=="") 
           {
            if(OrderType()==OP_BUY || OrderType()==OP_SELL) 
              {
               if(op<0 || OrderType()==op) 
                 {
                  if(mn<0 || OrderMagicNumber()==mn) 
                    {
                     if(l==0 || l>OrderOpenPrice()) l=OrderOpenPrice();
                    }
                 }
              }
           }
        }
     }
   return(l);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetMaxPriceFromOpenPos(string sy="",int op=-1,int mn=-1) 
  {
   double l=0;
   int    i,k=OrdersTotal();

   if(sy=="0") sy=Symbol();
   for(i=0; i<k; i++) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) 
        {
         if(OrderSymbol()==sy || sy=="") 
           {
            if(OrderType()==OP_BUY || OrderType()==OP_SELL) 
              {
               if(op<0 || OrderType()==op) 
                 {
                  if(mn<0 || OrderMagicNumber()==mn) 
                    {
                     if(l<OrderOpenPrice()) l=OrderOpenPrice();
                    }
                 }
              }
           }
        }
     }
   return(l);
  }
  

