Pod::Spec.new do |s|
  s.name             = 'RichEditorSwiftUI'
  s.version          = '1.0.0'
  s.summary          = 'Powerful WYSIWYG Rich editor for SwiftUI.'

  s.description      = <<-DESC
    Wrapper around UITextView to support Rich text editing in SwiftUI.
                       DESC

  s.homepage         = 'https://github.com/canopas/RichEditorSwiftUI'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'Jimmy' => 'jimmy@canopas.com' }
  s.source           = { :git => 'https://github.com/canopas/rich-editor-swiftui.git', :tag => s.version.to_s }
  s.social_media_url = 'https://x.com/canopas_eng'

  s.source_files     = 'Sources/**/*.swift'

  s.module_name      = 'RichEditorSwiftUI'
  s.requires_arc     = true

  s.swift_version    = '5.9'

  s.ios.deployment_target = '15.0'
  s.osx.deployment_target = '12.0'
  s.tvos.deployment_target = '17.0'
  s.visionos.deployment_target = '1.0'
  s.watchos.deployment_target = '8.0'

  s.preserve_paths   = 'README.md'

end
