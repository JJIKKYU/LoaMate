//
//  SetCharactersViewController.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/08.
//

import RIBs
import RxSwift
import UIKit
import Then
import SnapKit
import RxRelay

protocol SetCharactersPresentableListener: AnyObject {
    func pressedBackBtn(isOnlyDetach: Bool)
    func pressedConfimBtn()
    var charactersInfoRelay: BehaviorRelay<[CharacterInfoModel]> { get }
    var selectedCharacterArrRelay: BehaviorRelay<[CharacterInfoModel]> { get }
}

final class SetCharactersViewController: UIViewController, SetCharactersPresentable, SetCharactersViewControllable {
    weak var listener: SetCharactersPresentableListener?
    private let disposeBag = DisposeBag()
    
    private lazy var naviView = NaviView(type: .characterSelect).then {
        $0.backButton.addTarget(self, action: #selector(pressedBackBtn), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont(name: UIFont.SDGhotic(.Bold), size: 18)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "숙제를 진행할\n캐릭터를 선택 해주세요."
        $0.numberOfLines = 2
        $0.setLineHeight()
    }

    private lazy var boxButtopn = BoxButton(frame: .zero, btnStatus: .inactive, btnSize: .large).then {
        $0.addTarget(self, action: #selector(pressedConfirmBtn), for: .touchUpInside)
        $0.title = "캐릭터를 선택 해주세요"
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var tableView = UITableView().then {
        $0.separatorColor = .clear
        $0.rowHeight = 45
        $0.register(SetCharactersCell.self, forCellReuseIdentifier: "SetCharactersCell")
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.delegate = self
        $0.dataSource = self
    }

    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.bacgkround
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        setViews()
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isMovingFromParent || isBeingDismissed {
            listener?.pressedBackBtn(isOnlyDetach: true)
        }
        
        tableView.delegate = nil
        tableView.dataSource = nil
    }
    
    func bind() {
        listener?.selectedCharacterArrRelay
            .subscribe(onNext: { [weak self] arr in
                guard let self = self else { return }
                if arr.count != 0 {
                    self.boxButtopn.isUserInteractionEnabled = true
                    self.boxButtopn.btnStatus = .active
                    self.boxButtopn.title = "\(arr.count)개 캐릭터 선택"
                } else {
                    self.boxButtopn.isUserInteractionEnabled = false
                    self.boxButtopn.btnStatus = .inactive
                    self.boxButtopn.title = "캐릭터를 선택 해주세요"
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setViews() {
        view.addSubview(naviView)
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(boxButtopn)

        naviView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(44 + UIApplication.topSafeAreaHeight)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.width.equalToSuperview().inset(20)
            make.top.equalTo(naviView.snp.bottom).offset(52)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.width.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(34)
            make.bottom.equalTo(boxButtopn.snp.top).inset(-40)
        }

        boxButtopn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(56)
            make.bottom.equalToSuperview().inset(60)
        }
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
}

// MARK: - IBAction
extension SetCharactersViewController {
    @objc
    func pressedBackBtn() {
        listener?.pressedBackBtn(isOnlyDetach: false)
    }
    
    @objc
    func pressedConfirmBtn() {
        listener?.pressedConfimBtn()
    }
}


// MARK: - UITableview
extension SetCharactersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listener?.charactersInfoRelay.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SetCharactersCell") as? SetCharactersCell else { return UITableViewCell() }
        
        guard let dataArr = listener?.charactersInfoRelay.value else { return UITableViewCell() }
        
        let data = dataArr[indexPath.row]
        
        cell.selectionStyle = .none
        cell.characterName = data.CharacterName
        cell.info = "\(data.ItemMaxLevel) | \(data.CharacterClassName) | \(data.ServerName)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? SetCharactersCell else { return }
        
        guard let selectedCharacterArrRelayValue = listener?.selectedCharacterArrRelay.value else { return }
        
        if selectedCell.btnSelected {
            let value = selectedCharacterArrRelayValue.filter { $0.CharacterName != selectedCell.characterName }
            listener?.selectedCharacterArrRelay.accept(value)
        } else {
            guard let selectedValue = listener?.charactersInfoRelay.value[indexPath.row] else { return }
            listener?.selectedCharacterArrRelay.accept(selectedCharacterArrRelayValue + [selectedValue])
        }
        selectedCell.btnSelected = !selectedCell.btnSelected
        
    }
}
