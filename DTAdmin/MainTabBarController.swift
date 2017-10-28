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
        
// Create students tab
        let studentsTab = TabOneViewController()
        let studentsBarItem = UITabBarItem(title: "Students", image: nil, selectedImage: nil)
        studentsBarItem.image = UIImage(named: "ic_person_outline_white")
        studentsTab.tabBarItem = studentsBarItem
        tabBarViewControllers.append(studentsTab)

// Create subjects tab
        let subjectsTab = TabTwoViewController()
        let subjectsBarItem = UITabBarItem(title: "Subjects", image: nil, selectedImage: nil)
        subjectsBarItem.image = UIImage(named: "ic_subject_white")
        subjectsTab.tabBarItem = subjectsBarItem
        tabBarViewControllers.append(subjectsTab)

// Create groups tab
        let groupsTab = TabThreeViewController()
        let groupsBarItem = UITabBarItem(title: "Groups", image: nil, selectedImage: nil)
        groupsBarItem.image = UIImage(named: "ic_supervisor_account_white")
        groupsTab.tabBarItem = groupsBarItem
        tabBarViewControllers.append(groupsTab)
        
// Create faculty tab
        let facultyTab = TabFourViewController()
        let facultyBarItem = UITabBarItem(title: "Faculty", image: nil, selectedImage: nil)
        facultyBarItem.image = UIImage(named: "ic_account_balance_white")
        facultyTab.tabBarItem = facultyBarItem
        tabBarViewControllers.append(facultyTab)

// Create speciality tab
        let specialityTab = TabFiveViewController()
        let specialityBarItem = UITabBarItem(title: "Speciality", image: nil, selectedImage: nil)
        specialityBarItem.image = UIImage(named: "ic_subject_white")
        specialityTab.tabBarItem = specialityBarItem
        tabBarViewControllers.append(specialityTab)
        
// Create admins tab
        let adminStoryboard = UIStoryboard.init(name: "Admin", bundle: nil)
        guard let adminsNavController = adminStoryboard.instantiateViewController(withIdentifier: "AdminListView") as? UINavigationController else { return }
        let adminsBarItem = UITabBarItem(title: "Admins", image: nil, selectedImage: nil)
        adminsBarItem.image = UIImage(named: "ic_subject_white")
        adminsNavController.tabBarItem = adminsBarItem
        tabBarViewControllers.append(adminsNavController)
        
// Create timeTable tab
        let timeTableStoryboard = UIStoryboard.init(name: "TimeTable", bundle: nil)
        guard let timeTableNavController = timeTableStoryboard.instantiateViewController(withIdentifier: "timeTableNavController") as? UINavigationController else { return }
        let timeTableBarItem = UITabBarItem(title: "Time Table", image: nil, selectedImage: nil)
        timeTableBarItem.image = UIImage(named: "ic_subject_white")
        timeTableNavController.tabBarItem = timeTableBarItem
        tabBarViewControllers.append(timeTableNavController)
        
        self.setViewControllers(tabBarViewControllers, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
//MARK: UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let title = viewController.title {
            print("Selected \(title)")
        }
        if let navTitle = (viewController as? UINavigationController)?.viewControllers.first?.title {
            print("Selected \(navTitle)")
        }
    }
}

//MARK: temp view controllers for test
class TabOneViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blue
        self.title = "Students"
    }
}

class TabThreeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        self.title = "Groups"
    }
}

class TabFourViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blue
        self.title = "Faculty"
    }
}

class TabFiveViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        self.title = "Speciality"
    }
}

