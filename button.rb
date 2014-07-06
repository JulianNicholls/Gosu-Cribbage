require 'forwardable'
require 'gosu_enhanced'

module Cribbage
  # Button class
  class Button
    include GosuEnhanced

    attr_accessor :visible

    def initialize( window, origin, size, colour )
      @window = window
      @region = Region.new( origin, size )
      @colour = colour

      hide
    end

    def draw
      @region.draw( @window, 2, @colour ) if visible
    end

    def to_s
      "#{@region} #{@colour}"
    end

    def show
      @visible = true
    end

    def hide
      @visible = false
    end

    def contains?( col, row = nil )
      visible && @region.contains?( col, row )
    end
  end

  # Textual Button that sizes itself based on its text content
  class TextButton < Button
    include GosuEnhanced
    extend Forwardable

    def_delegators :@region, :position, :width, :height

    def initialize( window, origin, colour, text )
      @text = text

      measure_size( window )

      super( window, origin, @size, colour )
    end

    def draw
      return unless visible

      # outline
      super

      # White interior

      @window.draw_rectangle(
        @region.position.offset( 1, 1 ), @region.size.deflate( 2, 2 ),
        2, Gosu::Color::WHITE
      )

      # Passed colour used for text

      @window.font[:button].draw(
        @text, @region.left + 2 * @text_size.width / @text.size,
        @region.top + @size.height / 4, 3, 1, 1, @colour
      )
    end

    private

    # Measure the button text and make the overall button size twice the height
    # and about four letters more than the width.

    def measure_size( window )
      @text_size = window.font[:button].measure( @text )
      ave_width  = @text_size.width / @text.size

      @size = Size.new( @text_size.width + 4 * ave_width, @text_size.height * 2 )
    end
  end
end
