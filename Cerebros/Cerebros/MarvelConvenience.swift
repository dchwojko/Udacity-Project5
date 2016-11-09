//
//  MarvelConvenience.swift
//  MyMarvel
//
//  Created by DONALD CHWOJKO on 10/30/16.
//  Copyright © 2016 DONALD CHWOJKO. All rights reserved.
//

import Foundation

extension MarvelClient {
//    func getCharacters(completionHandler: [Character]) {
//        
////        // DOCUMENTATION: https://developer.marvel.com/docs#!/public/getCharacterEventsCollection_get_3
////        let urlString: String = "https://gateway.marvel.com/v1/public/characters"
////        let parameters: [String:AnyObject] = [:]
////        
////        MarvelClient.sharedInstance().taskForGETMethod(urlString: urlString, parameters: parameters) { result, error in
////            guard error == nil else {
////                print("There was an error: \(error)")
////                return
////            }
////            
////            if let characterDataWrapperDictionary = result {
////                
////                let attributionHTML = characterDataWrapperDictionary["attributionHTML"] as? String
////                
////                let attributionText = characterDataWrapperDictionary["attributionText"] as? String
////                let code = characterDataWrapperDictionary["code"] as? Int
////                
////                let copyright = characterDataWrapperDictionary["copyright"] as? String
////                let characterDataContainerDictionary = characterDataWrapperDictionary["data"] as? [String:AnyObject]
////                
////                if let characterDataContainerDictionary = characterDataContainerDictionary {
////                
////                    let count = characterDataContainerDictionary["count"] as? Int
////                    
////                    let limit = characterDataContainerDictionary["limit"] as? Int
////                    
////                    let offset = characterDataContainerDictionary["offset"] as? Int
////                    
////                    let results = characterDataContainerDictionary["results"] as? [[String:AnyObject]]
////                    var characters: [Character] = [Character]()
////                    for rDictionary in results! {
////                        print(rDictionary)
////                        let comics = rDictionary["comics"] as? [String:AnyObject]
////                        let available = comics?["available"] as? Int
////                        print(available!)
////                        let returned = comics?["returned"] as? Int
////                        let items = comics?["items"] as? [AnyObject]
////                        let description = rDictionary["description"] as? String
////                        let events = rDictionary["events"] as? [String:AnyObject]
////                        let id = rDictionary["id"] as? Int
////                        let modified = rDictionary["modified"] as? String
////                        /****************************/
////                        let name = rDictionary["name"] as? String
////                        let resourceURI = rDictionary["resourceUIR"] as? String
////                        let thumbnailDictionary = rDictionary["thumbnail"] as? [String:AnyObject]
////                        let thumbnail = thumbnailDictionary?["path"] as? String
////                        let character = Character(id: id, name: name, description: description, resourceURI: resourceURI, thumbnail: thumbnail)
////                        characters.append(character)
////                        /****************************/
////                    }
////                    
////                }
////                
////                
////            } else {
////                print("uh oh")
////            }
////            return
////        }
////        return characters
////
//    }
}
