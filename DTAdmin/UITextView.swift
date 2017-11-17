//
//  UITextView.swift
//  DTAdmin
//
//  Created by ITA student on 11/17/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class MyTextView: UITextView {
    private func applyStyle() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.applyStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.applyStyle()
    }
}

