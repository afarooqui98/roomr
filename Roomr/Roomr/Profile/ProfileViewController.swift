//
//  ProfileViewController.swift
//  Roomr
//
//  Created by Ryan Chan on 11/13/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var universityLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var separator: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage?.layer.cornerRadius = (profileImage?.frame.size.width ?? 0.0) / 2
        profileImage?.clipsToBounds = true
        profileImage?.layer.borderWidth = 3.0
        profileImage?.layer.borderColor = UIColor.white.cgColor
        
        
        profileImage.clipsToBounds = true
        view.sendSubviewToBack(separator)
        
        viewUpdate()
        
        //Fetch data from server
    }
    
	override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewUpdate()
    }
    
    func viewUpdate(){

        //Update labels with server info
        //Update image
        
    }
    
//Scene Delegate testing code
//guard let windowScene = (scene as? UIWindowScene) else { return }
//let storyboard = UIStoryboard(name: "Profile", bundle: nil)
//let vc = storyboard.instantiateViewController(identifier: "ProfileNavController")
//self.window?.windowScene = windowScene
//self.window?.rootViewController = vc

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
