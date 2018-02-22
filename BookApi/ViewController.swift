//
//  ViewController.swift
//  BookApi
//
//  Created by Alexander Yakovenko on 2/20/18.
//  Copyright © 2018 Alexander Yakovenko. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore



class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = LoginButton(readPermissions: [.publicProfile])
        loginButton.center = view.center
        view.addSubview(loginButton)
        
        passUserFromFBToUserProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        passUserFromFBToUserProfile()
        if let accessToken = AccessToken.current {
            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController
            self.present(secondVC!, animated: true, completion: nil)
            //self.navigationController?.pushViewController(secondVC!, animated: true)
        }
    }
    
    func passUserFromFBToUserProfile() {
        // get user from FB
        GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start({ (urlResponse, requestResult) in
            
            switch requestResult {
            case .success(response: let response):
                
                if let responseDictionary = response.dictionaryValue {
                    
                    if let email = responseDictionary["email"] as? String {
                        print(email)
                        UserProfile.shared.email = email
                    }
                    if let first = responseDictionary["name"] as? String {
                        print(first)
                        UserProfile.shared.name = first
                    }
                    if let picture = responseDictionary["picture"] as? NSDictionary {
                        if let data = picture["data"] as? NSDictionary{
                            if let profilePicture = data["url"] as? String {
                                print(profilePicture)
                                UserProfile.shared.urlPicture = profilePicture
                            }
                        }
                    }
                }
            case .failed(let error):
                print(error)
                
            }
        })
        // end get user
        
    }
}

