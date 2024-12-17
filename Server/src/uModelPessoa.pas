unit uModelPessoa;

interface

uses System.Generics.Collections, System.SysUtils;

type
  TModelPessoa = class
  private
    FNmprimeiro : string;
    FDtregistro : TDateTime;
    FNmsegundo  : string;
    FDsdocumento: string;
    FIdPessoa   : integer;
    FFlnatureza : integer;
  public
    property idpessoa   : integer   read FIdPessoa    write FIdPessoa;
    property flnatureza : integer   read FFlnatureza  write FFlnatureza;
    property dsdocumento: string    read FDsdocumento write FDsdocumento;
    property nmprimeiro : string    read FNmprimeiro  write FNmprimeiro;
    property nmsegundo  : string    read FNmsegundo   write FNmsegundo;
    property dtregistro : TDateTime read FDtregistro  write FDtregistro;
  end;

  TListaPessoas = class
  private
    FListaPessoas: TObjectList<TModelPessoa>;
  public
    constructor Create;
    destructor Destroy; override;

    property listaPessoas: TObjectList<TModelPessoa> read FListaPessoas write FListaPessoas;
  end;

implementation

{ TListaPessoas }

constructor TListaPessoas.Create;
begin
  FListaPessoas := TObjectList<TModelPessoa>.Create;
end;

destructor TListaPessoas.Destroy;
begin
  FreeAndNil(FListaPessoas);
  inherited;
end;

end.
