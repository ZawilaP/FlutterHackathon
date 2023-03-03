## FlutterHackathonTeam2 - badambadam 

badambadam is a web application written in flutter. It delivers the following functionalities:

+ **Done01** Parent can run a basic survey (20 question) and receive:
  +  a score, 
  +  results in PDF format,  
  +  unique ID that can be used for reference when talking with Synapsis
+  **Done02** In case the basic survey resulted in a score of 3-6 then Parent is presented with an option to run detailed survey. This survey again covers all the 20 questions but allows for tree like navigation as per MCHAT-R PDF rules. Same output: score, PDF with results, unique ID
+ **Done03** Parent can proceed to surveys only after providing a qualifying birth-date and postal code (no check on postal code being a real one).
+ **Done04** All responses are saved in a database, read access to it is restricted to authorized users (=Admin).
+ **Done05** Admin panel (authentication based on Firebase defined users) allows for editing question text. 
  +  Beware: it will fail to add new question, just the existing blocks can be renamed
+ **Done06** Admin panel allows Synapsis team to look into details of a saved survey (both basic and advances)

The following features are within reach:

+ Future01 PowerBI Dashboard, estimation: 2-3 WD
+ Future02 Internationalization - English version, estimation: 2-3 WD
+ Future03 Internationalization - more versions, estimation: 1-2 WD
+ Future04 Internationalization - translations, estimation: can be done by Synapsis, 1 WD per language with testing?

The following features can be considered as v2:

+ ...