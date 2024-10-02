//
//  Helpers.swift
//  TrendingMoviesTests
//
//  Created by Mohamed Sayed on 01/10/2024.
//

import Foundation

func readJSONStringFromFile(fileName: String, fileType: String = "json", bundleFor: AnyClass) -> Data? {
    let bundle = Bundle(for: bundleFor)
    guard let filePath = bundle.path(forResource: fileName, ofType: fileType) else {
        print("File not found: \(fileName).\(fileType)")
        return nil
    }
    
    do {
        let fileData = try Data(contentsOf: URL(fileURLWithPath: filePath))
        return fileData
    } catch {
        print("Error reading file: \(error.localizedDescription)")
        return nil
    }
}

