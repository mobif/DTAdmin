//
//  TestForGroupsVC.swift
//  DTAdmin
//
//  Created by ITA student on 11/15/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class TestForGroupsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func getSpeciality(_ sender: Any) {
        guard let getSpecialityVC = UIStoryboard(name: "Speciality", bundle: nil).instantiateViewController(
        withIdentifier: "SpecialitiesViewController") as? SpecialitiesViewController else  { return }
        getSpecialityVC.getSpeciality = true
        self.navigationController?.pushViewController(getSpecialityVC, animated: true)
    }


}
