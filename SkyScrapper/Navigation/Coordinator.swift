//
//  Coordinator.swift
//  SkyScrapper
//
//  Created by Angélica Rodrigues on 16/06/2024.
//

import UIKit

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(_ coordinator: Coordinator)
    
}

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController {get set}
    var childCoordinator: [Coordinator] {get set}
    var type: CoordinatorType {get set}
    var finishDelegate: CoordinatorFinishDelegate? {get set}
    func start()
}

extension Coordinator {
    func finish() {
        childCoordinator.removeAll()
        finishDelegate?.coordinatorDidFinish(self)
    }
}

enum CoordinatorType {
    case app
}
