# TimeLoggerNorbit
Small software for help us at the end of the month.  
First of all it is not clean and nice code, the target was something what works :)  

## Usage
Fill the fields for First and Last name and Role.  
Choose what were you doing on witch day.  
If you had an expense you can add them one by one with the + icon.  
If you dont give the Exchange rate than an API will do it.  
The result ZIP and optionally the Folder will be created under data_results directory.  
  
### Windows usage
Download the Release/Windows folder, and just run the exe.  
Tested on Windows 10 pro 64bit.   
  
### Ubuntu usage
Download the Release/Ubuntu folder, and at terminal run the software:  
```>>./timelogger_V_1_0```  
Tested on Ubuntu 20

## Known bugs
If you spend your weekend at abroad it wont appear in the excel.  
This case uncheck the Delete result folder checkbox, and add thoose weekends to it manually.
