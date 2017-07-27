//
//  WKTimer.swift
//  IOSQuizWatchOS Extension
//
//  Created by galushka on 7/10/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import Foundation

protocol QuizTimerType {
    weak var delegate: QuizTimerDelegate? { get set }
    var currentTime: UInt { get }
    
    func start()
    func finish()
    func pause()
    func resume()
    func reset()
}

protocol QuizTimerDelegate: class {
    func timerFire(time: UInt)
    func finished()
}

class QuizTimer: QuizTimerType {
    private var timer: Timer?
    
    private(set) var currentTime: UInt
    private let startingTime: UInt
    
    weak var delegate: QuizTimerDelegate?
    
    init(startingTime: UInt) {
        self.startingTime = startingTime
        currentTime = startingTime + 1
    }
    
    private func createNewTimer() {
        destroyTimerIfExist()
        
        timer = Timer(timeInterval: 1, target: self, selector: #selector(timerFireHandler), userInfo: nil, repeats: true)
        
        if let timer = self.timer {
            RunLoop.current.add(timer, forMode: .commonModes)
        }
    }
    
    @objc private func timerFireHandler() {
        guard currentTime > 0 else {
            finish()
            return
        }

        currentTime -= 1
        delegate?.timerFire(time: currentTime)
    }
    
    private func destroyTimerIfExist() {
        if timer == nil {
            timer?.invalidate()
            timer = nil
            print()
        }
    }
    
    private func resetTimer() {
        destroyTimerIfExist()
        currentTime = startingTime - 1
        createNewTimer()
        timer?.fire()
    }
    
    deinit {
        destroyTimerIfExist()
    }
}

extension QuizTimer {
    func start() {
        if timer != nil { return }
        
        createNewTimer()
        timer?.fire()
    }
    
    func finish() {
        destroyTimerIfExist()
        delegate?.finished()
    }
    
    func pause() {
        destroyTimerIfExist()
    }
    
    func resume() {
        createNewTimer()
    }
    
    func reset() {
        resetTimer()
    }
}

