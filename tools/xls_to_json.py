import pandas as pd
import pprint

df = pd.read_excel('mchatrf.xlsx')

class Node:
    def __init__(self, dict_input):
        self.id = dict_input['ID']
        self.author = dict_input['Who fills']
        self.is_top_level = dict_input['TopLevelNode']
        self.node_type = dict_input['DecisionAndDisplayMethod']
        self.no_path = dict_input["NoPath"]
        self.yes_path = dict_input["YesPath"]
        self.third_path = dict_input["OtherAnswerPath"]
        self.is_inverted = dict_input["IsInverted"]
        self.questions = dict_input['Questions_semicolon_separated'].split(";")
        self.question_group_id = dict_input['Question']
        
    def __str__(self):
        return f"{{ " + \
                f"\"id\": \"{self.id}\", " + \
                f"\"author\": \"{self.author}\", " + \
                f"\"is_top_level\": \"{self.is_top_level}\", " + \
                f"\"node_type\": \"{self.node_type}\", " + \
                f"\"no_path\": \"{self.no_path}\", " + \
                f"\"yes_path\": \"{self.yes_path}\", " + \
                f"\"third_path\": \"{self.third_path}\", " + \
                f"\"is_inverted\": \"{self.is_inverted}\", " + \
                f"\"questions\": {self.questions_as_json()}, " + \
                f"\"question_group_id\": \"{self.question_group_id}\" " + \
                f"}}"

    def questions_as_json(self):
        questions_string = "["
        for q in self.questions:
            q= q.replace("\n","")
            q= q.replace("\r","")
            questions_string += f"\"{q}\","
        questions_string = questions_string[:-1] # remove last comma
        questions_string += "]"
        return questions_string

df = df[df["ID"].notna()] # drop empty ones


output =  "{ \"questions\": ["
for row in df.to_dict(orient='records'):
    n = Node(row)
    output += str(n) + ",\n\n"
output = output[:-3] # remove last comma and line break ;)
output += "] }"
print (output)