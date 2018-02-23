//
//  BooksViewController.swift
//  BookApi
//
//  Created by Alexander Yakovenko on 2/22/18.
//  Copyright © 2018 Alexander Yakovenko. All rights reserved.
//

import UIKit



struct JSON: Decodable {
    var kind: String?
    var totalItems: Int?
    var items: [Items]?
    
    struct Items: Decodable {
        var kind: String?
        var id: String?
        var volumeInfo: VolumeInfo?
        
        
        struct VolumeInfo: Decodable {
            var title: String?
            var authors: [String]?
            var imageLinks: ImageLinks?
            var description: String?
            
            struct ImageLinks: Decodable {
                var smallThumbnail: String?
                var thumbnail: String?
            }
        }
    }
    
    
}


class BooksViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var books = [JSON.Items]()
    var numberSelectBook: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        searchBar.delegate = self as UISearchBarDelegate
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func downloadBooks(bookTitle: String) {
        let stringUrl = "https://www.googleapis.com/books/v1/volumes?q=\(bookTitle)"
        
        guard let url = URL(string: stringUrl) else {
            print("url problem")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, resp, error) in
            
            print("download books")
            guard let data = data else {
                return
            }
            guard error == nil else {
                return
            }
            
            do {
                let json = try JSONDecoder().decode(JSON.self, from: data)
                
                if let countItem = json.items {
                    self.books = countItem
                }
                
                //
                DispatchQueue.main.async(execute: { () -> Void in
                    self.tableView.reloadData()
                    //self.refreshControl?.endRefreshing()
                })
                
                //
                
                //DispatchQueue.main.async {
                  //  self.tableView.reloadData()
               // }
                
                
                print("Books VC")
                
            } catch let error {
                print(error)
            }
            }.resume()
        
        
        
        
        
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Detail" {
            let nextVC: DetailViewController = segue.destination as! DetailViewController
            if let number = numberSelectBook {
                nextVC.book = books[number]
            }
        }
        
        
        
    }
    
}

extension BooksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        tableView.register(UINib(nibName: "NameBookTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? NameBookTableViewCell
        
        if let volumeInfo = self.books[indexPath.row].volumeInfo {
            if let titleText = volumeInfo.title {
                cell?.titleLabel.text = titleText
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
            
            
            DispatchQueue.global(qos: .userInitiated).async {
            
            if let linkImage = volumeInfo.imageLinks?.smallThumbnail {
                    print(linkImage)
                
                    if let url = URL(string: linkImage) {
                        do {
                            let data = try Data(contentsOf: url) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                            DispatchQueue.main.async {
                            cell?.imageView?.image = UIImage(data: data)
                            print("cellForRowAt")
                            }
                        } catch {
                            print("image not exist", error)
                            
                        }
                        
                    }
                
                    
                    
                    
                }
                
                
                
                
            }
        
            
            
            cell?.authorLabel.text = authors
        }
        
        cell?.preservesSuperviewLayoutMargins = false
        cell?.separatorInset = UIEdgeInsets.zero
        cell?.layoutMargins = UIEdgeInsets.zero
        
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        numberSelectBook = indexPath.row
        
        performSegue(withIdentifier: "Detail", sender: nil)
        //let newViewController = DetailViewController()
        //newViewController.
        //self.navigationController?.pushViewController(newViewController, animated: true)

        
        
    }
}

extension BooksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension BooksViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let bookTitle = searchBar.text
        if let bookName = bookTitle {
            self.downloadBooks(bookTitle: bookName)
            
            searchBar.resignFirstResponder()
        }
        
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}


