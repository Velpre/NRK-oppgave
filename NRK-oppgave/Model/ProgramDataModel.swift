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
    func didUpdateData(_ movie: [Item], _ imageList: [UIImage])
    func didFoundError(_ error: String)
}

//Protocol delegate for passing video data
protocol VideoManagerDelegate{
    func didUpdateVideo(_ video: String)
}

struct ProgramDataModel{
    var delegate: DataManagerDelegate?
    var videoDelegate: VideoManagerDelegate?
    
    //function thats fetch data and use generic
    func fetchData<T: Codable>(url: String, completion: @escaping (Error?, T?) -> ()) {
        if let url = URL(string: url) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    completion(error, nil)
                    self.delegate?.didFoundError(error!.localizedDescription)
                    return
                }

                if let safeData = data {
                    let decoder = JSONDecoder()
                    do  {
                        let results = try decoder.decode(T.self, from: safeData)
                        completion(nil, results)
                    } catch {
                        completion(error, nil)
                        self.delegate?.didFoundError(error.localizedDescription)
                    }
                }
            }.resume()
        }
    }

    
    func fetchProgram(age: String) {
        let url = "https://psapi.nrk.no/tv/headliners/default?contentGroup=children&age=" + age
        let group = DispatchGroup()
        var movie = [Item]()
        var movieImages = [UIImage]()
        
        group.enter()
        fetchData(url: url) { (error: Error?, result: Movie?) in
            if let error = error {
                self.delegate?.didFoundError(error.localizedDescription)
                group.leave()
                return
            }
            if let safeData = result {
                for item in safeData.headliners {
                    movie.append(item)
                    
                    if let imageURL = URL(string: item.images[3].uri) {
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
                self.delegate?.didFoundError(error!.localizedDescription)
                group.leave()
                return
            }
        }
        group.notify(queue: .main) {
                self.delegate?.didUpdateData(movie, movieImages)
        }
    }
    
    func fetchVideoInfo(path:String){
        let url = "https://psapi.nrk.no" + path
        var formatedVideo:String?
        
        fetchData(url: url) { (error: Error?, result: Video?)  in
            if let error = error {
                self.delegate?.didFoundError(error.localizedDescription)
                return
            }
            if let safeData = result {
                for video in safeData.playable.assets {
                    if video.format == "HLS"{
                        formatedVideo = video.url
                        self.videoDelegate?.didUpdateVideo(formatedVideo!)
                    }else{
                        self.delegate?.didFoundError("Video have bad format")
                    }
                }

            }else{
                self.delegate?.didFoundError(error!.localizedDescription)
                return
            }
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
