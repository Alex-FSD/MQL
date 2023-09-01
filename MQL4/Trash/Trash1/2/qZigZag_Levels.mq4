//+--------------------------------------------------------------------------------------------------------------------------------------+
//|                                               +ZigZag_Levels.mq4                                                                     |
//|                                Copyright © 2008, Xrust Solution.                                                                     |
//|                                        http://www.xrust.ucoz.net                                                                     |
//+--------------------------------------------------------------------------------------------------------------------------------------+
//     Идея работы эксперта заключается в том что цена "помнит" прошлые уровни экстремумов которые я вляются ключевыми точками
//  преодолев, или не преодолев которые мы имеем два варианта развития событий - пробой или отскок. Характерное поведение
//  цены можно визуально проанализировать на авторском индикаторе " lines_XR", в данном советнике реализован торговый алгоритм
//  разработанный при помощи анализа поведения цены именно этим индикатором.
//     Данные экстремумы характерно располагаются внутри торгового дня, что обуславливается сменой торговых сессий и их характерных
//  особенностей.Экстремумы в эксперте считаются по индикаторам "ЗигЗаг" или "Фракталы" которые есть в комплекте поставки терминала
//     Эксперт позволяет установить до четырех пар отложенных ордеров типов "стоп" или "лимит" в установленное время и на срок 
//  корорый определяется в процессе оптимизации эксперта. Так же возможен выбор глубины тестируемой истории и таймфрейма с которого
//  эта история читается индикатором, и которая может не совпадать с ТФ на который установлен эксперт. 
//     Есть возможность включить автоматическую корректировку типа ордеров, что действенно на длинном тренде когда благодаря ей 
//  запрещается устанока ордеров противоположного направления. 
//     Есть также функция трейлинга тейкпрофита, что облегчает работу советника во флете. Общий трейлинг стоплосса не используется, 
//  так как он достаточно сильно снижает прибыльность эксперта и увеличиват просадки, достаточно точного расчета уровня стоплосса и 
//  тейкпрофита. 
//     Уровни стоплосса и тейкпрофита можно задать как напрямую в пунктах, так и в процентах от ширины текущего канала установки ордеров. 
//     Размер открываемого лота можно задавать как напрямую, так и применять систему автоматического определения торгового лота 
//  пропорционального проценту от депозита. 
//     Все параметры устанавливаются для каждого ордера отдельно,что позволяет торговой системе быть очень гибкой.
//+----------------------------------------------------------------------------------------------------------------------------------------+
//  Технология оптимизации : тип второго,третьего и четвертого ордера ставим в 0 -  ордера отключены, оптимизируем только первый
//-----------------------------------------------------------------------------------------------------------------------------------------+
//  Имя переменной                |мин.знач.|    шаг     |  макс. знач.            |  Примечания
//--------------------------------|---------|------------|-------------------------|-------------------------------------------------------+
//  тип_ордера_1                  |  -1     |     2      |  1                      |  
//  час_открытия_1                |   0     |     1      |  23                     | 
//  минута_открытия_1             |   0     | кратный ТФ |  макс.знач.часа.для ТФ  | 
//  время_удержания_в_часах_1     |   0     |     1      |  23                     |
//  мин_дистанция_до_экстремума_1 |   0     |     1      |  50 - 100               |  Зависит от средней волатильности пары
//  стоплосс_ордера_1             | -100    |    10      |  -50                    |  Зависит от средней волатильности пары
//  тейкпрофит_ордера_1           | -200    |    10      |  -100                   |  Зависит от средней волатильности пары 
//-----------------------------------------------------------------------------------------------------------------------------------------+
//  После того как получили оптимизированные значения фильтруем по макс прибыли, бьем ее значения на некие блоки шагом по предположим 
//  400 - 500 - 1000 $ ищем в этих блоках наименьшую просадку в процентах, после среди выбранных ищем значения с наименьшим временем удержания.
//  Переносим эти значения во второй ордер продолжаем оптимизировать первый. при этом второй ордер дает значения полученные при прошлой 
//  оптимизации. желательно при этом изменить пределы времени установки ордера и времени удержания так, 
//  что бы первый и второй если и перекрывались по времени, то совсем немного. По окончании этой фазы производим фильтрацию как и в 
//  предыдущем случае, и переносим значения в третий ордер. и опять продолжаем пока не заполним ордера, и при этом они не будут друг друга перекрывать.
//
#property copyright "Copyright © 2008, Xrust Solution."
#property link      "http://www.xrust.ucoz.net"


