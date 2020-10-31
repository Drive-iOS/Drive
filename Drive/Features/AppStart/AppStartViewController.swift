//
//  AppStartViewController.swift
//  Drive
//
//  Created by Amanuel Ketebo on 10/30/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import UIKit

class AppStartViewController: UIViewController, VideoViewDelegate {
    @IBOutlet var videoView: VideoView!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVideoView()
        playVideo()
    }

    private func setUpVideoView() {
        videoView.delegate = self
    }

    private func playVideo() {
        guard let startVideoPath = Bundle.main.path(forResource: "miata-start-video", ofType: "mov") else {
            return
        }

        videoView.play(url: URL(fileURLWithPath: startVideoPath))
    }

    func didReachEndOfVideo() {
        UIApplication.shared.windows.first?.rootViewController = DriveCoordinator.fromStoryboard()
    }
}
