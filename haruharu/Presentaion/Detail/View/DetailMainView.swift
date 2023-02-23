//
//  DetailMainView.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/23.
//

import Foundation
import UIKit
import SnapKit

class DetailMainView: UIView {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(DetailMainViewCell.self, forCellWithReuseIdentifier: DetailMainViewCell.identifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.collectionView.layer.cornerRadius = 15
        self.collectionView.layer.shadowOpacity = 0.2
        self.collectionView.layer.shadowColor = UIColor.gray.cgColor
        self.collectionView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.collectionView.layer.shadowRadius = 2
        self.collectionView.layer.masksToBounds = true
        self.collectionView.backgroundColor = .cardViewBgColor
        self.collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setAttributo() {
        
    }
    
    private func setLayout() {
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.leading.top.bottom.trailing.equalToSuperview()
        }
    }
}
