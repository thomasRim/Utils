#!/usr/bin/ruby
require 'fileutils'

#
# Functions and variables
#

@abort_msg = 'Option variable should be a path to project folder with pods!!!
Usage:
  podrun.rb [-help] [-npcp] [-ncpc] directory '
@log_file = 'podinstall.log'

def run_osascript(script_command)
  run_string = "osascript -e \'#{script_command}\'"
  system(run_string)
end

def simulator_close()
  run_osascript('if application "Simulator" is open, tell application "Simulator" to quit')
end

def xcode_close()
  run_osascript('tell application "Xcode" to quit')
end

def logger_open()
  system("open "+@log_file)
end

def logger_close()
  run_osascript('tell application "Console" to quit')
end

def prepare_clear_project()
  FileUtils.rm_rf('Pods')
  FileUtils.rm_rf('Podfile.lock')
  FileUtils.rm_rf(Dir.glob('*xcworkspace'))
end

def clear_pods_cache() 
  $stdout.write('clear pods cache' + "\n")
  $stdout.write('----------' + "\n")
  system('pod cache clean --all')
  $stdout.write('update pods up-to-date' + "\n")
  $stdout.write('----------' + "\n")
  system('pod repo update')
end

def pod_install()
  $stdout.write('install pods' + "\n")
  $stdout.write('----------' + "\n")
  system('pod install')
end

def parse(args)
  parsed = {}

  args.each do |arg|
    match = /^-?-(?<key>.*?)(=(?<value>.*)|)$/.match(arg)
    if match
      parsed[match[:key].to_sym] = match[:value]
    else
      parsed[:text] = "#{parsed[:text]} #{arg}".strip
    end
  end
  parsed
end

HELP = <<ENDHELP
   -help            Show this help.
   -npcp            No prepare crear project. Do not remove Podfile.lock and Pods
   -ncpc            No clear pods cache. Try to use current installed pods.

ENDHELP

#
# Main flow
#

abort(@abort_msg) if ARGV.count.zero?

@parsed = parse(ARGV)
if @parsed.has_key? :help
  puts HELP
  exit
end
@no_clear_pod_cache = @parsed.has_key? :ncpc
@no_prepare_clear_project = @parsed.has_key? :npcp

@project_dir = @parsed[:text]


Dir.chdir(@project_dir)

File.new(@log_file, 'a+')
$stdout.reopen(@log_file, 'a+')
$stdout.sync = true
$stderr.reopen($stdout)

unless File.file?('Podfile')
  $stdout.write("\n\n\n" + 'Please check if Podfile exists!' + "\n\n\n")
  $stdout = STDOUT
  abort('Please check if Podfile exists!')
end

xcode_close()
simulator_close()
unless @no_prepare_clear_project
  prepare_clear_project()
end
logger_open()

$stdout.write('//--------------------------//' + "\n")
$stdout.write('// ' + Time.now.gmtime.to_s + "\n")
$stdout.write('//--------------------------//' + "\n")
$stdout.write('Project folder..' + "\n")
$stdout.write(@project_dir + "\n")
$stdout.write('----------' + "\n")
unless @no_clear_pod_cache 
  clear_pods_cache()
end
pod_install()

logger_close()

workspace = Dir.glob('*xcworkspace')
system('open ' + Dir.pwd + '/' + workspace.first) unless workspace.count.zero?
$stdout = STDOUT
