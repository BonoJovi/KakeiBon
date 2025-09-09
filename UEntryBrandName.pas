unit UEntryBrandName;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Variants, SQLDB, SQLite3Conn, DB, Forms, Controls,
  Graphics, Dialogs, DBGrids, DBCtrls, StdCtrls, ExtCtrls, LCLIntf, LCLType,
  ActnList, UDBNavi;

type

  { TFrmEntryBrandName }

  TFrmEntryBrandName = class(TForm)
    ADS              : TDataSource;
    AQu              : TSQLQuery;
    ADSNextID        : TDataSource;
    AQuNextID        : TSQLQuery;
    ADSMaker         : TDataSource;
    AQuMaker         : TSQLQuery;
    ActionList       : TActionList;
    ActEntryMaker    : TAction;
    ActInsert        : TAction;
    ActCancel        : TAction;
    ActSave          : TAction;
    ActGoBack        : TAction;
    ADBGrid          : TDBGrid;
    ADBNavi           : TDBNavi;
    DBCBDisabled     : TDBCheckBox;
    DBCBEndOfSales   : TDBCheckBox;
    DBEdtBrandNameID : TDBEdit;
    DBEdtBrandName   : TDBEdit;
    DBEdtMakerID     : TDBEdit;
    DBEdtUserID      : TDBEdit;
    DBLCBMaker       : TDBLookupComboBox;
    LblDisabled1     : TLabel;
    LblDisabled2     : TLabel;
    LblDisabled3     : TLabel;
    LblEndOfSales1   : TLabel;
    LblEndOfSales2   : TLabel;
    LblID1           : TLabel;
    LblID2           : TLabel;
    LblBrandName1    : TLabel;
    LblBrandName2    : TLabel;
    LblMaker         : TLabel;
    BtnEntryMaker    : TPanel;
    BtnInsert        : TPanel;
    BtnCancel        : TPanel;
    BtnSave          : TPanel;
    BtnGoBack        : TPanel;
    Panel1           : TPanel;
    Panel2           : TPanel;
    Panel3           : TPanel;
    Panel4           : TPanel;
    PnlCancel        : TPanel;
    PnlSave          : TPanel;
    PnlGoBack        : TPanel;
    PnlInsert        : TPanel;
    PnlEntryMaker    : TPanel;
    Shape1           : TShape;
    Shape2           : TShape;
    Shape3           : TShape;
    Shape4           : TShape;
    Shape5           : TShape;
    Timer            : TTimer;
    procedure ADBGridEnter(Sender: TObject);
    procedure ADBGridSelectEditor(Sender: TObject; Column: TColumn;
      var Editor: TWinControl);
    procedure ADBNaviBtnClick(Sender: TObject; Index: TNavigateBtn);
    procedure ADBNaviClick(Sender: TObject; Button: TDBNavButtonType);
    procedure ADBNaviEnter(Sender: TObject);
    procedure ADBNaviExit(Sender: TObject);
    procedure ADBNaviKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ADBNaviMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ADBNaviWMSetFocus(Sender: TObject; HWndLostFocus: HWND);
    procedure DBCBDisabledEnter(Sender: TObject);
    procedure DBCBDisabledExit(Sender: TObject);
    procedure DBCBEndOfSalesEnter(Sender: TObject);
    procedure DBCBEndOfSalesExit(Sender: TObject);
    procedure DBEdtBrandNameEnter(Sender: TObject);
    procedure DBEdtBrandNameIDEnter(Sender: TObject);
    procedure DBEdtBrandNameIDExit(Sender: TObject);
    procedure DBLCBMakerChange(Sender: TObject);
    procedure DBLCBMakerEnter(Sender: TObject);
    procedure DBLCBMakerExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ProcEntryMaker(Sender: TObject);
    procedure ProcInsert(Sender: TObject);
    procedure ProcCancel(Sender: TObject);
    procedure ProcSave(Sender: TObject);
    procedure EntryMakerMouseOver(NewColor: TColor);
    procedure BtnEntryMakerEnter(Sender: TObject);
    procedure BtnEntryMakerExit(Sender: TObject);
    procedure InsertMouseOver(NewColor: TColor);
    procedure BtnInsertEnter(Sender: TObject);
    procedure BtnInsertExit(Sender: TObject);
    procedure CancelMouseOver(NewColor: TColor);
    procedure BtnCancelEnter(Sender: TObject);
    procedure BtnCancelExit(Sender: TObject);
    procedure SaveMouseOver(NewColor: TColor);
    procedure BtnSaveEnter(Sender: TObject);
    procedure BtnSaveExit(Sender: TObject);
    procedure GoBackMouseOver(NewColor: TColor);
    procedure BtnGoBackEnter(Sender: TObject);
    procedure BtnGoBackExit(Sender: TObject);
    procedure ActEntryMakerExecute(Sender: TObject);
    procedure ActInsertExecute(Sender: TObject);
    procedure ActCancelExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure ActGoBackExecute(Sender: TObject);
    procedure DBEdtBrandNameExit(Sender: TObject);
    procedure DBEdtBrandNameIDChange(Sender: TObject);
    procedure DBLCBMakerSelect(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FTab              : Boolean;
    FGuidePanels      : Array[0..3] of TPanel;
    FCurrentComponent : TObject;
    FDoCommit        : Boolean;
    FReOpenDS        : Boolean;
    FInsert          : Boolean;
    FCurrMakerID     : Integer;
    FMakerID         : Variant;
    FBrandNameID     : Variant;
    procedure BackupValues;
  public

  end;

var
  FrmEntryBrandName: TFrmEntryBrandName;

implementation
uses
  UCommonDB, UDefs, UConsts, UDBAccess, UTopMenu, UManageDetails, UAddDetail,
  UEditDetail, UEntryMaker;

{$R *.lfm}

{ TFrmEntryBrandName }

procedure TFrmEntryBrandName.BackupValues;
begin
  with Defs do begin
    if Not VarIsNull(DBLCBMaker.KeyValue) then begin;
      SetMakerID(DBLCBMaker.KeyValue);
    end;
    if (DBEdtBrandNameID.Text <> '')
      And (StrToInt(DBEdtBrandNameID.Text) > 0) then begin;
        SetBrandNameID(DBEdtBrandNameID.Text);
    end else begin
      SetBrandNameID('');
    end;
    if DBEdtBrandName.Text <> '' then begin;
      SetBrandName(DBEdtBrandName.Text);
    end;

    if DBCBEndOfSales.State = cbChecked then begin
      SetEndOfSales(True);
    end else begin
      SetEndOfSales(False);
    end;

    if DBCBDisabled.State = cbChecked then begin
      SetDisabled(True);
    end else begin
      SetDisabled(False);
    end;
  end;
end;

procedure TFrmEntryBrandName.ProcEntryMaker(Sender: TObject);
begin
  with Defs do begin
    SetEntryMaker(0);
    Close;
  end;
end;

procedure TFrmEntryBrandName.DBLCBMakerEnter(Sender: TObject);
begin
  Shape1.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.DBEdtBrandNameIDEnter(Sender: TObject);
begin
  Shape2.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.DBEdtBrandNameEnter(Sender: TObject);
begin
  Shape3.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.DBCBEndOfSalesEnter(Sender: TObject);
begin
  Shape4.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.DBCBDisabledEnter(Sender: TObject);
begin
  Shape5.Visible := True;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.ADBNaviClick(Sender: TObject;
  Button: TDBNavButtonType);
begin
  with CommonDB do begin
    with Defs do begin
      if (Button = nbFirst) or (Button = nbPrior) then begin
        if AQu.RecNo = 1  then begin
          AQu.First;
          BtnGoBack.SetFocus;
        end;
      end else if (Button = nbNext) Or (Button = nbLast) then begin
        if AQu.RecNo = AQu.RecordCount  then begin
          AQu.Last;
          DBEdtBrandName.SetFocus;
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryBrandName.ADBNaviBtnClick(Sender: TObject;
  Index: TNavigateBtn);
var
  LMakerID : Integer;
begin
  with CommonDB do begin
    with Defs do begin
      SetMakerID(DBLCBMaker.KeyValue);
      LMakerID := StrToInt(VarToStr(GetMakerID));
    end;
  end;

  if FInsert then begin
    ProcCancel(Sender);
  end;

  with CommonDB do begin
    ATr.Active := False;

    with Defs do begin
      OpenSelectQuery(
        ADSMaker, AQuMaker, SQL_20130002);
      SetKeyValToDBLCB(
        DBLCBMaker, DBEdtMakerID, LMakerID);

      OpenSelectQueryWithMakerID(
        ADS, AQu, SQL_20140002, StrToInt(VarToStr(GetMakerID)));
    end;
  end;

  Inherited;
end;

procedure TFrmEntryBrandName.ADBGridSelectEditor(Sender: TObject;
  Column: TColumn; var Editor: TWinControl);
begin
  ADBGrid.AutoAdjustColumns;
end;

procedure TFrmEntryBrandName.ADBGridEnter(Sender: TObject);
var
  LDBEdit : TDBEdit;
  LDBCB   : TDBCheckBox;
  LPanel  : TPanel;
begin
  if FInsert then begin;
    ProcCancel(Sender);
  end;

  if FCurrentComponent is TDBNavi then begin
    ADBNavi.SetFocus;
  end else if FCurrentComponent is TDBEdit then begin
    LDBEdit := FCurrentComponent as TDBEdit;
    LDBEdit.SetFocus;
  end else if FCurrentComponent is TDBCheckBox then begin
    LDBCB := FCurrentComponent as TDBCheckBox;
    LDBCB.SetFocus;
  end else if FCurrentComponent is TPanel then begin
    LPanel := FCurrentComponent as TPanel;
    LPanel.SetFocus;
  end;
end;

procedure TFrmEntryBrandName.ADBNaviEnter(Sender: TObject);
begin
  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.ADBNaviExit(Sender: TObject);
begin
  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.ADBNaviKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_SPACE) Or (Key = VK_RETURN) then begin
    if ActiveControl.ClassName = 'DBNavFocusableButton' then begin
      if FInsert then begin
        ProcCancel(Sender);
      end;
      with Defs do begin
        OpenSelectQueryWithMakerID(
          ADS, AQu, SQL_20140002, StrToInt(VarToStr(GetMakerID)));
      end;
    end;
  end;
