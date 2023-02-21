//
//  AddViewController.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/21.
//

import Foundation
import UIKit

class AddViewController: UIViewController {
    
    lazy var addView = AddView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func loadView() {
        self.view = addView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
