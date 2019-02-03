//
//  SecondTableViewCell.swift
//  hw9_app1
//
//  Created by Daniel Wei on 11/22/18.
//  Copyright © 2018 Daniel Wei. All rights reserved.
//

import UIKit

var title_temp: String = ""

class SecondTableViewCell: UITableViewCell {
    
    var imgView: UIImageView!
    var lblText1: UILabel!
    var lblText2: UILabel!
    var lblText3: UILabel!
    let starButton = UIButton(type: .system)
    
    var link: SecondViewController?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setupCell() {
        imgView = UIImageView(frame: CGRect(x: 15, y: 15, width: 80, height: 70))
        //        imgView.backgroundColor = .red
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 5
        addSubview(imgView)
        
        // Event Name
        lblText1 = UILabel(frame: CGRect(x: 110, y: 5, width: 250, height: 50))
        //        lblText.backgroundColor = .green
        lblText1.numberOfLines = 0
        addSubview(lblText1)
        
        // Venue
        lblText2 = UILabel(frame: CGRect(x: 110, y: 45, width: screenWidth-150, height: 30))
        //                lblText2.backgroundColor = .green
        lblText2.font = UIFont.italicSystemFont(ofSize: 15)
        lblText2.numberOfLines = 0
        addSubview(lblText2)
        
        // Venue
        lblText3 = UILabel(frame: CGRect(x: 110, y: 65, width: screenWidth-150, height: 30))
        lblText3.numberOfLines = 0
        addSubview(lblText3)
        
        
//        let starButton = UIButton(type: .system)
        let img = UIImage(named: "favorite-empty")
        starButton.setImage(img, for: .normal)
        //        starButton.tintColor = .red
                starButton.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
        starButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        accessoryView = starButton
    }
    
    @objc func handleMarkAsFavorite(){
        title_temp = lblText1.text!
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.link?.someMethodIWantToCall(cell: self)
        }
    }
}