end;

procedure TFrmEntryBrandName.ADBNaviMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if FInsert then begin
    ProcCancel(Sender);
  end;
end;

procedure TFrmEntryBrandName.ADBNaviWMSetFocus(Sender: TObject;
  HWndLostFocus: HWND);
begin
  if FTab then begin
    try
      if (Assigned(AQu)) And (AQu.RecordCount > 0)  then begin
        if Not FInsert then begin
          if Screen.ActiveControl is TDBNavi then begin
            TWinControl(ADBNavi.FindNextControl(TWinControl(ADBNavi), True, True, True)).SetFocus;
          end;
        end else begin
          ProcCancel(Sender);
        end;
      end;
    except
      on E: Exception do begin
        ShowMessage(E.Message);
      end;
    end;
  end;

  Timer.Enabled := True;
end;

procedure TFrmEntryBrandName.DBCBDisabledExit(Sender: TObject);
begin
  Shape5.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.DBCBEndOfSalesExit(Sender: TObject);
begin
  Shape4.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.DBEdtBrandNameIDExit(Sender: TObject);
begin
  Shape2.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.DBLCBMakerChange(Sender: TObject);
var
  LMakerID : Integer;
begin
  try
    try
      LMakerID := StrToInt(VarToStr(DBLCBMaker.KeyValue));
      with CommonDB do begin
        CloseQuery(AQu);

        with Defs do begin
          with AQu do begin
            SQLConnection  := ACn;
            SQLTransaction := ATr;

            OpenSelectQueryWithMakerID(
              ADS, AQu, SQL_20140002, LMakerID);

            Insert;

            OpenSelectQuery(
              ADS, AQu, SQL_20130001);
            DBLCBMaker.KeyValue := LMakerID;

            DBCBEndOfSales.Checked := False;
            DBCBDisabled.Checked   := False;
          end;
        end;
      end;
    except
      on E: Exception do begin
        ShowMessage(E.Message);
      end;
    end;
  finally
  end;
