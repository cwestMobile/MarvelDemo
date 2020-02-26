//
//  CharacterDetailListViewCell.swift
//  MarvelDemo
//
//  Created by Casey West on 2/25/20.
//  Copyright © 2020 Casey West. All rights reserved.
//

import UIKit

class CharacterDetailListViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    /**
    - Although CharacterDetailItem only has one property we handle it the same as Character for consistency and future proofing
    */
    var characterDetail: CharacterDetailItem? {
        didSet {
            setupCharacterDetailInfo()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = ""
    }
    
    func setupCharacterDetailInfo() {
        
        titleLabel.text = characterDetail?.name
    }
}

