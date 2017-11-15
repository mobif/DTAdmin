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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Answers"
        guard let id = questionId else { return }
        print(id)
        showAnswers(id: id)
    }
    
    private func showAnswers(id: String) {
        DataManager.shared.getAnswers(byQuestion: id) { (answersResult, error) in
            if error == nil,
                let answersUnwrap = answersResult {
                self.answers = answersUnwrap
                self.tableView.reloadData()
            } else {
                self.showMessage(message: error ?? "Incorect type data")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath) as? AnswerTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        let cellData = answers[indexPath.row]
        cell.answerText.text = cellData.answerText
        let answerTrue = cellData.trueAnswer == "1" ? "Right" : "Wrong"
        cell.trueAnswer.text = answerTrue
        if cellData.attachmant.count > 0 {
            if let dataDecoded : Data = Data(base64Encoded: cellData.attachmant, options: .ignoreUnknownCharacters) {
                let decodedimage = UIImage(data: dataDecoded)
                cell.attachment.image = decodedimage
            }
        } else {
            cell.attachment.image = UIImage(named: "Image")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            guard let answerId = self.answers[indexPath.row].id else { return }
            DataManager.shared.deleteEntity(byId: answerId, typeEntity: .answer)  { (result, error) in
                if let error = error {
                    self.showMessage(message: NSLocalizedString(error, comment: "Message for user") )
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
    
}
