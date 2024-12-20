unit dmConexao;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, uModelPessoa, uModelEndereco,
  uModelEnderecoIntegracao;

type
  TdtmConexao = class(TDataModule)
    FDConnection: TFDConnection;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    FDQuery: TFDQuery;
    FDPhysPgDriverLink: TFDPhysPgDriverLink;
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    function GetPessoa(idPessoa: integer): string;
    function GetEndereco(idEndereco: integer): string;
    function GetEnderecoIntegracao(idEndereco: integer): string;
  public
    function GetListaPessoas: string;
    function PostListaPessoas(ListaPessoas: TListaPessoas): string;
    function PostPessoa(DadosPessoa: TModelPessoa): string;
    function PutPessoa(idPessoa: integer; DadosPessoa: TModelPessoa): string;
    function DeletePessoa(idPessoa: integer): string;

    function GetListaEnderecos: string;
    function GetListaEnderecosPessoa(idpessoa: integer): string;
    function PostEndereco(DadosEndereco: TModelEndereco): string;
    function PutEndereco(idEndereco: integer; DadosEndereco: TModelEndereco): string;
    function DeleteEndereco(idEndereco: integer): string;

    function GetListaEnderecosIntegracao: string;
    function GetListaEnderecosIntegracaoId(idendereco: integer): string;
    function PostEnderecoIntegracao(idEndereco: integer; DadosEnderInt: TModelEnderecoIntegracao): string;
    function PutEnderecoIntegracao(idEndereco: integer; DadosEnderInt: TModelEnderecoIntegracao): string;
    function DeleteEnderecoIntegracao(idEndereco: integer): string;
  end;

var
  dtmConexao: TdtmConexao;

implementation

uses DataSet.Serialize;

{$R *.dfm}

{ TdtmConexao }

procedure TdtmConexao.DataModuleDestroy(Sender: TObject);
begin
  FDConnection.Close;
end;

function TdtmConexao.DeleteEndereco(idEndereco: integer): string;
begin
  Result := '';
  try
    Result := GetEndereco(idEndereco);

    FDQuery.Close;
    FDQuery.SQL.Text := ' DELETE FROM ENDERECO ' +
                        ' WHERE idendereco  = :idendereco ';
    FDQuery.ParamByName('idendereco').AsInteger := idEndereco;
    FDQuery.ExecSQL;

  except
    on E: Exception do
      raise Exception.Create(e.Message);
  end;
end;

function TdtmConexao.DeleteEnderecoIntegracao(idEndereco: integer): string;
begin
  Result := '';
  try
    Result := GetEnderecoIntegracao(idEndereco);

    FDQuery.Close;
    FDQuery.SQL.Text := ' DELETE FROM ENDERECO_INTEGRACAO ' +
                        ' WHERE idendereco  = :idendereco ';
    FDQuery.ParamByName('idendereco').AsInteger := idEndereco;
    FDQuery.ExecSQL;

  except
    on E: Exception do
      raise Exception.Create(e.Message);
  end;
end;

function TdtmConexao.DeletePessoa(idPessoa: integer): string;
begin
  Result := '';
  try
    Result := GetPessoa(idPessoa);

    FDQuery.Close;
    FDQuery.SQL.Text := ' DELETE FROM PESSOA ' +
                        ' WHERE idpessoa  = :idpessoa     ';
    FDQuery.ParamByName('idpessoa').AsInteger   := idPessoa;
    FDQuery.ExecSQL;

  except
    on E: Exception do
      raise Exception.Create(e.Message);
  end;
end;

function TdtmConexao.GetEndereco(idEndereco: integer): string;
begin
  try
    FDQuery.Close;
    FDQuery.SQL.Text := ' SELECT * FROM ENDERECO WHERE IDENDERECO = :IDENDERECO ';
    FDQuery.ParamByName('IDENDERECO').AsInteger := idEndereco;
    FDQuery.Open;

    Result := FDQuery.ToJSONObjectString;
  except
    on E: Exception do
      Result := e.Message;
  end;
end;

