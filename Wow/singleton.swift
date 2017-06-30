//
//  singleton.swift
//  Wow
//
//  Created by Anushka Shivaram on 6/14/17.
//  Copyright © 2017 Anushka Shivaram. All rights reserved.
//

import Foundation
import FirebaseDatabase

class singleton: NSObject {
    static let sharedInstance = singleton()
    var FESArray: Array <FoodEntrySaver> = [FoodEntrySaver]()
    //let username123: String = "anushka0205"
    var saveduser: user = user()
    var selectfav: FoodEntrySaver = FoodEntrySaver()
    
    func postFoodEntry() {
        let ref:DatabaseReference = Database.database().reference()
        
        ref.child("FoodEntry").child("Child").setValue(["Any":"Thing"])
    }
    
    
    
    
    
    func FoodinDatabase(_ input:FoodEntrySaver) {
        let ref:DatabaseReference = Database.database().reference()
        let datentime = DateFormatter()
        datentime.dateFormat = " MM-dd-yy_h:mm:ss:SSS_a"
        let uniq: String = saveduser.username + datentime.string(from: input.time)
        
        ref.child("FoodEntry").child(uniq).setValue(["type": input.type, "amnt": input.amnt, "loc": input.loc, "time": datentime.string(from: input.time)])
        
        self.FoodoutDatabase()
        
    }
    
    
    
    
    
    
    func FoodoutDatabase() {
        let ref:DatabaseReference = Database.database().reference()
        
        ref.child("FoodEntry").observeSingleEvent(of: .value, with: { (snapshot) in
            let dictt = snapshot.value as? NSDictionary
            if dictt == nil {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
                return
            }
            self.deleteEntries(dictt!.mutableCopy() as! NSMutableDictionary, leftover: { (dict) in
                var FESArray2: Array <FoodEntrySaver> = [FoodEntrySaver]()
                
                for i in (dict.allKeys) {
                    let dict2 = dict[i] as? NSDictionary
                    
                    let foodEntry: FoodEntrySaver = self.DictReader(dict2!)
                  
                    foodEntry.keyy = i as! String

                    FESArray2.append(foodEntry)
                    
                }
                self.FESArray = self.sort(FESArray2)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
                print("finished!")
                
            })
        })
    }
    
    func DictReader(_ dict2: NSDictionary) -> FoodEntrySaver{
        let foodEntry: FoodEntrySaver = FoodEntrySaver()
        
        for j in (dict2.allKeys) {
            let jString = j as! String
            
            if jString == "amnt"{
                foodEntry.amnt = dict2[jString] as! String
            }
            else if jString == "loc"{
                foodEntry.loc = dict2[jString] as! String
            }
                
            else if jString == "type"{
                foodEntry.type = dict2[jString] as! String
            }
            else if jString == "likez"{
                let temp = dict2[jString] as! NSDictionary
                if self.saveduser.username.characters.count == 0 {
                    foodEntry.hasLiked = false
                    foodEntry.hasDIsliked = false
                }
                else{
                    
                    foodEntry.hasLiked = temp[self.saveduser.username] == nil ? false : true
                }
                foodEntry.likes = temp.allKeys.count
            }
            else if jString == "dislikez"{
                let temp = dict2[jString] as! NSDictionary
                if self.saveduser.username.characters.count == 0 {
                    foodEntry.hasLiked = false
                    foodEntry.hasDIsliked = false
                }
                else{
                    
                    foodEntry.hasDIsliked = temp[self.saveduser.username] == nil ? false : true
                }
                foodEntry.dislikes = temp.allKeys.count
            }
            else if jString == "foodzgone" {
                let temp = dict2[jString] as! NSDictionary
                if self.saveduser.username.characters.count == 0 {
                    foodEntry.fudgon = false
                    
                }
                else{
                    
                    foodEntry.fudgon = temp[self.saveduser.username] == nil ? false : true
                }
                foodEntry.numfudgon = temp.allKeys.count
                
            }
            else if jString == "time"{
                let newdate = dict2[jString] as! String
                let datentime = DateFormatter()
                datentime.dateFormat = "MM-dd-yy_h:mm:ss:SSS_a"
                let date = datentime.date(from: newdate)
                foodEntry.time = date!
            }
            
        }
        
        return foodEntry
    }
    
    
    func UpdateObject(_ number: Int, updated: @escaping (Bool) -> () ){
        var edit = self.FESArray[number]
        let ref:DatabaseReference = Database.database().reference()
        
        ref.child("FoodEntry").child(edit.keyy).observeSingleEvent(of: .value, with: { (snapshot) in
            let dictt = snapshot.value as? NSDictionary
            if dictt == nil {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
                return
            }
            let foodEntry: FoodEntrySaver = self.DictReader(dictt!)
            edit.likes = foodEntry.likes
            edit.dislikes = foodEntry.dislikes
            edit.hasDIsliked = foodEntry.hasDIsliked
            edit.hasLiked = foodEntry.hasLiked
            edit.fudgon = foodEntry.fudgon
            edit.numfudgon = foodEntry.numfudgon
            updated(true)
            
        })
        
        
    }
    
    
    
    
    func UpdateLikes(_ updating: FoodEntrySaver, updated: @escaping (Bool) -> () ){
        let ref:DatabaseReference = Database.database().reference()
        if updating.hasLiked == true {
            ref.child("FoodEntry").child(updating.keyy).child("likez").updateChildValues([saveduser.username : true]) { (nil, DatabaseReference) in
                self.UpdateDislikes(updating, updated: updated)
            }
        }
        else {
            ref.child("FoodEntry").child(updating.keyy).child("likez").child(saveduser.username).removeValue() { (nil, DatabaseReference) in
                self.UpdateDislikes(updating, updated: updated)
            }
        }
        
    }
    
