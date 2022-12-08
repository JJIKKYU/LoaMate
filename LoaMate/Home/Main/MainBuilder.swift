//
//  MainBuilder.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import RIBs

protocol MainDependency: Dependency {
    var loaMateRepository: LoaMateRepository { get }
}

final class MainComponent: Component<MainDependency>, MainInteractorDependency, InputCharacterDependency, DetailDependency {
    var loaMateRepository: LoaMateRepository { dependency.loaMateRepository }
}

// MARK: - Builder

protocol MainBuildable: Buildable {
    func build(withListener listener: MainListener) -> MainRouting
}

final class MainBuilder: Builder<MainDependency>, MainBuildable {

    override init(dependency: MainDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MainListener) -> MainRouting {
        let component = MainComponent(dependency: dependency)
        let viewController = MainViewController()
        
        let interactor = MainInteractor(
            presenter: viewController,
            dependency: component
        )
        
        let inputCharacter = InputCharacterBuilder(dependency: component)
        let detail = DetailBuilder(dependency: component)
    
        interactor.listener = listener
        return MainRouter(
            interactor: interactor,
            viewController: viewController,
            inputChracter: inputCharacter,
            detail: detail
        )
    }
}
