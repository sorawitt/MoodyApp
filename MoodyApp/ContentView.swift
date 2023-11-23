//
//  ContentView.swift
//  MoodyApp
//
//  Created by Sorawit Trutsat on 23/11/2566 BE.
//

import SwiftUI

struct ImageModel: Identifiable {
    let id = UUID()
    let imageName: String
    let moodName: String
    var isSelected: Bool = false
    var isShaking: Bool = false
}

class ImageGridViewModel: ObservableObject {
    @Published var images: [ImageModel] = [
        ImageModel(imageName: "mood1", moodName: "Smile"),
        ImageModel(imageName: "mood2", moodName: "Sleep"),
        ImageModel(imageName: "mood3", moodName: "Sick"),
        ImageModel(imageName: "mood4", moodName: "Wired"),
        ImageModel(imageName: "mood5", moodName: "Content"),
        ImageModel(imageName: "mood6", moodName: "Anxious"),
        ImageModel(imageName: "mood7", moodName: "Joyful"),
        ImageModel(imageName: "mood8", moodName: "Grateful"),
        ImageModel(imageName: "mood9", moodName: "Frustrated"),
        ImageModel(imageName: "mood10", moodName: "Hopeful"),
        ImageModel(imageName: "mood11", moodName: "Bored"),
        ImageModel(imageName: "mood12", moodName: "Loved"),
        ImageModel(imageName: "mood13", moodName: "Confused"),
        ImageModel(imageName: "mood14", moodName: "Proud"),
        ImageModel(imageName: "mood15", moodName: "Optimistic"),
        ImageModel(imageName: "mood16", moodName: "Peaceful")
    ]
    
    func selectImage(at index: Int) {
        images.indices.forEach { images[$0].isSelected = false }
        images[index].isSelected = true
    }
    
    func toggleShakingState(for index: Int) {
        images[index].isShaking.toggle()
    }
}

struct ImageGridView: View {
    @ObservedObject var viewModel = ImageGridViewModel()
    @State private var isShaking = false
    @State private var showSuccess = false
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    
    var body: some View {
        VStack {
            colorfulTitle
            selectedImageView
            Divider()
            imageGridView
            if showSuccess {
                Text("Saved Successfully!")
                    .font(.headline)
                    .foregroundColor(.green)
                    .padding()
                    .transition(.opacity)
            }
            saveButton
        }
        .padding()
    }
    
    var colorfulTitle: some View {
        Text("My ")
            .font(.body)
            .fontWeight(.bold)
            .foregroundColor(.red) +
        Text("mood ")
            .font(.body)
            .fontWeight(.bold)
            .foregroundColor(.blue) +
        Text("today ")
            .font(.body)
            .fontWeight(.bold)
            .foregroundColor(.green) +
        Text("be ")
            .font(.body)
            .fontWeight(.bold)
            .foregroundColor(.yellow) +
        Text("like")
            .font(.body)
            .fontWeight(.bold)
            .foregroundColor(.purple)
    }
    
    var selectedImageView: some View {
        VStack {
            if let selectedIndex = viewModel.images.firstIndex(where: { $0.isSelected }) {
                let selectedImage = viewModel.images[selectedIndex]
                Image(selectedImage.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding()
                    .rotationEffect(selectedImage.isSelected ? Angle(degrees: selectedImage.isShaking ? -5 : 5) : .zero)
                    .onTapGesture {
                        viewModel.selectImage(at: selectedIndex)
                        withAnimation {
                            viewModel.toggleShakingState(for: selectedIndex)
                        }
                    }
                Text("Mood: \(selectedImage.moodName)")
                    .font(.headline)
                    .padding(.bottom)
            } else {
                Text("No mood selected")
                    .font(.headline)
                    .padding(.bottom)
            }
        }
    }
    
    var imageGridView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(viewModel.images) { image in
                    Image(image.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .rotationEffect(image.isSelected ? Angle(degrees: image.isShaking ? -5 : 5) : .zero)
                        .onTapGesture {
                            if let index = viewModel.images.firstIndex(where: { $0.id == image.id }) {
                                viewModel.selectImage(at: index)
                            }
                        }
                }
            }
        }
    }
    
    var saveButton: some View {
        Button(action: {
            if let selectedIndex = viewModel.images.firstIndex(where: { $0.isSelected }) {
                let selectedImage = viewModel.images[selectedIndex]
                
                // MARK: Save data to User Default App Group.
                let userDefaults = UserDefaults(suiteName: "group.com.sorawitt.moodyAppExtension")
                userDefaults?.set(selectedImage.imageName, forKey: "selectedImageName")
                
                showSuccess = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showSuccess = false
                    }
                }
            }
        }) {
            Text("Save your mood")
                .font(.title2)
                .padding(.vertical, 8) // Adjust vertical padding
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding([.horizontal, .bottom]) // Adjust horizontal and bottom padding
    }
}

#Preview {
    ImageGridView()
}
