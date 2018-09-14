#!/usr/bin/env ruby
require 'getoptlong'


DEFAULT_MIN_R = 1
DEFAULT_MAX_R = 100
MIN_R = DEFAULT_MIN_R
MAX_R = DEFAULT_MAX_R

DEFAULT_MIN_PBAS = 1
DEFAULT_MAX_PBAS = 127
MIN_PBAS = DEFAULT_MIN_PBAS
MAX_PBAS = DEFAULT_MAX_PBAS

filename = ''

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--file', '-f', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--minr', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--maxr', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--minpbas', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--maxpbas', GetoptLong::OPTIONAL_ARGUMENT ],
)

opts.each do |opt, arg|
    case opt
      when '--help'
        puts <<-EOF
  saystuff.rb [OPTIONS] -f FILENAME
  
  -h, --help:
     show help

  -f FILENAME
        File to read out loud in random voices

  --minr/maxr
        minimum/maximum -r parameter

  --minpbas/maxpbas
        min/max [[pbas NUMBER]] for pitch control
        EOF
      when '--file'
        filename = arg
      when '--minr'
        MIN_R if arg != ''
      when '--mmaxr'
        MAX_R if arg != ''
      when '--minpbas'
        MIN_PBAS if arg != ''
      when '--maxpbas'
        MAX_PBAS if arg != ''
    end
  end
  if filename == ''
    puts "\nPlease provide --file FILENAME option"
    exit 1
  end

  puts "Reading file: #{filename}"

file = File.open("#{filename}")
contents = file.read
file.close
contents.gsub!(/[^\s\d\w]*/, '')
voices = `say -v ?|cut -f 1 -d ' '`.split("\n")

strings = contents.split()
strings.each { |s| system("say -r #{rand(MIN_R..MAX_R)} -v #{voices.sample} [[pbas #{rand(MIN_PBAS..MAX_PBAS)}]]#{s}") }
