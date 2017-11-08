//
//  QuestionsTableViewController.swift
//  DTAdmin
//
//  Created by ITA student on 11/7/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class QuestionsTableViewController: UITableViewController, UISearchBarDelegate {
    
    var questions = [QuestionStructure]()
    var testId: String?
    var countOfQuestions: UInt = 100
    var refresherForQuestion: UIRefreshControl!
    var filteredData = [QuestionStructure]()
    var inSearchMode = false
    
    @IBOutlet weak var searchOfQuestion: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Questions"
        refresherForQuestion = UIRefreshControl()
        tableView.addSubview(refresherForQuestion)
        refresherForQuestion.attributedTitle = NSAttributedString (string: "Pull to refresh")
        refresherForQuestion.tintColor = UIColor(red: 1.0, green: 0.21, blue: 0.55, alpha: 0.5)
        refresherForQuestion.addTarget(self, action: #selector(getCountOfQuestion), for: .valueChanged)
        searchOfQuestion.showsScopeBar = true
        searchOfQuestion.scopeButtonTitles = ["Question", "Level", "Type"]
        searchOfQuestion.selectedScopeButtonIndex = 0
        getCountOfQuestion()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func getCountOfQuestion() {
        DataManager.shared.getCountItems(forEntity: .question) { count, error in
            if let error = error {
                self.showMessage(message: error)
            } else {
                if let countOfQuestions = count {
                    print(countOfQuestions)
                    guard let id = self.testId else { return }
                    self.showQuestions(id: id, quantity: countOfQuestions)
                }
            }
        }
        self.refresherForQuestion.endRefreshing()
    }
    
    func showQuestions(id: String, quantity: UInt) {
        DataManager.shared.getListRange(forEntity: .question, fromNo: 0, quantity: quantity) {(questions, error) in
            if error == nil,
                let questions = questions as? [QuestionStructure] {
                self.questions = questions
                self.tableView.reloadData()
            } else {
                self.showMessage(message: error ?? "Incorect type data")
            }
        }
    }
    
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
                filteredData = questions.filter{$0.type.contains(searchText)}
            case 2:
                filteredData = questions.filter{$0.level.contains(searchText)}
            default:
                print("No match")
            }
            tableView.reloadData()
        }
    }
    
    @IBAction func addQuestion(_ sender: UIBarButtonItem) {
        guard let wayToAddNewQuestion = UIStoryboard(name: "Subjects", bundle: nil).instantiateViewController(withIdentifier: "AddNewQuestion") as? AddNewQuestionViewController
            else { return }
        wayToAddNewQuestion.testId = testId!
        wayToAddNewQuestion.resultModification = { questionReturn in
            self.questions.append(questionReturn)
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(wayToAddNewQuestion, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredData.count : questions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath)
        let cellData = inSearchMode ? filteredData[indexPath.row] : questions[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row + 1). " + cellData.questionText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            guard let questionId = self.questions[indexPath.row].id else { return }
            DataManager.shared.deleteEntity(byId: questionId, typeEntity: .question)  { (result, error) in
                if let error = error {
                    self.showMessage(message: NSLocalizedString(error, comment: "Message for user") )
                } else {
                    self.questions.remove(at: indexPath.row)
                }
                self.tableView.reloadData()
            }
        }
        let update = UITableViewRowAction(style: .normal, title: "Update") { (action, indexPath) in
            guard let wayToAddNewQuestion = UIStoryboard(name: "Subjects", bundle: nil).instantiateViewController(withIdentifier: "AddNewQuestion") as? AddNewQuestionViewController else { return }
            guard let questionId = self.questions[indexPath.row].id else { return }
            wayToAddNewQuestion.questionId = questionId
            wayToAddNewQuestion.testId = self.questions[indexPath.row].testId
            wayToAddNewQuestion.updateDates = true
            wayToAddNewQuestion.question = self.questions[indexPath.row]
            wayToAddNewQuestion.resultModification = { questionResult in
                self.questions[indexPath.row] = questionResult
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(wayToAddNewQuestion, animated: true)
        }
        update.backgroundColor = UIColor.blue
        return [delete, update]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let wayToShowQuestionInfo = UIStoryboard(name: "Subjects", bundle: nil).instantiateViewController(withIdentifier: "QuestionInfo") as? QuestionInfoViewController
            else { return }
        wayToShowQuestionInfo.question = self.questions[indexPath.row]
        self.navigationController?.pushViewController(wayToShowQuestionInfo, animated: true)
    }
    
}
