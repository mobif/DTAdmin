//
//  PreviewViewController.swift
//  DTAdmin
//
//  Created by ITA student on 11/4/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit
import MessageUI

class PreviewViewController: UIViewController {
  
  @IBOutlet weak var webPreview: UIWebView!
  
  var pdfComposer: PDFComposer!
  var HTMLContent: String!
//  should replase params below
  var quizParameters: [String: [String: String]]!// {
//    didSet {
//
//    }
//  }
//  var quizParameters: [String: [String: String]] =
//    ["Subject": ["id":"1", "name": "Вища математика"],
//     "Group": ["id": "1", "name": "CI-12-1"],
//     "Quiz": ["id": "1", "name": "Фатальний"]]
  
  var studentsResult = [ResultStructure]()
  var maxQuizMark = 0
  var markMultiplier = 1.0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
//    self.createReportAsHTML(subjectName: self.subject["name"]!, quizName: self.quiz["name"]!, groupName: self.group["name"]!, maxMark: "100", students: self.studentsResult)
    DataManager.shared.getResultTestIds(byGroup: "1") { (error, testIds) in
      
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Get sudents test passed by group
    DataManager.shared.getResultsBy(group: self.quizParameters["Group"]!, subject: self.quizParameters["Subject"]!, test: self.quizParameters["Quiz"]!, maxMark: "100") { (error, studentsResult) in
      if let error = error {
        self.showWarningMsg(error)
      } else {
        print(studentsResult)
        self.studentsResult = studentsResult!
        
        //        DispatchQueue.main.sync {
        //          self.createReportAsHTML(subjectName: self.subject["name"]!, quizName: self.quiz["name"]!, groupName: self.group["name"]!, maxMark: "100", students: self.studentsResult)
        //        }
        
      }
      print("MAXMARK",self.maxQuizMark)
    }
    
    //getting quiz details for counting correct marks
    DataManager.shared.getTestDetails(byTest: self.quizParameters["Quiz"]!["id"]!, completionHandler: { (error, testDetail) in
      guard let testDetail = testDetail else { return }
      for i in testDetail {
        guard let rate = Int(i.rate), let tasks = Int(i.tasks) else { return }
        let mark = rate * tasks
        self.maxQuizMark += mark
      }
      self.markMultiplier = 100.0 / Double(self.maxQuizMark)
      
      print("MAXMARK",self.maxQuizMark)
      print("marMultiplier", 100.0 / Double(self.maxQuizMark))
    })
    
    // adding students full name to results by theirs' id
    DataManager.shared.getStudents(forGroup: self.quizParameters["Group"]!["id"]!, withoutImages: true) { (students, error) in
      if let error = error {
        print(error)
      } else {
        guard let students = students else { return }
        //FIXME: Replace this shit if possible
        for i in 0..<self.studentsResult.count {
          for j in students {
            if j.userId == self.studentsResult[i].studentId { self.studentsResult[i].studentName = ("\(j.studentSurname) \(j.studentName) \(j.studentFname)") }
          }
        }
      }
      print(self.studentsResult)
      
      self.createReportAsHTML(subjectName: self.quizParameters["Subject"]!["name"]!, quizName: self.quizParameters["Quiz"]!["name"]!, groupName: self.quizParameters["Group"]!["name"]!, maxMark: "100", students: self.studentsResult)
    }
  }
  
  func createReportAsHTML(subjectName: String, quizName: String, groupName: String,  maxMark: String, students: [ResultStructure]) {
    pdfComposer = PDFComposer()
    // ask about code formating
    if let reportHTML = pdfComposer.renderReport(subjectName: subjectName,
                                                 quizName: quizName,
                                                 groupName: groupName,
                                                 maxMark: maxMark,
                                                 markECTSMultiplier: self.markMultiplier,
                                                 resulsts: students) {
      webPreview.loadHTMLString(reportHTML, baseURL: NSURL(string: pdfComposer.pathToReportFormHTMLTemplate!)! as URL)
      HTMLContent = reportHTML
    }
  }
  
  @IBAction func printToPDFButton(_ sender: Any) {
    pdfComposer.exportHTMLContentToPDF(HTMLContent: HTMLContent)
    showOptionsAlert()
  }
  
  func showOptionsAlert() {
    let alertController =
      UIAlertController(title: NSLocalizedString("Yeah!",                                            comment: "Print alert title"), message: NSLocalizedString("Your Repory has been successfully printed to a PDF file.\n What do you want to do now?", comment: "Alert body notify that pdf has been printed and ask for next steps to do -> Priview or Send via Email or do nothing"), preferredStyle: UIAlertControllerStyle.alert)
    
    let actionPreview = UIAlertAction(title: "Preview it", style: UIAlertActionStyle.default) { (action) in
      if let filename = self.pdfComposer.fileName, let url = URL(string: filename) {
        let request = URLRequest(url: url)
        self.webPreview.loadRequest(request)
      }
    }
    
    let actionEmail = UIAlertAction(title: "Send via Email", style: UIAlertActionStyle.default) { (action) in
      DispatchQueue.main.async {
        self.sendEmail()
      }
    }
    
    let actionNothing = UIAlertAction(title: "Nothing", style: UIAlertActionStyle.default) { (action) in
    }
    
    alertController.addAction(actionPreview)
    alertController.addAction(actionEmail)
    alertController.addAction(actionNothing)
    present(alertController, animated: true, completion: nil)
  }
  
  func sendEmail() {
    if MFMailComposeViewController.canSendMail() {
      let mailComposeViewController = MFMailComposeViewController()
      guard let quizParameters = self.quizParameters["quiz"] else { return }
      mailComposeViewController.setSubject("Відомість з тесту \(quizParameters["name"])")
      mailComposeViewController.addAttachmentData(NSData(contentsOfFile: pdfComposer.fileName)! as Data, mimeType: "application/pdf", fileName: "Report")
      present(mailComposeViewController, animated: true, completion: nil)
    }
  }
  
}

