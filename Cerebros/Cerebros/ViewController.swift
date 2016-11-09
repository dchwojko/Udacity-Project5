//
//  ViewController.swift
//  Cerebros
//
//  Created by DONALD CHWOJKO on 11/9/16.
//  Copyright © 2016 DONALD CHWOJKO. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var stack: CoreDataStack!

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

