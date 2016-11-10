//
//  ViewController.swift
//  Cerebros
//
//  Created by DONALD CHWOJKO on 11/9/16.
//  Copyright © 2016 DONALD CHWOJKO. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var stack: CoreDataStack!

    @IBOutlet weak var tableView: UITableView!
    
    var characters = [ComicCharacter]()
    let reuseIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // get core data stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        stack = delegate.stack
        
        stack.mainContext.performAndWait {
            let entity = NSEntityDescription.entity(forEntityName: "ComicBook", in: self.stack.mainContext)
            let comicBook = NSManagedObject(entity: entity!, insertInto: self.stack.mainContext) as! ComicBook
            comicBook.title = "DON"
        }
        
        stack.mainContext.performAndWait {
            let entity = NSEntityDescription.entity(forEntityName: "ComicBook", in: self.stack.mainContext)
            let comicBook = NSManagedObject(entity: entity!, insertInto: self.stack.mainContext) as! ComicBook
            comicBook.title = "CHWOJKO"
        }
        
        stack.mainContext.performAndWait {
            let entity = NSEntityDescription.entity(forEntityName: "ComicBook", in: self.stack.mainContext)
            let comicBook = NSManagedObject(entity: entity!, insertInto: self.stack.mainContext) as! ComicBook
            comicBook.title = "Zoey"
        }
        
        stack.mainContext.performAndWait {
            let entity = NSEntityDescription.entity(forEntityName: "ComicBook", in: self.stack.mainContext)
            let comicBook = NSManagedObject(entity: entity!, insertInto: self.stack.mainContext) as! ComicBook
            comicBook.title = "Neka"
        }
        
        let fetchRequest: NSFetchRequest<ComicBook> = ComicBook.fetchRequest()
        
        let sectionSortDescriptor = NSSortDescriptor(key: "title", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            let searchResults = try self.stack.mainContext.fetch(fetchRequest)
            for searchHit in searchResults {
                print(searchHit.title!)
            }
        } catch {
            fatalError("There was an error reading")
        }
        
        
        // Get and load the characters if nil
        if characters.count == 0 {
            getMarvelCharacters()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMarvelCharacters() {
        
        var characterCount: Int = 0
        
        let parameters: [String:AnyObject] = [
            "orderBy" : "name" as AnyObject,
            "limit" : "1" as AnyObject
        ]
        // while (remainingCharacters > 0) {}
        self.getCharacterCount() { count in
            characterCount = count
        
            for offset in stride(from: 0, through: characterCount, by: 100) {
                self.getCharactersAtOffset(offset: offset) { characters in
//                  // TO DO
                }
            }
        }

    }
    
    func getCharacterCount(completionHandler: @escaping (_ count: Int) -> Void) -> Void {
        let parameters: [String:AnyObject] = [
            "orderBy" : "name" as AnyObject,
            "limit" : "1" as AnyObject
        ]
        MarvelClient.sharedInstance().taskForGETMethod(urlString: "https://gateway.marvel.com:443/v1/public/characters", parameters: parameters) { result, error in
            guard error == nil else {
                fatalError()
            }
            
            if let result = result {
                if let data : [String: AnyObject] = result["data"] as! [String:AnyObject] {
                    if let characterCount: Int = data["total"] as! Int {
                        completionHandler(characterCount)
                        return
                    }
                }
            }
            completionHandler(0)
            return
        }
    }

    func getCharactersAtOffset(offset: Int, completionHandler: (_ characters: [ComicCharacter]) -> Void) -> Void {
        let parameters: [String:AnyObject] = [
            "orderBy" : "name" as AnyObject,
            "limit" : "100" as AnyObject,
            "offset" : "\(offset)" as AnyObject
        ]
        MarvelClient.sharedInstance().taskForGETMethod(urlString: "https://gateway.marvel.com:443/v1/public/characters", parameters: parameters) { result, error in
            guard error == nil else {
                fatalError()
            }
//            print(result!)
            if let result = result {
                if let data: [String:AnyObject] = result["data"] as! [String:AnyObject] {
                    if let results: [[String:AnyObject]] = data["results"] as! [[String:AnyObject]] {
                        for arrayItem in results {
                            var thumbnailString: String
                            if let thumbnail: [String:String] = arrayItem["thumbnail"] as! [String:String] {
                                thumbnailString = "\(thumbnail["path"]).\(thumbnail["extension"])"
                                print(thumbnailString)
                            }
                            if let name: String = arrayItem["name"] as! String, let id: Int64 = arrayItem["id"] as! Int64 {
                                //print(name)
                                self.stack.mainContext.performAndWait {
                                    let entity = NSEntityDescription.entity(forEntityName: "ComicCharacter", in: self.stack.mainContext)
                                    let comicCharacter = NSManagedObject(entity: entity!, insertInto: self.stack.mainContext) as! ComicCharacter
                                    comicCharacter.name = name
                                    comicCharacter.identifier = id
                                    self.characters.append(comicCharacter)
                                }
                                self.updateTable()
                                
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    func updateTable() {
        let queue = DispatchQueue(label: "myQueue")
        queue.async {
            // placeholder
            DispatchQueue.main.async {
                self.characters.sort() { $0.name! < $1.name! }
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as UITableViewCell
        cell.textLabel?.text = characters[indexPath.row].name
        cell.detailTextLabel?.text = "\(characters[indexPath.row].identifier)"
        cell.imageView?.image = nil
        return cell
    }

}

