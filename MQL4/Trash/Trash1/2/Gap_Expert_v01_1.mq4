//+------------------------------------------------------------------+
//|                                             Gap_Expert_v01_1.mq4 |
//|  нач. 16/10/2017   релиз от 16/10/2017  посл.изм. 16/10/2017     |
//+------------------------------------------------------------------+
#property copyright "Inkov Evgeni"
#property link      "ew123@mail.ru"
//+------------------------------------------------------------------+
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
// ищется флет от 2-го бара длиной kol_flat_bar
// Если на первом баре и далее есть бары в одну сторону (ГЭП) размером большем флета в Koef_Gap раз,
//   то на 0 баре открывается реверсный ордер со стоп-лоссом на флет+Otstup_SL
//+------------------------------------------------------------------+
input bool       Trade                = true;
input bool       UP                   = true;
input bool       DW                   = true;
input string     s1_______________    = "------------------------------------";
                                                  // если = 0, считаем лот от Proc_Lot
input double     Lots                 = 0;
                                             // процент от баланса для расчета нач. лота
input double     Proc_Lot             = 10;
input string     s2_______________    = "------------------------------------";
input ENUM_TIMEFRAMES TF1             = PERIOD_M1;
input ENUM_TIMEFRAMES TF2             = PERIOD_M5;
input bool       On_TF2               = true;
                                                // кол. бар флета
input int        kol_flat_bar1        = 1;
                                                // размер бара ГЭПа отностельно размера флета
input double     Koef_Gap1            = 2.5;
                                                // кол. бар флета
input int        kol_flat_bar2        = 5;
                                                // размер бара ГЭПа отностельно размера флета
input double     Koef_Gap2            = 1.8;
input string     s3_______________    = "------------------------------------";
                                                // коэф.ТП от размера ГЭПа
input double     Koef_TP              = 4.3;
                                                // отступ для уст. SL
input int        Otstup_SL            = 130;
input string     s4_______________    = "------------------------------------";
input int        Magic                = 142389;
input int        Slippage             = 50;
input bool       Sound                = true;
//-------------------------------------------------------
bool   Risk_from_Balance    = true;// true - считаем риск от баланса, false - от своб.средств
double lot;
double min_l, max_l;
int    dig_lot;
double n_lot;
double poi;
string com_err="";

