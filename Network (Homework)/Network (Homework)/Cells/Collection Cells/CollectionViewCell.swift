//
//  CollectionViewCell.swift
//  Network (Homework)
//
//  Created by Ivan Kuzmenkov on 24.11.22.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    static let id = String(describing: CollectionViewCell.self)

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.container.layer.cornerRadius = 15
        self.container.layer.borderWidth = 1.5
        self.container.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    func setup() {
        container.layer.backgroundColor = self.isSelected ? UIColor.white.cgColor : UIColor.black.cgColor
        label.textColor = self.isSelected ? UIColor.black : UIColor.white
    }
}
