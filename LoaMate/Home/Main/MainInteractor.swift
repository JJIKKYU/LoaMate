//
//  MainInteractor.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import RIBs
import RxSwift
import RxRealm
import RealmSwift
import RxRelay

protocol MainRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func attachInputCharacters()
    func detachInputCharacters()
    
    func attachDetail(selectedModel: CharacterWork)
    func detachDetail(isOnlyDetach: Bool)
}

protocol MainPresentable: Presentable {
    var listener: MainPresentableListener? { get set }
    func tableViewReload()
}

protocol MainListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol MainInteractorDependency {
    var loaMateRepository: LoaMateRepository { get }
}

final class MainInteractor: PresentableInteractor<MainPresentable>, MainInteractable, MainPresentableListener {

    weak var router: MainRouting?
    weak var listener: MainListener?
    private let disposeBag = DisposeBag()
    let dependency: MainInteractorDependency
    var userDataRelay: BehaviorRelay<UserData?>
    var userDataNotificationToken: NotificationToken?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: MainPresentable,
        dependency: MainInteractorDependency
    ) {
        self.dependency = dependency
        self.userDataRelay = dependency.loaMateRepository.userData
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        dependency.loaMateRepository.fetchUserData()
        bind()
        reealmBind()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func bind() {
        dependency.loaMateRepository
            .charactersInfoRelay
            .subscribe(onNext: { [weak self] characters in
                guard let self = self else { return }
                print("Main :: Interactor -> characters -> \(characters)")
                self.presenter.tableViewReload()
            })
            .disposed(by: disposeBag)
        
        dependency.loaMateRepository
            .userData
            .subscribe(onNext: { [weak self] userData in
                guard let self = self else { return }
                print("main :: userData = \(userData)")
                if userData?.charactersWorksArr.count == 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.router?.attachInputCharacters()
                    }
                } else {
                    self.presenter.tableViewReload()
                }
            })
            .disposed(by: disposeBag)

    }
    
    func reealmBind() {
        guard let realm = Realm.safeInit() else { return }
        
        /*
        userDataNotificationToken = realm.objects(UserData.self).first?.
            .observe({ [weak self] changes in
                guard let self = self else { return }
                switch changes {
                case .change(let model, let proertyChanges):
                    for property in proertyChanges {
                        switch property.name {
                        default:
                            break
                        }
                    }
                case .error(let error):
                    fatalError("\(error)")
                case .deleted:
                    break
                }
        })
        */
    }
    
    func completeSetCharacters() {
        router?.detachInputCharacters()
    }
    
    func selectCharacterWorkModel(model: CharacterWork) {
        router?.attachDetail(selectedModel: model)
    }
    func detailPressedBackBtn(isOnlyDetach: Bool) {
        router?.detachDetail(isOnlyDetach: isOnlyDetach)
    }
}
