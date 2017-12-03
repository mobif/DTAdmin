//
//  PrintPageRenderer.swift
//  DTAdmin
//
//  Created by Yurii Krupa on 11/5/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class PrintPageRenderer: UIPrintPageRenderer {
    
    let A4PageWidth: CGFloat = 595.2
    
    let A4PageHeight: CGFloat = 841.8
    
    
    override init() {
        super.init()
        
        // Specify the frame of the A4 page.
        let pageFrame = CGRect(x: 10.0, y: 0.0, width: A4PageWidth, height: A4PageHeight)
        
        // Set the page frame.
        self.setValue(NSValue(cgRect: pageFrame), forKey: "paperRect")
        
        // Set the horizontal and vertical insets (that's optional).
        self.setValue(NSValue(cgRect: pageFrame.insetBy(dx: 10.0, dy: 10.0)), forKey: "printableRect")
        
        
        self.headerHeight = 20.0
        self.footerHeight = 20.0
    }
    
    func getTextSize(text: String, font: UIFont, textAttributes: [NSAttributedStringKey: AnyObject]! = nil) -> CGSize {
        let testLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.paperRect.size.width, height: footerHeight))
        if let attributes = textAttributes {
            testLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
        } else {
            testLabel.text = text
            testLabel.font = font
        }
        
        testLabel.sizeToFit()
        
        return testLabel.frame.size
    }
    
}
