//
//  PostSectionController.swift
//  ModelingAndBinding
//
//  Created by Ryan Nystrom on 8/18/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import Foundation
import IGListKit

final class PostSectionController: ListBindingSectionController<Post>,
ListBindingSectionControllerDataSource,
ActionCellDelegate {

    var localLikes: Int? = nil

    lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(),
                                  viewController: self.viewController)
        adapter.dataSource = self
        return adapter
    }()

    override init() {
        super.init()
        dataSource = self
    }

    // MARK: ListBindingSectionControllerDataSource

    func sectionController(
        _ sectionController: ListBindingSectionController<ListDiffable>,
        viewModelsFor object: Any
        ) -> [ListDiffable] {
        guard let object = object as? Post else { fatalError() }
        let results: [ListDiffable] = [
            UserViewModel(username: object.username, timestamp: object.timestamp),
            object.imageURLs.count == 1 ? ImageViewModel(url: object.imageURLs.first!) : ImageListViewModel(urls: object.imageURLs),
            ActionViewModel(likes: localLikes ?? object.likes)
        ]
        return results + object.comments
    }

    func sectionController(
        _ sectionController: ListBindingSectionController<ListDiffable>,
        sizeForViewModel viewModel: Any,
        at index: Int
        ) -> CGSize {
        guard let width = collectionContext?.containerSize.width else { fatalError() }
        let height: CGFloat
        switch viewModel {
        case is ImageViewModel, is ImageListViewModel: height = 250
        case is Comment: height = 35
        default: height = 55
        }
        return CGSize(width: width, height: height)
    }

    func sectionController(
        _ sectionController: ListBindingSectionController<ListDiffable>,
        cellForViewModel viewModel: Any,
        at index: Int
        ) -> UICollectionViewCell {
        let identifier: String
        switch viewModel {
        case is ImageViewModel: identifier = "image"
        case is ImageListViewModel: identifier = "embedded"
        case is Comment: identifier = "comment"
        case is UserViewModel: identifier = "user"
        default: identifier = "action"
        }
        guard let cell = collectionContext?
            .dequeueReusableCellFromStoryboard(withIdentifier: identifier, for: self, at: index)
            else { fatalError() }
        if let cell = cell as? ActionCell {
            cell.delegate = self
        } else if let cell = cell as? ImageListCell {
            adapter.collectionView = cell.collectionView
        }
        return cell
    }

    // MARK: ActionCellDelegate

    func didTapHeart(cell: ActionCell) {
        localLikes = (localLikes ?? object?.likes ?? 0) + 1
        update(animated: true)
    }

}

extension PostSectionController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        let objects = viewModels
            .compactMap({ $0 as? ImageListViewModel })
            .flatMap({$0.urls})
            .map({ImageViewModel(url: $0)})
        return objects
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is ImageViewModel {
            return ImageSectionController()
        }
        return ListSectionController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

class ImageSectionController: ListSectionController {
    var imageViewModel: ImageViewModel?

    override func sizeForItem(at index: Int) -> CGSize {
        guard let width = collectionContext?.containerSize.width else { fatalError() }

        return CGSize(width: width, height: 250)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCellFromStoryboard(withIdentifier: "image", for: self, at: index) as? ImageCell,
        let viewModel = imageViewModel else { fatalError() }

        cell.viewModel = viewModel
        return cell
    }

    override func didUpdate(to object: Any) {
        imageViewModel = object as? ImageViewModel
    }
}
