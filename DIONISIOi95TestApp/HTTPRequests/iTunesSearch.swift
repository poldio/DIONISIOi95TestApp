//
//  iTunesSearch.swift
//  DIONISIOi95TestApp
//
//  Created by Paul Dionisio on 7/14/17.
//  Copyright © 2017 Paul Dionisio. All rights reserved.
//

import Foundation

class iTunesSearch {

    private static let itunesBaseURL = "https://itunes.apple.com/"
    
    static func appendSearchURL(search : String) -> String
    {
        return "\(itunesBaseURL)search?term=\(search)&country=us&entity=movie"
    }
}
