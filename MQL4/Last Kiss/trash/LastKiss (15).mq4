//+------------------------------------------------------------------+
//|                                                     LastKiss.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

input int BuyRight_input = 1; //Вкл/Выкл робота правый ЛК на покупку (1 = Вкл, 0 = Выкл)
input int BuyLeft_input = 0; //Вкл/Выкл робота левый ЛК на покупку (1 = Вкл, 0 = Выкл)
input int SellRight_input = 0; //Вкл/Выкл робота правый ЛК на продажу (1 = Вкл, 0 = Выкл)
input int SellLeft_input = 0; //Вкл/Выкл робота левый ЛК на продажу (1 = Вкл, 0 = Выкл)
input string DelimiterLine1 = "======================================================================================================================================================";//==================================================

input double TP1_input = 2.61; //Тейкпрофит для правого ЛК в покупку(2.00 2.61 4.23)
input double TP2_input = 4.23; //Тейк, при пробитии 161 уровня (4.23 6.85 11.09)
input double SL_input = 0.618; //Стоп лосс для правого ЛК в покупку  (0.00 0.14 0.5 0.618)
input string DelimiterLine2 = "======================================================================================================================================================";//==================================================

input double BL_TP1_input = 2.61; //Тейкпрофит для левого ЛК в покупку (2.00 2.61 4.23)
input double BL_TP2_input = 4.23; //Тейк, при пробитии 161 уровня (4.23 6.85 11.09)
input double BL_SL_input = 0.00; //Стоп лосс для левого ЛК в покупку (0.00 0.14 0.5 0.618)
input string DelimiterLine3 = "======================================================================================================================================================";//==================================================

input int DynamicLots_input = 1; //Использовать динамичный лот (1 = Вкл, 0 = Выкл)
input double FixLots_input = 0.01; //Если динамичный лот выкл, какой лот использовать
input string DelimiterLine4 = "======================================================================================================================================================";//==================================================

input int BR_Safe_input = 0; //Метод сейфа для 1 Робота (0 = Нет, 1 = Да, 2 = Да х2 Лотом) 
input int BL_Safe_input = 0; //Метод сейфа для 2 Робота (0 = Нет, 1 = Да, 2 = Да х2 Лотом) 
input double BR_SafeTP_input = 1.61; //Тейкпрофит для сейфа 1 (1.61 2.00 2.61)
input double BL_SafeTP_input = 1.61; //Тейкпрофит для сейфа 2 (1.61 2.00 2.61)
input double BR_SafeSL_input = 0.618; //Стоп лосс для сейфа 1 (0.00 0.14 0.5 0.618)
input double BL_SafeSL_input = 0.00; //Стоп лосс для сейфа 2 (0.00 0.14 0.5 0.618)
input string DelimiterLine5 = "======================================================================================================================================================";//==================================================

input int Moving_input = 0; //Использовать мувинг (0 = Нет, 1 = Да)
input int MovingPeriod_input = 0; //Период мувинга
input int MovingShift_input = 0; //Сдвиг мувинга
input string DelimiterLine6 = "======================================================================================================================================================";//==================================================

input int RiskManagment_input = 0; //Закрытие убыточных сделок (1 = Вкл, 0 = Выкл)
input double RiskManagmentPercent_input = 0.2; //Допустимый убыток сделки, % от депозита (0.2 = 20%)
input string DelimiterLine7 = "======================================================================================================================================================";//==================================================

input int BR_MagicNumber = 28012021; //Не нужно трогать
input int BL_MagicNumber = 29012021; //Не нужно трогать
input int SR_MagicNumber = 30012021; //Не нужно трогать
input int SL_MagicNumber = 31012021; //Не нужно трогать

int res;

double Lots = 0.01;

double BR_Low0 = 0.00;
double BR_High100 = 0.00;
double BR_TP = 0.00;
double BR_SL = 0.00;
double BR_CountPips = 0.00;
double BR_Level161 = 0.00;

