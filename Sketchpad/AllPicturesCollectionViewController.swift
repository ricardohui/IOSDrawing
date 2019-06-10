//
//  AllPicturesCollectionViewController.swift
//  Sketchpad
//
//  Created by Ricardo Hui on 11/6/2019.
//  Copyright © 2019 Ricardo Hui. All rights reserved.
//

import UIKit


class AllPicturesCollectionViewController: UICollectionViewController {

    
    var pictures : [Picture] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        getPictures()
    }
    
    func getPictures(){
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            if let pictures =  try? context.fetch(Picture.fetchRequest()) as? [Picture]{
//                if let pics = pictures {
                    self.pictures = pictures
                    collectionView?.reloadData()
//                }
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return pictures.count
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let picture = pictures[indexPath.row]
        performSegue(withIdentifier: "viewDetail", sender: picture)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath) as? PictureCell{
            
            let picture = pictures[indexPath.row]
            cell.nameLabel.text = picture.name
            if let imageData  = picture.image{
                cell.imageView.image = UIImage(data: imageData)
            }
            
            
             return cell
        }
        return UICollectionViewCell()
        // Configure the cell
    
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? DetailViewController{
            if let picture = sender as? Picture{
                detailVC.picture = picture
            }
        }
    }

  

}


class PictureCell : UICollectionViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    
}
