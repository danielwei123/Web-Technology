//
//  SecondViewController.swift
//  TableViewDemo
//
//  Created by Daniel Wei on 11/24/18.
//  Copyright © 2018 Daniel Wei. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tblMain: UITableView!
    
    let nofav_Label = UILabel(frame: CGRect(x: screenWidth/2, y: 200, width: 150, height: 30))

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIs()
        self.navigationItem.title = "Places Search"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        // Initialize Sort SegmentedControl
        let items1 = ["SEARCH", "FAVORITES"]
        let customSC1 = UISegmentedControl(items: items1)
        customSC1.selectedSegmentIndex = 1
        customSC1.frame = CGRect(x: 30, y: 130, width: screenWidth-100, height: 30)

        // Add target action method
        customSC1.addTarget(self, action: #selector(changeSearch), for: .valueChanged)
        view.addSubview(customSC1)
        
        if (fav_items.count == 0){
            nofav_Label.text = "No favorites"
            nofav_Label.center = CGPoint(x: screenWidth/2 + 15, y: screenHeight/2)
            view.addSubview(nofav_Label)
        }
    }

    func someMethodIWantToCall(cell: SecondTableViewCell){
        
        guard let indexPathTapped = tblMain.indexPath(for: cell) else {return}
        print(indexPathTapped)
        
        let title = fav_items[indexPathTapped.row].title
        print(title)
        
        let hasFav = fav_items[indexPathTapped.row].hasFavorite
        fav_items[indexPathTapped.row].hasFavorite = !hasFav
        
        self.tblMain.reloadData()

        
    }
    
    @objc func changeSearch(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            print("Search")
        default:
            print("Favorite")
            let vc = FirstViewController()
            navigationController?.pushViewController(vc, animated: false)
        }
    }

    
    @objc func actionBtnTap() {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupUIs() {
        tblMain = UITableView(frame: CGRect(x: 0, y: 160, width: screenWidth, height: screenHeight))
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
        return fav_items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblMain.dequeueReusableCell(withIdentifier: "chenghao", for: indexPath) as! SecondTableViewCell
        
        cell.accessoryView?.tintColor = fav_items[indexPath.row].hasFavorite ? UIColor.red : .lightGray
        
        cell.lblText1.text = fav_items[indexPath.row].title
        cell.lblText2.text = fav_items[indexPath.row].venue
        cell.lblText3.text = fav_items[indexPath.row].date + " " + fav_items[indexPath.row].time
        
        
        if (fav_items[indexPath.row].segment == "Sports"){
            cell.imgView.image = UIImage(named: "sports")
        }
        if (fav_items[indexPath.row].segment == "Music"){
            cell.imgView.image = UIImage(named: "music")
        }
        if (fav_items[indexPath.row].segment == "Film"){
            cell.imgView.image = UIImage(named: "film")
        }
        if (fav_items[indexPath.row].segment == "Miscellaneous"){
            cell.imgView.image = UIImage(named: "miscellaneous")
        }
        if (fav_items[indexPath.row].segment == "Arts & Theatre"){
            cell.imgView.image = UIImage(named: "arts")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = TabViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    /*
      MARK: - Navigation
     
      In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      Get the new view controller using segue.destination.
      Pass the selected object to the new view controller.
     }
     */
    
}
