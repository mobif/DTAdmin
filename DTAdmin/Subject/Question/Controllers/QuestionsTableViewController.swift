//
//  QuestionsTableViewController.swift
//  DTAdmin
//
//  Created by ITA student on 11/7/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class QuestionsTableViewController: UITableViewController {
    
    var questions = [QuestionStructure]()
    var testId: String?
    var filteredData = [QuestionStructure]()
    var inSearchMode = false

    @IBOutlet weak var searchOfQuestion: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("Question", comment: "Title for QuestionsTableViewController")
        
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(getCountOfQuestion), for: .valueChanged)

        searchOfQuestion.showsScopeBar = true
        searchOfQuestion.scopeButtonTitles = ["Question", "Level", "Type"]
        searchOfQuestion.selectedScopeButtonIndex = 0

        getCountOfQuestion()

    }
    
    @objc func getCountOfQuestion() {
        startActivityIndicator()
        DataManager.shared.getCountItems(forEntity: .question) { count, errorMessage in
            if let errorMessage = errorMessage {
                self.stopActivityIndicator()
                self.refreshControl.endRefreshing()
                self.showMessage(message: errorMessage)
            } else {
                if let countOfQuestions = count {
                    print(countOfQuestions)
                    guard let id = self.testId else { return }
                    self.showQuestions(id: id, quantity: countOfQuestions)
                }
            }
        }
    }
    
    func showQuestions(id: String, quantity: UInt) {
        DataManager.shared.getRecordsRange(byTest: id, limit: String(quantity), offset: "0", withoutImages: true) {
            (questions, errorMessage) in

            self.stopActivityIndicator()
            self.refreshControl.endRefreshing()
            if errorMessage == nil,
                let questions = questions {
                self.questions = questions
                self.tableView.reloadData()
            } else {
                self.showMessage(message: errorMessage ??
                    NSLocalizedString("Incorect type data", comment: "Information for user about incorect data"))
            }
        }
    }
    
    @IBAction func addQuestion(_ sender: UIBarButtonItem) {
        guard let addNewQuestionViewController = UIStoryboard(name: "Subjects",
                                                              bundle: nil).instantiateViewController(withIdentifier:
                                                                "AddNewQuestion") as? AddNewQuestionViewController
            else { return }
        addNewQuestionViewController.testId = testId
        addNewQuestionViewController.resultModification = { questionReturn in
            self.questions.append(questionReturn)
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(addNewQuestionViewController, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredData.count : questions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as!
            QuestionTableViewCell
        let cellData = inSearchMode ? filteredData[indexPath.row] : questions[indexPath.row]
        cell.setQuestion(question: cellData)
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) ->
        [UITableViewRowAction]? {

        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            guard let questionId = self.questions[indexPath.row].id else { return }
            DataManager.shared.deleteEntity(byId: questionId, typeEntity: .question)  { (result, errorMessage) in
                if let errorMessage = errorMessage {
                    self.showMessage(message: errorMessage)
                } else {
                    self.questions.remove(at: indexPath.row)
                }
                self.tableView.reloadData()
            }
        }
        let update = UITableViewRowAction(style: .normal, title: "Update") { (action, indexPath) in
            guard let addNewQuestionViewController = UIStoryboard(name: "Subjects",
                                                                  bundle: nil).instantiateViewController(withIdentifier:
                                                                    "AddNewQuestion") as? AddNewQuestionViewController
                else { return }
            guard let questionId = self.questions[indexPath.row].id else { return }
            addNewQuestionViewController.questionId = questionId
            addNewQuestionViewController.testId = self.questions[indexPath.row].testId
            addNewQuestionViewController.updateDates = true
            addNewQuestionViewController.question = self.questions[indexPath.row]
            addNewQuestionViewController.resultModification = { questionResult in
                self.questions[indexPath.row] = questionResult
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(addNewQuestionViewController, animated: true)
        }
        update.backgroundColor = UIColor.blue
        return [delete, update]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let questionAttachmentViewController = UIStoryboard(name: "Subjects",
                                                                  bundle: nil).instantiateViewController(withIdentifier: "QuestionAttachmentViewController") as?
                                                                    QuestionAttachmentViewController else { return }
        questionAttachmentViewController.questionId = questions[indexPath.row].id
        self.navigationController?.pushViewController(questionAttachmentViewController, animated: true)
    }
    
}

extension QuestionsTableViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            inSearchMode = true
            guard let searchText = searchOfQuestion.text else { return }
            switch searchBar.selectedScopeButtonIndex {
            case 0:
                filteredData = questions.filter{$0.questionText.contains(searchText)}
            case 1:
                filteredData = questions.filter{$0.level.contains(searchText)}
            case 2:
                filteredData = questions.filter{$0.type.contains(searchText)}
            default:
                print("No match")
            }
            tableView.reloadData()
        }
    }
}

extension QuestionsTableViewController: QuestionTableViewCellDelegate {
    
    func didTapShowAnswer(for id: String) {
        guard let answersTableViewController = UIStoryboard(name: "Subjects",
                                                            bundle: nil).instantiateViewController(withIdentifier:
                                                                "Answers") as? AnswersTableViewController
            else { return }
        answersTableViewController.questionId = id
        self.navigationController?.pushViewController(answersTableViewController, animated: true)
    }
}