end;

procedure TFrmEntryBrandName.DBLCBMakerExit(Sender: TObject);
begin
  Shape1.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.ProcInsert(Sender: TObject);
begin
  if Not FInsert then begin
    with CommonDB do begin
      with Defs do begin
        try
          with ACn do begin
            if Not Connected then begin
              Open;
            end;
          end;
        except
          on E: Exception do begin
            ShowMessage(MSG_JP_000013 + ' : ' + E.Message);
          end;
        end;

        if (VarIsNull(GetMakerID))
            Or (VarToStr(GetMakerID) = '')
            Or (VarToStr(GetMakerID) = '0') then begin
          if (Not VarIsNull(DBLCBMaker.KeyValue))
              And (VarToStr(DBLCBMaker.KeyValue) <> '')
              And (VarToStr(DBLCBMaker.KeyValue) <> '0') then begin
            SetMakerID(DBLCBMaker.KeyValue);
          end else begin
            SetMakerID(0);
          end;
        end;

        ATr.Active := False;
        with ATr do begin
          if Not Active then begin
            StartTransaction;
          end;
        end;

        //CloseQuery(AQu);
        with AQu do begin
          SQLConnection  := ACn;
          SQLTransaction := ATr;

          if Not Active then begin
            if (Not VarIsNull(GetMakerID)) And (VarToStr(GetMakerID) <> '') then begin
              OpenSelectQueryWithMakerID(
                ADS, AQu, SQL_20140002, StrToInt(VarToStr(GetMakerID)));
            end else begin
              OpenSelectQueryWithMakerID(
                ADS, AQu, SQL_20140002, 0);
            end;
          end;

          Insert;

          DBEdtUserID.Text := IntToStr(GetUID);

          // Set maker combo box
          OpenSelectQuery(ADSMaker, AQuMaker, SQL_20130001);
          SetKeyValToDBLCB(DBLCBMaker, DBEdtMakerID, StrToInt(VarToStr(GetMakerID)));

          FInsert := True;
          DBCBEndOfSales.Checked := False;
          DBCBDisabled.Checked   := False;
          DBEdtBrandName.SetFocus;
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryBrandName.ProcCancel(Sender: TObject);
begin
  with CommonDB do begin
    with Defs do begin
      if FInsert then begin
        if AQu.RecordCount > 0 then begin
          ATr.Rollback;
          OpenSelQuAndSetVal(ADSMaker, AQuMaker,
            DBLCBMaker, DBEdtMakerID, SQL_20130002);
          SetKeyValToDBLCB(
            DBLCBMaker, DBEdtMakerID, StrToInt(VarToStr(GetMakerID)));

          DBCBEndOfSales.Checked := False;
          DBCBDisabled.Checked   := False;

          FInsert := False;
        end;
      end;

      if AQu.RecordCount = 0 then begin
        DBEdtBrandName.SetFocus;
      end else begin
        ADBNavi.SetFocus;
      end;
    end;
  end;
