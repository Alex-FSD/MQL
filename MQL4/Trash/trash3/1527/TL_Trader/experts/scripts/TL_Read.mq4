/****************************************************************
 ОБРАЗЦОВАЯ ТОРГОВЛЯ: TL_Read - отрисовка образцовых линий из файла
 Copyright © 2006-2008, Сергей Кравчук. http://forextools.com.ua
*****************************************************************/

#include <WinUser32.mqh>

#define _prefix_ "TL_"
#property show_inputs

extern string FileNameForRead = "TL_DATA.TXT";

int start()
{
  int LinesCNT=0,i; 
  
  int fh=FileOpen(FileNameForRead,FILE_CSV|FILE_READ,';');
  if(fh<0) { MessageBox("Ошибка открытия файла \"" + FileNameForRead + "\"","ОШИБКА", IDOK + MB_ICONERROR); return(1); }

  // сначала все удалим
  for(i=0;i<ObjectsTotal();i++) { if(StringFind(ObjectName(i),_prefix_)==0) { ObjectDelete(ObjectName(i)); i--; } }

  // обойдем все линии которые создали и запишем из них команды открытий для эксперта
  while(true)
  {
    string Operation=FileReadString(fh);
    
    if(FileIsEnding(fh)) break; // файл закончился? - выходим
    
    // считаем координаты отрезка
    datetime t1=StrToTime(FileReadString(fh));
    double   p1=StrToDouble(FileReadString(fh));
    datetime t2=StrToTime(FileReadString(fh));
    double   p2=StrToDouble(FileReadString(fh));

    // нарисуем отрезок
    LinesCNT++;
    string LineName = _prefix_+Operation+(LinesCNT);  // создадим имя для новой линии
    ObjectCreate(LineName,OBJ_TREND,0,t1,p1, t2,p2);  // создадим линию
    ObjectSet(LineName,OBJPROP_RAY,False); // сделаем ее отрезком а не лучом
    ObjectSet(LineName,OBJPROP_WIDTH,2);   // зададим ширину
    if(Operation=="B") ObjectSet(LineName,OBJPROP_COLOR,Blue); else  ObjectSet(LineName,OBJPROP_COLOR,Red);// зададим цвет

  }
  FileClose(fh);
  
  MessageBox("Считано отрезков "+(LinesCNT)+" шт.","Готово", IDOK + MB_ICONINFORMATION);
}  

