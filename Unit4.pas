unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls;

type
  TForm4 = class(TForm)
    StringGrid1: TStringGrid;
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label2: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

uses Unit1, Unit5;

{$R *.dfm}

procedure TForm4.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Form1.Timer1.Enabled:=true;
 Form1.Timer2.Enabled:=true;
 Form1.Timer3.Enabled:=true;
 Unit5.p[Unit5.pNum].bStop:=strtoint(edit1.Text);
 Unit5.p[Unit5.pNum].bFreeze:=strtoint(edit2.Text);
 Unit5.p[Unit5.pNum].bChange:=strtoint(edit3.Text);
 Form1.Button2.Click;
end;

procedure TForm4.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
 case key of
 '0'..'9':;
 else key:=#0;
 end;
end;

procedure TForm4.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
 case key of
 '0'..'9':;
 else key:=#0;
 end;
end;

procedure TForm4.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
 case key of
 '0'..'9':;
 else key:=#0;
 end;
end;

end.
