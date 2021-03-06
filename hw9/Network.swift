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

class Network {
    
    static let shared = Network()
    
    func getData(completion: @escaping (Int, JSON?)->()) {
        
        // async!!!
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            guard let url = URL(string: "http://571hw8-chenghaw.us-east-2.elasticbeanstalk.com/process_get?keyword=\(keyword_temp.urlEncode())&distance=\(distance_temp)&location=\(location_temp.urlEncode())")
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
