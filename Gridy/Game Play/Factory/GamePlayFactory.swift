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
        let gamePlayViewModel = GamePlayViewModel()
        gamePlay.assignDependancies(gamePlayFlowController: gamePlayFlowController, gamePlayViewModel: gamePlayViewModel)
        
        navigationController.pushViewController(gamePlay, animated: true)
        
    }
}
