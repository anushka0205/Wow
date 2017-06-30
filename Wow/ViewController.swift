//
//  ViewController.swift
//  Wow
//
//  Created by Anushka Shivaram on 6/13/17.
//  Copyright © 2017 Anushka Shivaram. All rights reserved.
//

import UIKit
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var FESTableView: UITableView!
    
    @IBOutlet weak var signInButton: UIBarButtonItem!
    
    @IBOutlet weak var NoEntriesLabel: UILabel!
    
    @IBAction func byebyefood(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let byebyefoodTag = sender.tag
        let FESObject:FoodEntrySaver = singleton.sharedInstance.FESArray[byebyefoodTag]
        FESObject.fudgon = !FESObject.fudgon
        sender.isUserInteractionEnabled = false

        singleton.sharedInstance.FoodGone(FESObject) { (cheese) in
            singleton.sharedInstance.UpdateObject(byebyefoodTag, updated: { (cool) in
                sender.isUserInteractionEnabled = true
                self.FESTableView.reloadRows(at: [IndexPath(row:byebyefoodTag, section:0)], with: UITableViewRowAnimation.automatic)
                
            })
        }
        
        
    }
    
    @IBAction func LikeButtonClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let likeButtonTag = sender.tag
        let FESObject:FoodEntrySaver = singleton.sharedInstance.FESArray[likeButtonTag]
        
        FESObject.hasLiked = !FESObject.hasLiked
        if FESObject.hasLiked == true {
            FESObject.hasDIsliked = false
        }
        sender.isUserInteractionEnabled = false
        singleton.sharedInstance.UpdateLikes(FESObject) { (dogs) in
            singleton.sharedInstance.UpdateObject(likeButtonTag, updated: { (cool) in
                sender.isUserInteractionEnabled = true
                self.FESTableView.reloadRows(at: [IndexPath(row:likeButtonTag, section:0)], with: UITableViewRowAnimation.automatic)
                
            })

         
        }
    
    }
    
    @IBAction func DislikeButtonClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let dislikeButtonTag = sender.tag
        let FESObject:FoodEntrySaver = singleton.sharedInstance.FESArray[dislikeButtonTag]
        
        FESObject.hasDIsliked = !FESObject.hasDIsliked
        if FESObject.hasDIsliked == true {
            FESObject.hasLiked = false
        }
        sender.isUserInteractionEnabled = false
        singleton.sharedInstance.UpdateLikes(FESObject) { (dogs) in
            singleton.sharedInstance.UpdateObject(dislikeButtonTag, updated: { (cool) in
                sender.isUserInteractionEnabled = true
                self.FESTableView.reloadRows(at: [IndexPath(row:dislikeButtonTag, section:0)], with: UITableViewRowAnimation.automatic)
                
            })

        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singleton.sharedInstance.addObserver(self, forKeyPath: "saveduser", options: NSKeyValueObservingOptions.new, context: nil)
        for family:String in UIFont.familyNames
        {
            print("\(family)")
            for names:String in UIFont.fontNames(forFamilyName: family)
            {
                print("==\(names)")
            }
            
        }
        
        NotificationCenter.default.addObserver(self.FESTableView, selector: #selector(UITableView.reloadData), name: NSNotification.Name(rawValue: "refresh"), object: nil)
        self.navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 238/255, green: 247/255, blue: 245/255, alpha: 1)
        
        //singleton.sharedInstance.FoodoutDatabase()
        singleton.sharedInstance.loadUser()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath=="saveduser"
        {
            signInButton.title = singleton.sharedInstance.saveduser.username.characters.count == 0 ? "Sign In": singleton.sharedInstance.saveduser.username
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FESTableView.reloadData()
        singleton.sharedInstance.FoodoutDatabase()
        super.viewWillAppear(animated)
        signInButton.title = singleton.sharedInstance.saveduser.username.characters.count == 0 ? "Sign In": singleton.sharedInstance.saveduser.username

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if singleton.sharedInstance.FESArray.count == 0{
            self.view.bringSubview(toFront: NoEntriesLabel)
        }
        else{
            self.view.sendSubview(toBack: NoEntriesLabel)
        }

        return singleton.sharedInstance.FESArray.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BasicTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Anything") as! BasicTableViewCell
        let FESObject:FoodEntrySaver = singleton.sharedInstance.FESArray[indexPath.row]
        cell.LikeButton.tag = indexPath.row
        cell.foodGone.tag = indexPath.row
        cell.LikeButton.isSelected = FESObject.hasLiked
        cell.DislikeButton.isSelected = FESObject.hasDIsliked
        cell.DislikeButton.tag = indexPath.row
        cell.gonecountLabel.text = FESObject.numfudgon == 0 ? "" : "Reported gone " + String(FESObject.numfudgon) + "x"
    
        cell.DislikeButton.isUserInteractionEnabled = true
        cell.LikeButton.isUserInteractionEnabled = true
        cell.LikeLabel.text = String(FESObject.likes)
        cell.DislikeLabel.text = String(FESObject.dislikes)
        cell.foodTypeLabel.text = "There is a " + FESObject.amnt + " amount of " + FESObject.type + " at " + FESObject.loc
        //cell.foodAmntLabel.text = FESObject.amnt
        //cell.foodLocationLabel.text = FESObject.loc
        cell.foodGone.isUserInteractionEnabled = true
        cell.foodGone.isSelected = FESObject.fudgon
        let datentime = DateFormatter()
        datentime.dateFormat = "MM/dd/yy h:mm a"
        cell.foodTimeLabel.text = "Posted " + datentime.string(from: FESObject.time)
        cell.selectionStyle = UITableViewCellSelectionStyle.none

        return cell
    }

}

