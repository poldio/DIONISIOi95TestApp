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
    public var ifLocal : Bool!
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var MovieView: UIView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDescription: UITextView!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var movieActor: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(self.ifLocal == false)
        {
            let bookmark = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Bookmarks, target: self, action:#selector(DetailsViewController.bookmark))
            navigationItem.rightBarButtonItem = bookmark
        }
        else
        {
            var lblTitle : UILabel
            lblTitle = UILabel()
            lblTitle.textColor = UIColor(colorLiteralRed: 0.2, green: 0.4, blue: 1, alpha: 1)
            lblTitle.text = "Favourites"
            self.navigationItem.titleView?.addSubview(lblTitle)
        }
        
        self.movieTitle.text = self.movie.trackName
        let year = String(self.movie.releaseDate!.characters.prefix(4))
        let genre = self.movie.primaryGenreName!
        self.movieGenre.text = "\(year) * \(genre)"
        print("artist \(self.movie.artistName!)")
        self.movieActor.text = self.movie.artistName!
        self.movieDescription.text = self.movie.longDescription!
        self.loader.startAnimating()
        self.loader.hidden = false
        
        if(ifLocal == false)
        {
            
            // retrieve movies search results
            let req = HTTPRequests()
            
            // retrieve 300x300 movie image
            var urlStr : String
            urlStr = self.movie.artworkUrl100!
            
            /*
            var i=0
            while (i<13)
            {
                urlStr = urlStr.substringToIndex(urlStr.endIndex.predecessor())
                i++
            }
            */
            
            for var i in (0..<13)
            {
                urlStr = urlStr.substringToIndex(urlStr.endIndex.predecessor())
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
        }
        else
        {            
            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let destinationPath = documentsPath.stringByAppendingString(self.movie.artworkUrl100!)
            print("dest \(destinationPath)")
           
            dispatch_async(dispatch_get_main_queue(), {
                    
                self.movieImage!.image = UIImage(contentsOfFile: String(UTF8String: self.movie.artworkUrl100!)!)
                self.loader.stopAnimating()
                self.loader.hidden = true
            })
        }
        
        // Do any additional setup after loading the view.
    }
    
    func bookmark()
    {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let destinationPathImg = documentsPath.stringByAppendingString("/\(self.movie.trackName).jpg")
        let destinationPathIco = documentsPath.stringByAppendingString("/\(self.movie.trackName)ico.jpg")

        var _movie : NSMutableDictionary
        _movie = NSMutableDictionary()
        _movie.setObject(self.movie.trackName!, forKey:"title")
        _movie.setObject(self.movie.primaryGenreName!, forKey:"genre")
        _movie.setObject(self.movie.releaseDate!, forKey:"year")
        _movie.setObject(self.movie.artistName!, forKey:"actor")
        _movie.setObject(self.movie.longDescription!, forKey:"description")
        _movie.setObject(destinationPathImg, forKey:"image")
        _movie.setObject(destinationPathIco, forKey:"imageico")

        
        let completeMovies = HTTPRequests.saveToPlist(_movie)
        //let succeed = NSKeyedArchiver.archiveRootObject(completeMovies, toFile: path)
        
        print(completeMovies)
        
        
        let filepath = HTTPRequests.applicationDocumentsDirectory().stringByAppendingString("/Bookmarks.plist")
        completeMovies.writeToFile(filepath, atomically: true)
        
        print("Does file exist: \(NSFileManager.defaultManager().fileExistsAtPath(filepath)) at path: \(filepath)")

        
        UIImageJPEGRepresentation(self.movieImage.image! ,1.0)!.writeToFile(destinationPathImg, atomically: true)
        
        let url: NSURL = NSURL(string: movie.artworkUrl100!)!
        let request = NSMutableURLRequest(URL: url)
        
        HTTPRequests.httpGetImage(request) { string, error in
            guard error == nil && string != nil else {
                print(error?.localizedDescription)
                return
            }
            let _image = UIImage(data: string!)
            UIImageJPEGRepresentation(_image! ,1.0)!.writeToFile(destinationPathIco, atomically: true)
        }
        
        let alert = UIAlertController(title: "iTunes", message:"Movie Saved!", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
        self.presentViewController(alert, animated: true){}
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
