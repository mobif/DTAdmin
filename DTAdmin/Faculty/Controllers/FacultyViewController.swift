//
//  FacultyViewController.swift
//  DTAdmin
//
//  Created by Volodymyr on 11/28/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class FacultyViewController: ParentViewController {

    var facultyArray = [FacultyStructure]()
    var filteredFacultyArray = [FacultyStructure]()
    lazy var refresh:UIRefreshControl = UIRefreshControl()
    var getFaculty = Bool()
    @IBOutlet weak var facultyTableView: UITableView!
    @IBOutlet weak var searcBar: UISearchBar!
    var selectFaculty: ((FacultyStructure) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString(Entities.faculty.rawValue, comment: "All faculties")
        refresh.addTarget(self, action: #selector(refreshDataInTableView), for: .valueChanged)
        facultyTableView.refreshControl = refresh
        refreshDataInTableView()
        searcBar.delegate = self
    }

    @objc func refreshDataInTableView() {
        refresh.beginRefreshing()
        DataManager.shared.getList(byEntity: .faculty) { (faculty, error) in
            if error == nil, let faculties = faculty as? [FacultyStructure] {
                self.facultyArray = faculties
                self.filteredFacultyArray = self.facultyArray
                self.facultyTableView.reloadData()
            } else {
                guard let error = error else {
                    self.showWarningMsg(NSLocalizedString("Incorrect data type", comment: "Incorrect data type"))
                    return
                }
                self.showWarningMsg(error.info)
                if error.code == HTTPStatusCodes.Unauthorized.rawValue {
                    StoreHelper.logout()
                    self.showLoginScreen()
                }
            }
        }
        self.refresh.endRefreshing()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        guard let createUpdateViewController = UIStoryboard(name: "Faculty",
            bundle: nil).instantiateViewController(withIdentifier: "CreateUpdateViewController")
                as? CreateUpdateViewController else { return }
        self.navigationController?.pushViewController(createUpdateViewController, animated: true)
        createUpdateViewController.resultModification = { newFacultyty in
            self.filteredFacultyArray.append(newFacultyty)
            self.facultyTableView.reloadData()
        }
    }
}

extension FacultyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFacultyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let protoCell = tableView.dequeueReusableCell(withIdentifier: "facultyCell", for: indexPath)
            as? FacultyTableViewCell
        guard let cell = protoCell else { return UITableViewCell() }
        let item = filteredFacultyArray[indexPath.row]
        cell.facultyIdLabel.text = item.id
        cell.facultyNameLabel.text = item.name
        cell.accessoryType = getFaculty ? UITableViewCellAccessoryType.none :
            UITableViewCellAccessoryType.detailDisclosureButton
        return cell
    }
}

extension FacultyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        let id = UILabel()
        id.text = NSLocalizedString(FacultyDetails.id.rawValue, comment: "header for id in table")
        id.textColor = UIColor.white
        id.frame = CGRect(x: 22, y: 2, width: 20, height: 25)
        view.addSubview(id)
        let code = UILabel()
        code.text = NSLocalizedString(FacultyDetails.name.rawValue, comment: "header for faculty name in table")
        code.textColor = UIColor.white
        code.frame = CGRect(x: 140, y: 2, width: 100, height: 25)
        view.addSubview(code)
        return view
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: NSLocalizedString("Edit", comment: "title for editing"),
            handler: { action, indexPath in
                guard let createUpdateViewController = UIStoryboard(name: "Faculty",
                    bundle: nil).instantiateViewController(withIdentifier: "CreateUpdateViewController")
                        as? CreateUpdateViewController else { return }
                            createUpdateViewController.facultyInstance = self.filteredFacultyArray[indexPath.row]
                            createUpdateViewController.canEdit = true
                            createUpdateViewController.resultModification = { updateResult in
                                self.filteredFacultyArray[indexPath.row] = updateResult
                                self.facultyTableView.reloadData()
                            }
                self.navigationController?.pushViewController(createUpdateViewController, animated: true)
        })
        let delete = UITableViewRowAction(style: .destructive, title: NSLocalizedString("Delete",
            comment: "title for deleting"),
                handler: { action, indexPath in
                let alert = UIAlertController(title: NSLocalizedString("WARNING", comment: "title for alert"),
                    message: NSLocalizedString("Do you want to delete this speciality?",
                        comment: "title for alert message"),
                            preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("YES", comment: "title for ok key"),
                          style: .default, handler: { (action) in
                            alert.dismiss(animated: true, completion: nil)
                            guard let id = self.filteredFacultyArray[indexPath.row].id else { return }
                            if indexPath.row < self.filteredFacultyArray.count {
                                DataManager.shared.deleteEntity(byId: id, typeEntity: Entities.faculty) { (deleted, error) in
                                    if let error = error {
                                        self.showWarningMsg(error.info)
                                    } else {
                                        self.filteredFacultyArray.remove(at: indexPath.row)
                                        tableView.deleteRows(at: [indexPath], with: .top)
                                        self.facultyTableView.reloadData()
                                    }
                                }
                            }
                    }))
                    alert.addAction(UIAlertAction(title: NSLocalizedString("NO", comment: "title for cancel key"),
                                                  style: .default, handler: { (action) in
                                                    alert.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
        })
        return [edit, delete]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if getFaculty {
            let selectedFaculty = self.filteredFacultyArray[indexPath.row]
            guard let selectFaculty = self.selectFaculty else { return }
            selectFaculty(selectedFaculty)
            self.navigationController?.popViewController(animated: true)
        } else {
            guard let facultyInfoViewController = UIStoryboard(name: "Faculty",
                bundle: nil).instantiateViewController(withIdentifier: "FacultyInfoViewController")
                as? FacultyInfoViewController else  { return }
            facultyInfoViewController.facultyInstance = self.filteredFacultyArray[indexPath.row]
            self.navigationController?.pushViewController(facultyInfoViewController, animated: true)
            
        }
    }
}

extension FacultyViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            filteredFacultyArray = facultyArray
            facultyTableView.reloadData()
            return
        }
        filteredFacultyArray = facultyArray.filter({ $0.name.lowercased().contains(searchText.lowercased()) })
        facultyTableView.reloadData()
    }
}



