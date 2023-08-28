tableextension 50005 "SDH CRM Account" extends "CRM Account"
{
    Description = 'Business that represents a customer or potential customer. The company that is billed in business transactions.';

    fields
    {
        field(50000; "SDH Facebook"; Text[300])
        {
            ExternalName = 'msdyusd_facebook';
            ExternalType = 'String';
            Description = 'Captures the facebook id';
            Caption = 'Facebook';
        }
        field(50001; "SDH Twitter"; Text[300])
        {
            ExternalName = 'msdyusd_twitter';
            ExternalType = 'String';
            Description = 'Capture the twitter id';
            Caption = 'Twitter';
        }
    }
}