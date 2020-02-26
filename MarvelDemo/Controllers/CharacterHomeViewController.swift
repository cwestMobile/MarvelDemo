//
//  CharacterHomeViewController.swift
//  MarvelDemo
//
//  Created by Casey West on 2/25/20.
//  Copyright © 2020 Casey West. All rights reserved.
//

import UIKit

/**
 - Spacing and number of items used for collectionView layout
 */
private let sectionInsets = UIEdgeInsets(top: 14.0, left: 14.0, bottom: 14.0, right: 14.0)
private var itemsPerRow: CGFloat = 2
private let reuseIdentifier = "characterHomeViewCell"

class CharacterHomeViewController: UICollectionViewController {

    let refreshControl = UIRefreshControl()
    
    var characterList = [Character]()
    var isLoading: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Marvel Characters"

        // Register cell classes
        self.collectionView.register(UINib(nibName:"CharacterHomeViewCell", bundle: nil), forCellWithReuseIdentifier:reuseIdentifier)
        
        setupRefreshControl()
        loadCharacterList(offset: 0)
    }
    
    func setupRefreshControl() {
        
        refreshControl.tintColor = .lightGray
        refreshControl.addTarget(self, action: #selector(refreshCharacterList), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
    }
    
    @objc func refreshCharacterList() {
        self.characterList.removeAll()
        loadCharacterList(offset: 0)
    }
    
    /**
     - Perform API call to load more characters
     - parameters:
        - offset: Starting position of API call
     */
    func loadCharacterList(offset: Int) {

        MarvelApiService.sharedInstance.getMarvelCharacters(offset: offset) { [weak self] (result) in
            switch result {
                
            case .success(let characters):
                characters.forEach({ (character) in
                    self?.characterList.append(character)
                })
                self?.isLoading = false
                break
            case .failure(let error):
                //TODO: Handle errors gracefully
                print(error.localizedDescription)
                self?.isLoading = false
                break
            }
            
            /**
             - Dispatch UI updates to the main thread
             */
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                self?.collectionView.reloadData()
            }
        }
    }
    
    // MARK: UICollectionView Datasource & Delegate
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return characterList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CharacterHomeViewCell
    
        if (characterList.count > indexPath.row) {
            cell.character = characterList[indexPath.row]
        }
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailController = CharacterDetailViewController()
        detailController.character = characterList[indexPath.row]
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == characterList.count - 1 ) {
            if (!isLoading) {
                isLoading = true
                //If reached bottom of collectionView load more characters with current offset which is characterList.count + 1
                loadCharacterList(offset: characterList.count + 1)
            }
        }
    }
    
}

extension CharacterHomeViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem + 28)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
}