    func UpdateDislikes(_ updating: FoodEntrySaver, updated: @escaping (Bool) -> () ) {
        let ref:DatabaseReference = Database.database().reference()
        if updating.hasDIsliked == true {
            ref.child("FoodEntry").child(updating.keyy).child("dislikez").updateChildValues([saveduser.username : true]) { (nil, DatabaseReference) in
                updated(true)
            }
        }
        else {
            ref.child("FoodEntry").child(updating.keyy).child("dislikez").child(saveduser.username).removeValue() { (nil, DatabaseReference) in
                updated(true)
            }
        }
    }
    
    /*func LikeDislikeValues(_ updating: FoodEntrySaver, updated: @escaping (Bool) -> () ) {
        let ref:DatabaseReference = Database.database().reference()
        
    }*/
    func FoodGone(_ disappeared: FoodEntrySaver, updated: @escaping (Bool) -> ()) {
        let ref:DatabaseReference = Database.database().reference()
        if disappeared.fudgon == true {
            ref.child("FoodEntry").child(disappeared.keyy).child("foodzgone").updateChildValues([saveduser.username : true]) { (nil, DatabaseReference) in
                updated(true)
            }

        }
        else {
            ref.child("FoodEntry").child(disappeared.keyy).child("foodzgone").child(saveduser.username).removeValue() { (nil, DatabaseReference) in
                updated(true)
            }
        }
    }

    
    
    
    
    
    
    func sort(_ array: Array<FoodEntrySaver>) -> Array<FoodEntrySaver> {
        var arraySorted = array
        arraySorted = array.sorted { (FoodEntry1, FoodEntry2) -> Bool in
            if FoodEntry1.time.timeIntervalSince(FoodEntry2.time) > 0{
                return true
            }
            else {
                return false
            }
        }
        return arraySorted
    }
    
    
    
    
    
    
    func deleteEntries(_ deletions: NSMutableDictionary, leftover: @escaping (NSDictionary) -> () ) {
        var deleted = false
        let datentime = DateFormatter()
        datentime.dateFormat = "MM-dd-yy_h:mm:ss:SSS_a"
        for i in (deletions.allKeys) {
            let dict2 = deletions[i] as? NSDictionary
            let newdate = dict2?["time"] as! String
            let date = datentime.date(from: newdate)
            if (date?.timeIntervalSinceNow)! <= (60 * 60 * 24 * -2) {
                deleted = true
                let ref:DatabaseReference = Database.database().reference()
                ref.child("FoodEntry").child(i as! String).removeValue { (nil, ref) in
                    deletions[i] = nil
                    self.deleteEntries(deletions, leftover: leftover)
                }
                break
            }
            
        }
        if deleted == false {
            leftover(deletions)
        }
        
        
    }
    
    
    
    
    
