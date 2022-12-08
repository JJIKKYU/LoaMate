//
//  Colors.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/08.
//

import Foundation
import UIKit

enum Colors {

    static var tintColor: UIColor {
        return color(
            dark: UIColor(red: 0.8156862854957581, green: 0.3176470696926117, blue: 0.49803921580314636, alpha: 1),
            light: UIColor(red: 0.8156862854957581, green: 0.3176470696926117, blue: 0.49803921580314636, alpha: 1)
        )
    }

    static var textColor: UIColor {
        return color(
            dark: UIColor(red: 0.8941176533699036, green: 0.8941176533699036, blue: 0.8941176533699036, alpha: 1),
            light: UIColor(red: 0.8941176533699036, green: 0.8941176533699036, blue: 0.8941176533699036, alpha: 1)
        )
    }

    static var valtan: UIColor {
        return color(
            dark: UIColor(red: 0.5375000238418579, green: 0.5375000238418579, blue: 0.5375000238418579, alpha: 1),
            light: UIColor(red: 0.5375000238418579, green: 0.5375000238418579, blue: 0.5375000238418579, alpha: 1)
        )
    }

    static var kouku: UIColor {
        return color(
            dark: UIColor(red: 0.8541666865348816, green: 0.4483836591243744, blue: 0.39505207538604736, alpha: 1),
            light: UIColor(red: 0.8541666865348816, green: 0.4483836591243744, blue: 0.39505207538604736, alpha: 1)
        )
    }

    static var illiakan: UIColor {
        return color(
            dark: UIColor(red: 0.683411180973053, green: 0.8125, blue: 0.40625, alpha: 1),
            light: UIColor(red: 0.683411180973053, green: 0.8125, blue: 0.40625, alpha: 1)
        )
    }

    static var biackiss: UIColor {
        return color(
            dark: UIColor(red: 0.8156862854957581, green: 0.3176470696926117, blue: 0.49803921580314636, alpha: 1),
            light: UIColor(red: 0.8156862854957581, green: 0.3176470696926117, blue: 0.49803921580314636, alpha: 1)
        )
    }

    static var cardBG: UIColor {
        return color(
            dark: UIColor(red: 0.18333333730697632, green: 0.18333333730697632, blue: 0.18333333730697632, alpha: 1),
            light: UIColor(red: 0.18333333730697632, green: 0.18333333730697632, blue: 0.18333333730697632, alpha: 1)
        )
    }

    static var bacgkround: UIColor {
        return color(
            dark: UIColor(red: 0.08235294371843338, green: 0.09803921729326248, blue: 0.11372549086809158, alpha: 1),
            light: UIColor(red: 0.08235294371843338, green: 0.09803921729326248, blue: 0.11372549086809158, alpha: 1)
        )
    }

    static var subTintColor: UIColor {
        return color(
            dark: UIColor(red: 0.5291666388511658, green: 0.5291666388511658, blue: 0.5291666388511658, alpha: 1),
            light: UIColor(red: 0.5291666388511658, green: 0.5291666388511658, blue: 0.5291666388511658, alpha: 1)
        )
    }

    static var abr: UIColor {
        return color(
            dark: UIColor(red: 0.5178738236427307, green: 0.4955555498600006, blue: 0.9291666746139526, alpha: 1),
            light: UIColor(red: 0.5178738236427307, green: 0.4955555498600006, blue: 0.9291666746139526, alpha: 1)
        )
    }
}

extension Colors {

    static func color(dark: UIColor, light: UIColor) -> UIColor {
        guard #available(iOS 13, *) else { return light }
        
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            switch UITraitCollection.userInterfaceStyle {
            case .dark: return dark
            case .light: return light
            default: return light
            }
        }
    }
}
