//+--------------------------------------------------------------------------------------------------------------------------------------+
//|                                               +ZigZag_Levels.mq4                                                                     |
//|                                Copyright � 2008, Xrust Solution.                                                                     |
//|                                        http://www.xrust.ucoz.net                                                                     |
//+--------------------------------------------------------------------------------------------------------------------------------------+
//     ���� ������ �������� ����������� � ��� ��� ���� "������" ������� ������ ����������� ������� � ������� ��������� �������
//  ���������, ��� �� ��������� ������� �� ����� ��� �������� �������� ������� - ������ ��� ������. ����������� ���������
//  ���� ����� ��������� ���������������� �� ��������� ���������� " lines_XR", � ������ ��������� ���������� �������� ��������
//  ������������� ��� ������ ������� ��������� ���� ������ ���� �����������.
//     ������ ���������� ���������� ������������� ������ ��������� ���, ��� ��������������� ������ �������� ������ � �� �����������
//  ������������.���������� � �������� ��������� �� ����������� "������" ��� "��������" ������� ���� � ��������� �������� ���������
//     ������� ��������� ���������� �� ������� ��� ���������� ������� ����� "����" ��� "�����" � ������������� ����� � �� ���� 
//  ������� ������������ � �������� ����������� ��������. ��� �� �������� ����� ������� ����������� ������� � ���������� � ��������
//  ��� ������� �������� �����������, � ������� ����� �� ��������� � �� �� ������� ���������� �������. 
//     ���� ����������� �������� �������������� ������������� ���� �������, ��� ���������� �� ������� ������ ����� ��������� �� 
//  ����������� �������� ������� ���������������� �����������. 
//     ���� ����� ������� ��������� �����������, ��� ��������� ������ ��������� �� �����. ����� �������� ��������� �� ������������, 
//  ��� ��� �� ���������� ������ ������� ������������ �������� � ���������� ��������, ���������� ������� ������� ������ ��������� � 
//  �����������. 
//     ������ ��������� � ����������� ����� ������ ��� �������� � �������, ��� � � ��������� �� ������ �������� ������ ��������� �������. 
//     ������ ������������ ���� ����� �������� ��� ��������, ��� � ��������� ������� ��������������� ����������� ��������� ���� 
//  ����������������� �������� �� ��������. 
//     ��� ��������� ��������������� ��� ������� ������ ��������,��� ��������� �������� ������� ���� ����� ������.
//+----------------------------------------------------------------------------------------------------------------------------------------+
//  ���������� ����������� : ��� �������,�������� � ���������� ������ ������ � 0 -  ������ ���������, ������������ ������ ������
//-----------------------------------------------------------------------------------------------------------------------------------------+
//  ��� ����������                |���.����.|    ���     |  ����. ����.            |  ����������
//--------------------------------|---------|------------|-------------------------|-------------------------------------------------------+
//  ���_������_1                  |  -1     |     2      |  1                      |  
//  ���_��������_1                |   0     |     1      |  23                     | 
//  ������_��������_1             |   0     | ������� �� |  ����.����.����.��� ��  | 
//  �����_���������_�_�����_1     |   0     |     1      |  23                     |
//  ���_���������_��_����������_1 |   0     |     1      |  50 - 100               |  ������� �� ������� ������������� ����
//  ��������_������_1             | -100    |    10      |  -50                    |  ������� �� ������� ������������� ����
//  ����������_������_1           | -200    |    10      |  -100                   |  ������� �� ������� ������������� ���� 
//-----------------------------------------------------------------------------------------------------------------------------------------+
//  ����� ���� ��� �������� ���������������� �������� ��������� �� ���� �������, ���� �� �������� �� ����� ����� ����� �� ����������� 
//  400 - 500 - 1000 $ ���� � ���� ������ ���������� �������� � ���������, ����� ����� ��������� ���� �������� � ���������� �������� ���������.
//  ��������� ��� �������� �� ������ ����� ���������� �������������� ������. ��� ���� ������ ����� ���� �������� ���������� ��� ������� 
//  �����������. ���������� ��� ���� �������� ������� ������� ��������� ������ � ������� ��������� ���, 
//  ��� �� ������ � ������ ���� � ������������� �� �������, �� ������ �������. �� ��������� ���� ���� ���������� ���������� ��� � � 
//  ���������� ������, � ��������� �������� � ������ �����. � ����� ���������� ���� �� �������� ������, � ��� ���� ��� �� ����� ���� ����� �����������.
//
#property copyright "Copyright � 2008, Xrust Solution."
#property link      "http://www.xrust.ucoz.net"


