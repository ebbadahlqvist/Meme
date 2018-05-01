//
//  DataHandler.swift
//  MemeGenerator
//
//  Created by Ebbas on 2018-04-28.
//  Copyright © 2018 enappstudio. All rights reserved.
//

import UIKit
import CoreLocation

open class DataHandler {
    
    fileprivate static var currentInstance: DataHandler?
    
    fileprivate var memes: [Meme] = []
  
    fileprivate init(){}
    
    open static func getInstance() -> DataHandler {
        if currentInstance == nil {
            currentInstance = DataHandler()
        }
        
        return currentInstance!
    }
    
    // MARK: - Memes
    func getMemes() -> [Meme] {
        return memes.sorted{ $0.name.lowercased() < $1.name.lowercased() }
    }
    
    func getMemeWith(id: String) -> Meme? {
        if let index = memes.index(where: {$0.id == id}) {
            return memes[index]
        }
        return nil
    }
    
    func setMemes(newMemes: [Meme]) {
        memes = newMemes
    }
}
