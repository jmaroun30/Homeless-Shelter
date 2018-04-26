//
//  pinAnnotation.swift
//  Homeless Shelter
//
//  Created by Johnny Maroun on 4/25/18.
//  Copyright © 2018 MarounApps. All rights reserved.
//

import MapKit

class pinAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title : String, subtitle : String, coordinate : CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
