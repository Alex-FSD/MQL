/****************************************************************
 ОБРАЗЦОВАЯ ТОРГОВЛЯ: TL_Write - запись координат образцовых линий в файл
 Copyright © 2006-2008, Сергей Кравчук. http://forextools.com.ua
*****************************************************************/

#include <WinUser32.mqh>

#define _prefix_ "TL_"
#property show_inputs

extern string FileNameForWrite = "TL_DATA.TXT";

int start()
{
  int LinesCNT=0,i; string Operation; double p; datetime t;
  
  int fh=FileOpen(FileNameForWrite,FILE_CSV|FILE_WRITE,';');

  // обойдем все линии которые создали и запишем из них команды открытий для эксперта
  for(i=0;i<ObjectsTotal();i++) 
  {
    if(StringFind(ObjectName(i),_prefix_)==0) // наша линиия
    {
      string LineName = ObjectName(i);  

      datetime t1=ObjectGet(LineName,OBJPROP_TIME1);
      datetime t2=ObjectGet(LineName,OBJPROP_TIME2);

      double p1=ObjectGet(LineName,OBJPROP_PRICE1);
      double p2=ObjectGet(LineName,OBJPROP_PRICE2);

      LinesCNT++; // увеличим счетчик для выдачи итогового сообщения
      
      Operation = StringSubstr(ObjectName(i),StringLen(_prefix_),1); 
      
      FileWrite(fh,Operation,TimeToStr(t1),DoubleToStr(p1,Digits),TimeToStr(t2),DoubleToStr(p2,Digits)); // цены нужны только чтобы восстановить линии на графике
    }
  }
  
  FileClose(fh);
  
  MessageBox("Записано отрезков "+(LinesCNT)+" шт.","Готово", IDOK + MB_ICONINFORMATION);
}  

