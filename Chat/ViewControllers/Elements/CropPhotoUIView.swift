//
//  CropPhotoUIImageView.swift
//  Chat
//
//  Created by Eduardo Fornari on 27/04/18.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit

@IBDesignable
class CropPhotoUIView: UIView {

    @IBInspectable public var size: CGFloat = -1
    private var defaultSize: CGFloat = 0.5

    @IBInspectable public var shadowColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)

    @IBInspectable public var cropMarkBorderWidth: CGFloat = 0
    @IBInspectable public var cropMarkBorderColor: UIColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

    @IBInspectable public var image: UIImage? {
        didSet {
            set(image: image)
        }
    }
    @IBInspectable public var defaultImage: UIImage?

    private var backgroundUIImageView: UIImageView!
    private var cropMarkUIImageView: UIImageView!
    private var cropUIImageView: UIImageView!

    private var lastPointTouched: CGPoint?

    private var initialBackgroundPosition: CGPoint!

    private var panGestureRecognizer: UIPanGestureRecognizer?
    private var pinchGestureRecognizer: UIPinchGestureRecognizer?

    override func awakeFromNib() {

        layer.cornerRadius = 10

        clipsToBounds = true

        image = nil
    }

    private func set(image: UIImage?) {
        for subview in subviews {
            subview.removeFromSuperview()
        }

        removeGestures()

        if let image = image {
            if size > 1 || size < 0 {
                size = defaultSize
            }

            let litleSizeImage = image.size.width < image.size.height ? image.size.width : image.size.height
            let largerSize = frame.size.width > frame.size.height ? frame.size.width : frame.size.height
            let divisor = CGFloat(Int(litleSizeImage / largerSize))
            let backgroundWidth = image.size.width / divisor
            let backgroundHeight = image.size.height / divisor

            let halfWidth = frame.size.width * 0.5
            let halfHeight = frame.size.height * 0.5
            let halfBackgroundWidth = backgroundWidth * 0.5
            let halfBackgroundHeight = backgroundHeight * 0.5
            let backgroundX = -(halfBackgroundWidth) + halfWidth
            let backgroundY = -(halfBackgroundHeight) + halfHeight

            let backgroundFrame = CGRect(x: backgroundX, y: backgroundY, width: backgroundWidth,
                                         height: backgroundHeight)
            backgroundUIImageView = UIImageView(frame: backgroundFrame)
            backgroundUIImageView.contentMode = .scaleAspectFill
            backgroundUIImageView.image = image
            addSubview(backgroundUIImageView)
            initialBackgroundPosition = backgroundUIImageView.frame.origin

            let shadowUIView = UIView(frame: backgroundUIImageView.frame)
            shadowUIView.backgroundColor = shadowColor
            addSubview(shadowUIView)

            let cropSize = largerSize * size
            let halfCropSize = cropSize * 0.5

            let xFrame =  halfWidth - halfCropSize
            let yFrame = halfHeight - halfCropSize
            cropMarkUIImageView = UIImageView(frame: CGRect(x: xFrame, y: yFrame,
                                                            width: cropSize, height: cropSize))
            cropMarkUIImageView.clipsToBounds = true
            cropMarkUIImageView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            cropMarkUIImageView.layer.borderColor = cropMarkBorderColor.cgColor
            cropMarkUIImageView.layer.borderWidth = cropMarkBorderWidth
            cropMarkUIImageView.layer.cornerRadius = halfCropSize
            addSubview(cropMarkUIImageView)

            cropUIImageView = UIImageView(frame: backgroundUIImageView.frame)
            cropUIImageView.contentMode = backgroundUIImageView.contentMode
            let halfCropImageWidth = cropUIImageView.frame.width * 0.5
            let halfCropImageHeight = cropUIImageView.frame.height * 0.5
            cropUIImageView.frame.origin.x = -(halfCropImageWidth) + halfCropSize
            cropUIImageView.frame.origin.y = -(halfCropImageHeight) + halfCropSize
            cropUIImageView.image = backgroundUIImageView.image
            cropMarkUIImageView.addSubview(cropUIImageView)

            print("backsize = \(backgroundUIImageView.frame)")
            print("size = \(frame)")

            addGestures()
        } else {
            let backgroundFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            backgroundUIImageView = UIImageView(frame: backgroundFrame)
            backgroundUIImageView.contentMode = .scaleAspectFill
            backgroundUIImageView.image = defaultImage
            addSubview(backgroundUIImageView)
            return
        }
    }

    private func addGestures() {
        isUserInteractionEnabled = true

        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panAction(recognizer:)))
        addGestureRecognizer(panGestureRecognizer!)

        pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(recognizer:)))
        addGestureRecognizer(pinchGestureRecognizer!)
    }

    private func removeGestures() {
        if let panGestureRecognizer = panGestureRecognizer,
            let pinchGestureRecognizer = pinchGestureRecognizer {
            removeGestureRecognizer(panGestureRecognizer)
            removeGestureRecognizer(pinchGestureRecognizer)
        }
    }

    @objc private func panAction(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            lastPointTouched = recognizer.translation(in: backgroundUIImageView)
        } else if recognizer.state == .changed {
            let pointTouched = recognizer.translation(in: backgroundUIImageView)

            let differenceX = lastPointTouched!.x - pointTouched.x
            let differenceY = lastPointTouched!.y - pointTouched.y

            backgroundUIImageView.frame.origin.x -= differenceX
            backgroundUIImageView.frame.origin.y -= differenceY

            cropUIImageView.frame.origin.x -= differenceX
            cropUIImageView.frame.origin.y -= differenceY

            lastPointTouched = pointTouched
        } else {
            print("-------------------------")
            if backgroundUIImageView.frame.origin.x > cropMarkUIImageView.frame.origin.x {
                print("X ultrapassou na esquerda")
            } else if backgroundUIImageView.frame.origin.x + backgroundUIImageView.frame.width <
                cropMarkUIImageView.frame.origin.x + cropMarkUIImageView.frame.width {
                print("X ultrapassou na direita")
            } else {
                print("X OK")
            }

            if backgroundUIImageView.frame.origin.y > cropMarkUIImageView.frame.origin.y {
                print("X ultrapassou em cima")
            } else if backgroundUIImageView.frame.origin.y + backgroundUIImageView.frame.height <
                cropMarkUIImageView.frame.origin.y + cropMarkUIImageView.frame.height {
                print("X ultrapassou em baixo")
            } else {
                print("Y OK")
            }

            lastPointTouched = nil
        }
    }

    @objc private func pinchAction(recognizer: UIPinchGestureRecognizer) {
        let increaseSize: CGFloat = 3
        if recognizer.velocity > 0 {
            backgroundUIImageView.frame.size.height += increaseSize
            backgroundUIImageView.frame.size.width += increaseSize
            cropUIImageView.frame.size.height += increaseSize
            cropUIImageView.frame.size.width += increaseSize

            backgroundUIImageView.frame.origin.x -= increaseSize * 0.5
            backgroundUIImageView.frame.origin.y -= increaseSize * 0.5
            cropUIImageView.frame.origin.x -= increaseSize * 0.5
            cropUIImageView.frame.origin.y -= increaseSize * 0.5
        } else if backgroundUIImageView.frame.size.width - increaseSize >= cropMarkUIImageView.frame.size.width &&
            backgroundUIImageView.frame.size.height - increaseSize >= cropMarkUIImageView.frame.size.height {
            backgroundUIImageView.frame.size.height -= increaseSize
            backgroundUIImageView.frame.size.width -= increaseSize
            cropUIImageView.frame.size.height -= increaseSize
            cropUIImageView.frame.size.width -= increaseSize

            backgroundUIImageView.frame.origin.x += increaseSize * 0.5
            backgroundUIImageView.frame.origin.y += increaseSize * 0.5
            cropUIImageView.frame.origin.x += increaseSize * 0.5
            cropUIImageView.frame.origin.y += increaseSize * 0.5
        }
    }

    public func getCropedImage() -> UIImage? {
        if self.image != nil {
            let cornerRadius = cropMarkUIImageView.layer.cornerRadius
            let borderColor = cropMarkUIImageView.layer.borderColor
            let borderWidth = cropMarkUIImageView.layer.borderWidth

            cropMarkUIImageView.layer.cornerRadius = 0
            cropMarkUIImageView.layer.borderColor = nil
            cropMarkUIImageView.layer.borderWidth = 0

            let renderer = UIGraphicsImageRenderer(size: cropMarkUIImageView.bounds.size)
            let image = renderer.image { _ in
                cropMarkUIImageView.drawHierarchy(in: cropMarkUIImageView.bounds, afterScreenUpdates: true)
            }

            cropMarkUIImageView.layer.cornerRadius = cornerRadius
            cropMarkUIImageView.layer.borderColor = borderColor
            cropMarkUIImageView.layer.borderWidth = borderWidth

            return image
        }
        return nil
    }

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */

}
