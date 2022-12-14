import Foundation
import AVFoundation
import SwiftUI

struct CameraPreview: UIViewRepresentable {
    @EnvironmentObject var cameraVM: CameraViewModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        cameraVM.preview = AVCaptureVideoPreviewLayer(session: cameraVM.session)
        cameraVM.preview.frame = view.frame
        
        cameraVM.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(cameraVM.preview)
        
        cameraVM.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
