//
//  MasterViewController.swift
//  STCv2
//
//  Created by Abdullah Alhazmi on 25/12/2017.
//  Copyright © 2017 Abdullah Alhazmi. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()
    
    let URL_BASE = "https://no89n3nc7b.execute-api.ap-southeast-1.amazonaws.com/staging/exercise"
    var refresher: UIRefreshControl!
    // to be used in the  and UITableView func
    var ResultsArticles: Results<Article>!
    //so we can get the row count
    var rows = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //navigationItem.leftBarButtonItem = editButtonItem
 
    
        

//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
//        navigationItem.rightBarButtonItem = addButton
//        if let split = splitViewController {
//            let controllers = split.viewControllers
//            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
//        }
        
        /* Calling my functions
         -------------------------------------------
        */
        largeNavbarTitle()
        downloadData()
        
        // to be used in the  and UITableView func
        let realm = try! Realm()
        ResultsArticles = realm.objects(Article.self)
        // Pull to refresh
        refresher = UIRefreshControl()
        
        refresher.attributedTitle = NSAttributedString(string: "Refreshing")
        
        refresher.addTarget(self, action: #selector(MasterViewController.downloadData), for: UIControlEvents.valueChanged)
        
        tableView.addSubview(refresher)
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        
        // navbar not translucent after coming back from detail view
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.tintColor = nil
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func insertNewObject(_ sender: Any) {
        objects.insert(NSDate(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = ResultsArticles[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                controller.navigationItem.largeTitleDisplayMode = .never
                controller.navigationItem.title = ""
                //to make navbar on detailController translucent
                navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                navigationController?.navigationBar.shadowImage = UIImage()
                navigationController?.navigationBar.isTranslucent = true
                
                
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ArticleCell {
            // populate cell with articles
            let article = ResultsArticles[indexPath.row]
            cell.configureCell(article: article)
            return cell
        } else {
           //Return a genaric Article cell..
            return ArticleCell()
            
        }
        
        
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    // To make a large title
    func largeNavbarTitle(){
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // to download & parse JSON
    @objc func downloadData() {
        let url = URL(string: URL_BASE)!
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            
            if error != nil {
                print(error.debugDescription)
            } else {
                do {
                    let dict = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? Dictionary<String, AnyObject>
                    
                    // changing the title
                    if let title = dict!["title"] as? String {
                        self.navigationController?.navigationItem.title = title
                    }

                    if let results = dict!["articles"] as? [Dictionary<String, AnyObject>] {
                        do {
                            
                            //clearing realm, because the data is the same from the server, dont need to check for duplicates and append the rest
                            
                            let realm = try! Realm()
                            let allArticles = realm.objects(Article.self)
                            
                            if allArticles.count > 0 {
                                try realm.write {
                                    realm.deleteAll()
                                }
                            }
                            
                        } catch {
                            
                            print("Delete failed", error)
                            
                        }
                        for obj in results {
                            // making sure there isn't an article with an empty title or content
                            let objTitle = obj["title"] as? String
                            let objContent = obj["content"] as? String
                            
                            
                            if(objTitle != "" || objContent != ""){
                                let article = Article(articleDict: obj)
                            
                                // Saving Articles to realm
                                do {
                                    let realm = try! Realm()
                                    try realm.write {
                                        realm.add(article)
                                    }
                                } catch {
                                    // to handle the error appropriately, for development purposes only
                                    let nserror = error as NSError
                                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                                }
                            }
                        }

                        let realm = try! Realm()
                        let ResultsArticles = realm.objects(Article.self)
                        //Updating rows
                        self.rows = ResultsArticles.count
                        
                        
                        //Main UI thread
                        DispatchQueue.main.async{
                            self.tableView.reloadData()
                            self.refresher.endRefreshing()
                        }
                    }
                    
                } catch {
                    print("JSON Processing Failed", error)
                }
                
            }
            
        }
        
        task.resume()
    }


}

