# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{pp-colour}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Stefan Penner"]
  s.date = %q{2009-11-25}
  s.description = %q{Tlonger description of your gem}
  s.email = %q{stefan.penner@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/pp-colour.rb",
     "lib/pp-colour/array.rb",
     "lib/pp-colour/file.rb",
     "lib/pp-colour/hash.rb",
     "lib/pp-colour/kernel.rb",
     "lib/pp-colour/matchdata.rb",
     "lib/pp-colour/object.rb",
     "lib/pp-colour/other.rb",
     "lib/pp-colour/range.rb",
     "lib/pp-colour/string.rb",
     "lib/pp-colour/struct.rb",
     "lib/pp-colour/temp.rb",
     "pp-colour.gemspec",
     "test/helper.rb",
     "test/test_pp-colour.rb"
  ]
  s.homepage = %q{http://github.com/stefanpenner/pp-colour}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{T one-line summary of your gem}
  s.test_files = [
    "test/helper.rb",
     "test/test_pp-colour.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
  end
end

