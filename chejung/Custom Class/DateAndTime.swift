//
//  DateAndTime.swift
//  chejung
//
//  Created by 윤희상 on 2017. 8. 21..
//  Copyright © 2017년 Clutch Studio. All rights reserved.
//

import UIKit

//DateAndTime.swift는 날짜 관련 요소들을 다루는 클래스임.
class DateAndTime: NSObject {
    
    var weekDay: Int = 0 //일요일이 1, 토요일이 7
    var meal: Int = 0 //아침이면 1, 점심이면 2, 저녁이면 3
    var date: String = ""
    
    
    
    //setNow는 self.date, self.meal, self.weekDay를 현재 시간&날짜에 맞게 설정해줌.
    func setNow() {
        
        let today = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HHmm"
        
        self.date = dateFormatter.string(from: today)
        //dateFormatter라는 기능 이용해 self.date에 '20171017'꼴의 string값이 저장되도록 함.
        self.weekDay = Calendar.current.component(.weekday, from: today)
        //weekDay는 요일임. 일요일이 1, 월요일이 2, ..., 토요일이 7의 값을 가짐.
        
        
        //10시, 16시, 22시 기준으로 self.meal값이 바뀌도록 설정해줌. 1은 아침, 2는 점심, 3은 저녁.
        if Int(timeFormatter.string(from: today))! < 1000 {
            self.meal = 1
        } else if Int(timeFormatter.string(from: today))! < 1600 {
            self.meal = 2
        } else if Int(timeFormatter.string(from: today))! < 2200 {
            self.meal = 3
        } else {
            //다음날 아침이 보여져야.
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
            self.date = dateFormatter.string(from: tomorrow!)
            self.meal = 1
            self.weekDay = Calendar.current.component(.weekday, from: tomorrow!)
        }
    }
    
    
    
    
    
    //ViewController.swift에서 라벨 텍스트 설정해줌.
    func setMonthDayString(date: String, meal: Int, weekDay: Int) -> (month: String, day: String, weekDay: String, meal: Int) {
        
        //마지막에 리턴 위해서 Zmonth, Zday 변수 새롭게 선언.
        var Zmonth: String = ""
        var Zday: String = ""
        //dateArr: 20170930을 길이 8의 문자열로 분해한 배열. 이 안에서 월/일 값을 찾아 리턴해주어야함.
        var dateArr = Array(date.characters)
        
        //9월 30일의 경우, 20170930에서 09월이 아니라 9월이 표시되어야 하므로, 0인지 아닌지 분석하는 작업이 필요.
        if dateArr[4] == "0" {
            Zmonth = String(dateArr[5])
        } else {
            Zmonth = String(dateArr[4]) + String(dateArr[5])
        }
        
        //같은 작업을 날짜(일)에 대해서 반복해주어야 함.
        if dateArr[6] == "0" {
            Zday = String(dateArr[7])
        } else {
            Zday = String(dateArr[6]) + String(dateArr[7])
        }
        
        //리턴해주는 값 중에서 파라미터를 이용해 각각 라벨에 필요한 텍스트를 할당할 수 있도록 하였음.
        return (Zmonth, Zday, self.weekDayToString(weekDayInt: weekDay), meal)
    }
    
    
    //weekDay 변수는 아직 숫자이기 때문에, 일월화수목금토 한글로 바꿔주는 switch문이 필요함.
    func weekDayToString(weekDayInt: Int) -> String {
    
        var weekdayAsChar: String = ""
        
        switch weekDayInt {
            case 1 : weekdayAsChar = "(일)"
            case 2 : weekdayAsChar = "(월)"
            case 3 : weekdayAsChar = "(화)"
            case 4 : weekdayAsChar = "(수)"
            case 5 : weekdayAsChar = "(목)"
            case 6 : weekdayAsChar = "(금)"
            case 7 :  weekdayAsChar = "(토)"
            default : weekdayAsChar = "(?)"
        }
        
        return weekdayAsChar
    }
    
    

    //다음날 메뉴 (오른쪽으로 스와이프한 경우) 를 찾기 위해 다음날 (20171018, 10, 18, 4 (수욜)) 값을 리턴해주는 함수가 필요.
    //실제 메뉴 쿼리 보내는 작업은 ViewController.swift에서 진행.
    //스와이프하면 무조건 self.meal=2 가 되도록 설정하였음.
    func nextMenu (nowDate: String, nowWeekDay: Int) -> (nextDate: String, nextMonth: String, nextDay: String, nextWeekDay: Int) {
        
        
        let dfmt = DateFormatter()
        dfmt.dateFormat = "yyyyMMdd"
        let dateNow = dfmt.date(from: nowDate)
        let dateTom = Calendar.current.date(byAdding: .day, value: 1, to: dateNow!)
        let dateTomString = dfmt.string(from: dateTom!)
        
        var Zmonth: String = ""
        var Zday: String = ""
        var dateArr = Array(dateTomString.characters)
        
        if dateArr[4] == "0" {
            Zmonth = String(dateArr[5])
        } else {
            Zmonth = String(dateArr[4]) + String(dateArr[5])
        }
        
        if dateArr[6] == "0" {
            Zday = String(dateArr[7])
        } else {
            Zday = String(dateArr[6]) + String(dateArr[7])
        }
        
        return (dfmt.string(from: dateTom!), Zmonth, Zday, Calendar.current.component(.weekday, from: dateTom!))
    }
    
    
    //전날 메뉴 확인할 때에도 같은 함수 필요.
    func prevMenu (nowDate: String, nowWeekDay: Int) -> (prevDate: String, prevMonth: String, prevDay: String, prevWeekDay: Int) {
        
        let dfmt = DateFormatter()
        dfmt.dateFormat = "yyyyMMdd"
        let dateNow = dfmt.date(from: nowDate)
        let dateYes = Calendar.current.date(byAdding: .day, value: -1, to: dateNow!)
        let dateYesString = dfmt.string(from: dateYes!)
        
        var Zmonth: String = ""
        var Zday: String = ""
        var dateArr = Array(dateYesString.characters)
        
        if dateArr[4] == "0" {
            Zmonth = String(dateArr[5])
        } else {
            Zmonth = String(dateArr[4]) + String(dateArr[5])
        }
        
        if dateArr[6] == "0" {
            Zday = String(dateArr[7])
        } else {
            Zday = String(dateArr[6]) + String(dateArr[7])
        }
        
        return (dfmt.string(from: dateYes!), Zmonth, Zday, Calendar.current.component(.weekday, from: dateYes!))
    }
    
    
    
    override init() {
        super.init()
        //start doing something here maybe...
    }
    
}
