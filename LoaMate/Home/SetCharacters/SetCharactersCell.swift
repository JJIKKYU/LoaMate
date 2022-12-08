//
//  SetCharactersCell.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/08.
//

import UIKit
import SnapKit
import Then

class SetCharactersCell: UITableViewCell {
    
    public var characterName: String = "" {
        didSet { setNeedsLayout() }
    }
    
    public var info: String = "" {
        didSet { setNeedsLayout() }
    }
    
    public var btnSelected: Bool = false {
        didSet { setNeedsLayout() }
    }
    
    lazy var selectBtn = UIButton(frame: .zero).then { (btn: UIButton) in
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(Asset.Check.unactive.image.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = Colors.textColor
    }
    
    private let characterLabel = UILabel().then {
        $0.text = "찌뀨뀨"
        $0.font = UIFont(name: UIFont.SDGhotic(.ExtraBold), size: 16)
        $0.textColor = Colors.textColor
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let infoLabel = UILabel().then {
        $0.text = "1999.99 | 직업 | 서버"
        $0.font = UIFont(name: UIFont.SDGhotic(.Light), size: 11)
        $0.textColor = Colors.textColor
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setViews() {
        backgroundColor = Colors.bacgkround
        addSubview(selectBtn)
        addSubview(characterLabel)
        addSubview(infoLabel)
        
        selectBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
        
        characterLabel.snp.makeConstraints { make in
            make.leading.equalTo(selectBtn.snp.trailing).offset(7)
            make.centerY.equalToSuperview()
        }
        
        infoLabel.snp.makeConstraints { make in
            make.leading.equalTo(characterLabel.snp.trailing).offset(7)
            make.bottom.equalTo(characterLabel.snp.bottom)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.characterLabel.text = characterName
        self.infoLabel.text = info
        
        switch btnSelected {
        case true:
            characterLabel.textColor = Colors.tintColor
            infoLabel.textColor = Colors.tintColor
            selectBtn.tintColor = Colors.tintColor
            selectBtn.setImage(Asset.Check.active.image.withRenderingMode(.alwaysTemplate), for: .normal)
        case false:
            characterLabel.textColor = Colors.textColor
            infoLabel.textColor = Colors.textColor
            selectBtn.tintColor = Colors.textColor
            selectBtn.setImage(Asset.Check.unactive.image.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }

}
