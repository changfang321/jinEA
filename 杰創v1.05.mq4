


//+--------------------------------------------------------------------------+
#define Copyright    "Copyright © 2018, Jin"
#property copyright  Copyright
#property link       ""
#define ExpertName   "Jinbeta"
#define Version      "1.00"
#property version    Version
#property strict
//#include <Controls\CheckBox.mqh>
//--
#define KEY_LEFT           37 
#define KEY_RIGHT          39 
#define KEY_UP             38 
#define KEY_DOWN           40 
//--
#define INDENT_TOP         15
#define INDENT_BOTTOM      30
//--
#define CLIENT_BG_X        5
#define CLIENT_BG_Y        20
//--
#define CLIENT_BG_WIDTH    300
#define CLIENT_BG_HEIGHT   300
//--
#define BUTTON_WIDTH       75
#define BUTTON_HEIGHT      20
//--
#define BUTTON_GAP_X       5
#define BUTTON_GAP_Y       5
//--
#define EDIT_WIDTH         75
#define EDIT_HEIGHT        18
//--
#define EDIT_GAP_X         15
#define EDIT_GAP_Y         15
//--
#define SPEEDTEXT_GAP_X    240
#define SPEEDTEXT_GAP_Y    28
//--
#define SPEEDBAR_GAP_X     210
#define SPEEDBAR_GAP_Y     28
//--
#define LIGHT              0
#define DARK               1
//--
#define CLOSEALL           0
#define CLOSELAST          1
#define CLOSEPROFIT        2
#define CLOSELOSS          3
#define CLOSEPARTIAL       4
//--
#define OPENPRICE          0
#define CLOSEPRICE         1
//--
#define OP_ALL             -1
//--
#define OBJPREFIX          "TP - "
//--
bool TimerIsEnabled        = false;
int TimerInterval          = 250;
//--
int Slippage               = 3;
double LotSize             = 0;
double LotStep             = 0;
double MinLot              = 0;
double MaxLot              = 0;
double MinStop             = 0;
double StopLoss            = 0;
double TakeProfit          = 0;
double FirstSL             = 0;
//--
double LotSizeInp          = 0;
double StopLossInp         = 0;
double TakeProfitInp       = 0;
double FirstSLInp            = 0;
string SymbolInp           = "";
//--

int SelectedTheme          = 0;
int CloseMode              = 0;
bool IsPainting            = false;
bool SoundIsEnabled        = false;
bool PlayTicks             = false;
//--
int mouse_x                = 0;
int mouse_y                = 0;
int mouse_w                = 0;
datetime mouse_dt          = 0;
double mouse_pr            = 0;
//--
//int MagicNumber            = 0; 
int draw                   = 0;
int BrushClrIndex          = 0;
int BrushIndex             = 0;
//--
int MaxSpeedBars           = 10;
double AvgPrice            = 0;
double UpTicks             = 0;
double DwnTicks            = 0;
int LastReason             = 0;
//--
color COLOR_BG             = clrNONE;
color COLOR_FONT           = clrNONE;
color COLOR_FONT2          = clrNONE;
color COLOR_MOVE           = clrNONE;
color COLOR_GREEN          = clrNONE;
color COLOR_RED            = clrNONE;
color COLOR_HEDGE          = clrNONE;
color COLOR_BID_REC        = clrNONE;
color COLOR_ASK_REC        = clrNONE;
color COLOR_ARROW          = clrNONE;
//--
color COLOR_SELL           = C'225,68,29';
color COLOR_BUY            = C'3,95,172';
color COLOR_CLOSE          = clrGoldenrod;
//--
int ErrorInterval          = 250;
string ErrorSound          = "::Files\\TradePanel\\error.wav";
//--
string MB_CAPTION=ExpertName+" v"+Version+" | "+Copyright;
//--
string CloseArr[]={"CLOSE ALL","CLOSE LAST","CLOSE PROFIT","CLOSE LOSS","CLOSE PARTIAL"};
//--
string BrushArr[]={"l","«","¨","t","­","Ë","°"};
color BrushClrArr[]={clrRed,clrGold,clrMagenta,clrBrown,clrDodgerBlue,clrGreen,clrOrange,clrWhite,clrBlack};
//--
int x1=0, x2=CLIENT_BG_WIDTH;
int y1=0, y2=CLIENT_BG_HEIGHT;
//--
int button_y=0;
int inputs_y=0;
int label_y=0;
//--
int fr_x=0;
//CCheckBox m_check1 ;
//--
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
extern bool               TestModePanelOFF = false ; //面板關閉(歷史回測可關閉)
extern bool               EAAUTO = true ;//EA自動下單
input string              st1 = "=================";//方向開關
extern bool               BUY_O  = true ; //做多
extern bool               SELL_O = true ; //做空
extern double             TLotSize = 0.01 ; //手數
extern int                biggest_OdersTotal = 20 ;//最多訂單總數(需大於1)
extern bool               TimetoTrade = false ; //時間交易開關
input int           Opentime = 14 ; // 起始交易時間(Hour 0-24)
input int           Closetime = 24;//關閉交易時間(Hour 0-24)
extern int                LongMa_PERIOD  =20; //長MA週期
extern int                ShortMa_PERIOD =10; //短MA週期 
extern int                Inp_Signal_MA_Shift    = 0;//MA_Shift
extern int                Shift_L = 0 ; //Shift
extern ENUM_MA_METHOD     Inp_Signal_MA_Method   = MODE_SMA;//MA模式
extern ENUM_APPLIED_PRICE Inp_Signal_MA_Applied  = PRICE_CLOSE;//MA price applied
extern ENUM_TIMEFRAMES    my_timeframe           =PERIOD_H1 ;//MA 時區(EA以此時區為基準)
extern bool               macrossout             =true ;
//extern double         my_lot = 0.05; //手數

extern bool           pmode = true ; //加倉模式 true = on false = off
extern double         protectprofit = 100 ; //獲利__步數加倉
extern bool           tpmode = true ; //加倉獲利保護模式 true = on false = off   
extern double         protectstep = 50 ;//獲利保護緩衝步數
extern int          m_slippage=3;//滑點               
extern string   NOTIN = "Spread" ;//超過__點差不下單
extern int      Spread = 30 ;//點差
extern double   CloseByPoint = 300 ;//最後一張虧損超過__清倉(步數P)
input bool     proout  = true ; //獲利出場開關
input double   profitout = 200 ;//獲利出場(全部持倉)
input double   profitdout = 200 ;//止損出場(全部持倉)
extern ENUM_TIMEFRAMES    timeframe_com           =PERIOD_H4 ;//MA條件 (大時區)
extern double   f4h_comp = 300 ;//MA(大時區)高低差(超過__才會下單) 
//extern int   InpStopLoss    = 0;          // StopLoss 
//extern int   InpTakeProfit  = 0;          // TakeProfit 
extern int   MagicNumber    = 20175566;    // MagicNumber

//長ma

double            iMA_handle_long,iMA_handle_long1;                                      
double            iMA_long[2];                                       
                            
//短ma
double            iMA_handle_short,iMA_handle_short1;                                     
double            iMA_short[2];                                      

//--H4 cmacondiiton
double            iMAh4_10,iMAh4_20,iMAh4_50,iMAh4_55,iMAh4_100;                                     
double            iMAh4[5],iMAh4_sort[5] ;
double            Open_buf[2] ;
double            Close_buf[2];                                    

int    ExtHandle=0;
bool   ExtHedging=false;


ulong             my_magicNumber ;
string            my_symbol;                                      
//ENUM_TIMEFRAMES   my_timeframe;                                  

//double profitpp = 300 ;

double protects = protectprofit - protectstep ;


double         ExtStopLoss;
double         ExtTakeProfit;

double         ExtTrailingStop=0;
double         ExtTrailingStep=5;
double         m_adjusted_point;             // point value adjusted for 3 or 5 points
double         mySPREAD = 0; 

datetime TimeBar;

double openhigh,openlow;

//+------------------------------------------------------------------+
//| J innovaatiom ea                                                          |
//+------------------------------------------------------------------+



//input bool ShowOrdHistory=true;//ShowOrderHistory
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- CreateTimer
   if(!IsTesting())
      TimerIsEnabled=EventSetMillisecondTimer(TimerInterval);

//-- EnableEventMouseMove 
   if(!IsTesting())
      if(!ChartGetInteger(0,CHART_EVENT_MOUSE_MOVE))
         ChartEventMouseMoveSet(true);

//-- CheckConnection
   if(!TerminalInfoInteger(TERMINAL_CONNECTED))
     {
      MessageBox("Warning: No Internet connection found!\nPlease check your network connection.",
                 MB_CAPTION+" | "+"#"+IntegerToString(ERR_NO_CONNECTION),MB_OK|MB_ICONWARNING);
     }

//-- CheckTradingIsAllowed
   if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))//Terminal
     {
      MessageBox("Warning: Check if automated trading is allowed in the terminal settings!",
                 MB_CAPTION+" | "+"#"+IntegerToString(ERR_TRADE_NOT_ALLOWED),MB_OK|MB_ICONWARNING);
     }
   else
     {
      if(!MQLInfoInteger(MQL_TRADE_ALLOWED))//CheckBox
        {
         MessageBox("Warning: Automated trading is forbidden in the program settings for "+__FILE__,
                    MB_CAPTION+" | "+"#"+IntegerToString(ERR_TRADE_NOT_ALLOWED),MB_OK|MB_ICONWARNING);
        }
     }
//--
   if(!AccountInfoInteger(ACCOUNT_TRADE_EXPERT))//Server
     {
      MessageBox("Warning: Automated trading is forbidden for the account "+IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN))+" at the trade server side.",
                 MB_CAPTION+" | "+"#"+IntegerToString(ERR_TRADE_EXPERT_DISABLED_BY_SERVER),MB_OK|MB_ICONWARNING);
     }
//--
   if(!AccountInfoInteger(ACCOUNT_TRADE_ALLOWED))//Investor
     {
      MessageBox("Warning: Trading is forbidden for the account "+IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN))+"."+
                 "\n\nPerhaps an investor password has been used to connect to the trading account."+
                 "\n\nCheck the terminal journal for the following entry:"+
                 "\n\'"+IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN))+"\': trading has been disabled - investor mode.",
                 MB_CAPTION+" | "+"#"+IntegerToString(ERR_TRADE_DISABLED),MB_OK|MB_ICONWARNING);
     }
//--
   if(!SymbolInfoInteger(_Symbol,SYMBOL_TRADE_MODE))//Symbol
     {
      MessageBox("Warning: Trading is disabled for the symbol "+_Symbol+" at the trade server side.",
                 MB_CAPTION+" | "+"#"+IntegerToString(ERR_TRADE_DISABLED),MB_OK|MB_ICONWARNING);
     }

//-- StrategyTester
   if(MQLInfoInteger(MQL_TESTER))
      Print("Some functions are not available in the strategy tester.");

//-- CheckSoundIsEnabled
   if(!GlobalVariableCheck(ExpertName+" - Sound"))
      SoundIsEnabled=true;
   else
      SoundIsEnabled=GlobalVariableGet(ExpertName+" - Sound");

//-- CheckColors
   SelectedTheme=(int)GlobalVariableGet(ExpertName+" - Theme");
   if(SelectedTheme==LIGHT)
      SetColors(LIGHT);
   else
      SetColors(DARK);

//-- GetStoredInputs
   if(TLotSize>0)
   LotSizeInp = TLotSize;
   else
   LotSizeInp=GlobalVariableGet(ExpertName+" - LotSize");
   StopLossInp=GlobalVariableGet(ExpertName+" - StopLoss");
   TakeProfitInp=GlobalVariableGet(ExpertName+" - TakeProfit");
   FirstSLInp = GlobalVariableGet(ExpertName+" - FirstStopLoss") ;

//-- GetClosingMode
   if(!IsTesting())
      CloseMode=(int)GlobalVariableGet(ExpertName+" - Close");

//-- GetAvgPrice
   if(IsConnected())
      AvgPrice=(MarketInfo(_Symbol,MODE_ASK)+MarketInfo(_Symbol,MODE_BID))/2;

//-- SetXYAxis
   GetSetCoordinates();

//-- CreateObjects
   if(TestModePanelOFF == false)
   ObjectsCreateAll();

//-- ChartChanged
   if(LastReason==REASON_CHARTCHANGE)
      _PlaySound("::Files\\TradePanel\\switch.wav");
   // if(Symbol()) // sets symbol name
      //return(INIT_FAILED);
  
   
//+------------------------------------------------------------------+
//|j innovation                                                      |
//+------------------------------------------------------------------+

   RefreshRates();
   
//---
  
  
    mySPREAD = MarketInfo(Symbol(),MODE_SPREAD) ;//setspread
   
    my_symbol = _Symbol ;
    my_magicNumber = MagicNumber ;
   

//--- tuning for 3 or 5 digits
   int digits_adjust=1;
   
   if(SYMBOL_DIGITS==3 || SYMBOL_DIGITS==5)
      digits_adjust=10;
      
   m_adjusted_point=SYMBOL_POINT*digits_adjust;

   
   if(iMA_handle_long==INVALID_HANDLE||iMA_handle_short==INVALID_HANDLE){
      Print("Failed to get the indicator handle");                 
      return(-1);                                                 
   }

   ArraySetAsSeries(Close_buf,true); 
   ArraySetAsSeries(iMA_long,true);                                 
   ArraySetAsSeries(iMA_short,true); 
   ArraySetAsSeries(Close_buf,true);                             


   return(INIT_SUCCEEDED);            
//+------------------------------------------------------------------+
//|j innovation                                                      |
//+------------------------------------------------------------------+     

  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
             
   ArraySetAsSeries(iMA_long,true);                                 
   ArraySetAsSeries(iMA_short,true); 
   ArraySetAsSeries(Close_buf,true);                             


//--- DestroyTimer
   EventKillTimer();
   TimerIsEnabled=false;

//-- DisableEventMouseMove
   if(!IsTesting())
      if(ChartGetInteger(0,CHART_EVENT_MOUSE_MOVE))
         ChartEventMouseMoveSet(false);

//-- SaveStoredValues
   if(reason!=REASON_INITFAILED)
     {
      //-- SaveXYAxis
      GlobalVariableSet(ExpertName+" - X",x1);
      GlobalVariableSet(ExpertName+" - Y",y1);
      //-- SaveUserInputs
      GlobalVariableSet(ExpertName+" - LotSize",LotSize);
      GlobalVariableSet(ExpertName+" - StopLoss",StopLoss);
      GlobalVariableSet(ExpertName+" - TakeProfit",TakeProfit);
      //-- Strategy Tester
      if(!IsTesting())
        {
         GlobalVariableSet(ExpertName+" - Theme",SelectedTheme);
         GlobalVariableSet(ExpertName+" - Sound",SoundIsEnabled);
         GlobalVariableSet(ExpertName+" - Close",CloseMode);
        }
      //--
      GlobalVariablesFlush();
     }

//-- ResetStoredTicks
   if(reason==REASON_CHARTCHANGE)
     {
      UpTicks=0;
      DwnTicks=0;
     }

//-- DeleteObjects
   if(reason<=REASON_REMOVE || reason==REASON_INITFAILED)
     {
      for(int i=0; i<ObjectsTotal(); i++)
        {
         //-- GetObjectName
         string obj_name=ObjectName(i);
         //-- PrefixObjectFound
         if(StringSubstr(obj_name,0,StringLen(OBJPREFIX))==OBJPREFIX)
           {
            //-- DeleteObjects
            if(ObjectsDeleteAll(0,OBJPREFIX,-1,-1)>0)
               break;
           }
        }
     }

//-- StoreDeinitReason
   LastReason=reason;
//---
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//+------------------------------------------------------------------+
//|j innovation                                                      |
//+------------------------------------------------------------------+
//---
int imalong = 0 ;
int imashort = 0 ;
int imah4_con = 0 ,imah4_con1 = 0 ,imah4_con2 = 0 ,imah4_con3 = 0,imah4_con4 = 0;
int closebar = 0 ;
int count = 0 ;
double f4_compare = 0 ;
bool f4_con = false ;
MqlDateTime dateTimeNowUtc;
TimeLocal(dateTimeNowUtc);