extern string      параметры_первого_ордера = "";
extern int                     тип_ордера_1 = 1 ;//"-1" = лимитные ордера , "1" = стор ордера "0" отключен
extern int                   час_открытия_1 = 21  ;//от 0 до 23 шаг 1
extern int                минута_открытия_1 = 40  ;//от 0 до 30 шаг30 на М30, до 45 шаг 15 на М15, до 55 шаг 5 на М5 
extern int        время_удержания_в_часах_1 = 1  ;//от 1 до 23 шаг 1, если "0" - то сет ордеров не используется
extern int    мин_дистанция_до_экстремума_1 = 10 ;//дистанция в пипсах меньше стоплевела не ставить
extern int                стоплосс_ордера_1 = -100 ;//отрицательные значения - ширина стоплосса относительно ширины канала пары ордеров
extern int              тейкпрофит_ордера_1 = -100 ;//в процентах, положительные значения - прямой размер стопа и тейка в пунктах 
extern double        обьем_ордера_в_лотах_1 = 0.1;//отрицательные целые значения = проценты от депозита и автолот, положительное дробное
//----                                              положительное дробное значение = прямое значение в долях лота ( автолот пока не активен)
extern string      параметры_второго_ордера = "";
extern int                     тип_ордера_2 = 0 ;
extern int                   час_открытия_2 = 18 ;
extern int                минута_открытия_2 = 0 ;
extern int        время_удержания_в_часах_2 = 4 ;
extern int    мин_дистанция_до_экстремума_2 = 46;
extern int                стоплосс_ордера_2 = -100 ;
extern int              тейкпрофит_ордера_2 = -100 ;
extern double        обьем_ордера_в_лотах_2 = 0.1 ;
//----
extern string     параметры_третьего_ордера = "";
extern int                     тип_ордера_3 = 0 ;
extern int                   час_открытия_3 = 0 ;
extern int                минута_открытия_3 = 0 ;
extern int        время_удержания_в_часах_3 = 0 ;
extern int    мин_дистанция_до_экстремума_3 = 10;
extern int                стоплосс_ордера_3 = -100 ;
extern int              тейкпрофит_ордера_3 = -100 ;
extern double        обьем_ордера_в_лотах_3 = 0.1 ;
//----
extern string   параметры_четвертого_ордера = "";
extern int                     тип_ордера_4 = 0 ;
extern int                   час_открытия_4 = 0 ;
extern int                минута_открытия_4 = 0 ;
extern int        время_удержания_в_часах_4 = 0 ;
extern int    мин_дистанция_до_экстремума_4 = 10;
extern int                стоплосс_ордера_4 = -100 ;
extern int              тейкпрофит_ордера_4 = -100 ;
extern double        обьем_ордера_в_лотах_4 = 0.1 ;
//----
extern int         количество_баров_истории = 1000;
extern int     ТаймФрейм_считываемых_данных = 0;
extern bool    Зигзаг_Фрактал_как_индикатор = true;
//----
extern bool       Корректировка_типа_ордера = true;
extern bool           Трейлинг_тейк_профита = false;
extern bool           Автоустановка_времени = false;
extern bool                  Общий_Стоплосс = false;
extern bool        Установка_ордера_с_рынка = true;
//----
int magic1=123,magic2=456,magic3=789,magic4=741;
//----
int mno,ZzPeriod;
//----
double step=1;
//----
double ZZ[1000];int ord[10][2];int res[4];
//----
bool Err147=false;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init(){
  if(ТаймФрейм_считываемых_данных<1 ){ZzPeriod=Period();}
  if(ТаймФрейм_считываемых_данных==1){ZzPeriod=1;}
  if(ТаймФрейм_считываемых_данных==2){ZzPeriod=5;}
  if(ТаймФрейм_считываемых_данных==3){ZzPeriod=15;}
  if(ТаймФрейм_считываемых_данных==4){ZzPeriod=30;}
  if(ТаймФрейм_считываемых_данных==5){ZzPeriod=60;}
  if(ТаймФрейм_считываемых_данных==6){ZzPeriod=240;}
  if(ТаймФрейм_считываемых_данных>=7){ZzPeriod=1440;}
if(Digits==5||Digits==3){mno=10;}else{mno=1;} 
return;}
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
void start(){int i;
  static int mxdrdn,mxord,mxzal;
  if(AccountBalance()-AccountEquity()>mxdrdn){mxdrdn=AccountBalance()-AccountEquity();}
  if(IsVisualMode()){
  int ot;
  for(i=0;i<OrdersTotal();i++){
    if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
      if(OrderSymbol()==Symbol()){
        if(OrderType()<2){
          ot++;
        }
      }
    }
  }
  }
  if(ot>mxord){mxord=ot;}
  if(AccountMargin()>mxzal){mxzal=AccountMargin();}
  Comment("Профит = ",AccountProfit(),"\nЗалог  = ",AccountMargin(),"\nMax Залог  = ",mxzal,"\nПросадка = ",mxdrdn,"\nОрдеров = ",mxord);
