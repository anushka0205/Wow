//
//  FavsTableViewC.swift
//  Wow
//
//  Created by Anushka Shivaram on 6/21/17.
//  Copyright © 2017 Anushka Shivaram. All rights reserved.
//

import Foundation
import UIKit
class FavsTableViewC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var noFavs: UILabel!
    
    @IBOutlet weak var favsTableView: UITableView!
    var arrayOfFavs: Array<FoodEntrySaver> = [FoodEntrySaver]()
    
    @IBAction func repostButton(_ sender: UIButton) {
     let taggo = sender.tag
    singleton.sharedInstance.selectfav = arrayOfFavs[taggo]
    self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func deleteButton(_ sender: UIButton) {
        let taggo = sender.tag
        let delete: FoodEntrySaver = arrayOfFavs[taggo]
        singleton.sharedInstance.DeletefromFav(delete) { (fun) in
            singleton.sharedInstance.loadFavs(lawl: {(Bool) in
                self.favsTableView.isHidden = true
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(favsHaveBeenRead(_:)), name: NSNotification.Name(rawValue: "display"), object: nil)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayOfFavs.count == 0 {
            self.view.bringSubview(toFront: noFavs)
        }
        else {
            self.view.sendSubview(toBack: noFavs)
        }
        return arrayOfFavs.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BasicTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FavsID") as! BasicTableViewCell
        let FESObject:FoodEntrySaver = arrayOfFavs[indexPath.row]
        
        cell.foodTypeLabel.text = FESObject.type
        cell.foodAmntLabel.text = FESObject.amnt
        cell.foodLocationLabel.text = FESObject.loc
        
        cell.repostButton.tag = indexPath.row       
        cell.selectionStyle = UITableViewCellSelectionStyle.none

        
        return cell
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        singleton.sharedInstance.loadFavs(lawl: {(Bool) in
            self.favsTableView.reloadData()
        })
    }
    
    func favsHaveBeenRead(_ notif: Notification) {
        let something: Dictionary <String, Array<FoodEntrySaver>> = notif.userInfo as! Dictionary<String, Array<FoodEntrySaver>>
        arrayOfFavs = something["key"]!
        favsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let delete: FoodEntrySaver = arrayOfFavs[indexPath.row]
            singleton.sharedInstance.DeletefromFav(delete) { (fun) in
                singleton.sharedInstance.loadFavs(lawl: {(Bool) in
                    self.favsTableView.isHidden = true
                })
            }

            //tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
    
}
