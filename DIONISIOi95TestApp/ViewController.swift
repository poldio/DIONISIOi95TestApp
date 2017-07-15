//
//  ViewController.swift
//  DIONISIOi95TestApp
//
//  Created by Paul Dionisio on 7/14/17.
//  Copyright © 2017 Paul Dionisio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    private var movies : NSMutableArray!
    private var myTableView: UITableView!
    lazy var searchBar:UISearchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.movies = NSMutableArray()
        self.addTableView()
        
        
    }
    
    func addTableView() -> Void
    {
        let barHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MovieCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        
        searchBar.searchBarStyle = UISearchBarStyle.Prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.translucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        
        let rightNavBarButton = UIBarButtonItem(title: "Search", style: .Plain, target: self, action:#selector(ViewController.searchButton))

        self.navigationItem.rightBarButtonItem = rightNavBarButton
        navigationItem.titleView = searchBar
        
        
        self.view.addSubview(myTableView)
        
    }
    
    func searchButton ()
    {
        // retrieve movies search results
        let req = HTTPRequests()
        let search = searchBar.text
        let escapedString = search!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        let path = iTunesSearch.appendSearchURL(escapedString!)
        let url: NSURL = NSURL(string: path)!
        let request = NSMutableURLRequest(URL: url)
        
        
        req.httpGet(request) { string, error in
            guard error == nil && string != nil else {
                print(error?.localizedDescription)
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.movies.removeAllObjects()
                let movies = HTTPRequests.convertStringToDictionary(string!)
                
                for (key, value) in movies! {
                    if(key == "results")
                    {
                        
                        for var i in (0..<value.count)
                        {
                            let par = value.objectAtIndex(i) as! NSDictionary
                            self.movies.addObject(HTTPRequests.convertMoviesDataModel(par))
                            
                        }
                    }
                }
                // for debugging only
                for var i in (0..<self.movies!.count)
                {
                    var movie : Movies
                    movie = self.movies!.objectAtIndex(i) as! Movies
                    print("i was here", movie.artistName)
                }
                self.myTableView.reloadData()
            })
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let newViewController = DetailsViewController()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.movies.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath)
        
        var movie : Movies!
        movie = Movies()
        movie = self.movies.objectAtIndex(indexPath.row) as! Movies
        cell.textLabel!.text = movie.trackName
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            let myImage =  UIImage(data: NSData(contentsOfURL: NSURL(string:movie.artworkUrl100)!)!)
            cell.imageView!.image = myImage!
        })
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

