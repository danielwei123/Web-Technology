//
//  FirstViewController.swift
//  TableViewDemo
//
//  Created by Daniel Wei on 11/24/18.
//  Copyright © 2018 Daniel Wei. All rights reserved.
//

import UIKit
import AutoCompletion

var name: String = ""
var keyword_temp: String = ""
var distance_temp: String = "10"
var location_temp: String = "University%20of%20southern%20california"

class FirstViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{

    var category_data = ["All","Sports","Music","Arts & Theatre", "Film", "Miscellaneous"]
    var unit_data = ["miles","kms"]

    let keywordLabel = UILabel(frame: CGRect(x: 15, y: 50, width: 150, height: 30))
    let keywordTextField = UITextField(frame: CGRect(x: 15, y: 80, width: 320, height: 30))
//    let keywordTextField = AutoCompletionTextField(frame: CGRect(x: 15, y: 80, width: 320, height: 30))

    let categoryLabel = UILabel(frame: CGRect(x: 15, y: 120, width: 150, height: 30))
    let categoryTextField = UITextField(frame: CGRect(x: 15, y: 180, width: 320, height: 30))
    let distanceLabel = UILabel(frame: CGRect(x: 15, y: 220, width: 150, height: 30))
    let distanceTextField = UITextField(frame: CGRect(x: 15, y: 250, width: 220, height: 30))
    let unitLabel = UILabel(frame: CGRect(x: 15, y: 220, width: 50, height: 30))
    let unitTextField = UITextField(frame: CGRect(x: 15, y: 280, width: 80, height: 30))
    let fromLabel = UILabel(frame: CGRect(x: 15, y: 320, width: 50, height: 30))
    let locationTextField = UITextField(frame: CGRect(x: 15, y: 380, width: 320, height: 30))

    let NotificationTextField = UILabel(frame: CGRect(x: 15, y: 600, width:220, height: 60))

    let radioBtn1 = DLRadioButton(frame: CGRect(x: 15, y: 380, width: 160, height: 30))
    let radioBtn2 = DLRadioButton(frame: CGRect(x: 165, y: 380, width: 160, height: 30))
    var otherButtons: [DLRadioButton] = []
    
    let searchBtn = UIButton(frame: CGRect(x: 15, y: 420, width: 150, height: 30))
    let clearBtn = UIButton(frame: CGRect(x: 15, y: 420, width: 150, height: 30))

//    let items1 = ["SEARCH", "FAVORITES"]
    let customSC1 = UISegmentedControl(items: ["SEARCH", "FAVORITES"])

    // Category Picker
    var picker1 = UIPickerView()
    // Unit Picker
    var picker2 = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Places Search"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        // Do any additional setup after loading the view.

        view.backgroundColor = .white

        customSC1.selectedSegmentIndex = 0
        customSC1.frame = CGRect(x: 30, y: 130, width: screenWidth-100, height: 30)
        
