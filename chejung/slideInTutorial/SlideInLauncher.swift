//
//  SlideInLauncher.swift
//  slideInTutorial
//
//  Created by 윤희상 on 2017. 8. 17..
//  Copyright © 2017년 Clutch Studio. All rights reserved.
//

import UIKit

class SlideInLauncher: NSObject, UITextFieldDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var passedDate = String()
    var passedMeal = String()
    
    let blackView = UIView()
    let slideInObj = UIView()
    
    
    
    func showCurtain() {
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            let swpDown = UISwipeGestureRecognizer(target: self, action: #selector(handleDismiss))
            swpDown.direction = .down
            slideInObj.addGestureRecognizer(swpDown)
            
            window.addSubview(blackView)
            window.addSubview(slideInObj)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            
            //let heightLim: CGFloat = Vy(400) //올라오는 slide-in view의 높이를 조정하려면 이 값만 딱 바꾸면 된다.
            //let yTop = Vy(267)
            slideInObj.frame = CGRect(x: 0, y: Vy(667), width: Vx(375), height: Vy(400))
            slideInObj.backgroundColor = self.appDelegate.ub.hexToUIColor("#EEE7D5")
            
            
            activityIndicator.activityIndicatorViewStyle = .gray
            activityIndicator.frame = CGRect(x: Vx(325)/2, y: (Vy(667)-Vx(50))/2, width: Vx(50), height: Vx(50))
            activityIndicator.isHidden = true
            window.addSubview(activityIndicator)
            window.bringSubview(toFront: activityIndicator)
            

            self.setUI()
            self.addSubviews()
            self.addTargets()
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                
                self.slideInObj.frame = CGRect(x: 0, y: self.Vy(267), width: self.Vx(375), height: self.Vy(400))
                
            }, completion: nil)
            
        }
        
        
    }
    
    
    func handleDismiss() {
        //view를 원래대로 돌리는 함수. blackView는 투명하게, slideInObj는 다시 내려가게.

        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            self.slideInObj.frame = CGRect(x: 0, y: self.Vy(667), width: self.Vx(375), height: self.Vy(400))
        })
    
    }
    
    
    
    
    
    
    
    var label1 = UILabel()
    var ratingView = CosmosView()
    var label2 = UILabel()
    var label3 = UILabel()
    
    var lineView = UIView() //선을 UIView로 일단 긋자.
    //var commentView = UIImageView()
    var commentView = UIView() //지금은 UIView지만 디자이너한테 이미지 파일 받고 나면 UIImageView로 바꿀 것.
    var commentTextView = UITextField()
    var returnBtn = UIButton()

    
    
    func setUI() {
    
        self.label1 = self.appDelegate.ub.buildLabel(target: self.label1, text: "0 점", color: "000000", textAlignment: .center, x: Vx(0), y: Vy(0), width: Vx(375), height: Vy(40))
        self.label1.font = UIFont(name: "NanumBarunpen-Bold", size: Vy(25.0))
        self.label1.textColor = self.appDelegate.ub.hexToUIColor("#C0392B")
        //확인하려고 만든 background color. 나중에 다 삭제해야됨.
        //self.label1.backgroundColor = self.appDelegate.ub.hexToUIColor("#F8C6CF")
        
        
        
        self.label2 = self.appDelegate.ub.buildLabel(target: self.label2, text: "별점을 매겨주세요!", color: "000000", textAlignment: .center, x: Vx(0), y: Vy(40), width: Vx(375), height: Vy(30))
        self.label2.font = UIFont(name: "NanumBarunpen", size: Vy(17.0))
        self.label2.textColor = self.appDelegate.ub.hexToUIColor("#C0392B")
        //확인하려고 만든 background color. 나중에 다 삭제해야됨.
        //self.label2.backgroundColor = self.appDelegate.ub.hexToUIColor("#F9BF3B")
        
        
        
        self.ratingView = self.appDelegate.ub.buildCosmosView(target: self.ratingView, fillMode: 1, starSize: Double(Vy(40.0)), filledColor: "#C0392B", emptyColor: "#FFFFFF", filledBorderColor: "#C0392B", emptyBorderColor: "#C0392B")
        let leftMargin = (self.slideInObj.frame.width - self.ratingView.intrinsicContentSize.width)/2
        self.ratingView.frame = CGRect(x: leftMargin, y: Vy(75), width: self.ratingView.intrinsicContentSize.width, height: self.ratingView.intrinsicContentSize.height)
        
        
        
        self.lineView.backgroundColor = self.appDelegate.ub.hexToUIColor("ABB7B7")
        self.lineView.frame = CGRect(x: Vx(10), y: Vy(119), width: Vx(355), height: Vy(2))

        
        
        self.label3 = self.appDelegate.ub.buildLabel(target: self.label3, text: "의견을 자유롭게 써주세요!", color: "000000", textAlignment: .center, x: Vx(0), y: Vy(125), width: Vx(375), height: Vy(40))
        self.label3.font = UIFont(name: "NanumBarunpen", size: Vy(20.0))
        self.label3.textColor = self.appDelegate.ub.hexToUIColor("#C0392B")
        //확인하려고 만든 background color. 나중에 다 삭제해야됨.
        //self.label3.backgroundColor = self.appDelegate.ub.hexToUIColor("#F8C6CF")
        
        
        
        //commentView는 진짜 배경으로서의 의미만 있다. 나중에 배경 이미지 넣어야지.
        self.commentView.backgroundColor = UIColor.white
        self.commentView.frame = CGRect(x: Vx(10), y: Vy(170), width: Vx(355), height: Vy(149))
        
        
        
        //자동으로 firstResponder 되는듯.
        self.commentTextView = self.appDelegate.ub.buildTextField(target: self.commentTextView, placeholder: "의견을 써주세요", keyboardType: .default, returnKeyType: .done, autocorrectionType: .no, autocapitalizationType: .none, secureTextEntry: false, x: Vx(10), y: Vy(170), width: Vx(355), height: Vy(149), text: "", color: "#000000", tintColor: "#000000", clearButtonMode: .whileEditing)
        self.commentTextView.font = UIFont(name: "NanumBarunpen", size: Vy(20.0))
        self.commentTextView.contentVerticalAlignment = .top
        
        
        
        self.returnBtn = self.appDelegate.ub.buildButton(target: self.returnBtn, title: "보내기", titleColor: "#FFFFFF", imageName: "returnBtn_temp", backgroundColor: "", x: Vx(20), y: Vy(329), width: Vx(335), height: Vy(60))
        self.returnBtn.titleLabel?.font = UIFont(name: "NanumBarunpen-Bold", size: Vy(20.0))
        self.returnBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: self.returnBtn.currentImage!.size.width * -1, bottom: 0, right: 0)
    }
    
    
    
    func addSubviews() {
    
        self.slideInObj.addSubview(self.label1)
        self.slideInObj.addSubview(self.label2)
        self.slideInObj.addSubview(self.ratingView)
        
        self.slideInObj.addSubview(self.lineView)
        self.slideInObj.addSubview(self.label3)
        self.slideInObj.addSubview(self.commentView)
        self.slideInObj.addSubview(self.commentTextView)
        
        self.slideInObj.addSubview(self.returnBtn)
    }
    
    
    
    func addTargets() {
        
        self.ratingView.didFinishTouchingCosmos = didFinishTouchingCosmos(_:)
        self.commentTextView.addTarget(self, action: #selector(exitEdit), for: .editingDidEnd)
        self.returnBtn.addTarget(self, action: #selector(self.touchReturnBtn), for: .touchUpInside)

        
        for vie in [self.label1, self.label2, self.label3, self.lineView] {
            vie.isUserInteractionEnabled = true
            vie.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        }
    }
    
    
    
    func dismissKeyboard() {
        
        print("DEBUG: func dismissKeyboard")
        self.commentTextView.resignFirstResponder()
    }
    
    
    
    func exitEdit() {
        
        print("DEBUG: func exitEdit")
        //withDuration의 0.2라는 값은 키보드 등장/사라지는 속도. 정확한 값을 몰라서 대충 0.2라고 함. 실험결과 0.2면 사용성 해치지 않음.
        UIView.animate(withDuration: 0.2, animations: {
            self.slideInObj.frame = CGRect(x: self.Vx(0), y: self.Vy(267), width: self.Vx(375), height: self.Vy(400))
        })
        
        if let window = UIApplication.shared.keyWindow {
            
            window.addSubview(UIApplication.shared.statusBarView!)
            window.bringSubview(toFront: UIApplication.shared.statusBarView!)
            //statusBar는 기본이 투명한 색깔이기 때문에, 바로 위의 두 줄 코드는 subView를 앞으로 가져오기는 한다만 눈으로 보이는 차이는 없다.
            //UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
            //이렇게 흰색 배경을 선언해줘야 눈으로 보임.
        }
        self.keyboardHeight = 0
    }
    
    
    
    let activityIndicator = UIActivityIndicatorView()
    
    
    func touchReturnBtn() {
        
        print("DEBUG: func touchReturnBtn")
        if let txt = self.commentTextView.text {
            print("DEBUG: rating is \(self.inputRating) and comment is \(txt)")
        }
        //한 사람이 한 메뉴에 대해 여러 번 포스트하면 어떡하지? 음음
        
        
        if self.inputRating != 0.0 || self.commentTextView.text != "" {
            
            if let window = UIApplication.shared.keyWindow {
                window.bringSubview(toFront: activityIndicator)
            }
            
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.activityIndicator.color = UIColor.blue
            
            self.insertRating(self.appDelegate.dateShared, String(self.appDelegate.mealShared), self.inputRating, self.commentTextView.text!)
            
            self.activityIndicator.stopAnimating()
            
            self.exitEdit()
            self.dismissKeyboard()
            self.handleDismiss()
            
            //Activity Indicator 안보임. Here's where I leave it.
            
        } else {
            print("DEBUG: false alarm - touchReturnBtn with no data")
        }
        
        
    }
    
    
    
    
    
    
    func insertRating(_ date: String, _ meal: String, _ rating: Double, _ comment: String) {
    
    
        let json = ["date": date, "meal": meal,"rating": rating, "comment": comment] as [String : Any]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            
            // create post request
            let session = URLSession.shared
            let serverURL = URL(string: "http://13.124.139.15:7777")
            //let localURL = URL(string: "http://172.30.1.16:7777")
            
            var request = URLRequest(url: serverURL!)
            
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            // insert json data to the request
            request.httpBody = jsonData
            
            
            let task = session.dataTask(with: request as URLRequest){ data,response,error in
                if error != nil{
                    print(error?.localizedDescription as Any)
                    return
                }
            }
            task.resume()
        } catch {
            print("bad things happened")
        }
    }
    
    
    
    
    
    
    override init() {
        super.init()
        self.commentTextView.delegate = self;
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //start doing something here maybe...
    }
    
    
    
    
    var keyboardHeight = CGFloat() {
        didSet {
            UIView.animate(withDuration: 0.5, animations: {
                self.slideInObj.frame = CGRect(x: self.Vx(0), y: self.Vy(267) - self.keyboardHeight, width: self.Vx(375), height: self.Vy(400))
            })
            
            if let window = UIApplication.shared.keyWindow {
                
                window.addSubview(UIApplication.shared.statusBarView!)
                window.bringSubview(toFront: UIApplication.shared.statusBarView!)
                //statusBar는 기본이 투명한 색깔이기 때문에, 바로 위의 두 줄 코드는 subView를 앞으로 가져오기는 한다만 눈으로 보이는 차이는 없다.
                //UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
                //이렇게 흰색 배경을 선언해줘야 눈으로 보임.
            }
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
    
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        self.keyboardHeight = keyboardRectangle.height
        //print("키보드: \(self.keyboardHeight)") //키보드가 보여진 다음에 이 값이 할당되는 것 같다.
    }
    
    
    
    
    
    
    var inputRating : Double = 0.0 {
        didSet {
            
            switch inputRating {
                case 0.0: self.setLabelText(label1Txt: "0 점", label2Txt: "별점을 매겨주세요!")
                case 0.5: self.setLabelText(label1Txt: "0.5 점", label2Txt: "살기 위해 먹는다...")
                case 1.0: self.setLabelText(label1Txt: "1 점", label2Txt: "음 이맛은... 노맛!")
                case 1.5: self.setLabelText(label1Txt: "1.5 점", label2Txt: "오늘 맛없다고 소문내야지")
                case 2.0: self.setLabelText(label1Txt: "2 점", label2Txt: "언냐들 나만 맛없어?") //"맛없는건 기분탓인가?"
                case 2.5: self.setLabelText(label1Txt: "2.5 점", label2Txt: "나는 아무 생각이 없다. 왜냐하면 아무 생각이 없기 때문이다.")
                case 3.0: self.setLabelText(label1Txt: "3 점", label2Txt: "무난무난")
                case 3.5: self.setLabelText(label1Txt: "3.5 점", label2Txt: "이정도면 뭐 꽤 맛있군.")
                case 4.0: self.setLabelText(label1Txt: "4 점", label2Txt: "만족스럽도다")
                case 4.5: self.setLabelText(label1Txt: "4.5 점", label2Txt: "존맛탱")
                case 5.0: self.setLabelText(label1Txt: "5 점", label2Txt: "주방장이 누구인가? 그자에게 큰 상을 내리고 싶도다.")
                default: self.label2.text = "별점을 매겨주세요!"
            }
        }
    }
    
    func setLabelText(label1Txt: String, label2Txt: String) {
        self.label1.text = label1Txt
        self.label2.text = label2Txt
    }
    
    
    
    
    
    func Vx(_ n: CGFloat) -> CGFloat {
    
        return n * (UIApplication.shared.keyWindow!.frame.width/375)
    }
    
    
    func Vy(_ n: CGFloat) -> CGFloat {
    
        return n * (UIApplication.shared.keyWindow!.frame.height/667)
    }
    
    
    
    
    
    
    
    
    
    private func didFinishTouchingCosmos(_ rating: Double) {
        print("DEBUG: func didFinishTouchingCosmos")
        self.inputRating = rating
    }
    
    
    
    //Return 혹은 키보드 바깥을 터치할 때 키보드를 감추어주는 함수.
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //이거 작동 안함. 그넫 왜 안하는지 모르겠음. 일일히 tapgesture 추가해줘야함.
        print("DEBUG: func touchesBegan (what a miracle!)")
        self.commentTextView.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.commentTextView.endEditing(true)
        //self.commentTextView.resignFirstResponder()
        return false
    }
    
    
}




extension UIApplication {
    
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}










