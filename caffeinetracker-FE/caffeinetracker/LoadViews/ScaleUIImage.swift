//
//  ScaleUIImage.swift
//  caffeinetracker
//
//  Created by Gino Piccirilli on 11/25/22.
//

import Foundation
import UIKit

extension UIImage {
    
    class func scaleImageToSize(img: UIImage, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        
        img.draw(in: CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return scaledImage!
    }
}
