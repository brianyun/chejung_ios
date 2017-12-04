//
//  ViewController.swift
//  chejung
//
//  Created by 윤희상 on 2017. 8. 21..
//  Copyright © 2017년 Clutch Studio. All rights reserved.
//

import UIKit

//ViewController는 메인 작업이 일어나는 클래스.
class ViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var weekDay: Int = 0
    var meal: Int = 0 //아침이면 1, 점심이면 2, 저녁이면 3
    var date: String = ""
    var month: Int = 0 //사소하지만, date는 String이고 month, day는 Int형 변수이다.
    var day: Int = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
        self.addSubviews()
        self.addTargets()
        
        self.sendQuery(qDate: self.date, qMeal: self.meal)
        self.getRating(qDate: self.date, qMeal: self.meal)
        self.shareVariable()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set("kGAIScreenName", value: "ViewController")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    
    //sendQuery는 qDate, qMeal에 맞추어 서버에 요청을 보내, 해당 식단을 리턴받는 함수임.
    func sendQuery(qDate: String, qMeal: Int) -> () {
        
        print("DEBUG: sendQuery is initiated.")
        //let localURL = URL(string: "http://172.30.1.16:7777/menu/search?date="+qDate+"&meal="+String(qMeal))
        let serverURL = URL(string: "http://13.124.139.15:7777/menu/search?date="+qDate+"&meal="+String(qMeal))
        
        var request2 = URLRequest(url: serverURL!)
        request2.httpMethod = "GET"
        
        let doTask = URLSession.shared.dataTask(with: request2) {(data, response, error) -> Void in
            
            //인터넷 연결이 없는 경우 이렇게 에러 처리를 해주어야 함. 안할 경우 그냥 앱이 crash함.
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
    
    
    //getRating은 '0.0 / 5.0' 텍스트를 받는 함수임. 이건 나중에 업데이트를 의식한 미완성 코드임.
    func getRating(qDate: String, qMeal: Int) -> () {
        
        print("DEBUG: getRating is initiated.")
        //let localURL = URL(string: "http://172.31.0.245:7777/menu/rating?date="+qDate+"&meal="+String(qMeal))
        let serverURL = URL(string: "http://13.124.139.15:7777/menu/rating?date="+qDate+"&meal="+String(qMeal))
        
        var request3 = URLRequest(url: serverURL!)
        request3.httpMethod = "GET"
        
        let doTask = URLSession.shared.dataTask(with: request3) {(data, response, error) -> Void in
            
            if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet
            {
                print("DEBUG: No internet")
                DispatchQueue.main.async(execute: {
                    self.specialRating.text = "no internet"
                })
            } else {
                let dataStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                print("DEBUG: dataStr is: \(dataStr)")
                
                DispatchQueue.main.async(execute: {
                    self.specialRating.text = dataStr
                })
            }
        }
        doTask.resume()
    }
    
    
    
    
    var backgroundView = UIImageView()
    
    var dorm1 = UILabel()
    var dorm2 = UILabel()
    var dorm3 = UILabel()
    var timeLabel = UILabel()
    var timeString : String = ""
    
    var nextBtn = UIButton()
    var backBtn = UIButton()
    
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
    var specialRating = UILabel()
    
    var ratingLabel = UILabel()
    var ratingImageView = UIImageView()
    
    let dateAndTime = DateAndTime()

    
    func setUI() {
        
        print("DEBUG: width: \(self.view.frame.width)")
        print("DEBUG: height: \(self.view.frame.height)")
        
        
        //일단 현재 날짜/시간을 받아와서 self에 저장한다.
        dateAndTime.setNow()
        self.date = dateAndTime.date
        self.meal = dateAndTime.meal
        self.weekDay = dateAndTime.weekDay
        //labelArr는 라벨 텍스트 설정에 필요한 값들을 한번에 모아둔 배열임. 그 내용은 DateAndTime 클래스 안에 있는 함수로 구성.
        let labelArr = dateAndTime.setMonthDayString(date: dateAndTime.date, meal: dateAndTime.meal, weekDay: dateAndTime.weekDay)
        
        
        //backgroundView가 노랑/초록/빨강 배경화면임. Assets 안에 image 이름을 각각 1, 2, 3으로 저장해, String(self.meal)이 바로 이미지 이름이 되도록 했음.
        //setUI() 안에서, 위에 상태표시바 높이만큼 시작점을 낮게 잡음. 이 설정은 일괄적으로 유지됨.
        self.backgroundView = self.appDelegate.ub.buildImageView(target: self.backgroundView, image: String(self.meal), contentMode: .scaleToFill, x: Ux(0), y: UIApplication.shared.statusBarFrame.height, width: Ux(375), height: Uy(504))
        self.backgroundView.isUserInteractionEnabled = true
        
        
        //앱 좌측 상단에 보이는 제중/법현/SK 글씨. 이미지 파일로 지정하면 좋았으련만 코드로 작성했다.
        //폰트는 나눔붓, 글씨 크기는 디바이스 따라 바뀌도록 adjustFontLabel()이라는 함수 만들어서 지정.
        self.dorm1 = self.appDelegate.ub.buildLabel(target: self.dorm1, text: "제중", color: "#000000", textAlignment: .center, x: Ux(0), y: UIApplication.shared.statusBarFrame.height+Uy(10), width: Ux(86), height: Uy(45))
        adjustFontLabel(label: self.dorm1, style: "NanumBrushOTF")
        
        self.dorm2 = self.appDelegate.ub.buildLabel(target: self.dorm2, text: "법현", color: "#000000", textAlignment: .center, x: Ux(0), y: UIApplication.shared.statusBarFrame.height+Uy(55), width: Ux(86), height: Uy(45))
        adjustFontLabel(label: self.dorm2, style: "NanumBrushOTF")
        
        self.dorm3 = self.appDelegate.ub.buildLabel(target: self.dorm3, text: "SK", color: "#000000", textAlignment: .center, x: Ux(0), y: UIApplication.shared.statusBarFrame.height+Uy(100), width: Ux(86), height: Uy(45))
        adjustFontLabel(label: self.dorm3, style: "NanumBrushOTF")
        
        
        //아침, 점심, 저녁 선택했을 때 보여지도록 라벨 만듦. 투명도 조정함으로서 선택된 라벨만 보이도록 함.
        self.morningLabel = self.appDelegate.ub.buildLabel(target: self.morningLabel, text: "아침", color: "#000000", textAlignment: .center, x: Ux(11), y: UIApplication.shared.statusBarFrame.height+Uy(275), width: Ux(68), height: Uy(66))
        adjustFontLabel(label: self.morningLabel, style: "NanumBarunpen")
        
        self.lunchLabel = self.appDelegate.ub.buildLabel(target: self.lunchLabel, text: "점심", color: "#FFFFFF", textAlignment: .center, x: Ux(11), y: UIApplication.shared.statusBarFrame.height+Uy(349), width: Ux(68), height: Uy(66))
        adjustFontLabel(label: self.lunchLabel, style: "NanumBarunpen")
        
        self.dinnerLabel = self.appDelegate.ub.buildLabel(target: self.dinnerLabel, text: "저녁", color: "#FFFFFF", textAlignment: .center, x: Ux(11), y: UIApplication.shared.statusBarFrame.height+Uy(424), width: Ux(68), height: Uy(66))
        adjustFontLabel(label: self.dinnerLabel, style: "NanumBarunpen")
        
        
        //아침, 점심, 저녁 버튼.
        self.morningButton = self.appDelegate.ub.buildButton(target: self.morningButton, title: "", titleColor: "#FFFFFF", imageName: "", backgroundColor: "", x: Ux(0), y: UIApplication.shared.statusBarFrame.height+Uy(259), width: Ux(86), height: Uy(74))
        
        self.lunchButton = self.appDelegate.ub.buildButton(target: self.lunchButton, title: "", titleColor: "#FFFFFF", imageName: "", backgroundColor: "", x: Ux(0), y: UIApplication.shared.statusBarFrame.height+Uy(356), width: Ux(86), height: Uy(74))
        
        self.dinnerBtn = self.appDelegate.ub.buildButton(target: self.dinnerBtn, title: "", titleColor: "#FFFFFF", imageName: "", backgroundColor: "", x: Ux(0), y: UIApplication.shared.statusBarFrame.height+Uy(429), width: Ux(86), height: Uy(74))
        
        
        //매뉴 배경. 투명한 UIView인데, user interaction (스와이프, 탭 등등)을 인식하기 위해 만들었음.
        self.menuView.backgroundColor = UIColor.clear
        self.menuView.frame = CGRect(x: Ux(105), y: UIApplication.shared.statusBarFrame.height, width: Ux(270), height: Uy(504))

        
        
        //메뉴 상단에 있는 '10월 17일 (수)' 라벨. 역시 글씨 크기 조정한다.
        self.timeString = labelArr.month+"월 "+labelArr.day+"일 "+labelArr.weekDay
        self.timeLabel = self.appDelegate.ub.buildLabel(target: self.timeLabel, text: self.timeString, color: "#FFFFFF", textAlignment: .center, x: Ux(142), y: UIApplication.shared.statusBarFrame.height+Uy(28), width: Ux(178), height: Uy(29))
        adjustFontLabel(label: self.timeLabel, style: "NanumBarunpen")
        
        
        //timeLabel 양쪽에 있는 <, >. 눌러도 아무 일도 일어나지 않는다.
        self.nextBtn = self.appDelegate.ub.buildButton(target: self.nextBtn, title: "", titleColor: "", imageName: "next", backgroundColor: "", x: Ux(335), y: UIApplication.shared.statusBarFrame.height+Uy(27), width: Ux(12), height: Uy(29))
        self.nextBtn.imageView?.contentMode = .scaleAspectFit
        
        self.backBtn = self.appDelegate.ub.buildButton(target: self.backBtn, title: "", titleColor: "", imageName: "back", backgroundColor: "", x: Ux(116), y: UIApplication.shared.statusBarFrame.height+Uy(27), width: Ux(12), height: Uy(29))
        self.backBtn.imageView?.contentMode = .scaleAspectFit
        
        
        
        //지금까지 읽으면서 알겠지만, (개체 좌표/화면 전체크기) 비율을 유지함으로서 디바이스에 관계없이 앱이 구동되도록 하였음. 그 함수가 Ux(), Uy().
        self.menu1 = self.appDelegate.ub.buildLabel(target: self.menu1, text: "로", color: "#FFFFFF", textAlignment: .center, x: Ux(142), y: UIApplication.shared.statusBarFrame.height+Uy(92), width: Ux(178), height: Uy(36))
        adjustFontLabel(label: self.menu1, style: "NanumBarunpen")
        
        self.menu2 = self.appDelegate.ub.buildLabel(target: self.menu2, text: "딩", color: "#FFFFFF", textAlignment: .center, x: Ux(142), y: UIApplication.shared.statusBarFrame.height+Uy(141), width: Ux(178), height: Uy(36))
        adjustFontLabel(label: self.menu2, style: "NanumBarunpen")
        
        self.menu3 = self.appDelegate.ub.buildLabel(target: self.menu3, text: "중", color: "#FFFFFF", textAlignment: .center, x: Ux(142), y: UIApplication.shared.statusBarFrame.height+Uy(189), width: Ux(178), height: Uy(36))
        adjustFontLabel(label: self.menu3, style: "NanumBarunpen")
        
        self.menu4 = self.appDelegate.ub.buildLabel(target: self.menu4, text: "!", color: "#FFFFFF", textAlignment: .center, x: Ux(142), y: UIApplication.shared.statusBarFrame.height+Uy(237), width: Ux(178), height: Uy(36))
        adjustFontLabel(label: self.menu4, style: "NanumBarunpen")
        
        
        self.specialLabel = self.appDelegate.ub.buildLabel(target: self.specialLabel, text: "<특식>", color: "#FFFFFF", textAlignment: .center, x: Ux(142), y: UIApplication.shared.statusBarFrame.height+Uy(317), width: Ux(178), height: Uy(36))
        adjustFontLabel(label: self.specialLabel, style: "NanumBarunpen")
        
        
        self.menuSpecial = self.appDelegate.ub.buildLabel(target: self.menuSpecial, text: "", color: "#FFFFFF", textAlignment: .center, x: Ux(142), y: UIApplication.shared.statusBarFrame.height+Uy(364), width: Ux(178), height: Uy(36))
        adjustFontLabel(label: self.menuSpecial, style: "NanumBarunpen")
        
        
        self.specialRating = self.appDelegate.ub.buildLabel(target: self.specialRating, text: "", color: "#FFFFFF", textAlignment: .center, x: Ux(142), y: UIApplication.shared.statusBarFrame.height+Uy(400), width: Ux(178), height: Uy(26))
        adjustFontLabel(label: self.specialRating, style: "NanumBarunpen")
        
        
        
        self.ratingLabel = self.appDelegate.ub.buildLabel(target: self.ratingLabel, text: "오늘 밥은 몇 점?", color: "#000000", textAlignment: .center, x: Ux(0), y: Uy(587), width: Ux(375), height: Uy(80))
        self.ratingLabel.font = UIFont(name: "NanumBarunpen", size: min(Ux(25.0), Uy(25.0)))
        self.ratingLabel.isUserInteractionEnabled = true
        
        
        //'오늘 밥은 몇 점?' 버튼의 배경이 되는 이미지뷰. 클릭하면 색깔이 짙게 바뀐다.
        self.ratingImageView = self.appDelegate.ub.buildImageView(target: self.ratingImageView, image: "gray_bottom", contentMode: .scaleToFill, x: Ux(0), y: Uy(587), width: Ux(375), height: Uy(80))
        
    }
    
    
    
    func addSubviews() {
    
        self.view.addSubview(backgroundView)
        
        self.view.addSubview(dorm1)
        self.view.addSubview(dorm2)
        self.view.addSubview(dorm3)
        
        self.view.addSubview(morningLabel)
        self.view.addSubview(lunchLabel)
        self.view.addSubview(dinnerLabel)
        
        //선택한 라벨 이외의 것들은 투명하게.
        switch self.meal{
        case 1:
            self.lunchLabel.alpha = 0
            self.dinnerLabel.alpha = 0
        case 2:
            self.morningLabel.alpha = 0
            self.dinnerLabel.alpha = 0
        case 3:
            self.morningLabel.alpha = 0
            self.lunchLabel.alpha = 0
        default:
            print("DEBUG: switch default func addSubviews()")
        }
        
        
        
        self.view.addSubview(morningButton)
        self.view.addSubview(lunchButton)
        self.view.addSubview(dinnerBtn)
        
        self.view.addSubview(timeLabel)
        self.view.addSubview(nextBtn)
        self.view.addSubview(backBtn)
        
        self.view.addSubview(menu1)
        self.view.addSubview(menu2)
        self.view.addSubview(menu3)
        self.view.addSubview(menu4)
        self.view.addSubview(specialLabel)
        self.view.addSubview(menuSpecial)
        self.view.addSubview(specialRating)
        //클릭 가능토록 하기 위해 마지막에 추가함.
        self.view.addSubview(menuView)
        
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
        
        self.menuView.addGestureRecognizer(swpLeft)
        self.menuView.addGestureRecognizer(swpRight)
        self.menuView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.swpDown)))
        
