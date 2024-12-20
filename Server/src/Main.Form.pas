unit Main.Form;

interface

uses Winapi.Windows, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Buttons, System.SysUtils, System.Generics.Collections, Horse.Commons;

type
  TFrmVCL = class(TForm)
    btnStop: TBitBtn;
    btnStart: TBitBtn;
    Label1: TLabel;
    edtPort: TEdit;
    procedure btnStopClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure Status;
    procedure Start;
    procedure Stop;
  end;

var
  FrmVCL: TFrmVCL;

implementation

uses
  Horse, System.JSON, System.StrUtils, Rest.JSON, uPessoa, uEndereco, Horse.Jhonson,
  uModelPessoa, uModelEndereco, uModelEnderecoIntegracao, uEnderecoIntegracao;

{$R *.dfm}

procedure TFrmVCL.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if THorse.IsRunning then
    Stop;
end;

procedure TFrmVCL.FormCreate(Sender: TObject);
begin
  THorse.Use(Jhonson);

  THorse.Get('datasnap/rest/TServerMethods/EchoString/:param',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send(Req.Params.Items['param']);
    end);

  THorse.Get('datasnap/rest/TServerMethods/ReverseString/:param',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send(ReverseString(Req.Params.Items['param']));
    end);

  { ** Rotas de Pessoa ** }
  THorse.Get('/pessoa',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      pes: TPessoa;
    begin
      pes := TPessoa.Create;
      try
        Res.Send(pes.GetListaPessoas).Status(THTTPStatus.OK);
      finally
        pes.Free;
      end;
    end);

  THorse.Post('/pessoa',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      DPessoa: TModelPessoa;
      pes: TPessoa;
    begin
      pes := TPessoa.Create;
      try
        try
          DPessoa := TJson.JsonToObject<TModelPessoa>(Req.Body);
          Res.Send(pes.PostPessoa(DPessoa)).Status(THTTPStatus.Created);
        except on E: Exception do
          Res.Send(TJSONObject.Create.AddPair('mensagem', e.Message)).Status(THTTPStatus.InternalServerError);
        end;
      finally
        pes.Free;
      end;
    end);

  THorse.Put('/pessoa/:idpessoa',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      idPessoa: integer;
      DPessoa: TModelPessoa;
      pes: TPessoa;
    begin
      pes := TPessoa.Create;
      try
        try
          idPessoa := StrToIntDef(Req.Params.Items['idpessoa'], 0);
          DPessoa  := TJson.JsonToObject<TModelPessoa>(Req.Body);
          Res.Send(pes.PutPessoa(idPessoa, DPessoa)).Status(THTTPStatus.OK);
        except on E: Exception do
          Res.Send(TJSONObject.Create.AddPair('mensagem', e.Message)).Status(THTTPStatus.InternalServerError);
        end;
      finally
        pes.Free;
      end;
    end);

  THorse.Delete('/pessoa/:idpessoa',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      idPessoa: integer;
      pes: TPessoa;
    begin
      pes := TPessoa.Create;
      try
        try
          idPessoa := StrToIntDef(Req.Params.Items['idpessoa'], 0);
          Res.Send(pes.DeletePessoa(idPessoa)).Status(THTTPStatus.OK);
        except on E: Exception do
          Res.Send(TJSONObject.Create.AddPair('mensagem', e.Message)).Status(THTTPStatus.InternalServerError);
        end;
      finally
        pes.Free;
      end;
    end);


  { ** Rotas de Endere�o ** }
  THorse.Get('/endereco',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      ender: TEndereco;
    begin
      ender := TEndereco.Create;
      try
        Res.Send(ender.GetListaEnderecos).Status(THTTPStatus.OK);
      finally
        ender.Free;
      end;
    end);

  THorse.Get('/endereco/:idpessoa',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      ender: TEndereco;
      idPessoa: integer;
    begin
      ender := TEndereco.Create;
      try
        idPessoa := StrToIntDef(Req.Params.Items['idpessoa'], 0);
        Res.Send(ender.GetListaEnderecosPessoa(idpessoa)).Status(THTTPStatus.OK);
      finally
        ender.Free;
      end;
    end);

  THorse.Post('/endereco',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      DEndereco: TModelEndereco;
      ender: TEndereco;
    begin
      ender := TEndereco.Create;
      try
        try
          DEndereco := TJson.JsonToObject<TModelEndereco>(Req.Body);
          Res.Send(ender.PostEndereco(DEndereco)).Status(THTTPStatus.Created);
        except on E: Exception do
          Res.Send(TJSONObject.Create.AddPair('mensagem', e.Message)).Status(THTTPStatus.InternalServerError);
        end;
      finally
        ender.Free;
      end;
    end);

  THorse.Put('/endereco/:idendereco',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      idEndereco: integer;
      DEndereco: TModelEndereco;
      ender: TEndereco;
    begin
      ender := TEndereco.Create;
      try
        try
          idEndereco := StrToIntDef(Req.Params.Items['idendereco'], 0);
          DEndereco  := TJson.JsonToObject<TModelEndereco>(Req.Body);
          Res.Send(ender.PutEndereco(idEndereco, DEndereco)).Status(THTTPStatus.OK);
        except on E: Exception do
          Res.Send(TJSONObject.Create.AddPair('mensagem', e.Message)).Status(THTTPStatus.InternalServerError);
        end;
      finally
        ender.Free;
      end;
    end);

  THorse.Delete('/endereco/:idendereco',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      idEndereco: integer;
      ender: TEndereco;
    begin
      ender := TEndereco.Create;
      try
        try
          idEndereco := StrToIntDef(Req.Params.Items['idendereco'], 0);
          Res.Send(ender.DeleteEndereco(idEndereco)).Status(THTTPStatus.OK);
        except on E: Exception do
          Res.Send(TJSONObject.Create.AddPair('mensagem', e.Message)).Status(THTTPStatus.InternalServerError);
        end;
      finally
        ender.Free;
      end;
    end);


  {** Rotas de Endereco_Integracao **}
  THorse.Get('/integracao/endereco',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      endInt: TEnderecoIntegracao;
    begin
      endInt := TEnderecoIntegracao.Create;
      try
        Res.Send(endInt.GetListaEnderecosIntegracao).Status(THTTPStatus.OK);
      finally
        endInt.Free;
      end;
    end);

  THorse.Get('/integracao/endereco/:idendereco',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      endInt: TEnderecoIntegracao;
      idEndereco: integer;
    begin
      endInt := TEnderecoIntegracao.Create;
      try
        idEndereco := StrToIntDef(Req.Params.Items['idendereco'], 0);
        Res.Send(endInt.GetListaEnderecosIntegracaoId(idEndereco)).Status(THTTPStatus.OK);
      finally
        endInt.Free;
      end;
    end);

  THorse.Post('/integracao/endereco/:idendereco',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      idEndereco: integer;
      DCep: TModelEnderecoCep;
      DEndereco: TModelEnderecoIntegracao;
      endInt: TEnderecoIntegracao;
    begin
      endInt   := TEnderecoIntegracao.Create;
      DEndereco:= TModelEnderecoIntegracao.Create;;
      try
        try
          idEndereco := StrToIntDef(Req.Params.Items['idendereco'], 0);

          DCep := TJson.JsonToObject<TModelEnderecoCep>(Req.Body);
          DEndereco.dsuf         := DCep.uf;
          DEndereco.nmcidade     := DCep.localidade;
          DEndereco.nmbairro     := DCep.bairro;
          DEndereco.nmlogradouro := DCep.logradouro;
          DEndereco.dscomplemento:= DCep.complemento;

          Res.Send(endInt.PostEnderecoIntegracao(idEndereco, DEndereco)).Status(THTTPStatus.Created);
        except on E: Exception do
          Res.Send(TJSONObject.Create.AddPair('mensagem', e.Message)).Status(THTTPStatus.InternalServerError);
        end;
      finally
        DEndereco.Free;
        endInt.Free;
      end;
    end);

  THorse.Put('/integracao/endereco/:idendereco',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      idEndereco: integer;
      DCep: TModelEnderecoCep;
      DEndereco: TModelEnderecoIntegracao;
      endInt: TEnderecoIntegracao;
    begin
      endInt   := TEnderecoIntegracao.Create;
      DEndereco:= TModelEnderecoIntegracao.Create;;
      try
        try
          idEndereco := StrToIntDef(Req.Params.Items['idendereco'], 0);

          DCep := TJson.JsonToObject<TModelEnderecoCep>(Req.Body);
          DEndereco.dsuf         := DCep.uf;
          DEndereco.nmcidade     := DCep.localidade;
          DEndereco.nmbairro     := DCep.bairro;
          DEndereco.nmlogradouro := DCep.logradouro;
          DEndereco.dscomplemento:= DCep.complemento;

          Res.Send(endInt.PutEnderecoIntegracao(idEndereco, DEndereco)).Status(THTTPStatus.OK);
        except on E: Exception do
          Res.Send(TJSONObject.Create.AddPair('mensagem', e.Message)).Status(THTTPStatus.InternalServerError);
        end;
      finally
        DEndereco.Free;
        endInt.Free;
      end;
    end);

  THorse.Delete('/integracao/endereco/:idendereco',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      idEndereco: integer;
      endInt: TEnderecoIntegracao;
    begin
      endInt := TEnderecoIntegracao.Create;
      try
        try
          idEndereco := StrToIntDef(Req.Params.Items['idendereco'], 0);
          Res.Send(endInt.DeleteEnderecoIntegracao(idEndereco)).Status(THTTPStatus.OK);
        except on E: Exception do
          Res.Send(TJSONObject.Create.AddPair('mensagem', e.Message)).Status(THTTPStatus.InternalServerError);
        end;
      finally
        endInt.Free;
      end;
    end);

end;

procedure TFrmVCL.Start;
begin
  // Need to set "HORSE_VCL" compilation directive
  THorse.Listen(StrToInt(edtPort.Text));
end;

procedure TFrmVCL.Status;
begin
  btnStop.Enabled := THorse.IsRunning;
  btnStart.Enabled := not THorse.IsRunning;
  edtPort.Enabled := not THorse.IsRunning;
end;

procedure TFrmVCL.Stop;
begin
  THorse.StopListen;
end;

procedure TFrmVCL.btnStartClick(Sender: TObject);
begin
  Start;
  Status;
end;

procedure TFrmVCL.btnStopClick(Sender: TObject);
begin
  Stop;
  Status;
end;

end.
