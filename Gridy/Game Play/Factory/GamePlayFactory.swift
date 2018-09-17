//
//  GamePlayFactory.swift
//  Gridy
//
//  Created by Carl Wainwright on 03/09/2018.
//  Copyright © 2018 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

class GamePlayFactory {
    static func PushIn(navigationController: UINavigationController, photo: UIImage) {
        
        let gamePlay = UIStoryboard(name: "GamePlay", bundle: nil).instantiateInitialViewController() as! GamePlayViewController
        let gamePlayFlowController = GamePlayFlowController(navigationController: navigationController)
        let gamePlayViewModel = GamePlayViewModel(photo : photo)
        gamePlay.assignDependancies(gamePlayFlowController: gamePlayFlowController, gamePlayViewModel: gamePlayViewModel)
        
        navigationController.pushViewController(gamePlay, animated: true)
        
    }
}

//static func PushIn(navigationController: UINavigationController, photo: UIImage) {
//    
//    let imageEditor = UIStoryboard(name: "ImageEditor", bundle: nil).instantiateInitialViewController() as! ImageEditorViewController
//    let imageEditorFlowController = ImageEditorFlowController(navigationController: navigationController)
//    let imageEditorViewModel = ImageEditorViewModel(photo: photo)
//    imageEditor.assignDependancies(imageEditorFlowController: imageEditorFlowController, imageEditorViewModel: imageEditorViewModel)
//    
//    navigationController.pushViewController(imageEditor, animated: true)
