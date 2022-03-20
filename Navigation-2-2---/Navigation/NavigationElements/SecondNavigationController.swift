//
//  SecondNavigationController.swift
//  Navigation
//
//  Created by Artemiy Zuzin on 05.09.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import UIKit

final class SecondNavigationController: UINavigationController, Coordinatable {
    var tabBar: TabBarController?
    var callTabBar: (() -> Void)?    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [LogInViewController()]
        
        tabBarItem = UITabBarItem(title: NSLocalizedString("Profile", comment: ""),
                                  image: UIImage(systemName: "person.fill"),
                                  selectedImage: UIImage(systemName: "person.fill"))
        
        title = NSLocalizedString("Profile", comment: "")
    }
}
