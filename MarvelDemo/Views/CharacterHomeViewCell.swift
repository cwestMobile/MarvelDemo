//
//  CharacterHomeViewCell.swift
//  MarvelDemo
//
//  Created by Casey West on 2/25/20.
//  Copyright © 2020 Casey West. All rights reserved.
//

import UIKit

class CharacterHomeViewCell: UICollectionViewCell {

    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    
    var gradientLayer = CAGradientLayer()

    /**
    - Use didSet to respond to a change in character so when we assign values in controller it is a simple implementation
    */
    var character: Character? {
        didSet {
            setupCharacterInfo()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Create gradient to make sure characterName label is clearly visible regardless of background image
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        gradientLayer.colors = [UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0).cgColor,UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8).cgColor]
        gradientLayer.locations = [0.5,1.0]
        
        // Insert layer at image level so text is on top
        characterImage.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        characterName.text = ""
        characterImage.image = UIImage()
        
    }

    func setupCharacterInfo() {
        
        characterName.text = character?.name ?? ""
        
        var imageUrl = ""
        imageUrl = character?.thumbnail?.path ?? ""
        imageUrl.append(".")
        imageUrl.append(character?.thumbnail?.ext ?? "")
        
        // Use UIImageView extension to set character image based on imageUrl created above
        characterImage.dowloadFromServer(link: imageUrl)
        
    }
    
}

