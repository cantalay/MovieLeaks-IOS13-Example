//
//  DetailViewCell.swift
//  MyApplication
//
//  Created by Can Talay on 2.01.2020.
//  Copyright © 2020 Can Talay. All rights reserved.
//

import UIKit

class DetailViewCell: UICollectionViewCell {
    var heavyLabel = UILabel()
    var descriptionLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        heavyLabel.text = "lorem ipsum"
        heavyLabel.font  = .systemFont(ofSize: 18, weight: .heavy)
        heavyLabel.textColor = .white
        
        
        descriptionLabel.text = "LoremIpsumLoremIpsumLoremIpsum"
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0
        let stackView = UIStackView(arrangedSubviews: [heavyLabel,descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        
        addSubview(stackView)
        
        stackView.fillSuperview(withPadding: .init(top: 10, left: 10, bottom: 10, right: 10
            ))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
