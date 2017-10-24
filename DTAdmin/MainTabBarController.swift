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
        
//MARK: Create students tab
        let studentsTab = UINavigationController()
        studentsTab.setViewControllers([StudentViewController()], animated: true)
        let studentsBarItem = UITabBarItem(title: "Students", image: nil, selectedImage: nil)
        studentsTab.tabBarItem = studentsBarItem

//MARK: Create subjects tab
        let subjectsTab = TabTwoViewController()
        let subjectsBarItem = UITabBarItem(title: "Subjects", image: nil, selectedImage: nil)
        subjectsTab.tabBarItem = subjectsBarItem

//MARK: Create groups tab
        let groupsTab = UINavigationController()
        groupsTab.setViewControllers([TabThreeViewController()], animated: true)
        let groupsBarItem = UITabBarItem(title: "Groups", image: nil, selectedImage: nil)
        groupsTab.tabBarItem = groupsBarItem
        
//MARK: Create faculty tab
        let facultyTab = TabFourViewController()
        let facultyBarItem = UITabBarItem(title: "Faculty", image: nil, selectedImage: nil)
        facultyTab.tabBarItem = facultyBarItem

//MARK: Create speciality tab
        let specialityTab = UINavigationController()
        specialityTab.setViewControllers([TabFiveViewController()], animated: true)
        let specialityBarItem = UITabBarItem(title: "Speciality", image: nil, selectedImage: nil)
        specialityTab.tabBarItem = specialityBarItem
        
//MARK: Create admins tab
        let adminsTab = TabSixViewController()
        let adminsBarItem = UITabBarItem(title: "Admins", image: nil, selectedImage: nil)
        adminsTab.tabBarItem = adminsBarItem
        
        
        self.viewControllers = [studentsTab, subjectsTab, groupsTab, facultyTab, specialityTab, adminsTab]
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

class TabTwoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blue
        self.title = "Subjects"
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

class TabSixViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        self.title = "Admins"
    }
}

