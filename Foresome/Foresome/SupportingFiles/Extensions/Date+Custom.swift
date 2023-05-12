//
//  Date+Custom.swift
//  Wedswing
//
//  Created by Rakesh Kumar on 27/06/18.
//  Copyright © 2018 rakesh. All rights reserved.
//

import UIKit

extension Date {
    
    func offsetFrom(date: Date) -> String {
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self)
        
        let seconds = "\(difference.second ?? 0) secs"
        let minutes = "\(difference.minute ?? 0) mins" + " " + seconds
        let hours = "\(difference.hour ?? 0) hrs"
        var  days = "\(difference.day ?? 0)"
        
        if (difference.hour ?? 0) > 0 {
            days = "\(difference.day ?? 0) days" + " " + hours
        }else  {
            days = "\(difference.day ?? 0) days"
        }
        
        if let day = difference.day, day          > 0 { return days }
        if let hour = difference.hour, hour       > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        if let second = difference.second, second > 0 { return seconds }
        return ""
    }
    
    func offsetFromDate(date: Date) -> String {
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self)
        var  seconds = "\(difference.second ?? 0) mins"
        if (difference.second ?? 0) < 10 {
            seconds = "0\(difference.second ?? 0) mins"
        } else  {
            seconds = "\(difference.second ?? 0) mins"
        }
        var minutes = "\(difference.minute ?? 0)"
        if (difference.minute ?? 0) > 0  {
            if (difference.minute ?? 0) < 10 {
                minutes = "0\(difference.minute ?? 0) :"
            }else  {
                minutes = "\(difference.minute ?? 0) :"
            }
        } else {
            minutes = "\(difference.minute ?? 0) :"
        }
        let hours = "\(difference.hour ?? 0) : " + "" + minutes + " hrs"
        var  days = "\(difference.day ?? 0)"
        
        if (difference.hour ?? 0) > 0 {
            days = "\(difference.day ?? 0) days" + " " + hours
        }else {
            minutes = "\(difference.minute ?? 0) : " + "" + seconds
            days = "\(difference.day ?? 0) days"
        }
        if let day = difference.day, day          > 0 { return days }
        if let hour = difference.hour, hour       > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        if let second = difference.second, second > 0 { return seconds }
        return ""
    }
    
    func localDate() -> Date {
        // 1) Get the current TimeZone's seconds from GMT. Since I am in Chicago this will be: 60*60*5 (18000)
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
        // 2) Get the current date (GMT) in seconds since 1970. Epoch datetime.
        let epochDate = self.timeIntervalSince1970
        
        // 3) Perform a calculation with timezoneOffset + epochDate to get the total seconds for the
        //    local date since 1970.
        //    This may look a bit strange, but since timezoneOffset is given as -18000.0, adding epochDate and timezoneOffset
        //    calculates correctly.
        let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
        
        // 4) Finally, create a date using the seconds offset since 1970 for the local date.
        let timeZoneOffsetDate = Date(timeIntervalSince1970: timezoneEpochOffset)
        return timeZoneOffsetDate
    }
    
    func utcDate() -> Date {
        // 1) Get the current TimeZone's seconds from GMT. Since I am in Chicago this will be: 60*60*5 (18000)
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
        
        // 2) Get the current date (GMT) in seconds since 1970. Epoch datetime.
        let epochDate = self.timeIntervalSince1970
        
        // 3) Perform a calculation with timezoneOffset + epochDate to get the total seconds for the
        //    local date since 1970.
        //    This may look a bit strange, but since timezoneOffset is given as -18000.0, adding epochDate and timezoneOffset
        //    calculates correctly.
        let timezoneEpochOffset = (epochDate - Double(timezoneOffset))
        
        // 4) Finally, create a date using the seconds offset since 1970 for the local date.
        let timeZoneOffsetDate = Date(timeIntervalSince1970: timezoneEpochOffset)
        return timeZoneOffsetDate
    }
    
    
    static var tomorrow: Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date())
    }
    
    func addingDays(value: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: value, to: self)!
    }
    
    func adding(value: Int, to copo: Calendar.Component) -> Date {
        return Calendar.current.date(byAdding: copo, value: value, to: self)!
    }
    
    public func component(_ component:Calendar.Component) -> DateComponents {
        return Calendar.current.dateComponents([component], from: self)
    }
    
    public func component(_ component:Calendar.Component, for date: Date) -> DateComponents {
        return Calendar.current.dateComponents([component], from: self, to: date)
    }
    
    
    func dateToString(format:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        //dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }
    
    func timeFormatForChat() -> String {
        if self.isToday {
            return "Today \(self.dateToString(format: "hh:mm a"))"
        } else if self.isYesterday {
            return "Yesterday \(self.dateToString(format: "hh:mm a"))"
        } else {
            return self.dateToString(format: "dd:mm:yy hh:mm a")
        }
    }
    
    func setTime(hours: Int, minutes: Int, seconds: Int = 0) -> Date {
        if let date = Calendar.current.date(bySettingHour: hours, minute: minutes, second: seconds, of: self) {
            return date
        } else {
            return self
        }
    }
    
    var day: Int? {
        let str = self.toString(format: "dd")
        return str.toInt
    }
    
    
    //    mutating func setTime(hours:Int, minutes:Int, seconds: Int = 0) {
    //        if let date = Calendar.current.date(bySettingHour: hours, minute: minutes, second: seconds, of: self) {
    //            self = date
    //        }
    //    }
    
    
    var isToday:Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    var isYesterday:Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    var isTomorrow:Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
    
    func getComponent(_ component:Calendar.Component) -> Int {
        return Calendar.current.component(component, from: self)
    }
    
    public func monthDays(year:Int, month:Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        print(numDays) // 31
        return numDays
    }
    
    func miliseconds() -> Double {
        return self.timeIntervalSince1970 * 1000
    }
    
    func dateToUTCString(format: String)->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format  //Your New Date format as per requirement change it own
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let newDate = dateFormatter.string(from: self)
        print(newDate)
        return newDate
    }
    
    func dateToUTCString(format: String.format) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US")
        let newDate = dateFormatter.string(from: self)
        return newDate
    }
    
    //date to string
    //    func dateToString(format:String)->String {
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = format  //Your New Date format as per requirement change it own
    //        dateFormatter.locale = Locale(identifier: "en_US")
    //        let newDate = dateFormatter.string(from: self)
    //        print(newDate)
    //        return newDate
    //    }
    
    
    var localToUtc: Date? {
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.calendar = Calendar.current
        //        dateFormatter.timeZone = TimeZone.current
        //        let dateStr = dateFormatter.string(from: self)
        //        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        //        dateFormatter.dateFormat = String.format.full1.rawValue
        //        return dateFormatter.date(from: dateStr)
        
        let date = self.dateToUTCString(format: .full1)
        return date.changeToDateStandard(withFormat: .full1)
        
    }
    
    var utcToLocal: Date? {
        let str = toStringStandard(format: .full1)
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dateStr = dateFormatter.string(from: self)
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.date(from: dateStr)
    }
    
    func timeAgoSinceDate() -> String {
        // From Time
        let fromDate = self
        // To Time
        let toDate = Date()
        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
            // return interval == 1 ? "\(interval)" + " " + "y" : "\(interval)" + " " + "y"
        }
        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
            // return interval == 1 ? "\(interval)" + " " + "m" : "\(interval)" + " " + "m"
        }
        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
            //return interval == 1 ? "\(interval)" + " " + "d" : "\(interval)" + " " + "d"
        }
        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
            // return interval == 1 ? "\(interval)" + " " + "h" : "\(interval)" + " " + "h"
        }
        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "min ago" : "\(interval)" + " " + "mins ago"
            //return interval == 1 ? "\(interval)" + " " + "m" : "\(interval)" + " " + "m"
        }
        return "just now"
    }
    
    func timeleftFromDate() -> String {
        // From Time
        let fromDate = self
        // To Time
        let toDate = Date()
        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: toDate, to: fromDate).year, interval > 0  {
            return interval == 1 ? "\(interval)" + " " + "year left" : "\(interval)" + " " + "years left"
            // return interval == 1 ? "\(interval)" + " " + "y" : "\(interval)" + " " + "y"
        }
        // Month
        if let interval = Calendar.current.dateComponents([.month], from: toDate, to: fromDate).month, interval > 0  {
            return interval == 1 ? "\(interval)" + " " + "month left" : "\(interval)" + " " + "months left"
            // return interval == 1 ? "\(interval)" + " " + "m" : "\(interval)" + " " + "m"
        }
        // Day
        if let interval = Calendar.current.dateComponents([.day], from: toDate, to: fromDate).day, interval > 0  {
            return interval == 1 ? "\(interval)" + " " + "day left" : "\(interval)" + " " + "days left"
            //return interval == 1 ? "\(interval)" + " " + "d" : "\(interval)" + " " + "d"
        }
        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: toDate, to: fromDate).hour, interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "hour left" : "\(interval)" + " " + "hours left"
            // return interval == 1 ? "\(interval)" + " " + "h" : "\(interval)" + " " + "h"
        }
        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: toDate, to: fromDate).minute, interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "min left" : "\(interval)" + " " + "mins left"
            //return interval == 1 ? "\(interval)" + " " + "m" : "\(interval)" + " " + "m"
        }
        return "just now"
    }
    
    
    
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 {
            return years(from: date) == 1 ? "\(years(from: date))yr" : "\(years(from: date))yrs"
        }
        if months(from: date)  > 0 {
            return months(from: date) == 1 ? "\(months(from: date))month" : "\(months(from: date))months"
        }
        if weeks(from: date)   > 0 {
            return weeks(from: date) == 1 ? "\(weeks(from: date))week" : "\(weeks(from: date))weeks"
        }
        if days(from: date)    > 0 {
            return days(from: date) == 1 ? "\(days(from: date))day" : "\(days(from: date))days"
        }
        if hours(from: date)   > 0 {
            return hours(from: date) == 1 ? "\(hours(from: date))hr" : "\(hours(from: date))hrs"
        }
        if minutes(from: date) > 0 {
            return minutes(from: date) == 1 ? "\(minutes(from: date))min" : "\(minutes(from: date))mins"
        }
        if seconds(from: date) > 0 {
            return seconds(from: date) == 1 ? "\(seconds(from: date))sec" : "\(seconds(from: date))secs"
        }
        return "just now"
    }
    
    func timeAgo() -> String {
        return self.offset(from: Date())
    }
    
}

