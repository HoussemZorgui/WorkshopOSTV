//
//  BookmarksViewController.swift
//  WorkshopIOSTV
//
//  Created by Khaled Guedria on 11/10/2021.
//  Copyright © 2021 Khaled Guedria. All rights reserved.
//

import UIKit


extension UIImageView {
    func load(urlString : String) {
        guard let url = URL(string: urlString)else {
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

class BookmarksViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //var
    var movies = [MovieModel]()
    @IBOutlet weak var mCV: UICollectionView!
    
    
    //widgets
    @IBOutlet weak var welcomeLabel: UILabel!
    
    
    

    //Data source protocol
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collCell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookmarkCell", for: indexPath)
        let cv = collCell.contentView
        let imageview = cv.viewWithTag(1) as! UIImageView
        imageview.load(urlString: movies[indexPath.row].Poster)
        
        let label = cv.viewWithTag(2) as! UILabel
        label.text = movies[indexPath.row].Title
        
        return collCell
        
    }
    
    //Delegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetailsSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "toDetailsSegue" {
            let index = sender as! IndexPath
            let destination = segue.destination as! DetailsViewController
            destination.movieName = movies[index.row].Title
            destination.movieImage = movies[index.row].Poster
        }
    }
    
    //life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMoviesFromAPI()
        // init welcome label
        let msg = "Welcome back "
        welcomeLabel.text =  msg
    }
    
    
    //from API
    //
    func fetchMoviesFromAPI(){
        

        let request = NSMutableURLRequest(url: NSURL(string: "https://my-json-server.typicode.com/horizon-code-academy/fake-movies-api/movies")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 100.0)
        request.httpMethod = "GET"
        //request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                if httpResponse?.statusCode == 200 {
                    
                    do {
                        let res = try JSONDecoder().decode([Dictionary<String, String>].self, from: data!)
                        
                        for item in res {
                            var movie = MovieModel(Title: item["Title"] ?? "", Poster: item["Poster"] ?? "")
                            self.movies.append(movie)
                        }
                        
                        DispatchQueue.main.async {
                        //self.movies = res
                            self.mCV.reloadData()
                        }
                    } catch let error {
                        print(error)
                    }
                }
            }
        }).resume()

        
    }

    

}
