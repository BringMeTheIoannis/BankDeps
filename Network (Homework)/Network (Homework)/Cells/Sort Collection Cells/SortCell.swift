//
//  SortCell.swift
//  Network (Homework)
//
//  Created by Ivan Kuzmenkov on 26.11.22.
//

import UIKit

class SortCell: UICollectionViewCell {
    static let id = String(describing: SortCell.self)

    @IBOutlet weak var labelOutlet: UILabel!
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius = 15
        self.containerView.layer.borderWidth = 1.5
        self.containerView.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    func setup() {
        containerView.layer.backgroundColor = self.isSelected ? UIColor.white.cgColor : UIColor.black.cgColor
        labelOutlet.textColor = self.isSelected ? UIColor.black : UIColor.white
    }
}
