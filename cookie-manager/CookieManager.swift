import Foundation
import SwiftUI
import UIKit
import WebKit


public class CookieManager {
    
    public var delegate : CookieManagerProtocol
    public var vc : UIViewController
    
    public init(vc:UIViewController,delegate:CookieManagerProtocol) {
        self.vc = vc
        self.delegate = delegate
    }
    
    public func askForPreference() {
       
        let storyBoard: UIStoryboard = UIStoryboard(name: "WebLayoutStoryboard", bundle: .init(identifier: "com.assesment.cookie-manager"))
        let webLayoutViewController = storyBoard.instantiateViewController(withIdentifier: "WebLayoutViewController") as! WebLayoutViewController
        webLayoutViewController.cookieManagerDelegate = delegate
        webLayoutViewController.modalPresentationStyle = .fullScreen
        vc.present(webLayoutViewController, animated: true, completion: nil)
    }
  
    
}
