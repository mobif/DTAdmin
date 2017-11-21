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
    func resize(toSize size:CGSize, scale:CGFloat) -> UIImage {
        let imgRect = CGRect(origin: CGPoint(x:0.0, y:0.0), size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        self.draw(in: imgRect)
        guard let copied = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        UIGraphicsEndImageContext()
        return copied
    }
    /**
    Convert from text encoded by Base-64 to UIImage.
     - Parameter fromBase64: Text in format Base-64.
     - Returns: Image converted from text. If text isn't convertable returns nil.
     */
    static func decode(fromBase64 text: String) -> UIImage? {
        guard let dataDecoded : Data = Data(base64Encoded: text, options: .ignoreUnknownCharacters) else { return nil }
        return  UIImage(data: dataDecoded)
    }
    /**
     Convert from Image to text in fromat Base-64.
     - Parameter fromImage: Image for encoding to text.
     - Returns: Text in format Base-64 as Strint.
     */
    static func encode(fromImage image: UIImage) -> String {
        var encodeImage: String = ""
        if let imageData = UIImagePNGRepresentation(image) {
            let photo = imageData.base64EncodedString(options: .lineLength64Characters)
            encodeImage = photo
        }
        return encodeImage
    }
}
