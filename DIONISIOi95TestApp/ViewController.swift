//
//  ViewController.swift
//  DIONISIOi95TestApp
//
//  Created by Paul Dionisio on 7/14/17.
//  Copyright © 2017 Paul Dionisio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var movies : NSMutableArray!
    private var myTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add tableview
        self.addTableView()
        
        // retrieve movies list
        self.movies = NSMutableArray()
        let req = HTTPRequests()
        let search = "paul"
        var path = iTunesSearch.appendSearchURL(search)
        var url: NSURL = NSURL(string: path)!
        var request = NSMutableURLRequest(URL: url)
        
        
        req.httpGet(request) { string, error in
            guard error == nil && string != nil else {
                print(error?.localizedDescription)
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                
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
    
    
    // add tableview
    func addTableView() -> Void
    {
        let barHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MovieCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
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
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

