//--------------------------------------------------------------------
// timebars.mq4
// ������������ ��� ������������� � �������� ������� � �������� MQL4.
//--------------------------------------------------------------------
int start()                            // ����. ������� start
  {
   Alert("TimeCurrent=",TimeToStr(TimeCurrent(),TIME_SECONDS),
         " Time[0]=",TimeToStr(Time[0],TIME_SECONDS));
   return;                             // ����� �� start()
  }
//--------------------------------------------------------------------