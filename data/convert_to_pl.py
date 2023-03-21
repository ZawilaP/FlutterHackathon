import json

old = json.load(open('dupa123-4b1fa-default-rtdb-export.json',encoding="utf8"))
polish = json.load(open('survey_PL.json',encoding="utf8"))

def find_question_content_in_dict(json_dict,id):
    """find out the questions element in a large json_dict for a known id"""
    for element in json_dict["questions"]:
        if element["id"]==id:
            #print (element["questions"])
            return element["questions"]

for element in old["questions"]:
    id = element["id"]
    new_content = find_question_content_in_dict(polish,id)
    if new_content:
        element["questions"] = new_content
        print (f"question {id} converted to Polish")
    else:
        print (f">>>not able to find proper content for question {id}")

new_file = open('converted_to_pl.json',"w",encoding="utf8")
json.dump(old,new_file)