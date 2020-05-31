//
//  HeaderView.swift
//  CollectionWithBackground
//
//  Created by Ahmed Fathi on 5/31/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    // MARK: View Functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setupViews()
    }
    
    private func setupViews() {
        contentView.backgroundColor = .clear
    }
}


