//
//  File.swift
//  
//
//  Created by GIZMEON on 07/05/21.
//

import Foundation
import UIKit
class HomeVideoCollectionViewCell: UICollectionViewCell {
    @IBOutlet  var videoImage: CustomImageView!
    @IBOutlet  var videoImageHieght: NSLayoutConstraint!
    @IBOutlet  var videoNameLabel: UILabel!
    @IBOutlet  var durationLabel: UILabel!
    @IBOutlet  var overlayView: UIView!{
        didSet{
            overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        }
    }
    @IBOutlet  var liveLabel: UIButton!{
        didSet{
            liveLabel.layer.cornerRadius = 8
        }
    }
    var selctedIndexpath : String?
    var video : Videos?  {
        didSet{
            if let video = video{
                if let image = video.thumbnail{
                    self.videoImage.loadImageUsingUrlString(urlString: String(image))
                }
                if let videoTitle = video.video_title{
                    self.videoNameLabel.text = videoTitle
                }
                if let duartion = video.video_duration{
                    self.durationLabel.text = duartion
                    self.durationLabel.isHidden = false
                }
                if let selected = video.selected {
                    if selected{
                        self.videoImage.layer.borderWidth = 5
                        self.videoImage.layer.borderColor = UIColor(hexString: "#FF7F42").cgColor
                    }
                    else{
                        self.videoImage.layer.borderWidth = 5
                        self.videoImage.layer.borderColor = UIColor.clear.cgColor
                    }
                }
                if let type = video.type{
                    if type == "LIVE"{
                        self.liveLabel.isHidden = false
                    }
                    else{
                        self.liveLabel.isHidden = true
                    }
                }
            }
        }
    }
    func select(){
        self.overlayView.isHidden = false
        self.videoImage.layer.borderWidth = 5
        self.videoImage.layer.borderColor = UIColor(hexString: "#FF7F42").cgColor
        
    }
    func deSelect(){
        self.overlayView.isHidden = true
        self.videoImage.layer.borderWidth = 5
        self.videoImage.layer.borderColor = UIColor.clear.cgColor
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
    }
    
}





extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
