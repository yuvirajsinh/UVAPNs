//
//  ContentView.swift
//  UVAPNs
//
//  Created by Yuvrajsinh Jadeja on 29/06/22.
//

import SwiftUI

struct ContentView: View {
    @State var authenticationExpanded = true
    @State var headerExpanded = true
    @State var bodyExpanded = true
    @State var environmentExpanded = true
    
    @State var file: File = File(fileUrl: nil, teamId: "", keyId: "")
    @State var header: Header = Header(authorization: "", pushType: .alert, priority: .immediately, collapseId: "", notificationId: UUID().uuidString, expiration: "0", apnsTopic: "")
    @State var payloadBody: PayloadBody = PayloadBody(deviceToken: "", payload: "", environment: .sandbox)
    
    @State private var filename: String = ""
    @State private var pushType: String = PushType.alert.rawValue
    @State private var priority: String = Priority.immediately.rawValue
    @State private var environment: String = APNSEnvironment.sandbox.rawValue
    
    @State private var showMissingDataAlert: Bool = false
    @State private var showAPNSResultAlert: Bool = false
    @State private var apnsResultTitle: String = ""
    @State private var apnsResultMessage: String = ""
    
    @State private var showLoader: Bool = false
    
    let apnsSender = NotificationSender()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                // AUTHENTICATION
                Section {
                    DisclosureGroup(isExpanded: $authenticationExpanded) {
                        HStack(alignment: .center, spacing: nil, content: {
                            VStack {
                                ZStack(alignment: Alignment(horizontal: .center, vertical: .center), content: {
                                    Image(systemName: "rectangle.dashed")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100, alignment: .center)
                                        .foregroundColor(Color.gray.opacity(0.2))
                                    if filename.isEmpty {
                                        Text("Drop your p8 file here")
                                            .multilineTextAlignment(.center)
                                            .font(.body)
                                            .frame(width: 100, height: 100, alignment: .center)
                                    }
                                    else {
                                        Text(filename)
                                            .multilineTextAlignment(.center)
                                            .font(.body)
                                            .frame(width: 100, height: 100, alignment: .center)
                                    }
                                })
                                    .onDrop(of: [.fileURL], isTargeted: nil, perform: { providers in
                                        guard let provider = providers.first else { return false }
                                        handleFileDrop(provider: provider)
                                        return true
                                    })
                            }
                            Spacer().frame(width: 30, height: 0, alignment: .center)
                            VStack(alignment: .center, spacing: nil, content: {
                                InputFieldView(title: "Team ID", titleWidth: 60, value: $file.teamId)
                                InputFieldView(title: "Key ID", titleWidth: 60, value: $file.keyId)
                            })
                        })
                    } label: {
                        Text("AUTHENTICATION")
                            .font(.headline)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 25.0)
                        .foregroundColor(Color.gray.opacity(0.1))
                )
                // This is done here because in SwiftUI we can't show two alerts in single view as I read or I don't know how to do
                .alert(isPresented: $showAPNSResultAlert, content: {
                    Alert(title: Text(apnsResultTitle), message: Text(apnsResultMessage), dismissButton: .default(Text("OK")))
                })
                
                // HEADER
                Section {
                    DisclosureGroup(isExpanded: $headerExpanded) {
                        Spacer().frame(height: 10)
                        HStack(alignment: .center, spacing: nil, content: {
                            Picker("Push type", selection: $pushType) {
                                ForEach(PushType.allCases, id: \.id) { type in
                                    Text(type.rawValue)
                                        .tag(type.rawValue)
                                }
                            }
                            .font(.title3)
                            .onChange(of: pushType, perform: { value in
                                guard let newType = PushType(rawValue: value) else { return }
                                header.pushType = newType
                                if newType == .background {
                                    header.priority = .normal
                                    priority = header.priority.rawValue
                                }
                            })
                            Spacer().frame(width: 50, height: 0, alignment: .center)
                            Picker("Priority", selection: $priority) {
                                ForEach(Priority.allCases, id: \.id) { priority in
                                    Text(priority.rawValue).tag(priority.rawValue)
                                }
                            }
                            .onChange(of: priority, perform: { value in
                                guard let newPriority = Priority(rawValue: value) else { return }
                                header.priority = newPriority
                            })
                            .font(.title3)
                        })
                        
                        InputFieldView(title: "Collapse ID (Optional)", titleWidth: 110, value: $header.collapseId)
                        HStack {
                            InputFieldView(title: "Notification ID", titleWidth: 110, value: $header.notificationId)
                            Button(action: {
                                refreshNotificationId()
                            }, label: {
                                Image(systemName: "arrow.clockwise")
                            })
                        }
                        InputFieldView(title: "Expiration", titleWidth: 110, value: $header.expiration)
                        InputFieldView(title: "Topic/Bundle ID", titleWidth: 110, value: $header.apnsTopic)
                    } label: {
                        Text("HEADER")
                            .font(.headline)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 25.0)
                        .foregroundColor(Color.gray.opacity(0.1))
                )
                
                // BODY
                Section {
                    DisclosureGroup(isExpanded: $bodyExpanded) {
                        Spacer().frame(height: 10)
                        MultilineInputFieldView(title: "Device token", titleWidth: 100, inputFieldHeight: 50.0, value: $payloadBody.deviceToken)
                        MultilineInputFieldView(title: "Message", titleWidth: 100, inputFieldHeight: 150.0, value: $payloadBody.payload)
                    } label: {
                        Text("BODY")
                            .font(.headline)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 25.0)
                        .foregroundColor(Color.gray.opacity(0.1))
                )
                
                // ENVIRONMENT
                Section {
                    DisclosureGroup(isExpanded: $environmentExpanded) {
                        Spacer().frame(height: 10)
                        Picker("", selection: $environment) {
                            ForEach(APNSEnvironment.allCases, id: \.id) { env in
                                Text(env.rawValue).tag(env.rawValue)
                            }
                        }
                        .onChange(of: environment, perform: { value in
                            guard let newEnv = APNSEnvironment(rawValue: value) else { return }
                            payloadBody.environment = newEnv
                        })
                    } label: {
                        Text("ENVIRONMENT")
                            .font(.headline)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 25.0)
                        .foregroundColor(Color.gray.opacity(0.1))
                )
                
                // Send button
                Button {
                    NSApp.keyWindow?.makeFirstResponder(nil) // Remove text field focuts
                    sendNotification()
                } label: {
                    Text("Send")
                        .font(.title2)
                        .frame(width: 100, height: 40, alignment: .center)
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue))
                }
                .buttonStyle(PlainButtonStyle())
                .alert(isPresented: $showMissingDataAlert, content: {
                    Alert(title: Text("Error"), message: Text("Please fill all mandatory fields"), dismissButton: .default(Text("OK")))
                })
            }
            .padding()
        }
        .frame(width: 500, height: 900, alignment: .top)
        .if(showLoader) { view in
            view.overlayModal(isPresented: $showLoader) {
                loadingOverlay
            }
        }
    }
    
    @ViewBuilder private var loadingOverlay: some View {
        if showLoader {
            ZStack {
                Rectangle()
                    .fill(Color.black.opacity(0.3))
                ActivityIndicator(shouldAnimate: $showLoader)
            }
        }
    }
}