end;

procedure TFrmEntryBrandName.ProcSave(Sender: TObject);
var
  LNextBrandNameID  : Integer;
  LMakerID     : Integer;
begin
  FDoCommit := True;
  try
    try
      with CommonDB do begin
        CloseQuery(AQu);

        with Defs do begin
          with AQu do begin
            SQL.Text := SQL_20140005;
            Params.ParamByName('pUserID').AsInteger := GetUID;

            with Params do begin
              FCurrMakerID := StrToInt(VarToStr(GetMakerID));

              if FCurrMakerID > 0 then begin
                ParamByName('pMakerID').AsInteger  := FCurrMakerID;
              end else begin
                ParamByName('pMakerID').AsInteger  := StrToInt(VarToStr(GetMakerID));
              end;
              LMakerID := ParamByName('pMakerID').AsInteger;

              OpenSelectQueryWithMakerID(
                ADSNextID, AQuNextID, SQL_20140003, LMakerID);
              LNextBrandNameID := AQuNextID.FieldByName('NEXT_ID').AsInteger;

              CloseQuery(AQuNextID);

              if VarToStr(GetBrandNameID) <> '' then begin
                ParamByName('pBrandNameID').AsInteger  := StrToInt(VarToStr(GetBrandNameID));
              end else begin
                ParamByName('pBrandNameID').AsInteger  := LNextBrandNameID;
              end;

              ParamByName('pBrandName').AsAnsiString     := GetBrandName;

              ParamByName('pEndOfSales').AsBoolean       := GetEndOfSales;

              ParamByName('pDisabled').AsBoolean         := GetDisabled;

              ParamByName('pEntryDT').AsDateTime         := Now;
              ParamByName('pUpdateDT').AsDateTime        := Now;
            end;

            //CloseTransactions;
            //SetDatabaseNames;

            ExecSQL;
            ATr.Commit;
          end;

          //CloseConn(ACn, ATr, AQu);
          //SetDatabaseNames;

          OpenSelectQuery(ADSMaker, AQuMaker, SQL_20130002);
          DBLCBMaker.KeyValue := GetMakerID;

          if DBEdtBrandNameID.Text <> '' then begin
            OpenSelectQueryWithMakerIDAndBrandNameID(
              ADS, AQu, SQL_20140002, StrToInt(VarToStr(DBLCBMaker.KeyValue)), StrToInt(DBEdtBrandNameID.Text));
          end else begin
            if (LMakerID > 0) then begin
              OpenSelectQueryWithMakerIDAndBrandNameID(
                ADS, AQu, SQL_20140002, LMakerID, 1);
            end else begin
              MessageDlg(MSG_JP_000034, mtInformation, [mbOk], 0);
            end;
          end;

          ADBGrid.AutoAdjustColumns;
          FInsert := False;
        end;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
      end;
    end;
    DBLCBMaker.SetFocus;
  finally
  end;

  FReOpenDS     := True;
  Timer.Enabled := True;
  FDoCommit     := False;
