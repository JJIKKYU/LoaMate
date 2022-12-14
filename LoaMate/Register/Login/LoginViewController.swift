//
//  LoginViewController.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import RIBs
import RxSwift
import UIKit
import Then
import AuthenticationServices
import SnapKit

protocol LoginPresentableListener: AnyObject {
    func saveEmail(email: String)
}

final class LoginViewController: UIViewController, LoginPresentable, LoginViewControllable {

    weak var listener: LoginPresentableListener?
    private lazy var appleLoginManager = AppleLoginManager().then {
        $0.delegate = self
    }
    
    private lazy var appleLoginBtn = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .white).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(pressedAppleLoginBtn), for: .touchUpInside)
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = Asset.mainIcon.image
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    // MARK: - VC 코드
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
        print("Login :: Login ViewDidLoad!!")
    }
    
    func setViews() {
        print("Login :: SetViews!")
        view.addSubview(appleLoginBtn)
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(140)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(264)
        }
        
        appleLoginBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(60)
            make.width.equalToSuperview().inset(60)
            make.height.equalTo(46)
            make.bottom.equalToSuperview().inset(80)
        }
    }
}

// MARK: - IBAction
extension LoginViewController {
    @objc
    func pressedAppleLoginBtn() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        //요청을 날릴 항목 설정 : 이름, 이메일
        request.requestedScopes = [.email]
        //request를 보내줄 controller 생성
        let controller = ASAuthorizationController(authorizationRequests: [request])
        //controller의 delegate와 presentationContextProvider 설정
        controller.delegate = appleLoginManager
        controller.presentationContextProvider = appleLoginManager
        controller.performRequests() //요청 보냄
        appleLoginManager.setAppleLoginPresentationAnchorView(self)
    }
}

// MARK: - AppleLoginManager Delegate
extension LoginViewController: AppleLoginManagerDelegate {
    func appleLoginSuccess(email: String) {
        print("Login :: appleLoginSuccess! = \(email)")
        listener?.saveEmail(email: email)
    }
    
    func appleLoginFail() {
        print("Login :: appleLoginFail")
    }
}
