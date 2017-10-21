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
  
  var adminInstance: UserModel.Admins?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if adminInstance != nil {
      prepareView(isEdit: true)
      let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.update))
      self.navigationItem.rightBarButtonItems = [saveButton]
    } else {
      self.title = NSLocalizedString("New", comment: "Title for new admin creation view")
      let addButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.create))
      self.navigationItem.rightBarButtonItems = [addButton]
    }
  }
  
  func prepareView(isEdit: Bool) {
    if isEdit {
      userNameTextField.text = adminInstance?.username
      userNameTextField.isEnabled = false
      actualPaswordTextField.text = adminInstance?.password
      emailTextField.text = adminInstance?.email
    }
  }
  
  func checkPaswords() -> Bool {
    if actualPaswordTextField.text == confirmTextField.text, isPasswordValid(actualPaswordTextField.text!) {
      print("password OK")
      return true
    } else {
      showAlert(message: NSLocalizedString("Passwords do not match", comment: "Passwords at inputed fields not match"))
    }
    return false
  }
  
  func isPasswordValid(_ password : String) -> Bool {
    let passwordRegEx = "^([a-zA-Z0-9@*#]{8,15})$"
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
    return passwordTest.evaluate(with: password)
  }
  
  func unWrapFields() -> (id: String, username: String, password: String, email: String)? {
    if let username = userNameTextField.text,
      let password = actualPaswordTextField.text,
      let email = emailTextField.text {
      let id = adminInstance?.id ?? "-1"
      return (id, username, password, email)
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
      showAlert(message: NSLocalizedString("Wrong email", comment: "Inputed email has invalid structure"))
    }
    return false
  }
  
  private func showAlert(message: String) {
    let alert = UIAlertController(title: NSLocalizedString("Alert", comment: "Alert title"), message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok button"), style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  @objc private func create() {
    if !(userNameTextField.text?.isEmpty)! {
      if checkPaswords(), checkEmail() {
        guard let params = unWrapFields() else { return }
        NetworkManager().createAdmin(username: params.username, password: params.password, email: params.email)
        self.navigationController?.popViewController(animated: true)
      }
    } else {
      showAlert(message: NSLocalizedString("Wrong username", comment: "Username field has wrong parametr"))
    }
  }
  
  @objc private func update() {
    if checkPaswords(), checkEmail() {
      guard let params = unWrapFields() else { return }
      NetworkManager().updateAdmin(id: params.id, userName: params.username, password: params.password, email: params.email) { (isOk) in
        print("OK")
        self.navigationController?.popViewController(animated: true)
      }
    }
  }
  
}
