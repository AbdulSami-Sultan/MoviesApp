//
//  ViewController.swift
//  MoviesApp
//
//  Created by Abdul Sami Sultan on 22/08/2020.
//  Copyright © 2020 Sami. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    struct movies {
    var id : Int = 0
       var title : String = ""
       var year : Int = 0
       var language : String = ""
       var medium_cover_image : String = ""
       var description_full : String = ""
    }
    var movieArray :[Movie] = []
    var secondMovieArray :[Movie] = []
    var titles : [String] = []
    
    var newArray : [movies] = []
    var forward = movies()
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
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
               if let response = response {
//                   print(response)
               }
               
               if let data = data {
//                print("data - > ")
//                   print(data)
              do {
                    json = try JSONSerialization.jsonObject(with: data, options: [])
           
                   // print(json!)
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
                
                
            }
//                movieArray.insert(currentMovie, at: i)
//                secondMovieArray.append(currentMovie)
            newArray.append(currentMovie)
            
           
        }
      
        print("--")
               for i in 0..<newArray.count{
                print("\(i)-\(newArray[i].id)")
               }
      
        reload()
        
    }
    func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
     
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newArray.count
       }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "MOVIES"
    }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
        let label = cell.viewWithTag(1001) as? UILabel
        var img = cell.viewWithTag(1002) as? UIImageView
        
        label?.text = "\(newArray[indexPath.row].title)( \(newArray[indexPath.row].year))"
//        print("\(movieArray.count) + \(indexPath.row) + \( movieArray[indexPath.row].title) ")
        
        img?.image = nil
        if let imageFromCache = imageCache.object(forKey: newArray[indexPath.row].medium_cover_image as AnyObject) as? UIImageView{
            img = imageFromCache
            
        }
        
        DispatchQueue.main.async {
            if let url = URL(string: self.newArray[indexPath.row].medium_cover_image){
                            do {
                             
                                let data = try Data(contentsOf: url)
                             let imageToCache = UIImage(data: data)
                             
                                img?.image = imageToCache
                            }catch {
                                print("Error")
                            }
                 
                 }
        }
        
     
        return cell
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        forward = newArray[indexPath.row]
        performSegue(withIdentifier: "info", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "info"{
            if let controller = segue.destination as? InformationViewController{
                controller.id = forward.id
                controller.titleName = forward.title
                controller.description_full = forward.description_full
                controller.language = forward.language
                controller.medium_cover_image = forward.medium_cover_image
                controller.year = forward.year
            }
        }
    }
  
}

