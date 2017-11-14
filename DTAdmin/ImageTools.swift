//
//  ImageTools.swift
//  DTAdmin
//
//  Created by ITA student on 11/14/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

extension UIImage {
    /**
     Resize image to defined size and scale according to bitmap-based graphics context.
     - Parameters:
     - size: The size (measured in points) of the new bitmap context.
     - scale: The scale factor to apply to the bitmap.
     - returns: Image after resizing.
     */
    func convert(toSize size:CGSize, scale:CGFloat) -> UIImage {
        let imgRect = CGRect(origin: CGPoint(x:0.0, y:0.0), size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        self.draw(in: imgRect)
        guard let copied = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        UIGraphicsEndImageContext()
        return copied
    }
    static func convert(fromBase64 text: String) -> UIImage? {
        guard let dataDecoded : Data = Data(base64Encoded: text, options: .ignoreUnknownCharacters) else { return nil }
        return  UIImage(data: dataDecoded)
    }
    static func convert(fromImage image: UIImage) -> String {
        var encodeImage: String = ""
        if let imageData = UIImagePNGRepresentation(image) {
            let photo = imageData.base64EncodedString(options: .lineLength64Characters)
            encodeImage = photo
        }
        return encodeImage
    }
    
}
