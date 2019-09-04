//
//  NetworkClient.swift
//  ChuckJug
//
//  Created by Ananta Shahane on 04/09/19.
//  Copyright © 2019 Ananta Shahane. All rights reserved.
//

import Foundation

func GetJoke(_ category : String?) -> (Joke?) {
    var url : URL!
    let group = DispatchGroup()
    
    group.enter()
    
    if let category = category {
        url = URL(string: "https://api.chucknorris.io/jokes/random?category=\(category)")!
    } else {
        url = URL(string: "https://api.chucknorris.io/jokes/random")!
    }
    var returnJoke : Joke?
    URLSession.shared.dataTask(with: url) {(data, response, error) in
        if let error = error {
            print( "Fetch error: \(error.localizedDescription) \n Response type: \(String(describing: response))")
            return
        }
        if let data = data {
            let decoder = JSONDecoder()
            do {
                returnJoke = try decoder.decode(Joke.self, from: data)
            }
            catch let err {
                print("Decoding/Saving error: \(err.localizedDescription)")
            }
            
        }
        group.leave()
        }.resume()
    
    group.wait()
    return returnJoke
}

func GetCategories() -> [String]? {
    var categories : [String]?
    let group = DispatchGroup()
    group.enter()
    let url = URL(string: "https://api.chucknorris.io/jokes/categories")
    if let url = url {
        URLSession.shared.dataTask(with: url) {(data, response, err) in
            if let err = err {
                print("error: \(err.localizedDescription) \n response : \(String(describing: response))")
                return
            }
            if let data = data {
                do {
                    categories = try JSONSerialization.jsonObject(with: data, options: []) as? [String] ?? [String]()
                    categories?.append("unknown")
                } catch let err {
                    print("Serialisation Error: \(err.localizedDescription)")
                }
            }
            group.leave()
            }.resume()
    }
    group.wait()
    return categories
}
