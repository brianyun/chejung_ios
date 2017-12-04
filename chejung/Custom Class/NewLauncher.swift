//
//  NewLauncher.swift
//  chejung
//
//  Created by 윤희상 on 2017. 9. 7..
//  Copyright © 2017년 Clutch Studio. All rights reserved.
//

import UIKit

//NewLauncher는 스르륵 메뉴 ('오늘 밥은 몇 점?' 클릭했을 때 올라오는 메뉴) 를 코딩하는 클래스임.
class NewLauncher: NSObject, UITextFieldDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //passedDate, passedMeal로 변수 공유 관리.
    var passedDate = String()
    var passedMeal = String()
    
    
    
    //showSlide()는 스르륵 메뉴 올라오게끔 해주는 함수. ViewController.swift에서 호출되는 함수이고, 메인 함수이다.
    func showSlide() {
        
        //개발자 본인은 setUI(), addSubviews(), addTargets() 이렇게 세 가지로 분리해서 UI 코드를 짠다. 이건 개인적인 성향.
        self.setUI()
        self.addSubviews()
        self.addTargets()
        
        //올라오는 애니메이션 코딩. (1) UIView가 올라와야 하며 (2) 배경이 어두워져야 한다.
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            //blackView가 뒤 배경.
            self.blackView.alpha = 1
            
            //slideInObj가 스르륵 올라오는 UIView임.
            //Vy(), Vx()는 비율을 유지해주는 함수. 맨 아래에 보면 자세한 함수 있음.
            self.slideInObj.frame = CGRect(x: 0, y: self.Vy(267), width: self.Vx(375), height: self.Vy(400))
        }, completion: nil)
    }

    
    
    let blackView = UIView()
    let slideInObj = UIView()
    
    
    
    var label1 = UILabel() //'0 점'
    var ratingView = CosmosView() //CosmosView가 별점 뷰임. 이건 GitHub에서 따로 클래스 받아왔음.
    var label2 = UILabel() // '별점을 매겨주세요.'
    var label3 = UILabel() // '의견 하나하나를 다 듣고있어요'
    
    var lineView = UIView() //선을 UIView로 일단 긋자.
    var commentView = UIView() //코멘트창의 배경이 되는 UIView. 그냥 흰색이다.
    var commentTextView = UITextField() //코멘트창 입력할 수 있는 TextField.
    var returnBtn = UIButton()
    
    var returnLabel = UILabel() //'보내기'버튼 글자.
    var returnImageView = UIImageView() //'보내기'버튼의 배경이 되는 이미지.
    
    
    
    func setUI() {
        
        if let window = UIApplication.shared.keyWindow {
        
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            slideInObj.frame = CGRect(x: 0, y: Vy(667), width: Vx(375), height: Vy(400))
            slideInObj.backgroundColor = self.appDelegate.ub.hexToUIColor("#EEE7D5")
            
            activityIndicator.activityIndicatorViewStyle = .gray
            activityIndicator.frame = CGRect(x: Vx(325)/2, y: (Vy(667)-Vx(50))/2, width: Vx(50), height: Vx(50))
            activityIndicator.isHidden = true
        }
        
        
        
        self.label1 = self.appDelegate.ub.buildLabel(target: self.label1, text: "0 점", color: "000000", textAlignment: .center, x: Vx(0), y: Vy(0), width: Vx(375), height: Vy(40))
        //폰트 크기 설정도 Vy() 함수 이용해서 비율 맞췄음. 이 부분은 헷갈릴 여지가 있는데,ViewController.swift에서는 폰트 크기 조정을 다른 방식으로 했음. 이 방법이 더 깔끔하다고 생각됨. 근데 결과물만 깔끔하면 상관 없으니까 안드로이드 버전에서는 취향에 맞게 폰트 설정할 것.
        //디바이스가 바뀌면 글자 크기도 (당연히) 스크린에 맞춰서 커져야 함.
        self.label1.font = UIFont(name: "NanumBarunpen", size: Vy(25.0))
        self.label1.textColor = self.appDelegate.ub.hexToUIColor("#C0392B")
        
        
        
        self.label2 = self.appDelegate.ub.buildLabel(target: self.label2, text: "별점을 매겨주세요", color: "000000", textAlignment: .center, x: Vx(0), y: Vy(40), width: Vx(375), height: Vy(30))
        self.label2.font = UIFont(name: "NanumBarunpen", size: Vy(17.0))
        self.label2.textColor = self.appDelegate.ub.hexToUIColor("#C0392B")
        
        
        
        //ratingView는 CosmosView를 이용해 생성한다. 기본값은 별점 0개이다.
        //CosmosView는 0.5점 단위로 설정할 수 있으며, 한번이라도 드래그한 적 있으면 그때는 최솟값이 0.5점임 (0점으로 복구 불가) 이해하기 어려울 수 있는데 직접 써보면 무슨얘긴지 알 것.
        self.ratingView = self.appDelegate.ub.buildCosmosView(target: self.ratingView, fillMode: 0, starSize: Double(Vy(40.0)), filledColor: "#C0392B", emptyColor: "#FFFFFF", filledBorderColor: "#C0392B", emptyBorderColor: "#C0392B")
        let leftMargin = (self.slideInObj.frame.width - self.ratingView.intrinsicContentSize.width)/2
        self.ratingView.frame = CGRect(x: leftMargin, y: Vy(75), width: self.ratingView.intrinsicContentSize.width, height: self.ratingView.intrinsicContentSize.height)
        
        
        
        self.lineView.backgroundColor = self.appDelegate.ub.hexToUIColor("ABB7B7")
        self.lineView.frame = CGRect(x: Vx(10), y: Vy(119), width: Vx(355), height: Vy(2))
        
        
        
        self.label3 = self.appDelegate.ub.buildLabel(target: self.label3, text: "의견 하나하나를 다 듣고있어요.", color: "000000", textAlignment: .center, x: Vx(0), y: Vy(125), width: Vx(375), height: Vy(40))
        self.label3.font = UIFont(name: "NanumBarunpen", size: Vy(20.0))
        self.label3.textColor = self.appDelegate.ub.hexToUIColor("#C0392B")
        
        
        
        //commentView는 진짜 배경으로서의 의미만 있다. 나중에 배경 이미지 넣어야지 (이러고 안했음).
        self.commentView.backgroundColor = UIColor.white
        self.commentView.frame = CGRect(x: Vx(10), y: Vy(170), width: Vx(355), height: Vy(149))
        
        
        
        //자동으로 firstResponder 되는듯.
        self.commentTextView = self.appDelegate.ub.buildTextField(target: self.commentTextView, placeholder: "의견을 써주세요", keyboardType: .default, returnKeyType: .done, autocorrectionType: .no, autocapitalizationType: .none, secureTextEntry: false, x: Vx(10), y: Vy(170), width: Vx(355), height: Vy(149), text: "", color: "#000000", tintColor: "#000000", clearButtonMode: .whileEditing)
        self.commentTextView.font = UIFont(name: "NanumBarunpen", size: Vy(20.0))
        self.commentTextView.contentVerticalAlignment = .top
        
        
        
        self.returnBtn = self.appDelegate.ub.buildButton(target: self.returnBtn, title: "보내기", titleColor: "#FFFFFF", imageName: "returnBtn_temp", backgroundColor: "", x: Vx(20), y: Vy(329), width: Vx(335), height: Vy(60))
        self.returnBtn.titleLabel?.font = UIFont(name: "NanumBarunpen", size: Vy(20.0))
        //버튼에 이미지를 넣으려면 이렇게 EdgeInsets를 넣어줘야 한다. 안드로이드는 다를 수도?
        self.returnBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: self.returnBtn.currentImage!.size.width * -1, bottom: 0, right: 0)
        
        
        self.returnLabel = self.appDelegate.ub.buildLabel(target: self.returnLabel, text: "보내기", color: "#FFFFFF", textAlignment: .center, x: Vx(20), y: Vy(329), width: Vx(335), height: Vy(60))
        self.returnLabel.font = UIFont(name: "NanumBarunpen", size: Vy(20.0))
        self.returnLabel.isUserInteractionEnabled = true
        
        
        self.returnImageView = self.appDelegate.ub.buildImageView(target: self.returnImageView, image: "returnBtn_temp", contentMode: .scaleToFill, x: Vx(20), y: Vy(329), width: Vx(335), height: Vy(60))
        
        
    }
    
    
    //addSubview() 함수들의 모음. 일단 window에 blackView, slideInObj를 넣고 slideInObj 안에 나머지 뷰들을 넣음.
    func addSubviews() {
        
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(blackView)
            window.addSubview(slideInObj)
            window.addSubview(activityIndicator)
        }
        
        self.slideInObj.addSubview(self.label1)
        self.slideInObj.addSubview(self.label2)
        self.slideInObj.addSubview(self.ratingView)
        
        self.slideInObj.addSubview(self.lineView)
        self.slideInObj.addSubview(self.label3)
        self.slideInObj.addSubview(self.commentView)
        self.slideInObj.addSubview(self.commentTextView)
        
        self.slideInObj.addSubview(self.returnImageView)
        self.slideInObj.addSubview(self.returnLabel)
    }
    
    
    //유저 터치/스와이프같은 입력에 반응하는 함수들의 모음.
    func addTargets() {
        
        //스르륵 메뉴가 올라왔을 때, blackView를 터치하면 스르륵 내려감.
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSlide)))
        //slideInObj를 아래로 스와이프해도 스르륵 내려감.
        let swpDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissSlide))
        swpDown.direction = .down
        slideInObj.addGestureRecognizer(swpDown)
        
        
        self.ratingView.didFinishTouchingCosmos = didFinishTouchingCosmos(_:)
        //키보드에서 '완료' 버튼 누르면 키보드가 사라지도록.
        self.commentTextView.addTarget(self, action: #selector(exitEdit), for: .editingDidEnd)
        
        
        //뷰들을 터치하면 dismissKeyboard (평점 입력도중 올라오는 키보드 없애기) 활성화.
        for vie in [self.label1, self.label2, self.label3, self.lineView] {
            vie.isUserInteractionEnabled = true
            vie.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        }
        
        //'보내기'버튼 누를 경우에 작동되는 함수.
        let tapReturn = UILongPressGestureRecognizer(target: self, action: #selector(self.panReturnBtn))
        tapReturn.minimumPressDuration = 0
        self.returnLabel.addGestureRecognizer(tapReturn)
    }
    
    
    
    
    func dismissSlide() {
        //view를 원래대로 돌리는 함수. slideInObj는 다시 내려가게.
        
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            self.commentTextView.endEditing(true)
            self.slideInObj.frame = CGRect(x: 0, y: self.Vy(667), width: self.Vx(375), height: self.Vy(400))
        })
    }
    
    
    
    func dismissKeyboard() {
        
        print("DEBUG: func dismissKeyboard")
        self.commentTextView.resignFirstResponder()
    }
    
    
    
    //키보드 사라지기
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
    
    
    
    
    //'보내기'버튼 생성. 라벨과 이미지뷰로 버튼같은 UX 구현하기.
    func panReturnBtn(gesture: UIPanGestureRecognizer) {
        
        let point = gesture.location(in: self.slideInObj)
        let ratingFrame = CGRect(x: Vx(20), y: Vy(329), width: Vx(335), height: Vy(60))
        
        if ratingFrame.contains(point) {
            self.returnImageView.image = UIImage(named: "returnBtn_dark")
            if gesture.state == .ended {
                self.touchReturnBtn()
            }
        } else {
            self.returnImageView.image = UIImage(named: "returnBtn_temp")
        }
        
        if gesture.state == .ended {
            self.returnImageView.image = UIImage(named: "returnBtn_temp")
        }
        
    }

    let activityIndicator = UIActivityIndicatorView()
    
    
    func touchReturnBtn() {
        
        print("DEBUG: func touchReturnBtn")
        if let txt = self.commentTextView.text {
            print("DEBUG: rating is \(self.inputRating) and comment is \(txt)")
        }
        //한 사람이 한 메뉴에 대해 여러 번 포스트하면 어떡하지? 음음 그냥 내버려두자.
        
        
        //평점, 의견 둘 다 nil일 경우에는 입력 작동 안함.
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
            self.dismissSlide()
            
            self.showFinish()
            
            
        } else {
            print("DEBUG: false alarm - touchReturnBtn with no data")
        }
        
        
    }

    
    
    //서버에 평점, 의견 POST 리퀘스트 보내는 코드. 엔드포인트는 없다 (/)
    func insertRating(_ date: String, _ meal: String, _ rating: Double, _ comment: String) {
        
        //이렇게 파라미터 지정해준 배열(?) 전체를 POST로 보냄.
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

    
    
    
    
    
    
    
    
    
    let finishView = UIView()
    var successLabel = UILabel()
    var tapLabel = UILabel()
    var doneIcon = UIImageView()
    
    
    
    //'보내기' 성공적으로 작동시에 보이는 화면 (tap to dismiss 문구 있는 화면) 코드.
    func showFinish() {
        
        self.setFinishUI()
        self.addFinishSubview()
        self.addFinishTargets()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.finishView.alpha = 1
            if let window = UIApplication.shared.keyWindow {
                self.finishView.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
            }
            
            
            self.doneIcon.frame = CGRect(x: self.finishView.frame.width*0.375, y: self.finishView.frame.height*0.5-self.finishView.frame.width*0.125, width: self.finishView.frame.width*0.25, height: self.finishView.frame.width*0.25)
            
            self.successLabel.center.y = self.finishView.center.y - self.Vy(100)
            self.tapLabel.center.y = self.finishView.center.y + self.Vy(100)
        })
    }
    
    
    
    //finishView를 따로 만들어 주었음.
    func setFinishUI() {
    
        if let window = UIApplication.shared.keyWindow {
            
            let w = window.frame.width
            let h = window.frame.height
            
            
            finishView.backgroundColor = UIColor(white: 0, alpha: 0.8)
            finishView.frame = CGRect(x: 0, y: 0, width: w, height: 0)
            finishView.alpha = 0
            
            
            doneIcon = self.appDelegate.ub.buildImageView(target: self.doneIcon, image: "success", contentMode: .scaleAspectFit, x: w*0.375, y: h*0.5-w*0.125, width: w*0.25, height: w*0.25)
            
            successLabel = self.appDelegate.ub.buildLabel(target: self.successLabel, text: "평점이 메뉴에 반영되었습니다!", color: "#FFFFFF", textAlignment: .center, x: self.finishView.frame.origin.x, y: self.finishView.frame.origin.y, width: self.finishView.frame.width, height: self.finishView.frame.height - Vy(200))
            successLabel.font = UIFont(name: "NanumBarunpen", size: Vy(25.0))
            
            
            tapLabel = self.appDelegate.ub.buildLabel(target: self.tapLabel, text: "tap to dismiss", color: "#FFFFFF", textAlignment: .center, x: self.finishView.frame.origin.x, y: self.finishView.frame.origin.y + Vy(200), width: self.finishView.frame.width, height: self.finishView.frame.height - Vy(200))
            tapLabel.font = UIFont(name: "NanumBarunpen", size: Vy(25.0))
            
        }
    }
    
    
    
    
    
    
    
    func addFinishSubview() {
    
        finishView.addSubview(doneIcon)
        finishView.addSubview(successLabel)
        finishView.addSubview(tapLabel)
        
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(finishView)
        }
    }
    
    
    
    func addFinishTargets() {
    
        finishView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissFinish)))
    }
    
    
    //탭할 경우에 발동되는, finishView 사라지는 함수.
    func dismissFinish() {
        UIView.animate(withDuration: 0.5) {
            self.finishView.alpha = 0
        }
    }
    
    
    
    
    
    
    
    
    
    
    override init() {
        super.init()
        self.commentTextView.delegate = self;
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //start doing something here maybe...
    }
    
    

    //의견 입력 시작하면 키보드 높이만큼 slideInObj가 똑같이 올라가야 한다. 생각해보면 당연한 요소. 이때 키보드 높이가 디바이스마다 다를까봐 키보드 높이를 알려주는 메소드가 있길래 찾아옴.
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
    
    
    
    
    
    //didSet 함수 이용해서, inputRating (CosmosView 드래그하면서 바뀌는 평점 값) 이 바뀔 때마다 그에 맞추어서 문구 (label2)가 바뀌도록 함.
    var inputRating : Double = 0.0 {
        didSet {
            
            switch inputRating {
            case 0.0: self.setLabelText(label1Txt: "0 점", label2Txt: "별점을 매겨주세요")
            case 1.0: self.setLabelText(label1Txt: "1 점", label2Txt: "죽창을 들라..!")
            case 2.0: self.setLabelText(label1Txt: "2 점", label2Txt: "언냐들 나만 맛없어?")
            case 3.0: self.setLabelText(label1Txt: "3 점", label2Txt: "무난무난")
            case 4.0: self.setLabelText(label1Txt: "4 점", label2Txt: "집밥만큼은 아니지만 만족")
            case 5.0: self.setLabelText(label1Txt: "5 점", label2Txt: "주방장이 누구인가? 그자에게 큰 상을 내리고 싶도다.")
            
            default: self.setLabelText(label1Txt: "1 점", label2Txt: "죽창을 들라..!")
            }
        }
    }
    
    //이건 바로 위에 있는 didSet 함수를 깔끔하게 만들기 위해서 선언한 간단한 함수.
    func setLabelText(label1Txt: String, label2Txt: String) {
        self.label1.text = label1Txt
        self.label2.text = label2Txt
    }
    
    
    //비율 설정을 위한 Vx(), Vy().
    func Vx(_ n: CGFloat) -> CGFloat { return n * (UIApplication.shared.keyWindow!.frame.width/375) }
    func Vy(_ n: CGFloat) -> CGFloat { return n * (UIApplication.shared.keyWindow!.frame.height/667) }
    
    
    //CosmosView를 드래그/탭 하여 별점을 선택하면 이렇게 self.inputRating이 바뀐다.
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
