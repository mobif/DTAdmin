//
//  FacultyViewController.swift
//  DTAdmin
//
//  Created by Admin on 21.10.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class FacultyViewController: UIViewController {
    
    @IBOutlet weak var facultyTableView: UITableView!
    
    var selectFaculty: ((Faculty) -> ())?
    
    var faculties = [Faculty]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Faculties"
        facultyTableView.delegate = self
        facultyTableView.dataSource = self
        HTTPService.getAllData(entityName: "faculty") {
            (facultyJSON:[[String:String]],facultyResponce) in
            let faculties = Faculty.getFacultiesFromJSON(json: facultyJSON)
            self.faculties = faculties
            DispatchQueue.main.async {
                self.facultyTableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension FacultyViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFaculty = self.faculties[indexPath.row]
        self.selectFaculty!(selectedFaculty)
        _ = navigationController?.popViewController(animated: true)
    }
}

//MARK: table view data source
extension FacultyViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = facultyTableView.dequeueReusableCell(withIdentifier: "FacultyCell", for: indexPath)
        cell.textLabel?.text = faculties[indexPath.row].facultyName
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faculties.count
    }
    
}
