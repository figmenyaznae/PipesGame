unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, ImgList, Menus, IniFiles, ShellApi;

type
  TForm1 = class(TForm)
    Button1: TButton;//Кнопка создания игры
    Button2: TButton;//Кнопка прорисовки игрового поля
    Button3: TButton;//Кнопка проверки готового маршрута
    Button4: TButton;
    ImageList1: TImageList;//Компонент, содержащий фрагменты трубопровода
    ImageList2: TImageList;//Компонент, содержащий фрагменты трубопровода заполненые водой
    ImageList3: TImageList;//Компонент, содержащий позиции вентиля
    Image1: TImage;//Игровое поле
    Image2: TImage;//Верхняя-правая труба
    Image3: TImage;//Нижняя-левая труба
    Image4: TImage;//Вентиль
    MainMenu1: TMainMenu;//Главное меню программы
    N1: TMenuItem;//Элемент главного меню "Сложность"
    N2: TMenuItem;//Сложность "Легкий"
    N3: TMenuItem;//Сложность "Средний"
    N4: TMenuItem;//Сложность "Тяжелый"
    N5: TMenuItem;//Элемент главного меню "Настройки"
    N6: TMenuItem;//Элемент главного меню "Справка"
    N7: TMenuItem;//Элемент главного меню "Выход"
    N8: TMenuItem;//Элемент главного меню "Рекорды"
    N9: TMenuItem;//Элемент главного меню "Закончить игру"
    N10: TMenuItem;//Элемент главного меню "Выход из игры"
    Label1: TLabel;//Надпись "Время"
    Label2: TLabel;//Время
    Timer1: TTimer;//таймер, отвечающий за обратный отсчет времени
    Timer2: TTimer;//таймер, отвечающий за поворот вентиля
    Timer3: TTimer;//таймер, отвечающий за анимацию воды
    StatusBar1: TStatusBar;
    Alvbry1: TMenuItem;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    ImageList4: TImageList;//Пнель свойств
    procedure FormCreate(Sender: TObject);//начальная загрузка
    procedure Button1Click(Sender: TObject);//начало игры
    procedure Button2Click(Sender: TObject);//перерисовка интерфейса
    procedure Button3Click(Sender: TObject);//проверка маршрута
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);//обработка действий пользователя
    procedure N2Click(Sender: TObject);//легкая сложность
    procedure N3Click(Sender: TObject);//средняя сложнотсь
    procedure N4Click(Sender: TObject);//тяжелая сложность
    procedure N5Click(Sender: TObject);//Пункт меню, вызывающий окно настроек
    procedure N9Click(Sender: TObject);//Пункт меню, вызывающий завершение игры
    procedure N10Click(Sender: TObject);//Пункт меню, вызывающий окно рекордов
    procedure Timer1Timer(Sender: TObject);//таймер, отвечающий за обратный отсчет времени
    procedure Timer2Timer(Sender: TObject);//таймер, отвечающий за поворот вентиля
    procedure Timer3Timer(Sender: TObject);//таймер, отвечающий за анимацию воды
    procedure FormClose(Sender: TObject; var Action: TCloseAction);//Действия, необходимые для выполнения перед закрытием формы
    procedure N6Click(Sender: TObject);//Вызов справки
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Alvbry1Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure Image7MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image5Click(Sender: TObject);//Запрос перед выходом

  private
    { Private declarations }
  public
    { Public declarations }
  end;

  Pipe=record
   ImageIndex:byte;
   Top,Bottom,Left,Right:boolean;
  end;

  mas=array[1..7,1..9] of record
   X,Y:word;
   PipeIndex:byte;
   Floated:boolean;
  end;
  bmas=array[1..7,1..9]of byte;

  pmas=array[1..15]of bmas;

var
  Form1: TForm1;
  Pipes:array[0..5]of pipe;
  a:mas;
  b:pmas;
  BottomFloat,TopFloat,ValveRotation,ValveOpen,InGame,PipeReplace,PipeCompltn:boolean;
  n,m,k,time,btime,ValveAngle,PipeLength,pasteNum:byte;
  bx,by,bn,x,y,i:integer;

implementation

uses Unit2, Unit4, Unit5;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
 with pipes[0] do
 begin
  top:=true;
  bottom:=false;
  left:=false;
  right:=true;
 end;
 with pipes[1] do
 begin
  top:=false;
  bottom:=true;
  left:=false;
  right:=true;
 end;
 with pipes[2] do
 begin
  top:=false;
  bottom:=true;
  left:=true;
  right:=false;
 end;
 with pipes[3] do
 begin
  top:=true;
  bottom:=false;
  left:=true;
  right:=false;
 end;
 with pipes[4] do
 begin
  top:=true;
  bottom:=true;
  left:=false;
  right:=false;
