//
//  CharacterDetailViewController.swift
//  MarvelDemo
//
//  Created by Casey West on 2/25/20.
//  Copyright © 2020 Casey West. All rights reserved.
//

import UIKit

class CharacterDetailViewController: UITableViewController {
    
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterDescription: UITextView!
    
    var character: Character?
    
    var sections = [GroupedCategory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 30
        tableView.register(UINib(nibName: "CharacterDetailListViewCell", bundle: nil), forCellReuseIdentifier: "characterDetailListViewCell")
        
        setupCharacterImage()
        setupCharacterInfo()
    }
    
    func setupCharacterImage() {
        characterImageView.layer.cornerRadius = 64
        characterImageView.layer.borderWidth = 2
        characterImageView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setupCharacterInfo() {
        if let character = character {
            self.title = character.name
            
            if character.description == "" {
                characterDescription.text = "No available description"
            } else {
                characterDescription.text = character.description
            }
            
            var imageUrl = ""
            imageUrl = character.thumbnail?.path ?? ""
            imageUrl.append(".")
            imageUrl.append(character.thumbnail?.ext ?? "")
            
            characterImageView.dowloadFromServer(link: imageUrl)
            
            let comics = character.comics?.items ?? [CharacterDetailItem]()
            let stories = character.stories?.items ?? [CharacterDetailItem]()
            let events = character.events?.items ?? [CharacterDetailItem]()
            let series = character.series?.items ?? [CharacterDetailItem]()

            sections = [GroupedCategory(name:"Comics", items:comics),
                        GroupedCategory(name:"Stories", items:stories),
                        GroupedCategory(name:"Events", items:events),
                        GroupedCategory(name:"Series", items:series)]
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].name
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].items.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterDetailListViewCell", for: indexPath) as! CharacterDetailListViewCell
        
        let items = self.sections[indexPath.section].items
        cell.characterDetail = items[indexPath.row]

        return cell
        
    }
    
}
