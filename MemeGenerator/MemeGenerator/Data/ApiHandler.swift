//
//  Resthandler.swift
//  MemeGenerator
//
//  Created by Ebbas on 2018-04-28.
//  Copyright © 2018 enappstudio. All rights reserved.
//

import Foundation

open class ApiHandler {
    
    fileprivate let API_PATH = "https://api.imgflip.com/"
    fileprivate let API_MEMES = "get_memes"
    
    fileprivate static var currentInstance: ApiHandler? = nil
    
    fileprivate init(){}
    
    open static func getInstance() -> ApiHandler {
        if currentInstance == nil {
            currentInstance = ApiHandler()
        }
        
        return currentInstance!
    }
    
    fileprivate func initiateRequest(for command: String) -> URLRequest? {
        guard let url = URL(string: API_PATH + command) else {
            return nil
        }
        
        let request = URLRequest(url: url)
        
        return request
    }
    
    fileprivate func validateResponseData(data: Data?, response: URLResponse?, error: Error?) -> Bool {
        guard error == nil else {
            return false
        }
        
        guard response as? HTTPURLResponse != nil else {
            return false
        }
        
        guard data != nil else {
            return false
        }
        
        return true
    }
    
    
    func getMemesFlow(completion: ((Bool, String) -> Void)?) {
        guard let request = initiateRequest(for: API_MEMES) else {
            completion?(false, "Request not working.")
            return
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            
            DispatchQueue.main.async {
                if !self.validateResponseData(data: responseData, response: response, error: responseError) {
                    completion?(false, "Invalid response.")
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let serverResponse = try decoder.decode(ServerResponse.self, from: responseData!)
                    DataHandler.getInstance().setMemes(newMemes: serverResponse.data.memes)
                    completion?(true, "")
                } catch let error {
                    completion?(false, error.localizedDescription)
                }
            }
        }
        
        task.resume()
    }
}
