(*
 * IPWorks MQ 2024 Delphi Edition - Sample Project
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
unit mqttf;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ipqcore, ipqtypes, ipqmqtt;

type
  TFormMQTT = class(TForm)
    tConnectBox: TGroupBox;
    tHost: TEdit;
    tPort: TEdit;
    tUser: TEdit;
    tPassword: TEdit;
    tConnectButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ipqMQTT1: TipqMQTT;
    tClientID: TEdit;
    tSubBox: TGroupBox;
    tSubscribeTopic: TEdit;
    Label7: TLabel;
    tSubscribeQoS: TComboBox;
    Label8: TLabel;
    tSubscribeButton: TButton;
    tUnsubscribeButton: TButton;
    tPubBox: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    tPublishTopic: TEdit;
    tPublishButton: TButton;
    tPublishMessage: TEdit;
    Label11: TLabel;
    tLogBox: TGroupBox;
    tSSL: TCheckBox;
    tCleanSession: TCheckBox;
    Label12: TLabel;
    tPublishQoS: TComboBox;
    Label13: TLabel;
    tLog: TMemo;
    procedure tConnectButtonClick(Sender: TObject);
    procedure ipqMQTT1ConnectionStatus(Sender: TObject;
      const ConnectionEvent: string; StatusCode: Integer;
      const Description: string);
    procedure tSubscribeButtonClick(Sender: TObject);
    procedure ipqMQTT1Subscribed(Sender: TObject; const TopicFilter: string;
      QOS, ResponseCode: Integer);
    procedure ipqMQTT1Unsubscribed(Sender: TObject; const TopicFilters: string;
      ResponseCode: Integer);
    procedure tUnsubscribeButtonClick(Sender: TObject);
    procedure Log(line: String);
    procedure Connect;
    procedure Reset;
    procedure tPublishButtonClick(Sender: TObject);
    procedure ipqMQTT1Connected(Sender: TObject; StatusCode: Integer;
      const Description: string);
    procedure tSSLClick(Sender: TObject);
    procedure EnableGroup(GroupBox: TGroupBox);
    procedure DisableGroup(GroupBox: TGroupBox);
    procedure EnableSubPub;
    procedure DisableSubPub;
    procedure ipqMQTT1Disconnected(Sender: TObject; StatusCode: Integer;
      const Description: string);
    procedure ipqMQTT1Error(Sender: TObject; ErrorCode: Integer;
      const Description: string);
    procedure ipqMQTT1MessageIn(Sender: TObject; PacketId: Integer;
      const Topic: string; QOS: Integer; Message: string;
      MessageB: TArray<System.Byte>; Retained, Duplicate: Boolean);
    procedure ipqMQTT1SSLServerAuthentication(Sender: TObject;
      CertEncoded: string; CertEncodedB: TArray<System.Byte>; const CertSubject, CertIssuer, Status: string;
      var Accept: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMQTT: TFormMQTT;
  sessionState: String;


implementation

{$R *.dfm}

// Fires when on connection to the broker
procedure TFormMQTT.ipqMQTT1Connected(Sender: TObject; StatusCode: Integer;
  const Description: string);
begin
  Screen.Cursor := crArrow;
  // If connection was successful
  if (StatusCode = 0) then
  begin
    // Check for a stored session
    if (ipqMQTT1.Config('SessionPresent').ToLower() = 'true') then
    begin
      Log('Found saved session on server, restoring local session.');
      ipqMQTT1.RestoreSession(sessionState);
    end;
    // Enable subscribing and publishing controls
    EnableSubPub;
  end
  else
  begin
    // Connection was not successful, disconnect
    Reset;
  end;
end;

// Fires when the connection status changes
procedure TFormMQTT.ipqMQTT1ConnectionStatus(Sender: TObject;
  const ConnectionEvent: string; StatusCode: Integer;
  const Description: string);
begin
  Log(ConnectionEvent);
  // If there is an error, log it
  if StatusCode <> 0 then
  begin
    Log(Description);
    Reset;
  end;
end;

// Fires when disconnected from the broker
procedure TFormMQTT.ipqMQTT1Disconnected(Sender: TObject; StatusCode: Integer;
  const Description: string);
begin
  Screen.Cursor := crArrow;
  sessionState := ipqMQTT1.SaveSession();
  // Disable subscribing and publishing and reenable connecting
  DisableSubPub;
  tConnectButton.Caption := '&Connect';
  EnableGroup(tConnectBox);
end;

// Fires when an error occurs and logs the error
procedure TFormMQTT.ipqMQTT1Error(Sender: TObject; ErrorCode: Integer;
  const Description: string);
begin
  Log('Error: ' + Description);
end;

// Fires when a message arrives and logs the message
procedure TFormMQTT.ipqMQTT1MessageIn(Sender: TObject; PacketId: Integer;
  const Topic: string; QOS: Integer; Message: string;
  MessageB: TArray<System.Byte>; Retained, Duplicate: Boolean);
begin
  Log('Message from <' + Topic + '> (QoS ' + inttostr(QOS) + '):');
  Log('    ' + Message);
end;

// Fires when authenticating an SSL connection
procedure TFormMQTT.ipqMQTT1SSLServerAuthentication(Sender: TObject;
  CertEncoded: string; CertEncodedB: TArray<System.Byte>; const CertSubject, CertIssuer, Status: string;
  var Accept: Boolean);
begin
  // Automatically accept certificate for demo purposes
  Accept := True;
end;

// Fires when subscribed to a topic
procedure TFormMQTT.ipqMQTT1Subscribed(Sender: TObject; const TopicFilter: string;
  QOS, ResponseCode: Integer);
begin
  Log('Subscribed to <' + TopicFilter + '> at QoS ' + inttostr(QOS));
end;

// Fires when unsubscribed from a topic
procedure TFormMQTT.ipqMQTT1Unsubscribed(Sender: TObject;
  const TopicFilters: string; ResponseCode: Integer);
begin
  Log('Unsubscribed from ' + TopicFilters);
end;

// If not connected, connect, otherwise disconnect
procedure TFormMQTT.tConnectButtonClick(Sender: TObject);
begin
  tConnectButton.Enabled := False;
  if NOT ipqMQTT1.Connected then
  begin
    Connect;
  end
  else
  begin
    Reset;
  end;
end;

// Publish a message
procedure TFormMQTT.tPublishButtonClick(Sender: TObject);
begin
  ipqMQTT1.PublishMessage(tPublishTopic.Text, tPublishQoS.ItemIndex, tPublishMessage.Text);
end;

// Set default MQTT port for SSL
procedure TFormMQTT.tSSLClick(Sender: TObject);
begin
  if tSSL.Checked then
  begin
    tPort.Text := '8883';
  end
  else
  begin
    tPort.Text := '1883';
  end;
end;

// Subscribe to a topic
procedure TFormMQTT.tSubscribeButtonClick(Sender: TObject);
begin
  ipqMQTT1.Subscribe(tSubscribeTopic.Text, tSubscribeQoS.ItemIndex);
end;

// Unsubscribe from a topic
procedure TFormMQTT.tUnsubscribeButtonClick(Sender: TObject);
begin
  ipqMQTT1.Unsubscribe(tSubscribeTopic.Text);
end;

// Connect to the broker
procedure TFormMQTT.Connect;
begin
  try
    Log('Connecting...');
    // Set properties based on form
    ipqMQTT1.CleanSession := tCleanSession.Checked;
    ipqMQTT1.ClientId := tClientId.Text;
    ipqMQTT1.SSLEnabled := tSSL.Checked;
    ipqMQTT1.User := tUser.Text;
    ipqMQTT1.Password := tPassword.Text;
    // Disable connection controls and connect
    DisableGroup(tConnectBox);
    Screen.Cursor := crHourGlass;
    ipqMQTT1.ConnectTo(tHost.Text, strtoint(tPort.Text));
  except
    on E: Exception do
    begin
      // Log the error, then reset the form
      Log(E.Message);
      Reset;
    end;
  end;
end;

// Reset the form
procedure TFormMQTT.Reset;
begin

  Screen.Cursor := crArrow;
  // Disable subscribing and publishing
  DisableSubPub;
  // Disconnect and reset
  if ipqMQTT1.Connected then
  begin
    ipqMQTT1.Disconnect;
    ipqMQTT1.Reset;
  end;
  // Reenable connecting
  tConnectButton.Caption := '&Connect';
  EnableGroup(tConnectBox);
end;

// Disable all controls within a GroupBox
procedure TFormMQTT.DisableGroup(GroupBox: TGroupBox);
var index: Integer;
begin
  for index := 0 to GroupBox.ControlCount - 1 do
  begin
    GroupBox.Controls[index].Enabled := False;
  end;
  GroupBox.Enabled := False;
end;

// Disable subscribing and publishing controls
procedure TFormMQTT.DisableSubPub;
begin
  DisableGroup(tSubBox);
  DisableGroup(tPubBox);
end;

// Enable all controls within a GroupBox
procedure TFormMQTT.EnableGroup(GroupBox: TGroupBox);
var index: Integer;
begin
  for index := 0 to GroupBox.ControlCount - 1 do
  begin
    GroupBox.Controls[index].Enabled := True;
  end;
  GroupBox.Enabled := True;
end;

// Enable subscribing and publishing controls
procedure TFormMQTT.EnableSubPub;
begin
  tConnectBox.Enabled := True;
  tConnectButton.Caption := '&Disconnect';
  tConnectButton.Enabled := True;
  EnableGroup(tSubBox);
  EnableGroup(tPubBox);
end;

// Add a line to the log memo
procedure TFormMQTT.Log(line: String);
begin
  tLog.Lines.Add(line);
end;
end.

