unit uModelEndereco;

interface

type
  TModelEndereco = class
  private
    FIdendereco: integer;
    FDscep     : string;
    FIdpessoa  : integer;
  public
    property idendereco: integer read FIdendereco write FIdendereco;
    property idpessoa  : integer read FIdpessoa   write FIdpessoa;
    property dscep     : string  read FDscep      write FDscep;
  end;

implementation

end.
