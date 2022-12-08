//
//  SetCharactersInteractor.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/08.
//

import RIBs
import RxSwift
import RxRelay

protocol SetCharactersRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SetCharactersPresentable: Presentable {
    var listener: SetCharactersPresentableListener? { get set }
    func reloadTableView()
}

protocol SetCharactersListener: AnyObject {
    func SetCharactersPressedBackBtn(isOnlyDetach: Bool)
    func completeSetCharacters()
}

protocol SetCharactersInteractorDependency {
    var loaMateRepository: LoaMateRepository { get }
}

final class SetCharactersInteractor: PresentableInteractor<SetCharactersPresentable>, SetCharactersInteractable, SetCharactersPresentableListener {
    
    weak var router: SetCharactersRouting?
    weak var listener: SetCharactersListener?
    private let disposeBag = DisposeBag()
    
    private let dependency: SetCharactersInteractorDependency
    private let userNickname: String
    internal var charactersInfoRelay: BehaviorRelay<[CharacterInfoModel]>
    internal var selectedCharacterArrRelay = BehaviorRelay<[CharacterInfoModel]>(value: [])

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: SetCharactersPresentable,
        dependency: SetCharactersInteractorDependency,
        userNickname: String
    ) {
        self.dependency = dependency
        self.userNickname = userNickname
        self.charactersInfoRelay = dependency.loaMateRepository.charactersInfoRelay
        super.init(presenter: presenter)
        presenter.listener = self
        
        self.dependency.loaMateRepository
            .searchCharacters(userNickname: userNickname)
        print("userNickName = \(userNickname)")
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        bind()
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
                self.presenter.reloadTableView()
                print("SetCharacters :: characters = \(characters)")
            })
            .disposed(by: disposeBag)
    }
    
    func pressedBackBtn(isOnlyDetach: Bool) {
        listener?.SetCharactersPressedBackBtn(isOnlyDetach: isOnlyDetach)
    }
    
    func pressedConfimBtn() {
        // 각 캐릭터별 세팅부터
        dependency.loaMateRepository
            .saveUserData(mainCharacterName: userNickname, selectedCharacterArr: selectedCharacterArrRelay.value)
        
        listener?.completeSetCharacters()
    }
}
