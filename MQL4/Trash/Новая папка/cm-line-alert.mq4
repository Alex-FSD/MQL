//+------------------------------------------------------------------+
//|                                                cm line alert.mq5 |
//|                                Copyright 2021, cmillion@narod.ru |
//|                                          https://www.cmillion.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, cmillion@narod.ru"
#property link      "https://www.cmillion.ru"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
/*Советник отправляет сообщение при достижении каждой линии на графике. 
Пересечение линии и цены считается, если Ask выше или равен линии и Bid ниже или равен линии.
У каждой линии можно задать любое имя и оно будет как раз и отображаться в сообщении.
После отправки сообщения линия удаляется.
Рисуете горизонтальную линию, даете ей имя, например "EURUSD 1.23545 50%" и как только цена ее цепляет, так отправляется сообщение на почту. 
Можно рисовать любое число линий.
//+------------------------------------------------------------------+*/
void OnTick()
{
   double price;
   string name;
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   #ifdef __MQL5__
   double Bid=SymbolInfoDouble(Symbol(),SYMBOL_BID);
   double Ask=SymbolInfoDouble(Symbol(),SYMBOL_ASK);
   #endif
   int n=0;
   for(int i=ObjectsTotal(#ifdef __MQL5__ 0#endif)-1; i>=0; i--)
   {
      name=ObjectName(0,i);
      if (StringFind(name,"#",0)!=-1) continue;
      if (ObjectGetInteger(0,name,OBJPROP_TYPE)!=OBJ_HLINE && ObjectGetInteger(0,name,OBJPROP_TYPE)!=OBJ_TREND) continue; 
      price=0;
      if (!ObjectGetDouble(0,name,OBJPROP_PRICE,0,price)) continue;
      if (price==0) continue;
      n++;
      if (Ask>=price && Bid<=price)
      {
         alert(name);
         ObjectDelete(0,name);
      }
   }
   if (n==0) Comment(TerminalInfoString(TERMINAL_LANGUAGE)=="Russian"?"Установите на экран любую горизонтальную линию":"Set horizontal line on the screen");
   else Comment(n," line ");
}
//+------------------------------------------------------------------+
void alert(string txt)
{
   Alert(txt);

   SendMail("cm line alert",txt);
}
//+------------------------------------------------------------------+
