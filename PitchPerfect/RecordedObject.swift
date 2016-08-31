//
//  RecordedObject.swift
//  PitchPerfect
//
//  Created by Kothapalli on 8/30/16.
//  Copyright © 2016 Kothapalli. All rights reserved.
//

import Foundation

class RecordedObject: NSObject {
    var filePathURL: NSURL!
    var title: String!
    
    init(url: NSURL, name: String) {
        filePathURL = url
        title = name
    }
    
}