//
//  BasicTableViewCell.swift
//  Wow
//
//  Created by Anushka Shivaram on 6/13/17.
//  Copyright © 2017 Anushka Shivaram. All rights reserved.
//

import Foundation
import UIKit
class BasicTableViewCell: UITableViewCell {
    
    @IBOutlet weak var foodTypeLabel: UILabel!
    @IBOutlet weak var foodAmntLabel: UILabel!
    @IBOutlet weak var foodTimeLabel: UILabel!
    @IBOutlet weak var foodLocationLabel: UILabel!
    
    @IBOutlet weak var repostButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var DislikeButton: UIButton!
    @IBOutlet weak var LikeButton: UIButton!
    @IBOutlet weak var DislikeLabel: UILabel!
    @IBOutlet weak var LikeLabel: UILabel!
    
    @IBOutlet weak var gonecountLabel: UILabel!
    @IBOutlet weak var foodGone: UIButton!
}
