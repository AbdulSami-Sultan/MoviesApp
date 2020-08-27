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
    var movieArray :[Movie] = []
    var secondMovieArray :[Movie] = []
    var titles : [String] = []
    var uniqueGenre : [String] = []
    var arrayofUnique : [Int] = []
    
    var newArray : [movies] = []
    var forward = movies()
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    

    
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .darkGray
        
        collectionView.isHidden = true
        activity.isHidden = false
        activity.startAnimating()
        
        calling()
        // Do any additional setup after loading the view.
    }

    func calling(){
        let url = "https://yts.mx/api/v2/list_movies.json"
        var json : Any?
        if let url = URL(string: url)
        {
           let session = URLSession.shared
           session.dataTask(with: url) { (data, response, error) in
            if response != nil {
                
//                   print(response)
               }
               
               if let data = data {
//                print("data - > ")
//                   print(data)
              do {
                    json = try JSONSerialization.jsonObject(with: data, options: [])
           
                    //print(json!)
                   } catch {
                       print(error)
                   }
                guard let data_array = json as? NSDictionary else {
                    return
                }
                if let message = data_array["status_message"] as? String{
//                    print("coming = \(message)")
                    if let movie_data = data_array as? [String:Any]{
//                        print("movie object")
//                        print(movie_data["data"]!)
                      
                        if let movie_data_all = movie_data["data"] as? [String:Any]{
//                           print("movie object for all ")
//                           print(movie_data_all["limit"]!)
                            if let movie_data_all = movie_data_all["movies"] as? [[String:Any]]{
//                                   print("sari movies ")
//                                print(movie_data_all.count)
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
            print("genre = \(newArray[i].genre)")
            array.append(contentsOf: newArray[i].genre)
        }
        print("outter")
   
        uniqueGenre = Array(Set(array))
        print(uniqueGenre)
    }
    func array(_ json:[[String:Any]] ){
        

        var currentMovie = movies()
        var last = movies()
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
//                titles.append(title)
                
                last.id = id
                last.title = title
                last.year = year
                if let genre = json[i]["genres"] as? NSArray{
                    for i in 0..<genre.count{
                        currentMovie.genre = genre as! [String]
                         print("\(title)array of each genre \(genre[i]) for \(i)")
                    }
                   
                }
                
            }
            
//                movieArray.insert(currentMovie, at: i)
//                secondMovieArray.append(currentMovie)
            newArray.append(currentMovie)
            
           
        }
      
        print("--")
               for i in 0..<newArray.count{
                print("\(i)-\(newArray[i].id)")
               }
      suffle()
        reload()
        
    }
    func reload() {
      
        DispatchQueue.main.async {
            self.collectionView.reloadData()
           // self.tableView.reloadData()
        }
        
     
    }
    
    
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return newArray.count
//       }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "MOVIES"
//    }
//
//       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
//        let label = cell.viewWithTag(1001) as? UILabel
//        let img = cell.viewWithTag(1002) as? UIImageView
//        img?.bounds.size = CGSize(width: 40, height: 40)
//
//
//        cell.backgroundColor = .lightGray
//        label?.text = "\(newArray[indexPath.row].title)( \(newArray[indexPath.row].year))"
////        print("\(movieArray.count) + \(indexPath.row) + \( movieArray[indexPath.row].title) ")
//
//        let activity = cell.viewWithTag(1234) as? UIActivityIndicatorView
//        activity?.isHidden = false
//        activity?.startAnimating()
//
//
//        img?.image = nil
//
//
//
////            if let url = URL(string: self.newArray[indexPath.row].medium_cover_image){
////                            do {
////
////                                let data = try Data(contentsOf: url)
////                                DispatchQueue.main.async {
////                             img?.image  = UIImage(data: data)
////
////
////                                activity?.isHidden = true
////                                    activity?.stopAnimating()
////
////                                }
////                            }catch {
////                                print("Error")
////                            }
////
////                 }
//
//
//
//        return cell
//       }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        forward = newArray[indexPath.row]
//        performSegue(withIdentifier: "info", sender: nil)
//    }
//    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//
//       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "info"{
            if let controller = segue.destination as? InformationViewController{
                controller.id = forward.id
                controller.titleName = forward.title
                controller.description_full = forward.description_full
                controller.language = forward.language
                controller.medium_cover_image = forward.medium_cover_image
                controller.year = forward.year
                controller.genre = forward.genre
            }
        }
    }
  
}

extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
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
 
        var objIndex = set[indexPath.item]
        var object = movies()
        object = newArray[objIndex]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
      
        
        let activity = cell.viewWithTag(3005) as? UIActivityIndicatorView
        activity?.isHidden = false
        activity?.startAnimating()
        
        let image = cell.viewWithTag(3001) as? UIImageView
        image?.backgroundColor = UIColor.red
        image?.layer.borderWidth = 5
        image?.layer.cornerRadius = 10
        
        image?.load(object.medium_cover_image)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {

            
            return CGSize(width: 126, height: 180);
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = indexPath.item
        let selected = arrayofUnique[selectedItem]
        forward = newArray[selected]
        performSegue(withIdentifier: "info", sender: nil)
    }
    
    
}

extension UIImageView{
    func layout() {
        self.backgroundColor = .lightGray
        self.contentMode = .scaleAspectFill
    }
    
    
    func load(_ Url:String){
        
        image = nil
        guard let url = URL(string: Url) else {
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
              
                        self?.image = image
                        
                    }
                }
            }
        }
    }
}
