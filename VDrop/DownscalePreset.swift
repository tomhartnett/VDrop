//
//  DownscalePreset.swift
//  VDrop
//
//  Created by Tom Hartnett on 2/15/25.
//

import Foundation

struct DownscalePreset: Hashable, Identifiable {
    var id: String {
        name
    }

    let name: String
    let width: Int
    let height: Int
}

extension DownscalePreset {
    static var devicePresets: [DownscalePreset] = [
        .init(name: "iPhone 16 Pro Max - 440x956", width: 440, height: 956),
        .init(name: "iPhone 16 Pro - 402x874", width: 402, height: 874),
        .init(name: "iPhone 16 Plus - 430x932", width: 430, height: 932),
        .init(name: "iPhone 16 - 393x852", width: 393, height: 852),
        .init(name: "iPhone 15 Pro Max - 430x932", width: 430, height: 932),
        .init(name: "iPhone 15 Pro - 393x852", width: 393, height: 852),
        .init(name: "iPhone 15 Plus - 430x932", width: 430, height: 932),
        .init(name: "iPhone 15 - 393x852", width: 393, height: 852),
        .init(name: "iPhone 14 Plus - 428x926", width: 428, height: 926),
        .init(name: "iPhone 14 Pro Max - 430x932", width: 430, height: 932),
        .init(name: "iPhone 14 Pro - 393x852", width: 393, height: 852),
        .init(name: "iPhone 14 - 390x844", width: 390, height: 844),
        .init(name: "iPhone SE 3rd gen - 375x667", width: 375, height: 667),
        .init(name: "iPhone 13 - 390x844", width: 390, height: 844),
        .init(name: "iPhone 13 mini - 375x812", width: 375, height: 812),
        .init(name: "iPhone 13 Pro Max - 428x926", width: 428, height: 926),
        .init(name: "iPhone 13 Pro - 390x844", width: 390, height: 844),
        .init(name: "iPhone 12 - 390x844", width: 390, height: 844),
        .init(name: "iPhone 12 mini - 375x812", width: 375, height: 812),
        .init(name: "iPhone 12 Pro Max - 428x926", width: 428, height: 926),
        .init(name: "iPhone 12 Pro - 390x844", width: 390, height: 844),
        .init(name: "iPhone SE 2nd gen - 375x667", width: 375, height: 667),
        .init(name: "iPhone 11 Pro Max - 414x896", width: 414, height: 896),
        .init(name: "iPhone 11 Pro - 375x812", width: 375, height: 812),
        .init(name: "iPhone 11 - 414x896", width: 414, height: 896),
        .init(name: "iPhone XR - 414x896", width: 414, height: 896),
        .init(name: "iPhone XS Max - 414x896", width: 414, height: 896),
        .init(name: "iPhone XS - 375x812", width: 375, height: 812),
        .init(name: "iPhone X - 375x812", width: 375, height: 812),
        .init(name: "iPhone 8 Plus - 414x736", width: 414, height: 736),
        .init(name: "iPhone 8 - 375x667", width: 375, height: 667),
        .init(name: "iPhone 7 Plus - 414x736", width: 414, height: 736),
        .init(name: "iPhone 7 - 375x667", width: 375, height: 667),
        .init(name: "iPhone SE 1st gen - 320x568", width: 320, height: 568),
        .init(name: "iPhone 6s Plus - 414x736", width: 414, height: 736),
        .init(name: "iPhone 6s - 375x667", width: 375, height: 667),
        .init(name: "iPhone 6 Plus - 414x736", width: 414, height: 736),
        .init(name: "iPhone 6 - 375x667", width: 375, height: 667),
        .init(name: "iPhone 5C - 320x568", width: 320, height: 568),
        .init(name: "iPhone 5S - 320x568", width: 320, height: 568),
        .init(name: "iPhone 5 - 320x568", width: 320, height: 568),
        .init(name: "iPhone 4S - 320x480", width: 320, height: 480),
        .init(name: "iPhone 4 - 320x480", width: 320, height: 480),
        .init(name: "iPhone 3GS - 320x480", width: 320, height: 480),
        .init(name: "iPhone 3G - 320x480", width: 320, height: 480),
        .init(name: "iPhone 1st gen - 320x480", width: 320, height: 480)
    ]

    static var iPhone16Pro: DownscalePreset {
        .init(name: "iPhone 16 Pro - 402x874", width: 402, height: 874)
    }
}
