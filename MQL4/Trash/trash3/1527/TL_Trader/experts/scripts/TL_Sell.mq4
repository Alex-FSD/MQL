/****************************************************************
 ќЅ–ј«÷ќ¬јя “ќ–√ќ¬Ћя: TL_Sell - создание новой образцовой линии продажи
 Copyright © 2006-2008, —ергей  равчук. http://forextools.com.ua
*****************************************************************/


#include <WinUser32.mqh>

#define _prefix_ "TL_"

int start()
{
  int MaxNo=0,i,No; 
  
  if(WindowOnDropped()!=0) { MessageBox("—крипт нужно сбрасывать в оснвное окно","ќЎ»Ѕ ј", IDOK + MB_ICONERROR); return(1); }

  // найдем максимальный номер суфикса всех линий
  for(i=0;i<ObjectsTotal();i++) 
  {
    if(StringFind(ObjectName(i),_prefix_)==0) 
    {
      No=StrToInteger(StringSubstr(ObjectName(i),StringLen(_prefix_)+1)); // выделим номер линии
      if(MaxNo<No) MaxNo=No; // запомним его если он больше
    }
  }
  
  datetime t0=WindowTimeOnDropped(); double p0=WindowPriceOnDropped(); // определим координаты точки сброса скрипта

  int width = 5*Period()*60;                             // ширина создаваемой линии в барах переведенна€ во врем€
  double height = 20*MarketInfo(Symbol(),MODE_TICKSIZE); // высота создаваемой линии в тиках переведенна€ в цену
  
  string LineName = _prefix_+"S"+(MaxNo+1);  // создадим им€ дл€ новой линии
  ObjectCreate(LineName,OBJ_TREND,0,t0-width,p0+height, t0+width,p0-height); // создадим линию
  ObjectSet(LineName,OBJPROP_RAY,False); // сделаем ее отрезком а не лучом
  ObjectSet(LineName,OBJPROP_WIDTH,2);   // зададим ширину
  ObjectSet(LineName,OBJPROP_COLOR,Red); // зададим цвет

}  

