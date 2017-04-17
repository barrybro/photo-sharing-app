//
//  WebService.swift
//  PhotoSharingApp
//
//  Created by Barry Brown on 4/17/17.
//  Copyright © 2017 barrybrown. All rights reserved.
//

import Foundation
import OAuthSwift

/*
"https://api.flickr.com/services/rest/" +
"?method=" +
"flickr.photos.getSizes" +
"&api_key=" +
"b8ed5d6479761720c97348abee0e226e" +
"&photo_id=" +
"33720404102" +
"&format=" +
"json&nojsoncallback=1" +
"&auth_token=" +
"72157682597400176-4b8aae9e574f1785" +
"&api_sig=" +
"db0793e31cbfd67d46599308e3605129"
*/

class WebService {

    // MARK: - OAuth Properties

    static let flickrKey = "96ed7003403f50e4a475e91cf172e16d"
    static let flickrSecret = "588dc19e3d8ab9e2"
    static let authenticationURLForMyApp = "https://www.flickr.com/auth-72157680536890821"
    static let requestTokenURL = "https://www.flickr.com/services/oauth/request_token"
    static let authorizeURL = "https://www.flickr.com/services/oauth/authorize"
    static let accessTokenURL = "https://www.flickr.com/services/oauth/access_token"

    static let baseURL = "https://api.flickr.com/services/rest/"
    static let methodURL = "?method="
    static let methodKey = "flickr.photosets.getSizes"
    static let apiURL = "&api_key="
    static let apiKey = "96ed7003403f50e4a475e91cf172e16d"
    static let photoURL = "&photo_id="
    static let photoID = "33720404102"
    static let userURL = "&user_id="
    static let userID = "34478335@N00"
    static let formatURL = "&format="
    static let formatType = "json&nojsoncallback=1"
    static let authTokenURL = "&auth_token="
    static let authToken = "72157682597400176-4b8aae9e574f1785"
    static let apiSigURL = "&api_sig"
    static let apiSigID = "3f23e5c0aa4d3beadcf93661f724bd8f"

    static func makeRequestURL() -> URL? {
        var requestURL = baseURL + methodURL + methodKey + apiURL + apiKey + photoURL + photoID + formatURL + formatType + authTokenURL + authToken + apiSigURL + apiSigID
        requestURL = requestURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        return URL(string: requestURL)
    }

    static func oauthSwift() -> OAuth1Swift {
        let oauthSwift = OAuth1Swift(consumerKey: WebService.flickrKey,
                                     consumerSecret: WebService.flickrSecret,
                                     requestTokenUrl: WebService.requestTokenURL,
                                     authorizeUrl: WebService.authorizeURL,
                                     accessTokenUrl: WebService.accessTokenURL)
        return oauthSwift
    }
}

//let url = "https://api.flickr.com/services/rest/?method=flickr.photosets.getPhotos&api_key=91254bea8c4aa44590f868e76a44bf85&photoset_id=72157680286729381&user_id=34478335%40N00&format=json&nojsoncallback=1&api_sig=3f23e5c0aa4d3beadcf93661f724bd8f"

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
                return
            }
            guard let jsonResponse: [String: Any] = try? JSONSerialization.jsonObject(with: responseData) as! [String : Any] else {
                completion(nil)
                return
            }
            guard let photosetDictionary = jsonResponse["photoset"] as? [String : Any] else {
                print("parse photoset dictionary error")
                completion(nil)
                return
            }
            guard let photoset = Photoset(dictionary: photosetDictionary) else {
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