//----
  
//----
  if(Трейлинг_тейк_профита){ProfitTraling();}
//----  
  if(NewBar()){
    if(Err147){DelOldOrders();}
    if(Зигзаг_Фрактал_как_индикатор){
      ReadZZ(количество_баров_истории);
    }else{
      ReadFr(количество_баров_истории);
    } 
//----
  if(Автоустановка_времени){TimeSetAuto();}
//---- 
  if(Автоустановка_времени){
    час_открытия_1=res[0];
    время_удержания_в_часах_1=res[1]-res[0];
  } 
  if(Trade(час_открытия_1,минута_открытия_1)){
        SetOrders(тип_ордера_1,
     время_удержания_в_часах_1,
 мин_дистанция_до_экстремума_1,
                        magic1,
        обьем_ордера_в_лотах_1,
             стоплосс_ордера_1,
           тейкпрофит_ордера_1
    );
  }
  if(тип_ордера_2==0)return;
  if(Автоустановка_времени){
    час_открытия_2=res[1];
    время_удержания_в_часах_2=res[2]-res[1];
  }  
  if(Общий_Стоплосс){стоплосс_ордера_2=стоплосс_ордера_1;}
  if(Trade(час_открытия_2,минута_открытия_2)){
        SetOrders(тип_ордера_2,
     время_удержания_в_часах_2,
 мин_дистанция_до_экстремума_2,
                        magic2,
        обьем_ордера_в_лотах_2,
             стоплосс_ордера_2,
           тейкпрофит_ордера_2
    );
  }  
  if(тип_ордера_3==0)return;
  if(Автоустановка_времени){
    час_открытия_3=res[2];
    время_удержания_в_часах_2=res[3]-res[2];
  }  
  if(Общий_Стоплосс){стоплосс_ордера_3=стоплосс_ордера_1;}
  if(Trade(час_открытия_3,минута_открытия_3)){
        SetOrders(тип_ордера_3,
     время_удержания_в_часах_3,
 мин_дистанция_до_экстремума_3,
                        magic3,
        обьем_ордера_в_лотах_3,
             стоплосс_ордера_3,
           тейкпрофит_ордера_3
    );
  }  
  if(тип_ордера_4==0)return;
  if(Автоустановка_времени){
    час_открытия_3=res[3];
    время_удержания_в_часах_3=24-res[3];
  }  
  if(Общий_Стоплосс){стоплосс_ордера_4=стоплосс_ордера_1;}
  if(Trade(час_открытия_3,минута_открытия_4)){
        SetOrders(тип_ордера_4,
     время_удержания_в_часах_4,
 мин_дистанция_до_экстремума_4,
                        magic4,
        обьем_ордера_в_лотах_4,
             стоплосс_ордера_4,
           тейкпрофит_ордера_4
    );
  }  
  }
