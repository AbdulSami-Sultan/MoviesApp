//
//  InformationViewController.swift
//  MoviesApp
//
//  Created by Abdul Sami Sultan on 23/08/2020.
//  Copyright © 2020 Sami. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {
            var id : Int = 0
          var titleName : String = ""
          var year : Int = 0
          var language : String = ""
          var medium_cover_image : String = ""
          var description_full : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(titleName)
        screenSetup()
        
//calling()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        screenSetup()
    }
    func screenSetup() {
        let label1 = view.viewWithTag(2001) as? UILabel
        let label2 = view.viewWithTag(2002) as? UILabel
        let label3 = view.viewWithTag(2003) as? UILabel
        let label4 = view.viewWithTag(2004) as? UILabel
        let label5 = view.viewWithTag(2005) as? UITextView

        let imagess = view.viewWithTag(2006) as? UIImageView
        
        
        label1?.text = String(id)
        label2?.text = String(titleName)
        label3?.text = String(year)
        label4?.text = String(language)
        label5?.text = String(description_full)
        
        if let url = URL(string: medium_cover_image){
            do {
             
                let data = try Data(contentsOf: url)
                imagess?.image = UIImage(data: data)
            }catch {
                print("Error")
            }
            
        }
        
        
        
        
    }
    
      
}
