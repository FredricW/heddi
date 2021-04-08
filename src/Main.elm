module Main exposing (..)

import Browser
import Element
    exposing
        ( Element
        , FocusStyle
        , above
        , alignBottom
        , alignRight
        , alignTop
        , below
        , centerX
        , centerY
        , column
        , el
        , fill
        , focusStyle
        , height
        , html
        , image
        , inFront
        , maximum
        , onLeft
        , padding
        , paddingXY
        , px
        , row
        , scrollbarY
        , shrink
        , spacing
        , text
        , width
        )
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region exposing (heading)
import FontAwesome.Icon exposing (Icon, viewIcon)
import FontAwesome.Solid as SolidIcons
import Html exposing (Html)
import Random
import Theme exposing (Theme)
import UUID
import Ui



---- MODEL ----


type alias Url =
    String


type alias Id =
    String


type alias Panel =
    { title : String
    , url : Url
    }


type alias Dashboard =
    { title : String
    , id : Id
    , icon : Icon
    , panels : List Panel
    }


type alias AddDashboardForm =
    { title : String
    , icon : Icon
    , showIconList : Bool
    }


type View
    = AddDashboardPage
    | DashboardPage Id


type alias Model =
    { dashboards : List Dashboard
    , view : View
    , theme : Theme
    , addDashboardForm : AddDashboardForm
    }


