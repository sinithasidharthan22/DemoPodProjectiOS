//
//  ProductCollectionViewCell.swift
//  DemoPodProject
//
//  Created by GIZMEON on 09/06/21.
//

import Foundation
import Foundation
import UIKit
class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet  var productImage: CustomImageView!
    @IBOutlet  var headerLabel: UILabel!
    @IBOutlet  var productNameLAbel: UILabel!
    @IBOutlet  var productPriceLAbel: UILabel!
    @IBOutlet  var productImageHeight: NSLayoutConstraint!
    override func awakeFromNib() {
          super.awakeFromNib()
      self.layoutIfNeeded()
      
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
        }
        else{
            productImageHeight.constant = 80
        }
      }
}
