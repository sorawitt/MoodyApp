//
//  MoodImageGridViewModel.swift
//  MoodyApp
//
//  Created by Sorawit Trutsat on 23/11/2566 BE.
//

import SwiftUI

class ImageGridViewModel: ObservableObject {
    @Published var images: [MoodImageName] = [
        MoodImageName(imageName: "mood1", moodName: "Smile"),
        MoodImageName(imageName: "mood2", moodName: "Sleep"),
        MoodImageName(imageName: "mood3", moodName: "Sick"),
        MoodImageName(imageName: "mood4", moodName: "Wired"),
        MoodImageName(imageName: "mood5", moodName: "Content"),
        MoodImageName(imageName: "mood6", moodName: "Anxious"),
        MoodImageName(imageName: "mood7", moodName: "Joyful"),
        MoodImageName(imageName: "mood8", moodName: "Grateful"),
        MoodImageName(imageName: "mood9", moodName: "Frustrated"),
        MoodImageName(imageName: "mood10", moodName: "Hopeful"),
        MoodImageName(imageName: "mood11", moodName: "Bored"),
        MoodImageName(imageName: "mood12", moodName: "Loved"),
        MoodImageName(imageName: "mood13", moodName: "Confused"),
        MoodImageName(imageName: "mood14", moodName: "Proud"),
        MoodImageName(imageName: "mood15", moodName: "Optimistic"),
        MoodImageName(imageName: "mood16", moodName: "Peaceful")
    ]
    
    func selectImage(at index: Int) {
        images.indices.forEach { images[$0].isSelected = false }
        images[index].isSelected = true
    }
    
    func toggleShakingState(for index: Int) {
        images[index].isShaking.toggle()
    }
}
