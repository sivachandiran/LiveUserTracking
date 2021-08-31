//
//  LocationManager.swift
//  LiveUserTracking
//
//  Created by SIVA on 02/02/21.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {

    var locationManager: CLLocationManager?
    
    var myLocation : CLLocationCoordinate2D!
    var myLocationAccuracy : CLLocationAccuracy!
    
    var myLocationDictInPlist : NSMutableDictionary = NSMutableDictionary()
    var myLocationArrayInPlist : NSMutableArray = []

    var afterResume : Bool!
    
    
    //Create instance
    class var sharedInstance: LocationManager {
        struct Static {
            static let instance: LocationManager = LocationManager()
        }
        return Static.instance
    }
    
    func startMonitoringLocation() {
        locationManager = CLLocationManager()

        if((locationManager) != nil) {
            locationManager?.stopMonitoringSignificantLocationChanges()
        }
        print("Start location")
        locationManager!.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager!.activityType = .otherNavigation
            locationManager!.startMonitoringSignificantLocationChanges()
        }        
    }
    
    func restartMonitoringLocation() {
        locationManager?.stopMonitoringSignificantLocationChanges()
        locationManager!.requestAlwaysAuthorization()
        locationManager!.startMonitoringSignificantLocationChanges()
    }
    
    // MARK: - CLLocationManager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        for i in 0..<locations.count {
            let newLocation : CLLocation = locations[i]
            let theLocation : CLLocationCoordinate2D = newLocation.coordinate
            let theAccuracy : CLLocationAccuracy = newLocation.horizontalAccuracy
            myLocation = theLocation
            myLocationAccuracy = theAccuracy
        }
        self.addLocation(toPList: true)
    }
    
    //MARK - Plist helper methods
    func addLocation(toPList fromResume: Bool) {
        print("addLocationToPList")
        myLocationDictInPlist = NSMutableDictionary()
        myLocationDictInPlist.setObject(NSNumber(value: myLocation.latitude), forKey: "Latitude" as NSCopying)
        myLocationDictInPlist.setObject(NSNumber(value: myLocation.longitude), forKey: "Longitude" as NSCopying)
        myLocationDictInPlist.setObject(NSNumber(value: myLocationAccuracy), forKey: "Accuracy" as NSCopying)
        if fromResume {
            myLocationDictInPlist.setObject("YES", forKey: "AddFromResume" as NSCopying)
        } else {
            myLocationDictInPlist.setObject("NO", forKey: "AddFromResume" as NSCopying)
        }
        myLocationDictInPlist.setObject(Date(), forKey: "Time" as NSCopying)
        saveLocationsToPlist()
    }
    
    func saveLocationsToPlist() {
        let plistName = "LocationArray.plist"
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).map(\.path)
        let docDir = paths[0]
        let fullPath = "\(docDir)/\(plistName)"

        var savedProfile = NSMutableDictionary(contentsOfFile: fullPath)//NSDictionary(contentsOfFile: fullPath) as Dictionary?
        if savedProfile == nil {
            savedProfile = [:]
            myLocationArrayInPlist.removeAllObjects()
        } else {
            myLocationArrayInPlist = savedProfile!["LocationArray"] as! NSMutableArray
        }
        myLocationArrayInPlist.add(myLocationDictInPlist) //.append(myLocationDictInPlist)
        savedProfile!["LocationArray"] = myLocationArrayInPlist

        if !(savedProfile!.write(toFile: fullPath, atomically: false)) {
            print("Couldn't save LocationArray.plist")
        }
    }
}
