//
//  DetailHeaderView.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/09.
//

import UIKit
import Then
import SnapKit
import Kingfisher

class DetailHeaderView: UICollectionReusableView {
    public var characterImage: UIImage? {
        didSet { setNeedsLayout() }
    }
    
    public var level: String = "0" {
        didSet { setNeedsLayout() }
    }
    
    public var characterName: String = "0" {
        didSet { setNeedsLayout() }
    }
    
    public var imageURL: String? {
        didSet { setNeedsLayout() }
    }
    
    public var section: Int = 0 {
        didSet { setNeedsLayout() }
    }
    
    private let charcterWrapView = UIView().then {
        $0.backgroundColor = Colors.bacgkround
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let characterImageView = UIImageView().then {
        $0.layer.masksToBounds = false
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
    }
    
    private let levelLabel = UILabel().then {
        $0.text = "0"
        $0.textColor = Colors.tintColor
        $0.font = UIFont(name: UIFont.SDGhotic(.Light), size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let characterNameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.textColor = Colors.tintColor
        $0.font = UIFont(name: UIFont.SDGhotic(.Heavy), size: 30)
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let sectionListHeader = UIView()
    private let orderImageView = UIImageView().then {
        $0.tintColor = Colors.textColor
        $0.image = Asset.order.image.withRenderingMode(.alwaysTemplate)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let title = UILabel().then {
        $0.text = "군단장"
        $0.font = UIFont(name: UIFont.SDGhotic(.Bold), size: 18)
        $0.textColor = Colors.textColor
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("DetailHeaderView :: !! - 2")
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("DetailHeaderView :: !! - 3")
      }
    
    func setViews() {
        backgroundColor = Colors.bacgkround

        addSubview(charcterWrapView)
        charcterWrapView.addSubview(characterImageView)
        charcterWrapView.addSubview(levelLabel)
        charcterWrapView.addSubview(characterNameLabel)
        addSubview(sectionListHeader)

        sectionListHeader.addSubview(orderImageView)
        sectionListHeader.addSubview(title)
        
        charcterWrapView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(250)
            make.width.equalToSuperview()
        }
        
        characterImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(170)
            make.height.equalToSuperview()
        }

        levelLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(characterNameLabel.snp.top).inset(3)
            make.width.equalToSuperview().inset(20)
        }

        characterNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(20)
            make.width.equalTo(200)
        }
        
        sectionListHeader.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(charcterWrapView.snp.bottom).offset(20)
            make.height.equalTo(35)
            make.width.equalToSuperview().inset(20)
        }
        
        orderImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        title.snp.makeConstraints { make in
            make.leading.equalTo(orderImageView.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch section {
        case 0:
            title.text = "군단장"
            charcterWrapView.isHidden = false
            sectionListHeader.snp.remakeConstraints { make in
                make.leading.equalToSuperview()
                make.top.equalTo(charcterWrapView.snp.bottom)
                make.height.equalTo(35)
                make.width.equalToSuperview().inset(20)
            }
        case 1:
            title.text = "일일숙제"
            charcterWrapView.isHidden = true
            sectionListHeader.snp.remakeConstraints { make in
                make.leading.equalToSuperview()
                make.centerY.equalToSuperview()
                make.height.equalTo(35)
                make.width.equalToSuperview().inset(20)
            }
        default:
            break
        }
        
        levelLabel.text = level
        characterNameLabel.text = characterName
        
        if let imageURL = imageURL {
            guard let url: URL = URL(string: imageURL) else { return }
            self.characterImageView.kf.setImage(with: url,
                                                placeholder: nil,
                                                options: [.transition(.fade(1))],
                                                progressBlock: nil) { result in
                switch result {
                case .success(let imageResult):
                    DispatchQueue.main.async {
                        self.characterImageView.image = imageResult.image
                    }
                case .failure(let error):
                    print("error! \(error)")
                }
            }
        } else {
            characterImageView.image = nil
        }
    }
}
