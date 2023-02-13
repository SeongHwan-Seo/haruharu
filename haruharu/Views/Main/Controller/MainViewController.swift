//
//  MainViewController.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/01.
//

import Foundation
import UIKit
import SnapKit


class MainViewController: UIViewController {
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        bind()
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func bind() {
        
    }
    
    private func setAttribute() {
        self.view.backgroundColor = .secondarySystemBackground
        
    }
    
    private func setLayout() {
        
    }
    
    
}
