//
//  ViewController.swift
//  TableViewDemo
//
//  Created by Daniel Wei on 11/24/18.
//  Copyright © 2018 Daniel Wei. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import SwiftSpinner

var num: Int = 0
var team_num: Int = 1
var team1_temp3: String = ""
var team2_temp3: String = ""

var team_temp2: String = ""
var venue_temp2: String = ""
var time_temp2: String = ""
var category_temp2: String = ""
var pricerange_temp2: String = ""
var ticketstatus_temp2: String = ""
var buyticket_temp2: String = ""
var seatmap_temp2: String = ""
var title_temp3: String = ""


var lat_temp: Double = 0.00
var lng_temp: Double = 0.00

var fav_items = [DataItem]()
var item_temp = DataItem(json: "")

var fav_index: Int = 0

let NotificationTextField = UILabel(frame: CGRect(x: 15, y: 600, width:250, height: 90))
let NoresultLabel = UILabel(frame: CGRect(x: 15, y: screenWidth/2, width:250, height: 90))

struct Coord {
    var lat: Double
    var lng: Double
    
    init(json: JSON) {
        self.lat = json["geometry"]["location"]["lat"].doubleValue
        self.lng = json["geometry"]["location"]["lng"].doubleValue
    }

}

struct Contact {
    let title: String
    var hasFavorited: Bool
}

struct DataItem {
    
    var title: String
    var thumbnail: String
    var venue: String
    var date: String
    var time: String
    var segment: String
    var team: String
    var genre: String
    var pricerange: String
    var ticketstatus: String
    var buyticket: String
    var seatmap: String
    var team1: String
    var hasFavorite: Bool = false
    