return;}
//+------------------------------------------------------------------+
//|  Ищем ордер выше\ниже указанной цены                             |
//+------------------------------------------------------------------+
double SearchPrise(int typ,double prise){double res,up=100000,dn=0;int i;
if(typ==0){
  for(i=0;i<OrdersTotal();i++){
    if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
      if(OrderSymbol()==Symbol()){
        if(OrderType()>1){
          if(OrderOpenPrice()-prise>0){
            if(OrderOpenPrice()-prise<up){
              up=OrderOpenPrice()-prise;
              res=OrderOpenPrice();
            }
          }
        }
      }
    }
  }
 return(res); 
}
if(typ==1){
  for(i=0;i<OrdersTotal();i++){
    if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
      if(OrderSymbol()==Symbol()){
        if(OrderType()>1){
          if(prise-OrderOpenPrice()>0){
            if(OrderOpenPrice()-prise<dn){
              dn=prise-OrderOpenPrice();
              res=OrderOpenPrice();
            }
          }
        }
      }
    }
  }
 return(res); 
}  
return(0);
}
//+------------------------------------------------------------------+
//| Трейлинг профита                                                 |
//+------------------------------------------------------------------+
void ProfitTraling(){
  for(int i=0;i<OrdersTotal();i++){
    if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
      if(OrderSymbol()==Symbol()){
        if(OrderType()<2){
          int    ordticket=OrderTicket();
          double ordtype  =OrderType();
          double ordprise =OrderOpenPrice();          
          double ordtake  =NormalizeDouble(OrderTakeProfit(),Digits);
          double ordstop  =NormalizeDouble(OrderStopLoss(),Digits);
          double newtake  =NormalizeDouble(SearchPrise(ordtype,ordprise),Digits);
          if(newtake!=0){
            if(newtake!=ordtake){
              if(!OrderModify(ordticket,ordprise,ordstop,newtake,0,White)){
                Print("Error =",GetLastError());
              }
            }
          }
        }
      }
    }
  }
