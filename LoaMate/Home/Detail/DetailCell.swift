//
//  DetailCell.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/09.
//

import UIKit
import Then
import SnapKit

class DetailCell: UICollectionViewCell {
    
    enum WorkType {
        case commander
        case daily
    }
    
    enum DailyType: String {
        case epona = "에포나"
        case chaos = "카오스던전"
        case guaridan = "가디언토벌"
    }
    
    var workType: WorkType = .commander {
        didSet { setNeedsLayout() }
    }
    
    var commanderName: CommandersName? {
        didSet { setNeedsLayout() }
    }
    
    var isClear: [Bool] = [] {
        didSet { setNeedsLayout() }
    }
    
    var dailyType: DailyType? {
        didSet { setNeedsLayout() }
    }
    
    private let workLabel = UILabel().then {
        $0.textColor = Colors.textColor
        $0.font = UIFont(name: UIFont.SDGhotic(.Bold), size: 14)
        $0.text = "발탄"
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let stackView = UIStackView().then {
        $0.alignment = .leading
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        setViews()
        // 여기서 init 진행
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func setViews() {
        backgroundColor = Colors.abr
        layer.cornerRadius = 8
        AppShadow(.shadow_4)

        addSubview(imageView)
        addSubview(stackView)
        addSubview(workLabel)
        
        workLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(10)
            make.width.equalToSuperview().inset(10)
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.top.width.bottom.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.top.bottom.width.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch workType {
        case .commander:
            workLabel.text = commanderName?.rawValue ?? ""
            switch commanderName {
            case .val:
                imageView.image = Asset.Commanders.valBG.image
            case .via:
                imageView.image = Asset.Commanders.viaBG.image
            case .kk:
                imageView.image = Asset.Commanders.kkBG.image
            case .abr:
                imageView.image = Asset.Commanders.abrBG.image
            case .il:
                imageView.image = Asset.Commanders.ilBG.image
            case .none:
                break
            }
            
        case .daily:
            workLabel.text = dailyType?.rawValue ?? ""
            switch dailyType {
            case .guaridan:
                imageView.image = Asset.Daily.guardianBG.image
            case .chaos:
                imageView.image = Asset.Daily.chaosBG.image
            case .epona:
                imageView.image = Asset.Daily.eponaBG.image
            case .none:
                break
            }
        }
    }
}
