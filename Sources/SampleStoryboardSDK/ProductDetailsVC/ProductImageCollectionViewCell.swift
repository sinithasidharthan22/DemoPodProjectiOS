//
//  File.swift
//  
//
//  Created by GIZMEON on 24/05/21.
//

import Foundation
import UIKit
class ProductImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet  var productImage: CustomImageView!
    @IBOutlet  var pageController: UIPageControl!{
        didSet{
            self.pageController.currentPageIndicatorTintColor = .darkGray
            self.pageController.pageIndicatorTintColor = .white
            }
    }
    @IBOutlet  var nameLabel: UILabel!
    var productThumbnail : String?  {
        didSet{
            if let image = productThumbnail{
                self.productImage.loadImageUsingUrlString(urlString: image)
                self.nameLabel.isHidden = true
                self.productImage.isHidden = false
                self.pageController.isHidden = false
            }
            }
    }
    var variantName : String?  {
        didSet{
            if let variant = variantName{
                self.nameLabel.text = variant
                self.nameLabel.isHidden = false
                self.productImage.isHidden = true
                self.pageController.isHidden = true
            }
            }
    }
    func select(){
        self.backgroundColor = .black
        self.nameLabel.textColor = .white
       }

       func deselct(){
        self.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1)
        self.nameLabel.textColor = .gray
       }
    override  func awakeFromNib() {
        self.layoutIfNeeded()
    
    }
}
