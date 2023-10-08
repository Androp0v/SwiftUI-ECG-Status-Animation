//
//  ECGWaveformConfiguration.swift
//  SwiftUI ECG Status Animation
//
//  Created by Raúl Montón Pinillos on 8/10/23.
//

import Foundation

struct ECGWaveformConfiguration {
    
    // MARK: - Timis
    
    let startTime: Double
    let pQTime: Double
    let rUpTime: Double
    let rDownTime: Double
    let sTTime: Double
    
    // MARK: - Scale
    
    let pWaveScaleFactor: Double
    let qScaleFactor: Double
    let rScaleFactor: Double
    let sScaleFactor: Double
    let tWaveScaleFactor: Double
    
    // MARK: - Torsades
    let lowFrequencyParameter: Double = Double.random(in: 1..<7)
    let midFrequencyParameter: Double = Double.random(in: 7..<44)
    let highFrequencyParameter: Double = Double.random(in: 44..<55)
    let torsadesOffset: Double = Double.random(in: 0..<1)
    
    static var random: ECGWaveformConfiguration {
        let qScaleFactor = 0.15 * (1 + 0.5 * Double.random(in: -1.0..<1.0))
        let potentialSScaleFactor = 0.3 * (1 + 0.5 * Double.random(in: -1.0..<1.0))
        let sScaleFactor = max(qScaleFactor + 0.1, potentialSScaleFactor)
        
        let rUpTime = 0.05 * (1.0 + 0.2 * Double.random(in: -1.0..<1.0))
        let rDownTime = rUpTime * 0.75
        return ECGWaveformConfiguration(
            startTime: 0.21 * (1.0 + 0.1 * Double.random(in: -1.0..<1.0)),
            pQTime: 0.05 * (1 + 0.5 * Double.random(in: -1.0..<1.0)),
            rUpTime: rUpTime,
            rDownTime: rDownTime,
            sTTime: 0.05 * (1 + 0.5 * Double.random(in: -1.0..<1.0)),
            pWaveScaleFactor: 0.1 * (1 + 0.2 * Double.random(in: -1.0..<1.0)),
            qScaleFactor: qScaleFactor,
            rScaleFactor: 1.0 * (0.5 + 0.5 * Double.random(in: 0.0..<1.1)),
            sScaleFactor: sScaleFactor,
            tWaveScaleFactor: 0.2 * (0.5 + 0.5 * Double.random(in: -0.5..<1.0))
        )
    }
    
    private init(startTime: Double, pQTime: Double, rUpTime: Double, rDownTime: Double, sTTime: Double, pWaveScaleFactor: Double, qScaleFactor: Double, rScaleFactor: Double, sScaleFactor: Double, tWaveScaleFactor: Double) {
        self.startTime = startTime
        self.pQTime = pQTime
        self.rUpTime = rUpTime
        self.rDownTime = rDownTime
        self.sTTime = sTTime
        self.pWaveScaleFactor = pWaveScaleFactor
        self.qScaleFactor = qScaleFactor
        self.rScaleFactor = rScaleFactor
        self.sScaleFactor = sScaleFactor
        self.tWaveScaleFactor = tWaveScaleFactor
    }
}
