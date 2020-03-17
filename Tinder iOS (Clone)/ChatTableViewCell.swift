//  ChatTableViewCell.swift
//  Tinder iOS (Clone)
//  Created by Jerry Tan on 17/03/2020.
//  Copyright © 2020 Jerry Tan. All rights reserved.


import UIKit
import Parse

class ChatTableViewCell: UITableViewCell {
    
    
    var recipientObjectId = ""
    
    ///properties outlet
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    //MARK: SEND BUTTON ACITON
    @IBAction func sendButton(_ sender: Any) {
        ///Methods that use to send message.
        let message = PFObject(className: "Message")
        
        message["sender"] = PFUser.current()?.objectId
        message["recipient"] = recipientObjectId
        message["content"] = messageTextField.text
        
        message.saveInBackground()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
