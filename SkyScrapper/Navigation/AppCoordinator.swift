//
//  AppCoordinator.swift
//  SkyScrapper
//
//  Created by Angélica Rodrigues on 16/06/2024.
//

import UIKit


class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType { .app }

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showMainFlow()
    }

    private func showMainFlow() {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        tabBarCoordinator.finishDelegate = self
        childCoordinators.append(tabBarCoordinator)
        
        tabBarCoordinator.start()
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(_ coordinator: Coordinator) {
        // Remove the finished child coordinator
        childCoordinators.removeAll { $0 === coordinator }
    }
}
