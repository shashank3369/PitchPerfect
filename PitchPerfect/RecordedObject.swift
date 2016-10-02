//
//  RecordedObject.swift
//  PitchPerfect
//
//  Created by Kothapalli on 8/30/16.
//  Copyright © 2016 Kothapalli. All rights reserved.
//

import Foundation

class RecordedObject: NSObject {
    var filePathURL: URL!
    var title: String!
    
    init(url: URL, name: String) {
        filePathURL = url
        title = name
    }
    
}
