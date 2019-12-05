//
//  TabController.swift
//  Roomr
//
//  Created by Ryan on 11/18/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit

class TabController: UITabBarController {

    @IBInspectable var defaultIndex: Int = 0
    var indexNum = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
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
