//
//  TestDetailsViewController.swift
//  DTAdmin
//
//  Created by ITA student on 11/6/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class TestDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var testDetailArray = [TestDetailStructure]()
    var id = "1"
    @IBOutlet weak var testDetailsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DataManager.shared.getTestDetails(byTest: id) { (details, error) in
            print(details)
            if error == nil, let testDetails = details as? [TestDetailStructure] {
                print(error, details, testDetails)
                self.testDetailArray = testDetails
                self.testDetailsTableView.reloadData()
            } else {
                self.showWarningMsg(error ?? NSLocalizedString("Incorect type data", comment: "Incorect type data"))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testDetailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let prototypeCell = tableView.dequeueReusableCell(withIdentifier: "testDetailsCell", for: indexPath) as? testDetailsTableViewCell
        guard let cell = prototypeCell else { return UITableViewCell() }
        let array = testDetailArray[indexPath.row]
        cell.testDetailId.text = array.id
        cell.testDetailTestId.text = array.testId
        cell.testDetailLevel.text = array.level
        cell.testDetailTasks.text = array.tasks
        cell.testDetailRate.text = array.rate
        return cell
    }


    @IBAction func addButtonTapped(_ sender: Any) {
        testDetailsTableView.reloadData()
        print(testDetailArray)
        
    }
    
    
    
    /* - - - LogIn for testing - - - */
    @IBAction func loginButtonTapped(_ sender: Any) {
        //test data
        let loginText = "admin"
        let passwordText = "dtapi_admin"
        
        CommonNetworkManager.shared().logIn(username: loginText, password: passwordText) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                StoreHelper.saveUser(user: user)
                DispatchQueue.main.async {
                    print("user is logged")
                }
            }
        }
        
    }
    
}
