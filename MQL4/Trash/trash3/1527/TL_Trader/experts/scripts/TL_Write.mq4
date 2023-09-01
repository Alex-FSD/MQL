/****************************************************************
 ���������� ��������: TL_Write - ������ ��������� ���������� ����� � ����
 Copyright � 2006-2008, ������ �������. http://forextools.com.ua
*****************************************************************/

#include <WinUser32.mqh>

#define _prefix_ "TL_"
#property show_inputs

extern string FileNameForWrite = "TL_DATA.TXT";

int start()
{
  int LinesCNT=0,i; string Operation; double p; datetime t;
  
  int fh=FileOpen(FileNameForWrite,FILE_CSV|FILE_WRITE,';');

  // ������� ��� ����� ������� ������� � ������� �� ��� ������� �������� ��� ��������
  for(i=0;i<ObjectsTotal();i++) 
  {
    if(StringFind(ObjectName(i),_prefix_)==0) // ���� ������
    {
      string LineName = ObjectName(i);  

      datetime t1=ObjectGet(LineName,OBJPROP_TIME1);
      datetime t2=ObjectGet(LineName,OBJPROP_TIME2);

      double p1=ObjectGet(LineName,OBJPROP_PRICE1);
      double p2=ObjectGet(LineName,OBJPROP_PRICE2);

      LinesCNT++; // �������� ������� ��� ������ ��������� ���������
      
      Operation = StringSubstr(ObjectName(i),StringLen(_prefix_),1); 
      
      FileWrite(fh,Operation,TimeToStr(t1),DoubleToStr(p1,Digits),TimeToStr(t2),DoubleToStr(p2,Digits)); // ���� ����� ������ ����� ������������ ����� �� �������
    }
  }
  
  FileClose(fh);
  
  MessageBox("�������� �������� "+(LinesCNT)+" ��.","������", IDOK + MB_ICONINFORMATION);
}  