if(EAAUTO == true){

   iMAh4_10 = iMA(my_symbol,timeframe_com,10,Inp_Signal_MA_Shift,Inp_Signal_MA_Method,Inp_Signal_MA_Applied,Shift_L);
   iMAh4_20 = iMA(my_symbol,timeframe_com,20,Inp_Signal_MA_Shift,Inp_Signal_MA_Method,Inp_Signal_MA_Applied,Shift_L);
   iMAh4_50 = iMA(my_symbol,timeframe_com,50,Inp_Signal_MA_Shift,Inp_Signal_MA_Method,Inp_Signal_MA_Applied,Shift_L);
   iMAh4_55 = iMA(my_symbol,timeframe_com,55,Inp_Signal_MA_Shift,Inp_Signal_MA_Method,Inp_Signal_MA_Applied,Shift_L);
   iMAh4_100 = iMA(my_symbol,timeframe_com,100,Inp_Signal_MA_Shift,Inp_Signal_MA_Method,Inp_Signal_MA_Applied,Shift_L);

   iMA_long[0]  = iMA_handle_long=iMA(my_symbol,my_timeframe,LongMa_PERIOD,Inp_Signal_MA_Shift,Inp_Signal_MA_Method,Inp_Signal_MA_Applied,Shift_L); 
   iMA_short[0] = iMA_handle_short=iMA(my_symbol,my_timeframe,ShortMa_PERIOD,Inp_Signal_MA_Shift,Inp_Signal_MA_Method,Inp_Signal_MA_Applied,Shift_L);
   
   iMA_long[1]  = iMA_handle_long1=iMA(my_symbol,my_timeframe,LongMa_PERIOD,Inp_Signal_MA_Shift,Inp_Signal_MA_Method,Inp_Signal_MA_Applied,Shift_L+1); 
   iMA_short[1] = iMA_handle_short1=iMA(my_symbol,my_timeframe,ShortMa_PERIOD,Inp_Signal_MA_Shift,Inp_Signal_MA_Method,Inp_Signal_MA_Applied,Shift_L+1);



int curorder = OrdersTotal() ;
double probuy = NormalizeDouble(OrderOpenPrice()+_Point*(protectprofit+SYMBOL_SPREAD),Digits());
double prosell = NormalizeDouble(OrderOpenPrice()-_Point*(protectprofit+SYMBOL_SPREAD),Digits()); 
int oh = Opentime ,ch = Closetime;  



/*if(macrossout == true)
   if(CrossClose() == true)
      CloseAllOpenPositions() ; */

if(proout==true){
closeby_Profit() ;

}
//notmine() ; 
//closebypoint() ;
//printf("ssssssssssssss==============%f",mySPREAD);
four_hsignal() ;
ArraySort(iMAh4) ;
f4_compare = NormalizeDouble(iMAh4[4]-iMAh4[0],_Digits) ;

if(f4_compare > NormalizeDouble(f4h_comp*_Point,_Digits) ){
f4_con = true ;
}

if(SYMBOL_SPREAD<Spread && pmode == true && Symbol_Positioncount() < biggest_OdersTotal ){
positionMD();
}
 
 
  
if(TimetoTrade==false){  
oh = 0 ;
ch = 24 ;
}  



   if( SYMBOL_SPREAD < Spread  && f4_con == true && newBar(my_timeframe)==true &&SelectPosition()==false ){
      if(TimeSession(oh,ch,TimeLocal())==true){
  
         if(CrossOpen() == "buy"&&BUY_O == true ){  
            OrderSend(OP_BUY);
            Print("Stop level in points=",MarketInfo(Symbol(),MODE_STOPLEVEL));
            return ;
         }
      
         if(CrossOpen() == "sell"&& SELL_O == true ){    
            OrderSend(OP_SELL);
            Print("Stop level in points=",MarketInfo(Symbol(),MODE_STOPLEVEL));
            return ;   
         }  
      } 
  }
}
//+------------------------------------------------------------------+
//|j innovation                                                      |
//+------------------------------------------------------------------+
//--- CreateTimer
  if(!TimerIsEnabled && !IsTesting())
      TimerIsEnabled=EventSetMillisecondTimer(TimerInterval);

//-- DisplaySpeedInfo
   Speedometer();

//-- StrategyTester
   if(IsTesting())
      _OnTester();
//---

  
   return  ; 
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//--- CheckObjects
  if(TestModePanelOFF == false){
   ObjectsCheckAll();
   }
//-- GetSetUserInputs
   GetSetInputs();

//-- DisplaySymbolInfo
   SymbolInfo();

//-- DisplayAccount&TradeInfo
   AccAndTradeInfo();
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
     if(TestModePanelOFF == true)
     return ;
   if(id==CHARTEVENT_OBJECT_CLICK)
     {

      //-- DisplayLastKnownPing
      if(sparam==OBJPREFIX+"CONNECTION")
        {
         //-- SetTransparentColor
         int sRed=88,sGreen=88,sBlue=88,sRGB=0;
         sRGB=(sBlue<<16);sRGB|=(sGreen<<8);sRGB|=sRed;
         //--
         double Ping=TerminalInfoInteger(TERMINAL_PING_LAST);//SetPingToMs
         string text=TerminalInfoInteger(TERMINAL_CONNECTED)?DoubleToString(Ping/1000,2)+" ms":"NC";/*SetText*/
         //--
         LabelCreate(0,OBJPREFIX+"PING",0,ChartMiddleX(),ChartMiddleY(),CORNER_LEFT_UPPER,text,"Tahoma",200,sRGB,0,ANCHOR_CENTER,true,false,true,0,"\n");
         //--
         Sleep(1000);
         ObjectDelete(0,OBJPREFIX+"PING");//DeleteObject
        }

      //-- SwitchTheme
      if(sparam==OBJPREFIX+"THEME")
        {
         if(SelectedTheme==LIGHT)
            SetTheme(DARK);
         else
            SetTheme(LIGHT);
        }

      //-- StartPainting
      if(sparam==OBJPREFIX+"PAINT")
        {
         if(!IsPainting)
           {
            //-- EnablePainting
            IsPainting=true;
            //-- BlockMouseScroll
            ChartMouseScrollSet(false);
            //-- DisplayInfo
            LabelCreate(0,OBJPREFIX+"ERASE",0,5,15,CORNER_LEFT_LOWER,"Press down to erase","Arial",9,COLOR_RED,0,ANCHOR_LEFT,false,false,true,0,"\n");
            LabelCreate(0,OBJPREFIX+"BRUSHCOLOR",0,ChartMiddleX(),15,CORNER_LEFT_LOWER,"Press up to change color / Press left to change brush","Arial",9,BrushClrArr[BrushClrIndex],0,ANCHOR_CENTER,false,false,true,0,"\n");
            LabelCreate(0,OBJPREFIX+"BRUSHTYPE",0,ChartMiddleX()+155,15,CORNER_LEFT_LOWER,BrushArr[BrushIndex],"Wingdings",9,BrushClrArr[BrushClrIndex],0,ANCHOR_CENTER,false,false,true,0,"\n");
            LabelCreate(0,OBJPREFIX+"STOPPAINT",0,5,15,CORNER_RIGHT_LOWER,"Press right to stop drawing","Arial",9,COLOR_GREEN,0,ANCHOR_RIGHT,false,false,true,0,"\n");
           }
        }

      //-- SoundManagement
      if(sparam==OBJPREFIX+"SOUND" || sparam==OBJPREFIX+"SOUNDIO")
        {
         //-- EnableSound
         if(!SoundIsEnabled)
           {
            SoundIsEnabled=true;
            ObjectSetInteger(0,OBJPREFIX+"SOUNDIO",OBJPROP_COLOR,C'59,41,40');//SetObject
            PlaySound("::Files\\TradePanel\\sound.wav");
           }
         //-- DisableSound
         else
           {
            SoundIsEnabled=false;
            ObjectSetInteger(0,OBJPREFIX+"SOUNDIO",OBJPROP_COLOR,clrNONE);//SetObject
           }
        }

      //-- TickSoundsManagement
      if(sparam==OBJPREFIX+"PLAY")
        {
         //-- EnableTickSounds
         if(!PlayTicks)
           {
            PlayTicks=true;
            //-- SetObjects
            ObjectSetString(0,OBJPREFIX+"PLAY",OBJPROP_TEXT,";");
            ObjectSetInteger(0,OBJPREFIX+"PLAY",OBJPROP_FONTSIZE,14);
           }
         //-- DisableTickSounds
         else
           {
            PlayTicks=false;
            //-- SetObjects
            ObjectSetString(0,OBJPREFIX+"PLAY",OBJPROP_TEXT,"4");
            ObjectSetInteger(0,OBJPREFIX+"PLAY",OBJPROP_FONTSIZE,15);
           }
        }

      //-- SetBull/BearColors
      if(sparam==OBJPREFIX+"CANDLES¦")
        {
         color clrBullish = RandomColor();
         color clrBearish = RandomColor();
         //-- SetChart
         ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,clrBullish);
         ChartSetInteger(0,CHART_COLOR_CHART_UP,clrBullish);
         ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,clrBearish);
         ChartSetInteger(0,CHART_COLOR_CHART_DOWN,clrBearish);
         ChartSetInteger(0,CHART_COLOR_CHART_LINE,RandomColor());
        }

      //-- RemoveExpert
      if(sparam==OBJPREFIX+"EXIT")
        {
         if(MessageBox("Do you really want to remove the EA?",MB_CAPTION,MB_ICONQUESTION|MB_YESNO)==IDYES)
            ExpertRemove();//Exit
        }

      //-- SetClosingMode
      if(sparam==OBJPREFIX+"CLOSE¹²³")
        {
         CloseMode++;
         if(CloseMode>=ArraySize(CloseArr))//Reset
            CloseMode=0;
         ObjectSetString(0,OBJPREFIX+"CLOSE¹²³",OBJPROP_TEXT,0,CloseArr[CloseMode]);//SetObject
         _PlaySound("::Files\\TradePanel\\switch.wav");
        }

      //-- DecLotSize
      if(sparam==OBJPREFIX+"LOTSIZE<")
         ObjectSetString(0,OBJPREFIX+"LOTSIZE<>",OBJPROP_TEXT,0,DoubleToString(LotSize-=LotStep,2));//SetObject

      //-- IncLotSize
      if(sparam==OBJPREFIX+"LOTSIZE>")
         ObjectSetString(0,OBJPREFIX+"LOTSIZE<>",OBJPROP_TEXT,0,DoubleToString(LotSize+=LotStep,2));//SetObject

      //-- SellClick
      if(sparam==OBJPREFIX+"SELL")
        {
         //-- SendSellOrder
         OrderSend(OP_SELL) ;
         //-- ResetButton
         Sleep(100);
         ObjectSetInteger(0,OBJPREFIX+"SELL",OBJPROP_STATE,false);//SetObject
        }

      //-- CloseClick
      if(sparam==OBJPREFIX+"CLOSE")
        {
         //-- CloseOrder(s)
         OrderClose() ;
         //-- ResetButton
         Sleep(100);
         ObjectSetInteger(0,OBJPREFIX+"CLOSE",OBJPROP_STATE,false);//SetObject
        }

      //-- BuyClick
      if(sparam==OBJPREFIX+"BUY")
        {
         //-- SendBuyOrder
         OrderSend(OP_BUY);
         printf("@@@@@@@@@@@@@@@@@@@@open = %f",openhigh);
         //-- ResetButton
         Sleep(100);
         ObjectSetInteger(0,OBJPREFIX+"BUY",OBJPROP_STATE,false);//SetObject
        }

      //-- ResetCoordinates
      if(sparam==OBJPREFIX+"RESET")
        {
         LabelMove(0,OBJPREFIX+"BCKGRND[]",CLIENT_BG_X,CLIENT_BG_Y);
         ObjectSetInteger(0,OBJPREFIX+"RESET",OBJPROP_STATE,false);//SetObject
         if(ObjectGetInteger(0,OBJPREFIX+"MOVE",OBJPROP_STATE))
            ObjectSetInteger(0,OBJPREFIX+"MOVE",OBJPROP_STATE,false);/*SetObject*/
         //-- MoveObjects
         GetSetCoordinates();
         ObjectsMoveAll();
        }

      //--
     }
//--
   if(id==CHARTEVENT_KEYDOWN)
     {

      //-- BrushType
      if(lparam==KEY_LEFT)
        {
         if(IsPainting)
           {
            BrushIndex++;
            if(BrushIndex>=ArraySize(BrushArr))//Reset
               BrushIndex=0;
            ObjectSetString(0,OBJPREFIX+"BRUSHTYPE",OBJPROP_TEXT,0,BrushArr[BrushIndex]);//SetObject
           }
        }

      //-- StopPainting
      if(lparam==KEY_RIGHT)
        {
         if(IsPainting)
           {
            //-- DisablePainting
            IsPainting=false;
            //-- DeleteObjects
            if(ObjectFind(0,OBJPREFIX+"ERASE")==0)
               ObjectDelete(0,OBJPREFIX+"ERASE");
            if(ObjectFind(0,OBJPREFIX+"BRUSHCOLOR")==0)
               ObjectDelete(0,OBJPREFIX+"BRUSHCOLOR");
            if(ObjectFind(0,OBJPREFIX+"BRUSHTYPE")==0)
               ObjectDelete(0,OBJPREFIX+"BRUSHTYPE");
            if(ObjectFind(0,OBJPREFIX+"STOPPAINT")==0)
               ObjectDelete(0,OBJPREFIX+"STOPPAINT");
            //-- UnblockMouseScroll
            ChartMouseScrollSet(true);
           }
        }

      //-- BrushColor
      if(lparam==KEY_UP)
        {
         if(IsPainting)
           {
            BrushClrIndex++;
            if(BrushClrIndex>=ArraySize(BrushClrArr))//Reset
               BrushClrIndex=0;
            //-- SetObjects
            ObjectSetInteger(0,OBJPREFIX+"BRUSHCOLOR",OBJPROP_COLOR,0,BrushClrArr[BrushClrIndex]);
            ObjectSetInteger(0,OBJPREFIX+"BRUSHTYPE",OBJPROP_COLOR,0,BrushClrArr[BrushClrIndex]);
           }
        }

      //-- DeleteDraws
      if(lparam==KEY_DOWN)
        {
         if(IsPainting)
           {
            if(ObjectsDeleteAll(0,"draw",0,OBJ_TEXT)>0)
               draw=0;
           }
        }

      //--  
     }
//---
   if(id==CHARTEVENT_MOUSE_MOVE)
     {

      //-- UserIsHolding (Left-Click)
      if(sparam=="1")
        {

         //-- MoveClient
         if(ObjectGetInteger(0,OBJPREFIX+"BCKGRND[]",OBJPROP_SELECTED) || ObjectFind(0,OBJPREFIX+"BCKGRND[]")!=0)
           {
            //-- MoveObjects
            GetSetCoordinates();
            ObjectsMoveAll();
           }

         //-- Paint
         if(IsPainting)
           {
            //-- GetMousePosition
            mouse_x=(int)lparam;
            mouse_y=(int)dparam;
            //-- ConvertXYToDatePrice
            ChartXYToTimePrice(0,mouse_x,mouse_y,mouse_w,mouse_dt,mouse_pr);
            //-- CreateObjects
            TextCreate(0,"draw"+IntegerToString(draw),0,mouse_dt,mouse_pr,BrushArr[BrushIndex],"Wingdings",10,BrushClrArr[BrushClrIndex],0,ANCHOR_CENTER,false,false,true,0,"\n");
            draw++;
           }

         //--
        }

      //--
     }
//---
  }
//+------------------------------------------------------------------+
//| OnTester                                                         |
//+------------------------------------------------------------------+
void _OnTester()
  {

//--- CheckObjects
   ObjectsCheckAll();

//-- GetSetUserInputs
   GetSetInputs();

//-- DisplaySymbolInfo
   SymbolInfo();

//-- DisplayAccount&TradeInfo
   AccAndTradeInfo();

  if(TestModePanelOFF == true)
  return ;
//-- SellClick
   if(ObjectFind(0,OBJPREFIX+"SELL")==0)//ObjectIsPresent
     {
      if(ObjectGetInteger(0,OBJPREFIX+"SELL",OBJPROP_STATE))
        {
         //-- SendSellOrder
         OrderSend(OP_SELL);
         ObjectSetInteger(0,OBJPREFIX+"SELL",OBJPROP_STATE,false);//ResetButton
        }
     }

//-- CloseClick
   if(ObjectFind(0,OBJPREFIX+"CLOSE")==0)//ObjectIsPresent
     {
      if(ObjectGetInteger(0,OBJPREFIX+"CLOSE",OBJPROP_STATE))
        {
        
         OrderClose() ;
         ObjectSetInteger(0,OBJPREFIX+"CLOSE",OBJPROP_STATE,false);//ResetButton
        }
     }

//-- BuyClick
   if(ObjectFind(0,OBJPREFIX+"BUY")==0)//ObjectIsPresent
     {
      if(ObjectGetInteger(0,OBJPREFIX+"BUY",OBJPROP_STATE))
        {
         //-- SendBuyOrder
         OrderSend(OP_BUY) ;
         ObjectSetInteger(0,OBJPREFIX+"BUY",OBJPROP_STATE,false);//ResetButton
        }
     }

//-- MoveClient
   if(ObjectFind(0,OBJPREFIX+"BCKGRND[]")==0)//ObjectIsPresent
     {
      //-- GetCurrentPos
      int bg_x=(int)ObjectGetInteger(0,OBJPREFIX+"BCKGRND[]",OBJPROP_XDISTANCE);
      int bg_y=(int)ObjectGetInteger(0,OBJPREFIX+"BCKGRND[]",OBJPROP_YDISTANCE);
      //-- MoveObjects
      if(bg_x!=x1 || bg_y!=y1)
        {
         GetSetCoordinates();
         ObjectsMoveAll();
        }
     }

//-- ResetPosition
   if(ObjectFind(0,OBJPREFIX+"RESET")==0)//ObjectIsPresent
     {
      if(ObjectGetInteger(0,OBJPREFIX+"RESET",OBJPROP_STATE))
        {
         //-- MoveObject
         LabelMove(0,OBJPREFIX+"BCKGRND[]",CLIENT_BG_X,CLIENT_BG_Y);
         ObjectSetInteger(0,OBJPREFIX+"RESET",OBJPROP_STATE,false);//SetObject
         if(ObjectGetInteger(0,OBJPREFIX+"MOVE",OBJPROP_STATE))
            ObjectSetInteger(0,OBJPREFIX+"MOVE",OBJPROP_STATE,false);//SetObject
        }
     }

//---
  }
