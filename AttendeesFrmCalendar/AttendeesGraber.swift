//
//  AttendeesGraber.swift
//  AttendeesFromCalendar
//
//  Created by Pankti Patel on 29/06/15.
//  Copyright (c) 2015 Pankti Patel. All rights reserved.
//

import Foundation
import EventKit

enum TimeUnit: Int {
    case Second = 1
    case Minute = 60
    case Hour = 3600
    case Day = 86400
    case Week = 604800
    case Month = 2629740
    case Year = 31556900
}


class AttandeesGraber {
    
    var attandeeEmail = Array<AnyObject>()
    var eventStore = EKEventStore()
    
    init(){
        
        eventStore.requestAccessToEntityType(EKEntityTypeEvent,
            completion: {(granted: Bool, error:NSError!) in
                if !granted {
                    println("Access to store not granted")
                }
        })
        
    }
    
    func fetchAttendeesFromCalendar(#fromNoOfDaysAgo:NSTimeInterval){
        
        //Perform read task in background
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { // 1
            
            // Create a predicate value with start date a year before and end date a year after the current date.
            let yearSeconds = fromNoOfDaysAgo * Double(TimeUnit.Day.rawValue) as NSTimeInterval;
            let predicate = self.eventStore.predicateForEventsWithStartDate(NSDate().dateByAddingTimeInterval(-yearSeconds), endDate: NSDate(), calendars: nil)
            
            // Get an array with all events.
            var events = self.eventStore.eventsMatchingPredicate(predicate)
            
            // iterate eventsArray to fetch attendees from EKParticipant
            if let eventsArray = events {
                
                for index:Int in 0..<eventsArray.count{
                    
                    var currentEvent:EKEvent = eventsArray[index] as! EKEvent
                    if let arrParticipants = currentEvent.attendees{
                        for participant in arrParticipants as! [EKParticipant]{
                            
                            var dicFromstring : Dictionary = self.returnDictionaryFromString(description: participant.description)
                            let email:String = dicFromstring["email"]!
                            self.attandeeEmail.insert(email, atIndex: 0)
                        }
                        
                    }
                }
                
            }
        });
        
    }
    
    func returnDictionaryFromString (#description:String) -> Dictionary<String,String>{
        
        var descriptionData = Dictionary<String,String>()
        for pairString in description.componentsSeparatedByString(";") as [String]{
            if !pairString.isEmpty{
                let pair  = pairString.componentsSeparatedByString("=") as Array
                if pair.count != 2{
                    continue
                }
                descriptionData[pair[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())] = pair[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            }
            
        }
        return descriptionData
        
    }
    
    
}
