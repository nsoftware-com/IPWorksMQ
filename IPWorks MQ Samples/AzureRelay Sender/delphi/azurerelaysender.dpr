(*
 * IPWorks MQ 2022 Delphi Edition - Sample Project
 *
 * This sample project demonstrates the usage of IPWorks MQ in a 
 * simple, straightforward way. It is not intended to be a complete 
 * application. Error handling and other checks are simplified for clarity.
 *
 * www.nsoftware.com/ipworksmq
 *
 * This code is subject to the terms and conditions specified in the 
 * corresponding product license agreement which outlines the authorized 
 * usage and restrictions.
 *)

program azurerelaysender;

uses
  Forms,
  azurerelaysenderf in 'azurerelaysenderf.pas' {FormAzurerelaysender};

begin
  Application.Initialize;

  Application.CreateForm(TFormAzurerelaysender, FormAzurerelaysender);
  Application.Run;
end.


         
