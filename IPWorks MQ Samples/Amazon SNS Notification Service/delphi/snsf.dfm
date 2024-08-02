object FormSns: TFormSns
  Left = 0
  Top = 0
  Caption = 'FormSns'
  ClientHeight = 604
  ClientWidth = 614
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 613
    Height = 57
    Caption = 'AWS Account Info'
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 61
      Height = 15
      Caption = 'Access Key:'
    end
    object Label2: TLabel
      Left = 312
      Top = 24
      Width = 57
      Height = 15
      Caption = 'Secret Key:'
    end
    object AccessKey: TEdit
      Left = 83
      Top = 21
      Width = 198
      Height = 23
      TabOrder = 0
    end
    object SecretKey: TEdit
      Left = 375
      Top = 21
      Width = 218
      Height = 23
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 63
    Width = 613
    Height = 162
    Caption = 'Topics and Subscriptions'
    TabOrder = 1
    object ListV: TListView
      Left = 16
      Top = 24
      Width = 465
      Height = 121
      Columns = <>
      TabOrder = 0
      OnSelectItem = OnSelectItem
    end
    object ListTopic: TButton
      Left = 496
      Top = 24
      Width = 97
      Height = 25
      Caption = 'List Topics'
      TabOrder = 1
      OnClick = ListTopicClick
    end
    object ListSub: TButton
      Left = 496
      Top = 55
      Width = 97
      Height = 25
      Caption = 'List Subscriptions'
      TabOrder = 2
      OnClick = ListSubClick
    end
    object CreateTopic: TButton
      Left = 496
      Top = 86
      Width = 97
      Height = 25
      Caption = 'Create Topic'
      TabOrder = 3
      OnClick = CreateTopicClick
    end
    object DeleteTopic: TButton
      Left = 496
      Top = 117
      Width = 97
      Height = 25
      Caption = 'Delete Topic'
      TabOrder = 4
      OnClick = DeleteTopicClick
    end
  end
  object GroupBox3: TGroupBox
    Left = 0
    Top = 231
    Width = 613
    Height = 162
    Caption = 'Subscription Menagement'
    TabOrder = 2
    object Label3: TLabel
      Left = 16
      Top = 32
      Width = 99
      Height = 15
      Caption = 'Endpoint Protocol:'
    end
    object Label4: TLabel
      Left = 16
      Top = 64
      Width = 58
      Height = 15
      Caption = 'Topic ARN:'
    end
    object Label5: TLabel
      Left = 16
      Top = 96
      Width = 181
      Height = 15
      Caption = 'Endpoint i.e email add, phone nr..:'
    end
    object Label6: TLabel
      Left = 16
      Top = 128
      Width = 96
      Height = 15
      Caption = 'Subscription ARN:'
    end
    object Protocol: TComboBox
      Left = 203
      Top = 32
      Width = 145
      Height = 23
      TabOrder = 0
      Items.Strings = (
        'Email'
        'Email-JSON'
        'HTTP'
        'HTTPS'
        'SMS'
        'SQS')
    end
    object TopicArn: TEdit
      Left = 203
      Top = 61
      Width = 278
      Height = 23
      TabOrder = 1
    end
    object EndPoint: TEdit
      Left = 203
      Top = 90
      Width = 278
      Height = 23
      TabOrder = 2
    end
    object SubArn: TEdit
      Left = 203
      Top = 119
      Width = 278
      Height = 23
      TabOrder = 3
    end
    object Sub: TButton
      Left = 496
      Top = 88
      Width = 97
      Height = 25
      Caption = 'Subscribe'
      TabOrder = 4
      OnClick = SubClick
    end
    object UnSub: TButton
      Left = 496
      Top = 119
      Width = 97
      Height = 25
      Caption = 'Unsubscribe'
      TabOrder = 5
      OnClick = UnSubClick
    end
  end
  object GroupBox4: TGroupBox
    Left = 0
    Top = 399
    Width = 613
    Height = 202
    Caption = 'Publish'
    TabOrder = 3
    object Label7: TLabel
      Left = 16
      Top = 32
      Width = 58
      Height = 15
      Caption = 'Topic ARN:'
    end
    object Label8: TLabel
      Left = 16
      Top = 64
      Width = 91
      Height = 15
      Caption = 'Message Subject:'
    end
    object Label9: TLabel
      Left = 16
      Top = 96
      Width = 49
      Height = 15
      Caption = 'Message:'
    end
    object TopicArnP: TEdit
      Left = 123
      Top = 23
      Width = 358
      Height = 23
      TabOrder = 0
    end
    object Subject: TEdit
      Left = 123
      Top = 60
      Width = 358
      Height = 23
      TabOrder = 1
    end
    object Message: TEdit
      Left = 123
      Top = 95
      Width = 358
      Height = 23
      TabOrder = 2
    end
    object Publish: TButton
      Left = 496
      Top = 24
      Width = 97
      Height = 25
      Caption = 'Publish'
      TabOrder = 3
      OnClick = PublishOnClick
    end
  end
  object ipqAmazonSNS1: TipqAmazonSNS
    SSLAcceptServerCertStore = 'MY'
    SSLCertStore = 'MY'
    OnSubscriptionList = OnSubList
    OnTopicList = OnTopicList
    Left = 528
    Top = 247
  end
end


