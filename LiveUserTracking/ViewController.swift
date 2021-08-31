//
//  ViewController.swift
//  LiveUserTracking
//
//  Created by SIVA on 01/02/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.removeFilesFromPath()
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let path = paths.appending("/LocationArray.plist")
            let plistDict = NSDictionary(contentsOfFile: path)
        print(plistDict as Any)
    }

    func removeFilesFromPath() {
        let fileManager = FileManager.default
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        let documentsPath = documentsUrl.path
        do {
            if let documentPath = documentsPath {
                let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                print("all files in cache: \(fileNames)")
                for fileName in fileNames {
                    if(fileName == "LocationArray.plist") {
                        let filePathName = "\(documentPath)/\(fileName)"
                        try fileManager.removeItem(atPath: filePathName)
                    }
                }
                let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                print("all files in cache after deleting images: \(files)")
            }
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
}


