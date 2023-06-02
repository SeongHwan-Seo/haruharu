//
//  HabitListViewCell.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/14.
//

import Foundation
import UIKit
import SnapKit
import KDCircularProgress


class HabitListViewCell: UITableViewCell {
    static let identifier = "HabitListViewCell"
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "별명"
        label.font = UIFont(name: "NanumGothicBold", size: 16)
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.8
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var startLabel: UILabel = {
        let label = UILabel()
        
        label.text = "2023.02.15 ~"
        label.font = UIFont(name: "NanumGothicBold", size: 13)
        label.textColor = .gray
        return label
    }()
    
    lazy var countLabel: UILabel = {
        let label = UILabel()
        
        label.text = "\(0)"
        label.textAlignment = .center
        label.font = UIFont(name: "NanumGothicBold", size: 16)
        
        return label
    }()
    
    lazy var linkBtn: UIButton = {
        let btn = UIButton()
        
        btn.setImage(UIImage(named: "ArrowIcon"), for: .normal)
        return btn
    }()
    
    
    lazy var verticalStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, startLabel])
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    var circleChart: KDCircularProgress!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20))
    }
    
    
    private func setAttribute() {
        self.backgroundColor = .bgColor
        
        circleChart = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        circleChart.startAngle = -90
        circleChart.progressThickness = 0.5
        circleChart.trackThickness = 0.6
        circleChart.clockwise = true
        circleChart.gradientRotateSpeed = 2
        circleChart.roundedCorners = true
        circleChart.glowMode = .forward
        circleChart.glowAmount = 0.3
        circleChart.trackColor = .bgColor!
        circleChart.set(colors: .btnBgColor!)
        circleChart.center = CGPoint(x: contentView.frame.origin.x + 40, y: contentView.frame.origin.y + 65)
        
        contentView.layer.cornerRadius = 15
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowColor = UIColor.gray.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowRadius = 2
        contentView.layer.masksToBounds = false
        contentView.backgroundColor = .cardViewBgColor
    }
    
    private func setLayout() {
        [titleLabel, startLabel].forEach {
            verticalStackView.addSubview($0)
        }
        
        
        [verticalStackView, circleChart, countLabel, linkBtn].forEach {
            self.contentView.addSubview($0)
        }
        
        
        countLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(25)
            $0.width.equalTo(30)
        }
        
        verticalStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(circleChart.snp.trailing).offset(12)
            $0.trailing.equalTo(linkBtn.snp.leading).offset(-15)
        }
        
        linkBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-15)
            $0.centerY.equalToSuperview()
        }
        
    }
}
