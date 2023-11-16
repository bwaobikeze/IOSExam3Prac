//
//  ContentView.swift
//  exam3practic
//
//  Created by brian waobikeze on 11/14/23.
//

import SwiftUI
import NaturalLanguage
import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI

struct ContentView: View {
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var avatarImage: UIImage?
    @State private var filter: String = "Original"
    @State private var filterarr: [String] = ["Original", "Blur", "Binarized", "Sepia"]
    @State private var blurFilter = CIFilter.gaussianBlur()
    @State private var binarizeFilter = CIFilter.colorThreshold()
    @State private var sepiaFilter = CIFilter.sepiaTone()
    @State private var tempImage: UIImage?
    @State private var curentfilter = 0.5
    let context = CIContext()
    @ObservedObject var classifier: ImageClassifier
    var syncService = SyncService()
    var body: some View {
        VStack {
            Text("ML Model Vs Image Filters").font(Font.system(size: 25))
            Spacer()
            
            Picker(selection: $filter) {
                ForEach(filterarr, id: \.self) { filtered in
                    Text("\(filtered)")
                }
            } label: {
                
            }.pickerStyle(.segmented)

            Image(uiImage: avatarImage ?? UIImage(systemName: "person.crop.circle") ?? UIImage())
                .resizable()
                .scaledToFit()
                .aspectRatio(250.250, contentMode: .fill)
                .frame(width: 250, height: 250)
                .background(.white)
                .onAppear {
                    classifier.detectObj(uiImage: avatarImage ?? UIImage(systemName: "person.crop.circle") ?? UIImage())
                }
                .onChange(of: avatarImage) {
                    classifier.detectObj(uiImage: avatarImage ?? UIImage(systemName: "person.crop.circle") ?? UIImage())
                }
            
            HStack {
                PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                    Image(systemName: "photo")
                }
                .onChange(of: selectedPhotoItem) { _, _ in
                    Task {
                        if let selectedPhotoItem, let data = try? await selectedPhotoItem.loadTransferable(type: Data.self) {
                            if let image = UIImage(data: data) {
                                let beginImage = CIImage(image: image)
                                tempImage = image
                                applyProcessing()
                            }
                        }
                        selectedPhotoItem = nil
                    }
                }
                .onChange(of: filter) {
                    let beginImage = CIImage(image: tempImage ?? UIImage())
                    blurFilter.setValue(beginImage, forKey: kCIInputImageKey)
                    binarizeFilter.setValue(beginImage, forKey: kCIInputImageKey)
                    sepiaFilter.setValue(beginImage, forKey: kCIInputImageKey)
                    applyProcessing()
                }
                
                Spacer()
                
                Button(action: {
                    add25()
                }) {
                    Text("+25%")
                }.disabled(filter == "Original")
                
                Spacer()
                
                Button(action: {
                    add75()
                }) {
                    Text("+75%")
                }.disabled(filter == "Original")
                Spacer()
                Button(action: {
                    transferToWatch()
                }) {
                    Image(systemName: "applewatch.and.arrow.forward")
                
                }
                Spacer()
                Button(action: {
                    SaveImage()
                }) {
                    Image(systemName: "square.and.arrow.down.on.square")
                }
            }.padding()
            Slider(value:$curentfilter).disabled(filter == "Original")
            
            Spacer()
            
            Group {
                if let imageClass = classifier.imageClass {
                    HStack {
                        Text(imageClass)
                            .bold()
                            .lineLimit(7)
                    }
                    .foregroundStyle(.black)
                } else {
                    HStack {
                        Text("Unable to identify objects")
                            .font(.system(size: 26))
                    }
                    .foregroundStyle(.red)
                }
            }
            .font(.subheadline)
            .padding()
            
            Spacer()
        }
        .padding()
    }
    
    func applyProcessing() {
        if filter == "Original" {
            avatarImage = tempImage
            return
        } else if filter == "Blur" {
            blurFilter.radius = 100
            guard let outputImage = blurFilter.outputImage else { return }
            if let cgimage = context.createCGImage(outputImage, from: outputImage.extent) {
                let uiimage = UIImage(cgImage: cgimage)
                avatarImage = uiimage
            }
        } else if filter == "Binarized" {
            binarizeFilter.threshold = 0.1
            guard let outputImage = binarizeFilter.outputImage else { return }
            if let cgimage = context.createCGImage(outputImage, from: outputImage.extent) {
                let uiimage = UIImage(cgImage: cgimage)
                avatarImage = uiimage
            }
        } else if filter == "Sepia" {
            sepiaFilter.intensity = 0.5
            guard let outputImage = sepiaFilter.outputImage else { return }
            if let cgimage = context.createCGImage(outputImage, from: outputImage.extent) {
                let uiimage = UIImage(cgImage: cgimage)
                avatarImage = uiimage
            }
        }
    }
    func transferToWatch(){
//        syncService.sendMessage("image", analyzeSentiment(), { error in })
    }
    func SaveImage(){
        UIImageWriteToSavedPhotosAlbum(avatarImage ??  UIImage(), nil, nil, nil)
        
    }
    
    func add25() {
        if filter == "Binarized" {
            let currentradius = binarizeFilter.threshold
            binarizeFilter.threshold = currentradius * 0.25
            guard let outputImage = binarizeFilter.outputImage else { return }
            if let cgimage = context.createCGImage(outputImage, from: outputImage.extent) {
                let uiimage = UIImage(cgImage: cgimage)
                avatarImage = uiimage
            }
        }else if filter == "Blur" {
            let currentradius = blurFilter.radius
            blurFilter.radius = currentradius * 0.25
            guard let outputImage = blurFilter.outputImage else { return }
            if let cgimage = context.createCGImage(outputImage, from: outputImage.extent) {
                let uiimage = UIImage(cgImage: cgimage)
                avatarImage = uiimage
            }
            
        }else if filter == "Sepia" {
            let currentradius =  sepiaFilter.intensity
            sepiaFilter.intensity = currentradius * 0.25
            guard let outputImage = sepiaFilter.outputImage else { return }
            if let cgimage = context.createCGImage(outputImage, from: outputImage.extent) {
                let uiimage = UIImage(cgImage: cgimage)
                avatarImage = uiimage
            }
            
        }
    }
    
    func add75() {
        if filter == "Binarized" {
            let currentradius = binarizeFilter.threshold
            binarizeFilter.threshold =  currentradius * 0.75
            guard let outputImage = binarizeFilter.outputImage else { return }
            if let cgimage = context.createCGImage(outputImage, from: outputImage.extent) {
                let uiimage = UIImage(cgImage: cgimage)
                avatarImage = uiimage
            }
            
        }else if filter == "Blur" {
            let currentradius = blurFilter.radius
            blurFilter.radius = currentradius * 0.75
            guard let outputImage = blurFilter.outputImage else { return }
            if let cgimage = context.createCGImage(outputImage, from: outputImage.extent) {
                let uiimage = UIImage(cgImage: cgimage)
                avatarImage = uiimage
            }
            //print(blurFilter.radius)
            
        }else if filter == "Sepia" {
            let currentradius =  sepiaFilter.intensity
            sepiaFilter.intensity = currentradius * 0.75
            guard let outputImage = sepiaFilter.outputImage else { return }
            if let cgimage = context.createCGImage(outputImage, from: outputImage.extent) {
                let uiimage = UIImage(cgImage: cgimage)
                avatarImage = uiimage
            }
            print(sepiaFilter.intensity)
        }
    }
    func analyzeSentiment() -> Data?{
//        func analyzeSentiment(text: String) -> Int {
//            
//            //limit input to first 100 symbols
//            let text = String(text.prefix(100))
//            
//            
//            if text.contains("building"){
//                return 1
//                
//            } else if text.contains("notebook") {
//                return 2
//                
//            } else if text.contains("car") {
//                return 3
//            } else {
//                return 0
//            }
//
//        }
        let data = avatarImage?.pngData()
        
        return data
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(classifier: ImageClassifier())
    }
}
