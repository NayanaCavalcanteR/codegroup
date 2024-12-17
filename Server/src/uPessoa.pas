unit uPessoa;

interface

uses uModelPessoa;

type
  TPessoa = class
  public
    function GetListaPessoas: string;
    function PostListaPessoas(ListaPessoas: TListaPessoas): string;
    function PostPessoa(DadosPessoa: TModelPessoa): string;
    function PutPessoa(idPessoa: integer; DadosPessoa: TModelPessoa): string;
    function DeletePessoa(idPessoa: integer): string;
  end;

implementation

{ TPessoa }

uses dmConexao;

function TPessoa.DeletePessoa(idPessoa: integer): string;
begin
  Result := dtmConexao.DeletePessoa(idPessoa);
end;

function TPessoa.GetListaPessoas: string;
begin
  Result := dtmConexao.GetListaPessoas;
end;

function TPessoa.PostListaPessoas(ListaPessoas: TListaPessoas): string;
begin
  Result := dtmConexao.PostListaPessoas(ListaPessoas);
end;

function TPessoa.PostPessoa(DadosPessoa: TModelPessoa): string;
begin
  Result := dtmConexao.PostPessoa(DadosPessoa);
end;

function TPessoa.PutPessoa(idPessoa: integer;
  DadosPessoa: TModelPessoa): string;
begin
  Result := dtmConexao.PutPessoa(idPessoa, DadosPessoa);
end;

end.