end;

procedure TFrmEntryBrandName.EntryMakerMouseOver(NewColor: TColor);
begin
  BtnEntryMaker.Color := NewColor;
end;

procedure TFrmEntryBrandName.BtnEntryMakerEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clSkyBlue);
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.BtnEntryMakerExit(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.InsertMouseOver(NewColor: TColor);
begin
  BtnInsert.Color := NewColor;
end;

procedure TFrmEntryBrandName.BtnInsertEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);
  InsertMouseOver(clSkyBlue);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.BtnInsertExit(Sender: TObject);
begin
  InsertMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.CancelMouseOver(NewColor: TColor);
begin
  BtnCancel.Color := NewColor;
end;

procedure TFrmEntryBrandName.BtnCancelEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clSkyBlue);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.BtnCancelExit(Sender: TObject);
begin
  CancelMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.SaveMouseOver(NewColor: TColor);
begin
  BtnSave.Color := NewColor;
end;

procedure TFrmEntryBrandName.BtnSaveEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clSkyBlue);
  GoBackMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.BtnSaveExit(Sender: TObject);
begin
  SaveMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.GoBackMouseOver(NewColor: TColor);
begin
  BtnGoBack.Color := NewColor;
end;

procedure TFrmEntryBrandName.BtnGoBackEnter(Sender: TObject);
begin
  EntryMakerMouseOver(clBtnFace);
  InsertMouseOver(clBtnFace);
  CancelMouseOver(clBtnFace);
  SaveMouseOver(clBtnFace);
  GoBackMouseOver(clSkyBlue);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.BtnGoBackExit(Sender: TObject);
begin
  GoBackMouseOver(clBtnFace);

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.ActEntryMakerExecute(Sender: TObject);
begin
  BackupValues;
  ProcEntryMaker(Sender);
end;

procedure TFrmEntryBrandName.ActInsertExecute(Sender: TObject);
begin
  ProcInsert(Sender);
end;

procedure TFrmEntryBrandName.ActCancelExecute(Sender: TObject);
begin
  ProcCancel(Sender);
  with CommonDB do begin
    ATr.Rollback;

    with Defs do begin
      with AQuMaker do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        OpenSelectQuery(ADSMaker, AQuMaker, SQL_20130002);
      end;
      with AQu do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        OpenSelectQuery(ADS     , AQu     , SQL_20140001);
      end;
    end;
  end;
