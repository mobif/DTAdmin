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
        let studentStoryboard = UIStoryboard(name: "Student", bundle: nil)
        guard let studentNavigationController = studentStoryboard.instantiateViewController(withIdentifier: "StudentNavigationController") as? UINavigationController else { return }
        let titleText = NSLocalizedString("Students", comment: "List all students")
        let studentBarItem = UITabBarItem(title: titleText, image: nil, selectedImage: nil)
        studentNavigationController.tabBarItem = studentBarItem
        tabBarViewControllers.append(studentNavigationController)

//MARK: Create subjects tab
        let subjectStoryboard = UIStoryboard.stoyboard(by: .subject)
        guard let subjectNavController = subjectStoryboard.instantiateViewController(withIdentifier: "SubjectNavController") as? UINavigationController else { return }
        let subjectBarItem = UITabBarItem(title: "Subjects", image: nil, selectedImage: nil)
        subjectNavController.tabBarItem = subjectBarItem
        tabBarViewControllers.append(subjectNavController)

//MARK: Create groups tab
        let groupStoryboard = UIStoryboard.stoyboard(by: .group)
        guard let groupNavController = groupStoryboard.instantiateViewController(withIdentifier: "GroupNavController") as? UINavigationController else { return }
//        let groupsTab = TabThreeViewController()
        let groupsBarItem = UITabBarItem(title: "Groups", image: nil, selectedImage: nil)
        groupNavController.tabBarItem = groupsBarItem
        tabBarViewControllers.append(groupNavController)
        
//MARK: Create faculty tab
        let facultyTab = TabFourViewController()
        let facultyBarItem = UITabBarItem(title: "Faculty", image: nil, selectedImage: nil)
        facultyTab.tabBarItem = facultyBarItem
        tabBarViewControllers.append(facultyTab)

//MARK: Create speciality tab
        let specialityTab = TabFiveViewController()
        let specialityBarItem = UITabBarItem(title: "Speciality", image: nil, selectedImage: nil)
        specialityTab.tabBarItem = specialityBarItem
        tabBarViewControllers.append(specialityTab)
        
//MARK: Create admins tab
        let adminStoryboard = UIStoryboard.stoyboard(by: .admin)
        guard let adminsNavController = adminStoryboard.instantiateViewController(withIdentifier: "AdminListView") as? UINavigationController else { return }
        let adminsBarItem = UITabBarItem(title: "Admins", image: nil, selectedImage: nil)
        adminsNavController.tabBarItem = adminsBarItem
        tabBarViewControllers.append(adminsNavController)
        
//MARK: Create timeTable tab
        let timeTableStoryboard = UIStoryboard.stoyboard(by: .timeTable)
        guard let timeTableNavController = timeTableStoryboard.instantiateViewController(withIdentifier: "timeTableNavController") as? UINavigationController else { return }
        let timeTableBarItem = UITabBarItem(title: "Time Table", image: nil, selectedImage: nil)
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

