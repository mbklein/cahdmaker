require "cahdmaker/version"
require 'RMagick'

module Cahdmaker
  class Maker
    attr_reader :opts
    
    def initialize(opts={})
      @opts = { magick: '/usr/local/bin/convert', text_size: 60, blank_size: 8 }.merge(opts)
    end
    
    def black(text, pick=1)
      make_card(text, "Black#{pick}")
    end
    
    def black2(text)
      black(text, 2)
    end
    
    def black3(text)
      black(text, 3)
    end
    
    def white(text)
      make_card(text, "White")
    end
    
    def make_card(text, source_card)
      text_size = opts[:text_size]
      color = source_card =~ /White/i ? 'black' : 'white'
      text.gsub! /\b_+\b/, ('_' * opts[:blank_size])

      capfile = File.join(Dir.tmpdir, Dir::Tmpname.make_tmpname(['caption','.png'],nil))
      args = [
        opts[:magick], '-background', 'transparent',  '-size', '600x600', 
        '-pointsize', text_size.to_s, '-fill', color.to_s, 
        '-interline-spacing', (text_size/3).to_s,
        '-font', 'Helvetica-Bold',
        "caption:#{text}", capfile
      ]
      Kernel.system(*args)
      cap = Magick::Image.read(capfile).first

      img = Magick::Image.read(File.expand_path("../../cards/CAH_#{source_card}.png",__FILE__)).first
      img.x_resolution = img.y_resolution = 300
      img.composite!(cap, 75, 75, Magick::OverCompositeOp)
      img.to_blob
    end
  end
end
