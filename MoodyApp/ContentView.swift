//
//  ContentView.swift
//  MoodyApp
//
//  Created by Sorawit Trutsat on 23/11/2566 BE.
//

import SwiftUI
import WidgetKit

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
                
                // MARK: Reload the widget timeline immediately.
                WidgetCenter.shared.reloadTimelines(ofKind: "TodayMoodWidget")
                
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
