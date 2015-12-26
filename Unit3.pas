unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm3 = class(TForm)
    Label1: TLabel;//Надпись "Самый быстрый игрок"
    Label2: TLabel;//Надпись "Самый длинный трубопровод"
    Label3: TLabel;//Надпись "Самый короткий трубопровод"
    Label4: TLabel;//Значение поля "Самый быстрый игрок"
    Label5: TLabel;//Значение поля "Самый длинный трубопровод"
    Label6: TLabel;//Значение поля "Самый короткий трубопровод"
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  Form3: TForm3;
implementation

uses Unit1;

{$R *.dfm}

end.