//+------------------------------------------------------------------+
//| OrderSendF                                                       |
//+------------------------------------------------------------------+
void OrderSend(const int Type)
  {
//--
   int op_tkt=0;
   uint tick=0;
   uint ex_time=0;
//--
   double rq_price=0;
   double slippage=0;
//--- reset the error value
   ResetLastError();
//-- CheckOrdSendRequirements
   if(OrdersTotal()<1 && FirstSL!=0)
   StopLoss = FirstSL ;
   
   if(IsTradeAllowed() && !IsTradeContextBusy() && IsConnected())
     {
      //-- SellOrders
      if(Type==OP_SELL){
         //-- EnoughMargin
         if(AccountFreeMarginCheck(_Symbol,OP_SELL,LotSize)>=0)
           {
            //-- CorrectLotSize (Rounded by GetSetInputs)
            if(LotSize>=MinLot && LotSize<=MaxLot)
              {
               tick=GetTickCount();//GetTime
               rq_price=MarketInfo(_Symbol,MODE_BID);//GetPrice
               op_tkt=OrderSend(_Symbol,OP_SELL,LotSize,rq_price,Slippage,0,0,ExpertName,MagicNumber,0,COLOR_SELL);//SendOrder
               Print("Stop level in points=",MarketInfo(Symbol(),MODE_STOPLEVEL));
              }
            else
              {
               //-- Error
               Print("OrderSend failed with error #131 [Invalid trade volume]");
               _PlaySound(ErrorSound);
               //--
               Sleep(ErrorInterval);
               return;
              }
            //--
            if(op_tkt<0)
              {
               //-- Error
               Print("OrderSend failed with error #",_LastError);
               _PlaySound(ErrorSound);
               //--
               Sleep(ErrorInterval);
               return;
              }
            else
              {
               //-- Succeeded
               ex_time=GetTickCount()-tick;//CalcExeTime
               slippage=(PriceByTkt(OPENPRICE,op_tkt)-rq_price)/_Point;//CalcSlippage
               Print("OrderSend placed successfully (Open Sell) "+"#"+IntegerToString(op_tkt)+" | Execuction Time: "+IntegerToString(ex_time)+"ms"+" | Slippage: "+DoubleToString(slippage,0)+"p");
               _PlaySound("::Files\\TradePanel\\sell.wav");
               //-- SL
               if(StopLoss>0 && StopLoss>=MinStop)
                 {
                  if(OrderSelect(op_tkt,SELECT_BY_TICKET,MODE_TRADES))
                    {
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+StopLoss*_Point,OrderTakeProfit(),0,COLOR_SELL))
                       {
                        //-- Error
                        Print("Error in OrderModify. Error code=",_LastError);
                        _PlaySound(ErrorSound);
                        Sleep(ErrorInterval);
                       }
                     else
                       {
                        //-- Succeeded
                        //Print("Order modified successfully");
                       }
                    }
                 }
               //-- TP
               if(TakeProfit>0 && TakeProfit>=MinStop)
                 {
                  if(OrderSelect(op_tkt,SELECT_BY_TICKET,MODE_TRADES))
                    {
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),OrderOpenPrice()-TakeProfit*_Point,0,COLOR_BUY))
                       {
                        //-- Error
                        Print("Error in OrderModify. Error code=",_LastError);
                        _PlaySound(ErrorSound);
                        Sleep(ErrorInterval);
                       }
                     else
                       {
                        //-- Succeeded
                        //Print("Order modified successfully");*/
                       }
                    }
                 }
              }
            //--
           }
         else
           {
            //-- NotEnoughMoney
            Print(" '",AccountNumber(),"' :"," order #0 sell ",DoubleToString(LotSize,2)," ",_Symbol," [Not enough money]");
            _PlaySound(ErrorSound);
           }
         //--
        }
      //-- BuyOrders
      if(Type==OP_BUY)
        {
         //-- EnoughMargin
         if(AccountFreeMarginCheck(_Symbol,OP_BUY,LotSize)>=0)
           {
            //-- CorrectLotSize (Rounded by GetSetInputs)
            if(LotSize>=MinLot && LotSize<=MaxLot)
              {
               tick=GetTickCount();//GetTime
               rq_price=MarketInfo(_Symbol,MODE_ASK);//GetPrice
               op_tkt=OrderSend(_Symbol,OP_BUY,LotSize,rq_price,Slippage,0,0,ExpertName,MagicNumber,0,COLOR_BUY);//SendOrder
               Print("Stop level in points=",MarketInfo(Symbol(),MODE_STOPLEVEL));
              }
            else
              {
               //-- Error
               Print("OrderSend failed with error #131 [Invalid trade volume]");
               _PlaySound(ErrorSound);
               //--
               Sleep(ErrorInterval);
               return;
              }
            //--
            if(op_tkt<0)
              {
               //-- Error
               Print("OrderSend failed with error #",_LastError);
               _PlaySound(ErrorSound);
               //--
               Sleep(ErrorInterval);
               return;
              }
            else
              {
               //-- Succeeded
               ex_time=GetTickCount()-tick;//CalcExeTime
               slippage=(rq_price-PriceByTkt(OPENPRICE,op_tkt))/_Point;//CalcSlippage
               Print("OrderSend placed successfully (Open Buy) "+"#"+IntegerToString(op_tkt)+" | Execuction Time: "+IntegerToString(ex_time)+"ms"+" | Slippage: "+DoubleToString(slippage,0)+"p");
               _PlaySound("::Files\\TradePanel\\buy.wav");
               //-- SL
               if(StopLoss>0 && StopLoss>=MinStop)
                 {
                  if(OrderSelect(op_tkt,SELECT_BY_TICKET,MODE_TRADES))
                    {
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-StopLoss*_Point,OrderTakeProfit(),0,COLOR_SELL))
                       {
                        //-- Error
                        Print("Error in OrderModify. Error code=",_LastError);
                        _PlaySound(ErrorSound);
                        Sleep(ErrorInterval);
                       }
                     else
                       {
                        //-- Succeeded
                        //Print("Order modified successfully");
                       }
                    }
                 }
               //-- TP
               if(TakeProfit>0 && TakeProfit>=MinStop)
                 {
                  if(OrderSelect(op_tkt,SELECT_BY_TICKET,MODE_TRADES))
                    {
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),OrderOpenPrice()+TakeProfit*_Point,0,COLOR_BUY))
                       {
                        //-- Error
                        Print("Error in OrderModify. Error code=",_LastError);
                        _PlaySound(ErrorSound);
                        Sleep(ErrorInterval);
                       }
                     else
                       {
                        //-- Succeeded
                        //Print("Order modified successfully");
                       }
                    }
                 }
              }
            //--
           }
         else
           {
            //-- NotEnoughMoney
            Print(" '",AccountNumber(),"' :"," order #0 buy ",DoubleToString(LotSize,2)," ",_Symbol," [Not enough money]");
            _PlaySound(ErrorSound);
           }
         //--
        }
     }
   else
     {
      //-- RequirementsNotFulfilled
      if(!IsConnected())
         Print("No Internet connection found! Please check your network connection and try again.");
      if(IsTradeContextBusy())
         Print("Trade context is busy, Please wait...");
      if(!IsTradeAllowed())
         Print("Check if automated trading is allowed in the terminal / program settings and try again.");
      //--
      _PlaySound(ErrorSound);
      //--
      Sleep(ErrorInterval);
      return;
      //--
     }
//--
  }
//+------------------------------------------------------------------+
//| OrderClose                                                       |
//+------------------------------------------------------------------+
void OrderClose()
  {
//--
   double ordprofit=0;
   double ordlots=0;
//--
   int c_tkt=0;
   int ordtype=0;
   uint tick=0;
   uint ex_time=0;
//--
   double rq_price=0;
   double slippage=0;
//--
   string ordtypestr="";
//--- reset the error value
   ResetLastError();
//-- CheckOrdCloseRequirements
   if(IsTradeAllowed() && !IsTradeContextBusy() && IsConnected())
     {
      //-- SelectOrder
      for(int i=OrdersTotal()-1; i>=0; i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
           {
            if(OrderSymbol()==_Symbol && OrderMagicNumber()==MagicNumber)
              {
               if(OrderType()<=OP_SELL)//MarketOrdersOnly
                 {
                  //--
                  ordprofit=OrderProfit()+OrderCommission()+OrderSwap();//GetPtofit
                  ordlots=(CloseMode==CLOSEPARTIAL)?ordlots=LotSizeInp:OrderLots();//SetLots
                  if(ordlots>OrderLots())
                     ordlots=OrderLots();
                  //--
                  if((CloseMode==CLOSEALL) || (CloseMode==CLOSELAST) || (CloseMode==CLOSEPROFIT && ordprofit>0) || (CloseMode==CLOSELOSS && ordprofit<0) || (CloseMode==CLOSEPARTIAL))
                    {
                     tick=GetTickCount();
                     rq_price=OrderClosePrice();
                     c_tkt=OrderTicket();
                     ordtype=OrderType();
                     ordtypestr=(OrderType()==OP_SELL)?ordtypestr="Sell":ordtypestr="Buy";
                     //--
                     if(!OrderClose(OrderTicket(),ordlots,rq_price,0,COLOR_CLOSE))
                       {
                        //-- Error
                        Print("OrderClose failed with error #",_LastError);
                        Sleep(ErrorInterval);
                        return;
                       }
                     else
                       {
                        //-- Succeeded
                        ex_time=GetTickCount()-tick;//CalcExeTime
                        slippage=(ordtype==OP_SELL)?(PriceByTkt(CLOSEPRICE,c_tkt)-rq_price)/_Point:(rq_price-PriceByTkt(CLOSEPRICE,c_tkt))/_Point;//CalcSlippage
                        Print("Order closed successfully"+" (Close "+ordtypestr+") "+"#"+IntegerToString(c_tkt)+" | Execuction Time: "+IntegerToString(ex_time)+"ms"+" | "+"Slippage: "+DoubleToString(slippage,0)+"p");
                        _PlaySound("::Files\\TradePanel\\close.wav");
                        //--
                        if(CloseMode==CLOSELAST || CloseMode==CLOSEPARTIAL)
                           break;
                       }
                    }
                  //--
                 }
              }
           }
        }
      //--
     }
   else
     {
      //-- RequirementsNotFulfilled
      if(!IsConnected())
         Print("No Internet connection found! Please check your network connection and try again.");
      if(IsTradeContextBusy())
         Print("Trade context is busy, Please wait...");
      if(!IsTradeAllowed())
         Print("Check if automated trading is allowed in the terminal / program settings and try again.");
      //--
      _PlaySound(ErrorSound);
      //--
      Sleep(ErrorInterval);
      return;
     }
//--
  }
//+------------------------------------------------------------------+
//| OpenPos                                                          |
//+------------------------------------------------------------------+
int OpenPos(const int Type)
  {
//--
   int count=0;
//--
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==_Symbol && OrderMagicNumber()==MagicNumber)
           {
            if(OrderType()==OP_SELL && Type==OP_SELL)
               count++;
            if(OrderType()==OP_BUY && Type==OP_BUY)
               count++;
            if(OrderType()<=OP_SELL && Type==OP_ALL)
               count++;
           }
        }
     }
   return(count);
//--
  }
//+------------------------------------------------------------------+
//| ØOpenPrice                                                       |
//+------------------------------------------------------------------+
double ØOpenPrice()
  {
//--
   double ordlots=0;
   double price=0;
   double avgprice=0;
//--
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==_Symbol && OrderMagicNumber()==MagicNumber)
           {
            if(OrderType()<=OP_SELL)//MarketOrdersOnly
              {
               ordlots+=OrderLots();
               price+=OrderLots()*OrderOpenPrice();
              }
           }
        }
     }
//-- CalcAvgPrice
   avgprice=price/ordlots;
//--
   return(avgprice);
  }
//+------------------------------------------------------------------+
//| FloatingProfits                                                  |
//+------------------------------------------------------------------+
double FloatingProfits()
  {
//--  
   double profit=0;
//--
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==_Symbol && OrderMagicNumber()==MagicNumber)
           {
            if(OrderType()<=OP_SELL)//MarketOrdersOnly
              {
               profit+=OrderProfit()+OrderCommission()+OrderSwap();
              }
           }
        }
     }
   return(profit);
//--
  }
//+------------------------------------------------------------------+
//| FloatingPoints                                                   |
//+------------------------------------------------------------------+
double FloatingPoints()
  {
//--
   double sellpts=0;
   double buypts=0;
//--
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==_Symbol && OrderMagicNumber()==MagicNumber)
           {
            if(OrderType()==OP_SELL)
               sellpts+=(OrderOpenPrice()-OrderClosePrice())/_Point;
            if(OrderType()==OP_BUY)
               buypts+=(OrderClosePrice()-OrderOpenPrice())/_Point;
           }
        }
     }
   return(sellpts+buypts);
//--
  }
//+------------------------------------------------------------------+
//| DailyProfits                                                     |
//+------------------------------------------------------------------+
double DailyProfits()
  {
//--  
   double profit=0;
//--
   for(int i=OrdersHistoryTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
        {
         if(OrderSymbol()==_Symbol && OrderMagicNumber()==MagicNumber)
           {
            if(OrderType()<=OP_SELL)//MarketOrdersOnly
              {
               if(TimeToStr(TimeCurrent(),TIME_DATE)==TimeToString(OrderCloseTime(),TIME_DATE))
                  profit+=OrderProfit()+OrderCommission()+OrderSwap();
              }
           }
        }
     }
   return(profit);
//--
  }
//+------------------------------------------------------------------+
//| DailyPoints                                                      |
//+------------------------------------------------------------------+
double DailyPoints()
  {
//--
   double sellpts=0;
   double buypts=0;
//--
   for(int i=OrdersHistoryTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
        {
         if(OrderSymbol()==_Symbol && OrderMagicNumber()==MagicNumber)
           {
            if(OrderType()<=OP_SELL)//MarketOrdersOnly
              {
               if(TimeToStr(TimeCurrent(),TIME_DATE)==TimeToString(OrderCloseTime(),TIME_DATE))
                 {
                  if(OrderType()==OP_SELL)
                     sellpts+=(OrderOpenPrice()-OrderClosePrice())/_Point;
                  if(OrderType()==OP_BUY)
                     buypts+=(OrderClosePrice()-OrderOpenPrice())/_Point;
                 }
              }
           }
        }
     }
   return(sellpts+buypts);
//--
  }
//+------------------------------------------------------------------+
//| DailyReturn                                                      |
//+------------------------------------------------------------------+
double DailyReturn()
  {
//--
   double percent=0;
   double startbal=0;

//-- GetStartBalance
   startbal=(DailyProfits()>0)?AccountBalance()-DailyProfits():AccountBalance()+MathAbs(DailyProfits());

//-- CalcReturn (ROI)
   if(startbal!=0)//AvoidZeroDivide
      percent=DailyProfits()*100/startbal;
//--
   return(percent);
  }
//+------------------------------------------------------------------+
//| PriceByTkt                                                       |
//+------------------------------------------------------------------+
double PriceByTkt(const int Type,const int Ticket)
  {
//--
   double price=0;
//--
   if(OrderSelect(Ticket,SELECT_BY_TICKET,MODE_TRADES))
     {
      if(Type==OPENPRICE)
         price=OrderOpenPrice();
      if(Type==CLOSEPRICE)
         price=OrderClosePrice();
     }
//--
   return(price);
  }
