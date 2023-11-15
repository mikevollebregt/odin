using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace core_backend.Models.DTOs
{
    public class ResponseApiDTO<T>
    {
        public T Response { get; set; }
        public List<ResponseMessageDTO> Messages { get; set; }
    }
}
