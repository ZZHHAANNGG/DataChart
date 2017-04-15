//
//  Model.swift
//  Chart
//
//  Created by Ted Zhang on 4/14/17.
//  Copyright © 2017 Ted Zhang. All rights reserved.
//

import Foundation
import Gloss

class ChartDataModel: Glossy {
    var start:Double?
    var ftp:Double?
    
    required init?(json: JSON) {
        self.start = "start" <~~ json
        self.ftp = "ftp" <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "start" ~~> self.start,
            "ftp" ~~> self.ftp
            ])
    }
}
