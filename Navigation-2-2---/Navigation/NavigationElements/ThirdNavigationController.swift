//
//  ThirdNavigationController.swift
//  Navigation
//
//  Created by Artemiy Zuzin on 30.12.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import UIKit

class ThirdNavigationController: UINavigationController, Coordinatable {
    
    var tabBar: TabBarController?
    var callTabBar: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllers = [SaveViewController()]
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("Save", comment: ""),
                                       image: UIImage(systemName: "doc.on.doc.fill"),
                                       selectedImage: UIImage(systemName: "doc.on.doc.fill"))
        self.title = NSLocalizedString("Save", comment: "")
    }
    
}
