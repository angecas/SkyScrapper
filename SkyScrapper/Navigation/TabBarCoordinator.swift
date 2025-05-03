//
//  TabBarCoordinator.swift
//  SkyScrapper
//
//  Created by Angélica Rodrigues on 19/01/2025.
//


import UIKit

class TabBarCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var finishDelegate: CoordinatorFinishDelegate?
    let tabBarController: UITabBarController
    
    var type: CoordinatorType { .tab }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
    }
    
    func start() {

        let homeCoordinator = HomeCoordinator(navigationController: UINavigationController())
        homeCoordinator.start()
        
        let searchCoordinator = SearchCoordinator(navigationController: UINavigationController())
        searchCoordinator.start()
        
        let MyGroupsCoordinator = SearchCoordinator(navigationController: UINavigationController())
        searchCoordinator.start()
                
        childCoordinators = [homeCoordinator, searchCoordinator, MyGroupsCoordinator]
        
        tabBarController.viewControllers = [
            homeCoordinator.navigationController,
            searchCoordinator.navigationController,
        ]
        
        tabBarController.viewControllers?[0].tabBarItem = UITabBarItem(title: "Fly", image: UIImage(systemName: "airplane.circle"), selectedImage: UIImage(systemName: "airplane.circle.fill"))
        tabBarController.viewControllers?[1].tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        
        navigationController.setViewControllers([tabBarController], animated: false)
    }
}
