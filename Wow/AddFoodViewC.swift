//
//  AddFoodViewC.swift
//  Wow
//
//  Created by Anushka Shivaram on 6/13/17.
//  Copyright © 2017 Anushka Shivaram. All rights reserved.
//

import Foundation
import UIKit
class AddFoodViewC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var foodTypeLabel: UILabel!
    @IBOutlet weak var foodTypeTextField: UITextField!
    
    @IBOutlet weak var amntLabel: UILabel!
    @IBOutlet weak var foodNumSlider: UISlider!
    @IBOutlet weak var foodNumLabel: UILabel!
    @IBOutlet weak var foodLocationTextField: UITextField!
    
    @IBOutlet weak var getFavs: UIBarButtonItem!
    var foodEntry: FoodEntrySaver = FoodEntrySaver()
    
    
    
    @IBAction func FavoritesButton(_ sender: UIButton) {
        if foodTypeTextField.text?.characters.count == 0 || foodLocationTextField.text?.characters.count == 0 {
            return
        }
        foodEntry.type = foodTypeTextField.text!
        foodEntry.loc = foodLocationTextField.text!
        foodEntry.time = Date.init()
        singleton.sharedInstance.SavetoFav(foodEntry) { (success) in
        }
    }
    @IBAction func saveButton(_ sender: UIButton) {
        if foodTypeTextField.text?.characters.count == 0 || foodLocationTextField.text?.characters.count == 0 {
            return
        }
        foodEntry.type = foodTypeTextField.text!
        foodEntry.loc = foodLocationTextField.text!
        foodEntry.time = Date.init()
        //singleton.sharedInstance.FESArray.append(foodEntry)
        //singleton.sharedInstance.sort()
        singleton.sharedInstance.FoodinDatabase(foodEntry)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        foodEntry = singleton.sharedInstance.selectfav
        singleton.sharedInstance.selectfav = FoodEntrySaver()
        self.sliderchanging()
    }
    
    func sliderchanging(){
        foodTypeTextField.text = foodEntry.type
        foodLocationTextField.text = foodEntry.loc
        if(foodEntry.amnt == "Small"){
            foodNumSlider.value = 20
            
        }
        else if(foodEntry.amnt == "Medium"){
            foodNumSlider.value = 50
        }
        else{
            foodNumSlider.value = 80
        }
        self.sliderValueDidChange(foodNumSlider)
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    @IBAction func sliderValueDidChange(_ sender: Any) {
        if (sender as? UISlider == self.foodNumSlider) {
            if foodNumSlider.value <= 33 {
                foodNumLabel.text = "Small"
                foodNumLabel.textColor = UIColor.init(colorLiteralRed: 209/255, green: 54/255, blue: 23/255, alpha: 1)
                foodNumLabel.shadowColor = UIColor.clear
            }
            else if foodNumSlider.value >= 67 {
                foodNumLabel.text = "Large"
                foodNumLabel.textColor = UIColor.init(colorLiteralRed: 32/255, green: 130/255, blue: 48/255, alpha: 1)
                foodNumLabel.shadowColor = UIColor.clear
            }
            else {
                foodNumLabel.text = "Medium"
                foodNumLabel.textColor = UIColor.init(colorLiteralRed: 193/255, green: 209/255, blue: 23/255, alpha: 1)
                foodNumLabel.shadowColor = UIColor.black
            }
        }
        
        foodEntry.amnt = foodNumLabel.text!
        
    }
    
    
}
