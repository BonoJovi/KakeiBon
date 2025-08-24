unit UManageExp;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, DateUtils, Variants, SQLDB, SQLite3Conn, DB, SysUtils, Forms,
  Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, DBCtrls, Menus, Grids,
  DBGrids, LCLIntf, LCLType, ActnList;

const
  ORDER_KEY1_IDX : Integer = 4;
  ORDER_KEY2_IDX : Integer = 5;
  ORDER_KEY3_IDX : Integer = 6;

type

  { TFrmManageExp }

  TFrmManageExp = class(TForm)
    ACn1                : TSQLite3Connection;
    ADS1                : TDataSource;
    ATr1                : TSQLTransaction;
    AQu1                : TSQLQuery;
    ACn2                : TSQLite3Connection;
    ADS2                : TDataSource;
    ATr2                : TSQLTransaction;
    AQu2                : TSQLQuery;
    ACn3                : TSQLite3Connection;
    ADS3                : TDataSource;
    ATr3                : TSQLTransaction;
    AQu3                : TSQLQuery;
    { ActionLists}
    ActionList          : TActionList;
    ActAddExp2          : TAction;
    ActDefaultOrderKey2 : TAction;
    ActAddExp3          : TAction;
    ActDefaultOrderKey3 : TAction;
    ActGoBack             : TAction;
    ASG1                : TStringGrid;
    ASG2                : TStringGrid;
    ASG3                : TStringGrid;
    Label1              : TLabel;
    Label2              : TLabel;
    BtnAddExp2          : TPanel;
    BtnDefaultOrderKey2 : TPanel;
    BtnAddExp3          : TPanel;
    BtnDefaultOrderKey3 : TPanel;
    BtnGoBack           : TPanel;
    PnlGoBack           : TPanel;
    Timer1              : TTimer;
    procedure ProcAddExp2(Sender: TObject);
    procedure ProcDefaultOrderKey2(Sender: TObject);
    procedure ProcAddExp3(Sender: TObject);
    procedure ProcDefaultOrderKey3(Sender: TObject);
    procedure ProcGoBack(Sender: TObject);
    procedure AddExp2MouseOver(NewColor: TColor);
    procedure BtnAddExp2Enter(Sender: TObject);
    procedure BtnAddExp2Exit(Sender: TObject);
    procedure DefaultOrderKey2MouseOver(NewColor: TColor);
    procedure BtnDefaultOrderKey2Enter(Sender: TObject);
    procedure BtnDefaultOrderKey2Exit(Sender: TObject);
    procedure AddExp3MouseOver(NewColor: TColor);
    procedure BtnAddExp3Enter(Sender: TObject);
    procedure BtnAddExp3Exit(Sender: TObject);
    procedure DefaultOrderKey3MouseOver(NewColor: TColor);
    procedure BtnDefaultOrderKey3Enter(Sender: TObject);
    procedure BtnDefaultOrderKey3Exit(Sender: TObject);
    procedure GoBackMouseOver(NewColor: TColor);
    procedure BtnGoBackEnter(Sender: TObject);
    procedure BtnGoBackExit(Sender: TObject);
    procedure ActAddExp2Execute(Sender: TObject);
    procedure ActDefaultOrderKey2Execute(Sender: TObject);
    procedure ActAddExp3Execute(Sender: TObject);
    procedure ActDefaultOrderKey3Execute(Sender: TObject);
    procedure ActGoBackExecute(Sender: TObject);
    procedure ASG1Click(Sender: TObject);
    procedure ASG2CheckboxToggled(Sender: TObject; aCol, aRow: Integer;
      aState: TCheckboxState);
    procedure ASG2Click(Sender: TObject);
    procedure ASG2KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ASG2PickListSelect(Sender: TObject);
    procedure ASG3CheckboxToggled(Sender: TObject; aCol, aRow: Integer;
      aState: TCheckboxState);
    procedure ASG3Click(Sender: TObject);
    procedure ASG3KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ASG3PickListSelect(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FPrevOrderKey2  : Integer;
    FPrevOrderKey3  : Integer;
    FNewOrderKey2   : Integer;
    FNewOrderKey3   : Integer;
    FPrevExp2       : String;
    FPrevExp3       : String;
    procedure SetDatabaseNames;
    procedure CloseTransactions;
    function GetMaxOrderKey(Qu: TSQLQuery; FieldName: String): Integer;
    function GeneratePickList(MaxIndex: Integer): TStringList;
    procedure SetPickList(StrGrid: TStringGrid;
      FieldIdx: Integer; PickList: TStringList);
    procedure DeleteAllRecords(var SG: TStringGrid);
    procedure SelectExp1;
    procedure SelectExp2;
    procedure SelectExp3;
 public
  end;

var
  FrmManageExp: TFrmManageExp;

implementation

uses
  UConsts, UDBAccess, UTopMenu;

{$R *.lfm}

{ TFrmManageExp }

procedure TFrmManageExp.SetDatabaseNames;
begin
  with FrmTopMenu.Defs do begin
    SetDatabaseName(ACn1);
    SetDatabaseName(ACn2);
    SetDatabaseName(ACn3);
  end;
end;

procedure TFrmManageExp.CloseTransactions;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn1, ATr1);
    CloseConn(ACn2, ATr2);
    CloseConn(ACn3, ATr3);
  end;
