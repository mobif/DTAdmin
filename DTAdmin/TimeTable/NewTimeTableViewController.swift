//
//  NewTimeTableViewController.swift
//  DTAdmin
//
//  Created by mac6 on 10/22/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

enum DataPickerType: Int {
    case Group = 0
    case Subject = 1
}

enum TimeType: Int {
    case Start = 0
    case End = 1
}

class NewTimeTableViewController: ParentViewController, TimePickerDelegate {

    @IBOutlet weak var groupButton: UIButton!
    @IBOutlet weak var subjectsButton: UIButton!
    @IBOutlet weak var startTimePicker: TimePicker!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var endTimePicker: TimePicker!
    
    var newTimeTable = TimeTable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New Time Table"
        self.saveButton.setTitle("Save", for: .normal)
        self.subjectsButton.setTitle("Select Subject", for: .normal)
        self.groupButton.setTitle("Select Group", for: .normal)
        self.startTimePicker.timeDelegate = self
        self.startTimePicker.tag = TimeType.Start.rawValue
        self.endTimePicker.timeDelegate = self
        self.endTimePicker.tag = TimeType.End.rawValue
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        print(self.newTimeTable)
        self.startActivity()
        CommonNetworkManager.shared().createTimeTable(timeTable: self.newTimeTable) { (newTimeTable, error) in
            self.stopActivity()
            if let error = error {
                self.showAllert(title: "Error", message: error.localizedDescription, completionHandler: nil)
            } else if newTimeTable != nil {
                self.showAllert(title: nil, message: "Time Table added successfully!", completionHandler: {
                    self.navigationController?.popViewController(animated: true)
                })
            } else {
                self.showAllert(title: "Error", message: "Error insertion data!", completionHandler: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    @IBAction func subjectButtonClicked(_ sender: Any) {
        let subjectStoryboard = UIStoryboard.stoyboard(by: .subject)
        guard let subjectViewController = subjectStoryboard.instantiateViewController(withIdentifier: "SubjectTableViewController") as? SubjectTableViewController else { return }
        subjectViewController.selectedSubject = { subject in
            self.newTimeTable.subjectID = subject.id
            self.subjectsButton.setTitle(subject.name, for: .normal)
        }
        self.navigationController?.pushViewController(subjectViewController, animated: true)
    }
    
    @IBAction func groupButtonTapped(_ sender: Any) {
    }
    
    //MARK: picker delegate method
    func pickedValue(value: Any, tag: Int) {
        switch tag {
        case DataPickerType.Group.rawValue:
            print("Groups")
        case DataPickerType.Subject.rawValue:
            print("Subjects")
        default:
            print("")
        }
    }
    
    func pickedTime(date: Date, tag: Int) {
        switch tag {
        case TimeType.Start.rawValue:
            self.newTimeTable.startTime = date.timeString
            self.newTimeTable.startDate = date.dateString
        case TimeType.End.rawValue:
            self.newTimeTable.endTime = date.timeString
            self.newTimeTable.endDate = date.dateString
        default:
            print("")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

