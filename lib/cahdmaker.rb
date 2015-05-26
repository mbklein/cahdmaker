require "cahdmaker/version"
require 'RMagick'
require 'tempfile'

module Cahdmaker
  class Maker
    attr_reader :opts
    
    def initialize(opts={})
      @opts = { text_size: 60, blank_size: 10, bleed: 0, resolution: 300, font: 'Helvetica-Bold' }.merge(opts)
    end
    
    def black(text, pick=1, &block)
      make_card(text, "black#{pick}".to_sym, &block)
    end
    
    def black2(text, &block)
      black(text, 2, &block)
    end
    
    def black3(text, &block)
      black(text, 3, &block)
    end
    
    def white(text, &block)
      make_card(text, :white, &block)
    end
    
    def px(ins, bleed=nil)
      bleed ||= opts[:bleed]/2
      (ins * opts[:resolution]) + bleed
    end
    
    def logo(black_card)
      logo = Magick::Draw.new
      logo.stroke_color('black')
      logo.stroke_opacity(0.8)
      logo.stroke_linecap('round')
      logo.stroke_linejoin('round')
      logo.stroke_width((0.75/72)*opts[:resolution])
      
      fan_x = px(0.03,0)
      fan_y = px(0.01,0)
      
      logo.translate(px(0.40),px(3.20))
      
      logo.translate(-fan_x,fan_y)
      logo.rotate(-15)
      logo.fill(black_card ? 'grey49' : 'black')
      logo.rectangle(px(-0.075,0), px(-0.150,0), px(0.075,0), 0)
      
      logo.rotate(15)
      logo.translate(fan_x,-fan_y)
      logo.fill(black_card ? 'grey69' : 'grey49')
      logo.rectangle(px(-0.075,0), px(-0.150,0), px(0.075,0), 0)

      logo.translate(fan_x,fan_y)
      logo.rotate(15)
      logo.fill('white')
      logo.rectangle(px(-0.075,0), px(-0.150,0), px(0.075,0), 0)
    end
    
    def make_card(text, source_card)
      bleed = opts[:bleed].to_i
      resolution = opts[:resolution].to_i
      text_size = opts[:text_size].to_i
      black_card = source_card == :white ? false : true
      background_color = black_card ? 'black' : 'white'
      color = black_card ? 'white' : 'black'
      font = opts[:font]
      text.gsub! /\b_+\b/, ('_' * opts[:blank_size])
      card_width = px(2.0, bleed);
      multiplier = resolution / 300
      
      cap = Magick::Image.read(%{caption:#{text}}) do
        self.size = "#{card_width}x"
        self.background_color = 'transparent'
        self.pointsize = text_size.to_f * multiplier
        self['interline-spacing'] = (text_size/3).to_f * multiplier
        self.font = font
        self.fill = color
      end.first
      cap.x_resolution = cap.y_resolution = resolution

      img = Magick::Image.new(px(2.5,bleed),px(3.5,bleed)) do
        self.background_color = background_color
      end
      img.x_resolution = img.y_resolution = resolution
      logo(black_card).draw(img)
      img.composite!(cap, px(0.25), px(0.25), Magick::OverCompositeOp)
      if block_given?
        yield(img)
      else
        img
      end
    end
  end
end
