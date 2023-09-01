/****************************************************************
 ���������� ��������: TL_Sell - �������� ����� ���������� ����� �������
 Copyright � 2006-2008, ������ �������. http://forextools.com.ua
*****************************************************************/


#include <WinUser32.mqh>

#define _prefix_ "TL_"

int start()
{
  int MaxNo=0,i,No; 
  
  if(WindowOnDropped()!=0) { MessageBox("������ ����� ���������� � ������� ����","������", IDOK + MB_ICONERROR); return(1); }

  // ������ ������������ ����� ������� ���� �����
  for(i=0;i<ObjectsTotal();i++) 
  {
    if(StringFind(ObjectName(i),_prefix_)==0) 
    {
      No=StrToInteger(StringSubstr(ObjectName(i),StringLen(_prefix_)+1)); // ������� ����� �����
      if(MaxNo<No) MaxNo=No; // �������� ��� ���� �� ������
    }
  }
  
  datetime t0=WindowTimeOnDropped(); double p0=WindowPriceOnDropped(); // ��������� ���������� ����� ������ �������

  int width = 5*Period()*60;                             // ������ ����������� ����� � ����� ������������ �� �����
  double height = 20*MarketInfo(Symbol(),MODE_TICKSIZE); // ������ ����������� ����� � ����� ������������ � ����
  
  string LineName = _prefix_+"S"+(MaxNo+1);  // �������� ��� ��� ����� �����
  ObjectCreate(LineName,OBJ_TREND,0,t0-width,p0+height, t0+width,p0-height); // �������� �����
  ObjectSet(LineName,OBJPROP_RAY,False); // ������� �� �������� � �� �����
  ObjectSet(LineName,OBJPROP_WIDTH,2);   // ������� ������
  ObjectSet(LineName,OBJPROP_COLOR,Red); // ������� ����

}  

