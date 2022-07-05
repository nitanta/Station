//
//  AlertView.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 04/07/2022.
//

import SwiftUI

enum AlertType {
    case info(String)
    case error(Error)
    case success(String)
    
    var title: String {
        switch self {
        case .info: return Constants.info
        case .error: return Constants.sorry
        case .success: return Constants.success
        }
    }
    
    var message: String {
        switch self {
        case .info(let message): return message
        case .error(let error):
            if let localized = error as? LocalizedError {
                return localized.recoverySuggestion.safeUnwrapped
            }
            return error.localizedDescription
        case .success(let message): return message
        }
    }
    
    struct Constants {
        static let sorry = "Sorry"
        static let info = "Info"
        static let success = "Success"
    }
}

struct AlertAction: Identifiable, Hashable {
    static func == (lhs: AlertAction, rhs: AlertAction) -> Bool {
        lhs.title == rhs.title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    var id: String {
        return UUID().uuidString
    }
    var action: (() -> ())?
    var title: String
}

struct AppAlert {
    let type: AlertType
    let actions: [AlertAction]
}

struct AlertView: View {
    var alert: AppAlert
    @Environment(\.presentationMode) var presentationMode
        
    var body: some View {
        ZStack {
            Color.black.opacity(0.2).edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            
            ZStack {
                VStack(spacing: 16) {
                    Text(alert.type.title)
                        .font(AppFont.proRegular18)
                        .foregroundColor(AppColor.primaryText)
                        .frame(maxWidth: .infinity)
                    
                    Text(alert.type.message)
                        .font(AppFont.proRegular16)
                        .foregroundColor(AppColor.primaryLightText)
                        .frame(maxWidth: .infinity)

                    
                    
                    HStack {
                        ForEach(alert.actions, id: \.self) { action in
                            Button {
                                action.action?()
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Text(action.title)
                                    .font(AppFont.proRegular16)
                                    .foregroundColor(AppColor.primaryText.opacity(0.5))
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
                .padding()
                .background(.white)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            
            
        }
    }

}

extension AlertView {
    struct Constants {
        //static let show = "Show"
    }
}


struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(alert: AppAlert(
            type: .info("Registration email has been sent. Registration email has been sent.Registration email has been sent"),
            actions: [
                AlertAction(action: nil, title: "OKAY"), AlertAction(action: nil, title: "CANCEL"),
                AlertAction(action: nil, title: "INGNORE")
            ]))
        .previewLayout(.sizeThatFits)
    }
}

extension View {
    func appAlert(error: Binding<AppAlert?>, showAlert: Binding<Bool>) -> some View {
        return fullScreenCover(isPresented: showAlert) {
            AlertView(alert: error.wrappedValue!)
                .background(BackgroundBlurView())
        }
        
//        sheet(isPresented: .constant(error.wrappedValue != nil)) {
//            AlertView(alert: error.wrappedValue!)
//                //.presentationDetents([.medium, .fraction(0.7)])
//        }
    }
}

struct BackgroundBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
