//
//  Coordinator.swift
//  SkyScrapper
//
//  Created by Angélica Rodrigues on 16/06/2024.
//

import UIKit

protocol CoordinatorFinishDelegate: AnyObject {
    /// Notify the parent coordinator that this child has finished
    func coordinatorDidFinish(_ coordinator: Coordinator)
}

protocol Coordinator: AnyObject {
    /// The navigation controller to manage navigation
    var navigationController: UINavigationController { get set }
    
    /// List of child coordinators (to avoid retain cycles and manage dependencies)
    var childCoordinators: [Coordinator] { get set }
    
    /// Coordinator type to differentiate between different flows
    var type: CoordinatorType { get }
    
    /// Delegate to notify when this coordinator finishes
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    
    /// Starts the flow managed by the coordinator
    func start()
    
    /// Removes all child coordinators and notifies the parent that this coordinator is done
    func finish()
}

// MARK: - Default Implementation for Finish
extension Coordinator {
    func finish() {
        // Clear child coordinators and notify the delegate
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(self)
    }
}

// MARK: - CoordinatorType
enum CoordinatorType {
    case app
    case tab
    case home
    case search
    case profile
}
