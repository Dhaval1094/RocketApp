//
//  StorageManager.swift
//  RocketApp
//
//  Created by iOS Developer on 19/06/21.
//

import Foundation
import CoreData
import UIKit

class StorageManager {
    
    class func archiveURL(path: String) -> URL? {
        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            else { return nil }
        return documentURL.appendingPathComponent(path)
    }
    
    class func archive(object: NSObject, path: String) {
        guard let dataToBeArchived = try? NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false) else {
            return
        }
        guard let archiveURL = archiveURL(path: path) else { return }
        do {
            try dataToBeArchived.write(to: archiveURL)
        } catch  {
            print(error.localizedDescription)
        }
    }

    class func unarchive(path: String, type: String) -> NSObject? {
        guard let archiveURL = archiveURL(path: path),
            let archivedData = try? Data(contentsOf: archiveURL) else { return nil }
        if type == "rocket" {
            let rocket = (try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archivedData)) as? Rocket
            return rocket
        }
        return nil
    }
    
    class func unarchiveAllLaunches() -> [Launches]? {
        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentURL, includingPropertiesForKeys: nil, options: [])
            // if you want to filter the directory contents you can do like this:
            let fileUrls = directoryContents.map{ $0.absoluteURL }
            var launches = [Launches]()
            for url in fileUrls {
                if let archivedData = try? Data(contentsOf: url) {
                    if let launch = (try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archivedData)) as? Launches {
                        launches.append(launch)
                    }
                }
            }
            return launches
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }

}
