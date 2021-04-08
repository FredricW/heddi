module Ui exposing (button, icon, iconInverted, inputText)

import Element exposing (Attribute, Element, alignLeft, el, height, html, minimum, mouseOver, paddingXY, px, rgba255, shrink, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import FontAwesome.Icon exposing (Icon, viewIcon)
import Html.Events
import Json.Decode as Decode
import Theme exposing (Theme)


button : Theme -> List (Attribute msg) -> { onPress : Maybe msg, label : Element msg } -> Element msg
button theme externalAttributes buttonConfig =
    let
        attributes : List (Attribute msg)
        attributes =
            [ paddingXY 24 16
            , Border.rounded 4
            , Background.color theme.bg3
            , Font.light
            , Font.color theme.fontColor
            , Border.color theme.bg3
            , Border.width 1
            , Border.shadow
                { offset = ( 0, 0 )
                , size = 2
                , blur = 12
                , color = rgba255 40 40 40 0.3
                }
            , mouseOver
                [ Border.color theme.bg2
                ]
            ]
    in
    el externalAttributes (Input.button attributes buttonConfig)


inputLabel : Theme -> String -> Input.Label msg
inputLabel theme value =
    Input.labelAbove [ alignLeft, Font.color theme.accent ] (text value)


inputAttributes : Theme -> List (Attribute msg)
inputAttributes theme =
    [ Font.color theme.fontColor
    , Background.color theme.bg
    , Border.color theme.bg2
    , paddingXY 16 16
    , width (minimum 200 shrink)
    ]


inputText : Theme -> String -> String -> String -> (String -> msg) -> Element msg
inputText theme label placeholder value toMsg =
    el []
        (Input.text
            (inputAttributes theme)
            { onChange = toMsg
            , text = value
            , placeholder = Just <| Input.placeholder [] (text placeholder)
            , label = inputLabel theme label
            }
        )


icon : Theme -> Icon -> Element msg
icon theme iconConfig =
    el [ width (px 24), height (px 24), Font.color theme.accent ] (html (viewIcon iconConfig))


iconInverted : Theme -> Icon -> Element msg
iconInverted theme iconConfig =
    el [ width (px 24), height (px 24), Font.color theme.fontInvertedColor ] (html (viewIcon iconConfig))



-- Keyboard


onEnter : msg -> Element.Attribute msg
onEnter msg =
    Element.htmlAttribute
        (Html.Events.on "keyup"
            (Decode.field "key" Decode.string
                |> Decode.andThen
                    (\key ->
                        if key == "Enter" then
                            Decode.succeed msg

                        else
                            Decode.fail "Not the enter key"
                    )
            )
        )
