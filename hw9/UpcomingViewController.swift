//
//  ViewController.swift
//  TableViewDemo
//
//  Created by Daniel Wei on 11/25/18.
//  Copyright © 2018 Daniel Wei. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import SwiftSpinner

var sort_temp:  Int = 0
var order_temp: Int = 0

struct NextIdItem {
    
    var id: String
    
    init(json: JSON) {
        self.id = json["id"].stringValue
    }
}

struct NextItem {
    
    var displayName: String
    var artist: String
    var date: String
    var time: String
    var datetime: String
    var type: String
    var url: String
    
    init(json: JSON) {
        self.displayName = json["displayName"].stringValue
        self.artist = json["performance"][0]["displayName"].stringValue
        self.date = json["start"]["date"].stringValue
        self.time = json["start"]["time"].stringValue
        self.datetime = self.date + " " + self.time
        self.type = json["type"].stringValue
        self.url = json["uri"].stringValue
    }
}

class UpcomingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var scrollView: UIScrollView = {
        
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize.height = 900
        view.backgroundColor = UIColor.white
        
        return view
        
    }()
    
    var tblMain: UITableView!
    var items = [NextItem]()

    let Noresult_Title = UILabel(frame: CGRect(x: screenWidth/2, y: screenHeight/2, width: 150, height: 20))
    
    let Sort_Title = UILabel(frame: CGRect(x: screenWidth/2, y: screenHeight/2, width: 150, height: 20))
    let Order_Title = UILabel(frame: CGRect(x: screenWidth/2, y: screenHeight/2, width: 150, height: 20))
    let Events_Title = UILabel(frame: CGRect(x: screenWidth/2, y: screenHeight/2, width: 150, height: 20))

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
            SwiftSpinner.show("Searching for Upcomging Event").addTapHandler({
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
        progress += (timer.timeInterval/3)
        if progress >= 0.3 {
            progress = 0
            timer.invalidate()
            SwiftSpinner.show(duration: 0.5, title: "Complete!", animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(scrollView)
        setupScrollView()

        setupUIs()
        fetchNext()

        
        // Initialize Sort SegmentedControl
        let items1 = ["Default", "Name", "Time", "Artist", "Type"]
        let customSC1 = UISegmentedControl(items: items1)
        customSC1.selectedSegmentIndex = 0
        customSC1.frame = CGRect(x: 15, y: 100, width: screenWidth-100, height: 30)
        
        // Add target action method
        customSC1.addTarget(self, action: #selector(changeSort), for: .valueChanged)

        // Initialize Order SegmentedControl
        let items2 = ["Ascending", "Descending"]
        let customSC2 = UISegmentedControl(items: items2)
        customSC2.selectedSegmentIndex = 0
        customSC2.frame = CGRect(x: 15, y: 170, width: screenWidth-100, height: 30)
        
        // Add target action method
        customSC2.addTarget(self, action: #selector(changeOrder), for: .valueChanged)

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            self.scrollView.addSubview(self.tblMain)

            self.Sort_Title.text = "Sort By"
            self.Sort_Title.center = CGPoint(x: 90, y: 80)
            self.scrollView.addSubview(self.Sort_Title)
            
            self.Order_Title.text = "Order"
            self.Order_Title.center = CGPoint(x: 90, y: 150)
            self.scrollView.addSubview(self.Order_Title)
            
            self.Events_Title.text = "Events"
            self.Events_Title.center = CGPoint(x: 90, y: 220)
            self.scrollView.addSubview(self.Events_Title)
            
            self.scrollView.addSubview(customSC1)
            self.scrollView.addSubview(customSC2)

            if (self.items.count > 0){
                print("True")
            }
            else{
                print("False")
                self.Noresult_Title.text = "No results"
                self.Noresult_Title.center = CGPoint(x: screenWidth/2, y: screenHeight/2)
                self.Noresult_Title.textAlignment = .center
                self.scrollView.addSubview(self.Noresult_Title)
                
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func changeSort(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            print("Name")
            sort_temp = 1
            switch order_temp{
                case 1:
                    self.items.sort(by: {$0.displayName > $1.displayName})
                default:
                    self.items.sort(by: {$0.displayName < $1.displayName})
            }
        case 2:
            print("Time")
            sort_temp = 2
            switch order_temp{
                case 1:
                    self.items.sort(by: {$0.datetime > $1.datetime})
                default:
                    self.items.sort(by: {$0.datetime < $1.datetime})
            }
        case 3:
            print("Artist")
            sort_temp = 3
            switch order_temp{
            case 1:
                self.items.sort(by: {$0.artist > $1.artist})
            default:
                self.items.sort(by: {$0.artist < $1.artist})
            }
        case 4:
            print("Type")
            sort_temp = 4
            switch order_temp{
                case 1:
                    self.items.sort(by: {$0.type > $1.type})
                default:
                    self.items.sort(by: {$0.type < $1.type})
            }
        default:
            print("Default")
            sort_temp = 0
            switch order_temp{
                case 1:
                    self.items.sort(by: {$0.datetime > $1.datetime})
                default:
                    self.items.sort(by: {$0.datetime < $1.datetime})
            }

        }
        self.tblMain.reloadData()
    }

    @objc func changeOrder(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            print("Decending")
            order_temp = 1
            switch sort_temp {
                case 1:
                    self.items.sort(by: {$0.displayName > $1.displayName})
                case 2:
                    print("Time")
                    self.items.sort(by: {$0.datetime > $1.datetime})
                case 3:
                    print("Artist")
                    self.items.sort(by: {$0.artist > $1.artist})
                case 4:
                    print("Type")
                    self.items.sort(by: {$0.type > $1.type})
                default:
                    print("Default")
                    self.items.sort(by: {$0.datetime > $1.datetime})
            }
        default:
            print("Ascending")
            order_temp = 0
            switch sort_temp {
                case 1:
                    self.items.sort(by: {$0.displayName < $1.displayName})
                case 2:
                    print("Time")
                    self.items.sort(by: {$0.datetime < $1.datetime})
                case 3:
                    print("Artist")
                    self.items.sort(by: {$0.artist < $1.artist})
                case 4:
                    print("Type")
                    self.items.sort(by: {$0.type < $1.type})
                default:
                    print("Default")
                    self.items.sort(by: {$0.datetime < $1.datetime})
            }
            
        }
        self.tblMain.reloadData()
    }

    
    func setupScrollView(){
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
    }

    func setupUIs() {
        tblMain = UITableView(frame: CGRect(x: 15, y: 230, width: screenWidth-50, height: screenHeight))
        tblMain.delegate = self
        tblMain.dataSource = self
        tblMain.register(UpcomingTableViewCell.self, forCellReuseIdentifier: "chenghao")
        tblMain.tableFooterView = UIView()
        tblMain.backgroundColor = UIColor.white
//        scrollView.addSubview(tblMain)
    }
    
    // MARK: - UITableViewDelegate & DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (items.count >= 5){
            return 5
        }
        else{
            return items.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblMain.dequeueReusableCell(withIdentifier: "chenghao", for: indexPath) as! UpcomingTableViewCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        let date_temp = dateFormatter.date(from: items[indexPath.row].date)
        dateFormatter.dateFormat = "MMM d, yyyy"
        let date_string = dateFormatter.string(from: date_temp!)
        
        cell.lblText1.text = items[indexPath.row].displayName
        cell.lblText2.text = items[indexPath.row].artist
        cell.lblText3.text = date_string + " " + items[indexPath.row].time
        cell.lblText4.text = "Type: " + items[indexPath.row].type

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        UIApplication.shared.openURL(NSURL(string: items[indexPath.row].url)! as URL)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    func fetchNext() {
        Network_Next.shared.getData { (status, value) in
            guard status / 100 == 2 else {
                return
            }
            guard let json = value else {
                return
            }
            let itemsJSON = json["event"].arrayValue
            self.items = itemsJSON.map({ NextItem(json: $0) })
            self.tblMain.reloadData()
        }
    }
    
}

