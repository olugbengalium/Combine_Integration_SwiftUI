//
//  SubscriberView.swift
//  CombineSwiftUI
//
//  Created by Gbenga Abayomi on 11/04/2023.
//

import SwiftUI
import Combine

class SubscriberViewModel: ObservableObject {
    @Published var textFieldText: String = " "
    @Published var count: Int = 0
    @Published var testIsValid: Bool = false
    var cancellables = Set<AnyCancellable>()
    
    func setupTimer(){
        Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self]_ in
                self?.count += 1
                if let count = self?.count, count <= 10 {
                    for item in self!.cancellables {
                        item.cancel()
                    }
                }
            }
            .store(in: &cancellables)
    }

    init(){
        setupTimer()
        addTextFieldSubscriber()
    }
    
    func addTextFieldSubscriber(){
        $textFieldText
            .map{ (text) -> Bool in
                if text.count > 3 {
                    return true
                }
                return false
            }
//            .assign(to: \.testIsValid, on: self)
        
            .sink{[weak self] (isValid) in
                self?.testIsValid = isValid
            }
            .store(in: &cancellables)
        
    }
}

struct SubscriberView: View {
    
    @StateObject var vm = SubscriberViewModel()
    var body: some View {
        VStack {
            Text("\(vm.count)")
                .font(.largeTitle)
            Text(vm.testIsValid.description)
                .font(.largeTitle)
            TextField("Enter Text", text: $vm.textFieldText)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .font(.largeTitle)
                .fontWeight(.bold)
                .background(Color(.red))
        }
    }
    

}

struct SubscriberView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriberView()
    }
}
