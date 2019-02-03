//
//  Network.swift
//  hw9_app1
//
//  Created by Daniel Wei on 11/22/18.
//  Copyright © 2018 Daniel Wei. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Network_Venue {
    
    static let shared = Network_Venue()
    
    func getData(completion: @escaping (Int, JSON?)->()) {
        
        // async!!!
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            guard let url = URL(string: "http://571hw8-chenghaw.us-east-2.elasticbeanstalk.com/venue?venue=\(venue_temp2.urlEncode())")
                else {
                    return
            }
            
            print(url)
            
            Alamofire.request(url).responseJSON { (response) in
                guard let statusCode = response.response?.statusCode else {
                    completion(500, nil)
                    return
                }
                guard let value = response.result.value else {
                    completion(statusCode, nil)
                    return
                }
                completion(statusCode, JSON(value))
            }
        }
        
    }
    
}

class Network_Coord {
    
    static let shared = Network_Coord()
    
    func getData(completion: @escaping (Int, JSON?)->()) {
        
        // async!!!
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            guard let url = URL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=\(venue_temp2.urlEncode())&key=%20AIzaSyC96cBV4maiHK6-gkbR8R4NWODY3-W4c1U")
                else {
                    return
            }
            
            print(url)
            
            Alamofire.request(url).responseJSON { (response) in
                guard let statusCode = response.response?.statusCode else {
                    completion(500, nil)
                    return
                }
                guard let value = response.result.value else {
                    completion(statusCode, nil)
                    return
                }
                completion(statusCode, JSON(value))
            }
        }
        
    }
    
}