//+------------------------------------------------------------------+
//| GetSetInputs                                                     |
//+------------------------------------------------------------------+
void GetSetInputs()
  {
//-- GetMarketInfo
   LotStep=MarketInfo(_Symbol,MODE_LOTSTEP);
   MinLot=MarketInfo(_Symbol,MODE_MINLOT);
   MaxLot=MarketInfo(_Symbol,MODE_MAXLOT);
   MinStop=MarketInfo(_Symbol,MODE_STOPLEVEL);

//-- GetLotSizeInput
   LotSizeInp=StringToDouble(ObjectGetString(0,OBJPREFIX+"LOTSIZE<>",OBJPROP_TEXT));/*SetObject*/
//-- RoundLotSize
   LotSize=LotSizeInp;
   LotSize=MathRound(LotSize/LotStep)*LotStep;
   ObjectSetString(0,OBJPREFIX+"LOTSIZE<>",OBJPROP_TEXT,0,DoubleToString(LotSize,2));/*SetObject*/
//-- WrongLotSize
   if(LotSize<=MinLot)
     {
      LotSize=MinLot;
      ObjectSetString(0,OBJPREFIX+"LOTSIZE<>",OBJPROP_TEXT,0,DoubleToString(LotSize,2));/*SetObject*/
     }
//--
   if(LotSize>=MaxLot)
     {
      LotSize=MaxLot;
      ObjectSetString(0,OBJPREFIX+"LOTSIZE<>",OBJPROP_TEXT,0,DoubleToString(LotSize,2));/*SetObject*/
     }

//-- GetSLInput
   StopLossInp=StringToDouble(ObjectGetString(0,OBJPREFIX+"SL<>",OBJPROP_TEXT));/*GetObject*/
//-- WrongSL
   if(StopLossInp<0 || StopLossInp<MinStop)
     {
      StopLoss=0;
      ObjectSetString(0,OBJPREFIX+"SL<>",OBJPROP_TEXT,0,DoubleToString(StopLoss,0));/*SetObject*/
     }
   else
     {
      StopLoss=StopLossInp;
     }

//-- GetTPInput
   TakeProfitInp=StringToDouble(ObjectGetString(0,OBJPREFIX+"TP<>",OBJPROP_TEXT));/*GetObject*/
//-- WrongTP
   if(TakeProfitInp<0 || TakeProfitInp<MinStop)
     {
      TakeProfit=0;
      ObjectSetString(0,OBJPREFIX+"TP<>",OBJPROP_TEXT,0,DoubleToString(TakeProfit,0));/*SetObject*/
     }
   else
     {
      TakeProfit=TakeProfitInp;
     }
//-- GetFSLInput
   FirstSLInp=StringToDouble(ObjectGetString(0,OBJPREFIX+"FSL<>",OBJPROP_TEXT));/*GetObject*/
//-- WrongTP
   if(FirstSLInp<0 || FirstSLInp<MinStop)
     {
      FirstSL=0;
      ObjectSetString(0,OBJPREFIX+"FSL<>",OBJPROP_TEXT,0,DoubleToString(FirstSL,0));/*SetObject*/
     }
   else{
      FirstSL = FirstSLInp ;
   }

//-- SymbolChanger
   SymbolInp=ObjectGetString(0,OBJPREFIX+"SYMBOL¤",OBJPROP_TEXT);//GetSymbolInput

   if(SymbolInp!="" && _Symbol!=SymbolInp)
     {
      if(SymbolFind(SymbolInp))
        {
         ChartSetSymbolPeriod(0,SymbolInp,PERIOD_CURRENT);//SetChart
        }
      else
        {
         //-- WrongSymbolInput
         MessageBox("Warning: Symbol "+SymbolInp+" couldn't be found!\n\nMake sure it is available in the symbol list.\n(View -> Symbols / Ctrl+U)",
                    MB_CAPTION,MB_OK|MB_ICONWARNING);
         ObjectSetString(0,OBJPREFIX+"SYMBOL¤",OBJPROP_TEXT,_Symbol);//Reset
        }
     }
//--
  }
//+------------------------------------------------------------------+
//| SymbolInfo                                                       |
//+------------------------------------------------------------------+
void SymbolInfo()
  {
//-- SetObjects
   ObjectSetString(0,OBJPREFIX+"ASK",OBJPROP_TEXT,DoubleToString(MarketInfo(_Symbol,MODE_ASK),_Digits));
   ObjectSetString(0,OBJPREFIX+"BID",OBJPROP_TEXT,DoubleToString(MarketInfo(_Symbol,MODE_BID),_Digits));
//--
   ObjectSetString(0,OBJPREFIX+"UPTICKS",OBJPROP_TEXT,DoubleToString(UpTicks,0));
   ObjectSetString(0,OBJPREFIX+"DWNTICKS",OBJPROP_TEXT,DoubleToString(DwnTicks,0));
//--
   ObjectSetString(0,OBJPREFIX+"TIMER",OBJPROP_TEXT,"->"+TimeToString(Time[0]+Period()*60-TimeCurrent(),TIME_MINUTES|TIME_SECONDS));
//--
   ObjectSetString(0,OBJPREFIX+"SPREAD",OBJPROP_TEXT,DoubleToString(MarketInfo(_Symbol,MODE_SPREAD),0)+"p");

//-- GetOpen&Close
   double dayopen=iOpen(NULL,PERIOD_D1,0);
   double dayclose=iClose(NULL,PERIOD_D1,0);

//-- AvoidZeroDivide
   if(dayclose!=0)
     {
      //-- CalcPercentage
      double symbol_p=NormalizeDouble((dayclose-dayopen)/dayclose*100,2);
      //-- PositiveValue
      if(symbol_p>0)
        {
         //-- SetObjects
         ObjectSetString(0,OBJPREFIX+"SYMBOL§",OBJPROP_TEXT,0,"é");
         ObjectSetInteger(0,OBJPREFIX+"SYMBOL§",OBJPROP_COLOR,±Clr(symbol_p));
         //--
         ObjectSetString(0,OBJPREFIX+"SYMBOL%",OBJPROP_TEXT,0,±Str(symbol_p,2)+"%");
         ObjectSetInteger(0,OBJPREFIX+"SYMBOL%",OBJPROP_COLOR,±Clr(symbol_p));
        }
      //-- NegativeValue
      if(symbol_p<0)
        {
         //-- SetObjects
         ObjectSetString(0,OBJPREFIX+"SYMBOL§",OBJPROP_TEXT,0,"ê");
         ObjectSetInteger(0,OBJPREFIX+"SYMBOL§",OBJPROP_COLOR,±Clr(symbol_p));
         //--
         ObjectSetString(0,OBJPREFIX+"SYMBOL%",OBJPROP_TEXT,0,±Str(symbol_p,2)+"%");
         ObjectSetInteger(0,OBJPREFIX+"SYMBOL%",OBJPROP_COLOR,±Clr(symbol_p));
        }
      //-- NeutralValue
      if(symbol_p==0)
        {
         //-- SetObjects
         ObjectSetString(0,OBJPREFIX+"SYMBOL§",OBJPROP_TEXT,0,"è");
         ObjectSetInteger(0,OBJPREFIX+"SYMBOL%",OBJPROP_COLOR,±Clr(symbol_p));
         //--
         ObjectSetString(0,OBJPREFIX+"SYMBOL%",OBJPROP_TEXT,0,±Str(symbol_p,2)+"%");
         ObjectSetInteger(0,OBJPREFIX+"SYMBOL§",OBJPROP_COLOR,±Clr(symbol_p));
        }
     }
//-- ResetCumulatedTicks
   ResetTicks();
//--
  }
//+------------------------------------------------------------------+
//| Speedometer                                                      |
//+------------------------------------------------------------------+
void Speedometer()
  {
//-- CalcSpeed
   double LastPrice=AvgPrice/_Point;
   double CurrentPrice=((MarketInfo(_Symbol,MODE_ASK)+MarketInfo(_Symbol,MODE_BID))/2)/_Point;
   double Speed=NormalizeDouble((CurrentPrice-LastPrice),0);
   AvgPrice=(MarketInfo(_Symbol,MODE_ASK)+MarketInfo(_Symbol,MODE_BID))/2;

//-- SetMaxSpeed
   if(Speed>99)
      Speed=99;

//-- ResetColors
   for(int i=0; i<(MaxSpeedBars); i++)
     {
      //-- SetObjects
      ObjectSetInteger(0,OBJPREFIX+"SPEED#"+IntegerToString(i,0,0),OBJPROP_COLOR,clrNONE);
      ObjectSetInteger(0,OBJPREFIX+"SPEEDª",OBJPROP_COLOR,clrNONE);
     }

//-- SetColor&Text
   for(int i=0; i<MathAbs(Speed); i++)
     {
      //-- PositiveValue
      if(Speed>0)
        {
         //-- SetObjects
         ObjectSetInteger(0,OBJPREFIX+"SPEED#"+IntegerToString(i,0,0),OBJPROP_COLOR,COLOR_BUY);
         ObjectSetInteger(0,OBJPREFIX+"SPEEDª",OBJPROP_COLOR,COLOR_BUY);
         //--
         UpTicks+=Speed;//Cumulated
        }
      //-- NegativeValue
      if(Speed<0)
        {
         //-- SetObjects
         ObjectSetInteger(0,OBJPREFIX+"SPEED#"+IntegerToString(i,0,0),OBJPROP_COLOR,COLOR_SELL);
         ObjectSetInteger(0,OBJPREFIX+"SPEEDª",OBJPROP_COLOR,COLOR_SELL);
         //--
         DwnTicks+=MathAbs(Speed);//Cumulated
        }
      ObjectSetString(0,OBJPREFIX+"SPEEDª",OBJPROP_TEXT,0,±Str(Speed,0));//SetObject
     }

//-- IsPlayTickSound
   if(PlayTicks)
     {
      //-- SetWavFile
      string SpeedToStr="";
      //-- PositiveValue
      if(Speed>0)
        {
         SpeedToStr="+"+DoubleToString(MathMin(Speed,10),0);
        }
      //-- NegativeValue
      else
        {
         SpeedToStr=""+DoubleToString(MathMax(Speed,-10),0);
        }
      //--
      _PlaySound("::Files\\TradePanel\\Tick"+SpeedToStr+".wav");
     }
//--
  }
//+------------------------------------------------------------------+
//| AccAndTradeInfo                                                  |
//+------------------------------------------------------------------+
void AccAndTradeInfo()
  {
//-- ZeroOrders
   if(OpenPos(OP_ALL)==0)
     {
      //-- SetObjects
      ObjectSetInteger(0,OBJPREFIX+"ROIª",OBJPROP_COLOR,±Clr(DailyProfits()));
      ObjectSetInteger(0,OBJPREFIX+"ROI§",OBJPROP_COLOR,±Clr(DailyProfits()));
      //--
      ObjectSetString(0,OBJPREFIX+"ROI%",OBJPROP_TEXT,±Str(DailyReturn(),2)+"%");
      ObjectSetInteger(0,OBJPREFIX+"ROI%",OBJPROP_COLOR,±Clr(DailyReturn()));
      //--
      ObjectSetString(0,OBJPREFIX+"PROFITS",OBJPROP_TEXT,±Str(DailyProfits(),2)+_AccountCurrency());
      ObjectSetInteger(0,OBJPREFIX+"PROFITS",OBJPROP_COLOR,±Clr(DailyProfits()));
      //--
      ObjectSetString(0,OBJPREFIX+"POINTS",OBJPROP_TEXT,±Str(DailyPoints(),0)+"p");
      ObjectSetInteger(0,OBJPREFIX+"POINTS",OBJPROP_COLOR,±Clr(DailyPoints()));
      //--
      ObjectSetString(0,OBJPREFIX+"FLOATª",OBJPROP_TEXT,"");
      ObjectSetInteger(0,OBJPREFIX+"FLOATª",OBJPROP_COLOR,clrNONE);
      //--
      ObjectSetString(0,OBJPREFIX+"FLOAT§",OBJPROP_TEXT,"");
      ObjectSetInteger(0,OBJPREFIX+"FLOAT§",OBJPROP_COLOR,clrNONE);
      //--
      ObjectSetString(0,OBJPREFIX+"FLOAT$",OBJPROP_TEXT,DoubleToString(0,_Digits));
      ObjectSetInteger(0,OBJPREFIX+"FLOAT$",OBJPROP_COLOR,clrNONE);
     }

//-- BuyOrders
   if(OpenPos(OP_BUY)>0 && OpenPos(OP_SELL)==0)
     {
      //-- SetObjects
      ObjectSetString(0,OBJPREFIX+"FLOATª",OBJPROP_TEXT,"ö");
      ObjectSetInteger(0,OBJPREFIX+"FLOATª",OBJPROP_COLOR,clrDodgerBlue);
      //--
      ObjectSetString(0,OBJPREFIX+"FLOAT§",OBJPROP_TEXT,"Buy");
      ObjectSetInteger(0,OBJPREFIX+"FLOAT§",OBJPROP_COLOR,clrDodgerBlue);
      //--
      ObjectSetString(0,OBJPREFIX+"FLOAT$",OBJPROP_TEXT,DoubleToString(ØOpenPrice(),_Digits));
      ObjectSetInteger(0,OBJPREFIX+"FLOAT$",OBJPROP_COLOR,clrDodgerBlue);
     }

//-- SellOrders
   if(OpenPos(OP_SELL)>0 && OpenPos(OP_BUY)==0)
     {
      //-- SetObjects
      ObjectSetString(0,OBJPREFIX+"FLOATª",OBJPROP_TEXT,"ø");
      ObjectSetInteger(0,OBJPREFIX+"FLOATª",OBJPROP_COLOR,clrNONE);
      //--
      ObjectSetString(0,OBJPREFIX+"FLOAT§",OBJPROP_TEXT,"Sell");
      ObjectSetInteger(0,OBJPREFIX+"FLOAT§",OBJPROP_COLOR,clrNONE);
      //--
      ObjectSetString(0,OBJPREFIX+"FLOAT$",OBJPROP_TEXT,DoubleToString(ØOpenPrice(),_Digits));
      ObjectSetInteger(0,OBJPREFIX+"FLOAT$",OBJPROP_COLOR,clrNONE);
     }

//-- Buy&Sell Orders (Hedge)
   if(OpenPos(OP_BUY)>0 && OpenPos(OP_SELL)>0)
     {
      //-- SetObjects
      ObjectSetString(0,OBJPREFIX+"FLOATª",OBJPROP_TEXT,"ô");
      ObjectSetInteger(0,OBJPREFIX+"FLOATª",OBJPROP_COLOR,COLOR_HEDGE);
      //--
      ObjectSetString(0,OBJPREFIX+"FLOAT§",OBJPROP_TEXT,"Hedge");
      ObjectSetInteger(0,OBJPREFIX+"FLOAT§",OBJPROP_COLOR,COLOR_HEDGE);
      //--
      ObjectSetString(0,OBJPREFIX+"FLOAT$",OBJPROP_TEXT,DoubleToString(ØOpenPrice(),_Digits));
      ObjectSetInteger(0,OBJPREFIX+"FLOAT$",OBJPROP_COLOR,COLOR_HEDGE);
     }

//-- AtLeastOneOrder
   if(OpenPos(OP_ALL)>0)
     {
      //-- SetObjects
      ObjectSetInteger(0,OBJPREFIX+"ROIª",OBJPROP_COLOR,clrNONE);
      ObjectSetInteger(0,OBJPREFIX+"ROI§",OBJPROP_COLOR,clrNONE);
      //--
      ObjectSetInteger(0,OBJPREFIX+"ROI%",OBJPROP_COLOR,clrNONE);
      //--
      ObjectSetString(0,OBJPREFIX+"PROFITS",OBJPROP_TEXT,±Str(FloatingProfits(),2)+_AccountCurrency());
      ObjectSetInteger(0,OBJPREFIX+"PROFITS",OBJPROP_COLOR,±Clr(FloatingProfits()));
      //--
      ObjectSetString(0,OBJPREFIX+"POINTS",OBJPROP_TEXT,±Str(FloatingPoints(),0)+"p");
      ObjectSetInteger(0,OBJPREFIX+"POINTS",OBJPROP_COLOR,±Clr(FloatingPoints()));
     }

//-- DisplayOrderHistory
   /*if(ShowOrdHistory)
      DrawOrdHistory();*/
//--
  }
//+------------------------------------------------------------------+
//| GetSetCoordinates                                                |
//+------------------------------------------------------------------+
void GetSetCoordinates()
  {
//--
   if(TestModePanelOFF == true)
   return ; 
   if(ObjectFind(0,OBJPREFIX+"BCKGRND[]")!=0)//ObjectNotFound
     {

      //-- DeleteObjects (Background must be at the back)
      for(int i=0; i<ObjectsTotal(); i++)
        {
         //-- GetObjectName
         string obj_name=ObjectName(i);
         //-- PrefixObjectFound
         if(StringSubstr(obj_name,0,StringLen(OBJPREFIX))==OBJPREFIX)
           {
            //-- DeleteObjects
            if(ObjectsDeleteAll(0,OBJPREFIX,-1,-1)>0)
               break;
           }
        }

      //-- GetXYValues (Saved)
      if(GlobalVariableGet(ExpertName+" - X")!=0 && GlobalVariableGet(ExpertName+" - Y")!=0)
        {
         x1=(int)GlobalVariableGet(ExpertName+" - X");
         y1=(int)GlobalVariableGet(ExpertName+" - Y");
        }
      //-- SetXYValues (Default)
      else
        {
         x1=CLIENT_BG_X;
         y1=CLIENT_BG_Y;
        }

      //-- CreateObject (Background)
      RectLabelCreate(0,OBJPREFIX+"BCKGRND[]",0,x1,y1,x2,y2,COLOR_BG,BORDER_FLAT,CORNER_LEFT_UPPER,C'67,96,195',STYLE_SOLID,1,false,true,true,0,"\n");
      ObjectSetInteger(0,OBJPREFIX+"BCKGRND[]",OBJPROP_SELECTED,false);//UnselectObject
     }

//-- GetCoordinates
   x1=(int)ObjectGetInteger(0,OBJPREFIX+"BCKGRND[]",OBJPROP_XDISTANCE);
   y1=(int)ObjectGetInteger(0,OBJPREFIX+"BCKGRND[]",OBJPROP_YDISTANCE);

//-- SetCommonAxis
   button_y=y1+y2-(BUTTON_HEIGHT+BUTTON_GAP_Y);
   inputs_y=button_y-BUTTON_HEIGHT-BUTTON_GAP_Y;
   label_y=inputs_y+EDIT_HEIGHT/2;
//--
   fr_x=x1+SPEEDBAR_GAP_X;
//--
  }
