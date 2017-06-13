//
//  ViewController.swift
//  Wow
//
//  Created by Anushka Shivaram on 6/13/17.
//  Copyright © 2017 Anushka Shivaram. All rights reserved.
//

import UIKit
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BasicTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Anything") as! BasicTableViewCell
        return cell
    }

}

