//
//  QuestionsTableViewController.swift
//  DTAdmin
//
//  Created by ITA student on 11/7/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class QuestionsTableViewController: UITableViewController {
    
    @IBOutlet weak var searchFooter: SearchFooter!

    var questions = [QuestionStructure]()
    var testId: String?
    var filteredData = [QuestionStructure]()
    var refresh: MyRefreshController!
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("Question", comment: "Title for QuestionsTableViewController")

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true

        searchController.searchBar.scopeButtonTitles = ["Question", "Level"]
        searchController.searchBar.delegate = self

        tableView.tableFooterView = searchFooter

        refresh = MyRefreshController()
        tableView.addSubview(refresh)
        refresh.addTarget(self, action: #selector(getCountOfQuestion), for: .valueChanged)

        getCountOfQuestion()

    }
    
    @objc func getCountOfQuestion() {
        startActivityIndicator()
        DataManager.shared.getCountItems(forEntity: .question) { count, errorMessage in
            if let errorMessage = errorMessage {
                self.stopActivityIndicator()
                self.refresh.endRefreshing()
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
            self.refresh.endRefreshing()
            self.stopActivityIndicator()
            if errorMessage == nil,
                let questions = questions {
                self.questions = questions
                self.questions.sort { return $0.type < $1.type}
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

    // MARK: - Private instance methods
    func filterContentForSearchText(_ searchText: String, scope: String) {
        filteredData = questions.filter({ (question : QuestionStructure) -> Bool in
            if scope == "Question" {
                return question.questionText.lowercased().contains(searchText.lowercased())
            } else {
                return question.level.lowercased().contains(searchText.lowercased())
            }
        })
        tableView.reloadData()
    }

    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredData.count, of: questions.count)
            return filteredData.count
        }

        searchFooter.setNotFiltering()
        return questions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as!
            QuestionTableViewCell
        let cellData = isFiltering() ? filteredData[indexPath.row] : questions[indexPath.row]
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

extension QuestionsTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

extension QuestionsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
