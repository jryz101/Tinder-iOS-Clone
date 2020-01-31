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
                    }
                })
            }
        }
    }
}
