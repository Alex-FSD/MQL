//+------------------------------------------------------------------+
//|                                                   TradePanel.mq4 |
//|                                              Copyright 2016, AM2 |
//|                                      http://www.forexsystems.biz |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, AM2"
#property link      "http://www.forexsystems.biz"
#property version   "1.00"
#property strict

#include <Controls\Dialog.mqh>
#include <Controls\Label.mqh>
#include <Controls\Button.mqh>

//--- Inputs
extern double Lot        = 0.1;      // лот
extern int StopLoss      = 500;      // лось
extern int TakeProfit    = 500;      // язь
extern int Slip          = 30;       // реквот
extern int Magic         = 0;        // магик
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum label_align
  {
   left=-1,
   right=1,
   center=0
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CTradePanel : public CAppDialog
  {
private:

   CLabel            Lots_label;                      // Display label " Lots"
   CEdit             Lots;                            // Display volume of next order
   CButton           SELL,BUY;                        // Sell and Buy Buttons
   CButton           CloseAll;                        // Close buttons

   //--- Create Label object
   bool              CreateLabel(const long chart,const int subwindow,CLabel &object,const string text,const uint x,const uint y,label_align align);
   //--- Create Button
   bool              CreateButton(const long chart,const int subwindow,CButton &object,const string text,const uint x,const uint y,const uint x_size,const uint y_size);
   //--- Create Edit object
   bool              CreateEdit(const long chart,const int subwindow,CEdit &object,const string text,const uint x,const uint y,const uint x_size,const uint y_size);

   //--- On Event functions
   void              LotsEndEdit(void);               // Edit Lot size

   //--- variables of current values
   double            cur_lot;                         // Lot of next order

   void              BuyClick();                      // Click BUY button
   void              SellClick();                     // Click SELL button
   void              CloseClick();                    // Click CLOSE button   

public:
                     CTradePanel(void){};
                    ~CTradePanel(void){};
   virtual bool      Create(const long chart,const string name,const int subwin=0,const int x1=20,const int y1=20,const int x2=320,const int y2=420);
   virtual bool      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   virtual void      Destroy(const int reason);
  };

CTradePanel TradePanel;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
// Create Trade Panel
   TradePanel.Create(ChartID(),"Panelka",0,20,20,150,200);
   TradePanel.Run();   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   TradePanel.Destroy(reason);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTradePanel::CreateLabel(const long chart,const int subwindow,CLabel &object,const string text,const uint x,const uint y,label_align align)
  {
// All objects must have separate name
   string name=m_name+"Label"+(string)ObjectsTotal(chart,-1,OBJ_LABEL);
//--- Call Create function
   if(!object.Create(chart,name,subwindow,x,y,0,0))
     {
      return false;
     }
//--- Adjust text
   if(!object.Text(text))
     {
      return false;
     }
//--- Align text to Dialog box's grid
   ObjectSetInteger(chart,object.Name(),OBJPROP_ANCHOR,(align==left ? ANCHOR_LEFT_UPPER :(align==right ? ANCHOR_RIGHT_UPPER : ANCHOR_UPPER)));
//--- Add object to controls
   if(!Add(object))
     {
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTradePanel::CreateButton(const long chart,const int subwindow,CButton &object,const string text,const uint x,const uint y,const uint x_size,const uint y_size)
  {
// All objects must have separate name
   string name=m_name+"Button"+(string)ObjectsTotal(chart,-1,OBJ_BUTTON);
//--- Call Create function
   if(!object.Create(chart,name,subwindow,x,y,x+x_size,y+y_size))
     {
      return false;
     }
//--- Adjust text
   if(!object.Text(text))
     {
      return false;
     }
//--- set button flag to unlock
   object.Locking(false);
//--- set button flag to unpressed
   if(!object.Pressed(false))
     {
      return false;
     }
//--- Add object to controls
   if(!Add(object))
     {
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTradePanel::CreateEdit(const long chart,const int subwindow,CEdit &object,const string text,const uint x,const uint y,const uint x_size,const uint y_size)
  {
// All objects must have separate name
   string name=m_name+"Edit"+(string)ObjectsTotal(chart,-1,OBJ_EDIT);
//--- Call Create function
   if(!object.Create(chart,name,subwindow,x,y,x+x_size,y+y_size))
     {
      return false;
     }
//--- Adjust text
   if(!object.Text(text))
     {
      return false;
     }
//--- Align text in Edit box
   if(!object.TextAlign(ALIGN_CENTER))
     {
      return false;
     }
//--- set Read only flag to false
   if(!object.ReadOnly(false))
     {
      return false;
     }
//--- Add object to controls
   if(!Add(object))
     {
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTradePanel::Create(const long chart,const string name,const int subwin=0,const int x1=20,const int y1=20,const int x2=320,const int y2=420)
  {
// At first call create function of parents class
   CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2);

// Calculate coordinates and size of BID object

// Create object
   CreateLabel(chart,subwin,Lots_label,"LOT",55,5,0);
   CreateEdit(chart,subwin,Lots,"0.1",33,35,60,20);
   CreateButton(chart,subwin,BUY,"BUY",33,65,60,20);
   CreateButton(chart,subwin,SELL,"SELL",33,95,60,20);
   CreateButton(chart,subwin,CloseAll,"CLOSE",33,125,60,20);

   return(true);
  }
//+------------------------------------------------------------------+
//| Event Handling                                                   |
//+------------------------------------------------------------------+
EVENT_MAP_BEGIN(CTradePanel)
ON_EVENT(ON_END_EDIT,Lots,LotsEndEdit)
ON_EVENT(ON_CLICK,BUY,BuyClick)
ON_EVENT(ON_CLICK,SELL,SellClick)
ON_EVENT(ON_CLICK,CloseAll,CloseClick)
EVENT_MAP_END(CAppDialog)
//+------------------------------------------------------------------+
//|  Click BUY button                                                |
//+------------------------------------------------------------------+
void CTradePanel::BuyClick(void)
  {
   PutOrder(0,Ask);
  }
//+------------------------------------------------------------------+
//|  Click BUY button                                                |
//+------------------------------------------------------------------+
void CTradePanel::SellClick(void)
  {
   PutOrder(1,Bid);
  }
//+------------------------------------------------------------------+
//|  Click BUY button                                                |
//+------------------------------------------------------------------+
void CTradePanel::CloseClick(void)
  {
   CloseAll();
  }
//+------------------------------------------------------------------+
//| Read lots value after edit                                       |
//+------------------------------------------------------------------+
void CTradePanel::LotsEndEdit(void)
  {
//--- Read and normalize lot value
   cur_lot=NormalizeDouble(StringToDouble(Lots.Text()),2);
  }
//+------------------------------------------------------------------+
//| Application deinitialization function                            |
//+------------------------------------------------------------------+
void CTradePanel::Destroy(const int reason)
  {
   CAppDialog::Destroy(reason);
   return;
  }
//+------------------------------------------------------------------+
//| Установка ордера                                                 |
//+------------------------------------------------------------------+
void PutOrder(int type,double price)
  {
   int r=0;
   color clr=Green;
   double sl=0,tp=0;

   if(type==1 || type==3 || type==5)
     {
      clr=Red;
      if(StopLoss>0)   sl=NormalizeDouble(price+StopLoss*Point,Digits);
      if(TakeProfit>0) tp=NormalizeDouble(price-TakeProfit*Point,Digits);
     }

   if(type==0 || type==2 || type==4)
     {
      clr=Blue;
      if(StopLoss>0)   sl=NormalizeDouble(price-StopLoss*Point,Digits);
      if(TakeProfit>0) tp=NormalizeDouble(price+TakeProfit*Point,Digits);
     }

   r=OrderSend(NULL,type,Lot,NormalizeDouble(price,Digits),Slip,sl,tp,"",Magic,0,clr);
   return;
  }
//+------------------------------------------------------------------+
//| Закрытие позиции по типу ордера                                  |
//+------------------------------------------------------------------+
void CloseAll(int ot=-1)
  {
   bool cl;
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
           {
            if(OrderType()==0 && (ot==0 || ot==-1))
              {
               RefreshRates();
               cl=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Bid,Digits),Slip,White);
              }
            if(OrderType()==1 && (ot==1 || ot==-1))
              {
               RefreshRates();
               cl=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Ask,Digits),Slip,White);
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   TradePanel.OnEvent(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+