//        self.nextBtn.addTarget(self, action: #selector(self.swpLeft), for: .touchUpInside)
//        self.backBtn.addTarget(self, action: #selector(self.swpRight), for: .touchUpInside)
        
        let tapRating = UILongPressGestureRecognizer(target: self, action: #selector(self.touchRatingBtn))
        tapRating.minimumPressDuration = 0
        self.ratingLabel.addGestureRecognizer(tapRating)
    }
    
    func blackLabel() {
        self.timeLabel.textColor! = self.appDelegate.ub.hexToUIColor("000000")
        self.menu1.textColor! = self.appDelegate.ub.hexToUIColor("000000")
        self.menu2.textColor! = self.appDelegate.ub.hexToUIColor("000000")
        self.menu3.textColor! = self.appDelegate.ub.hexToUIColor("000000")
        self.menu4.textColor! = self.appDelegate.ub.hexToUIColor("000000")
        
        self.menuSpecial.textColor! = self.appDelegate.ub.hexToUIColor("000000")
        self.specialLabel.textColor! = self.appDelegate.ub.hexToUIColor("000000")
        self.specialRating.textColor! = self.appDelegate.ub.hexToUIColor("000000")
        self.backBtn.setImage(UIImage(named: "backB"), for: UIControlState.normal)
        self.nextBtn.setImage(UIImage(named: "nextB"), for: UIControlState.normal)
    }
    
    func whiteLabel() {
        self.timeLabel.textColor! = self.appDelegate.ub.hexToUIColor("FFFFFF")
        self.menu1.textColor! = self.appDelegate.ub.hexToUIColor("FFFFFF")
        self.menu2.textColor! = self.appDelegate.ub.hexToUIColor("FFFFFF")
        self.menu3.textColor! = self.appDelegate.ub.hexToUIColor("FFFFFF")
        self.menu4.textColor! = self.appDelegate.ub.hexToUIColor("FFFFFF")
        
        self.menuSpecial.textColor! = self.appDelegate.ub.hexToUIColor("FFFFFF")
        self.specialLabel.textColor! = self.appDelegate.ub.hexToUIColor("FFFFFF")
        self.specialRating.textColor! = self.appDelegate.ub.hexToUIColor("FFFFFF")
        self.backBtn.setImage(UIImage(named: "back"), for: UIControlState.normal)
        self.nextBtn.setImage(UIImage(named: "next"), for: UIControlState.normal)
    }
    
    
    
    //아침 눌렀을 경우에 아침만 보여지도록. 간단한 함수이다.
    func touchMorningBtn() {
        self.morningLabel.alpha = 1
        self.lunchLabel.alpha = 1
        self.dinnerLabel.alpha = 1
        self.blackLabel()
        
        print("DEBUG: func touchMorningBtn")
        self.meal = 1
        
        self.lunchLabel.alpha = 0
        self.dinnerLabel.alpha = 0
        
        //배경 이미지도 바꾸고
        self.backgroundView.image = UIImage(named: "1")
        //메뉴를 불러와야지
        self.sendQuery(qDate: self.date, qMeal: self.meal)
        //shareVariable()은 변수 공유를 위해 만듦.
        self.shareVariable()
    }
    
    
    
    func touchLunchBtn() {
        self.morningLabel.alpha = 1
        self.lunchLabel.alpha = 1
        self.dinnerLabel.alpha = 1
        self.whiteLabel()
        
        print("DEBUG: func touchLunchBtn")
        self.meal = 2
        
        self.morningLabel.alpha = 0
        self.dinnerLabel.alpha = 0
        
        self.backgroundView.image = UIImage(named: "2")
        self.sendQuery(qDate: self.date, qMeal: self.meal)
        self.shareVariable()
    }
    
    
    
    func touchDinnerBtn() {
        self.morningLabel.alpha = 1
        self.lunchLabel.alpha = 1
        self.dinnerLabel.alpha = 1
        self.whiteLabel()
        
        print("DEBUG: func touchDinnerBtn")
        self.meal = 3
        
        self.morningLabel.alpha = 0
        self.lunchLabel.alpha = 0
        
        self.backgroundView.image = UIImage(named: "3")
        self.sendQuery(qDate: self.date, qMeal: self.meal)
        self.shareVariable()
    }
    
    
    
    
    
    
    
    //다음날 메뉴
    func swpLeft() {
        //참고) swipe left라는 것은, 손가락이 왼쪽으로 간다는 의미이다. 즉 오른쪽에서 왼쪽으로 손가락을 끄는 것.
        print("DEBUG: func swpLeft")
        let labelArr = dateAndTime.nextMenu(nowDate: self.date, nowWeekDay: self.weekDay)
        self.date = labelArr.nextDate
        self.meal = 2
        self.morningLabel.alpha = 0
        self.lunchLabel.alpha = 1
        self.dinnerLabel.alpha = 0
        self.whiteLabel()
        
        self.timeString = labelArr.nextMonth+"월 "+labelArr.nextDay+"일 "+dateAndTime.weekDayToString(weekDayInt: labelArr.nextWeekDay)
        self.timeLabel.text = self.timeString
        self.backgroundView.image = UIImage(named: "2") //연욱이 피드백받고 추가.
        
        self.sendQuery(qDate: self.date, qMeal: self.meal)
        self.getRating(qDate: self.date, qMeal: self.meal)
        self.shareVariable()
    }
    
    
    //전날 메뉴
    func swpRight() {
    
        print("DEBUG: func swpRight")
        let labelArr = dateAndTime.prevMenu(nowDate: self.date, nowWeekDay: self.weekDay)
        self.date = labelArr.prevDate
        self.meal = 2
        self.morningLabel.alpha = 0
        self.lunchLabel.alpha = 1
        self.dinnerLabel.alpha = 0
        self.whiteLabel()
        
        self.timeString = labelArr.prevMonth+"월 "+labelArr.prevDay+"일 "+dateAndTime.weekDayToString(weekDayInt: labelArr.prevWeekDay)
        self.timeLabel.text = self.timeString
        self.backgroundView.image = UIImage(named: "2")
        
        self.sendQuery(qDate: self.date, qMeal: self.meal)
        self.getRating(qDate: self.date, qMeal: self.meal)
        self.shareVariable()
    }
    
    
    //새로고침 함수. swpDown으로 이름을 짓긴 했는데 메뉴를 탭할 경우에 호출된다.
    func swpDown() {
        self.morningLabel.alpha = 1
        self.lunchLabel.alpha = 1
        self.dinnerLabel.alpha = 1
        
        print("DEBUG: func swpDown")
        dateAndTime.setNow()
        self.date = dateAndTime.date
        self.meal = dateAndTime.meal
        self.weekDay = dateAndTime.weekDay
        let labelArr = dateAndTime.setMonthDayString(date: dateAndTime.date, meal: dateAndTime.meal, weekDay: dateAndTime.weekDay)
        
        self.backgroundView.image = UIImage(named: String(self.meal))
        
        switch self.meal{
        case 1:
            self.lunchLabel.alpha = 0
            self.dinnerLabel.alpha = 0
            self.blackLabel()
        case 2:
            self.morningLabel.alpha = 0
            self.dinnerLabel.alpha = 0
            self.whiteLabel()
        case 3:
            self.morningLabel.alpha = 0
            self.lunchLabel.alpha = 0
            self.whiteLabel()
        default:
            print("DEBUG: switch default func swpDown()")
        }
        
        self.timeString = labelArr.month+"월 "+labelArr.day+"일 "+labelArr.weekDay
        self.timeLabel.text = self.timeString
        
        self.sendQuery(qDate: self.date, qMeal: self.meal)
        self.getRating(qDate: self.date, qMeal: self.meal)
        self.shareVariable()
    }
    
    
    
    
    
    func shareVariable() {
    
        self.appDelegate.dateShared = self.date
        self.appDelegate.mealShared = self.meal
    }
    
    
    
    func Ux(_ n: CGFloat) -> CGFloat { return n*(self.view.frame.width/375) }
    func Uy(_ n: CGFloat) -> CGFloat { return n*(self.view.frame.height/667) }
    
    
    //글자크기를 디바이스에 맞추어 변화시키는 함수. NewLauncher()에서 쓰인 메커니즘과 다르다. 그냥 알아서 ㄱㄱ
    func adjustFontLabel(label: UILabel, style: String) {
        
        label.font = UIFont(name: style, size: 100)
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.1
        label.adjustsFontSizeToFitWidth = true
    }
    
    
    
    
    
    
    
    
    let newLauncher = NewLauncher()
    
    //'오늘 밥은 몇 점?' 버튼은 누르고 있을 경우에 색깔이 짙게 바뀌도록 만든 함수.
    func touchRatingBtn(gesture: UIPanGestureRecognizer) {
        
        let point = gesture.location(in: view)
        let ratingFrame = CGRect(x: Ux(0), y: Uy(587), width: Ux(375), height: Uy(80))
        
        if ratingFrame.contains(point) {
            self.ratingImageView.image = UIImage(named: "dark_bottom")
            if gesture.state == .ended {
                print("DEBUG: func touchRatingBtn")
                newLauncher.showSlide()
            }
        } else {
            self.ratingImageView.image = UIImage(named: "gray_bottom")
        }
        
        if gesture.state == .ended {
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
