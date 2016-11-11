//
//  CharacterDetailViewController.swift
//  Cerebros
//
//  Created by DONALD CHWOJKO on 11/11/16.
//  Copyright © 2016 DONALD CHWOJKO. All rights reserved.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    
    var selectedCharacter: ComicCharacter!

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let data = selectedCharacter.thumbnail {
            imageView.image = UIImage(data: data as! Data)
        }
        
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
