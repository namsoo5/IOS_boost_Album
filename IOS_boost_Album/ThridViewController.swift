//
//  ThridViewController.swift
//  IOS_boost_Album
//
//  Created by 남수김 on 06/03/2019.
//  Copyright © 2019 남수김. All rights reserved.
//

import UIKit

class ThridViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    var picture: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = picture
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
