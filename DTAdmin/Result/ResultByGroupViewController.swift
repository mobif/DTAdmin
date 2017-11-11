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
  
  var group: GroupStructure? //{
  //    didSet {
  //      guard let group = self.group, let groupId = self.group?.groupId else {
  //        showWarningMsg("Wrong group structure")
  //        return
  //      }
  //      DataManager.shared.getResultTestIds(byGroup: groupId) { (error, testIds) in
  //        if let error = error {
  //          print(error)
  //        } else {
  //          print(testIds)
  //        }
  //      }
  //    }
  //  }
  //var subject: SubjectStructure?
  var tests: [TestStructure]?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    var testsIds = [String]()
    var subjectsIds = [String]()
    DataManager.shared.getResultTestIds(byGroup: group!.groupId!) { (error, testIds) in
      
      if let error = error {
        print(error)
      } else {
        print(testIds)
        //        print(testIds?.first!["test_id"])
        guard let testIds = testIds else { return}
        
        for i in testIds {
          testsIds.append(i["test_id"]!)
          //          subjectsIds.append(i["subject_id"]!)
        }
        
        DataManager.shared.getTestsBy(ids: testsIds, completionHandler: { (error, tests) in
          if let error = error {
            print(error)
          } else {
            print(tests)
            self.tests = tests
            for i in tests! {
              //              testsIds.append(i["test_id"]!)
              subjectsIds.append(i.subjectId)
            }
            //            DispatchQueue.main.sync {
            //              self.setUpView()
            //              self.resultsTableView.reloadData()
            //            }
          }
          
          DataManager.shared.getSubjectsBy(ids: subjectsIds, completionHandler: { (error, subjects) in
            for i in 0..<self.tests!.count {
              var testSubj = subjects?.filter({ $0.id == self.tests![i].subjectId })
              self.tests![i].subjectName = testSubj?.first?.name
              DispatchQueue.main.sync {
                self.setUpView()
                self.resultsTableView.reloadData()
              }
            }
          })
          
        })
        
        
        
      }
      
    }
  }
  
  private func setUpView() {
    self.title = NSLocalizedString("Results by group", comment: "Title for results table list view")
    
  }
  
}

extension ResultByGroupViewController: UITableViewDelegate {
  
}

extension ResultByGroupViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tests != nil ? tests!.count : 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "reusableResultCell") as? ResultsTableTestViewCell else {
      let cell = UITableViewCell()
      cell.textLabel?.text = "This group haven't passed tests yet!"
      return cell
    }
    cell.testIdLabel.text = tests?[indexPath.row].id
    cell.testNameLabel.text = tests?[indexPath.row].name
    cell.testSubjectNameLabel.text = tests?[indexPath.row].subjectName
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let previewViewController = UIStoryboard(name: "PDFPrinter", bundle: nil).instantiateViewController(withIdentifier: "PrintReportByGroupTest") as? PreviewViewController else  { return }
    
    guard let test = tests?[indexPath.row] else {
      return
    }
    previewViewController.title = NSLocalizedString("Printer", comment: "")
    var quizParameters: [String: [String: String]] =
      ["Subject": ["id": test.subjectId, "name": test.subjectName!],
       "Group": ["id": "1", "name": "CI-12-1"],
       "Quiz": ["id": test.id!, "name": test.name]]
    previewViewController.quizParameters = quizParameters
    
    self.navigationController?.pushViewController(previewViewController, animated: true)
  }
 
  
}