function TdtmConexao.GetEnderecoIntegracao(idEndereco: integer): string;
begin
  Result := '';
  try
    FDQuery.Close;
    FDQuery.SQL.Text := ' SELECT E.IDPESSOA, I.IDENDERECO, I.DSUF, I.NMCIDADE, ' +
                        '        I.NMBAIRRO, I.NMLOGRADOURO, I.DSCOMPLEMENTO ' +
                        ' FROM ENDERECO_INTEGRACAO I ' +
                        ' JOIN ENDERECO E ON E.IDENDERECO = I.IDENDERECO ' +
                        ' WHERE I.IDENDERECO = :IDENDERECO '+
                        ' ORDER BY E.IDPESSOA, I.IDENDERECO ';
    FDQuery.ParamByName('IDENDERECO').AsInteger := idEndereco;
    FDQuery.Open;

    if (not FDQuery.IsEmpty) then
      Result := FDQuery.ToJSONObjectString;
  except
    on E: Exception do
      Result := e.Message;
  end;
end;

function TdtmConexao.GetListaEnderecos: string;
begin
  try
    FDQuery.Close;
    FDQuery.SQL.Text := ' SELECT * FROM ENDERECO ORDER BY IDPESSOA, IDENDERECO ';
    FDQuery.Open;

    Result := FDQuery.ToJSONArrayString;
  except
    on E: Exception do
      Result := e.Message;
  end;
end;

function TdtmConexao.GetListaEnderecosIntegracao: string;
begin
  try
    FDQuery.Close;
    FDQuery.SQL.Text := ' SELECT E.IDPESSOA, I.IDENDERECO, I.DSUF, I.NMCIDADE, ' +
                        '        I.NMBAIRRO, I.NMLOGRADOURO, I.DSCOMPLEMENTO ' +
                        ' FROM ENDERECO_INTEGRACAO I ' +
                        ' JOIN ENDERECO E ON E.IDENDERECO = I.IDENDERECO ' +
                        ' ORDER BY E.IDPESSOA, I.IDENDERECO ';
    FDQuery.Open;

    Result := FDQuery.ToJSONArrayString;
  except
    on E: Exception do
      Result := e.Message;
  end;
end;

function TdtmConexao.GetListaEnderecosIntegracaoId(idendereco: integer): string;
begin
  try
    FDQuery.Close;
    FDQuery.SQL.Text := ' SELECT IDENDERECO, DSUF, NMCIDADE, ' +
                        '        NMBAIRRO, NMLOGRADOURO, DSCOMPLEMENTO ' +
                        ' FROM ENDERECO_INTEGRACAO ' +
                        ' WHERE IDENDERECO = :idendereco ';
    FDQuery.ParamByName('idendereco').AsInteger := idendereco;
    FDQuery.Open;

    Result := FDQuery.ToJSONObjectString;
  except
    on E: Exception do
      Result := e.Message;
  end;
end;

function TdtmConexao.GetListaEnderecosPessoa(idpessoa: integer): string;
begin
  try
    FDQuery.Close;
    FDQuery.SQL.Text := ' SELECT * FROM ENDERECO WHERE IDPESSOA = :idpessoa';
    FDQuery.ParamByName('idpessoa').AsInteger := idpessoa;
    FDQuery.Open;

    Result := FDQuery.ToJSONArrayString;
  except
    on E: Exception do
      Result := e.Message;
  end;
end;

function TdtmConexao.GetListaPessoas: string;
begin
  try
    FDQuery.Close;
    FDQuery.SQL.Text := ' SELECT * FROM PESSOA ORDER BY IDPESSOA ';
    FDQuery.Open;

    Result := FDQuery.ToJSONArrayString;
  except
    on E: Exception do
      Result := e.Message;
  end;
end;

function TdtmConexao.GetPessoa(idPessoa: integer): string;
begin
  Result := '';
  try
    FDQuery.Close;
    FDQuery.SQL.Text := ' SELECT * FROM PESSOA WHERE IDPESSOA = :IDPESSOA ';
    FDQuery.ParamByName('IDPESSOA').AsInteger := idPessoa;
    FDQuery.Open;

    if (not FDQuery.IsEmpty) then
      Result := FDQuery.ToJSONObjectString;
  except
    on E: Exception do
      Result := e.Message;
  end;
end;

function TdtmConexao.PostEndereco(DadosEndereco: TModelEndereco): string;
var
  iIdEndereco: integer;
