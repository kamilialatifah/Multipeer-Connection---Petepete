//
//  DetailViewController.swift
//  petepete
//
//  Created by Kamilia Latifah on 18/09/19.
//  Copyright © 2019 masaksendiri. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var detail: [String: String]!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelNote: UILabel!
    
    @IBOutlet weak var textViewPesanku: UITextView!
    @IBOutlet weak var viewDetail: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(detail)
        // Do any additional setup after loading the view.
        labelNote.text = detail["title"]
        
       
        self.viewDetail.layer.cornerRadius = 10;
        self.viewDetail.layer.masksToBounds = true;
        self.view.backgroundColor = #colorLiteral(red: 0.6070170403, green: 0.1529285014, blue: 0.01681580208, alpha: 1)
        
        
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
