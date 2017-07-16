//
//  DetailsViewController.swift
//  DIONISIOi95TestApp
//
//  Created by Paul Dionisio on 7/15/17.
//  Copyright © 2017 Paul Dionisio. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    
    public var movie : Movies!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var MovieView: UIView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDescription: UITextView!
    @IBOutlet weak var movieGenre: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.movieTitle.text = self.movie.trackName
        self.movieGenre.text = self.movie.primaryGenreName
        self.movieDescription.text = self.movie.longDescription
        self.loader.startAnimating()
        self.loader.hidden = false
        print("track view url", self.movie.trackViewUrl)
       
        
        
        // retrieve movies search results
        let req = HTTPRequests()
        
        // retrieve 300x300 movie image
        var urlStr : String
        urlStr = self.movie.artworkUrl100!
        var i=0
        while (i<13)
        {
            urlStr = urlStr.substringToIndex(urlStr.endIndex.predecessor())  // "ab"
            i++
        }
        urlStr = "\(urlStr)300x300bb.jpg"
        
        let url: NSURL = NSURL(string: urlStr)!
        let request = NSMutableURLRequest(URL: url)
        print("str: ", url)
        
        
        HTTPRequests.httpGetImage(request) { string, error in
            guard error == nil && string != nil else {
                print(error?.localizedDescription)
                return
            }
            let _image = UIImage(data: string!)
            dispatch_async(dispatch_get_main_queue(), {

                self.movieImage.image = _image
                self.loader.stopAnimating()
                self.loader.hidden = true
            })
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
