//
//  AppRootInteractor.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import Foundation
import RIBs
import RxSwift

protocol AppRootRouting: Routing {
    func cleanupViews()
    func attachMainHome()
}

protocol AppRootPresentable: Presentable {
  var listener: AppRootPresentableListener? { get set }
  
}

protocol AppRootListener: AnyObject {
    
}

protocol AppRootInteractorDependency {

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
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
        // TODO: Pause any business logic.
    }
}

