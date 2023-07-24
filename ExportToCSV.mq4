//+------------------------------------------------------------------+
//|                                                  ExportToCSV.mq4 |
//|                                                      XYNCRONIZED |
//|                                                 t.me/xyncronized |
//+------------------------------------------------------------------+
#property strict

// File handle for CSV
int file_handle;
extern string file_name = "Exported.csv";
string indicator_name = "waddah attar explosion averages nmc alerts 2_4.ex4";
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
void OnInit()
  {

// Open the file handle
   file_handle = FileOpen(file_name, FILE_WRITE | FILE_CSV | FILE_SHARE_READ, ';');
   if(file_handle == INVALID_HANDLE)
     {
      Print("Gagal membuka file ", file_name, ", error code: ", GetLastError());
      return;
     }

// Write header row if the file is empty
   if(FileIsEnding(file_handle))
     {
      //header for the column
      string header = "Time;WASval;WABval;ATRval;MAval;Action";
      FileWrite(file_handle, header);
     }
  }

//+------------------------------------------------------------------+
//| Export Indicator Data to CSV                                     |
//+------------------------------------------------------------------+
void ExportIndicatorDataToCSV()
  {
//Time match with the indicator index
   datetime time = iTime(NULL, PERIOD_CURRENT, 1);
//Indicator data example below, you can change with yours
   double atrval = iCustom(Symbol(),PERIOD_CURRENT,indicator_name,0,0,20,40,13,20,0,2.0,150,200,false,false,false,false,false,false,false,false,"alert2.wav",true,5,1);
   double maval = iCustom(Symbol(),PERIOD_CURRENT,indicator_name,0,0,20,40,13,20,0,2.0,150,200,false,false,false,false,false,false,false,false,"alert2.wav",true,4,1);
   double waBuy = iCustom(Symbol(),PERIOD_CURRENT,indicator_name,0,0,20,40,13,20,0,2.0,150,200,false,false,false,false,false,false,false,false,"alert2.wav",true,0,1);
   double waSell = iCustom(Symbol(),PERIOD_CURRENT,indicator_name,0,0,20,40,13,20,0,2.0,150,200,false,false,false,false,false,false,false,false,"alert2.wav",true,2,1);

//some logic, this can be ignored if you don't have indicator value that get max integer value, or you can change with your logic if the value is null
   if(waBuy > 100000)
     {
      waBuy = 0;
     }
   if(waSell > 100000)
     {
      waSell = 0;
     }

//formatted the time above to date/minutes
   string formatted_time = TimeToString(time, TIME_DATE | TIME_MINUTES);

//add some logic with indicator data to take the action "buy|wait|sell"
   string action;
   if(waSell > atrval && waSell > maval)
      action = "SELL";
   else
      if(waBuy > atrval && waBuy > maval)
         action = "BUY";
      else
         action = "WAIT";

//fill the column in csv, align it with each header position
   string line = formatted_time + ";" + DoubleToString(waSell, 2)  + ";" + DoubleToString(waBuy, 2) + ";" + DoubleToString(atrval, 2)+ ";" + DoubleToString(maval, 2) + ";" +action;
   FileWrite(file_handle, line);
  }

//+------------------------------------------------------------------+
//| OnTick function                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   ExportIndicatorDataToCSV();
  }

//+------------------------------------------------------------------+
//| Deinitialization function                                        |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
// Close the file handle when the script is stopped
   FileClose(file_handle);
  }
//+------------------------------------------------------------------+
