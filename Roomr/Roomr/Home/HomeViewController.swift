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
import FirebaseDatabase
import Firebase


class HomeViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var userName_label: UILabel!
    @IBOutlet weak var userAge_label: UILabel!
    
    @IBOutlet weak var userDistance_label: UILabel!
    
    var likedCandidates = [ProfileSummary]()
    var dislikedCandidates = [ProfileSummary]()

    var candidateProfiles = [ProfileSummary]()
    var potential_roommates : [DataSnapshot]?
    var currentUserIndex: Int = -1 // keep track of index of card user is viewing
    var tapStartLocation: CGPoint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSideMenuPreferences()
        loadCandidates()
        kolodaView.dataSource = self
        kolodaView.delegate = self
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.black,
         NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 30)!]
        
        // do this in background?
//        let potentials = translateCSVToUser()
//        print(filterPreferenceMismatches(targetUser: potentials[0], users: potentials))
        print("DONE")
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
    
    
    func loadCandidates() {
        // use most recent user data from firebase
        // first call filter fxn and make sure current user not included
        let rootRef = Database.database().reference()
        rootRef.child("user").observe(.value, with: { snapshot in
            guard let candidates = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            // Build array of candidate profiles
            for user in candidates {
                // extract user info
                let userName = user.childSnapshot(forPath: "firstName").value as? String
                let userDOB = user.childSnapshot(forPath: "dob").value as? String
                let userGender = user.childSnapshot(forPath: "gender").value as? String
                let userPref = user.childSnapshot(forPath: "genderpref").value as? String
                
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
                let profile = ProfileSummary(image: userImage, name: userName, dob: userDOB, gender: userGender, gender_pref: userPref, housing_pref: nil, clean: nil, vol: nil, pics: [nil], info: nil, uid: user.key)
                self.candidateProfiles.append(profile)
            }
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
        profile_vc.user_preference = "Likes \(preference)"
        profile_vc.user_image = pic
        
        
        profile_vc.modalPresentationStyle = .pageSheet
        self.present(profile_vc, animated: true, completion: nil)

    } /* showProfileSummary(): display popup with user information */

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
        if direction == .right {
            guard let current_uid = Auth.auth().currentUser?.uid else { return }
            let key = rootRef.child("user").child(current_uid).child("likes")
            key.child(candidateProfiles[index].user_key).setValue(true)
            self.likedCandidates.append(candidateProfiles[index])
        } else {
            self.dislikedCandidates.append(candidateProfiles[index])
        }
    } /* called whenever card is swiped */



    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        currentUserIndex = -1
        userName_label.text = ""
        userAge_label.text = ""
        userDistance_label.text = ""
        candidateProfiles = likedCandidates
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
