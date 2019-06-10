//
//  DetailViewController.swift
//  Sketchpad
//
//  Created by Ricardo Hui on 11/6/2019.
//  Copyright © 2019 Ricardo Hui. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var picture : Picture?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = picture?.name
        if let imageData = picture?.image{
            imageView.image = UIImage(data: imageData)
        }
    }
    
    @IBAction func deletetTapped(_ sender: Any) {
           if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            // delete from CoreData
            if let picToBeDeleted = picture{
                context.delete(picToBeDeleted)
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        if let image = imageView.image {
        
             let shareVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            present(shareVC, animated: true, completion: nil)
        }
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
