using core_backend.Models.DTOs;
using core_backend.Models.Enums;
using core_backend.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Infrastructure;
using Microsoft.Extensions.Options;

namespace core_backend.Middlewares
{
    internal class ResponseEnvelopeResultExecutor : ObjectResultExecutor
    {
        private readonly ErrorService _errorService;
        private readonly LogService _logService;

        public ResponseEnvelopeResultExecutor(
            OutputFormatterSelector formatterSelector, 
            IHttpResponseStreamWriterFactory writerFactory, 
            ILoggerFactory loggerFactory, 
            IOptions<MvcOptions> mvcOptions,
            ErrorService errorService,
            LogService logService
        ) : base(formatterSelector, writerFactory, loggerFactory, mvcOptions)
        {
            _logService = logService;
            _errorService = errorService;
        }

        public override Task ExecuteAsync(ActionContext context, ObjectResult result)
        {
            var messages = _errorService.Errors.Select(e => new ResponseMessageDTO { Message = e, MessageType = MessageType.Error }).ToList();
            messages.AddRange(_logService.Logs.Select(e => new ResponseMessageDTO { Message = e, MessageType = MessageType.Info }).ToList());
            messages.AddRange(new List<ResponseMessageDTO>
            {
                new ResponseMessageDTO { Message = "This is an example info message", MessageType = MessageType.Info },
                new ResponseMessageDTO { Message = "This is an example error message", MessageType = MessageType.Error },
                new ResponseMessageDTO { Message = "This is an example debug message", MessageType = MessageType.Debug },
            });

            var response = new ResponseApiDTO<object>
            {
                Response = result.Value,
                Messages = messages
            };

            if(result.Value is null)
            {
                return base.ExecuteAsync(context, result);
            }

            var typeCode = Type.GetTypeCode(result.Value.GetType());
            if (typeCode == TypeCode.Object)
                result.Value = response;

            return base.ExecuteAsync(context, result);
        }
    }
}
