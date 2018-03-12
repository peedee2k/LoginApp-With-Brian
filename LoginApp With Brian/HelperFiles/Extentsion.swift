//
//  Extentsion.swift
//  LoginApp With Brian
//
//  Created by Pankaj Sharma on 1/29/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    
    
    
    func loadImageUseingCacheWithUrlString(urlString: String) {
        
        if let cacheingImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cacheingImage
            return
            }
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                print("I have an error for image")
                return
            }
            DispatchQueue.main.async(execute: {
                if let downlodedImage = UIImage(data: data!) {
                    imageCache.setObject(downlodedImage, forKey: urlString as NSString)
                self.image = downlodedImage
                }
                
                
                
               
            })
        }) .resume()
    }
}
