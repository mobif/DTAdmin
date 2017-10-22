//
//  AdminViewController.swift
//  DTAdmin
//
//  Created by ITA student on 10/15/17.
//  Copyright © 2017 Yurii Krupa. All rights reserved.
//

import UIKit

class AdminViewController: UIViewController {
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var adminsListTableView: UITableView!
  
  var adminsList: [UserModel.Admins]?
  var isSearchStart = false
  var filteredList: [UserModel.Admins]? {
    if isSearchStart {
      guard let searchSample = searchBar.text else { return adminsList }
      return adminsList?.filter({
        $0.username.contains(searchSample) || $0.email.contains(searchSample)
      })
    } else {
      return adminsList
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = NSLocalizedString("Administrators", comment: "Title for admins table list view")

    let addNewAdminButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.showAdminCreateUpdateViewController))
    let serverSyncDataButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.syncDataWithServer))
    self.navigationItem.rightBarButtonItems = [addNewAdminButton, serverSyncDataButton]
    
//    MARK: DEBUG - Using for first login into system
//    _ = NetworkManager().logIn(username: "admin", password: "dtapi_admin") { (admin, cookie) in
//        print(admin, cookie)
//        }
//    MARK: DEBUG - Using to create new user, to proceed should be loginned before
//    _ = NetworkManager().createAdmin(username: "veselun", password: "1qaz2wsx", email: "veselun@tuhes.if.com")

//    MARK: DEBUG - Using for geting list of admin, to proceed should be loginned before
//    NetworkManager().getAdmins { (admins) in
//      print(UserDefaults.standard.getCookie())
//      print(admins)
//      self.adminsList = admins
//      self.adminsListTBV.reloadData()
//    }
//    MARK: DEBUG - Using after first login into system, to proceed should be loginned before
//    _ = NetworkManager().logOut()

  }
  
  @objc func showAdminCreateUpdateViewController() {
    guard let adminCreateUpdateViewController = UIStoryboard(name: "Admin", bundle: nil).instantiateViewController(withIdentifier: "AdminCreateUpdateViewController") as? AdminCreateUpdateViewController else  { return }
    self.navigationController?.pushViewController(adminCreateUpdateViewController, animated: true)
  }
  @objc func syncDataWithServer() {
//    print("Cookie",UserDefaults.standard.getCookie())
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
    return filteredList != nil ? filteredList!.count : 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "reusableAdminCell")!
    cell.textLabel?.text = filteredList?[indexPath.row].username
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let adminCreateUpdateViewController = UIStoryboard(name: "Admin", bundle: nil).instantiateViewController(withIdentifier: "AdminCreateUpdateViewController") as? AdminCreateUpdateViewController else  { return }
    adminCreateUpdateViewController.title = NSLocalizedString("Edit", comment: "Title for edit admin creation view")
    adminCreateUpdateViewController.adminInstance = filteredList?[indexPath.row]
    self.navigationController?.pushViewController(adminCreateUpdateViewController, animated: true)
    
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let deleteOpt = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
      
      guard let admin = self.adminsList?[indexPath.row] else { return }
      NetworkManager().deleteAdmin(id: admin.id, completionHandler: { (isComplete) in
        if isComplete {
          print("Is deleted: ", isComplete)
          self.adminsList?.remove(at: indexPath.row)
          self.adminsListTableView.reloadData()
        }
      })
    }
    deleteOpt.backgroundColor = UIColor.red
    return [deleteOpt]
  }
}

extension AdminViewController: UISearchBarDelegate {
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    guard let searchText = searchBar.text else { return }
    isSearchStart = !searchText.isEmpty
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    isSearchStart = !searchText.isEmpty
    adminsListTableView.reloadData()
  }
}
