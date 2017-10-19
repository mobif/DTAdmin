//
//  AdminViewController.swift
//  DTAdmin
//
//  Created by ITA student on 10/15/17.
//  Copyright © 2017 Yurii Krupa. All rights reserved.
//

import UIKit

class AdminViewController: UIViewController {
  
  @IBOutlet weak var adminsListTableView: UITableView!
  
  var adminsList: [UserModel.Admins]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Administrators"
    
    
    let btnAddAdmin = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.showAdminCreateUpdateViewController))
    let btnSyncData = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.syncDataWithServer))
    self.navigationItem.rightBarButtonItems = [btnAddAdmin, btnSyncData]
    
//    MARK: DEBUG - Using for first login into system
//    _ = NetworkManager().logIn(username: "admin", password: "dtapi_admin") { (admin, cookie) in
//        print(admin, cookie)
//        }
//    MARK: DEBUG - Using to create new user, to preceed should be loginned before
//    _ = NetworkManager().createAdmin(username: "veselun", password: "1qaz2wsx", email: "veselun@tuhes.if.com")

//    MARK: DEBUG - Using for geting list of admin, to preceed should be loginned before
//    NetworkManager().getAdmins { (admins) in
//      print(UserDefaults.standard.getCookie())
//      print(admins)
//      self.adminsList = admins
//      self.adminsListTBV.reloadData()
//    }
//    MARK: DEBUG - Using for first login into system, to preceed should be loginned before
//    _ = NetworkManager().logOut()
    
    

  }
  
  @IBAction func refreshButtonTapped(_ sender: Any) {
    NetworkManager().getAdmins { (admins) in
      self.adminsList = admins
      self.adminsListTableView.reloadData()
      
    }
  }
  
  @objc func showAdminCreateUpdateViewController() {
    guard let adminCreateUpdateViewController = UIStoryboard(name: "Admin", bundle: nil).instantiateViewController(withIdentifier: "AdminCreateUpdateViewController") as? AdminCreateUpdateViewController else  { return }
    self.navigationController?.pushViewController(adminCreateUpdateViewController, animated: true)
  }
  @objc func syncDataWithServer() {
    NetworkManager().getAdmins { (admins) in
      self.adminsList = admins
      self.adminsListTableView.reloadData()
    }
  }
}

private func setUpNavigationBar() {
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
