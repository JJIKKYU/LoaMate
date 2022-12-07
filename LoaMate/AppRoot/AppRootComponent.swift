//
//  AppRootComponent.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import Foundation
import RIBs

final class AppRootComponent: Component<AppRootDependency> {

    private let rootViewController: ViewControllable
    
    init(
        dependency: AppRootDependency,
        rootViewController: ViewControllable
    ) {
        self.rootViewController = rootViewController
        super.init(dependency: dependency)
    }
}

extension AppRootComponent: AppRootInteractorDependency
{

}

