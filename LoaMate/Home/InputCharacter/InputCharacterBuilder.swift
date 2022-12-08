//
//  InputCharacterBuilder.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/08.
//

import RIBs

protocol InputCharacterDependency: Dependency {
    var loaMateRepository: LoaMateRepository { get }
}

final class InputCharacterComponent: Component<InputCharacterDependency>, SetCharactersDependency {
    var loaMateRepository: LoaMateRepository { dependency.loaMateRepository }
    

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol InputCharacterBuildable: Buildable {
    func build(withListener listener: InputCharacterListener) -> InputCharacterRouting
}

final class InputCharacterBuilder: Builder<InputCharacterDependency>, InputCharacterBuildable {

    override init(dependency: InputCharacterDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: InputCharacterListener) -> InputCharacterRouting {
        let component = InputCharacterComponent(dependency: dependency)
        let viewController = InputCharacterViewController()
        
        let setCharacters = SetCharactersBuilder(dependency: component)
        
        let interactor = InputCharacterInteractor(
            presenter: viewController
        )
        interactor.listener = listener
        return InputCharacterRouter(
            interactor: interactor,
            viewController: viewController,
            setCharacters: setCharacters
        )
    }
}
