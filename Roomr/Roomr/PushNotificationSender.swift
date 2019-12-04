//
//  PushNotificationSender.swift
//  Roomr
//
//  Created by Ahmed Farooqui on 12/4/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit

class PushNotificationSender {
    func sendPushNotification(to token: String, title: String, body: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let serverKey = "AAAAfT5Bs9o:APA91bFPUT90NL75jttR-FB76D8vaqdkzVeTR-lxl_D_k0b8nO_NuhsKeqc3a0cZ2o5BE1wruX_xEthdSXBYK5ZkHiq1oK3cWxei3OFzNTE7KEORc4c9QF1yMLemlON2_jV3JIUXNUvX"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body],
                                           "data" : ["user" : "test_id"]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
