import UIKit
import cookie_manager
import WebKit

class ViewController: UIViewController,CookieManagerProtocol {
  

    @IBOutlet weak var lblCookieStatus: UILabel!
    @IBOutlet weak var label: UILabel!
    var cookieManager:CookieManager? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cookieManager = CookieManager(vc: self,delegate: self)
        lblCookieStatus.isHidden = true
    }


    @IBAction func askForPreference(_ sender: Any) {
        cookieManager?.askForPreference()
    }
    
    func onPreferenceChanged(preferenceChanged: Bool) {
        lblCookieStatus.isHidden = false
        lblCookieStatus.text = preferenceChanged ? "The user granted consent" : "The user denied consent"
    }
    
    
}

