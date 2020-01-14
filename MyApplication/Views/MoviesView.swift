//
//  MoviesView.swift
//  MyApplication
//
//  Created by Can Talay on 27.12.2019.
//  Copyright © 2019 Can Talay. All rights reserved.
//

import UIKit

class MoviesView: UICollectionViewCell {

    @IBOutlet weak var visualEffect: UIVisualEffectView!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var effectView: UIVisualEffectView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.numberOfLines = 0
       
        
        
        
    }
    
    

}
