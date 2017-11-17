//
//  PDFComposer.swift
//  DTAdmin
//
//  Created by Yurii Krupa on 11/4/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class PDFComposer: NSObject {
    
    let pathToReportFormHTMLTemplate = Bundle.main.path(forResource: "reportForm", ofType: "html")
    let pathToReportFromStudentRowHTMLTemplate = Bundle.main.path(forResource: "reportFormStudentRow", ofType: "html")
    
    var subjectName = String()
    var quizName = String()
    var groupName = String()
    var maxMark = String()
    
    var fileName = String()
    
    override init() {
        super.init()
        
        self.fileName = "Quiz_\(self.quizName)_\(self.subjectName)_\(self.groupName)_\(Date())"
    }
    
    func renderReport(subjectName: String, quizName: String, groupName: String, maxMark: String = "100", markECTSMultiplier: Double, resulsts: [TestResults]) -> String! {
        
        self.subjectName = subjectName
        self.quizName = quizName
        self.groupName = groupName
        self.maxMark = maxMark
        
        do {
            // Load the Report HTML template code into a String variable.
            var HTMLContent = try String(contentsOfFile: pathToReportFormHTMLTemplate!)
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#SUBJECT_NAME#", with: subjectName)
            HTMLContent = HTMLContent.replacingOccurrences(of: "#QUIZ_NAME#", with: quizName)
            HTMLContent = HTMLContent.replacingOccurrences(of: "#GROUP_NAME#", with: groupName)
            HTMLContent = HTMLContent.replacingOccurrences(of: "#MAX_MARK#", with: maxMark)
            
            var allStudents = String()
            
            var number = UInt()
            for i in resulsts {
                number += 1
                guard let result = Double(i.result) else { return nil }
                let mark = result * markECTSMultiplier
                
                var studentHTMLContent = try String(contentsOfFile: pathToReportFromStudentRowHTMLTemplate!)
                
                studentHTMLContent = studentHTMLContent.replacingOccurrences(of: "#NUMBER#", with: "\(number)")
                studentHTMLContent = studentHTMLContent.replacingOccurrences(of: "#STUDENT_NAME#", with: i.studentName ?? "No Name" )
                studentHTMLContent = studentHTMLContent.replacingOccurrences(of: "#RESULT#", with: "\(result)")
                studentHTMLContent = studentHTMLContent.replacingOccurrences(of: "#MARK#", with: "\(mark)")
                studentHTMLContent = studentHTMLContent.replacingOccurrences(of: "#MARK_ECTS#", with: getECTSMark(mark: Int(mark)))
                
                allStudents += studentHTMLContent
            }
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#STUDENTS#", with: allStudents)
            
            return HTMLContent
            
        }
        catch {
            assertionFailure("Unable to open and use HTML template files")
            print("Unable to open and use HTML template files", Error.self)
        }
        return nil
    }
    
    func exportHTMLContentToPDF(HTMLContent: String) {
        let printPageRenderer = PrintPageRenderer()
        
        let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        
        let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer: printPageRenderer)
        
        fileName = "\(AppDelegate.getAppDelegate().getDocDir())/Quiz_\(self.quizName)_\(self.subjectName)_\(self.groupName)_\(Date().dateString).pdf"
        pdfData?.write(toFile: fileName, atomically: true)
        
        print("\nPath to pdf file in File System\n",fileName)
    }
    
    
    func drawPDFUsingPrintPageRenderer(printPageRenderer: UIPrintPageRenderer) -> NSData! {
        let data = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
        UIGraphicsBeginPDFPage()
        printPageRenderer.drawPage(at: 0, in: UIGraphicsGetPDFContextBounds())
        UIGraphicsEndPDFContext()
        
        return data
    }
    
    func getECTSMark(mark: Int) -> String {
        switch mark {
        case 90...100: return "A"
        case 82...89: return "B"
        case 75...81: return "C"
        case 67...80: return "D"
        case 60...66: return "E"
        case 35...59: return "FX"
        default: return "F"
        }
    }
    
}