//+------------------------------------------------------------------+
//| CreateObjects                                                    |
//+------------------------------------------------------------------+ 
void ObjectsCreateAll()
  {
  if(TestModePanelOFF == true)
  return ;
//--
   ButtonCreate(0,OBJPREFIX+"RESET",0,CLIENT_BG_X,CLIENT_BG_Y,15,15,CORNER_LEFT_UPPER,"°","Wingdings",10,COLOR_FONT,COLOR_MOVE,clrOrange,false,false,false,true,0,"\n");
//--
   RectLabelCreate(0,OBJPREFIX+"BORDER[]",0,x1,y1,x2,INDENT_TOP,clrAliceBlue,BORDER_FLAT,CORNER_LEFT_UPPER,1,STYLE_SOLID,1,false,false,true,0,"\n");
//-- 
   LabelCreate(0,OBJPREFIX+"CAPTION",0,x1+(x2/2),y1+15,CORNER_LEFT_UPPER,/*name*/"JJJJJ","Impact",15,clrDarkGoldenrod,0,ANCHOR_UPPER,false,false,true,0,"\n");
//-- 
   LabelCreate(0,OBJPREFIX+"EXIT",0,(x1+(x2/2))+143,y1-2,CORNER_LEFT_UPPER,"r","Webdings",10,C'59,41,40',0,ANCHOR_UPPER,false,false,true,0,"\n",false);
//--
   ButtonCreate(0,OBJPREFIX+"MOVE",0,x1,y1,15,15,CORNER_LEFT_UPPER,"ó","Wingdings",10,COLOR_FONT,COLOR_MOVE,clrBlanchedAlmond,false,false,false,true,0,"\n");
//--
  // LabelCreate(0,OBJPREFIX+"CONNECTION",0,(x1+(x2/2))-97,y1-2,CORNER_LEFT_UPPER,"ü","Webdings",10,C'59,41,40',0,ANCHOR_UPPER,false,false,true,0,"",false);
//--
  // LabelCreate(0,OBJPREFIX+"THEME",0,(x1+(x2/2))-90,y1-4,CORNER_LEFT_UPPER,"N","Webdings",15,C'59,41,40',0,ANCHOR_UPPER,false,false,true,0,"\n",false);
//--
  // LabelCreate(0,OBJPREFIX+"PAINT",0,(x1+(x2/2))-48,y1,CORNER_LEFT_UPPER,"$","Wingdings 2",13,C'59,41,40',0,ANCHOR_UPPER,false,false,true,0,"\n",false);
//--
   //LabelCreate(0,OBJPREFIX+"PLAY",0,(x1+(x2/2))+75,y1-5,CORNER_LEFT_UPPER,"4","Webdings",15,C'59,41,40',0,ANCHOR_UPPER,false,false,true,0,"\n",false);
//--
   //LabelCreate(0,OBJPREFIX+"CANDLES¦",0,(x1+(x2/2))+97,y1-6,CORNER_LEFT_UPPER,"ß","Webdings",15,C'59,41,40',0,ANCHOR_UPPER,false,false,true,0,"\n",false);
//--
  // LabelCreate(0,OBJPREFIX+"SOUND",0,(x1+(x2/2))+50,y1-2,CORNER_LEFT_UPPER,"X","Webdings",12,C'59,41,40',0,ANCHOR_UPPER,false,false,true,0,"\n",false);
//--
  // LabelCreate(0,OBJPREFIX+"SOUNDIO",0,(x1+(x2/2))+60,y1-1,CORNER_LEFT_UPPER,"ð","Webdings",10,C'59,41,40',0,ANCHOR_UPPER,false,false,true,0,"\n",false);
//--
   EditCreate(0,OBJPREFIX+"SYMBOL¤",0,x1+BUTTON_GAP_X,y1+INDENT_TOP+BUTTON_GAP_X+30,EDIT_WIDTH+10,EDIT_HEIGHT+10,_Symbol,"Trebuchet MS",10,ALIGN_CENTER,false,CORNER_LEFT_UPPER,COLOR_FONT,COLOR_BG,clrDimGray,false,false,true,0);
//--
  // LabelCreate(0,OBJPREFIX+"SYMBOL§",0,x1+100,y1+27,CORNER_LEFT_UPPER,"","Wingdings",12,clrLimeGreen,0,ANCHOR_RIGHT,false,false,true,0,"\n");
//--
   //LabelCreate(0,OBJPREFIX+"SYMBOL%",0,x1+145,y1+27,CORNER_LEFT_UPPER,"","Arial Black",8,COLOR_FONT,0,ANCHOR_RIGHT,false,false,true,0,"\n");
//--
 //  LabelCreate(0,OBJPREFIX+"SPEEDª",0,x1+SPEEDTEXT_GAP_X,y1+SPEEDTEXT_GAP_Y,CORNER_LEFT_UPPER,"","Tahoma",12,clrNONE,0.0,ANCHOR_RIGHT,false,false,true,0);
//--
  // LabelCreate(0,OBJPREFIX+"CLOSE¹²³",0,(x1+BUTTON_GAP_X)+37,(y1+INDENT_TOP+BUTTON_GAP_X)+27,CORNER_LEFT_UPPER,CloseArr[CloseMode],"Arial",6,COLOR_FONT,0,ANCHOR_CENTER,false,false,true,0,"\n",false);
//--
   LabelCreate(0,OBJPREFIX+"SPREAD",0,x1+150,y1+70,CORNER_LEFT_UPPER,"","Broadway",12,C'100,183,60',0,ANCHOR_CENTER,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"SPREAD§",0,x1+150,y1+55,CORNER_LEFT_UPPER,"SPREAD","Forte",10,COLOR_FONT,0,ANCHOR_CENTER,false,false,true,0,"\n");
//--
  // RectLabelCreate(0,OBJPREFIX+"ASK[]",0,x1+155,y1+41,85,15,COLOR_ASK_REC,BORDER_FLAT,CORNER_LEFT_UPPER,COLOR_ASK_REC,STYLE_SOLID,1,false,false,true,0,"\n");
//--
 //  LabelCreate(0,OBJPREFIX+"ASK",0,x1+180,y1+100,CORNER_LEFT_UPPER,"","Arial",8,COLOR_FONT2,0,ANCHOR_CENTER,false,false,FALSE,0,"\n");
//--
  // RectLabelCreate(0,OBJPREFIX+"BID[]",0,x1+125,y1+56,85,15,COLOR_BID_REC,BORDER_FLAT,CORNER_LEFT_UPPER,COLOR_BID_REC,STYLE_SOLID,1,false,false,true,0,"\n");
//--
  // LabelCreate(0,OBJPREFIX+"BID",0,x1+180,y1+63,CORNER_LEFT_UPPER,"","Arial",8,COLOR_FONT2,0,ANCHOR_CENTER,false,false,FALSE,0,"\n");
//--
  // LabelCreate(0,OBJPREFIX+"UPTICKS",0,x1+225,y1+49,CORNER_LEFT_UPPER,"","Arial",8,COLOR_FONT2,0,ANCHOR_CENTER,false,false,true,0,"\n");
//--
  // LabelCreate(0,OBJPREFIX+"DWNTICKS",0,x1+140,y1+63,CORNER_LEFT_UPPER,"","Arial",8,COLOR_FONT2,0,ANCHOR_CENTER,false,false,true,0,"\n");
//--
  // LabelCreate(0,OBJPREFIX+"UP»",0,x1+141,y1+47,CORNER_LEFT_UPPER,"6","Webdings",12,COLOR_SELL,0,ANCHOR_CENTER,false,false,true,0,"\n");
//--
  // LabelCreate(0,OBJPREFIX+"DN»",0,x1+225,y1+63,CORNER_LEFT_UPPER,"5","Webdings",12,COLOR_BUY,0,ANCHOR_CENTER,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"TIMER",0,x1+210,y1+60,CORNER_LEFT_UPPER,"","Tahoma",10,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"FLOATª",0,x1+BUTTON_GAP_X,inputs_y-145,CORNER_LEFT_UPPER,"","Wingdings",15,clrNONE,0,ANCHOR_LEFT,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"FLOAT§",0,x1+BUTTON_GAP_X+40,inputs_y-145,CORNER_LEFT_UPPER,"","Magneto Bold",9,clrNONE,0,ANCHOR_CENTER,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"FLOAT$",0,x1+BUTTON_GAP_X+140,inputs_y-145,CORNER_LEFT_UPPER,"","Magneto Bold",9,clrNONE,0,ANCHOR_RIGHT,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"PROFITS",0,x1+BUTTON_GAP_X+220,inputs_y-145,CORNER_LEFT_UPPER,"","Magneto Bold",8,clrNONE,0,ANCHOR_RIGHT,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"POINTS",0,x1+BUTTON_GAP_X+290,inputs_y-145,CORNER_LEFT_UPPER,"","Magneto Bold",9,clrNONE,0,ANCHOR_RIGHT,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"ROIª",0,x1+BUTTON_GAP_X+5,inputs_y-145,CORNER_LEFT_UPPER,"TodayProfit","Calibri",8,clrNONE,0,ANCHOR_LEFT,false,false,true,0,"\n");
//--
  // LabelCreate(0,OBJPREFIX+"ROI§",0,x1+BUTTON_GAP_X+45,inputs_y-15,CORNER_LEFT_UPPER,"","Arial",9,clrNONE,0,ANCHOR_LEFT,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"ROI%",0,x1+BUTTON_GAP_X+130,inputs_y-145,CORNER_LEFT_UPPER,"","Arial",9,clrNONE,0,ANCHOR_RIGHT,false,false,true,0,"\n");
//--
   EditCreate(0,OBJPREFIX+"SL<>",0,x1+BUTTON_GAP_X,inputs_y-120,EDIT_WIDTH+5,EDIT_HEIGHT+5,DoubleToString(StopLossInp,3),"Tahoma",10,ALIGN_RIGHT,false,CORNER_LEFT_UPPER,C'59,41,40',clrWhite,clrWhite,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"SLª",0,x1+BUTTON_GAP_X+EDIT_GAP_Y,label_y-120,CORNER_LEFT_UPPER,"sl","Arial",10,clrDarkGray,0,ANCHOR_CENTER,false,false,true,0,"\n");
//--
   EditCreate(0,OBJPREFIX+"LOTSIZE<>",0,x1+BUTTON_GAP_X+BUTTON_WIDTH+BUTTON_GAP_X+25,inputs_y-120,EDIT_WIDTH+5,EDIT_HEIGHT+5,DoubleToString(LotSizeInp,3),"Tahoma",10,ALIGN_CENTER,false,CORNER_LEFT_UPPER,C'59,41,40',clrWhite,clrWhite,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"LOTSIZE<",0,(x1+BUTTON_GAP_X+EDIT_GAP_Y)+100,label_y-115,CORNER_LEFT_UPPER,"6","Webdings",10,C'59,41,40',0,ANCHOR_CENTER,false,false,true,0,"\n",false);
//--
   LabelCreate(0,OBJPREFIX+"LOTSIZE>",0,(x1+BUTTON_GAP_X+EDIT_GAP_Y)+160,label_y-115,CORNER_LEFT_UPPER,"5","Webdings",10,C'59,41,40',0,ANCHOR_CENTER,false,false,true,0,"\n",false);
//--
   EditCreate(0,OBJPREFIX+"TP<>",0,x1+(BUTTON_WIDTH*2)+(BUTTON_GAP_X*3)+50,inputs_y-120,EDIT_WIDTH+5,EDIT_HEIGHT+5,DoubleToString(TakeProfitInp,0),"Tahoma",10,ALIGN_RIGHT,false,CORNER_LEFT_UPPER,C'59,41,40',clrWhite,clrWhite,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"TPª",0,x1+(BUTTON_WIDTH*2)+(BUTTON_GAP_X*3)+50+EDIT_GAP_Y,label_y-120,CORNER_LEFT_UPPER,"tp","Arial",10,clrDarkGray,0,ANCHOR_CENTER,false,false,true,0,"\n");
//--
   ButtonCreate(0,OBJPREFIX+"SELL",0,x1+BUTTON_GAP_X,button_y-115,BUTTON_WIDTH+60,BUTTON_HEIGHT+40,CORNER_LEFT_UPPER,"","Trebuchet MS",10,C'214,60,81',C'214,60,81',C'239,112,112',false,false,false,true,1,"\n");
//--
   ButtonCreate(0,OBJPREFIX+"CLOSE",0,x1+BUTTON_GAP_X,button_y-45,BUTTON_WIDTH+60,BUTTON_HEIGHT+40,CORNER_LEFT_UPPER,"一鍵清倉","華康布丁體(P)",12,C'241,212,198',C'7,41,85',C'241,212,198',false,false,false,true,1,"\n");
//--
   ButtonCreate(0,OBJPREFIX+"BUY",0,x1+(BUTTON_WIDTH*2)+(BUTTON_GAP_X*3)-5,button_y-115,BUTTON_WIDTH+60,BUTTON_HEIGHT+40,CORNER_LEFT_UPPER,"","Trebuchet MS",10,C'160,192,255',C'160,192,255',C'59,41,40',false,false,false,true,1,"\n");
//--
   LabelCreate(0,OBJPREFIX+"ASK",0,x1+225,y1+190,CORNER_LEFT_UPPER,"","Arial",18,clrWhite,0,ANCHOR_CENTER,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"BID",0,x1+70,y1+190,CORNER_LEFT_UPPER,"","Arial",18,clrWhite,0,ANCHOR_CENTER,false,false,FALSE,0,"\n");
//--
   EditCreate(0,OBJPREFIX+"FSL<>",0,x1+(BUTTON_WIDTH*2)+(BUTTON_GAP_X*3)+20,inputs_y-20,EDIT_WIDTH+10,EDIT_HEIGHT+5,DoubleToString(FirstSLInp,0),"Tahoma",10,ALIGN_RIGHT,false,CORNER_LEFT_UPPER,C'59,41,40',clrWhite,clrWhite,false,false,true,0,"\n");
//--
   LabelCreate(0,OBJPREFIX+"FSL",0,x1+(BUTTON_WIDTH*2)+(BUTTON_GAP_X*3)+30+EDIT_GAP_Y,label_y-20,CORNER_LEFT_UPPER,"1st sl","Arial",10,clrDarkGray,0,ANCHOR_CENTER,false,false,true,0,"\n");
//--
//   m_check1.Create(0,"check",0,x1+(BUTTON_WIDTH*2)+(BUTTON_GAP_X*3)+30,30+EDIT_GAP_Y, BUTTON_WIDTH+50, BUTTON_HEIGHT+50) ;  
     // ObjectSetText(Name,CharToStr(254),14,"Wingdings",clrBlack);
/*//-- CreateSpeedBars
   for(int i=0; i<MaxSpeedBars; i++)
     {
      LabelCreate(0,OBJPREFIX+"SPEED#"+IntegerToString(i),0,fr_x,y1+SPEEDBAR_GAP_Y,CORNER_LEFT_UPPER,"l","Arial Black",15,clrNONE,0.0,ANCHOR_RIGHT,false,false,true,0);
      fr_x-=5;
     }

//-- Strategy Tester (Cannot change symbol)
   if(IsTesting())
     {
      if(ObjectFind(0,OBJPREFIX+"SYMBOL¤")==0)//ObjectIsPresent
        {
         if(!ObjectGetInteger(0,OBJPREFIX+"SYMBOL¤",OBJPROP_READONLY))//GetObject
            ObjectSetInteger(0,OBJPREFIX+"SYMBOL¤",OBJPROP_READONLY,true);//SetObject
        }
     }*/
//--
  }
  
  
