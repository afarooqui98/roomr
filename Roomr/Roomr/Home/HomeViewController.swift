//
//  HomeViewController.swift
//  Roomr
//
//  Created by Katie Kwak on 11/13/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit
import Koloda
import SideMenuSwift
import PopupDialog
import FirebaseDatabase
import Firebase


class HomeViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var userName_label: UILabel!
    @IBOutlet weak var userAge_label: UILabel!
    
    @IBOutlet weak var userDistance_label: UILabel!
    
    var curr_user: ProfileSummary?
    // store current user's previous likes, dislikes, matches from firebase
    var user_likes : Dictionary<String, Any>?
    var user_dislikes : Dictionary<String, Any>?
    var matches : Dictionary<String, Any>?
    
    var candidateProfiles = [ProfileSummary]()
    var candidateKeys = [String]()
    var potential_roommates : [DataSnapshot]?
    var currentUserIndex: Int = -1 // keep track of index of card user is viewing
    var tapStartLocation: CGPoint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSideMenuPreferences()
        createCurrentUser() // also loads candidates
        kolodaView.dataSource = self
        kolodaView.delegate = self
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.black,
         NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 30)!]
        
        // do this in background?
        // let potentials = translateCSVToUser()
        //print(filterPreferenceMismatches(targetUser: potentials[0], users: potentials))
    } /* viewDidLoad() */
    
    
    
    func setSideMenuPreferences() {
        SideMenuController.preferences.basic.menuWidth = 250
        //SideMenuController.preferences.basic.statusBarBehavior = .hideOnMenu
        //SideMenuController.preferences.basic.position = .below
        SideMenuController.preferences.basic.direction = .left
        SideMenuController.preferences.basic.enablePanGesture = true
        SideMenuController.preferences.basic.supportedOrientations = .portrait
        SideMenuController.preferences.basic.shouldRespectLanguageDirection = true
    } /* setSideMenuPreferences() */

    
    
    
    @IBAction func hamburger_pressed(_ sender: UIButton) {
        sideMenuController?.revealMenu()
    }
    
    
    func createCurrentUser() {
        let rootRef = Database.database().reference()
        guard let current_uid = Auth.auth().currentUser?.uid else { return }
        
        rootRef.child("user").child(current_uid).observe(.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let userName = value?["firstName"] as? String
            let userDOB = value?["dob"] as? String
            let userGender = value?["gender"] as? String
            let genderPref = value?["genderpref"] as? String
            let housingPref = value?["housingpref"] as? Int
            let volume = Int(value?["volume"] as? Double ?? 0.0)
            let cleanliness = Int(value?["cleanliness"] as? Double ?? 0.0)
            
            self.user_likes = value?["likes"] as? Dictionary<String, Any>
            self.user_dislikes = value?["dislikes"] as? Dictionary<String, Any>
            self.matches = value?["matches"] as? Dictionary<String, Any>
            
            var userImage : UIImage?
            if (userGender == "Woman") {
                userImage = UIImage(named: "Home_PotentialMatches/Aria")
            } else {
                userImage = UIImage(named: "Home_PotentialMatches/James")
            }
            
            self.curr_user = ProfileSummary(image: userImage, name: userName, dob: userDOB, gender: userGender, gender_pref: genderPref, housing_pref: housingPref, clean: cleanliness, vol: volume, pics: [nil], info: nil, uid: current_uid, likesYou: false)
            self.loadCandidates()
        })
    } /* createCurrentUser(): ProfileSummary for current user */
    
    
    
    
    func loadCandidates() {
        
        // use most recent user data from firebase
        // first call filter fxn and make sure current user not included
        let rootRef = Database.database().reference()
        guard let current_uid = Auth.auth().currentUser?.uid else { return }
        
        guard let currUser = curr_user else { return }
        rootRef.child("user").observe(.value, with: { snapshot in
        guard let candidates = snapshot.children.allObjects as? [DataSnapshot] else { return }
        // Build array of candidate profiles
            for user in candidates {
                print("\(user.key) and current key: \(currUser.user_key)")
                
                // if candidate was already matched/liked/disliked with/by user or loaded in card view, don't include
                if ((self.user_likes?[user.key] != nil) ||
                    (self.user_dislikes?[user.key] != nil) ||
                    (self.matches?[user.key] != nil) ||
                    (self.candidateKeys.contains(user.key))) {
                    continue
                }
                        
                // extract user info
                let userName = user.childSnapshot(forPath: "firstName").value as? String
                let userDOB = user.childSnapshot(forPath: "dob").value as? String
                let userGender = user.childSnapshot(forPath: "gender").value as? String
                let userPref = user.childSnapshot(forPath: "genderpref").value as? String
                let housingPref = user.childSnapshot(forPath: "housingpref").value as? Int
                let volume = Int(user.childSnapshot(forPath: "volume").value as? Double ?? 0.0)
                let cleanliness = Int(user.childSnapshot(forPath: "cleanliness").value as? Double ?? 0.0)
                let likes = user.childSnapshot(forPath: "likes").value as? Dictionary<String, Any>
                
                var likesYou = false
                if (likes?[currUser.user_key] != nil) {
                    likesYou = true
                }
                
                // FIXME: change user image to url URL: (String)
                var userImage : UIImage?
                switch userGender {
                case "Woman":
                    userImage = UIImage(named: "Home_PotentialMatches/Aria")
                case "Man":
                    userImage = UIImage(named: "Home_PotentialMatches/James")
                default:
                    print("could not get user image")
                    return
                }
                    
                // create profile summary from user info and add to candidates
                let profile = ProfileSummary(image: userImage, name: userName, dob: userDOB, gender: userGender, gender_pref: userPref, housing_pref: housingPref, clean: cleanliness, vol: volume, pics: [nil], info: nil, uid: user.key, likesYou: likesYou)
                if (filterPreferenceMismatches(targetUser: currUser, user: profile) == true) {
                    self.candidateProfiles.append(profile)
                    self.candidateKeys.append(profile.user_key)
                }
            } // for each candidate, check compatibility with current user
            DispatchQueue.main.async {
                self.kolodaView.reloadData()
            }
        })
        //kolodaView.reloadCardsInIndexRange(Range<Int>(0, candidateProfiles.count))
    } /* loadCandidates(): Load users from firebase */
    
    
    // change touch up inside event to event that triggers after finger lifted from tap
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: self.kolodaView) else { return }
        tapStartLocation = location
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: self.kolodaView) else { return }
        
        if tapStartLocation == nil || location != tapStartLocation || currentUserIndex == -1 {
            return
        } // if user dragged card (tapStart != tap lift) or no user cards available
        
        let height = kolodaView.frame.height
        let width = kolodaView.frame.width
        
        let leftTapRegion = CGRect(x: 0, y: 0, width: (0.5 * width), height: (0.75 * height))
        let rightTapRegion = CGRect(x: (0.5 * width), y: 0, width:(0.5 * width), height: (0.75 * height))
        let downTapRegion = CGRect(x: 0, y: (0.75 * height), width: width, height: (0.25 * height))
        
        //if !kolodaView.frame.contains(location) {
            //print("Tapped inside the view")
        if leftTapRegion.contains(location) {
            print("left region tapped")
        } else if rightTapRegion.contains(location) {
            print("right region tapped")
        } else if downTapRegion.contains(location) {
            showProfileSummary()
            print("down region tapped")
        }
    } /* touchesEnded(): on tap of lower region of koloda view, popup profile summary */
    
    
    
    func showProfileSummary() {
        
        let storyBoard = UIStoryboard(name: "HomeViewsStoryboard", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "profileSummaryViewController")
        let profile_vc = vc as! ProfileSummaryViewController
        
        let profileSummary = candidateProfiles[currentUserIndex]
        
        guard let age = profileSummary.user_age,
            let preference = profileSummary.gender_preference,
            let pic = profileSummary.user_image,
            let name = profileSummary.user_name else { return }
        
        profile_vc.user_age = "\(String(age)) years old"
        profile_vc.user_name = name
        profile_vc.user_preference = "Prefers to live with \(preference)"
        profile_vc.user_image = pic
        
        
        profile_vc.modalPresentationStyle = .pageSheet
        self.present(profile_vc, animated: true, completion: nil)

    } /* showProfileSummary(): display popup with user information */
    
    
    func createMatchPopup() {
        // Customize dialog appearance
        let pv = PopupDialogDefaultView.appearance()
        pv.titleFont    = UIFont(name: "Lato-Bold", size: 16)!
        pv.titleColor   = .white
        pv.messageFont  = UIFont(name: "Lato-Regular", size: 14)!
        pv.messageColor = UIColor(white: 0.8, alpha: 1)

        // Customize the container view appearance
        let pcv = PopupDialogContainerView.appearance()
        pcv.backgroundColor = UIColor(red:0.23, green:0.23, blue:0.27, alpha:1.00)
        pcv.cornerRadius    = 2
        pcv.shadowEnabled   = true
        pcv.shadowColor     = .black

        // Customize overlay appearance
        let ov = PopupDialogOverlayView.appearance()
        ov.blurEnabled     = true
        ov.blurRadius      = 30
        ov.liveBlurEnabled = true
        ov.opacity         = 0.7
        ov.color           = .black

        // Customize default button appearance
        let db = DefaultButton.appearance()
        db.titleFont      = UIFont(name: "Lato-Regular", size: 14)!
        db.titleColor     = .white
        db.buttonColor    = UIColor(red:0.25, green:0.25, blue:0.29, alpha:1.00)
        db.separatorColor = UIColor(red:0.20, green:0.20, blue:0.25, alpha:1.00)
        
        let title = "It's a match!"
        let message = "You both liked each other. You can see them under 'Matches' now!"
        
        let popup = PopupDialog(title: title, message: message)
        let ok_button = DefaultButton(title: "Ok", dismissOnTap: false) {}
        
        popup.addButton(ok_button)
        self.present(popup, animated: true, completion: nil)
    } /* createMatchPopup(): Shown when there is an immediate match */

} /* HomeViewController: Browse potential matches & navigate to other components */