begin
  Result := '';
  try
    if (GetPessoa(DadosEndereco.idpessoa) = '') then
      raise Exception.Create('C�digo da pessoa n�o existe.');

    FDQuery.Close;
    FDQuery.SQL.Text := ' INSERT INTO ENDERECO ' +
                        '   (idendereco, idpessoa, dscep) ' +
                        ' VALUES ' +
                        '   ((select coalesce(max(idendereco),0)+1 from endereco), :idpessoa, :dscep) ';
    FDQuery.ParamByName('idpessoa').AsInteger := DadosEndereco.idpessoa;
    FDQuery.ParamByName('dscep').AsString     := DadosEndereco.dscep;
    FDQuery.ExecSQL;


    FDQuery.Close;
    FDQuery.SQL.Text := ' SELECT MAX(IDENDERECO) AS IDENDERECO FROM ENDERECO ';
    FDQuery.Open;

    iIdEndereco := FDQuery.FieldByName('IDENDERECO').AsInteger;

    Result := GetEndereco(iIdEndereco);
  except
    on E: Exception do
      raise Exception.Create(e.Message);
  end;
end;

function TdtmConexao.PostEnderecoIntegracao(idEndereco: integer;
  DadosEnderInt: TModelEnderecoIntegracao): string;
begin
  Result := '';
  try
    if (GetEnderecoIntegracao(idendereco) <> '') then
      raise Exception.Create('Endere�o j� cadastrado.');

    FDQuery.Close;
    FDQuery.SQL.Text := ' INSERT INTO ENDERECO_INTEGRACAO ' +
                        '   (idendereco, dsuf, nmcidade, nmbairro, nmlogradouro, dscomplemento) ' +
                        ' VALUES ' +
                        '   (:idendereco, :dsuf, :nmcidade, :nmbairro, :nmlogradouro, :dscomplemento) ';
    FDQuery.ParamByName('idendereco').AsInteger   := idendereco;
    FDQuery.ParamByName('dsuf').AsString          := DadosEnderInt.dsuf;
    FDQuery.ParamByName('nmcidade').AsString      := DadosEnderInt.nmcidade;
    FDQuery.ParamByName('nmbairro').AsString      := DadosEnderInt.nmbairro;
    FDQuery.ParamByName('nmlogradouro').AsString  := DadosEnderInt.nmlogradouro;
    FDQuery.ParamByName('dscomplemento').AsString := DadosEnderInt.dscomplemento;
    FDQuery.ExecSQL;

    Result := GetEnderecoIntegracao(idEndereco);
  except
    on E: Exception do
      raise Exception.Create(e.Message);
  end;
end;

function TdtmConexao.PostListaPessoas(ListaPessoas: TListaPessoas): string;
var
  Pessoa: TModelPessoa;
begin
  Result := '';

  try
    for Pessoa in ListaPessoas.listaPessoas do
    begin
      FDQuery.Close;
      FDQuery.SQL.Text := ' INSERT INTO PESSOA ' +
                          '   (idpessoa, flnatureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro) ' +
                          ' VALUES ' +
                          '   ((select max(idpessoa)+1 from pessoa), :flnatureza, :dsdocumento, :nmprimeiro, :nmsegundo, :dtregistro) ';
      FDQuery.ParamByName('flnatureza').AsInteger := Pessoa.flnatureza;
      FDQuery.ParamByName('dsdocumento').AsString := Pessoa.dsdocumento;
      FDQuery.ParamByName('nmprimeiro').AsString  := Pessoa.nmprimeiro;
      FDQuery.ParamByName('nmsegundo').AsString   := Pessoa.nmsegundo;
      FDQuery.ParamByName('dtregistro').AsDate    := Pessoa.dtregistro;
      FDQuery.ExecSQL;
    end;

    Result := GetListaPessoas;
  except
    on E: Exception do
      raise Exception.Create(e.Message);
  end;
end;

function TdtmConexao.PostPessoa(DadosPessoa: TModelPessoa): string;
var
  iIdPessoa: integer;
begin
  Result := '';
  try
    FDQuery.Close;
    FDQuery.SQL.Text := ' INSERT INTO PESSOA ' +
                        '   (idpessoa, flnatureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro) ' +
                        ' VALUES ' +
                        '   ((select max(idpessoa)+1 from pessoa), :flnatureza, :dsdocumento, :nmprimeiro, :nmsegundo, :dtregistro) ';
    FDQuery.ParamByName('flnatureza').AsInteger := DadosPessoa.flnatureza;
    FDQuery.ParamByName('dsdocumento').AsString := DadosPessoa.dsdocumento;
    FDQuery.ParamByName('nmprimeiro').AsString  := DadosPessoa.nmprimeiro;
    FDQuery.ParamByName('nmsegundo').AsString   := DadosPessoa.nmsegundo;
    FDQuery.ParamByName('dtregistro').AsDate    := DadosPessoa.dtregistro;
    FDQuery.ExecSQL;


    FDQuery.Close;
    FDQuery.SQL.Text := ' SELECT MAX(IDPESSOA) AS IDPESSOA FROM PESSOA ';
    FDQuery.Open;

    iIdPessoa := FDQuery.FieldByName('IDPESSOA').AsInteger;

    Result := GetPessoa(iIdPessoa);

  except
    on E: Exception do
      raise Exception.Create(e.Message);
  end;