end;

procedure TFrmManageExp.ProcAddExp2(Sender: TObject);
var
  LMaxOrderKey2 : Integer;
  LPickList     : TStringList;

  procedure UpdateExpName2;
  begin
    with AQu2 do begin
      SQL.Text := SQL_20060005;
      with Params do begin
        with ASG1 do begin
          ParamByName('pUserID').AsInteger   := Cells[1, ASG1.Row].ToInteger;
          ParamByName('pExpKey1').AsInteger  := Cells[3, ASG1.Row].ToInteger;
          ParamByName('pName2').AsAnsiString := AnsiString(NEW_EXP_NAME);
          ParamByName('pEntryDT').AsDateTime := Now;
        end;

        CloseTransactions;
        ExecSQL;
        ATr2.Commit;
      end;
    end;
  end;

begin
  try
    try
      with FrmTopMenu.Defs do begin
        with AQu2 do begin
          CloseConn(ACn2, ATr2);
          SetDatabaseNames;

          UpdateExpName2;

          // ReQuery
          SelectExp2;
          if AQu2.RecordCount > 0 then begin
            SelectExp3;
          end else begin
            DeleteAllRecords(ASG3);
          end;

          // Generate and set order key lists to order key cells
          LMaxOrderKey2 := GetMaxOrderKey(AQu2, 'ORDER_KEY2');
          LPickList     := GeneratePickList(LMaxOrderKey2);
          SetPickList(ASG2, ORDER_KEY2_IDX, LPickList);

          ASG2.Row      := LMaxOrderKey2;
        end;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
        ATr2.Rollback;
      end;
    end;
  finally
  end;
end;

