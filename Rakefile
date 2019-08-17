require "rake"
require "fileutils"

task :install do
  install_homebrew
  install_brew_packages
  install_apps

  install_rbenv

  file_operation(Dir.glob("cli/git/*"))
  file_operation(Dir.glob("cli/ag/*"))

  file_operation(Dir.glob("langs/ruby/*"))
  file_operation(Dir.glob('cli/ctags/*'))
  file_operation(Dir.glob('cli/tmux/*'))
  file_operation(Dir.glob('cli/readline/*'))

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

def install_brew_packages
  log_with_separator("Installing Homebrew packages.")
  run("brew install zsh ctags git hub tmux reattach-to-user-namespace the_silver_searcher fasd")
  run("brew install neovim")
end

def install_apps
  log_with_separator("Installing apps with Homebrew cask.")
  run("brew tap homebrew/cask-drivers") # Needed for sonos

  run("brew cask install sourcetree")
  run("brew cask install google-chrome")
  run("brew cask install hammerspoon")
  run("brew cask install sublime-text")
  run("brew cask install spotify")
  run("brew cask install 1password")
  run("brew cask install slack")
  run("brew cask install docker")
  run("brew cask install firefox")
  run("brew cask install timing")
  run("brew cask install sonos")
end

private

def installed?(cmd)
  `which #{cmd}`
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
