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
  
  var admin: UserModel.Admins? {
    didSet {
      self.view.layoutIfNeeded()
      userNameTextField.text = admin?.username
      userNameTextField.isEnabled = false
      //actualPaswordTextField.text = adminInstance?.password
      emailTextField.text = admin?.email
      self.title = NSLocalizedString("Edit", comment: "Title for admin editing view")
      let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.update))
      self.navigationItem.rightBarButtonItems = [saveButton]
    }
  }
  
  var saveAction: ((UserModel.Admins?) -> ())?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    prepareCreationView()
    
  }
  
  private func prepareCreationView() {
    self.title = NSLocalizedString("New", comment: "Title for new admin creation view")
    let addButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.create))
    self.navigationItem.rightBarButtonItems = [addButton]
  }
  
  func checkPaswords() -> Bool {
    let passwordRegEx = "^([a-zA-Z0-9@*#]{8,15})$"
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
    if actualPaswordTextField.text == confirmTextField.text,
      passwordTest.evaluate(with: actualPaswordTextField.text!) {
      print("password OK")
      return true
    } else {
      showAlert(message: NSLocalizedString("Passwords do not match", comment: "Passwords at inputed fields not match"))
    }
    return false
  }
  
  func unWrapFields() -> (username: String, password: String, email: String)? {
    if let username = userNameTextField.text,
      let password = actualPaswordTextField.text,
      let email = emailTextField.text {
      return (username, password, email)
    }
    return nil
  }
  
  func checkEmail() -> Bool {
    let emailRegEx = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    guard let email = emailTextField.text else {
      assertionFailure("[AdminCreateUpdateVC] Wrong text at emailTextField")
      return false
    }
    if emailTest.evaluate(with: email) {
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
    guard let userName = userNameTextField.text, checkPaswords(), checkEmail(), let params = unWrapFields() else {
        showAlert(message: NSLocalizedString("Wrong username or ema", comment: "Username field has wrong parameter"))
        return
      }
        NetworkManager().createAdmin(username: userName, password: params.password, email: params.email, completionHandler: {(admin, error) in
          //          FIXME: Handle response
          if let error = error {
            self.showAlert(message: NSLocalizedString(error.localizedDescription, comment: "Admin create request failed with error"))
            return
          }
          guard let admin = admin else { return }
          self.saveAction!(admin)
          self.navigationController?.popViewController(animated: true)
        })
  }
  
  @objc private func update() {
    guard checkPaswords(), checkEmail(), let params = unWrapFields(), let id = admin?.id else { return }
      NetworkManager().editAdmin(id: id, userName: params.username, password: params.password, email: params.email) { (admin, error) in
        //          FIXME: Handle response
//        print(admin, error)
        
        self.navigationController?.popViewController(animated: true)
      }
    }
  
  
}