//+------------------------------------------------------------------+
//| MoveObjects                                                      |
//+------------------------------------------------------------------+
void ObjectsMoveAll()
  {
//--
   if(TestModePanelOFF == true)
   return ; 
   RectLabelMove(0,OBJPREFIX+"BORDER[]",x1,y1);
//--
   LabelMove(0,OBJPREFIX+"CAPTION",(x1+(x2/2)),y1+15);
//--
   LabelMove(0,OBJPREFIX+"EXIT",(x1+(x2/2))+143,y1-2);
//--
   ButtonMove(0,OBJPREFIX+"MOVE",x1,y1);
//--
   LabelMove(0,OBJPREFIX+"CONNECTION",(x1+(x2/2))-97,y1-2);
//--
   LabelMove(0,OBJPREFIX+"THEME",(x1+(x2/2))-90,y1-4);
//--
   LabelMove(0,OBJPREFIX+"PAINT",(x1+(x2/2))-48,y1);
//--
   LabelMove(0,OBJPREFIX+"PLAY",(x1+(x2/2))+75,y1-5);
//--
   LabelMove(0,OBJPREFIX+"CANDLES¦",(x1+(x2/2))+97,y1-6);
//--
   LabelMove(0,OBJPREFIX+"SOUND",(x1+(x2/2))+50,y1-2);
//--
   LabelMove(0,OBJPREFIX+"SOUNDIO",(x1+(x2/2))+60,y1-1);
//--
   EditMove(0,OBJPREFIX+"SYMBOL¤",x1+BUTTON_GAP_X,y1+INDENT_TOP+BUTTON_GAP_X+30);
//--
   LabelMove(0,OBJPREFIX+"SYMBOL§",x1+100,y1+27);
//--
   LabelMove(0,OBJPREFIX+"SYMBOL%",x1+145,y1+27);
//--   
   LabelMove(0,OBJPREFIX+"SPEEDª",x1+SPEEDTEXT_GAP_X,y1+SPEEDTEXT_GAP_Y);
//--
   LabelMove(0,OBJPREFIX+"CLOSE¹²³",(x1+BUTTON_GAP_X)+37,(y1+INDENT_TOP+BUTTON_GAP_X)+27);
//--
   LabelMove(0,OBJPREFIX+"SPREAD",x1+150,y1+70);
//--
   LabelMove(0,OBJPREFIX+"SPREAD§",x1+150,y1+55);
//--
   RectLabelMove(0,OBJPREFIX+"ASK[]",x1+155,y1+41);
//--
   LabelMove(0,OBJPREFIX+"ASK",x1+225,y1+190);
//--
   RectLabelMove(0,OBJPREFIX+"BID[]",x1+125,y1+56);
//--
   LabelMove(0,OBJPREFIX+"BID",x1+70,y1+190);
//--
   LabelMove(0,OBJPREFIX+"UPTICKS",x1+225,y1+49);
//--
   LabelMove(0,OBJPREFIX+"DWNTICKS",x1+140,y1+63);
//--
   LabelMove(0,OBJPREFIX+"UP»",x1+141,y1+47);
//--
   LabelMove(0,OBJPREFIX+"DN»",x1+225,y1+63);
//--
   LabelMove(0,OBJPREFIX+"TIMER",x1+210,y1+60);
//--
   LabelMove(0,OBJPREFIX+"FLOATª",x1+BUTTON_GAP_X,inputs_y-145);
//--
   LabelMove(0,OBJPREFIX+"FLOAT§",x1+BUTTON_GAP_X+40,inputs_y-145);
//--
   LabelMove(0,OBJPREFIX+"FLOAT$",x1+BUTTON_GAP_X+140,inputs_y-145);
//--
   LabelMove(0,OBJPREFIX+"PROFITS",x1+BUTTON_GAP_X+220,inputs_y-145);
//--
   LabelMove(0,OBJPREFIX+"POINTS",x1+BUTTON_GAP_X+290,inputs_y-145);
//--
   LabelMove(0,OBJPREFIX+"ROIª",x1+BUTTON_GAP_X+5,inputs_y-145);
//--
   LabelMove(0,OBJPREFIX+"ROI§",x1+BUTTON_GAP_X+45,inputs_y-145);
//--
   LabelMove(0,OBJPREFIX+"ROI%",x1+BUTTON_GAP_X+130,inputs_y-145);
//--
   EditMove(0,OBJPREFIX+"SL<>",x1+BUTTON_GAP_X,inputs_y-120);
//--
   LabelMove(0,OBJPREFIX+"SLª",x1+BUTTON_GAP_X+EDIT_GAP_Y,label_y-120);
//--
   EditMove(0,OBJPREFIX+"LOTSIZE<>",x1+BUTTON_WIDTH+(BUTTON_GAP_X*2)+25,inputs_y-120);
//--
   LabelMove(0,OBJPREFIX+"LOTSIZE<",(x1+BUTTON_GAP_X+EDIT_GAP_Y)+100,label_y-115);
//--
   LabelMove(0,OBJPREFIX+"LOTSIZE>",(x1+BUTTON_GAP_X+EDIT_GAP_Y)+160,label_y-115);
//--
   EditMove(0,OBJPREFIX+"TP<>",x1+(BUTTON_WIDTH*2)+(BUTTON_GAP_X*3)+50,inputs_y-120);
//--
   LabelMove(0,OBJPREFIX+"TPª",x1+(BUTTON_WIDTH*2)+(BUTTON_GAP_X*3)+EDIT_GAP_Y+50,label_y-120);
//--
   ButtonMove(0,OBJPREFIX+"SELL",x1+BUTTON_GAP_X,button_y-115);
//--
   ButtonMove(0,OBJPREFIX+"CLOSE",x1+BUTTON_GAP_X,button_y-45);
//--
   ButtonMove(0,OBJPREFIX+"BUY",x1+(BUTTON_WIDTH*2)+(BUTTON_GAP_X*3)-5,button_y-115);
//--
   EditMove(0,OBJPREFIX+"FSL<>",x1+(BUTTON_WIDTH*2)+(BUTTON_GAP_X*3)+20,inputs_y-20);
//--
   LabelMove(0,OBJPREFIX+"FSL",x1+(BUTTON_WIDTH*2)+(BUTTON_GAP_X*3)+EDIT_GAP_Y+30,label_y-20);   

//-- MoveSpeedBars
   for(int i=0; i<MaxSpeedBars; i++)
     {
      LabelMove(0,OBJPREFIX+"SPEED#"+IntegerToString(i),fr_x,y1+SPEEDBAR_GAP_Y);
      fr_x-=5;
     }
//--
  }
//+------------------------------------------------------------------+
//| CheckObjects                                                     |
//+------------------------------------------------------------------+
void ObjectsCheckAll()
  {
//-- CreateObjects
   ObjectsCreateAll();/*User may have deleted one*/

//+------- TrackSomeObjects -------+

//-- IsSelectable
   if(ObjectFind(0,OBJPREFIX+"MOVE")==0 && ObjectFind(0,OBJPREFIX+"BCKGRND[]")==0)//ObjectIsPresent
     {
      if(ObjectGetInteger(0,OBJPREFIX+"MOVE",OBJPROP_STATE))//GetObject
        {
         if(!ObjectGetInteger(0,OBJPREFIX+"BCKGRND[]",OBJPROP_SELECTED))//GetObject
            ObjectSetInteger(0,OBJPREFIX+"BCKGRND[]",OBJPROP_SELECTED,true);//SetObject
        }
      //-- IsNotSelectable
      else
        {
         if(!ObjectGetInteger(0,OBJPREFIX+"MOVE",OBJPROP_STATE))//GetObject
            ObjectSetInteger(0,OBJPREFIX+"BCKGRND[]",OBJPROP_SELECTED,false);//SetObject
        }
     }

//-- IsConnected
   if(ObjectFind(0,OBJPREFIX+"CONNECTION")==0)//ObjectIsPresent
     {
      if(TerminalInfoInteger(TERMINAL_CONNECTED))
        {
         if(ObjectGetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TEXT)!="ü")//GetObject
            ObjectSetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TEXT,"ü");//SetObject
         if(ObjectGetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TOOLTIP)!="Connected")//GetObject
            ObjectSetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TOOLTIP,"Connected");//SetObject
        }
      //-- IsDisconnected
      else
        {
         if(ObjectGetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TEXT)!="ñ")//GetObject
            ObjectSetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TEXT,"ñ");//SetObject
         if(ObjectGetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TOOLTIP)!="No connection!")//GetObject
            ObjectSetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TOOLTIP,"No connection!");//SetObject
        }
     }

//-- SoundIsEnabled
   if(ObjectFind(0,OBJPREFIX+"SOUNDIO")==0)//ObjectIsPresent
     {
      if(SoundIsEnabled)
        {
         if(ObjectGetInteger(0,OBJPREFIX+"SOUNDIO",OBJPROP_COLOR)!=C'59,41,40')//GetObject
            ObjectSetInteger(0,OBJPREFIX+"SOUNDIO",OBJPROP_COLOR,C'59,41,40');//SetObject
        }
      //-- SoundIsDisabled
      else
        {
         if(ObjectGetInteger(0,OBJPREFIX+"SOUNDIO",OBJPROP_COLOR)!=clrNONE)//GetObject
            ObjectSetInteger(0,OBJPREFIX+"SOUNDIO",OBJPROP_COLOR,clrNONE);//SetObject
        }
     }

//-- TickSoundsAreEnabled
   if(ObjectFind(0,OBJPREFIX+"PLAY")==0)//ObjectIsPresent
     {
      if(PlayTicks)
        {
         if(ObjectGetString(0,OBJPREFIX+"PLAY",OBJPROP_TEXT)!=";")//GetObject
            ObjectSetString(0,OBJPREFIX+"PLAY",OBJPROP_TEXT,";");//SetObject
         if(ObjectGetInteger(0,OBJPREFIX+"PLAY",OBJPROP_FONTSIZE)!=14)//GetObject
            ObjectSetInteger(0,OBJPREFIX+"PLAY",OBJPROP_FONTSIZE,14);//SetObject
        }
      //-- TickSoundsAreDisabled
      else
        {
         if(ObjectGetString(0,OBJPREFIX+"PLAY",OBJPROP_TEXT)!="4")//GetObject
            ObjectSetString(0,OBJPREFIX+"PLAY",OBJPROP_TEXT,"4");//SetObject
         if(ObjectGetInteger(0,OBJPREFIX+"PLAY",OBJPROP_FONTSIZE)!=15)//GetObject
            ObjectSetInteger(0,OBJPREFIX+"PLAY",OBJPROP_FONTSIZE,15);//SetObject
        }
     }

//+--------------------------------+
//--
  }
//+------------------------------------------------------------------+
//| SetColors                                                        |
//+------------------------------------------------------------------+
void SetColors(const int Type)
  {
//--
   if(Type==LIGHT)
     {
      //-- Light
      COLOR_BG=C'40,40,40';
      COLOR_FONT=clrSkyBlue;
      COLOR_FONT2=COLOR_BG;
      COLOR_MOVE=clrDimGray;
      COLOR_GREEN=clrLimeGreen;
      COLOR_RED=clrRed;
      COLOR_HEDGE=clrGold;
      COLOR_ASK_REC=COLOR_SELL;
      COLOR_BID_REC=COLOR_BUY;
     }
   else
     {
      //-- Dark
      COLOR_BG=C'40,40,40';
      COLOR_FONT=clrSkyBlue;
      COLOR_FONT2=COLOR_BG;
      COLOR_MOVE=clrDimGray;
      COLOR_GREEN=clrLimeGreen;
      COLOR_RED=clrRed;
      COLOR_HEDGE=clrGold;
      COLOR_ASK_REC=COLOR_SELL;
      COLOR_BID_REC=COLOR_BUY;
     }
//--
  }
//+------------------------------------------------------------------+
//| SetTheme                                                         |
//+------------------------------------------------------------------+
void SetTheme(const int Type)
  {
//--
   if(Type==DARK)
     {
      //-- Dark
      COLOR_BG=C'28,28,28';
      COLOR_FONT=clrDarkGray;
      COLOR_MOVE=clrDimGray;
      COLOR_GREEN=clrLimeGreen;
      COLOR_RED=clrRed;
      COLOR_HEDGE=clrGold;
      //-- SetObjects
      ObjectSetInteger(0,OBJPREFIX+"RESET",OBJPROP_BGCOLOR,COLOR_MOVE);
      ObjectSetInteger(0,OBJPREFIX+"RESET",OBJPROP_COLOR,COLOR_FONT);
      //--
      ObjectSetInteger(0,OBJPREFIX+"BCKGRND[]",OBJPROP_BGCOLOR,COLOR_BG);
      //--
      ObjectSetInteger(0,OBJPREFIX+"MOVE",OBJPROP_BGCOLOR,COLOR_MOVE);
      ObjectSetInteger(0,OBJPREFIX+"MOVE",OBJPROP_COLOR,COLOR_FONT);
      //--
      ObjectSetInteger(0,OBJPREFIX+"CLOSE¹²³",OBJPROP_COLOR,COLOR_FONT);
      //--
      ObjectSetInteger(0,OBJPREFIX+"SYMBOL¤",OBJPROP_BGCOLOR,COLOR_BG);
      ObjectSetInteger(0,OBJPREFIX+"SYMBOL¤",OBJPROP_COLOR,COLOR_FONT);
      //--
      ObjectSetInteger(0,OBJPREFIX+"ASK[]",OBJPROP_BGCOLOR,COLOR_SELL);
      ObjectSetInteger(0,OBJPREFIX+"ASK[]",OBJPROP_COLOR,COLOR_SELL);
      ObjectSetInteger(0,OBJPREFIX+"ASK",OBJPROP_COLOR,COLOR_BG);
      ObjectSetInteger(0,OBJPREFIX+"UPTICKS",OBJPROP_COLOR,COLOR_BG);
      //--
      ObjectSetInteger(0,OBJPREFIX+"BID[]",OBJPROP_BGCOLOR,COLOR_BUY);
      ObjectSetInteger(0,OBJPREFIX+"BID[]",OBJPROP_COLOR,COLOR_BUY);
      ObjectSetInteger(0,OBJPREFIX+"BID",OBJPROP_COLOR,COLOR_BG);
      ObjectSetInteger(0,OBJPREFIX+"DWNTICKS",OBJPROP_COLOR,COLOR_BG);
      //--
      ObjectSetInteger(0,OBJPREFIX+"SPREAD§",OBJPROP_COLOR,COLOR_FONT);
      ObjectSetInteger(0,OBJPREFIX+"SPREAD",OBJPROP_COLOR,COLOR_FONT);
      //--
      ObjectSetInteger(0,OBJPREFIX+"TIMER",OBJPROP_COLOR,COLOR_FONT);
      //-- StoreSelectedTheme
      SelectedTheme=DARK;
     }
   else
     {
//-- Light
      COLOR_BG=C'28,28,28';
      COLOR_FONT=clrDarkGray;
      COLOR_MOVE=clrDimGray;
      COLOR_GREEN=clrLimeGreen;
      COLOR_RED=clrRed;
      COLOR_HEDGE=clrGold;
      //-- SetObjects
      ObjectSetInteger(0,OBJPREFIX+"RESET",OBJPROP_BGCOLOR,COLOR_MOVE);
      ObjectSetInteger(0,OBJPREFIX+"RESET",OBJPROP_COLOR,COLOR_FONT);
      //--
      ObjectSetInteger(0,OBJPREFIX+"BCKGRND[]",OBJPROP_BGCOLOR,COLOR_BG);
      //--
      ObjectSetInteger(0,OBJPREFIX+"MOVE",OBJPROP_BGCOLOR,COLOR_MOVE);
      ObjectSetInteger(0,OBJPREFIX+"MOVE",OBJPROP_COLOR,COLOR_FONT);
      //--
      ObjectSetInteger(0,OBJPREFIX+"CLOSE¹²³",OBJPROP_COLOR,COLOR_FONT);
      //--
      ObjectSetInteger(0,OBJPREFIX+"SYMBOL¤",OBJPROP_BGCOLOR,COLOR_BG);
      ObjectSetInteger(0,OBJPREFIX+"SYMBOL¤",OBJPROP_COLOR,COLOR_FONT);
      //--
      ObjectSetInteger(0,OBJPREFIX+"ASK[]",OBJPROP_BGCOLOR,COLOR_SELL);
      ObjectSetInteger(0,OBJPREFIX+"ASK[]",OBJPROP_COLOR,COLOR_SELL);
      ObjectSetInteger(0,OBJPREFIX+"ASK",OBJPROP_COLOR,COLOR_BG);
      ObjectSetInteger(0,OBJPREFIX+"UPTICKS",OBJPROP_COLOR,COLOR_BG);
      //--
      ObjectSetInteger(0,OBJPREFIX+"BID[]",OBJPROP_BGCOLOR,COLOR_BUY);
      ObjectSetInteger(0,OBJPREFIX+"BID[]",OBJPROP_COLOR,COLOR_BUY);
      ObjectSetInteger(0,OBJPREFIX+"BID",OBJPROP_COLOR,COLOR_BG);
      ObjectSetInteger(0,OBJPREFIX+"DWNTICKS",OBJPROP_COLOR,COLOR_BG);
      //--
      ObjectSetInteger(0,OBJPREFIX+"SPREAD§",OBJPROP_COLOR,COLOR_FONT);
      ObjectSetInteger(0,OBJPREFIX+"SPREAD",OBJPROP_COLOR,COLOR_FONT);
      //--
      ObjectSetInteger(0,OBJPREFIX+"TIMER",OBJPROP_COLOR,COLOR_FONT);
      //-- StoreSelectedTheme
      SelectedTheme=DARK;
      //-- StoreSelectedTheme
      SelectedTheme=LIGHT;
     }
//--
  }
//+------------------------------------------------------------------+
//| ResetTicks                                                       |
//+------------------------------------------------------------------+
bool ResetTicks()
  {
//--
   static datetime lastbar=0;
//--
   if(lastbar!=Time[0])
     {
      //-- ResetTicks
      UpTicks=0;
      DwnTicks=0;
      //-- StoreBarTime
      lastbar=Time[0];
      return(true);
     }
   else
     {
      return(false);
     }
//--
  }
//+------------------------------------------------------------------+
//| ±Str                                                             |
//+------------------------------------------------------------------+
string ±Str(double Inp,int Precision)
  {
//-- PositiveValue
   if(Inp>0)
     {
      return("+"+DoubleToString(Inp,Precision));
     }
//-- NegativeValue
   else
     {
      return(DoubleToString(Inp,Precision));
     }
//--
  }