extension HomeViewController: KolodaViewDelegate {
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.left, .right]
    } /* allowed directions to swipe card */



    func koloda(_ koloda: KolodaView, shouldSwipeCardAt index: Int, in direction: SwipeResultDirection) -> Bool {
        return true
    } /* called before card swiped; allow/deny this swipe */



    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        let rootRef = Database.database().reference()
        guard let current_uid = Auth.auth().currentUser?.uid else { return }
        
        // FIXME: maybe remove profile from candidateProfiles after?
        if direction == .right {
            // right swipe: match if they also like you, otherwise add to likes (firebase)
            if (candidateProfiles[index].likesCurrentUser) {
                let matches_key = rootRef.child("user").child(current_uid).child("matches")
                matches_key.child(candidateProfiles[index].user_key).setValue(true)
                createMatchPopup()
            } else {
                let likes_key = rootRef.child("user").child(current_uid).child("likes")
                likes_key.child(candidateProfiles[index].user_key).setValue(true)
            }
            
        } else { // left swipe: add to dislikes
            let dislikes_key = rootRef.child("user").child(current_uid).child("dislikes")
            dislikes_key.child(candidateProfiles[index].user_key).setValue(true)
        }
        DispatchQueue.main.async {
            self.kolodaView.reloadData()
        }
    } /* called whenever card is swiped */



    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        currentUserIndex = -1
        userName_label.text = ""
        userAge_label.text = ""
        userDistance_label.text = ""
        //candidateProfiles.removeAll()
        DispatchQueue.main.async {
            self.kolodaView.reloadData()
        }
    } /* called when no more cards to display */



    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
