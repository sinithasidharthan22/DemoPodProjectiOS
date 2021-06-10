//
//  File.swift
//  
//
//  Created by GIZMEON on 10/05/21.
//

import Foundation
import SystemConfiguration
public class ApiCommonClass
{
    static let sharedInstance = ApiCommonClass()
    
    
    // fetch json
    
    let baseUrl: String = "http://localhost:9090/"
    func fetchJSON(url: String, httpMethod: String, params:[String:Any] ,header:[String:String], completionHandler:@escaping (_ status:String,_ data :Data) -> Void){
        var request = URLRequest(url: URL(string: url)!)
        print("request = \(request)")
        request.httpMethod = httpMethod
        request.allHTTPHeaderFields = header
        request.httpBody = params.percentEncoded()
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            guard let dataResponse = data,
                  error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                return
            }
            completionHandler("Success", dataResponse)
        })
        task.resume()
    }
    
    
func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}





extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}




