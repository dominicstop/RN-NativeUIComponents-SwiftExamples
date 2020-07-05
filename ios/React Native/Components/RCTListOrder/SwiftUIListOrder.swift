//
//  SwiftUIListOrder.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 7/4/20.
//

import SwiftUI



struct SwiftUIListOrder: View {
  
  @State var isEditable = true;
  @State var descLabel  = "Description: ";
  
  @ObservedObject var listOrderVM = ListOrderViewModel();
  
  var body: some View {
    List {
      ForEach(listOrderVM.listItems.indices, id: \.self) { index in
        VStack(alignment: .leading) {
          Group {
            Unwrap(self.listOrderVM.listItems[index].title){ title in
              Text("\(index + 1). ")
                .fontWeight(.bold)
                .foregroundColor(.blue)
              + Text(title);
            };
          }
          .lineLimit(2)
          .padding(.bottom, 2.0);
          
          Unwrap(self.listOrderVM.listItems[index].description){ desc in
            Text(self.descLabel)
              .fontWeight(.bold)
            + Text(desc)
              .fontWeight(.light)
          };
        }
        .listRowInsets( EdgeInsets(
          top     : 10,
          leading : self.isEditable ? -20 : 15,
          bottom  : 10,
          trailing: 15
        ))
      }
      .onMove(perform: move)
    }
    .environment(\.editMode, isEditable ? .constant(.active) : .constant(.inactive))
  }
  
  func move(from source: IndexSet, to destination: Int) {
    self.listOrderVM
        .listItems
        .move(fromOffsets: source, toOffset: destination)
  }
}

struct SwiftUIListOrder_Previews: PreviewProvider {
  static var previews: some View {
    SwiftUIListOrder(
      isEditable: false,
      descLabel : "Desc: ",
      listOrderVM: ListOrderViewModel()
    )
  }
}
