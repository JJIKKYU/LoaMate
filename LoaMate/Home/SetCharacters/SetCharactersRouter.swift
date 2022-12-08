//
//  SetCharactersRouter.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/08.
//

import RIBs

protocol SetCharactersInteractable: Interactable {
    var router: SetCharactersRouting? { get set }
    var listener: SetCharactersListener? { get set }
}

protocol SetCharactersViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SetCharactersRouter: ViewableRouter<SetCharactersInteractable, SetCharactersViewControllable>, SetCharactersRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(
        interactor: SetCharactersInteractable,
        viewController: SetCharactersViewControllable
    ) {
        super.init(
            interactor: interactor,
            viewController: viewController
        )
        interactor.router = self
    }
}
