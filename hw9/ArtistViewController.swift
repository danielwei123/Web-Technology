//
//  ArtistViewController.swift
//  TableViewDemo
//
//  Created by Daniel Wei on 11/25/18.
//  Copyright © 2018 Daniel Wei. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import SwiftSpinner

struct PhotoItem {
    
    var title: String
    var link: String
    
    init(json: JSON) {
        self.title = json["title"].stringValue
        self.link = json["link"].stringValue
    }
}

struct ArtistItem {
    
    var name: String
    var followers: String
    var popularity : String
    var url: String
    
    init(json: JSON) {
        self.name = json["name"].stringValue
        self.followers = json["followers"]["total"].stringValue
        self.popularity = json["popularity"].stringValue
        self.url = json["external_urls"]["spotify"].stringValue
    }
}


class ArtistViewController: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize.height = 2000
        view.backgroundColor = UIColor.white
        
        return view
        
    }()
    
    
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
            SwiftSpinner.show("Fetching Artist Info").addTapHandler({
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
    
    var items = [PhotoItem]()
    var artist_items = [ArtistItem]()
    let cellId = "cellId"
    
    let titleLabel = UILabel(frame: CGRect(x: 15, y: 50, width: screenWidth, height: 30))
    let nameLabel = UILabel(frame: CGRect(x: 15, y: 80, width: 100, height: 20))
    let nameValue = UILabel(frame: CGRect(x: 15, y: 100, width: 150, height: 20))
    let followerLabel = UILabel(frame: CGRect(x: 15, y: 130, width: 100, height: 20))
    let followerValue = UILabel(frame: CGRect(x: 15, y: 150, width: 150, height: 20))
    let popularityLabel = UILabel(frame: CGRect(x: 15, y: 180, width: 100, height: 20))
    let popularityValue = UILabel(frame: CGRect(x: 15, y: 200, width: 150, height: 20))
    let urlLabel = UILabel(frame: CGRect(x: 15, y: 230, width: 100, height: 20))
    let urlValue = UITextView(frame: CGRect(x: 15, y: 250, width: 150, height: 25))
    
    let newCollection: UICollectionView = {
        let layout  = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collection.backgroundColor = UIColor.white
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = true
        return collection
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.addSubview(scrollView)
        setupScrollView()
        
        fetchAritst()
        fetchPhoto()
        
        newCollection.delegate = self
        newCollection.dataSource = self
        newCollection.register(CustomCell.self, forCellWithReuseIdentifier: cellId)
        view.backgroundColor = .white
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            
            self.scrollView.addSubview(self.newCollection)
            self.setupCollection()

            self.titleLabel.text = title_temp3
            self.titleLabel.textAlignment = .center
            self.titleLabel.font = UIFont.systemFont(ofSize: 25)
            self.titleLabel.center = CGPoint(x: screenWidth/2, y: 60)
            
            if (team_num == 1){
                
                print(self.artist_items[0].name)
                print(self.artist_items[0].followers)
                print(self.artist_items[0].popularity)
                
                self.nameLabel.text = "Name"
                self.nameLabel.center = CGPoint(x: 75, y: 110)
                self.nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
                self.newCollection.addSubview(self.nameLabel)
                
                self.nameValue.text = self.artist_items[0].name
                self.nameValue.center = CGPoint(x: 100, y: 130)
                self.nameValue.font = UIFont.systemFont(ofSize: 15)
                self.newCollection.addSubview(self.nameValue)
                
                self.followerLabel.text = "Followers"
                self.followerLabel.center = CGPoint(x: 75, y: 150)
                self.followerLabel.font = UIFont.boldSystemFont(ofSize: 15)
                self.newCollection.addSubview(self.followerLabel)
                
                
                let converted_num = NSNumber(value: Int(self.artist_items[0].followers)!)
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = NumberFormatter.Style.decimal
                
                self.followerValue.text = numberFormatter.string(from: converted_num)
                self.followerValue.center = CGPoint(x: 100, y: 170)
                self.followerValue.font = UIFont.systemFont(ofSize: 15)
                self.newCollection.addSubview(self.followerValue)
                
                self.popularityLabel.text = "Popularity"
                self.popularityLabel.center = CGPoint(x: 75, y: 190)
                self.popularityLabel.font = UIFont.boldSystemFont(ofSize: 15)
                self.newCollection.addSubview(self.popularityLabel)
                
                self.popularityValue.text = self.artist_items[0].popularity
                self.popularityValue.center = CGPoint(x: 100, y: 210)
                self.popularityValue.font = UIFont.systemFont(ofSize: 15)
                self.newCollection.addSubview(self.popularityValue)
                
                self.urlLabel.text = "Check At"
                self.urlLabel.center = CGPoint(x: 75, y: 230)
                self.urlLabel.font = UIFont.boldSystemFont(ofSize: 15)
                self.newCollection.addSubview(self.urlLabel)
                
                self.urlValue.center = CGPoint(x: 100, y: 250)
                self.urlValue.font = UIFont.systemFont(ofSize: 15)
                self.newCollection.addSubview(self.urlValue)
                
                let Seatmap_attributedString = NSMutableAttributedString(string: "Spotify")
                let Seatmap_url = URL(string: self.artist_items[0].url)!
                Seatmap_attributedString.setAttributes([.link: Seatmap_url], range: NSMakeRange(0, 7))
                
                self.urlValue.attributedText = Seatmap_attributedString
                self.urlValue.isUserInteractionEnabled = true
                self.urlValue.isEditable = false
                
                // Set how links should appear: blue and underlined
                self.urlValue.linkTextAttributes = [
                    .foregroundColor: UIColor.blue,
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                    NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 20.0)!
                ]
                
            }
            
            self.newCollection.addSubview(self.titleLabel)
        }
    }
    
    func setupScrollView(){
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
    }
    
    func setupCollection(){
        newCollection.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newCollection.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        newCollection.heightAnchor.constraint(equalToConstant: 800).isActive = true
        newCollection.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
    }
    
    func fetchPhoto() {
        Network_Photo.shared.getData { (status, value) in
            guard status / 100 == 2 else {
                return
            }
            guard let json = value else {
                return
            }
            let itemsJSON = json["items"].arrayValue
            self.items = itemsJSON.map({ PhotoItem(json: $0) })
            self.newCollection.reloadData()
        }
    }
    
    func fetchAritst() {
        Network_Artist.shared.getData { (status, value) in
            guard status / 100 == 2 else {
                return
            }
            guard let json = value else {
                return
            }
            let itemsJSON = json["event"]["artists"]["items"].arrayValue
            self.artist_items = itemsJSON.map({ ArtistItem(json: $0) })
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


extension ArtistViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = newCollection.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCell
        //        cell.backgroundColor = .white
        
        print(indexPath.row)
        
        //        if let url = NSURL(string: "http://verona-api.municipiumstaging.it/system/images/image/image/22/app_1920_1280_4.jpg") {
        if (indexPath.row < 3){
            if let url = NSURL(string: items[indexPath.row].link) {
                if let data = NSData(contentsOf: url as URL) {
                    cell.imageView.image = UIImage(data: data as Data)
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: (screenHeight-200)/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if (team_num == 1){
            return UIEdgeInsets(top: 270, left: 30, bottom: 30, right: 30)
        }
        else {
            return UIEdgeInsets(top: 70, left: 30, bottom: 30, right: 30)
        }
    }
    
}


class CustomCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        
        return image
    }()
    
    func setupView(){
        addSubview(imageView)
        
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: (screenHeight-300)/2).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
