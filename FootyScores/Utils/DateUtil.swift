//
//  DateUtil.swift
//  FootyScores
//
//  Created by Ramon Schriks on 22-10-17.
//  Copyright © 2017 Ramon Schriks. All rights reserved.
//

import Foundation

class DateUtil {
    
    public static func getStringDateFrom(days from: Int)-> String {
        let date = Date(timeInterval: TimeInterval(-(from*86400)), since: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
    
    public static func getStringDateTo(days to: Int)-> String {
        let date = Date(timeInterval: TimeInterval(to*86400), since: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
}
