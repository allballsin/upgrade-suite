##Compilation Instructions for Original Software

- Install Delphi 5 without db or bde items into a non "Program Files" directory.
- Install Delphi 5 Update 1
- Install GExperts (optional but I like the search and multi-line component pallette features)
- Open and install the component package d5com/usuite/USD5.dpk
- Add the USD5.dpk directory to Project Options >> Search Path
- Add Delphi’s ToolsAPI directory to Project Options >> Search Path
- Remove Demo from Conditional Defines in Project Options
- Run TRegSvr bordbk50.dll from common files\borland shared\debugger

###Errors
**"This is demo software"**  
Remove Demo from Conditional Defines in Project Options

**"Debugger kernel bordbk50.dll missing or not registered" error:**  
TregSvr bordbk50.dll from common files\borland shared\debugger

The programs will probably (depending on your runtime configuration) raise an exception in IDE the first time they write registry entries. Continue running the exe and the operation should continue properly.

Enjoy!