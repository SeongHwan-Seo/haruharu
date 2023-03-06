//
//  SettingMenu.swift
//  haruharu
//
//  Created by SHSEO on 2023/03/06.
//

import Foundation

enum SettingMenu: Int, CaseIterable {
    case rating
    case version
    case privacy
    
    var title: String {
        switch self {
        case .rating: return "하루하루 별점주기"
        case .version: return "앱 버전"
        case .privacy: return "개인정보처리방침"
        }
    }
}

