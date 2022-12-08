//
//  AppRootRouter.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import RIBs

protocol AppRootInteractable: Interactable, LoginListener, MainListener
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
    
    private let main: MainBuildable
    private var mainRouting: ViewableRouting?
    
//    private let inputCharacter: InputCharacterBuildable
//    private var inputCharacterRouting: ViewableRouting?
    
    init(
        interactor: AppRootInteractable,
        viewController: AppRootViewControllable,
        login: LoginBuildable,
        main: MainBuildable
        // inputChracter: InputCharacterBuildable
    ) {
        self.login = login
        self.main = main
        // self.inputCharacter = inputChracter
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
    
    func attachMain() {
        let mainRouting = main.build(withListener: interactor)
        attachChild(mainRouting)
        
        let navigation = NavigationControllerable(root: mainRouting.viewControllable)
        navigation.navigationController.modalPresentationStyle = .fullScreen

        viewController.setViewController(navigation)
    }
    
    func attachLogin() {
        let loginRouting = login.build(withListener: interactor)
        attachChild(loginRouting)
        
        let navigation = NavigationControllerable(root: loginRouting.viewControllable)
        navigation.navigationController.modalPresentationStyle = .fullScreen
        viewController.setViewController(navigation)
    }
    
//    func attachInputCharacter() {
//        let inputChracterRouting = inputCharacter.build(withListener: interactor)
//        attachChild(inputChracterRouting)
//
//        let navigation = NavigationControllerable(root: inputChracterRouting.viewControllable)
//        navigation.navigationController.modalPresentationStyle = .fullScreen
//        viewController.setViewController(navigation)
//    }
    
    func cleanupViews() {
        // TODO: Since this router does not own its view, it needs to cleanup the views
        // it may have added to the view hierarchy, when its interactor is deactivated.
    }
}
