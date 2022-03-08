import Nat "mo:base/Nat";
import Text "mo:base/Text";


actor Counter {
    public type HeaderField = (Text, Text);
    public type HttpRequest = {
        url : Text;
        method : Text;
        body : [Nat8];
        headers : [HeaderField];
    };
    public type HttpResponse = {
        body : Blob;
        headers : [HeaderField];
        streaming_strategy : ?StreamingStrategy;
        status_code : Nat16;
    };
    public type Key = Text;
    public type StreamingCallbackHttpResponse = {
        token : ?StreamingCallbackToken;
        body : [Nat8];
    };
    public type StreamingCallbackToken = {
        key : Text;
        sha256 : ?[Nat8];
        index : Nat;
        content_encoding : Text;
    };
    public type StreamingStrategy = {
        #Callback : {
            token : StreamingCallbackToken;
            callback : shared query StreamingCallbackToken -> async ?StreamingCallbackHttpResponse;
        };
    };
    
    stable var currentValue : Nat = 0;

    // Increment the counter with the increment function.
    public func increment() : async () {
    currentValue += 1;
    };

    // Read the counter value with a get function.
    public query func get() : async Nat {
    currentValue
    };

    // Write an arbitrary value with a set function.
    public func set(n: Nat) : async () {
    currentValue := n;
    };

    public query func http_request(req: HttpRequest): async HttpResponse {
        
        {
            status_code = 200;
            headers = [];
            body = Text.encodeUtf8("<html><body>" # Nat.toText(currentValue) # "</body></html>");
            streaming_strategy = null;

        }
    }
};

