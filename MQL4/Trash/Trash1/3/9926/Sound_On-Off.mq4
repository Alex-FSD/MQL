//+------------------------------------------------------------------+
//|                                                 Sound_On-Off.mq4 |
//|                                   Copyright � 2010, Korvin � Co. |
//|                                         http://alecask.narod.ru/ |
//+------------------------------------------------------------------+
#property copyright "Copyright � 2010, Korvin � Co."
#property link      "http://alecask.narod.ru/"
#property show_inputs
#define QUESTION "�������� ��� ��������� ���� ?!"
extern string msg1 = QUESTION;
extern bool SoundOn;
//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
if (SoundOn) {GlobalVariableSet("Sound", 1); msg1 = "���� ����ר� !!!";}
else {GlobalVariableSet("Sound", 0); msg1 = "���� ����ר� !!!";}
Alert(msg1);
   return(0);
  }
//+------------------------------------------------------------------+