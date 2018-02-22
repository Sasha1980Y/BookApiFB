//
//  AccountViewController.swift
//  BookApi
//
//  Created by Alexander Yakovenko on 2/22/18.
//  Copyright © 2018 Alexander Yakovenko. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class AccountViewController: UIViewController {
    @IBOutlet weak var accountPictureImageView: UIImageView!
    
    @IBOutlet weak var accountNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        print("Begin of code")
        if let url = URL(string: UserProfile.shared.urlPicture) {
            accountPictureImageView.contentMode = .scaleAspectFit
            downloadImage(url: url)
        }
        print("End of code. The image will continue downloading in the background and it will be loaded when it ends.")
        
        accountNameLabel.text = UserProfile.shared.name
        

    }

    @IBAction func logOutButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        LoginManager().logOut()
        
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }

    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.accountPictureImageView.image = UIImage(data: data)
            }
        }
    }

    

}