procedure TFrmManageExp.ProcDefaultOrderKey2(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    CloseTransactions;
    SetDatabaseNames;
    SetDefaultOrderKey2(
      ACn2, ADS2, ATr2, AQu2, SQL_20060014,
      ASG1.Cells[3, ASG1.Row].ToInteger);
  end;
end;

procedure TFrmManageExp.ProcAddExp3(Sender: TObject);
var
  LMaxOrderKey3 : Integer;
  LPickList     : TStringList;

  procedure UpdateExpName3;
  begin
    with AQu3 do begin
      SQL.Text := SQL_20060006;
      with Params do begin
        with ASG2 do begin
          ParamByName('pUserID').AsInteger   := Cells[1, ASG1.Row].ToInteger;
          ParamByName('pExpKey1').AsInteger  := Cells[2, ASG2.Row].ToInteger;
          ParamByName('pExpKey2').AsInteger  := Cells[3, ASG2.Row].ToInteger;
          ParamByName('pName3').AsAnsiString := AnsiString('費目');
          ParamByName('pEntryDT').AsDateTime := Now;
        end;

        CloseTransactions;
        ExecSQL;
        ATr3.Commit;
      end;
    end;
  end;

begin
  try
    try
      with FrmTopMenu.Defs do begin
        with AQu3 do begin
          CloseConn(ACn3, ATr3);
          SetDatabaseNames;

          UpdateExpName3;

          // ReQuery
          SelectExp3;

          // Generate and set order key lists to order key cells
          LMaxOrderKey3 := GetMaxOrderKey(AQu3, 'ORDER_KEY3');
          LPickList     := GeneratePickList(LMaxOrderKey3);
          SetPickList(ASG3, ORDER_KEY3_IDX, LPickList);

          ASG3.Row      := LMaxOrderKey3;
        end;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
        ATr3.Rollback;
      end;
    end;
  finally
  end;
end;

procedure TFrmManageExp.ProcDefaultOrderKey3(Sender: TObject);
begin
  with FrmTopMenu.Defs do begin
    CloseTransactions;
    SetDatabaseNames;
    SetDefaultOrderKey3(
      ACn2, ADS2, ATr2, AQu2, SQL_20060015,
      ASG1.Cells[3, ASG1.Row].ToInteger,
      ASG2.Cells[3, ASG2.Row].ToInteger);
  end;
end;

procedure TFrmManageExp.ProcGoBack(Sender: TObject);
begin
  FrmTopMenu.Visible := True;
  FrmManageExp.Close;
end;

procedure TFrmManageExp.AddExp2MouseOver(NewColor: TColor);
begin
  BtnAddExp2.Color := NewColor;
end;

procedure TFrmManageExp.BtnAddExp2Enter(Sender: TObject);
begin
  AddExp2MouseOver(clSkyBlue);
  DefaultOrderKey2MouseOver(clBtnFace);
  AddExp3MouseOver(clBtnFace);
  DefaultOrderKey3MouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmManageExp.BtnAddExp2Exit(Sender: TObject);
begin
  AddExp2MouseOver(clBtnFace);
end;

procedure TFrmManageExp.DefaultOrderKey2MouseOver(NewColor: TColor);
begin
  BtnDefaultOrderKey2.Color := NewColor;
end;

procedure TFrmManageExp.BtnDefaultOrderKey2Enter(Sender: TObject);
begin
  AddExp2MouseOver(clBtnFace);
  DefaultOrderKey2MouseOver(clSkyBlue);
  AddExp3MouseOver(clBtnFace);
  DefaultOrderKey3MouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmManageExp.BtnDefaultOrderKey2Exit(Sender: TObject);
begin
  DefaultOrderKey2MouseOver(clBtnFace);
end;

procedure TFrmManageExp.AddExp3MouseOver(NewColor: TColor);
begin
  BtnAddExp3.Color := NewColor;
end;

procedure TFrmManageExp.BtnAddExp3Enter(Sender: TObject);
begin
  AddExp2MouseOver(clBtnFace);
  DefaultOrderKey2MouseOver(clBtnFace);
  AddExp3MouseOver(clSkyBlue);
  DefaultOrderKey3MouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmManageExp.BtnAddExp3Exit(Sender: TObject);
begin
  AddExp3MouseOver(clBtnFace);
end;

procedure TFrmManageExp.DefaultOrderKey3MouseOver(NewColor: TColor);
begin
  BtnDefaultOrderKey3.Color := NewColor;
end;

procedure TFrmManageExp.BtnDefaultOrderKey3Enter(Sender: TObject);
begin
  AddExp2MouseOver(clBtnFace);
  DefaultOrderKey2MouseOver(clBtnFace);
  AddExp3MouseOver(clBtnFace);
  DefaultOrderKey3MouseOver(clSkyBlue);
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmManageExp.BtnDefaultOrderKey3Exit(Sender: TObject);
begin
  DefaultOrderKey3MouseOver(clBtnFace);
end;

procedure TFrmManageExp.GoBackMouseOver(NewColor: TColor);
begin
  BtnGoBack.Color := NewColor;
end;

procedure TFrmManageExp.BtnGoBackEnter(Sender: TObject);
begin
  AddExp2MouseOver(clBtnFace);
  DefaultOrderKey2MouseOver(clBtnFace);
  AddExp3MouseOver(clBtnFace);
  DefaultOrderKey3MouseOver(clBtnFace);
  GoBackMouseOver(clSkyBlue);
end;

procedure TFrmManageExp.BtnGoBackExit(Sender: TObject);
begin
  GoBackMouseOver(clBtnFace);
end;

function TFrmManageExp.GetMaxOrderKey(
  Qu: TSQLQuery; FieldName: String): Integer;
var
  LMaxOrderKey: Integer = 0;
begin
  with Qu do begin
    First;
    while Not EOF do begin
      if LMaxOrderKey < Qu.FieldByName(FieldName).AsInteger then begin
        LMaxOrderKey := Qu.FieldByName(FieldName).AsInteger;
      end;
      Next;
    end;
    First;
  end;

  Result       := LMaxOrderKey;
end;

function TFrmManageExp.GeneratePickList(MaxIndex: Integer): TStringList;
var
  LPickList : TStringList;
  i         : Integer;
begin
  LPickList := TStringList.Create;

  for i := 1 to MaxIndex do
  begin
    LPickList.Add(i.ToString);
  end;

  Result    := LPickList;
end;

procedure TFrmManageExp.SetPickList(StrGrid: TStringGrid;
  FieldIdx: Integer; PickList: TStringList);
var
  i: Integer;
begin
  for i := 1 to StrGrid.RowCount - 1 do
  begin
    with StrGrid.Columns do begin
      Items[FieldIdx].PickList := PickList;
    end;
  end;
end;

procedure TFrmManageExp.DeleteAllRecords(var SG: TStringGrid);
begin
  with SG do begin
    while RowCount > 1 do begin
      DeleteRow(SG.RowCount - 1);
    end;
  end;
end;

procedure TFrmManageExp.SelectExp1;
var
  i : Integer = 1;

  procedure SetValuesToASG1;
  begin
    with AQu1 do begin
      if RecordCount > 0 then begin
        First;
        while Not EOF do begin
          with ASG1 do begin
            RowCount := RowCount + 1;
            Cells[1, i] := FieldByName('USER_ID').AsAnsiString;
            Cells[2, i] := FieldByName('UNAME').AsAnsiString;
            Cells[3, i] := FieldByName('EXP_KEY1').AsAnsiString;
            Cells[4, i] := FieldByName('NAME1').AsAnsiString;
            Cells[5, i] := FieldByName('DISABLED1').AsAnsiString;
            Cells[6, i] := FieldByName('ORDER_KEY1').AsAnsiString;
            Cells[7, i] := FieldByName('ENTRY_DT').AsAnsiString;
            Cells[8, i] := FieldByName('UPDATE_DT').AsAnsiString;
          end;
          Inc(i);
          Next;
        end;
      end;
    end;
  end;

begin
  // Query exp1
  with FrmTopMenu.Defs do begin
    OpenSelectQuery(ACn1, ADS1, ATr1, AQu1, SQL_20060002);
    DeleteAllRecords(ASG1);

    SetValuesToASG1;
  end;
end;

procedure TFrmManageExp.SelectExp2;
var
  i             : Integer = 1;
  LMaxOrderKey2 : Integer;
  LPickList     : TStringList;

  procedure SetValuesToASG2;
  begin
    i := 1;
    with AQu2 do begin
      ASG2.RowCount := AQu2.RecordCount + i;
      if RecordCount > 0 then begin
        First;
        while Not EOF do begin
          with ASG2 do begin
            Cells[1, i] := FieldByName('USER_ID').AsAnsiString;
            Cells[2, i] := FieldByName('EXP_KEY1').AsAnsiString;
            Cells[3, i] := FieldByName('EXP_KEY2').AsAnsiString;
            Cells[4, i] := FieldByName('NAME2').AsAnsiString;
            Cells[5, i] := IntToStr(FieldByName('DISABLED2').AsBoolean.ToInteger);
            Cells[6, i] := FieldByName('ORDER_KEY2').AsAnsiString;
            Cells[7, i] := FieldByName('ENTRY_DT').AsAnsiString;
            Cells[8, i] := FieldByName('UPDATE_DT').AsAnsiString;
          end;
          Inc(i);
          Next;
        end;
      end;
    end;
  end;

begin
  // Query exp2
  with FrmTopMenu.Defs do begin
    DeleteAllRecords(ASG2);

    CloseConn(ACn2, ATr2);
    SetDatabaseNames;
    OpenSelectQueryWithExp1(
      ACn2, ADS2, ATr2, AQu2, SQL_20060003, StrToInt(ASG1.Cells[3, ASG1.Row]));
    SetValuesToASG2;

    // Generate and set order key lists to order key cells
    LMaxOrderKey2 := GetMaxOrderKey(AQu2, 'ORDER_KEY2');
    LPickList     := GeneratePickList(LMaxOrderKey2);
    SetPickList(ASG2, ORDER_KEY2_IDX, LPickList);
  end;
end;

procedure TFrmManageExp.SelectExp3;
var
  i : Integer = 1;
  LMaxOrderKey3 : Integer;
  LPickList     : TStringList;

  procedure SetValuesToASG3;
  begin
    i := 1;
    with AQu3 do begin
      ASG3.RowCount := AQu3.RecordCount + i;
      if RecordCount > 0 then begin
        First;
        while Not EOF do begin
          with ASG3 do begin
            Cells[1, i] := FieldByName('USER_ID').AsAnsiString;
            Cells[2, i] := FieldByName('EXP_KEY1').AsAnsiString;
            Cells[3, i] := FieldByName('EXP_KEY2').AsAnsiString;
            Cells[4, i] := FieldByName('EXP_KEY3').AsAnsiString;
            Cells[5, i] := FieldByName('NAME3').AsAnsiString;
            Cells[6, i] := IntToStr(FieldByName('DISABLED3').AsBoolean.ToInteger);
            Cells[7, i] := FieldByName('ORDER_KEY3').AsAnsiString;
            Cells[8, i] := FieldByName('ENTRY_DT').AsAnsiString;
            Cells[9, i] := FieldByName('UPDATE_DT').AsAnsiString;
          end;
          Inc(i);
          Next;
        end;
      end;
    end;
  end;

begin
  // Query exp3
  with FrmTopMenu.Defs do begin
    DeleteAllRecords(ASG3);

    CloseConn(ACn3, ATr3);
    SetDatabaseNames;
    with ASG2 do begin
      OpenSelectQueryWithExp1AndExp2(
        ACn3, ADS3, ATr3, AQu3, SQL_20060004,
        StrToInt(Cells[2, ASG2.Row]),
        StrToInt(Cells[3, ASG2.Row]));
    end;
    SetValuesToASG3;

    // Generate and set order key lists to order key cells
    LMaxOrderKey3 := GetMaxOrderKey(AQu3, 'ORDER_KEY3');
    LPickList     := GeneratePickList(LMaxOrderKey3);
    SetPickList(ASG3, ORDER_KEY3_IDX, LPickList);
  end;
end;

procedure TFrmManageExp.ActAddExp2Execute(Sender: TObject);
begin
  ProcAddExp2(Sender);
end;

procedure TFrmManageExp.ActDefaultOrderKey2Execute(Sender: TObject);
begin
  ProcDefaultOrderKey2(Sender);
  SelectExp2;
  SelectExp3;
end;

procedure TFrmManageExp.ActAddExp3Execute(Sender: TObject);
begin
  ProcAddExp3(Sender);
end;

procedure TFrmManageExp.ActDefaultOrderKey3Execute(Sender: TObject);
begin
  ProcDefaultOrderKey3(Sender);
  SelectExp3;
end;

procedure TFrmManageExp.ActGoBackExecute(Sender: TObject);
begin
  ProcGoBack(Sender);
end;

procedure TFrmManageExp.ASG1Click(Sender: TObject);
begin
  SelectExp2;
  if AQu2.RecordCount > 0 then begin
    SelectExp3;
  end else begin
    DeleteAllRecords(ASG3);
  end;
end;

procedure TFrmManageExp.ASG2CheckboxToggled(Sender: TObject; aCol,
  aRow: Integer; aState: TCheckboxState);
begin
  try
    try
      with FrmTopMenu.Defs do begin
        with AQu2 do begin
          with Params do begin
            SQL.Text := SQL_20060010;
            if aState = cbChecked then begin
              ParamByName('pDisabled2').AsBoolean := True;
            end else if aState = cbUnchecked then begin
              ParamByName('pDisabled2').AsBoolean := False;
            end;
            with ASG2 do begin
              ParamByName('pUpdateDT').AsDateTime := Now;
              ParamByName('pUserID').AsInteger    := GetUID;
              ParamByName('pExpKey1').AsInteger   := Cells[2, Row].ToInteger;
              ParamByName('pExpKey2').AsInteger   := Cells[3, Row].ToInteger;
            end;

            CloseTransactions;
            ExecSQL;
            ATr2.Commit;
          end;
        end;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
        ATr2.Rollback;
      end;
    end;
  finally
  end;
end;

procedure TFrmManageExp.ASG2Click(Sender: TObject);
begin
  SelectExp3;
  with ASG2 do begin
    FPrevOrderKey2 := Cells[6, ASG2.Row].ToInteger;
    FPrevExp2      := Cells[4, ASG2.Row];
  end;
end;

procedure TFrmManageExp.ASG2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  i : Integer;

  procedure UpdateExp2(SS: String; SG: TStringGrid; aRow: Integer);
  begin
    with AQu2 do begin
      SQL.Text := SS;
      with Params do begin
        with SG do begin
          ParamByName('pUserID').AsInteger    := Cells[1, aRow].ToInteger;
          ParamByName('pExpKey1').AsInteger   := Cells[2, aRow].ToInteger;
          ParamByName('pExpKey2').AsInteger   := Cells[3, aRow].ToInteger;
          ParamByName('pName2').AsString      := Cells[4, aRow];
          ParamByName('pDisabled2').AsBoolean := Cells[5, aRow].ToBoolean;
          ParamByName('pOrderKey2').AsInteger := Cells[6, aRow].ToInteger;
          ParamByName('pUpdateDT').AsDateTime := Now;
        end;

        CloseTransactions;
        ExecSQL;
        ATr2.Commit;
      end;
    end;
  end;

  procedure CancelChangedOrderKey2(
    SS: String; SG: TStringGrid; aRow, OrderKey2: Integer);
  begin
    with AQu2 do begin
      SQL.Text := SS;
      with SG do begin
        with Params do begin
          ParamByName('pUserID').AsInteger    := Cells[1, aRow].ToInteger;
          ParamByName('pExpKey1').AsInteger   := Cells[2, aRow].ToInteger;
          ParamByName('pExpKey2').AsInteger   := Cells[3, aRow].ToInteger;
          ParamByName('pOrderKey2').AsInteger := OrderKey2;
          ParamByName('pUpdateDT').AsDateTime := Now;

          ExecSQL;
        end;
      end;
    end;
  end;

begin
  if Key = VK_RETURN then begin
    try
      try
        UpdateExp2(SQL_20060007, ASG2, ASG2.Row);

        SelectExp2;
        SelectExp3;
      except
        on E: ESQLDatabaseError do begin
          ShowMessage(E.Message);
          ATr2.Rollback;
        end;
      end;
    finally
    end;
  end else if Key = VK_ESCAPE then begin
    if ASG2.Col = 6 then begin
      try
        try
          with ASG2 do begin
            if FPrevOrderKey2 < FNewOrderKey2 then begin
              CloseTransactions;
              CancelChangedOrderKey2(
                SQL_20060012, ASG2, FPrevOrderKey2, FNewOrderKey2);

              for i := FPrevOrderKey2 + 1 to FNewOrderKey2 do begin
                Cells[6, i] := IntToStr(Cells[6, i].ToInteger + 1);

                CancelChangedOrderKey2(
                  SQL_20060012, ASG2, i, Cells[6, i].ToInteger);
              end;
              ATr2.Commit;
            end else if FPrevOrderKey2 > FNewOrderKey2 then begin
              CloseTransactions;
              CancelChangedOrderKey2(
                SQL_20060012, ASG2, FPrevOrderKey2, FPrevOrderKey2);
              for i := FNewOrderKey2 to FPrevOrderKey2 - 1 do begin
                Cells[6, i] := IntToStr(Cells[6, i].ToInteger - 1);

                CancelChangedOrderKey2(
                  SQL_20060012, ASG2, i, Cells[6, i].ToInteger);
              end;
              ATr2.Commit;
            end;
          end;
        except
          on E: ESQLDatabaseError do begin
            ShowMessage(E.Message);
            ATr2.Rollback;
          end;
        end;
      finally
      end;
    end;
  end;
end;

procedure TFrmManageExp.ASG2PickListSelect(Sender: TObject);
var
  i             : Integer;

  procedure SaveChangedOrderKey2(
    SS: String; SG: TStringGrid; aRow, OrderKey2: Integer );
  begin
    with AQu2 do begin
      SQL.Text := SS;
      with Params do begin
        with SG do begin
          ParamByName('pUserID').AsInteger    := Cells[1, aRow].ToInteger;
          ParamByName('pExpKey1').AsInteger   := Cells[2, aRow].ToInteger;
          ParamByName('pExpKey2').AsInteger   := Cells[3, aRow].ToInteger;
          ParamByName('pOrderKey2').AsInteger := OrderKey2;
          ParamByName('pUpdateDT').AsDateTime := Now;
        end;

        ExecSQL;
      end;
    end;
  end;

begin
  try
    try
      with ASG2 do begin
        if Cells[6, ASG2.Row] <> '' then begin
          FNewOrderKey2 := Cells[6, ASG2.Row].ToInteger;
          if FPrevOrderKey2 < FNewOrderKey2 then begin
            CloseTransactions;
            SaveChangedOrderKey2(
              SQL_20060012, ASG2, FPrevOrderKey2, FNewOrderKey2);
            for i := FPrevOrderKey2 + 1 to FNewOrderKey2 do begin
              Cells[6, i] := IntToStr(Cells[6, i].ToInteger - 1);

              SaveChangedOrderKey2(SQL_20060012, ASG2, i, Cells[6, i].ToInteger);
            end;
            ATr2.Commit;
          end else if FPrevOrderKey2 > FNewOrderKey2 then begin
            CloseTransactions;
            SaveChangedOrderKey2(
              SQL_20060012, ASG2, FPrevOrderKey2, FNewOrderKey2);
            for i := FNewOrderKey2 to FPrevOrderKey2 - 1 do begin
              Cells[6, i] := IntToStr(Cells[6, i].ToInteger + 1);

              SaveChangedOrderKey2(SQL_20060012, ASG2, i, Cells[6, i].ToInteger);
            end;
            ATr2.Commit;
          end;
        end;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
        ATr2.Rollback;
      end;
    end;
  finally
  end;
end;

procedure TFrmManageExp.ASG3CheckboxToggled(Sender: TObject; aCol,
  aRow: Integer; aState: TCheckboxState);
begin
  try
    try
      with FrmTopMenu.Defs do begin
        with AQu3 do begin
          with Params do begin
            SQL.Text := SQL_20060011;
            if aState = cbChecked then begin
              ParamByName('pDisabled3').AsBoolean := True;
            end else if aState = cbUnchecked then begin
              ParamByName('pDisabled3').AsBoolean := False;
            end;
            with ASG3 do begin
              ParamByName('pUpdateDT').AsDateTime := Now;
              ParamByName('pUserID').AsInteger    := GetUID;
              ParamByName('pExpKey1').AsInteger   := Cells[2, Row].ToInteger;
              ParamByName('pExpKey2').AsInteger   := Cells[3, Row].ToInteger;
              ParamByName('pExpKey3').AsInteger   := Cells[4, Row].ToInteger;
            end;

            CloseTransactions;
            ExecSQL;
            ATr3.Commit;
          end;
        end;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
        ATr3.Rollback;
      end;
    end;
  finally
  end;
end;

procedure TFrmManageExp.ASG3Click(Sender: TObject);
begin
  with ASG3 do begin
    FPrevOrderKey3 := Cells[7, ASG3.Row].ToInteger;
    FPrevExp3      := Cells[5, ASG3.Row];
  end;
end;

procedure TFrmManageExp.ASG3KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  i : Integer;

  procedure UpdateExp3(SS: String; SG: TStringGrid; aRow: Integer);
  begin
    with AQu3 do begin
      SQL.Text := SS;
      with Params do begin
        with SG do begin
          ParamByName('pUserID').AsInteger    := Cells[1, Row].ToInteger;
          ParamByName('pExpKey1').AsInteger   := Cells[2, Row].ToInteger;
          ParamByName('pExpKey2').AsInteger   := Cells[3, Row].ToInteger;
          ParamByName('pExpKey3').AsInteger   := Cells[4, Row].ToInteger;
          ParamByName('pName3').AsString      := Cells[5, Row];
          ParamByName('pDisabled3').AsBoolean := Cells[6, Row].ToBoolean;
          ParamByName('pOrderKey3').AsInteger := Cells[7, Row].ToInteger;
          ParamByName('pUpdateDT').AsDateTime := Now;
        end;

        CloseTransactions;
        ExecSQL;
        ATr3.Commit;
      end;
    end;
  end;

  procedure CancelChangedOrderKey3(
    SS: String; SG: TStringGrid; aRow, OrderKey3: Integer);
  begin
    with AQu3 do begin
      SQL.Text := SS;
      with SG do begin
        with Params do begin
          ParamByName('pUserID').AsInteger    := Cells[1, aRow].ToInteger;
          ParamByName('pExpKey1').AsInteger   := Cells[2, aRow].ToInteger;
          ParamByName('pExpKey2').AsInteger   := Cells[3, aRow].ToInteger;
          ParamByName('pExpKey3').AsInteger   := Cells[4, aRow].ToInteger;
          ParamByName('pOrderKey3').AsInteger := OrderKey3;
          ParamByName('pUpdateDT').AsDateTime := Now;

          ExecSQL;
        end;
      end;
    end;
  end;

begin
  if Key = VK_RETURN then begin
    try
      try
        UpdateExp3(SQL_20060008, ASG3, ASG3.Row);

        SelectExp3;
      except
        on E: ESQLDatabaseError do begin
          ShowMessage(E.Message);
          ATr2.Rollback;
        end;
      end;
    finally
    end;
  end else if Key = VK_ESCAPE then begin
    if ASG3.Col = 7 then begin
      try
        try
          with ASG3 do begin
            if FPrevOrderKey3 < FNewOrderKey3 then begin
              CancelChangedOrderKey3(
                SQL_20060013, ASG3, FPrevOrderKey3, FPrevOrderKey3);

              for i := FPrevOrderKey3 + 1 to FNewOrderKey3 do begin
                Cells[7, i] := IntToStr(Cells[7, i].ToInteger + 1);

                CancelChangedOrderKey3(
                  SQL_20060013, ASG3, i, Cells[7, i].ToInteger);
              end;
              ATr3.Commit;
            end else if FPrevOrderKey3 > FNewOrderKey3 then begin
              CancelChangedOrderKey3(
                SQL_20060013, ASG3, FPrevOrderKey3, FPrevOrderKey3);

              for i := FNewOrderKey3 to FPrevOrderKey3 - 1 do begin
                Cells[7, i] := IntToStr(Cells[7, i].ToInteger - 1);

                CancelChangedOrderKey3(
                  SQL_20060013, ASG3, i, Cells[7, i].ToInteger);
              end;
              ATr3.Commit;
            end;
          end;
        except
          on E: ESQLDatabaseError do begin
            ShowMessage(E.Message);
            ATr3.Rollback;
          end;
        end;
      finally
      end;
    end;
  end;
end;

procedure TFrmManageExp.ASG3PickListSelect(Sender: TObject);
var
  i             : Integer;

  procedure SaveChangedOrderKey3(
    SS: String; SG: TStringGrid; aRow, OrderKey3: Integer );
  begin
    with AQu3 do begin
      SQL.Text := SS;
      with Params do begin
        with SG do begin
          ParamByName('pUserID').AsInteger    := Cells[1, aRow].ToInteger;
          ParamByName('pExpKey1').AsInteger   := Cells[2, aRow].ToInteger;
          ParamByName('pExpKey2').AsInteger   := Cells[3, aRow].ToInteger;
          ParamByName('pExpKey3').AsInteger   := Cells[4, aRow].ToInteger;
          ParamByName('pOrderKey3').AsInteger := OrderKey3;
          ParamByName('pUpdateDT').AsDateTime := Now;
        end;

        ExecSQL;
      end;
    end;
  end;

begin
  try
    try
      with ASG3 do begin
        if Cells[7, ASG3.Row] <> '' then begin
          FNewOrderKey3 := Cells[7, ASG3.Row].ToInteger;
          if FPrevOrderKey3 < FNewOrderKey3 then begin
            CloseTransactions;
            SaveChangedOrderKey3(
                SQL_20060013, ASG3, FPrevOrderKey3, FNewOrderKey3);

            for i := FPrevOrderKey3 + 1 to FNewOrderKey3 do begin
              Cells[7, i] := IntToStr(Cells[7, i].ToInteger - 1);

              SaveChangedOrderKey3(
                  SQL_20060013, ASG3, i, Cells[7, i].ToInteger);
            end;
            ATr3.Commit;
          end else if FPrevOrderKey3 > FNewOrderKey3 then begin
            CloseTransactions;
            SaveChangedOrderKey3(
                SQL_20060013, ASG3, FPrevOrderKey3, FNewOrderKey3);
            for i := FNewOrderKey3 to FPrevOrderKey3 - 1 do begin
              Cells[7, i] := IntToStr(Cells[7, i].ToInteger + 1);

              SaveChangedOrderKey3(
                  SQL_20060013, ASG3, i, Cells[7, i].ToInteger);
            end;
            ATr3.Commit;
          end;
        end;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
        ATr3.Rollback;
      end;
    end;
  finally
  end;
end;

procedure TFrmManageExp.FormClose(
  Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseTransactions;

  FrmTopMenu.Visible := True;
  CloseAction        := caFree;
  FrmManageExp       := nil;
end;

procedure TFrmManageExp.FormCreate(Sender: TObject);
begin
  SetDatabaseNames;
  with FrmTopMenu.Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;

  with ASG1 do begin
    ColWidths[0]     := 20;
    Columns[0].Width := 0;   // USER_ID
    Columns[1].Width := 120; // NAME
    Columns[2].Width := 0;   // EXP_KEY1
    Columns[3].Width := 150; // NAME1
    Columns[4].Width := 64;  // DEL_FLG1
    Columns[5].Width := 64;  // ORDER_KEY2
    Columns[6].Width := 0;   // ENTRY_DT
    Columns[7].Width := 0;   // UPDATE_DT

    AutoSize          := False;
    ScrollBars        := ssAutoBoth;
  end;

  with ASG2 do begin
    ColWidths[0]     := 20;
    Columns[0].Width := 0;   // USER_ID
    Columns[1].Width := 0;   // EXP_KEY1
    Columns[2].Width := 0;   // EXP_KEY2
    Columns[3].Width := 150; // NAME2
    Columns[4].Width := 64;  // DEL_FLG2
    Columns[5].Width := 64;  // ORDER_KEY2
    Columns[6].Width := 0;   // ENTRY_DT
    Columns[7].Width := 0;   // UPDATE_DT

    AutoSize          := False;
    ScrollBars        := ssAutoBoth;
  end;

  with ASG3 do begin
    ColWidths[0]     := 20;
    Columns[0].Width := 0;   // USER_ID
    Columns[1].Width := 0;   // EXP_KEY1
    Columns[2].Width := 0;   // EXP_KEY2
    Columns[3].Width := 0;   // EXP_KEY3
    Columns[4].Width := 150; // NAME3
    Columns[5].Width := 64;  // DEL_FLG3
    Columns[6].Width := 64;  // ORDER_KEY3
    Columns[7].Width := 0;   // ENTRY_DT
    Columns[8].Width := 0;   // UPDATE_DT

    AutoSize   := False;
    ScrollBars := ssAutoBoth;
  end;
end;

procedure TFrmManageExp.FormShow(Sender: TObject);
begin
  FrmManageExp.KeyPreview := True;

  FrmManageExp.Color := RGB(112, 168, 175);
  PnlGoBack.Color    := RGB( 72, 122, 129);

  SelectExp1;
  SelectExp2;
  if AQu2.RecordCount > 0 then begin
    SelectExp3;
  end else begin
    DeleteAllRecords(ASG3);
  end;

  ASG2.AutoAdjustColumns;
  ASG3.AutoAdjustColumns;
end;

procedure TFrmManageExp.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (Key = VK_SPACE) Or (Key = VK_RETURN) then begin
    if ActiveControl.Name = 'BtnAddExp2' then begin
      ActAddExp2.Execute;
    end else if ActiveControl.Name = 'BtnDefaultOrderKey2' then begin
      ActDefaultOrderKey2.Execute;
    end else if ActiveControl.Name = 'BtnAddExp3' then begin
      ActAddExp3.Execute;
    end else if ActiveControl.Name = 'BtnDefaultOrderKey3' then begin
      ActDefaultOrderKey3.Execute;
    end else if ActiveControl.Name = 'BtnGoBack' then begin
      ActGoBack.Execute;
    end;
  end;
end;

end.
