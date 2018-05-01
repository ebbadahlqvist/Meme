//
//  StorageHandler.swift
//  MemeGenerator
//
//  Created by Ebbas on 2018-04-28.
//  Copyright © 2018 enappstudio. All rights reserved.
//

import Foundation

open class StorageHandler {
    
    fileprivate static var currentInstance: StorageHandler?
    
    fileprivate let MEME_TEXTS = "MemeTexts"
    
    var memeTexts : [String:String] = [:]
    
    var storageDidChange: Bool = false
  
    fileprivate init(){}
    
    open static func getInstance() -> StorageHandler {
        if currentInstance == nil {
            currentInstance = StorageHandler()
            getInstance().setMemeTexts()
        }
        return currentInstance!
    }
    
    fileprivate func setMemeTexts()  {
        let defaults = UserDefaults.standard
        if let dMemeText = defaults.object(forKey: MEME_TEXTS) as? [String : String] {
            memeTexts = dMemeText
        } else {
            memeTexts = [:]
        }
    }
    
    func getTextForMeme(id: String) -> String {
        if let text = memeTexts[id] {
            return text
        } else {
            return ""
        }
    }
    
    func saveMemeText(memeId: String, text: String) {
        storageDidChange = true
        memeTexts[memeId] = text
        saveMemeTexts()
    }
    
    fileprivate func saveMemeTexts() {
        let defaults = UserDefaults.standard
        defaults.set(memeTexts, forKey: MEME_TEXTS)
    }
    
    func clearStorage() {
        let defaults = UserDefaults.standard
        defaults.set([:], forKey: MEME_TEXTS)
        setMemeTexts()
    }
}
