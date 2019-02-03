//
//  SecondViewController.swift
//  TableViewDemo
//
//  Created by Daniel Wei on 11/24/18.
//  Copyright © 2018 Daniel Wei. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import GoogleMaps
import SwiftSpinner

struct VenueItem {
    
    var address: String
    var city: String
    var phone: String
    var openHours: String
    var generalRule: String
    var childRule: String
    
    init(json: JSON) {
        self.address = json["address"].stringValue
        self.city = json["city"].stringValue
        self.phone = json["phone"].stringValue
        self.openHours = json["openHours"].stringValue
        self.generalRule = json["generalRule"].stringValue
        self.childRule = json["childRule"].stringValue
    }
}

class VenueViewController: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize.height = 1100
        view.backgroundColor = UIColor.white
        
        return view
        
    }()

    var miniview: GMSMapView?
    
    var progress = 0.0
    
    func delay(seconds: Double, completion: @escaping () -> ()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.demoSpinner()
    }
    
    func demoSpinner() {
        
        delay(seconds: 0.1, completion: {
            SwiftSpinner.show("Searching for Venue").addTapHandler({
                print("tapped")
                SwiftSpinner.hide()
            }, subtitle: "")
        })
        
        delay(seconds: 0.5) {
            SwiftSpinner.setTitleColor(UIColor.white)
            SwiftSpinner.sharedInstance.innerColor = nil
            Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.timerFire), userInfo: nil, repeats: true)
        }
    }
    
    @objc func timerFire(_ timer: Timer) {
        progress += (timer.timeInterval/2)
        if progress >= 1 {
            progress = 0
            timer.invalidate()
            SwiftSpinner.show(duration: 0.3, title: "Complete!", animated: false)
        }
    }
    var item = VenueItem(json: "")
    
    let Address_Title = UILabel(frame: CGRect(x: 15, y: 20, width: 150, height: 20))
    let Address_Value = UILabel(frame: CGRect(x: 15, y: 40, width: screenWidth-50, height: 20))
    
    let City_Title = UILabel(frame: CGRect(x: 15, y: 70, width: 150, height: 20))
    let City_Value = UILabel(frame: CGRect(x: 15, y: 90, width: screenWidth-50, height: 20))
    
    let Phone_Title = UILabel(frame: CGRect(x: 15, y: 120, width: 150, height: 20))
    let Phone_Value = UILabel(frame: CGRect(x: 15, y: 140, width: screenWidth-50, height: 20))
    
    let Hour_Title = UILabel(frame: CGRect(x: 15, y: 160, width: 150, height: 20))
    let Hour_Value = UILabel(frame: CGRect(x: 15, y: 180, width: screenWidth-50, height: 200))
    
    let GeneralRules_Title = UILabel(frame: CGRect(x: 15, y: 380, width: 150, height: 20))
    let GeneralRules_Value = UILabel(frame: CGRect(x: 15, y: 400, width: screenWidth-50, height: 100))
    
    let ChildRules_Title = UILabel(frame: CGRect(x: 15, y: 470, width: 150, height: 20))
    let ChildRules_Value = UILabel(frame: CGRect(x: 15, y: 490, width: screenWidth-50, height: 160))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        setupScrollView()
        
        fetchVenue()
        
        self.navigationItem.title = ""
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {

            self.Address_Title.text = "Address"
            self.Address_Title.center = CGPoint(x: 100, y: 120)
            self.Address_Title.font = UIFont.boldSystemFont(ofSize: 15)
            self.scrollView.addSubview(self.Address_Title)

            self.Address_Value.center = CGPoint(x: screenWidth/2, y: 140)
            self.Address_Value.font = UIFont.systemFont(ofSize: 15)
            self.scrollView.addSubview(self.Address_Value)
            self.Address_Value.text = self.item.address

            self.City_Title.text = "City"
            self.City_Title.center = CGPoint(x: 100, y: 170)
            self.City_Title.font = UIFont.boldSystemFont(ofSize: 15)
            self.scrollView.addSubview(self.City_Title)

            self.City_Value.center = CGPoint(x: screenWidth/2, y: 190)
            self.City_Value.font = UIFont.systemFont(ofSize: 15)
            self.scrollView.addSubview(self.City_Value)
            self.City_Value.text = self.item.city

            self.Phone_Title.text = "Phone Number"
            self.Phone_Title.center = CGPoint(x: 100, y: 220)
            self.Phone_Title.font = UIFont.boldSystemFont(ofSize: 15)
            self.scrollView.addSubview(self.Phone_Title)

            self.Phone_Value.center = CGPoint(x: screenWidth/2, y: 240)
            self.Phone_Value.font = UIFont.systemFont(ofSize: 15)
            self.scrollView.addSubview(self.Phone_Value)
            self.Phone_Value.text = self.item.phone

            self.Hour_Title.text = "Open Hours"
            self.Hour_Title.center = CGPoint(x: 100, y: 270)
            self.Hour_Title.font = UIFont.boldSystemFont(ofSize: 15)
            self.scrollView.addSubview(self.Hour_Title)

            self.Hour_Value.center = CGPoint(x: screenWidth/2, y: 360)
            self.Hour_Value.font = UIFont.systemFont(ofSize: 15)
            self.Hour_Value.numberOfLines = 0
            self.Hour_Value.text = self.item.openHours
            self.scrollView.addSubview(self.Hour_Value)

            self.GeneralRules_Title.text = "General Rules"
            self.GeneralRules_Title.center = CGPoint(x: 100, y: 460)
            self.GeneralRules_Title.font = UIFont.boldSystemFont(ofSize: 15)
            self.scrollView.addSubview(self.GeneralRules_Title)

            self.GeneralRules_Value.center = CGPoint(x: screenWidth/2, y: 510)
            self.GeneralRules_Value.font = UIFont.systemFont(ofSize: 15)
            self.GeneralRules_Value.numberOfLines = 0
            self.GeneralRules_Value.text = self.item.generalRule
            self.scrollView.addSubview(self.GeneralRules_Value)

            self.ChildRules_Title.text = "Child Rules"
            self.ChildRules_Title.center = CGPoint(x: 100, y: 570)
            self.ChildRules_Title.font = UIFont.boldSystemFont(ofSize: 15)
            self.scrollView.addSubview(self.ChildRules_Title)

            self.ChildRules_Value.center = CGPoint(x: screenWidth/2, y: 640)
            self.ChildRules_Value.font = UIFont.systemFont(ofSize: 15)
            self.ChildRules_Value.numberOfLines = 0
            self.ChildRules_Value.text = self.item.childRule
            self.scrollView.addSubview(self.ChildRules_Value)

            let camera = GMSCameraPosition.camera(withLatitude: lat_temp, longitude: lng_temp, zoom: 14.0)

            self.miniview = GMSMapView.map(withFrame: CGRect(x: 100, y: 100, width: screenWidth-50, height: 300), camera: camera)
            self.miniview?.center = CGPoint(x:screenWidth/2, y: 900)
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lat_temp, longitude: lng_temp)
            marker.title = "\(venue_temp2)"
            marker.map = self.miniview
            
            self.scrollView.addSubview(self.miniview!)


        }
        
    }
    
    func setupScrollView(){
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
    }

    func fetchVenue() {
        Network_Venue.shared.getData { (status, value) in
            guard status / 100 == 2 else {
                return
            }
            guard let json = value else {
                return
            }
            self.item =  VenueItem(json: json)
//            self.items = itemsJSON.map({ VenueItem(json: $0) })
//            self.newCollection.reloadData()
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
