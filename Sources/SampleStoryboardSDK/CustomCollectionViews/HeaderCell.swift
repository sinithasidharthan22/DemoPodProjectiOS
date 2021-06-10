//
//  File.swift
//  
//
//  Created by GIZMEON on 27/05/21.
//

import Foundation
import UIKit
class HeaderCell: UICollectionReusableView {
    static let identifier = "HeaderCell"
    public let title: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "System Semibold", size: 16)
        return label
    }()
    public func configure(){
        addSubview(title)
    }
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        title.frame = bounds
        
    }
   
}
