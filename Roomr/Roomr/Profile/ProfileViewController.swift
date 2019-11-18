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
    @IBOutlet var dropdownButtons: [UIButton]!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var universityLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewUpdate()
        //Fetch data from server
    }
    
	override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewUpdate()
    }
    
    func viewUpdate(){
        for button in dropdownButtons {
            button.isHidden = true
        }
        //Update labels with server info
        //Update image
    }
    
    
    @IBAction func menuButton(_ sender: UIButton) {
        dropdownButtons.forEach { (button) in
            UIView.animate(withDuration: 0.2, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func addMediaButton(_ sender: UIButton) {
        //Popup to choose media
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AddMediaViewController") as! AddMediaViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func editButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func settingsButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dropdownButtons.forEach { (button) in
            UIView.animate(withDuration: 0.2, animations: {
                button.isHidden = true
                self.view.layoutIfNeeded()
            })
        }
    }

//Scene Delegate testing code
//guard let windowScene = (scene as? UIWindowScene) else { return }
//let storyboard = UIStoryboard(name: "Profile", bundle: nil)
//let vc = storyboard.instantiateViewController(identifier: "ProfileNavController")
//self.window?.windowScene = windowScene
//self.window?.rootViewController = vc
//
//guard let _ = (scene as? UIWindowScene) else { return }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
