//
//  EditStudentViewController.swift
//  DTAdmin
//
//  Created by Володимир on 10/16/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class EditStudentViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    var studentLoaded: StudentGetStructure?{
        didSet {
            self.view.layoutIfNeeded()
        }
    }
    var studentForSave: StudentPostStructure?
    
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
    
    var titleViewController: String?
    var selectedGroupForStudent: GroupStructure?
    var selectedUserAccountForStudent: UserGetStructure?
    var isNewStudent = true
    var resultModification: ((StudentGetStructure, Bool) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let saveButton: UIBarButtonItem
        if let studentLoaded = studentLoaded {
            nameStudentTextField.text = studentLoaded.studentName
            familyNameStudentTextField.text = studentLoaded.studentFname
            surnameStudentTextField.text = studentLoaded.studentSurname
            passwordStudentTextField.text = studentLoaded.plainPassword
            gradeBookIdTextField.text = studentLoaded.gradebookId
            getGroupFromAPI(byId: studentLoaded.groupId)
            getUserFromAPI(byId: studentLoaded.userId)
            saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(self.postUpdateStudentToAPI))
            if studentLoaded.photo.count > 1 {
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
        if titleViewController != nil {
            navigationItem.title = titleViewController
        }
    }
    
    @objc func imageTaped(recognizer: UITapGestureRecognizer) {
        let imagePhoto = UIImagePickerController()
        imagePhoto.delegate = self
        imagePhoto.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePhoto.allowsEditing = false
        self.present(imagePhoto, animated: true)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let size = selectedImage.size
            let scale = selectedImage.scale
            let sizeX = size.width
            let sizeY = size.height
            let k = ( sizeX / sizeY ) * 100
            print(size)
            print(scale)
            let resizedImage = selectedImage.convert(toSize:CGSize(width:k, height:100.0), scale: UIScreen.main.scale)
            studentPhoto.image = resizedImage
        } else {
            showWarningMsg("Image not selected!")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func showStudentPhoto(){
        let dataDecoded : Data = Data(base64Encoded: (studentLoaded?.photo)!, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        studentPhoto.image = decodedimage
    }
    
    @objc func postUpdateStudentToAPI(){
        let postMan = PostManager<StudentPostStructure>()
        if prepareForSave(){
            guard let userIDForUpdate = studentLoaded?.userId else { return }
            guard let studentForSave = studentForSave else { return }
            postMan.updateEntity(byId: userIDForUpdate, entity: studentForSave, entityStructure: Entities.Student, returnResults: { error in
                if let error = error {
                    self.showWarningMsg(error)
                } else {
                    if let resultModification = self.resultModification {
                        resultModification(studentForSave.convertToGetStructure(id: userIDForUpdate), false)
                    }
                    self.navigationController?.popViewController(animated: true)
                } })
        }
    }
    
    @objc func postNewStudentToAPI(){
        let postMan = PostManager<StudentPostStructure>()
        if prepareForSave(){
            guard let studentForSave = studentForSave else { return }
            postMan.insertEntity(entity: studentForSave, entityStructure: Entities.Student, returnResults: { (resultString, error) in
                if let error = error {
                        self.showWarningMsg(error)
                } else {
                    guard let resultStringUnwraper = resultString else {
                        self.showWarningMsg("No server response")
                        return
                    }
                    let dictionaryResult = self.convertToDictionary(text: resultStringUnwraper)
                    guard let dictionaryResultUnwraped = dictionaryResult else {
                        self.showWarningMsg("Incorect response structure")
                        return
                    }
                    guard let newUserId = self.getIdAsInt(dict: dictionaryResultUnwraped) else {
                        self.showWarningMsg("Incorect response structure")
                        return
                    }
                    if let resultModification = self.resultModification {
                        resultModification(studentForSave.convertToGetStructure(id: newUserId), true)
                    }
                    self.navigationController?.popViewController(animated: true)
                } })
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                return dict
            } catch {
                self.showWarningMsg(error.localizedDescription)
            }
        }
        return nil
    }
    
    func getIdAsInt(dict: [String: Any]) -> String? {
        let id = dict["id"] as? Int
        guard let idValue = id else { return nil }
        return String(idValue)
    }
    
    func prepareForSave() -> Bool {
        guard let login = loginStudentTextField.text,
            let email = emailStudentTextField.text,
            let name = nameStudentTextField.text,
            let sname = surnameStudentTextField.text,
            let fname = familyNameStudentTextField.text,
            let gradebook = gradeBookIdTextField.text,
            let pass = passwordStudentTextField.text,
            let passConfirm = passwordConfirmTextField.text,
            let image : UIImage = studentPhoto.image,
            let imageData = UIImagePNGRepresentation(image),
            let group = selectedGroupForStudent?.groupId else { return false}
        let photo = imageData.base64EncodedString(options: .lineLength64Characters)
        print(photo.count)
        if (name.count > 2) && (sname.count > 2) && (fname.count > 1) && (gradebook.count > 4) && (pass.count > 6) && (pass == passConfirm){
            studentForSave = StudentPostStructure(userName: login, password: pass, passwordConfirm: passConfirm, plainPassword: pass, email: email, gradebookId: gradebook, studentSurname: sname, studentName: name, studentFname: fname, groupId: group, photo: photo)
        } else {
            return false
        }
        return true
    }
    
    @IBAction func selectGroup(_ sender: UIButton) {
        guard let groupsViewController = UIStoryboard(name: "Student", bundle: nil).instantiateViewController(withIdentifier: "GroupsTableViewController") as? GroupsTableViewController else { return }
        groupsViewController.titleViewController = "Groups"
        groupsViewController.selecectedGroup = {
            group in
            self.selectedGroupForStudent = group
            self.groupButton.setTitle(group.groupName, for: .normal)
        }
        self.navigationController?.pushViewController(groupsViewController, animated: true)
    }
    func getGroupFromAPI(byId: String) {
        let manager = RequestManager<GroupStructure>()
        manager.getEntity(byId: byId, entityStructure: Entities.Group, returnResults: { (groupInstance, error) in
            if let groupInstance = groupInstance {
                self.selectedGroupForStudent = groupInstance
                self.groupButton.setTitle(groupInstance.groupName, for: .normal)
            } else if let error = error {
                self.showWarningMsg(error)
            }
        })
    }
    func getUserFromAPI(byId: String) {
        let manager = RequestManager<UserGetStructure>()
        manager.getEntity(byId: byId, entityStructure: .User, returnResults: { (userInstance, error) in
            if let userInstance = userInstance {
                self.selectedUserAccountForStudent = userInstance
                self.loginStudentTextField.text = userInstance.userName
                self.emailStudentTextField.text = userInstance.email
            } else if let error = error {
                self.showWarningMsg(error)
            }
        })
    }
}
extension UIImage
{
    func convert(toSize size:CGSize, scale:CGFloat) -> UIImage
    {
        let imgRect = CGRect(origin: CGPoint(x:0.0, y:0.0), size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        self.draw(in: imgRect)
        guard let copied = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        UIGraphicsEndImageContext()
        return copied
    }
}
