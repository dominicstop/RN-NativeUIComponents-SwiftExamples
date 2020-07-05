//
//  RCTQuizQuestionEditList.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 7/3/20.
//

import SwiftUI

struct QuizQuestionItem: Hashable {
  var quizID        : String;
  var sectionID     : String;
  var sectionType   : String;
  var questionID    : String;
  var questionText  : String;
  var questionAnswer: String;
}

struct RCTQuizQuestionEditList: View {
  @State var questionItems = [
    QuizQuestionItem(
      quizID        : "quizID-01"      ,
      sectionID     : "sectionID-01"   ,
      sectionType   : "IDENTIFICATION" ,
      questionID    : "questionID-01"  ,
      questionText  : "Question #1"    ,
      questionAnswer: "Question Ans #1"
    ),
    QuizQuestionItem(
      quizID        : "quizID-02"      ,
      sectionID     : "sectionID-02"   ,
      sectionType   : "IDENTIFICATION" ,
      questionID    : "questionID-02"  ,
      questionText  : "Question #2 some very long text here lorum ipsum sit amit dolor aspicing",
      questionAnswer: "Question Ans #2"
    ),
    QuizQuestionItem(
      quizID        : "quizID-03"      ,
      sectionID     : "sectionID-03"   ,
      sectionType   : "IDENTIFICATION" ,
      questionID    : "questionID-03"  ,
      questionText  : "Question #3"    ,
      questionAnswer: "Question Ans #3"
    ),
    QuizQuestionItem(
      quizID        : "quizID-04"      ,
      sectionID     : "sectionID-04"   ,
      sectionType   : "IDENTIFICATION" ,
      questionID    : "questionID-04"  ,
      questionText  : "Question #4"    ,
      questionAnswer: "Question Ans #4"
    )
  ];
  
  @State var fruits = ["Apple", "Banana", "Mango"]
  @State var isEditable = false

  var body: some View {
    List {
      ForEach(questionItems.indices, id: \.self) { index in
        VStack(alignment: .leading) {
          Group {
            Text("\(index + 1). ")
              .fontWeight(.bold)
              .foregroundColor(.blue)
            + Text(self.questionItems[index].questionText)
          }
          .lineLimit(2)
          .padding(.bottom, 2.0)
          
          Text("Answer: ")
            .fontWeight(.bold)
          + Text(self.questionItems[index].questionAnswer)
            .fontWeight(.light)
        }
        .listRowInsets(
          EdgeInsets(
            top     : 10,
            leading : self.isEditable ? -20 : 15,
            bottom  : 10,
            trailing: 15
          ))
      }
      .onMove(perform: move)
      .onLongPressGesture {
        withAnimation {
          self.isEditable.toggle()
        }
      }
    }
    .environment(\.editMode, isEditable ? .constant(.active) : .constant(.inactive))
    .onAppear() {
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        withAnimation {
          //self.isEditable = true;
        }
      }
    }
  }

  func move(from source: IndexSet, to destination: Int) {
    self.questionItems.move(fromOffsets: source, toOffset: destination)
  }
}


struct RCTQuizQuestionEditList_Previews: PreviewProvider {
  static var previews: some View {
    RCTQuizQuestionEditList()
  }
}
