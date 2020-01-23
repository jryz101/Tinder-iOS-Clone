//  ViewController.swift
//  Tinder iOS (Clone)
//  Created by Jerry Tan on 23/01/2020.
//  Copyright © 2020 Jerry Tan. All rights reserved.


import UIKit

class SwipeObjectViewController: UIViewController {
    
    //MARK: SWIPE OBJECT UILABEL
    @IBOutlet weak var swipeObject: UILabel!
    
    
    
    //MARK: VIEW DID LOAD BLOCK
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///A concrete subclass of UIGestureRecognizer that looks for panning (dragging) gestures.
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(draggedFunction(gestureRecognizer:)))
            swipeObject.addGestureRecognizer(gesture)
    }
    
    //MARK: DRAGGED FUNCTION BLOCK
    @objc func draggedFunction(gestureRecognizer: UIPanGestureRecognizer) {
        
        ///Methods that make the swipe object rotate.
        let xFromCenter = view.bounds.width / 2 - swipeObject.center.x
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        let scale = min(100 / abs(xFromCenter), 1)
        var scaleAndRotated = rotation.scaledBy(x: scale, y: scale)
        
        swipeObject.transform = scaleAndRotated
        
        
        ///Methods that move the swipe object around.
        let labelPoint = gestureRecognizer.translation(in: view)
        swipeObject.center = CGPoint(x: view.bounds.width / 2 + labelPoint.x, y: view.bounds.height / 2 + labelPoint.y)
        
        ///Methods that detect swipe left for not interested right for interested.
        if gestureRecognizer.state == .ended {
            if swipeObject.center.x < (view.bounds.width / 2 - 100) {
                print("Not Interested")
            }
            if swipeObject.center.x > (view.bounds.width / 2 + 100) {
                print("Interested")
                
                }
            
                ///Methods that reset the swipe object rotation and position back to default position.
                rotation = CGAffineTransform(rotationAngle: 0)
                scaleAndRotated = rotation.scaledBy(x: 1, y: 1)
                swipeObject.transform = scaleAndRotated
                swipeObject.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
            
            }
        }
    }

