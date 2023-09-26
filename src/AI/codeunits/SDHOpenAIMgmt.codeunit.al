codeunit 50011 "SDH Open AI Mgmt."
{
    procedure GetResponseFromChatGPT(Input: Text; NewModel: Boolean; var Response: Text)
    var
        Clinet: HttpClient;
        Content: HttpContent;
        RequestMsg: HttpRequestMessage;
        ResponseMsg: HttpResponseMessage;
        ContentText, OutputString : Text;
    begin
        OpenAISetup.Get();
        Content.Clear();

        SetChatGPTBody(Input, NewModel, ContentText);
        Content.WriteFrom(ContentText);
        SetChatGptHeader(Content, NewModel, RequestMsg);

        if not Clinet.Send(RequestMsg, ResponseMsg) then
            Error('Error Sending Request %1', ResponseMsg.HttpStatusCode);

        ResponseMsg.Content.ReadAs(OutputString);

        if ResponseMsg.IsSuccessStatusCode then
            Response := ParseChatGPTResponseText(OutputString, NewModel)
        else
            Error('%1', OutputString);
    end;

    procedure GeneratePurchaseOrderEmailBodyFromChatGPT(PurchaseHeader: Record "Purchase Header"): Text
    var
        CompanyInformation: Record "Company Information";
        InputLbl: Label 'Write a email, in html format, with professional langauge, regarding an order %2 to a vendor %1. Buyer company Name is %3 , Buyer company address is %4 and Buyer company email is %5';
        Input, Response : Text;
    begin
        CompanyInformation.get();

        case PurchaseHeader."Document Type" of
            PurchaseHeader."Document Type"::Order:
                Input := StrSubstNo(InputLbl, PurchaseHeader."Buy-from Vendor Name", PurchaseHeader."No.", CompanyInformation.Name, CompanyInformation.Address, CompanyInformation."E-Mail");
        end;
        GetResponseFromChatGPT(Input, true, Response);
        exit(Response);
    end;

    local procedure SetChatGPTBody(Input: Text; NewModel: Boolean; var ContentText: Text)
    var
        ChatGPTBody: JsonObject;
        ChatGPTBodyArray: JsonArray;
    begin
        if NewModel then begin
            ChatGPTBody.Add('model', Format(OpenAISetup.Model));
            ChatGPTBody.Add('messages', GetChatGPTMessageArray(Input));
        end else begin
            ChatGPTBody.Add('model', Format(OpenAISetup."Model (Legacy)"));
            ChatGPTBody.Add('prompt', Input);
            ChatGPTBody.Add('max_tokens', OpenAISetup."Max Tokens");
            ChatGPTBody.Add('temperature', OpenAISetup.Temperature);
            ChatGPTBody.Add('top_p', OpenAISetup."Top P");
            ChatGPTBody.Add('presence_penalty', OpenAISetup."Presence Penalty");
            ChatGPTBody.Add('frequency_penalty', OpenAISetup."Frequency Penalty");
            ChatGPTBody.Add('best_of', OpenAISetup."Best of");
        end;
        ChatGPTBody.WriteTo(ContentText);
    end;

    local procedure GetChatGPTMessageArray(Input: Text) InputArray: JsonArray
    var
        InputJsonObject: JsonObject;
    begin
        InputJsonObject.Add('role', 'system');
        InputJsonObject.Add('content', Input);
        InputArray.Add(InputJsonObject);
    end;

    local procedure SetChatGptHeader(var Content: HttpContent; NewModel: Boolean; var RequestMsg: HttpRequestMessage)
    var
        Headers: HttpHeaders;
    begin
        Content.GetHeaders(Headers);
        Headers.Clear();
        Headers.Add('Content-Type', 'application/json');
        RequestMsg.GetHeaders(Headers);
        Headers.Add('Authorization', 'Bearer ' + OpenAISetup."Secret Key");

        RequestMsg.Content(Content);
        if NewModel then
            RequestMsg.SetRequestUri('https://api.openai.com/v1/chat/completions')
        else
            RequestMsg.SetRequestUri('https://api.openai.com/v1/completions');
        RequestMsg.Method := 'POST';
    end;

    local procedure ParseChatGPTResponseText(OutputString: Text; NewModel: Boolean): Text
    var
        JsonObjectResponse: JsonObject;
        JsonTokenResponse: JsonToken;
        JsonArrayResponse: JsonArray;
    begin
        JsonObjectResponse.ReadFrom(OutputString);
        if JsonObjectResponse.Get('choices', JsonTokenResponse) then begin
            JsonArrayResponse := JsonTokenResponse.AsArray();
            JsonArrayResponse.Get(0, JsonTokenResponse);
            JsonObjectResponse := JsonTokenResponse.AsObject();
            if NewModel then begin
                JsonObjectResponse.Get('message', JsonTokenResponse);
                JsonObjectResponse := JsonTokenResponse.AsObject();
                JsonObjectResponse.Get('content', JsonTokenResponse);
            end else
                JsonObjectResponse.Get('text', JsonTokenResponse);
            exit(JsonTokenResponse.AsValue().AsText());
        end;
    end;

    var
        OpenAISetup: Record "SDH Open AI Setup";
}
