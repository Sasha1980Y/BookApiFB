//
//  DetailViewController.swift
//  BookApi
//
//  Created by Alexander Yakovenko on 2/22/18.
//  Copyright © 2018 Alexander Yakovenko. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var pictureImageView: UIImageView!
    
    @IBOutlet weak var nameBookLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var titleTextView: UITextView!
    
    
    var book: JSON.Items?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        
        setBook()
        
        
    
        
        print("ok")
        
    }
    
    
    @IBAction func saveToBasket(_ sender: Any) {
       
        if let book = book {
            UserProfile.shared.booksBasket.append(book)
        }
        
        self.tabBarController?.viewControllers![1] as! BasketViewController
        self.tabBarController?.selectedIndex = 1
        
        self.navigationController?.popViewController(animated: true)
        
    }
    

    func setBook() {
        
        if let volumeInfo = book?.volumeInfo {
            if let titleText = volumeInfo.title {
                nameBookLabel.text = titleText
            }
            
            var authors = ""
            if let author = volumeInfo.authors {
                for item in author {
                    if author[0] == item {
                        authors += item
                    } else {
                        authors += ", " + item
                    }
                    
                }
            }
            authorLabel.text = authors
            
            if let linkImage = volumeInfo.imageLinks?.thumbnail {
                print(linkImage)
                //let imageView = UIImageView(frame: CGRect(x: 50.0, y: 50.0, width: 50.0, height: 50.0))
                if let url = URL(string: linkImage) {
                    do {
                        let data = try Data(contentsOf: url) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                        pictureImageView.image = UIImage(data: data)
                        print("ok")
                    } catch {
                        print("image not exist", error)
                        
                    }
                    
                }
                
            }
            if let describe = volumeInfo.description {
                titleTextView.text = describe
            }
            
            
        }
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
