using core_backend.Models.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace core_backend.Models.DTOs
{
    public class ResponseMessageDTO
    {
        public string Message { get; set; }
        public MessageType MessageType { get; set; }
    }
}
