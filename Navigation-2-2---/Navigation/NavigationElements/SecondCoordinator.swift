//
//  SecondNavigationController.swift
//  Navigation
//
//  Created by Artemiy Zuzin on 05.09.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import UIKit

protocol Coordinator {
    
    func pushLogInViewController()
    
    func pushProfileViewController()
    
    func pushPhotosViewController(images: [UIImageView])
        
}

protocol SecondCoordinatable {
    
    var coordintor: SecondCoordinator? { get set }
    
}

final class SecondCoordinator: Coordinator, Coordinatable {
    
    init() {
        self.pushLogInViewController()
    }
    
    var tabBar: TabBarController?
    var callTabBar: (() -> Void)?
    
    private let navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        
            navigationController.tabBarItem = UITabBarItem(title: NSLocalizedString("Profile",
                                                                                    comment: ""),
                                  image: UIImage(systemName: "person.fill"),
                                  selectedImage: UIImage(systemName: "person.fill"))
        
            navigationController.title = NSLocalizedString("Profile", comment: "")
        
        return navigationController
    }()
    
    func pushLogInViewController() {
        let viewController = LogInViewController()
        
        viewController.coordintor = self
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func pushProfileViewController() {
        let viewController = ProfileViewController()
        
        viewController.coordintor = self
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func pushPhotosViewController(images: [UIImageView] = []) {
        let viewController = PhotosViewController()
        
        viewController.imageViews = images
        viewController.coordintor = self
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func getNavigationController() -> UINavigationController {
        return self.navigationController
    }
    
}
