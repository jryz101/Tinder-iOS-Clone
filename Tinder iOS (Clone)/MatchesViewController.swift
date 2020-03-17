//  MatchesViewController.swift
//  Tinder iOS (Clone)
//  Created by Jerry Tan on 05/03/2020.
//  Copyright © 2020 Jerry Tan. All rights reserved.


import UIKit

class MatchesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    ///table view outlet.
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: VIEW DID LOAD SECTION
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///table view delegate and data source.
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    ///table view methods that return rows and cell.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as? ChatTableViewCell {
        cell.messageLabel.text = "You haven't received a message yet"
        return cell
        }
        return ChatTableViewCell()
    }
    
    
    
    
    //MARK: BACK TO SWIPE VIEW SEGUE ACTION
    @IBAction func backToSwipeController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
