//
//  SecondTableViewCell.swift
//  hw9_app1
//
//  Created by Daniel Wei on 11/22/18.
//  Copyright © 2018 Daniel Wei. All rights reserved.
//

import UIKit

class UpcomingTableViewCell: UITableViewCell {
    
    var lblText1: UILabel!
    var lblText2: UILabel!
    var lblText3: UILabel!
    var lblText4: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setupCell() {
        
        // Event Name
        lblText1 = UILabel(frame: CGRect(x: 10, y: 0, width: screenWidth, height: 50))
        lblText1.numberOfLines = 0
        lblText1.font = UIFont.systemFont(ofSize: 15)
        lblText1.textColor = UIColor.blue
        addSubview(lblText1)
        
        // Venue
        lblText2 = UILabel(frame: CGRect(x: 10, y: 40, width: screenWidth, height: 20))
        lblText2.font = UIFont.italicSystemFont(ofSize: 15)
        lblText2.textColor = UIColor.orange
        lblText2.numberOfLines = 0
        addSubview(lblText2)
        
        // Venue
        lblText3 = UILabel(frame: CGRect(x: 10, y: 65, width: screenWidth, height: 20))
        lblText3.numberOfLines = 0
        lblText3.textColor = UIColor.lightGray
        lblText3.font = UIFont.systemFont(ofSize: 15)
        addSubview(lblText3)
        
        lblText4 = UILabel(frame: CGRect(x: 10, y: 90, width: screenWidth, height: 20))
        lblText4.numberOfLines = 0
        lblText4.font = UIFont.systemFont(ofSize: 15)
        addSubview(lblText4)
        

    }
    
    
}