return;
}
//+------------------------------------------------------------------+
//|  Определяем наилучшее время для установки ордеров                |
//+------------------------------------------------------------------+
void TimeSetAuto(){
  if(TimeHour(TimeCurrent())==0){
    int time[24];
    for(int p=0;p<(количество_баров_истории/24);p++){
    for(int i=0;i<24;i++){
      if(iCustom(Symbol(),60,"Zigzag",0,(p*24)+i)!=0){
        time[i]++;
      }
    }  
    }
    for(i=0;i<4;i++){
      int re=ArrayMaximum(time);
      res[i]=re+1;
      time[re-1]=0;
      time[re]=0;
      time[re+1]=0;
      time[re+2]=0;
    }
    ArraySort(res);
  }
return;
}
//+------------------------------------------------------------------+
//|  если цена крайняя                                               |
//+------------------------------------------------------------------+
int IfPrise(double up,double dn){
  ArraySort(ZZ,WHOLE_ARRAY,0,MODE_DESCEND );
  if(NormalizeDouble(up,Digits)==NormalizeDouble(ZZ[0],Digits)){return( 1);}
  ArraySort(ZZ,WHOLE_ARRAY,0,MODE_ASCEND );
  if(NormalizeDouble(dn,Digits)==NormalizeDouble(ZZ[0],Digits)){return(-1);}  
  return(0);
}
//+------------------------------------------------------------------+
//|  Ставим отложки                                                  |
//+------------------------------------------------------------------+
void SetOrders(int typ,int ordtime,int mindistanse,int magic,double lot,double sl=0,double tp=0){
  Print("trade");
  double sll,tpp;
  int ticket,err;
  double buy =NormalizeDouble(UpPrise(NormalizeDouble(Ask,Digits),mindistanse),Digits);
  double sell=NormalizeDouble(DnPrise(NormalizeDouble(Bid,Digits),mindistanse),Digits);  
  int stlw=MarketInfo(Symbol(),MODE_STOPLEVEL);
  int timecl=TimeCurrent()+ordtime*3600;
  if(Корректировка_типа_ордера){
    int korr=IfPrise(buy,sell);
    if(korr!=0){typ=korr;}
  }  
  if(typ<0){
   if(CountOpOrd(3,magic)<1){
     if(buy!=0){
       if(OpPrise(buy)){RefreshRates();
         if(buy-Ask<stlw*Point){buy=NormalizeDouble(Ask+stlw*Point,Digits);}
         if(sl<0){sll=NormalizeDouble(buy+((buy-sell)*(sl/(-100))),Digits);}
         if(sl>0){sll=NormalizeDouble(buy+sl*Point*mno,Digits);}
         if(tp>0){tpp=NormalizeDouble(buy-tp*Point*mno,Digits);}
         if(tp<0){tpp=NormalizeDouble(buy-((buy-sell)*(-tp/100)),Digits);}
         ticket=OrderSend(Symbol(),3,lot,buy,3*mno,sll,tpp,NULL,magic,timecl,Red);
         if(ticket<1){// обработка ошибок
           err=GetLastError();
           if(err==147){// запрешение времени истечения
             Err147=true;
             ticket=OrderSend(Symbol(),3,lot,buy,3*mno,sll,tpp,NULL,magic,0,Red);
             if(ticket>0){
               WriteOrder(ticket,timecl);
             }else{
               err=GetLastError();
               if(err==130){
                 if(Установка_ордера_с_рынка){
                   RefreshRates();
                   ticket=OrderSend(Symbol(),1,lot,Bid,3*mno,sll,tpp,NULL,magic,0,Red);
                   if(ticket<1){
                     err=GetLastError();
                     Print("Ошибка установки ордера с рынка  № ",err,
                           "  тип ордера = СЕЛЛ  ",
                           "  Цена открытия =",Bid,
                           "  Цена = ",Bid,
                           "  Стоплосс = ",sll,
                           "  Тейкпрофит = ",tpp);
                   }
                 }else{
                 
                 }
               }
             }
           }
               if(err==130){
                 if(Установка_ордера_с_рынка){
                   RefreshRates();
                   ticket=OrderSend(Symbol(),1,lot,Bid,3*mno,sll,tpp,NULL,magic,0,Red);
                   if(ticket<1){
                     err=GetLastError();
                     Print("Ошибка установки ордера с рынка  № ",err,
                           "  тип ордера = СЕЛЛ  ",
                           "  Цена открытия =",Bid,
                           "  Цена = ",Bid,
                           "  Стоплосс = ",sll,
                           "  Тейкпрофит = ",tpp);
                   }
                 }else{
                 
                 }
               }           
           Print("3  Ошибка установки ордера № ",err);
         }
       }
     }
   } 
   if(CountOpOrd(2,magic)<1){
     if(sell!=0){
       if(OpPrise(sell)){RefreshRates();
         if(Bid-sell<stlw*Point){NormalizeDouble(Bid-stlw*Point,Digits);}
         if(sl<0){sll=NormalizeDouble(sell-((buy-sell)*(sl/(-100))),Digits);}
         if(sl>0){sll=NormalizeDouble(sell-sl*Point*mno,Digits);}
         if(tp>0){tpp=NormalizeDouble(sell+(tp*Point*mno),Digits);}
         if(tp<0){tpp=NormalizeDouble(sell+((buy-sell)*(-tp/100)),Digits);}   
         ticket=OrderSend(Symbol(),2,lot,sell,3*mno,sll,tpp,NULL,magic,timecl, Blue);    
         if(ticket<1){// обработка ошибок
           err=GetLastError();
           if(err==147){// запрешение времени истечения
             Err147=true;
             ticket=OrderSend(Symbol(),2,lot,sell,3*mno,sll,tpp,NULL,magic,0, Blue);
             if(ticket>0){
               WriteOrder(ticket,timecl);
             }else{
               err=GetLastError();
               if(err==130){
                 if(Установка_ордера_с_рынка){
                   RefreshRates();
                   ticket=OrderSend(Symbol(),0,lot,Ask,3*mno,sll,tpp,NULL,magic,0,Blue);
                   if(ticket<1){
                     err=GetLastError();
                     Print("Ошибка установки ордера с рынка  № ",err,
                           "  тип ордера = BUY  ",
                           "  Цена открытия =",Ask,
                           "  Цена = ",Ask,
                           "  Стоплосс = ",sll,
                           "  Тейкпрофит = ",tpp);
                   }
                 }else{
                 
                 }
               }                 
             }
           }     
               if(err==130){
                 if(Установка_ордера_с_рынка){
                   RefreshRates();
                   ticket=OrderSend(Symbol(),0,lot,Ask,3*mno,sll,tpp,NULL,magic,0,Blue);
                   if(ticket<1){
                     err=GetLastError();
                     Print("Ошибка установки ордера с рынка  № ",err,
                           "  тип ордера = BUY  ",
                           "  Цена открытия =",Ask,
                           "  Цена = ",Ask,
                           "  Стоплосс = ",sll,
                           "  Тейкпрофит = ",tpp);
                   }
                 }else{
                 
                 }
               }                  
           Print("2  Ошибка установки ордера № ",err);
         }          
       }  
     }
   }
  }
  if(typ>0){
   if(CountOpOrd(4,magic)<1){
     if(buy!=0){
       if(OpPrise(buy)){RefreshRates();
         if(buy-Ask<stlw*Point){NormalizeDouble(Ask+stlw*Point,Digits);}
         if(sl<0){sll=NormalizeDouble(buy-((buy-sell)*(sl/(-100))),Digits);}
         if(sl>0){sll=NormalizeDouble(buy-sl*Point*mno,Digits);}
         if(tp>0){tpp=NormalizeDouble(buy+tp*Point*mno,Digits);}
         if(tp<0){tpp=NormalizeDouble(buy+((buy-sell)*(-tp/100)),Digits);}
         ticket=OrderSend(Symbol(),4,lot,buy,3*mno,sll,tpp,NULL,magic,timecl,Blue);
         if(ticket<1){// обработка ошибок
           err=GetLastError();
           if(err==147){// запрешение времени истечения
             Err147=true;
             ticket=OrderSend(Symbol(),4,lot,buy,3*mno,sll,tpp,NULL,magic,0,Blue);
             if(ticket>0){
               WriteOrder(ticket,timecl);
             }else{
               err=GetLastError();
               if(err==130){
                 if(Установка_ордера_с_рынка){
                   RefreshRates();
                   ticket=OrderSend(Symbol(),0,lot,Ask,3*mno,sll,tpp,NULL,magic,0,Blue);
                   if(ticket<1){
                     err=GetLastError();
                     Print("Ошибка установки ордера с рынка  № ",err,
                           "  тип ордера = BUY  ",
                           "  Цена открытия =",Ask,
                           "  Цена = ",Ask,
                           "  Стоплосс = ",sll,
                           "  Тейкпрофит = ",tpp);
                   }
                 }else{
                 
                 }
               }               
             }  
           }
               if(err==130){
                 if(Установка_ордера_с_рынка){
                   RefreshRates();
                   ticket=OrderSend(Symbol(),0,lot,Ask,3*mno,sll,tpp,NULL,magic,0,Blue);
                   if(ticket<1){
                     err=GetLastError();
                     Print("Ошибка установки ордера с рынка  № ",err,
                           "  тип ордера = BUY  ",
                           "  Цена открытия =",Ask,
                           "  Цена = ",Ask,
                           "  Стоплосс = ",sll,
                           "  Тейкпрофит = ",tpp);
                   }
                 }else{
                 
                 }
               }                       
           Print("4  Ошибка установки ордера № ",err);
         }         
       }
     }
   }  
   if(CountOpOrd(5,magic)<1){
     if(sell!=0){
       if(OpPrise(sell)){RefreshRates();
         if(Bid-sell<stlw*Point){NormalizeDouble(Bid-stlw*Point,Digits);}
         if(sl<0){sll=NormalizeDouble(sell+((buy-sell)*(sl/(-100))),Digits);}
         if(sl>0){sll=NormalizeDouble(sell+sl*Point*mno,Digits);}
         if(tp>0){tpp=NormalizeDouble(sell-tp*Point*mno,Digits);}
         if(tp<0){tpp=NormalizeDouble(sell-((buy-sell)*(-tp/100)),Digits);}   
         ticket=OrderSend(Symbol(),5,lot,sell,3*mno,sll,tpp,NULL,magic,timecl, Red);
         if(ticket<1){// обработка ошибок
           err=GetLastError();
           if(err==147){// запрешение времени истечения
             Err147=true;
             ticket=OrderSend(Symbol(),5,lot,sell,3*mno,sll,tpp,NULL,magic,0, Red);
             if(ticket>0){
               WriteOrder(ticket,timecl);
             }else{
               err=GetLastError();
               if(err==130){
                 if(Установка_ордера_с_рынка){
                   RefreshRates();
                   ticket=OrderSend(Symbol(),1,lot,Bid,3*mno,sll,tpp,NULL,magic,0,Red);
                   if(ticket<1){
                     err=GetLastError();
                     Print("Ошибка установки ордера с рынка  № ",err,
                           "  тип ордера = SELL  ",
                           "  Цена открытия =",Bid,
                           "  Цена = ",Bid,
                           "  Стоплосс = ",sll,
                           "  Тейкпрофит = ",tpp);
                   }
                 }else{
                 
                 }
               }               
             }      
           } 
               if(err==130){
                 if(Установка_ордера_с_рынка){
                   RefreshRates();
                   ticket=OrderSend(Symbol(),1,lot,Bid,3*mno,sll,tpp,NULL,magic,0,Red);
                   if(ticket<1){
                     err=GetLastError();
                     Print("Ошибка установки ордера с рынка  № ",err,
                           "  тип ордера = SELL  ",
                           "  Цена открытия =",Bid,
                           "  Цена = ",Bid,
                           "  Стоплосс = ",sll,
                           "  Тейкпрофит = ",tpp);
                   }
                 }else{
                 
                 }
               }                 
           Print("5  Ошибка установки ордера № ",err);
         }                
       }  
     }
   } 
 }
return;
} 
//+------------------------------------------------------------------+
//|  Запись ордера в массив для своевремменого удаления              |
//+------------------------------------------------------------------+
void WriteOrder(int ticket,int time){int pos;
  int razm=ArrayRange(ord,1);
  for(int i=0;i<razm;i++){
    if(ord[i][0]==ticket){return;}
    if(ord[i][1]==0){pos=i;}
  }
  ord[pos][0]=ticket;
  ord[pos][1]=time;
return;
}
//+------------------------------------------------------------------+
//|  читает массив ордеров и удаляет олрдера с истекшим сроком       |
//+------------------------------------------------------------------+
void DelOldOrders(){
  int razm=ArrayRange(ord,1);
  for(int i=0;i<razm;i++){
    if(ord[i][1]!=0){
      if(ord[i][1]<=TimeCurrent()){
      int ticket=ord[i][0];
      if(OrderSelect(ticket,SELECT_BY_TICKET)){
        if(OrderCloseTime()==0){
          if(OrderType()>1){
            if(OrderDelete(OrderTicket(),White)){
              ord[i][0]=0;
              ord[i][1]=0;
            }
          }
        }else{ord[i][0]=0;ord[i][1]=0;}
      }else{ord[i][0]=0;ord[i][1]=0;}
      }
    }
  }
return;
}
//-----------------------------------------------------------------------------+
//| Расчет лота соотв риску и балансу                                          |
//-----------------------------------------------------------------------------+
double CalcLotsAuto(double Risk){double LotOpt,LotNeOpt,Zalog;
   RefreshRates();
   //double bs=AccountBalance()+GrPorfit();
   double lott=MarketInfo(Symbol(),MODE_MARGINREQUIRED)/1000;
   double Marga=AccountFreeMargin();
   double Balans=AccountBalance();
   double LotMin=MarketInfo(Symbol(),MODE_MINLOT);
   double LotMax=MarketInfo(Symbol(),MODE_MAXLOT);
   double StepLot=MarketInfo(Symbol(),MODE_LOTSTEP);
   double StopLv=AccountStopoutLevel();
   int PrsMinLot=1000*LotMin;
   if(Risk<0)Risk=0;
   if(Risk>100)Risk=100; 
   if(StepLot==0.01){int step=2;}else{step=1;}  
//---------------------------     
   Zalog=(Balans*(Risk/100));
   LotOpt=NormalizeDouble((Zalog/1000),step);
   if(LotOpt>LotMax)LotOpt=LotMax;
   if(LotOpt<LotMin)LotOpt=LotMin;
   return(LotOpt);
}
//+------------------------------------------------------------------+
//|  Время установки одного отложенника в день                       |
//+------------------------------------------------------------------+
bool Trade(int ho,int min){
  if(TimeHour(TimeCurrent())==ho){
    if(TimeMinute(TimeCurrent())>=min&&TimeMinute(TimeCurrent())<min+5){
      return(true); 
    }
  }
  return(false);
} 
//-----------------------------------------------------------------------------+
// Ищем цену нужного ордера                                                    |
//-----------------------------------------------------------------------------+
bool OpPrise(double prise,int dist=5){return(true);
  for(int i=0;i<OrdersTotal();i++){
    if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
      if(OrderSymbol()==Symbol()){
        if(MathAbs(OrderOpenPrice()-prise)<dist*Point*mno){
          return(false);
        }
      }
    }
  }
 return(true);  
}  
//+------------------------------------------------------------------+
//|   Ищем близжайшую цену сверху                                    |
//+------------------------------------------------------------------+
double UpPrise(double prise,int dist){double res=100000;int shift;
  int stlw=MarketInfo(Symbol(),MODE_STOPLEVEL);
  if(dist<stlw){dist=stlw;}
  int count=ArraySize(ZZ);
  ArraySort(ZZ,WHOLE_ARRAY,0,MODE_DESCEND );
  for(int i=0;i<count;i++){
    double pd=ZZ[i]-prise;
    if(pd>dist*Point*mno){
      if(pd<res){
        res=pd;
        shift=i;
      }  
    }
  }

  return(ZZ[shift]);
}
//+------------------------------------------------------------------+
//|   Ищем близжайшую цену снизу                                     |
//+------------------------------------------------------------------+
double DnPrise(double prise,int dist){double res=100000;int shift;
  int stlw=MarketInfo(Symbol(),MODE_STOPLEVEL);
  if(dist<stlw){dist=stlw;}
  int count=ArraySize(ZZ);
  ArraySort(ZZ,WHOLE_ARRAY,0,MODE_ASCEND );
  for(int i=0;i<count;i++){
    double pd=prise-ZZ[i];
    if(pd>dist*Point*mno){
      if(pd<res){
        res=pd;
        shift=i;
      }  
    }
  }
  return(ZZ[shift]);
}  
//+------------------------------------------------------------------+
//|  Забиваем экстремумы в массив                                    |
//+------------------------------------------------------------------+
void ReadZZ(int per){int y;
  ArrayInitialize(ZZ,0);
  ArrayResize(ZZ,1000);
  for(int i=3;i<per;i++){
     double x = iCustom(Symbol(),ZzPeriod,"Zigzag",0,i);
     if(x!=0){ZZ[y]=NormalizeDouble(x,Digits);y++;}
  }
  ArrayResize(ZZ,y);
}  
//+------------------------------------------------------------------+
//|  Забиваем экстремумы фракталов в массив                          |
//+------------------------------------------------------------------+
void ReadFr(int per){int y;
  ArrayInitialize(ZZ,0);
  ArrayResize(ZZ,1000);
  for(int i=3;i<per;i++){
     double xup = iFractals(Symbol(),ZzPeriod,MODE_UPPER,i);
     double xdn = iFractals(Symbol(),ZzPeriod,MODE_LOWER,i);
     if(xup!=0){ZZ[y]=NormalizeDouble(xup,Digits);y++;xdn=0;}
     if(xdn!=0){ZZ[y]=NormalizeDouble(xdn,Digits);y++;xup=0;}
  }
  ArrayResize(ZZ,y);
}
//-------------------------------------------------------------------+
//| Подсчитывает количество открытых ордеров согласно условиям       |
//-------------------------------------------------------------------+
int CountOpOrd(int Typ=-1,int Magik=-1){int count=0;
  for(int i=0;i<OrdersTotal();i++){
    if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
      if(OrderSymbol()==Symbol()){
        if(OrderMagicNumber()==Magik){
          if(OrderType()==Typ){
            if(OrderCloseTime()==0){
              count++;
            }  
          }
        }
      }
    }
  }
 return(count);  
}   
//-----------------------------------------------------------------------------+
// Функция контроля нового бара                                                |
//-----------------------------------------------------------------------------+
bool NewBar(){
   static int PrevTime=0;
   if (PrevTime==Time[0]) return(false);
   PrevTime=Time[0];
   return(true);}   

