//
//  UIViewController+Ext.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/07.
//

import Foundation
import UIKit
// 키보드 숨기기
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
