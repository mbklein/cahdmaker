require "cahdmaker/version"
require 'RMagick'
require 'tempfile'

module Cahdmaker
  class Maker
    attr_reader :opts
    
    def initialize(opts={})
      @opts = { text_size: 60, blank_size: 10, font: 'Helvetica-Bold' }.merge(opts)
    end
    
    def black(text, pick=1, &block)
      make_card(text, "Black#{pick}", &block)
    end
    
    def black2(text, &block)
      black(text, 2, &block)
    end
    
    def black3(text, &block)
      black(text, 3, &block)
    end
    
    def white(text, &block)
      make_card(text, "White", &block)
    end
    
    def make_card(text, source_card)
      text_size = opts[:text_size].to_i
      color = source_card =~ /White/i ? 'black' : 'white'
      font = opts[:font]
      text.gsub! /\b_+\b/, ('_' * opts[:blank_size])

      cap = Magick::Image.read(%{caption:#{text}}) do
        self.size = '600x'
        self.background_color = 'transparent'
        self.pointsize = text_size.to_f
        self['interline-spacing'] = (text_size/3).to_f
        self.font = font
        self.fill = color
      end.first

      img = Magick::Image.read(File.expand_path("../../cards/CAH_#{source_card}.png",__FILE__)).first
      img.x_resolution = img.y_resolution = 300
      img.composite!(cap, 75, 75, Magick::OverCompositeOp)
      if block_given?
        yield(img)
      else
        img
      end
    end
  end
end
