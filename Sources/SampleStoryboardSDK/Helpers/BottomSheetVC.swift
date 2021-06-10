//
//  File.swift
//  
//
//  Created by GIZMEON on 24/05/21.
//

import Foundation
import UIKit
class HalfSizePresentationController : UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        get {
            guard let theView = containerView else {
                return CGRect.zero
            }
            
            return CGRect(x: 0, y: theView.bounds.height - theView.bounds.height/3, width: theView.bounds.width, height:theView.bounds.height/3 )
        }
    }
}

class CustomFlowLayout : UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let answer = super.layoutAttributesForElements(in: rect)
        for i in 1..<(answer?.count ?? 0) {
            let currentLayoutAttributes: UICollectionViewLayoutAttributes = (answer?[i])!
            let prevLayoutAttributes: UICollectionViewLayoutAttributes = (answer?[i - 1])!
            let maximumSpacing = CGFloat(15)
            let origin = prevLayoutAttributes.frame.maxX
            
            if CGFloat(origin + maximumSpacing) + currentLayoutAttributes.frame.size.width < collectionViewContentSize.width {
                var frame: CGRect = currentLayoutAttributes.frame
                frame.origin.x = CGFloat(origin + maximumSpacing)
                currentLayoutAttributes.frame = frame
            }
        }
        return answer
    }
}