init : ( Model, Cmd Msg )
init =
    ( { dashboards = []
      , view = AddDashboardPage
      , theme = Theme.dark
      , addDashboardForm =
            { title = ""
            , icon = SolidIcons.tachometerAlt
            , showIconList = False
            }
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = NoOp
    | TitleInputChanged String
    | ClickedDashboardButton Id
    | ClickedSidebarAddButton
    | ClickedCreateDashboard
    | NewDashboard UUID.UUID
    | ChangeAppName String
    | ClickedOnIconPicker
    | ClickedOnIcon Icon


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        addDashboardForm =
            model.addDashboardForm
    in
    case msg of
        TitleInputChanged newTitle ->
            let
                newForm =
                    { addDashboardForm | title = newTitle }
            in
            ( { model | addDashboardForm = newForm }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )

        ClickedDashboardButton id ->
            ( { model | view = DashboardPage id }, Cmd.none )

        ClickedSidebarAddButton ->
            ( { model | view = AddDashboardPage }, Cmd.none )

        ClickedCreateDashboard ->
            ( model, Random.generate NewDashboard UUID.generator )

        NewDashboard newUUID ->
            let
                newDashboard : Dashboard
                newDashboard =
                    { title = model.addDashboardForm.title
                    , icon = model.addDashboardForm.icon
                    , id = UUID.toRepresentation UUID.Canonical newUUID
                    , panels = []
                    }
            in
            ( { model
                | dashboards = List.append [ newDashboard ] model.dashboards
                , view = DashboardPage newDashboard.id
              }
            , Cmd.none
            )

        ChangeAppName _ ->
            ( model, Cmd.none )

        ClickedOnIconPicker ->
            let
                newForm =
                    { addDashboardForm | showIconList = not addDashboardForm.showIconList }
            in
            ( { model | addDashboardForm = newForm }, Cmd.none )

        ClickedOnIcon icon ->
            let
                newForm =
                    { addDashboardForm | icon = icon, showIconList = False }
            in
            ( { model | addDashboardForm = newForm }, Cmd.none )



---- VIEW ----


userButton : Model -> Element Msg
userButton model =
    row [ alignRight, height fill, paddingXY 30 0, spacing 20 ]
        [ image [ height (px 30), width (px 30) ] { src = "/logo.svg", description = "Logo" }
        , el [ Font.color model.theme.fontColor, Font.bold ] (text "Username")
        ]


header : Model -> Element Msg
header model =
    row [ height (px 60), width fill, alignTop, Background.color model.theme.bg ]
        [ el [ centerX, Font.extraBold, Font.color model.theme.fontColor ] (text "HEDDI Dashboard")
        , userButton model
        ]


dashboardButton : Theme -> Dashboard -> Bool -> Element Msg
dashboardButton theme dash isActive =
    let
        buttonLabel =
            dash.title
                |> String.words
                |> List.map (String.left 1)
                |> List.take 2
                |> String.join ""
                |> text
    in
    el
        [ width fill
        , height (px 60)
        ]
        (Input.button
            [ width fill
            , height fill
            , Background.color
                (if isActive then
                    theme.bg

                 else
                    theme.bg3
                )
            , Font.center
            , Font.color
                (if isActive then
                    theme.accent

                 else
                    theme.fontColor
                )
            ]
            { onPress = Just (ClickedDashboardButton dash.id), label = Ui.icon theme dash.icon }
        )


sidebar : Model -> Element Msg
sidebar model =
    let
        selectedDashboard : Maybe Dashboard
        selectedDashboard =
            case model.view of
                DashboardPage id ->
                    getSelectedDashboard id model.dashboards

                _ ->
                    Nothing

        dashboardButtons =
            model.dashboards
                |> List.map
                    (\dash ->
                        case selectedDashboard of
                            Just selected ->
                                dashboardButton model.theme dash (dash.id == selected.id)

                            Nothing ->
                                dashboardButton model.theme dash False
                    )
    in
    column [ Background.color model.theme.bg3, height fill, width (px 60) ]
        [ el
            [ height (px 60)
            , Background.color model.theme.accent
            , width fill
            , Font.color model.theme.bg
            ]
          <|
            el [ centerX, centerY ]
                (Ui.iconInverted model.theme SolidIcons.tachometerAlt)
        , column [ width fill ]
            dashboardButtons
        , el [ centerX, width fill, Font.extraBold, Font.color model.theme.fontColor ]
            (Input.button
                [ width fill
                , height fill
                , paddingXY 0 15
                , Background.color
                    (if model.view == AddDashboardPage then
                        model.theme.bg

                     else
                        model.theme.bg3
                    )
                ]
                { onPress = Just ClickedSidebarAddButton
                , label = Ui.icon model.theme SolidIcons.plusSquare
                }
            )
        ]


addDashboardPage : Model -> Element Msg
addDashboardPage model =
    let
        dashboardIcons : List Icon
        dashboardIcons =
            [ SolidIcons.adjust
            , SolidIcons.airFreshener
            , SolidIcons.ambulance
            , SolidIcons.anchor
            , SolidIcons.ad
            , SolidIcons.archive
            , SolidIcons.baby
            , SolidIcons.businessTime
            , SolidIcons.envelope
            , SolidIcons.calendar
            , SolidIcons.home
            , SolidIcons.footballBall
            , SolidIcons.skiing
            , SolidIcons.chess
            , SolidIcons.newspaper
            , SolidIcons.moneyCheck
            ]

        iconButton : Theme -> Icon -> Icon -> Element Msg
        iconButton theme activeIcon icon =
            let
                isActive =
                    icon == activeIcon
            in
            Input.button
                [ width fill
                , paddingXY 0 16
                , Background.color
                    (if isActive then
                        theme.accent

                     else
                        theme.bg3
                    )
                ]
                { label =
                    if isActive then
                        Ui.iconInverted theme icon

                    else
                        Ui.icon theme icon
                , onPress = Just (ClickedOnIcon icon)
                }
    in
    row
        [ centerX
        , alignTop
        , spacing 16
        , padding 16
        , Border.rounded 4
        , Border.color model.theme.bg3
        , Border.dashed
        , Border.width 2
        , width shrink
        ]
        [ Ui.button model.theme
            [ onLeft
                (if model.addDashboardForm.showIconList then
                    el [ paddingXY 16 0, height (maximum 360 shrink) ]
                        (column
                            [ Background.color model.theme.bg3
                            , scrollbarY
                            , alignBottom
                            , width (px 64)
                            , Border.rounded 4
                            ]
                            (List.map (iconButton model.theme model.addDashboardForm.icon) dashboardIcons)
                        )

                 else
                    Element.none
                )
            , alignBottom
            ]
            { onPress = Just ClickedOnIconPicker
            , label = Ui.icon model.theme model.addDashboardForm.icon
            }
        , Ui.inputText model.theme "Add dashboard" "Name" model.addDashboardForm.title TitleInputChanged
        , Ui.button model.theme
            [ alignBottom ]
            { onPress = Just ClickedCreateDashboard
            , label = text "+"
            }
        ]


getSelectedDashboard : Id -> List Dashboard -> Maybe Dashboard
getSelectedDashboard id list =
    list
        |> List.filter (.id >> (==) id)
        |> List.head


dashboardPage : Model -> Id -> Element Msg
dashboardPage model id =
    let
        selectedDashboard =
            getSelectedDashboard id model.dashboards

        sign : String -> Element msg
        sign value =
            el [ Font.color model.theme.bg2 ] (text <| "[ " ++ value ++ " ]")
    in
    case selectedDashboard of
        Just dash ->
            column [ spacing 24, centerX, width (maximum 1920 fill), paddingXY 48 48, height fill ]
                [ el [ heading 1, Font.extraBold, Font.size 40 ] (text dash.title)
                , sign dash.id
                ]

        Nothing ->
            el [] (text "No Dashboard found")


body : Model -> Element Msg
body model =
    case model.view of
        AddDashboardPage ->
            addDashboardPage model

        DashboardPage id ->
            dashboardPage model id


view : Model -> Html Msg
view model =
    Element.layoutWith
        { options =
            [ focusStyle
                { borderColor = Nothing
                , backgroundColor = Nothing
                , shadow = Nothing
                }
            ]
        }
        [ width fill
        , Background.color model.theme.bg
        , Font.color model.theme.fontColor
        ]
        (row [ width fill, height fill ]
            [ sidebar model
            , column [ width fill, height fill ]
                [ header model
                , body model
                ]
            ]
        )



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
