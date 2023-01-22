Below is the starting model that sums up how we decomposed the "domain".

Flutter will be having a "QuestionType" visualizer and a "SurveyNavigator" that will take the user through the survey. 

The plan is to have less QuestionTypes than QuestionNodes (i.e. less than 20) and looks like this will be doable. 


```mermaid
classDiagram
    QuestionNode --> QuestionType

    class QuestionNode {
        string ID
        string Author
        bool IsTopLevel
        bool IsInverted
        string[] Questions
        QuestionType NodeType
        string QuestionGroupID
        ------
        string YesPathID
        string NoPathID
        string ThirdPathID
        
    }
    class QuestionType{
        various building blocks:
        SimpleYesNo, 
        OpenTextAnyAnswerWillDo,
        YesNoBranching,
        etc...
    }
```
