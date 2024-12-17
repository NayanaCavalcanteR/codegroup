program Server;

uses
  Vcl.Forms,
  Main.Form in 'src\Main.Form.pas' {FrmVCL},
  uEndereco in 'src\uEndereco.pas',
  uPessoa in 'src\uPessoa.pas',
  dmConexao in 'src\dmConexao.pas' {dtmConexao: TDataModule},
  uModelPessoa in 'src\uModelPessoa.pas',
  uModelEndereco in 'src\uModelEndereco.pas',
  uModelEnderecoIntegracao in 'src\uModelEnderecoIntegracao.pas',
  uEnderecoIntegracao in 'src\uEnderecoIntegracao.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmVCL, FrmVCL);
  Application.CreateForm(TdtmConexao, dtmConexao);
  Application.Run;
end.
