//
//  RestaurantCell.swift
//  Eda
//
//  Created by Шпинев Виталий Васильевич on 14/01/2019.
//  Copyright © 2019 Шпинев Виталий Васильевич. All rights reserved.
//

import UIKit
import PinLayout
import SDWebImage
import Nuke
import Kingfisher

class RestaurantCell: UITableViewCell {
    
    private let imageViewRestaurant = UIImageView()
    private let labelRestaurantName = UILabel()
    private let labelRestaurantDescription = UILabel()
    
    private let widthPlaceholder = "{w}"
    private let heightPlaceholder = "{h}"
    private let messageNoDescription = "Нет описания"
    private let urlPrefix = "https://eda.yandex"
    private let defaultImageWidth: Float = 100.0
    private let defaultImageHeight: Float = 75.0
    private let defaultAspectRatio: Float = 1.33
    
    func setupCell() {
        addSubview(imageViewRestaurant)
        addSubview(labelRestaurantName)
        addSubview(labelRestaurantDescription)
        labelRestaurantName.numberOfLines = 0
        labelRestaurantDescription.numberOfLines = 0
    }
    
    override func layoutSubviews() {
        imageViewRestaurant.pin.top(0).left(10).width(100).height(75).bottom(10)
        labelRestaurantName.pin.right(of: imageViewRestaurant).marginLeft(10).top(0).right(10).minHeight(14).sizeToFit(.width)
        labelRestaurantDescription.pin.right(of: imageViewRestaurant).below(of: labelRestaurantName).marginLeft(10).marginTop(10).right(10).minHeight(14).sizeToFit(.width)
    }
    
    func injectData(restaurant: Restaurant, library: ImageLibrary) {

        labelRestaurantName.text = restaurant.name ?? ""
        labelRestaurantName.sizeToFit()
        labelRestaurantDescription.text = restaurant.description ?? messageNoDescription
        labelRestaurantDescription.sizeToFit()

        if let url = restaurant.url, let aspectRatio = restaurant.aspectRatio {
            let composedUrl = composeImageUrl(url, forAspectRatio: aspectRatio)
            loadImage(url: composedUrl, withLibrary: library)
        }
    }
}

// MARK: - Private functions
private extension RestaurantCell {
    private func composeImageUrl(_ imageUrl: String, forAspectRatio aspectRatio: Float) -> String {
       
        func setImageSize(inUrl inputUrl: String, toWidth width: Int, andHeight height: Int) -> String {
            var url = inputUrl
            if let rangeW = url.range(of: widthPlaceholder) {
                url.replaceSubrange(rangeW, with: String(width))
            }
            if let rangeH = url.range(of: heightPlaceholder) {
                url.replaceSubrange(rangeH, with: String(height))
            }
            return url
        }

        var url = ""
        
        if aspectRatio >= defaultAspectRatio {
            
            url = setImageSize(inUrl: imageUrl,
                               toWidth: Int(defaultImageWidth),
                               andHeight: Int(defaultImageWidth/aspectRatio))

        } else if aspectRatio > 0 {

            url = setImageSize(inUrl: imageUrl,
                               toWidth: Int(aspectRatio * defaultImageHeight),
                               andHeight: Int(defaultImageHeight))
            
        } else {
            
            url = setImageSize(inUrl: imageUrl,
                               toWidth: Int(defaultImageWidth),
                               andHeight: Int(defaultImageHeight))
        }
        
        url = urlPrefix + url
        return url
    }
    
    private func loadImage(url: String, withLibrary library: ImageLibrary) {
        
        guard let formattedUrl = URL(string: url) else { return }
        
        switch library {
        case .kingfisher:
            loadImageWithKingfisher(url: formattedUrl)
        case .nuke:
            loadImageWithNuke(url: formattedUrl)
        case .sdWebImage:
            loadImageWithSdWebImage(url: formattedUrl)
        }
    }
    
    private func loadImageWithKingfisher(url: URL) {
        imageViewRestaurant.kf.indicatorType = .activity
        imageViewRestaurant.kf.setImage(with: url, placeholder: UIImage(named: "food"), options: [.transition(.fade(0.25))])
    }

    private func loadImageWithSdWebImage(url: URL) {
        imageViewRestaurant.sd_setShowActivityIndicatorView(true)
        imageViewRestaurant.sd_setIndicatorStyle(.gray)
        imageViewRestaurant.sd_setImage(with: url, completed: {_, _, _, _ in})
    }
    
    private func loadImageWithNuke(url: URL) {
        Nuke.loadImage(
            with: url,
            options: ImageLoadingOptions(
                placeholder: UIImage(named: "food"),
                transition: .fadeIn(duration: 0.25)
            ),
            into: imageViewRestaurant
        )
    }
}
