//
//  TimePicker.swift
//  DTAdmin
//
//  Created by mac6 on 10/22/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

protocol TimePickerDelegate: class {
    func pickedTime(date: Date, tag: Int)
}

class TimePicker: UITextField {
    
    let timePicker = UIDatePicker()
    weak var timeDelegate: TimePickerDelegate?
    var doneButton: UIBarButtonItem?
    var cancelButton: UIBarButtonItem?
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    let toolBar = UIToolbar()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addRightArrowDown()
        self.tintColor = UIColor.clear
        self.addToolBar(textField: self)
        self.inputView = self.timePicker
        timePicker.datePickerMode = UIDatePickerMode.dateAndTime
        timePicker.backgroundColor = UIColor.white
        timePicker.addTarget(self, action: #selector(self.startTimeDiveChanged), for: UIControlEvents.valueChanged)
    }

    @objc func startTimeDiveChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        self.text = formatter.string(from: sender.date)
        self.timeDelegate?.pickedTime(date: sender.date, tag: self.tag)
    }
    
    func addToolBar(textField: UITextField){
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        self.doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(PickedTextField.donePressed))
        self.cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(PickedTextField.cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton!, spaceButton, doneButton!], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
    }
 
    @objc func donePressed(){
        self.endEditing(false)
    }
    @objc func cancelPressed(){
        self.endEditing(false)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