int    mas_ord[6];
int    kol_ord, kol_ord_pred;
string pref="GE_";
string Glob_SL;
string Glob_TP;
string ss1,ss2;
bool   out_obj;
bool   ust_sl;
bool   ust_tp;
double profit=0;
//========================================
int OnInit()
{
   min_l=MarketInfo(Symbol(),MODE_MINLOT);
   max_l=MarketInfo(Symbol(),MODE_MAXLOT);
   //.............................................
   n_lot=MarketInfo(Symbol(),MODE_LOTSTEP);
   dig_lot=(int)NormalizeDouble(MathLog(1.0/n_lot)/MathLog(10.0),0);
   //.............................................
   poi=MarketInfo(Symbol(),MODE_POINT);
   if (poi==0)poi=1;
   //.............................................
   out_obj=true;
   if (IsTesting() && !IsVisualMode())out_obj=false;
   //.....................................................
   Glob_SL=pref+IntegerToString(IsTesting())+"_"+Symbol()+"_"+TimeFrameToString(TF1)+"_SL";
   Glob_TP=pref+IntegerToString(IsTesting())+"_"+Symbol()+"_"+TimeFrameToString(TF1)+"_TP";
   if (!GlobalVariableCheck(Glob_SL))GlobalVariableSet(Glob_SL,-1);
   if (!GlobalVariableCheck(Glob_TP))GlobalVariableSet(Glob_TP,-1);
   //.....................................................
   kol_ord_pred=-1;
   ust_sl=true;
   ust_tp=true;
   //.............................................
   OnTick();
   //.............................
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
}
//+------------------------------------------------------------------+
double OnTester()
{
   double n1=TesterStatistics(STAT_PROFIT);
   double n2=TesterStatistics(STAT_EQUITY_DD);
   double n3=1;
//   n3=MathLog10(TesterStatistics(STAT_TRADES));
   double n=0;
   if (n2!=0)n=n1/n2*n3;
   return(n);
}
//+------------------------------------------------------------------+
void OnTick()
{
   if (Bid==0)return;
   //........................................
   com_err="";  // обнулить строку комментария ошибок открытия ордеров
   //........................................
   lot=opred_lot();
   //........................................
   Orders_Total();
   //........................................
   double sl=0;
   double tp=0;
   int usl2=0;
   if (On_TF2)usl2=usl_open_ord(TF2,kol_flat_bar2,Koef_Gap2,sl,tp,ss2);
   int us1l = usl_open_ord(TF1,kol_flat_bar1,Koef_Gap1,sl,tp,ss1);
   //........................................
   if (out_obj)
      Comment("UP= ",(UP?"Yes":"NO"),"   DW= ",(DW?"Yes":"NO"),(Trade?"":"   Торговля закрыта !")+"\n",
              "LOT = ",DoubleToStr(lot,2), (Lots==0?"  ( "+DoubleToStr(Proc_Lot,2)+"% )":"")+"\n"+
              "TF1= ",TimeFrameToString(TF1)+": "+ss1+"\n"
              "TF2= ",TimeFrameToString(TF2)+": "+(On_TF2?ss2:"NO"));
   //........................................
   if (kol_ord==0)
      if(Trade)
         if (UP && us1l>0 && (!On_TF2 || usl2>0))
         {
            double sl_end_ord=-1;
            bool prof_plus=Profit_end_plus_Hist(OP_BUY,sl_end_ord);
            if (!prof_plus || (prof_plus && ND(sl_end_ord)!=ND(sl)))
            {
               if (Open_Buy())
               {
                  ust_sl=true;
                  ust_tp=true;
                  GlobalVariableSet(Glob_SL,sl);
                  GlobalVariableSet(Glob_TP,tp);
               }
            }
         }
         else
            if (DW && us1l<0 && (!On_TF2 || usl2<0))
            {
               double sl_end_ord=-1;
               bool prof_plus=Profit_end_plus_Hist(OP_SELL,sl_end_ord);
               if (!prof_plus || (prof_plus && ND(sl_end_ord)!=ND(sl)))
               {
                  if (Open_Sell())
                  {
                     ust_sl=true;
                     GlobalVariableSet(Glob_SL,sl);
                     GlobalVariableSet(Glob_TP,tp);
                  }
               }
            }
   //........................................
   if (ust_sl || ust_tp)ust_SL_TP();
   //........................................
   if (out_obj)
      if (com_err!="")Comment(com_err);
} 
//=========================================================
int usl_open_ord(int TF, int kol_flat_bar, double Koef_Gap,double& sl,double& tp, string& ss)
{
      // найти первый не нулевой бар
   ss="";
   double OC;
   int n_beg=0;
   do
   {
      n_beg++;
      OC=iClose(NULL,TF,n_beg)-iClose(NULL,TF,n_beg+1);
   }
   while(ND(OC)==0 && n_beg<iBars(NULL,TF)-2);
   //................................
         // найти начало плюшки
   int N;
   for(N=n_beg+1;N<iBars(NULL,TF)-kol_flat_bar-2;N++)
   {
      double OC_N=iClose(NULL,TF,N)-iClose(NULL,TF,N+1);
      if ((ND(OC)>0 && ND(OC_N)<0) || (ND(OC)<0 && ND(OC_N)>0))break;
   }
   //........................
            // оценить размер плюшки и найти макс. и мин. для уст.ТП,СЛ
   int out=0;
   double hi_pred_bar;
   double lo_pred_bar;
   sl=0;
   tp=0;
   
   double HL=Find_hl_pred_bar(TF,kol_flat_bar,N+1,hi_pred_bar,lo_pred_bar); // найти среднее значение баров от бар N и далее назад
   double OC_1=iClose(NULL,TF,1)-iClose(NULL,TF,N+1);
   if (ND(HL)==0)HL=Point;
   double K= OC_1/HL;
   
   if (kol_ord==0)
      if (K>0) // бычий бар, уст.Sell
      {
            if (NormalizeDouble(K,2)>=NormalizeDouble(Koef_Gap,2))
            {
               sl=hi_pred_bar;
               tp=iClose(NULL,TF,1)-(iClose(NULL,TF,1)-lo_pred_bar)*Koef_TP;
               out=-1;
            }
      }
      else
         if (K<0) // медв.бар, уст.Buy
            if (NormalizeDouble(-K,2)>=NormalizeDouble(Koef_Gap,2))
            {
               sl=lo_pred_bar;
               tp=iClose(NULL,TF,1)+(hi_pred_bar-iClose(NULL,TF,1))*Koef_TP;
               out=1;
            }
         
   if (out_obj)
      ss="K= "+DoubleToStr(K,2)+" / "+DoubleToStr(Koef_Gap,2)+"  Open order= "+(out==0?"NO":(out==1?"BUY":"SELL"));
         
   return(out);
}
//------------------------------------
double Find_hl_pred_bar(int TF,int kol_flat_bar, int N,double& max_hl,double& min_lo)
{  // на найти размах баров плюшки
   double lo=0,hi=0;
   max_hl=0;
   min_lo=0;
   
   for(int i=0;i<kol_flat_bar;i++)
   {
      lo=iLow (NULL,TF,i+N);
      hi=iHigh(NULL,TF,i+N);
      if (max_hl==0 || ND(hi)>ND(max_hl))max_hl=hi;
      if (min_lo==0 || ND(lo)<ND(min_lo))min_lo=lo;
   }
   double hl=ND(max_hl-min_lo);
   //.......................................
   for(int i=1;i<N;i++)
   {
      lo=iLow (NULL,TF,i);
      hi=iHigh(NULL,TF,i);
      if (max_hl==0 || ND(hi)>ND(max_hl))max_hl=hi;
      if (min_lo==0 || ND(lo)<ND(min_lo))min_lo=lo;
   }
   
   return(hl);
}
//----------------------------
void ust_SL_TP()
{
   double sl_Buy =0;
   double sl_Sell=0;
   
   int stop_level=(int)MarketInfo(Symbol(),MODE_STOPLEVEL);
   double tp_Glob=GlobalVariableGet(Glob_TP);
   double sl_Glob=GlobalVariableGet(Glob_SL);
   if (sl_Glob>0)
   {
      sl_Buy =sl_Glob-Otstup_SL*poi;
      sl_Sell=sl_Glob+Otstup_SL*poi;
   }
   //..........................................
   for (int i=OrdersTotal()-1;i>=0;i--)
   {
      if (!Good_ord(i,MODE_TRADES))continue;
      
      if (OrderType()==OP_BUY)
      {
         if (ND(sl_Buy)>0)
         {
            RefreshRates();
            double sl=sl_Buy;
            if (ND(sl_Buy)>ND(Bid-stop_level*poi))sl=Bid-stop_level*poi;
            if (OrderStopLoss()==0 || ND(sl)>ND(OrderStopLoss()))
            {
               bool M=OrderModify(OrderTicket(),OrderOpenPrice(),ND(sl),OrderTakeProfit(),0,clrBlue);
               ust_sl=!(ND(OrderStopLoss())==ND(sl_Glob-Otstup_SL*poi));
            }
         }
         if (ND(tp_Glob)>0)
            if (ND(tp_Glob)!=ND(OrderTakeProfit()))
            {
               bool M=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),ND(tp_Glob),0,clrBlue);
               ust_tp=!(ND(OrderTakeProfit())==ND(tp_Glob));
            }
      }
            
      if (OrderType()==OP_SELL)
      {
         if (ND(sl_Sell)>0)
         {
            RefreshRates();
            double sl=sl_Sell;
            if (ND(sl_Sell)<ND(Ask+stop_level*poi))sl=Ask+stop_level*poi;
            if (OrderStopLoss()==0 || ND(sl)<ND(OrderStopLoss()))
            {
               bool M=OrderModify(OrderTicket(),OrderOpenPrice(),ND(sl),OrderTakeProfit(),0,clrRed);
               ust_sl=!(ND(OrderStopLoss())==ND(sl_Glob+Otstup_SL*poi));
            }
         }
         if (ND(tp_Glob)>0)
            if (ND(tp_Glob)!=ND(OrderTakeProfit()))
            {
               bool M=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),ND(tp_Glob),0,clrRed);
               ust_tp=!(ND(OrderTakeProfit())==ND(tp_Glob));
            }
      }
   }
}
//---------------------------
bool Profit_end_plus_Hist(int tip, double& sl)
{  // если на нулевом баре был ордер с плюсом, то вых true
   bool out=false;
   sl=-1;
   
   for (int i=OrdersHistoryTotal()-1;i>=0;i--)
   {
      if (!Good_ord(i,MODE_HISTORY))continue;
      
      if (OrderType()==tip)
         if (OrderProfit()>0)
         {
            sl=OrderStopLoss();
            out=true;
         }
      break;
   }
   return(out);
}
//---------------------------------
double opred_lot()
{
   double L=0;
   if (Lots>0)     // определиться с начальным лотом
      L=Ogran_min_lot(Lots);
   else
      L=Ogran_min_lot(GetLot(Proc_Lot));
   return(L);
}
//-------------------------------
double GetLot(double proc)
{
   double free_magrin;
   
   if (Risk_from_Balance)
      free_magrin = AccountBalance();
   else
      free_magrin = AccountFreeMargin();

   double lot1 = NormalizeDouble(free_magrin * proc/100000.0,dig_lot);
   
   return (lot1);
}
//---------------------------------------------------------------
double Ogran_min_lot(double lot1)
{
   if (lot1 < min_l)lot1 = min_l;
   return(lot1);
}
//---------------------------------------------------------------
double Ogran_max_lot(double lot1)
{
   if (lot1 > max_l)lot1 = max_l;
   return(lot1);
}
//---------------------------------------------------------------
void Orders_Total()
{
   ArrayInitialize(mas_ord,0);
   kol_ord=0;
   profit=0;
   
   for (int i=0;i<OrdersTotal();i++)
   {
      if (!Good_ord(i,MODE_TRADES))continue;
      
      mas_ord[OrderType()]++;
      kol_ord++;
      profit+=OrderProfit()+OrderSwap()+OrderCommission();
   }
   //.....................................
   if (kol_ord_pred>0 && kol_ord_pred!=kol_ord) 
      if (Sound)PlaySound("connect.wav");
      
   kol_ord_pred=kol_ord;
   
   if (kol_ord==0) kol_ord_pred=-1;
}
//---------------------------------------------------------------
bool Good_ord(int i, int mode)
{
   if (!OrderSelect(i,SELECT_BY_POS,mode))return(0);
   if (OrderSymbol()!=Symbol())return(0);
   if (OrderMagicNumber()==Magic)return(1);
   if (OrderMagicNumber()==0)return(1);
   
   return(0);
}
//---------------------------------------------------------------
double ND(double n)
{
   return(NormalizeDouble(n,Digits));
}
//---------------------------------------------------------------
double ND2(double n)
{
   return(NormalizeDouble(n,2));
}
//---------------------------------------------------------------
double NDL(double n)
{
   return(MathRound(n/n_lot)*n_lot);
}
//---------------------------------------------------------------
bool Open_Buy()
{
   int tik=ust_order(Symbol(), OP_BUY, lot, ND(Ask), Slippage, 0, 0, "", Magic, clrBlue);
   
   return(tik>0);
}
//-------------------------------------------
bool Open_Sell()
{
   int tik=ust_order(Symbol(), OP_SELL, lot, ND(Bid), Slippage, 0, 0, "", Magic, clrRed);

   return(tik>0);
}
//-------------------------------------------
int ust_order(string sym,int Tip, double lot1, double pr, int slippage, double sl, double tp, string com2, int mag, color col=clrNONE, int dt=0)
{
   double tek_lot;
   double ust_lot=lot1;
   int tik=0;
   while (ust_lot>0)
   {
      tek_lot=Ogran_max_lot(ust_lot);
      tik = OrderSend(sym, Tip, tek_lot, pr, slippage, sl, tp, com2, mag, dt, col);
      if (tik<0)break;
      ust_lot-=tek_lot;
   }
   if (tik<0)IsError(tip_str(Tip)+": pr="+DoubleToStr(pr,Digits)+" sl="+DoubleToStr(sl,Digits)+" tp="+DoubleToStr(tp,Digits));

   return(tik);
}
//-----------------------------------------------
string tip_str (int tip)
{
   switch(tip)
   {
      case 0: return("Buy");
      case 1: return("Sell");
      case 2: return("BuyLimit");
      case 3: return("SellLimit");
      case 4: return("BuyStop");
      case 5: return("SellStop");
   }
   return("?");
}
//-----------------------------------------------
int IsError(string Whose)  
{
   int ierr = GetLastError(); 
   
   bool result = (ierr > 1);
   if(result)com_err=com_err+Whose+ " error = "+ IntegerToString(ierr)+ "; desc = "+ error(ierr)+"\n";
      
   return(ierr);
}
//-----------------------------------------------
string error(int eer)
{
   string er;
   switch(eer)
   {
      case 0:   break;
      case 1:   er="Нет ошибки, но результат неизвестен";                         break;
      case 2:   er="Общая ошибка";                                                break;
      case 3:   er="Неправильные параметры";                                      break;
      case 4:   er="Торговый сервер занят";                                       break;
      case 5:   er="Старая версия клиентского терминала";                         break;
      case 6:   er="Нет связи с торговым сервером";                               break;
      case 7:   er="Недостаточно прав";                                           break;
      case 8:   er="Слишком частые запросы";                                      break;
      case 9:   er="Недопустимая операция нарушающая функционирование сервера";   break;
      case 64:  er="Счет заблокирован";                                           break;
      case 65:  er="Неправильный номер счета";                                    break;
      case 128: er="Истек срок ожидания совершения сделки";                       break;
      case 129: er="Неправильная цена";                                           break;
      case 130: er="Неправильные стопы";                                          break;
      case 131: er="Неправильный объем";                                          break;
      case 132: er="Рынок закрыт";                                                break;
      case 133: er="Торговля запрещена";                                          break;
      case 134: er="Недостаточно денег для совершения операции";                  break;
      case 135: er="Цена изменилась";                                             break;
      case 136: er="Нет цен";                                                     break;
      case 137: er="Брокер занят";                                                break;
      case 138: er="Новые цены - Реквот";                                         break;
      case 139: er="Ордер заблокирован и уже обрабатывается";                     break;
      case 140: er="Разрешена только покупка";                                    break;
      case 141: er="Слишком много запросов";                                      break;
      case 145: er="Модификация запрещена, так как ордер слишком близок к рынку"; break;
      case 146: er="Подсистема торговли занята";                                  break;
      case 147: er="Использование даты истечения ордера запрещено брокером";      break;
      case 148: er="Количество открытых и отложенных ордеров достигло предела ";  break;
      //---- 
      case 4000: er="Нет ошибки";                                                 break;
      case 4001: er="Неправильный указатель функции";                             break;
      case 4002: er="Индекс массива - вне диапазона";                             break;
      case 4003: er="Нет памяти для стека функций";                               break;
      case 4004: er="Переполнение стека после рекурсивного вызова";               break;
      case 4005: er="На стеке нет памяти для передачи параметров";                break;
      case 4006: er="Нет памяти для строкового параметра";                        break;
      case 4007: er="Нет памяти для временной строки";                            break;
      case 4008: er="Неинициализированная строка";                                break;
      case 4009: er="Неинициализированная строка в массиве";                      break;
      case 4010: er="Нет памяти для строкового массива";                          break;
      case 4011: er="Слишком длинная строка";                                     break;
      case 4012: er="Остаток от деления на ноль";                                 break;
      case 4013: er="Деление на ноль";                                            break;
      case 4014: er="Неизвестная команда";                                        break;
      case 4015: er="Неправильный переход";                                       break;
      case 4016: er="Неинициализированный массив";                                break;
      case 4017: er="Вызовы DLL не разрешены";                                    break;
      case 4018: er="Невозможно загрузить библиотеку";                            break;
      case 4019: er="Невозможно вызвать функцию";                                 break;
      case 4020: er="eВызовы внешних библиотечных функций не разрешены";          break;
      case 4021: er="Недостаточно памяти для строки, возвращаемой из функции";    break;
      case 4022: er="Система занята";                                             break;
      case 4050: er="Неправильное количество параметров функции";                 break;
      case 4051: er="Недопустимое значение параметра функции";                    break;
      case 4052: er="Внутренняя ошибка строковой функции";                        break;
      case 4053: er="Ошибка массива";                                             break;
      case 4054: er="Неправильное использование массива-таймсерии";               break;
      case 4055: er="Ошибка пользовательского индикатора";                        break;
      case 4056: er="Массивы несовместимы";                                       break;
      case 4057: er="Ошибка обработки глобальныех перем○енных";                    break;
      case 4058: er="Глобальная переменная не обнаружена";                        break;
      case 4059: er="Функция не разрешена в тестовом режиме";                     break;
      case 4060: er="Функция не подтверждена";                                    break;
      case 4061: er="Ошибка отправки почты";                                      break;
      case 4062: er="Ожидается параметр типа string";                             break;
      case 4063: er="Ожидается параметр типа integer";                            break;
      case 4064: er="Ожидается параметр типа double";                             break;
      case 4065: er="В качестве параметра ожидается массив";                      break;
      case 4066: er="Запрошенные исторические данные в состоянии обновления";     break;
      case 4067: er="Ошибка при выполнении торговой операции";                    break;
      case 4099: er="Конец файла";                                                break;
      case 4100: er="Ошибка при работе с файлом";                                 break;
      case 4101: er="Неправильное имя файла";                                     break;
      case 4102: er="Слишком много открытых файлов";                              break;
      case 4103: er="Невозможно открыть файл";                                    break;
      case 4104: er="Несовместимый режим доступа к файлу";                        break;
      case 4105: er="Ни один ордер не выбран";                                    break;
      case 4106: er="Неизвестный символ";                                         break;
      case 4107: er="Неправильный параметр цены для торговой функции";            break;
      case 4108: er="Неверный номер тикета";                                      break;
      case 4109: er="Торговля не разрешена";                                      break;
      case 4110: er="Длинные позиции не разрешены";                               break;
      case 4111: er="Короткие позиции не разрешены";                              break;
      case 4200: er="Объект уже существует";                                      break;
      case 4201: er="Запрошено неизвестное свойство объекта";                     break;
      case 4202: er="Объект не существует";                                       break;
      case 4203: er="Неизвестный тип объекта";                                    break;
      case 4204: er="Нет имени объекта";                                          break;
      case 4205: er="Ошибка координат объекта";                                   break;
      case 4206: er="Не найдено указанное подокно";                               break;
      case 4207: er="Ошибка при работе с объектом";                               break;
      default:   er="Неизвестная ошибка";
   }
   return(er);
}
//==============================================================
string TimeFrameToString(int tf) 
{
   string s = "";
   if (tf==0)tf=Period();
   
   switch (tf) 
   {
      case PERIOD_M1: s = "M1";  break;
      case PERIOD_M5: s = "M5";  break;
      case PERIOD_M15:s = "M15"; break;
      case PERIOD_M30:s = "M30"; break;
      case PERIOD_H1: s = "H1";  break;
      case PERIOD_H4: s = "H4";  break;
      case PERIOD_D1: s = "D1";  break;
      case PERIOD_W1: s = "W1";  break;
      case PERIOD_MN1:s = "MN1";
   }
      
   return (s);
}
//-------------------------------------------------
void Close_ord(int tip=-1)
{
   bool C,usl=true,CL=false;
   while (usl)
   {
      usl=false;
      for(int i=0; i<OrdersTotal(); i++)
      {
         if (!Good_ord(i,MODE_TRADES))continue;
         
         if(OrderType()==OP_BUY && (tip==OP_BUY || tip==-1))
         {
            RefreshRates();
            C=OrderClose(OrderTicket(),OrderLots(),Bid,Slippage);
            CL=true;
            usl=true;
         }
         if (OrderType()==OP_SELL && (tip==OP_SELL || tip==-1))
         {
            RefreshRates();
            C=OrderClose(OrderTicket(),OrderLots(),Ask,Slippage);
            CL=true;
            usl=true;
         }
      }
   }
   if(CL)Orders_Total();
}
//-----------------------------------------------
