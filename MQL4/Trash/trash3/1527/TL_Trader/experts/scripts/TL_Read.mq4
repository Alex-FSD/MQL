/****************************************************************
 ���������� ��������: TL_Read - ��������� ���������� ����� �� �����
 Copyright � 2006-2008, ������ �������. http://forextools.com.ua
*****************************************************************/

#include <WinUser32.mqh>

#define _prefix_ "TL_"
#property show_inputs

extern string FileNameForRead = "TL_DATA.TXT";

int start()
{
  int LinesCNT=0,i; 
  
  int fh=FileOpen(FileNameForRead,FILE_CSV|FILE_READ,';');
  if(fh<0) { MessageBox("������ �������� ����� \"" + FileNameForRead + "\"","������", IDOK + MB_ICONERROR); return(1); }

  // ������� ��� ������
  for(i=0;i<ObjectsTotal();i++) { if(StringFind(ObjectName(i),_prefix_)==0) { ObjectDelete(ObjectName(i)); i--; } }

  // ������� ��� ����� ������� ������� � ������� �� ��� ������� �������� ��� ��������
  while(true)
  {
    string Operation=FileReadString(fh);
    
    if(FileIsEnding(fh)) break; // ���� ����������? - �������
    
    // ������� ���������� �������
    datetime t1=StrToTime(FileReadString(fh));
    double   p1=StrToDouble(FileReadString(fh));
    datetime t2=StrToTime(FileReadString(fh));
    double   p2=StrToDouble(FileReadString(fh));

    // �������� �������
    LinesCNT++;
    string LineName = _prefix_+Operation+(LinesCNT);  // �������� ��� ��� ����� �����
    ObjectCreate(LineName,OBJ_TREND,0,t1,p1, t2,p2);  // �������� �����
    ObjectSet(LineName,OBJPROP_RAY,False); // ������� �� �������� � �� �����
    ObjectSet(LineName,OBJPROP_WIDTH,2);   // ������� ������
    if(Operation=="B") ObjectSet(LineName,OBJPROP_COLOR,Blue); else  ObjectSet(LineName,OBJPROP_COLOR,Red);// ������� ����

  }
  FileClose(fh);
  
  MessageBox("������� �������� "+(LinesCNT)+" ��.","������", IDOK + MB_ICONINFORMATION);
}  

