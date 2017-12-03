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
    
    var admin: UserStructure? {
        didSet {
            self.view.layoutIfNeeded()
            self.title = NSLocalizedString("Edit", comment: "Title for admin editing view")
            
            userNameTextField.text = admin?.userName
            userNameTextField.isEnabled = false
            emailTextField.text = admin?.email
            
            let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.update))
            self.navigationItem.rightBarButtonItems = [saveButton]
        }
    }
    
    var saveAction: ((UserStructure?) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareCreationView()
        
    }
    
    private func prepareCreationView() {
        self.title = NSLocalizedString("New", comment: "Title for new admin creation view")
        let addButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.create))
        self.navigationItem.rightBarButtonItems = [addButton]
    }
    
    private func unWrapFields() -> (userName: String, password: String, email: String)? {
        if userNameTextField.text != "",
            let userName = userNameTextField?.text,
            let password = actualPaswordTextField?.text,
            let email = emailTextField?.text {
            return (userName, password, email)
        }
        self.showAlert(message: "Username field is empty")
        return nil
    }
    /**
     This function validate passed password due suggested pattern written with RegEx.
     - Precondition: Password have to be 8-15 symbols length, contains charecters a-z, A-Z, 0-9 and some special symbols such as @,*,#,$.
     
     - Returns: If result of checking is success returns True, and False if not with warning message.
     */
    func checkPaswords() -> Bool {
        let passwordRegEx = "^([a-zA-Z0-9@*#$]{8,15})$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        if actualPaswordTextField.text == confirmTextField.text,
            passwordTest.evaluate(with: actualPaswordTextField.text!) {
            return true
        } else {
            self.showAlert(message: NSLocalizedString("Passwords fileds are empty or don't match", comment: "Passwords fields empty or don't match"))
        }
        return false
    }
    /**
     This function validate passed email due suggested pattern written with RegEx.
     - Precondition: Password have to be >2 symbols length, contains charecters a-z, A-Z, 0-9 and coincide with pattern xxx@xxx.xxx
     
     - Returns: If result of checking is success returns True, and False if not with warning message.
     */
    func checkEmail() -> Bool {
        let emailRegEx = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        guard let email = emailTextField.text else {
            return false
        }
        if emailTest.evaluate(with: email) {
            return true
        } else {
            self.showAlert(message: NSLocalizedString("Wrong email format", comment: "Inputed email has invalid structure"))
            return false
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Alert", comment: "Alert title"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok button"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc private func create() {
        guard checkPaswords(), checkEmail(),
            let params = unWrapFields() else {
                return
        }
        guard var userForSave = UserStructure(dictionary: ["username": params.userName, "email": params.email, "password": params.password, "logins": "0"]) else { return }
        
        DataManager.shared.insertEntity(entity: userForSave, typeEntity: .user) { (id, error) in
            guard let error = error else {
                if let id = id as? String {
                    userForSave.id = id
                    self.saveAction!(userForSave)
                    self.navigationController?.popViewController(animated: true)
                    return
                } else {
                    self.showAlert(message: NSLocalizedString("Server error\nNew user creation failed\nPlease try again", comment: "Server error. New user creation failed. Please try again"))
                    assertionFailure("AdminCreate..VC, Bad id return after creation")    
                    return
                }
            }
            self.showAlert(message: error.info)
        }
    }
    
    @objc private func update() {
        guard checkPaswords(), checkEmail(),
            let params = unWrapFields(),
            let id = self.admin?.id else { return }
        
        guard var userForSave = self.admin else { return }
        userForSave.userName = params.userName
        userForSave.email = params.email
        userForSave.password = params.password
        DataManager.shared.updateEntity(byId: id, entity:  userForSave, typeEntity: .user) { (error) in
            if let error = error {
                self.showAlert(message: error.info)
                return
            }
            self.saveAction!(userForSave)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