//        let alert = UIAlertController(title: "Congratulation!", message: "Now you're \(index)", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        self.present(alert, animated: true)
    } /* called when a card is tapped */



    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return true // apply appear animation
    } /* called when card is displayed */



    func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
        return true // move background card when front card is dragged
    } /* called @start of front card swiping */



    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return true // make card below current card transparent
    } /* called after swiping */



    func koloda(_ koloda: KolodaView, draggedCardWithPercentage finishPercentage: CGFloat, in direction: SwipeResultDirection) {

    } /* called when card dragging event recognized */



    func kolodaSwipeThresholdRatioMargin(_ koloda: KolodaView) -> CGFloat? {
        return nil // threshold set to half the distance
    } /* % of distance between center of card & edge needed to trigger a swipe*/



    func kolodaDidResetCard(_ koloda: KolodaView) {

    } /* called after resetting a card */



    func koloda(_ koloda: KolodaView, didShowCardAt index: Int) {
        currentUserIndex = index
        userName_label.text = candidateProfiles[index].user_name
        
        if let age = candidateProfiles[index].user_age {
        userAge_label.text = "\(String(age)) yrs old"
        }
    } /* called after card is shown (animation complete) */



    func koloda(_ koloda: KolodaView, shouldDragCardAt index: Int) -> Bool {
        return true // card moves in direction of drag
        // return false: card doesn't move
    } /* called when user begins dragging card */

} /* extend KolodaViewDelegate */








extension HomeViewController: KolodaViewDataSource {
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return candidateProfiles.count
    } /* return # items in koloda view */



    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let view = UIImageView(image: candidateProfiles[index].user_image)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true

        return view
    } /* return view to display at specific index */



//    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
//        // set custom overlay action on swiping:
//            // override didSet of overlayState property in OverlayView
//        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
//    } /* return view for card overlay @index*/



    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    } /* manage swipe animation duration */
    
    
    
} /* extend KolodaViewDataSource */
