//
//  NavigationController.swift
//  Navigation
//
//  Created by Artemiy Zuzin on 03.09.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import UIKit

final class FirstNavigationController: UINavigationController, Coordinatable {
    var tabBar: TabBarController?
    var callTabBar: (() -> Void)?    
    
    private let createModuleFactory = CreateModuleFactory()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createModuleFactory.createModule(navigatinController: self)
        
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("Feed", comment: ""),
                                  image: UIImage(systemName: "house.fill"),
                                  selectedImage: UIImage(systemName: "house.fill"))
        
        self.title = NSLocalizedString("Feed", comment: "")
    }
}
