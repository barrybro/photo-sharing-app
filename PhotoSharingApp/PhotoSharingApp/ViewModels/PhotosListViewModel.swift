//
//  PhotosListViewModel.swift
//  PhotoSharingApp
//
//  Created by Barry Brown on 4/14/17.
//  Copyright © 2017 barrybrown. All rights reserved.
//

import Foundation

struct PhotosListViewModel {
    let screenTitle = "Photos List"
    let photoset: Photoset
}

let url = "https://api.flickr.com/services/rest/?method=flickr.photosets.getPhotos&api_key=91254bea8c4aa44590f868e76a44bf85&photoset_id=72157680286729381&user_id=34478335%40N00&format=json&nojsoncallback=1&api_sig=3f23e5c0aa4d3beadcf93661f724bd8f"

struct PhotosetFetcher {
    static let baseURL = "https://api.flickr.com/services/rest/?method=flickr.photosets.getPhotos"
    static let apiURL = "&api_key="
    static let apiKey = "96ed7003403f50e4a475e91cf172e16d"
    static let photosetURL = "&photoset_id="
    static let photosetID = "72157680286729381"
    static let userURL = "&user_id="
    static let userID = "34478335@N00"
    static let formatURL = "&format="
    static let formatType = "json&nojsoncallback=1"
    static let apiSigURL = "&api_sig"
    static let apiSigID = "3f23e5c0aa4d3beadcf93661f724bd8f"

    static func makeRequestURL() -> URL? {
        var requestURL = baseURL + apiURL + apiKey + photosetURL + photosetID + userURL + userID + formatURL + formatType + apiSigURL + apiSigID
        requestURL = requestURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        return URL(string: requestURL)
    }

    static func fetchPhotosets(completion: @escaping (_ photoset: Photoset?) -> Void) {
        guard let requestURL = makeRequestURL() else {
            print("Error building request URL")
            completion(nil)
            return
        }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let downloadTask = session.dataTask(with: requestURL, completionHandler: {(data, response, error) in
            guard let responseData = data else {
                debugPrint("ERROR \(String(describing: error))")
                completion(nil)
                // Handle errors?
                return
            }
            guard let jsonResponse: [String: Any] = try? JSONSerialization.jsonObject(with: responseData) as! [String : Any] else {
                completion(nil)
                return
            }

            guard let photoset = Photoset(dictionary: jsonResponse["photoset"] as! [String : Any]) else {
                print("parse error")
                completion(nil)
                return
            }
            print("parse success for \(photoset)")
            completion(photoset)
        })

        // Kick things off
        downloadTask.resume()
    }
}
