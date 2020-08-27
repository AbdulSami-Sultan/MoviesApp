//
//  CustomImageView.swift
//  MoviesApp
//
//  Created by Abdul Sami Sultan on 26/08/2020.
//  Copyright © 2020 Sami. All rights reserved.
//

import UIKit
class CustomImageView: UIImageView{
    var task: URLSessionDataTask!
    
    func loadImage(from url:URL){
        image = nil
        if let task = task{
            task.cancel()
        }
        
        task = URLSession.shared.dataTask(with: url){(data, response, error) in
            guard let data = data  else{
                return
            }
            print("cell")
            print(data)
            do{
                let new = try Data(contentsOf: url)
                let newImage = UIImage(data: new)
                
                DispatchQueue.main.async {
                               self.image = newImage
                           }
                
            }catch{
                print("error")
            }
            
        
           
        }
        task.resume()
    }
}
