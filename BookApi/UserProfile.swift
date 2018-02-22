//
//  UserProfile.swift
//  BookApi
//
//  Created by Alexander Yakovenko on 2/22/18.
//  Copyright © 2018 Alexander Yakovenko. All rights reserved.
//

import Foundation

public struct UserProfile {
    static var shared = UserProfile()
    public var name: String = "Not name"
    public var email: String = "Not email"
    public var urlPicture: String = "Not url"
    
    var booksBasket: [JSON.Items] = []
    
    
}
