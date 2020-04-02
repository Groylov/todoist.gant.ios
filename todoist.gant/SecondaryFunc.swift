//
//  SecondaryFunc.swift
//  todoist.gant
//
//  Created by Aleksey Groylov on 03.04.2020.
//  Copyright © 2020 Aleksey Groylov. All rights reserved.
//

import Foundation
import SwiftUI

/// Loading resized image for specified parameters
/// - Parameters:
///   - imageName: named image
///   - width: new width image
///   - height: new heigth image
/// - Returns: Image of specified dimensions or nil if the image with the same name was not found
func readResizeImage(named imageName: String, _ width: CGFloat, _ height: CGFloat) -> UIImage? {
    
    let Image: UIImage? = UIImage(named: imageName)
    
    if Image != nil {
        let renderFormat = UIGraphicsImageRendererFormat.default()
        renderFormat.opaque = false
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
        let newImage = renderer.image {
                (context) in
                Image!.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        return newImage
    } else {
        return nil
    }
}
