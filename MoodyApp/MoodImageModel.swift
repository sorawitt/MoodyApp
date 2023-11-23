//
//  MoodImageName.swift
//  MoodyApp
//
//  Created by Sorawit Trutsat on 23/11/2566 BE.
//

import Foundation

struct MoodImageName: Identifiable {
    let id = UUID()
    let imageName: String
    let moodName: String
    var isSelected: Bool = false
    var isShaking: Bool = false
}
