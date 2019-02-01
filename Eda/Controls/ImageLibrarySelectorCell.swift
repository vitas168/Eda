//
//  ImageLibrarySelectorCell.swift
//  Eda
//
//  Created by Шпинев Виталий Васильевич on 15/01/2019.
//  Copyright © 2019 Шпинев Виталий Васильевич. All rights reserved.
//

import UIKit
import PinLayout

class ImageLibrarySelectorCell: UICollectionViewCell {
    
    private let labelTitle = UILabel()
    
    override var isSelected: Bool {
        willSet {
            backgroundColor = newValue ? UIColor.gray.withAlphaComponent(0.1) : UIColor.white
        }
    }
    
    func initializeWith(title: String) {
        addSubview(labelTitle)
        labelTitle.text = title
        labelTitle.textColor = UIColor.black.withAlphaComponent(0.8)
        labelTitle.textAlignment = .center
        labelTitle.font = .boldSystemFont(ofSize: 14)
        layer.cornerRadius = 8.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.gray.cgColor
    }
    
    override func layoutSubviews() {
        labelTitle.pin.all(5)
    }
}
