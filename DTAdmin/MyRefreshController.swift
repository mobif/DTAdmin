//
//  MyRefreshController.swift
//  DTAdmin
//
//  Created by ITA student on 11/20/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class MyRefreshController: UIRefreshControl {

    private func applyStyle() {
        self.tintColor = UIColor(red: 1.0, green: 0.21, blue: 0.55, alpha: 0.5)
        self.attributedTitle = NSAttributedString(string:
                                                    NSLocalizedString("Pull to refresh", comment: "Pull to refresh"))
    }

     override init() {
        super.init()
        self.applyStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.applyStyle()
    }


}