     func SavetoFav(_ thefood: FoodEntrySaver, isInDB: @escaping (Bool) -> ()) {
        let ref:DatabaseReference = Database.database().reference()
        let datentime = DateFormatter()
        datentime.dateFormat = "MM-dd-yy_h:mm:ss:SSS_a"
        let uniq: String = datentime.string(from: thefood.time)
        
        ref.child("SavedEntries").child(saveduser.username).child(uniq).setValue(["type": thefood.type, "amnt": thefood.amnt, "loc": thefood.loc, "time": datentime.string(from: thefood.time)])
    }
    
    
    
    
    
    
    func DeletefromFav(_ nomore: FoodEntrySaver, byeee: @escaping (Bool) -> ()) {
        let ref:DatabaseReference = Database.database().reference()
        let datentime = DateFormatter()
        datentime.dateFormat = "MM-dd-yy_h:mm:ss:SSS_a"
        let uniq: String = datentime.string(from: nomore.time)
        ref.child("SavedEntries").child(saveduser.username).child(uniq).removeValue { (nil, ref) in
            byeee(true)
            
        }
    }
    
    
    
    
    
    
    func loadFavs(lawl: @escaping (Bool) -> ()) {
        let ref:DatabaseReference = Database.database().reference()
        
        ref.child("SavedEntries").child(saveduser.username).observeSingleEvent(of: .value, with: { (snapshot) in
            var FESArray2: Array <FoodEntrySaver> = [FoodEntrySaver]()
            
            let dict = snapshot.value as? NSDictionary
            if dict == nil {
                lawl(false)
                return
            }
            
            for i in (dict?.allKeys)! {
                let dict2 = dict?[i] as? NSDictionary
                
                let foodEntry: FoodEntrySaver = FoodEntrySaver()
                
                for j in (dict2?.allKeys)! {
                    let jString = j as! String
                    
                    if jString == "amnt" {
                        foodEntry.amnt = dict2?[jString] as! String
                    }
                        
                    else if jString == "loc" {
                        foodEntry.loc = dict2?[jString] as! String
                    }
                        
                    else if jString == "type" {
                        foodEntry.type = dict2?[jString] as! String
                    }
                        
                    else if jString == "time" {
                        let newdate = dict2?[jString] as! String
                        let datentime = DateFormatter()
                        datentime.dateFormat = "MM-dd-yy_h:mm:ss:SSS_a"
                        let date = datentime.date(from: newdate)
                        foodEntry.time = date!
                    }
                    
                }
                
                FESArray2.append(foodEntry)
                
            }
            let Favorites = self.sort(FESArray2)
            var userInfoDict: Dictionary <String, Array<FoodEntrySaver>> = [String: Array<FoodEntrySaver>]()
            userInfoDict["key"] = Favorites
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "display"), object: nil, userInfo: userInfoDict)
            print("finished!")
        })
    }
    
    
    
    
    
    func logIn(_ theUser: user, isInDB: @escaping (Bool) -> ()) {
        let ref:DatabaseReference = Database.database().reference()
        ref.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
        let dict = snapshot.value as? NSDictionary
            if dict?[theUser.username] != nil {
                let dict2 =  dict?[theUser.username] as? NSDictionary
                if dict2?["password"] != nil{
                    if((dict2?["password"] as! String) == theUser.password) {
                        self.saveduser = theUser
                        self.saveUser()
                        isInDB(true)
                        return
                    }
                }
            }
           isInDB(false)
            
        })
        
    }
    
    
    
    
    
    func signUp(_ theUser: user, isInDB: @escaping (Bool) -> ()) {
        let ref:DatabaseReference = Database.database().reference()
        ref.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
        let dict = snapshot.value as? NSDictionary
            if dict?[theUser.username] == nil {
                ref.child("Users").child(theUser.username).setValue(["username": theUser.username, "password": theUser.password])
                self.saveduser = theUser
                self.saveUser()
                isInDB(true)
            }
            else {
                
                isInDB(false)
                
            }
            
        })
        
    }
    
    
    
    
    
    func saveUser(){
       UserDefaults.standard.set(self.saveduser.username, forKey: "username")
       UserDefaults.standard.set(self.saveduser.password, forKey: "password")
    }
    
    
    
    
    
    func loadUser(){
        if UserDefaults.standard.value(forKey: "username") != nil && UserDefaults.standard.value(forKey: "password") != nil{
            saveduser.username = UserDefaults.standard.value(forKey: "username") as! String
            saveduser.password = UserDefaults.standard.value(forKey: "password") as! String
        
        }
    
    }
    
    
}
