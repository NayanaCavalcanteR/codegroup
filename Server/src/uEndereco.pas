unit uEndereco;

interface

uses uModelEndereco;

type
  TEndereco = class
  public
    function GetListaEnderecos: string;
    function GetListaEnderecosPessoa(idpessoa: integer): string;
    function PostEndereco(DadosEndereco: TModelEndereco): string;
    function PutEndereco(idEndereco: integer; DadosEndereco: TModelEndereco): string;
    function DeleteEndereco(idEndereco: integer): string;
  end;

implementation

{ TEndereco }

uses dmConexao;

function TEndereco.DeleteEndereco(idEndereco: integer): string;
begin
  Result := dtmConexao.DeleteEndereco(idEndereco);
end;

function TEndereco.GetListaEnderecos: string;
begin
  Result := dtmConexao.GetListaEnderecos;
end;

function TEndereco.GetListaEnderecosPessoa(idpessoa: integer): string;
begin
  Result := dtmConexao.GetListaEnderecosPessoa(idpessoa);
end;

function TEndereco.PostEndereco(DadosEndereco: TModelEndereco): string;
begin
  Result := dtmConexao.PostEndereco(DadosEndereco);
end;

function TEndereco.PutEndereco(idEndereco: integer;
  DadosEndereco: TModelEndereco): string;
begin
  Result := dtmConexao.PutEndereco(idEndereco, DadosEndereco);
end;

end.
