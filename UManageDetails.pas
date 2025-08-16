unit UManageDetails;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, Dialogs, Variants, SysUtils, SQLDB, SQLite3Conn, DB, Forms, Controls,
  Graphics, StdCtrls, DBCtrls, DBGrids, ExtCtrls, LCLIntf, ActnList;

type

  { TFrmManageDetails }

  TFrmManageDetails = class(TForm)
    ADS                    : TDataSource;
    ATr                    : TSQLTransaction;
    AQu                    : TSQLQuery;
    { ActionLists }
    ActionList             : TActionList;
    ActAddDetailsHeader    : TAction;
    ActEditDetailsHeader   : TAction;
    ActDeleteDetailsHeader : TAction;
    ActQuit                : TAction;
    { Etc controls }
    ADBG                   : TDBGrid;
    ADBNav                 : TDBNavigator;
    BtnAddDetailHeader: TPanel;
    BtnEditDetailHeader: TPanel;
    BtnDeleteDetailHeader: TPanel;
    BtnGoBack: TPanel;
    PnlAddDetail           : TPanel;
    PnlEditDetail          : TPanel;
    PnlGoBack              : TPanel;
    PnlRemoveDetail        : TPanel;
    ACn: TSQLite3Connection;
    procedure ProcAddDetailsHeader(Sender: TObject);
    procedure ProcEditDetailsHeader(Sender: TObject);
    procedure ProcDeleteDetailsHeader(Sender: TObject);
    procedure AddDetailHeaderMouseOver(NewColor: TColor);
    procedure BtnAddDetailHeaderEnter(Sender: TObject);
    procedure BtnAddDetailHeaderExit(Sender: TObject);
    procedure EditDetailHeaderMouseOver(NewColor: TColor);
    procedure BtnEditDetailHeaderEnter(Sender: TObject);
    procedure BtnEditDetailHeaderExit(Sender: TObject);
    procedure DeleteDetailHeaderMouseOver(NewColor: TColor);
    procedure BtnDeleteDetailHeaderEnter(Sender: TObject);
    procedure BtnDeleteDetailHeaderExit(Sender: TObject);
    procedure GoBackMouseOver(NewColor: TColor);
    procedure BtnGoBackEnter(Sender: TObject);
    procedure BtnGoBackExit(Sender: TObject);
    procedure ActAddDetailsHeaderExecute(Sender: TObject);
    procedure ActEditDetailsHeaderExecute(Sender: TObject);
    procedure ActDeleteDetailsHeaderExecute(Sender: TObject);
    procedure ActQuitExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FGoBack : Boolean;
    procedure SetDatabaseNames;
    procedure CloseTransactions;
    function GetGoBack: Boolean;
    procedure SetGoBack(GoBack: Boolean);
    property GoBack: Boolean read GetGoBack write SetGoBack;
  public

  end;

var
  FrmManageDetails: TFrmManageDetails;

implementation
uses
  UConsts, UDBAccess, UTopMenu, UEntryAccount, UEntryShop, UAddDetailsHeader,
  UEditDetailsHeader;

{$R *.lfm}

{ TFrmManageDetails }

procedure TFrmManageDetails.SetDatabaseNames;
begin
  with FrmTopMenu.Defs do begin
    SetDatabaseName(ACn);
  end;
end;

procedure TFrmManageDetails.CloseTransactions;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn, ATr);
  end;
end;

procedure TFrmManageDetails.ProcAddDetailsHeader(Sender: TObject);
begin
  try
    try
      FrmAddDetailsHeader := TFrmAddDetailsHeader.Create(Application);
      with FrmTopMenu.Defs do begin
        SetHeaderDT('');

        CloseTransactions;
        SetDatabaseNames;

        FrmAddDetailsHeader := TFrmAddDetailsHeader.Create(Application);
        OpenForm(Self, FrmAddDetailsHeader);
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
      end;
    end;
  finally
  end;
end;

