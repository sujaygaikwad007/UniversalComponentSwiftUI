import SwiftUI

struct UniversalButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            HStack {
                Text(title)
                    .font(.caption)
                    .foregroundColor(Color.white)
            }
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(16)
        })
    }
}

struct UniversalButton_Previews: PreviewProvider {
    static var previews: some View {
        UniversalButton(title: "Demo"){
            
        }
        .padding()
        
    }
}
