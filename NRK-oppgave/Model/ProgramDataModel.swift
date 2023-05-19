//
//  ProgramDataModel.swift
//  NRK-oppgave
//
//  Created by VP on 19/05/2023.
//

import Foundation
import UIKit

//Protocol delegate for passing data
protocol DataManagerDelegate{
    func didUpdateData(_ movie: Movie, _ imageList: [UIImage])
    func didFoundError(_ error: String)
}

struct ProgramDataModel{
    var delegate: DataManagerDelegate?
    //Fetching data
    func getData(url:String, completion: @escaping (Error?, Movie?) -> ()) {
        if let url = URL(string: url) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    completion(error, nil)
                    return
                }
                
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do  {
                        let results = try decoder.decode(Movie.self, from: safeData)
                        completion(nil, results)
                    } catch {
                        completion(error, nil)
                    }
                }
            }.resume()
        }
    }
    
    
    
    func fetchProgram(age: String) {
        let url = "https://psapi.nrk.no/tv/headliners/default?contentGroup=children&age=" + age
        let group = DispatchGroup()
        var movie: Movie?
        var movieImages = [UIImage]()
        
        group.enter()
        getData(url: url) { error, result in
            if let error = error {
                print(error)
                group.leave()
                return
            }
            if let safeData = result {
                movie = safeData
                for item in safeData.headliners {
                    if let imageURL = URL(string: item.images[0].uri) {
                        group.enter()
                        self.downloadImage(url: imageURL) { imageResult in
                            if let image = imageResult {
                                movieImages.append(image)
                            }
                            group.leave()
                        }
                    }
                }
                group.leave()
            } else {
                print("error")
                group.leave()
                return
            }
        }
        
        group.notify(queue: .main) {
            self.delegate?.didUpdateData(movie!, movieImages)

        }
    }
    
    
    
    func downloadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                  guard let data = data, error == nil else {
                      completion(nil)
                      return
                  }
                if let image = UIImage(data: data) {
                    completion(image)
                    
                } else {
                    completion(nil)
                }
            }.resume()
    }
    
    
    
}