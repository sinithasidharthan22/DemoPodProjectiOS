//
//  File.swift
//  
//
//  Created by GIZMEON on 07/05/21.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import MediaPlayer


public class HomeViewController: UIViewController {
//    public static let HomestoryboardVC = UIStoryboard(name: "HomeStoryBoard", bundle: Bundle.main).instantiateInitialViewController()!
    @IBOutlet var videoListingTableview: UITableView!
    @IBOutlet var LiveView: UIView!
    @IBOutlet var LivePlayingView: UIView!
    @IBOutlet var ProductCollectionView: UICollectionView!
    @IBOutlet var CategoryCollectionView: UICollectionView!
    @IBOutlet var playPauseButton: UIButton!{
        didSet{
            playPauseButton.isHidden = true
        }
    }
    @IBOutlet var backwardButton: UIButton!{
        didSet{
            self.backwardButton.addTarget(self, action: #selector(HomeViewController.rewindVideo), for: .touchUpInside)
            self.backwardButton.isHidden = true
        }
    }
    @IBOutlet var forwardButton: UIButton!{
        didSet{
            self.forwardButton.isHidden = true
            self.forwardButton.addTarget(self, action: #selector(HomeViewController.forwardVideo), for: .touchUpInside)
            
        }
    }
    @IBOutlet var muteButton: UIButton!{
        didSet{
            self.muteButton.isHidden = true
        }
    }
    @IBOutlet var videoPlayBackSlider: UISlider!{
        didSet{
            self.videoPlayBackSlider.isHidden = true
            
        }
    }
    @IBOutlet var startDurationLabel: UILabel!{
        didSet{
            self.startDurationLabel.isHidden = true
            
        }
    }
    @IBOutlet var durationLabel: UILabel!{
        didSet{
            self.durationLabel.isHidden = true
            
        }
    }
    @IBOutlet var liveViewHeight: NSLayoutConstraint!
    @IBOutlet var livePlayingViewHeight: NSLayoutConstraint!
    @IBOutlet var productCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var productDetailsView: UIView!
    @IBOutlet weak var productDetailsViewHeight: NSLayoutConstraint!
    // Initialize Models
    var categoryModel: LiveFeed?
    var productModel = [Products]()
    var videoModel : [Vod]?
    
    let imageUrl =  "https://gizmeon.s.llnwi.net/vod/thumbnails/thumbnails/"
    let showUrl =  "https://gizmeon.s.llnwi.net/vod/logo/thumbnails/"
    var productIdArray = [String]()
    var ListOfProductIds = [Int]()
    var startTimeArray = [Int]()
    var selectedProductId = Int()
    var parserLink : String?
    var ismuted = false
    var isPlaying = true
    var isSlidding = false
    let playerViewController = AVPlayerViewController()
    var avPlayer: AVPlayer? = AVPlayer(playerItem: nil)
    var playerItem: AVPlayerItem?
    var selectedIndex = IndexPath()
    var previousIndex = IndexPath()
    var previousPosition = -1
    var videoDuration = String()
    var contentPlayerLayer: AVPlayerLayer?
    var observer: Any!
    var hidevideoController = true
    var contentType = String()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        //        self.productModel.count = 0
        let bundle = Bundle(for: ProductCollectionViewCell.self)
        let nib1 = UINib(nibName: "ProductCollectionView", bundle: bundle)
        ProductCollectionView.register(nib1, forCellWithReuseIdentifier: "ProductCell")
        ProductCollectionView.delegate = self
        ProductCollectionView.dataSource = self
        ProductCollectionView.backgroundColor = .clear
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        ProductCollectionView.collectionViewLayout = layout
        let bundle1 = Bundle(for: HomeVideoTableViewCell.self)
        let nib =  UINib(nibName: "HomeVideoTableViewCell", bundle: bundle1)
        videoListingTableview.register(nib, forCellReuseIdentifier: "homecell")
        videoListingTableview.delegate = self
        videoListingTableview.dataSource = self
        self.videoListingTableview.separatorStyle = UITableViewCell.SeparatorStyle.none
        getShedule()
        getLiveFeed()
        if UIDevice.current.userInterfaceIdiom ==  UIUserInterfaceIdiom.pad
        {
            
        }
        else{
            self.productCollectionViewHeight.constant = 100.0
            self.livePlayingViewHeight.constant = 250.0
            self.liveViewHeight.constant = self.productCollectionViewHeight.constant + self.livePlayingViewHeight.constant
        }
        
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        avPlayer?.pause()
    }
    @IBAction func showViewButtonAction(_ sender: Any) {
        UIView.animate(withDuration: 1.5) {
            self.view.bringSubview(toFront: self.productDetailsView)
//            self.avPlayer?.pause()
        self.productDetailsView.center.y =  self.productDetailsView.center.y - self.productDetailsView.frame.height
        }
       
    }
//    @IBAction func hideViewButtonAction(_ sender: Any) {
//    UIView.animate(withDuration: 1.5) {
//        self.viewToAnimateOutlet.center.y += self.viewToAnimateOutlet.frame.height
//       }
//    }
    @IBAction func muteAction(_ sender: Any){
        if ismuted {
            print("muteVideo")
            muteButton.setImage(UIImage(named: "ic_mute", in: Bundle.main, compatibleWith: nil), for: .normal)
            avPlayer?.isMuted = true
            
            
        } else {
            print("unmuteVideo")
            muteButton.setImage(UIImage(named: "ic_sound", in: Bundle.main, compatibleWith: nil), for: .normal)
            
            avPlayer?.isMuted = false
        }
        
        ismuted = !ismuted
    }
    func getShedule(){
        
        ApiCommonClass.sharedInstance.fetchJSON(url: "http://api.gizmott.com/staging/api/ecommerce/videos", httpMethod: "GET", params: [:], header: [:]) { (status, data) in
            do {
                let postModels =  try JSONDecoder().decode(HomeFeed.self, from: data)
                self.videoModel = postModels.data
                Application.shared.videoModel = postModels.data
                print("list of productid",self.ListOfProductIds)
                DispatchQueue.main.async {
                    self.videoListingTableview.reloadData()
                }
            }
            catch let jsonErr {
                print("Error serializing json", jsonErr)
            }
        }
    }
    
    func getLiveFeed(){
        ApiCommonClass.sharedInstance.fetchJSON(url: "http://api.gizmott.com/staging/api/ecommerce/details?channelid=365", httpMethod: "GET", params: [:], header: ["pubid":"50029"]) { (status, data) in
            do {
                let postModels =  try JSONDecoder().decode(LiveFeed.self, from: data)
                self.categoryModel = postModels
                if  postModels.data?.products?.count != nil {
                    self.productModel = (postModels.data?.products)!
                    if self.productModel.count > 0{
                        self.ListOfProductIds = self.productModel.map({$0.product_id}) as! [Int]
                        print("list of productid",self.ListOfProductIds)
                        DispatchQueue.main.async {
                            self.productCollectionViewHeight.constant = 100.0
                            self.livePlayingViewHeight.constant = 250.0
                            self.liveViewHeight.constant = self.productCollectionViewHeight.constant + self.livePlayingViewHeight.constant
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            self.productCollectionViewHeight.constant = 0
                            self.livePlayingViewHeight.constant = 250.0
                            self.liveViewHeight.constant = self.productCollectionViewHeight.constant + self.livePlayingViewHeight.constant
                        }
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.productCollectionViewHeight.constant = 0
                        self.livePlayingViewHeight.constant = 250.0
                        self.liveViewHeight.constant = self.productCollectionViewHeight.constant + self.livePlayingViewHeight.constant
                    }
                }
                DispatchQueue.main.async {
                    if  let url = postModels.data?.url {
                        print("url",url)
                        self.setUpContentPlayer(liveLink: url, type: "Live")
                        self.contentType = "Live"
                    }
                    else{
                        self.setUpContentPlayer(liveLink: "", type: "Live")
                        self.contentType = "Live"
                    }
                    self.ProductCollectionView.reloadData()
                }
            }
            catch let jsonErr {
                print("Error serializing json", jsonErr)
            }
        }
    }
    func videoFeed(videoId:Int){
        ApiCommonClass.sharedInstance.fetchJSON(url: "http://api.gizmott.com/staging/api/ecommerce/details?video_id=\(videoId)", httpMethod: "GET", params: [:], header: ["pubid":"50029"]) { (status, data) in
            do {
                let postModels =  try JSONDecoder().decode(LiveFeed.self, from: data)
                self.categoryModel = postModels
                if  postModels.data?.products?.count != nil {
                    self.productModel = (postModels.data?.products)!
                    if self.productModel.count > 0{
                        self.ListOfProductIds = self.productModel.map({$0.product_id}) as! [Int]
                        print("list of productid",self.ListOfProductIds)
                        DispatchQueue.main.async {
                            self.productCollectionViewHeight.constant = 100.0
                            self.livePlayingViewHeight.constant = 250.0
                            self.liveViewHeight.constant = self.productCollectionViewHeight.constant + self.livePlayingViewHeight.constant
                        }
                      
                    }
                    else{
                        DispatchQueue.main.async {
                            self.productCollectionViewHeight.constant = 0
                            self.livePlayingViewHeight.constant = 250.0
                            self.liveViewHeight.constant = self.productCollectionViewHeight.constant + self.livePlayingViewHeight.constant
                        }
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.productCollectionViewHeight.constant = 0
                        self.livePlayingViewHeight.constant = 250.0
                        self.liveViewHeight.constant = self.productCollectionViewHeight.constant + self.livePlayingViewHeight.constant
                    }
                }
                DispatchQueue.main.async {
                    if  let url = postModels.data?.url {
                        self.setUpContentPlayer(liveLink: url, type: "Video")
                        self.contentType = "Video"
                    }
                    
                    self.ProductCollectionView.reloadData()
                }
                
            }
            catch let jsonErr {
                print("Error serializing json", jsonErr)
            }
        }
    }
    
    func setUpContentPlayer(liveLink:String?,type:String?) {
        
        let contentUrl = NSURL(string: liveLink!)
        let asset: AVURLAsset = AVURLAsset(url: contentUrl! as URL)
        playerItem = AVPlayerItem(asset: asset)
        avPlayer?.replaceCurrentItem(with: playerItem)
        avPlayer?.play()
        // Create a player layer for the player.
        contentPlayerLayer = AVPlayerLayer(player: avPlayer)
        contentPlayerLayer?.backgroundColor = UIColor.clear.cgColor
        contentPlayerLayer?.videoGravity=AVLayerVideoGravity.resizeAspect
        self.observer = avPlayer!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { [self] (progressTime) -> Void in
            let seconds = CMTimeGetSeconds(progressTime)
            if type == "Live"{
                self.getProductId()
                self.hideControls()
            }
            else{
                let time = Int(seconds)
                if let result = self.productModel.filter({time >= $0.start_time! && time <= $0.end_time!}).first, let position = self.productModel.firstIndex(where: {$0.product_id! == result.product_id}){
                    if position == self.previousPosition{
                    }
                    else{
                        self.selectedProductId = (self.productModel[position].product_id)!
                        self.scrollToNextCell(index: position)
                    }
                    self.previousPosition = position
                    
                }
                else{
                    self.previousPosition = -1
                    self.selectedProductId = -1
                    self.ProductCollectionView.reloadData()
                }
                let secondsString = String(format: "%02d", Int(seconds .truncatingRemainder(dividingBy: 60)))
                let minutesString = String(format: "%02d", Int(seconds / 60))
                self.startDurationLabel.text = "\(minutesString):\(secondsString)"
                if let duration = avPlayer?.currentItem?.asset.duration {
                    let seconds = CMTimeGetSeconds(duration)
                    let secondsString = String(format: "%02d", Int(seconds .truncatingRemainder(dividingBy: 60)))
                    let minutesString = String(format: "%02d", Int(seconds / 60))
                    print("Seconds :: secondsString :: minutesString \(seconds)\(secondsString)\(minutesString)")
                    self.durationLabel.text = "\(minutesString):\(secondsString)"
                }
                //lets move the slider thumb
                if(self.isSlidding == true) {
                    self.isSlidding = false
                } else {
                    if let duration = self.avPlayer?.currentItem?.duration {
                        let durationSeconds = CMTimeGetSeconds(duration)
                        self.videoPlayBackSlider.value = Float(seconds / durationSeconds)
                    }
                }
            }
        }
        contentPlayerLayer!.frame =  CGRect(x: 0, y: 0, width: view.frame.size.width , height: 250 )
        LivePlayingView.layer.addSublayer(contentPlayerLayer!)
        LivePlayingView.bringSubview(toFront: playPauseButton)
        LivePlayingView.bringSubview(toFront: forwardButton)
        LivePlayingView.bringSubview(toFront: backwardButton)
        LivePlayingView.bringSubview(toFront: muteButton)
        LivePlayingView.bringSubview(toFront: videoPlayBackSlider)
        LivePlayingView.bringSubview(toFront: startDurationLabel)
        LivePlayingView.bringSubview(toFront: durationLabel)
        playPauseButton.addTarget(self, action: #selector(playPauseAction), for: .touchUpInside)
        playPauseButton.titleLabel?.text = ""
        videoPlayBackSlider.minimumValue = 0
        videoPlayBackSlider.maximumValue = 1
        videoPlayBackSlider.isContinuous = false
        videoPlayBackSlider.addTarget(self, action: #selector(playbackSliderValueChanged), for: .valueChanged)
        self.videoPlayBackSlider.value = 0
        self.startDurationLabel.text = "00:00"
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        LivePlayingView.addGestureRecognizer(tap)
        LivePlayingView.isUserInteractionEnabled = true
    }
    
    @objc func playbackSliderValueChanged() {
        self.isSlidding = true
        if let duration = avPlayer?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(videoPlayBackSlider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            avPlayer?.seek(to: seekTime)
        }
        if isPlaying {
            avPlayer?.play()
        } else {
            avPlayer?.pause()
        }
        
    }
    @objc func playPauseAction() {
        
        if isPlaying {
            avPlayer?.pause()
            //            if let fileURL = Bundle.main.url(forResource: "play", withExtension: "txt") {
            //                // we found the file in our bundle!
            //            }
            playPauseButton.setImage(UIImage(named: "play", in: Bundle.main, compatibleWith: nil), for: .normal)
            //            .setImage(UIImage(named: "playPauseButton"), for: .normal)
        } else {
            avPlayer?.play()
            playPauseButton.setImage(UIImage(named: "pause", in: Bundle.main, compatibleWith: nil), for: .normal)
        }
        isPlaying = !isPlaying
        
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if hidevideoController {
            if contentType == "Live"{
                hideControls()
            }
            else{
                showControls()
            }
            
            self.hidevideoController = false
        }
        else{
            if contentType == "Live"{
                hideControls()
            }
            else{
                hideControls()
            }
            
            self.hidevideoController = true
        }
    }
    func showControls(){
        playPauseButton.isHidden = false
        forwardButton.isHidden = false
        backwardButton.isHidden = false
        startDurationLabel.isHidden = false
        durationLabel.isHidden = false
        videoPlayBackSlider.isHidden = false
        muteButton.isHidden = false
        
    }
    func hideControls(){
        playPauseButton.isHidden = true
        forwardButton.isHidden = true
        backwardButton.isHidden = true
        startDurationLabel.isHidden = true
        durationLabel.isHidden = true
        videoPlayBackSlider.isHidden = true
        muteButton.isHidden = true
    }
    @IBAction func rewindVideo(_ sender: Any) {
        if let currentTime = avPlayer?.currentTime() {
            var newTime = CMTimeGetSeconds(currentTime) - 10.0
            if newTime <= 0 {
                newTime = 0
            }
            avPlayer?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }
    
    @IBAction func forwardVideo(_ sender: Any) {
        if let currentTime = avPlayer?.currentTime(), let duration = avPlayer?.currentItem?.duration {
            var newTime = CMTimeGetSeconds(currentTime) + 10.0
            if newTime >= CMTimeGetSeconds(duration) {
                newTime = CMTimeGetSeconds(duration)
            }
            avPlayer?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }
   
    func getProductId(){
        ApiCommonClass.sharedInstance.fetchJSON(url: "https://giz.poppo.tv/liveecom/eventstream/ecom_365", httpMethod: "GET", params: [:], header: [:]) { (status, data) in
            do {
                let postModels =  try JSONDecoder().decode(productFeed.self, from: data)
                let productId = postModels.data?.id
                if self.selectedProductId == productId {
                    print("productid same")
                }
                else{
                    self.selectedProductId = productId!
                    if let position = self.ListOfProductIds.firstIndex(of: self.selectedProductId){
                        print("position",position)
                        self.scrollToNextCell(index: position)
                    }
                }
            }
            catch let jsonErr {
                print("Error serializing json", jsonErr)
            }
        }
    }
    
    func scrollToNextCell(index:Int){
        DispatchQueue.main.async {
            self.ProductCollectionView.reloadData()
            self.ProductCollectionView.scrollToItem(at:IndexPath(item: index, section: 0), at: .left, animated: true)
        }
        
    }
    func  showProductDetails(){
        let storyboard = UIStoryboard(name: "HomeStoryBoard", bundle: Bundle.main)
        let pvc = storyboard.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsViewController
        pvc.modalPresentationStyle = UIModalPresentationStyle.custom
        pvc.transitioningDelegate = self
        self.present(pvc, animated: true, completion: nil)
        
    }
//    public override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//    }
    
    
}
extension HomeViewController :HomeVideoTableViewCellDelegate{
    func didSelectShowVideos(passModel: Videos?) {
        if contentPlayerLayer != nil{
            self.observer =  self.avPlayer?.removeTimeObserver(observer as Any)

        }
        if passModel?.type == "LIVE"{
            print("select category")
            self.getLiveFeed()
        }
        else{
            print("select live videos")
            self.videoDuration = (passModel?.video_duration)!
            self.videoFeed(videoId: (passModel?.video_id)!)
        }
    }
}
extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoModel?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homecell", for: indexPath) as! HomeVideoTableViewCell
        if videoModel != nil{
            cell.currentIndexpath = indexPath
            cell.homevdeoCollectionView.contentOffset = .zero
            
            cell.homeButton.setTitle(videoModel?[indexPath.item].category_name, for: .normal)
            cell.channelArray = Application.shared.videoModel?[indexPath.item].videos
            
            cell.delegate = self
        }
        print("tableview scrolled",indexPath)
        return cell
        
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = (view.frame.width) / 2.3
        let height =  (4 * width) / 7
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            return height + 100
        }
        else
        {
            print("height",height)
            return height + 115
        }
        
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
}
//@available(iOS 10.0, *)
extension HomeViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productModel.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath as IndexPath) as! ProductCollectionViewCell
        if productModel.count != 0{
            if let id = productModel[indexPath.item].product_id{
                if id == self.selectedProductId {
                    self.selectedIndex = indexPath
                    cell.layer.borderWidth = 2
                    cell.layer.borderColor = UIColor.red.cgColor
                    cell.headerLabel.isHidden = false
                    
                    
                }
                else{
                    print("outside else")
                    cell.headerLabel.isHidden = true
                    cell.layer.borderColor = UIColor.clear.cgColor
                }
            }
            if let name = productModel[indexPath.item]
                .product_name{
                cell.productNameLAbel.text = name
            }
            if let image = productModel[indexPath.item]
                .product_banner {
                cell.productImage.loadImageUsingUrlString(urlString:image)
                cell.productImage.layer.cornerRadius = 8
            }
            if let price = productModel[indexPath.item].price{
                cell.productPriceLAbel.text = "$ " + price
            }
        }
        cell.backgroundColor = .clear
        cell.layer.cornerRadius = 8
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 100, height: productCollectionViewHeight.constant)
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("item clicked")

        let pvc = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsViewController
        if let id =  self.productModel[indexPath.item].product_id{
            pvc.productId = id
        }
        self.navigationController?.pushViewController(pvc, animated: false)
    }
    
}




extension HomeViewController : UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}
