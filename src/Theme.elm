module Theme exposing (Theme, colors, dark, light)

import Element exposing (Color, rgb255)


type alias Theme =
    { accent : Color
    , accent2 : Color
    , bg : Color
    , bg2 : Color
    , bg3 : Color
    , fontColor : Color
    , fontInvertedColor : Color
    }


colors =
    { blueDark = rgb255 40 38 41
    , violetDark = rgb255 62 31 71
    , violetDarker = rgb255 27 58 75
    , green = rgb255 129 178 154
    , yellow = rgb255 242 204 143
    , red = rgb255 224 122 95
    , offWhite = rgb255 244 241 222
    , black = rgb255 10 10 10

    -- Simple palette
    , ashGray = rgb255 202 210 197
    , darkSeaGreen = rgb255 132 169 140
    , hookersGreen = rgb255 82 121 111
    , darkSlateGray = rgb255 53 79 82
    , charcoal = rgb255 47 62 70
    }


dark =
    Theme
        colors.darkSeaGreen
        colors.ashGray
        colors.charcoal
        colors.hookersGreen
        colors.darkSlateGray
        colors.ashGray
        colors.charcoal


light =
    Theme
        colors.darkSeaGreen
        colors.ashGray
        colors.charcoal
        colors.hookersGreen
        colors.darkSlateGray
        colors.ashGray
        colors.black
