Pod::Spec.new do |s|
  s.name             = "RichEditorSwiftUI"
  s.version          = "1.0.0"
  s.summary          = "Rich text editing, SwiftUI rich text editor library."

  s.description      = <<-DESC
    Wrapper around UITextView to support Rich text editing in SwiftUI.
                       DESC

  s.homepage         = "https://github.com/canopas/RichEditorSwiftUI"
  s.license          = { :type => "MIT", :file => "LICENSE.md" }
  s.author           = { "Jimmy" => "jimmy@canopas.com" }
  s.source           = { :git => "https://github.com/canopas/rich-editor-swiftui.git", :tag => s.version.to_s }
  s.source_files     = "Sources/**/*.swift"
  s.social_media_url = 'https://twitter.com/canopassoftware'

  s.module_name      = 'RichEditorSwiftUI'
  s.requires_arc     = true
  s.swift_version    = '5.5'

  s.preserve_paths   = 'README.md'

  s.ios.deployment_target     = '14.0'
end
