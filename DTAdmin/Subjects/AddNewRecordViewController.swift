//
//  AddNewRecordViewController.swift
//  DTAdmin
//
//  Created by ITA student on 10/18/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class AddNewRecordViewController: UIViewController {

    @IBOutlet weak var subjectName: UITextField!
    
    @IBOutlet weak var subjectDescription: UITextView!
    
    var updateDates = false
    var subjectId: String = ""
    var name: String = ""
    var desc: String = ""
    private var httpStatusCode: Int? = nil
    let queryService = QueryService()
    
    private func showMessage(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveNewRecord(_ sender: UIButton) {
        guard let name = subjectName.text?.capitalized else { return }
        guard let description = subjectDescription.text?.capitalized else { return }
        
        if !name.isEmpty && !description.isEmpty {
            if !updateDates {
                queryService.postRequests(parameters : ["subject_name" : name, "subject_description" : description], sufix : "subject/InsertData", completion: {(results:Int?) in
                    if let code = results {
                        self.httpStatusCode = code
                        DispatchQueue.main.async {
                            if self.httpStatusCode == 200 {
                                let _ = self.navigationController?.popViewController(animated: true)
                                
                            } else {
                                self.showMessage(message: "You cann't to save data!")
                                
                            }
                            
                        }
                    }
                })
            } else {
                queryService.postRequests(parameters : ["subject_name" : name, "subject_description" : description], sufix : "subject/update/\(subjectId)", completion: {(results:Int?) in
                    if let code = results {
                        self.httpStatusCode = code
                        DispatchQueue.main.async {
                            if self.httpStatusCode == 200 {
                                let _ = self.navigationController?.popViewController(animated: true)
                            } else {
                                self.showMessage(message: "You cann't to save data!")
                            }
                        }
                    }
                })
                
            }
        } else {
            showMessage(message: "Enter all fields!")
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !updateDates {
            navigationItem.title = "Add new item"
        } else {
            navigationItem.title = "Update record"
            subjectName.text = name
            subjectDescription.text = desc
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
