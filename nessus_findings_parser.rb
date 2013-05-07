#!/usr/bin/env ruby
require 'csv'
require 'trollop'

opts = Trollop::options do
  opt :nessus_plugin_path, "Path to Nessus plugins (.nasl)", :type => String, :short => 'i', :required => true
  opt :output_filename, "Output filename", :type => String, :short => 'o', :required => true
end

# Do some rudimentary user input validation
if !File.directory? opts[:nessus_plugin_path]
  puts "#{opts[:nessus_plugin_path]} does not exist."
  exit
end

nessus_plugin_path = File.join(opts[:nessus_plugin_path], '**', '*.nasl')
nasl_count = Dir[nessus_plugin_path].count { |file| File.file?(file) }
if nasl_count == 0
  puts "No .nasl files found in #{opts[:nessus_plugin_path]}. Are you you sure the path is correct?"
  exit
end

CSV.open(opts[:output_filename], "w") do |csv|
  Dir.glob(nessus_plugin_path) do |nasl_file|
    file = File.open(nasl_file)
    regex = /script_id\((\d*)\).*name\[\"english"\]\s*=\s*\"([^"]+)\";|script_id\((\d*)\).*script_name\(english:\s*\"([^\"]+)\"/m
    # Do double-encoding to fix any UTF-8 errors that typically happen
    match = file.read.encode!('UTF-8', 'UTF-8', :invalid => :replace).scan(regex)[0]
    if !match.nil?
      file_name = File.basename(nasl_file)
      finding_id ||= match[0]
      finding_id ||= match[2]
      finding_name ||= match[1]
      finding_name ||= match[3]
      csv << %W(#{finding_name} #{file_name} #{finding_id})
      puts "\"#{finding_name}\",#{file_name},#{finding_id}"
    end
  end
end
