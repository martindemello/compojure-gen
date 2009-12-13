#!/bin/env ruby

require 'fileutils'
require 'yaml'
require 'erb'

include FileUtils

unless ARGV[0]
  puts "usage: #$0 <project-name> [<display-name>]"
  exit
end

$project = ARGV[0]
$dir = File.dirname($0)

config = YAML.load(IO.read("#$dir/app-engine/config.yml"))

# write skeleton files
project = $project
compojure = config['compojure']
appengine_sdk_jar = config['appengine_sdk_jar']
appengine_sdk_dir = config['appengine_sdk_dir']
appengine_clj_jar = config['appengine_clj_jar']
display_name = ARGV[1] || $project
servlet_name = $project

b = binding

files = nil
skel = "#$dir/app-engine/skel"
Dir.chdir(skel) {|d| files = Dir['**/*']}
files.each do |f|
  sfile = "#{skel}/#{f}"
  ofile = "#$project/#{f}"
  if File.directory? sfile
    mkdir_p ofile
  else
    template = ERB.new(IO.read(sfile))
    File.open(ofile, 'w') do |out|
      out.puts template.result(b)
    end
  end
end

mv "#$project/src/project", "#$project/src/#$project"
