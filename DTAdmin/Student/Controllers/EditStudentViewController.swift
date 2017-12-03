//
//  EditStudentViewController.swift
//  DTAdmin
//
//  Created by Volodymyr on 10/16/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class EditStudentViewController: ParentViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    var studentLoaded: StudentStructure?
    var studentForSave: StudentStructure?
    @IBOutlet weak var loginStudentTextField: UITextField!
    @IBOutlet weak var emailStudentTextField: UITextField!
    @IBOutlet weak var nameStudentTextField: UITextField!
    @IBOutlet weak var familyNameStudentTextField: UITextField!
    @IBOutlet weak var surnameStudentTextField: UITextField!
    @IBOutlet weak var groupButton: UIButton!
    @IBOutlet weak var passwordStudentTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var gradeBookIdTextField: UITextField!
    @IBOutlet weak var studentPhoto: UIImageView!
    
    var selectedGroupForStudent: GroupStructure?
    var selectedUserAccountForStudent: UserStructure?
    var isNewStudent = true
    var resultModification: ((StudentStructure, Bool) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        let saveButton: UIBarButtonItem
        if let studentLoaded = studentLoaded {
            nameStudentTextField.text = studentLoaded.studentName
            familyNameStudentTextField.text = studentLoaded.studentFname
            surnameStudentTextField.text = studentLoaded.studentSurname
            passwordStudentTextField.text = studentLoaded.plainPassword
            passwordConfirmTextField.text = studentLoaded.plainPassword
            gradeBookIdTextField.text = studentLoaded.gradebookId
            getGroupFromAPI(byId: studentLoaded.groupId)
            if let userId = studentLoaded.userId {
                getUserFromAPI(byId: userId)
            }
            saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(self.postUpdateStudentToAPI))
            if studentLoaded.photo != nil {
                showStudentPhoto()
            }
            isNewStudent = false
        } else {
            saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(self.postNewStudentToAPI))
            isNewStudent = true
        }
        navigationItem.rightBarButtonItem = saveButton
        let onImageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditStudentViewController.imageTaped(recognizer:)))
        onImageGestureRecognizer.numberOfTapsRequired = 1
        studentPhoto.isUserInteractionEnabled = true
        studentPhoto.addGestureRecognizer(onImageGestureRecognizer)

    }
    @objc func imageTaped(recognizer: UITapGestureRecognizer) {
        let imagePhoto = UIImagePickerController()
        imagePhoto.delegate = self
        imagePhoto.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePhoto.allowsEditing = false
        self.present(imagePhoto, animated: true)
    }
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let size = selectedImage.size
            let imageHeight: CGFloat = 50.0
            let aspectRatioForWidth = ( size.width / size.height ) * imageHeight
            let resizedImage = selectedImage.resize(toSize: CGSize(width: aspectRatioForWidth, height: imageHeight), scale: UIScreen.main.scale)
            studentPhoto.image = resizedImage
        } else {
            showWarningMsg(NSLocalizedString("Image not selected!", comment: "You have to select image to adding in profile."))
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func showStudentPhoto(){
        guard let photoBase64 = studentLoaded?.photo else { return }
        studentPhoto.image = photoBase64
    }
    
    @objc func postUpdateStudentToAPI(){
        if prepareForSave(){
            guard let userIDForUpdate = studentLoaded?.userId else { return }
            guard var studentForSave = studentForSave else { return }
            DataManager.shared.updateEntity(byId: userIDForUpdate, entity: studentForSave, typeEntity: .student) { error in
                if let error = error {
                    self.showAllert(error: error, completionHandler: nil)
                } else {
                    if let resultModification = self.resultModification {
                        studentForSave.userId = userIDForUpdate
                        resultModification(studentForSave, false)
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @objc func postNewStudentToAPI(){
        if prepareForSave(){
            guard let studentForSave = studentForSave else { return }
            DataManager.shared.insertEntity(entity: studentForSave, typeEntity: .student) { (id, error) in
                if let error = error {
                    self.showAllert(error: error, completionHandler: nil)
                } else {
                    guard let id = id else {
                        self.showWarningMsg(NSLocalizedString("Incorect response structure", comment: "New user ID not found in the response message"))
                        return
                    }
                    let newUserId = String(describing: id)
                    var newStudent = studentForSave
                    newStudent.userId = newUserId
                    if let resultModification = self.resultModification {
                        resultModification(newStudent, true)
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
/**
     This function checks all data from fields for creation of instance new student.
     - Precondition: Each field must have its properly value. Group and photo has to be selected also.
     - Postcondition: In case if checking is success then would be prepared the instance for transfer to API, otherwise shows warning.
     - Returns: If result of checking is success returns True, and False if not.
*/
    func prepareForSave() -> Bool {
        guard let login = loginStudentTextField.text,
            let email = emailStudentTextField.text,
            let name = nameStudentTextField.text,
            let sname = surnameStudentTextField.text,
            let fname = familyNameStudentTextField.text,
            let gradebook = gradeBookIdTextField.text,
            let pass = passwordStudentTextField.text,
            let passConfirm = passwordConfirmTextField.text,
            let group = selectedGroupForStudent?.groupId else { return false}
        if (name.count > 2) && (sname.count > 2) && (fname.count > 1) && (gradebook.count > 4) && (pass.count > 6) && (pass == passConfirm){
            let dictionary: [String: Any] = ["username": login, "password": pass, "password_confirm": passConfirm, "plain_password": pass, "email": email, "gradebook_id": gradebook, "student_surname": sname, "student_name": name, "student_fname": fname, "group_id": group]
            studentForSave = StudentStructure(dictionary: dictionary)
            if let image: UIImage = studentPhoto.image {
                studentForSave?.photo = image
            }
        } else {
            showWarningMsg(NSLocalizedString("Entered incorect data", comment: "All fields have to be filled correctly"))
            return false
        }
        return true
    }
    
    @IBAction func selectGroup(_ sender: UIButton) {
        guard let groupsViewController = UIStoryboard.stoyboard(by: .group).instantiateViewController(withIdentifier: "GroupVC") as? GroupViewController else { return }
        groupsViewController.selectGroup = {
            group in
            self.selectedGroupForStudent = group
            self.groupButton.setTitle(group.groupName, for: .normal)
        }
        self.navigationController?.pushViewController(groupsViewController, animated: true)
    }
    func getGroupFromAPI(byId: String) {
        DataManager.shared.getEntity(byId: byId, typeEntity: .group) { (groupInstance, error) in
            if let groupInstance = groupInstance as? GroupStructure {
                self.selectedGroupForStudent = groupInstance
                self.groupButton.setTitle(groupInstance.groupName, for: .normal)
            } else if let error = error {
                self.showAllert(error: error, completionHandler: nil)
            }
        }
    }
    func getUserFromAPI(byId: String) {
        DataManager.shared.getEntity(byId: byId, typeEntity: .user) { (userInstance, error) in
            if let userInstance = userInstance as? UserStructure{
                self.selectedUserAccountForStudent = userInstance
                self.loginStudentTextField.text = userInstance.userName
                self.emailStudentTextField.text = userInstance.email
            } else if let error = error {
                self.showAllert(error: error, completionHandler: nil)
            }
        }
    }
}

