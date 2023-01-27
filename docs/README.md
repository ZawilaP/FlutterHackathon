## Model 

```mermaid
classDiagram

    class Backend{
        load_survey(guid) returns Survey, loads historical one
        register_new_survey(): returns id and guid
        save_survey(Survey): saves it to backend (and locally!)
        get_empty_survey(): get Survey details for user to fill in
    }

    class Survey{
        id/guid - when is a filled/being filled one 
        birth date 
        postal code
        
        getTopLevelQuestions(): List of Nodes
        getNodeByID(String): Node
    }

    Survey --"*" Node

    class Node {

    }

    Node --> NodeStatus
    Node --> NodeAnswer

    class NodeStatus{
        (enum actually)
    }

    class NodeAnswer{
        (enum actually)
    }

```

## Page Graph
```mermaid
graph TD
  Home[Home Page] --> |Take Survey| AgeCheck(Age Check)
  AgeCheck --> |Age within 16-30 months| BasicSurvey(Take Basic Survey)
  AgeCheck --> |Age not within 16-30 months| Home
  BasicSurvey --> |See Results| BasicResults(Basic Survey Result Page)
  BasicResults --> |Take Advanced Survey| AdvancedSurvey(Advanced Survey)
  AdvancedSurvey --> |Advanced Survey Results| AdvancedResults(Advanced Survey Result Page)
  
  Home --> |Past Surveys| SurveyList(List of Surveys)
  SurveyList --> |Basic Survey| BasicResults
  SurveyList --> |Advanced Survey| AdvancedResults
  
  Admin[Admin Panel] --> |Edit Questions| EditQuestions(Edit Questions)
  Admin --> |Review Surveys| SurveyList(List of Surveys)
```