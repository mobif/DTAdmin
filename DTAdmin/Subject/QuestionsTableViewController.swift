//
//  QuestionsTableViewController.swift
//  DTAdmin
//
//  Created by ITA student on 10/26/17.
//  Copyright © 2017 if-ios-077. All rights reserved.


//  Question: {question_id, test_id, question_text, level, type, attachment}

import UIKit

class QuestionsTableViewController: UITableViewController {
    
    var questions = [QuestionStructure]()
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
        DataManager.shared.getListRange(forEntity: .Question, entityId: id, quantity: 100, fromNo: 0) {(questions, error) in
            if error == nil,
                let questions = questions as? [QuestionStructure] {
                self.questions = questions
                self.tableView.reloadData()
            } else {
                self.showWarningMsg(error ?? "Incorect type data")
            }
        }
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
            wayToAddNewQuestion.resultModification = { (questionReturn, isNew) in
            if isNew {
                self.questions.append(questionReturn)
                self.tableView.reloadData()
            }
            }
            self.navigationController?.pushViewController(wayToAddNewQuestion, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) 
        cell.textLabel?.text = questions[indexPath.row].questionText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
       let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            guard let questionId = self.questions[indexPath.row].id else { return }
            DataManager.shared.deleteEntity(byId: questionId, typeEntity: .Question)  { (result, error) in
                if let error = error {
                    self.showMessage(message: NSLocalizedString(error, comment: "Message for user") )
                } else {
                    self.questions.remove(at: indexPath.row)
                    }
            self.tableView.reloadData()
                }
            }
        let update = UITableViewRowAction(style: .normal, title: "Update") { (action, indexPath) in
            if let wayToAddNewQuestion = UIStoryboard(name: "Subjects", bundle: nil).instantiateViewController(withIdentifier: "AddNewQuestion") as? AddNewQuestionViewController {
                guard let questionId = self.questions[indexPath.row].id else { return }
                wayToAddNewQuestion.questionId = questionId
                wayToAddNewQuestion.testId = self.questions[indexPath.row].testId
                wayToAddNewQuestion.updateDates = true
                wayToAddNewQuestion.question = self.questions[indexPath.row]
//                wayToAddNewQuestion.saveAction = { item in
//                    guard let item = item else { return }
//                    self.questions[indexPath.row] = item
//                    self.tableView.reloadData()
//                }
                self.navigationController?.pushViewController(wayToAddNewQuestion, animated: true)
            }
        }
        update.backgroundColor = UIColor.blue
        return [delete, update]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let wayToShowQuestionInfo = UIStoryboard(name: "Subjects", bundle: nil).instantiateViewController(withIdentifier: "QuestionInfo") as? QuestionInfoViewController
        {
            wayToShowQuestionInfo.question = self.questions[indexPath.row]
            self.navigationController?.pushViewController(wayToShowQuestionInfo, animated: true)
        }
    }
    

}
