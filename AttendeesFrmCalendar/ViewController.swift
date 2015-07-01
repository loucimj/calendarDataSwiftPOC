//
//  ViewController.swift
//  AttendeesFromCalendar
//
//  Created by Pankti Patel on 29/06/15.
//  Copyright (c) 2015 Pankti Patel. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myClassObject = AttandeesGraber()
        myClassObject.fetchAttendeesFromCalendar(fromNoOfDaysAgo: 15)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
        
            print(myClassObject.attandeeEmail)
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}



