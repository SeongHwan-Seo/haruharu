//
//  NavigationController.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/14.
//

import Foundation
import UIKit

class NavigationController: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        self.navigationBar.tintColor = .fgTintColor
        self.navigationBar.topItem?.title = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
