//
//  PhotosListViewModel.swift
//  PhotoSharingApp
//
//  Created by Barry Brown on 4/14/17.
//  Copyright © 2017 barrybrown. All rights reserved.
//

import Foundation

struct PhotosListViewModel {

    let photoset: Photoset

    func photosetTitle() -> String {
        return photoset.photosetTitle
    }

    func photoCount() -> Int {
        return photoset.photos.count
    }

    func photo(index: Int) -> Photo? {
        let photoCount = photoset.photos.count
        guard index < photoCount else {
            return nil
        }
        return photoset.photos[index]
    }
}
