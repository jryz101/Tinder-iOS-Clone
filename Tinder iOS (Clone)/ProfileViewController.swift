//  ProfileViewController.swift
//  Tinder iOS (Clone)
//  Created by Jerry Tan on 31/01/2020.
//  Copyright © 2020 Jerry Tan. All rights reserved.


import UIKit
import Parse

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //MARK: PROFILE IMAGE PROPERTY
    @IBOutlet weak var profileImage: UIImageView!
    
    //MARK: SWITCHES UISWITCH
    @IBOutlet weak var genderSwitch: UISwitch!
    @IBOutlet weak var interestedInSwitch: UISwitch!
    
    //MARK: ERROR LABEL PROPERTY
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    
    //MARK: VIEW DID LOAD BLOCK
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.isHidden = true
        
        ///Methods that retrieve user saved profile data after the user login. 
        if let isFemale = PFUser.current()?["isFemale"] as? Bool {
            genderSwitch.setOn(isFemale, animated: false)
        }
        if let isInterestedInWoman = PFUser.current()?["isInterestedInWoman"] as? Bool {
            interestedInSwitch.setOn(isInterestedInWoman, animated: false)
        }
        if let photo = PFUser.current()?["photo"] as? PFFileObject {
            photo.getDataInBackground { (data, error) in
                if let imageData = data {
                    if let image = UIImage(data: imageData) {
                        self.profileImage.image = image
                    }
                }
            }
        }
    }
    
    //MARK: CREATE WOMAN DATA FUNCTION BLOCK
    func createWomanData() {
        let imageDataUrls = ["https://images.unsplash.com/photo-1490005564410-32c2ff8ada3b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80", "https://images.unsplash.com/photo-1524502397800-2eeaad7c3fe5?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80", "https://images.unsplash.com/photo-1529911194209-8578109840df?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80", "https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1534&q=80"]
        
        var counter = 0
        
        for imageData in imageDataUrls {
            counter += 1
            if let url = URL(string: imageData) {
                if let data = try? Data(contentsOf: url) {
                    let imageFile = PFFileObject(name: "photo.png", data: data)
                    
                    let user = PFUser()
                    user["photo"] = imageFile
                    user.username = String(counter)
                    user.password = "abc123"
                    user["isFemale"] = true
                    user["isInterestedInWoman"] = false
                    
                    user.signUpInBackground { (success, error) in
                        if success {
                            print("Woman Data Created!")
                        }
                    }
                }
            }
        }
    }
    
    
    
    //MARK: UPLOAD PROFILE IMAGE ACTION BLOCK
    @IBAction func uploadProfileImageAction(_ sender: Any) {
        
        ///Methods for user to select photo from library and upload to the image view.
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    //MARK: UPDATE PROFILE ACTION BLOCK
    @IBAction func updateProfileAction(_ sender: Any) {
        
        ///Methods that save user profile details into the Parse Server.
        PFUser.current()?["isFemale"] = genderSwitch.isOn
        PFUser.current()?["isInterestedInWoman"] = interestedInSwitch.isOn
        
        if let image = profileImage.image {
            if let imageData = image.pngData() {
                PFUser.current()?["photo"] = PFFileObject(name: "photo.png", data: imageData)
                
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    if error != nil {
                        var errorMessage = "Update Faild - Try Again"
                        
                        if let newError = error as NSError? {
                            if let detailError = newError.userInfo["error"] as? String {
                                errorMessage = detailError
                            }
                        }
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = errorMessage
                    }else{
                        print("Update Successful")
                        
                        ////Method that prompt user to swipe view after updated their profile.
                        self.performSegue(withIdentifier: "PromptToSwipeViewSegue", sender: self)
                    }
                })
            }
        }
    }
}
