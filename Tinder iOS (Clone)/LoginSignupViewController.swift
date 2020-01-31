//  LoginSignupViewController.swift
//  Tinder iOS (Clone)
//  Created by Jerry Tan on 26/01/2020.
//  Copyright © 2020 Jerry Tan. All rights reserved.


import UIKit
import TextFieldEffects
import Parse

class LoginSignupViewController: UIViewController {
    
    //MARK: TEXT FIELDS PROPERTIES
    @IBOutlet weak var usernameTextField: YoshikoTextField!
    @IBOutlet weak var emailTextField: YoshikoTextField!
    @IBOutlet weak var passwordTextField: YoshikoTextField!
    
    //MARK: BUTTONS PROPERTIES
    @IBOutlet weak var switchSignupLoginButton: UIButton!
    @IBOutlet weak var loginSignupButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    var signupMode = false
    
    
    //MARK: VIEW DID LOAD BLOCK
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.isHidden = true

    }
    
    
    
    //MARK: LOGIN SIGNUP ACTION BLOCK
    @IBAction func loginSignupAction(_ sender: Any) {
        
        ///Signup user methods.
        if signupMode {
            let user = PFUser()
            user.username = usernameTextField.text
            user.email = emailTextField.text
            user.password = passwordTextField.text
            
            user.signUpInBackground { (success, error) in
                if error != nil {
                    var errorMessage = "Signup Faild - Try Again"
                    
                    if let newError = error as NSError? {
                        if let detailError = newError.userInfo["error"] as? String {
                            errorMessage = detailError
                        }
                    }
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = errorMessage
                }else{
                    print("Signup Successful")
                    self.performSegue(withIdentifier: "PopToProfileViewSegue", sender: self)
                }
            }
        }else{
            ///Login user methods.
            if let username = usernameTextField.text {
                if let password = passwordTextField.text {
                    PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
                        if error != nil {
                            var errorMessage = "Login Faild - Try Again"
                            
                            if let newError = error as NSError? {
                                if let detailError = newError.userInfo["error"] as? String {
                                    errorMessage = detailError
                                }
                            }
                            self.errorLabel.isHidden = false
                            self.errorLabel.text = errorMessage
                        }else{
                            print("Login Successful")
                            self.performSegue(withIdentifier: "PopToProfileViewSegue", sender: self)
                        }
                    }
                }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            self.performSegue(withIdentifier: "PopToProfileViewSegue", sender: self)
        }
    }
    
    
    
    
    
    
    //MARK: SWITCH LOGIN SIGNUP ACTION BLOCK
    @IBAction func switchLoginSignupAction(_ sender: Any) {
        
        ///Switch button between login and signup methods.
        if signupMode {
            loginSignupButton.setTitle("Log In", for: .normal)
            switchSignupLoginButton.setTitle("Switch To Sign Up", for: .normal)
            signupMode = false
        }else{
            loginSignupButton.setTitle("Sign Up", for: .normal)
            switchSignupLoginButton.setTitle("Switch To Log In", for: .normal)
            signupMode = true
        }
    }
}
