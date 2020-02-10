//  ViewController.swift
//  Tinder iOS (Clone)
//  Created by Jerry Tan on 23/01/2020.
//  Copyright © 2020 Jerry Tan. All rights reserved.


import UIKit
import Parse

class SwipeObjectViewController: UIViewController {
    
    //MARK: SWIPE OBJECT UILABEL
    @IBOutlet weak var matchImageView: UIImageView!
    
    //MARK: DISPLAY USER ID VARIABLE
    var displayUserID = ""
    
    
    //MARK: VIEW DID LOAD BLOCK
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateProfileImage()
        
        ///A concrete subclass of UIGestureRecognizer that looks for panning (dragging) gestures.
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(draggedFunction(gestureRecognizer:)))
            matchImageView.addGestureRecognizer(gesture)
    }
    
    
    //MARK: LOGOUT ACTION BLOCK
    @IBAction func logoutButtonAction(_ sender: Any) {
        PFUser.logOut()
        performSegue(withIdentifier: "logoutSegue", sender: self)
    }
    
    
    
    //MARK: DRAGGED FUNCTION BLOCK
    @objc func draggedFunction(gestureRecognizer: UIPanGestureRecognizer) {
        
        ///Methods that make the swipe object rotate.
        let xFromCenter = view.bounds.width / 2 - matchImageView.center.x
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        let scale = min(100 / abs(xFromCenter), 1)
        var scaleAndRotated = rotation.scaledBy(x: scale, y: scale)
        
        matchImageView.transform = scaleAndRotated
        
        
        ///Methods that move the swipe object around.
        let labelPoint = gestureRecognizer.translation(in: view)
        matchImageView.center = CGPoint(x: view.bounds.width / 2 + labelPoint.x, y: view.bounds.height / 2 + labelPoint.y)
        
        ///Methods that detect swipe left for not interested right for interested.
        if gestureRecognizer.state == .ended {
            
            //MARK: ACCEPTED OR REJECTED VARIABLE
            var acceptedOrRejected = ""
            
            if matchImageView.center.x < (view.bounds.width / 2 - 100) {
                print("Not Interested")
                acceptedOrRejected = "rejected"
            }
            if matchImageView.center.x > (view.bounds.width / 2 + 100) {
                print("Interested")
                acceptedOrRejected = "accepted"
                
            }
            ///Methods tha save accepted or rejected status to Parse server.
            if acceptedOrRejected != "" && displayUserID != "" {
                PFUser.current()?.addUniqueObject(displayUserID, forKey: acceptedOrRejected)
                
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    if success {
                        self.updateProfileImage()
                    }
                })
            }
            
                ///Methods that reset the swipe object rotation and position back to default position.
                rotation = CGAffineTransform(rotationAngle: 0)
                scaleAndRotated = rotation.scaledBy(x: 1, y: 1)
                matchImageView.transform = scaleAndRotated
                matchImageView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
            }
    }
    
    
    
    
    
    
    //MARK: UPDATE PROFILE IMAGE FUNCTION BLOCK
    func updateProfileImage() {
        if let query = PFUser.query() {
        
        ///Methods that check the user gender and interested status.
        if let isInterestedInWoman = PFUser.current()?["isInterestedInWoman"] {
            query.whereKey("isFemale", equalTo: isInterestedInWoman)
        }
        if let isFemale = PFUser.current()?["isFemale"] {
            query.whereKey("isInterestedInWoman", equalTo: isFemale)
        }
            
        ///Methods that load up another data when the user swipping to confirmed the status.
        var ignoreUsers : [String] = []
        
            if let acceptedUsers = PFUser.current()?["accepted"] as? [String] {
                ignoreUsers += acceptedUsers
            }
            if let rejectedUsers = PFUser.current()?["rejected"] as? [String] {
                ignoreUsers += rejectedUsers
            }
            query.whereKey("objectId", notContainedIn: ignoreUsers)
            
            query.limit = 1
            
        ///Finds objects *asynchronously* and calls the given block with the results.
        query.findObjectsInBackground { (objects, error) in
            if let users = objects {
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        ///Retrieve user image data from Parse server.
                        if let imageFile = user["photo"] as? PFFileObject {
                            imageFile.getDataInBackground(block: { (data, error) in
                                if let imageData = data {
                                    self.matchImageView.image = UIImage(data: imageData)
                                    
                                    ///Set user object id.
                                    if let objectID = object.objectId {
                                        self.displayUserID = objectID
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
