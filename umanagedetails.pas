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
    ActRemoveDetailsHeader : TAction;
    ActQuit                : TAction;
    { Etc controls }
    ADBG                   : TDBGrid;
    ADBNav                 : TDBNavigator;
    BtnAddDetail           : TButton;
    BtnEditDetail          : TButton;
    BtnGoBack              : TButton;
    BtnRemoveDetail        : TButton;
    PnlAddDetail           : TPanel;
    PnlEditDetail          : TPanel;
    PnlGoBack              : TPanel;
    PnlRemoveDetail        : TPanel;
    ACn: TSQLite3Connection;
    procedure ActAddDetailsHeaderExecute(Sender: TObject);
    procedure ActEditDetailsHeaderExecute(Sender: TObject);
    procedure ActEntryAccountExecute(Sender: TObject);
    procedure ActEntryShopExecute(Sender: TObject);
    procedure ActQuitExecute(Sender: TObject);
    procedure ActRemoveDetailsHeaderExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    FGoBack : Boolean;
    procedure CloseTransactions;
    procedure ProcAddDetailsHeader;
    procedure ProcEditDetailsHeader;
    procedure ProcEntryAccount;
    procedure ProcEntryShop;
    procedure ProcRemoveDetailsHeader;
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

procedure TFrmManageDetails.CloseTransactions;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn      , ATr      );
  end;
end;

procedure TFrmManageDetails.ProcAddDetailsHeader;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn, ATr);
  end;

  try
    try
      FrmAddDetailsHeader := TFrmAddDetailsHeader.Create(Application);
      with FrmTopMenu.Defs do begin
        SetHeaderDT('');
        CloseConn(ACn, ATr);

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

procedure TFrmManageDetails.ProcEditDetailsHeader;
begin
  try
    try
      if (Assigned(AQu)) And (AQu.RecordCount > 0) then begin;
        with FrmTopMenu.Defs do begin
          SetUID(AQu.FieldByName('USER_ID').AsInteger);
          SetHID(AQu.FieldByName('HEADER_ID').AsInteger);
          SetHeaderDT(FormatDateTime('yyyy/mm/dd hh:mm:ss', AQu.FieldByName('HEADER_DT').AsDateTime, GetFS));
          SetShopID(AQu.FieldByName('SHOP_ID').AsInteger);
          SetExpKey1(AQu.FieldByName('EXP_KEY1').AsInteger);
          SetFromACID(AQu.FieldByName('FROM_ID').AsInteger);
          SetToACID(AQu.FieldByName('TO_ID').AsInteger);

          CloseConn(ACn, ATr);

          FrmEditDetailsHeader := TFrmEditDetailsHeader.Create(Application);
          OpenForm(Self, FrmEditDetailsHeader);
        end;
      end else begin
        MessageDlg(MSG_JP_000030, mtInformation, [mbOk], 0);
      end;
    except
      on E: ESQLDatabaseError do begin
        ShowMessage(E.Message);
      end;
    end;
  finally
  end;
end;

procedure TFrmManageDetails.ProcRemoveDetailsHeader;
var
  LHeaderID : Integer;
  LResult   : TModalResult;
begin
  try
    try
      with FrmTopMenu.Defs do begin
        LHeaderID := AQu.FieldByName('HEADER_ID').AsInteger;
        with AQu do begin
          CloseConn(ACn, ATr);

          LResult:= QuestionDlg(
            REMOVE_DETAILS_HEADER_CAPTION, REMOVE_DETAILS_HEADER_MESSAGE,
            mtConfirmation, [mrYes, mrNo], 0);
          if LResult = mrYes then begin
            SQL.Text := SQL_20090002;
            Params.ParamByName('pUserID').AsInteger   := GetUID;
            Params.ParamByName('pHeaderID').AsInteger := LHeaderID;
            ExecSQL;

            SQL.Text := SQL_20090003;
            Params.ParamByName('pUserID').AsInteger   := GetUID;
            Params.ParamByName('pHeaderID').AsInteger := LHeaderID;

            //CloseTransactions;
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
      OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20090001);
      if AQu.RecordCount = 0 then begin
        BtnEditDetail.Enabled   := False;
        BtnRemoveDetail.Enabled := False;
      end else begin
        BtnEditDetail.Enabled   := True;
        BtnRemoveDetail.Enabled := True;
      end;
    end;
    ADBG.AutoAdjustColumns;
  end;
end;

procedure TFrmManageDetails.ProcEntryAccount;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn, ATr);

    FrmEntryAccount := TFrmEntryAccount.Create(Application);
    OpenForm(Self, FrmEntryAccount);
  end;
end;

procedure TFrmManageDetails.ProcEntryShop;
begin
  with FrmTopMenu.Defs do begin
    CloseConn(ACn, ATr);

    FrmEntryShop := TFrmEntryShop.Create(Application);
    OpenForm(Self, FrmEntryShop);
  end;
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
  ProcAddDetailsHeader;
end;

procedure TFrmManageDetails.ActEditDetailsHeaderExecute(Sender: TObject);
begin
  SetGoBack(False);
  ProcEditDetailsHeader;
end;

procedure TFrmManageDetails.ActEntryAccountExecute(Sender: TObject);
begin
  SetGoBack(False);
  ProcEntryAccount;
end;

procedure TFrmManageDetails.ActEntryShopExecute(Sender: TObject);
begin
  SetGoBack(False);
  ProcEntryShop;
end;

procedure TFrmManageDetails.ActQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmManageDetails.ActRemoveDetailsHeaderExecute(Sender: TObject);
begin
  ProcRemoveDetailsHeader;
end;

procedure TFrmManageDetails.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseTransactions;

  if GetGoBack then begin
    FrmTopMenu.Visible          := True;
  end;
  CloseAction                   := caFree;
  FrmManageDetails              := nil;
end;

procedure TFrmManageDetails.FormShow(Sender: TObject);
begin
  SetGoBack(True);

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
      OpenSelectQuery(ACn, ADS, ATr, AQu, SQL_20090001);
      if AQu.RecordCount = 0 then begin
        BtnEditDetail.Enabled   := False;
        BtnRemoveDetail.Enabled := False;
      end else begin
        BtnEditDetail.Enabled   := True;
        BtnRemoveDetail.Enabled := True;
      end;
    end;
    ADBG.AutoAdjustColumns;
  finally
  end;
end;

end.

