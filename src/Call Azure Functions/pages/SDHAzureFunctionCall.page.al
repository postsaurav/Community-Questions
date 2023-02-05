page 50001 "SDH Azure Function Call"
{
    ApplicationArea = All;
    UsageCategory = Tasks;
    Caption = 'Azure Function Call';
    PageType = Card;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(CallAzure; CallAzureLbl)
                {
                    ApplicationArea = all;
                    ShowCaption = false;
                    trigger OnDrillDown()
                    var
                        AzureFunctions: Codeunit "Azure Functions";
                        AzureFunctionsResponse: Codeunit "Azure Functions Response";
                        AzureFunctionsAuthentication: Interface "Azure Functions Authentication";
                        QueryDict: Dictionary of [Text, Text];
                        Result: Text;
                    begin
                        AzureFunctionsAuthentication := CreateAuthentication();
                        QueryDict.Add('name', 'Saurav'); //Paramters

                        AzureFunctionsResponse := AzureFunctions.SendGetRequest(AzureFunctionsAuthentication, QueryDict);

                        if not AzureFunctionsResponse.IsSuccessful() then
                            error('%1', AzureFunctionsResponse.GetError());
                        AzureFunctionsResponse.GetResultAsText(Result);
                        Message(Result);
                    end;
                }
            }
        }
    }
    var
        CallAzureLbl: Label 'Call Azure Functions';

    local procedure CreateAuthentication(): Interface "Azure Functions Authentication"
    var
        AzureFunctionsAuthentication: Codeunit "Azure Functions Authentication";
    begin
        //Paramters - Endpoint: Text, AuthenticationCode: Text
        exit(AzureFunctionsAuthentication.CreateCodeAuth('https://trailbcfunction.azurewebsites.net/api/DemoFunction',
                                                    'fBg99SrAXXj0-F6tAIlN_x8ij082U4Wi46m4A3dameIpAzFusexVTQ=='));
    end;
}
