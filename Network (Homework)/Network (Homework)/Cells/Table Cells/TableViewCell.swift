//
//  TableViewCell.swift
//  Network (Homework)
//
//  Created by Ivan Kuzmenkov on 27.11.22.
//

import UIKit

class TableViewCell: UITableViewCell {
    static let id = String(describing: TableViewCell.self)

    @IBOutlet weak var labelOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
