//
//  MySearchController.swift
//  DTAdmin
//
//  Created by ITA student on 11/23/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class MySearchController: UISearchController {

    func configure() {
        self.obscuresBackgroundDuringPresentation = false
        self.searchBar.placeholder = NSLocalizedString("Search", comment: "Placeholder for searchController")
    }

    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return self.searchBar.text?.isEmpty ?? true
    }

    func isFiltering() -> Bool {
        return self.isActive && !searchBarIsEmpty()
    }

}

