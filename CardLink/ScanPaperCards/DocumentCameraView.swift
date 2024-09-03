//
//  DocumentCameraView.swift
//  CardLink
//
//  Created by Sahil Ak on 02/09/2024.
//

import SwiftUI
import VisionKit
import Vision

struct DocumentCameraView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var recognizedText: String
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        
        viewController.delegate = context.coordinator
        
        return viewController
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var parent: DocumentCameraView

        init(parent: DocumentCameraView) {
            self.parent = parent
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            controller.dismiss(animated: true)
            
            // Process the scanned images
            var scannedTexts: [String] = []
            let requestHandler = VNImageRequestHandler(cgImage: scan.imageOfPage(at: scan.pageCount - 1).cgImage!, options: [:])
            
            let request = VNRecognizeTextRequest { (request, error) in
                guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
                
                for observation in observations {
                    guard let bestCandidate = observation.topCandidates(1).first else { continue }
                    scannedTexts.append(bestCandidate.string)
                }
                
                self.parent.recognizedText = scannedTexts.joined(separator: "\n")
            }
            
            request.recognitionLevel = .accurate
            
            do {
                try requestHandler.perform([request])
            } catch {
                print("Request Handler is unable to perform request.")
            }
        }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true)
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            controller.dismiss(animated: true)
            print("Scanning failed with error: \(error)")
        }
    }
    
}
