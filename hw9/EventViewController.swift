//
//  SecondViewController.swift
//  TableViewDemo
//
//  Created by Daniel Wei on 11/24/18.
//  Copyright © 2018 Daniel Wei. All rights reserved.
//

import UIKit

var id_temp:String = ""

class EventViewController: UIViewController {
    
    var id_item = NextIdItem(json: "")

    let ArtistTeam_Title = UILabel(frame: CGRect(x: 15, y: 20, width: 150, height: 20))
    let ArtistTeam_Value = UILabel(frame: CGRect(x: 15, y: 40, width: 300, height: 20))

    let Venue_Title = UILabel(frame: CGRect(x: 15, y: 70, width: 150, height: 20))
    let Venue_Value = UILabel(frame: CGRect(x: 15, y: 90, width: 300, height: 20))

    let Time_Title = UILabel(frame: CGRect(x: 15, y: 120, width: 150, height: 20))
    let Time_Value = UILabel(frame: CGRect(x: 15, y: 140, width: 300, height: 20))

    let Category_Title = UILabel(frame: CGRect(x: 15, y: 70, width: 150, height: 20))
    let Category_Value = UILabel(frame: CGRect(x: 15, y: 90, width: 300, height: 20))
    
    let PriceRange_Title = UILabel(frame: CGRect(x: 15, y: 120, width: 150, height: 20))
    let PriceRange_Value = UILabel(frame: CGRect(x: 15, y: 140, width: 300, height: 20))

    let TicketStatus_Title = UILabel(frame: CGRect(x: 15, y: 70, width: 150, height: 20))
    let TicketStatus_Value = UILabel(frame: CGRect(x: 15, y: 90, width: 300, height: 20))
    
    let BuyTicket_Title = UILabel(frame: CGRect(x: 15, y: 120, width: 150, height: 20))
    let BuyTicket_Value = UITextView(frame: CGRect(x: 15, y: 140, width: 300, height: 20))

    let Seatmap_Title = UILabel(frame: CGRect(x: 15, y: 120, width: 150, height: 20))
    let Seatmap_Value = UITextView(frame: CGRect(x: 15, y: 140, width: 300, height: 20))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = ""


        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        ArtistTeam_Title.text = "Artists/Team(s)"
        ArtistTeam_Title.center = CGPoint(x: 100, y: 120)
        ArtistTeam_Title.font = UIFont.boldSystemFont(ofSize: 15)
        view.addSubview(ArtistTeam_Title)
        
        ArtistTeam_Value.center = CGPoint(x: 175, y: 140)
        ArtistTeam_Value.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(ArtistTeam_Value)

        Venue_Title.text = "Venue"
        Venue_Title.center = CGPoint(x: 100, y: 170)
        Venue_Title.font = UIFont.boldSystemFont(ofSize: 15)
        view.addSubview(Venue_Title)
        
        Venue_Value.center = CGPoint(x: 175, y: 190)
        Venue_Value.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(Venue_Value)

        Time_Title.text = "Time"
        Time_Title.center = CGPoint(x: 100, y: 220)
        Time_Title.font = UIFont.boldSystemFont(ofSize: 15)
        view.addSubview(Time_Title)
        
        Time_Value.center = CGPoint(x: 175, y: 240)
        Time_Value.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(Time_Value)
        
        Category_Title.text = "Category"
        Category_Title.center = CGPoint(x: 100, y: 270)
        Category_Title.font = UIFont.boldSystemFont(ofSize: 15)
        view.addSubview(Category_Title)
        
        Category_Value.center = CGPoint(x: 175, y: 290)
        Category_Value.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(Category_Value)
        
        PriceRange_Title.text = "Price Range"
        PriceRange_Title.center = CGPoint(x: 100, y: 320)
        PriceRange_Title.font = UIFont.boldSystemFont(ofSize: 15)
        view.addSubview(PriceRange_Title)
        
        PriceRange_Value.center = CGPoint(x: 175, y: 340)
        PriceRange_Value.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(PriceRange_Value)
        
        TicketStatus_Title.text = "Ticket Status"
        TicketStatus_Title.center = CGPoint(x: 100, y: 370)
        TicketStatus_Title.font = UIFont.boldSystemFont(ofSize: 15)
        view.addSubview(TicketStatus_Title)
        
        TicketStatus_Value.center = CGPoint(x: 175, y: 390)
        TicketStatus_Value.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(TicketStatus_Value)
        
        BuyTicket_Title.text = "Buy Tickets At"
        BuyTicket_Title.center = CGPoint(x: 100, y: 420)
        BuyTicket_Title.font = UIFont.boldSystemFont(ofSize: 15)
        view.addSubview(BuyTicket_Title)
        
        BuyTicket_Value.center = CGPoint(x: 175, y: 440)
        BuyTicket_Value.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(BuyTicket_Value)

        let BuyTicket_attributedString = NSMutableAttributedString(string: "Ticketmaster")
        let BuyTicket_url = URL(string: buyticket_temp2)!
        
        // Set the 'click here' substring to be the link
        BuyTicket_attributedString.setAttributes([.link: BuyTicket_url], range: NSMakeRange(0, 12))
        
        BuyTicket_Value.attributedText = BuyTicket_attributedString
        BuyTicket_Value.isUserInteractionEnabled = true
        BuyTicket_Value.isEditable = false
        
        // Set how links should appear: blue and underlined
        BuyTicket_Value.linkTextAttributes = [
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]

        Seatmap_Title.text = "Seatmap"
        Seatmap_Title.center = CGPoint(x: 100, y: 470)
        Seatmap_Title.font = UIFont.boldSystemFont(ofSize: 15)
        view.addSubview(Seatmap_Title)
        
        Seatmap_Value.center = CGPoint(x: 175, y: 490)
        Seatmap_Value.font = .systemFont(ofSize: 30)
        view.addSubview(Seatmap_Value)

        let Seatmap_attributedString = NSMutableAttributedString(string: "View Here")
        let Seatmap_url = URL(string: seatmap_temp2)!
        
        // Set the 'click here' substring to be the link
        Seatmap_attributedString.setAttributes([.link: Seatmap_url], range: NSMakeRange(0, 9))
        
        Seatmap_Value.attributedText = Seatmap_attributedString
        Seatmap_Value.isUserInteractionEnabled = true
        Seatmap_Value.isEditable = false
        
        // Set how links should appear: blue and underlined
        Seatmap_Value.linkTextAttributes = [
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 30.0)!
        ]


        
        ArtistTeam_Value.text = team_temp2
        Venue_Value.text = venue_temp2
        Time_Value.text = time_temp2
        Category_Value.text = category_temp2
        PriceRange_Value.text = pricerange_temp2
        TicketStatus_Value.text = ticketstatus_temp2
        
        fetchId()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            id_temp = self.id_item.id
        }


    }
    
    @objc func actionBtnTap() {
        dismiss(animated: true, completion: nil)
    }
    
    func fetchId() {
        Network_id.shared.getData { (status, value) in
            guard status / 100 == 2 else {
                return
            }
            guard let json = value else {
                return
            }
            self.id_item = NextIdItem(json: json)
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
