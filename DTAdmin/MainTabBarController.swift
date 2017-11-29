//
//  ViewController.swift
//  DTAdmin
//
//  Created by ITA student on 10/10/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        var tabBarViewControllers = [UIViewController]()
        
//MARK: Create students tab
        let studentStoryboard = UIStoryboard.stoyboard(by: .student)
        guard let studentNavigationController = studentStoryboard.instantiateViewController(withIdentifier:
            "StudentNavigationController") as? UINavigationController else { return }
        let titleText = NSLocalizedString("Students", comment: "List all students")
        let studentBarItem = UITabBarItem(title: titleText, image: nil, selectedImage: nil)
        studentBarItem.image = UIImage(named: "ic_person_outline_white")
        studentNavigationController.tabBarItem = studentBarItem
        tabBarViewControllers.append(studentNavigationController)

//MARK: Create subjects tab
        let subjectStoryboard = UIStoryboard.stoyboard(by: .subject)
        guard let subjectNavController = subjectStoryboard.instantiateViewController(withIdentifier:
            "SubjectNavController") as? UINavigationController else { return }
        let subjectBarItem = UITabBarItem(title: NSLocalizedString("Subjects", comment: "Title for subjects tap"),
                                          image: nil,  selectedImage: nil)
        subjectBarItem.image = UIImage(named: "ic_subject_white")
        subjectNavController.tabBarItem = subjectBarItem
        tabBarViewControllers.append(subjectNavController)

//MARK: Create groups tab
        let groupStoryboard = UIStoryboard.stoyboard(by: .group)
        guard let groupNavController = groupStoryboard.instantiateViewController(withIdentifier:
            "GroupNavController") as? UINavigationController else { return }
        let groupsBarItem = UITabBarItem(title: NSLocalizedString("Groups", comment: "Title for groups tap"),
                                         image: nil, selectedImage: nil)
        groupsBarItem.image = UIImage(named: "ic_supervisor_account_white")
        groupNavController.tabBarItem = groupsBarItem
        tabBarViewControllers.append(groupNavController)
        
// Create faculty tab
        let facultyStoryboard = UIStoryboard.stoyboard(by: .faculty)
        guard let facultyNavController = facultyStoryboard.instantiateViewController(withIdentifier:
            "FacultyNavController") as? UINavigationController else { return }
        let facultyBarItem = UITabBarItem(title: NSLocalizedString("Faculty", comment: "Title for faculty tap"),
                                             image: nil, selectedImage: nil)
        facultyBarItem.image = UIImage(named: "ic_account_balance_white")
        facultyNavController.tabBarItem = facultyBarItem
        tabBarViewControllers.append(facultyNavController)

// Create speciality tab
        let specialityStoryboard = UIStoryboard.stoyboard(by: .speciality)
        guard let specialityNavController = specialityStoryboard.instantiateViewController(withIdentifier:
            "SpecialityNavController") as? UINavigationController else { return }
        let specialityBarItem = UITabBarItem(title: NSLocalizedString("Speciality", comment: "Title for speciality tap"),
                                             image: nil, selectedImage: nil)
        specialityBarItem.image = UIImage(named: "ic_subject_white")
        specialityNavController.tabBarItem = specialityBarItem
        tabBarViewControllers.append(specialityNavController)
        
//MARK: Create admins tab
        let adminStoryboard = UIStoryboard.stoyboard(by: .admin)
        guard let adminsNavController = adminStoryboard.instantiateViewController(withIdentifier: "AdminListView")
            as? UINavigationController else { return }
        let adminsBarItem = UITabBarItem(title: NSLocalizedString("Admins", comment: "Title for admins tap"),
                                         image: nil, selectedImage: nil)
        adminsBarItem.image = UIImage(named: "ic_subject_white")
        adminsNavController.tabBarItem = adminsBarItem
        tabBarViewControllers.append(adminsNavController)
        

//MARK: Create timeTable tab
        guard let logoutController = self.storyboard?.instantiateViewController(withIdentifier: "LogoutViewController")
            as? LogoutViewController else { return }
        let logoutBarItem = UITabBarItem(title: NSLocalizedString("Logout", comment: "Title for logout"),
                                         image: nil, selectedImage: nil)
        logoutBarItem.image = UIImage(named: "ic_exit_to_app_white")
        logoutController.tabBarItem = logoutBarItem
        tabBarViewControllers.append(logoutController)

        self.setViewControllers(tabBarViewControllers, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}



