//
//  UINavigationController.swift
//  Vinux (macOS)
//
//  Created by git on 8/21/22.
//

// Push View Controller Onto Navigation Stack
// navigationController.pushViewController(viewController, animated: true)

// Pop View Controller From Navigation Stack
// navigationController.popViewController(animated: true)


#if !os(macOS) || targetEnvironment(macCatalyst)
import SwiftUI
#else
import UIKit

extension UINavigationController {

    var rootViewController: UIViewController? {
        return viewControllers.first
    }

}
#endif
