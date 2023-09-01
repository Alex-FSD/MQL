/****************************************************************
 ���������� ��������: TL_Trader - �������� �� ���������� ������
 Copyright � 2006-2008, ������ �������. http://forextools.com.ua
*****************************************************************/

#include <WinUser32.mqh>

#define _prefix_ "TL_"

extern string FileNameForRead = "TL_DATA.TXT";
extern double Lots = 0.1;
extern double StopLoss = 0;
extern double TrailingStop = 30;
extern bool   ProcedTrailing=true; // ������������ ���� ���������

double SL; // ��� ������� �������� ���� ��� �������� ������

int start()
{
  int LinesCNT=0,i,ticket,pos; double p; datetime t; string s;

  int fh=FileOpen(FileNameForRead,FILE_CSV|FILE_READ,';'); // ��� ������������ ���� ����� �������� � tester\files\TL_DATA.txt

  if(fh<0) { MessageBox("������ �������� ����� \"" + FileNameForRead + "\"","������", IDOK + MB_ICONERROR); return(1); }

  // �������� ��� ������: ���� ����� �������� ��� ������ � ������ � ����� �������� ��� �� � ������� �� � ��������
  // ������ �� ��� �� ���������� - ������� ��� ��� �������

  while(true)
  {
    string Operation=FileReadString(fh);
    
    if(FileIsEnding(fh)) break; // ���� ����������? - �������
    
    // ������� ���������� �������
    string st1=FileReadString(fh);
    string sp1=FileReadString(fh);
    string st2=FileReadString(fh);
    string sp2=FileReadString(fh);
    datetime t1=StrToTime(st1);
    double   p1=StrToDouble(sp1);
    datetime t2=StrToTime(st2);
    double   p2=StrToDouble(sp2);
    
  
    // � ����� ����� �������� ����������?
    if(t1>t2) { p=p1; p1=p2; p2=p; t=t1; t1=t2; t2=t;  s=st1; st1=st2; st2=s; s=sp1; sp1=sp2; sp2=s; } 

    string MarkComent = t1+"="+t2;
    
    //*****************************************************************
    // 1) ���� �������� ������� �� ������� � ����� ����������� �������.
    //*****************************************************************
    for(i=0;i<OrdersTotal();i++)
    {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) continue;
      if(OrderComment()==MarkComent && TimeCurrent()>=t2) // ����� ����� �������
      {
        if(OrderType()==OP_BUY) OrderClose(OrderTicket(),OrderLots(),Bid,3,Violet); // close position
        else OrderClose(OrderTicket(),OrderLots(),Ask,3,Violet); // close position
      }
    }

    //****************************************************************
    // 2) ���� �������� ������� �� ������� ������ ����������� �������.
    //****************************************************************
    bool OrderNotPresent=true; // ������� ��� ������ ������ �� ��� �� ���������
    if(t1<=TimeCurrent() && TimeCurrent()<t2) // ���� ����������� - �������� ��� ���� ����� �� ������ � �� ������
    {
      for(i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) continue;
        if(OrderComment()==MarkComent) { OrderNotPresent=false; break; } // ���� ����� �����
      }
      for(i=0;i<OrdersHistoryTotal() && OrderNotPresent;i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) continue;
        // � ����� � ������� ������������ � ����� ����� ����� "[sl]" - ��� ����� ��������!!
        pos = StringFind(OrderComment(),"[");
        string CurOrderComment = StringSubstr(OrderComment(),0,pos);
        if(CurOrderComment==MarkComent) { OrderNotPresent=false; break; } // ���� ����� �����
      }
      if(OrderNotPresent) // ������ ��� - �����������
      {
        // ������� �����
        if(Operation=="B") // �������
        { 
          if(StopLoss<=0) SL=0; else SL=Ask-StopLoss*Point;
          ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,3,SL,0,MarkComent,1235,0,Blue);
          OrderSelect(ticket,SELECT_BY_TICKET);
        }
        else // �������
        {
          if(StopLoss<=0) SL=0; else SL=Bid+StopLoss*Point;
          ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,3,SL,0,MarkComent,1235,0,Red);
          OrderSelect(ticket,SELECT_BY_TICKET);
        }
      }
    }
  }
  
  FileClose(fh);
 
  
  //******************************************************
  // 3) ���� ������������ ��������-����� � ������ � �����.
  //******************************************************
  if(ProcedTrailing)
  {
    for(i=0;i<OrdersTotal();i++)
    {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) continue;
      if(OrderType()==OP_BUY)
      {
        if(Bid-OrderOpenPrice()>Point*TrailingStop)
        {
         if(OrderStopLoss()<Bid-Point*TrailingStop)
           {
            OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Point*TrailingStop,OrderTakeProfit(),0,Green);
            return(0);
           }
        }
      }
      if(OrderType()==OP_SELL)
      {
       if((OrderOpenPrice()-Ask)>(Point*TrailingStop))
         {
          if((OrderStopLoss()>(Ask+Point*TrailingStop)) || (OrderStopLoss()==0))
            {
             OrderModify(OrderTicket(),OrderOpenPrice(),Ask+Point*TrailingStop,OrderTakeProfit(),0,Red);
             return(0);
            }
         }
      }
    }
  }
  
  return(0);
}

