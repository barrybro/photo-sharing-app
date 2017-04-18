//
//  LaunchViewModel.swift
//  PhotoSharingApp
//
//  Created by Barry Brown on 4/14/17.
//  Copyright © 2017 barrybrown. All rights reserved.
//

import Foundation

struct LaunchViewModel {
    let titleString = "Flickr Photoset Viewer"
    let loadingTitle = "Loading..."
    let buttonTitle = "View Photo Set"
    let loadingDuration: TimeInterval = 0.33
    let labelTitle = "LabelTitle"
    let defaultPhotosetID = "72157680286729381"

    let alertTitle = "Uh oh!"
    let alertMessage = "Something went wrong fetching your photos."
    let alertButtonTitle = "OK"

    func loadPhotoset(showLoadingBlock: () -> Void, completion: @escaping (_ photoset: Photoset?) -> Void) {
        showLoadingBlock()

        // fetch photos and in completion return and call hide
        WebService.fetchPhotoset(photosetID: defaultPhotosetID) { (photoset: Photoset?) in
            if let photoset = photoset {
                completion(photoset)
            } else {
                completion(nil)
            }
        }
    }
}
