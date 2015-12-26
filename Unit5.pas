unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IniFiles;

type
  TForm5 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  Player=record
   Name:string[12];
  end;

  plmas=array[1..30]of Player;  

var
  Form5: TForm5;
  p:plmas;
  pNum:byte;
  n:byte;
implementation

uses Unit1, Unit2;

{$R *.dfm}

procedure TForm5.Edit1Change(Sender: TObject);
begin
 Edit1.Font.Color:=clWindowText;
 if Edit1.Text='' then
 begin
  Edit1.Text:='Имя игрока';
  Edit1.Font.Color:=clGray;
 end;
end;

procedure TForm5.FormCreate(Sender: TObject);
var i:byte;
begin
 with TIniFile.Create(ExtractFilePath(Application.ExeName)+'data.ini') do
 begin
  n:=StrToInt(ReadString('MAIN','N','0'));
  for i:=1 to n do
   p[i].name:=ReadString('USERS','U'+inttostr(i),'Игрок '+inttostr(i));
 end;
end;

procedure TForm5.Button1Click(Sender: TObject);
var i:byte;
begin
 if n>0 then
 begin
  pNum:=0;
  for i:=1 to n do
   if p[i].Name=edit1.Text then
    pNum:=i;
  if pNum=0 then
  begin
   button2.Click;
   pNum:=n;
  end;
 end else
 if n=0 then
 begin
  button2.Click;
  pNum:=n;
 end;
 Form2.Edit1.Text:=p[pNum].Name;
 Form5.Hide;
 Form1.Show;
end;

procedure TForm5.Button2Click(Sender: TObject);
begin
 inc(n);
 if Edit1.Text='Имя игрока' then
  p[n].name:='Игрок '+intToStr(n)
 else
  P[n].name:=Edit1.Text;
end;

end.
