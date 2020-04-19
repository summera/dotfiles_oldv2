require "rake"
require "fileutils"

task :install do
  install_homebrew
  install_brew_packages

  install_apps
  file_operation(Dir.glob("apps/hammerspoon"))
  install_iterm_theme

  install_rbenv
  file_operation(Dir.glob("langs/ruby/*"))

  file_operation(Dir.glob("cli/git/*"))
  file_operation(Dir.glob("cli/ag/*"))
  file_operation(Dir.glob("cli/ctags/*"))
  file_operation(Dir.glob("cli/tmux/*"))
  file_operation(Dir.glob("cli/readline/*"))

  file_operation(Dir.glob('editors/vim'))
  file_operation(Dir.glob('editors/nvim'), :symlink, true)
  install_vim_plugins

  configure_zsh
end

task :default => "install"

def install_homebrew
  if installed?("brew")
    log_with_separator("Homebrew already installed.")
  else
    log_with_separator("Installing Homebrew")
    run(%{ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"})
  end
end

def install_rbenv
  if installed?("rbenv")
    log_with_separator("rbenv already installed.")
    run("which ruby")
  else
    log_with_separator("Installing rbenv.")
    run("brew install rbenv")
    run("rbenv init")

    log_with_separator("Installing rbenv-default-gems")
    run("git clone https://github.com/rbenv/rbenv-default-gems.git $(rbenv root)/plugins/rbenv-default-gems")
    symlink_from_cwd("version_managers/rbenv/default-gems", "$(rbenv root)/default-gems")
  end
end

def install_nvm
  # TODO
  #
  # if installed?("nvm")
  #   log_with_separator("Node version manager already installed.")
  # else
  #   log_with_separator("Installing node version manager.")
  #   run("curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash")
  # end
end

def install_python
  # TODO
end

def setup_macos
  # TODO
end

def configure_zsh
  puts "======================================================"
  puts "Installing prezto."
  puts "======================================================"
  puts ""

  run("git clone --recursive https://github.com/sorin-ionescu/prezto.git ${ZDOTDIR:-$HOME}/.zprezto")

  puts "Configuring symlinks..."
  Dir.glob("#{ENV["HOME"]}/.zprezto/runcoms/z*").each do |file|
    target = "${ZDOTDIR:-$HOME}/.#{File.basename(file)}"
    puts "Source: #{file}"
    puts "Target: #{target}"
    run("ln -nfs #{file} #{target}")
  end

  file_operation(Dir.glob("cli/zsh/prezto_overrides/*"))

  run("mkdir -p #{ENV["HOME"]}/.zsh")
  Dir.glob("cli/zsh/*.zsh").each do |file|
    target = "#{ENV["HOME"]}/.zsh/#{File.basename(file)}"
    source = "#{ENV["PWD"]}/#{file}"
    puts "Source: #{source}"
    puts "Target: #{target}"
    run("ln -nfs #{source} #{target}")
  end

  # Set default shell to zsh
  run("chsh -s /bin/zsh")
end

def install_vim_plugins
  puts "======================================================"
  puts "Installing and updating vim plugins."
  puts "======================================================"
  puts ""

  plug_path = File.join(ENV["HOME"], "vim", "autoload")
  unless File.exists? plug_path
    run %{
      mkdir -p ~/.vim/autoload
      curl -fLo ~/.vim/autoload/plug.vim \
          https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    }
  end

  # Install/update plugins
  system "vim --noplugin -u #{ENV["HOME"]}/.vim/plugs.vim -N " \
    "\"+set hidden\" \"+syntax on\" +PlugClean +PlugInstall +qall"
end

def install_brew_packages
  log_with_separator("Installing Homebrew packages.")
  run("brew install zsh ctags git hub tmux reattach-to-user-namespace the_silver_searcher fasd python neovim")

  # Python 3 support for neovim. This is needed for deoplete vim plugin
  run("pip3 install --upgrade pynvim")
end

def install_apps
  log_with_separator("Installing apps with Homebrew cask.")
  run("brew tap homebrew/cask-drivers") # Needed for sonos

  run("brew cask install iterm2") unless app_installed?("iTerm")
  run("brew cask install sourcetree") unless app_installed?("Sourcetree")
  run("brew cask install google-chrome") unless app_installed?("Google Chrome")
  run("brew cask install hammerspoon") unless app_installed?("Hammerspoon")
  run("brew cask install sublime-text") unless app_installed?("Sublime Text")
  run("brew cask install spotify") unless app_installed?("Spotify")
  run("brew cask install 1password") unless app_installed?("1Password")
  run("brew cask install slack") unless app_installed?("Slack")
  run("brew cask install docker") unless app_installed?("Docker")
  run("brew cask install firefox") unless app_installed?("Firefox")
  run("brew cask install timing") unless app_installed?("Timing")
  run("brew cask install sonos") unless app_installed?("Sonos")
end

def install_iterm_theme
  if !File.exists?(File.join(ENV["HOME"], "/Library/Preferences/com.googlecode.iterm2.plist"))
    puts "======================================================"
    puts "Please check your color settings in iTerm2 to make sure things are swell."
    puts "Preferences> Profiles> [your profile]> Colors> Load Preset.."
    puts "======================================================"
    return
  end

  # Ask the user which theme he wants to install
  message = "Which theme would you like to apply to your iTerm2 profile?"
  color_scheme = ask message, iterm_available_themes

  return if color_scheme == "None"

  color_scheme_file = File.join("apps/iterm", "#{color_scheme}.itermcolors")

  # Ask the user on which profile he wants to install the theme
  profiles = iterm_profile_list
  message = "I've found #{profiles.size} #{profiles.size > 1 ? "profiles": "profile"} on your iTerm2 configuration, which one would you like to apply the color theme to?"
  profiles << "All"
  selected = ask message, profiles

  if selected == 'All'
    (profiles.size-1).times { |idx| apply_theme_to_iterm_profile_idx idx, color_scheme_file }
  else
    apply_theme_to_iterm_profile_idx profiles.index(selected), color_scheme_file
  end
end

def iterm_available_themes
   Dir["apps/iterm/*.itermcolors"].map { |value| File.basename(value, ".itermcolors") } << "None"
end

def iterm_profile_list
  profiles = Array.new

  begin
    profiles <<  %x{ /usr/libexec/PlistBuddy -c "Print :'New Bookmarks':#{profiles.size}:Name" ~/Library/Preferences/com.googlecode.iterm2.plist 2>/dev/null }
  end while $?.exitstatus==0

  profiles.pop
  profiles
end

def apply_theme_to_iterm_profile_idx(index, color_scheme_path)
  values = Array.new
  16.times { |i| values << "Ansi #{i} Color" }
  values << ["Background Color", "Bold Color", "Cursor Color", "Cursor Text Color", "Foreground Color", "Selected Text Color", "Selection Color"]
  values.flatten.each { |entry| run %{ /usr/libexec/PlistBuddy -c "Delete :'New Bookmarks':#{index}:'#{entry}'" ~/Library/Preferences/com.googlecode.iterm2.plist } }

  run %{ /usr/libexec/PlistBuddy -c "Merge '#{color_scheme_path}' :'New Bookmarks':#{index}" ~/Library/Preferences/com.googlecode.iterm2.plist }
  run %{ defaults read com.googlecode.iterm2 }
end

private

def ask(message, values)
  puts message
  while true
    values.each_with_index { |val, idx| puts " #{idx+1}. #{val}" }
    selection = STDIN.gets.chomp
    if (Float(selection)==nil rescue true) || selection.to_i < 0 || selection.to_i > values.size+1
      puts "ERROR: Invalid selection.\n\n"
    else
      break
    end
  end
  selection = selection.to_i-1
  values[selection]
end

def installed?(cmd)
  `which #{cmd}`
end

def app_installed?(app)
  !`system_profiler SPApplicationsDataType | grep -i -w "#{app}"`.to_s.strip.empty?
end

def run(cmd)
  puts "[Running] #{cmd}"
  system(cmd) unless ENV['DEBUG']
  puts ""
end

def log_with_separator(message = nil, &block)
  puts ""
  puts "======================================================"
  puts message if message
  yield($stdout) if block_given?
  puts "======================================================"
  puts ""
end

def symlink_from_cwd(source, target)
  run(%{ ln -nfs #{current_working_dir}/#{source} #{target} })
end

def file_operation(files, method = :symlink, xdg_config = false)
  files.each do |f|
    file = f.split('/').last
    source = "#{ENV["PWD"]}/#{f}"

    if xdg_config
      run %{ mkdir -p #{ENV["HOME"]}/.config }
      target = "#{ENV["HOME"]}/.config/#{file}"
    else
      target = "#{ENV["HOME"]}/.#{file}"
    end

    puts "======================#{file}=============================="
    puts "Source: #{source}"
    puts "Target: #{target}"

    if File.exists?(target) && (!File.symlink?(target) || (File.symlink?(target) && File.readlink(target) != source))
      puts "[Overwriting] #{target}...leaving original at #{target}.backup..."
      run %{mv "#{target}" "#{target}.backup"}
    end

    if method == :symlink
      run %{ ln -nfs "#{source}" "#{target}" }
    else
      run %{ cp -f "#{source}" "#{target}" }
    end

    puts "=========================================================="
    puts
  end
end

def home
  ENV["HOME"]
end

def current_working_dir
  ENV["PWD"]
end
