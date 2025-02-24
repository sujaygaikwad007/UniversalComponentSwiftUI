import SwiftUI

enum TextFieldStyle {
    case bordered
    case borderless
}

struct CustomTextField: View {
    @Binding var text: String
    let title: String
    let required: String
    let placeholder: String
    let isSecure: Bool
    let keyboardType: UIKeyboardType
    let height: CGFloat?
    let unit: String
    let style: TextFieldStyle
    let helperText: String
    let foregroundColor: Color?
    let backgroundColor : Color?

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(required)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }

            switch style {
            case .bordered:
                ZStack(alignment: .trailing) {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 0.5)
                        .frame(height: height)

                    if isSecure {
                        SecureField(placeholder, text: $text)
                            .font(.caption)
                            .foregroundColor(foregroundColor)
                            .keyboardType(keyboardType)
                            .padding(.horizontal, 10)
                            .frame(height: height)
                    } else {
                        TextField(placeholder, text: $text)
                            .font(.caption)
                            .foregroundColor(foregroundColor)
                            .keyboardType(keyboardType)
                            .padding(.horizontal, 10)
                            .frame(height: height)
                    }

                    Text(unit)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.trailing, 15)
                }
                .frame(height: height)
                .background(backgroundColor)
                
                // Display helper text below the text field if available
                if let helperText = helperText, !helperText.isEmpty {
                    Text(helperText)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

            case .borderless:
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .font(.caption)
                        .foregroundColor(foregroundColor)
                        .keyboardType(keyboardType)
                        .multilineTextAlignment(.trailing)
                } else {
                    TextField(placeholder, text: $text)
                        .font(.caption)
                        .foregroundColor(foregroundColor)
                        .keyboardType(keyboardType)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
    }
}


