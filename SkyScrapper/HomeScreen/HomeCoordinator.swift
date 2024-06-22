//
//  HomeCoordinator.swift
//  SkyScrapper
//
//  Created by Angélica Rodrigues on 13/06/2024.
//

import UIKit

class HomeCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var childCoordinator: [Coordinator] = []
    
    var type: CoordinatorType = .app
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        ////show screen func?
    }
    
    //show screen func?
    
    
}
