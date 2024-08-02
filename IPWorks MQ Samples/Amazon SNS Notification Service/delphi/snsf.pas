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
unit snsf;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, ipqcore,
  ipqtypes, ipqamazonsns, Unit2;

type
  TFormSns = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    AccessKey: TEdit;
    SecretKey: TEdit;
    GroupBox2: TGroupBox;
    ListV: TListView;
    ListTopic: TButton;
    ListSub: TButton;
    CreateTopic: TButton;
    DeleteTopic: TButton;
    GroupBox3: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    TopicArn: TEdit;
    EndPoint: TEdit;
    SubArn: TEdit;
    Sub: TButton;
    UnSub: TButton;
    GroupBox4: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    TopicArnP: TEdit;
    Subject: TEdit;
    Message: TEdit;
    Publish: TButton;
    Protocol: TComboBox;
    ipqAmazonSNS1: TipqAmazonSNS;
    procedure ListTopicClick(Sender: TObject);
    procedure OnTopicList(Sender: TObject; const TopicArn: string);
    procedure ListSubClick(Sender: TObject);
    procedure OnSubList(Sender: TObject; const SubscriptionArn, TopicArn, Owner,
      Endpoint: string; Protocol: Integer);
    procedure CreateTopicClick(Sender: TObject);
    procedure OnSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure DeleteTopicClick(Sender: TObject);
    procedure PublishOnClick(Sender: TObject);
    procedure SubClick(Sender: TObject);
    procedure UnSubClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSns: TFormSns;
  FormUnit: TFormUnit;
  selectedTopicArn: string;

implementation

{$R *.dfm}

procedure TFormSns.CreateTopicClick(Sender: TObject);
begin
  FormUnit.ShowModal;
  if FormUnit.okClicked then
  begin
    ShowMessage('Topic ARN: ' +  ipqAmazonSNS1.CreateTopic(FormUnit.Edit1.Text));
    ListTopicClick(Sender);
  end;
end;

procedure TFormSns.DeleteTopicClick(Sender: TObject);
var
  Result: Integer;
begin
  if selectedTopicArn <> '' then
  begin
    Result := MessageDlg('Delete Topic: ' + selectedTopicArn + '?', mtConfirmation, [mbYes, mbNo], 0);
    if Result = mrYes then
      begin
        ipqAmazonSNS1.DeleteTopic(selectedTopicArn);
        ListTopicClick(Sender);
      end;
  end
  else
  begin
    MessageDlg('Nothing selected!', mtError, [mbOK], 0);
  end;
end;

procedure TFormSns.ListSubClick(Sender: TObject);
var
  Column: TListColumn;
  Column1: TListColumn;
  Column2: TListColumn;
  Column3: TListColumn;
  Column4: TListColumn;
begin
  ipqAmazonSNS1.AccessKey := AccessKey.Text;
  ipqAmazonSNS1.SecretKey := SecretKey.Text;

  ListV.ViewStyle := vsReport;
  ListV.Columns.Clear;
  ListV.Items.Clear;

  Column := ListV.Columns.Add;
  Column.Caption := 'Topic ARN';
  Column.Width := 70;

  Column1 := ListV.Columns.Add;
  Column1.Caption := 'Subscription ARN:';
  Column1.Width := 120;

  Column2 := ListV.Columns.Add;
  Column2.Caption := 'Endpoint';
  Column2.Width := 60;

  Column3 := ListV.Columns.Add;
  Column3.Caption := 'Owner';
  Column3.Width := 50;

  Column4 := ListV.Columns.Add;
  Column4.Caption := 'EndPoint protocol';
  Column4.Width := 120;

  repeat ipqAmazonSNS1.ListSubscriptions();
  until ipqAmazonSNS1.SubscriptionMarker = '';
end;

procedure TFormSns.ListTopicClick(Sender: TObject);
var
  Column: TListColumn;
begin
  ipqAmazonSNS1.AccessKey := AccessKey.Text;
  ipqAmazonSNS1.SecretKey := SecretKey.Text;

  ListV.ViewStyle := vsReport;
  ListV.Columns.Clear;
  ListV.Items.Clear;
  Column := ListV.Columns.Add;
  Column.Caption := 'Topic ARN';
  Column.Width := 500;

  repeat ipqAmazonSNS1.ListTopics();
  until ipqAmazonSNS1.TopicMarker = '';
end;

procedure TFormSns.OnSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Selected then
    begin
      selectedTopicArn := Item.Caption;
      TopicArn.Text := Item.Caption;
      TopicArnP.Text := Item.Caption;
    end;
end;

procedure TFormSns.OnSubList(Sender: TObject; const SubscriptionArn, TopicArn,
  Owner, Endpoint: string; Protocol: Integer);
var
  ListItem: TListItem;
  protocolStr: string;
begin
  case Protocol of
    0: protocolStr := 'email';
    1: protocolStr := 'email-json';
    2: protocolStr := 'http';
    3: protocolStr := 'https';
    4: protocolStr := 'SMS';
    5: protocolStr := 'SQS';
  else
    protocolStr := 'not known protocol';
  end;

  ListItem := ListV.Items.Add;
  ListItem.Caption := TopicArn;
  ListItem.SubItems.Add(SubscriptionArn);
  ListItem.SubItems.Add(Endpoint);
  ListItem.SubItems.Add(Owner);
  ListItem.SubItems.Add(protocolStr);
end;

procedure TFormSns.OnTopicList(Sender: TObject; const TopicArn: string);
var
  ListItem: TListItem;
begin
  ListItem := ListV.Items.Add;
  ListItem.Caption := TopicArn;
end;

procedure TFormSns.PublishOnClick(Sender: TObject);
begin
  ShowMessage('Message ID: ' +  ipqAmazonSNS1.Publish(TopicArnP.Text, Subject.Text, Message.Text));
  TopicArnP.Text := '';
  Subject.Text := '';
  Message.Text := '';
end;

procedure TFormSns.SubClick(Sender: TObject);
var
  protocolInt: Integer;
begin
  if Protocol.Text = 'Email' then
  begin
    protocolInt := 0;
  end
  else if Protocol.Text = 'Email-JSON' then
  begin
    protocolInt := 1;
  end
  else if Protocol.Text = 'HTTP' then
  begin
    protocolInt := 2;
  end
  else if Protocol.Text = 'HTTPS' then
  begin
    protocolInt := 3;
  end
  else if Protocol.Text = 'SMS' then
  begin
    protocolInt := 4;
  end
  else if Protocol.Text = 'SQS' then
  begin
    protocolInt := 5;
  end
  else
  begin
    protocolInt := -1;
  end;

  ShowMessage('Subscription ARN for new subscriber: ' +  ipqAmazonSNS1.Subscribe(TopicArn.Text, Endpoint.Text, protocolInt));
  TopicArn.Text := '';
  Endpoint.Text := '';
  Protocol.Text := '';
end;

procedure TFormSns.UnSubClick(Sender: TObject);
begin
  ipqAmazonSNS1.Unsubscribe(SubArn.Text);
  ShowMessage('Unsubscribed succesfully user: ' +  SubArn.Text);
  SubArn.Text := '';
end;

end.



