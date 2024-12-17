unit uModelEnderecoIntegracao;

interface

type
  TModelEnderecoIntegracao = class
  private
    FIdendereco   : integer;
    FDscep        : string;
    FIdpessoa     : integer;
    FNmcidade     : string;
    FNmlogradouro : string;
    FNmbairro     : string;
    FDsuf         : string;
    FDscomplemento: string;
  public
    property idendereco   : integer read FIdendereco    write FIdendereco;
    property idpessoa     : integer read FIdpessoa      write FIdpessoa;
    property dsuf         : string  read FDsuf          write FDsuf;
    property nmcidade     : string  read FNmcidade      write FNmcidade;
    property nmbairro     : string  read FNmbairro      write FNmbairro;
    property nmlogradouro : string  read FNmlogradouro  write FNmlogradouro;
    property dscomplemento: string  read FDscomplemento write FDscomplemento;
  end;

  TModelEnderecoCep = class
  private
    FLogradouro : string;
    FRegiao     : string;
    FIbge       : string;
    FBairro     : string;
    FDdd        : string;
    FUf         : string;
    FCep        : string;
    FSiafi      : string;
    FLocalidade : string;
    FUnidade    : string;
    FComplemento: string;
    FGia        : string;
    FEstado     : string;
  public
	  property cep        : string read FCep         write FCep;
	  property logradouro : string read FLogradouro  write FLogradouro;
	  property complemento: string read FComplemento write FComplemento;
	  property unidade    : string read FUnidade     write FUnidade;
	  property bairro     : string read FBairro      write FBairro;
	  property localidade : string read FLocalidade  write FLocalidade;
	  property uf         : string read FUf          write FUf;
	  property estado     : string read FEstado      write FEstado;
	  property regiao     : string read FRegiao      write FRegiao;
	  property ibge       : string read FIbge        write FIbge;
	  property gia        : string read FGia         write FGia;
	  property ddd        : string read FDdd         write FDdd;
	  property siafi      : string read FSiafi       write FSiafi;
  end;


implementation

end.
