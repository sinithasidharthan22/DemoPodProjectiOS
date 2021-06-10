//
//  File.swift
//  
//
//  Created by GIZMEON on 10/05/21.
//

import Foundation
import UIKit
protocol HomeVideoTableViewCellDelegate:class {
    func didSelectShowVideos(passModel :Videos?)
}
class HomeVideoTableViewCell: UITableViewCell{
    //    0128oCollectionView: UICollectionView!
    @IBOutlet  var homevdeoCollectionView: UICollectionView!
    @IBOutlet  var homeButton: UIButton!
    weak var delegate: HomeVideoTableViewCellDelegate!
    var channelType = ""
    var selectedIndex = IndexPath()
    var currentIndexpath = IndexPath()
    var channelArray: [Videos]? {
        didSet{
            homevdeoCollectionView.reloadData()
            self.layoutIfNeeded()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        let bundle = Bundle(for: HomeVideoCollectionViewCell.self)
        homevdeoCollectionView.register(UINib(nibName: "HomeVideoCollectionViewCell", bundle: bundle
        ), forCellWithReuseIdentifier: "homeCollectionViewCell")
        homevdeoCollectionView.delegate = self
        homevdeoCollectionView.dataSource = self
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        homevdeoCollectionView.reloadData()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension HomeVideoTableViewCell :UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if channelArray?.count != nil{
            return channelArray!.count
        }
        else{
            return 3
        }
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionViewCell", for: indexPath as IndexPath) as! HomeVideoCollectionViewCell
        cell.backgroundColor = .clear
        cell.videoImage.contentMode = .scaleToFill
        cell.video = channelArray?[indexPath.item]
        
        if channelArray != nil{
            if let selected = self.channelArray?[indexPath.item].selected,selected == true{
                cell.select()
            }
            else{
                cell.deSelect()
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (frame.width) / 1.8
        let height =  (4 * width) / 5
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            return CGSize(width: width - 20, height: height)
        } else {
            return CGSize(width: width - 20, height: height)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 10, bottom: 5, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _ = collectionView.cellForItem(at: indexPath) as! HomeVideoCollectionViewCell
        if let selectedCollectionIndex = Application.shared.selectedCollectionIndex{
            if let selectedTableIndex = Application.shared.selectedTableIndex, let superview = self.tableView {
                
                if  selectedTableIndex != currentIndexpath {
                    Application.shared.videoModel?[selectedTableIndex.row].videos?[selectedCollectionIndex.item].selected = false
                    superview.reloadRows(at: [selectedTableIndex], with: .none)
                }
                else{
                    Application.shared.videoModel?[selectedTableIndex.row].videos?[selectedCollectionIndex.item].selected = false
                    self.channelArray?[selectedCollectionIndex.item].selected = false
                }
            }
        }
        if let row = self.channelArray!.firstIndex(where: {$0.video_id == channelArray![indexPath.item].video_id}) {
            channelArray![row].selected = true
            Application.shared.videoModel?[currentIndexpath.row].videos?[indexPath.item].selected = true
            Application.shared.selectedTableIndex = currentIndexpath
            Application.shared.selectedCollectionIndex = indexPath
        }
        delegate.didSelectShowVideos(passModel: channelArray![indexPath.item])
    }
}
extension UIView {
    func parentView<T: UIView>(of type: T.Type) -> T? {
        guard let view = superview else {
            return nil
        }
        return (view as? T) ?? view.parentView(of: T.self)
    }
}
extension UITableViewCell {
    var tableView: UITableView? {
        return parentView(of: UITableView.self)
    }
}
