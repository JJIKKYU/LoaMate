//
//  MainCell.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/08.
//

import UIKit
import SnapKit
import Then

class MainCell: UITableViewCell {
    
    public var level: String = "" {
        didSet { setNeedsLayout() }
    }
    
    public var characterName: String = "" {
        didSet { setNeedsLayout() }
    }
    
    public var isShowCommander: [CommandersName] = [] {
        didSet { setNeedsLayout() }
    }
    
    public var isClearsCommander: [CommandersName] = [] {
        didSet { setNeedsLayout() }
    }
    
    public var eponaClearCount: Int = 0 {
        didSet { setNeedsLayout() }
    }
    
    public var guardianClearCount: Int = 0 {
        didSet { setNeedsLayout() }
    }
    
    public var chaosClearCount: Int = 0 {
        didSet { setNeedsLayout() }
    }
    
    private let shadowView = UIView().then {
        $0.layer.zPosition = -1
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = Colors.cardBG
        $0.layer.cornerRadius = 10
        $0.AppShadow(.shadow_2)
    }
    
    private let wrapView = UIView().then {
        $0.layer.zPosition = 1
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = Colors.cardBG
        $0.layer.cornerRadius = 10
    }
    
    private let classImageView = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 6
        $0.backgroundColor = Colors.tintColor
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let levelLabel = UILabel().then {
        $0.text = "1605.52"
        $0.font = UIFont(name: UIFont.SDGhotic(.Light), size: 12)
        $0.textColor = Colors.subTintColor
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let characterNameLabel = UILabel().then {
        $0.textColor = Colors.textColor
        $0.font = UIFont(name: UIFont.SDGhotic(.Bold), size: 20)
        $0.text = "캐릭터이름입니다."
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let commandersStackView = UIStackView(frame: .zero).then {
        $0.alignment = .trailing
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 5
        $0.distribution = .fill
    }
    
    private let dailyStackView = UIStackView(frame: .zero).then {
        $0.alignment = .trailing
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 5
        $0.distribution = .fill
    }

    private let valtanLabel = PaddingLabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.masksToBounds = true
        $0.textEdgeInsets = UIEdgeInsets(top: 3, left: 5, bottom: 2, right: 5)
        $0.text = "발탄"
        $0.backgroundColor = Colors.valtan
        $0.layer.cornerRadius = 5
        $0.font = UIFont(name: UIFont.SDGhotic(.Bold), size: 11)
        $0.isHidden = true
    }
    
    private let viaLabel = PaddingLabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.masksToBounds = true
        $0.textEdgeInsets = UIEdgeInsets(top: 3, left: 5, bottom: 2, right: 5)
        $0.text = "비아"
        $0.backgroundColor = Colors.tintColor
        $0.layer.cornerRadius = 5
        $0.font = UIFont(name: UIFont.SDGhotic(.Bold), size: 11)
        $0.isHidden = true
    }
    
