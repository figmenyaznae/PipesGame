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
   bStop,bFreeze,bChange:byte;
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
  begin
   p[i].name:=ReadString('USERS','U'+inttostr(i),'Игрок '+inttostr(i));
   p[i].bStop:=strtoint(ReadString('USERS','U'+inttostr(i)+'S','0'));
   p[i].bFreeze:=strtoint(ReadString('USERS','U'+inttostr(i)+'F','0'));
   p[i].bChange:=strtoint(ReadString('USERS','U'+inttostr(i)+'C','0'));
  end;
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

  end;
 end else
 if n=0 then
  button2.Click;
 Form2.Edit1.Text:=p[pNum].Name;
 Form5.Hide;
 if pNum=1 then
 begin
  Form1.Alvbry1.Enabled:=true;
  Form1.Alvbry1.Visible:=true;
 end
 else
 begin
  Form1.Alvbry1.Enabled:=false;
  Form1.Alvbry1.Visible:=false;
 end;
 Form1.Show;
end;

procedure TForm5.Button2Click(Sender: TObject);
begin
 if n<30 then
  inc(n);
 if Edit1.Text='Имя игрока' then
  p[n].name:='Игрок '+intToStr(n)
 else
  P[n].name:=Edit1.Text;
 pNum:=n;
 p[n].bStop:=0;
 p[n].bFreeze:=0;
 p[n].bChange:=0;
 if pNum=1 then MessageDlg('Вы являетесь администратором.',mtInformation,[mbOk],0);
 if (MessageDlg('Вы зашли первый раз, хотите просмотреть справку?',mtConfirmation,[mbYes,mbNo],0)=mryes) then
  Form1.N6.Click;
end;

end.
