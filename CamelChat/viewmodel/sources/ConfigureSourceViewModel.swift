//
//  ConfigureSourceViewModel.swift
//  Camel
//
//  Created by Alex Rozanski on 30/03/2023.
//

import SwiftUI
import Combine

protocol ConfigureSourceNavigationViewModelDelegate: AnyObject {
  func goBack()
  func next()
}

class ConfigureSourceNavigationViewModel: ObservableObject {
  @Published var canContinue: Bool = false

  weak var delegate: ConfigureSourceNavigationViewModelDelegate?

  init() {
    canContinue = false
  }

  func goBack() {
    delegate?.goBack()
  }

  func next() {
    delegate?.next()
  }
}

struct ConfigureSourceNavigationView: View {
  @ObservedObject var viewModel: ConfigureSourceNavigationViewModel
  var presentationStyle: AddSourceFlowPresentationStyle

  var body: some View {
    HStack {
      if presentationStyle.showBackButton {
        Button("Back") {
          viewModel.goBack()
        }
      }
      Spacer()
      Button("Add") {
        viewModel.next()
      }
      .keyboardShortcut(.return)
      .disabled(!viewModel.canContinue)
    }
  }
}

protocol ConfigureSourceViewModel {
  var navigationViewModel: ConfigureSourceNavigationViewModel { get }
}

func makeConfigureLocalLlamaModelSourceViewModel(
  addSourceHandler: @escaping ConfigureLocalModelSourceViewModel.AddSourceHandler,
  goBackHandler: @escaping ConfigureLocalModelSourceViewModel.GoBackHandler
) -> ConfigureLocalModelSourceViewModel {
  return ConfigureLocalModelSourceViewModel(
    defaultName: "LLaMa",
    chatSourceType: .llama,
    exampleModelPath: "ggml-model-q4_0.bin",
    addSourceHandler: addSourceHandler,
    goBackHandler: goBackHandler
  )
}

func makeConfigureLocalAlpacaModelSourceViewModel(
  addSourceHandler: @escaping ConfigureLocalModelSourceViewModel.AddSourceHandler,
  goBackHandler: @escaping ConfigureLocalModelSourceViewModel.GoBackHandler
) -> ConfigureLocalModelSourceViewModel {
  return ConfigureLocalModelSourceViewModel(
    defaultName: "Alpaca",
    chatSourceType: .alpaca,
    exampleModelPath: "ggml-alpaca-7b-q4.bin",
    addSourceHandler: addSourceHandler,
    goBackHandler: goBackHandler
  )
}

func makeConfigureLocalGPT4AllModelSourceViewModel(
  addSourceHandler: @escaping ConfigureLocalModelSourceViewModel.AddSourceHandler,
  goBackHandler: @escaping ConfigureLocalModelSourceViewModel.GoBackHandler
) -> ConfigureLocalModelSourceViewModel {
  return ConfigureLocalModelSourceViewModel(
    defaultName: "GPT4All",
    chatSourceType: .gpt4All,
    exampleModelPath: "gpt4all-lora-quantized.bin",
    addSourceHandler: addSourceHandler,
    goBackHandler: goBackHandler
  )
}

@ViewBuilder func makeConfigureSourceView(
  from viewModel: ConfigureSourceViewModel,
  presentationStyle: AddSourceFlowPresentationStyle
) -> some View {
  VStack {
    if let viewModel = viewModel as? ConfigureLocalModelSourceViewModel {
      ConfigureLocalModelSourceView(viewModel: viewModel, presentationStyle: presentationStyle)
    } else {
      EmptyView()
    }
    Spacer()
    ConfigureSourceNavigationView(viewModel: viewModel.navigationViewModel, presentationStyle: presentationStyle)
      .padding()
  }
}
