
//+------------------------------------------------------------------+
//|                                                    NightMare.mq4 |
//|                                     Copyright � 2010, NutCracher |
//|                                              forex-way@yandex.ru |
//|                                              http://wellforex.ru |
//-------------------------------------------------------------------+

#property copyright "Copyright � 2010, http://wellforex.ru"
#property link      "forex-way@yandex.ru"
extern string   ParamertSet = "��������� ��������";
extern int      K=20;                         //K - �������� ����������
extern int      S=27;                         //S - �������� ����������
extern double   Stop_Loss=29;                 //��������
extern double   Take_Profit=18;               //����������
extern double   L_open=12;                    //������� ���������������/���������������
extern int      StartTime=19;                 //����� ������ ������ ��������
extern int      EndTime=2;                    //����� ��������� ������ ��������
extern string   BrokerSet = "��������� ��";  
extern int      NumberOfDigit=5;               //���������� ������ � ���������� ��������� �������: 4 ��� 5
extern string   MMSet = "���������� ���������";
extern bool     MM=false;                      // ��������� ��
extern double   MMRisk=0.1;                    // ����-������
extern double   Lots = 0.1;                    //��� �� ���������


#define MAGICMA  20050610
double SMain_current_M15; double SMain_past_M15, MA_cur, MA_past;
int MODE_AV;
int res, D=1, Dec;

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

   if(Volume[0]>1) return;

     
      SMain_current_M15=iStochastic(NULL,PERIOD_M5,K,D,S,MODE_AV,1,MODE_MAIN,1);    
      SMain_past_M15=iStochastic(NULL,PERIOD_M5,K,D,S,MODE_AV,1,MODE_MAIN,2);  
      

      if ((SMain_current_M15>L_open && SMain_past_M15<L_open)) 
    
      {
      res=OrderSend(Symbol(),OP_BUY,Lots,Ask,3*Dec,Bid-Stop_Loss*Dec*Point,Ask+Take_Profit*Dec*Point,"",MAGICMA,0,Blue);
      if(res>0)
           {
            if(OrderSelect(res,SELECT_BY_TICKET,MODE_TRADES)) Print("BUY �� ���� : ",OrderOpenPrice());
            }
         else 
         {
         Print("Error opening BUY order : ",GetLastError()); 
         }
      }

      if ((SMain_current_M15<100-L_open && SMain_past_M15>100-L_open))
      
      {
      res=OrderSend(Symbol(),OP_SELL,Lots,Bid,3*Dec,Ask+Stop_Loss*Dec*Point,Bid-Take_Profit*Dec*Point,"",MAGICMA,0,Red);
      if(res>0)
           {
            if(OrderSelect(res,SELECT_BY_TICKET,MODE_TRADES)) Print("SELL �� ���� : ",OrderOpenPrice());
            }
         else 
         {
         Print("Error opening BUY order : ",GetLastError()); 
        }
        }
       
      return;
      }

int deinit()
  {

   return(0);
  }

int start()
  {
  
   if (MM) Lots = MoneyManagement (MM,MMRisk);
   if (NumberOfDigit==4) Dec=1;
   if (NumberOfDigit==5) Dec=10;     
   
   MODE_AV=MODE_EMA;
  
   if(Bars<100 || IsTradeAllowed()==false) return;

   if(CalculateCurrentOrders(Symbol())==0)
   {
   if (Hour()>StartTime) CheckForOpen();
   if (Hour()<EndTime) CheckForOpen();  
   }                           
   return(0);
  }
//+------------------------------------------------------------------+