extern string      ���������_�������_������ = "";
extern int                     ���_������_1 = 1 ;//"-1" = �������� ������ , "1" = ���� ������ "0" ��������
extern int                   ���_��������_1 = 21  ;//�� 0 �� 23 ��� 1
extern int                ������_��������_1 = 40  ;//�� 0 �� 30 ���30 �� �30, �� 45 ��� 15 �� �15, �� 55 ��� 5 �� �5 
extern int        �����_���������_�_�����_1 = 1  ;//�� 1 �� 23 ��� 1, ���� "0" - �� ��� ������� �� ������������
extern int    ���_���������_��_����������_1 = 10 ;//��������� � ������ ������ ���������� �� �������
extern int                ��������_������_1 = -100 ;//������������� �������� - ������ ��������� ������������ ������ ������ ���� �������
extern int              ����������_������_1 = -100 ;//� ���������, ������������� �������� - ������ ������ ����� � ����� � ������� 
extern double        �����_������_�_�����_1 = 0.1;//������������� ����� �������� = �������� �� �������� � �������, ������������� �������
//----                                              ������������� ������� �������� = ������ �������� � ����� ���� ( ������� ���� �� �������)
extern string      ���������_�������_������ = "";
extern int                     ���_������_2 = 0 ;
extern int                   ���_��������_2 = 18 ;
extern int                ������_��������_2 = 0 ;
extern int        �����_���������_�_�����_2 = 4 ;
extern int    ���_���������_��_����������_2 = 46;
extern int                ��������_������_2 = -100 ;
extern int              ����������_������_2 = -100 ;
extern double        �����_������_�_�����_2 = 0.1 ;
//----
extern string     ���������_��������_������ = "";
extern int                     ���_������_3 = 0 ;
extern int                   ���_��������_3 = 0 ;
extern int                ������_��������_3 = 0 ;
extern int        �����_���������_�_�����_3 = 0 ;
extern int    ���_���������_��_����������_3 = 10;
extern int                ��������_������_3 = -100 ;
extern int              ����������_������_3 = -100 ;
extern double        �����_������_�_�����_3 = 0.1 ;
//----
extern string   ���������_����������_������ = "";
extern int                     ���_������_4 = 0 ;
extern int                   ���_��������_4 = 0 ;
extern int                ������_��������_4 = 0 ;
extern int        �����_���������_�_�����_4 = 0 ;
extern int    ���_���������_��_����������_4 = 10;
extern int                ��������_������_4 = -100 ;
extern int              ����������_������_4 = -100 ;
extern double        �����_������_�_�����_4 = 0.1 ;
//----
extern int         ����������_�����_������� = 1000;
extern int     ���������_�����������_������ = 0;
extern bool    ������_�������_���_��������� = true;
//----
extern bool       �������������_����_������ = true;
extern bool           ��������_����_������� = false;
extern bool           �������������_������� = false;
extern bool                  �����_�������� = false;
extern bool        ���������_������_�_����� = true;
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
  if(���������_�����������_������<1 ){ZzPeriod=Period();}
  if(���������_�����������_������==1){ZzPeriod=1;}
  if(���������_�����������_������==2){ZzPeriod=5;}
  if(���������_�����������_������==3){ZzPeriod=15;}
  if(���������_�����������_������==4){ZzPeriod=30;}
  if(���������_�����������_������==5){ZzPeriod=60;}
  if(���������_�����������_������==6){ZzPeriod=240;}
  if(���������_�����������_������>=7){ZzPeriod=1440;}
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
  Comment("������ = ",AccountProfit(),"\n�����  = ",AccountMargin(),"\nMax �����  = ",mxzal,"\n�������� = ",mxdrdn,"\n������� = ",mxord);
