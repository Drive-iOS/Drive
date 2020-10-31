//
//  VideoView.swift
//  Drive
//
//  Created by Amanuel Ketebo on 10/31/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import AVKit

protocol VideoViewDelegate: AnyObject {
    func didReachEndOfVideo()
}

class VideoView: UIView {
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?

    weak var delegate: VideoViewDelegate?

    func play(url: URL) {
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = bounds
        playerLayer?.videoGravity = .resizeAspectFill

        guard let playerLayer = playerLayer else {
            return
        }

        layer.addSublayer(playerLayer)
        player?.play()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReachEndOfVideo),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
    }

    @objc private func didReachEndOfVideo() {
        delegate?.didReachEndOfVideo()
    }
}
