unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, System.ImageList, Vcl.ImgList,
  Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.Mask, Vcl.ExtCtrls,
  Vcl.Buttons, Vcl.ComCtrls, Datasnap.DBClient, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.JSON, Rest.Json;

type
  TAcao = (acInserir, acAlterar, acExcluir);

  TThreadCep = class(TThread)
  protected
    Endereco, Cep: string;
    StAcao: TAcao;
    procedure Execute; override;
    procedure Sincronizar;
  private
    procedure PostEnderecoIntegracao(idEndereco, numCep: string);
    procedure PutEnderecoIntegracao(idEndereco, numCep: string);
    procedure DeleteEnderecoIntegracao(idEndereco: string);
  public
    constructor Create(idEndereco, numCep: string; acao: TAcao); overload;
    destructor Destroy; override;
  end;

  TfrmPrincipal = class(TForm)
    pgDados: TPageControl;
    tsConsulta: TTabSheet;
    tsAlteracao: TTabSheet;
    pnlNavegacao: TPanel;
    btInicio: TSpeedButton;
    btAnterior: TSpeedButton;
    btNovo: TSpeedButton;
    btEditar: TSpeedButton;
    btExcluir: TSpeedButton;
    btCancelar: TSpeedButton;
    btProximo: TSpeedButton;
    btFinal: TSpeedButton;
    btSalvar: TSpeedButton;
    pnlPessoa: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label8: TLabel;
    edPrimeiroNome: TDBEdit;
    edSegundoNome: TDBEdit;
    edNumDocumento: TDBEdit;
    pnlItensPedido: TPanel;
    griditens: TDBGrid;
    pnlProduto: TPanel;
    pnlNavDetalhes: TPanel;
    btAnteriorItem: TSpeedButton;
    btNovoItem: TSpeedButton;
    btEditarItem: TSpeedButton;
    btExcluirItem: TSpeedButton;
    btCancelarItem: TSpeedButton;
    btProximoItem: TSpeedButton;
    btSalvarItem: TSpeedButton;
    pnlCep: TPanel;
    Label5: TLabel;
    edCEP: TDBEdit;
    ImageList: TImageList;
    DBGrid1: TDBGrid;
    dsDados: TDataSource;
    mtDados: TFDMemTable;
    edDtRegistro: TDateTimePicker;
    Label3: TLabel;
    rgNatureza: TRadioGroup;
    mtItens: TFDMemTable;
    dsItens: TDataSource;
    mtItensidendereco: TIntegerField;
    mtItensidpessoa: TIntegerField;
    mtItensdscep: TStringField;
    procedure FormShow(Sender: TObject);
    procedure btNovoClick(Sender: TObject);
    procedure btEditarClick(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure btExcluirClick(Sender: TObject);
    procedure btCancelarClick(Sender: TObject);
    procedure btInicioClick(Sender: TObject);
    procedure btAnteriorClick(Sender: TObject);
    procedure btProximoClick(Sender: TObject);
    procedure btFinalClick(Sender: TObject);
    procedure mtDadosBeforePost(DataSet: TDataSet);
    procedure dsDadosDataChange(Sender: TObject; Field: TField);
    procedure btAnteriorItemClick(Sender: TObject);
    procedure btProximoItemClick(Sender: TObject);
    procedure btNovoItemClick(Sender: TObject);
    procedure btEditarItemClick(Sender: TObject);
    procedure btSalvarItemClick(Sender: TObject);
    procedure btExcluirItemClick(Sender: TObject);
    procedure btCancelarItemClick(Sender: TObject);
    procedure mtItensBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
    FThreadCep: TThreadCep;
    procedure SetaDados;
    procedure GetDados;
    procedure ListarPessoas;
    procedure ListarEnderecos(idPessoa: integer);
    procedure PostPessoa;
    procedure PostEndereco;
    procedure PutPessoa;
    procedure PutEndereco;
    procedure DeletePessoa(idPessoa: integer);
    procedure DeleteEndereco(idEndereco: string);
    procedure StatusTela;
    function  ValidaPessoa: boolean;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses RestRequest4D, DataSet.Serialize, DataSet.Serialize.Adapter.RESTRequest4D;


{$R *.dfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.btAnteriorClick(Sender: TObject);
begin
  mtDados.Prior;
  ListarEnderecos(mtDados.FieldByName('idpessoa').AsInteger);
  StatusTela;
end;

procedure TfrmPrincipal.btAnteriorItemClick(Sender: TObject);
begin
  mtItens.Prior;
  StatusTela;
end;

procedure TfrmPrincipal.btCancelarClick(Sender: TObject);
begin
  if (not mtDados.Active) then
    Exit;

  mtDados.Cancel;
  ListarEnderecos(mtDados.FieldByName('idpessoa').AsInteger);
  StatusTela;
end;

procedure TfrmPrincipal.btCancelarItemClick(Sender: TObject);
begin
  if (not mtItens.Active) then
    Exit;

  mtItens.Cancel;
  StatusTela;
end;

procedure TfrmPrincipal.btEditarClick(Sender: TObject);
begin
  if (not mtDados.Active) then
    Exit;

  mtDados.Edit;
  StatusTela;

  if (edPrimeiroNome.CanFocus) then
    edPrimeiroNome.SetFocus;
end;

procedure TfrmPrincipal.btEditarItemClick(Sender: TObject);
begin
  if (not mtItens.Active) then
    Exit;

  mtItens.Edit;
  StatusTela;

  if (edCEP.CanFocus) then
    edCEP.SetFocus;
end;

procedure TfrmPrincipal.btExcluirClick(Sender: TObject);
var
  idPessoa: integer;
begin
  if (not mtDados.Active) then
    Exit;

  if (MessageDlg('Deseja excluir o registro?', TMsgDlgType.mtConfirmation, mbYesNo, 0) = mrYes) then
  begin
    idPessoa := mtDados.FieldByName('idpessoa').AsInteger;
    mtDados.Delete;
    DeletePessoa(idPessoa);
    ListarPessoas;
    ListarEnderecos(mtDados.FieldByName('idpessoa').AsInteger);
    StatusTela;
  end;
end;

procedure TfrmPrincipal.btExcluirItemClick(Sender: TObject);
var
  idEndereco: string;
begin
  if (not mtItens.Active) then
    Exit;

  if (MessageDlg('Deseja excluir o registro?', TMsgDlgType.mtConfirmation, mbYesNo, 0) = mrYes) then
  begin
    idEndereco := mtItens.FieldByName('idendereco').AsString;
    mtItens.Delete;
    DeleteEndereco(idEndereco);
    FThreadCep := TThreadCep.Create(idEndereco, mtItens.FieldByName('dsCep').AsString, acExcluir);
    FThreadCep.Start;
    StatusTela;
  end;
end;

procedure TfrmPrincipal.btFinalClick(Sender: TObject);
begin
  mtDados.Last;
  ListarEnderecos(mtDados.FieldByName('idpessoa').AsInteger);
  StatusTela;
end;

procedure TfrmPrincipal.btInicioClick(Sender: TObject);
begin
  mtDados.First;
  ListarEnderecos(mtDados.FieldByName('idpessoa').AsInteger);
  StatusTela;
end;

procedure TfrmPrincipal.btNovoClick(Sender: TObject);
begin
  if (not mtDados.Active) then
    Exit;

  mtDados.Append;
  rgNatureza.ItemIndex := 0;
  StatusTela;

  if (edPrimeiroNome.CanFocus) then
    edPrimeiroNome.SetFocus;
end;

procedure TfrmPrincipal.btNovoItemClick(Sender: TObject);
begin
  if (not mtItens.Active) then
    Exit;

  mtItens.Append;
  StatusTela;

  if (edCEP.CanFocus) then
    edCEP.SetFocus;
end;

procedure TfrmPrincipal.btProximoClick(Sender: TObject);
begin
  mtDados.Next;
  ListarEnderecos(mtDados.FieldByName('idpessoa').AsInteger);
  StatusTela;
end;

procedure TfrmPrincipal.btProximoItemClick(Sender: TObject);
begin
  mtItens.Next;
  StatusTela;
end;

procedure TfrmPrincipal.btSalvarClick(Sender: TObject);
var
  iStatus: TDataSetState;
begin
  if (not ValidaPessoa) then
    Exit;

  if (mtDados.State in [dsInsert, dsEdit]) then
  begin
    iStatus := mtDados.State;
    mtDados.Post;

    if (iStatus = dsInsert) then
    begin
      PostPessoa;
      ListarPessoas;
    end
    else if (iStatus = dsEdit) then
      PutPessoa;
  end;

  ListarEnderecos(mtDados.FieldByName('idpessoa').AsInteger);
  StatusTela;
end;

procedure TfrmPrincipal.btSalvarItemClick(Sender: TObject);
var
  iStatus: TDataSetState;
begin
  if (Length(edCEP.Text) <> 8) then
  begin
    MessageDlg('CEP inv�lido', TMsgDlgType.mtWarning, [mbOK], 0);
    Exit;
  end;

  if (mtItens.State in [dsInsert, dsEdit]) then
  begin
    iStatus := mtItens.State;
    mtItens.Post;

    if (iStatus = dsInsert) then
      PostEndereco
    else if (iStatus = dsEdit) then
      PutEndereco;
  end;

  StatusTela;
end;

procedure TfrmPrincipal.DeleteEndereco(idEndereco: string);
begin
  var LResponse := TRequest.New
                           .BaseURL('http://localhost:8080')
                           .Resource('endereco/:idendereco')
                           .AddParam('idendereco', idEndereco, pkURLSEGMENT)
                           .Delete;

  if (LResponse.StatusCode <> 200) then
    raise Exception.Create('Erro ao excluir o endere�o.');
end;

procedure TfrmPrincipal.DeletePessoa(idPessoa: integer);
begin
  var LResponse := TRequest.New
                           .BaseURL('http://localhost:8080')
                           .Resource('pessoa/:idpessoa')
                           .AddParam('idpessoa', IntToStr(idPessoa), pkURLSEGMENT)
                           .Delete;

  if (LResponse.StatusCode <> 200) then
    raise Exception.Create('Erro ao excluir o registro de pessoa.');
end;

procedure TfrmPrincipal.dsDadosDataChange(Sender: TObject; Field: TField);
begin
  GetDados;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  pgDados.ActivePage := tsConsulta;
  ListarPessoas;
  GetDados;
  ListarEnderecos(mtDados.FieldByName('idpessoa').AsInteger);
  StatusTela;
end;

procedure TfrmPrincipal.GetDados;
var
  dtRegistro: string;
begin
  dtRegistro := '';

  if (mtDados.FieldByName('dtregistro').AsString <> '') then
    dtRegistro := Copy(mtDados.FieldByName('dtregistro').AsString,9,2) + '/' +
                  Copy(mtDados.FieldByName('dtregistro').AsString,6,2) + '/' +
                  Copy(mtDados.FieldByName('dtregistro').AsString,1,4);

  edDtRegistro.Date := StrToDateDef(dtRegistro, Date);
  if (mtDados.FieldByName('flnatureza').AsInteger = 1) then
    rgNatureza.ItemIndex := 0
  else
    rgNatureza.ItemIndex := 1;
end;

procedure TfrmPrincipal.ListarEnderecos(idPessoa: integer);
begin
  var LResponse := TRequest.New
                           .BaseURL('http://localhost:8080')
                           .Resource('endereco/:idpessoa')
                           .AddParam('idpessoa', IntToStr(idPessoa), pkURLSEGMENT)
                           .Adapters(TDataSetSerializeAdapter.New(mtItens))
                           .Accept('application/json')
                           .Get;

  if (LResponse.StatusCode <> 200) then
    raise Exception.Create('Erro ao listar os endere�os.');

  dsItens.DataSet.Open;
  dsItens.DataSet.First;
end;

procedure TfrmPrincipal.ListarPessoas;
begin
  var LResponse := TRequest.New
                           .BaseURL('http://localhost:8080')
                           .Resource('pessoa')
                           .Adapters(TDataSetSerializeAdapter.New(mtDados))
                           .Accept('application/json')
                           .Get;

  if (LResponse.StatusCode <> 200) then
    raise Exception.Create('Erro ao listar as pessoas.');

  dsDados.DataSet.Open;
  dsDados.DataSet.First;
end;

procedure TfrmPrincipal.mtDadosBeforePost(DataSet: TDataSet);
begin
  SetaDados;
end;

procedure TfrmPrincipal.mtItensBeforePost(DataSet: TDataSet);
begin
  if Dataset.State = dsInsert then
    mtItens.FieldByName('idpessoa').AsInteger := mtDados.FieldByName('idpessoa').AsInteger;
end;

procedure TfrmPrincipal.PostEndereco;
var
  idEndereco: string;
begin
  var LJson := TJSONObject.Create
                          .AddPair('idpessoa', mtDados.FieldByName('idpessoa').AsInteger)
                          .AddPair('dscep', mtItens.FieldByName('dsCep').AsString);

  var LResponse := TRequest.New
                           .BaseURL('http://localhost:8080')
                           .Resource('endereco')
                           .ContentType('application/json')
                           .AddBody(LJson)
                           .Post;

  if (LResponse.StatusCode <> 201) then
    raise Exception.Create('Erro ao inserir o endere�o.');

  var LJsonV := TJSONObject.ParseJSONValue(LResponse.Content);
  idEndereco := LJsonV.GetValue<string>('idendereco');

  FThreadCep := TThreadCep.Create(idEndereco, mtItens.FieldByName('dsCep').AsString, acInserir);
  FThreadCep.Start;
end;

procedure TfrmPrincipal.PostPessoa;
begin
  var LJson := TJSONObject.Create
                          .AddPair('flnatureza',  mtDados.FieldByName('flnatureza').AsInteger)
                          .AddPair('dsdocumento', mtDados.FieldByName('dsdocumento').AsString)
                          .AddPair('nmprimeiro',  mtDados.FieldByName('nmprimeiro').AsString)
                          .AddPair('nmsegundo',   mtDados.FieldByName('nmsegundo').AsString)
                          .AddPair('dtregistro',  mtDados.FieldByName('dtregistro').AsString);

  var LResponse := TRequest.New
                           .BaseURL('http://localhost:8080')
                           .Resource('pessoa')
                           .ContentType('application/json')
                           .AddBody(LJson)
                           .Post;

  if (LResponse.StatusCode <> 201) then
    raise Exception.Create('Erro ao inserir o registro de pessoa.');
end;

procedure TfrmPrincipal.PutEndereco;
var
  idEndereco: string;
begin
  idEndereco := mtItens.FieldByName('idendereco').AsString;

  var LJson := TJSONObject.Create
                          .AddPair('idpessoa', mtItens.FieldByName('idpessoa').AsInteger)
                          .AddPair('dscep', mtItens.FieldByName('dscep').AsString);

  var LResponse := TRequest.New
                           .BaseURL('http://localhost:8080')
                           .Resource('endereco/:idendereco')
                           .AddParam('idendereco', idEndereco, pkURLSEGMENT)
                           .ContentType('application/json')
                           .AddBody(LJson)
                           .Put;

  if (LResponse.StatusCode <> 200) then
    raise Exception.Create('Erro ao atualizar o endere�o.');

  FThreadCep := TThreadCep.Create(idEndereco, mtItens.FieldByName('dsCep').AsString, acAlterar);
  FThreadCep.Start;
end;

procedure TfrmPrincipal.PutPessoa;
var
  idPessoa: integer;
begin
  idPessoa  := mtDados.FieldByName('idpessoa').AsInteger;

  var LJson := TJSONObject.Create
                          .AddPair('flnatureza',  mtDados.FieldByName('flnatureza').AsInteger)
                          .AddPair('dsdocumento', mtDados.FieldByName('dsdocumento').AsString)
                          .AddPair('nmprimeiro',  mtDados.FieldByName('nmprimeiro').AsString)
                          .AddPair('nmsegundo',   mtDados.FieldByName('nmsegundo').AsString)
                          .AddPair('dtregistro',  mtDados.FieldByName('dtregistro').AsString);

  var LResponse := TRequest.New
                           .BaseURL('http://localhost:8080')
                           .Resource('pessoa/:idpessoa')
                           .AddParam('idpessoa', IntToStr(idPessoa), pkURLSEGMENT)
                           .ContentType('application/json')
                           .AddBody(LJson)
                           .Put;

  if (LResponse.StatusCode <> 200) then
    raise Exception.Create('Erro ao atualizar o registro de pessoa.');

end;

procedure TfrmPrincipal.SetaDados;
begin
  dsDados.OnDataChange := nil;
  try
    if not (mtDados.State in [dsInsert, dsEdit]) then
      Exit;

    mtDados.FieldByName('dtregistro').AsString  := FormatDateTime('yyyy-mm-dd', edDtRegistro.Date);
    mtDados.FieldByName('flnatureza').AsInteger := (rgNatureza.ItemIndex + 1);
  finally
    dsDados.OnDataChange := dsDadosDataChange;
  end;
end;

procedure TfrmPrincipal.StatusTela;
begin
  pnlPessoa.Enabled       := (mtDados.State in [dsInsert, dsEdit]);
  pnlnavDetalhes.Enabled  := (mtDados.State = dsEdit) and (not mtDados.isEmpty);
  pnlCep.Enabled          := (mtItens.State in [dsInsert, dsEdit]);
  gridItens.Enabled       := (mtItens.State = dsEdit);

  btInicio.Enabled   := (not mtDados.IsEmpty) and (mtDados.State = dsBrowse) and (not mtDados.Bof);
  btAnterior.Enabled := (not mtDados.IsEmpty) and (mtDados.State = dsBrowse) and (not mtDados.Bof);
  btProximo.Enabled  := (not mtDados.IsEmpty) and (mtDados.State = dsBrowse) and (not mtDados.Eof);
  btFinal.Enabled    := (not mtDados.IsEmpty) and (mtDados.State = dsBrowse) and (not mtDados.Eof);

  btNovo.Enabled     := (mtDados.State = dsBrowse);
  btEditar.Enabled   := (mtDados.State = dsBrowse) and (not mtDados.IsEmpty);
  btExcluir.Enabled  := (mtDados.State = dsBrowse) and (not mtDados.IsEmpty);
  btSalvar.Enabled   := (mtDados.State in [dsInsert, dsEdit]);
  btCancelar.Enabled := (mtDados.State in [dsInsert, dsEdit]);

  btAnteriorItem.Enabled := (not mtItens.IsEmpty) and (mtItens.State = dsBrowse) and (not mtItens.Bof);
  btProximoItem.Enabled  := (not mtItens.IsEmpty) and (mtItens.State = dsBrowse) and (not mtItens.Eof);

  btNovoItem.Enabled     := (mtItens.State = dsBrowse);
  btEditarItem.Enabled   := (mtItens.State = dsBrowse) and (not mtItens.IsEmpty);
  btExcluirItem.Enabled  := (mtItens.State = dsBrowse) and (not mtItens.IsEmpty);
  btSalvarItem.Enabled   := (mtItens.State in [dsInsert, dsEdit]);
  btCancelarItem.Enabled := (mtItens.State in [dsInsert, dsEdit]);

end;

function TfrmPrincipal.ValidaPessoa: boolean;
begin
  Result := True;

  if (Trim(edPrimeiroNome.Text) = '') then
  begin
    MessageDlg('Nome inv�lido', TMsgDlgType.mtWarning, [mbOK], 0);
    Result := False;
    Exit;
  end;

  if (Trim(edSegundoNome.Text) = '') then
  begin
    MessageDlg('Sobrenome inv�lido', TMsgDlgType.mtWarning, [mbOK], 0);
    Result := False;
    Exit;
  end;

  if (Trim(edNumDocumento.Text) = '') then
  begin
    MessageDlg('N� do documento inv�lido', TMsgDlgType.mtWarning, [mbOK], 0);
    Result := False;
    Exit;
  end;

  if (edDtRegistro.Date <= 0) then
  begin
    MessageDlg('Data Registro inv�lido', TMsgDlgType.mtWarning, [mbOK], 0);
    Result := False;
    Exit;
  end;
end;

{ TThreadCep }

constructor TThreadCep.Create(idEndereco, numCep: string; acao: TAcao);
begin
  inherited Create(True);
  Endereco := idEndereco;
  Cep      := numCep;
  StAcao   := acao;
  FreeOnTerminate := True;
end;

procedure TThreadCep.DeleteEnderecoIntegracao(idEndereco: string);
begin
  var LResponse := TRequest.New
                           .BaseURL('http://localhost:8080')
                           .Resource('integracao/endereco/:idendereco')
                           .AddParam('idendereco', idEndereco, pkURLSEGMENT)
                           .Delete;

  if (LResponse.StatusCode <> 200) then
    raise Exception.Create('Erro ao excluir o endere�o.');
end;

destructor TThreadCep.Destroy;
begin
  WaitFor;
  Free;
  inherited;
end;

procedure TThreadCep.Execute;
var
  i: integer;
begin
  inherited;
  Queue(Sincronizar);
  Terminate;
end;

procedure TThreadCep.PostEnderecoIntegracao(idEndereco, numCep: string);
begin
  var LResponseCep := TRequest.New
                              .BaseURL('http://viacep.com.br/ws/:cep/json/')
                              .AddParam('cep', numCep, pkURLSEGMENT)
                              .Get;

  if (LResponseCep.StatusCode <> 200) then
    raise Exception.Create('Erro ao buscar os dados do CEP.');

  var LJson := TJSONObject.ParseJSONValue(LResponseCep.Content) as TJSONValue;

  var LResponse := TRequest.New
                           .BaseURL('http://localhost:8080')
                           .Resource('integracao/endereco/:idendereco')
                           .ContentType('application/json')
                           .AddParam('idendereco', idendereco, pkURLSEGMENT)
                           .AddBody(TJson.Format(LJson))
                           .Post;

  if (LResponse.StatusCode <> 201) then
    raise Exception.Create('Erro ao inserir o endere�o.');
end;

procedure TThreadCep.PutEnderecoIntegracao(idEndereco, numCep: string);
begin
  var LResponseCep := TRequest.New
                              .BaseURL('http://viacep.com.br/ws/:cep/json/')
                              .AddParam('cep', numCep, pkURLSEGMENT)
                              .Get;

  if (LResponseCep.StatusCode <> 200) then
    raise Exception.Create('Erro ao buscar os dados do CEP.');

  var LJson := TJSONObject.ParseJSONValue(LResponseCep.Content) as TJSONValue;

  var LResponse := TRequest.New
                           .BaseURL('http://localhost:8080')
                           .Resource('integracao/endereco/:idendereco')
                           .ContentType('application/json')
                           .AddParam('idendereco', idEndereco, pkURLSEGMENT)
                           .AddBody(TJson.Format(LJson))
                           .Put;

  if (LResponse.StatusCode <> 200) then
    raise Exception.Create('Erro ao atualizar o endere�o.');
end;

procedure TThreadCep.Sincronizar;
begin
  if (StAcao = acInserir) then
    PostEnderecoIntegracao(Endereco, Cep)
  else if (StAcao = acAlterar) then
    PutEnderecoIntegracao(Endereco, Cep)
  else if (StAcao = acExcluir) then
    DeleteEnderecoIntegracao(Endereco);
end;

end.
