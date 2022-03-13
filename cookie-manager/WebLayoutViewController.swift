import Foundation
import WebKit

class WebLayoutViewController: UIViewController,WKScriptMessageHandler {
    
  
    public var cookieManagerDelegate : CookieManagerProtocol? = nil
    public var webView : WKWebView!
    private let name="iubenda_sdk"
    
    override func viewDidLoad() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController.add(self,name: name)
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        webView = WKWebView(frame: frame,configuration: webConfiguration)
        let url = URL(string: "https://cdn.iubenda.com/cs/test/mobile-assessment.html")
        
        let request = URLRequest(url: url!)
        self.view.addSubview(webView)
        webView.load(request)
    }
    
   
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        let body = message.body as! NSDictionary
        let funcName = body["func"]
        
        if funcName as! String == "emit" {
            let args = body["args"] as! [String?]
            emit(eventName: args[0]! , eventParameter: args[1])
        }
        
    }
    
    
    private func emit(eventName:String,eventParameter:String?) {
        if (eventName == "jsready") {
            onJsReady()
        } else if (eventName == "preferencechanged") {
            onPreferenceChanged(eventParameter: eventParameter!)
        }
    }
    
    private func onJsReady() {
        let json = "{\"text\":\"Do You Accept?\"}"
        let js = "window.setCSConfiguration(\(json))"
        self.webView.evaluateJavaScript(js)
    }
    
    private func onPreferenceChanged(eventParameter:String) {
        if let consent = getConsent(jsonString: eventParameter) {
            self.dismiss(animated: true, completion: nil)
            cookieManagerDelegate?.onPreferenceChanged(preferenceChanged: consent)
        }
        
    }
  
  private func getConsent(jsonString:String) -> Bool? {
        
        let data = Data(jsonString.utf8)

        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                return json["consent"] as? Bool
            }
        } catch let error as NSError {
            print("Json is not valid: \(error.localizedDescription)")
        }
        
        return nil
    }
  
}
