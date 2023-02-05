pageextension 50100 "SDH Customer List" extends "Customer List"
{
    trigger OnOpenPage()
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

    local procedure CreateAuthentication(): Interface "Azure Functions Authentication"
    var
        AzureFunctionsAuthentication: Codeunit "Azure Functions Authentication";
    begin
        //Paramters - Endpoint: Text, AuthenticationCode: Text
        exit(AzureFunctionsAuthentication.CreateCodeAuth('https://trailbcfunction.azurewebsites.net/api/DemoFunction',
                                                    'fBg99SrAXXj0-F6tAIlN_x8ij082U4Wi46m4A3dameIpAzFusexVTQ=='));
    end;
}