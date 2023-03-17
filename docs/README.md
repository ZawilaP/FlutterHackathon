## FlutterHackathonTeam2 - badambadam 

badambadam is a web application written in flutter. It delivers the following functionalities:

+ **Done01** Parent can run a basic survey (20 question) and receive:
  +  a score, 
  +  results in PDF format,  
  +  unique ID that can be used for reference when talking with Synapsis
+  **Done02** In case the basic survey resulted in a score of greater than 3 then Parent is presented with an option to run detailed survey. This survey again covers questions from the simple survey digging deep in those for which the parent got points but allows for tree like navigation as per MCHAT-R PDF rules. Same output: score, PDF with results, unique ID.
+ **Done03** Parent can proceed to surveys only after providing a qualifying birth-date and postal code (no check on postal code being a real one). TODO: save postal code, postal code validation done, saving to Firebase still TODO (**Francisco** to try: Submit button on main survey is the place to look at) 
+ **Done04** All responses are saved in a database, read access to it is restricted to authorized users (=Admin), seperate download for basic and advanced survey. 
+ **Done05** Admin panel (authentication based on Firebase defined users) allows for editing question text. 
  +  Beware: it will fail to add new question, just the existing blocks can be renamed
+ **Done06** Admin panel allows Synapsis team to look into details of a saved survey (both basic and advances) TODO: find search widget for admins for surveys. Need PDF list (TODO by **Nela**).
+ Polish language is the only version there (TODO: Fix it to be 100% compliant. **Piotr** to do it, troubleshoot with **Nela** required)

The following features are within reach:

+ Future01 PowerBI Dashboard, estimation: 2-3 WD
+ Future02 Internationalization - English version, estimation: 2-3 WD
+ Future03 Internationalization - more versions, estimation: 1-2 WD
+ Future04 Internationalization - translations, estimation: can be done by Synapsis, 1 WD per language with testing?

The following features can be considered as v2:

+ ...
