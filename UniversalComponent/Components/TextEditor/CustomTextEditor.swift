import SwiftUI
import Foundation


struct CustomTextEditor: UIViewRepresentable {
    @Binding var text: String
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomTextEditor
        
        init(parent: CustomTextEditor) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.text = text
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}
