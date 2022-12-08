//
//  LoginInteractor.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import RIBs
import RxSwift
import AuthenticationServices

protocol LoginRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func attachMain()
}

protocol LoginPresentable: Presentable {
    var listener: LoginPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol LoginListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol LoginInteractorDependency {
    var loaMateRepository: LoaMateRepository { get }
}

final class LoginInteractor: PresentableInteractor<LoginPresentable>, LoginInteractable, LoginPresentableListener {

    weak var router: LoginRouting?
    weak var listener: LoginListener?
    private let dependency: LoginInteractorDependency
    private let disposeBag = DisposeBag()

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: LoginPresentable,
        dependency: LoginInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        bind()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func saveEmail(email: String) {
        print("Login :: interactor -> saveEmail!")
        dependency.loaMateRepository
            .addEmail(email: email)
    }
    
    func bind() {
        dependency.loaMateRepository
            .userEmailRelay.subscribe(onNext: { [weak self] email in
                guard let self = self else { return }
                print("AppRoot :: email! = \(email)")
                if email == "" {
                    // self.router?.attachLogin()
                } else {
                    self.getUserEmailKeyChain(email: email)
                    print("AppRoot :: 로그인 체크 ㄲ")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func getUserEmailKeyChain(email: String) {
        let getQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                          kSecAttrAccount: email,
                                          kSecReturnAttributes: true,
                                          kSecReturnData: true]
        var item: CFTypeRef?
        let result = SecItemCopyMatching(getQuery as CFDictionary, &item)

        if result == errSecSuccess {
            if let existingItem = item as? [String: Any],
               let data = existingItem[kSecValueData as String] as? Data,
               let password = String(data: data, encoding: .utf8) {
                print("이거? = \(password)")
                self.checkUserIdentifier(identifier: password)
            }
        }
    }
    
    func checkUserIdentifier(identifier: String) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: identifier) { (credentialState, error) in
            switch credentialState {
            case .authorized:
                //인증성공 상태
                print("AppRoot :: 인증 성공 상태!")
                DispatchQueue.main.async {
                    self.router?.attachMain()
                }
                
            case .revoked:
                //인증만료 상태
                print("AppRoot :: 인증만료 상태")
            default:
                print("AppRoot :: 인증 그 외 상태!")
                //.notFound 등 이외 상태
            }
        }
    }
}
