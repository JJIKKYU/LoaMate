//
//  AppRootInteractor.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import Foundation
import RIBs
import RxSwift
import AuthenticationServices
import Alamofire
import Moya

protocol AppRootRouting: Routing {
    func cleanupViews()
    func attachMain()
    func attachInputCharacter()
    func attachLogin()
}

protocol AppRootPresentable: Presentable {
  var listener: AppRootPresentableListener? { get set }
  
}

protocol AppRootListener: AnyObject {
    
}

protocol AppRootInteractorDependency {
    var loaMateRepository: LoaMateRepository { get }
}

final class AppRootInteractor: PresentableInteractor<AppRootPresentable>,
                               AppRootInteractable,
                               AppRootPresentableListener,
                               URLHandler {

    
    func handle(_ url: URL) {
        
    }
    

    weak var router: AppRootRouting?
    weak var listener: AppRootListener?
    private let disposeBag = DisposeBag()
    private let dependency: AppRootInteractorDependency

    // in constructor.
    init(
        presenter: AppRootPresentable,
        dependency: AppRootInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        bind()
        testMoya()
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
        // TODO: Pause any business logic.
    }
    
    func testMoya() {
//        let provider = MoyaProvider<LostarkAPI>()
//        provider.request(.characters(characterName: "찌뀨뀨")) { result in
//            switch result {
//            case .success(let response):
//                let result = try? response.map([CharacterInfoModel].self)
//                print("sucess! = \(response.description), result = \(result)")
//                
//                if let result = result {
//                    self.dependency.loaMateRepository
//                        .charactersInfoRelay.accept(result)
//                }
//                
//                
//            case .failure(let error):
//                print("error = \(error.localizedDescription)")
//            }
//        }
        
//        provider.request(.profiles(characterName: "찌뀨뀨")) { result in
//            switch result {
//            case .success(let response):
//                let result = try? response.map(ArmoryProfileModel.self)
//                print("sucess! = \(response.description), result = \(result)")
//
//            case .failure(let error):
//                print("error = \(error.localizedDescription)")
//            }
//        }
    }
    
    func bind() {
        dependency.loaMateRepository
            .userEmailRelay.subscribe(onNext: { [weak self] email in
                guard let self = self else { return }
                print("AppRoot :: email! = \(email)")
                if email == "" {
                    self.router?.attachLogin()
                } else {
                    self.getUserEmailKeyChain(email: email)
                    // self.router?.attachMain()
                    self.router?.attachInputCharacter()
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

