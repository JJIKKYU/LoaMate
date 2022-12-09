//
//  DetailInteractor.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/08.
//

import RIBs
import RxSwift
import RxRelay

protocol DetailRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol DetailPresentable: Presentable {
    var listener: DetailPresentableListener? { get set }
    func setData()
}

protocol DetailListener: AnyObject {
    func detailPressedBackBtn(isOnlyDetach: Bool)
}

protocol DetailInteractorDependecy {
    var loaMateRepository: LoaMateRepository { get }
}

final class DetailInteractor: PresentableInteractor<DetailPresentable>, DetailInteractable, DetailPresentableListener {

    var characterProfileModelRelay: BehaviorRelay<ArmoryProfileModel?>
    var characterWorkData: CharacterWork?

    weak var router: DetailRouting?
    weak var listener: DetailListener?
    private let disposeBag = DisposeBag()
    
    private let dependency: DetailInteractorDependecy
    let selectedModel: CharacterWork

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: DetailPresentable,
        dependency: DetailInteractorDependecy,
        selectedModel: CharacterWork
    ) {
        self.dependency = dependency
        self.selectedModel = selectedModel
        print("Detail :: int! = \(selectedModel.nickName)")
        characterWorkData = dependency.loaMateRepository.userData.value?
            .charactersWorks.filter ({ $0.nickName == selectedModel.nickName}).first
        self.characterProfileModelRelay = dependency.loaMateRepository.characterProfileRelay
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        bind()
        searchCharacter()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func searchCharacter() {
        print("Detail :: searchCharacter")
        let userNickname: String = selectedModel.nickName
        dependency.loaMateRepository.searchCharcterProfile(userNickname: userNickname)
    }
    
    func bind() {
        dependency.loaMateRepository
            .characterProfileRelay
            .subscribe(onNext: { [weak self] model in
                guard let self = self,
                      let model = model
                else { return }
                
                print("Detail :: model = \(model)")
            })
            .disposed(by: disposeBag)
        
        characterProfileModelRelay
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                self.presenter.setData()
            })
            .disposed(by: disposeBag)
    }
    
    func pressedBackBtn(isOnlyDetach: Bool) {
        listener?.detailPressedBackBtn(isOnlyDetach: isOnlyDetach)
    }
}
