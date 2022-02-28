//
//  TableViewCell.swift
//  MyToDoList
//
//  Created by Георгий Матченко on 27.02.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskComment: UILabel!
    @IBOutlet weak var tastColor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
