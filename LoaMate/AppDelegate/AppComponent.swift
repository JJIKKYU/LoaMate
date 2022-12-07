//
//  AppComponent.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import Foundation
import RIBs

final class AppComponent: Component<EmptyDependency>, AppRootDependency {
  
  init() {
    super.init(dependency: EmptyComponent())
  }
  
}