//----
  
//----
  if(��������_����_�������){ProfitTraling();}
//----  
  if(NewBar()){
    if(Err147){DelOldOrders();}
    if(������_�������_���_���������){
      ReadZZ(����������_�����_�������);
    }else{
      ReadFr(����������_�����_�������);
    } 
//----
  if(�������������_�������){TimeSetAuto();}
//---- 
  if(�������������_�������){
    ���_��������_1=res[0];
    �����_���������_�_�����_1=res[1]-res[0];
  } 
  if(Trade(���_��������_1,������_��������_1)){
        SetOrders(���_������_1,
     �����_���������_�_�����_1,
 ���_���������_��_����������_1,
                        magic1,
        �����_������_�_�����_1,
             ��������_������_1,
           ����������_������_1
    );
  }
  if(���_������_2==0)return;
  if(�������������_�������){
    ���_��������_2=res[1];
    �����_���������_�_�����_2=res[2]-res[1];
  }  
  if(�����_��������){��������_������_2=��������_������_1;}
  if(Trade(���_��������_2,������_��������_2)){
        SetOrders(���_������_2,
     �����_���������_�_�����_2,
 ���_���������_��_����������_2,
                        magic2,
        �����_������_�_�����_2,
             ��������_������_2,
           ����������_������_2
    );
  }  
  if(���_������_3==0)return;
  if(�������������_�������){
    ���_��������_3=res[2];
    �����_���������_�_�����_2=res[3]-res[2];
  }  
  if(�����_��������){��������_������_3=��������_������_1;}
  if(Trade(���_��������_3,������_��������_3)){
        SetOrders(���_������_3,
     �����_���������_�_�����_3,
 ���_���������_��_����������_3,
                        magic3,
        �����_������_�_�����_3,
             ��������_������_3,
           ����������_������_3
    );
  }  
  if(���_������_4==0)return;
  if(�������������_�������){
    ���_��������_3=res[3];
    �����_���������_�_�����_3=24-res[3];
  }  
  if(�����_��������){��������_������_4=��������_������_1;}
  if(Trade(���_��������_3,������_��������_4)){
        SetOrders(���_������_4,
     �����_���������_�_�����_4,
 ���_���������_��_����������_4,
                        magic4,
        �����_������_�_�����_4,
             ��������_������_4,
           ����������_������_4
    );
  }  
  }
