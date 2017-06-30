//
//  UserView.swift
//  Wow
//
//  Created by Anushka Shivaram on 6/19/17.
//  Copyright © 2017 Anushka Shivaram. All rights reserved.
//

import Foundation
import UIKit
class UserView: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var userErrorMsg: UILabel!
    @IBOutlet weak var logInFailed: UILabel!
    
    @IBOutlet weak var Loginmessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == usernameTF)
        {
            
        }
            
        else if(textField == passwordTF)
        {
            
        }
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func logIn(_ sender: Any) {
        if usernameTF.text?.characters.count == 0 || passwordTF.text?.characters.count == 0 {
            self.logInFailed.isHidden = false
            return
        }
        
        let oldUser: user = user()
        oldUser.username = usernameTF.text!
        oldUser.password = passwordTF.text!
        singleton.sharedInstance.logIn(oldUser) { (getin) in
            if(getin == true) {
                self.navigationController?.popViewController(animated: true)
            }
                
            else {
                self.logInFailed.isHidden = false
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Loginmessage.text = "You are logged in as " + singleton.sharedInstance.saveduser.username
        Loginmessage.isHidden = false
    }
    
    @IBAction func signUp(_ sender: Any) {
        if usernameTF.text?.characters.count == 0 || passwordTF.text?.characters.count == 0 {
            self.logInFailed.isHidden = false
            return
        }
        
        let newUser: user = user()
        newUser.username = usernameTF.text!
        newUser.password = passwordTF.text!
        singleton.sharedInstance.signUp(newUser) { (success) in
            if(success == true)
            {
                self.navigationController?.popViewController(animated: true)
            }
            else
            {
                self.userErrorMsg.isHidden = false
            }
        }
    }
    
    
    
    
    
}
