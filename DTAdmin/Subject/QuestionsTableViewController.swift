//
//  QuestionsTableViewController.swift
//  DTAdmin
//
//  Created by ITA student on 10/26/17.
//  Copyright © 2017 if-ios-077. All rights reserved.


//  Question: {question_id, test_id, question_text, level, type, attachment}

import UIKit

class QuestionsTableViewController: UITableViewController {
    
    var questions = [Question]()
    let queryService = QueryService()
    var testId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Questions"
        guard let id = testId else { return }
        print(id)
        
        showQuestions(id: id)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func showQuestions(id: String) {
        Question.showQuestions(sufix: "getRecordsRangeByTest/" + id + "/100/0", completion: { (results:[Question]?) in
            
            if let data = results {
                self.questions = data
                for item in self.questions {
                    print("questionId " + item.questionId)
                    print("questionText " + item.questionText)
                    print("testId " + item.testId)
                    print("level " + item.level)
                    print("type " + item.type)
                    print("attachment " + item.attachment)

                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            
        })
    }
    
    private func showMessage(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert title"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok button"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addQuestion(_ sender: UIBarButtonItem) {
        if let wayToAddNewQuestion = UIStoryboard(name: "Subjects", bundle: nil).instantiateViewController(withIdentifier: "AddNewQuestion") as? AddNewQuestionViewController
        {
            wayToAddNewQuestion.testId = testId!
            wayToAddNewQuestion.saveAction = { item in
                guard let item = item else { return }
                self.questions.append(item)
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(wayToAddNewQuestion, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! QuestionTableViewCell

        cell.questionText.text = questions[indexPath.row].questionText
        cell.level.text = "Level: " + questions[indexPath.row].level
        cell.type.text = "Type: " + questions[indexPath.row].type

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125.0
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let item = self.questions[indexPath.row].questionId
            print(item)
            self.queryService.deleteReguest(sufix: "question/del/\(item)", completion: { (code: Int, error: (String)?) in
                print(code)
                DispatchQueue.main.async {
                    if let error = error {
                        self.showMessage(message: error)
                    }
                    if code == 200 {
                        self.questions.remove(at: indexPath.row)
                        tableView.reloadData()
                    } else {
                        self.showMessage(message: NSLocalizedString("Error", comment: "Message for user") )
                    }
                }
            })

        }
        let update = UITableViewRowAction(style: .normal, title: "Update") { (action, indexPath) in
            if let wayToAddNewQuestion = UIStoryboard(name: "Subjects", bundle: nil).instantiateViewController(withIdentifier: "AddNewQuestion") as? AddNewQuestionViewController
            {
                wayToAddNewQuestion.questionId = self.questions[indexPath.row].questionId
                wayToAddNewQuestion.testId = self.questions[indexPath.row].testId
                wayToAddNewQuestion.updateDates = true
                wayToAddNewQuestion.question = self.questions[indexPath.row]
                wayToAddNewQuestion.saveAction = { item in
                    guard let item = item else { return }
                    self.questions[indexPath.row] = item
                    self.tableView.reloadData()
                }
                self.navigationController?.pushViewController(wayToAddNewQuestion, animated: true)
            }
        }
        update.backgroundColor = UIColor.blue
        return [delete, update]
    }
    

}
