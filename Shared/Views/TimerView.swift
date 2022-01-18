//
//  TimerView.swift
//  QuizApp
//
//  Created by Aleksandar Geyman on 18.01.22.
//

import Foundation
import UIKit
import SwiftUI

struct TimerViewRepresentable: UIViewRepresentable {
    let duration: TimeInterval
    
    func makeUIView(context: UIViewRepresentableContext<TimerViewRepresentable>) -> UIView {
        TimerView(duration: duration)
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<TimerViewRepresentable>) {
        
    }
}

@objc public class TimerView: UIControl {
    ///The amount of time the timer will go for set at initialization
    public private(set) var duration: TimeInterval = 0
    
    ///Keeps track of the time remaining for the animation
    public private(set) var timeLeft: TimeInterval = 0
    
    ///Will hide the timer when it reaches 0 if set to true
    public var hidesWhenStopped = false
    
    public override var intrinsicContentSize: CGSize { CGSize(width: 30, height: 30) }
    
    private var timer: Timer? {
        didSet {
            oldValue?.invalidate()
        }
    }
    
    public override var bounds: CGRect {
        didSet {
            self.startAnimation()
        }
    }
    
    private lazy var timeLeftShapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 2
        self.layer.addSublayer(layer)
        return layer
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = timeLeft.time
        label.font = .systemFont(ofSize: 14)
        label.textColor = self.tintColor
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        NSLayoutConstraint.activate([self.leadingAnchor.constraint(equalTo: label.leadingAnchor),
                                     self.trailingAnchor.constraint(equalTo: label.trailingAnchor),
                                     self.topAnchor.constraint(equalTo: label.topAnchor),
                                     self.bottomAnchor.constraint(equalTo: label.bottomAnchor)])
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    public convenience init(duration: TimeInterval) {
        self.init()
        self.start(duration: duration)
    }
    
    private func setup() {
        self.contentMode = .redraw
        self.isOpaque = false
        self.clipsToBounds = false
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    public override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        self.intrinsicContentSize
    }
    
    @discardableResult
    @objc public func start(duration: TimeInterval) -> Bool {
        guard self.timer == nil else {
            // already running
            return false
        }
        
        if self.hidesWhenStopped {
            self.isHidden = false
        }
        
        self.duration = duration
        self.timeLeft = duration
        self.timeLabel.text = String(Int(timeLeft))
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        self.startAnimation()
        
        return true
    }
    
    public override func draw(_ rect: CGRect) {
        self.tintColor.setStroke()
        
        let path = UIBezierPath(arcCenter: CGPoint(x: rect.midX , y: rect.midY),
                                radius: (rect.height - 2) / 2,
                                startAngle: -90.degreesToRadians,
                                endAngle: 270.degreesToRadians,
                                clockwise: true)
        path.lineWidth = 2
        path.stroke()
    }
    
    private func startAnimation() {
        guard self.frame.size != .zero else {
            return
        }
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = (duration - timeLeft) / duration
        animation.toValue = 1
        animation.duration = timeLeft
        
        timeLeftShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: bounds.midX , y: bounds.midY),
                                               radius: (bounds.height - 2) / 2,
                                               startAngle: -90.degreesToRadians,
                                               endAngle: 270.degreesToRadians,
                                               clockwise: true).cgPath
        timeLeftShapeLayer.frame.size = self.bounds.size
        timeLeftShapeLayer.removeAllAnimations()
        timeLeftShapeLayer.add(animation, forKey: nil)
    }
    
    @objc private func willEnterForeground() {
        // entering background ends the animation, restart it
        startAnimation()
    }
    
    @objc private func updateTime() {
        if timeLeft > 0 {
            timeLeft = timeLeft - 1
            timeLabel.text = String(Int(timeLeft))
        } else {
            timer = nil
            self.sendActions(for: .valueChanged)
            
            if self.hidesWhenStopped {
                self.isHidden = true
            }
        }
    }
    
}

extension TimeInterval {
    var time: String {
        return String(Int(ceil(truncatingRemainder(dividingBy: 90))) )
    }
}

extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
