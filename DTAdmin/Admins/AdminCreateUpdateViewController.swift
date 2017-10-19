//
//  AdminCreateUpdateViewController.swift
//  DTAdmin
//
//  Created by ITA student on 10/15/17.
//  Copyright © 2017 Yurii Krupa. All rights reserved.
//

import UIKit

class AdminCreateUpdateViewController: UIViewController {
  
  @IBOutlet weak var userNameTextField: UITextField!
  @IBOutlet weak var actualPaswordTextField: UITextField!
  @IBOutlet weak var confirmTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  
  var adminInstanse: UserModel.Admins?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if adminInstanse != nil {
      prepareView(isEdit: true)
      let btnSave = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.update))
      self.navigationItem.rightBarButtonItems = [btnSave]
    } else {
      self.title = "Add"
      let btnAdd = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.create))
      self.navigationItem.rightBarButtonItems = [btnAdd]
    }
  }

  func prepareView(isEdit: Bool) {
    if isEdit {
      userNameTextField.text = adminInstanse?.username
      actualPaswordTextField.text = adminInstanse?.password
      emailTextField.text = adminInstanse?.email
    }
  }
  func checkPaswords() -> Bool{
    if actualPaswordTextField.text == confirmTextField.text, isPasswordValid(actualPaswordTextField.text!) {
        print("password OK")
        return true
      } else {
        let alertView = UIAlertController(title: "ALERT!", message: "Passwords do not match", preferredStyle: UIAlertControllerStyle.alert)
        alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertView, animated: true, completion: nil)
      }
    return false
  }
  func isPasswordValid(_ password : String) -> Bool{
    let passwordRegEx = "^([a-zA-Z0-9@*#]{8,15})$"
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
    return passwordTest.evaluate(with: password)
  }
  func unWrapFields() -> (username: String, password: String, email: String)? {
    if let username = userNameTextField.text,
      let password = actualPaswordTextField.text,
      let email = emailTextField.text {
      return (username, password, email)
    }
    return nil
  }
  func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
  }
  func checkEmail() -> Bool {
    if isValidEmail(testStr: unWrapFields()!.email) {
      print("Email OK")
      return true
    } else {
      let alertView = UIAlertController(title: "ALERT!!", message: "Wrong email", preferredStyle: UIAlertControllerStyle.alert)
      alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
      self.present(alertView, animated: true, completion: nil)
    }
    return false
  }
  
  @objc private func create() {
    if checkPaswords(), checkEmail() {
      guard let params = unWrapFields() else { return }
      NetworkManager().createAdmin(username: params.username, password: params.password, email: params.email)
    }
  }
  @objc private func update() {
    if checkPaswords(), checkEmail() {
      guard let params = unWrapFields() else { return }
      NetworkManager().updateAdmin(id: adminInstanse!.id, userName: params.username, password: params.password, email: params.email) { (isOk) in
        print("OK")
      }
    }
  }
}