return;}
//+------------------------------------------------------------------+
//|  ���� ����� ����\���� ��������� ����                             |
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
//| �������� �������                                                 |
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
//|  ���������� ��������� ����� ��� ��������� �������                |
//+------------------------------------------------------------------+
void TimeSetAuto(){
  if(TimeHour(TimeCurrent())==0){
    int time[24];
    for(int p=0;p<(����������_�����_�������/24);p++){
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
//|  ���� ���� �������                                               |
//+------------------------------------------------------------------+
int IfPrise(double up,double dn){
  ArraySort(ZZ,WHOLE_ARRAY,0,MODE_DESCEND );
  if(NormalizeDouble(up,Digits)==NormalizeDouble(ZZ[0],Digits)){return( 1);}
  ArraySort(ZZ,WHOLE_ARRAY,0,MODE_ASCEND );
  if(NormalizeDouble(dn,Digits)==NormalizeDouble(ZZ[0],Digits)){return(-1);}  
  return(0);
}
//+------------------------------------------------------------------+
//|  ������ �������                                                  |
//+------------------------------------------------------------------+
void SetOrders(int typ,int ordtime,int mindistanse,int magic,double lot,double sl=0,double tp=0){
  Print("trade");
  double sll,tpp;
  int ticket,err;
  double buy =NormalizeDouble(UpPrise(NormalizeDouble(Ask,Digits),mindistanse),Digits);
  double sell=NormalizeDouble(DnPrise(NormalizeDouble(Bid,Digits),mindistanse),Digits);  
  int stlw=MarketInfo(Symbol(),MODE_STOPLEVEL);
  int timecl=TimeCurrent()+ordtime*3600;
  if(�������������_����_������){
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
         if(ticket<1){// ��������� ������
           err=GetLastError();
           if(err==147){// ���������� ������� ���������
             Err147=true;
             ticket=OrderSend(Symbol(),3,lot,buy,3*mno,sll,tpp,NULL,magic,0,Red);
             if(ticket>0){
               WriteOrder(ticket,timecl);
             }else{
               err=GetLastError();
               if(err==130){
                 if(���������_������_�_�����){
                   RefreshRates();
                   ticket=OrderSend(Symbol(),1,lot,Bid,3*mno,sll,tpp,NULL,magic,0,Red);
                   if(ticket<1){
                     err=GetLastError();
                     Print("������ ��������� ������ � �����  � ",err,
                           "  ��� ������ = ����  ",
                           "  ���� �������� =",Bid,
                           "  ���� = ",Bid,
                           "  �������� = ",sll,
                           "  ���������� = ",tpp);
                   }
                 }else{
                 
                 }
               }
             }
           }
               if(err==130){
                 if(���������_������_�_�����){
                   RefreshRates();
                   ticket=OrderSend(Symbol(),1,lot,Bid,3*mno,sll,tpp,NULL,magic,0,Red);
                   if(ticket<1){
                     err=GetLastError();
                     Print("������ ��������� ������ � �����  � ",err,
                           "  ��� ������ = ����  ",
                           "  ���� �������� =",Bid,
                           "  ���� = ",Bid,
                           "  �������� = ",sll,
                           "  ���������� = ",tpp);
                   }
                 }else{
                 
                 }
               }           
           Print("3  ������ ��������� ������ � ",err);
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
         if(ticket<1){// ��������� ������
           err=GetLastError();
           if(err==147){// ���������� ������� ���������
             Err147=true;
             ticket=OrderSend(Symbol(),2,lot,sell,3*mno,sll,tpp,NULL,magic,0, Blue);
             if(ticket>0){
               WriteOrder(ticket,timecl);
             }else{
               err=GetLastError();
               if(err==130){
                 if(���������_������_�_�����){
                   RefreshRates();
                   ticket=OrderSend(Symbol(),0,lot,Ask,3*mno,sll,tpp,NULL,magic,0,Blue);
                   if(ticket<1){
                     err=GetLastError();
                     Print("������ ��������� ������ � �����  � ",err,
                           "  ��� ������ = BUY  ",
                           "  ���� �������� =",Ask,
                           "  ���� = ",Ask,
                           "  �������� = ",sll,
                           "  ���������� = ",tpp);
                   }
                 }else{
                 
                 }
               }                 
             }
           }     
               if(err==130){
                 if(���������_������_�_�����){
                   RefreshRates();
                   ticket=OrderSend(Symbol(),0,lot,Ask,3*mno,sll,tpp,NULL,magic,0,Blue);
                   if(ticket<1){
                     err=GetLastError();
                     Print("������ ��������� ������ � �����  � ",err,
                           "  ��� ������ = BUY  ",
                           "  ���� �������� =",Ask,
                           "  ���� = ",Ask,
                           "  �������� = ",sll,
                           "  ���������� = ",tpp);
                   }
                 }else{
                 
                 }
               }                  
           Print("2  ������ ��������� ������ � ",err);
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
         if(ticket<1){// ��������� ������
           err=GetLastError();
           if(err==147){// ���������� ������� ���������
             Err147=true;
             ticket=OrderSend(Symbol(),4,lot,buy,3*mno,sll,tpp,NULL,magic,0,Blue);
             if(ticket>0){
               WriteOrder(ticket,timecl);
             }else{
               err=GetLastError();
               if(err==130){
                 if(���������_������_�_�����){
                   RefreshRates();
                   ticket=OrderSend(Symbol(),0,lot,Ask,3*mno,sll,tpp,NULL,magic,0,Blue);
                   if(ticket<1){
                     err=GetLastError();
                     Print("������ ��������� ������ � �����  � ",err,
                           "  ��� ������ = BUY  ",
                           "  ���� �������� =",Ask,
                           "  ���� = ",Ask,
                           "  �������� = ",sll,
                           "  ���������� = ",tpp);
                   }
                 }else{
                 
                 }
               }               
             }  
           }
               if(err==130){
                 if(���������_������_�_�����){
                   RefreshRates();
                   ticket=OrderSend(Symbol(),0,lot,Ask,3*mno,sll,tpp,NULL,magic,0,Blue);
                   if(ticket<1){
                     err=GetLastError();
                     Print("������ ��������� ������ � �����  � ",err,
                           "  ��� ������ = BUY  ",
                           "  ���� �������� =",Ask,
                           "  ���� = ",Ask,
                           "  �������� = ",sll,
                           "  ���������� = ",tpp);
                   }
                 }else{
                 
                 }
               }                       
           Print("4  ������ ��������� ������ � ",err);
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
         if(ticket<1){// ��������� ������
           err=GetLastError();
           if(err==147){// ���������� ������� ���������
             Err147=true;
             ticket=OrderSend(Symbol(),5,lot,sell,3*mno,sll,tpp,NULL,magic,0, Red);
             if(ticket>0){
               WriteOrder(ticket,timecl);
             }else{
               err=GetLastError();
               if(err==130){
                 if(���������_������_�_�����){
                   RefreshRates();
                   ticket=OrderSend(Symbol(),1,lot,Bid,3*mno,sll,tpp,NULL,magic,0,Red);
                   if(ticket<1){
                     err=GetLastError();
                     Print("������ ��������� ������ � �����  � ",err,
                           "  ��� ������ = SELL  ",
                           "  ���� �������� =",Bid,
                           "  ���� = ",Bid,
                           "  �������� = ",sll,
                           "  ���������� = ",tpp);
                   }
                 }else{
                 
                 }
               }               
             }      
           } 
               if(err==130){
                 if(���������_������_�_�����){
                   RefreshRates();
                   ticket=OrderSend(Symbol(),1,lot,Bid,3*mno,sll,tpp,NULL,magic,0,Red);
                   if(ticket<1){
                     err=GetLastError();
                     Print("������ ��������� ������ � �����  � ",err,
                           "  ��� ������ = SELL  ",
                           "  ���� �������� =",Bid,
                           "  ���� = ",Bid,
                           "  �������� = ",sll,
                           "  ���������� = ",tpp);
                   }
                 }else{
                 
                 }
               }                 
           Print("5  ������ ��������� ������ � ",err);
         }                
       }  
     }
   } 
 }
return;
} 
//+------------------------------------------------------------------+
//|  ������ ������ � ������ ��� �������������� ��������              |
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
//|  ������ ������ ������� � ������� ������� � �������� ������       |
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
//| ������ ���� ����� ����� � �������                                          |
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
//|  ����� ��������� ������ ����������� � ����                       |
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
// ���� ���� ������� ������                                                    |
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
//|   ���� ���������� ���� ������                                    |
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
//|   ���� ���������� ���� �����                                     |
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
//|  �������� ���������� � ������                                    |
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
//|  �������� ���������� ��������� � ������                          |
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
//| ������������ ���������� �������� ������� �������� ��������       |
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
// ������� �������� ������ ����                                                |
//-----------------------------------------------------------------------------+
bool NewBar(){
   static int PrevTime=0;
   if (PrevTime==Time[0]) return(false);
   PrevTime=Time[0];
   return(true);}   

