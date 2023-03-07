//
//  SettingViewModel.swift
//  haruharu
//
//  Created by SHSEO on 2023/03/03.
//

import Foundation
import RxSwift
import UIKit

class SettingViewModel {
    
    var settingMenu = BehaviorSubject<[SettingMenu]>(value: SettingMenu.allCases)
    let storeURL = URL(string: "itms-apps://itunes.apple.com/app/id6446077663")!
    
    func getCountDate(createdDate: String) -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")

        let createdDate = dateFormatter.date(from: createdDate)!
        let nowDate = dateFormatter.date(from: Date().toString()!)!

        return Int(nowDate.timeIntervalSince(createdDate)) / (60 * 60) / 24 + 1
    }
    
    /// 현재 버전 가져오기
    func getCurrentVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
        return version
    }
    
    
    /// 앱스토어 이동
    func goToStore() {
        UIApplication.shared.open(storeURL)
    }
    
    
    /// 설정 - 알림 이동
    func goToAlarm() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}


