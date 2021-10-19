//
//  CircleView.swift
//  CountDown Mania
//
//  Created by JimmyHarrington on 2019/03/01.
//  Copyright © 2019 JimmyHarrington. All rights reserved.
//

import UIKit
import AVFoundation

public protocol TomatoCircleViewDelegate {
	func countDownDone()
}

public class TomatoCircleView: NSObject {
	public var tomatoCircleViewDelegate: TomatoCircleViewDelegate?
    
	var shapeLayer = CAShapeLayer() // shapeLayer
    var progView = UIView() // progView
    var countLabel = UILabel()
    var countTimer = Timer()
    var canAbort = false
    
	public var hasSpeech: Bool
	public var enLan: String?
	public var utterRate: Float
	public var hasZero: Bool
	public var startDegree: CGFloat
	public var radius: CGFloat
	public var strokeColor: UIColor
	public var weight: CGFloat
	public var labelFont: UIFont
	public var num: Int
	public var rect: CGRect
	public var view: UIView
	public init(hasSpeech: Bool, enLan: String?, utterRate: Float, hasZero: Bool, startDegree: CGFloat, radius: CGFloat, strokeColor: UIColor, weight: CGFloat, labelFont: UIFont, num: Int, rect: CGRect, view: UIView) {
		self.enLan = enLan
		self.hasSpeech = hasSpeech
		self.utterRate = utterRate
		self.hasZero = hasZero
		self.startDegree = startDegree
		self.radius = radius
		self.strokeColor = strokeColor
		self.weight = weight
		self.labelFont = labelFont
		self.num = num
		self.rect = rect
		self.view = view
	}
    
	public func createProgress() {
        let start = degreesToRadians(degree: startDegree)
        let end = start + CGFloat(2.0 * .pi)
        let centerPoint = CGPoint.init(x: rect.width/2.0, y: rect.height/2.0) // center of progView
        let circlePath = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = weight
        progView = UIView.init(frame: rect)
        progView.layer.addSublayer(shapeLayer)
        view.addSubview(progView)
        drawCircleAnimation(duration: TimeInterval(num), key: "strokeEnd", animationName: "strokeAnimation", fromValue: 0.0, toValue: 1.0, flag: false, removal: true)
        
        /* label */
		countLabel = UILabel(frame: CGRect(origin: CGPoint.zero, size: rect.size))
		countLabel.textColor = UIColor.black
		countLabel.font = labelFont
        //countLabel.text = NSString(format: "%i", count) as String
		countLabel.isUserInteractionEnabled = true
        countLabel.textAlignment = .center
        progView.addSubview(countLabel)
        
		/* tap gesture */
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(abortCount))
		countLabel.addGestureRecognizer(tapGesture)
		
        /* counting down */
        countMe()
        
		DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(num) + 1.0) {
            self.progView.removeFromSuperview()
        }
    }
	
	
	let synthesizer = AVSpeechSynthesizer()
    func countMe() {
        if canAbort { return }
        let text = NSString(format: "%i", num) as String
        countLabel.text = text
		
		let endNum = (hasZero) ? -1 : 0
		if num == endNum {
			tomatoCircleViewDelegate?.countDownDone()
		} else {
			if hasSpeech {
				let utterrance = AVSpeechUtterance(string: text)
				if let lan = enLan {
					utterrance.voice = AVSpeechSynthesisVoice(language: lan)
				} else {
					utterrance.voice = AVSpeechSynthesisVoice(language: "en-US")
				}
				utterrance.rate = utterRate
				synthesizer.speak(utterrance)
			}
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
				self.num -= 1
				self.countMe()
			}
		}
    }
    
    @objc func abortCount() {
		tomatoCircleViewDelegate?.countDownDone()
        canAbort = true
        progView.removeFromSuperview()
    }
	
    /* duration = dur + 1 because you want the user to see the initial number as an extra second */
    func drawCircleAnimation(duration: TimeInterval, key: String, animationName: String, fromValue: CGFloat, toValue: CGFloat, flag: Bool, removal: Bool) {
        let drawAnimation = CABasicAnimation(keyPath: key)
        drawAnimation.duration = duration + 1.0
        drawAnimation.repeatCount = 1
        drawAnimation.fromValue = fromValue
        drawAnimation.toValue = toValue
        drawAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        drawAnimation.isRemovedOnCompletion = removal;
        drawAnimation.fillMode = CAMediaTimingFillMode.forwards;
        drawAnimation.autoreverses = flag
        shapeLayer.add(drawAnimation, forKey: animationName)
    }
	
	
	// MARK: - Functions
	func degreesToRadians(degree: CGFloat) -> CGFloat {
		return degree * .pi / 180.0
	}
	
	func radiansToDegrees(degree: CGFloat) -> CGFloat {
		return degree * (180.0 / .pi)
	}
}

