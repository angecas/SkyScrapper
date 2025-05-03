//
//  SearchCoordinator.swift
//  SkyScrapper
//
//  Created by Angélica Rodrigues on 19/01/2025.
//


import UIKit

class SearchCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var finishDelegate: CoordinatorFinishDelegate?
    
    var type: CoordinatorType { .search }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let searchViewController = UIViewController()
        searchViewController.title = "Search"
        navigationController.pushViewController(searchViewController, animated: false)
    }
}