//+------------------------------------------------------------------+
//| ±Clr                                                             |
//+------------------------------------------------------------------+
color ±Clr(double Inp)
  {
//--
   color clr=clrNONE;
//-- PositiveValue
   if(Inp>0)
     {
      clr=COLOR_GREEN;
     }
//-- NegativeValue
   if(Inp<0)
     {
      clr=COLOR_RED;
     }
//-- NeutralValue
   if(Inp==0)
     {
      clr=COLOR_FONT;
     }
//--
   return(clr);
//--
  }
//+------------------------------------------------------------------+
//| SymbolFind                                                       |
//+------------------------------------------------------------------+
bool SymbolFind(const string _Symb)
  {
//--
   bool result=false;
//--
   for(int i=0; i<SymbolsTotal(false); i++)
     {
      if(_Symb==SymbolName(i,false))
        {
         result=true;//SymbolFound
         break;
        }
     }
   return(result);
  }
//+------------------------------------------------------------------+
//| DrawOrdHistory                                                   |
//+------------------------------------------------------------------+
void DrawOrdHistory()
  {
//--
   string obj_name="",ordtype="",ticket="",openprice="",closeprice="",ordlots="",stoploss="",takeprofit="";
//--
   for(int i=OrdersHistoryTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
        {
         if(OrderSymbol()==_Symbol && OrderMagicNumber()==MagicNumber)
           {
            if(OrderType()<=OP_SELL)//MarketOrdersOnly
              {
               //-- SetColor&OrdType
               if(OrderType()==OP_SELL){COLOR_ARROW=COLOR_SELL;ordtype="sell";}//SellOrders
               else{COLOR_ARROW=COLOR_BUY;ordtype="buy";}/*BuyOrders*/
               //-- ConvertToString
               ticket=IntegerToString(OrderTicket());//GetTicket
               openprice=DoubleToString(OrderOpenPrice(),_Digits);//GetOpenPrice
               closeprice=DoubleToString(OrderClosePrice(),_Digits);//GetClosePrice
               ordlots=DoubleToString(OrderLots(),2);/*GetOrderLots*/
               //-- OrderLine
               obj_name="#"+ticket+" "+openprice+" -> "+closeprice;//SetName
               TrendCreate(0,obj_name,0,OrderOpenTime(),OrderOpenPrice(),OrderCloseTime(),OrderClosePrice(),COLOR_ARROW,STYLE_DOT,1,false,false,false,0);
               //-- OpenArrow
               obj_name="#"+ticket+" "+ordtype+" "+ordlots+" "+_Symbol+" at "+openprice;//SetName
               ArrowCreate(0,obj_name,0,OrderOpenTime(),OrderOpenPrice(),1,ANCHOR_BOTTOM,COLOR_ARROW,STYLE_SOLID,1,false,false,false,0);
               //-- CloseArrow
               obj_name+=" close at "+closeprice;//SetName
               ArrowCreate(0,obj_name,0,OrderCloseTime(),OrderClosePrice(),3,ANCHOR_BOTTOM,COLOR_CLOSE,STYLE_SOLID,1,false,false,false,0);
               //-- StopLossArrow
               if(OrderStopLoss()>0)
                 {
                  stoploss=DoubleToString(OrderStopLoss(),_Digits);//GetStopLoss
                  obj_name="#"+ticket+" "+ordtype+" "+ordlots+" "+_Symbol+" at "+openprice+" sl at "+stoploss;//SetName
                  ArrowCreate(0,obj_name,0,OrderOpenTime(),OrderStopLoss(),4,ANCHOR_BOTTOM,COLOR_SELL,STYLE_SOLID,1,false,false,false,0);
                 }
               //-- TakeProfitArrow
               if(OrderTakeProfit()>0)
                 {
                  takeprofit=DoubleToString(OrderTakeProfit(),_Digits);//GetTakeProfit
                  obj_name="#"+ticket+" "+ordtype+" "+ordlots+" "+_Symbol+" at "+openprice+" tp at "+takeprofit;//SetName
                  ArrowCreate(0,obj_name,0,OrderOpenTime(),OrderTakeProfit(),4,ANCHOR_BOTTOM,COLOR_BUY,STYLE_SOLID,1,false,false,false,0);
                 }
               //--
              }
           }
        }
     }
//--
  }
//+------------------------------------------------------------------+
//| Create rectangle label                                           |
//+------------------------------------------------------------------+
bool RectLabelCreate(const long             chart_ID=0,               // chart's ID
                     const string           name="RectLabel",         // label name
                     const int              sub_window=0,             // subwindow index
                     const int              x=0,                      // X coordinate
                     const int              y=0,                      // Y coordinate
                     const int              width=50,                 // width
                     const int              height=18,                // height
                     const color            back_clr=C'236,233,216',  // background color
                     const ENUM_BORDER_TYPE border=BORDER_SUNKEN,     // border type
                     const ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                     const color            clr=clrRed,               // flat border color (Flat)
                     const ENUM_LINE_STYLE  style=STYLE_SOLID,        // flat border style
                     const int              line_width=1,             // flat border width
                     const bool             back=false,               // in the background
                     const bool             selection=false,          // highlight to move
                     const bool             hidden=true,              // hidden in the object list
                     const long             z_order=0,                // priority for mouse click 
                     const string           tooltip="\n")             // tooltip for mouse hover
  {
//--- reset the error value
   ResetLastError();
//--
   if(ObjectFind(chart_ID,name)!=0)
     {
      if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE_LABEL,sub_window,0,0))
        {
         Print(__FUNCTION__,
               ": failed to create a rectangle label! Error code = ",_LastError);
         return(false);
        }
      //-- SetObjects
      ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
      ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
      ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_TYPE,border);
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
      ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,line_width);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
      ObjectSetString(chart_ID,name,OBJPROP_TOOLTIP,tooltip);
     }
//--
   return(true);
  }
//+------------------------------------------------------------------+
//| Move rectangle label                                             |
//+------------------------------------------------------------------+
bool RectLabelMove(const long   chart_ID=0,       // chart's ID
                   const string name="RectLabel", // label name
                   const int    x=0,              // X coordinate
                   const int    y=0)              // Y coordinate
  {
//--- reset the error value
   ResetLastError();
//--
   if(ObjectFind(chart_ID,name)==0)
     {
      if(!ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x))
        {
         Print(__FUNCTION__,
               ": failed to move X coordinate of the label! Error code = ",_LastError);
         return(false);
        }
      if(!ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y))
        {
         Print(__FUNCTION__,
               ": failed to move Y coordinate of the label! Error code = ",_LastError);
         return(false);
        }
     }
//--
   return(true);
  }
//+------------------------------------------------------------------+ 
//| Create the button                                                | 
//+------------------------------------------------------------------+ 
bool ButtonCreate(const long              chart_ID=0,               // chart's ID 
                  const string            name="Button",            // button name 
                  const int               sub_window=0,             // subwindow index 
                  const int               x=0,                      // X coordinate 
                  const int               y=0,                      // Y coordinate 
                  const int               width=50,                 // button width 
                  const int               height=18,                // button height 
                  const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring 
                  const string            text="",            // text 
                  const string            font="Arial",             // font 
                  const int               font_size=10,             // font size 
                  const color             clr=clrNONE,             // text color 
                  const color             back_clr=C'236,233,216',  // background color 
                  const color             border_clr=clrAzure,       // border color 
                  const bool              state=false,              // pressed/released 
                  const bool              back=false,               // in the background 
                  const bool              selection=false,          // highlight to move 
                  const bool              hidden=true,              // hidden in the object list 
                  const long              z_order=0,                // priority for mouse click 
                  const string            tooltip="\n")             // tooltip for mouse hover
  {
//-- reset the error value 
   ResetLastError();
//--
   if(ObjectFind(chart_ID,name)!=0)
     {
      if(!ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0))
        {
         Print(__FUNCTION__,
               ": failed to create the button! Error code = ",_LastError);
         return(false);
        }
      //-- SetObjects
      ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
      ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
      ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
      ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
      ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
      ObjectSetString(chart_ID,name,OBJPROP_TOOLTIP,tooltip);
     }
//--
   return(true);
  }


//+------------------------------------------------------------------+
//| Move the button                                                  |
//+------------------------------------------------------------------+
bool ButtonMove(const long   chart_ID=0,    // chart's ID
                const string name="Button", // button name
                const int    x=0,           // X coordinate
                const int    y=0)           // Y coordinate
  {
//--- reset the error value
   ResetLastError();
//--
   if(ObjectFind(chart_ID,name)==0)
     {
      if(!ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x))
        {
         Print(__FUNCTION__,
               ": failed to move X coordinate of the button! Error code = ",_LastError);
         return(false);
        }
      if(!ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y))
        {
         Print(__FUNCTION__,
               ": failed to move Y coordinate of the button! Error code = ",_LastError);
         return(false);
        }
     }
//--
   return(true);
  }
//+------------------------------------------------------------------+ 
//| Create a text label                                              | 
//+------------------------------------------------------------------+ 
bool LabelCreate(const long              chart_ID=0,               // chart's ID 
                 const string            name="Label",             // label name 
                 const int               sub_window=0,             // subwindow index 
                 const int               x=0,                      // X coordinate 
                 const int               y=0,                      // Y coordinate 
                 const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring 
                 const string            text="Label",             // text 
                 const string            font="Arial",             // font 
                 const int               font_size=10,             // font size 
                 const color             clr=clrRed,               // color 
                 const double            angle=0.0,                // text slope 
                 const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // anchor type 
                 const bool              back=false,               // in the background 
                 const bool              selection=false,          // highlight to move 
                 const bool              hidden=true,              // hidden in the object list 
                 const long              z_order=0,                // priority for mouse click 
                 const string            tooltip="\n",             // tooltip for mouse hover
                 const bool              tester=true)              // create object in the strategy tester
  {
//-- reset the error value 
   ResetLastError();
//-- CheckTester
   if(!tester && IsTesting())
      return(false);
//--
   if(ObjectFind(chart_ID,name)!=0)
     {
      if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0))
        {
         Print(__FUNCTION__,
               ": failed to create text label! Error code = ",_LastError);
         return(false);
        }
      //-- SetObjects
      ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
      ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
      ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
      ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
      ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
      ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
      ObjectSetString(chart_ID,name,OBJPROP_TOOLTIP,tooltip);
     }
//--
   return(true);
  }
//+------------------------------------------------------------------+
//| Move the text label                                              |
//+------------------------------------------------------------------+
bool LabelMove(const long   chart_ID=0,   // chart's ID
               const string name="Label", // label name
               const int    x=0,          // X coordinate
               const int    y=0)          // Y coordinate
  {
//-- reset the error value
   ResetLastError();
//--
   if(ObjectFind(chart_ID,name)==0)
     {
      if(!ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x))
        {
         Print(__FUNCTION__,
               ": failed to move X coordinate of the label! Error code = ",_LastError);
         return(false);
        }
      if(!ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y))
        {
         Print(__FUNCTION__,
               ": failed to move Y coordinate of the label! Error code = ",_LastError);
         return(false);
        }
     }
//--
   return(true);
  }
//+------------------------------------------------------------------+
//| Create Edit object                                               |
//+------------------------------------------------------------------+
bool EditCreate(const long             chart_ID=0,               // chart's ID
                const string           name="Edit",              // object name
                const int              sub_window=0,             // subwindow index
                const int              x=0,                      // X coordinate
                const int              y=0,                      // Y coordinate
                const int              width=50,                 // width
                const int              height=18,                // height
                const string           text="Text",              // text
                const string           font="Arial",             // font
                const int              font_size=10,             // font size
                const ENUM_ALIGN_MODE  align=ALIGN_CENTER,       // alignment type
                const bool             read_only=false,          // ability to edit
                const ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                const color            clr=clrBlack,             // text color
                const color            back_clr=clrWhite,        // background color
                const color            border_clr=clrNONE,       // border color
                const bool             back=false,               // in the background
                const bool             selection=false,          // highlight to move
                const bool             hidden=true,              // hidden in the object list
                const long             z_order=0,                // priority for mouse click 
                const string           tooltip="\n")             // tooltip for mouse hover
  {
//-- reset the error value
   ResetLastError();
//--
   if(ObjectFind(chart_ID,name)!=0)
     {
      if(!ObjectCreate(chart_ID,name,OBJ_EDIT,sub_window,0,0))
        {
         Print(__FUNCTION__,
               ": failed to create \"Edit\" object! Error code = ",_LastError);
         return(false);
        }
      //-- SetObjects
      ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
      ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
      ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
      ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
      ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
      ObjectSetInteger(chart_ID,name,OBJPROP_ALIGN,align);
      ObjectSetInteger(chart_ID,name,OBJPROP_READONLY,read_only);
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
      ObjectSetString(chart_ID,name,OBJPROP_TOOLTIP,tooltip);
     }
//--
   return(true);
  }
//+------------------------------------------------------------------+
//| Move Edit object                                                 |
//+------------------------------------------------------------------+
bool EditMove(const long   chart_ID=0,  // chart's ID
              const string name="Edit", // object name
              const int    x=0,         // X coordinate
              const int    y=0)         // Y coordinate
  {

//-- reset the error value
   ResetLastError();
//--
   if(ObjectFind(chart_ID,name)==0)
     {
      if(!ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x))
        {
         Print(__FUNCTION__,
               ": failed to move X coordinate of the object! Error code = ",_LastError);
         return(false);
        }
      if(!ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y))
        {
         Print(__FUNCTION__,
               ": failed to move Y coordinate of the object! Error code = ",_LastError);
         return(false);
        }
     }
//--
   return(true);
  }
//+------------------------------------------------------------------+ 
//| Creating Text object                                             | 
//+------------------------------------------------------------------+ 
bool TextCreate(const long              chart_ID=0,               // chart's ID 
                const string            name="Text",              // object name 
                const int               sub_window=0,             // subwindow index 
                datetime                time=0,                   // anchor point time 
                double                  price=0,                  // anchor point price 
                const string            text="Text",              // the text itself 
                const string            font="Arial",             // font 
                const int               font_size=10,             // font size 
                const color             clr=clrRed,               // color 
                const double            angle=0.0,                // text slope 
                const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // anchor type 
                const bool              back=false,               // in the background 
                const bool              selection=false,          // highlight to move 
                const bool              hidden=true,              // hidden in the object list 
                const long              z_order=0,                // priority for mouse click 
                const string            tooltip="\n")             // tooltip for mouse hover
  {
//-- reset the error value
   ResetLastError();
//--
   if(ObjectFind(chart_ID,name)!=0)
     {
      if(!ObjectCreate(chart_ID,name,OBJ_TEXT,sub_window,time,price))
        {
         Print(__FUNCTION__,
               ": failed to create \"Text\" object! Error code = ",_LastError);
         return(false);
        }
      //-- SetObjects
      ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
      ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
      ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
      ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
      ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
      ObjectSetString(chart_ID,name,OBJPROP_TOOLTIP,tooltip);
     }
//--
   return(true);
  }
//+------------------------------------------------------------------+ 
//| Create the arrow                                                 | 
//+------------------------------------------------------------------+ 
bool ArrowCreate(const long              chart_ID=0,           // chart's ID 
                 const string            name="Arrow",         // arrow name 
                 const int               sub_window=0,         // subwindow index 
                 datetime                time=0,               // anchor point time 
                 double                  price=0,              // anchor point price 
                 const uchar             arrow_code=252,       // arrow code 
                 const ENUM_ARROW_ANCHOR anchor=ANCHOR_BOTTOM, // anchor point position 
                 const color             clr=clrRed,           // arrow color 
                 const ENUM_LINE_STYLE   style=STYLE_SOLID,    // border line style 
                 const int               width=3,              // arrow size 
                 const bool              back=false,           // in the background 
                 const bool              selection=true,       // highlight to move 
                 const bool              hidden=true,          // hidden in the object list 
                 const long              z_order=0)            // priority for mouse click 
  {
//-- reset the error value
   ResetLastError();
//--
   if(ObjectFind(chart_ID,name)!=0)
     {
      if(!ObjectCreate(chart_ID,name,OBJ_ARROW,sub_window,time,price))
        {
         Print(__FUNCTION__,
               ": failed to create an arrow! Error code = ",_LastError);
         return(false);
        }
      //-- SetObjects
      ObjectSetInteger(chart_ID,name,OBJPROP_ARROWCODE,arrow_code);
      ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
      ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
     }
//--
   return(true);
  }
//+------------------------------------------------------------------+ 
//| Create a trend line by the given coordinates                     | 
//+------------------------------------------------------------------+ 
bool TrendCreate(const long            chart_ID=0,        // chart's ID 
                 const string          name="TrendLine",  // line name 
                 const int             sub_window=0,      // subwindow index 
                 datetime              time1=0,           // first point time 
                 double                price1=0,          // first point price 
                 datetime              time2=0,           // second point time 
                 double                price2=0,          // second point price 
                 const color           clr=clrRed,        // line color 
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // line style 
                 const int             width=1,           // line width 
                 const bool            back=false,        // in the background 
                 const bool            selection=true,    // highlight to move 
                 const bool            ray_right=false,   // line's continuation to the right 
                 const bool            hidden=true,       // hidden in the object list 
                 const long            z_order=0)         // priority for mouse click 
  {
//-- reset the error value
   ResetLastError();
//--
   if(ObjectFind(chart_ID,name)!=0)
     {
      if(!ObjectCreate(chart_ID,name,OBJ_TREND,sub_window,time1,price1,time2,price2))
        {
         Print(__FUNCTION__,
               ": failed to create a trend line! Error code = ",_LastError);
         return(false);
        }
      //-- SetObjects
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
      ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_RAY_RIGHT,ray_right);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
     }
