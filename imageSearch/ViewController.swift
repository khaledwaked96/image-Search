//
//  ViewController.swift
//  imageSearch
//
//  Created by macintosh on 9/22/20.
//  Copyright © 2020 macintosh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class ViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var tectField: UITextField!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var collectionView: UICollectionView!
     var imagesList: Array<Data> = Array()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        activity.hidesWhenStopped = true
  
    }
    

    
    

    func searchImage(query: String){
        
    let headers = ["x-rapidapi-host" : "contextualwebsearch-websearch-v1.p.rapidapi.com",
                "x-rapidapi-key" : "cXtRDS885QmshoVdppQSActidvHgp1KmizcjsnR6GmTEyUnUat",
                                "Content-Type":"application/x-www-form-urlencoded"]
              
    let request = AF.request("https://contextualwebsearch-websearch-v1.p.rapidapi.com/api/Search/ImageSearchAPI?autoCorrect=true&pageNumber=1&pageSize=10&q=\(query)&safeSearch=false", method: .get, headers: HTTPHeaders(headers))
              
              request.responseJSON {(response) in
                             
                        
            switch response.result {
                                 
        case .success(let value):
                                 
        let json = JSON(value)
        let images = json["value"].array
                                 
        for photo in images!{
            print(photo["url"])
                                     
            self.imagesList.append(Data(imagesearch: photo["url"].string ?? ""))
       
                }
                                 
        self.dispatsh()
                                 
                      
                case .failure(let error):
                print("Error: \(error.localizedDescription)")
                       
                                 
                             }
                             
                         }
    
}
    
    func dispatsh(){
    DispatchQueue.main.async {
             UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                 self.collectionView?.reloadData()
                 self.collectionView?.alpha = 1
                 self.activity.stopAnimating()
             }, completion: nil)
   
         }
     }
          

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
        return imagesList.count
     }
     
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
         
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchCollectionView
        
        let search = imagesList[indexPath.row]
        
        cell.image.loadImage(imageUrl: search.imagesearch)
     
        
        return cell
        
        
     }
    
    
        func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {

                     let nbCol = 2

                     let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
                     let totalSpace = flowLayout.sectionInset.left
                         + flowLayout.sectionInset.right
                         + (flowLayout.minimumInteritemSpacing * CGFloat(nbCol - 1))
                     let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(nbCol))
                     return CGSize(width: size, height: size)
                 }

    
    
    @IBAction func searchAction(_ sender: Any) {
       
        activity.startAnimating()
        if  imagesList == nil {
         searchImage(query: tectField.text ?? "")
        } else {
            imagesList.removeAll()
                searchImage(query: tectField.text ?? "")
        }
    }
    
 
    
}
extension UIImageView {
    func loadImage(imageUrl: String?){
    
        AF.request(imageUrl!, method: .get).response { (response) in
            if(response.data == nil){
                return
            }
          
            self.image = UIImage(data: response.data!, scale:1)
         
           }
       }
}

