//
//  ViewController.swift
//  TomatoCountdownSample
//
//  Created by Tomato on 2021/10/18.
//

import UIKit
import AVFoundation
import TomatoCountdown

class ViewController: UIViewController, TomatoCircleViewDelegate {
	// MARK: - Variables
	let synthesizer = AVSpeechSynthesizer()
	
	
	// MARK: - IBOutlet
	@IBOutlet weak var startButton: UIButton!
	
	
	// MARK: - IBAction
	@IBAction func startTapped(_ sender: UIButton) {
		/* disabling startButton */
		startButton.isEnabled = false
		
		/* instantiating TomatoCircleView */
		let radius: CGFloat = 120.0
		let weight: CGFloat = 20.0
		let startNum = 10
		let viewSide = min(self.view.frame.size.width, self.view.frame.size.height)
		let rect = CGRect(x: (self.view.frame.size.width - viewSide)/2.0, y: (self.view.frame.size.height - viewSide) / 2.0, width: viewSide, height: viewSide)
		let font = UIFont.systemFont(ofSize: 128.0)
		
		
		let tomatoCircleView = TomatoCircleView(hasSpeech: true, enLan: "en-US", utterRate: 0.4, hasZero: false, startDegree: -90.0, radius: radius, strokeColor: UIColor.red, weight: weight, labelFont: font, num: startNum, rect: rect, view: self.view)
		tomatoCircleView.tomatoCircleViewDelegate = self
		tomatoCircleView.createProgress()
	}
	
	
	// MARK: - Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let utterrance = AVSpeechUtterance(string: " ")
		utterrance.voice = AVSpeechSynthesisVoice(language: "en-US")
		//utterrance.rate = 0.5
		synthesizer.speak(utterrance)
		startButton.setTitleColor(UIColor.white, for: .normal)
		startButton.setTitleColor(UIColor.lightGray, for: .disabled)
	}
	
	
	func countDownDone() {
		startButton.isEnabled = true
		print("I'm done")
	}
}

