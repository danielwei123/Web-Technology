//
//  GlobalVariables.swift
//  hw9_app1
//
//  Created by Daniel Wei on 11/22/18.
//  Copyright © 2018 Daniel Wei. All rights reserved.
//

import UIKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

extension String {
    
    func urlEncode() -> String {
        let urlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return urlString ?? ""
    }
    
    func urlDecode() -> String {
        return self.removingPercentEncoding ?? ""
    }
}
