//
//  UIBuilder.swift
//  Black
//
//  Created by Jinu Kim on 27/01/2017.
//  Copyright © 2017 Christudio. All rights reserved.
//

import UIKit
import Social

class UIBuilder: NSObject {
    var viewControllers: [String : UIViewController] = [:]
    var currentViewController: String = ""
    
    func buildButton(target: UIButton?, title: String, titleColor: String, imageName: String, backgroundColor: String, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UIButton {
        var button: UIButton = UIButton()
        if target != nil {
            button = target!
        }
        button.setTitle(title, for: UIControlState.normal)
        if titleColor == "blue" {
            button.setTitleColor(button.tintColor, for: UIControlState.normal)
        } else {
            button.setTitleColor(self.hexToUIColor(titleColor), for: UIControlState.normal)
        }
        button.setTitleShadowColor(UIColor.clear, for: UIControlState.normal)
        button.frame = CGRect(x: x, y: y, width: width, height: height)
        
        if imageName != "" {
            button.setImage(UIImage(named: imageName), for: UIControlState.normal)
        }
        if backgroundColor != "" {
            button.backgroundColor = self.hexToUIColor(backgroundColor)
        }
        
        return button
    }
    
    func buildLabel(target: UILabel?, text: String, color: String, textAlignment: NSTextAlignment, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UILabel {
        var label: UILabel = UILabel()
        if target != nil {
            label = target!
        }
        label.text = text
        label.textColor = self.hexToUIColor(color)
        label.textAlignment = textAlignment
        label.frame = CGRect(x: x, y: y, width: width, height: height)
        
        return label
    }
    
    func buildTextField(target: UITextField?, placeholder: String, keyboardType: UIKeyboardType, returnKeyType: UIReturnKeyType, autocorrectionType: UITextAutocorrectionType, autocapitalizationType: UITextAutocapitalizationType, secureTextEntry: Bool, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, text: String, color: String, tintColor: String, clearButtonMode: UITextFieldViewMode) -> UITextField {
        var textField: UITextField = UITextField()
        if target != nil {
            textField = target!
        }
        textField.keyboardType = keyboardType
        textField.returnKeyType = returnKeyType
        textField.autocorrectionType = autocorrectionType
        textField.autocapitalizationType = autocapitalizationType
        textField.isSecureTextEntry = secureTextEntry
        textField.placeholder = placeholder
        textField.frame = CGRect(x: x, y: y, width: width, height: height)
        
        textField.textColor = self.hexToUIColor(color)
        textField.tintColor = self.hexToUIColor(tintColor)
        textField.clearButtonMode = clearButtonMode
        textField.text = text
        return textField
    }
    
    func buildImageView(target: UIImageView?, image: String, contentMode: UIViewContentMode, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UIImageView {
        var uiImage: UIImage?
        if image != "" {
            uiImage = UIImage(named: image)
        }
        var imageView: UIImageView = UIImageView()
        if target != nil {
            imageView = target!
        }
        imageView.image = uiImage
        imageView.contentMode = contentMode
        imageView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        return imageView
    }
    
    func buildCosmosView(target: CosmosView?, fillMode: Int, starSize: Double, filledColor: String, emptyColor: String, filledBorderColor: String, emptyBorderColor: String) -> CosmosView {
        //기본 rating은 0으로 자동설정해둠. 나중에 파라미터 추가해서 바꿔주던지 하고.
        //intrinsicContentSize로 자동 설정해둠. frame은 자체 참조가 필요해서 포함시키지 않음.
        
        var cosmosView: CosmosView = CosmosView()
        if target != nil {
            cosmosView = target!
        }
        
        cosmosView.rating = 0
        cosmosView.minTouchRating = 0.5
        cosmosView.totalStars = 5
        
        cosmosView.fillMode = fillMode
        cosmosView.starSize = starSize
        cosmosView.filledColor = self.hexToUIColor(filledColor)
        cosmosView.emptyColor = self.hexToUIColor(emptyColor)
        cosmosView.filledBorderColor = self.hexToUIColor(filledBorderColor)
        cosmosView.emptyBorderColor = self.hexToUIColor(emptyBorderColor)
        cosmosView.frame.size = cosmosView.intrinsicContentSize
        
        return cosmosView
    }
    
    func hexToUIColor(_ hex:String) -> UIColor {
        if hex == "" {
            return UIColor.clear
        } else {
            var cString:String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
            
            if (cString.hasPrefix("#")) {
                cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 1))
            }
            
            if ((cString.characters.count) != 6) {
                return UIColor.red
            }
            
            var rgbValue:UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            
            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
    }
    
    func showAlert(_ vc: UIViewController, title: String, message: String, actions: Array<UIAlertAction>) {
        DispatchQueue.main.async(execute: {
            var alertTitle: String? = title
            var alertMsg: String? = message
            
            if title == "error" {
                alertTitle = "Something went wrong"
            }
            
            if alertTitle == "" {
                alertTitle = nil
            }
            if alertMsg == "" {
                alertMsg = nil
            }
            let alert: UIAlertController = UIAlertController(title: alertTitle, message: alertMsg, preferredStyle: .alert)
            if actions.count == 0 {
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action -> Void in
                    
                }))
            } else {
                for i in 0..<actions.count {
                    alert.addAction(actions[i])
                }
            }
            
            vc.present(alert, animated: true, completion: nil)
        })
    }
    
    func showLoading(vc: UIViewController) {
        print("DEBUG : Show Loading")
        let viewController = vc
        let backgroundView: UIButton = UIButton()
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        
        backgroundView.frame = viewController.view.bounds
        backgroundView.backgroundColor = self.hexToUIColor("#000000")
        backgroundView.alpha = 0.0
        backgroundView.tag = -4
        
        loadingIndicator.frame = CGRect(x: viewController.view.frame.size.width/2 - 50/2, y: viewController.view.frame.size.height/2 - 50/2, width: 50, height: 50)
        loadingIndicator.startAnimating()
        backgroundView.alpha = 0.0
        loadingIndicator.tag = -5
        
        // Add Subviews
        backgroundView.removeFromSuperview()
        loadingIndicator.removeFromSuperview()
        viewController.view.addSubview(backgroundView)
        viewController.view.addSubview(loadingIndicator)
        
        // Animate
        DispatchQueue.main.async(execute: {
            UIView.animate(withDuration: 0.25, animations: {
                backgroundView.alpha = 0.6
                loadingIndicator.alpha = 1.0
            }, completion: {result -> Void in
                
            })
        })
    }
    
    func hideLoading(vc: UIViewController) {
        DispatchQueue.main.async(execute: {
            print("DEBUG : Hide Loading")
            let viewController = vc
            
            if viewController.view.viewWithTag(-4) != nil && viewController.view.viewWithTag(-5) != nil {
                let backgroundView = viewController.view.viewWithTag(-4) as! UIButton
                let loadingIndicator: UIView = viewController.view.viewWithTag(-5)! as UIView
                UIView.animate(withDuration: 0.25, animations: {
                    backgroundView.alpha = 0.0
                    loadingIndicator.alpha = 0.0
                }, completion: {result -> Void in
                    backgroundView.removeFromSuperview()
                    loadingIndicator.removeFromSuperview()
                })
            }
        })
    }
    
    func copyString(_ string: String) {
        print("DEBUG : Copy String Called")
        UIPasteboard.general.string = string
    }

    func sendFacebook(_ shareLink: String) {
        print("DEBUG : Send Facebook Called")
        
        let facebookVC: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        facebookVC.add(URL(string: shareLink))
        
        facebookVC.completionHandler = { (result: SLComposeViewControllerResult) in
            switch result {
            case SLComposeViewControllerResult.cancelled:
                print("DEBUG : Send Facebook Cancelled")
                break
            case SLComposeViewControllerResult.done:
                print("DEBUG : Send Facebook Success")
                break
            }
        }
        
        DispatchQueue.main.async(execute: {
            self.viewControllers[self.currentViewController]?.present(facebookVC, animated: true, completion: nil)
        })
    }
    
    func sendTwitter(_ text: String, image: UIImage?) {
        print("DEBUG : Send Twitter Called")
        
        let twitterVC: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        twitterVC.setInitialText(text)
        if image != nil {
            twitterVC.add(image)
        }
        
        twitterVC.completionHandler = { (result:SLComposeViewControllerResult) in
            switch (result) {
            case SLComposeViewControllerResult.cancelled:
                print("DEBUG : Send Twitter Cancelled")
                break
            case SLComposeViewControllerResult.done:
                print("DEBUG : Send Twitter Success")
                break
            }
        }
        
        DispatchQueue.main.async(execute: {
            self.viewControllers[self.currentViewController]?.present(twitterVC, animated: true, completion: nil)
        })
    }
    
    func sendSinaWeibo(_ text: String, image: UIImage?) {
        print("DEBUG : Send Sina Weibo Called")
        
        let sinaWeiboVC: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeSinaWeibo)
        sinaWeiboVC.setInitialText(text)
        if image != nil {
            sinaWeiboVC.add(image)
        }
        
        sinaWeiboVC.completionHandler = { (result: SLComposeViewControllerResult) in
            
            switch (result) {
            case SLComposeViewControllerResult.cancelled:
                print("DEBUG : Send Sina Weibo Cancelled")
                break
            case SLComposeViewControllerResult.done:
                print("DEBUG : Send Sina Weibo Success")
                break
            }
        }
        
        DispatchQueue.main.async(execute: {
            self.viewControllers[self.currentViewController]?.present(sinaWeiboVC, animated: true, completion: nil)
        })
    }
    
    func sendTencentWeibo(_ text: String, image: UIImage?) {
        print("DEBUG : Send Tencent Weibo Called")
        
        let tencentWeiboVC: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTencentWeibo)
        tencentWeiboVC.setInitialText(text)
        if image != nil {
            tencentWeiboVC.add(image)
        }
        
        tencentWeiboVC.completionHandler = { (result: SLComposeViewControllerResult) in
            
            switch (result) {
            case SLComposeViewControllerResult.cancelled:
                print("DEBUG : Send Tencent Weibo Cancelled")
                break
            case SLComposeViewControllerResult.done:
                print("DEBUG : Send Tencent Weibo Success")
                break
            }
        }
        
        DispatchQueue.main.async(execute: {
            self.viewControllers[self.currentViewController]?.present(tencentWeiboVC, animated: true, completion: nil)
        })
    }
    
    func changeViewController(_ from: String, destination: String) {
        print("DEBUG : Change View Controller from \(from) -> \(destination)")
        DispatchQueue.main.async(execute: {
            print(self.viewControllers)
            self.viewControllers[from]?.performSegue(withIdentifier: destination, sender: self.viewControllers[from])
            self.currentViewController = destination
        })
    }
    
    func delay(seconds: Double, run: @escaping ((Void) -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // your code here
            run()
        }
    }
}
