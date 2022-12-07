//
//  UIApplication+Util.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import Foundation
import UIKit

extension UIApplication {
    static var topSafeAreaHeight: CGFloat {
        var topSafeAreaHeight: CGFloat = 0
         if #available(iOS 11.0, *) {
               let window = UIApplication.shared.windows[0]
               let safeFrame = window.safeAreaLayoutGuide.layoutFrame
               topSafeAreaHeight = safeFrame.minY
             }
        return topSafeAreaHeight
    }
}