        // Add target action method
        customSC1.addTarget(self, action: #selector(changeSearch), for: .valueChanged)
        view.addSubview(customSC1)
        
        keywordLabel.text = "Keyword"
        keywordLabel.center = CGPoint(x: 110, y: 200)
        view.addSubview(keywordLabel)

        keywordTextField.placeholder = "Enter keyword here"
        keywordTextField.center = CGPoint(x: 190, y: 230)
        keywordTextField.borderStyle = UITextField.BorderStyle.roundedRect
        keywordTextField.autocorrectionType = UITextAutocorrectionType.yes
        view.addSubview(keywordTextField)
        
        categoryLabel.text = "Category"
        categoryLabel.center = CGPoint(x: 110, y: 270)
        view.addSubview(categoryLabel)
        
        categoryTextField.text = "All"
        categoryTextField.center = CGPoint(x: 190, y: 300)
        categoryTextField.borderStyle = UITextField.BorderStyle.roundedRect
        view.addSubview(categoryTextField)

        distanceLabel.text = "Distance"
        distanceLabel.center = CGPoint(x: 110, y: 340)
        view.addSubview(distanceLabel)

        distanceTextField.placeholder = "10"
        distanceTextField.center = CGPoint(x: 140, y: 370)
        distanceTextField.borderStyle = UITextField.BorderStyle.roundedRect
        view.addSubview(distanceTextField)

        unitLabel.text = "Unit"
        unitLabel.center = CGPoint(x: 300, y: 340)
        view.addSubview(unitLabel)

        unitTextField.text = "miles"
        unitTextField.center = CGPoint(x: 310, y: 370)
        unitTextField.borderStyle = UITextField.BorderStyle.roundedRect
        view.addSubview(unitTextField)

        fromLabel.text = "From"
        fromLabel.center = CGPoint(x: 60, y: 410)
        view.addSubview(fromLabel)
        
        radioBtn1.setTitle("Current Location", for: .normal)
        radioBtn1.titleLabel?.font = .systemFont(ofSize: 15)
        radioBtn1.center = CGPoint(x: 100, y: 430)
        radioBtn1.setTitleColor(UIColor.black, for: .normal)
        radioBtn1.tag = 1
        radioBtn1.isSelected = true
        view.addSubview(radioBtn1)

        radioBtn2.setTitle("Custom Location", for: .normal)
        radioBtn2.titleLabel?.font = .systemFont(ofSize: 15)
        radioBtn2.center = CGPoint(x: 270, y: 430)
        radioBtn2.setTitleColor(UIColor.black, for: .normal)
        radioBtn2.tag = 2
        view.addSubview(radioBtn2)

        otherButtons.append(radioBtn2)
        radioBtn1.otherButtons = otherButtons
        radioBtn1.addTarget(self, action: #selector(radioBtns(_:)), for: .touchUpInside)
        radioBtn2.addTarget(self, action: #selector(radioBtns(_:)), for: .touchUpInside)

        locationTextField.placeholder = "Type in the location"
        locationTextField.center = CGPoint(x: 190, y: 470)
        locationTextField.borderStyle = UITextField.BorderStyle.roundedRect
        locationTextField.isEnabled = false
        view.addSubview(locationTextField)
        
        searchBtn.setTitle("Search", for: .normal)
        searchBtn.titleLabel?.font = .systemFont(ofSize: 15)
        searchBtn.center = CGPoint(x: 110, y: 520)
        searchBtn.setTitleColor(UIColor.black, for: .normal)
        searchBtn.backgroundColor = UIColor.lightGray
        view.addSubview(searchBtn)

        clearBtn.setTitle("Clear", for: .normal)
        clearBtn.titleLabel?.font = .systemFont(ofSize: 15)
        clearBtn.center = CGPoint(x: 270, y: 520)
        clearBtn.setTitleColor(UIColor.black, for: .normal)
        clearBtn.backgroundColor = UIColor.lightGray
        view.addSubview(clearBtn)

        // go to second ViewController
        searchBtn.addTarget(self, action: #selector(SearchFunc), for: .touchUpInside)
        clearBtn.addTarget(self, action: #selector(ClearFunc), for: .touchUpInside)
        
        picker1.delegate = self
        picker1.dataSource = self
        categoryTextField.inputView = picker1
        picker2.delegate = self
        picker2.dataSource = self
        unitTextField.inputView = picker2
        
        NotificationTextField.backgroundColor = UIColor.gray
        NotificationTextField.textColor = .white
        NotificationTextField.textAlignment = .center
        NotificationTextField.layer.cornerRadius = 5
        NotificationTextField.isHidden = true
        NotificationTextField.center = CGPoint(x: screenWidth/2, y: 750)
        NotificationTextField.numberOfLines = 0
        view.addSubview(NotificationTextField)
    }
    
    @objc func radioBtns(_ sender: DLRadioButton) {
        print(sender)
        if (sender.tag == 1){
//            print("1")
            locationTextField.isEnabled = false
            locationTextField.text = ""
        }
        else{
//            print("2")
            locationTextField.isEnabled = true
        }
    }

    @objc func changeSearch(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            print("Favorite")
            print("1")
            let vc = FavoriteViewController()
            navigationController?.pushViewController(vc, animated: false)
//            navigationItem.setHidesBackButton(true, animated:false);
//            self.navigationController?.isNavigationBarHidden = true

        default:
            print("Search")
            print("0")
            
        }
//        self.tblMain.reloadData()
    }
    
    @objc func SearchFunc(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
        guard let key = keywordTextField.text, keywordTextField.text?.characters.count != 0 else{
            NotificationTextField.text = "Keyword and location are mandatory fields"
            NotificationTextField.isHidden = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.NotificationTextField.isHidden = true
            }
            return
        }

        if (locationTextField.isEnabled == true){
            guard let loc = locationTextField.text, locationTextField.text?.characters.count != 0 else{
                NotificationTextField.text = "Keyword and location are mandatory fields"
                NotificationTextField.isHidden = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.NotificationTextField.isHidden = true
                }
                return
            }
        }

        
        if (keywordTextField.text != ""){
            //            name = keywordFieldName.text!
            keyword_temp = keywordTextField.text!
        }
        
        if (distanceTextField.text != ""){
            distance_temp = distanceTextField.text!
        }
        
        if (locationTextField.text != ""){
            location_temp = locationTextField.text!
        }
        
        // go to second ViewController
//        let vc = TabViewController()
        let vc = SecondViewController()
        navigationController?.pushViewController(vc, animated: true)
        
        NoresultLabel.isHidden = true
        
    }
    
    @objc func ClearFunc(_ sender: UIButton) {
        keywordTextField.text = ""
        categoryTextField.text = "All"
        distanceTextField.text = ""
        unitTextField.text = "miles"
        locationTextField.text = ""
        location_temp = "University%20of%20southern%20california"
        radioBtn1.isSelected = true
        locationTextField.isEnabled = false
        fav_items = [DataItem]()
        customSC1.selectedSegmentIndex = 0
        NoresultLabel.isHidden = true

    }
    
    // returns the number of 'columns' to display.
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == picker1){
            return category_data.count
        }else{
            return unit_data.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == picker1){
            categoryTextField.text = category_data[row]
            self.view.endEditing(true)
        }
        else{
            unitTextField.text = unit_data[row]
            self.view.endEditing(true)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == picker1){
            return category_data[row]
        }
        else{
            return unit_data[row]
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


