//
//  TimeTableListViewController.swift
//  DTAdmin
//
//  Created by mac6 on 10/22/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class TimeTableListViewController: ParentViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var subjectID: Int?
    var groupID: Int?
    
    var timeTableList = [TimeTable]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Time Table"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let subjectID = self.subjectID {
            self.startActivity()
            CommonNetworkManager.shared().timeTableSubject(by: subjectID, completion: { (timeTableList, error) in
                self.stopActivity()
                if let error = error {
                    self.showAllert(title: NSLocalizedString("Error", comment: "Alert title"), message: error.localizedDescription, completionHandler: nil)
                } else {
                    self.timeTableList = timeTableList ?? [TimeTable]()
                }
            })
        } else if let groupID = self.groupID {
            self.startActivity()
            CommonNetworkManager.shared().timeTable(by: groupID, completion: { (timeTableList, error) in
                self.stopActivity()
                if let error = error {
                    self.showAllert(title: NSLocalizedString("Error", comment: "Alert title"), message: error.localizedDescription, completionHandler: nil)
                } else {
                    self.timeTableList = timeTableList ?? [TimeTable]()
                }
            })
        } else {
            self.startActivity()
            CommonNetworkManager.shared().timeTable { (timeTableList, error) in
                self.stopActivity()
                if let error = error {
                    self.showAllert(title: NSLocalizedString("Error", comment: "Alert title"), message: error.localizedDescription, completionHandler: nil)
                } else {
                    self.timeTableList = timeTableList ?? [TimeTable]()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addItemTapped(_ sender: Any) {
        let timeTableStoryboard = UIStoryboard.init(name: "TimeTable", bundle: nil)
        guard let newTimeTableController = timeTableStoryboard.instantiateViewController(withIdentifier: "NewTimeTableViewController") as? NewTimeTableViewController else { return }
        
        self.navigationController?.pushViewController(newTimeTableController, animated: true)
    }
    
    // MARK: - Table View delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.timeTableList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let timeTableItem = self.timeTableList[indexPath.row]
        cell.textLabel?.text = "Start date: \(timeTableItem.startDate ?? "") Start time: \(timeTableItem.startTime ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
