//
//  FavoritesViewController.swift
//  WorkshopIOSTV
//
//  Created by Khaled Guedria on 10/25/20.
//  Copyright © 2020 Khaled Guedria. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //var
    var favorites = [String]()
    
    @IBOutlet weak var tableview: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let favCell = tableView.dequeueReusableCell(withIdentifier: "favCell")
        let contentView = favCell?.contentView
        
        let label = contentView?.viewWithTag(1) as! UILabel
        let imageView = contentView?.viewWithTag(2) as! UIImageView
        
        label.text = favorites[indexPath.row]
        imageView.image = UIImage(named: favorites[indexPath.row])
        

        return favCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let movie = favorites[indexPath.row]
        performSegue(withIdentifier: "mSegue2", sender: movie)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            deleteElement(tableView: tableview, index: indexPath.row)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let param = sender as! String
        if segue.identifier == "mSegue2" {
            
            let destination = segue.destination as! DetailsViewController
            destination.movieName = param
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        // Do any additional setup after loading the view.
    }
    

    
    
    
    //methods
    func fetchData() {
        
        //1
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //2
        let persistentContainer = appDelegate.persistentContainer
        //3
        let managedContext = persistentContainer.viewContext
        
        //4
        let request = NSFetchRequest<NSManagedObject>(entityName: "Movie")
        
        //5
        do {
            let result = try managedContext.fetch(request)
            for item in result {
                favorites.append(item.value(forKey: "moviename") as! String)
            }
            
        } catch  {
            print("SELECT ERROR")
        }
        
    }
    

    func getByCreateria(movie: String) -> NSManagedObject{
                
        var obj:NSManagedObject?
        
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
                obj = result[0]
            }
            
            
        } catch {
            print("Error")
        }
        
        
        return obj!
        
    }
    
    
    func deleteElement(tableView: UITableView, index: Int) {
        
        //1
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //2
        let persistentContainer = appDelegate.persistentContainer
        //3
        let managedContext = persistentContainer.viewContext
        //4
        managedContext.delete(getByCreateria(movie: favorites[index]))
        //5
        do {
            try managedContext.save()
            
        } catch {
            print("Error!")
        }
        
        favorites.remove(at: index)
        tableview.reloadData()
                
    }
    
    //..
    
    func moviesClear() {
        
        //1
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //2
        let persistentContainer = appDelegate.persistentContainer
        //3
        let managedContext = persistentContainer.viewContext
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "Movie")
        
        do {
            let result = try managedContext.fetch(request)
            
            for item in result {
                
                managedContext.delete(item)
            }
            
            try managedContext.save()
            
        } catch {
            print("Error!")
        }
        
        favorites.removeAll()
        tableview.reloadData()
        
        
        
    }
    
    //..
    
    @IBAction func clearAction(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Delete", message: "Are you sure ?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let yesAction = UIAlertAction(title: "Delete", style: .destructive, handler: {_ in
            self.moviesClear()
        })
        
        alert.addAction(cancelAction)
        alert.addAction(yesAction)
        
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    

}
