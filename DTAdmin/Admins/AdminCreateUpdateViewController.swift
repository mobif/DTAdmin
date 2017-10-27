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
  
  var adminInstance: UserModel.Admins? {
    didSet {
      self.view.layoutIfNeeded()
      userNameTextField.text = adminInstance?.username
      userNameTextField.isEnabled = false
      //actualPaswordTextField.text = adminInstance?.password
      emailTextField.text = adminInstance?.email
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
    if let userName = userNameTextField.text {
      if checkPaswords(), checkEmail() {
        guard let params = unWrapFields() else { return }
        NetworkManager().createAdmin(username: userName, password: params.password, email: params.email, completionHandler: {( newAdmin, adminId, error) in
          //          FIXME: Handle response
          print(newAdmin, adminId, error)
          if let newAdmin = newAdmin, let adminId = adminId {
            //            var dict = newAdmin.dictionaryRepresentation
            //            dict["id"] = adminId
            //            var adm = UserModel.Admins.init(json: dict)
            //            print(adm)
            NetworkManager().getRecord(by: adminId, completionHandler: { (adm, response, err) in
//              DispatchQueue.main.sync {
                if let adm = adm{
                  print(adm)
                  self.saveAction!(adm)
                }
//              }
            })
          }
        })
        self.navigationController?.popViewController(animated: true)
      }
    } else {
      showAlert(message: NSLocalizedString("Wrong username", comment: "Username field has wrong parametr"))
    }
  }
  
  @objc private func update() {
    if checkPaswords(), checkEmail() {
      guard let params = unWrapFields() else { return }
      NetworkManager().editAdmin(id: (adminInstance?.id)!, userName: params.username, password: params.password, email: params.email) { (isOk, admin, error) in
        //          FIXME: Handle response
        print(isOk, admin, error)
        //self.saveAction!(admin)
        self.navigationController?.popViewController(animated: true)
      }
    }
  }
  
}
