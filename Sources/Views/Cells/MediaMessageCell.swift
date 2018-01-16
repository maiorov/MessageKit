/*
 MIT License

 Copyright (c) 2017 MessageKit

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit

open class MediaMessageCell: MessageCollectionViewCell<UIImageView> {
    open override class func reuseIdentifier() -> String { return "messagekit.cell.mediamessage" }

    // MARK: - Properties

    open lazy var playButtonView: PlayButtonView = {
        let playButtonView = PlayButtonView()
        playButtonView.frame.size = CGSize(width: 35, height: 35)
        return playButtonView
    }()
    
    open lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.isHidden = true
        return activityIndicatorView
    }()
    
    open lazy var progressView: UIProgressView = {
        let progressView = UIProgressView() // UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        progressView.trackTintColor = UIColor.clear
        return progressView
    }()
    
    open lazy var quantityLabel: UILabel = {
        let quantityLabel = UILabel()
        quantityLabel.textAlignment = .center
        quantityLabel.textColor = UIColor.white
        quantityLabel.font = UIFont.italicSystemFont(ofSize: 28)
        quantityLabel.backgroundColor = UIColor(white: 0.6, alpha: 0.4)
        quantityLabel.layer.cornerRadius = 5
        quantityLabel.layer.borderWidth = 1
        quantityLabel.layer.borderColor = UIColor(white: 0.7, alpha: 1.0).cgColor
        return quantityLabel
    }()
    
    open lazy var mediaStatusLabel: UILabel = {
        let mediaStatusLabel = UILabel()
        mediaStatusLabel.textAlignment = .center
        mediaStatusLabel.textColor = UIColor.darkGray
        mediaStatusLabel.font = UIFont.systemFont(ofSize: 14)
        //mediaStatusLabel.backgroundColor = UIColor(white: 0.6, alpha: 0.4)
        //mediaStatusLabel.layer.cornerRadius = 5
        //mediaStatusLabel.layer.borderWidth = 1
        //mediaStatusLabel.layer.borderColor = UIColor(white: 0.7, alpha: 1.0).cgColor
        return mediaStatusLabel
    }()

    // MARK: - Methods

    private func setupConstraints() {
        playButtonView.translatesAutoresizingMaskIntoConstraints = false

        let centerX = playButtonView.centerXAnchor.constraint(equalTo: messageContainerView.centerXAnchor)
        let centerY = playButtonView.centerYAnchor.constraint(equalTo: messageContainerView.centerYAnchor)
        let width = playButtonView.widthAnchor.constraint(equalToConstant: playButtonView.bounds.width)
        let height = playButtonView.heightAnchor.constraint(equalToConstant: playButtonView.bounds.height)
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        let activityIndicatorCenterX = activityIndicatorView.centerXAnchor.constraint(equalTo: messageContainerView.centerXAnchor)
        let activityIndicatorCenterY = activityIndicatorView.centerYAnchor.constraint(equalTo: messageContainerView.centerYAnchor)
        
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let quantityLabelCenterX = quantityLabel.centerXAnchor.constraint(equalTo: messageContainerView.centerXAnchor)
        let quantityLabelCenterY = quantityLabel.centerYAnchor.constraint(equalTo: messageContainerView.centerYAnchor)
        let quantityLabelWidth = quantityLabel.widthAnchor.constraint(equalToConstant: 100)
        let quantityLabelHeight = quantityLabel.heightAnchor.constraint(equalToConstant: 100)
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        let progressViewCenterX = progressView.centerXAnchor.constraint(equalTo: messageContainerView.centerXAnchor)
        let progressViewCenterY = progressView.centerYAnchor.constraint(equalTo: messageContainerView.centerYAnchor)
        progressViewCenterY.constant = 20
        let progressViewWidth = progressView.widthAnchor.constraint(equalTo: messageContainerView.widthAnchor)
        progressViewWidth.constant = -50
        let progressViewHeight = progressView.heightAnchor.constraint(equalToConstant: 2)
        
        mediaStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        let mediaStatusLabelCenterX = mediaStatusLabel.centerXAnchor.constraint(equalTo: messageContainerView.centerXAnchor)
        let mediaStatusLabelCenterY = mediaStatusLabel.centerYAnchor.constraint(equalTo: messageContainerView.centerYAnchor)
        mediaStatusLabelCenterY.constant = -30
        let mediaStatusLabelWidth = mediaStatusLabel.widthAnchor.constraint(equalTo: messageContainerView.widthAnchor)
        mediaStatusLabelWidth.constant = -50
        let mediaStatusLabelHeight = mediaStatusLabel.heightAnchor.constraint(equalToConstant: 100)
        
        NSLayoutConstraint.activate([centerX, centerY, width, height,
                                     activityIndicatorCenterX, activityIndicatorCenterY,
                                     quantityLabelCenterX, quantityLabelCenterY, quantityLabelWidth, quantityLabelHeight,
                                     progressViewCenterX, progressViewCenterY, progressViewWidth, progressViewHeight,
                                     mediaStatusLabelCenterX, mediaStatusLabelCenterY, mediaStatusLabelWidth, mediaStatusLabelHeight])
    }

    override func setupSubviews() {
        super.setupSubviews()
        messageContentView.addSubview(playButtonView)
        messageContentView.addSubview(activityIndicatorView)
        messageContentView.addSubview(quantityLabel)
        messageContentView.addSubview(progressView)
        messageContentView.addSubview(mediaStatusLabel)
        setupConstraints()
    }

    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        switch message.data {
        case .photo(let image, let quantity):
            messageContentView.image = image
            playButtonView.isHidden = true
            quantityLabel.isHidden = !(quantity > 1)
            quantityLabel.text = quantity > 1 ? "\(quantity)" : ""
            activityIndicatorView.isHidden = true
            activityIndicatorView.stopAnimating()
            progressView.isHidden = true
            mediaStatusLabel.isHidden = true
        case .video(_, let image):
            messageContentView.image = image
            playButtonView.isHidden = false
            quantityLabel.isHidden = false
            activityIndicatorView.isHidden = true
            activityIndicatorView.stopAnimating()
            progressView.isHidden = true
            mediaStatusLabel.isHidden = true
        case .placeholder(let activityAnimating):
            messageContentView.image = nil
            playButtonView.isHidden = true
            quantityLabel.isHidden = true
            mediaStatusLabel.isHidden = false
            if activityAnimating {
                activityIndicatorView.startAnimating()
                activityIndicatorView.isHidden = false
                progressView.isHidden = true
                mediaStatusLabel.text = "Расшифровка"
            } else {
                progressView.isHidden = false
                progressView.progress = 0.05
                activityIndicatorView.stopAnimating()
                activityIndicatorView.isHidden = true
                mediaStatusLabel.text = "Загрузка"
            }
        default:
            break
        }
    }
}
