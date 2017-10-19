//
//  AdminViewController.swift
//  DTAdmin
//
//  Created by ITA student on 10/15/17.
//  Copyright © 2017 Yurii Krupa. All rights reserved.
//

import UIKit

class AdminViewController: ViewController {
  
  @IBOutlet weak var adminsListTableView: UITableView!
  
  var adminsList: [UserModel.Admins]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//        MARK: DEBUG - Using for first login into system
//        _ = NetworkManager().logIn(username: "admin", password: "dtapi_admin") { (admin, cookie) in
//        print(admin, cookie)
//        }
//    MARK: DEBUG - Using to create new user
//    _ = NetworkManager().createAdmin(username: "veselun", password: "1qaz2wsx", email: "veselun@tuhes.if.com")

//    MARK: DEBUG - Using for geting list of admin
//    NetworkManager().getAdmins { (admins) in
//      print(UserDefaults.standard.getCookie())
//      print(admins)
//      self.adminsList = admins
//      self.adminsListTBV.reloadData()
//    }
//        MARK: DEBUG - Using for first login into system
//        _ = NetworkManager().logOut()
//    _ = NetworkManager().updateAdmin(id: "29", userName: "Veselun", password: "1qaz@WSX", email: "veselun.pupkin@tuhes.if.com.ua")
  }
  
  @IBAction func refreshButtonTapped(_ sender: Any) {
    NetworkManager().getAdmins { (admins) in
      print(UserDefaults.standard.getCookie())
      print(admins)
      self.adminsList = admins
      self.adminsListTableView.reloadData()
    }
  }
}

extension AdminViewController: UITableViewDelegate {
  
}

extension AdminViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return adminsList != nil ? adminsList!.count : 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //TODO: make cell more informative
    let cell = tableView.dequeueReusableCell(withIdentifier: "reusableAdminCell")!
    cell.textLabel?.text = adminsList?[indexPath.row].username
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //TODO: send to next view -> adminsList[indexPath.row]
  }
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let deleteOpt = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
      
      guard let admin = self.adminsList?[indexPath.row] else { return }
      NetworkManager().deleteAdmin(id: admin.id, completionHandler: { (isComplete) in
        print("Is deleted: ", isComplete)
        self.adminsListTableView.reloadData()
      })
    }
    deleteOpt.backgroundColor = UIColor.red
    return [deleteOpt]
  }
}
