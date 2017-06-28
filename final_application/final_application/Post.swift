//
//  Post.swift
//  final_application
//
//  Created by Cheng Enzo on 2017/6/4.
//  Copyright © 2017年 Cheng Enzo. All rights reserved.
//

import UIKit

class Post: NSObject {
    var author: String!
    var likes: Int!
    var pathToImage: String!
    var userID: String!
    var postID: String!
    var postTime: String!
    
    var peopleWhoLike:[String] = [String]()

}
