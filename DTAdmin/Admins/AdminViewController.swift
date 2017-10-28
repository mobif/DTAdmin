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

  var isSearchStart = false
  
  var adminsList: [UserModel.Admins]?
  var filteredList: [UserModel.Admins]? {
    if isSearchStart {
      guard let searchSample = searchBar.text else { return adminsList }
      return adminsList?.filter({
        $0.username.contains(searchSample) || $0.email.contains(searchSample)
      })
    } else if let admins = adminsList {
      return admins.sorted(by: { $0.username < $1.username})
    }
    return adminsList
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpView()
    
    //    StoreHelper.logout()
    //    print(StoreHelper.getCookie() as Any)
    
    //    MARK: DEBUG - Using for first login into system
    //    _ = NetworkManager().logIn(username: "admin", password: "dtapi_admin") { (admin, cookie) in
    //      print(admin, cookie)
    //    }
    //    print(UserDefaults.standard.getCookie())
    
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
  
  private func setUpView() {
    self.title = NSLocalizedString("Administrators", comment: "Title for admins table list view")
    
    let addNewAdminButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.showAdminCreateUpdateViewController))
    //MARK: temporary exist just for ease debug proces
    let serverSyncDataButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.syncDataWithServer))
    
    self.navigationItem.rightBarButtonItems = [addNewAdminButton, serverSyncDataButton]
  }
  
  @objc func showAdminCreateUpdateViewController() {
    guard let adminCreateUpdateViewController = UIStoryboard(name: "Admin", bundle: nil).instantiateViewController(withIdentifier: "AdminCreateUpdateViewController") as? AdminCreateUpdateViewController else  { return }
    adminCreateUpdateViewController.saveAction = { admin in
        if let admin = admin {
          self.adminsList?.append(admin)
          self.adminsListTableView.reloadData()
        }
      }
    self.navigationController?.pushViewController(adminCreateUpdateViewController, animated: true)
  }
  
  //MARK: temporary exist just for ease debug proces
  @objc func syncDataWithServer() {
    NetworkManager().getAdmins { (admins, response, error)  in
      if let admins = admins {
        self.adminsList = admins.sorted(by: { $0.username < $1.username})
        self.adminsListTableView.reloadData()
      } else {
        print(error!.localizedDescription, response)
      }
    }
  }
  
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
    adminCreateUpdateViewController.admin = filteredList?[indexPath.row]
    adminCreateUpdateViewController.saveAction = { admin in
      if let admin = admin {
        self.adminsList?[indexPath.row] = admin
        self.adminsListTableView.reloadData()
      }
    }
    self.navigationController?.pushViewController(adminCreateUpdateViewController, animated: true)
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let deleteOpt = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
      
      guard let admin = self.adminsList?[indexPath.row] else { return }
      NetworkManager().deleteAdmin(id: admin.id, completionHandler: { (error) in
          if let error = error {
            print(error.localizedDescription)
            return
          }
          self.adminsListTableView.beginUpdates()
          self.adminsList?.remove(at: indexPath.row)
          self.adminsListTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
          self.adminsListTableView.endUpdates()
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
