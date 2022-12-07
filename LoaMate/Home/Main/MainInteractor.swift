//
//  MainInteractor.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import RIBs
import RxSwift

protocol MainRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol MainPresentable: Presentable {
    var listener: MainPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
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

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: MainPresentable,
        dependency: MainInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
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
                print("Main :: Interactor -> characters -> \(characters)")
            })
            .disposed(by: disposeBag)
    }
}
