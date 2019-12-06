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
import FirebaseMessaging
import FirebaseAuth


class HomeViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var userName_label: UILabel!
    @IBOutlet weak var userAge_label: UILabel!
    
    @IBOutlet weak var userHousingPref_label: UILabel!
    
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
    var animateCard = true // determines if koloda view should be animated when displayed
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSideMenuPreferences()
        createCurrentUser() // also loads candidates
        kolodaView.dataSource = self
        kolodaView.delegate = self
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.black,
         NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 30)!]
    } /* viewDidLoad() */
    
    
   
    
    
    func setSideMenuPreferences() {
        SideMenuController.preferences.basic.menuWidth = 250
        SideMenuController.preferences.basic.direction = .left
        SideMenuController.preferences.basic.enablePanGesture = true
        SideMenuController.preferences.basic.supportedOrientations = .portrait
        SideMenuController.preferences.basic.shouldRespectLanguageDirection = true
    } /* setSideMenuPreferences() */

    
    

    
    @IBAction func hamburger_pressed(_ sender: UIButton) {
        sideMenuController?.revealMenu()
    } /* show Side Menu */
    
    
    
    
    
    func createCurrentUser() {
        let rootRef = Database.database().reference()
        guard let current_uid = Auth.auth().currentUser?.uid else { return }
        
        rootRef.child("user").child(current_uid).observe(.value, with: { (snapshot) in
            let token = Messaging.messaging().fcmToken
            rootRef.child("user").child(current_uid).child("fcmToken").setValue(token)
            let value = snapshot.value as? NSDictionary
            let userName = value?["firstName"] as? String
            let userDOB = value?["dob"] as? String
            let userGender = value?["gender"] as? String
            let genderPref = value?["genderpref"] as? String
            let housingPref = value?["housingpref"] as? Int
            let volume = Int(value?["volume"] as? Int ?? 0)
            let cleanliness = Int(value?["cleanliness"] as? Int ?? 0)
            
            self.user_likes = value?["likes"] as? Dictionary<String, Any>
            self.user_dislikes = value?["dislikes"] as? Dictionary<String, Any>
            self.matches = value?["matches"] as? Dictionary<String, Any>
            
            
            self.curr_user = ProfileSummary(name: userName, dob: userDOB, gender: userGender, gender_pref: genderPref, housing_pref: housingPref, clean: cleanliness, vol: volume, info: nil, uid: current_uid, likesYou: false, imgIndex: 0, kv: self.kolodaView)
            self.curr_user?.push_token = token
            self.loadCandidates()
        })
    } /* createCurrentUser(): ProfileSummary for current user */

    
    
    
    
    func loadCandidates() {
        // use most recent user data from firebase
        // first call filter fxn and make sure current user not included
        let rootRef = Database.database().reference()
        
        guard let currUser = curr_user else { return }
        rootRef.child("user").observe(.value, with: { snapshot in
        guard let candidates = snapshot.children.allObjects as? [DataSnapshot] else { return }
        // Build array of candidate profiles
            for user in candidates {
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
                let info = user.childSnapshot(forPath: "bio").value as? String
                let token = user.childSnapshot(forPath: "fcmToken").value as? String
                
                // check if user liked you before
                var likesYou = false
                if (likes?[currUser.user_key] != nil) {
                    likesYou = true
                }
                    
                // create profile summary from user info (also loads images) and add to candidates
                let profile = ProfileSummary(name: userName, dob: userDOB, gender: userGender, gender_pref: userPref, housing_pref: housingPref, clean: cleanliness, vol: volume, info: info, uid: user.key, likesYou: likesYou, imgIndex: 0, kv: self.kolodaView)
                profile.push_token = token
                // filter out potentially bad matches
                if (filterPreferenceMismatches(targetUser: currUser, user: profile) == true) {
                    //profile.user_images = self.loadUserImages(userKey: profile.user_key)
                    self.candidateProfiles.append(profile)
                    self.candidateKeys.append(profile.user_key)
                }
            } // for each candidate, check compatibility with current user
        })
    } /* loadCandidates(): Load users from firebase */
    
    
    
    
    
    // change touch up inside event to event that triggers after finger lifted from tap
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: self.kolodaView) else { return }
        tapStartLocation = location
    } /* touchesBegan() */

    
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
        
        if leftTapRegion.contains(location) {
            let imgIndex = candidateProfiles[currentUserIndex].currentImgDisplayed
            if (imgIndex - 1 >= 0) {
                candidateProfiles[currentUserIndex].currentImgDisplayed -= 1
                DispatchQueue.main.async {
                    self.animateCard = false
                    self.kolodaView.reloadData()
                    self.animateCard = true
                }
            }
        } else if rightTapRegion.contains(location) {
            let imgIndex = candidateProfiles[currentUserIndex].currentImgDisplayed
            if (imgIndex + 1 < candidateProfiles[currentUserIndex].user_images.count) {
                candidateProfiles[currentUserIndex].currentImgDisplayed += 1
                DispatchQueue.main.async {
                    self.animateCard = false
                    self.kolodaView.reloadData()
                    self.animateCard = true
                }
            }
        } else if downTapRegion.contains(location) {
            showProfileSummary()
        }
    } /* touchesEnded(): on tap of lower region of koloda view, popup profile summary */
    
    
    
    func showProfileSummary() {
        
        let storyBoard = UIStoryboard(name: "HomeViewsStoryboard", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "profileSummaryViewController")
        let profile_vc = vc as! ProfileSummaryViewController
        
        let profileSummary = candidateProfiles[currentUserIndex]
        
        guard let age = profileSummary.user_age,
        let preference = profileSummary.gender_preference,
        let name = profileSummary.user_name else { return }
        
        profile_vc.user_age = "\(String(age)) years old"
        profile_vc.user_name = name
        profile_vc.user_preference = "Prefers to live with \(preference)"
        profile_vc.user_image = profileSummary.user_images[profileSummary.currentImgDisplayed]
        profile_vc.user_gender = profileSummary.user_gender
        profile_vc.user_bio = profileSummary.user_info
        
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
        self.present(popup, animated: true, completion: nil)
    } /* createMatchPopup(): Shown when there is an immediate match */
    
    
    
    
    
    func createMatchInfo(user: ProfileSummary?) -> [String : Any] {
        guard let match = user else { return ["name": "", "token": "", "wantToTalk": false, "isFriend": false, "imageURL": ""]}
        let matchInfo : [String : Any] = [
            "name": match.user_name ?? "",
            "token": "",
            "wantToTalk": false,
            "isFriend": false,
            "imageURL": match.profilePic_Url
        ]
        return matchInfo
    } /* createMatchInfo(): return dict on user info to be stored under matches */
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
        let candidate = candidateProfiles[index]
        
        if direction == .right {
            // RIGHT SWIPE: match if they also like you, otherwise add to likes (firebase)
            if (candidateProfiles[index].likesCurrentUser) { // is a match
                // store under matches for current user
                let matches_key = rootRef.child("user").child(current_uid).child("matches")
                matches_key.child(candidate.user_key).setValue(createMatchInfo(user: candidate))
                
                // for other user: move curr user from likes to matches
                let likes_key = rootRef.child("user").child(candidate.user_key).child("likes").child(current_uid)
                likes_key.removeValue()
                let other_matches_key = rootRef.child("user").child(candidate.user_key).child("matches")
                other_matches_key.child(current_uid).setValue(createMatchInfo(user: self.curr_user))
                
                // show push notification to user:
                createMatchPopup()
//                if let token = candidateProfiles[index].push_token {
//                    var sender = PushNotificationSender()
//                    sender.sendPushNotification(to: token, title: "You Got a Match on Roomr!", body: "Look under matches")
//                }
                
            } else { // is a like
                let likes_key = rootRef.child("user").child(current_uid).child("likes")
                likes_key.child(candidate.user_key).setValue(true)
            }
        } else { // LEFT SWIPE: add to dislikes
            let dislikes_key = rootRef.child("user").child(current_uid).child("dislikes")
            dislikes_key.child(candidate.user_key).setValue(true)
        }
        DispatchQueue.main.async {
            self.kolodaView.reloadData()
        }
    } /* called whenever card is swiped: store likes, dislikes or matches */


    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        currentUserIndex = -1
        userName_label.text = ""
        userAge_label.text = ""
        userHousingPref_label.text = ""
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
        return animateCard
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
            switch candidateProfiles[index].housing_preference {
            case 1:
                userHousingPref_label.text = "Looking for a room"
            case 2:
                userHousingPref_label.text = "Needs a roommate & has a room"
            case 3:
                userHousingPref_label.text = "Looking for a room & roommate"
            default:
                userHousingPref_label.text = ""
            }
        }
    } /* called after card is shown (animation complete) */


    func koloda(_ koloda: KolodaView, shouldDragCardAt index: Int) -> Bool {
        return true // card moves in direction of drag
    } /* called when user begins dragging card */

} /* extend KolodaViewDelegate */






extension HomeViewController: KolodaViewDataSource {
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return candidateProfiles.count
    } /* return # items in koloda view */


    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let imgIndex = candidateProfiles[index].currentImgDisplayed
        let imgCount = candidateProfiles[index].user_images.count
        var view : UIImageView
        
        // load user image to koloda view if any existing in user images
        if ((imgCount > 0) && (0 ... (imgCount - 1) ~= imgIndex))  {
            view = UIImageView(image: candidateProfiles[index].user_images[imgIndex])
            view.layer.cornerRadius = 5
            view.clipsToBounds = true
            return view
        } else {
            return UIView()
        }
    } /* return view to display at specific index */


    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    } /* manage swipe animation duration */

} /* extend KolodaViewDataSource */
