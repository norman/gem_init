require "fileutils"
require "shellwords"
require "erb"

module GemInit
  class App
    include FileUtils

    attr :gem_name
    attr :module_name
    attr :templates

    DEFAULT_GIT_CONFIG = {
      :user => {
        :name  => "YOUR NAME",
        :email => "YOUR EMAIL",
      },
      :github => {
        :name => "your_github_user_name"
      }
    }

    def initialize(gem_name)
      @gem_name  = gem_name.downcase
      @templates = File.expand_path("../templates",  __FILE__)
    end

    def main
      if File.exists?(gem_name)
        raise "Directory '#{gem_name}' already exists, bailing out."
      end
      mkdir_p module_lib_dir
      mkdir_p test_dir
      write_template(lib_dir, "module.rb", "#{gem_name}.rb")
      write_template(module_lib_dir, "version.rb")
      write_template(test_dir, "test_helper.rb")
      write_template(test_dir, "module_test.rb", "#{gem_name}_test.rb")
      write_template(gem_name, "gemspec", "#{gem_name}.gemspec")
      write_template(gem_name, "Gemfile.default")
      write_template(gem_name, "Gemfile.default", "Gemfile")
      write_template(gem_name, "Rakefile")
      write_template(gem_name, "MIT-LICENSE")
      write_template(gem_name, "README.md")
      write_template(gem_name, "gitignore", ".gitignore")
      `git init #{gem_name.shellescape}`
    end

    def author
      @author ||= git_config[:user][:name]
    end

    def email
      @email ||= git_config[:user][:email]
    end

    def github_user
      @github_user ||= git_config[:github][:user]
    end

    private

    def git_config
      @git_config ||= read_git_config || DEFAULT_GIT_CONFIG
    end

    def read_git_config
      begin
        config = {}
        key = nil
        File.read(File.expand_path("~/.gitconfig")).split("\n").each do |line|
          if line =~ /\A\s?+\[([\w]*)\]\s?+\z/
            key = $1.strip.to_sym
            config[key] = {}
          elsif line =~ /\A\s?+(.*)\s?+=\s?+(.*)\s?+\Z/
            config[key][$1.strip.to_sym] = $2
          end
        end
        # Be a tad paranoid and make it harder to accidentally reveal this
        config[:github][:token] = nil
        config
      rescue Errno::ENOENT
        warn "Could not read your ~/.gitconfig, using silly defaults."
      end
    end

    def module_name
      @module_name ||= gem_name.gsub(/\b[\w]|_[\w]/) {|s| s.upcase}.gsub("_", "")
    end

    def lib_dir
      @lib_dir = File.join(gem_name, "lib")
    end

    def module_lib_dir
      @module_lib_dir = File.join(lib_dir, gem_name)
    end

    def test_dir
      @test_dir = File.join(gem_name, "test")
    end

    def write_template(dir, template_name, output_name = nil)
      output_name ||= template_name
      File.open(File.join(dir, output_name), "w") do |file|
        file.write(read_template(template_name))
      end
    end

    def read_template(file_name)
      file = File.join(templates, "#{file_name}.erb")
      File.open(file, "r") do |f|
        ERB.new(f.read).result(binding)
      end
    end
  end
end