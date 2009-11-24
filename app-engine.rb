#!/bin/env ruby

require 'fileutils'
require 'yaml'
require 'erb'

include FileUtils

$project = ARGV[0]
$dir = File.dirname($0)

config = YAML.load(IO.read("#$dir/app-engine/config.yml"))

# set up directory structure
['src/', 'war/WEB-INF/classes', 'war/WEB-INF/lib'].each do |dir|
  mkdir_p "#$project/#{dir}"
end

# copy jars
%w(clojure contrib compojure appengine_sdk appengine_clj).each do |jar|
  cp config[jar], "#$project/war/WEB-INF/lib/"
end

# write build.xml
template = ERB.new(IO.read("#$dir/app-engine/build.xml"))
project = $project
compojure = config['compojure']
appengine_sdk = config['appengine_sdk']
appengine_clj = config['appengine_clj']
b = binding
File.open("#$project/build.xml", 'w') {|f|
  f.puts template.result(b)
}