end;
 with pipes[5] do
 begin
  top:=false;
  bottom:=false;
  left:=true;
  right:=true;
 end;

 b[1][1,1]:=0; b[1][1,2]:=0; b[1][1,3]:=0; b[1][1,4]:=2; b[1][1,5]:=2;
 b[1][2,1]:=0; b[1][2,2]:=0; b[1][2,3]:=2; b[1][2,4]:=2; b[1][2,5]:=0;
 b[1][3,1]:=0; b[1][3,2]:=0; b[1][3,3]:=2; b[1][3,4]:=2; b[1][3,5]:=0;
 b[1][4,1]:=0; b[1][4,2]:=0; b[1][4,3]:=2; b[1][4,4]:=2; b[1][4,5]:=0;
 b[1][5,1]:=2; b[1][5,2]:=1; b[1][5,3]:=2; b[1][5,4]:=0; b[1][5,5]:=0;

 b[2][1,1]:=0; b[2][1,2]:=0; b[2][1,3]:=0; b[2][1,4]:=2; b[2][1,5]:=2;
 b[2][2,1]:=2; b[2][2,2]:=1; b[2][2,3]:=1; b[2][2,4]:=2; b[2][2,5]:=0;
 b[2][3,1]:=2; b[2][3,2]:=2; b[2][3,3]:=0; b[2][3,4]:=0; b[2][3,5]:=0;
 b[2][4,1]:=0; b[2][4,2]:=1; b[2][4,3]:=0; b[2][4,4]:=0; b[2][4,5]:=0;
 b[2][5,1]:=2; b[2][5,2]:=2; b[2][5,3]:=0; b[2][5,4]:=0; b[2][5,5]:=0;

 b[3][1,1]:=0; b[3][1,2]:=0; b[3][1,3]:=0; b[3][1,4]:=0; b[3][1,5]:=2;
 b[3][2,1]:=0; b[3][2,2]:=0; b[3][2,3]:=0; b[3][2,4]:=2; b[3][2,5]:=2;
 b[3][3,1]:=0; b[3][3,2]:=0; b[3][3,3]:=0; b[3][3,4]:=2; b[3][3,5]:=2;
 b[3][4,1]:=0; b[3][4,2]:=2; b[3][4,3]:=2; b[3][4,4]:=2; b[3][4,5]:=2;
 b[3][5,1]:=2; b[3][5,2]:=2; b[3][5,3]:=2; b[3][5,4]:=2; b[3][5,5]:=0;

 b[4][1,1]:=0; b[4][1,2]:=0; b[4][1,3]:=0; b[4][1,4]:=2; b[4][1,5]:=2;
 b[4][2,1]:=0; b[4][2,2]:=0; b[4][2,3]:=0; b[4][2,4]:=2; b[4][2,5]:=2;
 b[4][3,1]:=0; b[4][3,2]:=2; b[4][3,3]:=2; b[4][3,4]:=2; b[4][3,5]:=2;
 b[4][4,1]:=2; b[4][4,2]:=2; b[4][4,3]:=2; b[4][4,4]:=2; b[4][4,5]:=0;
 b[4][5,1]:=1; b[4][5,2]:=0; b[4][5,3]:=0; b[4][5,4]:=0; b[4][5,5]:=0;

 b[5][1,1]:=0; b[5][1,2]:=0; b[5][1,3]:=0; b[5][1,4]:=0; b[5][1,5]:=1;
 b[5][2,1]:=2; b[5][2,2]:=1; b[5][2,3]:=2; b[5][2,4]:=2; b[5][2,5]:=2;
 b[5][3,1]:=2; b[5][3,2]:=2; b[5][3,3]:=2; b[5][3,4]:=2; b[5][3,5]:=0;
 b[5][4,1]:=2; b[5][4,2]:=2; b[5][4,3]:=0; b[5][4,4]:=0; b[5][4,5]:=0;
 b[5][5,1]:=1; b[5][5,2]:=0; b[5][5,3]:=0; b[5][5,4]:=0; b[5][5,5]:=0;

 b[6][1,1]:=0; b[6][1,2]:=0; b[6][1,3]:=0; b[6][1,4]:=0; b[6][1,5]:=0; b[6][1,6]:=2; b[6][1,7]:=2;
 b[6][2,1]:=0; b[6][2,2]:=2; b[6][2,3]:=1; b[6][2,4]:=1; b[6][2,5]:=1; b[6][2,6]:=2; b[6][2,7]:=0;
 b[6][3,1]:=0; b[6][3,2]:=2; b[6][3,3]:=1; b[6][3,4]:=1; b[6][3,5]:=2; b[6][3,6]:=0; b[6][3,7]:=0;
 b[6][4,1]:=0; b[6][4,2]:=0; b[6][4,3]:=0; b[6][4,4]:=2; b[6][4,5]:=2; b[6][4,6]:=0; b[6][4,7]:=0;
 b[6][5,1]:=0; b[6][5,2]:=0; b[6][5,3]:=0; b[6][5,4]:=2; b[6][5,5]:=2; b[6][5,6]:=0; b[6][5,7]:=0;
 b[6][6,1]:=2; b[6][6,2]:=2; b[6][6,3]:=2; b[6][6,4]:=1; b[6][6,5]:=1; b[6][6,6]:=0; b[6][6,7]:=0;
 b[6][7,1]:=1; b[6][7,2]:=2; b[6][7,3]:=2; b[6][7,4]:=2; b[6][7,5]:=2; b[6][7,6]:=0; b[6][7,7]:=0;

 b[7][1,1]:=0; b[7][1,2]:=0; b[7][1,3]:=0; b[7][1,4]:=0; b[7][1,5]:=0; b[7][1,6]:=2; b[7][1,7]:=2;
 b[7][2,1]:=0; b[7][2,2]:=0; b[7][2,3]:=0; b[7][2,4]:=0; b[7][2,5]:=0; b[7][2,6]:=2; b[7][2,7]:=2;
 b[7][3,1]:=0; b[7][3,2]:=0; b[7][3,3]:=2; b[7][3,4]:=2; b[7][3,5]:=0; b[7][3,6]:=2; b[7][3,7]:=2;
 b[7][4,1]:=0; b[7][4,2]:=2; b[7][4,3]:=2; b[7][4,4]:=2; b[7][4,5]:=2; b[7][4,6]:=2; b[7][4,7]:=0;
 b[7][5,1]:=2; b[7][5,2]:=2; b[7][5,3]:=0; b[7][5,4]:=2; b[7][5,5]:=2; b[7][5,6]:=0; b[7][5,7]:=0;
 b[7][6,1]:=1; b[7][6,2]:=0; b[7][6,3]:=0; b[7][6,4]:=0; b[7][6,5]:=0; b[7][6,6]:=0; b[7][6,7]:=0;
 b[7][7,1]:=1; b[7][7,2]:=0; b[7][7,3]:=0; b[7][7,4]:=0; b[7][7,5]:=0; b[7][7,6]:=0; b[7][7,7]:=0;

 b[8][1,1]:=0; b[8][1,2]:=0; b[8][1,3]:=0; b[8][1,4]:=0; b[8][1,5]:=0; b[8][1,6]:=2; b[8][1,7]:=2;
 b[8][2,1]:=0; b[8][2,2]:=0; b[8][2,3]:=0; b[8][2,4]:=0; b[8][2,5]:=0; b[8][2,6]:=1; b[8][2,7]:=0;
 b[8][3,1]:=0; b[8][3,2]:=0; b[8][3,3]:=0; b[8][3,4]:=2; b[8][3,5]:=1; b[8][3,6]:=2; b[8][3,7]:=0;
 b[8][4,1]:=0; b[8][4,2]:=2; b[8][4,3]:=1; b[8][4,4]:=2; b[8][4,5]:=0; b[8][4,6]:=0; b[8][4,7]:=0;
 b[8][5,1]:=2; b[8][5,2]:=2; b[8][5,3]:=0; b[8][5,4]:=0; b[8][5,5]:=0; b[8][5,6]:=0; b[8][5,7]:=0;
 b[8][6,1]:=2; b[8][6,2]:=2; b[8][6,3]:=0; b[8][6,4]:=0; b[8][6,5]:=0; b[8][6,6]:=0; b[8][6,7]:=0;
 b[8][7,1]:=2; b[8][7,2]:=2; b[8][7,3]:=0; b[8][7,4]:=0; b[8][7,5]:=0; b[8][7,6]:=0; b[8][7,7]:=0;

 b[9][1,1]:=0; b[9][1,2]:=0; b[9][1,3]:=0; b[9][1,4]:=0; b[9][1,5]:=0; b[9][1,6]:=0; b[9][1,7]:=1;
 b[9][2,1]:=0; b[9][2,2]:=0; b[9][2,3]:=0; b[9][2,4]:=0; b[9][2,5]:=0; b[9][2,6]:=0; b[9][2,7]:=1;
 b[9][3,1]:=0; b[9][3,2]:=0; b[9][3,3]:=0; b[9][3,4]:=0; b[9][3,5]:=0; b[9][3,6]:=2; b[9][3,7]:=2;
 b[9][4,1]:=0; b[9][4,2]:=2; b[9][4,3]:=1; b[9][4,4]:=2; b[9][4,5]:=0; b[9][4,6]:=2; b[9][4,7]:=2;
 b[9][5,1]:=0; b[9][5,2]:=2; b[9][5,3]:=2; b[9][5,4]:=2; b[9][5,5]:=2; b[9][5,6]:=2; b[9][5,7]:=2;
 b[9][6,1]:=0; b[9][6,2]:=2; b[9][6,3]:=2; b[9][6,4]:=0; b[9][6,5]:=2; b[9][6,6]:=2; b[9][6,7]:=0;
 b[9][7,1]:=2; b[9][7,2]:=2; b[9][7,3]:=0; b[9][7,4]:=0; b[9][7,5]:=0; b[9][7,6]:=0; b[9][7,7]:=0;

 b[10][1,1]:=0; b[10][1,2]:=0; b[10][1,3]:=0; b[10][1,4]:=0; b[10][1,5]:=0; b[10][1,6]:=0; b[10][1,7]:=1;
 b[10][2,1]:=0; b[10][2,2]:=2; b[10][2,3]:=1; b[10][2,4]:=2; b[10][2,5]:=0; b[10][2,6]:=0; b[10][2,7]:=1;
 b[10][3,1]:=2; b[10][3,2]:=2; b[10][3,3]:=0; b[10][3,4]:=2; b[10][3,5]:=1; b[10][3,6]:=2; b[10][3,7]:=1;
 b[10][4,1]:=2; b[10][4,2]:=2; b[10][4,3]:=0; b[10][4,4]:=0; b[10][4,5]:=2; b[10][4,6]:=2; b[10][4,7]:=1;
 b[10][5,1]:=0; b[10][5,2]:=2; b[10][5,3]:=2; b[10][5,4]:=0; b[10][5,5]:=1; b[10][5,6]:=0; b[10][5,7]:=1;
 b[10][6,1]:=0; b[10][6,2]:=2; b[10][6,3]:=2; b[10][6,4]:=0; b[10][6,5]:=2; b[10][6,6]:=2; b[10][6,7]:=1;
 b[10][7,1]:=2; b[10][7,2]:=2; b[10][7,3]:=0; b[10][7,4]:=0; b[10][7,5]:=0; b[10][7,6]:=2; b[10][7,7]:=2;

 b[11][1,1]:=0; b[11][1,2]:=0; b[11][1,3]:=0; b[11][1,4]:=0; b[11][1,5]:=0; b[11][1,6]:=2; b[11][1,7]:=2; b[11][1,8]:=0; b[11][1,9]:=1;
 b[11][2,1]:=0; b[11][2,2]:=0; b[11][2,3]:=0; b[11][2,4]:=0; b[11][2,5]:=2; b[11][2,6]:=2; b[11][2,7]:=2; b[11][2,8]:=2; b[11][2,9]:=1;
 b[11][3,1]:=0; b[11][3,2]:=0; b[11][3,3]:=0; b[11][3,4]:=0; b[11][3,5]:=2; b[11][3,6]:=2; b[11][3,7]:=2; b[11][3,8]:=2; b[11][3,9]:=1;
 b[11][4,1]:=0; b[11][4,2]:=0; b[11][4,3]:=0; b[11][4,4]:=0; b[11][4,5]:=2; b[11][4,6]:=2; b[11][4,7]:=2; b[11][4,8]:=2; b[11][4,9]:=1;
 b[11][5,1]:=0; b[11][5,2]:=0; b[11][5,3]:=2; b[11][5,4]:=2; b[11][5,5]:=2; b[11][5,6]:=2; b[11][5,7]:=2; b[11][5,8]:=2; b[11][5,9]:=1;
 b[11][6,1]:=0; b[11][6,2]:=2; b[11][6,3]:=2; b[11][6,4]:=2; b[11][6,5]:=1; b[11][6,6]:=2; b[11][6,7]:=2; b[11][6,8]:=2; b[11][6,9]:=1;
 b[11][7,1]:=2; b[11][7,2]:=2; b[11][7,3]:=0; b[11][7,4]:=0; b[11][7,5]:=0; b[11][7,6]:=0; b[11][7,7]:=0; b[11][7,8]:=2; b[11][7,9]:=2;

 b[12][1,1]:=0; b[12][1,2]:=0; b[12][1,3]:=0; b[12][1,4]:=0; b[12][1,5]:=0; b[12][1,6]:=0; b[12][1,7]:=0; b[12][1,8]:=2; b[12][1,9]:=2;
 b[12][2,1]:=0; b[12][2,2]:=0; b[12][2,3]:=0; b[12][2,4]:=0; b[12][2,5]:=0; b[12][2,6]:=2; b[12][2,7]:=1; b[12][2,8]:=2; b[12][2,9]:=0;
 b[12][3,1]:=0; b[12][3,2]:=0; b[12][3,3]:=0; b[12][3,4]:=0; b[12][3,5]:=2; b[12][3,6]:=2; b[12][3,7]:=0; b[12][3,8]:=0; b[12][3,9]:=0;
 b[12][4,1]:=2; b[12][4,2]:=1; b[12][4,3]:=2; b[12][4,4]:=2; b[12][4,5]:=2; b[12][4,6]:=0; b[12][4,7]:=0; b[12][4,8]:=0; b[12][4,9]:=0;
 b[12][5,1]:=2; b[12][5,2]:=2; b[12][5,3]:=2; b[12][5,4]:=2; b[12][5,5]:=0; b[12][5,6]:=0; b[12][5,7]:=0; b[12][5,8]:=0; b[12][5,9]:=0;
 b[12][6,1]:=2; b[12][6,2]:=2; b[12][6,3]:=0; b[12][6,4]:=0; b[12][6,5]:=0; b[12][6,6]:=0; b[12][6,7]:=0; b[12][6,8]:=0; b[12][6,9]:=0;
 b[12][7,1]:=1; b[12][7,2]:=0; b[12][7,3]:=0; b[12][7,4]:=0; b[12][7,5]:=0; b[12][7,6]:=0; b[12][7,7]:=0; b[12][7,8]:=0; b[12][7,9]:=0;

 b[13][1,1]:=0; b[13][1,2]:=0; b[13][1,3]:=0; b[13][1,4]:=0; b[13][1,5]:=0; b[13][1,6]:=0; b[13][1,7]:=0; b[13][1,8]:=2; b[13][1,9]:=2;
 b[13][2,1]:=0; b[13][2,2]:=0; b[13][2,3]:=0; b[13][2,4]:=0; b[13][2,5]:=0; b[13][2,6]:=0; b[13][2,7]:=0; b[13][2,8]:=2; b[13][2,9]:=2;
 b[13][3,1]:=0; b[13][3,2]:=0; b[13][3,3]:=0; b[13][3,4]:=0; b[13][3,5]:=0; b[13][3,6]:=0; b[13][3,7]:=0; b[13][3,8]:=2; b[13][3,9]:=2;
 b[13][4,1]:=0; b[13][4,2]:=0; b[13][4,3]:=2; b[13][4,4]:=2; b[13][4,5]:=2; b[13][4,6]:=2; b[13][4,7]:=0; b[13][4,8]:=2; b[13][4,9]:=2;
 b[13][5,1]:=0; b[13][5,2]:=2; b[13][5,3]:=2; b[13][5,4]:=2; b[13][5,5]:=2; b[13][5,6]:=2; b[13][5,7]:=2; b[13][5,8]:=2; b[13][5,9]:=2;
 b[13][6,1]:=0; b[13][6,2]:=2; b[13][6,3]:=2; b[13][6,4]:=0; b[13][6,5]:=0; b[13][6,6]:=0; b[13][6,7]:=2; b[13][6,8]:=2; b[13][6,9]:=0;
 b[13][7,1]:=2; b[13][7,2]:=1; b[13][7,3]:=2; b[13][7,4]:=0; b[13][7,5]:=0; b[13][7,6]:=0; b[13][7,7]:=0; b[13][7,8]:=0; b[13][7,9]:=0;

 b[14][1,1]:=0; b[14][1,2]:=0; b[14][1,3]:=0; b[14][1,4]:=0; b[14][1,5]:=0; b[14][1,6]:=0; b[14][1,7]:=0; b[14][1,8]:=2; b[14][1,9]:=2;
 b[14][2,1]:=0; b[14][2,2]:=0; b[14][2,3]:=0; b[14][2,4]:=0; b[14][2,5]:=0; b[14][2,6]:=0; b[14][2,7]:=0; b[14][2,8]:=2; b[14][2,9]:=2;
 b[14][3,1]:=0; b[14][3,2]:=0; b[14][3,3]:=2; b[14][3,4]:=2; b[14][3,5]:=0; b[14][3,6]:=0; b[14][3,7]:=2; b[14][3,8]:=1; b[14][3,9]:=2;
 b[14][4,1]:=2; b[14][4,2]:=1; b[14][4,3]:=2; b[14][4,4]:=1; b[14][4,5]:=0; b[14][4,6]:=0; b[14][4,7]:=1; b[14][4,8]:=0; b[14][4,9]:=0;
 b[14][5,1]:=1; b[14][5,2]:=0; b[14][5,3]:=2; b[14][5,4]:=2; b[14][5,5]:=0; b[14][5,6]:=2; b[14][5,7]:=2; b[14][5,8]:=0; b[14][5,9]:=0;
 b[14][6,1]:=1; b[14][6,2]:=0; b[14][6,3]:=2; b[14][6,4]:=1; b[14][6,5]:=1; b[14][6,6]:=2; b[14][6,7]:=0; b[14][6,8]:=0; b[14][6,9]:=0;
 b[14][7,1]:=1; b[14][7,2]:=0; b[14][7,3]:=0; b[14][7,4]:=0; b[14][7,5]:=0; b[14][7,6]:=0; b[14][7,7]:=0; b[14][7,8]:=0; b[14][7,9]:=0;

 b[15][1,1]:=0; b[15][1,2]:=2; b[15][1,3]:=1; b[15][1,4]:=1; b[15][1,5]:=1; b[15][1,6]:=1; b[15][1,7]:=1; b[15][1,8]:=1; b[15][1,9]:=2;
 b[15][2,1]:=0; b[15][2,2]:=1; b[15][2,3]:=2; b[15][2,4]:=1; b[15][2,5]:=2; b[15][2,6]:=0; b[15][2,7]:=0; b[15][2,8]:=0; b[15][2,9]:=0;
 b[15][3,1]:=0; b[15][3,2]:=2; b[15][3,3]:=2; b[15][3,4]:=0; b[15][3,5]:=2; b[15][3,6]:=1; b[15][3,7]:=1; b[15][3,8]:=2; b[15][3,9]:=0;
 b[15][4,1]:=0; b[15][4,2]:=0; b[15][4,3]:=0; b[15][4,4]:=0; b[15][4,5]:=0; b[15][4,6]:=0; b[15][4,7]:=0; b[15][4,8]:=1; b[15][4,9]:=0;
 b[15][5,1]:=0; b[15][5,2]:=2; b[15][5,3]:=2; b[15][5,4]:=0; b[15][5,5]:=2; b[15][5,6]:=1; b[15][5,7]:=1; b[15][5,8]:=2; b[15][5,9]:=0;
 b[15][6,1]:=2; b[15][6,2]:=2; b[15][6,3]:=2; b[15][6,4]:=1; b[15][6,5]:=2; b[15][6,6]:=0; b[15][6,7]:=0; b[15][6,8]:=0; b[15][6,9]:=0;
 b[15][7,1]:=1; b[15][7,2]:=0; b[15][7,3]:=0; b[15][7,4]:=0; b[15][7,5]:=0; b[15][7,6]:=0; b[15][7,7]:=0; b[15][7,8]:=0; b[15][7,9]:=0;

 Image1.Canvas.Brush.Color:=clBtnFace;
 Image2.Canvas.Brush.Color:=clBtnFace;
 Image3.Canvas.Brush.Color:=clBtnFace;
 Image4.Canvas.Brush.Color:=clBtnFace;
 Image5.Canvas.Brush.Color:=clBtnFace;
 Image6.Canvas.Brush.Color:=clBtnFace;
 Image7.Canvas.Brush.Color:=clBtnFace;

 pasteNum:=0;
 n9.Click;
