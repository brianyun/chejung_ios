//
//  ViewController.swift
//  chejung
//
//  Created by 윤희상 on 2017. 8. 21..
//  Copyright © 2017년 Clutch Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var weekDay: Int = 0
    var meal: Int = 0 //아침이면 1, 점심이면 2, 저녁이면 3
    var date: String = ""
    var month: Int = 0
    var day: Int = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
        self.addSubviews()
        self.addTargets()
        
        self.sendQuery(qDate: self.date, qMeal: self.meal)
        self.shareVariable()
    }
    
    
    
    
    func sendQuery(qDate: String, qMeal: Int) -> () {
        
        print("DEBUG: sendQuery is initiated.")
        //let localURL = URL(string: "http://172.30.1.16:7777/menu/search?date="+qDate+"&meal="+String(qMeal))
        let serverURL = URL(string: "http://13.124.139.15:7777/menu/search?date="+qDate+"&meal="+String(qMeal))
        
        var request2 = URLRequest(url: serverURL!)
        request2.httpMethod = "GET"
        
        let doTask = URLSession.shared.dataTask(with: request2) {(data, response, error) -> Void in
            
            if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet
            {
                print("DEBUG: No internet")
                DispatchQueue.main.async(execute: {
                    self.menu1.text = "인터넷 연결을"
                    self.menu2.text = "확인해 주시길"
                    self.menu3.text = "바랍니다."
                    self.menu4.text = ""
                    self.menuSpecial.text = ""
                })
            } else {
            
                let dataStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                let menuArr = dataStr.toJSON()
            
                //print(menuArr)
                let menuDict = menuArr?[0]
            
                DispatchQueue.main.async(execute: {
                    self.menu1.text = menuDict?["menu1"] as? String
                    self.menu2.text = menuDict?["menu2"] as? String
                    self.menu3.text = menuDict?["menu3"] as? String
                    self.menu4.text = menuDict?["menu4"] as? String
                    self.menuSpecial.text = menuDict?["special"] as? String
                    print("DEBUG: Menu all set")
                })
            }
        }
        doTask.resume()
    }
    
    
    
    
    var backgroundView = UIImageView()
    
    var monthLabel = UILabel()
    var dayLabel = UILabel()
    var weekDayLabel = UILabel()
    
    var morningLabel = UILabel()
    var lunchLabel = UILabel()
    var dinnerLabel = UILabel()
    
    var morningButton = UIButton()
    var lunchButton = UIButton()
    var dinnerBtn = UIButton()
    
    var menuView = UIView()
    var menu1 = UILabel()
    var menu2 = UILabel()
    var menu3 = UILabel()
    var menu4 = UILabel()
    var menuSpecial = UILabel()
    var specialLabel = UILabel()
    var ratingBtn = UIButton()
    
    var ratingLabel = UILabel()
    var ratingImageView = UIImageView()
    
    
    let dateAndTime = DateAndTime()

    
    func setUI() {
        
        print("DEBUG: width: \(self.view.frame.width)")
        print("DEBUG: height: \(self.view.frame.height)")
        
        
        dateAndTime.setNow()
        self.date = dateAndTime.date
        self.meal = dateAndTime.meal
        self.weekDay = dateAndTime.weekDay
        let labelArr = dateAndTime.setMonthDayString(date: dateAndTime.date, meal: dateAndTime.meal, weekDay: dateAndTime.weekDay)
        
        
        self.backgroundView = self.appDelegate.ub.buildImageView(target: self.backgroundView, image: String(self.meal), contentMode: .scaleToFill, x: Ux(20), y: UIApplication.shared.statusBarFrame.height, width: Ux(356), height: Uy(504))
        self.backgroundView.isUserInteractionEnabled = true
        
        
        self.monthLabel = self.appDelegate.ub.buildLabel(target: self.monthLabel, text: labelArr.month+"월", color: "#C0392B", textAlignment: .center, x: Ux(23), y: UIApplication.shared.statusBarFrame.height+Uy(9), width: Ux(55), height: Uy(45))
        adjustFontLabel(label: self.monthLabel, style: "NanumBarunpen-Bold")
        
        
        self.dayLabel = self.appDelegate.ub.buildLabel(target: self.dayLabel, text: labelArr.day+"일", color: "#C0392B", textAlignment: .center, x: Ux(23), y: UIApplication.shared.statusBarFrame.height+Uy(54), width: Ux(55), height: Uy(45))
        adjustFontLabel(label: self.dayLabel, style: "NanumBarunpen-Bold")
        
        
        self.weekDayLabel = self.appDelegate.ub.buildLabel(target: self.weekDayLabel, text: labelArr.weekDay, color: "#C0392B", textAlignment: .center, x: Ux(23), y: UIApplication.shared.statusBarFrame.height+Uy(98), width: Ux(55), height: Uy(45))
        adjustFontLabel(label: self.weekDayLabel, style: "NanumBarunpen-Bold")
        
    
        
        self.morningLabel = self.appDelegate.ub.buildLabel(target: self.morningLabel, text: "아침", color: "#FFFFFF", textAlignment: .center, x: Ux(36), y: UIApplication.shared.statusBarFrame.height+Uy(244), width: Ux(63), height: Uy(49))
        adjustFontLabel(label: self.morningLabel, style: "NanumBarunpen-Bold")
        
        self.lunchLabel = self.appDelegate.ub.buildLabel(target: self.lunchLabel, text: "점심", color: "#FFFFFF", textAlignment: .center, x: Ux(36), y: UIApplication.shared.statusBarFrame.height+Uy(338), width: Ux(63), height: Uy(49))
        adjustFontLabel(label: self.lunchLabel, style: "NanumBarunpen-Bold")
        
        self.dinnerLabel = self.appDelegate.ub.buildLabel(target: self.dinnerLabel, text: "저녁", color: "#FFFFFF", textAlignment: .center, x: Ux(36), y: UIApplication.shared.statusBarFrame.height+Uy(431), width: Ux(63), height: Uy(49))
        adjustFontLabel(label: self.dinnerLabel, style: "NanumBarunpen-Bold")
        
        
        
        self.morningButton = self.appDelegate.ub.buildButton(target: self.morningButton, title: "", titleColor: "#FFFFFF", imageName: "", backgroundColor: "", x: Ux(0), y: UIApplication.shared.statusBarFrame.height+Uy(224), width: Ux(116), height: Uy(92))
        
        self.lunchButton = self.appDelegate.ub.buildButton(target: self.lunchButton, title: "", titleColor: "#FFFFFF", imageName: "", backgroundColor: "", x: Ux(0), y: UIApplication.shared.statusBarFrame.height+Uy(316), width: Ux(116), height: Uy(92))
        
        self.dinnerBtn = self.appDelegate.ub.buildButton(target: self.dinnerBtn, title: "", titleColor: "#FFFFFF", imageName: "", backgroundColor: "", x: Ux(0), y: UIApplication.shared.statusBarFrame.height+Uy(408), width: Ux(116), height: Uy(92))
        
        
        
        self.menuView.backgroundColor = UIColor.clear
        self.menuView.frame = CGRect(x: Ux(105), y: UIApplication.shared.statusBarFrame.height, width: Ux(270), height: Uy(504))

        
        
        //menu label 설정은 좀 나중에 해도 될 것 같다. 아니다. 선언은 처음에 다 하고, 나중에 텍스트만 바꿔주자.
        self.menu1 = self.appDelegate.ub.buildLabel(target: self.menu1, text: "menu1", color: "#FFFFFF", textAlignment: .center, x: Ux(150), y: UIApplication.shared.statusBarFrame.height+Uy(74), width: Ux(178), height: Uy(36))
        adjustFontLabel(label: self.menu1, style: "NanumBarunpen")
        
        self.menu2 = self.appDelegate.ub.buildLabel(target: self.menu2, text: "menu2", color: "#FFFFFF", textAlignment: .center, x: Ux(150), y: UIApplication.shared.statusBarFrame.height+Uy(128), width: Ux(178), height: Uy(36))
        adjustFontLabel(label: self.menu2, style: "NanumBarunpen")
        
        self.menu3 = self.appDelegate.ub.buildLabel(target: self.menu3, text: "menu3", color: "#FFFFFF", textAlignment: .center, x: Ux(150), y: UIApplication.shared.statusBarFrame.height+Uy(183), width: Ux(178), height: Uy(36))
        adjustFontLabel(label: self.menu3, style: "NanumBarunpen")
        
        self.menu4 = self.appDelegate.ub.buildLabel(target: self.menu4, text: "menu4", color: "#FFFFFF", textAlignment: .center, x: Ux(150), y: UIApplication.shared.statusBarFrame.height+Uy(238), width: Ux(178), height: Uy(36))
        adjustFontLabel(label: self.menu4, style: "NanumBarunpen")
        
        
        self.specialLabel = self.appDelegate.ub.buildLabel(target: self.specialLabel, text: "<특식>", color: "#FFFFFF", textAlignment: .center, x: Ux(150), y: UIApplication.shared.statusBarFrame.height+Uy(325), width: Ux(178), height: Uy(36))
        adjustFontLabel(label: self.specialLabel, style: "NanumBarunpen")
        
        
        self.menuSpecial = self.appDelegate.ub.buildLabel(target: self.menuSpecial, text: "menuSpecial", color: "#FFFFFF", textAlignment: .center, x: Ux(150), y: UIApplication.shared.statusBarFrame.height+Uy(371), width: Ux(178), height: Uy(36))
        adjustFontLabel(label: self.menuSpecial, style: "NanumBarunpen")
        
        
        
        self.ratingBtn = self.appDelegate.ub.buildButton(target: self.ratingBtn, title: "오늘 밥은 몇 점?", titleColor: "#FFFFFF", imageName: "gray_bottom", backgroundColor: "", x: Ux(0), y: Uy(587), width: Ux(375), height: Uy(80))
        
        //self.ratingBtn.titleLabel?.backgroundColor = UIColor.blue
        self.ratingBtn.titleLabel?.font = UIFont(name: "NanumBarunpen-Bold", size: min(Ux(25.0), Uy(25.0)))
        self.ratingBtn.titleLabel?.sizeToFit()
        
        self.ratingBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: self.ratingBtn.currentImage!.size.width * -1, bottom: 0, right: 0)
        
        self.ratingBtn.contentMode = .scaleToFill
        
        
        
        self.ratingLabel = self.appDelegate.ub.buildLabel(target: self.ratingLabel, text: "오늘 밥은 몇 점?", color: "#FFFFFF", textAlignment: .center, x: Ux(0), y: Uy(587), width: Ux(375), height: Uy(80))
        self.ratingLabel.font = UIFont(name: "NanumBarunpen-Bold", size: min(Ux(25.0), Uy(25.0)))
        self.ratingLabel.isUserInteractionEnabled = true
        
        
        self.ratingImageView = self.appDelegate.ub.buildImageView(target: self.ratingImageView, image: "gray_bottom", contentMode: .scaleToFill, x: Ux(0), y: Uy(587), width: Ux(375), height: Uy(80))
        
    }
    
    
    
    func addSubviews() {
    
        self.view.addSubview(backgroundView)
        
        self.view.addSubview(monthLabel)
        self.view.addSubview(dayLabel)
        self.view.addSubview(weekDayLabel)
        
        
        //self.view.addSubview(testView)
        
        self.view.addSubview(morningLabel)
        self.view.addSubview(lunchLabel)
        self.view.addSubview(dinnerLabel)
        self.view.addSubview(morningButton)
        self.view.addSubview(lunchButton)
        self.view.addSubview(dinnerBtn)
        
        self.view.addSubview(menu1)
        self.view.addSubview(menu2)
        self.view.addSubview(menu3)
        self.view.addSubview(menu4)
        self.view.addSubview(specialLabel)
        self.view.addSubview(menuSpecial)
        self.view.addSubview(menuView)
        
        //menu들을 menuView의 subview가 아니라, 전체 화면 view의 subview로 등록했음에 유의.
        
        //self.view.addSubview(ratingBtn)
        self.view.addSubview(ratingImageView)
        self.view.addSubview(ratingLabel)
    }
    
    
    
    func addTargets() {
        
        self.morningButton.addTarget(self, action: #selector(self.touchMorningBtn), for: .touchUpInside)
        self.lunchButton.addTarget(self, action: #selector(self.touchLunchBtn), for: .touchUpInside)
        self.dinnerBtn.addTarget(self, action: #selector(self.touchDinnerBtn), for: .touchUpInside)
        
        let swpLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swpLeft))
        swpLeft.direction = .left
        let swpRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swpRight))
        swpRight.direction = .right
        let swpDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swpDown))
        swpDown.direction = .down
