//
//  EffectImageView.swift
//  MemoryLeakDemo
//
//  Created by 정재성 on 5/31/25.
//

import SwiftUI
import HostingView
import VariableBlur

final class EffectImageView: UIView {
  private let contentView: StatefulHostingView<UIImage?>

  var image: UIImage? {
    get { contentView.state }
    set { contentView.state = newValue }
  }

  override var intrinsicContentSize: CGSize { image?.size ?? .zero }

  init(image: UIImage? = nil) {
    self.contentView = StatefulHostingView(state: image) { image in
      Rectangle()
        .foregroundStyle(.placeholder)
        .overlay {
          if let image {
            Image(uiImage: image)
              .resizable()
              .aspectRatio(contentMode: .fill)
          }
        }
        .overlay {
          GeometryReader { proxy in
            VStack {
              Spacer()
              ZStack {
                VariableBlurView(maxBlurRadius: 10, direction: .blurredBottomClearTop)
                Rectangle()
                  .foregroundStyle(.linearGradient(colors: [.black.opacity(0.5), .clear], startPoint: .bottom, endPoint: .top))
              }
              .frame(height: proxy.size.height * 0.3)
            }
          }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    super.init(frame: .zero)
    addSubview(contentView)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.frame = bounds
  }
}

// MARK: - EffectImageView Preview

#Preview {
  EffectImageView(image: .image4)
}