extension ContentView {
    private func handleFileDrop(provider: NSItemProvider) {
        _ = provider.loadObject(ofClass: URL.self) { url, _ in
            guard let url = url else { return }
            let filename = url.lastPathComponent
            
            if filename.hasSuffix(".p8") {
                file.fileUrl = url
                self.filename = filename
                
                DispatchQueue.main.async {
                    print("Good file\n\(file)")
                }
            }
            else {
                print("Bad file")
            }
        }
    }
    
    private func refreshNotificationId() {
        header.notificationId = UUID().uuidString
    }
    
    private func sendNotification() {
        guard file.isValid && header.isValid && payloadBody.isValid else {
            showMissingDataAlert = true
            return
        }
        showLoader.toggle()
        apnsSender.sendNotification(file: file, header: header, payload: payloadBody, handler: { result in
            showLoader.toggle()
            switch result {
            case .success(let apnsId):
                apnsResultTitle = "Success"
                apnsResultMessage = "APNS sent successfully with apns-id\n\(apnsId)"
                showAPNSResultAlert = true
                refreshNotificationId()
                
            case .failure(let apnsError):
                apnsResultTitle = "Error"
                apnsResultMessage = apnsError.errorDescription
                showAPNSResultAlert = true
            }
        })
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(width: 500, height: 850, alignment: .top)
    }
}
#endif
