//
//  File.swift
//  
//
//  Created by GIZMEON on 04/06/21.
//

import Foundation
import UIKit
class CartViewController: UIViewController {
    @IBOutlet weak var cartListingCollectionView: UICollectionView!
    @IBOutlet weak var checkoutLabel: UILabel!{
        didSet{
            checkoutLabel.backgroundColor = UIColor(red: 0.322, green: 0.569, blue: 0.804, alpha: 1)
            checkoutLabel.layer.cornerRadius = 16
            
        }
    }
    @IBOutlet weak var stackView: UIStackView!{
        didSet{
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let bundle = Bundle(for: CartListCollectionviewCell.self)

        cartListingCollectionView.register(UINib(nibName: "CartListCollectionviewCell", bundle: bundle), forCellWithReuseIdentifier: "CartCell")
        cartListingCollectionView.delegate = self
        cartListingCollectionView.dataSource = self
        cartListingCollectionView.backgroundColor = .clear
        let topBorder: CALayer = CALayer()
        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: stackView.frame.size.width, height: 1.0)
        topBorder.backgroundColor = UIColor.lightGray.cgColor
        stackView.layer.addSublayer(topBorder)
    }
}
extension CartViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartCell", for: indexPath as IndexPath) as! CartListCollectionviewCell
        cell.contentView.layer.cornerRadius = 2.0;
        cell.contentView.layer.borderWidth = 2.0;
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true

        cell.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.16).cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1
        cell.layer.masksToBounds = false
//        cell.layer.shadowPath =
//            UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
    
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width , height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 0, right: 5)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 40
//    }
    
}

