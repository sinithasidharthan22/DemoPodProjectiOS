//
//  File.swift
//  
//
//  Created by GIZMEON on 10/05/21.
//

import Foundation
import UIKit
struct HomeFeed:Decodable {
  
    let data : [Vod]?

}
struct LiveFeed:Decodable {
  
    let data : LiveModel?
    

}
struct productFeed:Decodable {
  
    let data : productIdModel?
    let type : String?

}
struct productIdModel : Decodable{
    let id : Int?
    let title : String?
}
struct ProductDeatilsFeed:Decodable {
  
    let data : ProductDetailModel?

}
struct ProductDetailModel:Decodable {
    var title : String?
    var description : String?
    var images : [String]?
    var options : [optionModel]?
    var variants : [VaraintModel]?
}
struct optionModel:Decodable {
    var name : String?
    var values : [String]?
}
struct VaraintModel : Decodable {
    var id : String?
    var price: String?
    var currencyCode : String?
    var image: String?
    var available: Bool?
    var options : [singleOptionModel]?
    
}
struct singleOptionModel:Decodable {
    var name : String?
    var value : String?
}
//struct LiveFeed:Decodable {
//    let live : [LiveModel]
//    let vod : [Vod]?
//
//}
struct LiveModel:Decodable {
    let live_link : String?
    let parser_link : String?
    let products : [Products]?
    let url : String?
}

class Products :  NSObject, NSCoding,Codable {
    
    struct Keys {
        static let product_name = "product_name"
        static let product_id = "product_id"
        static let start_time = "start_time"
        static let end_time = "end_time"
        static let price = "price"
        static let product_banner = "product_banner"


    }
    var product_name :String?
    var price : String?
    var product_banner : String?
    var product_id : Int?
    var start_time : Int?
    var end_time : Int?
    
    required init(coder decoder: NSCoder) {
        super.init()
        //super.init("", nil)
        
        if decoder.containsValue(forKey: Keys.product_name) {
            if let product_name = decoder.decodeObject(forKey: Keys.product_name) as? String { self.product_name = product_name }
        }
        if decoder.containsValue(forKey: Keys.product_id) {
            if let product_id = decoder.decodeObject(forKey: Keys.product_id) as? Int { self.product_id = product_id }
        }
        if decoder.containsValue(forKey: Keys.start_time) {
            if let start_time = decoder.decodeObject(forKey: Keys.start_time) as? Int { self.start_time = start_time }
        }
        if decoder.containsValue(forKey: Keys.end_time) {
            if let end_time = decoder.decodeObject(forKey: Keys.end_time) as? Int { self.end_time = end_time }
        }
        if decoder.containsValue(forKey: Keys.price) {
            if let price = decoder.decodeObject(forKey: Keys.price) as? String { self.price = price }
        }
        if decoder.containsValue(forKey: Keys.product_banner) {
            if let product_banner = decoder.decodeObject(forKey: Keys.product_banner) as? String { self.product_banner = product_banner }
        }

    }
    func encode(with coder: NSCoder) {
        coder.encode(product_name, forKey: Keys.product_name)
        coder.encode(product_id, forKey: Keys.product_id)
        coder.encode(start_time, forKey: Keys.start_time)
        coder.encode(end_time, forKey: Keys.end_time)
        coder.encode(price, forKey: Keys.price)
        coder.encode(product_banner, forKey: Keys.product_banner)
    }
}
struct Vod : Codable {
    let category_name : String?
    var videos :[Videos]?
}
class Application {
    static var shared = Application()
    var videoModel : [Vod]?
    var selectedTableIndex : IndexPath?
    var selectedCollectionIndex : IndexPath?

}
struct Videos:Codable {
    let video_id :Int?
    let thumbnail :String?
    let video_title :String?
    let video_duration :String?
    let type : String?
    let channel_id:Int?
    let channel_name :String?
    let logo : String?
    var selected : Bool?
   
}
