//
//  AppRootViewController.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import RIBs

protocol AppRootPresentableListener: AnyObject {
}

final class AppRootViewController:
  UIViewController,
  AppRootPresentable,
  AppRootViewControllable
{

  // MARK: - RootPresentable
  
  weak var listener: AppRootPresentableListener?
}

// MARK: - RootViewControllable
extension AppRootViewController {
    /*
  func present(_ viewController: ViewControllable, animated: Bool) {
    present(viewController.uiviewController, animated: animated)
  }
     */
    
    func setViewController(_ viewController: ViewControllable) {
        present(viewController.uiviewController, animated: false)
    }
}


