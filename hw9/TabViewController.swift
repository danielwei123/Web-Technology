//
//  TabViewController.swift
//  TableViewDemo
//
//  Created by Daniel Wei on 11/24/18.
//  Copyright © 2018 Daniel Wei. All rights reserved.
//

import UIKit

class TabViewController: UIViewController {

    var tabBarCnt: UITabBarController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTabBarController()
        // Do any additional setup after loading the view.
        
        let fav_img = UIImage(named: "favorite-empty")!
        let twitter_img = UIImage(named: "twitter")!
        
        let favButton = UIBarButtonItem(image: fav_img,  style: .plain, target: self, action: #selector(favFunc(sender:)))
        let twitterButton = UIBarButtonItem(image: twitter_img,  style: .plain, target: self, action: #selector(twitterFunc(sender:)))

        navigationItem.rightBarButtonItems = [favButton, twitterButton]
        
    }
    
    func createTabBarController() {
        
        tabBarCnt = UITabBarController()
        tabBarCnt.tabBar.barTintColor = UIColor .white
        
        let firstViewController = EventViewController()
        firstViewController.tabBarItem = UITabBarItem.init(title: "Info", image:UIImage(named: "info"), tag: 1)
        
        let secondViewController = ArtistViewController()
        secondViewController.tabBarItem = UITabBarItem.init(title: "Artist", image:UIImage(named: "contacts"), tag: 2)

        let thirdViewController = VenueViewController()
        thirdViewController.tabBarItem = UITabBarItem.init(title: "Venue", image:UIImage(named: "location"), tag: 3)

        let fourthViewController = UpcomingViewController()
        fourthViewController.tabBarItem = UITabBarItem.init(title: "Upcoming", image:UIImage(named: "calendar"), tag: 4)

        tabBarCnt.viewControllers = [firstViewController, secondViewController, thirdViewController, fourthViewController]

        self.view.addSubview(tabBarCnt.view)
    }

    @objc func twitterFunc(sender: UIBarButtonItem){
        let urlStr: String = "https://twitter.com/intent/tweet?text=Check out \(team_temp2) located at \(venue_temp2).\nWebsite:\(buyticket_temp2)".urlEncode()
        if let url = NSURL(string:urlStr) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }

    @objc func favFunc(sender: UIBarButtonItem){
            
            let img_empty = UIImage(named: "favorite-empty")
            let img_filled = UIImage(named: "favorite-filled")
            
//            if (hasFav == false){
                fav_items.append(item_temp)
//                cell.starButton.setImage(img_filled, for: .normal)
                NotificationTextField.text = "\(item_temp.title) was added to favorites"
//            }
//            else{
//                fav_items = fav_items.filter{$0.title != items[indexPathTapped.row].title}
//                cell.starButton.setImage(img_empty, for: .normal)
//                NotificationTextField.text = "\(title_temp) was removed from favorites"
//            }
//
            view.addSubview(NotificationTextField)
            
            NotificationTextField.isHidden = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                NotificationTextField.isHidden = true
            }
            
            print("fav_items")
            print(fav_items)
            
//            self.tblMain.reloadData()
        
//        }
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