    private let koukuLabel = PaddingLabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.masksToBounds = true
        $0.textEdgeInsets = UIEdgeInsets(top: 3, left: 5, bottom: 2, right: 5)
        $0.text = "쿠크"
        $0.backgroundColor = Colors.kouku
        $0.layer.cornerRadius = 5
        $0.font = UIFont(name: UIFont.SDGhotic(.Bold), size: 11)
        $0.isHidden = true
    }
    
    private let abrLabel = PaddingLabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.masksToBounds = true
        $0.textEdgeInsets = UIEdgeInsets(top: 3, left: 5, bottom: 2, right: 5)
        $0.text = "아브"
        $0.backgroundColor = Colors.abr
        $0.layer.cornerRadius = 5
        $0.font = UIFont(name: UIFont.SDGhotic(.Bold), size: 11)
        $0.isHidden = true
    }
    
    private let ilLabel = PaddingLabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.masksToBounds = true
        $0.textEdgeInsets = UIEdgeInsets(top: 3, left: 5, bottom: 2, right: 5)
        $0.text = "아칸"
        $0.backgroundColor = Colors.illiakan
        $0.layer.cornerRadius = 5
        $0.font = UIFont(name: UIFont.SDGhotic(.Bold), size: 11)
        $0.isHidden = true
    }

    // 일일숙제
    private let chaosLabel = PaddingLabel(frame: .zero, type: .type2).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.masksToBounds = true
        $0.textEdgeInsets = UIEdgeInsets(top: 3, left: 5, bottom: 2, right: 5)
        $0.titleLabel.text = "카던"
        $0.text = "카던"
        $0.textColor = .clear
        $0.layer.cornerRadius = 5
        $0.font = UIFont(name: UIFont.SDGhotic(.Bold), size: 11)
        $0.isHidden = false
    }
    
    private let guardianLabel = PaddingLabel(frame: .zero, type: .type2).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.masksToBounds = true
        $0.textEdgeInsets = UIEdgeInsets(top: 3, left: 5, bottom: 2, right: 5)
        $0.titleLabel.text = "가토"
        $0.text = "가토"
        $0.textColor = .clear
        $0.layer.cornerRadius = 5
        $0.font = UIFont(name: UIFont.SDGhotic(.Bold), size: 11)
        $0.isHidden = false
    }
    
    private let eponaLabel = PaddingLabel(frame: .zero, type: .type3).then {
        $0.titleLabel.text = "에포나"
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.masksToBounds = true
        $0.textEdgeInsets = UIEdgeInsets(top: 3, left: 5, bottom: 2, right: 5)
        $0.text = "에포나"
        $0.textColor = .clear
        $0.layer.cornerRadius = 5
        $0.font = UIFont(name: UIFont.SDGhotic(.Bold), size: 11)
        $0.isHidden = false
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViews()
        layer.cornerRadius = 5
        // AppShadow(.shadow_6)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setViews() {
        backgroundColor = .clear
        addSubview(shadowView)
        addSubview(wrapView)
        wrapView.addSubview(levelLabel)
        wrapView.addSubview(classImageView)
        wrapView.addSubview(characterNameLabel)
        wrapView.addSubview(commandersStackView)
        wrapView.addSubview(dailyStackView)
        commandersStackView.addArrangedSubview(valtanLabel)
        commandersStackView.addArrangedSubview(viaLabel)
        commandersStackView.addArrangedSubview(koukuLabel)
        commandersStackView.addArrangedSubview(abrLabel)
        commandersStackView.addArrangedSubview(ilLabel)
        dailyStackView.addArrangedSubview(chaosLabel)
        dailyStackView.addArrangedSubview(guardianLabel)
        dailyStackView.addArrangedSubview(eponaLabel)
        bringSubviewToFront(wrapView)
        
        wrapView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.width.equalToSuperview().inset(20)
            make.top.equalToSuperview()
            make.height.equalTo(106)
        }
        
        shadowView.snp.makeConstraints { make in
            make.leading.width.top.bottom.equalTo(wrapView)
        }
        
        classImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(30)
            make.width.height.equalTo(18)
        }
        
        levelLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(36)
            make.top.equalToSuperview().offset(12)
        }
        
        characterNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(classImageView.snp.trailing).offset(6)
            make.top.equalTo(levelLabel.snp.bottom).offset(1)
        }
        
        commandersStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(17)
            make.bottom.equalToSuperview().inset(15)
            make.height.equalTo(24)
        }
        
        dailyStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(17)
            make.bottom.equalTo(commandersStackView.snp.top).offset(-4)
            make.height.equalTo(24)
        }
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        levelLabel.text = level
        characterNameLabel.text = characterName
        
        print("MainCell :: isCelarCommanders = \(isClearsCommander)")
        
        valtanLabel.layer.borderWidth = 1
        valtanLabel.layer.borderColor = Colors.valtan.cgColor
        valtanLabel.backgroundColor = .clear
        
        viaLabel.layer.borderWidth = 1
        viaLabel.backgroundColor = .clear
        viaLabel.layer.borderColor = Colors.tintColor.cgColor
        
        koukuLabel.layer.borderWidth = 1
        koukuLabel.layer.borderColor = Colors.kouku.cgColor
        koukuLabel.backgroundColor = .clear
        
        abrLabel.layer.borderWidth = 1
        abrLabel.layer.borderColor = Colors.abr.cgColor
        abrLabel.backgroundColor = .clear
        
        ilLabel.layer.borderWidth = 1
        ilLabel.layer.borderColor = Colors.illiakan.cgColor
        ilLabel.backgroundColor = .clear
        
        valtanLabel.font = UIFont(name: UIFont.SDGhotic(.Light), size: 11)
        viaLabel.font = UIFont(name: UIFont.SDGhotic(.Light), size: 11)
        koukuLabel.font = UIFont(name: UIFont.SDGhotic(.Light), size: 11)
        abrLabel.font = UIFont(name: UIFont.SDGhotic(.Light), size: 11)
        ilLabel.font = UIFont(name: UIFont.SDGhotic(.Light), size: 11)

        for clearCommander in isClearsCommander {
            switch clearCommander {
            case .val:
                valtanLabel.layer.borderWidth = 0
                valtanLabel.backgroundColor = Colors.valtan
                valtanLabel.font = UIFont(name: UIFont.SDGhotic(.Bold), size: 11)
            case .via:
                viaLabel.layer.borderWidth = 0
                viaLabel.backgroundColor = Colors.tintColor
                viaLabel.font = UIFont(name: UIFont.SDGhotic(.Bold), size: 11)
            case .kk:
                koukuLabel.layer.borderWidth = 0
                koukuLabel.backgroundColor = Colors.kouku
                koukuLabel.font = UIFont(name: UIFont.SDGhotic(.Bold), size: 11)
            case .abr:
                abrLabel.layer.borderWidth = 0
                abrLabel.backgroundColor = Colors.abr
                abrLabel.font = UIFont(name: UIFont.SDGhotic(.Bold), size: 11)
            case .il:
                ilLabel.layer.borderWidth = 0
                ilLabel.backgroundColor = Colors.illiakan
                ilLabel.font = UIFont(name: UIFont.SDGhotic(.Bold), size: 11)
            }
        }
        
        for commander in isShowCommander {
            switch commander {
            case .val:
                valtanLabel.isHidden = false
            case .via:
                viaLabel.isHidden = false
            case .kk:
                koukuLabel.isHidden = false
            case .abr:
                abrLabel.isHidden = false
            case .il:
                ilLabel.isHidden = false
            }
        }
        
        eponaLabel.clearCount = eponaClearCount
        guardianLabel.clearCount = guardianClearCount
        chaosLabel.clearCount = chaosClearCount
    }
}