end;

procedure TFrmEntryBrandName.ActSaveExecute(Sender: TObject);
begin
  BackupValues;
  ProcSave(Sender);
end;

procedure TFrmEntryBrandName.ActGoBackExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmEntryBrandName.DBLCBMakerSelect(Sender: TObject);
var
  LNextBrandNameID : Integer;
  LMakerID         : Integer;
begin
  if Not FDoCommit then begin
    with CommonDB do begin
      with Defs do begin
        CloseQuery(AQu);
        SetSQLite3DatabaseName;

        with AQu do begin
          SetMakerID(DBLCBMaker.KeyValue);
          DBEdtMakerID.Text := VarToStr(GetMakerID);
          LMakerID          := StrToInt(DBEdtMakerID.Text);

          //OpenSelectQueryWithMakerIDAndBrandNameID(ACn, ADS, ATr, AQu, SQL_20140001, StrToInt(VarToStr(GetMakerID)), StrToInt(VarToStr(GetBrandNameID)));
          OpenSelectQueryWithMakerIDAndBrandNameID(
            ADS, AQu, SQL_20140002, LMakerID, 1);
          if AQu.RecordCount > 0 then begin
            Insert;
          end else begin
            OpenSelectQuery(ADSNextID, AQuNextID, SQL_20140003);
            LNextBrandNameID := AQuNextID.FieldByName('NEXT_ID').AsInteger;

            CloseQuery(AQuNextID);

            DBEdtBrandNameID.Text := IntToStr(LNextBrandNameID);
            DBEdtBrandName.Text   := '';
            Insert;
            OpenSelectQuery(ADSMaker, AQuMaker, SQL_20130002);
            if (Not VarIsNull(GetMakerID)) And (VarToStr(GetMakerID) <> '') then begin
              DBLCBMaker.KeyValue := StrToInt(VarToStr(GetMakerID));
            end else begin
              DBLCBMaker.KeyValue := AQuMaker.FieldByName('MAKER_ID').AsInteger;
            end;
          end;
          DBEdtUserID.Text := IntToStr(GetUID);
        end;
      end;
    end;
  end;
  ADBGrid.AutoAdjustColumns;
end;

procedure TFrmEntryBrandName.DBEdtBrandNameIDChange(Sender: TObject);
begin
  if Not FDoCommit then begin
    with CommonDB do begin
      with Defs do begin
        if (AQu.FieldByName('BRAND_NAME_ID').AsAnsiString <> '')
          And (AQu.FieldByName('BRAND_NAME_ID').AsInteger > 0) then begin
          SetBrandNameID(AQu.FieldByName('BRAND_NAME_ID').AsVariant);
        end;
      end;
    end;
  end;
end;

procedure TFrmEntryBrandName.DBEdtBrandNameExit(Sender: TObject);
begin
  if Not FDoCommit then begin
    with Defs do begin
      SetBrandName(DBEdtBrandName.Text);
    end;
  end;

  Shape3.Visible := False;

  FCurrentComponent := Sender;
  Timer.Enabled     := True;
end;

procedure TFrmEntryBrandName.FormClose(
  Sender: TObject; var CloseAction: TCloseAction);
begin
  with CommonDB do begin
    CloseQuery(AQu);
    CloseQuery(AQuNextID);
    CloseQuery(AQuMaker);
  end;

  with Defs do begin
    if GetEntryMaker = 0 then begin
      FrmEntryMaker            := TFrmEntryMaker.Create(Application);
      FrmEntryMaker.Visible    := True;
    end else if GetEntryBrandName = 1 then begin
      FrmAddDetail             := TFrmAddDetail.Create(Application);
      FrmAddDetail.Visible     := True;
    end else if GetEntryBrandName = 2 then begin
      FrmEditDetail            := TFrmEditDetail.Create(Application);
      FrmEditDetail.Visible    := True;
    end;
  end;

  CloseAction                  := caFree;
  FrmEntryBrandName            := nil;
end;

