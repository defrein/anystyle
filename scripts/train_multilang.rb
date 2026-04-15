#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# Script untuk menggabungkan semua dataset multi-bahasa menjadi satu file XML
# Usage:
#   ruby scripts/train_multilang.rb combine    # Gabungkan semua bahasa
#   ruby scripts/train_multilang.rb stats      # Tampilkan statistik

require 'fileutils'
require 'nokogiri'

class MultilingualTrainer
  LANG_DIR = 'res/parser/lang'
  OUTPUT_FILE = 'res/parser/multilang_combined.xml'

  def initialize
    FileUtils.mkdir_p(File.dirname(OUTPUT_FILE))
  end

  # Dapatkan daftar semua bahasa
  def languages
    Dir.glob("#{LANG_DIR}/*/").map { |d| File.basename(d) }.sort
  end

  # Dapatkan daftar file XML untuk satu bahasa
  def language_files(lang)
    Dir.glob("#{LANG_DIR}/#{lang}/*.xml").sort
  end

  # Baca file XML dan extract semua sequence
  def read_sequences(file)
    doc = Nokogiri::XML(File.read(file))
    doc.xpath('//sequence')
  rescue => e
    puts "❌ ERROR membaca #{file}: #{e.message}"
    []
  end

  # Gabungkan semua XML dari semua bahasa + core.xml ke 1 file
  def combine
    puts "🔄 Menggabungkan dataset dari core.xml + semua bahasa...\n"

    builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.dataset do
        # Include core.xml first
        core_file = 'res/parser/core.xml'
        if File.exist?(core_file)
          print "  📂 core.xml..."
          sequences = read_sequences(core_file)
          count = sequences.length
          sequences.each { |seq| xml << seq.to_xml }
          puts " ✓ #{count} referensi"
        end

        # Include all language files
        languages.each do |lang|
          print "  📂 #{lang}..."
          count = 0
          
          language_files(lang).each do |file|
            sequences = read_sequences(file)
            count += sequences.length
            sequences.each { |seq| xml << seq.to_xml }
          end
          
          puts " ✓ #{count} referensi"
        end
      end
    end

    File.write(OUTPUT_FILE, builder.to_xml)
    puts "\n✅ Berhasil! Dataset disimpan: #{OUTPUT_FILE}\n"
    show_stats
  end

  # Tampilkan statistik
  def show_stats
    puts "\n📊 STATISTIK DATASET\n"
    puts "%-20s %10s" % ["Source", "Referensi"]
    puts "-" * 35
    
    grand_total = 0
    
    # Core.xml
    core_file = 'res/parser/core.xml'
    if File.exist?(core_file)
      count = read_sequences(core_file).length
      grand_total += count
      puts "%-20s %10d" % ["core.xml", count]
    end
    
    # Languages
    languages.each do |lang|
      count = language_files(lang).sum { |f| read_sequences(f).length }
      grand_total += count
      puts "%-20s %10d" % [lang, count]
    end
    
    puts "-" * 35
    puts "%-20s %10d\n" % ["TOTAL", grand_total]
  end
end

# Main execution
if __FILE__ == $0
  trainer = MultilingualTrainer.new
  action = ARGV[0] || 'help'

  case action
  when 'combine'
    trainer.combine
  when 'stats'
    trainer.show_stats
  when 'help', '-h', '--help'
    puts <<~HELP
      🛠️  MULTILINGUAL DATASET COMBINER

      Usage: ruby scripts/train_multilang.rb [command]

      Commands:
        combine    - Gabungkan semua bahasa → 1 file XML (DEFAULT)
        stats      - Tampilkan statistik dataset
        help       - Tampilkan bantuan ini

      Examples:
        ruby scripts/train_multilang.rb combine
        ruby scripts/train_multilang.rb stats

      Next step after combine:
        anystyle train res/parser/multilang_combined.xml res/models/multilang.mod

    HELP
  else
    puts "❌ Perintah tidak dikenal: #{action}\n"
    puts "Gunakan: ruby scripts/train_multilang.rb help"
    exit 1
  end
end
