//
//  DetailViewController.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/08.
//

import RIBs
import RxSwift
import UIKit
import SnapKit
import Then
import RxRelay
import Kingfisher

protocol DetailPresentableListener: AnyObject {
    func pressedBackBtn(isOnlyDetach: Bool)
    var characterProfileModelRelay: BehaviorRelay<ArmoryProfileModel?> { get }
    var characterWorkData: CharacterWork? { get }
    
    func setClearCommander(commanderName: CommandersName?, isClear: [Bool])
}

final class DetailViewController: UIViewController, DetailPresentable, DetailViewControllable {
    
    let dailyWorkOrder: [DetailCell.DailyType] = [.epona, .chaos, .guaridan]

    weak var listener: DetailPresentableListener?
    private let disposeBag = DisposeBag()
    
    private lazy var naviView = NaviView(type: .detail).then {
        $0.backButton.addTarget(self, action: #selector(pressedBackBtn), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        let flowlayout = UICollectionViewFlowLayout.init()
        flowlayout.scrollDirection = .vertical
        flowlayout.minimumLineSpacing = 20
        flowlayout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 35, right: 20)
        $0.setCollectionViewLayout(flowlayout, animated: true)
        
        $0.register(DetailCell.self, forCellWithReuseIdentifier: "DetailCell")
        $0.register(DetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DetailHeaderView")
        $0.backgroundColor = Colors.bacgkround
        $0.dataSource = self
        $0.delegate = self
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let tableViewHeaderView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = Colors.bacgkround
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        
        if isMovingFromParent || isBeingDismissed {
            listener?.pressedBackBtn(isOnlyDetach: true)
        }
    }
    
    func setViews() {
        view.backgroundColor = Colors.bacgkround
        view.addSubview(naviView)
        view.addSubview(collectionView)
        view.bringSubviewToFront(naviView)


        naviView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(44 + UIApplication.topSafeAreaHeight)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.width.top.bottom.equalToSuperview()
        }
    }
    
    func setData() {
//        guard let data = listener?.characterProfileModelRelay.value else { return }
//        characterNameLabel.text = data.CharacterName
//        levelLabel.text = data.ItemMaxLevel
    }
    
    func bind() {
        listener?.characterProfileModelRelay
            .subscribe(onNext: { [weak self] model in
                guard let self = self,
                      let model = model
                else { return }
                
                guard let commanderHeaderView = self.collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader)[safe: 0] as? DetailHeaderView,
                      let dailyHeaderView = self.collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader)[safe: 1] as? DetailHeaderView
                else { return }
                
                commanderHeaderView.level = model.ItemMaxLevel
                commanderHeaderView.characterName = model.CharacterName
                commanderHeaderView.imageURL = model.CharacterImage
                commanderHeaderView.section = 0
                
                dailyHeaderView.section = 1
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - IBAction
extension DetailViewController {
    @objc
    func pressedBackBtn() {
        listener?.pressedBackBtn(isOnlyDetach: false)
    }
}

// MARK: - UICollectionView
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            guard let data = listener?.characterWorkData else { return 0 }
            return data.commandersWork?.commandersArr.count ?? 0
            
        case 1:
            return 3
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCell", for: indexPath) as? DetailCell,
              let data = listener?.characterWorkData
        else { return UICollectionViewCell() }

        switch indexPath.section {
        // 군단장
        case 0:
            cell.workType = .commander
            cell.commanderName = data.commandersWork?.commandersArr[indexPath.row].name
            cell.isClear = [data.commandersWork?.commandersArr[indexPath.row].isClear ?? false]
        // 일일숙제
        case 1:
            cell.workType = .daily
            cell.dailyType = dailyWorkOrder[indexPath.row]
            switch cell.dailyType {
            case .epona:
                cell.isClear = data.dailyWork?.epona?.isClearsArr ?? []
            case .chaos:
                cell.isClear = data.dailyWork?.chaos?.isClearsArr ?? []
            case .guaridan:
                cell.isClear = data.dailyWork?.guardian?.isClearsArr ?? []
            case .none:
                break
            }
            
        default:
            break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.window?.windowScene?.screen.bounds.width ?? 0
        
        let newWidth = (width - 50) / 2
        
        print("Detail :: width = \(width)")
        
        return CGSize(width: newWidth, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "DetailHeaderView", for: indexPath) as? DetailHeaderView
            else { return UICollectionReusableView() }
            
            return headerView
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        switch section {
        case 0:
            return CGSize(width: collectionView.frame.size.width, height: 290)
        case 1:
            return CGSize(width: collectionView.frame.size.width, height: 40)
        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DetailCell else { return }
        
        print("Detail :: Select! \(indexPath.section) \(indexPath.row), \(cell.isClear)")
        
        switch indexPath.section {
        case 0:
            cell.isClear = [!(cell.isClear.first ?? false)]
            listener?.setClearCommander(commanderName: cell.commanderName, isClear: cell.isClear)

        case 1:
            let clearCount: Int = cell.isClear.filter ({ $0 == true }).count
            var clears: [Bool] = cell.isClear
            switch cell.dailyType {
            case .chaos, .guaridan:
                if clearCount >= 2 {
                    clears = [false, false]
                } else {
                    clears[clearCount] = true
                }
                cell.isClear = clears

            case .epona:
                if clearCount >= 3 {
                    clears = [false, false, false]
                } else {
                    clears[clearCount] = true
                }
                cell.isClear = clears

            case .none:
                break
            }
            

        default:
            break
        }
    }
}