procedure TFrmManageDetails.ProcEditDetailsHeader(Sender: TObject);
begin
  try
    try
      with FrmTopMenu.Defs do begin
        if (Assigned(AQu)) And (AQu.RecordCount > 0) then begin;
          with AQu do begin
            SetUID(FieldByName('USER_ID').AsInteger);
            SetHID(FieldByName('HEADER_ID').AsInteger);
            SetHeaderDT(FormatDateTime('yyyy/mm/dd hh:mm:ss', FieldByName('HEADER_DT').AsDateTime, GetFS));
            SetShopID(FieldByName('SHOP_ID').AsInteger);
            SetExpKey1(FieldByName('EXP_KEY1').AsInteger);
            SetFromACID(FieldByName('FROM_ID').AsInteger);
            SetToACID(FieldByName('TO_ID').AsInteger);
          end;

          CloseTransactions;
          SetDatabaseNames;

          FrmEditDetailsHeader := TFrmEditDetailsHeader.Create(Application);
          OpenForm(Self, FrmEditDetailsHeader);
        end else begin
          MessageDlg(MSG_JP_000030, mtInformation, [mbOk], 0);
        end;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
      end;
    end;
  finally
  end;
end;

procedure TFrmManageDetails.ProcDeleteDetailsHeader(Sender: TObject);
var
  LHeaderID : Integer;
  LResult   : TModalResult;
begin
  try
    try
      with FrmTopMenu.Defs do begin
        LHeaderID := AQu.FieldByName('HEADER_ID').AsInteger;
        with AQu do begin
          CloseTransactions;
          SetDatabaseNames;

          LResult:= QuestionDlg(
            REMOVE_DETAILS_HEADER_CAPTION, REMOVE_DETAILS_HEADER_MESSAGE,
            mtConfirmation, [mrYes, mrNo], 0);
          if LResult = mrYes then begin
            SQL.Text := SQL_20090002;
            with Params do begin
              ParamByName('pUserID').AsInteger   := GetUID;
              ParamByName('pHeaderID').AsInteger := LHeaderID;
            end;
            ExecSQL;

            SQL.Text := SQL_20090003;
            with Params do begin
              ParamByName('pUserID').AsInteger   := GetUID;
              ParamByName('pHeaderID').AsInteger := LHeaderID;
            end;

            ExecSQL;
            ATr.Commit;
          end else begin
            MessageDlg(
              CANCEL_OF_REMOVE_CAPTION, CANCEL_OF_REMOVE_MESSAGE,
              mtInformation, [mbOK], 0);
          end;
        end;
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
      end;
    end;
  finally
    with FrmTopMenu.Defs do begin
      CloseTransactions;
      SetDatabaseNames;

      OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20090001);
      if AQu.RecordCount = 0 then begin
        BtnEditDetailHeader.Enabled   := False;
        BtnDeleteDetailHeader.Enabled := False;
      end else begin
        BtnEditDetailHeader.Enabled   := True;
        BtnDeleteDetailHeader.Enabled := True;
      end;
    end;
    ADBG.AutoAdjustColumns;
  end;
end;

procedure TFrmManageDetails.AddDetailHeaderMouseOver(NewColor: TColor);
begin
  BtnAddDetailHeader.Color := NewColor;
end;

procedure TFrmManageDetails.BtnAddDetailHeaderEnter(Sender: TObject);
begin
  AddDetailHeaderMouseOver(clSkyBlue);
  EditDetailHeaderMouseOver(clBtnFace);
  DeleteDetailHeaderMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmManageDetails.BtnAddDetailHeaderExit(Sender: TObject);
begin
  AddDetailHeaderMouseOver(clBtnFace);
end;

procedure TFrmManageDetails.EditDetailHeaderMouseOver(NewColor: TColor);
begin
  BtnEditDetailHeader.Color := NewColor;
end;

procedure TFrmManageDetails.BtnEditDetailHeaderEnter(Sender: TObject);
begin
  AddDetailHeaderMouseOver(clBtnFace);
  EditDetailHeaderMouseOver(clSkyBlue);
  DeleteDetailHeaderMouseOver(clBtnFace);
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmManageDetails.BtnEditDetailHeaderExit(Sender: TObject);
begin
  EditDetailHeaderMouseOver(clBtnFace);
