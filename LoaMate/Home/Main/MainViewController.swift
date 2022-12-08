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

protocol MainPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class MainViewController: UIViewController, MainPresentable, MainViewControllable {

    weak var listener: MainPresentableListener?
    
    private let naviView = UIView().then {
        $0.backgroundColor = .black
    }
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .black
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
        // view.addSubview(charactersBtn)
        view.addSubview(naviView)
        view.addSubview(collectionView)
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
        
        collectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalToSuperview().offset(500)
            make.bottom.equalToSuperview()
        }
    }

}
