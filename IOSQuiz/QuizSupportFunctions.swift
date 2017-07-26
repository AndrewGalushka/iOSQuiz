//
//  QuizSupportFunctions.swift
//  IOSQuiz
//
//  Created by galushka on 6/20/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

func convert(secondsToHoursMinutesSeconds seconds: Int) -> (hours: Int, minutes: Int, seconds: Int) {
    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
}

func convert(timeIntervalSince1970ToDate timeInterval: TimeInterval) -> Date {
    let epochDate = Date(timeIntervalSince1970: timeInterval)
    
    return epochDate
}

func convert(dateToQuizHistoryDateString date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, yyyy, h:mm"
    
    let stringDate = dateFormatter.string(from: date)
    
    return stringDate
}

func convert(dateToAmPmFormatString date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "a"
    
    return dateFormatter.string(from: date)
}
