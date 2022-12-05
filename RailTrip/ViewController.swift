//
//  ViewController.swift
//  RailTrip
//
//  Created by Trin Pongsri on 4/12/2565 BE.
//

//
//  ViewController.swift
//  Test047
//
//  Created by Trin Pongsri on 28/11/2565 BE.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playBackgroundVideo()
        // Do any additional setup after loading the view.
    }
    
    //Video Background
    func playBackgroundVideo() {
        let path = Bundle.main.path(forResource: "video", ofType: "mp4")
        player = AVPlayer(url: URL(fileURLWithPath: path!))
        player!.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.insertSublayer(playerLayer, at: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player!.currentItem)
        player!.seek(to: CMTime.zero)
        player!.play()
        //self.player?.isMuted = true
    }
    
    @objc func  playerItemDidReachEnd(){
        player!.seek(to: CMTime.zero)
    }
    
    
    @IBAction func Test(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "Login")
        
        
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.modalTransitionStyle = .crossDissolve

        show(secondVC, sender: self)
    }
    
    @IBAction func showLoginViewController(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "LoginViewController_ID")
        
        
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.modalTransitionStyle = .crossDissolve

        show(secondVC, sender: self)
    }
    
    //Hello
}