    init(json: JSON) {
        self.title = json["name"].stringValue
        self.thumbnail = json["images"][0]["url"].stringValue
        self.venue = json["_embedded"]["venues"][0]["name"].stringValue
        self.date = json["dates"]["start"]["localDate"].stringValue
        self.time = json["dates"]["start"]["localTime"].stringValue
        self.segment = json["classifications"][0]["segment"]["name"].stringValue
        self.genre = json["classifications"][0]["genre"]["name"].stringValue
        self.team1 = json["_embedded"]["attractions"][0]["name"].stringValue
        
        if (json["priceRanges"].exists()){
            self.pricerange = json["priceRanges"][0]["min"].stringValue + " ~ " + json["priceRanges"][0]["max"].stringValue
        }else{
            self.pricerange = "N/A"
        }
        
        if (segment == "Sports"){
            self.team = json["_embedded"]["attractions"][0]["name"].stringValue + " | " + json["_embedded"]["attractions"][1]["name"].stringValue
        }
        else{
            self.team = json["_embedded"]["attractions"][0]["name"].stringValue
        }
        
        if (json["dates"]["status"]["code"].exists()){
            self.ticketstatus = json["dates"]["status"]["code"].stringValue
        }
        else{
            self.ticketstatus = "N/A"
        }
        
        if (json["url"].exists()){
            self.buyticket = json["url"].stringValue
        }
        else{
            self.buyticket = "N/A"
        }
        
        if (json["seatmap"].exists()){
            self.seatmap = json["seatmap"]["staticUrl"].stringValue
        }
        else{
            self.seatmap = "N/A"
        }
        
    }
}

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tblMain: UITableView!
    var items = [DataItem]()
    var coord_item = [Coord]()

    var progress = 0.0
    
    // Custom Delegation
    func someMethodIWantToCall(cell: SecondTableViewCell){
        
        guard let indexPathTapped = tblMain.indexPath(for: cell) else {return}
        print(indexPathTapped)
        
        let title = items[indexPathTapped.row].title
        print(title)
        
        let hasFav = items[indexPathTapped.row].hasFavorite
        items[indexPathTapped.row].hasFavorite = !hasFav
        
        print(hasFav)
        
        let img_empty = UIImage(named: "favorite-empty")
        let img_filled = UIImage(named: "favorite-filled")
        
        if (hasFav == false){
            fav_items.append(items[indexPathTapped.row])
            cell.starButton.setImage(img_filled, for: .normal)
            NotificationTextField.text = "\(title_temp) was added to favorites"
        }
        else{
            fav_items = fav_items.filter{$0.title != items[indexPathTapped.row].title}
            cell.starButton.setImage(img_empty, for: .normal)
            NotificationTextField.text = "\(title_temp) was removed from favorites"
        }
        
        

        NotificationTextField.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            NotificationTextField.isHidden = true
        }

        print("fav_items")
        print(fav_items)
        
        self.tblMain.reloadData()

    }
    
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
            SwiftSpinner.show("Searching for Events").addTapHandler({
                print("tapped")
                SwiftSpinner.hide()
            }, subtitle: "")
        })
        
        delay(seconds: 0.2) {
            SwiftSpinner.setTitleColor(UIColor.white)
            SwiftSpinner.sharedInstance.innerColor = nil
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.timerFire), userInfo: nil, repeats: true)
        }
    }
    
    @objc func timerFire(_ timer: Timer) {
        progress += (timer.timeInterval)
        if progress >= 1 {
            progress = 0
            timer.invalidate()
            SwiftSpinner.show(duration: 0.2, title: "Complete!", animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Search Results"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

//        items = [DataItem]()
        
        setupUIs()
        fetchData()
        NoresultLabel.isHidden = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            print("test")
            print(self.items.count)
            if (self.items.count == 0){
                NoresultLabel.text = "No results"
                NoresultLabel.textAlignment = .center
                NoresultLabel.center = CGPoint(x: screenWidth/2, y:screenHeight/2)
                NoresultLabel.isHidden = false
                self.view.addSubview(NoresultLabel)
                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                    NoresultLabel.isHidden = true
//                }
                
            }
            else{
                NoresultLabel.isHidden = true
            }
        }

        
        NotificationTextField.backgroundColor = UIColor.gray
        NotificationTextField.textColor = .white
        NotificationTextField.textAlignment = .center
        NotificationTextField.layer.cornerRadius = 5
        NotificationTextField.isHidden = true
        NotificationTextField.center = CGPoint(x: screenWidth/2, y: 700)
        NotificationTextField.numberOfLines = 0
        self.tblMain.addSubview(NotificationTextField)


    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupUIs() {
        tblMain = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        tblMain.delegate = self
        tblMain.dataSource = self
        tblMain.register(SecondTableViewCell.self, forCellReuseIdentifier: "chenghao")
        tblMain.tableFooterView = UIView()
        
        view.addSubview(tblMain)
    }
    
    // MARK: - UITableViewDelegate & DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblMain.dequeueReusableCell(withIdentifier: "chenghao", for: indexPath) as! SecondTableViewCell
        
        cell.link = self 
        cell.accessoryView?.tintColor = items[indexPath.row].hasFavorite ? UIColor.red : .lightGray
        
        cell.lblText1.text = items[indexPath.row].title
        cell.lblText2.text = items[indexPath.row].venue
        cell.lblText3.text = items[indexPath.row].date + " " + items[indexPath.row].time

        
        if (items[indexPath.row].segment == "Sports"){
            cell.imgView.image = UIImage(named: "sports")
        }
        if (items[indexPath.row].segment == "Music"){
            cell.imgView.image = UIImage(named: "music")
        }
        if (items[indexPath.row].segment == "Film"){
            cell.imgView.image = UIImage(named: "film")
        }
        if (items[indexPath.row].segment == "Miscellaneous"){
            cell.imgView.image = UIImage(named: "miscellaneous")
        }
        if (items[indexPath.row].segment == "Arts & Theatre"){
            cell.imgView.image = UIImage(named: "arts")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        team_temp2 = items[indexPath.row].team
        venue_temp2 = items[indexPath.row].venue
        time_temp2 = items[indexPath.row].date + " " + items[indexPath.row].time
        category_temp2 = items[indexPath.row].segment + " | " + items[indexPath.row].genre
        pricerange_temp2 = items[indexPath.row].pricerange
        ticketstatus_temp2 = items[indexPath.row].ticketstatus
        buyticket_temp2 = items[indexPath.row].buyticket
        seatmap_temp2 = items[indexPath.row].seatmap
        title_temp3 = items[indexPath.row].team1
        team1_temp3 = items[indexPath.row].team1
        
        fav_index = indexPath.row
        
        item_temp = items[indexPath.row]
        
        if (items[indexPath.row].segment == "Sports"){
            team_num = 2
        }
        else{
            team_num = 1
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.fetchCoord()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            lat_temp = self.coord_item[0].lat
            lng_temp = self.coord_item[0].lng
            
//            print("result=")
            print(lat_temp)
            print(lng_temp)
        }

        let vc = TabViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }

    
    func fetchData() {
        Network.shared.getData { (status, value) in
            guard status / 100 == 2 else {
                return
            }
            guard let json = value else {
                return
            }
            let itemsJSON = json["events"].arrayValue
            self.items = itemsJSON.map({ DataItem(json: $0) })
            self.tblMain.reloadData()
            //            for item in itemsJSON {
            //                self.items.append(DataItem(json: item))
            //            }
        }
    }
    
    func fetchCoord() {
        Network_Coord.shared.getData { (status, value) in
            guard status / 100 == 2 else {
                return
            }
            guard let json = value else {
                return
            }
            let itemsJSON = json["results"].arrayValue
            self.coord_item = itemsJSON.map({ Coord(json: $0) })

        }
    }

    
}

