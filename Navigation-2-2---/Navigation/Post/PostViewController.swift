//
//  PostViewController.swift
//  Navigation
//
//  Created by Artem Novichkov on 12.09.2020.
//  Copyright © 2020 Artem Novichkov. All rights reserved.
//

import UIKit
import StorageService

final class PostViewController: UIViewController, Coordinatable {
    
    var callTabBar: (() -> Void)?
    weak var tabBar: TabBarController?
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .backgroundColor
        
        self.title = post?.title
        
        self.navigationItem.title = NSLocalizedString("Post", comment: "")
        
        self.present(InfoViewController(), animated: true)
    }
}
