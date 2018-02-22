//
//  TabBarViewController.swift
//  BookApi
//
//  Created by Alexander Yakovenko on 2/22/18.
//  Copyright © 2018 Alexander Yakovenko. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = UIColor.white
        self.tabBar.items![0].image = UIImage(named: "book")
        self.tabBar.items![1].image = UIImage(named: "basket")
        self.tabBar.items![2].image = UIImage(named: "user")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
