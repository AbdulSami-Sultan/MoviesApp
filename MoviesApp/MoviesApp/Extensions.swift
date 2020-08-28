//
//  Extensions.swift
//  MoviesApp
//
//  Created by Abdul Sami Sultan on 28/08/2020.
//  Copyright © 2020 Sami. All rights reserved.
//

import UIKit
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
