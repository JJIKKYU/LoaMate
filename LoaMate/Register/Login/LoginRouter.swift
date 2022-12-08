//
//  LoginRouter.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import RIBs

protocol LoginInteractable: Interactable, MainListener {
    var router: LoginRouting? { get set }
    var listener: LoginListener? { get set }
}

protocol LoginViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class LoginRouter: ViewableRouter<LoginInteractable, LoginViewControllable>, LoginRouting {

    private let main: MainBuildable
    private var mainRouting: ViewableRouting?
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: LoginInteractable,
        viewController: LoginViewControllable,
        main: MainBuildable
    ) {
        self.main = main
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachMain() {
        if mainRouting != nil {
            return
        }
        
        let router = main.build(
            withListener: interactor
        )
        
        viewController.pushViewController(router.viewControllable, animated: true)
        
        mainRouting = router
        attachChild(router)
    }
}