double BL_Low0 = 0;
double BL_High100 = 0; 
double BL_TP = 0;
double BL_SL = 0;  
double BL_CountPips = 0.00;
double BL_Level161 = 0.00;


void CalculateLots()
  {
      if (DynamicLots_input == 1)
         {
            if (AccountBalance() <= 1000) 
               {
                  Lots = 0.01;
               }
               else
                  {
                     Lots = AccountBalance()/1000*0.01;
                  }
         }
         else
            {
               Lots = FixLots_input; 
            }
  }

void RiskManagment()
  {   
     for(int i=0; i<OrdersTotal(); i++)
     {
         if ((OrderSelect(i, SELECT_BY_POS,MODE_TRADES) == true) && ((OrderMagicNumber() == BR_MagicNumber) || (OrderMagicNumber() == BL_MagicNumber)))
            if ((OrderProfit() < 0) && ((OrderProfit() * (-1))) > (AccountBalance()*RiskManagmentPercent_input))
            {
               res = OrderClose(OrderTicket(),OrderLots(),Bid,1000,0);      
            }
     }
  }

void OnBuyRightOrder()
  {
      if (BR_Low0 == 0)
         {  
            if (Close[1]>Close[2] && Close[1]>Open[1] && Close[2]<Open[2])
               {
                  BR_Low0 = Low[1]; 
               }
         }
      else    
      if (Close[1]>BR_Low0)
         {      
            if ((Close[1]<Open[1]) && (BR_High100 == 0)) 
               {
                  BR_High100 = High[1];   
               }
               else
               if ((BR_High100 != 0) && (Close[1]>BR_High100))
                  {
                     if ((BR_High100 != 0) && (BR_Low0 != 0)) 
                        {
                           BR_CountPips = (BR_High100 - BR_Low0)/Point;
                           BR_Level161 = BR_Low0 + BR_CountPips * 1.618 * Point;
                           
                           BR_SL = BR_Low0 + BR_CountPips * SL_input * Point;
                           
                           if (High[1] > BR_Level161)
                              {
                                    BR_TP = BR_Low0 + BR_CountPips * TP1_input * Point;
                              }
                              else
                                 {
                                    BR_TP = BR_Low0 + BR_CountPips * TP2_input * Point;
                                 }
                                                      
                        }
                     res = OrderSend(Symbol(),OP_BUY,Lots,Ask,3,BR_SL,BR_TP,"",BR_MagicNumber,0,clrGreen);
                                        
                     if (BR_Safe_input == 1)
                        {
                           BR_TP = BR_Low0 + BR_CountPips * BR_SafeTP_input * Point;
                           BR_SL = BR_Low0 + BR_CountPips * BR_SafeSL_input * Point;
                           res = OrderSend(Symbol(),OP_BUY,Lots,Ask,3,BR_SL,BR_TP,"",BR_MagicNumber,0,clrGreen);
                        }
                        else if (BR_Safe_input == 2)
                                 {
                                    BR_TP = BR_Low0 + BR_CountPips * BR_SafeTP_input * Point;
                                    BR_SL = BR_Low0 + BR_CountPips * BR_SafeSL_input * Point;
                                    res = OrderSend(Symbol(),OP_BUY,Lots*2,Ask,3,BR_SL,BR_TP,"",BR_MagicNumber,0,clrGreen);   
                                 }
                     
                     BR_Low0 = 0;
                     BR_High100 = 0;
                     BR_TP = 0;
                     BR_SL = 0; 
                  }

         }
         else
            {
               BR_Low0 = 0;
               BR_High100 = 0;
               BR_TP = 0;
               BR_SL = 0; 
            }
  }
  
