//
//  ViewController.swift
//  Pentaminoes Puzzle
//
//  Created by Thadea Achmad on 9/13/16.
//  Copyright © 2016 Thadea Achmad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    @IBOutlet weak var largeBoard: UIImageView!
    
    let boardImage = UIImage(named: "Board0.png")
    var boardImageView:UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        boardImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 420, height: 420))
        boardImageView.contentMode = .ScaleAspectFill
        boardImageView.image  = boardImage
        view.addSubview(boardImageView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