procedure TFrmEntryBrandName.FormCreate(Sender: TObject);
begin
  with Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;

  with Defs do begin
    FMakerID     := GetMakerID;
    FBrandNameID := GetBrandNameID;
  end;

  FGuidePanels[0] := Panel1;
  FGuidePanels[1] := Panel2;
  FGuidePanels[2] := Panel3;
  FGuidePanels[3] := Panel4;
end;

procedure TFrmEntryBrandName.FormShow(Sender: TObject);
begin
  FrmEntryBrandName.Width      := 594;

  FrmEntryBrandName.KeyPreview := True;

  FReOpenDS       := False;
  Timer.Enabled   := False;
  FDoCommit       := False;
  FInsert         := False;

  FrmEntryBrandName.Color := RGB(112, 168, 175);
  PnlEntryMaker.Color     := RGB( 72, 122, 129);
  PnlInsert.Color         := RGB( 72, 122, 129);
  PnlCancel.Color         := RGB( 72, 122, 129);
  PnlSave.Color           := RGB( 72, 122, 129);
  PnlGoBack.Color         := RGB( 72, 122, 129);

  { Debug }
  //FrmEntryBrandName.Width := 813;
end;

procedure TFrmEntryBrandName.FormActivate(Sender: TObject);
begin
  with CommonDB do begin
    with Defs do begin
      with AQuMaker do begin
        SQLConnection  := ACn;
        SQLTransaction := ATr;

        ProcInsert(Sender);
        OpenSelectQuery(ADSMaker, AQuMaker, SQL_20130002);
        DBEdtUserID.Text := IntToStr(GetUID);
      end;
    end;
  end;

  ADBGrid.AutoAdjustColumns;
end;

procedure TFrmEntryBrandName.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_TAB) And (ssShift in Shift) then begin
    FTab := False;
  end else begin
    FTab := True;
    if Screen.ActiveControl is TDBNavi then begin
      ADBNaviWMSetFocus(ADBNavi, ADBNavi.Handle);
    end;
  end;

  if (Key = VK_TAB) AND (ssShift in Shift) then begin
    if Screen.ActiveControl is TDBNavi then begin
      BtnGoBack.SetFocus;
    end;
    Timer.Enabled := True;
  end else begin
    Timer.Enabled := True;
  end;

  if (Key = VK_SPACE) Or (Key = VK_RETURN) then begin
    if ActiveControl.Name = 'BtnEntryMaker' then begin
      ActEntryMaker.Execute;
    end else if ActiveControl.Name = 'BtnInsert' then begin
      ActInsert.Execute;
    end else if ActiveControl.Name = 'BtnCancel' then begin
      ActCancel.Execute;
    end else if ActiveControl.Name = 'BtnSave' then begin
      ActSave.Execute;
    end else if ActiveControl.Name = 'BtnGoBack' then begin
      ActGoBack.Execute;
    end;
  end;
end;

procedure TFrmEntryBrandName.TimerTimer(Sender: TObject);
var
  i            : Integer;
  LTargetIndex : Integer;
begin
  Timer.Enabled      := False;

  if FInsert then begin
    if DBCBEndOfSales.State = cbChecked then begin
      AQu.FieldByName('END_OF_SALES').AsBoolean := True;
    end else begin
      AQu.FieldByName('END_OF_SALES').AsBoolean := False;
    end;
    if DBCBDisabled.State = cbChecked then begin
      AQu.FieldByName('DISABLED').AsBoolean := True;
    end else begin
      AQu.FieldByName('DISABLED').AsBoolean := False;
    end;
  end;

  if FReOpenDS then begin
    with CommonDB do begin
      with Defs do begin
        OpenSelectQuery(ADS, AQu, SQL_20080001);
      end;
    end;
    FReOpenDS          := False;
  end;

  try
    if (ActiveControl is TDBNavFocusableButton) then begin
      LTargetIndex := ActiveControl.ComponentIndex - 10;

      for i := Low(FGuidePanels) To High(FGuidePanels) do begin
        FGuidePanels[i].Visible := (i = LTargetIndex);
      end;
    end else begin
      for i := Low(FGuidePanels) To High(FGuidePanels) do begin
        FGuidePanels[i].Visible := False;
      end;
    end;
  except
    on E: Exception do begin
      ShowMessage(E.Message);
    end;
  end;
end;

end.

