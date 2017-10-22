//
//  SpecialityViewController.swift
//  DTAdmin
//
//  Created by Admin on 21.10.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class SpecialityViewController: UIViewController {

    @IBOutlet weak var specialityTableView: UITableView!
    var selectSpeciality: ((Speciality) -> ())?
    
    var specialities = [Speciality]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Specialities"
        specialityTableView.delegate = self
        specialityTableView.dataSource = self
        HTTPService.getAllData(entityName: "speciality") {
            (specialityJSON:[[String:String]],facultyResponce) in
            let specialities = Speciality.getSpecialitiesFromJSON(json: specialityJSON)
            self.specialities = specialities
            DispatchQueue.main.async {
                self.specialityTableView.reloadData()
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

extension SpecialityViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSpeciality = self.specialities[indexPath.row]
        self.selectSpeciality!(selectedSpeciality)
        _ = navigationController?.popViewController(animated: true)
    }
}

//MARK: table view data source
extension SpecialityViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = specialityTableView.dequeueReusableCell(withIdentifier: "SpecialityCell", for: indexPath)
        cell.textLabel?.text = specialities[indexPath.row].specialityName
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return specialities.count
    }
    
}

