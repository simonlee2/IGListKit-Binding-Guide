//
//  ImageListCell.swift
//  ModelingAndBinding
//
//  Created by Simon Lee on 3/22/19.
//  Copyright © 2019 Ryan Nystrom. All rights reserved.
//

import UIKit
import IGListKit

final class ImageListCell: UICollectionViewCell, ListBindable {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.backgroundColor = .clear
            collectionView.alwaysBounceVertical = false
            collectionView.alwaysBounceHorizontal = true
        }
    }

    // MARK: ListBindable
    func bindViewModel(_ viewModel: Any) {

    }

}
