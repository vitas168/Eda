//
//  ImageLibrarySelector.swift
//  Eda
//
//  Created by Шпинев Виталий Васильевич on 15/01/2019.
//  Copyright © 2019 Шпинев Виталий Васильевич. All rights reserved.
//

import UIKit

enum ImageLibrary: String {
    case sdWebImage = "SDWebImage"
    case kingfisher = "Kingfisher"
    case nuke = "Nuke"
}

// MARK: - ImageLibrarySelectorDelegate protocol
protocol ImageLibrarySelectorDelegate: class {
    func didSelectLibrary(_ library: ImageLibrary)
}

// MARK: - ImageLibrarySelector class
class ImageLibrarySelector: UICollectionView {

    private let libraries = ["SDWebImage", "Kingfisher", "Nuke"]
    private let cellReuseIdentifier = "imageLibrarySelectorCell"
    weak var customDelegate: ImageLibrarySelectorDelegate?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: frame, collectionViewLayout: layout)
        self.dataSource = self
        self.delegate = self
        backgroundColor = .white
        register(ImageLibrarySelectorCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - UICollectionViewDelegate methods
extension ImageLibrarySelector: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let libraryName = libraries[indexPath.row]
        if let library = ImageLibrary.init(rawValue: libraryName) {
            customDelegate?.didSelectLibrary(library)
        }
    }
}

// MARK: - UICollectionViewDataSource methods
extension ImageLibrarySelector: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return libraries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! ImageLibrarySelectorCell
        cell.initializeWith(title: libraries[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout methods
extension ImageLibrarySelector: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let textWidth: CGFloat = libraries[indexPath.row].width(withConstraintedHeight: 20, font: .boldSystemFont(ofSize: 14))
        return CGSize(width: textWidth + 20, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10.0)
    }
}
