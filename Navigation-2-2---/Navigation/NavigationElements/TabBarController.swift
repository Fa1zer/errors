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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureViewControllers()

        let controllers = [firstNavigationController,
                           secondNavigationController,
                           thirdNavigationController]
                
        self.viewControllers = controllers
        
        selectedIndex = 2
        selectedIndex = 1
        selectedIndex = 0
    }
    
    private func configureViewControllers() {
        profileViewController.tabBar = self
        logInViewController.tabBar = self
        photosViewController.tabBar = self
        postViewController.tabBar = self
        infoViewController.tabBar = self
        feedModule.tabBar = self
        firstNavigationController.tabBar = self
        secondNavigationController.tabBar = self
        thirdNavigationController.tabBar = self
        saveViewController.tabBar = self
    }
    
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
