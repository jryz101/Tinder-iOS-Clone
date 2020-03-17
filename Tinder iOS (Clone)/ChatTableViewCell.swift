//  ChatTableViewCell.swift
//  Tinder iOS (Clone)
//  Created by Jerry Tan on 17/03/2020.
//  Copyright © 2020 Jerry Tan. All rights reserved.


import UIKit

class ChatTableViewCell: UITableViewCell {

    ///properties outlet
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    //MARK: SEND BUTTON ACITON
    @IBAction func sendButton(_ sender: Any) {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
