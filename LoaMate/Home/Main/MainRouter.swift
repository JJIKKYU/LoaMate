//
//  MainRouter.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import RIBs

protocol MainInteractable: Interactable, InputCharacterListener, DetailListener {
    var router: MainRouting? { get set }
    var listener: MainListener? { get set }
}

protocol MainViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MainRouter: ViewableRouter<MainInteractable, MainViewControllable>, MainRouting {

    var navigationController: NavigationControllerable?
    
    private let inputCharacter: InputCharacterBuildable
    private var inputCharacterRouting: ViewableRouting?
    
    private let detail: DetailBuildable
    private var detailRouting: ViewableRouting?
    
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: MainInteractable,
        viewController: MainViewControllable,
        inputChracter: InputCharacterBuildable,
        detail: DetailBuildable
    ) {
        self.detail = detail
        self.inputCharacter = inputChracter

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
    
    func attachInputCharacters() {
        print("Main :: router -> attachInputCharacters, \(inputCharacterRouting)")
        if inputCharacterRouting != nil {
            return
        }
        
        let router = inputCharacter.build(
            withListener: interactor
        )
        
//        viewControllable.pushViewController(router.viewControllable, animated: true)
        // presentInsideNavigation(router.viewControllable)
        // viewController.present(router.viewControllable, animated: true, completion: nil)
        presentInsideNavigation(router.viewControllable)
//        router.viewControllable.uiviewController.definesPresentationContext = true
        
        inputCharacterRouting = router
        attachChild(router)
    }
    
    func detachInputCharacters() {
        print("Main :: router -> detachInputCharacters")
        guard let router = inputCharacterRouting else {
            return
        }
            
        // dismissPresentedNavigation(completion: nil)
        dismissPresentedNavigation(completion: nil)
        detachChild(router)
        
        inputCharacterRouting = nil
    }
    
    func attachDetail(selectedModel: CharacterWork) {
        if detailRouting != nil {
            return
        }
        
        let router = detail.build(
            withListener: interactor,
            selectedModel: selectedModel
        )
        
        viewController.pushViewController(router.viewControllable, animated: true)
        
        detailRouting = router
        attachChild(router)
    }
    
    func detachDetail(isOnlyDetach: Bool) {
        print("Main :: router -> detachInputCharacters")
        guard let router = detailRouting else {
            return
        }
        
        if !isOnlyDetach {
            viewController.popViewController(animated: true)
        }

        detachChild(router)
        detailRouting = nil
    }
}
