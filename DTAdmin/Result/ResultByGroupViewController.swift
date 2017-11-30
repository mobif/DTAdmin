//
//  ResultByGroupViewController.swift
//  DTAdmin
//
//  Created by Yurii Krupa on 11/8/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class ResultByGroupViewController: ParentViewController {
    
    @IBOutlet weak var resultsTableView: UITableView!
    
    let badApiResponseWarning = NSLocalizedString("Wrong server response, please make refresh to update data",
                                                  comment:"Message says that server return wrong data")
    
    var group: GroupStructure? {
        didSet {
            guard let group = self.group else {
                self.showWarningMsg(badApiResponseWarning)
                return
            }
            self.prepareView(group: group)
        }
    }
    
    var tests: [TestStructure]?
    lazy var refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(loadDataFromAPI), for: .valueChanged)
        resultsTableView.refreshControl = refreshControl
    }
    
    private func prepareView(group: GroupStructure) {
        self.startActivity()
        self.title = NSLocalizedString("Results by \(group.groupName)", comment: "Title for results table list view")
        self.refreshControl.beginRefreshing()
        self.loadDataFromAPI()
    }
    
    @objc private func loadDataFromAPI() {
        guard let groupId = self.group?.groupId else { return }
        var testsIds = [String]()
        var subjectsIds = [String]()
        
        DataManager.shared.getTestsResultIds(byGroup: groupId) { (testIds, error) in
            if let error = error {
                self.stopActivity()
                self.showWarningMsg(error.message)
                return
            } else {
                guard let testIds = testIds else {
                    self.stopActivity()
                    self.showWarningMsg(self.badApiResponseWarning)
                    return
                }
                for i in testIds {
                    if let testId = i["test_id"] {
                        testsIds.append(testId)
                    }
                }
                
                DataManager.shared.getTestsBy(ids: testsIds, completionHandler: { (tests, error) in
                    if let error = error {
                        self.stopActivity()
                        self.showWarningMsg(error.message)
                    } else {
                        guard var tests = tests else {
                            self.stopActivity()
                            self.showWarningMsg(self.badApiResponseWarning)
                            return
                        }
                        self.tests = tests
                        for i in tests {
                            subjectsIds.append(i.subjectId)
                        }
                        
                        DataManager.shared.getSubjectsBy(ids: subjectsIds, completionHandler: { (subjects, error) in
                            for i in 0..<tests.count {
                                let testSubj = subjects?.filter({ $0.id == tests[i].subjectId })
                                tests[i].subjectName = testSubj?.first?.name
                            }
                            self.tests = tests
                            self.resultsTableView.reloadData()
                            self.refreshControl.endRefreshing()
                            self.stopActivity()
                        })
                        
                    }
                })
                
            }
        }
    }
    
}

extension ResultByGroupViewController: UITableViewDelegate {
}

extension ResultByGroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tests = self.tests {
            return tests.count
        } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reusableResultCell") as? ResultsTableTestViewCell else {
            let cell = UITableViewCell() as! ResultsTableTestViewCell
            cell.testNameLabel?.text = "This group haven't passed tests yet!"
            return cell
        }
        cell.testIdLabel.text = tests?[indexPath.row].id
        cell.testNameLabel.text = tests?[indexPath.row].name
        cell.testSubjectNameLabel.text = tests?[indexPath.row].subjectName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "PDFPrinter", bundle: nil)
        guard let previewViewController = storyboard.instantiateViewController(withIdentifier: "PrintReportByGroupTest")
            as? PreviewViewController else { return }
        guard let test = self.tests?[indexPath.row], let group = self.group else {
            return
        }
        previewViewController.title = NSLocalizedString("Printer", comment: "")
        let quizParameters: [String: [String: String]] =
            ["Subject": ["id": test.subjectId, "name": test.subjectName!],
             "Group": ["id": group.groupId!, "name": group.groupName],
             "Quiz": ["id": test.id!, "name": test.name]]
        previewViewController.quizParameters = quizParameters
        
        self.navigationController?.pushViewController(previewViewController, animated: true)
    }
    
}
