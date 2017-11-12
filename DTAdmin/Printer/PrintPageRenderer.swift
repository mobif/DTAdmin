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
  
  //MARK: For setuping and drawing header
//  override func drawHeaderForPage(at pageIndex: Int, in headerRect: CGRect) {
//    // Specify the header text.
//    let headerText: NSString = "Дані університету"
//
//    // Set the desired font.
//    guard let font = UIFont(name: "Times New Roman", size: 14.0) else {
//      assertionFailure("Font for header page fail")
//      return
//    }
//
//    // Specify some text attributes we want to apply to the header text.
//    let textAttributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.black] as [NSAttributedStringKey: AnyObject]
//
//    // Calculate the text size.
////    let textSize = getTextSize(text: headerText as String, font: font,
////                               textAttributes: textAttributes)
//    let textSize = getTextSize(text: headerText as String, font: font)
//
//    // Determine the offset to the right side.
//    let offsetX: CGFloat = 20.0
//
//    // Specify the point that the text drawing should start from.
//    let pointX = headerRect.size.width - textSize.width - offsetX
//    let pointY = headerRect.size.height/2 - textSize.height/2
//
//    // Draw the header text.
//    headerText.draw(at: CGPoint(x: pointX, y: pointY), withAttributes: textAttributes)
//  }
//
//  override func drawFooterForPage(at pageIndex: Int, in footerRect: CGRect) {
//    let footerText: NSString = "© Yurii Krupa :D"
//
//    guard let font = UIFont(name: "Times New Roman", size: 14.0) else {
//      assertionFailure("Font for footer page fail")
//      return
//    }
//
//    let textSize = getTextSize(text: footerText as String, font: font)
//
//    let centerX = footerRect.size.width/2 - textSize.width/2
//    let centerY = footerRect.origin.y + self.footerHeight/2 - textSize.height/2
//    //Light Gray color
//    let attributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor(red: 205.0/255.0, green: 205.0/255.0, blue: 205.0/255, alpha: 1.0)]
//
//    footerText.draw(at: CGPoint(x: centerX, y: centerY), withAttributes: attributes)
//
//
//    // Draw a horizontal line.
//    let lineOffsetX: CGFloat = 20.0
//    let context = UIGraphicsGetCurrentContext()
//    context!.setStrokeColor(red: 205.0/255.0, green: 205.0/255.0,
//                            blue: 205.0/255, alpha: 1.0)
//    context!.move(to: CGPoint(x: lineOffsetX, y: footerRect.origin.y))
//    context!.addLine(to: CGPoint(x: footerRect.size.width - lineOffsetX, y: footerRect.origin.y))
//    context!.strokePath()
//  }
  
  func getTextSize(text: String, font: UIFont!, textAttributes: [NSAttributedStringKey: AnyObject]! = nil) -> CGSize {
    let testLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.paperRect.size.width, height: footerHeight))
    if let attributes = textAttributes {
      testLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
    else {
      testLabel.text = text
      testLabel.font = font!
    }
    
    testLabel.sizeToFit()
    
    return testLabel.frame.size
  }
  
}
