/****************************************************************
 ОБРАЗЦОВАЯ ТОРГОВЛЯ: TL_Clear - удаление всех образцовых линий
 Copyright © 2006-2008, Сергей Кравчук. http://forextools.com.ua
*****************************************************************/

#include <WinUser32.mqh>

#define _prefix_ "TL_"

int start()
{
  int LinesCNT=0,i;
  
  for(i=0;i<ObjectsTotal();i++) 
  {
    if(StringFind(ObjectName(i),_prefix_)==0) { ObjectDelete(ObjectName(i)); i--; LinesCNT++; }
  }
}  

