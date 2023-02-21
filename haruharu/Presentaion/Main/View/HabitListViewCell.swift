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
    
    lazy var uiView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.shadowOpacity = 0.2
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 2
        view.layer.masksToBounds = false
        view.backgroundColor = .cardViewBgColor
        //view.backgroundColor = .red
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "별명"
        label.font = UIFont(name: "NanumGothicBold", size: 16)
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
        print("HabitListViewCell init")
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
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
        circleChart.center = CGPoint(x: uiView.frame.origin.x + 40, y: uiView.frame.origin.y + 60)
        
        
    }
    
    private func setLayout() {
        [titleLabel, startLabel].forEach {
            verticalStackView.addSubview($0)
        }
        
        [ circleChart, countLabel, linkBtn].forEach {
            self.uiView.addSubview($0)
        }
        
        [uiView, verticalStackView].forEach {
            self.contentView.addSubview($0)
        }
        
        uiView.snp.makeConstraints{
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        countLabel.snp.makeConstraints {
            $0.centerY.equalTo(uiView)
            $0.leading.equalTo(uiView).offset(25)
            $0.width.equalTo(30)
        }
        
        verticalStackView.snp.makeConstraints {
            $0.top.equalTo(uiView).offset(40)
            $0.bottom.equalTo(uiView).offset(-40)
            $0.leading.equalTo(circleChart.snp.trailing).offset(12)
        }
        
        linkBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-15)
            $0.centerY.equalTo(uiView)
        }
        
    }
}
