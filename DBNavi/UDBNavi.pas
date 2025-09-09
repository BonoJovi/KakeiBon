unit UDBNavi;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LCLType, Forms, Controls, ExtCtrls, DBCtrls, LMessages;

type

  // イベント型
  TWMSetFocusEvent = procedure(Sender: TObject; HWndLostFocus: HWND) of object;
  TBtnClickEvent = procedure(Sender: TObject; Index: TNavigateBtn) of object;

  { TDBNavi }

  TDBNavi = class(TDBNavigator)
    procedure Enter(Sender: TObject);
    function FindNextControl(CurrentControl: TWinControl; GoForward,
      CheckTabStop, CheckParent: Boolean): TWinControl;
  private
    FDBNavFirstEnter : Boolean;
    FOnBtnClick : TBtnClickEvent;
    FOnKeyUp : TKeyEvent;
    FOnWMSetFocus : TWMSetFocusEvent;
  public
    constructor Create(TheOwner: TComponent); override;
    procedure BtnClick(Index: TNavigateBtn); override;
  protected
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure WMSetFocus(var Message: TLMSetFocus); message LM_SETFOCUS;
  published
    property OnBtnClick: TBtnClickEvent read FOnBtnClick write FOnBtnClick;
    property OnKeyUp: TKeyEvent read FOnKeyUp write FOnKeyUp;
    property OnWMSetFocus: TWMSetFocusEvent read FOnWMSetFocus write FOnWMSetFocus;
  end;

procedure Register;

implementation

uses
  LazLogger;

procedure Register;
begin
  // 'Data Controls'タブに TDBNavi クラスを登録する
  RegisterComponents('Custom Controls', [TDBNavi]);
end;

{ TDBNavi }

constructor TDBNavi.Create(TheOwner: TComponent);
begin
  FDBNavFirstEnter := True;
  Inherited Create(TheOwner);
end;

procedure TDBNavi.BtnClick(Index: TNavigateBtn);
begin
  if Assigned(FOnBtnClick) then
  begin
    FOnBtnClick(Self, Index);
  end;
  Inherited BtnClick(Index);
end;

procedure TDBNavi.Enter(Sender: TObject);
begin
  FDBNavFirstEnter := True;
end;

procedure TDBNavi.KeyUp(var Key: Word; Shift: TShiftState);
begin

  if Assigned(FOnKeyUp) then
  begin
    FOnKeyUp(Self, Key, Shift);
    Key := VK_UNKNOWN;
  end;
end;

procedure TDBNavi.WMSetFocus(var Message: TLMSetFocus);
begin
  // OnSetFocusイベントがフォーム側で割り当てられていれば、それを実行する
  if Assigned(FOnWMSetFocus) then
  begin
    FOnWMSetFocus(Self, Message.FocusedWnd); // Messageのユーザが操作するのに必要な情報だけ受け取る
  end;
end;

function TDBNavi.FindNextControl(CurrentControl: TWinControl;
  GoForward: Boolean; CheckTabStop: Boolean; CheckParent: Boolean): TWinControl;
begin
  Result := Inherited;
end;

end.

