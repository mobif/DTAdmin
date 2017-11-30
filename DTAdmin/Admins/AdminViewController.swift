//
//  AdminViewController.swift
//  DTAdmin
//
//  Created by ITA student on 10/15/17.
//  Copyright © 2017 Yurii Krupa. All rights reserved.
//

import UIKit

class AdminViewController: ParentViewController {
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var adminsListTableView: UITableView!

  var isSearchStart = false
  
  var admins: [UserStructure]?
  
  var filteredList: [UserStructure]? {
    if isSearchStart {
      guard let searchSample = searchBar.text else { return self.admins }
      return self.admins?.filter({
        $0.userName.contains(searchSample) || $0.email.contains(searchSample)
      })
    } else {
      self.admins = self.admins?.sorted(by: { $0.userName < $1.userName})
      return self.admins
    }
  }
  
  lazy var refreshControl: UIRefreshControl = UIRefreshControl()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setUpView()
    updateTable()
    refreshControl.addTarget(self, action: #selector(updateTable), for: .valueChanged)
    adminsListTableView.refreshControl = refreshControl

//    MARK: Debug helper for login test
//    StoreHelper.logout()
  }
  
  private func setUpView() {
    self.title = NSLocalizedString("Administrators", comment: "Title for admins table list view")
    
    let addNewAdminButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.showAdminCreateUpdateViewController))
    self.navigationItem.rightBarButtonItems = [addNewAdminButton]
  }
  
  @objc private func updateTable() {
    startActivity()
    DataManager.shared.getList(byEntity: .user) { (admins, error) in
      self.stopActivity()
      guard let admins = admins as? [UserStructure] else {
        self.refreshControl.endRefreshing()
        self.showAllert(error: error, completionHandler: nil)
        return
      }
      self.admins = admins
      self.adminsListTableView.reloadData()
    }
    self.refreshControl.endRefreshing()
  }
  
  @objc func showAdminCreateUpdateViewController() {
    guard let adminCreateUpdateViewController = UIStoryboard(name: "Admin", bundle: nil).instantiateViewController(withIdentifier: "AdminCreateUpdateViewController") as? AdminCreateUpdateViewController else  { return }
    adminCreateUpdateViewController.saveAction = { admin in
        if let admin = admin {
          self.admins?.append(admin)
          self.adminsListTableView.reloadData()
        }
      }
    self.navigationController?.pushViewController(adminCreateUpdateViewController, animated: true)
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
    cell.textLabel?.text = filteredList?[indexPath.row].userName
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let adminCreateUpdateViewController = UIStoryboard(name: "Admin", bundle: nil).instantiateViewController(withIdentifier: "AdminCreateUpdateViewController") as? AdminCreateUpdateViewController else  { return }
    adminCreateUpdateViewController.title = NSLocalizedString("Edit", comment: "Title for edit admin creation view")
    adminCreateUpdateViewController.admin = filteredList?[indexPath.row]
    adminCreateUpdateViewController.saveAction = { admin in
      if let admin = admin {
        self.admins?[indexPath.row] = admin
        self.adminsListTableView.reloadData()
      }
    }
    self.navigationController?.pushViewController(adminCreateUpdateViewController, animated: true)
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let deleteOpt = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
      
        guard let admin = self.admins?[indexPath.row], let adminId = admin.id else { return }
      DataManager.shared.deleteEntity(byId: adminId, typeEntity: .user, completionHandler: { (status, error) in
        guard let error = error else {
          self.adminsListTableView.beginUpdates()
          self.admins?.remove(at: indexPath.row)
          self.adminsListTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
          self.adminsListTableView.endUpdates()
          return
        }
        self.showAllert(error: error, completionHandler: nil)
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
