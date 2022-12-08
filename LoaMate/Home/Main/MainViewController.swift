//
//  MainViewController.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import RIBs
import RxSwift
import UIKit
import Then
import SnapKit
import RxRelay

protocol MainPresentableListener: AnyObject {
    var userDataRelay: BehaviorRelay<UserData?> { get }
    func selectCharacterWorkModel(model: CharacterWork)
}

final class MainViewController: UIViewController, MainPresentable, MainViewControllable {
    

    weak var listener: MainPresentableListener?
    
    private lazy var naviView = NaviView(type: .main).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var tableView = UITableView(frame: .zero).then {
        $0.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        $0.separatorColor = .clear
        $0.backgroundColor = .clear
        $0.rowHeight = 130
        $0.register(MainCell.self, forCellReuseIdentifier: "MainCell")
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        $0.dataSource = self
    }
    
    private let charactersBtn = BoxButton(frame: CGRect.zero, btnStatus: .active, btnSize: .xLarge).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.title = "캐릭터 불러오기"
        $0.btnSelected = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        print("Main :: viewDidLoad!")
        setViews()
    }
    
    func setViews() {
        view.backgroundColor = Colors.bacgkround
        // view.addSubview(charactersBtn)
        view.addSubview(naviView)
        view.addSubview(tableView)
        view.bringSubviewToFront(naviView)
        
//        charactersBtn.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(20)
//            make.width.equalToSuperview().inset(20)
//            make.height.equalTo(56)
//            make.top.equalToSuperview().offset(100)
//        }
        naviView.snp.makeConstraints { make in
            make.leading.width.top.equalToSuperview()
            make.height.equalTo(44 + UIApplication.topSafeAreaHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(naviView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }

    func tableViewReload() {
        tableView.reloadData()
    }
    
}

// MARK: - UITableviewDelegate
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listener?.userDataRelay.value?.charactersWorksArr.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell") as? MainCell else {
            return UITableViewCell()
        }
        
        guard let data = listener?.userDataRelay.value?.charactersWorksArr[indexPath.row] else {
            return UITableViewCell()
        }

        // 군단장 세팅
        var isClearCommanders: [CommandersName] = []
        let commandersArr: [Commander] = data.commandersWork?.commandersArr ?? []
        for commander in commandersArr {
            print("Main :: \(commander.name.rawValue)를 \(commander.isClear == true ? "클리어했습니다." : "클리어하지 않았습니다.")")
            cell.isShowCommander.append(commander.name)
            if commander.name == .abr {
                isClearCommanders.append(commander.name)
            }
            if commander.isClear {
                isClearCommanders.append(commander.name)
            }
        }
        
        // 일일숙제 세팅
        let eponaClearCount: Int = data.dailyWork?.epona?.isClears.filter ({ $0 == true }).count ?? 0
        cell.eponaClearCount = eponaClearCount
        
        let guardianClearCount: Int = data.dailyWork?.guardian?.isClears.filter({ $0 == true }).count ?? 0
        cell.guardianClearCount = guardianClearCount
        
        let chaosClearCount: Int = data.dailyWork?.chaos?.isClears.filter({ $0 == true }).count ?? 0
        cell.chaosClearCount = 3
        
        
        cell.layer.zPosition = CGFloat(indexPath.row)
        cell.isClearsCommander = isClearCommanders
        cell.selectionStyle = .none
        cell.level = data.level
        cell.characterName = data.nickName

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = listener?.userDataRelay.value?.charactersWorksArr[indexPath.row] else { return }
        
        listener?.selectCharacterWorkModel(model: model)
    }
}
