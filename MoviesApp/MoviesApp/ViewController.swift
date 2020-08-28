//
//  ViewController.swift
//  MoviesApp
//
//  Created by Abdul Sami Sultan on 22/08/2020.
//  Copyright © 2020 Sami. All rights reserved.
//



import UIKit

class ViewController: UIViewController{
   
    
    struct movies {
    var id : Int = 0
       var title : String = ""
       var year : Int = 0
       var language : String = ""
       var medium_cover_image : String = ""
       var description_full : String = ""
        var genre : [String] = []
    }

    var titles : [String] = []
    var uniqueGenre : [String] = []
    var arrayofUnique : [Int] = []
    var movieID : [String:Int] = [:]
    var newArray : [movies] = []
    var forward = movies()
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    

    
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .lightGray
        
        collectionView.isHidden = true
        activity.isHidden = false
        activity.startAnimating()
        
        calling()
        // Do any additional setup after loading the view.
    }

    func calling(){
        let url = "https://yts.mx/api/v2/list_movies.json?limit=20"
        var json : Any?
        if let url = URL(string: url)
        {
           let session = URLSession.shared
           session.dataTask(with: url) { (data, response, error) in
            if response != nil {
               }
               
               if let data = data {

              do {
                    json = try JSONSerialization.jsonObject(with: data, options: [])
           print("data recived")

                   } catch {
                       print(error)
                   }
                guard let data_array = json as? NSDictionary else {
                    return
                }
                if let message = data_array["status_message"] as? String{

                    if let movie_data = data_array as? [String:Any]{

                      
                        if let movie_data_all = movie_data["data"] as? [String:Any]{

                            if let movie_data_all = movie_data_all["movies"] as? [[String:Any]]{

                                self.array(movie_data_all)
                               }
                       }
                        
                       
                    }
                }
                   
               }
           }.resume()
        }
        
       
        
    }
    func suffle(){
        var array : [String] = []
        for i in 0..<newArray.count{
        
            array.append(contentsOf: newArray[i].genre)
        }
        uniqueGenre = Array(Set(array))

    }
    func array(_ json:[[String:Any]] ){
        

        var currentMovie = movies()
        var last = movies()
        print("movies count = \(json.count)")
        for i in 0..<json.count{
            if let id = json[i]["id"] as? Int,
                let title = json[i]["title"] as? String,
                let year = json[i]["year"] as? Int,
                let language = json[i]["language"] as? String,
                let medium_cover_image = json[i]["medium_cover_image"] as? String,
                let description_full = json[i]["description_full"] as? String{
                
                currentMovie.id = id
                currentMovie.title = title
                currentMovie.year = year
                currentMovie.language = language
                currentMovie.medium_cover_image = medium_cover_image
                currentMovie.description_full = description_full

                
                last.id = id
                last.title = title
                last.year = year
                if let genre = json[i]["genres"] as? NSArray{
                    for i in 0..<genre.count{
                        currentMovie.genre = genre as! [String]
                        
                    }
                   
                }
                
            }
            newArray.append(currentMovie)
            
           
        }

      suffle()
        reload()
        
    }
    func reload() {
      
        DispatchQueue.main.async {
            self.collectionView.reloadData()

        }
        
     
    }
   
  
}

extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.collectionView.isHidden = false
               self.activity.isHidden = true
               self.activity.stopAnimating()
        return uniqueGenre.count
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionsName", for: indexPath) as UICollectionReusableView
        let label = section.viewWithTag(4001) as! UILabel
        label.text = uniqueGenre[indexPath.section]
        label.textColor = .white
        section.backgroundColor = .black
        return section
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var counting = 0
        for i in 0..<newArray.count{
            for j in 0..<newArray[i].genre.count{
                if newArray[i].genre[j] == uniqueGenre[section]{
                            counting += 1
                }
            }
        }
        
        return counting
        
       
        
    }
    func gather(number:Int) -> [Int] {
        
        let currentGenre = uniqueGenre[number]
        arrayofUnique = []
        for i in 0..<newArray.count {
            for j in 0..<newArray[i].genre.count{
                if currentGenre == newArray[i].genre[j]{
                    arrayofUnique.append(i)
                  
                }
              
             }
        }
        

        return arrayofUnique
    }
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let set = gather(number: indexPath.section)

        let objIndex = set[indexPath.item]
        var object = movies()
        object = newArray[objIndex]
   
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
      
        
        let activity = cell.viewWithTag(3005) as? UIActivityIndicatorView
        activity?.isHidden = false
        activity?.startAnimating()
        
        let image = cell.viewWithTag(3001) as? UIImageView
        
        image?.layer.borderWidth = 5
        image?.layer.cornerRadius = 10
        
        image?.load(object.medium_cover_image)

        return cell
    }
    
   
    
    
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
               return CGSize(width: 126, height: 180);
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
}
