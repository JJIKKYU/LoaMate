//
//  InputCharacterInteractor.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/08.
//

import RIBs
import RxSwift
import RxRelay

protocol InputCharacterRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func attachSetCharacters(userNickname: String)
    func detachSetCharacters(isOnlyDetach: Bool)
}

protocol InputCharacterPresentable: Presentable {
    var listener: InputCharacterPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol InputCharacterListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class InputCharacterInteractor: PresentableInteractor<InputCharacterPresentable>, InputCharacterInteractable, InputCharacterPresentableListener {

    weak var router: InputCharacterRouting?
    weak var listener: InputCharacterListener?
    
    var inputCharacterRelay = BehaviorRelay<String>(value: "")

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: InputCharacterPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func pressedConfirmBtn(userNickname: String) {
        router?.attachSetCharacters(userNickname: userNickname)
    }
    
    func SetCharactersPressedBackBtn(isOnlyDetach: Bool) {
        router?.detachSetCharacters(isOnlyDetach: isOnlyDetach)
    }
}
