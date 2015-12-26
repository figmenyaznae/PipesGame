unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm2 = class(TForm)
    Edit1: TEdit;//���� ��� ����� ����� ������
    Label1: TLabel;//������� "��� ������"
    CheckBox1: TCheckBox;//�������� ������ ������� �������� �����
    CheckBox2: TCheckBox;//����� ������� ��� �����
    Button1: TButton;//������ "��"
    Button2: TButton;//������ "������"
    procedure Button1Click(Sender: TObject);//���������� ���������� � �������� �����
    procedure Button2Click(Sender: TObject);//�������� ����� ��� ���������� ����������
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);//������ ������������ ����� ������������
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
