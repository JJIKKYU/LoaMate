//
//  NaviView.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/08.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa

/// 뷰마다 NavigationType 정의
enum NaviViewType {
    case main
    case inputCharacter
    case characterSelect
    case detail
    case detailSetting
}

class NaviView: UIView {
    
    var naviViewType: NaviViewType

    lazy var titleImage = UIImageView().then {
        let image = Asset.loamate.image.withRenderingMode(.alwaysTemplate)
        $0.tintColor = Colors.tintColor
        $0.image = image
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isHidden = true
        $0.contentMode = .scaleAspectFit
    }
    
    var backButton = UIButton().then {
        $0.setImage(Asset.Arrow.back.image.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
        $0.contentHorizontalAlignment = .fill
        $0.contentVerticalAlignment = .fill
        $0.isHidden = true
    }
    
    var titleLabel = UILabel().then {
        $0.text = "title"
        $0.font = UIFont(name: UIFont.SDGhotic(.Bold), size: 16)
        $0.textColor = .white
        $0.isHidden = true
    }
    
    // 가장 오른쪽
    var rightButton1 = UIButton().then {
        // $0.setImage(Asset._24px.profile.image.withRenderingMode(.alwaysTemplate), for: .normal)
        // $0.tintColor = Colors.tint.main.v700
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.contentHorizontalAlignment = .fill
        $0.contentVerticalAlignment = .fill
        $0.isHidden = true
    }
    
    var rightButton1IsActive: Bool = false {
        didSet { setNeedsLayout() }
    }
    
    var rightButton2IsActive: Bool = false {
        didSet { setNeedsLayout() }
    }
    
    // 오른쪽에서 2번째
    var rightButton2 = UIButton().then {
        // $0.setImage(Asset._24px.search.image.withRenderingMode(.alwaysTemplate), for: .normal)
        // $0.tintColor = Colors.tint.main.v700
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.contentHorizontalAlignment = .fill
        $0.contentVerticalAlignment = .fill
        $0.isHidden = true
    }
    
    var leftButton1 = UIButton().then {
        // $0.setImage(Asset._24px.close.image.withRenderingMode(.alwaysTemplate), for: .normal)
        // $0.tintColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.contentHorizontalAlignment = .fill
        $0.contentVerticalAlignment = .fill
        $0.isHidden = true
    }
    
    init(type: NaviViewType) {
        self.naviViewType = type
        super.init(frame: CGRect.zero)
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViews() {
        // backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        // applyBlurEffect()
        backgroundColor = .clear
        addSubview(titleImage)
        addSubview(backButton)
        addSubview(rightButton1)
        addSubview(titleLabel)

        titleImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(129)
            make.height.equalTo(29)
            make.bottom.equalToSuperview().inset(14)
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(10)
            make.width.height.equalTo(24)
        }
        
        rightButton1.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(10)
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }
        titleLabel.sizeToFit()
        
        setNaviViewType()
    }
    
    func setNaviViewType() {
        switch naviViewType {
        case .main:
            rightButton1.isHidden = false
            rightButton1.setImage(Asset.setting.image.withRenderingMode(.alwaysTemplate), for: .normal)
            rightButton1.tintColor = Colors.tintColor
            rightButton2.isHidden = true
            titleImage.isHidden = false
        case .inputCharacter:
            titleImage.isHidden = true
            titleLabel.text = "대표 캐릭터 설정"
            titleLabel.font = UIFont(name: UIFont.Montserrat(.ExtraBold), size: 16)
            backButton.isHidden = true
            titleLabel.isHidden = false
        case .characterSelect:
            titleImage.isHidden = true
            titleLabel.text = "캐릭터 선택"
            titleLabel.font = UIFont(name: UIFont.Montserrat(.ExtraBold), size: 16)
            backButton.isHidden = false
            backButton.tintColor = Colors.textColor
            backButton.setImage(Asset.Arrow.back.image.withRenderingMode(.alwaysTemplate), for: .normal)
            titleLabel.isHidden = false
            
        case .detail:
            titleLabel.isHidden = true
            backButton.isHidden = false
            backButton.tintColor = Colors.textColor
            backButton.setImage(Asset.Arrow.back.image.withRenderingMode(.alwaysTemplate), for: .normal)
            backgroundColor = .clear
            
        case .detailSetting:
            titleImage.isHidden = true
            titleLabel.text = "일일 숙제 세팅"
            titleLabel.font = UIFont(name: UIFont.Montserrat(.ExtraBold), size: 16)
            backButton.isHidden = true
            backButton.tintColor = Colors.textColor
            backButton.setImage(Asset.Arrow.back.image.withRenderingMode(.alwaysTemplate), for: .normal)
            titleLabel.isHidden = false
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
