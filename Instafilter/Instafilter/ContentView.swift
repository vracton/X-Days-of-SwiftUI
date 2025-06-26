//
//  ContentView.swift
//  Instafilter
//
//  Created by vracto on 6/24/25.
//

import SwiftUI
import PhotosUI
import CoreImage
import CoreImage.CIFilterBuiltins
import StoreKit


struct ContentView: View {
    @Environment(\.requestReview) var requestReview
    @AppStorage("filterCount") var filterCount = 0
    
    @State private var processedImage: Image?
    @State private var selectedImage: PhotosPickerItem?
    
    @State private var filterIntensity: Float = 0.5
    @State private var filterRadius: Float = 20.0
    @State private var filterScale: Float = 2.5
    
    @State private var activeSliders: [Bool] = [false, false, false]
    
    @State private var curFilter: CIFilter = CIFilter.sepiaTone()
    let ctx = CIContext()
    
    @State private var showFilterPicker: Bool = false
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedImage?.loadTransferable(type: Data.self) else { return }
            guard let inputImg = UIImage(data: imageData) else { return }
            
            let beginImg = CIImage(image: inputImg)
            curFilter.setValue(beginImg, forKey: kCIInputImageKey)
            processImage()
        }
    }
    
    func processImage() {
        let inputKeys = curFilter.inputKeys

        activeSliders = [false, false, false]
        
        if inputKeys.contains(kCIInputIntensityKey) {
            curFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
            activeSliders[0] = true
        }
        
        if inputKeys.contains(kCIInputSharpnessKey) {
            curFilter.setValue(filterIntensity, forKey: kCIInputSharpnessKey)
            activeSliders[0] = true
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            curFilter.setValue(filterRadius, forKey: kCIInputRadiusKey)
            activeSliders[1] = true
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            curFilter.setValue(filterScale, forKey: kCIInputScaleKey)
            activeSliders[2] = true
        }
        
        if inputKeys.contains("inputLevels") {
            curFilter.setValue(filterScale, forKey: "inputLevels")
            activeSliders[2] = true
        }
        
        guard let outputImg = curFilter.outputImage else { return }
        guard let cgImage = ctx.createCGImage(outputImg, from: outputImg.extent) else { return }
        
        processedImage = Image(uiImage: UIImage(cgImage: cgImage))
    }
    
    func setFilter(_ filter: CIFilter) {
        curFilter = filter
        loadImage()
        
        filterCount += 1
        if filterCount > 20 {
            filterCount = 0
            requestReview()
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                PhotosPicker(selection: $selectedImage) {
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                    } else {
                        ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Tap to import picture"))
                    }
                }
                .buttonStyle(.plain)
                .onChange(of: selectedImage, loadImage)
                Spacer()
                VStack(spacing: 10) {
                    HStack {
                        Text("Intensity")
                            .fontWeight(.bold)
                        Slider(value: $filterIntensity)
                            .onChange(of: filterIntensity, processImage)
                            .disabled(processedImage == nil || !activeSliders[0])
                    }
                    HStack {
                        Text("Radius")
                            .fontWeight(.bold)
                        Slider(value: $filterRadius, in: 0...100)
                            .onChange(of: filterRadius, processImage)
                            .disabled(processedImage == nil || !activeSliders[1])
                    }
                    HStack {
                        Text("Scale")
                            .fontWeight(.bold)
                        Slider(value: $filterScale, in: 0...10)
                            .onChange(of: filterScale, processImage)
                            .disabled(processedImage == nil || !activeSliders[2])
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    if let processedImage {
                        ShareLink(item: processedImage, message: Text("Check out my Instafilter image!"), preview: SharePreview("Instafilter Image", image: processedImage))
                    } else {
                        ShareLink(item: "you should not be able to share this")
                            .disabled(true)
                    }
                }
                ToolbarSpacer(.flexible, placement: .bottomBar)
                ToolbarItem(placement: .bottomBar) {
                    Button("Change Filter", systemImage: "camera.filters") {
                        showFilterPicker = true
                    }
                    .disabled(processedImage == nil)
                    .confirmationDialog("Select a filter", isPresented: $showFilterPicker) {
                        Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                        Button("Edges") { setFilter(CIFilter.edges()) }
                        Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                        Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                        Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                        Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                        Button("Vignette") { setFilter(CIFilter.vignette()) }
                        Button("Halftone") {setFilter(CIFilter.cmykHalftone())}
                        Button("Dither") {setFilter(CIFilter.dither())}
                        Button("Posterize") {setFilter(CIFilter.colorPosterize())}
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("Select a filter")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
