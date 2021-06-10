//
//  File.swift
//  
//
//  Created by GIZMEON on 04/06/21.
//

import Foundation
import UIKit
class CartListCollectionviewCell: UICollectionViewCell {
    @IBOutlet  var productImage: CustomImageView!
    @IBOutlet  var stackView: UIStackView!{
        didSet{
            stackView.layer.cornerRadius = 2
            stackView.layer.borderColor = UIColor.blue.cgColor
            stackView.layer.borderWidth = 2
        }
    }
    @IBOutlet  var closeButton: UIButton!
    @IBOutlet  var productNameLAbel: UILabel!
    @IBOutlet  var productPriceLAbel: UILabel!
    @IBOutlet  var productImageHeight: NSLayoutConstraint!
    @IBOutlet  var productImageWidth: NSLayoutConstraint!
    @IBOutlet  var addButton: UIButton!{
        didSet{
            addButton.layer.borderWidth = 1
            addButton.layer.borderColor = UIColor.gray.cgColor
        }
    }
    @IBOutlet  var countLabel: UIButton!
    {
        didSet{
            countLabel.layer.borderWidth = 1
            countLabel.layer.borderColor = UIColor.gray.cgColor
        }
    }
    @IBOutlet  var minusButton: UIButton!
    {
        didSet{
            minusButton.layer.borderWidth = 1
            minusButton.layer.borderColor = UIColor.gray.cgColor
        }
    }

    override  func awakeFromNib() {
        self.layoutIfNeeded()
    
    }
}
