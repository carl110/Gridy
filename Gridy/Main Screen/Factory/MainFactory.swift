//
//  Main Factory.swift
//  Gridy
//
//  Created by Carl Wainwright on 27/08/2018.
//  Copyright © 2018 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

class MainFactory {
    
    static func showIn(window: UIWindow) {
        
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        navigationController.navigationBar.backgroundColor = UIColor.lightGray
        navigationController.navigationBar.tintColor = UIColor.blue
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.blue]
        
        let mainController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! ViewController
        let mainFlowController = MainFlowController(navigationController: navigationController)

        mainController.assignDependancies(mainFlowController: mainFlowController)
        
        navigationController.setViewControllers([mainController], animated: false)
        window.rootViewController = navigationController
        
    }
    
    static func PushIn(navigationController: UINavigationController) {
        
        let mainEditor = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! ViewController
        let mainFlowController = MainFlowController(navigationController: navigationController)
        mainEditor.assignDependancies(mainFlowController: mainFlowController)
        navigationController.pushViewController(mainEditor, animated: true)
        
    }
}
