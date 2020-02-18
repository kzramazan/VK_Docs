//
//  DateUtility.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/18/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import Foundation

/// Утилитарный класс для работы с Date
struct DateUtility {
    private static let weekdays = ["Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб"]
    private static let numberOfHoursInDay = 24.0
    static let minCheckInHour = 14
    static let maxCheckOutHour = 12
    /// Возвращает количество дней (суток) между двумя датами в виде строки
    ///
    /// - Parameters:
    ///   - startDate: начало
    ///   - endDate: конец
    /// - Returns: количество дней в виде строки
    static func generateNumberOfDaysAsString(startDate: Date, endDate: Date) -> String {
        let numberOfDays = DateUtility.calculateNumberOfDays(startDate: startDate, endDate: endDate)
        return "\(numberOfDays) \(numberOfDays > 1 ? "суток":"сутки")"
    }
    
    static func generateNumberOfDaysAsString(numberOfDays: Int) -> String {
        return "\(numberOfDays) \(numberOfDays > 1 ? "суток":"сутки")"
    }
    
    /// Возвращает количество дней между двумя датами
    ///
    /// - Parameters:
    ///   - startDate: начало
    ///   - endDate: конец
    /// - Returns: количество дней
    static func calculateNumberOfDays(startDate: Date, endDate: Date) -> Int {
        let hoursBetweenDates = max(Calendar.current.dateComponents([.hour], from: startDate, to: endDate).hour!, 1)
        return Int(ceil(Double(hoursBetweenDates)/DateUtility.numberOfHoursInDay))
    }
    
    /// Возвращает период между двумя датами в виде дня и месяца (22 янв - 25 янв)
    ///
    /// - Parameters:
    ///   - startDate: начало
    ///   - endDate: конец
    /// - Returns: период в виде "день месяц - день месяц"
    static func getPeriodAsDayAndMonth(startDate: Date, endDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM"
        dateFormatter.locale = Locale(identifier: "ru")
        return "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
    }
    
    /// Возвращает период между двумя датами в виде дня и месяца (22 янв. 14:00 - 25 янв. 12:00)
    ///
    /// - Parameters:
    ///   - startDate: начало
    ///   - endDate: конец
    /// - Returns: период в виде "день месяц - день месяц"
    static func getPeriodAsDayAndMonthAndTime(startDate: Date, endDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM HH:mm"
        dateFormatter.locale = Locale(identifier: "ru")
        return "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
    }
    
    /// Возвращает дату в виде день месяц
    ///
    /// - Parameter date: принимает дату
    /// - Returns: строка "день месяц"
    static func getDayAndMonthFrom(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM"
        dateFormatter.locale = Locale(identifier: "ru")
        return dateFormatter.string(from: date)
    }
    
    static func getHoursAndMinutesFrom(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    /// Возвращает дату в виде "25 дек. 2018 в 12:00"
    ///
    /// - Parameter date: Дата
    /// - Returns: Строка в виде "25 дек. 2018 в 12:00"
    static func getFullDateWithTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy 'в' HH:mm"
        return dateFormatter.string(from: date)
    }
    
    /// Возвращает дату в виде "25 дек. 2018"
    ///
    /// - Parameter date: Дата
    /// - Returns: Строка в виде "25 дек. 2018"
    static func getFullDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    
    static func getFullDateSeperatodByDots(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
}

extension DateUtility {
    static func ifCheckInToday(now: Date, timestamp: Date) -> Bool {
        let acceptableHour = 6
        let leftHour = Calendar.current.dateComponents([.hour], from: now, to: timestamp).hour
        if let leftHour = leftHour {
            return acceptableHour <= leftHour && leftHour >= 0
        }
        return false
    }
    
    static func getHourFrom(date: Date) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        return Int(dateFormatter.string(from: date))
    }
    
    static func getDateStringPastDates(from: Date, till: Date = Date()) -> String {
        let pastDate = Calendar.current.dateComponents([.year, .day, .hour], from: from, to: till)
        let years = pastDate.year
        let days = pastDate.day
        
        if let years = years, years > 0 {
            return getFullDate(date: from)
        }else if getWeekOfMonth(from: till) - getWeekOfMonth(from: from) > 0 {
            return getDayAndMonthFrom(date: from)
        }else if let days = days, days > 0 {
            return getWeekDay(from: from)
        }else {
            return getHoursAndMinutesFrom(date: from)
        }
    }
    
    static func getWeekDay(from date: Date) -> String {
        let dayNumber = Calendar.current.component(.weekday, from: date)
        return weekdays[dayNumber - 1]
    }
    
    static func getWeekOfMonth(from date: Date) -> Int {
        return Calendar.current.component(.weekOfMonth, from: date)
    }
}
