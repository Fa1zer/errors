//
//  FourthNavigationController.swift
//  Navigation
//
//  Created by Artemiy Zuzin on 17.03.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import Foundation
import UIKit

final class FourthNavigationController: UINavigationController, Coordinatable {
    
    var tabBar: TabBarController?
    var callTabBar: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllers = [GeolocationViewController()]
        
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("Geocoder", comment: ""),
                                       image: UIImage(systemName: "globe"),
                                       selectedImage: UIImage(systemName: "globe"))
        self.title = NSLocalizedString("Geocoder", comment: "")
    }
    
}