void OnBuyLeftOrder()
  {
      if (BL_High100 == 0)
         {  
            if (Close[1]<Close[2] && Close[1]<Open[1] && Close[2]>Open[2])
               {
                  BL_High100 = High[1];   
               }
         }
      else    
         if ((Close[1]>Open[1]) && (Close[1]>Close[2]) && (BL_Low0 == 0)) 
            {
               BL_Low0 = Low[1];    
            }
            else
               if (Close[1]>BL_Low0)
                  { 
                     if ((BL_Low0 != 0) && (Close[1]>BL_High100))
                        {
                           if ((BL_High100 != 0) && (BL_Low0 != 0)) 
                              {                                 
                                 BL_CountPips = (BL_High100 - BL_Low0)/Point;
                                 BL_Level161 = BL_Low0 + BL_CountPips * 1.618 * Point;
                                 
                                 BL_SL = BL_Low0 + BL_CountPips * BL_SL_input * Point; 
                                 
                                 if (High[1] > BL_Level161)
                                    {
                                       BL_TP = BL_Low0 + BL_CountPips * BL_TP1_input * Point;
                                    }
                                    else
                                       {
                                          BL_TP = BL_Low0 + BL_CountPips * BL_TP2_input * Point;
                                       }  
                              }
                           res = OrderSend(Symbol(),OP_BUY,Lots,Ask,3,BL_SL,BL_TP,"",BL_MagicNumber,0,clrGreen);
                           
                           if (BL_Safe_input == 1)
                              {
                                 BL_TP = BL_Low0 + BL_CountPips * BR_SafeTP_input * Point;
                                 BL_SL = BL_Low0 + BL_CountPips * BL_SafeSL_input * Point;
                                 res = OrderSend(Symbol(),OP_BUY,Lots,Ask,3,BL_SL,BL_TP,"",BL_MagicNumber,0,clrGreen);
                              }
                              else if (BL_Safe_input == 2)
                                 {
                                    BL_TP = BL_Low0 + BL_CountPips * BR_SafeTP_input * Point;
                                    BL_SL = BL_Low0 + BL_CountPips * BL_SafeSL_input * Point;
                                    res = OrderSend(Symbol(),OP_BUY,Lots*2,Ask,3,BL_SL,BL_TP,"",BR_MagicNumber,0,clrGreen);   
                                 }
                           
                           BL_Low0 = 0;
                           BL_High100 = 0;  
                           BL_TP = 0;
                           BL_SL = 0;  
                        }
                  }
                  else
                     {
                        BL_Low0 = 0;
                        BL_High100 = 0; 
                        BL_TP = 0;
                        BL_SL = 0;   
                     }
  }

void OnTick()
  {    
      CalculateLots(); 
         
      if (RiskManagment_input == 1) 
         {
            RiskManagment();
         } 

      if (Moving_input == 1)
         {
            if (Close[1] > iMA(NULL,0,MovingPeriod_input,MovingShift_input,MODE_SMA,PRICE_CLOSE,0)) 
               {
                  if (BuyRight_input == 1)
                     {
                        OnBuyRightOrder();   
                     }
                  if (BuyLeft_input == 1)
                     {
                        OnBuyLeftOrder();   
                     }   
                  }
            else
               {
                  for(int i=OrdersTotal()-1;i>=0;i--)
                     {
                        res = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
                        if ((OrderType() == OP_BUY) && ((OrderMagicNumber() == BR_MagicNumber) || (OrderMagicNumber() == BL_MagicNumber))) res = OrderClose(OrderTicket(),OrderLots(),Bid,1000,0);
                     } 
            
                     BR_Low0 = 0;
                     BR_High100 = 0;
                     BR_TP = 0;
                     BR_SL = 0; 
                     BL_Low0 = 0;
                     BL_High100 = 0; 
                     BL_TP = 0;
                     BL_SL = 0;  
               }
         }
         else
            {
               if (BuyRight_input == 1)
                  {
                     OnBuyRightOrder();   
                  }
               if (BuyLeft_input == 1)
                  {
                     OnBuyLeftOrder();   
                  }
            }

  }