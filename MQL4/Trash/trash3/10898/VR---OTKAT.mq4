//+------------------------------------------------------------------+
//|                                                   VR---OTKAT.mq4 |
//|                                                      Voldemar227 |
//|                                         http://www.trading-go.ru |
//+------------------------------------------------------------------+
#property copyright "Voldemar227"
#property link      "http://www.trading-go.ru"
int start ()
  {
  if (IsTesting() == true)
   {
   Fun_Code();
   }
  else
   {
   while(!IsStopped())
   {
   Fun_Code();
   Sleep(50); 
   }
  }
 }
///======================================================================================================///
int Fun_Code()
  {
color cvet=Blue;
int w;
int ur;
double pi;
for(int x=0;x<=5;x++)
{
if (x==0||x==4){cvet=Blue;w=2;}
else {cvet=Blue;w=1;}
ObjectCreate("A"+x,OBJ_TREND,0,Time[0]-(Period()*60*20), Ask+NormalizeDouble(300*x*Point,Digits),Time[0]+(Period()*60*20),Ask+NormalizeDouble(300*x*Point,Digits));
ObjectSet   ("A"+x,OBJPROP_RAY,false);
ObjectSet   ("A"+x,OBJPROP_COLOR,cvet);
ObjectSet   ("A"+x,OBJPROP_WIDTH,w);

if (x==0)ur=0;
if (x==1)ur=30;
if (x==2)ur=50;
if (x==3)ur=70;
if (x==4)ur=100;
if (x==5)ur=160;
ObjectCreate ("ldl"+x,OBJ_TEXT,0,0,0,0,0);
ObjectSetText("ldl"+x,"U "+DoubleToStr(ur,2), 10, "Times New Roman",Red);
ObjectSet    ("ldl"+x,OBJPROP_COLOR,Blue);
}
ObjectSet("ldl"+0,OBJPROP_PRICE1,ObjectGet("A"+0,OBJPROP_PRICE2));
ObjectSet("ldl"+0,OBJPROP_TIME1 ,ObjectGet("A"+0,OBJPROP_TIME2 ));

ObjectSet("ldl"+1,OBJPROP_PRICE1,ObjectGet("A"+1,OBJPROP_PRICE2));
ObjectSet("ldl"+1,OBJPROP_TIME1 ,ObjectGet("A"+1,OBJPROP_TIME2 ));

ObjectSet("ldl"+2,OBJPROP_PRICE1,ObjectGet("A"+2,OBJPROP_PRICE2));
ObjectSet("ldl"+2,OBJPROP_TIME1 ,ObjectGet("A"+2,OBJPROP_TIME2 ));

ObjectSet("ldl"+3,OBJPROP_PRICE1,ObjectGet("A"+3,OBJPROP_PRICE2));
ObjectSet("ldl"+3,OBJPROP_TIME1 ,ObjectGet("A"+3,OBJPROP_TIME2 ));

ObjectSet("ldl"+4,OBJPROP_PRICE1,ObjectGet("A"+4,OBJPROP_PRICE2));
ObjectSet("ldl"+4,OBJPROP_TIME1 ,ObjectGet("A"+4,OBJPROP_TIME2 ));

ObjectSet("ldl"+5,OBJPROP_PRICE1,ObjectGet("A"+5,OBJPROP_PRICE2));
ObjectSet("ldl"+5,OBJPROP_TIME1 ,ObjectGet("A"+5,OBJPROP_TIME2 ));

double ons = ObjectGet("A"+0,OBJPROP_PRICE1);
double one = ObjectGet("A"+0,OBJPROP_PRICE2);
double ots = ObjectGet("A"+0,OBJPROP_TIME1);
double ote = ObjectGet("A"+0,OBJPROP_TIME2);

double ons4 = ObjectGet("A"+4,OBJPROP_PRICE1);
double one4 = ObjectGet("A"+4,OBJPROP_PRICE2);
double ots4 = ObjectGet("A"+4,OBJPROP_TIME1);
double ote4 = ObjectGet("A"+4,OBJPROP_TIME2);
WindowRedraw();
ObjectSet("A"+0,OBJPROP_PRICE2,ons);
ObjectSet("A"+4,OBJPROP_PRICE2,ons4);
ObjectSet("A"+4,OBJPROP_TIME1,ots);
ObjectSet("A"+4,OBJPROP_TIME2,ote);
WindowRedraw();
ObjectSet("A"+2,OBJPROP_PRICE1,(ons+ons4)/2);
ObjectSet("A"+2,OBJPROP_PRICE2,(ons+ons4)/2);
ObjectSet("A"+2,OBJPROP_TIME1,ots);
ObjectSet("A"+2,OBJPROP_TIME2,ote);
WindowRedraw();
ObjectSet("A"+1,OBJPROP_PRICE1,ons+(ons4-ons)/3);
ObjectSet("A"+1,OBJPROP_PRICE2,ons+(ons4-ons)/3);
ObjectSet("A"+1,OBJPROP_TIME1,ots);
ObjectSet("A"+1,OBJPROP_TIME2,ote);
WindowRedraw();
ObjectSet("A"+3,OBJPROP_PRICE1,ons+(ons4-ons)/3*2);
ObjectSet("A"+3,OBJPROP_PRICE2,ons+(ons4-ons)/3*2);
ObjectSet("A"+3,OBJPROP_TIME1,ots);
ObjectSet("A"+3,OBJPROP_TIME2,ote);
WindowRedraw();
ObjectSet("A"+5,OBJPROP_PRICE1,ons+(ons4-ons)/3*5);
ObjectSet("A"+5,OBJPROP_PRICE2,ons+(ons4-ons)/3*5);
ObjectSet("A"+5,OBJPROP_TIME1,ots);
ObjectSet("A"+5,OBJPROP_TIME2,ote);
WindowRedraw();
RefreshRates();

double it;
ObjectCreate("l",OBJ_TRENDBYANGLE,0,Time[0]-(Period()*60*20),ons,Time[0]+(Period()*60*20),Ask+NormalizeDouble(300*x*Point,Digits));
ObjectSet   ("l",OBJPROP_RAY,false);
ObjectSet   ("l",OBJPROP_COLOR,Red);
ObjectSet   ("l",OBJPROP_WIDTH,2);
double ug=ObjectGet("l",OBJPROP_ANGLE);
ObjectSet("l",OBJPROP_PRICE1,ons);
ObjectSet("l",OBJPROP_TIME1 ,ots);
WindowRedraw();
RefreshRates();
ObjectSet("l",OBJPROP_PRICE2,one4);
ObjectSet("l",OBJPROP_TIME2 ,ote4);
if (ons<ons4)it=ug;else it=360-ug;
ObjectCreate ("ll",OBJ_TEXT,0,Time[0],ons,0,0);
ObjectSetText("ll","C "+DoubleToStr(it,2), 10, "Times New Roman",Red);

ObjectSet("ll",OBJPROP_PRICE1,ons);
ObjectSet("ll",OBJPROP_TIME1 ,ots);
WindowRedraw();
RefreshRates();
}