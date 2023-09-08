table 50002 "SDH Open AI Setup"
{
    Caption = 'Open AI Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            Caption = 'Primary Key';
        }
        field(2; "Secret Key"; Text[250])
        {
            Caption = 'Secret Key';
            ExtendedDatatype = Masked;
        }
        field(3; "Model (Legacy)"; Option)
        {
            Caption = 'Model (Legacy)';
            OptionMembers = "","text-davinci-003","text-davinci-002","text-davinci-001","text-curie-001","text-babbage-001","text-ada-001",davinci,curie,babbage,ada;
        }
        field(4; Model; Option)
        {
            Caption = 'Model';
            OptionMembers = "","gpt-4","gpt-4-0613","gpt-4-32k","gpt-4-32k-0613","gpt-3.5-turbo","gpt-3.5-turbo-0613","gpt-3.5-turbo-16k","gpt-3.5-turbo-16k-0613";
        }
        field(5; "Max Tokens"; Integer)
        {
            Caption = 'Max Tokens';
            InitValue = 16;
        }
        field(6; Temperature; Decimal)
        {
            Caption = 'Temperature';
            MinValue = 0.0;
            MaxValue = 2.0;
        }
        field(7; "Top P"; Integer)
        {
            Caption = 'Top P';
            InitValue = 1;
        }
        field(8; "Presence Penalty"; Decimal)
        {
            Caption = 'Presence Penalty';
            MinValue = -2.0;
            MaxValue = 2.0;
        }
        field(9; "Frequency Penalty"; Decimal)
        {
            Caption = 'Frequency Penalty';
            MinValue = -2.0;
            MaxValue = 2.0;
        }
        field(10; "Best of"; Integer)
        {
            Caption = 'Best of';
            InitValue = 1;
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}