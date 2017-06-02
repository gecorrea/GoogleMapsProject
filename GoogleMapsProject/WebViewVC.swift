import UIKit
import WebKit

class WebViewVC: UIViewController, WKNavigationDelegate {
    
    var theWeb : WKWebView!
    
    @IBOutlet weak var mapButton: UIButton!
    
    var urlString = String()
    
    override func viewDidLoad() {
        let configuration = WKWebViewConfiguration()
        theWeb = WKWebView(frame: UIScreen.main.bounds, configuration: configuration)
        view.insertSubview(theWeb, at: 0)
        theWeb.navigationDelegate = self
        self.goToWeb(urlString: urlString)
        theWeb.allowsBackForwardNavigationGestures = true
    }
    
    func goToWeb(urlString: String) {
        if let url = URL(string: urlString) {
            DispatchQueue.main.async {
                let urlRequest = URLRequest(url: url)
                self.theWeb.load(urlRequest)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        mapButton.isHidden = false
    }
    
    @IBAction func backToMap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
