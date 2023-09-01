//+------------------------------------------------------------------+
//|                                                        Panel.mq4 |
//|                                              Copyright 2016, AM2 |
//|                                      http://www.forexsystems.biz |
//+------------------------------------------------------------------+

#property copyright "Copyright 2015, AM2"
#property link      "https://www.forexsystems.biz"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   PutButton("B",50,50,"BUY");
   PutButton("S",150,50,"SELL");
   PutButton("C",250,50,"CLOSE");

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PutButton(string name,int x,int y,string text)
  {
   ObjectCreate(0,name,OBJ_BUTTON,0,0,0);

//--- ��������� ���������� ������
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
//--- ��������� ������ ������
   ObjectSetInteger(0,name,OBJPROP_XSIZE,80);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,30);
//--- ��������� ���� �������, ������������ �������� ����� ������������ ���������� �����
   ObjectSetInteger(0,name,OBJPROP_CORNER,2);
//--- ��������� �����
   ObjectSetString(0,name,OBJPROP_TEXT,text);
//--- ��������� ����� ������
   ObjectSetString(0,name,OBJPROP_FONT,"Arial");
//--- ��������� ������ ������
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,12);
//--- ��������� ���� ������
   ObjectSetInteger(0,name,OBJPROP_COLOR,Red);
//--- ��������� ���� ����
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,White);
//--- ��������� ���� �������
   ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,Blue);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PutOrder(int type,double price)
  {
   int r=0;
   color clr=Green;

   if(type==1 || type==3 || type==5)
     {
      clr=Red;
     }

   if(type==0 || type==2 || type==4)
     {
      clr=Blue;
     }

   r=OrderSend(NULL,type,0.1,NormalizeDouble(price,Digits),100,0,0,"",123,0,clr);
   return;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ClosePos(int ot=-1)
  {
   bool cl;
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol())
           {
            if(OrderType()==0 && (ot==0 || ot==-1))
              {
               RefreshRates();
               cl=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Bid,Digits),100,White);
              }
            if(OrderType()==1 && (ot==1 || ot==-1))
              {
               RefreshRates();
               cl=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Ask,Digits),100,White);
              }
           }
        }
     }
  }  
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//--- �������� ������� �� ������� ������ �����
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      string clickedChartObject=sparam;
      //--- ���� ������� �� ������� � ������ "B"
      if(clickedChartObject=="B")
        {
         PutOrder(0,Ask);
        }

      if(clickedChartObject=="S")
        {
         PutOrder(1,Bid);
        }

      if(clickedChartObject=="C")
        {
         ClosePos();
        }

      ChartRedraw();// ������������� ���������� ��� ������� �� �������
     }
  }
//+------------------------------------------------------------------+
