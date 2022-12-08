//
//  DetailBuilder.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/08.
//

import RIBs

protocol DetailDependency: Dependency {
    var loaMateRepository: LoaMateRepository { get }
}

final class DetailComponent: Component<DetailDependency>, DetailInteractorDependecy {
    var loaMateRepository: LoaMateRepository { dependency.loaMateRepository }
}

// MARK: - Builder

protocol DetailBuildable: Buildable {
    func build(
        withListener listener: DetailListener,
        selectedModel: CharacterWork
    ) -> DetailRouting
}

final class DetailBuilder: Builder<DetailDependency>, DetailBuildable {

    override init(dependency: DetailDependency) {
        super.init(dependency: dependency)
    }

    func build(
        withListener listener: DetailListener,
        selectedModel: CharacterWork
    ) -> DetailRouting {
        let component = DetailComponent(dependency: dependency)
        let viewController = DetailViewController()
        let interactor = DetailInteractor(
            presenter: viewController,
            dependency: component,
            selectedModel: selectedModel
        )
        interactor.listener = listener
        return DetailRouter(interactor: interactor, viewController: viewController)
    }
}
