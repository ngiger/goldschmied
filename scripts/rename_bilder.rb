#!/usr/bin/env ruby
# encoding: utf-8
# Copyright 2013 Niklaus Giger niklaus.giger@member.fsf.org

# Small helper script to rename Rolf Müllers old images file to the new convention
# Bilder sind alleine ca. 480 MB gross

require 'fileutils'

pfad = 'Mueller2/bil*'
nrFilesSeen = 0
nrFilesSkipped = 0
files = (Dir.glob("#{pfad}/**/*.jpg") + Dir.glob("#{pfad}/**/*.tif")).sort
files.each{ 
  |name|
    pfad = File.dirname(name)
    prefix = File.basename(pfad)
    base = File.basename(name)
    if base.index('-') == 4 or not /^\d\d\d\d$/.match(prefix)
      nrFilesSkipped += 1
      puts "Skipping #{name}"
      next
    end
    neuerName = "#{pfad}/#{prefix}-#{base.sub(/^(\d\d\d\d)(\d+)(\..*)/, '\1-\2\3')}"
    FileUtils.mv( name, neuerName, :verbose => true, :noop => false)
}
puts "#{__FILE__} considered #{files.size} files. Skipped #{nrFilesSkipped}"
