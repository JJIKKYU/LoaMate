//
//  SetCharactersBuilder.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/08.
//

import RIBs

protocol SetCharactersDependency: Dependency {
    var loaMateRepository: LoaMateRepository { get }
}

final class SetCharactersComponent: Component<SetCharactersDependency>, SetCharactersInteractorDependency {
    var loaMateRepository: LoaMateRepository { dependency.loaMateRepository }
    

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SetCharactersBuildable: Buildable {
    func build(
        withListener listener: SetCharactersListener,
        userNickname: String
    ) -> SetCharactersRouting
}

final class SetCharactersBuilder: Builder<SetCharactersDependency>, SetCharactersBuildable {

    override init(dependency: SetCharactersDependency) {
        super.init(dependency: dependency)
    }

    func build(
        withListener listener: SetCharactersListener,
        userNickname: String
    ) -> SetCharactersRouting {
        let component = SetCharactersComponent(dependency: dependency)
        let viewController = SetCharactersViewController()
        let interactor = SetCharactersInteractor(
            presenter: viewController,
            dependency: component,
            userNickname: userNickname
        )
        interactor.listener = listener
        return SetCharactersRouter(
            interactor: interactor,
            viewController: viewController
        )
    }
}
