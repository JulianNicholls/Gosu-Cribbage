require 'gosu_enhanced'

module Cribbage
  # Constants for the Cribbage Game
  module Constants
    include GosuEnhanced
    # Window Sizes

    WIDTH             = 800
    HEIGHT            = 600

    MID_X             = WIDTH / 2
    MID_Y             = HEIGHT / 2

    MARGIN            = 12

    # Card Sizes

    CARD_SIZE         = Size.new( 100, 150 )

    CARD_GAP          = 12
    FANNED_GAP        = 25

    # Positions

    WATERMARK_POS     = Point.new( WIDTH / 10, MID_Y - HEIGHT / 6 )

    INSTRUCTION_TOP   = MID_Y + HEIGHT / 12

    # Hand positions

    CPU_HAND_POS      = Point.new( MARGIN, MARGIN )
    PLAYER_HAND_POS   = Point.new( MARGIN, HEIGHT - (CARD_SIZE.height + MARGIN) )

    PACK_POS          = Point.new(    # Spare Pack
                          WIDTH - (CARD_SIZE.width + MARGIN),
                          MID_Y - (CARD_SIZE.height / 2) )

    FAN_POS           = Point.new( 50, PACK_POS.y )

    CRIB_POS          = PACK_POS.offset( -(CARD_SIZE.width + MARGIN), 0 )   # Crib

    PLAY31_POS        = CPU_HAND_POS.offset( 0, CARD_SIZE.height + CARD_GAP * 2 )

    BUTTON_HEIGHT     = 40
    DISCARD_BTN_POS   = Point.new(    # Discard Button
                          MARGIN * 3,
                          PLAYER_HAND_POS.y - BUTTON_HEIGHT * 2 )

    SCORE_POS         = Point.new( WIDTH - CARD_SIZE.width, MARGIN )
    SCORE_BOX_HEIGHT  = 64

    # Colours

    BAIZE             = Gosu::Color.new( 0xff007000 )
    WATERMARK         = Gosu::Color.new( 0x20000000 )

    SCORE_BKGR        = Gosu::Color.new( 0xff005000 )
    SCORE_TEXT        = Gosu::Color.new( 0xffffcc00 )
    SCORE_NUM         = Gosu::Color.new( 0xffffff00 )

    ARROW             = Gosu::Color.new( 0xf0ffcc00 )
    DISCARD           = Gosu::Color.new( 0xff104ec2 )
  end
end
