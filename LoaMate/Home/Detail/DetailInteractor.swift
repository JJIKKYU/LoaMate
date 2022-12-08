//
//  DetailInteractor.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/08.
//

import RIBs
import RxSwift

protocol DetailRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol DetailPresentable: Presentable {
    var listener: DetailPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol DetailListener: AnyObject {
    func detailPressedBackBtn(isOnlyDetach: Bool)
}

protocol DetailInteractorDependecy {
    var loaMateRepository: LoaMateRepository { get }
}

final class DetailInteractor: PresentableInteractor<DetailPresentable>, DetailInteractable, DetailPresentableListener {

    weak var router: DetailRouting?
    weak var listener: DetailListener?
    
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
        super.init(presenter: presenter)
        presenter.listener = self
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
            .characterProfileRelay
            .subscribe(onNext: { [weak self] model in
                guard let self = self,
                      let model = model
                else { return }
            })
    }
    
    func pressedBackBtn(isOnlyDetach: Bool) {
        listener?.detailPressedBackBtn(isOnlyDetach: isOnlyDetach)
    }
}
