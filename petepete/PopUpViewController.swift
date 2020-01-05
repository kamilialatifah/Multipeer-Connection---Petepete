//
//  PopUpViewController.swift
//  petepete
//
//  Created by Kamilia Latifah on 19/09/19.
//  Copyright © 2019 masaksendiri. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    var detail2: [String: String]!
    
    
    @IBOutlet weak var viewMini: UIView!
    
    @IBOutlet weak var textFieldNama: UITextField!
    
    @IBOutlet weak var textViewPesan: UITextView!
    
    @IBAction func batalAction(_ sender: Any) {
        removeAnimate()
    }
    
    @IBAction func batalOutlet(_ sender: Any) {
    }
    
    @IBAction func postAction(_ sender: Any) {
        var title = textFieldNama.text as! String
        var pesan = textViewPesan.text as! String
        
        var newDict = ["title" : title, "body" : pesan]
        
        
        //
        //            print(self.arrVacancy)
        //
        //            self.tableView.reloadData()
    }
    
    @IBAction func postOutlet(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func showAnimate() { self.view.transform  =  CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha =  0
        UIView.animate(withDuration: 0.25, animations: {self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {self.view.transform  = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0
        }, completion: {(finished: Bool) in  if (finished) { self.view.removeFromSuperview()}
        })
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