end;

function TdtmConexao.PutEndereco(idEndereco: integer;
  DadosEndereco: TModelEndereco): string;
begin
  Result := '';
  try
    FDQuery.Close;
    FDQuery.SQL.Text := ' UPDATE ENDERECO ' +
                        ' SET idpessoa     = :idpessoa,  ' +
                        '     dscep        = :dscep      ' +
                        ' WHERE idendereco = :idendereco ';
    FDQuery.ParamByName('idendereco').AsInteger := idEndereco;
    FDQuery.ParamByName('idpessoa').AsInteger   := DadosEndereco.idpessoa;
    FDQuery.ParamByName('dscep').AsString       := DadosEndereco.dscep;
    FDQuery.ExecSQL;

    Result := GetEndereco(idEndereco);

  except
    on E: Exception do
      raise Exception.Create(e.Message);
  end;
end;

function TdtmConexao.PutPessoa(idPessoa: integer;
  DadosPessoa: TModelPessoa): string;
begin
  Result := '';
  try
    FDQuery.Close;
    FDQuery.SQL.Text := ' UPDATE PESSOA ' +
                        ' SET flnatureza  = :flnatureza,  ' +
                        '     dsdocumento = :dsdocumento, ' +
                        '     nmprimeiro  = :nmprimeiro,  ' +
                        '     nmsegundo   = :nmsegundo,   ' +
                        '     dtregistro  = :dtregistro   ' +
                        ' WHERE idpessoa  = :idpessoa     ';
    FDQuery.ParamByName('idpessoa').AsInteger   := idPessoa;
    FDQuery.ParamByName('flnatureza').AsInteger := DadosPessoa.flnatureza;
    FDQuery.ParamByName('dsdocumento').AsString := DadosPessoa.dsdocumento;
    FDQuery.ParamByName('nmprimeiro').AsString  := DadosPessoa.nmprimeiro;
    FDQuery.ParamByName('nmsegundo').AsString   := DadosPessoa.nmsegundo;
    FDQuery.ParamByName('dtregistro').AsDate    := DadosPessoa.dtregistro;
    FDQuery.ExecSQL;

    Result := GetPessoa(idPessoa);

  except
    on E: Exception do
      raise Exception.Create(e.Message);
  end;
end;

function TdtmConexao.PutEnderecoIntegracao(idEndereco: integer;
  DadosEnderInt: TModelEnderecoIntegracao): string;
begin
  Result := '';
  try
    if (GetEnderecoIntegracao(idendereco) = '') then
      raise Exception.Create('Endere�o n�o existe.');

    FDQuery.Close;
    FDQuery.SQL.Text := ' UPDATE ENDERECO_INTEGRACAO ' +
                        ' SET dsuf          = :dsuf,         ' +
                        '     nmcidade      = :nmcidade,     ' +
                        '     nmbairro      = :nmbairro,     ' +
                        '     nmlogradouro  = :nmlogradouro, ' +
                        '     dscomplemento = :dscomplemento ' +
                        ' WHERE idendereco  = :idendereco    ';
    FDQuery.ParamByName('idendereco').AsInteger   := idendereco;
    FDQuery.ParamByName('dsuf').AsString          := DadosEnderInt.dsuf;
    FDQuery.ParamByName('nmcidade').AsString      := DadosEnderInt.nmcidade;
    FDQuery.ParamByName('nmbairro').AsString      := DadosEnderInt.nmbairro;
    FDQuery.ParamByName('nmlogradouro').AsString  := DadosEnderInt.nmlogradouro;
    FDQuery.ParamByName('dscomplemento').AsString := DadosEnderInt.dscomplemento;
    FDQuery.ExecSQL;

    Result := GetEnderecoIntegracao(idEndereco);
  except
    on E: Exception do
      raise Exception.Create(e.Message);
  end;
end;

end.
