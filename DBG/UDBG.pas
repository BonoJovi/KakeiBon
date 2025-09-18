unit UDBG;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LCLType, Forms, Controls, ExtCtrls, DBCtrls, DBGrids,
  LMessages;

type

  // イベント型
  TWMVScrollEvent = procedure(Sender: TObject; var Message: TLMVScroll) of object;

  { TDBG }

  TDBG = class(TDBGrid)
  private
    FOnWMVScroll : TWMVScrollEvent;
  public
    constructor Create(TheOwner: TComponent); override;
    procedure WMVScroll(var Message: TLMVScroll); message LM_VScroll;
  published
    property OnWMVScroll: TWMVScrollEvent read FOnWMVScroll write FOnWMVScroll;
  end;

procedure Register;

implementation

uses
  LazLogger;

procedure Register;
begin
  // 'Data Controls'タブに TDBG クラスを登録する
  RegisterComponents('Custom Controls', [TDBG]);
end;

{ TDBG }

constructor TDBG.Create(TheOwner: TComponent);
begin
  Inherited Create(TheOwner);
end;

procedure TDBG.WMVScroll(var Message: TLMVScroll);
begin
  // OnSetFocusイベントがフォーム側で割り当てられていれば、それを実行する
  if Assigned(FOnWMVScroll) then
  begin
    FOnWMVScroll(Self, Message);
  end;

  Inherited;
end;

end.

