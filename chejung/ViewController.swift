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
        
        print("sendQuery is initiated.")
        //let localURL = URL(string: "http://172.30.1.16:7777/menu/search?date="+qDate+"&meal="+String(qMeal))
        let serverURL = URL(string: "http://13.124.139.15:7777/menu/search?date="+qDate+"&meal="+String(qMeal))
        
        var request2 = URLRequest(url: serverURL!)
        request2.httpMethod = "GET"
        
        let doTask = URLSession.shared.dataTask(with: request2) {(data, response, error) -> Void in
            
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
                
                print("all set.")
            })
        }
        doTask.resume()
    }
    
    
    
    
    var backgroundView = UIImageView()
    
    var monthLabel = UILabel()
    var dayLabel = UILabel()
    var weekDayLabel = UILabel()
    
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
    
    
    let dateAndTime = DateAndTime()
    
    
    
    func setUI() {
        
        print("DEBUG: width: \(self.view.frame.width)")
        print("DEBUG: height: \(self.view.frame.height)")
        
        
        dateAndTime.setNow()
        self.date = dateAndTime.date
        self.meal = dateAndTime.meal
        self.weekDay = dateAndTime.weekDay
        let labelArr = dateAndTime.setMonthDayString(date: dateAndTime.date, meal: dateAndTime.meal, weekDay: dateAndTime.weekDay)
        
        
        self.backgroundView = self.appDelegate.ub.buildImageView(target: self.backgroundView, image: String(self.meal), contentMode: .scaleToFill, x: Ux(63), y: UIApplication.shared.statusBarFrame.height, width: Ux(356), height: Uy(504))
        self.backgroundView.isUserInteractionEnabled = true
        
        
        self.monthLabel = self.appDelegate.ub.buildLabel(target: self.monthLabel, text: labelArr.month, color: "#C0392B", textAlignment: .center, x: Ux(48), y: UIApplication.shared.statusBarFrame.height+Uy(29), width: Ux(49), height: Uy(40))
        self.monthLabel.font = UIFont(name: "NanumBarunpen-Bold", size: 25.0)
        
        
        self.dayLabel = self.appDelegate.ub.buildLabel(target: self.dayLabel, text: labelArr.day, color: "#C0392B", textAlignment: .center, x: Ux(47), y: UIApplication.shared.statusBarFrame.height+Uy(69), width: Ux(49), height: Uy(40))
        self.dayLabel.font = UIFont(name: "NanumBarunpen-Bold", size: 25.0)
        
        
        self.weekDayLabel = self.appDelegate.ub.buildLabel(target: self.weekDayLabel, text: labelArr.weekDay, color: "#C0392B", textAlignment: .center, x: Ux(49), y: UIApplication.shared.statusBarFrame.height+Uy(112), width: Ux(49), height: Uy(40))
        self.weekDayLabel.font = UIFont(name: "NanumBarunpen-Bold", size: 25.0)
        
        
        //현재 상황은, 8.25 (m=3) -> 8.26 (m=2) -> 8.27 (m=2) -> 8.26 (m=2) -> 8.25 (m=2). 좌우 스와이프해서 오늘로 돌아와도
        //meal은 2로 통일된다. 새로고침을 해야지만 현재 meal이 반영된다.
        //해결할 필요가 있을지 잘 모르겠다. 해결은 어렵지 않음.
        
        
        //글자크기 adjust!
        
        
        self.morningButton = self.appDelegate.ub.buildButton(target: self.morningButton, title: "아침", titleColor: "#FFFFFF", imageName: "", backgroundColor: "", x: Ux(66), y: UIApplication.shared.statusBarFrame.height+Uy(269), width: Ux(49), height: Uy(23))
        self.morningButton.titleLabel?.font = UIFont(name: "NanumBarunpen-Bold", size: 30.0)
        
        
        self.lunchButton = self.appDelegate.ub.buildButton(target: self.lunchButton, title: "점심", titleColor: "#FFFFFF", imageName: "", backgroundColor: "", x: Ux(66), y: UIApplication.shared.statusBarFrame.height+Uy(365), width: Ux(49), height: Uy(23))
        self.lunchButton.titleLabel?.font = UIFont(name: "NanumBarunpen-Bold", size: 30.0)
        
        
        self.dinnerBtn = self.appDelegate.ub.buildButton(target: self.dinnerBtn, title: "저녁", titleColor: "#FFFFFF", imageName: "", backgroundColor: "", x: Ux(66), y: UIApplication.shared.statusBarFrame.height+Uy(456), width: Ux(49), height: Uy(23))
        self.dinnerBtn.titleLabel?.font = UIFont(name: "NanumBarunpen-Bold", size: 30.0)
        
        
        
        self.menuView.backgroundColor = UIColor.clear
        self.menuView.frame = CGRect(x: Ux(240), y: UIApplication.shared.statusBarFrame.height, width: Ux(270), height: Uy(504))

        
        
        //menu label 설정은 좀 나중에 해도 될 것 같다. 아니다. 선언은 처음에 다 하고, 나중에 텍스트만 바꿔주자.
        self.menu1 = self.appDelegate.ub.buildLabel(target: self.menu1, text: "menu1", color: "#FFFFFF", textAlignment: .center, x: Ux(239), y: UIApplication.shared.statusBarFrame.height+Uy(99), width: Ux(178), height: Uy(23))
        self.menu1.font = UIFont(name: "NanumBarunpen", size: 25.0)
        
        self.menu2 = self.appDelegate.ub.buildLabel(target: self.menu2, text: "menu2", color: "#FFFFFF", textAlignment: .center, x: Ux(239), y: UIApplication.shared.statusBarFrame.height+Uy(150), width: Ux(178), height: Uy(23))
        self.menu2.font = UIFont(name: "NanumBarunpen", size: 25.0)
        
        self.menu3 = self.appDelegate.ub.buildLabel(target: self.menu3, text: "menu3", color: "#FFFFFF", textAlignment: .center, x: Ux(239), y: UIApplication.shared.statusBarFrame.height+Uy(202), width: Ux(178), height: Uy(23))
        self.menu3.font = UIFont(name: "NanumBarunpen", size: 25.0)
        
        self.menu4 = self.appDelegate.ub.buildLabel(target: self.menu4, text: "menu4", color: "#FFFFFF", textAlignment: .center, x: Ux(239), y: UIApplication.shared.statusBarFrame.height+Uy(254), width: Ux(178), height: Uy(23))
        self.menu4.font = UIFont(name: "NanumBarunpen", size: 25.0)
        
        
        self.specialLabel = self.appDelegate.ub.buildLabel(target: self.specialLabel, text: "<특식>", color: "#FFFFFF", textAlignment: .center, x: Ux(239), y: UIApplication.shared.statusBarFrame.height+Uy(339), width: Ux(178), height: Uy(23))
        self.menu4.font = UIFont(name: "NanumBarunpen", size: 25.0)
        
        
        self.menuSpecial = self.appDelegate.ub.buildLabel(target: self.menuSpecial, text: "menuSpecial", color: "#FFFFFF", textAlignment: .center, x: Ux(239), y: UIApplication.shared.statusBarFrame.height+Uy(383), width: Ux(178), height: Uy(23))
        self.menuSpecial.font = UIFont(name: "NanumBarunpen", size: 25.0)
        
        
        
        self.ratingBtn = self.appDelegate.ub.buildButton(target: self.ratingBtn, title: "오늘 밥은 몇 점?", titleColor: "#FFFFFF", imageName: "gray_bottom", backgroundColor: "", x: 0, y: self.view.frame.height*(33/40), width: self.view.frame.width, height: self.view.frame.height*(7/40))
        self.ratingBtn.titleLabel?.font = UIFont(name: "NanumBarunpen-Bold", size: 25.0)
        self.ratingBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: self.ratingBtn.currentImage!.size.width * -1, bottom: 0, right: 0)
        self.ratingBtn.contentMode = .scaleToFill
        
    }
    
    
    
    func addSubviews() {
    
        self.view.addSubview(backgroundView)
        
        self.view.addSubview(monthLabel)
        self.view.addSubview(dayLabel)
        self.view.addSubview(weekDayLabel)
        
        self.view.addSubview(morningButton)
        self.view.addSubview(lunchButton)
        self.view.addSubview(dinnerBtn)
        
        
        self.view.addSubview(menu1)
        self.view.addSubview(menu2)
        self.view.addSubview(menu3)
        self.view.addSubview(menu4)
        self.view.addSubview(menuSpecial)
        self.view.addSubview(menuView)
        
        //menu들을 menuView의 subview가 아니라, 전체 화면 view의 subview로 등록했음에 유의.
        
        self.view.addSubview(ratingBtn)
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
        self.monthLabel.text = labelArr.nextMonth
        self.dayLabel.text = labelArr.nextDay
        self.weekDayLabel.text = dateAndTime.weekDayToString(weekDayInt: labelArr.nextWeekDay)
        
        self.sendQuery(qDate: self.date, qMeal: self.meal)
        self.shareVariable()
    }
    
    
    
    //ViewController.swift 안의 self 변수를 언제 할당해줄지 잘 모르겠음.
    
    //nextDate 함수가 바뀌어야함 - nextMonth, nextDay, nextWkday 도 같이 전달받아야함.
    //date, meal은 sendQuery할때 필요. month, day는 디스플레이 위해 필요.
    
    //self.weekday는 필요 없는 변수라는 직관이 든다. 좀 더 생각해보자.
    
    
    
    func swpRight() {
    
        print("DEBUG: func swpRight")
        let labelArr = dateAndTime.prevMenu(nowDate: self.date, nowWeekDay: self.weekDay)
        self.date = labelArr.prevDate
        self.meal = 2
        self.monthLabel.text = labelArr.prevMonth
        self.dayLabel.text = labelArr.prevDay
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
        
        self.monthLabel.text = labelArr.month
        self.dayLabel.text = labelArr.day
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
    
    
    
    
    
    let slideInLauncher = SlideInLauncher()
    
    func touchRatingBtn() {
    
        print("DEBUG: func touchRatingBtn")
        slideInLauncher.showCurtain()
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