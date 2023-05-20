//
//  PlayVideoViewController.swift
//  NRK-oppgave
//
//  Created by VP on 20/05/2023.
//

import UIKit
import AVKit

class PlayVideoViewController: UIViewController {
    
    var href: String!
    var videoUrl: String!

    var programDataModel = ProgramDataModel()
    
    @IBOutlet weak var playerContainerView: UIView!
    var playerViewController: AVPlayerViewController!


    override func viewDidLoad() {
        super.viewDidLoad()
        programDataModel.videoDelegate = self
        programDataModel.fetchVideoInfo(path: href)
    }
    
    func setupPlayer() {
            // Create an instance of AVPlayerViewController and adding to playerContainerView
            playerViewController = AVPlayerViewController()
            addChild(playerViewController)
            playerViewController.view.frame = playerContainerView.bounds
            playerContainerView.addSubview(playerViewController.view)
            playerViewController.didMove(toParent: self)

            guard let videoUrlString = videoUrl, let videoUrl = URL(string: videoUrlString) else {
                // Handle the case where videoURL is nil or not a valid URL
                return
            }

            let player = AVPlayer(url: videoUrl)
            playerViewController.player = player
            playVideo()
        }
    
    func playVideo() {
         playerViewController.player?.play()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playerViewController.player?.pause()

    }
}

extension PlayVideoViewController: VideoManagerDelegate{
    func didUpdateVideo(_ video: String) {
        videoUrl = video
        DispatchQueue.main.async {
            //Setting up player after fetching data
            self.setupPlayer()
        }
    }

}
