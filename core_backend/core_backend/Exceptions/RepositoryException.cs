using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace core_backend.Exceptions
{
    public class RepositoryException : ResponseException
    {
        public RepositoryException(string prefixMessage, string message, int statusCode) : base(prefixMessage, message, statusCode)
        {
            StatusCode = statusCode;
        }
    }
}
