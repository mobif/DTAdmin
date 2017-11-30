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
    var qustionType: String?
    var refresh: MyRefreshController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("Answers", comment: "Title for AnswersTableViewController")

        refreshControllConfigure()

        showAnswers()
    }

    private func refreshControllConfigure() {
        refresh = MyRefreshController()
        tableView.addSubview(refresh)
        refresh.addTarget(self, action: #selector(showAnswers), for: .valueChanged)
    }
    
    @objc private func showAnswers() {
        startActivityIndicator()
        guard let id = questionId else { return }
        DataManager.shared.getAnswers(byQuestion: id) { (answersResult, error) in
            self.stopActivityIndicator()
            self.refresh.endRefreshing()
            if let errorMessage = error {
                self.showMessage(message: errorMessage.message)
            } else {
                if let answersUnwrap = answersResult {
                    self.answers = answersUnwrap
                    self.tableView.reloadData()
                }
            }
        }
    }

    @IBAction func addNewAnswer(_ sender: Any) {
        guard let addNewAnswerViewController = UIStoryboard(name: "Subjects",
                                                            bundle: nil).instantiateViewController(withIdentifier: "AddNewAnswerViewController") as?
                                                            AddNewAnswerViewController else { return }
        guard let id = questionId else { return }
        guard let type = qustionType else { return }
        addNewAnswerViewController.questionId = id
        addNewAnswerViewController.qustionType = type
        addNewAnswerViewController.resultModification = { anserReturn in
            self.answers.append(anserReturn)
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(addNewAnswerViewController, animated: true)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath) as?
                                                                                    AnswerTableViewCell else {
                                            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
                                                }
        let cellData = answers[indexPath.row]
        cell.setAnswer(answer: cellData)
        return cell
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) ->
        [UITableViewRowAction]? {

        let delete = UITableViewRowAction(style: .destructive,
                                          title: NSLocalizedString("Delete",
                                                                comment: "Swipe title button")) { (action, indexPath) in
            guard let answerId = self.answers[indexPath.row].id else { return }
            DataManager.shared.deleteEntity(byId: answerId, typeEntity: .answer)  { (result, errorMessage) in
                if let errorMessage = errorMessage {
                    self.showMessage(message: errorMessage.message)
                } else {
                    self.answers.remove(at: indexPath.row)
                }
                self.tableView.reloadData()
            }
        }
        let update = UITableViewRowAction(style: .normal,
                                          title: NSLocalizedString("Update",
                                                                comment: "Swipe title button")) { (action, indexPath) in
            guard let addNewAnswerViewController = UIStoryboard(name: "Subjects",
                                                                bundle: nil).instantiateViewController(withIdentifier: "AddNewAnswerViewController") as?
                                                                AddNewAnswerViewController else { return }
            addNewAnswerViewController.questionId = self.answers[indexPath.row].questionId
            addNewAnswerViewController.updateDates = true
            addNewAnswerViewController.answer = self.answers[indexPath.row]
            addNewAnswerViewController.resultModification = { answerResult in
                self.answers[indexPath.row] = answerResult
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(addNewAnswerViewController, animated: true)
        }
        update.backgroundColor = UIColor.blue
        return [delete, update]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let answerAttachmentViewController = UIStoryboard(name: "Subjects",
                                                                bundle: nil).instantiateViewController(withIdentifier: "AnswerAttachmentViewController") as?
                                                                AnswerAttachmentViewController else { return }
        answerAttachmentViewController.answerId = answers[indexPath.row].id
        self.navigationController?.pushViewController(answerAttachmentViewController, animated: true)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        animatedCell(for: cell)
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let message = answers[indexPath.row].answerText
        showMessage(message: message, title: "Detail")
    }
}
