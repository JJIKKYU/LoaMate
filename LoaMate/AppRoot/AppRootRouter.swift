//
//  AppRootRouter.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import RIBs

protocol AppRootInteractable: Interactable, LoginListener
{
    var router: AppRootRouting? { get set }
    var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable {
    func setViewController(_ viewController: ViewControllable)
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {
    
    var navigationController: NavigationControllerable?

    private let login: LoginBuildable
    private var loginRouting: ViewableRouting?
    
    init(
        interactor: AppRootInteractable,
        viewController: AppRootViewControllable,
        login: LoginBuildable
    ) {
        self.login = login
        // self.diaryHome = diaryHome
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        // attachMainHome()
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
    
    func attachMainHome() {
        /*
        // let registerIDRouting = registerID.build(withListener: interactor)
        let diaryHomeRouting = diaryHome.build(withListener: interactor)
        
        // attachChild(diaryWritingRouting)
        // attachChild(registerHomeRouting)
        
        // attachChild(registerHomeRouting)
        // attachChild(loginHomeRouting)
        attachChild(diaryHomeRouting)
        let navigation = NavigationControllerable(root: diaryHomeRouting.viewControllable)
        navigation.navigationController.modalPresentationStyle = .fullScreen

        viewController.setViewController(navigation)
        */
        let loginRouting = login.build(withListener: interactor)
        attachChild(loginRouting)
        
        let navigation = NavigationControllerable(root: loginRouting.viewControllable)
        navigation.navigationController.modalPresentationStyle = .fullScreen
        viewController.setViewController(navigation)
    }
    
    func cleanupViews() {
        // TODO: Since this router does not own its view, it needs to cleanup the views
        // it may have added to the view hierarchy, when its interactor is deactivated.
    }
}
