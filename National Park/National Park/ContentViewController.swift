//
//  ContentViewController.swift
//  National Park
//
//  Created by Thadea Achmad on 10/15/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//


import Foundation
import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    
    
    //@IBOutlet weak var continueButton: UIButton!
    //@IBOutlet weak var titleLabel: UILabel!
    //@IBOutlet weak var previewImage: UIImageView!
    
    var pageIndex : Int?
    var titleText : String?
    var imageFile : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.previewImage.image = UIImage(named: self.imageFile!)
        self.titleLabel.text = self.titleText
    }
}