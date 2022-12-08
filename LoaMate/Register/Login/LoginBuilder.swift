//
//  LoginBuilder.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import RIBs

protocol LoginDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    var loaMateRepository: LoaMateRepository { get }
}

final class LoginComponent: Component<LoginDependency>, LoginInteractorDependency, MainDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    var loaMateRepository: LoaMateRepository { dependency.loaMateRepository }
}

// MARK: - Builder

protocol LoginBuildable: Buildable {
    func build(withListener listener: LoginListener) -> LoginRouting
}

final class LoginBuilder: Builder<LoginDependency>, LoginBuildable {

    override init(dependency: LoginDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: LoginListener) -> LoginRouting {
        let component = LoginComponent(dependency: dependency)
        let viewController = LoginViewController()
        let interactor = LoginInteractor(
            presenter: viewController,
            dependency: component
        )
        interactor.listener = listener
        
        let main = MainBuilder(dependency: component)
        return LoginRouter(
            interactor: interactor,
            viewController: viewController,
            main: main
        )
    }
}
