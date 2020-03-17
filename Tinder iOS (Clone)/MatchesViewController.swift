//  MatchesViewController.swift
//  Tinder iOS (Clone)
//  Created by Jerry Tan on 05/03/2020.
//  Copyright © 2020 Jerry Tan. All rights reserved.


import UIKit
import Parse

class MatchesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    ///images and userids variables
    var images : [UIImage] = []
    var userIds : [String] = []
    var messages : [String] = []

    ///table view outlet.
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: VIEW DID LOAD SECTION
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///table view delegate and data source.
        tableView.dataSource = self
        tableView.delegate = self
        
        ///methods that search users data and pull out profile image to display.
        if let query = PFUser.query() {
            query.whereKey("accepted", contains: PFUser.current()?.objectId)
            
            if let acceptedPeeps = PFUser.current()?["accepted"] as? [String] {
                query.whereKey("objectId", containedIn: acceptedPeeps)
                
                query.findObjectsInBackground { (objects, error) in
                    if let users = objects {
                        for user in users {
                            if let theUser = user as? PFUser {
                                if let imageFile = theUser["photo"] as? PFFileObject {
                                    
                                    imageFile.getDataInBackground(block: { (data, error) in
                                        if let imageData = data {
                                            if let image = UIImage(data: imageData) {
                                                
                                                if let objectId = theUser.objectId {
                                                    
                                                    let messageQuery = PFQuery(className: "Message")
                                                    
                                                    ///methods that use to send messages to a particular user.
                                                    messageQuery.whereKey("recipient", containedIn: [PFUser.current()?.objectId as Any])
                                                    messageQuery.whereKey("sender", containedIn: [objectId as Any])
                                                    
                                                    messageQuery.findObjectsInBackground(block: { (objects, error) in
                                                        var messagetext = "No message from this user"
                                                        if let objects = objects {
                                                            for message in objects {
                                                                if let content = message["content"] as? String  {
                                                                    messagetext = content
                                                                }
                                                            }
                                                        }
                                                        self.messages.append(messagetext)
                                                        self.userIds.append(objectId)
                                                        self.images.append(image)
                                                        self.tableView.reloadData()
                                                    })
                                                    
                                                }
                                            }
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: TABLE VIEW CELL SECTION
    ///table view methods that return rows and cell.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as? ChatTableViewCell {
        cell.messageLabel.text = "You haven't received a message yet"
        cell.profileImage.image = images[indexPath.row]
        cell.recipientObjectId = userIds[indexPath.row]
        cell.messageLabel.text = messages[indexPath.row]
            
        return cell
        }
        return ChatTableViewCell()
    }
    
    
    
    
    //MARK: BACK TO SWIPE VIEW SEGUE ACTION
    @IBAction func backToSwipeController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