end;

procedure TFrmManageDetails.DeleteDetailHeaderMouseOver(NewColor: TColor);
begin
  BtnDeleteDetailHeader.Color := NewColor;
end;

procedure TFrmManageDetails.BtnDeleteDetailHeaderEnter(Sender: TObject);
begin
  AddDetailHeaderMouseOver(clBtnFace);
  EditDetailHeaderMouseOver(clBtnFace);
  DeleteDetailHeaderMouseOver(clSkyBlue);
  GoBackMouseOver(clBtnFace);
end;

procedure TFrmManageDetails.BtnDeleteDetailHeaderExit(Sender: TObject);
begin
  DeleteDetailHeaderMouseOver(clBtnFace);
end;

procedure TFrmManageDetails.GoBackMouseOver(NewColor: TColor);
begin
  BtnGoBack.Color := NewColor;
end;

procedure TFrmManageDetails.BtnGoBackEnter(Sender: TObject);
begin
  AddDetailHeaderMouseOver(clBtnFace);
  EditDetailHeaderMouseOver(clBtnFace);
  DeleteDetailHeaderMouseOver(clBtnFace);
  GoBackMouseOver(clSkyBlue);
end;

procedure TFrmManageDetails.BtnGoBackExit(Sender: TObject);
begin
  GoBackMouseOver(clBtnFace);
end;

function TFrmManageDetails.GetGoBack: Boolean;
begin
  Result := FGoBack;
end;

procedure TFrmManageDetails.SetGoBack(GoBack: Boolean);
begin
  FGoBack := GoBack;
end;

procedure TFrmManageDetails.ActAddDetailsHeaderExecute(Sender: TObject);
begin
  SetGoBack(False);
  ProcAddDetailsHeader(Sender);
end;

procedure TFrmManageDetails.ActEditDetailsHeaderExecute(Sender: TObject);
begin
  SetGoBack(False);
  ProcEditDetailsHeader(Sender);
end;

procedure TFrmManageDetails.ActDeleteDetailsHeaderExecute(Sender: TObject);
begin
  ProcDeleteDetailsHeader(Sender);
end;

procedure TFrmManageDetails.ActQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmManageDetails.FormClose(
  Sender: TObject; var CloseAction: TCloseAction);
begin
  with FrmTopMenu do begin
    CloseTransactions;

    if GetGoBack then begin
      Visible          := True;
    end;
    CloseAction                   := caFree;
    FrmManageDetails              := nil;
  end;
end;

procedure TFrmManageDetails.FormCreate(Sender: TObject);
begin
  SetDatabaseNames;
  with FrmTopMenu.Defs do begin
    if GetDoExitKakeiBon then begin
      Application.Terminate;
    end;
  end;

  SetGoBack(True);
end;

procedure TFrmManageDetails.FormShow(Sender: TObject);
begin
  FrmManageDetails.Color := RGB(112, 168, 175);
  PnlAddDetail.Color     := RGB( 72, 122, 129);
  PnlEditDetail.Color    := RGB( 72, 122, 129);
  PnlRemoveDetail.Color  := RGB( 72, 122, 129);
  PnlGoBack.Color        := RGB( 72, 122, 129);

  // Clear values of next screen
  with FrmTopMenu,Defs do begin
    SetHeaderDT('');

    SetShopID(0);
    SetExpKey1(0);
    SetFromACID(0);
    SetToACID(0);
    SetUnitID(0);
    SetTaxTypeID(0);

    SetQuantity(0);
    SetExcludeTax(0);
    SetTax(0);
    SetTotalAmount(0);
  end;

  try
    with FrmTopMenu.Defs do begin
      CloseTransactions;
      SetDatabaseNames;

      OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20090001);
      if AQu.RecordCount = 0 then begin
        BtnEditDetailHeader.Enabled   := False;
        BtnDeleteDetailHeader.Enabled := False;
      end else begin
        BtnEditDetailHeader.Enabled   := True;
        BtnDeleteDetailHeader.Enabled := True;
      end;
    end;
    ADBG.AutoAdjustColumns;
  finally
  end;
end;

end.

