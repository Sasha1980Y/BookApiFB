//
//  BasketViewController.swift
//  BookApi
//
//  Created by Alexander Yakovenko on 2/22/18.
//  Copyright © 2018 Alexander Yakovenko. All rights reserved.
//

import UIKit

class BasketViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var books: [JSON.Items] = UserProfile.shared.booksBasket
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        print("ok")
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        books = UserProfile.shared.booksBasket
        tableView.reloadData()
    }

}
extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "NameBookTableViewCell", bundle: nil), forCellReuseIdentifier: "CellBasket")
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellBasket", for: indexPath) as! NameBookTableViewCell
        if let title = books[indexPath.row].volumeInfo?.title {
            cell.titleLabel.text = title
        }
        if let author = books[indexPath.row].volumeInfo?.authors![0] {
            cell.authorLabel.text = author
        }
        
        var authors = ""
        if let author = books[indexPath.row].volumeInfo?.authors {
            for item in author {
                if author[0] == item {
                    authors += item
                } else {
                    authors += ", " + item
                }
                
            }
            cell.authorLabel.text = authors
        }
        if let linkImage = books[indexPath.row].volumeInfo?.imageLinks?.smallThumbnail {
            print(linkImage)
            //let imageView = UIImageView(frame: CGRect(x: 50.0, y: 50.0, width: 50.0, height: 50.0))
            if let url = URL(string: linkImage) {
                do {
                    let data = try Data(contentsOf: url) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    cell.imageView?.image = UIImage(data: data)
                    print("ok")
                } catch {
                    print("image not exist", error)
                    
                }
                
            }
            
        }
        
        
        
        
       return cell
    }
}

