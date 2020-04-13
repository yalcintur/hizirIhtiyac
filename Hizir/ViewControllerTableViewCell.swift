//
//  ViewControllerTableViewCell.swift
//  Hizir
//
//  Created by Hüseyin Yağız Devre on 12.04.2020.
//  Copyright © 2020 inocom. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var isim: UILabel!
    @IBOutlet weak var tür: UILabel!
    
    @IBOutlet weak var acilGorsel: UIImageView!
    @IBOutlet weak var miktar: UILabel!
    @IBOutlet weak var aciliyet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
