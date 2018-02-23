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
    
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(BooksViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        searchBar.delegate = self as UISearchBarDelegate
        
        self.tableView.addSubview(self.refreshControl)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tableView.reloadData()
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
                DispatchQueue.main.async {
                if let countItem = json.items {
                    self.books = countItem
                    
                }
            
                DispatchQueue.main.async(execute: { () -> Void in
                    self.tableView.reloadData()
                })
                   
                }
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
        
            
            if let linkImage = volumeInfo.imageLinks?.smallThumbnail {
                    print(linkImage)
                
                
                //cell?.imageView?.imageFromServerURL(urlString: linkImage)
                //cell?.imageView?.loadImageUsingCache(withUrl: linkImage)
                
                
// WORK ONLY BLOCK !!!
                
                cell?.imageView?.loadImageUsingCache(withUrl: linkImage, block: {
                    self.tableView.reloadData()
                })
                
                
                
                
                
                /*
                
                    if let url = URL(string: linkImage) {
                        do {
                            let data = try Data(contentsOf: url) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                            DispatchQueue.main.async {
                            
                            cell?.imageView?.image = UIImage(data: data)
                            print("cellForRowAt")
                            
                             self.tableView?.reloadData()
                            
                            }
                            //self.tableView.reloadData()
                        } catch {
                            print("image not exist", error)
                        }
                        
                    }*/
                
                }
            
           // }
            
            
            
            cell?.authorLabel.text = authors
        }
        
        //self.tableView.layoutSubviews()
        //self.tableView.layoutIfNeeded()
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        numberSelectBook = indexPath.row
        performSegue(withIdentifier: "Detail", sender: nil)
    }
    
    func reload() {
        self.tableView.reloadData()
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
extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }}


let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    
    func loadImageUsingCache(withUrl urlString : String, block: @escaping () -> Void) {
        let url = URL(string: urlString)
        self.image = nil
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    block()
                }
            }
            
        }).resume()
    }
}

final class UITableViewWithReloadCompletion: UITableView {
    private var reloadDataCompletionBlock: (() -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        reloadDataCompletionBlock?()
        reloadDataCompletionBlock = nil
    }
    
    
    func reloadDataWithCompletion(completion: @escaping () -> Void) {
        reloadDataCompletionBlock = completion
        super.reloadData()
    }
}


