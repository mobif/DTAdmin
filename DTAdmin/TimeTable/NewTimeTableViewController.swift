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

class NewTimeTableViewController: UIViewController, PickerDelegate, TimePickerDelegate {

    @IBOutlet weak var groupPickedTextField: PickedTextField!
    @IBOutlet weak var subjectsPickedTextField: PickedTextField!
    @IBOutlet weak var startTimePicker: TimePicker!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var endTimePicker: TimePicker!
    
    var newTimeTable = TimeTable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New Time Table"
        self.saveButton.setTitle("Save", for: .normal)
        self.groupPickedTextField.tag = DataPickerType.Group.rawValue
        self.groupPickedTextField.customDelegate = self
        self.subjectsPickedTextField.tag = DataPickerType.Subject.rawValue
        self.subjectsPickedTextField.customDelegate = self
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

