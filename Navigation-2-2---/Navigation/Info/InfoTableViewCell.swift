//
//  InfoTableViewCell.swift
//  Navigation
//
//  Created by Artemiy Zuzin on 21.11.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import UIKit
import SnapKit

class InfoTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var name: String? {
        didSet {
            if let name = name {
                nameLabel.text = name
            }
        }
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = .clear
        label.tintColor = .black
        label.textAlignment = .center
        label.text = "none"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private func setupViews() {
        addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
