//
//  InputCharacterViewController.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/08.
//

import RIBs
import RxSwift
import UIKit
import Then
import SnapKit

protocol InputCharacterPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func pressedConfirmBtn(userNickname: String)
}

final class InputCharacterViewController: UIViewController, InputCharacterPresentable, InputCharacterViewControllable {

    weak var listener: InputCharacterPresentableListener?
    private let disposeBag = DisposeBag()
    
    private lazy var naviView = NaviView(type: .inputCharacter).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont(name: UIFont.SDGhotic(.Bold), size: 18)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "대표캐릭터로 지정할\n닉네임을 입력해 주세요."
        $0.numberOfLines = 2
        $0.setLineHeight()
    }
    
    lazy var textField = UITextField(frame: .zero).then {
        $0.font = UIFont(name: UIFont.SDGhotic(.Bold), size: 18)
        $0.textColor = Colors.tintColor
        $0.tintColor = Colors.tintColor
        $0.attributedPlaceholder = NSAttributedString(string: "캐릭터 닉네임을 입력 해주세요.", attributes: [NSAttributedString.Key.foregroundColor : Colors.subTintColor.withAlphaComponent(0.6)])
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let textFieldLine = UIView().then {
        $0.backgroundColor = Colors.tintColor
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var boxButtopn = BoxButton(frame: .zero, btnStatus: .inactive, btnSize: .large).then {
        $0.isUserInteractionEnabled = false
        $0.addTarget(self, action: #selector(pressedConfirmBtn), for: .touchUpInside)
        $0.title = "대표 캐릭터 설정 완료"
        $0.translatesAutoresizingMaskIntoConstraints = false
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
        view.backgroundColor = Colors.bacgkround
        setViews()
        bind()
    }
    
    func bind() {
        textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                
                if text.count >= 2 {
                    self.boxButtopn.isUserInteractionEnabled = true
                    self.boxButtopn.btnStatus = .active
                } else {
                    self.boxButtopn.isUserInteractionEnabled = false
                    self.boxButtopn.btnStatus = .inactive
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setViews() {
        view.addSubview(naviView)
        view.addSubview(titleLabel)
        view.addSubview(textField)
        view.addSubview(textFieldLine)
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
        
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.width.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(46)
            make.height.equalTo(36)
        }
        
        textFieldLine.snp.makeConstraints { make in
            make.leading.width.equalTo(textField)
            make.top.equalTo(textField.snp.bottom).offset(2)
            make.height.equalTo(2)
        }
        
        boxButtopn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(56)
            make.bottom.equalToSuperview().inset(60)
        }
    }
}

// MARK: - IBACtion
extension InputCharacterViewController {
    @objc
    func pressedConfirmBtn() {
        listener?.pressedConfirmBtn(userNickname: textField.text ?? "")
    }
}
