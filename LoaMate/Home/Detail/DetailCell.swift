//
//  DetailCell.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/09.
//

import UIKit
import Then
import SnapKit

public enum WorkType {
    case commander
    case daily
}

public enum DailyType: String {
    case epona = "에포나"
    case chaos = "카오스던전"
    case guaridan = "가디언토벌"
}

class DetailCell: UICollectionViewCell {
    
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
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
        $0.alignment = .fill
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let imageblackView1 = UIView().then {
        $0.layer.masksToBounds = true
        $0.backgroundColor = .black.withAlphaComponent(0.3)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isHidden = false
    }
    private let imageblackView2 = UIView().then {
        $0.layer.masksToBounds = true
        $0.backgroundColor = .black.withAlphaComponent(0.3)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isHidden = false
    }
    private let imageblackView3 = UIView().then {
        $0.layer.masksToBounds = true
        $0.backgroundColor = .black.withAlphaComponent(0.3)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isHidden = false
    }
    private lazy var imageblackViewArr: [UIView] = [
        imageblackView1,
        imageblackView2,
        imageblackView3,
    ]
    
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
        bringSubviewToFront(stackView)
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
        
        stackView.addArrangedSubview(imageblackView1)
        stackView.addArrangedSubview(imageblackView2)
        stackView.addArrangedSubview(imageblackView3)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch workType {
        case .commander:
            workLabel.text = commanderName?.rawValue ?? ""
            let isClear: Bool = self.isClear.first ?? false
            switch commanderName {
            case .val:
                if isClear {
                    imageView.image = Asset.Commanders.valBG2.image
                } else {
                    imageView.image = Asset.Commanders.valBG.image
                }
                
            case .via:
                if isClear {
                    imageView.image = Asset.Commanders.viaBG.image.noir ?? UIImage()
                } else {
                    imageView.image = Asset.Commanders.viaBG.image
                }
            case .kk:
                if isClear {
                    imageView.image = Asset.Commanders.kkBG.image.noir ?? UIImage()
                } else {
                    imageView.image = Asset.Commanders.kkBG.image
                }
            case .abr:
                if isClear {
                    imageView.image = Asset.Commanders.abrBG.image.noir ?? UIImage()
                } else {
                    imageView.image = Asset.Commanders.abrBG.image
                }
            case .il:
                if isClear {
                    imageView.image = Asset.Commanders.ilBG.image.noir ?? UIImage()
                } else {
                    imageView.image = Asset.Commanders.ilBG.image
                }
            case .none:
                break
            }
            
        case .daily:
            workLabel.text = dailyType?.rawValue ?? ""
            switch dailyType {
            case .guaridan:
                imageblackView3.isHidden = true
                imageView.image = Asset.Daily.guardianBG.image
            case .chaos:
                imageblackView3.isHidden = true
                imageView.image = Asset.Daily.chaosBG.image
            case .epona:
                imageView.image = Asset.Daily.eponaBG.image
            case .none:
                break
            }
            
            let clearCount: Int = isClear.filter ({ $0 == true }).count
            if clearCount == 0 {
                for count in 0..<3 {
                    imageblackViewArr[safe: count]?.backgroundColor = .black.withAlphaComponent(0.3)
                }
            } else {
                for count in 0..<clearCount {
                    print("DetailCell :: clearCount = \(clearCount) - \(count), \(imageblackViewArr[safe: count])")
                    imageblackViewArr[safe: count]?.backgroundColor = .black.withAlphaComponent(0.7)
                }
            }
        }
    }
}
