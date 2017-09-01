//
//  DateAndTime.swift
//  chejung
//
//  Created by 윤희상 on 2017. 8. 21..
//  Copyright © 2017년 Clutch Studio. All rights reserved.
//

import UIKit

class DateAndTime: NSObject {
    
    var weekDay: Int = 0 //일요일이 1, 토요일이 7
    var meal: Int = 0 //아침이면 1, 점심이면 2, 저녁이면 3
    var date: String = ""
    
    
    //함수 각각의 역할에 대한 정리가 필요하다.
    //내일 해야겠다.
    
    
    
    //setNow는 self.date, self.meal, self.weekDay 정해줌.
    func setNow() {
        
        let today = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HHmm"
        
        self.date = dateFormatter.string(from: today)
        
        if Int(timeFormatter.string(from: today))! < 1000 {
            self.meal = 1
        } else if Int(timeFormatter.string(from: today))! < 1500 {
            self.meal = 2
        } else {
            self.meal = 3
        }
        
        self.weekDay = Calendar.current.component(.weekday, from: today)
    }
    
    
    
    //라벨 설정해줌.
    func setMonthDayString(date: String, meal: Int, weekDay: Int) -> (month: String, day: String, weekDay: String, meal: Int) {
        
        var Zmonth: String = ""
        var Zday: String = ""
        var dateArr = Array(date.characters)
        
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
        
        return (Zmonth, Zday, self.weekDayToString(weekDayInt: weekDay), meal)
    }
    
    
    
    func weekDayToString(weekDayInt: Int) -> String {
    
        var weekdayAsChar: String = ""
        
        switch weekDayInt {
            case 1 : weekdayAsChar = "일"
            case 2 : weekdayAsChar = "월"
            case 3 : weekdayAsChar = "화"
            case 4 : weekdayAsChar = "수"
            case 5 : weekdayAsChar = "목"
            case 6 : weekdayAsChar = "금"
            case 7 :  weekdayAsChar = "토"
            default : weekdayAsChar = "?"
        }
        
        return weekdayAsChar
    }
    
    

    
    //작업중임 아직.
    
    //날짜 바뀌면 무조건 점심 메뉴가 나오는걸로 하자. 장급식은 그럼. 생각해보니 중학교는 점심밖에 없긴 하다.
    //무조건 하나로 고정하는거 자체는 괜찮은듯.
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
