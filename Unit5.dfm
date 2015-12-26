object Form5: TForm5
  Left = 192
  Top = 114
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = #1040#1074#1090#1086#1088#1080#1079#1072#1094#1080#1103
  ClientHeight = 97
  ClientWidth = 142
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 16
    Top = 16
    Width = 113
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Text = #1048#1084#1103' '#1080#1075#1088#1086#1082#1072
    OnChange = Edit1Change
  end
  object Button1: TButton
    Left = 32
    Top = 56
    Width = 75
    Height = 25
    Caption = #1042#1086#1081#1090#1080
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 32
    Top = 80
    Width = 75
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 2
    Visible = False
    OnClick = Button2Click
  end
end
