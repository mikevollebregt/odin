namespace core_backend.Exceptions
{
    public class ResponseException : Exception
    {
        public int StatusCode { get; set; }
        public string TypeException { get; set; }
        public ResponseException(string prefixMessage, string message, int statusCode) : base(prefixMessage + ": " + message)
        {
            StatusCode = statusCode;
            TypeException = GetType().Name;
        }

    }
}
