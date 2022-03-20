//
//  TapBarController.swift
//  Navigation
//
//  Created by Artemiy Zuzin on 05.09.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {
    
    private let profileViewController = ProfileViewController()
    private let logInViewController = LogInViewController()
    private let photosViewController = PhotosViewController()
    private let postViewController = PostViewController()
    private let infoViewController = InfoViewController()
    private let feedModule = FeedViewModel()
    private let firstNavigationController = FirstNavigationController()
    private let secondNavigationController = SecondNavigationController()
    private let thirdNavigationController = ThirdNavigationController()
    private let saveViewController = SaveViewController()
    private let fourthNavigationController = FourthNavigationController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configureViewControllers()

        let controllers = [firstNavigationController,
                           secondNavigationController,
                           thirdNavigationController,
                           fourthNavigationController]
                
        self.viewControllers = controllers
        
        self.selectedIndex = 3
        self.selectedIndex = 2
        self.selectedIndex = 1
        self.selectedIndex = 0
    }
    
    private func configureViewControllers() {
        
        self.profileViewController.tabBar = self
        self.logInViewController.tabBar = self
        self.photosViewController.tabBar = self
        self.postViewController.tabBar = self
        self.infoViewController.tabBar = self
        self.feedModule.tabBar = self
        self.firstNavigationController.tabBar = self
        self.secondNavigationController.tabBar = self
        self.thirdNavigationController.tabBar = self
        self.saveViewController.tabBar = self
        self.fourthNavigationController.tabBar = self
        
    }
    
    
    
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
