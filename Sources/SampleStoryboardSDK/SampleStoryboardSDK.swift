//struct SampleStoryboardSDK {
//    var text = "Hello, World!"
//}
import UIKit
public class SampleStoryboardSDK : UIViewController{
    public static let storyboardVC = UIStoryboard(name: "Storyboard", bundle: Bundle.main).instantiateInitialViewController()!
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
    
    @IBOutlet var Imageview: UIImageView!
    @IBOutlet var label: UILabel!
}
