//
//  PetePeteHomeTableViewController.swift
//  petepete
//
//  Created by Kamilia Latifah on 18/09/19.
//  Copyright © 2019 masaksendiri. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import LocalAuthentication
import Intents

class PetePeteHomeTableViewController: UITableViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    // MARK: - Properties
    var arrVacancy = [[String:String]]()
    var clickPosition: Int!
    var context = LAContext()
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
    var mcAdvertiserAssistant: MCAdvertiserAssistant?
    
    enum AuthenticationState{
           case loggedin, loggedout
       }
       var state = AuthenticationState.loggedout{
           didSet{
           }
       }
    
    @IBOutlet weak var newVacancyOutlet: UIBarButtonItem!
    
    @IBAction func newVacancy(_ sender: Any) {
        
        // Pengumuman alert
        let addAlert = UIAlertController(title: "Buat Pengumuman", message: "Butuh temen buat pesen delivery? Buat pengumuman di sini!", preferredStyle: .alert)
        let subview = (addAlert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        
        // Alert design
        subview.layer.cornerRadius = 10
        subview.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.8470588235, blue: 0.431372549, alpha: 1)
        addAlert.view.tintColor = #colorLiteral(red: 0.6070170403, green: 0.1529285014, blue: 0.01681580208, alpha: 1)
        addAlert.addTextField { (textfield: UITextField) in textfield.placeholder = "Nama kamu: pesan"}
        
        // Post button
        addAlert.addAction(UIAlertAction(title: "Post!", style: .default, handler: {
            (action: UIAlertAction) in
            
            var title = addAlert.textFields![0].text as! String
            var newDict = ["title" : title, "body" : "body"]
            self.arrVacancy.insert(newDict, at: 0)
            print(self.arrVacancy)
            self.tableView.reloadData()
            
            // Sending message set on alert to others and make it appear on table
            let arrayAsPLISTData = try?  NSKeyedArchiver.archivedData(withRootObject: self.arrVacancy, requiringSecureCoding: true)
            try? self.mcSession?.send(arrayAsPLISTData!, toPeers: self.mcSession!.connectedPeers, with: .reliable)
        }))
        
        // Batal button
        addAlert.addAction(UIAlertAction(title: "Batal", style: .cancel, handler: nil))
        self.present(addAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Idle state is logged out
        state = .loggedout
        
        newVacancyOutlet.accessibilityIdentifier = "myButton"
        print(newVacancyOutlet)
        
        // Navigation controller design
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.6070170403, green: 0.1529285014, blue: 0.01681580208, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        let logo = UIImage(named: "PetePete3")
        let imageView = UIImageView(image: logo)
        imageView.accessibilityLabel = "petepete"
        self.navigationItem.titleView = imageView
        
        // Adding search navigation item programatically
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showConnectionPrompt))
        
        // Multipeer state
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
    }

    // MARK: - Actions
    public func sayHi() {
        let alert = UIAlertController(title: "Hi There!", message: "Hey there! Glad to see you got this working!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ArsipToDetail"
        {
            let destination = segue.destination as! DetailViewController
            destination.detail = arrVacancy[clickPosition]
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrVacancy.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as! UITableViewCell

        // Configure the cell...
        
        //title  value sama dengan  index array
        cell.textLabel!.text = arrVacancy[indexPath.row] ["title"]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickPosition = indexPath.row
        
        self.performSegue(withIdentifier: "ArsipToDetail", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
   
    // MARK: - FaceID
        @objc fileprivate func handleFaceId(){
            let context = LAContext()

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "This app need FaceID to login") { (wasSuccessful, error) in
                    if wasSuccessful{
                        self.performSegue(withIdentifier: "loginSuccess", sender: self)
                    }else{
                        Alert.showBasic(title: "Incorrect credentials", msg: "Please try again", vc: self)
                    }
                }
            }else{
                Alert.showBasic(title: "FaceID not configured", msg: "Please go to settings", vc: self)
            }
        }

        class Alert{
            class func showBasic(title: String, msg: String, vc: UIViewController){
                let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                vc.present(alert, animated: true)
            }
        }
    
    // MARK: - Show Connection
    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Pencarian", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Teman yang mau ikut pesan", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Nebeng pesen ke teman", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Batal", style: .cancel))
        present(ac, animated: true)
        
        let subview2 = (ac.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        
        subview2.layer.cornerRadius = 10
        subview2.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.8470588235, blue: 0.431372549, alpha: 1)
        ac.view.tintColor = #colorLiteral(red: 0.6070170403, green: 0.1529285014, blue: 0.01681580208, alpha: 1)
    }
    
    // MARK: - Multipeer Connection ActionsSetting

    func startHosting(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
            mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "petepeteGOP9", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant?.start()
    }
    
    func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: "petepeteGOP9", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
            
        case .connecting:
            print("Connecting: \(peerID.displayName)")
            
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
            
            @unknown default:
                print("Unknown state received: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print(data)
        
        var arrSementara = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [[String:String]]
        
        arrVacancy = arrSementara!
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}



