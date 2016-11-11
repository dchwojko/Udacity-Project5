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
    
    func getMarvelCharacters() {
        
        var characterCount: Int = 0
        
        let parameters: [String:AnyObject] = [
            "orderBy" : "name" as AnyObject,
            "limit" : "100" as AnyObject
        ]
        // while (remainingCharacters > 0) {}
        self.getCharacterCount() { count in
            characterCount = count
        
            for offset in stride(from: 0, through: characterCount, by: 100) {
                print(offset)
                self.getCharactersAtOffset(offset: offset) { characterSet in
                    for character in characterSet {
                        self.characters.append(character)
                        self.updateTable()
                    }
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

    func getCharactersAtOffset(offset: Int, completionHandler: @escaping (_ characters: [ComicCharacter]) -> Void) -> Void {
        let parameters: [String:AnyObject] = [
            "orderBy" : "name" as AnyObject,
            "limit" : "100" as AnyObject,
            "offset" : "\(offset)" as AnyObject
        ]
        MarvelClient.sharedInstance().taskForGETMethod(urlString: "https://gateway.marvel.com:443/v1/public/characters", parameters: parameters) { result, error in
            guard error == nil else {
                fatalError()
            }
            
            var characterSet = [ComicCharacter]()
//            print(result!)
            if let result = result {
                if let data: [String:AnyObject] = result["data"] as! [String:AnyObject] {
                    if let results: [[String:AnyObject]] = data["results"] as! [[String:AnyObject]] {
                        for arrayItem in results {
                            print("DEBUG: results size: \(results.count)")
                            print("DEBUG: characterSet size: \(characterSet.count)")
                            var thumbnailString: String = ""
                            if let thumbnail: [String:String] = arrayItem["thumbnail"] as! [String:String] {
                                let tempThumbnailString = "\(thumbnail["path"]!).\(thumbnail["extension"]!)"
                                
                                // Repalce 'http:' with 'https:'
                                thumbnailString = tempThumbnailString.replacingOccurrences(of: "http:", with: "https:", options: .literal, range: nil)
                                
                                print(thumbnailString)
                            }
                            if let name: String = arrayItem["name"] as! String, let id: Int64 = arrayItem["id"] as! Int64 {
                                //print(name)
                                self.stack.mainContext.performAndWait {
                                    let entity = NSEntityDescription.entity(forEntityName: "ComicCharacter", in: self.stack.mainContext)
                                    let comicCharacter = NSManagedObject(entity: entity!, insertInto: self.stack.mainContext) as! ComicCharacter
                                    comicCharacter.name = name
                                    comicCharacter.identifier = id
                                    comicCharacter.thumbnailPath = thumbnailString
                                    characterSet.append(comicCharacter)
                                }
                            }
                        }
                        completionHandler(characterSet)
                        return
                    }
                }
                
            }
            completionHandler(characterSet)
            return
        }
    }
    
    func getCharacterPhoto(character: ComicCharacter, completionHandler: @escaping (_ imageData: NSData?, _ error: NSError?) -> Void) {
        print("DEBUG: \(character.name!) : \(character.identifier) : \(character.thumbnailPath!)")
//        let parameters : [String:AnyObject] = [:]
        MarvelClient.sharedInstance().taskForGETMethod(urlString: character.thumbnailPath!, parameters: [:]) { (data, error) in
            guard error == nil else {
                print("There was an error: \(error)")
                completionHandler(nil, error)
                return
            }
            
            completionHandler(data as! NSData?, nil)
        }

    }
    
    func updateTable() {
        performUIUpdatesOnMain {
            self.characters.sort() { $0.name! < $1.name! }
            self.tableView.reloadData()
        }
    }
    
    func performUIUpdatesOnMain(updates: @escaping () -> Void) {
        let queue = DispatchQueue(label: "myQueue")
        queue.async {
            // placeholder
            DispatchQueue.main.async {
                updates()
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
        
        if characters[indexPath.row].thumbnail == nil {
            MarvelClient.sharedInstance().getCharacterPhoto(character: characters[indexPath.row])  { (imageData, error) in
                guard error == nil else {
                    self.performUIUpdatesOnMain {
                        cell.imageView?.image = UIImage(named: "CharacterPlaceholderImage")
                    }
                    
                    return
                }
                
                self.performUIUpdatesOnMain {
                    cell.imageView?.image = UIImage(data: imageData as! Data)
                }
                
                return
            }

        } else {
            self.performUIUpdatesOnMain {
                cell.imageView?.image = UIImage(data: self.characters[indexPath.row].thumbnail as! Data)
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "characterDetailViewController") as! CharacterDetailViewController
        let selectedCharacter: ComicCharacter = characters[indexPath.row]
        print(selectedCharacter.name)
        controller.selectedCharacter = selectedCharacter
        navigationController?.pushViewController(controller, animated: true)
        
    }

}

