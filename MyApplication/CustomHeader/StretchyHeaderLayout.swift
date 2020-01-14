//
//  StretchyHeaderLayout.swift
//  MyApplication
//
//  Created by Can Talay on 31.12.2019.
//  Copyright © 2019 Can Talay. All rights reserved.
//

import UIKit

class StretchyHeaderLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let layoutAttiributes = super.layoutAttributesForElements(in: rect)
        
        layoutAttiributes?.forEach({ (attributes) in
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader && attributes.indexPath.section == 0 {
                
                guard let collectionView = collectionView else { return }
                
                let contentOffsetY = collectionView.contentOffset.y
                let height = attributes.frame.height - contentOffsetY
                
                print("content of Y \(contentOffsetY)")
                print("height : \(height)")
                
                let width = collectionView.frame.width
                
                
                
                attributes.frame = CGRect(x: 0, y: min(contentOffsetY, abs(attributes.frame.height)), width: width, height: max(height,150))
                
            }
        })
        return layoutAttiributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
