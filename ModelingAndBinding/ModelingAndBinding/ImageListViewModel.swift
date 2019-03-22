//
//  ImageListViewModel.swift
//  ModelingAndBinding
//
//  Created by Simon Lee on 3/22/19.
//  Copyright © 2019 Ryan Nystrom. All rights reserved.
//

import UIKit
import IGListKit

final class ImageListViewModel: ListDiffable {

    let urls: [URL]

    init(urls: [URL]) {
        self.urls = urls
    }

    // MARK: ListDiffable
    func diffIdentifier() -> NSObjectProtocol {
        return "image-list" as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? ImageListViewModel else { return false }
        return urls == object.urls
    }

}
