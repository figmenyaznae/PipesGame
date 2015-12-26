object Form4: TForm4
  Left = 462
  Top = 153
  Width = 417
  Height = 308
  Caption = 'System'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 40
    Top = 32
    Width = 14
    Height = 32
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 32
    Height = 13
    Caption = 'Label2'
  end
  object Label3: TLabel
    Left = 16
    Top = 88
    Width = 36
    Height = 13
    Caption = 'Bonus1'
  end
  object Label4: TLabel
    Left = 16
    Top = 104
    Width = 36
    Height = 13
    Caption = 'Bonus2'
  end
  object StringGrid1: TStringGrid
    Left = 96
    Top = 24
    Width = 289
    Height = 225
    ColCount = 9
    DefaultColWidth = 30
    DefaultRowHeight = 30
    FixedCols = 0
    RowCount = 7
    FixedRows = 0
    TabOrder = 0
  end
  object Edit1: TEdit
    Left = 16
    Top = 200
    Width = 49
    Height = 21
    TabOrder = 1
    Text = 'Edit1'
    OnKeyPress = Edit1KeyPress
  end
  object Edit2: TEdit
    Left = 16
    Top = 176
    Width = 49
    Height = 21
    TabOrder = 2
    Text = 'Edit2'
    OnKeyPress = Edit2KeyPress
  end
  object Edit3: TEdit
    Left = 16
    Top = 224
    Width = 49
    Height = 21
    TabOrder = 3
    Text = 'Edit3'
    OnKeyPress = Edit3KeyPress
  end
end
