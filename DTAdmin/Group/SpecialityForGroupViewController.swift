//
//  SpecialityViewController.swift
//  DTAdmin
//
//  Created by Admin on 21.10.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class SpecialityForGroupViewController: ParentViewController {
    
    @IBOutlet weak var specialityTableView: UITableView!
    
    /**
     This clousure perfoms by transmitting the object to be selected by the user to other controllers
     */
    var selectSpeciality: ((SpecialityStructure) -> ())?
    var specialities = [SpecialityStructure]() {
        didSet {
            DispatchQueue.main.async {
                self.specialityTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Specialities", comment: "Title for Specialities table view")
        specialityTableView.delegate = self
        specialityTableView.dataSource = self
        DataManager.shared.getList(byEntity: .speciality){ (specialities, error) in
            if let error = error {
                self.showAllert(error: error, completionHandler: nil)
            } else {
                guard let specialities = specialities as? [SpecialityStructure] else {return}
                self.specialities = specialities
            }
        }
    }
}

//MARK: table view delegate
extension SpecialityForGroupViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSpeciality = self.specialities[indexPath.row]
        guard let selectSpeciality = self.selectSpeciality else { return }
        selectSpeciality(selectedSpeciality)
        navigationController?.popViewController(animated: true)
    }
}

//MARK: table view data source
extension SpecialityForGroupViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = specialityTableView.dequeueReusableCell(withIdentifier: "SpecialityCell", for: indexPath)
        cell.textLabel?.text = specialities[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return specialities.count
    }
}

