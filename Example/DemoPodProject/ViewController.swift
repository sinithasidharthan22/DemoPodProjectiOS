//
//  ViewController.swift
//  DemoPodProject
//
//  Created by 35226835 on 06/08/2021.
//  Copyright (c) 2021 35226835. All rights reserved.
//

import UIKit
import DemoPodProject

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "HomeStoryBoard", bundle: Bundle(for: HomeViewController.self))
        if let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as? HomeViewController{
       
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
