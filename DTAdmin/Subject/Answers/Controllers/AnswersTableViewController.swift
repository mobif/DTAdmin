//
//  AnswersTableViewController.swift
//  DTAdmin
//
//  Created by ITA student on 11/8/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class AnswersTableViewController: UITableViewController {
    
    var answers = [AnswerStructure]()
    var questionId: String?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Answers"

        myActivityIndicator.center = view.center
        view.addSubview(myActivityIndicator)

        showAnswers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func showAnswers() {
        myActivityIndicator.startAnimating()
        guard let id = questionId else { return }
        DataManager.shared.getAnswers(byQuestion: id) { (answersResult, errorMessage) in
            self.myActivityIndicator.stopAnimating()
            self.myActivityIndicator.hidesWhenStopped = true
            if errorMessage == nil,
                let answersUnwrap = answersResult {
                self.answers = answersUnwrap
                self.tableView.reloadData()
            } else {
                self.showMessage(message: errorMessage ?? "Incorect type data")
            }
        }
    }

    @IBAction func addNewAnswer(_ sender: Any) {
        guard let wayToAddNewAnswer = UIStoryboard(name: "Subjects", bundle: nil).instantiateViewController(withIdentifier: "AddNewAnswerViewController") as? AddNewAnswerViewController else { return }
        guard let id = questionId else { return }
        wayToAddNewAnswer.questionId = id
        wayToAddNewAnswer.resultModification = { anserReturn in
            self.answers.append(anserReturn)
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(wayToAddNewAnswer, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath) as? AnswerTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        let cellData = answers[indexPath.row]
        cell.setAnswer(answer: cellData)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            guard let answerId = self.answers[indexPath.row].id else { return }
            DataManager.shared.deleteEntity(byId: answerId, typeEntity: .answer)  { (result, errorMessage) in
                if let errorMessage = errorMessage {
                    self.showMessage(message: NSLocalizedString(errorMessage, comment: "Message for user") )
                } else {
                    self.answers.remove(at: indexPath.row)
                }
                self.tableView.reloadData()
            }
        }
        let update = UITableViewRowAction(style: .normal, title: "Update") { (action, indexPath) in
            guard let wayToAddNewAnswer = UIStoryboard(name: "Subjects", bundle: nil).instantiateViewController(withIdentifier: "AddNewAnswerViewController") as? AddNewAnswerViewController else { return }
            wayToAddNewAnswer.questionId = self.answers[indexPath.row].questionId
            wayToAddNewAnswer.updateDates = true
            wayToAddNewAnswer.answer = self.answers[indexPath.row]
            wayToAddNewAnswer.resultModification = { answerResult in
                self.answers[indexPath.row] = answerResult
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(wayToAddNewAnswer, animated: true)
        }
        update.backgroundColor = UIColor.blue
        return [delete, update]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let answerAttachmentViewController = UIStoryboard(name: "Subjects", bundle: nil).instantiateViewController(withIdentifier: "AnswerAttachmentViewController") as? AnswerAttachmentViewController else { return }
        answerAttachmentViewController.answerId = answers[indexPath.row].id
        self.navigationController?.pushViewController(answerAttachmentViewController, animated: true)
    }
    
}
