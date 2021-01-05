//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Tajwar Rahman on 1/4/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI
import CodeScanner
import UserNotifications

struct ProspectsView: View {
    enum  FilterType {
        case none, contacted, uncontacted
    }
    
    enum Sort {
        case name, recent
    }
    
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    @State private var isSorting = false
    @State private var sort : Sort = .name
    
    let filter: FilterType
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    var filteredProspects: [Prospect] {
        let filterOrder = sort == .name ? prospects.people.sorted { $0.name < $1.name } : prospects.people.sorted { $0.added > $1.added }
        
        switch filter {
            case .none:
                return filterOrder
            case .contacted:
                return filterOrder.filter { $0.isContacted }
            case .uncontacted:
                return filterOrder.filter { !$0.isContacted }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
                    HStack{
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.email)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: prospect.isContacted ? "checkmark.circle.fill" : "checkmark.circle")
                    }
                    .contextMenu {
                        Button(prospect.isContacted ? "Mark Uncontacted" : "Mark Contacted") {
                            self.prospects.toggle(prospect)
                        }
                        
                        if !prospect.isContacted {
                            Button("Remind Me") {
                                self.addNotification(for: prospect)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(title)
            .navigationBarItems(trailing: Button(action: {
                self.isShowingScanner = true
            }) {
                Image(systemName: "qrcode.viewfinder")
                Text("Scan")
            })
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "PaulHudson\npaul@hudsonswift.com", completion: self.handleScan)
            }
            .actionSheet(isPresented: $isSorting) { () -> ActionSheet in
                ActionSheet(title: Text("Sort Contacts"), message: Text("Select sorting style"), buttons: [
                    .default(Text("Sort by name")) { self.sort = .name },
                    .default(Text("Sort by recency")) { self.sort = .recent },
                    .cancel()
                ])
            }
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        
        switch result {
        case .success(let code):
            let details = code.components(separatedBy: "\n")
            guard details.count == 2 else {return}
            
            let person = Prospect()
            person.name = details[0]
            person.email = details[1]
            self.prospects.add(person)
            
        case .failure(_):
            print("Scanning failed")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.email
            content.sound = UNNotificationSound.default
            
//            var dateComponents = DateComponents()
//            dateComponents.hour = 9
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            }
            else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    }
                    else {
                        print("Rip")
                    }
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}
