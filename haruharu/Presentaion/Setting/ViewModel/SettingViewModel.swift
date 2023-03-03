//
//  SettingViewModel.swift
//  haruharu
//
//  Created by SHSEO on 2023/03/03.
//

import Foundation


class SettingViewModel {
    
    func getCountDate(createdDate: String) -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")

        let createdDate = dateFormatter.date(from: createdDate)!
        let nowDate = dateFormatter.date(from: Date().toString()!)!

        return Int(nowDate.timeIntervalSince(createdDate)) / (60 * 60) / 24 + 1
    }
}
