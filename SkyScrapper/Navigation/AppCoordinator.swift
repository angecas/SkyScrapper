//
//  AppCoordinator.swift
//  SkyScrapper
//
//  Created by Angélica Rodrigues on 16/06/2024.
//

import UIKit


class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var childCoordinator: [Coordinator] = []
    
    var type: CoordinatorType = .app
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showMainScreen()
    }
    
    func showMainScreen() {
        //TODO: Show mainscreen
        
        let viewController = HomeViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}