//        self.backgroundView.addGestureRecognizer(swpLeft)
//        self.backgroundView.addGestureRecognizer(swpRight)
//        self.backgroundView.addGestureRecognizer(swpDown)
        
        self.menuView.addGestureRecognizer(swpLeft)
        self.menuView.addGestureRecognizer(swpRight)
        self.menuView.addGestureRecognizer(swpDown)
        
        self.ratingBtn.addTarget(self, action: #selector(self.touchRatingBtn), for: .touchUpInside)
        
        
        
        
        self.ratingLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchRatingBtn)))
        
        let tapRating = UILongPressGestureRecognizer(target: self, action: #selector(self.touchRatingBtn))
        tapRating.minimumPressDuration = 0
        self.ratingLabel.addGestureRecognizer(tapRating)
    }
    
    
    
    
    
    
    func touchMorningBtn() {
    
        print("DEBUG: func touchMorningBtn")
        self.meal = 1
        self.backgroundView.image = UIImage(named: "1")
        self.sendQuery(qDate: self.date, qMeal: self.meal)
        self.shareVariable()
    }
    
    
    
    func touchLunchBtn() {
    
        print("DEBUG: func touchLunchBtn")
        self.meal = 2
        self.backgroundView.image = UIImage(named: "2")
        self.sendQuery(qDate: self.date, qMeal: self.meal)
        self.shareVariable()
    }
    
    
    
    func touchDinnerBtn() {
    
        print("DEBUG: func touchDinnerBtn")
        self.meal = 3
        self.backgroundView.image = UIImage(named: "3")
        self.sendQuery(qDate: self.date, qMeal: self.meal)
        self.shareVariable()
    }
    
    
    
    
    
    
    
    
    func swpLeft() {
        //참고) swipe left라는 것은, 손가락이 왼쪽으로 간다는 의미이다. 즉 오른쪽에서 왼쪽으로 손가락을 끄는 것.
        print("DEBUG: func swpLeft")
        let labelArr = dateAndTime.nextMenu(nowDate: self.date, nowWeekDay: self.weekDay)
        self.date = labelArr.nextDate
        self.meal = 2
        self.monthLabel.text = labelArr.nextMonth+"월"
        self.dayLabel.text = labelArr.nextDay+"일"
        self.weekDayLabel.text = dateAndTime.weekDayToString(weekDayInt: labelArr.nextWeekDay)
        
        self.sendQuery(qDate: self.date, qMeal: self.meal)
        self.shareVariable()
    }
    
    
    func swpRight() {
    
        print("DEBUG: func swpRight")
        let labelArr = dateAndTime.prevMenu(nowDate: self.date, nowWeekDay: self.weekDay)
        self.date = labelArr.prevDate
        self.meal = 2
        self.monthLabel.text = labelArr.prevMonth+"월"
        self.dayLabel.text = labelArr.prevDay+"일"
        self.weekDayLabel.text = dateAndTime.weekDayToString(weekDayInt: labelArr.prevWeekDay)
        
        self.sendQuery(qDate: self.date, qMeal: self.meal)
        self.shareVariable()
    }
    
    
    func swpDown() {
        
        print("DEBUG: func swpDown")
        dateAndTime.setNow()
        self.date = dateAndTime.date
        self.meal = dateAndTime.meal
        self.weekDay = dateAndTime.weekDay
        let labelArr = dateAndTime.setMonthDayString(date: dateAndTime.date, meal: dateAndTime.meal, weekDay: dateAndTime.weekDay)
        
        self.monthLabel.text = labelArr.month+"월"
        self.dayLabel.text = labelArr.day+"일"
        self.weekDayLabel.text = labelArr.weekDay
        
        self.sendQuery(qDate: self.date, qMeal: self.meal)
        self.shareVariable()
    }
    
    
    
    
    
    func shareVariable() {
    
        self.appDelegate.dateShared = self.date
        self.appDelegate.mealShared = self.meal
    }
    
    
    
    
    
    func Ux(_ n: CGFloat) -> CGFloat {
        
        return n*(self.view.frame.width/375)
    }
    
    
    func Uy(_ n: CGFloat) -> CGFloat {
        
        return n*(self.view.frame.height/667)
    }
    
    
    
    
    func adjustFontLabel(label: UILabel, style: String) {
        
        label.font = UIFont(name: style, size: 100)
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.1
        label.adjustsFontSizeToFitWidth = true
    }
    
    
    
    
    
    
    
    
    let slideInLauncher = SlideInLauncher()
    
    func touchRatingBtn(gesture: UIPanGestureRecognizer) {
        
        let point = gesture.location(in: view)
        let ratingFrame = CGRect(x: Ux(0), y: Uy(587), width: Ux(375), height: Uy(80))
        
        if ratingFrame.contains(point) {
            self.ratingImageView.image = UIImage(named: "dark_bottom")
            if gesture.state == .ended {
                print("DEBUG: func touchRatingBtn")
                slideInLauncher.showCurtain()
            }
        } else {
            self.ratingImageView.image = UIImage(named: "gray_bottom")
        }
        
        if gesture.state == .ended {
            print("DEBUG: gray")
            self.ratingImageView.image = UIImage(named: "gray_bottom")
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension String {
    func toJSON() -> [[String: Any]]? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [[String: Any]]
    }
}