//--
   return(true);
  }
//+------------------------------------------------------------------------------+ 
//| ChartEventMouseMoveSet                                                       | 
//+------------------------------------------------------------------------------+ 
bool ChartEventMouseMoveSet(const bool value)
  {
//-- reset the error value 
   ResetLastError();
//--
   if(!ChartSetInteger(0,CHART_EVENT_MOUSE_MOVE,0,value))
     {
      Print(__FUNCTION__,
            ", Error Code = ",_LastError);
      return(false);
     }
//--
   return(true);
  }
//+--------------------------------------------------------------------+ 
//| ChartMouseScrollSet                                                | 
//+--------------------------------------------------------------------+ 
bool ChartMouseScrollSet(const bool value)
  {
//-- reset the error value 
   ResetLastError();
//--
   if(!ChartSetInteger(0,CHART_MOUSE_SCROLL,0,value))
     {
      Print(__FUNCTION__,
            ", Error Code = ",_LastError);
      return(false);
     }
//--
   return(true);
  }
//+------------------------------------------------------------------+
//| ChartMiddleX                                                     |
//+------------------------------------------------------------------+
int ChartMiddleX()
  {
   return((int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS)/2);
  }
//+------------------------------------------------------------------+
//| ChartMiddleY                                                     |
//+------------------------------------------------------------------+
int ChartMiddleY()
  {
   return((int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS)/2);
  }
//+------------------------------------------------------------------+
//| RandomColor                                                      |
//+------------------------------------------------------------------+
color RandomColor()
  {
//--
   int p1=0+255*MathRand()/32768;
   int p2=0+255*MathRand()/32768;
   int p3=0+255*MathRand()/32768;
//--
   return(StringToColor(IntegerToString(p1)+","+IntegerToString(p2)+","+IntegerToString(p3)));
  }
//+------------------------------------------------------------------+ 
//| PlaySound                                                        | 
//+------------------------------------------------------------------+ 
void _PlaySound(const string FileName)
  {
   if(SoundIsEnabled)
      PlaySound(FileName);
  }
//+------------------------------------------------------------------+
//| AccountCurrency                                                  |
//+------------------------------------------------------------------+
string _AccountCurrency()
  {
//--
   string txt="";
   if(AccountCurrency()=="AUD")txt="$";
   if(AccountCurrency()=="CAD")txt="$";
   if(AccountCurrency()=="CHF")txt="Fr.";
   if(AccountCurrency()=="EUR")txt="€";
   if(AccountCurrency()=="GBP")txt="£";
   if(AccountCurrency()=="JPY")txt="¥";
   if(AccountCurrency()=="NZD")txt="$";
   if(AccountCurrency()=="USD")txt="$";
   if(txt=="")txt="$";
   return(txt);
//--
  }
//+------------------------------------------------------------------+ 
//| Resources                                                        | 
//+------------------------------------------------------------------+ 
/*#resource "\\Files\\TradePanel\\sound.wav"
#resource "\\Files\\TradePanel\\error.wav"
#resource "\\Files\\TradePanel\\switch.wav"
#resource "\\Files\\TradePanel\\sell.wav"
#resource "\\Files\\TradePanel\\buy.wav"
#resource "\\Files\\TradePanel\\close.wav"
//--
#resource "\\Files\\TradePanel\\Tick+1.wav"
#resource "\\Files\\TradePanel\\Tick+2.wav"
#resource "\\Files\\TradePanel\\Tick+3.wav"
#resource "\\Files\\TradePanel\\Tick+4.wav"
#resource "\\Files\\TradePanel\\Tick+5.wav"
#resource "\\Files\\TradePanel\\Tick+6.wav"
#resource "\\Files\\TradePanel\\Tick+7.wav"
#resource "\\Files\\TradePanel\\Tick+8.wav"
#resource "\\Files\\TradePanel\\Tick+9.wav"
#resource "\\Files\\TradePanel\\Tick+10.wav"
//--
#resource "\\Files\\TradePanel\\Tick-1.wav"
#resource "\\Files\\TradePanel\\Tick-2.wav"
#resource "\\Files\\TradePanel\\Tick-3.wav"
#resource "\\Files\\TradePanel\\Tick-4.wav"
#resource "\\Files\\TradePanel\\Tick-5.wav"
#resource "\\Files\\TradePanel\\Tick-6.wav"
#resource "\\Files\\TradePanel\\Tick-7.wav"
#resource "\\Files\\TradePanel\\Tick-8.wav"
#resource "\\Files\\TradePanel\\Tick-9.wav"
#resource "\\Files\\TradePanel\\Tick-10.wav"*/
//+------------------------------------------------------------------+ 
//| End of the code                                                  | 
//+------------------------------------------------------------------+ 
//+------------------------------------------------------------------+
//| timetotrade                                          |
//+------------------------------------------------------------------+

bool TimeSession(int aStartHour,int aStopHour,datetime aTimeCur)
  {
//--- session start time
   int StartTime=3600*aStartHour;
//--- session end time
   int StopTime=3600*aStopHour;
//--- current time in seconds since the day start
   aTimeCur=aTimeCur%86400;
   if(StopTime<StartTime)
     {
      //--- going past midnight
      if(aTimeCur>=StartTime || aTimeCur<StopTime)
        {
         return(true);
        }
     }
   else
     {
      //--- within one day
      if(aTimeCur>=StartTime && aTimeCur<StopTime)
        {
         return(true);
        }
     }
   return(false);
  }
//+------------------------------------------------------------------+

bool newBar(int period) {
//
static datetime previousTime;
datetime currentTime;
bool returnValue;
//
currentTime = iTime(NULL,period,0);
if (returnValue = (previousTime < currentTime))
   previousTime = currentTime;
return returnValue;
}
//+------------------------------------------------------------------+
//| 關閉所有持倉Symbol                                                      |
//+------------------------------------------------------------------+
void CloseAllOpenPositions(){
   bool checkOrderClose=false;
   int index=OrdersTotal()-1;


   for(int i = index ; i>=0 ; i--){
    if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      if(OrderSymbol()==my_symbol && OrderMagicNumber()==MagicNumber)
        if(!OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,clrWhite)){
          printf("Close error");
          Sleep(100) ;
        }
   }

}


//+------------------------------------------------------------------+
//| 新單開倉                                                         |
//+------------------------------------------------------------------+
void iOpenOrdes(string myType , double myLots , int myLossStop , int myTakeProfet){

  
   double BuyLossStop = Ask - myLossStop*_Point ;
   double BuyTakeProfit = Ask + myTakeProfet*_Point ;
   double SellLossStop = Bid + myLossStop*_Point ;
   double SellTakeProfit = Bid - myTakeProfet*_Point ;
   int TicketNumber ;
   if(myLossStop<=0){
      BuyLossStop = 0 ;
      SellLossStop = 0 ;     
   }
   
   if(myTakeProfet <= 0){
      BuyTakeProfit = 0 ;
      SellTakeProfit = 0 ;
   }
   
   
   if(myType == "Buy"){
     TicketNumber = OrderSend(_Symbol,OP_BUY,myLots,Ask,m_slippage,BuyLossStop,BuyTakeProfit,"EASET",MagicNumber,0,clrBlue) ;
     
   }
   if(myType == "Sell"){
     TicketNumber = OrderSend(_Symbol,OP_SELL,myLots,Bid,m_slippage,SellLossStop,SellTakeProfit,"EASET",MagicNumber,0,clrRed) ;
     
   }   
        
}
//+------------------------------------------------------------------+ 
//| openSignal                                                       | 
//+------------------------------------------------------------------+ 
string CrossOpen()
{
   string mktinf = "N/A" ; 
   

   //UPCROSS
   if(iMA_short[0] > iMA_long[0] && iMA_short[1] < iMA_long[1] ){
         mktinf = "buy" ;
   }
   
   
   
   //DOWNCROSS
   if(iMA_short[0] < iMA_long[0] && iMA_short[1] > iMA_long[1] ) {
         mktinf = "sell" ;
   }

   
   return(mktinf) ;
}
//+------------------------------------------------------------------+ 
//| 關倉訊號                           | 
//+------------------------------------------------------------------+ 
bool  CrossClose(){
   int closin = false ; 
   int index=OrdersTotal()-1;

  // ENUM_ORDER_TYPE ptype = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE) ; 
 

    while(index>=0 && OrderSelect(index,SELECT_BY_POS,MODE_TRADES)==true){
    
      if(OrderSymbol()==_Symbol && OrderMagicNumber()==MagicNumber){
        if(OrderType()== OP_BUY){
          if(iMA_short[0] < iMA_long[0] && iMA_short[1] > iMA_long[1])
         closin = true ;
          break; 
        }
        if(OrderType()==OP_SELL){
          if(iMA_short[0] > iMA_long[0] && iMA_short[1] < iMA_long[1])
         closin = true ;
            break;
        } 
     index-- ; 
     }     
   }
      return(closin) ;
      
}
//+------------------------------------------------------------------+ 
//| closebyprofit                                                    | 
//+------------------------------------------------------------------+ 

void closeby_Profit(){

   if(FloatingProfits()>profitout)
   OrderClose();
}
//+------------------------------------------------------------------+ 
//| 5ma 訊號  H4                                                     | 
//+------------------------------------------------------------------+ 
void four_hsignal(){
   
   double fhma10=0.0, fhma20=0.0,fhma50=0.0 ,fhma55=0.0 , fhma100=0.0 ;
 
   iMAh4[0]=iMAh4_10;
   iMAh4[1]=iMAh4_20;
   iMAh4[2]=iMAh4_50;
   iMAh4[3]=iMAh4_55;
   iMAh4[4]=iMAh4_100;
   
}
//+------------------------------------------------------------------+ 
//| 點數關倉                                                         | 
//+------------------------------------------------------------------+ 
void closebypoint(){
   
   double outpp = -CloseByPoint ;
   if(FloatingPoints()<outpp)
      OrderClose();
}

//+------------------------------------------------------------------+ 
//|              Symbol_Positioncount                                | 
//+------------------------------------------------------------------+ 
 
 int Symbol_Positioncount(){
   
  int ps_count = 0;
  int index=OrdersTotal(); 
  
  for(int i = 0; i<=index-1  ; i++){
   if(OrderSelect(i,SELECT_BY_POS))
    if(OrderSymbol()==_Symbol && OrderMagicNumber()==MagicNumber){
     ps_count = ps_count++;
     }
   }
     
   
     return(ps_count) ;
}  


//+------------------------------------------------------------------+ 
//| openSignal                                                       | 
//+------------------------------------------------------------------+ 
string SlopeOpenplus(){
   string mktinf = "N/A" ; 
   

   //UPCROSS
   if(iMA_short[0]>iMA_short[1] && iMA_long[0]>iMA_long[1] ){
         mktinf = "buy" ;
   }
   //DOWNCROSS
   
   if(iMA_short[0]<iMA_short[1] && iMA_long[0]<iMA_long[1]){
         mktinf = "sell" ;
   }

   
   return(mktinf) ;
}
//+------------------------------------------------------------------+ 
//| positionplus                                                     | 
//+------------------------------------------------------------------+ 
void positionMD(){

double probuy = NormalizeDouble(OrderOpenPrice()+_Point*protectprofit,Digits());
double prosell = NormalizeDouble(OrderOpenPrice()-_Point*protectprofit,Digits());
int preorder = OrdersTotal()-1 ;
int cg;
int cnt,total=OrdersTotal();
 

if(OrdersTotal()==0)
openhigh = 0;
if(OrdersTotal()==1)
openlow = OrderOpenPrice(); 

 for(cnt=preorder;cnt>=0;cnt--)
   if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
     if(OrderType()<=OP_SELL&&OrderSymbol()==Symbol()&&OrderMagicNumber()==my_magicNumber)
       if(protectprofit>0){
         if(OrderType()==OP_BUY){
              
                 if(NormalizeDouble(Ask-openhigh,_Digits)>protectprofit*_Point){
                  if(OrderStopLoss() != NormalizeDouble(OrderOpenPrice()+protectstep*_Point,_Digits))
                   cg = OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()+protectstep*_Point,Digits),OrderTakeProfit(),0,Orange);
                  
                  if(Ask>openhigh){
                     OrderSend(OP_BUY);
                     openhigh = Ask;
                     break;
                     }
                  }

               }
                 if(OrderType()==OP_SELL){
              
                 if(NormalizeDouble(MathAbs(Bid-openlow),_Digits)>protectprofit*_Point){
                  if(OrderStopLoss() != NormalizeDouble(OrderOpenPrice()-protectstep*_Point,_Digits))
                   cg = OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()-protectstep*_Point,Digits),OrderTakeProfit(),0,Orange);
                   
                  
                  if(Bid<openlow){
                     OrderSend(OP_SELL);
                     openlow = Bid;
                     break;
                     }
                  }

               }



/*         else {
              if(OrderStopLoss()==NormalizeDouble(OrderOpenPrice()-protectstep*_Point,_Digits))continue;{
                if(NormalizeDouble(OrderOpenPrice()-Bid,_Digits)>protectprofit*_Point)
                 cg = OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()-protectstep*_Point,Digits),OrderTakeProfit(),0,Orange);
                 }
                 if(SlopeOpenplus()=="sell" && Bid<prosell){
                  if(OrdersTotal()==1)openlow = OrderOpenPrice();
                   if(Bid<openlow){
                    OrderSend(OP_SELL);
                    openlow = OrderOpenPrice() ;

                    break ;
                   }
               }
            
        }//--SELLPLUS END*/
    }
 

 //--foreach order END

}


/*void buyplus(){

double probuy = NormalizeDouble(OrderOpenPrice()+_Point*protectprofit,Digits());
int preorder = OrdersTotal()-1 ;
int h_preorder = OrdersHistoryTotal()-1;
double openhigh=0 ; ;
      
      


        for(int i=preorder ; i>=0 ; i--)
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true) 
          if(OrderSymbol()==my_symbol && OrderMagicNumber()==my_magicNumber)         
            if(protectprofit>0){
             if(Ask!=GetLastPositionsPriceOpen())
               if(Ask-OrderOpenPrice()>=NormalizeDouble(_Point*protectprofit,_Digits) && SlopeOpenplus()=="buy"){
                if(tpmode==true){
                  RefreshRates() ;
                  if(OrderStopLoss()==NormalizeDouble(OrderOpenPrice()+protectstep*_Point,_Digits))continue;
                  if(!OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()+protectstep*_Point,Digits),OrderTakeProfit(),0,clrYellow))
                     printf("Modifyerroe") ;
                }
               if(OrdersTotal()==0)
                  openhigh = 0 ;
               if(Ask > openhigh)
               OrderSend(OP_BUY);
               openhigh = OrderOpenPrice() ;
               break;
              }
            }
     

}



void sellplus(){

double prosell = NormalizeDouble(OrderOpenPrice()-_Point*protectprofit,Digits());
int preorder = OrdersTotal()-1 ;
int h_preorder = OrdersHistoryTotal()-1;
//double openlow ;
 




       for(int i=preorder ; i>=0 ; i--)
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true) 
         if(OrderSymbol()==my_symbol && OrderMagicNumber()==my_magicNumber)      
          if(OrderType() == OP_SELL)
           if(protectprofit>0){
            if(Bid!=GetLastPositionsPriceOpen())
              if(MathAbs(Bid-OrderOpenPrice())>_Point*protectprofit){
               if(tpmode==true){
                   RefreshRates() ;
                  if(OrderStopLoss()==NormalizeDouble(OrderOpenPrice()-protectstep*_Point,_Digits))continue;
                  if(!OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()-protectstep*_Point,Digits),OrderTakeProfit(),0,clrYellow))
                  printf("Modifyerroe") ;
               }
           OrderSend(OP_SELL) ;
               break;
              }
           }
         
 
      return ;
   }
*/

 //+------------------------------------------------------------------+
//| Returns the price of opening of the last position                |
//+------------------------------------------------------------------+

double GetLastPositionsPriceOpen() { 

  double last_price=0.0;
  int preorder = OrdersTotal()-1 ;
int h_preorder = OrdersHistoryTotal()-1;
   


     
 for(int i=preorder;i>=0;i--){
  if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
   if(OrderSymbol()==my_symbol && OrderMagicNumber()==my_magicNumber){
     if(last_price == OrderOpenPrice())
      break ;
     else {      
     last_price = OrderOpenPrice();
     }
     break ;
    }
 }
 return (last_price) ; 
}
  

//+------------------------------------------------------------------+
//| Position select depending on netting or hedging                  |
//+------------------------------------------------------------------+
bool SelectPosition()
  {
   bool res=false;
//---
 //  printf("res===============================false") ;
     
    int index=OrdersTotal();
      for(int i=index; i>=0; i--){
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
          if(OrderSymbol()== my_symbol&& OrderMagicNumber()==my_magicNumber){
            res=true;
             //printf("res===============================true") ;
            break;
           }
      }

//---
   return(res);
  }
  