extension Date {
    var month1: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M"
        return dateFormatter.string(from: self)
    }
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
    var MMMM: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy"
        return dateFormatter.string(from: self)
    }
    var yyyy: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: self).capitalized
    }
    
    func toStringStandard(format: String.format) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.ReferenceType.local
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
    
    func toStringStandard(format string: String) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.ReferenceType.local
        formatter.dateFormat = string
        return formatter.string(from: self)
    }
    
    func toString(format: String.format) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
    
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func toStringFormat(format: String = "dd/MM/yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    
    
    var startOfMonth: Date {
        let calendar = Calendar(identifier: .indian)
        let components = calendar.dateComponents([.year, .month], from: self)
        return  calendar.date(from: components)!
    }
    
    var currentMonthDates: [Date] {
        let calendar = Calendar.current
        let interval = calendar.dateInterval(of: .month, for: self)!
        
        // Fetch Total days in a month
        let days = calendar.dateComponents([.day], from: self, to: interval.end).day!
        
        var dates: [Date] = []
        
        for i in 0..<days {
            let nextDay = calendar.date(byAdding: .day, value: i, to: self)
            dates.append(nextDay!)
        }
        
        return dates
    }
    
    var startTime: Date? {
        let date = self.toString(format: .ddM3y4)
        let start = "\(date) 00:00".changeToDate(withFormat: .ddM3y4HHmm)
        return start
    }
    
    var endTime: Date? {
        let date = self.toString(format: .ddM3y4)
        let end = "\(date) 23:59".changeToDate(withFormat: .ddM3y4HHmm)
        return end
    }
    
}


extension Date {
    
    public func dateByAdding(value:Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: value, to: self)!
    }
    
    public func monthByAdding(value:Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: value, to: self)!
    }
    
    public func yearByAdding(value:Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: value, to: self)!
    }
    
    
    func isEqualTo(_ date: Date) -> Bool {
        let date1 = self.toStringStandard(format: .ddM3y4).changeToDateStandard(withFormat: .ddM3y4)
        let date2 = date.toStringStandard(format: .ddM3y4).changeToDateStandard(withFormat: .ddM3y4)
        return date1 == date2
    }
    
    func isGreaterThan(_ date: Date) -> Bool {
        let date1 = self.toStringStandard(format: .ddM3y4).changeToDateStandard(withFormat: .ddM3y4)
        let date2 = date.toStringStandard(format: .ddM3y4).changeToDateStandard(withFormat: .ddM3y4)
        return date1! > date2!
    }
    
    func isSmallerThan(_ date: Date?) -> Bool {
        let date1 = self.toStringStandard(format: .ddM3y4).changeToDateStandard(withFormat: .ddM3y4)
        let date2 = date?.toStringStandard(format: .ddM3y4).changeToDateStandard(withFormat: .ddM3y4)
        return date1! < date2!
    }
}


