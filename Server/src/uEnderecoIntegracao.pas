unit uEnderecoIntegracao;

interface

uses uModelEnderecoIntegracao;

type
  TEnderecoIntegracao = class
  public
    function GetListaEnderecosIntegracao: string;
    function GetListaEnderecosIntegracaoId(idendereco: integer): string;
    function PostEnderecoIntegracao(idEndereco: integer; DadosEnderInt: TModelEnderecoIntegracao): string;
    function PutEnderecoIntegracao(idEndereco: integer; DadosEnderInt: TModelEnderecoIntegracao): string;
    function DeleteEnderecoIntegracao(idEndereco: integer): string;
  end;


implementation

{ TEnderecoIntegracao }

uses dmConexao;

function TEnderecoIntegracao.DeleteEnderecoIntegracao(
  idEndereco: integer): string;
begin
  Result := dtmConexao.DeleteEnderecoIntegracao(idEndereco);
end;

function TEnderecoIntegracao.GetListaEnderecosIntegracao: string;
begin
  Result := dtmConexao.GetListaEnderecosIntegracao;
end;

function TEnderecoIntegracao.GetListaEnderecosIntegracaoId(
  idendereco: integer): string;
begin
  Result := dtmConexao.GetListaEnderecosIntegracaoId(idendereco);
end;

function TEnderecoIntegracao.PostEnderecoIntegracao(idEndereco: integer;
  DadosEnderInt: TModelEnderecoIntegracao): string;
begin
  Result := dtmConexao.PostEnderecoIntegracao(idEndereco, DadosEnderInt);
end;

function TEnderecoIntegracao.PutEnderecoIntegracao(idEndereco: integer;
  DadosEnderInt: TModelEnderecoIntegracao): string;
begin
  Result := dtmConexao.PutEnderecoIntegracao(idEndereco, DadosEnderInt);
end;

end.
