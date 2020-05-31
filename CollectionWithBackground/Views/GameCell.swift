//
//  GameCell.swift
//  CollectionWithBackground
//
//  Created by Ahmed Fathi on 5/31/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit

class GameCell: UICollectionViewCell {
    
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageContainer.layer.cornerRadius = 15
        imageContainer.clipsToBounds = true
        
        shadowView.layer.cornerRadius = 16
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowRadius = 13
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shouldRasterize = true
        shadowView.layer.rasterizationScale = UIScreen.main.scale
        
    }
    
}