end;

procedure TForm1.Button1Click(Sender: TObject);
var i,j:byte;
begin
 if n2.Checked then
 begin
  n:=5;
  m:=5;
  time:=30;
 end;
 if n3.Checked then
 begin
  n:=7;
  m:=7;
  time:=40;
 end;
 if n4.Checked then
 begin
  n:=7;
  m:=9;
  time:=30;
 end;
 Label1.Visible:=true;
 Label2.Visible:=true;
 TopFloat:=false;
 BottomFloat:=false;
 Randomize;
 k:=random(5)+1;
 bn:=random(20);
 if bn<10 then bn:=3
 else if bn<17 then bn:=1
  else bn:=2;
 bx:=random(n)+1;
 by:=random(m)+1;
 if m=7 then k:=k+5;
 if m=9 then k:=k+10;
 for i:=1 to n do
  for j:=1 to m do
  begin
   a[i,j].X:=(j-1)*57;
   a[i,j].Y:=(i-1)*57;
   if b[k][i,j]=0 then
    a[i,j].PipeIndex:=random(6);
   if b[k][i,j]=1 then
    a[i,j].PipeIndex:=random(2)+4;
   if b[k][i,j]=2 then
    a[i,j].PipeIndex:=random(4);
   a[i,j].Floated:=false;
  end;
 InGame:=true;
 N9.Enabled:=true;
 N1.Enabled:=false;
 Button4.Visible:=false;
 Form1.Width:=57*m+152;
 Form1.Height:=57*n+120;
 Label1.Left:=Form1.Width-130;
 Label2.Left:=Form1.Width-40;
 Button3.Left:=Form1.Width-130;
 Image2.Left:=Image1.Left+57*(m-1);
 Image3.Top:=Image1.Top+57*n;
 Image4.Left:=Form1.Width-130;
 Image5.Left:=Form1.Width-130;
 Image6.Left:=Form1.Width-130;
 Image7.Left:=Form1.Width-130;
 ValveRotation:=false;
 button2.Click;
