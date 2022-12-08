//
//  BoxButton.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import Foundation
import UIKit
import Then
import SnapKit

enum BoxButtonStatus {
    case active
    case inactive
    case pressed
}

enum BoxButtonSize {
    case large
    case xLarge
}


class BoxButton: UIButton {
    var btnStatus: BoxButtonStatus = .inactive {
        didSet { setNeedsLayout() }
    }
    
    var btnSize: BoxButtonSize = .large {
        didSet { setNeedsLayout() }
    }
    
    var title: String = "" {
        didSet { setNeedsLayout() }
    }
    
    var btnSelected: Bool = false {
        didSet { setNeedsLayout() }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted && btnStatus != .inactive {
                btnStatus = .pressed
            } else {
                setNeedsLayout()
            }
        }
    }
    
    private let btnLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = Colors.textColor
        $0.font = UIFont(name: UIFont.SDGhotic(.Bold), size: 16)
        // $0.textColor = Colors.grey.g800
        $0.text = "텍스트를 입력해주세요"
    }
    
    init(frame: CGRect, btnStatus: BoxButtonStatus, btnSize: BoxButtonSize) {
        self.btnStatus = btnStatus
        self.btnSize = btnSize
        super.init(frame: frame)
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViews() {
        addSubview(btnLabel)
        layer.cornerRadius = 6
        btnLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        btnLabel.text = title
        
        switch btnSize {
        case .large:
            // btnLabel.font = UIFont.AppTitle(.title_3)
            break
            
        case .xLarge:
            // btnLabel.font = UIFont.AppTitle(.title_2)
            break
        }
        
        switch btnStatus {
        case .active:
            // btnLabel.textColor = Colors.grey.g800
            backgroundColor = Colors.tintColor
            btnLabel.textColor = .white

        case .inactive:
            // backgroundColor = Colors.grey.g700
            backgroundColor = Colors.cardBG
            // btnLabel.textColor = Colors.grey.g500
            btnLabel.textColor = .white
            
            break
            
        case .pressed:
            // btnLabel.textColor = Colors.grey.g800
            btnLabel.textColor = .white
        }
        
        switch isHighlighted {
        case true:
            print("BoxButton :: isSelecteed! - true")

        case false:
            print("BoxButton :: isSelecteed! - false")
        }
        
//        if btnStatus == .inactive { return }
//        switch btnSelected {
//        case true:
//            btnStatus = .pressed
//
//        case false:
//            btnStatus = .active
//        }
    }
}

