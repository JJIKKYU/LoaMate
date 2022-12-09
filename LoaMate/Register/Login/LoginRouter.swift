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

    var navigationController: NavigationControllerable?
    
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
    
    // Bottom Up 으로 스크린을 띄울때
    private func presentInsideNavigation(_ viewControllable: ViewControllable) {
        let navigation = NavigationControllerable(root: viewControllable)
        navigation.navigationController.isNavigationBarHidden = true
        navigation.navigationController.modalPresentationStyle = .fullScreen
        self.navigationController = navigation
        
        viewController.present(navigation, animated: true, completion:  nil)
    }

    private func dismissPresentedNavigation(completion: (() -> Void)?) {
        if self.navigationController == nil {
            return
        }

        viewController.dismiss(completion: nil)
        self.navigationController = nil
    }
    
    func attachMain() {
        if mainRouting != nil {
            return
        }
        
        let router = main.build(
            withListener: interactor
        )
        
        presentInsideNavigation(router.viewControllable)
        // viewController.pushViewController(router.viewControllable, animated: true)
        
        mainRouting = router
        attachChild(router)
    }
}