end;

procedure TForm1.Button2Click(Sender: TObject);
var i,j:byte;
begin
 if InGame then
 begin
  Image1.Canvas.Rectangle(-1,-1,700,700);
  for i:=1 to n do
   for j:=1 to m do
    if not a[i,j].Floated then
     ImageList1.Draw(Image1.Canvas,a[i,j].X,a[i,j].Y,a[i,j].PipeIndex,true)
    else
     ImageList2.Draw(Image1.Canvas,a[i,j].X,a[i,j].Y,a[i,j].PipeIndex,true);
  Image2.Canvas.Rectangle(-1,-1,58,58);
  if not TopFloat then
   ImageList1.Draw(Image2.Canvas,0,0,7,true)
  else
   ImageList2.Draw(Image2.Canvas,0,0,7,true);
  Image3.Canvas.Rectangle(-1,-1,58,58);
  if not BottomFloat then
   ImageList1.Draw(Image3.Canvas,0,0,6,true)
  else
   ImageList2.Draw(Image3.Canvas,0,0,6,true);
  ImageList1.Draw(Image1.Canvas,a[bx,by].X,a[bx,by].Y,7+bn,true);
 end;
 Image5.Canvas.Rectangle(-1,-1,58,58);
 Image6.Canvas.Rectangle(-1,-1,58,58);
 Image7.Canvas.Rectangle(-1,-1,58,58);
 Imagelist4.Draw(Image5.Canvas,0,0,0,true);
 Image5.Canvas.TextOut(0,0,inttostr(unit5.p[unit5.pNum].bFreeze));
 Imagelist4.Draw(Image6.Canvas,0,0,1,true);
 Image6.Canvas.TextOut(0,0,inttostr(unit5.p[unit5.pNum].bStop));
 Imagelist1.Draw(Image7.Canvas,0,0,pasteNum,true);
 Imagelist4.Draw(Image7.Canvas,40,40,2,true);
 Image7.Canvas.TextOut(0,0,inttostr(unit5.p[unit5.pNum].bChange));
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var Xe,Ye:integer;
begin
 if (x>0)and(x<57*9) then
 begin
  Xe:=(X div 57)+1;
  if (y>0)and(y<57*7) then
  begin
   Ye:=(Y div 57)+1;
   if InGame then
   begin
    if not a[Ye,Xe].Floated then
     if PipeReplace then
     begin
      a[Ye,Xe].PipeIndex:=pasteNum;
      PipeReplace:=false;
     end
     else
     case a[Ye,Xe].PipeIndex of
     0..2:inc(a[Ye,Xe].PipeIndex);
     3:a[Ye,Xe].PipeIndex:=0;
     4:inc(a[Ye,Xe].PipeIndex);
     5:a[Ye,Xe].PipeIndex:=4;
     end;
    button2.Click;
   end;
  end;
 end;
