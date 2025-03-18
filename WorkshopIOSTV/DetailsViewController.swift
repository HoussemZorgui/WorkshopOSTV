//
//  DetailsViewController.swift
//  WorkshopIOSTV
//
//  Created by Khaled Guedria on 10/18/20.
//  Copyright © 2020 Khaled Guedria. All rights reserved.
//

import UIKit
import CoreData


class DetailsViewController: UIViewController {
    
    //var
    var movieName:String?
    var movieImage:String?
    
    
    
    
    //Widgets
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    
    
    
    
    //Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //OnStart
        movieImageView.load(urlString: movieImage!)
        movieNameLabel.text = movieName!

}
    
    
    
    //IBActions

    
    @IBAction func saveAction(_ sender: Any) {
        if !fetchOneByCriteria(movie: movieName!) {
            insertMovie()
        }
        else{
            prompt(title: "Warning", message: "Movie Already Exists!")
        }
    }
    

    
    //FUNCTIONS
    func insertMovie() {
        
        //1
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //2
        let persistentContainer = appDelegate.persistentContainer
        //3
        let managedContext = persistentContainer.viewContext
        
        //4
        let entityDescription = NSEntityDescription.entity(forEntityName: "Movie", in: managedContext)
        
        
        let obj = NSManagedObject(entity: entityDescription!, insertInto: managedContext)
        obj.setValue(movieName, forKey: "moviename")
        
        do {
            try managedContext.save()
            prompt(title: "Success", message: "Movie added successfully !")
            
        } catch  {
            print("INSERT ERROR")
        }
        
        
    }
    
    func prompt(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Got it", style: .default, handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
   
    
    //fetchOne
    func fetchOneByCriteria(movie: String) -> Bool {

        var isExists: Bool = false
        
        //1
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //2
        let persistentContainer = appDelegate.persistentContainer
        //3
        let managedContext = persistentContainer.viewContext
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "Movie")
        
        let predicate = NSPredicate(format: "moviename = %@", movie)
        
        request.predicate = predicate
        
        do {
            let result = try managedContext.fetch(request)
            
            if result.count > 0 {
                isExists = true
            }
            
            
        } catch {
            print("Error")
        }
        
        return isExists
        
    }
    
    
    
    


}
