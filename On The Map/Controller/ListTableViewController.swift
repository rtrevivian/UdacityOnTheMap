//
//  ListTableViewController.swift
//  On The Map
//
//  Created by Richard Trevivian on 10/20/15.
//  Copyright © 2015 Richard Trevivian. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addNavigation()
        clearsSelectionOnViewWillAppear = true
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: "load", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        load()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OTMStudents.studentInformations.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let studentLocation = OTMStudents.studentInformations[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.imageView?.image = UIImage(named: "pin")
        cell.textLabel?.text = studentLocation.title
        cell.detailTextLabel?.text = studentLocation.mediaURL
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        openURL(OTMStudents.studentInformations[indexPath.row].mediaURL!)
    }
    
    // MARK: - Methods
    
    func load() {
        OTMStudents.getStudentLocations { (error) -> Void in
            guard error == nil else {
                self.presentSimpleAlert(error!.localizedDescription, message: OTMClient.ErrorMessages.tryAgain)
                return
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            })
        }
    }

}
