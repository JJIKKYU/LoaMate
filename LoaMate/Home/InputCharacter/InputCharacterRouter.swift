//
//  InputCharacterRouter.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/08.
//

import RIBs

protocol InputCharacterInteractable: Interactable, SetCharactersListener {
    var router: InputCharacterRouting? { get set }
    var listener: InputCharacterListener? { get set }
}

protocol InputCharacterViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class InputCharacterRouter: ViewableRouter<InputCharacterInteractable, InputCharacterViewControllable>, InputCharacterRouting {
    
    var navigationController: NavigationControllerable?
    
    private let setCharacters: SetCharactersBuildable
    private var setCharactersRouting: ViewableRouting?
    

    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: InputCharacterInteractable,
        viewController: InputCharacterViewControllable,
        setCharacters: SetCharactersBuildable
    ) {
        self.setCharacters = setCharacters
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachSetCharacters(userNickname: String) {
        if setCharactersRouting != nil {
            return
        }
        
        let router = setCharacters.build(
            withListener: interactor,
            userNickname: userNickname
        )
        
        viewController.pushViewController(router.viewControllable, animated: true)
        
        setCharactersRouting = router
        attachChild(router)
    }
    
    func detachSetCharacters(isOnlyDetach: Bool) {
        guard let router = setCharactersRouting else {
            return
        }
        
        if !isOnlyDetach {
            viewController.popViewController(animated: true)
        }
        
        detachChild(router)
        setCharactersRouting = nil
    }
}
