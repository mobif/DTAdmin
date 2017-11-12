//
//  PreviewViewController.swift
//  DTAdmin
//
//  Created by Yurii Krupa on 11/4/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit
import MessageUI

class PreviewViewController: UIViewController {
  
  @IBOutlet weak var webPreview: UIWebView!
  
  var pdfComposer = PDFComposer()
  var HTMLContent = String()
  
  var quizParameters = [String: [String: String]]()
  var studentsResult = [ResultStructure]()
  var maxQuizMark = Int()
  var markMultiplier = 1.0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    let shareButton = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(self.share))
    self.navigationItem.rightBarButtonItems = [shareButton]
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    //Unwrap all nessesary data
    guard let group = self.quizParameters["Group"],
      let groupId = group["id"],
      let subject = self.quizParameters["Subject"],
      let test = self.quizParameters["Quiz"],
      let testId = test["id"] else {
        self.showWarningMsg("Quiz has wrong parameters please try again")
        return
    }
    // Get sudents test passed by group
    DataManager.shared.getResultsBy(group: group, subject: subject, test: test, maxMark: "100") { (error, studentsResult) in
      if let error = error {
        self.showWarningMsg(error)
      } else {
        guard let studentsResult = studentsResult else { return }
        self.studentsResult = studentsResult
      }
    }
    
    //getting quiz details for counting correct marks
    DataManager.shared.getTestDetails(byTest: testId, completionHandler: { (error, testDetail) in
      guard let testDetail = testDetail else { return }
      for i in testDetail {
        guard let rate = Int(i.rate), let tasks = Int(i.tasks) else { return }
        let mark = rate * tasks
        self.maxQuizMark += mark
      }
      self.markMultiplier = 100.0 / Double(self.maxQuizMark)
    })
    
    // adding students full name to results by theirs' id
    DataManager.shared.getStudents(forGroup: groupId, withoutImages: true) { (students, error) in
      if let error = error {
        self.showWarningMsg(error)
      } else {
        guard let students = students else { return }
        //FIXME: Replace this shit if possible
        for i in 0..<self.studentsResult.count {
          for j in students {
            if j.userId == self.studentsResult[i].studentId {
              self.studentsResult[i].studentName =
                ("\(j.studentSurname) \(j.studentName) \(j.studentFname)") }
          }
        }
      }
      guard let subjectName = self.quizParameters["Subject"]?["name"],
        let quizName = self.quizParameters["Quiz"]?["name"],
        let groupName = self.quizParameters["Group"]?["name"] else {
          self.showWarningMsg("Quiz has wrong parameters please try again")
          return
      }
      self.createReportAsHTML(subjectName: subjectName,
                              quizName: quizName,
                              groupName: groupName,
                              maxMark: "100",
                              students: self.studentsResult)
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
      webPreview.loadHTMLString(reportHTML, baseURL:
        NSURL(string: pdfComposer.pathToReportFormHTMLTemplate!)! as URL)
      HTMLContent = reportHTML
    }
  }
  
  @objc private func share() {
    pdfComposer.exportHTMLContentToPDF(HTMLContent: HTMLContent)
    showOptionsAlert()
  }
  
  func showOptionsAlert() {
    let alertController =
      UIAlertController(title: NSLocalizedString("Yeah!",                                            comment: "Print alert title"), message: NSLocalizedString("Your Report has successfully printed to a PDF file.\n What do you want to do now?", comment: "Alert body notify that pdf has been printed and ask for next steps to do -> Priview or Send via Email or do nothing"), preferredStyle: UIAlertControllerStyle.alert)
    
    let actionPreview = UIAlertAction(title: NSLocalizedString("Preview it", comment: "Preview it UIAlert option"), style: UIAlertActionStyle.default) { (action) in
      if let url = URL(string: self.pdfComposer.fileName) {
        let request = URLRequest(url: url)
        self.webPreview.loadRequest(request)
      }
    }
    
    let actionEmail = UIAlertAction(title: NSLocalizedString("Send via Email", comment: "Send email UIAlert option"), style: UIAlertActionStyle.default) { (action) in
      DispatchQueue.main.async {
        self.sendEmail()
      }
    }
    let actionNothing = UIAlertAction(title: NSLocalizedString("Nothing", comment: "Do nothing UIAlert option"), style: UIAlertActionStyle.cancel) { (action) in
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
      mailComposeViewController.setSubject("Відомість з тесту \(String(describing: quizParameters["name"]))")
      mailComposeViewController.addAttachmentData(NSData(contentsOfFile: pdfComposer.fileName)! as Data, mimeType: "application/pdf", fileName: "Report")
      present(mailComposeViewController, animated: true, completion: nil)
    }
  }
  
}

