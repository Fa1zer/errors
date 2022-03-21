//
//  CustomColor.swift
//  Navigation
//
//  Created by Artemiy Zuzin on 21.03.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let textColor = UIColor.createColr(lightMode: .black, darkMode: .white)
    static let boundsColor = UIColor.createColr(lightMode: .black, darkMode: .systemGray)
    static let secondaryTextColor = UIColor.createColr(lightMode: .systemGray, darkMode: .white)
    static let backgroundColor = UIColor.createColr(lightMode: .white,
                                                    darkMode: UIColor(red: 30/255, green: 29/255,
                                                                      blue: 42/255, alpha: 1))
    static let textFieldColor = UIColor.createColr(lightMode: .systemGray6,
                                                    darkMode: UIColor(red: 39/255, green: 38/255,
                                                                      blue: 51/255, alpha: 1))
    
    static func createColr(lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else { return lightMode }
        
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
        }
    }
    
}
