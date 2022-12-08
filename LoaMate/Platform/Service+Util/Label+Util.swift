//
//  Label+Util.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/08.
//

import Foundation
import UIKit
import Then
import SnapKit

class PaddingLabel: UILabel {
    enum type {
        case defualt
        case type2
        case type3
    }
    
    var paddingLabelType: type = .defualt {
        didSet { setNeedsLayout() }
    }
    
    var clearCount: Int = 0 {
        didSet { setNeedsLayout() }
    }
    
    var titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.masksToBounds = true
        $0.font = UIFont(name: UIFont.SDGhotic(.Bold), size: 11)
        $0.textColor = Colors.textColor
    }
    
    var backgroundStackView = UIStackView().then {
        $0.alignment = .fill
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var backgroundView1 = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = Colors.subTintColor.withAlphaComponent(0.15)
    }
    
    var backgroundView2 = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = Colors.subTintColor.withAlphaComponent(0.15)
    }
    
    var backgroundView3 = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = Colors.subTintColor.withAlphaComponent(0.15)
    }
    
    var textEdgeInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textEdgeInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textEdgeInsets.top, left: -textEdgeInsets.left, bottom: -textEdgeInsets.bottom, right: -textEdgeInsets.right)
        return textRect.inset(by: invertedInsets)
    }
    
    init(frame: CGRect = .zero, type: PaddingLabel.type = .defualt) {
        super.init(frame: frame)
        self.paddingLabelType = type
        setViews()
    }
    
    func setViews() {
        addSubview(backgroundStackView)
        addSubview(titleLabel)
        
        backgroundStackView.snp.makeConstraints { make in
            make.leading.width.top.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        sendSubviewToBack(backgroundStackView)
        super.sendSubviewToBack(backgroundStackView)

        switch paddingLabelType {
        case .defualt:
            break

        case .type2:
            backgroundStackView.addArrangedSubview(backgroundView1)
            backgroundStackView.addArrangedSubview(backgroundView2)
            
        case .type3:
            backgroundStackView.addArrangedSubview(backgroundView1)
            backgroundStackView.addArrangedSubview(backgroundView2)
            backgroundStackView.addArrangedSubview(backgroundView3)
        }
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch clearCount {
        case 0:
            backgroundView1.backgroundColor = Colors.subTintColor.withAlphaComponent(0.15)
            backgroundView2.backgroundColor = Colors.subTintColor.withAlphaComponent(0.15)
            backgroundView3.backgroundColor = Colors.subTintColor.withAlphaComponent(0.15)
            
        case 1:
            backgroundView1.backgroundColor = Colors.subTintColor.withAlphaComponent(0.7)
            backgroundView2.backgroundColor = Colors.subTintColor.withAlphaComponent(0.15)
            backgroundView3.backgroundColor = Colors.subTintColor.withAlphaComponent(0.15)
            
        case 2:
            backgroundView1.backgroundColor = Colors.subTintColor.withAlphaComponent(0.7)
            backgroundView2.backgroundColor = Colors.subTintColor.withAlphaComponent(0.7)
            backgroundView3.backgroundColor = Colors.subTintColor.withAlphaComponent(0.15)
            
        case 3:
            backgroundView1.backgroundColor = Colors.subTintColor.withAlphaComponent(0.7)
            backgroundView2.backgroundColor = Colors.subTintColor.withAlphaComponent(0.7)
            backgroundView3.backgroundColor = Colors.subTintColor.withAlphaComponent(0.7)
            
        default:
            break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textEdgeInsets))
    }
    
    var paddingLeft: CGFloat {
        set { textEdgeInsets.left = newValue }
        get { return textEdgeInsets.left }
    }
    
    var paddingRight: CGFloat {
        set { textEdgeInsets.right = newValue }
        get { return textEdgeInsets.right }
    }
    
    var paddingTop: CGFloat {
        set { textEdgeInsets.top = newValue }
        get { return textEdgeInsets.top }
    }
    
    var paddingBottom: CGFloat {
        set { textEdgeInsets.bottom = newValue }
        get { return textEdgeInsets.bottom }
    }
}
