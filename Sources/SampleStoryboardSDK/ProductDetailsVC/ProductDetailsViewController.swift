//
//  File.swift
//  
//
//  Created by GIZMEON on 24/05/21.
//

import Foundation
import UIKit
class ProductDetailsViewController: UIViewController {
    @IBOutlet var closeButton: UIButton!{
        didSet{
            self.closeButton.addTarget(self, action: #selector(ProductDetailsViewController.dismissView), for: .touchUpInside)
        }
    }
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var MainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var MainViewWidth: NSLayoutConstraint!
    @IBOutlet weak var productImageCollectionview: UICollectionView!
    @IBOutlet weak var productImageCollectionviewHeight: NSLayoutConstraint!
    @IBOutlet weak var productImageCollectionviewWidth: NSLayoutConstraint!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var variantCollectionview: UICollectionView!
    @IBOutlet weak var variantCollectionviewHeight: NSLayoutConstraint!
    @IBOutlet weak var sizeListingCollectionview: UICollectionView!
    @IBOutlet weak var sizeListingCollectionviewHeight: NSLayoutConstraint!
    @IBOutlet weak var colorHeader: UILabel!
    @IBOutlet weak var sizeHeader: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var buyNowButton: UIButton!
    var productDeatailModel : ProductDetailModel?
    var productImageArray = [String?]()
    var selectedVariants = [String:String]()
    var initialFlag = true
    var productId = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        let topBorder: CALayer = CALayer()
        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: bottomView.frame.size.width, height: 1.0)
        topBorder.backgroundColor = UIColor.lightGray.cgColor
        bottomView.layer.addSublayer(topBorder)
        let bundle = Bundle(for: ProductCollectionViewCell.self)
        productImageCollectionview.register(UINib(nibName: "ProductImageCollectionView", bundle:bundle), forCellWithReuseIdentifier: "ProductImageCollectionViewCell")
        productImageCollectionview.delegate = self
        productImageCollectionview.dataSource = self
        productImageCollectionview.backgroundColor = .clear
        productImageCollectionview.isPagingEnabled = true
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        productImageCollectionview.collectionViewLayout = layout
        productImageCollectionview?.register(HeaderCell.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderCell.identifier")
        let bundle1 = Bundle(for: ProductCollectionViewCell.self)
        variantCollectionview.register(UINib(nibName: "ProductImageCollectionView", bundle:bundle1), forCellWithReuseIdentifier: "ProductImageCollectionViewCell")
        variantCollectionview.delegate = self
        variantCollectionview.dataSource = self
        variantCollectionview.backgroundColor = .clear
        variantCollectionview?.register(HeaderCell.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderCell.identifier")
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        variantCollectionview.collectionViewLayout = flowLayout
        self.getShedule()
        if UIDevice.current.userInterfaceIdiom ==  UIUserInterfaceIdiom.pad
        {
            
        }
        else{
            self.MainViewWidth.constant = view.frame.width
            self.productImageCollectionviewWidth.constant = view.frame.width - 50
            
        }
    }
    //Api call for get productDetails
    // @param productId
    func getShedule(){
        ApiCommonClass.sharedInstance.fetchJSON(url: "http://api.gizmott.com/staging/api/ecommerce/shopify/product/76", httpMethod: "GET", params: [:], header: ["pubid":"50029"]) { [self] (status, data) in
            do {
                let postModels =  try JSONDecoder().decode(ProductDeatilsFeed.self, from: data)
                if let details = postModels.data{
                    self.productDeatailModel = details
                }
                DispatchQueue.main.async {
                    if let name = self.productDeatailModel?.title{
                        self.productNameLabel.text = name
                    }
                    if let description = self.productDeatailModel?.description{
                        self.productDescriptionLabel.text = description
                    }
                    self.productImageCollectionview.reloadData()
                    self.variantCollectionview.reloadData()
                    self.getvariantFromAttributes()
                }
            }
            catch let jsonErr {
                print("Error serializing json", jsonErr)
            }
        }
    }
    //update data with selection of variants
    func getvariantFromAttributes(){
        self.productImageArray.removeAll()
        if self.productDeatailModel != nil{
            if  let array = productDeatailModel?.variants!.filter({
                var variantDictionary = [String:String]()
                $0.options?.forEach({ (item) in
                    variantDictionary[item.name!] = item.value
                })
                return variantDictionary == selectedVariants
            }){
                if !array.isEmpty{
                    self.productImageArray.append(array[0].image)
                    self.productPriceLabel.text = String(format:"%@  %@",array[0].currencyCode!,array[0].price!)
                    self.productImageCollectionview.reloadData()
                }
            }
        }
    }
    //close view
    @objc func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addToCartFunction(_sender : AnyObject){
      print("Add to cart function")
        ApiCommonClass.sharedInstance.fetchJSON(url: "http://api.gizmott.com/staging/api/ecommerce/shopify/product/76", httpMethod: "GET", params: [:], header: ["pubid":"50029"]) { [self] (status, data) in
            do {
                let postModels =  try JSONDecoder().decode(ProductDeatilsFeed.self, from: data)
                if let details = postModels.data{
                    self.productDeatailModel = details
                }
                DispatchQueue.main.async {
                    if let name = self.productDeatailModel?.title{
                        self.productNameLabel.text = name
                    }
                    if let description = self.productDeatailModel?.description{
                        self.productDescriptionLabel.text = description
                    }
                    self.productImageCollectionview.reloadData()
                    self.variantCollectionview.reloadData()
                    self.getvariantFromAttributes()
                }
            }
            catch let jsonErr {
                print("Error serializing json", jsonErr)
            }
        }
        
    }
    @IBAction func BuyNowFunction(_sender : AnyObject){
        let pvc = storyboard?.instantiateViewController(withIdentifier: "cartVC") as! CartViewController
        self.present(pvc, animated: true, completion: nil)
        print("Buy now function")
    }
    //calculating text size of each varient item
    func textWidth(text: String, font: UIFont?) -> CGFloat {
        let attributes = font != nil ? [NSAttributedString.Key.font: font!] : [:]
        return text.size(withAttributes: attributes).width
    }
}
extension ProductDetailsViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == productImageCollectionview{
            return 1
        }
        else{
            if productDeatailModel != nil{
                return (self.productDeatailModel?.options!.count)!
            }
            return 0
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productImageCollectionview{
            return self.productImageArray.count
        }
        else{
            if productDeatailModel != nil{
                return self.productDeatailModel!.options![section].values!.count
            }
            return 0
        }
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        _ = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCollectionViewCell", for: indexPath as IndexPath) as! ProductImageCollectionViewCell
        if collectionView == productImageCollectionview{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCollectionViewCell", for: indexPath as IndexPath) as! ProductImageCollectionViewCell
            if let image = self.productImageArray[indexPath.item]{
                cell.productThumbnail = image
            }
            if self.productImageArray.count !=  0 {
                cell.pageController.numberOfPages = (self.productImageArray.count)
                cell.pageController.isHidden = !( (self.productImageArray.count) > 1)
                cell.pageController.currentPage = indexPath.item
                cell.pageController.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
            return cell
        }
        
        else{
            if initialFlag{
                productDeatailModel!.options?.forEach({ (item) in
                    self.selectedVariants[item.name!] = item.values![0]
                    getvariantFromAttributes()
                })
                print("selected variants",selectedVariants)
                self.initialFlag = false
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCollectionViewCell", for: indexPath as IndexPath) as! ProductImageCollectionViewCell
            if self.productDeatailModel!.options![indexPath.section].name == "Size"{
                cell.layer.cornerRadius = 50/2
            }
            else{
                cell.layer.cornerRadius = 0
            }
            cell.variantName = productDeatailModel!.options![indexPath.section].values![indexPath.item]
            cell.deselct()  // Call subclassed cell method.
            if selectedVariants.values.contains(productDeatailModel!.options![indexPath.section].values![indexPath.item]) {
                cell.select()
            }
            self.variantCollectionviewHeight.constant = self.variantCollectionview.contentSize.height
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == productImageCollectionview{
            
        }
        else{
            variantCollectionview.allowsMultipleSelection = false
            if let cell = collectionView.cellForItem(at: indexPath) as! ProductImageCollectionViewCell?{
                let indexPathData = NSKeyedArchiver.archivedData(withRootObject: indexPath)
                UserDefaults.standard.set(indexPathData,forKey: "backgroundIndexPath")
                variantCollectionview.reloadData() //update all cells. It could be heavy if you have many cells.
                if let key = productDeatailModel!.options![indexPath.section].name, let value = cell.variantName {
                    self.selectedVariants[key] = value
                }
            }
            print("selected Array",selectedVariants)
            getvariantFromAttributes()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == productImageCollectionview{
            return CGSize(width: view.frame.width - 10, height: productImageCollectionviewHeight.constant)
        }
        else{
            if self.productDeatailModel!.options![indexPath.section].name == "Size"{
                return CGSize(width: 50 , height: 50)
            }
            else{
                let width = self.textWidth(text: self.productDeatailModel!.options![indexPath.section].values![indexPath.item], font: UIFont.systemFont(ofSize: 12)) + 30
                return CGSize(width: width + 10 , height: 40)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind:
                            String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:
                                                                        "HeaderCell.identifier", for: indexPath) as! HeaderCell
        header.title.text = productDeatailModel!.options![indexPath.section].name
        header.configure()
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == variantCollectionview{
            return CGSize(width: view.frame.size.width, height: 40)
        }
        else {
            return CGSize(width: 0, height: 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == productImageCollectionview{
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        }
        else{
            return UIEdgeInsets(top: 10, left: 8, bottom: 5, right: 8)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == productImageCollectionview{
            return 10
        }
        else{
            return 10
        }
    }
}