end;

procedure TForm1.N2Click(Sender: TObject);
begin
 N2.Checked:=true;
end;

procedure TForm1.N3Click(Sender: TObject);
begin
 N3.Checked:=true;
end;

procedure TForm1.N4Click(Sender: TObject);
begin
 N4.Checked:=true;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 if InGame then
 begin
  PipeLength:=0;
  ValveRotation:=true;
  x:=n;
  y:=1;
  i:=1;
  BottomFloat:=true;
  ValveOpen:=true;
  button2.Click;
 end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 if InGame then
 begin
  if btime>0 then
   dec(btime)
  else
   if time>1 then
   begin
    dec(time);
  label2.Caption:=inttostr(time-1);
   end
   else
    if time=1 then
    begin
     button3.Click;
     dec(time);
    end;
 end;
 StatusBar1.Panels.Items[1].Text:=timetostr(now);
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
 if ValveRotation then
 begin
  inc(ValveAngle);
  if ValveAngle>5 then ValveAngle:=0;
  Image4.Canvas.Rectangle(-1,-1,101,101);
  Imagelist3.Draw(Image4.Canvas,0,0,ValveAngle,true);
 end;
end;

procedure TForm1.Timer3Timer(Sender: TObject);
var timestr:string[8]; bstr:array[1..3]of string[10];
begin
 if InGame then
 begin
  if ValveOpen then
  begin
   time:=0;
   if (x<=n) and (x>=1) and (y<=m) and (y>=1) then
   begin
    PipeCompltn:=false;
    case i of
     0:if not pipes[a[x,y].PipeIndex].top then ValveOpen:=false;
     1:if not pipes[a[x,y].PipeIndex].bottom then ValveOpen:=false;
     2:if not pipes[a[x,y].PipeIndex].left then ValveOpen:=false;
     3:if not pipes[a[x,y].PipeIndex].right then ValveOpen:=false;
    end;
    if (x=1) and (y=m) then
     PipeCompltn:=ValveOpen;
    if ValveOpen then
     a[x,y].Floated:=true;
    if pipes[a[x,y].PipeIndex].top and (i<>0) then
    begin
     x:=x-1;
     i:=1;
    end else
    if pipes[a[x,y].PipeIndex].bottom and (i<>1) then
    begin
     x:=x+1;
     i:=0;
    end else
    if pipes[a[x,y].PipeIndex].left and (i<>2) then
    begin
     y:=y-1;
     i:=3;
    end else
    if pipes[a[x,y].PipeIndex].right and (i<>3) then
    begin
     y:=y+1;
     i:=2;
    end;
    button2.Click;
    inc(PipeLength);
   end
   else ValveOpen:=false;
  end
  else if ValveRotation then
  begin
   ValveRotation:=false;
   if (x=0) and (y=m) and (i=1) and PipeCompltn then
   begin
    if a[bx,by].Floated then
     case bn of
     1:inc(Unit5.p[Unit5.pNum].bStop);
     2:inc(Unit5.p[Unit5.pNum].bFreeze);
     3:inc(Unit5.p[Unit5.pNum].bChange);
     end;
    bstr[1]:='Остановка';
    bstr[2]:='Замедление';
    bstr[3]:='Замена';
    a[x,y].Floated:=true;
    TopFloat:=true;
    button2.Click;
    inc(PipeLength);
    if n3.Checked then
     timestr:=inttostr(40-strtoint(label2.Caption))
    else
     timestr:=inttostr(30-strtoint(label2.Caption));
    MessageDlg('Вы выиграли!'+#10+#13+ 'Ваше время - '+timestr+'сек.'+
    #10+#13+'Ваша труба - '+inttostr(PipeLength)+'звеньев',mtInformation,[mbOK],0);
    if a[bx,by].Floated then
     MessageDlg('Бонус получен: '+bstr[bn],mtInformation,[mbOk],0);
    n9.Click;
   end
   else
    if MessageDlg('Вы проиграли. Хотите начать заново?',mtConfirmation,[mbYes, mbNo], 0) = mrYes then
     button1.Click
    else n9.Click;
  end;
 end;
end;

procedure TForm1.N5Click(Sender: TObject);
begin
 Form2.ShowModal;
end;

procedure TForm1.N9Click(Sender: TObject);
begin
 n1.Enabled:=true;
 InGame:=false;
 N9.Enabled:=false;
 ValveOpen:=false;
 ValveRotation:=false;
 time:=0;
 Timer1.Interval:=1000;

 Form1.Width:=57*5+152;
 Form1.Height:=57*5+120;

 Image1.Canvas.Rectangle(-1,-1,700,700);
 Image2.Canvas.Rectangle(-1,-1,58,58);
 Image3.Canvas.Rectangle(-1,-1,58,58);
 Image4.Left:=Form1.Width-130;
 Image4.Canvas.Rectangle(-1,-1,101,101);
 Imagelist3.Draw(Image4.Canvas,0,0,0,true);
 Button4.Visible:=true;
 PipeReplace:=false;

 Button2.Click;
 Label1.Visible:=false;
 Label2.Visible:=false;
end;

procedure TForm1.N10Click(Sender: TObject);
begin
 Form1.Close;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var i:byte;
begin
 with TIniFile.Create(ExtractFilePath(Application.ExeName)+'data.ini') do
  begin
   WriteString('MAIN','N',inttostr(Unit5.n));
   for i:=1 to Unit5.n do
   begin
    WriteString('USERS','U'+inttostr(i),Unit5.p[i].name);
    WriteString('USERS','U'+inttostr(i)+'S',inttostr(Unit5.p[i].bStop));
    WriteString('USERS','U'+inttostr(i)+'F',inttostr(Unit5.p[i].bFreeze));
    WriteString('USERS','U'+inttostr(i)+'C',inttostr(Unit5.p[i].bChange));
   end;
 end;
 Application.Terminate;
end;

procedure TForm1.N6Click(Sender: TObject);
begin
 ShellExecute(Application.Handle,PChar('open'),PChar('pipeshelp.exe'),nil,PChar(ExtractFilePath(Application.ExeName)),SW_SHOWNORMAL)
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 if (MessageDlg('Вы действительно хотите выйти?',mtConfirmation,[mbYes,mbNo],0)=mryes) then
  canclose:=True
 else
  canclose:=False;
end;

procedure TForm1.Alvbry1Click(Sender: TObject);
var i,j:word;
begin
 Timer1.Enabled:=false;
 Timer2.Enabled:=false;
 Timer3.Enabled:=false;
 for i:=1 to n do
  for j:=1 to m do
   Form4.StringGrid1.Cells[j-1,i-1]:=inttostr(b[k][i,j])+'('+inttostr(a[i,j].PipeIndex)+')';
 Form4.Label1.Caption:=inttostr(k);
 Form4.Label2.Caption:=inttostr(Unit5.pNum)+' - '+Unit5.p[Unit5.pNum].Name;
 Form4.Edit1.Text:=inttostr(unit5.p[unit5.pNum].bStop);
 Form4.Edit2.Text:=inttostr(unit5.p[unit5.pNum].bFreeze);
 Form4.Edit3.Text:=inttostr(unit5.p[unit5.pNum].bChange);
 Form4.show;
end;

procedure TForm1.N8Click(Sender: TObject);
begin
  MessageDlg('Извините, рекорды в этой версии отсутствуют =Р',mtInformation,[mbOK],0)
end;

procedure TForm1.Image6Click(Sender: TObject);
begin
 if InGame then if Unit5.p[Unit5.pNum].bStop>0 then
 begin
  btime:=10;
  dec(Unit5.p[Unit5.pNum].bStop);
 end;
 Button2.Click;
end;

procedure TForm1.Image7MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if (X>40) and (Y>40) then
  if pasteNum<5 then
   inc(pasteNum)
  else
   pasteNum:=0
 else
  if InGame then if Unit5.p[Unit5.pNum].bChange>0 then
  begin
   PipeReplace:=true;
   dec(Unit5.p[Unit5.pNum].bChange);
  end;
 Button2.Click;
end;

procedure TForm1.Image5Click(Sender: TObject);
begin
 if InGame then if Timer1.Interval<5000 then
  if Unit5.p[Unit5.pNum].bFreeze>0 then
  begin
   Timer1.Interval:=Timer1.Interval*2;
   dec(Unit5.p[Unit5.pNum].bFreeze);
  end;
 Button2.Click;
end;

end.
