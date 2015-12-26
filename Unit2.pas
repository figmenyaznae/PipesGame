unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm2 = class(TForm)
    Edit1: TEdit;//Поле для ввода имени игрока
    Label1: TLabel;//Надпись "Имя игрока"
    CheckBox1: TCheckBox;//Видимоть панели свойств основной формы
    CheckBox2: TCheckBox;//Путой чекбокс про запас
    Button1: TButton;//Кнопка "ОК"
    Button2: TButton;//Кнопка "Отмена"
    procedure Button1Click(Sender: TObject);//Сохранение параметров и закрытие формы
    procedure Button2Click(Sender: TObject);//Закрытие формы без сохранения параметров
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);//Фильтр длительности имени пользователя
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
 Form1.StatusBar1.Visible:=CheckBox1.Checked;
 Form2.Close;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
 Form2.Close;
end;

procedure TForm2.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
 if length(edit1.Text)>=12 then if key<>#8 then key:=#0;
end;

end.
