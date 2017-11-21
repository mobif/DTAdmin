//
//  PickedTextField.swift
//  DTAdmin
//
//  Created by mac6 on 10/22/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

protocol PickerDelegate: class {
    func pickedValue(value: Any, tag: Int)
}

class PickedTextField: UITextField, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var dropDownData = [Any]()
    let picker = UIPickerView()
    weak var customDelegate: PickerDelegate?
    var selectedRow: Int?
    var doneButton: UIBarButtonItem?
    var cancelButton: UIBarButtonItem?
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    let toolBar = UIToolbar()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.addRightArrowDown()
        self.tintColor = UIColor.clear
        self.picker.delegate = self
        self.addToolBar(textField: self)
        self.inputView = self.picker
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @objc func donePressed(){
        self.customDelegate?.pickedValue(value: self.dropDownData[self.selectedRow ?? 0], tag: self.tag)
        self.endEditing(false)
    }
    @objc func cancelPressed(){
        self.endEditing(false)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dropDownData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return  self.getTitleFromAny(value: self.dropDownData[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedRow = row
    }
    
    func getTitleFromAny(value: Any) -> String {
        if value is Int {
            return String(value as! Int)
        } else if value is String {
            return value as! String
        } else if value is Dictionary<String, String> {
            let dict = value as! Dictionary<String, String>
            return dict["title"]!
        } else {
            return ""
        }
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

extension UITextField {
    func addRightArrowDown() {
        self.rightViewMode = .always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = UIImage(named: "arrowDrop")
        self.rightView = imageView
    }
}
